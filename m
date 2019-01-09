Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35336 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbfAINAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Jan 2019 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghDSq-0000eB-Ct
        for fio@vger.kernel.org; Wed, 09 Jan 2019 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190109130002.307EF2C0118@kernel.dk>
Date: Wed,  9 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6e70fd303855575c99c520e8c46b7d85c9f21dc8:

  io_uring.h should include <linux/fs.h> (2019-01-08 05:43:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b08e7d6b18b4a38f61800e7553cd5e5d282da4a8:

  engines/devdax: Make detection of device-dax instances more robust (2019-01-08 12:47:37 -0700)

----------------------------------------------------------------
Dan Williams (1):
      engines/devdax: Make detection of device-dax instances more robust

Jens Axboe (4):
      io_uring: use kernel header directly
      configure: add __kernel_rwf_t check
      engines/io_uring: ensure to use the right opcode for fixed buffers
      t/io_uring: ensure to use the right opcode for fixed buffers

 configure          | 20 ++++++++++++++
 engines/dev-dax.c  |  5 ++--
 engines/io_uring.c | 47 +++++++++++++++++---------------
 lib/types.h        |  4 +++
 os/io_uring.h      | 78 ++++++++++++++++++++++++++++++++----------------------
 t/io_uring.c       | 37 ++++++++++++--------------
 6 files changed, 115 insertions(+), 76 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 1f4e50b1..c4fffd99 100755
--- a/configure
+++ b/configure
@@ -2295,6 +2295,23 @@ if compile_prog "" "-lcunit" "CUnit"; then
 fi
 print_config "CUnit" "$cunit"
 
+##########################################
+# check for __kernel_rwf_t
+__kernel_rwf_t="no"
+cat > $TMPC << EOF
+#include <linux/fs.h>
+int main(int argc, char **argv)
+{
+  __kernel_rwf_t x;
+  x = 0;
+  return x;
+}
+EOF
+if compile_prog "" "" "__kernel_rwf_t"; then
+  __kernel_rwf_t="yes"
+fi
+print_config "__kernel_rwf_t" "$__kernel_rwf_t"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2563,6 +2580,9 @@ fi
 if test "$cunit" = "yes" ; then
   output_sym "CONFIG_HAVE_CUNIT"
 fi
+if test "$__kernel_rwf_t" = "yes"; then
+  output_sym "CONFIG_HAVE_KERNEL_RWF_T"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 0660bba5..422ea634 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -259,7 +259,7 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	char spath[PATH_MAX];
 	char npath[PATH_MAX];
-	char *rpath;
+	char *rpath, *basename;
 	FILE *sfile;
 	uint64_t size;
 	struct stat st;
@@ -289,7 +289,8 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 	}
 
 	/* check if DAX device */
