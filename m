Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37412350A2C
	for <fio@vger.kernel.org>; Wed, 28 Jan 2026 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769605212; cv=none; b=t3ddxh6SrFXdb7Rq+4Ay+pc0W8aWfN8wDAOoieoJAey+BONeVmq22FqTFq/13SIaZP4m0sgfAQfiwvGro4wtbvLO1Dag5OXc3Q/eQe9lh/OOB2G+2/Zr9TNsujefFBhXVn5r4/3a6Xk0m1fWB2Y96CnZ53muB2Ay6JBVyxnfQPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769605212; c=relaxed/simple;
	bh=fMTJafaEhqgBt+HXUZO40R9qYZad73/5GPCMv4W6xfA=;
	h=Subject:From:To:Date:Message-Id; b=lDx/H2t1wENJXJcRg495TNsX6oeq7XiP7osuY2z71RgMcBWOJpo7EBmA181qNxmcnt5c8s6PzHzPM4BCcAhKqXtWMHlpHG7mFx7l5peXfoLAZ2Hrg1Obr4HYho6TStjYG1a1fLLMq3Tf/CecNrFYMIJ1fttTOewAKyLa2qmcDTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esENohPN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esENohPN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=HaQEPXClWoyeSODBx2rtJRc2PdkdlxjCgYDMUYof0rU=; b=esENohPN0PJAyLMHsbQGcwNxuM
	0t6vpGx2xgrInIsNcT1tGzK+exWGcvxdYXzNRTbsDSls8+wNLb4BKTKq9Q4xvdqqA+zjIuv2R7tjz
	QtbkPyMC+oipwzcKm+OI4+V4Uk58YMqo4nNUq07qhHPeFOVmvmkUEbJoL5Fm6Y3nfAKsXO4ffW8Nh
	yLYBB8yZhyEL1A9Eh3Cf63aI/rMDPSXeKxHUMXY+te7Q9+5MQaqv9mldX/IC3rjZ0bZKCD7tux8Ae
	1q13KrmFfafniKSDZEjHWvmFPtyjzTHHru7rhsRusPeyQ0kHNfBfbVfHJj73PdTTHmL3zbRTIokXj
	4MkX8CXg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vl59S-00000009371-2UZ8
	for fio@vger.kernel.org;
	Wed, 28 Jan 2026 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 80BE31BC0192; Wed, 28 Jan 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 28 Jan 2026 06:00:01 -0700
Message-Id: <20260128130001.80BE31BC0192@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e2e90ae52be17877d61bb58cf50e9781810d3d49:

  Merge branch 'issue_1499' of https://github.com/gautammenghani/fio (2026-01-23 12:55:48 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2d953029b289b778e18c9418f7d596bd12232215:

  Merge branch 'job-process-comm' of https://github.com/robertbaldyga/fio (2026-01-28 05:22:30 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      engines/io_uring: don't flag iowait for GET_EVENTS if feasible
      Merge branch 'job-process-comm' of https://github.com/robertbaldyga/fio

Robert Baldyga (1):
      Add option to specify job process comm

 HOWTO.rst           |  5 +++++
 backend.c           |  9 +++++++++
 cconv.c             |  3 +++
 configure           |  3 +++
 engines/io_uring.c  |  9 ++++++---
 fio.1               |  4 ++++
 options.c           | 11 +++++++++++
 os/linux/io_uring.h |  2 ++
 server.h            |  2 +-
 thread_options.h    |  2 ++
 10 files changed, 46 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index d566c18e..fcb8a914 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3744,6 +3744,11 @@ Threads, processes and job synchronization
 	(meaning no forward references). Second, if a job is being referenced as a
 	waitee, it must have a unique name (no duplicate waitees).
 
+.. option:: comm=str
+
+	Set the job process comm to the specified string. See man :manpage:`prctrl(2)`.
+	Note: This option is currently supported only on Linux.
+
 .. option:: nice=int
 
 	Run the job with the given nice value. See man :manpage:`nice(2)`.
diff --git a/backend.c b/backend.c
index 7eb5ca2b..3a000464 100644
--- a/backend.c
+++ b/backend.c
@@ -31,6 +31,11 @@
 #include <math.h>
 #include <pthread.h>
 
+#ifdef CONFIG_LINUX
+#include <linux/prctl.h>
+#include <sys/prctl.h>
+#endif
+
 #include "fio.h"
 #include "smalloc.h"
 #include "verify.h"
@@ -1758,6 +1763,10 @@ static void *thread_main(void *data)
 
 	fio_local_clock_init();
 
+#ifdef CONFIG_LINUX
+	prctl(PR_SET_NAME, o->comm);
+#endif
+
 	dprint(FD_PROCESS, "jobs pid=%d started\n", (int) td->pid);
 
 	if (is_backend)
diff --git a/cconv.c b/cconv.c
index 0c4a3f2d..3d7b3d14 100644
--- a/cconv.c
+++ b/cconv.c
@@ -34,6 +34,7 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	free(o->opendir);
 	free(o->ioengine);
 	free(o->mmapfile);
+	free(o->comm);
 	free(o->read_iolog_file);
 	free(o->write_iolog_file);
 	free(o->merge_blktrace_file);
