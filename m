Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbHVMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 22 Aug 2015 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZT7Ss-0004oi-RH
	for fio@vger.kernel.org; Sat, 22 Aug 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150822120001.E58652C00BE@kernel.dk>
Date: Sat, 22 Aug 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae156be6aadb7b4ca6db8584cf5c9e957df916ed:

  configure: cleanup strsep() test case (2015-08-18 11:26:00 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c6d140fb8c0cf58d61bbd42ea5382f42d3b8fa20:

  Fix aux_path for verify state saving (2015-08-21 11:09:03 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      README: update for trigger options
      Add --aux-path support
      parse: only print option mismatch help, if the distance is close enough
      Fix aux_path for verify state saving

 README    |  5 +++++
 backend.c | 14 +++-----------
 client.c  | 10 ++++++++--
 fio.h     |  1 +
 init.c    | 15 ++++++++++++++-
 options.c |  2 +-
 parse.c   | 13 +++++++++++++
 parse.h   |  1 +
 verify.c  | 20 +++++++++++++++-----
 verify.h  |  2 +-
 10 files changed, 62 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index cfe7084..9d0863d 100644
--- a/README
+++ b/README
@@ -179,6 +179,11 @@ $ fio
 				(option=system,percpu) or run unit work
 				calibration only (option=calibrate).
 	--inflate-log=log	Inflate and output compressed log
+	--trigger-file=file	Execute trigger cmd when file exists
+	--trigger-timeout=t	Execute trigger af this time
+	--trigger=cmd		Set this command as local trigger
+	--trigger-remote=cmd	Set this command as remote trigger
+	--aux-path=path		Use this path for fio state generated files
 
 
 Any parameters following the options will be assumed to be job files,
diff --git a/backend.c b/backend.c
index 76994d9..d41c742 100644
--- a/backend.c
+++ b/backend.c
@@ -1638,16 +1638,8 @@ static void *thread_main(void *data)
 	td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
 
 	if (td->o.verify_state_save && !(td->flags & TD_F_VSTATE_SAVED) &&
-	    (td->o.verify != VERIFY_NONE && td_write(td))) {
-		struct all_io_list *state;
-		size_t sz;
-
-		state = get_all_io_list(td->thread_number, &sz);
-		if (state) {
-			__verify_save_state(state, "local");
-			free(state);
-		}
-	}
+	    (td->o.verify != VERIFY_NONE && td_write(td)))
+		verify_save_state(td->thread_number);
 
 	fio_unpin_memory(td);
 
@@ -1897,7 +1889,7 @@ void check_trigger_file(void)
 		if (nr_clients)
 			fio_clients_send_trigger(trigger_remote_cmd);
 		else {
-			verify_save_state();
+			verify_save_state(IO_LIST_ALL);
 			fio_terminate_threads(TERMINATE_ALL);
 			exec_trigger(trigger_cmd);
 		}
diff --git a/client.c b/client.c
index 110a01b..147ee38 100644
--- a/client.c
+++ b/client.c
@@ -1497,9 +1497,15 @@ int fio_handle_client(struct fio_client *client)
 		break;
 	case FIO_NET_CMD_VTRIGGER: {
 		struct all_io_list *pdu = (struct all_io_list *) cmd->payload;
-		char buf[64];
+		char buf[128];
+		int off = 0;
 
-		__verify_save_state(pdu, server_name(client, buf, sizeof(buf)));
+		if (aux_path) {
+			strcpy(buf, aux_path);
+			off = strlen(buf);
+		}
+
+		__verify_save_state(pdu, server_name(client, &buf[off], sizeof(buf) - off));
 		exec_trigger(trigger_cmd);
 		break;
 		}
diff --git a/fio.h b/fio.h
index 17bc02b..53d8256 100644
--- a/fio.h
+++ b/fio.h
@@ -434,6 +434,7 @@ extern char *trigger_file;
 extern char *trigger_cmd;
 extern char *trigger_remote_cmd;
 extern long long trigger_timeout;
+extern char *aux_path;
 
 extern struct thread_data *threads;
 
diff --git a/init.c b/init.c
index 6d8dcff..cdb98c5 100644
--- a/init.c
+++ b/init.c
@@ -69,6 +69,8 @@ long long trigger_timeout = 0;
 char *trigger_cmd = NULL;
 char *trigger_remote_cmd = NULL;
 
+char *aux_path = NULL;
+
 static int prev_group_jobs;
 
 unsigned long fio_debug = 0;
@@ -267,6 +269,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'J',
 	},
 	{
+		.name		= (char *) "aux-path",
+		.has_arg	= required_argument,
+		.val		= 'K',
+	},
+	{
 		.name		= NULL,
 	},
 };
@@ -1793,6 +1800,7 @@ static void usage(const char *name)
 	printf("  --trigger-timeout=t\tExecute trigger af this time\n");
 	printf("  --trigger=cmd\t\tSet this command as local trigger\n");
 	printf("  --trigger-remote=cmd\tSet this command as remote trigger\n");
