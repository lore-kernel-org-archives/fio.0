Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A2A2080F0
	for <fio@vger.kernel.org>; Fri, 21 Feb 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740142813; cv=none; b=W1aneO6MPf98wK6f7favZAojVZ7FdH4++2jHIN0LZY16AXrUiMBlTQkSxUvD7SFFhSJdsXjdfBufJkHTDSqsmvyYQgYO1+kmHWPKqjdOYbKl6TZhgZHIrtVIfrEr7jyH5iTE8jODm0BGDXoByyKTApmTYLF7DjefQZJErE5r+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740142813; c=relaxed/simple;
	bh=Vuyl58vTYxxzpdjK6Lo61qj+kOAh9X0aMj0s9o/xNUw=;
	h=Subject:From:To:Message-Id:Date; b=DpU3npaC1mzdwzyntQ6W1LycBxxhaoAfEwLDbr6is0ro4o8ZIaWhCQdHbO6wlUmWZ+QukqgFUpp3ckCe22xENFmpMi04RFSN+h/k6DHoFfn7yW5DedmrT4A3xlkzjs6DNYcMJG1E72hoe72+PpM4J3XoK0mK/f8FiUnRaZB+HJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dsaB5u/e; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dsaB5u/e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=L5iJ5dvoLLdJaTnJkIMBwHmxV35JEItgaIwcib8a9+s=; b=dsaB5u/e1x2ao+vbvXPBqkNHzP
	iDzGSsMnGtMWGTlZDke0clD8XRImkPDQx8qHHAL6b6vrcLxR/ajb3+czQPyJHrTy0bXxA6pXzS/Bm
	KBMgfdtbhirIw/JYH13pXB3u0Nmp3ZYHv1aJJ9uy4lfnL3wHtxfBKSY9qOl26e4DeqzLWnZGgbPXk
	4pfylKkp4wZYZvezPyROnB7hujOBUNgwwbWh34Qof4dk+6tDcEY+tNO29Ot8Sc6s+YDSEzhngHRVr
	UTsOpl7LQff3rY6Hbw49fR8y4BaGGhQsTZ8kx8wEV/NVdR8DIiExF0DZiB72Ubctk8QtPPPU6jMY2
	7CNkNFHQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tlSdR-0000000Djbt-1Pan
	for fio@vger.kernel.org;
	Fri, 21 Feb 2025 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 536901BC0154; Fri, 21 Feb 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250221130001.536901BC0154@kernel.dk>
Date: Fri, 21 Feb 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a6e474c9e896e4ba1eb40066a03402afb040710a:

  Fio 3.39 (2025-02-18 08:36:57 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 43c67b9f3a8808274bc1e0a3b7b70c56bb8a007f:

  Re-introduce RWF_DONTCACHE (2025-02-20 13:07:41 -0700)

----------------------------------------------------------------
Dan Dedrick (1):
      t/read-to-pipe-async: fix -DNDEBUG support

Jens Axboe (2):
      Merge branch 'fix-DNDEBUG' of https://github.com/dandedrick/fio
      Re-introduce RWF_DONTCACHE

 Makefile                     |  2 +-
 engines/io_uring.c           | 11 ++++++++++-
 engines/sync.c               |  9 ++++++++-
 os/os-linux.h                |  4 ++++
 t/read-to-pipe-async.c       |  1 +
 tools/fiograph/fiograph.conf |  4 ++--
 6 files changed, 26 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 746a27d4..173378fa 100644
--- a/Makefile
+++ b/Makefile
@@ -365,7 +365,7 @@ T_DEDUPE_PROGS = t/fio-dedupe
 T_VS_OBJS = t/verify-state.o t/log.o crc/crc32c.o crc/crc32c-intel.o crc/crc32c-arm64.o t/debug.o
 T_VS_PROGS = t/fio-verify-state
 
-T_PIPE_ASYNC_OBJS = t/read-to-pipe-async.o
+T_PIPE_ASYNC_OBJS = t/read-to-pipe-async.o t/log.o
 T_PIPE_ASYNC_PROGS = t/read-to-pipe-async
 
 T_IOU_RING_OBJS = t/io_uring.o lib/rand.o lib/pattern.o lib/strntol.o
diff --git a/engines/io_uring.c b/engines/io_uring.c
index facc967f..983e32b7 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -114,6 +114,7 @@ struct ioring_options {
 	unsigned int sqpoll_set;
 	unsigned int sqpoll_cpu;
 	unsigned int nonvectored;
+	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
 	unsigned int md_per_io_size;
@@ -271,7 +272,11 @@ static struct fio_option options[] = {
 	{
 		.name	= "uncached",
 		.lname	= "Uncached",
-		.type	= FIO_OPT_SOFT_DEPRECATED,
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, uncached),
+		.help	= "Use RWF_DONTCACHE for buffered read/writes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
 	},
 	{
 		.name	= "nowait",
@@ -432,6 +437,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			}
 		}
 		sqe->rw_flags = 0;
+		if (!td->o.odirect && o->uncached)
+			sqe->rw_flags |= RWF_DONTCACHE;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
 		if (td->o.oatomic && io_u->ddir == DDIR_WRITE)
@@ -513,6 +520,8 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->fd = f->fd;
 	}
 	sqe->rw_flags = 0;
