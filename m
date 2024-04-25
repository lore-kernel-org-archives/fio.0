Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D2917C91
	for <fio@vger.kernel.org>; Thu, 25 Apr 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046417; cv=none; b=fnhDsvXDr9knqy+ZPIZXwtKMvoKqOmrKqZvg6yxOIATooXid6cs7hquvLRBWPk3qFVGTQXCygQicT/O4f7DrKQH3w8+gVxnWXmPbleErPj37u6ege60Gmq8KRONpQ/nZzldsY+qyL7DuSCAM9OIzxH/t3jsjKAFnoCYxsSK1v84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046417; c=relaxed/simple;
	bh=vUSQ1Qugb5ISOY5k5XcEbT2RvJIJHb7tGtwFpaeUyjw=;
	h=Subject:From:To:Message-Id:Date; b=e+Ui/WGltGPHuncppAyvEGo94j4JkWEXnMQObl44+fad5tHpG1voVq2aYH2nqYaoGWghzQ0icrq7InbGI/7b4LdILzsGCtbpBk7ND03miegt1cYsI12SxA7nmAvH0QgIqs9PxTL8+gGv04mv9eiUpV06LgDNQeb7Gyovn3wXJOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X+PCXg43; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X+PCXg43"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9aRaBwMQ87bYeaz5Vid7MbtzG4QgvH9Ucy96e8Q1twg=; b=X+PCXg43UwEpwN5Ik+7SmGuyTJ
	lIyEJ0iYSI97KsEquYQwvtbS1JQu6oKS7x1T5MDyBpMPd9DMqjtZj5dT0IJoQqSmHWl8IGXgXxnwV
	yYBc7qkuem/kU2ous05xqBe1oBsAephpvDI8EU++LGKG7zkVRLUvkCPnyMkispBdTWGTHkHsd7eaC
	HncAZbOMEvvUYl7BnYe9H1EcXUX6zgZwITODGiYYLvBEK1x7NvjDk1AAP/YBxXwaOxNGIon5c6aPW
	1p1cBzprutRppxHjAozysEsFy+ylOiaOQTXTkXPxqho7ZhUjwehNSjlyUKFBLaao/yJZv+zo8Uw8x
	5nTboXDw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzxlk-00000002xsp-1Ihb
	for fio@vger.kernel.org;
	Thu, 25 Apr 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 654C31BC0128; Thu, 25 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240425120001.654C31BC0128@kernel.dk>
Date: Thu, 25 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit c948ee34afde7eda14adf82512772b03f6fb1d69:

  Merge branch 'master' of https://github.com/celestinechen/fio (2024-04-19 13:51:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 349bbcb2e36658db05d5247ef8cbcb285d58dfbf:

  docs: update for new data placement options (2024-04-24 13:44:09 -0400)

----------------------------------------------------------------
Vincent Fu (9):
      fio: rename fdp.[c,h] to dataplacement.[c,h]
      fio: create over-arching data placement option
      t/nvmept_fdp.py: test script for FDP
      fio: support NVMe streams
      options: reject placement IDs larger than the max
      options: parse placement IDs as unsigned values
      dataplacement: add a debug print for IOs
      t/nvmept_streams: test NVMe streams support
      docs: update for new data placement options

 HOWTO.rst                |  36 ++-
 Makefile                 |   2 +-
 cconv.c                  |  18 +-
 fdp.c => dataplacement.c |  37 ++-
 dataplacement.h          |  37 +++
 engines/xnvme.c          |   2 +-
 fdp.h                    |  29 --
 filesetup.c              |   4 +-
 fio.1                    |  35 ++-
 init.c                   |  10 +-
 io_u.c                   |   4 +-
 ioengines.h              |   2 +-
 options.c                |  62 +++-
 server.h                 |   2 +-
 t/nvmept_fdp.py          | 745 +++++++++++++++++++++++++++++++++++++++++++++++
 t/nvmept_streams.py      | 520 +++++++++++++++++++++++++++++++++
 thread_options.h         |  15 +-
 17 files changed, 1466 insertions(+), 94 deletions(-)
 rename fdp.c => dataplacement.c (69%)
 create mode 100644 dataplacement.h
 delete mode 100644 fdp.h
 create mode 100755 t/nvmept_fdp.py
 create mode 100755 t/nvmept_streams.py

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2f108e36..2f8ef6d4 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2500,7 +2500,24 @@ with the caveat that when used on the command line, they must come after the
 
 	Enable Flexible Data Placement mode for write commands.
 
-.. option:: fdp_pli_select=str : [io_uring_cmd] [xnvme]
+.. option:: dataplacement=str : [io_uring_cmd] [xnvme]
+
+        Specifies the data placement directive type to use for write commands.
+        The following types are supported:
+
+                **none**
+                        Do not use a data placement directive. This is the
+                        default.
+
+                **fdp**
+                        Use Flexible Data Placement directives for write
+                        commands. This is equivalent to specifying
+                        :option:`fdp` =1.
+
+               **streams**
+                        Use Streams directives for write commands.
+
+.. option:: plid_select=str, fdp_pli_select=str : [io_uring_cmd] [xnvme]
 
 	Defines how fio decides which placement ID to use next. The following
 	types are defined:
@@ -2512,16 +2529,17 @@ with the caveat that when used on the command line, they must come after the
 			Round robin over available placement IDs. This is the
 			default.
 
-	The available placement ID index/indices is defined by the option
-	:option:`fdp_pli`.
+	The available placement ID (indices) are defined by the option
+	:option:`plids`.
 
-.. option:: fdp_pli=str : [io_uring_cmd] [xnvme]
+.. option:: plids=str, fdp_pli=str : [io_uring_cmd] [xnvme]
 