-	if (strcmp("/sys/class/dax", rpath)) {
+	basename = strrchr(rpath, '/');
+	if (!basename || strcmp("dax", basename+1)) {
 		log_err("%s: %s not a DAX device!\n",
 			td->o.name, f->file_name);
 	}
diff --git a/engines/io_uring.c b/engines/io_uring.c
index ebca08c8..55f48eda 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -20,28 +20,23 @@
 
 #ifdef ARCH_HAVE_IOURING
 
-typedef uint64_t u64;
-typedef uint32_t u32;
-typedef int32_t s32;
-typedef uint16_t u16;
-typedef uint8_t u8;
-
+#include "../lib/types.h"
 #include "../os/io_uring.h"
 
 struct io_sq_ring {
-	u32 *head;
-	u32 *tail;
-	u32 *ring_mask;
-	u32 *ring_entries;
-	u32 *flags;
-	u32 *array;
+	unsigned *head;
+	unsigned *tail;
+	unsigned *ring_mask;
+	unsigned *ring_entries;
+	unsigned *flags;
+	unsigned *array;
 };
 
 struct io_cq_ring {
-	u32 *head;
-	u32 *tail;
-	u32 *ring_mask;
-	u32 *ring_entries;
+	unsigned *head;
+	unsigned *tail;
+	unsigned *ring_mask;
+	unsigned *ring_entries;
 	struct io_uring_event *events;
 };
 
@@ -154,6 +149,7 @@ static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct fio_file *f = io_u->file;
 	struct io_uring_iocb *iocb;
 
@@ -163,10 +159,17 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	iocb->ioprio = 0;
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
-		if (io_u->ddir == DDIR_READ)
-			iocb->opcode = IORING_OP_READ;
-		else
-			iocb->opcode = IORING_OP_WRITE;
+		if (io_u->ddir == DDIR_READ) {
+			if (o->fixedbufs)
+				iocb->opcode = IORING_OP_READ_FIXED;
+			else
+				iocb->opcode = IORING_OP_READ;
+		} else {
+			if (o->fixedbufs)
+				iocb->opcode = IORING_OP_WRITE_FIXED;
+			else
+				iocb->opcode = IORING_OP_WRITE;
+		}
 		iocb->off = io_u->offset;
 		iocb->addr = io_u->xfer_buf;
 		iocb->len = io_u->xfer_buflen;
@@ -211,7 +214,7 @@ static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct io_cq_ring *ring = &ld->cq_ring;
-	u32 head, reaped = 0;
+	unsigned head, reaped = 0;
 
 	head = *ring->head;
 	do {
@@ -401,7 +404,7 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 	struct io_cq_ring *cring = &ld->cq_ring;
 	void *ptr;
 
-	ld->mmap[0].len = p->sq_off.array + p->sq_entries * sizeof(u32);
+	ld->mmap[0].len = p->sq_off.array + p->sq_entries * sizeof(__u32);
 	ptr = mmap(0, ld->mmap[0].len, PROT_READ | PROT_WRITE,
 			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 			IORING_OFF_SQ_RING);
diff --git a/lib/types.h b/lib/types.h
index 236bf8a3..d92b064c 100644
--- a/lib/types.h
+++ b/lib/types.h
@@ -13,4 +13,8 @@ typedef int bool;
 #include <stdbool.h> /* IWYU pragma: export */
 #endif
 
+#if !defined(CONFIG_HAVE_KERNEL_RWF_T)
+typedef int __kernel_rwf_t;
+#endif
+
 #endif
diff --git a/os/io_uring.h b/os/io_uring.h
index 8dda7951..7dd21126 100644
--- a/os/io_uring.h
+++ b/os/io_uring.h
@@ -1,25 +1,33 @@
-#ifndef IO_URING_H
-#define IO_URING_H
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Header file for the io_uring interface.
+ *
+ * Copyright (C) 2019 Jens Axboe
+ * Copyright (C) 2019 Christoph Hellwig
+ */
+#ifndef LINUX_IO_URING_H
+#define LINUX_IO_URING_H
 
 #include <linux/fs.h>
+#include <linux/types.h>
 
 /*
  * IO submission data structure
  */
 struct io_uring_iocb {
-	u8	opcode;
-	u8	flags;
-	u16	ioprio;
-	s32	fd;
-	u64	off;
+	__u8	opcode;
+	__u8	flags;
+	__u16	ioprio;
+	__s32	fd;
+	__u64	off;
 	union {
 		void	*addr;
-		u64	__pad;
+		__u64	__pad;
 	};
-	u32	len;
+	__u32	len;
 	union {
 		__kernel_rwf_t	rw_flags;
-		u32		__resv;
+		__u32		__resv;
 	};
 };
 
@@ -44,10 +52,13 @@ struct io_uring_iocb {
  */
 struct io_uring_event {
 	__u64	index;		/* what iocb this event came from */
-	s32	res;		/* result code for this event */
-	u32	flags;
+	__s32	res;		/* result code for this event */
+	__u32	flags;
 };
 
+/*
+ * io_uring_event->flags
+ */
 #define IOEV_FLAG_CACHEHIT	(1 << 0)	/* IO did not hit media */
 
 /*
@@ -61,39 +72,42 @@ struct io_uring_event {
  * Filled with the offset for mmap(2)
  */
 struct io_sqring_offsets {
-	u32 head;
-	u32 tail;
-	u32 ring_mask;
-	u32 ring_entries;
-	u32 flags;
-	u32 dropped;
-	u32 array;
-	u32 resv[3];
+	__u32 head;
+	__u32 tail;
+	__u32 ring_mask;
+	__u32 ring_entries;
+	__u32 flags;
+	__u32 dropped;
+	__u32 array;
+	__u32 resv[3];
 };
 
 #define IORING_SQ_NEED_WAKEUP	(1 << 0) /* needs io_uring_enter wakeup */
 
 struct io_cqring_offsets {
-	u32 head;
-	u32 tail;
-	u32 ring_mask;
-	u32 ring_entries;
-	u32 overflow;
-	u32 events;
-	u32 resv[4];
+	__u32 head;
+	__u32 tail;
+	__u32 ring_mask;
+	__u32 ring_entries;
+	__u32 overflow;
+	__u32 events;
+	__u32 resv[4];
 };
 
+/*
+ * io_uring_enter(2) flags
+ */
 #define IORING_ENTER_GETEVENTS	(1 << 0)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
  */
 struct io_uring_params {
-	u32 sq_entries;
-	u32 cq_entries;
-	u32 flags;
-	u16 sq_thread_cpu;
-	u16 resv[9];
+	__u32 sq_entries;
+	__u32 cq_entries;
+	__u32 flags;
+	__u16 sq_thread_cpu;
+	__u16 resv[9];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
diff --git a/t/io_uring.c b/t/io_uring.c
index 83d723f9..fb2654a3 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -21,13 +21,7 @@
 #include <sched.h>
 
 #include "../arch/arch.h"
-
-typedef uint64_t u64;
-typedef uint32_t u32;
-typedef int32_t s32;
-typedef uint16_t u16;
-typedef uint8_t u8;
-
+#include "../lib/types.h"
 #include "../os/io_uring.h"
 
 #define barrier()	__asm__ __volatile__("": : :"memory")
@@ -35,18 +29,18 @@ typedef uint8_t u8;
 #define min(a, b)		((a < b) ? (a) : (b))
 
 struct io_sq_ring {
-	u32 *head;
-	u32 *tail;
-	u32 *ring_mask;
-	u32 *ring_entries;
-	u32 *array;
+	unsigned *head;
+	unsigned *tail;
+	unsigned *ring_mask;
+	unsigned *ring_entries;
+	unsigned *array;
 };
 
 struct io_cq_ring {
-	u32 *head;
-	u32 *tail;
-	u32 *ring_mask;
-	u32 *ring_entries;
+	unsigned *head;
+	unsigned *tail;
+	unsigned *ring_mask;
+	unsigned *ring_entries;
 	struct io_uring_event *events;
 };
 
@@ -113,7 +107,10 @@ static void init_io(struct submitter *s, int fd, unsigned index)
 	lrand48_r(&s->rand, &r);
 	offset = (r % (s->max_blocks - 1)) * BS;
 
-	iocb->opcode = IORING_OP_READ;
+	if (fixedbufs)
+		iocb->opcode = IORING_OP_READ_FIXED;
+	else
+		iocb->opcode = IORING_OP_READ;
 	iocb->flags = 0;
 	iocb->ioprio = 0;
 	iocb->fd = fd;
@@ -125,7 +122,7 @@ static void init_io(struct submitter *s, int fd, unsigned index)
 static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 {
 	struct io_sq_ring *ring = &s->sq_ring;
-	u32 index, tail, next_tail, prepped = 0;
+	unsigned index, tail, next_tail, prepped = 0;
 
 	next_tail = tail = *ring->tail;
 	do {
@@ -176,7 +173,7 @@ static int reap_events(struct submitter *s)
 {
 	struct io_cq_ring *ring = &s->cq_ring;
 	struct io_uring_event *ev;
-	u32 head, reaped = 0;
+	unsigned head, reaped = 0;
 
 	head = *ring->head;
 	do {
@@ -345,7 +342,7 @@ static int setup_ring(struct submitter *s)
 	}
 
 	s->ring_fd = fd;
-	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(u32),
+	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_SQ_RING);
 	printf("sq_ring ptr = 0x%p\n", ptr);

