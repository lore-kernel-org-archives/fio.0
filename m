Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:17067 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965300AbeAJPuF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Jan 2018 10:50:05 -0500
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 4084961DC0
        for <fio@vger.kernel.org>; Wed, 10 Jan 2018 15:50:05 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 84C207F
        for <fio@vger.kernel.org>; Wed, 10 Jan 2018 15:50:04 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2] ioengines: don't call munmap unless size boundary is exceeded
Date: Wed, 10 Jan 2018 09:50:01 -0600
Message-Id: <20180110155001.16037-1-elliott@hpe.com>
In-Reply-To: <20180110005517.14708-1-elliott@hpe.com>
References: <20180110005517.14708-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

In ioengines using mmap() and munmap(), don't call munmap() when doing an
IO that accesses the last byte of a file. This affects the dev-dax,
libpmem, and mmap ioengines.

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
Changes in v2: applied same change to dev-dax.c which has the same pattern

 engines/dev-dax.c | 2 +-
 engines/libpmem.c | 2 +-
 engines/mmap.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index b1f91a40..caae1e09 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -157,7 +157,7 @@ static int fio_devdax_prep(struct thread_data *td, struct io_u *io_u)
 	 * It fits within existing mapping, use it
 	 */
 	if (io_u->offset >= fdd->devdax_off &&
-	    io_u->offset + io_u->buflen < fdd->devdax_off + fdd->devdax_sz)
+	    io_u->offset + io_u->buflen <= fdd->devdax_off + fdd->devdax_sz)
 		goto done;
 
 	/*
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