-	Select which Placement ID Index/Indicies this job is allowed to use for
-	writes. By default, the job will cycle through all available Placement
-        IDs, so use this to isolate these identifiers to specific jobs. If you
-        want fio to use placement identifier only at indices 0, 2 and 5 specify
-        ``fdp_pli=0,2,5``.
+        Select which Placement IDs (streams) or Placement ID Indices (FDP) this
+        job is allowed to use for writes. For FDP by default, the job will
+        cycle through all available Placement IDs, so use this to isolate these
+        identifiers to specific jobs. If you want fio to use FDP placement
+        identifiers only at indices 0, 2 and 5 specify ``plids=0,2,5``. For
+        streams this should be a comma-separated list of Stream IDs.
 
 .. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
 
diff --git a/Makefile b/Makefile
index cc8164b2..be57e296 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c zbd.c dedupe.c fdp.c
+		steadystate.c zone-dist.c zbd.c dedupe.c dataplacement.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/cconv.c b/cconv.c
index ead47248..16112248 100644
--- a/cconv.c
+++ b/cconv.c
@@ -354,10 +354,11 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 		o->merge_blktrace_iters[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_iters[i].u.i));
 
 	o->fdp = le32_to_cpu(top->fdp);
-	o->fdp_pli_select = le32_to_cpu(top->fdp_pli_select);
-	o->fdp_nrpli = le32_to_cpu(top->fdp_nrpli);
-	for (i = 0; i < o->fdp_nrpli; i++)
-		o->fdp_plis[i] = le32_to_cpu(top->fdp_plis[i]);
+	o->dp_type = le32_to_cpu(top->dp_type);
+	o->dp_id_select = le32_to_cpu(top->dp_id_select);
+	o->dp_nr_ids = le32_to_cpu(top->dp_nr_ids);
+	for (i = 0; i < o->dp_nr_ids; i++)
+		o->dp_ids[i] = le32_to_cpu(top->dp_ids[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -652,10 +653,11 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->merge_blktrace_iters[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_iters[i].u.f));
 
 	top->fdp = cpu_to_le32(o->fdp);
-	top->fdp_pli_select = cpu_to_le32(o->fdp_pli_select);
-	top->fdp_nrpli = cpu_to_le32(o->fdp_nrpli);
-	for (i = 0; i < o->fdp_nrpli; i++)
-		top->fdp_plis[i] = cpu_to_le32(o->fdp_plis[i]);
+	top->dp_type = cpu_to_le32(o->dp_type);
+	top->dp_id_select = cpu_to_le32(o->dp_id_select);
+	top->dp_nr_ids = cpu_to_le32(o->dp_nr_ids);
+	for (i = 0; i < o->dp_nr_ids; i++)
+		top->dp_ids[i] = cpu_to_le32(o->dp_ids[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/fdp.c b/dataplacement.c
similarity index 69%
rename from fdp.c
rename to dataplacement.c
index 49c80d2c..1d5b21ed 100644
--- a/fdp.c
+++ b/dataplacement.c
@@ -13,7 +13,7 @@
 #include "file.h"
 
 #include "pshared.h"
-#include "fdp.h"
+#include "dataplacement.h"
 
 static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
 			struct fio_ruhs_info *ruhs)
@@ -49,6 +49,20 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	if (!ruhs)
 		return -ENOMEM;
 
+	/* set up the data structure used for FDP to work with the supplied stream IDs */
+	if (td->o.dp_type == FIO_DP_STREAMS) {
+		if (!td->o.dp_nr_ids) {
+			log_err("fio: stream IDs must be provided for dataplacement=streams\n");
+			return -EINVAL;
+		}
+		ruhs->nr_ruhs = td->o.dp_nr_ids;
+		for (int i = 0; i < ruhs->nr_ruhs; i++)
+			ruhs->plis[i] = td->o.dp_ids[i];
+
+		f->ruhs_info = ruhs;
+		return 0;
+	}
+
 	ret = fdp_ruh_info(td, f, ruhs);
 	if (ret) {
 		log_info("fio: ruh info failed for %s (%d)\n",
@@ -59,13 +73,13 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	if (ruhs->nr_ruhs > FDP_MAX_RUHS)
 		ruhs->nr_ruhs = FDP_MAX_RUHS;
 
-	if (td->o.fdp_nrpli == 0) {
+	if (td->o.dp_nr_ids == 0) {
 		f->ruhs_info = ruhs;
 		return 0;
 	}
 
-	for (i = 0; i < td->o.fdp_nrpli; i++) {
-		if (td->o.fdp_plis[i] >= ruhs->nr_ruhs) {
+	for (i = 0; i < td->o.dp_nr_ids; i++) {
+		if (td->o.dp_ids[i] >= ruhs->nr_ruhs) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -77,16 +91,16 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	tmp->nr_ruhs = td->o.fdp_nrpli;
-	for (i = 0; i < td->o.fdp_nrpli; i++)
-		tmp->plis[i] = ruhs->plis[td->o.fdp_plis[i]];
+	tmp->nr_ruhs = td->o.dp_nr_ids;
+	for (i = 0; i < td->o.dp_nr_ids; i++)
+		tmp->plis[i] = ruhs->plis[td->o.dp_ids[i]];
 	f->ruhs_info = tmp;
 out:
 	sfree(ruhs);
 	return ret;
 }
 
-int fdp_init(struct thread_data *td)
+int dp_init(struct thread_data *td)
 {
 	struct fio_file *f;
 	int i, ret = 0;
@@ -107,7 +121,7 @@ void fdp_free_ruhs_info(struct fio_file *f)
 	f->ruhs_info = NULL;
 }
 
-void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
+void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_ruhs_info *ruhs = f->ruhs_info;
@@ -119,7 +133,7 @@ void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		return;
 	}
 
-	if (td->o.fdp_pli_select == FIO_FDP_RR) {
+	if (td->o.dp_id_select == FIO_DP_RR) {
 		if (ruhs->pli_loc >= ruhs->nr_ruhs)
 			ruhs->pli_loc = 0;
 
@@ -129,6 +143,7 @@ void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		dspec = ruhs->plis[ruhs->pli_loc];
 	}
 
-	io_u->dtype = FDP_DIR_DTYPE;
+	io_u->dtype = td->o.dp_type == FIO_DP_FDP ? FDP_DIR_DTYPE : STREAMS_DIR_DTYPE;
 	io_u->dspec = dspec;
+	dprint(FD_IO, "dtype set to 0x%x, dspec set to 0x%x\n", io_u->dtype, io_u->dspec);
 }
diff --git a/dataplacement.h b/dataplacement.h
new file mode 100644
index 00000000..b5718c86
--- /dev/null
+++ b/dataplacement.h
@@ -0,0 +1,37 @@
+#ifndef FIO_DATAPLACEMENT_H
+#define FIO_DATAPLACEMENT_H
+
+#include "io_u.h"
+
+#define STREAMS_DIR_DTYPE	1
+#define FDP_DIR_DTYPE		2
+#define FDP_MAX_RUHS		128
+#define FIO_MAX_DP_IDS 		16
+
+/*
+ * How fio chooses what placement identifier to use next. Choice of
+ * uniformly random, or roundrobin.
+ */
+enum {
+	FIO_DP_RANDOM	= 0x1,
+	FIO_DP_RR	= 0x2,
+};
+
+
+enum {
+	FIO_DP_NONE	= 0x0,
+	FIO_DP_FDP	= 0x1,
+	FIO_DP_STREAMS	= 0x2,
+};
+
+struct fio_ruhs_info {
+	uint32_t nr_ruhs;
+	uint32_t pli_loc;
+	uint16_t plis[];
+};
+
+int dp_init(struct thread_data *td);
+void fdp_free_ruhs_info(struct fio_file *f);
+void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
+
+#endif /* FIO_DATAPLACEMENT_H */
diff --git a/engines/xnvme.c b/engines/xnvme.c
index a8137286..6ba4aa46 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -13,7 +13,7 @@
 #include "fio.h"
 #include "verify.h"
 #include "zbd_types.h"
-#include "fdp.h"
+#include "dataplacement.h"
 #include "optgroup.h"
 
 static pthread_mutex_t g_serialize = PTHREAD_MUTEX_INITIALIZER;
diff --git a/fdp.h b/fdp.h
deleted file mode 100644
index accbac38..00000000
--- a/fdp.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef FIO_FDP_H
-#define FIO_FDP_H
-
-#include "io_u.h"
-
-#define FDP_DIR_DTYPE	2
-#define FDP_MAX_RUHS	128
-
-/*
- * How fio chooses what placement identifier to use next. Choice of
- * uniformly random, or roundrobin.
- */
-
-enum {
-	FIO_FDP_RANDOM	= 0x1,
-	FIO_FDP_RR	= 0x2,
-};
-
-struct fio_ruhs_info {
-	uint32_t nr_ruhs;
-	uint32_t pli_loc;
-	uint16_t plis[];
-};
-
-int fdp_init(struct thread_data *td);
-void fdp_free_ruhs_info(struct fio_file *f);
-void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
-
-#endif /* FIO_FDP_H */
diff --git a/filesetup.c b/filesetup.c
index 2d277a64..cb42a852 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1411,8 +1411,8 @@ done:
 
 	td_restore_runstate(td, old_state);
 
-	if (td->o.fdp) {
-		err = fdp_init(td);
+	if (td->o.dp_type != FIO_DP_NONE) {
+		err = dp_init(td);
 		if (err)
 			goto err_out;
 	}
diff --git a/fio.1 b/fio.1
index 5fd3603d..ee812494 100644
--- a/fio.1
+++ b/fio.1
@@ -2264,7 +2264,26 @@ file blocks are fully allocated and the disk request could be issued immediately
 .BI (io_uring_cmd,xnvme)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
-.BI (io_uring_cmd,xnvme)fdp_pli_select \fR=\fPstr
+.BI (io_uring_cmd,xnvme)dataplacement \fR=\fPstr
+Specifies the data placement directive type to use for write commands. The
+following types are supported:
+.RS
+.RS
+.TP
+.B none
+Do not use a data placement directive. This is the default.
+.TP
+.B fdp
+Use Flexible Data placement directives for write commands. This is equivalent
+to specifying \fBfdp\fR=1.
+.TP
+.B streams
+Use Streams directives for write commands.
+.TP
+.RE
+.RE
+.TP
+.BI (io_uring_cmd,xnvme)plid_select=str, fdp_pli_select \fR=\fPstr
 Defines how fio decides which placement ID to use next. The following types
 are defined:
 .RS
@@ -2277,14 +2296,16 @@ Choose a placement ID at random (uniform).
 Round robin over available placement IDs. This is the default.
 .RE
 .P
-The available placement ID index/indices is defined by \fBfdp_pli\fR option.
+The available placement ID (indices) are defined by the \fBplids\fR option.
 .RE
 .TP
-.BI (io_uring_cmd,xnvme)fdp_pli \fR=\fPstr
-Select which Placement ID Index/Indicies this job is allowed to use for writes.
-By default, the job will cycle through all available Placement IDs, so use this
-to isolate these identifiers to specific jobs. If you want fio to use placement
-identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
+.BI (io_uring_cmd,xnvme)plids=str, fdp_pli \fR=\fPstr
+Select which Placement IDs (streams) or Placement ID Indicies (FDP) this job is
+allowed to use for writes.  For FDP by default, the job will cycle through all
+available Placement IDs, so use this to isolate these identifiers to specific
+jobs. If you want fio to use placement identifier only at indices 0, 2 and 5
+specify, you would set `plids=0,2,5`. For streams this should be a
+comma-separated list of Stream IDs.
 .TP
 .BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. Default: 0.
diff --git a/init.c b/init.c
index 7a0b14a3..ff3e9a90 100644
--- a/init.c
+++ b/init.c
@@ -1015,7 +1015,15 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
-
+	if (td->o.fdp) {
+		if (fio_option_is_set(&td->o, dp_type) &&
+			(td->o.dp_type == FIO_DP_STREAMS || td->o.dp_type == FIO_DP_NONE)) {
+			log_err("fio: fdp=1 is not compatible with dataplacement={streams, none}\n");
+			ret |= 1;
+		} else {
+			td->o.dp_type = FIO_DP_FDP;
+		}
+	}
 	return ret;
 }
 
diff --git a/io_u.c b/io_u.c
index a499ff07..a090e121 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1065,8 +1065,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
-	if (td->o.fdp)
-		fdp_fill_dspec_data(td, io_u);
+	if (td->o.dp_type != FIO_DP_NONE)
+		dp_fill_dspec_data(td, io_u);
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
 		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
diff --git a/ioengines.h b/ioengines.h
index 4fe9bb98..d5b0cafe 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -7,7 +7,7 @@
 #include "flist.h"
 #include "io_u.h"
 #include "zbd_types.h"
-#include "fdp.h"
+#include "dataplacement.h"
 
 #define FIO_IOOPS_VERSION	34
 
diff --git a/options.c b/options.c
index de935efc..61ea41cc 100644
--- a/options.c
+++ b/options.c
@@ -270,12 +270,19 @@ static int str_fdp_pli_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_PLIS)
-		td->o.fdp_plis[i++] = strtoll(v, NULL, 0);
+	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_DP_IDS) {
+		unsigned long long id = strtoull(v, NULL, 0);
+		if (id > 0xFFFF) {
+			log_err("Placement IDs cannot exceed 0xFFFF\n");
+			free(p);
+			return 1;
+		}
+		td->o.dp_ids[i++] = id;
+	}
 	free(p);
 
-	qsort(td->o.fdp_plis, i, sizeof(*td->o.fdp_plis), fio_fdp_cmp);
-	td->o.fdp_nrpli = i;
+	qsort(td->o.dp_ids, i, sizeof(*td->o.dp_ids), fio_fdp_cmp);
+	td->o.dp_nr_ids = i;
 
 	return 0;
 }
@@ -3710,32 +3717,59 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group  = FIO_OPT_G_INVALID,
 	},
 	{
-		.name	= "fdp_pli_select",
-		.lname	= "FDP Placement ID select",
+		.name	= "dataplacement",
+		.alias	= "data_placement",
+		.lname	= "Data Placement interface",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, dp_type),
+		.help	= "Data Placement interface to use",
+		.def	= "none",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "none",
+			    .oval = FIO_DP_NONE,
+			    .help = "Do not specify a data placement interface",
+			  },
+			  { .ival = "fdp",
+			    .oval = FIO_DP_FDP,
+			    .help = "Use Flexible Data Placement interface",
+			  },
+			  { .ival = "streams",
+			    .oval = FIO_DP_STREAMS,
+			    .help = "Use Streams interface",
+			  },
+		},
+	},
+	{
+		.name	= "plid_select",
+		.alias	= "fdp_pli_select",
+		.lname	= "Data Placement ID selection strategy",
 		.type	= FIO_OPT_STR,
-		.off1	= offsetof(struct thread_options, fdp_pli_select),
-		.help	= "Select which FDP placement ID to use next",
+		.off1	= offsetof(struct thread_options, dp_id_select),
+		.help	= "Strategy for selecting next Data Placement ID",
 		.def	= "roundrobin",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 		.posval	= {
 			  { .ival = "random",
-			    .oval = FIO_FDP_RANDOM,
+			    .oval = FIO_DP_RANDOM,
 			    .help = "Choose a Placement ID at random (uniform)",
 			  },
 			  { .ival = "roundrobin",
-			    .oval = FIO_FDP_RR,
+			    .oval = FIO_DP_RR,
 			    .help = "Round robin select Placement IDs",
 			  },
 		},
 	},
 	{
-		.name	= "fdp_pli",
-		.lname	= "FDP Placement ID indicies",
+		.name	= "plids",
+		.alias	= "fdp_pli",
+		.lname	= "Stream IDs/Data Placement ID indices",
 		.type	= FIO_OPT_STR,
 		.cb	= str_fdp_pli_cb,
-		.off1	= offsetof(struct thread_options, fdp_plis),
-		.help	= "Sets which placement ids to use (defaults to all)",
+		.off1	= offsetof(struct thread_options, dp_ids),
+		.help	= "Sets which Data Placement ids to use (defaults to all for FDP)",
 		.hide	= 1,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/server.h b/server.h
index 6d2659b0..83ce449b 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 103,
+	FIO_SERVER_VER			= 104,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/nvmept_fdp.py b/t/nvmept_fdp.py
new file mode 100755
index 00000000..031b439c
--- /dev/null
+++ b/t/nvmept_fdp.py
@@ -0,0 +1,745 @@
+#!/usr/bin/env python3
+#
+# Copyright 2024 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# nvmept_fdp.py
+#
+# Test fio's io_uring_cmd ioengine with NVMe pass-through FDP write commands.
+#
+# USAGE
+# see python3 nvmept_fdp.py --help
+#
+# EXAMPLES
+# python3 t/nvmept_fdp.py --dut /dev/ng0n1
+# python3 t/nvmept_fdp.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# Device formatted with LBA data size 4096 bytes
+# Device with at least five placement IDs
+#
+# WARNING
+# This is a destructive test
+"""
+import os
+import sys
+import json
+import time
+import locale
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+class FDPTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class. Check to make sure output for selected data
+    direction(s) is non-zero and that zero data appears for other directions.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept-fdp",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            "--randrepeat=0",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'num_range',
+                    'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
+                    'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
+                    'buffer_pattern', 'verify_pattern', 'offset', 'fdp',
+                    'fdp_pli', 'fdp_pli_select', 'dataplacement', 'plid_select',
+                    'plids', 'number_ios']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+    def check_result(self):
+        try:
+            self._check_result()
+        finally:
+            if not update_all_ruhs(self.fio_opts['filename']):
+                logging.error("Could not reset device")
+            if not check_all_ruhs(self.fio_opts['filename']):
+                logging.error("Reclaim units have inconsistent RUAMW values")
+
+
+    def _check_result(self):
+
+        super().check_result()
+
+        if 'rw' not in self.fio_opts or \
+                not self.passed or \
+                'json' not in self.fio_opts['output-format']:
+            return
+
+        job = self.json_data['jobs'][0]
+
+        if self.fio_opts['rw'] in ['read', 'randread']:
+            self.passed = self.check_all_ddirs(['read'], job)
+        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.fio_opts:
+                self.passed = self.check_all_ddirs(['write'], job)
+            else:
+                self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+            self.passed = self.check_all_ddirs(['trim'], job)
+        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+            self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            self.passed = self.check_all_ddirs(['trim', 'write'], job)
+        else:
+            logging.error("Unhandled rw value %s", self.fio_opts['rw'])
+            self.passed = False
+
+        if 'iodepth' in self.fio_opts:
+            # We will need to figure something out if any test uses an iodepth
+            # different from 8
+            if job['iodepth_level']['8'] < 95:
+                logging.error("Did not achieve requested iodepth")
+                self.passed = False
+            else:
+                logging.debug("iodepth 8 target met %s", job['iodepth_level']['8'])
+
+
+class FDPMultiplePLIDTest(FDPTest):
+    """
+    Write to multiple placement IDs.
+    """
+
+    def setup(self, parameters):
+        mapping = {
+                    'nruhsd': FIO_FDP_NUMBER_PLIDS,
+                    'max_ruamw': FIO_FDP_MAX_RUAMW,
+                }
+        if 'number_ios' in self.fio_opts and isinstance(self.fio_opts['number_ios'], str):
+            self.fio_opts['number_ios'] = eval(self.fio_opts['number_ios'].format(**mapping))
+
+        super().setup(parameters)
+
+    def _check_result(self):
+        if 'fdp_pli' in self.fio_opts:
+            plid_list = self.fio_opts['fdp_pli'].split(',')
+        elif 'plids' in self.fio_opts:
+            plid_list = self.fio_opts['plids'].split(',')
+        else:
+            plid_list = list(range(FIO_FDP_NUMBER_PLIDS))
+
+        plid_list = sorted([int(i) for i in plid_list])
+        logging.debug("plid_list: %s", str(plid_list))
+
+        fdp_status = get_fdp_status(self.fio_opts['filename'])
+
+        select = "roundrobin"
+        if 'fdp_pli_select' in self.fio_opts:
+            select = self.fio_opts['fdp_pli_select']
+        elif 'plid_select' in self.fio_opts:
+            select = self.fio_opts['plid_select']
+
+        if select == "roundrobin":
+            self._check_robin(plid_list, fdp_status)
+        elif select == "random":
+            self._check_random(plid_list, fdp_status)
+        else:
+            logging.error("Unknown plid selection strategy %s", select)
+            self.passed = False
+
+        super()._check_result()
+
+    def _check_robin(self, plid_list, fdp_status):
+        """
+        With round robin we can know exactly how many writes each PLID will
+        receive.
+        """
+        ruamw = [FIO_FDP_MAX_RUAMW] * FIO_FDP_NUMBER_PLIDS
+
+        remainder = int(self.fio_opts['number_ios'] % len(plid_list))
+        whole = int((self.fio_opts['number_ios'] - remainder) / len(plid_list))
+        logging.debug("PLIDs in the list should receive %d writes; %d PLIDs will receive one extra",
+                      whole, remainder)
+
+        for plid in plid_list:
+            ruamw[plid] -= whole
+            if remainder:
+                ruamw[plid] -= 1
+                remainder -= 1
+        logging.debug("Expected ruamw values: %s", str(ruamw))
+
+        for idx, ruhs in enumerate(fdp_status['ruhss']):
+            if ruhs['ruamw'] != ruamw[idx]:
+                logging.error("RUAMW mismatch with idx %d, pid %d, expected %d, observed %d", idx,
+                              ruhs['pid'], ruamw[idx], ruhs['ruamw'])
+                self.passed = False
+                break
+
+            logging.debug("RUAMW match with idx %d, pid %d: ruamw=%d", idx, ruhs['pid'], ruamw[idx])
+
+    def _check_random(self, plid_list, fdp_status):
+        """
+        With random selection, a set of PLIDs will receive all the write
+        operations and the remainder will be untouched.
+        """
+
+        total_ruamw = 0
+        for plid in plid_list:
+            total_ruamw += fdp_status['ruhss'][plid]['ruamw']
+
+        expected = len(plid_list) * FIO_FDP_MAX_RUAMW - self.fio_opts['number_ios']
+        if total_ruamw != expected:
+            logging.error("Expected total ruamw %d for plids %s, observed %d", expected,
+                          str(plid_list), total_ruamw)
+            self.passed = False
+        else:
+            logging.debug("Observed expected total ruamw %d for plids %s", expected, str(plid_list))
+
+        for idx, ruhs in enumerate(fdp_status['ruhss']):
+            if idx in plid_list:
+                continue
+            if ruhs['ruamw'] != FIO_FDP_MAX_RUAMW:
+                logging.error("Unexpected ruamw %d for idx %d, pid %d, expected %d", ruhs['ruamw'],
+                              idx, ruhs['pid'], FIO_FDP_MAX_RUAMW)
+                self.passed = False
+            else:
+                logging.debug("Observed expected ruamw %d for idx %d, pid %d", ruhs['ruamw'], idx,
+                              ruhs['pid'])
+
+
+class FDPSinglePLIDTest(FDPTest):
+    """
+    Write to a single placement ID only.
+    """
+
+    def _check_result(self):
+        if 'plids' in self.fio_opts:
+            plid = self.fio_opts['plids']
+        elif 'fdp_pli' in self.fio_opts:
+            plid = self.fio_opts['fdp_pli']
+        else:
+            plid = 0
+
+        fdp_status = get_fdp_status(self.fio_opts['filename'])
+        ruamw = fdp_status['ruhss'][plid]['ruamw']
+        lba_count = self.fio_opts['number_ios']
+
+        if FIO_FDP_MAX_RUAMW - lba_count != ruamw:
+            logging.error("FDP accounting mismatch for plid %d; expected ruamw %d, observed %d",
+                          plid, FIO_FDP_MAX_RUAMW - lba_count, ruamw)
+            self.passed = False
+        else:
+            logging.debug("FDP accounting as expected for plid %d; ruamw = %d", plid, ruamw)
+
+        super()._check_result()
+
+
+class FDPReadTest(FDPTest):
+    """
+    Read workload test.
+    """
+
+    def _check_result(self):
+        ruamw = check_all_ruhs(self.fio_opts['filename'])
+
+        if ruamw != FIO_FDP_MAX_RUAMW:
+            logging.error("Read workload affected FDP ruamw")
+            self.passed = False
+        else:
+            logging.debug("Read workload did not disturb FDP ruamw")
+            super()._check_result()
+
+
+def get_fdp_status(dut):
+    """
+    Run the nvme-cli command to obtain FDP status and return result as a JSON
+    object.
+    """
+
+    cmd = f"sudo nvme fdp status --output-format=json {dut}"
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    if cmd_result.returncode != 0:
+        logging.error("Error obtaining device %s FDP status: %s", dut, cmd_result.stderr)
+        return False
+
+    return json.loads(cmd_result.stdout)
+
+
+def update_ruh(dut, plid):
+    """
+    Update reclaim unit handles with specified ID(s). This tells the device to
+    point the RUH to a new (empty) reclaim unit.
+    """
+
+    ids = ','.join(plid) if isinstance(plid, list) else plid
+    cmd = f"nvme fdp update --pids={ids} {dut}"
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    if cmd_result.returncode != 0:
+        logging.error("Error updating RUH %s ID(s) %s", dut, ids)
+        return False
+
+    return True
+
+
+def update_all_ruhs(dut):
+    """
+    Update all reclaim unit handles on the device.
+    """
+
+    fdp_status = get_fdp_status(dut)
+    for ruhs in fdp_status['ruhss']:
+        if not update_ruh(dut, ruhs['pid']):
+            return False
+
+    return True
+
+
+def check_all_ruhs(dut):
+    """
+    Check that all RUHs have the same value for reclaim unit available media
+    writes (RUAMW).  Return the RUAMW value.
+    """
+
+    fdp_status = get_fdp_status(dut)
+    ruh_status = fdp_status['ruhss']
+
+    ruamw = ruh_status[0]['ruamw']
+    for ruhs in ruh_status:
+        if ruhs['ruamw'] != ruamw:
+            logging.error("RUAMW mismatch: found %d, expected %d", ruhs['ruamw'], ruamw)
+            return False
+
+    return ruamw
+
+
+TEST_LIST = [
+    # Write one LBA to one PLID using both the old and new sets of options
+    ## omit fdp_pli_select/plid_select
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=roundrobin
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=random
+    {
+        "test_id": 5,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 6,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    # Write four LBAs to one PLID using both the old and new sets of options
+    ## omit fdp_pli_select/plid_select
+    {
+        "test_id": 7,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 1,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 8,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 1,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=roundrobin
+    {
+        "test_id": 9,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 1,
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 10,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 1,
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=random
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 1,
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 1,
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    # Just a regular write without FDP directive--should land on plid 0
+    {
+        "test_id": 13,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 19,
+            "verify": "crc32c",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    # Read workload
+    {
+        "test_id": 14,
+        "fio_opts": {
+            "rw": 'randread',
+            "bs": 4096,
+            "number_ios": 19,
+            "output-format": "json",
+            },
+        "test_class": FDPReadTest,
+    },
+    # write to multiple PLIDs using round robin to select PLIDs
+    ## write to all PLIDs using old and new sets of options
+    {
+        "test_id": 100,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "2*{nruhsd}+3",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "2*{nruhsd}+3",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    ## write to a subset of PLIDs using old and new sets of options
+    {
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{nruhsd}+1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1,3",
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{nruhsd}+1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1,3",
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    # write to multiple PLIDs using random selection of PLIDs
+    ## write to all PLIDs using old and new sets of options
+    {
+        "test_id": 200,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 201,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    ## write to a subset of PLIDs using old and new sets of options
+    {
+        "test_id": 202,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1,3,4",
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 203,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1,3,4",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    # Specify invalid options fdp=1 and dataplacement=none
+    {
+        "test_id": 300,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "output-format": "normal",
+            "dataplacement": "none",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    # Specify invalid options fdp=1 and dataplacement=streams
+    {
+        "test_id": 301,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "output-format": "normal",
+            "dataplacement": "streams",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+]
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('--dut', help='target NVMe character device to test '
+                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    args = parser.parse_args()
+
+    return args
+
+
+FIO_FDP_MAX_RUAMW = 0
+FIO_FDP_NUMBER_PLIDS = 0
+
+def main():
+    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
+    global FIO_FDP_MAX_RUAMW
+    global FIO_FDP_NUMBER_PLIDS
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept-fdp-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    fdp_status = get_fdp_status(args.dut)
+    FIO_FDP_NUMBER_PLIDS = fdp_status['nruhsd']
+    update_all_ruhs(args.dut)
+    FIO_FDP_MAX_RUAMW = check_all_ruhs(args.dut)
+    if not FIO_FDP_MAX_RUAMW:
+        sys.exit(-1)
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept-fdp',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/nvmept_streams.py b/t/nvmept_streams.py
new file mode 100755
index 00000000..e5425506
--- /dev/null
+++ b/t/nvmept_streams.py
@@ -0,0 +1,520 @@
+#!/usr/bin/env python3
+#
+# Copyright 2024 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# nvmept_streams.py
+#
+# Test fio's NVMe streams support using the io_uring_cmd ioengine with NVMe
+# pass-through commands.
+#
+# USAGE
+# see python3 nvmept_streams.py --help
+#
+# EXAMPLES
+# python3 t/nvmept_streams.py --dut /dev/ng0n1
+# python3 t/nvmept_streams.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+# WARNING
+# This is a destructive test
+#
+# Enable streams with
+# nvme dir-send -D 0 -O 1 -e 1 -T 1 /dev/nvme0n1
+#
+# See streams directive status with
+# nvme dir-receive -D 0 -O 1 -H /dev/nvme0n1
+"""
+import os
+import sys
+import time
+import locale
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+class StreamsTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class for streams. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept-streams",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            "--randrepeat=0",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'num_range',
+                    'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
+                    'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
+                    'buffer_pattern', 'verify_pattern', 'offset', 'dataplacement',
+                    'plids', 'plid_select' ]:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+    def check_result(self):
+        try:
+            self._check_result()
+        finally:
+            release_all_streams(self.fio_opts['filename'])
+
+
+    def _check_result(self):
+
+        super().check_result()
+
+        if 'rw' not in self.fio_opts or \
+                not self.passed or \
+                'json' not in self.fio_opts['output-format']:
+            return
+
+        job = self.json_data['jobs'][0]
+
+        if self.fio_opts['rw'] in ['read', 'randread']:
+            self.passed = self.check_all_ddirs(['read'], job)
+        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.fio_opts:
+                self.passed = self.check_all_ddirs(['write'], job)
+            else:
+                self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+            self.passed = self.check_all_ddirs(['trim'], job)
+        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+            self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            self.passed = self.check_all_ddirs(['trim', 'write'], job)
+        else:
+            logging.error("Unhandled rw value %s", self.fio_opts['rw'])
+            self.passed = False
+
+        if 'iodepth' in self.fio_opts:
+            # We will need to figure something out if any test uses an iodepth
+            # different from 8
+            if job['iodepth_level']['8'] < 95:
+                logging.error("Did not achieve requested iodepth")
+                self.passed = False
+            else:
+                logging.debug("iodepth 8 target met %s", job['iodepth_level']['8'])
+
+        stream_ids = [int(stream) for stream in self.fio_opts['plids'].split(',')]
+        if not self.check_streams(self.fio_opts['filename'], stream_ids):
+            self.passed = False
+            logging.error("Streams not as expected")
+        else:
+            logging.debug("Streams created as expected")
+
+
+    def check_streams(self, dut, stream_ids):
+        """
+        Confirm that the specified stream IDs exist on the specified device.
+        """
+
+        id_list = get_device_stream_ids(dut)
+        if not id_list:
+            return False
+
+        for stream in stream_ids:
+            if stream in id_list:
+                logging.debug("Stream ID %d found active on device", stream)
+                id_list.remove(stream)
+            else:
+                if self.__class__.__name__ != "StreamsTestRand":
+                    logging.error("Stream ID %d not found on device", stream)
+                else:
+                    logging.debug("Stream ID %d not found on device", stream)
+                return False
+
+        if len(id_list) != 0:
+            logging.error("Extra stream IDs %s found on device", str(id_list))
+            return False
+
+        return True
+
+
+class StreamsTestRR(StreamsTest):
+    """
+    NVMe pass-through test class for streams. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions. Check that Stream IDs are accessed in round robin order.
+    """
+
+    def check_streams(self, dut, stream_ids):
+        """
+        The number of IOs is less than the number of stream IDs provided. Let N
+        be the number of IOs. Make sure that the device only has the first N of
+        the stream IDs provided.
+
+        This will miss some cases where some other selection algorithm happens
+        to select the first N stream IDs. The solution would be to repeat this
+        test multiple times. Multiple trials passing would be evidence that
+        round robin is working correctly.
+        """
+
+        id_list = get_device_stream_ids(dut)
+        if not id_list:
+            return False
+
+        num_streams = int(self.fio_opts['io_size'] / self.fio_opts['bs'])
+        stream_ids = sorted(stream_ids)[0:num_streams]
+
+        return super().check_streams(dut, stream_ids)
+
+
+class StreamsTestRand(StreamsTest):
+    """
+    NVMe pass-through test class for streams. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions. Check that Stream IDs are accessed in random order.
+    """
+
+    def check_streams(self, dut, stream_ids):
+        """
+        The number of IOs is less than the number of stream IDs provided. Let N
+        be the number of IOs. Confirm that the stream IDs on the device are not
+        the first N stream IDs.
+
+        This will produce false positives because it is possible for the first
+        N stream IDs to be randomly selected. We can reduce the probability of
+        false positives by increasing N and increasing the number of streams
+        IDs to choose from, although fio has a max of 16 placement IDs.
+        """
+
+        id_list = get_device_stream_ids(dut)
+        if not id_list:
+            return False
+
+        num_streams = int(self.fio_opts['io_size'] / self.fio_opts['bs'])
+        stream_ids = sorted(stream_ids)[0:num_streams]
+
+        return not super().check_streams(dut, stream_ids)
+
+
+def get_device_stream_ids(dut):
+    cmd = f"sudo nvme dir-receive -D 1 -O 2 -H {dut}"
+    logging.debug("check streams command: %s", cmd)
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    logging.debug(cmd_result.stdout)
+
+    if cmd_result.returncode != 0:
+        logging.error("Error obtaining device %s stream IDs: %s", dut, cmd_result.stderr)
+        return False
+
+    id_list = []
+    for line in cmd_result.stdout.split('\n'):
+        if not 'Stream Identifier' in line:
+            continue
+        tokens = line.split(':')
+        id_list.append(int(tokens[1]))
+
+    return id_list
+
+
+def release_stream(dut, stream_id):
+    """
+    Release stream on given device with selected ID.
+    """
+    cmd = f"nvme dir-send -D 1 -O 1 -S {stream_id} {dut}"
+    logging.debug("release stream command: %s", cmd)
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    if cmd_result.returncode != 0:
+        logging.error("Error releasing %s stream %d", dut, stream_id)
+        return False
+
+    return True
+
+
+def release_all_streams(dut):
+    """
+    Release all streams on specified device.
+    """
+
+    id_list = get_device_stream_ids(dut)
+    if not id_list:
+        return False
+
+    for stream in id_list:
+        if not release_stream(dut, stream):
+            return False
+
+    return True
+
+
+TEST_LIST = [
+    # 4k block size
+    # {seq write, rand write} x {single stream, four streams}
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "8",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "3",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "1,2,3,4",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "5,6,7,8",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    # 256KiB block size
+    # {seq write, rand write} x {single stream, four streams}
+    {
+        "test_id": 10,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "88",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "20",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "16,32,64,128",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 13,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "10,20,40,82",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    # Test placement ID selection patterns
+    # default is round robin
+    {
+        "test_id": 20,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '88,99,100,123,124,125,126,127,128,129,130,131,132,133,134,135',
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTestRR,
+    },
+    {
+        "test_id": 21,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '12,88,99,100,123,124,125,126,127,128,129,130,131,132,133,11',
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTestRR,
+    },
+    # explicitly select round robin
+    {
+        "test_id": 22,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '22,88,99,100,123,124,125,126,127,128,129,130,131,132,133,134',
+            "dataplacement": "streams",
+            "output-format": "json",
+            "plid_select": "roundrobin",
+            },
+        "test_class": StreamsTestRR,
+    },
+    # explicitly select random
+    {
+        "test_id": 23,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16',
+            "dataplacement": "streams",
+            "output-format": "json",
+            "plid_select": "random",
+            },
+        "test_class": StreamsTestRand,
+    },
+    # Error case with placement ID > 0xFFFF
+    {
+        "test_id": 30,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": "1,2,3,0x10000",
+            "dataplacement": "streams",
+            "output-format": "normal",
+            "plid_select": "random",
+            },
+        "test_class": StreamsTestRand,
+        "success": SUCCESS_NONZERO,
+    },
+    # Error case with no stream IDs provided
+    {
+        "test_id": 31,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "dataplacement": "streams",
+            "output-format": "normal",
+            },
+        "test_class": StreamsTestRand,
+        "success": SUCCESS_NONZERO,
+    },
+
+]
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('--dut', help='target NVMe character device to test '
+                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept-streams-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    release_all_streams(args.dut)
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept-streams',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/thread_options.h b/thread_options.h
index c2e71518..a36b7909 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -391,11 +391,11 @@ struct thread_options {
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
-#define FIO_MAX_PLIS 16
 	unsigned int fdp;
-	unsigned int fdp_pli_select;
-	unsigned int fdp_plis[FIO_MAX_PLIS];
-	unsigned int fdp_nrpli;
+	unsigned int dp_type;
+	unsigned int dp_id_select;
+	unsigned int dp_ids[FIO_MAX_DP_IDS];
+	unsigned int dp_nr_ids;
 
 	unsigned int log_entries;
 	unsigned int log_prio;
@@ -709,9 +709,10 @@ struct thread_options_pack {
 	uint32_t log_prio;
 
 	uint32_t fdp;
-	uint32_t fdp_pli_select;
-	uint32_t fdp_plis[FIO_MAX_PLIS];
-	uint32_t fdp_nrpli;
+	uint32_t dp_type;
+	uint32_t dp_id_select;
+	uint32_t dp_ids[FIO_MAX_DP_IDS];
+	uint32_t dp_nr_ids;
 
 	uint32_t num_range;
 	/*
