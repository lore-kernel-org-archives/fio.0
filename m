Return-Path: <dpf@google.com>
From: peter chang <dpf@google.com>
Subject: [PATCH] fix memory allocation in the cases we may need to align
Date: Wed, 24 Apr 2013 14:55:45 -0700
Message-Id: <1366840545-11768-1-git-send-email-dpf@google.com>
To: axboe@kernel.dk
Cc: gwendal@google.com, fio@vger.kernel.org, peter chang <dpf@google.com>
List-ID: <fio@vger.kernel.org>

when using the sg backend we crash w/ a SEGV in fio_sgio_getevents()
because of memory corruption from the IO. when we allocate the td's
backing store there's a possible post-allocation adjustment to page
align the buffers. however, the extra memory that this alignment may
need is not taken into account when allocating the buffer.

Tested:
  - the problematic fio file looks like
  fdha347:~# cat foo.fio
  [global]
  bs=64k
  thread
  rw=read
  size=100g
  time_based=1
  runtime=60
  iodepth=1

  [sdc]
  ioengine=sg
  filename=/dev/sg2
  numjobs=1

Signed-off-by: peter chang <dpf@google.com>
---
 backend.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/backend.c b/backend.c
index 1c4484b..f48b43d 100644
--- a/backend.c
+++ b/backend.c
@@ -910,6 +910,15 @@ static int init_io_u(struct thread_data *td)
 	if ((td->io_ops->flags & FIO_NOIO) || !(td_read(td) || td_write(td)))
 		data_xfer = 0;
 
+	/*
+	 * if we may later need to do address alignment, then add any
+	 * possible adjustment here so that we don't cause a buffer
+	 * overflow later. this adjustment may be too much if we get
+	 * lucky and the allocator gives us an aligned address.
+	 */
+	if (td->o.odirect || td->o.mem_align || (td->io_ops->flags & FIO_RAWIO))
+		td->orig_buffer_size += page_mask + td->o.mem_align;
+
 	if (td->o.mem_type == MEM_SHMHUGE || td->o.mem_type == MEM_MMAPHUGE) {
 		unsigned long bs;
 
-- 
1.8.2.1


