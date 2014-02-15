Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaBONAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 Feb 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WEeqi-0002BC-7b
	for fio@vger.kernel.org; Sat, 15 Feb 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140215130003.1EF3445349@strynoevaenget.dk>
Date: Sat, 15 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b74b8208826be02d93d0933eb24ad792f4e78f64:

  Fix inverted logic in gtod_reduce() (2014-02-13 20:04:02 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 81fa6e06408879509e005cbb192205b9125f7614:

  Fix early termination of cpu id string (2014-02-14 08:48:22 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Fix another typo in gtod_reduce()
      Fix early termination of cpu id string

 arch/arch-x86-common.h |    4 ++--
 io_u.c                 |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 26a14a8..31aa79f 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -54,13 +54,13 @@ static inline int arch_init_amd(unsigned int level)
 static inline int arch_init(char *envp[])
 {
 	unsigned int level;
-	char str[12];
+	char str[13];
 
 	cpuid(0, &level, (unsigned int *) &str[0],
 			 (unsigned int *) &str[8],
 			 (unsigned int *) &str[4]);
 
-	str[11] = '\0';
+	str[12] = '\0';
 	if (!strcmp(str, "GenuineIntel"))
 		tsc_reliable = arch_init_intel(level);
 	else if (!strcmp(str, "AuthenticAMD"))
diff --git a/io_u.c b/io_u.c
index 61038a4..b84b3e2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1523,7 +1523,7 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 
 static inline int gtod_reduce(struct thread_data *td)
 {
-	return td->o.disable_clat && td->o.disable_lat && !td->o.disable_slat
+	return td->o.disable_clat && td->o.disable_lat && td->o.disable_slat
 		&& td->o.disable_bw;
 }
 
