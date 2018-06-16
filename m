Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932651AbeFPMAb (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Jun 2018 08:00:31 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fU9sc-0003rw-T3
        for fio@vger.kernel.org; Sat, 16 Jun 2018 12:00:30 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180616120001.6D6942C0136@kernel.dk>
Date: Sat, 16 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cdfb5a85d9743fb53f4a2b56a392e0897a333568:

  rand: make randX_upto() do the end value increment (2018-06-12 11:43:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to af84cd66149507424814cf9c0b4950f4cf66e3b7:

  client: close dup'ed descriptor if fdopen() fails (2018-06-15 09:18:04 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      client: check return of dup(2)
      client: close dup'ed descriptor if fdopen() fails

Tomohiro Kusumi (1):
      client: parse env variables before sending job-file contents to server

 client.c  | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fio.h     |  1 +
 options.c |  4 ++--
 3 files changed, 60 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 96cc35e..2a86ea9 100644
--- a/client.c
+++ b/client.c
@@ -118,6 +118,58 @@ static int read_data(int fd, void *data, size_t size)
 	return 0;
 }
 
+static int read_ini_data(int fd, void *data, size_t size)
+{
+	char *p = data;
+	int ret = 0;
+	FILE *fp;
+	int dupfd;
+
+	dupfd = dup(fd);
+	if (dupfd < 0)
+		return errno;
+
+	fp = fdopen(dupfd, "r");
+	if (!fp) {
+		ret = errno;
+		close(dupfd);
+		goto out;
+	}
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
+			}
+			break;
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
+		*p = '\0';
+		size -= len;
+	}
+
+	fclose(fp);
+out:
+	return ret;
+}
+
 static void fio_client_json_init(void)
 {
 	char time_buf[32];
@@ -763,13 +815,17 @@ static int __fio_client_send_local_ini(struct fio_client *client,
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