+	if (!td->o.odirect && o->uncached)
+		sqe->rw_flags |= RWF_DONTCACHE;
 	if (o->nowait)
 		sqe->rw_flags |= RWF_NOWAIT;
 
diff --git a/engines/sync.c b/engines/sync.c
index 729d8a71..89466ca5 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -39,6 +39,7 @@ struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int hipri_percentage;
+	unsigned int uncached;
 	unsigned int nowait;
 };
 
@@ -67,7 +68,11 @@ static struct fio_option options[] = {
 	{
 		.name	= "uncached",
 		.lname	= "Uncached",
-		.type	= FIO_OPT_SOFT_DEPRECATED,
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct psyncv2_options, uncached),
+		.help	= "Use RWF_DONTCACHE for buffered read/writes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
 	},
 	{
 		.name	= "nowait",
@@ -167,6 +172,8 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 	if (o->hipri &&
 	    (rand_between(&sd->rand_state, 1, 100) <= o->hipri_percentage))
 		flags |= RWF_HIPRI;
+	if (!td->o.odirect && o->uncached)
+		flags |= RWF_DONTCACHE;
 	if (o->nowait)
 		flags |= RWF_NOWAIT;
 
diff --git a/os/os-linux.h b/os/os-linux.h
index ead8295c..6157e0e0 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -333,6 +333,10 @@ static inline int fio_set_sched_idle(void)
 #define RWF_ATOMIC	0x00000040
 #endif
 
+#ifndef RWF_DONTCACHE
+#define RWF_DONTCACHE	0x00000080
+#endif
+
 #ifndef RWF_WRITE_LIFE_SHIFT
 #define RWF_WRITE_LIFE_SHIFT		4
 #define RWF_WRITE_LIFE_SHORT		(1 << RWF_WRITE_LIFE_SHIFT)
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index de98d032..2abe25d3 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -35,6 +35,7 @@
 #include <assert.h>
 
 #include "../flist.h"
+#include "../log.h"
 
 #include "compiler/compiler.h"
 
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 75712180..74f9752d 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,7 +51,7 @@ specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_ke
 specific_options=ime_psync  ime_psyncv
 
 [ioengine_io_uring]
-specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async atomic
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async atomic uncached
 
 [ioengine_io_uring_cmd]
 specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async  cmd_type  md_per_io_size  pi_act  pi_chk  apptag  apptag_mask
@@ -99,7 +99,7 @@ specific_options=hostname  bindname  port  verb
 specific_options=hipri  readfua  writefua  sg_write_mode  stream_id
 
 [ioengine_pvsync2]
-specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync atomic
+specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync atomic uncached
 
 [ioengine_xnvme]
 specific_options=hipri  sqthread_poll  xnvme_be  xnvme_async  xnvme_sync  xnvme_admin  xnvme_dev_nsid  xnvme_iovec
