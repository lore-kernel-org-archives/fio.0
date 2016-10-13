Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53767 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754035AbcJMMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Oct 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bueg7-00086V-7R
        for fio@vger.kernel.org; Thu, 13 Oct 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161013120002.087E72C0400@kernel.dk>
Date: Thu, 13 Oct 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d23ae82785f99927331e358d2c0deac5e53f2df1:

  Update bandwidth log documentation (2016-10-11 16:04:28 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to afd2ceffd65514a54665493075d7957ec9d0e5fc:

  Add alias for 'disable_bw_measurement' option (2016-10-12 08:59:25 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      Implement nice() for Windows

Jens Axboe (1):
      Add alias for 'disable_bw_measurement' option

 HOWTO              |  4 ++++
 options.c          |  1 +
 os/windows/posix.c | 17 +++++++++++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 07419a1..cf1024c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1066,6 +1066,10 @@ random_generator=str	Fio supports the following engines for generating
 
 nice=int	Run the job with the given nice value. See man nice(2).
 
+     On Windows, values less than -15 set the process class to "High";
+     -1 through -15 set "Above Normal"; 1 through 15 "Below Normal";
+     and above 15 "Idle" priority class.
+
 prio=int	Set the io priority value of this job. Linux limits us to
 		a positive value between 0 and 7, with 0 being the highest.
 		See man ionice(1). Refer to an appropriate manpage for
diff --git a/options.c b/options.c
index bcda556..3c9adfb 100644
--- a/options.c
+++ b/options.c
@@ -3920,6 +3920,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "disable_bw_measurement",
+		.alias	= "disable_bw",
 		.lname	= "Disable bandwidth stats",
 		.type	= FIO_OPT_BOOL,
 		.off1	= offsetof(struct thread_options, disable_bw),
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 3388127..bbd93e9 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -647,10 +647,19 @@ int setgid(gid_t gid)
 
 int nice(int incr)
 {
-	if (incr != 0) {
-		errno = EINVAL;
-		return -1;
-	}
+	DWORD prioclass = NORMAL_PRIORITY_CLASS;
+	
+	if (incr < -15)
+		prioclass = HIGH_PRIORITY_CLASS;
+	else if (incr < 0)
+		prioclass = ABOVE_NORMAL_PRIORITY_CLASS;
+	else if (incr > 15)
+		prioclass = IDLE_PRIORITY_CLASS;
+	else if (incr > 0)
+		prioclass = BELOW_NORMAL_PRIORITY_CLASS;
+	
+	if (!SetPriorityClass(GetCurrentProcess(), prioclass))
+		log_err("fio: SetPriorityClass failed\n");
 
 	return 0;
 }