@@ -81,6 +82,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->opendir, top->opendir);
 	string_to_cpu(&o->ioengine, top->ioengine);
 	string_to_cpu(&o->mmapfile, top->mmapfile);
+	string_to_cpu(&o->comm, top->comm);
 	string_to_cpu(&o->read_iolog_file, top->read_iolog_file);
 	string_to_cpu(&o->write_iolog_file, top->write_iolog_file);
 	string_to_cpu(&o->merge_blktrace_file, top->merge_blktrace_file);
@@ -396,6 +398,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->opendir, o->opendir);
 	string_to_net(top->ioengine, o->ioengine);
 	string_to_net(top->mmapfile, o->mmapfile);
+	string_to_net(top->comm, o->comm);
 	string_to_net(top->read_iolog_file, o->read_iolog_file);
 	string_to_net(top->write_iolog_file, o->write_iolog_file);
 	string_to_net(top->merge_blktrace_file, o->merge_blktrace_file);
diff --git a/configure b/configure
index dca87255..9927976e 100755
--- a/configure
+++ b/configure
@@ -3075,6 +3075,9 @@ if test "$bigendian" = "yes" ; then
 else
   output_sym "CONFIG_LITTLE_ENDIAN"
 fi
+if test "$targetos" = "Linux" ; then
+  output_sym "CONFIG_LINUX"
+fi
 if test "$zlib" = "yes" ; then
   output_sym "CONFIG_ZLIB"
 fi
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5c416bc5..0ea3aba1 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -194,6 +194,8 @@ struct ioring_options {
 	enum uring_cmd_type cmd_type;
 };
 
+static unsigned int enter_flags = IORING_ENTER_GETEVENTS;
+
 static const int ddir_to_op[2][2] = {
 	{ IORING_OP_READV, IORING_OP_READ },
 	{ IORING_OP_WRITEV, IORING_OP_WRITE }
@@ -825,8 +827,7 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 		}
 
 		if (!o->sqpoll_thread) {
-			r = io_uring_enter(ld, 0, actual_min,
-						IORING_ENTER_GETEVENTS);
+			r = io_uring_enter(ld, 0, actual_min, enter_flags);
 			if (r < 0) {
 				if (errno == EAGAIN || errno == EINTR)
 					continue;
@@ -979,7 +980,7 @@ static int fio_ioring_commit(struct thread_data *td)
 		unsigned start = *ld->sq_ring.head;
 		long nr = ld->queued;
 
-		ret = io_uring_enter(ld, nr, 0, IORING_ENTER_GETEVENTS);
+		ret = io_uring_enter(ld, nr, 0, enter_flags);
 		if (ret > 0) {
 			fio_ioring_queued(td, start, ret);
 			io_u_mark_submit(td, ret);
@@ -1182,6 +1183,8 @@ retry:
 		return ret;
 	}
 
+	if (p.features & IORING_FEAT_NO_IOWAIT)
+		enter_flags |= IORING_ENTER_NO_IOWAIT;
 	ld->ring_fd = ret;
 
 	fio_ioring_probe(td);
diff --git a/fio.1 b/fio.1
index 4ecfc658..014916ea 100644
--- a/fio.1
+++ b/fio.1
@@ -3454,6 +3454,10 @@ limitations. First, the waitee must be defined prior to the waiter job
 (meaning no forward references). Second, if a job is being referenced as a
 waitee, it must have a unique name (no duplicate waitees).
 .TP
+.BI comm \fR=\fPstr
+Set the job process comm to the specified string. See man \fBprctrl\fR\|(2).
+Note: This option is currently supported only on Linux.
+.TP
 .BI nice \fR=\fPint
 Run the job with the given nice value. See man \fBnice\fR\|(2).
 .\" ignore blank line here from HOWTO as it looks normal without it
diff --git a/options.c b/options.c
index f526f5eb..fe22df01 100644
--- a/options.c
+++ b/options.c
@@ -4034,6 +4034,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RWMIX,
 	},
+#ifdef CONFIG_LINUX
+	{
+		.name	= "comm",
+		.lname	= "Job process comm",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct thread_options, comm),
+		.help	= "Process comm of this job",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_DESC,
+	},
+#endif
 	{
 		.name	= "nice",
 		.lname	= "Nice",
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 10cb3c4c..cadcadae 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -374,6 +374,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAIT		(1U << 2)
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
+#define IORING_ENTER_NO_IOWAIT		(1U << 7)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -406,6 +407,7 @@ struct io_uring_params {
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
+#define IORING_FEAT_NO_IOWAIT		(1U << 17)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/server.h b/server.h
index 09e6663e..a1e71a44 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 116,
+	FIO_SERVER_VER			= 117,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index b4dd8d7a..4a52f981 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -252,6 +252,7 @@ struct thread_options {
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[DDIR_RWDIR_CNT];
+	char *comm;
 	unsigned int nice;
 	unsigned int ioprio;
 	unsigned int ioprio_class;
@@ -585,6 +586,7 @@ struct thread_options_pack {
 	uint32_t iolog;
 	uint32_t rwmixcycle;
 	uint32_t rwmix[DDIR_RWDIR_CNT];
+	uint8_t comm[FIO_TOP_STR_MAX];
 	uint32_t nice;
 	uint32_t ioprio;
 	uint32_t ioprio_class;
