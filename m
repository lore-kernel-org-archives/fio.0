Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaKTNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Nov 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XrRLB-00023n-VY
	for fio@vger.kernel.org; Thu, 20 Nov 2014 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141120130003.877CC4012D@lyth.info>
Date: Thu, 20 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 21750a254b5481f78ac3c6697754abf3cfa63e89:

  Kill off -Wshadow again (2014-11-18 20:14:23 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 256bc54c13ba8b37eb0e08fdbbd1bbbcfe8a86cc:

  server: fix missing ETA in some cases (2014-11-19 09:34:01 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      trigger: enable separate remote and local trigger
      HOWTO: add description and examples of verify triggers
      client: defer local trigger execute until after state is received
      trigger: always send trigger, not just when remote command is set
      server: fix missing ETA in some cases

 HOWTO     |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 backend.c |    2 +-
 client.c  |    1 +
 eta.c     |    2 +-
 fio.h     |    1 +
 init.c    |   58 ++++++++++++++++++++++-----------------------
 6 files changed, 111 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cdb7b01..c73b9ec 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1993,3 +1993,81 @@ An unit work is defined as touching a full page of unsigned characters. Mean
 and standard deviation of time to complete an unit work is reported in "unit
 work" section. Options can be chosen to report detailed percpu idleness or
 overall system idleness by aggregating percpu stats.
+
+
+10.0 Verification and triggers
+------------------------------
+Fio is usually run in one of two ways, when data verification is done. The
+first is a normal write job of some sort with verify enabled. When the
+write phase has completed, fio switches to reads and verifies everything
+it wrote. The second model is running just the write phase, and then later
+on running the same job (but with reads instead of writes) to repeat the
+same IO patterns and verify the contents. Both of these methods depend
+on the write phase being completed, as fio otherwise has no idea how much
+data was written.
+
+With verification triggers, fio supports dumping the current write state
+to local files. Then a subsequent read verify workload can load this state
+and know exactly where to stop. This is useful for testing cases where
+power is cut to a server in a managed fashion, for instance.
+
+A verification trigger consists of two things:
+
+1) Storing the write state of each job
+2) Executing a trigger command
+
+The write state is relatively small, on the order of hundreds of bytes
+to single kilobytes. It contains information on the number of completions
+done, the last X completions, etc.
+
+A trigger is invoked either through creation ('touch') of a specified
+file in the system, or through a timeout setting. If fio is run with
+--trigger-file=/tmp/trigger-file, then it will continually check for
+the existence of /tmp/trigger-file. When it sees this file, it will
+fire off the trigger (thus saving state, and executing the trigger
+command).
+
+For client/server runs, there's both a local and remote trigger. If
+fio is running as a server backend, it will send the job states back
+to the client for safe storage, then execute the remote trigger, if
+specified. If a local trigger is specified, the server will still send
+back the write state, but the client will then execute the trigger.
+
+10.1 Verification trigger example
+---------------------------------
+Lets say we want to run a powercut test on the remote machine 'server'.
+Our write workload is in write-test.fio. We want to cut power to 'server'
+at some point during the run, and we'll run this test from the safety
+or our local machine, 'localbox'. On the server, we'll start the fio
+backend normally:
+
+server# fio --server
+
+and on the client, we'll fire off the workload:
+
+localbox$ fio --client=server --trigger-file=/tmp/my-trigger --trigger-remote="bash -c \"echo b > /proc/sysrq-triger\""
+
+We set /tmp/my-trigger as the trigger file, and we tell fio to execute
+
+echo b > /proc/sysrq-trigger
+
+on the server once it has received the trigger and sent us the write
+state. This will work, but it's not _really_ cutting power to the server,
+it's merely abruptly rebooting it. If we have a remote way of cutting
+power to the server through IPMI or similar, we could do that through
+a local trigger command instead. Lets assume we have a script that does
+IPMI reboot of a given hostname, ipmi-reboot. On localbox, we could
+then have run fio with a local trigger instead:
+
+localbox$ fio --client=server --trigger-file=/tmp/my-trigger --trigger="ipmi-reboot server"
+
+For this case, fio would wait for the server to send us the write state,
+then execute 'ipmi-reboot server' when that happened.
+
+10.1 Loading verify state
+-------------------------
+To load store write state, read verification job file must contain
+the verify_state_load option. If that is set, fio will load the previously
+stored state. For a local fio run this is done by loading the files directly,
+and on a client/server run, the server backend will ask the client to send
+the files over and load them from there.
diff --git a/backend.c b/backend.c
index 77f5233..6816362 100644
--- a/backend.c
+++ b/backend.c
@@ -1805,7 +1805,7 @@ void check_trigger_file(void)
 {
 	if (__check_trigger_file() || trigger_timedout()) {
 		if (nr_clients)
-			fio_clients_send_trigger(trigger_cmd);
+			fio_clients_send_trigger(trigger_remote_cmd);
 		else {
 			verify_save_state();
 			fio_terminate_threads(TERMINATE_ALL);
diff --git a/client.c b/client.c
index 52440f0..2c10c03 100644
--- a/client.c
+++ b/client.c
@@ -1485,6 +1485,7 @@ int fio_handle_client(struct fio_client *client)
 		char buf[64];
 
 		__verify_save_state(pdu, server_name(client, buf, sizeof(buf)));
+		exec_trigger(trigger_cmd);
 		break;
 		}
 	case FIO_NET_CMD_SENDFILE: {
diff --git a/eta.c b/eta.c
index 5be5aed..a90f1fb 100644
--- a/eta.c
+++ b/eta.c
@@ -574,7 +574,7 @@ struct jobs_eta *get_jobs_eta(int force, size_t *size)
 	je = malloc(*size);
 	memset(je, 0, *size);
 
-	if (!calc_thread_status(je, 0)) {
+	if (!calc_thread_status(je, force)) {
 		free(je);
 		return NULL;
 	}
diff --git a/fio.h b/fio.h
index 50cf1b0..0601b37 100644
--- a/fio.h
+++ b/fio.h
@@ -393,6 +393,7 @@ extern int helper_do_stat;
 extern pthread_cond_t helper_cond;
 extern char *trigger_file;
 extern char *trigger_cmd;
+extern char *trigger_remote_cmd;
 extern long long trigger_timeout;
 
 extern struct thread_data *threads;
diff --git a/init.c b/init.c
index 108f2b8..b72689a 100644
--- a/init.c
+++ b/init.c
@@ -65,8 +65,9 @@ int read_only = 0;
 int status_interval = 0;
 
 char *trigger_file = NULL;
-char *trigger_cmd = NULL;
 long long trigger_timeout = 0;
+char *trigger_cmd = NULL;
+char *trigger_remote_cmd = NULL;
 
 static int prev_group_jobs;
 
@@ -246,7 +247,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'L',
 	},
 	{
-		.name		= (char *) "trigger",
+		.name		= (char *) "trigger-file",
 		.has_arg	= required_argument,
 		.val		= 'W',
 	},
@@ -256,6 +257,16 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'B',
 	},
 	{
+		.name		= (char *) "trigger",
+		.has_arg	= required_argument,
+		.val		= 'H',
+	},
+	{
+		.name		= (char *) "trigger-remote",
+		.has_arg	= required_argument,
+		.val		= 'J',
+	},
+	{
 		.name		= NULL,
 	},
 };
@@ -287,6 +298,11 @@ static void free_shm(void)
 		free_threads_shm();
 	}
 