+	printf("  --aux-path=path\tUse this path for fio state generated files\n");
 	printf("\nFio was written by Jens Axboe <jens.axboe@oracle.com>");
 	printf("\n                   Jens Axboe <jaxboe@fusionio.com>");
 	printf("\n                   Jens Axboe <axboe@fb.com>\n");
@@ -1990,7 +1998,7 @@ static void show_closest_option(const char *name)
 		i++;
 	}
 
-	if (best_option != -1)
+	if (best_option != -1 && string_distance_ok(name, best_distance))
 		log_err("Did you mean %s?\n", l_opts[best_option].name);
 }
 
@@ -2383,6 +2391,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				free(trigger_remote_cmd);
 			trigger_remote_cmd = strdup(optarg);
 			break;
+		case 'K':
+			if (aux_path)
+				free(aux_path);
+			aux_path = strdup(optarg);
+			break;
 		case 'B':
 			if (check_str_time(optarg, &trigger_timeout, 1)) {
 				log_err("fio: failed parsing time %s\n", optarg);
diff --git a/options.c b/options.c
index ed5d37e..e040495 100644
--- a/options.c
+++ b/options.c
@@ -4093,7 +4093,7 @@ static void show_closest_option(const char *opt)
 		i++;
 	}
 
-	if (best_option != -1)
+	if (best_option != -1 && string_distance_ok(name, best_distance))
 		log_err("Did you mean %s?\n", fio_options[best_option].name);
 
 	free(name);
diff --git a/parse.c b/parse.c
index 745056b..3e94c7d 100644
--- a/parse.c
+++ b/parse.c
@@ -1061,6 +1061,19 @@ int string_distance(const char *s1, const char *s2)
 	return i;
 }
 
+/*
+ * Make a guess of whether the distance from 's1' is significant enough
+ * to warrant printing the guess. We set this to a 1/2 match.
+ */
+int string_distance_ok(const char *opt, int distance)
+{
+	size_t len;
+
+	len = strlen(opt);
+	len = (len + 1) / 2;
+	return distance <= len;
+}
+
 static struct fio_option *find_child(struct fio_option *options,
 				     struct fio_option *o)
 {
diff --git a/parse.h b/parse.h
index 264243b..0a813b0 100644
--- a/parse.h
+++ b/parse.h
@@ -97,6 +97,7 @@ extern int check_str_time(const char *p, long long *val, int);
 extern int str_to_float(const char *str, double *val, int is_time);
 
 extern int string_distance(const char *s1, const char *s2);
+extern int string_distance_ok(const char *s1, int dist);
 
 /*
  * Handlers for the options
diff --git a/verify.c b/verify.c
index f833e85..7608caf 100644
--- a/verify.c
+++ b/verify.c
@@ -231,8 +231,11 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 
 	ptr = strdup(f->file_name);
 
-	fname[DUMP_BUF_SZ - 1] = '\0';
-	strncpy(fname, basename(ptr), DUMP_BUF_SZ - 1);
+	memset(fname, 0, sizeof(fname));
+	if (aux_path)
+		sprintf(fname, "%s%s", aux_path, FIO_OS_PATH_SEPARATOR);
+
+	strncpy(fname + strlen(fname), basename(ptr), buf_left - 1);
 
 	buf_left -= strlen(fname);
 	if (buf_left <= 0) {
@@ -1477,14 +1480,21 @@ void __verify_save_state(struct all_io_list *state, const char *prefix)
 	}
 }
 
-void verify_save_state(void)
+void verify_save_state(int mask)
 {
 	struct all_io_list *state;
 	size_t sz;
 
-	state = get_all_io_list(IO_LIST_ALL, &sz);
+	state = get_all_io_list(mask, &sz);
 	if (state) {
-		__verify_save_state(state, "local");
+		char prefix[PATH_MAX];
+
+		if (aux_path)
+			sprintf(prefix, "%s%slocal", aux_path, FIO_OS_PATH_SEPARATOR);
+		else
+			strcpy(prefix, "local");
+
+		__verify_save_state(state, prefix);
 		free(state);
 	}
 }
diff --git a/verify.h b/verify.h
index c37b1d5..8305eeb 100644
--- a/verify.h
+++ b/verify.h
@@ -145,7 +145,7 @@ struct verify_state_hdr {
 #define IO_LIST_ALL		0xffffffff
 extern struct all_io_list *get_all_io_list(int, size_t *);
 extern void __verify_save_state(struct all_io_list *, const char *);
-extern void verify_save_state(void);
+extern void verify_save_state(int mask);
 extern int verify_load_state(struct thread_data *, const char *);
 extern void verify_free_state(struct thread_data *);
 extern int verify_state_should_stop(struct thread_data *, struct io_u *);
