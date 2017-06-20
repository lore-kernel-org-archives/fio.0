Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51820 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdFTMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Jun 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dNHpD-0003Th-M3
        for fio@vger.kernel.org; Tue, 20 Jun 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170620120001.AC73C2C016D@kernel.dk>
Date: Tue, 20 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 594f7abb0c3e5ea4174b1d450959305f827cbdfd:

  Merge branch 'dev/doc/pkg' of https://github.com/bobsaintcool/fio (2017-06-18 10:32:11 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b2fcbe01bdac01bc5d7f8ddea94f264b9f8c2003:

  Ensure that thread_stat alignment is correct (2017-06-19 16:41:51 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Update write_hint mechanism to latest API

Omri Mor (1):
      Ensure that thread_stat alignment is correct

 cconv.c          |  2 ++
 engines/sync.c   | 26 --------------------------
 fio.h            |  2 +-
 ioengines.c      | 10 +++++-----
 options.c        | 46 ++++++++++++++++++++++++++++------------------
 os/os-linux.h    | 18 +++++++++++++++---
 server.h         |  2 +-
 thread_options.h |  3 +++
 8 files changed, 55 insertions(+), 54 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index bf4c517..b8d9ddc 100644
--- a/cconv.c
+++ b/cconv.c
@@ -156,6 +156,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->end_fsync = le32_to_cpu(top->end_fsync);
 	o->pre_read = le32_to_cpu(top->pre_read);
 	o->sync_io = le32_to_cpu(top->sync_io);
+	o->write_hint = le32_to_cpu(top->write_hint);
 	o->verify = le32_to_cpu(top->verify);
 	o->do_verify = le32_to_cpu(top->do_verify);
 	o->verifysort = le32_to_cpu(top->verifysort);
@@ -365,6 +366,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->end_fsync = cpu_to_le32(o->end_fsync);
 	top->pre_read = cpu_to_le32(o->pre_read);
 	top->sync_io = cpu_to_le32(o->sync_io);
+	top->write_hint = cpu_to_le32(o->write_hint);
 	top->verify = cpu_to_le32(o->verify);
 	top->do_verify = cpu_to_le32(o->do_verify);
 	top->verifysort = cpu_to_le32(o->verifysort);
diff --git a/engines/sync.c b/engines/sync.c
index 69d5e21..e76bbbb 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -36,7 +36,6 @@ struct syncio_data {
 struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
-	unsigned int stream;
 };
 
 static struct fio_option options[] = {
@@ -50,29 +49,6 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
-		.name	= "stream",
-		.lname	= "Stream ID",
-		.type	= FIO_OPT_STR,
-		.off1	= offsetof(struct psyncv2_options, stream),
-		.help	= "Set expected write life time",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_INVALID,
-		.posval = {
-			  { .ival = "short",
-			    .oval = RWF_WRITE_LIFE_SHORT,
-			  },
-			  { .ival = "medium",
-			    .oval = RWF_WRITE_LIFE_MEDIUM,
-			  },
-			  { .ival = "long",
-			    .oval = RWF_WRITE_LIFE_LONG,
-			  },
-			  { .ival = "extreme",
-			    .oval = RWF_WRITE_LIFE_EXTREME,
-			  },
-		},
-	},
-	{
 		.name	= NULL,
 	},
 };
@@ -158,8 +134,6 @@ static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 
 	if (o->hipri)
 		flags |= RWF_HIPRI;
-	if (o->stream)
-		flags |= o->stream;
 
 	iov->iov_base = io_u->xfer_buf;
 	iov->iov_len = io_u->xfer_buflen;
diff --git a/fio.h b/fio.h
index 963cf03..6c06a0c 100644
--- a/fio.h
+++ b/fio.h
@@ -149,7 +149,7 @@ struct thread_data {
 	unsigned int thread_number;
 	unsigned int subjob_number;
 	unsigned int groupid;
-	struct thread_stat ts __attribute__ ((aligned));
+	struct thread_stat ts __attribute__ ((aligned(8)));
 
 	int client_type;
 
diff --git a/ioengines.c b/ioengines.c
index c90a2ca..2d55065 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -472,13 +472,13 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 			goto err;
 		}
 	}
