Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbbDVMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2015 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YktJz-0002qQ-BK
	for fio@vger.kernel.org; Wed, 22 Apr 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150422120002.1357A401CF@lyth.info>
Date: Wed, 22 Apr 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1d6d3455a9ad610a423f5d4ca849fbe82049997c:

  Don't export state variable (2015-04-20 19:15:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9e98688960347b9b733db9426fb7747f22d3a77e:

  Fix off-by-one in cpus_allowed (2015-04-21 09:39:32 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fix off-by-one in cpu mask index handling
      Fix off-by-one in cpus_allowed

 options.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 017920e..5fbad31 100644
--- a/options.c
+++ b/options.c
@@ -443,9 +443,9 @@ static int str_cpumask_cb(void *data, unsigned long long *val)
 
 	for (i = 0; i < sizeof(int) * 8; i++) {
 		if ((1 << i) & *val) {
-			if (i > max_cpu) {
+			if (i >= max_cpu) {
 				log_err("fio: CPU %d too large (max=%ld)\n", i,
-								max_cpu);
+								max_cpu - 1);
 				return 1;
 			}
 			dprint(FD_PARSE, "set cpu allowed %d\n", i);
@@ -503,9 +503,9 @@ static int set_cpus_allowed(struct thread_data *td, os_cpu_mask_t *mask,
 				ret = 1;
 				break;
 			}
-			if (icpu > max_cpu) {
+			if (icpu >= max_cpu) {
 				log_err("fio: CPU %d too large (max=%ld)\n",
-							icpu, max_cpu);
+							icpu, max_cpu - 1);
 				ret = 1;
 				break;
 			}
