Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbeKCVLW (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Nov 2018 17:11:22 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gIubA-00016R-J8
        for fio@vger.kernel.org; Sat, 03 Nov 2018 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181103120002.7D08C2C01D7@kernel.dk>
Date: Sat,  3 Nov 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 199710f5822cf22bf76107f26993a9468f93a422:

  oslib: fix strlcat's incorrect copying (2018-10-26 10:24:28 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 16500b5a0b03ee0142d592bb74a46943a223b06e:

  Fio 3.12 (2018-11-02 12:41:50 -0600)

----------------------------------------------------------------
Jeff Furlong (1):
      Fix Windows CPU count

Jens Axboe (1):
      Fio 3.12

 FIO-VERSION-GEN   | 2 +-
 os/os-windows-7.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 17b215d..ea5be1a 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.11
+DEF_VER=fio-3.12
 
 LF='
 '
diff --git a/os/os-windows-7.h b/os/os-windows-7.h
index f5ddb8e..0a6eaa3 100644
--- a/os/os-windows-7.h
+++ b/os/os-windows-7.h
@@ -10,7 +10,7 @@ typedef struct {
 /* Return all processors regardless of processor group */
 static inline unsigned int cpus_online(void)
 {
-	return GetMaximumProcessorCount(ALL_PROCESSOR_GROUPS);
+	return GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
 }
 
 static inline void print_mask(os_cpu_mask_t *cpumask)
@@ -104,7 +104,7 @@ static inline int mask_to_group_mask(os_cpu_mask_t *cpumask, int *processor_grou
 	cpus_offset = 0;
 	group_size = 0;
 	while (!found && group < online_groups) {
-		group_size = GetMaximumProcessorCount(group);
+		group_size = GetActiveProcessorCount(group);
 		dprint(FD_PROCESS, "group=%d group_start=%d group_size=%u search_cpu=%d\n",
 		       group, cpus_offset, group_size, search_cpu);
 		if (cpus_offset + group_size > search_cpu)
@@ -271,7 +271,7 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 	dprint(FD_PROCESS, "current_groups=%d group_count=%d\n",
 	       current_groups[0], group_count);
 	while (true) {
-		group_size = GetMaximumProcessorCount(group);
+		group_size = GetActiveProcessorCount(group);
 		if (group_size == 0) {
 			log_err("fio_getaffinity: error retrieving size of "
 				"processor group %d\n", group);

