Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgJaMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 31 Oct 2020 08:00:08 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E565C0613D5
        for <fio@vger.kernel.org>; Sat, 31 Oct 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYpYC-0000Y6-7b
        for fio@vger.kernel.org; Sat, 31 Oct 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201031120002.4CEED1BC00F9@kernel.dk>
Date: Sat, 31 Oct 2020 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a0b72421064b5dd7312812509e9babe923063deb:

  Merge branch 'o_dsync' of https://github.com/anarazel/fio (2020-10-28 16:20:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8c17a6248bd227a9f3cc3da52bd1cb922dc6cf81:

  t/zbd: Fix test target size of test case #48 (2020-10-30 07:24:59 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      zbd: Avoid excessive zone resets
      t/zbd: Fix test target size of test case #48

 t/zbd/test-zbd-support | 2 +-
 zbd.c                  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 248423bb..acde3b3a 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -913,7 +913,7 @@ test48() {
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
 	opts+=("--io_size=$zone_size" "--iodepth=256" "--thread=1")
-	opts+=("--group_reporting=1")
+	opts+=("--size=$size" "--group_reporting=1")
 	# max_open_zones is already specified
 	opts+=($(job_var_opts_exclude "--max_open_zones"))
     done
diff --git a/zbd.c b/zbd.c
index 905c0c2b..9327816a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -718,6 +718,9 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	uint64_t length = (z+1)->start - offset;
 	int ret = 0;
 
+	if (z->wp == z->start)
+		return 0;
+
 	assert(is_valid_offset(f, offset + length - 1));
 
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,

