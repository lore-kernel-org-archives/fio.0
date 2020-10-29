Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgJ2MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Oct 2020 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717B8C0613CF
        for <fio@vger.kernel.org>; Thu, 29 Oct 2020 05:00:10 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY6bA-0002NY-7r
        for fio@vger.kernel.org; Thu, 29 Oct 2020 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201029120001.D17061BC017E@kernel.dk>
Date: Thu, 29 Oct 2020 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8bfe330eb42739d503d35d0b7d96f98c5c544204:

  Disallow offload IO mode for engines marked with FIO_NO_OFFLOAD (2020-10-14 20:11:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a0b72421064b5dd7312812509e9babe923063deb:

  Merge branch 'o_dsync' of https://github.com/anarazel/fio (2020-10-28 16:20:43 -0600)

----------------------------------------------------------------
Andres Freund (1):
      extend --sync to allow {sync,dsync,0,1}, to support O_DSYNC

Jens Axboe (1):
      Merge branch 'o_dsync' of https://github.com/anarazel/fio

 HOWTO               | 24 +++++++++++++++++++++---
 engines/glusterfs.c |  3 +--
 engines/ime.c       |  3 +--
 engines/libpmem.c   |  1 +
 filesetup.c         |  3 +--
 fio.1               | 28 +++++++++++++++++++++++++---
 options.c           | 26 ++++++++++++++++++++++----
 7 files changed, 72 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 2d8c7a02..386fd12a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1677,10 +1677,28 @@ Buffers and memory
 	This will be ignored if :option:`pre_read` is also specified for the
 	same job.
 
-.. option:: sync=bool
+.. option:: sync=str
+
+	Whether, and what type, of synchronous I/O to use for writes.  The allowed
+	values are:
+
+		**none**
+			Do not use synchronous IO, the default.
+
+		**0**
+			Same as **none**.
+
+		**sync**
+			Use synchronous file IO. For the majority of I/O engines,
+			this means using O_SYNC.
+
+		**1**
+			Same as **sync**.
+
+		**dsync**
+			Use synchronous data IO. For the majority of I/O engines,
+			this means using O_DSYNC.
 
-	Use synchronous I/O for buffered writes. For the majority of I/O engines,
-	this means using O_SYNC. Default: false.
 
 .. option:: iomem=str, mem=str
 
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index f2b84a2a..fc6fee19 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -271,8 +271,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 
 	if (td->o.odirect)
 		flags |= OS_O_DIRECT;
-	if (td->o.sync_io)
-		flags |= O_SYNC;
+	flags |= td->o.sync_io;
 
 	dprint(FD_FILE, "fio file %s open mode %s td rw %s\n", f->file_name,
 	       flags & O_RDONLY ? "ro" : "rw", td_read(td) ? "read" : "write");
diff --git a/engines/ime.c b/engines/ime.c
index 42984021..440cc29e 100644
--- a/engines/ime.c
+++ b/engines/ime.c
@@ -194,8 +194,7 @@ static int fio_ime_open_file(struct thread_data *td, struct fio_file *f)
 	}
 	if (td->o.odirect)
 		flags |= O_DIRECT;
-	if (td->o.sync_io)
-		flags |= O_SYNC;
+	flags |= td->o.sync_io;
 	if (td->o.create_on_open && td->o.allow_create)
 		flags |= O_CREAT;
 
diff --git a/engines/libpmem.c b/engines/libpmem.c
index a9b3e29b..eefb7767 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -193,6 +193,7 @@ static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
 
 	dprint(FD_IO, "DEBUG fio_libpmem_queue\n");
 	dprint(FD_IO,"td->o.odirect %d td->o.sync_io %d \n",td->o.odirect, td->o.sync_io);
+	/* map both O_SYNC / DSYNC to not using NODRAIN */
 	flags = td->o.sync_io ? 0 : PMEM_F_MEM_NODRAIN;
 	flags |= td->o.odirect ? PMEM_F_MEM_NONTEMPORAL : PMEM_F_MEM_TEMPORAL;
 
diff --git a/filesetup.c b/filesetup.c
index e44f31c7..f4360a6f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -655,8 +655,7 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 		}
 		flags |= OS_O_DIRECT | FIO_O_ATOMIC;
 	}
-	if (td->o.sync_io)
-		flags |= O_SYNC;
+	flags |= td->o.sync_io;
 	if (td->o.create_on_open && td->o.allow_create)
 		flags |= O_CREAT;
 skip_flags:
diff --git a/fio.1 b/fio.1
index a881277c..48119325 100644
--- a/fio.1
+++ b/fio.1
@@ -1462,9 +1462,31 @@ starting I/O if the platform and file type support it. Defaults to true.
 This will be ignored if \fBpre_read\fR is also specified for the
 same job.
 .TP
-.BI sync \fR=\fPbool
-Use synchronous I/O for buffered writes. For the majority of I/O engines,
-this means using O_SYNC. Default: false.
+.BI sync \fR=\fPstr
+Whether, and what type, of synchronous I/O to use for writes.  The allowed
+values are:
+.RS
+.RS
+.TP
+.B none
+Do not use synchronous IO, the default.
+.TP
+.B 0
+Same as \fBnone\fR.
+.TP
+.B sync
+Use synchronous file IO. For the majority of I/O engines,
+this means using O_SYNC.
+.TP
+.B 1
+Same as \fBsync\fR.
+.TP
+.B dsync
+Use synchronous data IO. For the majority of I/O engines,
+this means using O_DSYNC.
+.PD
+.RE
+.RE
 .TP
 .BI iomem \fR=\fPstr "\fR,\fP mem" \fR=\fPstr
 Fio can use various types of memory as the I/O unit buffer. The allowed
diff --git a/options.c b/options.c
index b497d973..1e91b3e9 100644
--- a/options.c
+++ b/options.c
@@ -3733,14 +3733,32 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "sync",
 		.lname	= "Synchronous I/O",
-		.type	= FIO_OPT_BOOL,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, sync_io),
-		.help	= "Use O_SYNC for buffered writes",
-		.def	= "0",
-		.parent = "buffered",
+		.help	= "Use synchronous write IO",
+		.def	= "none",
 		.hide	= 1,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
+		.posval = {
+			  { .ival = "none",
+			    .oval = 0,
+			  },
+			  { .ival = "0",
+			    .oval = 0,
+			  },
+			  { .ival = "sync",
+			    .oval = O_SYNC,
+			  },
+			  { .ival = "1",
+			    .oval = O_SYNC,
+			  },
+#ifdef O_DSYNC
+			  { .ival = "dsync",
+			    .oval = O_DSYNC,
+			  },
+#endif
+		},
 	},
 #ifdef FIO_HAVE_WRITE_HINT
 	{

