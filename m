Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38315 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLFNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Dec 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XxExx-0005et-KP
	for fio@vger.kernel.org; Sat, 06 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141206130003.D3C9140246@lyth.info>
Date: Sat,  6 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7fa085eaed61cf6ffe26a010d5b115cd1c84867c:

  verify: cleanup (2014-12-04 16:49:53 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 74a92cdd178ac5434d2bbbc1649fe66ff341c1d0:

  lib/rand: cleanup __fill_random_buffer() (2014-12-05 11:04:19 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      sync: use io_u_log_error() for more detailed error messages
      parse: make suggestions for unknown options
      lib/rand: fix bug with non uint64_t aligned random buffer fill
      lib/rand: cleanup __fill_random_buffer()

 engines/sync.c |    4 +++-
 init.c         |   25 +++++++++++++++++++++++++
 lib/rand.c     |   27 +++++++++++++++++++++++----
 parse.c        |    2 +-
 parse.h        |    2 ++
 5 files changed, 54 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sync.c b/engines/sync.c
index 41612df..48aafff 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -63,8 +63,10 @@ static int fio_io_end(struct thread_data *td, struct io_u *io_u, int ret)
 			io_u->error = errno;
 	}
 
-	if (io_u->error)
+	if (io_u->error) {
+		io_u_log_error(td, io_u);
 		td_verror(td, io_u->error, "xfer");
+	}
 
 	return FIO_Q_COMPLETED;
 }
diff --git a/init.c b/init.c
index 4f66759..9fbc477 100644
--- a/init.c
+++ b/init.c
@@ -1875,6 +1875,30 @@ static void parse_cmd_client(void *client, char *opt)
 	fio_client_add_cmd_option(client, opt);
 }
 
+static void show_closest_option(const char *name)
+{
+	int best_option, best_distance;
+	int i, distance;
+
+	while (*name == '-')
+		name++;
+
+	best_option = -1;
+	best_distance = INT_MAX;
+	i = 0;
+	while (l_opts[i].name) {
+		distance = string_distance(name, l_opts[i].name);
+		if (distance < best_distance) {
+			best_distance = distance;
+			best_option = i;
+		}
+		i++;
+	}
+
+	if (best_option != -1)
+		log_err("Did you mean %s?\n", l_opts[best_option].name);
+}
+
 int parse_cmd_line(int argc, char *argv[], int client_type)
 {
 	struct thread_data *td = NULL;
@@ -2237,6 +2261,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case '?':
 			log_err("%s: unrecognized option '%s'\n", argv[0],
 							argv[optind - 1]);
+			show_closest_option(argv[optind - 1]);
 		default:
 			do_exit++;
 			exit_val = 1;
diff --git a/lib/rand.c b/lib/rand.c
index 618a2f0..185b679 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -69,11 +69,26 @@ void init_rand_seed(struct frand_state *state, unsigned int seed)
 
 void __fill_random_buf(void *buf, unsigned int len, unsigned long seed)
 {
-	long *ptr = buf;
+	void *ptr = buf;
 
-	while ((void *) ptr - buf < len) {
-		*ptr = seed;
-		ptr++;
+	while (len) {
+		int this_len;
+
+		if (len >= sizeof(int64_t)) {
+			*((int64_t *) ptr) = seed;
+			this_len = sizeof(int64_t);
+		} else if (len >= sizeof(int32_t)) {
+			*((int32_t *) ptr) = seed;
+			this_len = sizeof(int32_t);
+		} else if (len >= sizeof(int16_t)) {
+			*((int16_t *) ptr) = seed;
+			this_len = sizeof(int16_t);
+		} else {
+			*((int8_t *) ptr) = seed;
+			this_len = sizeof(int8_t);
+		}
+		ptr += this_len;
+		len -= this_len;
 		seed *= GOLDEN_RATIO_PRIME;
 		seed >>= 3;
 	}
@@ -146,10 +161,14 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 		__fill_random_buf(buf, this_len, seed);
 
 		len -= this_len;
+		if (!len)
+			break;
 		buf += this_len;
 
 		if (this_len > len)
 			this_len = len;
+		else if (len - this_len <= sizeof(long))
+			this_len = len;
 
 		if (pbytes)
 			fill_pattern(buf, this_len, pattern, pbytes);
diff --git a/parse.c b/parse.c
index 4209647..141f4b2 100644
--- a/parse.c
+++ b/parse.c
@@ -1068,7 +1068,7 @@ int parse_option(char *opt, const char *input,
  * Option match, levenshtein distance. Handy for not quite remembering what
  * the option name is.
  */
-static int string_distance(const char *s1, const char *s2)
+int string_distance(const char *s1, const char *s2)
 {
 	unsigned int s1_len = strlen(s1);
 	unsigned int s2_len = strlen(s2);
diff --git a/parse.h b/parse.h
index a9d726d..15f2e06 100644
--- a/parse.h
+++ b/parse.h
@@ -95,6 +95,8 @@ extern int check_str_bytes(const char *p, long long *val, void *data);
 extern int check_str_time(const char *p, long long *val, int);
 extern int str_to_float(const char *str, double *val, int is_time);
 
+extern int string_distance(const char *s1, const char *s2);
+
 /*
  * Handlers for the options
  */