+	free(trigger_file);
+	free(trigger_cmd);
+	free(trigger_remote_cmd);
+	trigger_file = trigger_cmd = trigger_remote_cmd = NULL;
+
 	options_free(fio_options, &def_thread);
 	fio_filelock_exit();
 	scleanup();
@@ -1679,8 +1695,10 @@ static void usage(const char *name)
 #ifdef CONFIG_ZLIB
 	printf("  --inflate-log=log\tInflate and output compressed log\n");
 #endif
-	printf("  --trigger=file:cmd\tExecute trigger cmd when file exists\n");
+	printf("  --trigger-file=file\tExecute trigger cmd when file exists\n");
 	printf("  --trigger-timeout=t\tExecute trigger af this time\n");
+	printf("  --trigger=cmd\t\tSet this command as local trigger\n");
+	printf("  --trigger-remote=cmd\tSet this command as remote trigger\n");
 	printf("\nFio was written by Jens Axboe <jens.axboe@oracle.com>");
 	printf("\n                   Jens Axboe <jaxboe@fusionio.com>");
 	printf("\n                   Jens Axboe <axboe@fb.com>\n");
@@ -2200,33 +2218,15 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			status_interval = val / 1000;
 			break;
 			}
-		case 'W': {
-			char *split, *cmd;
-			size_t sz;
-
-			split = strchr(optarg, ':');
-			if (!split) {
-				log_err("fio: trigger is file:command\n");
-				do_exit++;
-				exit_val = 1;
-			}
-
-			sz = split - optarg;
-			if (sz) {
-				trigger_file = calloc(1, sz + 1);
-				strncpy(trigger_file, optarg, sz);
-			}
-
-			split++;
-			cmd = trigger_cmd = strdup(split);
-			strip_blank_front(&trigger_cmd);
-			strip_blank_end(trigger_cmd);
-			if (strlen(trigger_cmd) == 0) {
-				free(cmd);
-				trigger_cmd = NULL;
-			}
+		case 'W':
+			trigger_file = strdup(optarg);
+			break;
+		case 'H':
+			trigger_cmd = strdup(optarg);
+			break;
+		case 'J':
+			trigger_remote_cmd = strdup(optarg);
 			break;
-			}
 		case 'B':
 			if (check_str_time(optarg, &trigger_timeout, 1)) {
 				log_err("fio: failed parsing time %s\n", optarg);
