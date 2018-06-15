Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] client: parse env variables before sending job-file contents to server
Date: Fri, 15 Jun 2018 08:11:26 -0700
Message-Id: <1529075486-18805-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Fixes "fio environment var bug".
https://www.spinics.net/lists/fio/msg07093.html

Add read_ini_data() to parse and expand env variables within job-file
before sending to server. By doing this, clients can control parameters
embedded within the job-file, without server side having to set them
separately.

Reported-by: Jeff Furlong <jeff.furlong@wdc.com>
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 client.c  |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fio.h     |    1 +
 options.c |    4 ++--
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/client.c b/client.c
index 96cc35e..d1b61b0 100644
--- a/client.c
+++ b/client.c
@@ -118,6 +118,50 @@ static int read_data(int fd, void *data, size_t size)
 	return 0;
 }
 
+static int read_ini_data(int fd, void *data, size_t size)
+{
+	char *p = data;
+	int ret = 0;
+
+	FILE *fp = fdopen(dup(fd), "r");
+	if (!fp)
+		return errno;
+
+	while (1) {
+		ssize_t len;
+		char buf[OPT_LEN_MAX+1], *sub;
+
+		if (!fgets(buf, sizeof(buf), fp)) {
+			if (ferror(fp)) {
+				if (errno == EAGAIN || errno == EINTR)
+					continue;
+				ret = errno;
+				break;
+			} else
+				break;
+		}
+
+		sub = fio_option_dup_subs(buf);
+		len = strlen(sub);
+		if (len + 1 > size) {
+			log_err("fio: no space left to read data\n");
+			free(sub);
+			ret = ENOSPC;
+			break;
+		}
+
+		memcpy(p, sub, len);
+		free(sub);
+		p += len;
+		*p = 0;
+		size -= len;
+	}
+
+	fclose(fp);
+
+	return ret;
+}
+
 static void fio_client_json_init(void)
 {
 	char time_buf[32];
@@ -763,13 +807,17 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 		return ret;
 	}
 
+	/*
+	 * Add extra space for variable expansion, but doesn't guarantee.
+	 */
+	sb.st_size += OPT_LEN_MAX;
 	p_size = sb.st_size + sizeof(*pdu);
 	pdu = malloc(p_size);
 	buf = pdu->buf;
 
 	len = sb.st_size;
 	p = buf;
-	if (read_data(fd, p, len)) {
+	if (read_ini_data(fd, p, len)) {
 		log_err("fio: failed reading job file %s\n", filename);
 		close(fd);
 		free(pdu);
diff --git a/fio.h b/fio.h
index 9f3140a..9727f6c 100644
--- a/fio.h
+++ b/fio.h
@@ -567,6 +567,7 @@ extern void fio_fill_default_options(struct thread_data *);
 extern int fio_show_option_help(const char *);
 extern void fio_options_set_ioengine_opts(struct option *long_options, struct thread_data *td);
 extern void fio_options_dup_and_init(struct option *);
+extern char *fio_option_dup_subs(const char *);
 extern void fio_options_mem_dupe(struct thread_data *);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void td_fill_verify_state_seed(struct thread_data *);
diff --git a/options.c b/options.c
index 9fbcd96..0c4f89c 100644
--- a/options.c
+++ b/options.c
@@ -4790,7 +4790,7 @@ static char *bc_calc(char *str)
  * substitution always occurs, even if VARNAME is empty or the corresponding
  * environment variable undefined.
  */
-static char *option_dup_subs(const char *opt)
+char *fio_option_dup_subs(const char *opt)
 {
 	char out[OPT_LEN_MAX+1];
 	char in[OPT_LEN_MAX+1];
@@ -4895,7 +4895,7 @@ static char **dup_and_sub_options(char **opts, int num_opts)
 	int i;
 	char **opts_copy = malloc(num_opts * sizeof(*opts));
 	for (i = 0; i < num_opts; i++) {
-		opts_copy[i] = option_dup_subs(opts[i]);
+		opts_copy[i] = fio_option_dup_subs(opts[i]);
 		if (!opts_copy[i])
 			continue;
 		opts_copy[i] = fio_keyword_replace(opts_copy[i]);
-- 
1.7.1


