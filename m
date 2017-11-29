Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40410 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752694AbdK2NAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Nov 2017 08:00:19 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eK1yM-0008En-8B
        for fio@vger.kernel.org; Wed, 29 Nov 2017 13:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171129130002.4FE3B2C011A@kernel.dk>
Date: Wed, 29 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 609ac152d5a7d0bc5c645f8c50bf2415e7b2d4d3:

  docs: Add documention for RDMA ioengine options. (2017-11-23 22:08:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1201b24acd347d6daaad969e6abfe0975cb86bc8:

  init: did_arg cleanup (2017-11-28 16:00:22 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      init: check and fail status-interval settings that are too small
      init: remove dead code
      init: did_arg cleanup

 init.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index b7e9c0e..acbbd48 100644
--- a/init.c
+++ b/init.c
@@ -78,7 +78,7 @@ unsigned int fio_debug_jobno = -1;
 unsigned int *fio_debug_jobp = NULL;
 
 static char cmd_optstr[256];
-static int did_arg;
+static bool did_arg;
 
 #define FIO_CLIENT_FLAG		(1 << 16)
 
@@ -2430,35 +2430,35 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			output_format |= FIO_OUTPUT_TERSE;
 			break;
 		case 'h':
-			did_arg = 1;
+			did_arg = true;
 			if (!cur_client) {
 				usage(argv[0]);
 				do_exit++;
 			}
 			break;
 		case 'c':
-			did_arg = 1;
+			did_arg = true;
 			if (!cur_client) {
 				fio_show_option_help(optarg);
 				do_exit++;
 			}
 			break;
 		case 'i':
-			did_arg = 1;
+			did_arg = true;
 			if (!cur_client) {
 				fio_show_ioengine_help(optarg);
 				do_exit++;
 			}
 			break;
 		case 's':
-			did_arg = 1;
+			did_arg = true;
 			dump_cmdline = 1;
 			break;
 		case 'r':
 			read_only = 1;
 			break;
 		case 'v':
-			did_arg = 1;
+			did_arg = true;
 			if (!cur_client) {
 				log_info("%s\n", fio_version_string);
 				do_exit++;
@@ -2494,7 +2494,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				do_exit++;
 			break;
 		case 'P':
-			did_arg = 1;
+			did_arg = true;
 			parse_only = 1;
 			break;
 		case 'x': {
@@ -2516,12 +2516,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 #ifdef CONFIG_ZLIB
 		case 'X':
 			exit_val = iolog_file_inflate(optarg);
-			did_arg++;
+			did_arg = true;
 			do_exit++;
 			break;
 #endif
 		case 'p':
-			did_arg = 1;
+			did_arg = true;
 			if (exec_profile)
 				free(exec_profile);
 			exec_profile = strdup(optarg);
@@ -2535,7 +2535,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				if (ret)
 					goto out_free;
 				td = NULL;
-				did_arg = 1;
+				did_arg = true;
 			}
 			if (!td) {
 				int is_section = !strncmp(opt, "name", 4);
@@ -2610,7 +2610,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			break;
 		case 'S':
-			did_arg = 1;
+			did_arg = true;
 #ifndef CONFIG_NO_SHM
 			if (nr_clients) {
 				log_err("fio: can't be both client and server\n");
@@ -2636,14 +2636,14 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'I':
 			if ((ret = fio_idle_prof_parse_opt(optarg))) {
 				/* exit on error and calibration only */
-				did_arg = 1;
+				did_arg = true;
 				do_exit++;
 				if (ret == -1)
 					exit_val = 1;
 			}
 			break;
 		case 'C':
-			did_arg = 1;
+			did_arg = true;
 			if (is_backend) {
 				log_err("fio: can't be both client and server\n");
 				do_exit++;
@@ -2700,19 +2700,19 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			break;
 		case 'R':
-			did_arg = 1;
+			did_arg = true;
 			if (fio_client_add_ini_file(cur_client, optarg, true)) {
 				do_exit++;
 				exit_val = 1;
 			}
 			break;
 		case 'T':
-			did_arg = 1;
+			did_arg = true;
 			do_exit++;
 			exit_val = fio_monotonic_clocktest(1);
 			break;
 		case 'G':
-			did_arg = 1;
+			did_arg = true;
 			do_exit++;
 			exit_val = fio_crctest(optarg);
 			break;
@@ -2725,6 +2725,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				exit_val = 1;
 				break;
 			}
+			if (val < 1000) {
+				log_err("fio: status interval too small\n");
+				do_exit++;
+				exit_val = 1;
+			}
 			status_interval = val / 1000;
 			break;
 			}
@@ -2865,13 +2870,8 @@ int parse_options(int argc, char *argv[])
 			return 0;
 
 		log_err("No job(s) defined\n\n");
-
-		if (!did_arg) {
-			usage(argv[0]);
-			return 1;
-		}
-
-		return 0;
+		usage(argv[0]);
+		return 1;
 	}
 
 	if (output_format & FIO_OUTPUT_NORMAL)