-#ifdef FIO_HAVE_STREAMID
-	if (td->o.fadvise_stream &&
+#ifdef FIO_HAVE_WRITE_HINT
+	if (fio_option_is_set(&td->o, write_hint) &&
 	    (f->filetype == FIO_TYPE_BLOCK || f->filetype == FIO_TYPE_FILE)) {
-		off_t stream = td->o.fadvise_stream;
+		uint64_t hint = td->o.write_hint;
 
-		if (posix_fadvise(f->fd, stream, f->io_size, POSIX_FADV_STREAMID) < 0) {
-			td_verror(td, errno, "fadvise streamid");
+		if (fcntl(f->fd, F_SET_RW_HINT, &hint) < 0) {
+			td_verror(td, errno, "fcntl write hint");
 			goto err;
 		}
 	}
diff --git a/options.c b/options.c
index 6d799bf..a8fdde4 100644
--- a/options.c
+++ b/options.c
@@ -2355,24 +2355,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
-#ifdef FIO_HAVE_STREAMID
-	{
-		.name	= "fadvise_stream",
-		.lname	= "Fadvise stream",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct thread_options, fadvise_stream),
-		.help	= "Use fadvise() to set stream ID",
-		.category = FIO_OPT_C_FILE,
-		.group	= FIO_OPT_G_INVALID,
-	},
-#else
-	{
-		.name	= "fadvise_stream",
-		.lname	= "Fadvise stream",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support fadvise stream ID",
-	},
-#endif
 	{
 		.name	= "fsync",
 		.lname	= "Fsync",
@@ -3434,6 +3416,34 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#ifdef FIO_HAVE_WRITE_HINT
+	{
+		.name	= "write_hint",
+		.lname	= "Write hint",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, write_hint),
+		.help	= "Set expected write life time",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+		.posval = {
+			  { .ival = "none",
+			    .oval = RWH_WRITE_LIFE_NONE,
+			  },
+			  { .ival = "short",
+			    .oval = RWH_WRITE_LIFE_SHORT,
+			  },
+			  { .ival = "medium",
+			    .oval = RWH_WRITE_LIFE_MEDIUM,
+			  },
+			  { .ival = "long",
+			    .oval = RWH_WRITE_LIFE_LONG,
+			  },
+			  { .ival = "extreme",
+			    .oval = RWH_WRITE_LIFE_EXTREME,
+			  },
+		},
+	},
+#endif
 	{
 		.name	= "create_serialize",
 		.lname	= "Create serialize",
diff --git a/os/os-linux.h b/os/os-linux.h
index 09e7413..3e7a2fc 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -303,11 +303,23 @@ static inline int fio_set_sched_idle(void)
 }
 #endif
 
-#ifndef POSIX_FADV_STREAMID
-#define POSIX_FADV_STREAMID	8
+#ifndef F_GET_RW_HINT
+#ifndef F_LINUX_SPECIFIC_BASE
+#define F_LINUX_SPECIFIC_BASE	1024
+#endif
+#define F_GET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 11)
+#define F_SET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 12)
+#endif
+
+#ifndef RWH_WRITE_LIFE_NONE
+#define RWH_WRITE_LIFE_NONE	0
+#define RWH_WRITE_LIFE_SHORT	1
+#define RWH_WRITE_LIFE_MEDIUM	2
+#define RWH_WRITE_LIFE_LONG	3
+#define RWH_WRITE_LIFE_EXTREME	4
 #endif
 
-#define FIO_HAVE_STREAMID
+#define FIO_HAVE_WRITE_HINT
 
 #ifndef RWF_HIPRI
 #define RWF_HIPRI	0x00000001
diff --git a/server.h b/server.h
index fff6804..f002f3b 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 62,
+	FIO_SERVER_VER			= 63,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 493e92e..72d86cf 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -102,6 +102,7 @@ struct thread_options {
 	unsigned int end_fsync;
 	unsigned int pre_read;
 	unsigned int sync_io;
+	unsigned int write_hint;
 	unsigned int verify;
 	unsigned int do_verify;
 	unsigned int verifysort;
@@ -376,6 +377,7 @@ struct thread_options_pack {
 	uint32_t end_fsync;
 	uint32_t pre_read;
 	uint32_t sync_io;
+	uint32_t write_hint;
 	uint32_t verify;
 	uint32_t do_verify;
 	uint32_t verifysort;
@@ -417,6 +419,7 @@ struct thread_options_pack {
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
+	uint32_t pad;
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
