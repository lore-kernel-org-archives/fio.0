Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42730 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbeC3MAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Mar 2018 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f1sha-0001BU-4u
        for fio@vger.kernel.org; Fri, 30 Mar 2018 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180330120002.708272C00D1@kernel.dk>
Date: Fri, 30 Mar 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b348b7c7a1a6278d793698fc23993620ae9c588a:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-03-23 09:58:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d6d74886759e3f268a6a3b12a47872865b867023:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-03-29 10:02:25 -0600)

----------------------------------------------------------------
Bart Van Assche (2):
      Make it clear to Coverity that the tmp buffer in switch_ioscheduler() is \0-terminated
      switch_ioscheduler(): only remove the last character if it's a newline

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 backend.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index fc83ed1..f2d7cc3 100644
--- a/backend.c
+++ b/backend.c
@@ -1328,7 +1328,7 @@ static int init_io_u(struct thread_data *td)
 static int switch_ioscheduler(struct thread_data *td)
 {
 #ifdef FIO_HAVE_IOSCHED_SWITCH
-	char tmp[256], tmp2[128];
+	char tmp[256], tmp2[128], *p;
 	FILE *f;
 	int ret;
 
@@ -1364,17 +1364,19 @@ static int switch_ioscheduler(struct thread_data *td)
 	/*
 	 * Read back and check that the selected scheduler is now the default.
 	 */
-	memset(tmp, 0, sizeof(tmp));
-	ret = fread(tmp, sizeof(tmp), 1, f);
+	ret = fread(tmp, 1, sizeof(tmp) - 1, f);
 	if (ferror(f) || ret < 0) {
 		td_verror(td, errno, "fread");
 		fclose(f);
 		return 1;
 	}
+	tmp[ret] = '\0';
 	/*
-	 * either a list of io schedulers or "none\n" is expected.
+	 * either a list of io schedulers or "none\n" is expected. Strip the
+	 * trailing newline.
 	 */
-	tmp[strlen(tmp) - 1] = '\0';
+	p = tmp;
+	strsep(&p, "\n");
 
 	/*
 	 * Write to "none" entry doesn't fail, so check the result here.
