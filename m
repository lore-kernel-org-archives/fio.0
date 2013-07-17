Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:40488 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3GQVXG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Jul 2013 17:23:06 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 88BA7127BE
	for <fio@vger.kernel.org>; Wed, 17 Jul 2013 23:23:03 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 864DA5B4100A
	for <fio@vger.kernel.org>; Wed, 17 Jul 2013 23:23:03 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B_xie5fsC86i for <fio@vger.kernel.org>;
	Wed, 17 Jul 2013 23:23:03 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 29F805B41007
	for <fio@vger.kernel.org>; Wed, 17 Jul 2013 23:23:03 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 35h6EcQvu_el for <fio@vger.kernel.org>;
	Wed, 17 Jul 2013 23:23:02 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 9AD3117BC23
	for <fio@vger.kernel.org>; Wed, 17 Jul 2013 23:23:02 +0200 (CEST)
Message-ID: <51E70B35.1080702@enovance.com>
Date: Wed, 17 Jul 2013 23:23:01 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [pull request] Updates for exec_string
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d1415111eebe7a95d8de1af1ec61e80f9d534552:

   genfio: Enforce time_based if runtime > 0 (2013-07-12 17:13:59 +0200)

are available in the git repository at:

   git@github.com:enovance/fio.git exec_string

for you to fetch changes up to ce4864950d2ced54e0a1ccb8ef9a1e62135f1d2d:

   backend: Logging exec_{pre|post}run (2013-07-17 23:16:31 +0200)

----------------------------------------------------------------
Erwan Velu (2):
       backend: Get rid of sh -c for exec_string
       backend: Logging exec_{pre|post}run

  backend.c | 11 ++++++-----
  fio.1     |  6 ++++++
  2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/backend.c b/backend.c
index 8d16fe2..b9c1c12 100644
--- a/backend.c
+++ b/backend.c
@@ -1086,14 +1086,15 @@ static int keep_running(struct thread_data *td)
      return 0;
  }

-static int exec_string(const char *string)
+static int exec_string(struct thread_options *o, const char *string, 
const char *mode)
  {
-    int ret, newlen = strlen(string) + 1 + 8;
+    int ret, newlen = strlen(string) + strlen(o->name) + strlen(mode) + 
9 + 1;
      char *str;

      str = malloc(newlen);
-    sprintf(str, "sh -c %s", string);
+    sprintf(str, "%s &> %s.%s.txt", string, o->name, mode);

+    log_info("%s : Saving output of %s in %s.%s.txt\n",o->name, mode, 
o->name, mode);
      ret = system(str);
      if (ret == -1)
          log_err("fio: exec of cmd <%s> failed\n", str);
@@ -1274,7 +1275,7 @@ static void *thread_main(void *data)
      if (init_random_map(td))
          goto err;

-    if (o->exec_prerun && exec_string(o->exec_prerun))
+    if (o->exec_prerun && exec_string(o, o->exec_prerun, (const char 
*)"prerun"))
          goto err;

      if (o->pre_read) {
@@ -1397,7 +1398,7 @@ static void *thread_main(void *data)

      fio_mutex_up(writeout_mutex);
      if (o->exec_postrun)
-        exec_string(o->exec_postrun);
+        exec_string(o, o->exec_postrun, (const char *)"postrun");

      if (exitall_on_terminate)
          fio_terminate_threads(td->groupid);
diff --git a/fio.1 b/fio.1
index 91020b2..91fd531 100644
--- a/fio.1
+++ b/fio.1
@@ -1061,9 +1061,15 @@ simulate a smaller amount of memory. The amount 
specified is per worker.
  .TP
  .BI exec_prerun \fR=\fPstr
  Before running the job, execute the specified command with 
\fBsystem\fR\|(3).
+.RS
+Output is redirected in a file called \fBjobname.prerun.txt\fR
+.RE
  .TP
  .BI exec_postrun \fR=\fPstr
  Same as \fBexec_prerun\fR, but the command is executed after the job 
completes.
+.RS
+Output is redirected in a file called \fBjobname.postrun.txt\fR
+.RE
  .TP
  .BI ioscheduler \fR=\fPstr
  Attempt to switch the device hosting the file to the specified I/O 
scheduler.

