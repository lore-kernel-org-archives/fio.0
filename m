Return-Path: <fio-owner@vger.kernel.org>
Received: from thorn.bewilderbeest.net ([71.19.156.171]:52275 "EHLO
	thorn.bewilderbeest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbbCLUfb (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Mar 2015 16:35:31 -0400
From: Zev Weiss <zev@bewilderbeest.net>
Subject: [PATCH] init: fix exit status with bogus arguments
Date: Thu, 12 Mar 2015 15:28:17 -0500
Message-Id: <1426192097-25806-1-git-send-email-zev@bewilderbeest.net>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Zev Weiss <zev@bewilderbeest.net>

Had been exiting "successfully" on invalid command-line arguments.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
---
 init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init.c b/init.c
index 7aedf2b..95e26b8 100644
--- a/init.c
+++ b/init.c
@@ -2135,6 +2135,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 						td = NULL;
 					}
 					do_exit++;
+					exit_val = 1;
 					break;
 				}
 				fio_options_set_ioengine_opts(l_opts, td);
@@ -2153,6 +2154,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 					td = NULL;
 				}
 				do_exit++;
+				exit_val = 1;
 			}
 
 			if (!ret && !strcmp(opt, "ioengine")) {
@@ -2161,6 +2163,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 					put_job(td);
 					td = NULL;
 					do_exit++;
+					exit_val = 1;
 					break;
 				}
 				fio_options_set_ioengine_opts(l_opts, td);
-- 
2.1.4

