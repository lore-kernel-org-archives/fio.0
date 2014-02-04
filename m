Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 2/2] init: log error on missing --output-format argument
Date: Tue,  4 Feb 2014 14:27:11 +0100
Message-Id: <1391520431-21732-3-git-send-email-stefanha@redhat.com>
In-Reply-To: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
References: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

strcmp(optarg, "foo") will crash if --output-format was given without an
argument.  Log an error and exit properly instead of crashing.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/init.c b/init.c
index 05c73ef..6c48d3a 100644
--- a/init.c
+++ b/init.c
@@ -1652,6 +1652,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			output_format = FIO_OUTPUT_TERSE;
 			break;
 		case 'F':
+			if (!optarg) {
+				log_err("fio: missing --output-format argument\n");
+				exit_val = 1;
+				do_exit++;
+				break;
+			}
 			if (!strcmp(optarg, "minimal") ||
 			    !strcmp(optarg, "terse") ||
 			    !strcmp(optarg, "csv"))
-- 
1.8.5.3


