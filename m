Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2nam03on0138.outbound.protection.outlook.com ([104.47.42.138]:28842
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750734AbeFFERP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Jun 2018 00:17:15 -0400
From: <Friendy.Su@sony.com>
Subject: [PATCH] idle-prof: Fix segment fault issue when run with
  '--idle-prof' and multiple output format normal,json
Date: Wed, 6 Jun 2018 04:17:09 +0000
Message-ID: <925A83423110DA4D836092D40AC7A7E8084BAA4F@APYOKXMS108.ap.sony.com>
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: No.Tanaka@sony.com, Hajime.Tomura@sony.com, Friendy.Su@sony.com

Original issue:

./fio --output-format=normal,json --idle-prof=system jobfile.job

job1: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=sync, iodepth=1
fio-3.7-19-ga43f
Starting 1 process
Segmentation fault (core dumped)

Fix solution:

do fio_idle_prof_cleanup() after all formats of output shown.

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 idletime.c | 8 +-------
 idletime.h | 1 +
 stat.c     | 2 ++
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/idletime.c b/idletime.c
index 8762c856..2f59f510 100644
--- a/idletime.c
+++ b/idletime.c
@@ -397,7 +397,7 @@ static double fio_idle_prof_cpu_stat(int cpu)
        return p * 100.0;
 }

-static void fio_idle_prof_cleanup(void)
+void fio_idle_prof_cleanup(void)
 {
        if (ipc.ipts) {
                free(ipc.ipts);
@@ -471,10 +471,6 @@ void show_idle_prof_stats(int output, struct json_object *parent,
                        log_buf(out, " stddev=%3.2f\n", ipc.cali_stddev);
                }

-               /* dynamic mem allocations can now be freed */
-               if (ipc.opt != IDLE_PROF_OPT_NONE)
-                       fio_idle_prof_cleanup();
-
                return;
        }

@@ -498,7 +494,5 @@ void show_idle_prof_stats(int output, struct json_object *parent,

                json_object_add_value_float(tmp, "unit_mean", ipc.cali_mean);
                json_object_add_value_float(tmp, "unit_stddev", ipc.cali_stddev);
-
-               fio_idle_prof_cleanup();
        }
 }
diff --git a/idletime.h b/idletime.h
index 6c1161a7..602456fe 100644
--- a/idletime.h
+++ b/idletime.h
@@ -58,4 +58,5 @@ extern void fio_idle_prof_stop(void);

 extern void show_idle_prof_stats(int, struct json_object *, struct buf_output *);

+extern void fio_idle_prof_cleanup(void);
 #endif
diff --git a/stat.c b/stat.c
index 5b49dddb..58edf047 100644
--- a/stat.c
+++ b/stat.c
@@ -1934,6 +1934,8 @@ void __show_run_stats(void)
                buf_output_free(out);
        }

+       fio_idle_prof_cleanup();
+
        log_info_flush();
        free(runstats);
        free(threadstats);
--
2.17.0


________________________________

This email is confidential and intended only for the use of the individual or entity named above and may contain information that is privileged. If you are not the intended recipient, you are notified that any dissemination, distribution or copying of this email is strictly prohibited. If you have received this email in error, please notify us immediately by return email or telephone and destroy the original message. - This mail is sent via Sony Asia Pacific Mail Gateway..
