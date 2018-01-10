Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t2353.austin.hpe.com ([15.233.44.26]:37012 "EHLO
        g2t2353.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755030AbeAJAzZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Jan 2018 19:55:25 -0500
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2353.austin.hpe.com (Postfix) with ESMTP id 946BB6D
        for <fio@vger.kernel.org>; Wed, 10 Jan 2018 00:55:24 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] mmap, libpmem: don't call munmap unless size boundary is exceeded
Date: Tue,  9 Jan 2018 18:55:17 -0600
Message-Id: <20180110005517.14708-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

In ioengines using mmap() and munmap(), don't call munmap() when doing an
IO that accesses the last byte of a file.

Example:
io       12987 DEBUG fio_libpmem_prep
io       12987  io_u->offset 7516061696 : fdd->libpmem_off 0 : io_u->buflen 131072 : fdd->libpmem_sz 7516192768
io       12987 munmap addr=0x7f5600000000 size=0x1c0000000

That accesses the last 128 KiB of a 7 GiB file, triggering an munmap
because the comparison to 7 GiB fails:
	7516061696 + 131072 < 7516192768

Change < to <= so that doesn't occur unless an overflow really
happens.

In one test in linux, this increases performance from 5 GB/s to 20 GB/s
as fio stops spending time in mmap() page table mapping spinlocks and
instead spends its time in memmove().  The perf top results improve from:
  36.81%  [kernel]             [k] queued_spin_lock_slowpath
  24.26%  libc-2.26.so         [.] __memmove_avx_unaligned_erms
   4.09%  [kernel]             [k] __radix_tree_lookup
   3.85%  [kernel]             [k] find_next_iomem_res
   3.70%  [kernel]             [k] _raw_spin_lock_irq
   3.48%  [kernel]             [k] down_read

to:
  79.76%  libc-2.26.so         [.] __memmove_avx_unaligned_erms
   3.23%  libc-2.26.so         [.] vfprintf
---
 engines/libpmem.c | 2 +-
 engines/mmap.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/libpmem.c b/engines/libpmem.c
index 3f4e44fb..30387845 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -430,7 +430,7 @@ static int fio_libpmem_prep(struct thread_data *td, struct io_u *io_u)
 			io_u->buflen, fdd->libpmem_sz);
 
 	if (io_u->offset >= fdd->libpmem_off &&
-	    (io_u->offset + io_u->buflen <
+	    (io_u->offset + io_u->buflen <=
 	     fdd->libpmem_off + fdd->libpmem_sz))
 		goto done;
 
diff --git a/engines/mmap.c b/engines/mmap.c
index 51606e12..77556588 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -137,7 +137,7 @@ static int fio_mmapio_prep(struct thread_data *td, struct io_u *io_u)
 	 * It fits within existing mapping, use it
 	 */
 	if (io_u->offset >= fmd->mmap_off &&
-	    io_u->offset + io_u->buflen < fmd->mmap_off + fmd->mmap_sz)
+	    io_u->offset + io_u->buflen <= fmd->mmap_off + fmd->mmap_sz)
 		goto done;
 
 	/*
-- 
2.14.3

