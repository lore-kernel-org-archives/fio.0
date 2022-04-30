Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44065C433EF
	for <fio@archiver.kernel.org>; Sat, 30 Apr 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiD3MDa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 30 Apr 2022 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbiD3MD3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 Apr 2022 08:03:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDF52BC1
        for <fio@vger.kernel.org>; Sat, 30 Apr 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3zvnpvWnWEIA05mA+eO64Z2LsmeQ+oSmoFcmTsSK6Sw=; b=TrkdBBW+DnHU+XRWDLCfCGu1g3
        6aVRQPWT+vrj+U0n7wBtdXeqM/LFYKC70tlfnQaZ8PSVpvZdcKjrCXbNw2TZsk/LH1Zy+3aeWULev
        4u9UVS6Guwc5Bo/acNj3xzHhcz67F2mbDcCPUXzRdoXkOgEHG8mi5/uDSFDPkj9KnQ7T4P5N1Kdb3
        yzrgfexirE99sOSnG1mcltBMOfNM+r3XRNu2A5R+W36VL3VfcxlX/J2WTYlyDrAcR7Z2/Qy90Fe2l
        mgWtBIhTSVCwiHNlSNbnqXrDgw6g72Er1Z2nqO+f10D/kMETJR8O07qK71NlRgtru0QRHId890xDD
        KmB5DeXw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nklld-00DJFO-0P
        for fio@vger.kernel.org; Sat, 30 Apr 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E29BD1BC0135; Sat, 30 Apr 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220430120001.E29BD1BC0135@kernel.dk>
Date:   Sat, 30 Apr 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5f2d43188c2d65674aaba6280e2a87107e5d7099:

  Merge branch 'fix/json/strdup_memory_leak' of https://github.com/dpronin/fio (2022-04-17 16:47:22 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6e594a2fa8388892dffb2ffc9b865689e2d67833:

  Merge branch 'global_dedup' of https://github.com/bardavid/fio (2022-04-29 16:30:50 -0600)

----------------------------------------------------------------
Bar David (2):
      Introducing support for generation of dedup buffers across jobs. The dedup buffers are spread evenly between the jobs that enabled the dedupe_global option
      adding an example for dedupe_global usage and DRR testing

Jens Axboe (1):
      Merge branch 'global_dedup' of https://github.com/bardavid/fio

 HOWTO.rst                  |  6 +++++
 backend.c                  |  5 ++++
 cconv.c                    |  2 ++
 dedupe.c                   | 46 +++++++++++++++++++++++++++++++++----
 dedupe.h                   |  3 ++-
 examples/dedupe-global.fio | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 fio.1                      |  9 ++++++++
 init.c                     |  2 +-
 options.c                  | 10 ++++++++
 server.h                   |  2 +-
 thread_options.h           |  3 +++
 11 files changed, 138 insertions(+), 7 deletions(-)
 create mode 100644 examples/dedupe-global.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index a5fa432e..6a3e09f5 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1749,6 +1749,12 @@ Buffers and memory
 	Note that size needs to be explicitly provided and only 1 file per
 	job is supported
 
+.. option:: dedupe_global=bool
+
+	This controls whether the deduplication buffers will be shared amongst
+	all jobs that have this option set. The buffers are spread evenly between
+	participating jobs.
+
 .. option:: invalidate=bool
 
 	Invalidate the buffer/page cache parts of the files to be used prior to
diff --git a/backend.c b/backend.c
index 317e4f6c..ffbb7e2a 100644
--- a/backend.c
+++ b/backend.c
@@ -2570,6 +2570,11 @@ int fio_backend(struct sk_out *sk_out)
 		setup_log(&agg_io_log[DDIR_TRIM], &p, "agg-trim_bw.log");
 	}
 
+	if (init_global_dedupe_working_set_seeds()) {
+		log_err("fio: failed to initialize global dedupe working set\n");
+		return 1;
+	}
+
 	startup_sem = fio_sem_init(FIO_SEM_LOCKED);
 	if (!sk_out)
 		is_local_backend = true;
diff --git a/cconv.c b/cconv.c
index 62d02e36..6c36afb7 100644
--- a/cconv.c
+++ b/cconv.c
@@ -305,6 +305,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
 	o->dedupe_mode = le32_to_cpu(top->dedupe_mode);
 	o->dedupe_working_set_percentage = le32_to_cpu(top->dedupe_working_set_percentage);
+	o->dedupe_global = le32_to_cpu(top->dedupe_global);
 	o->block_error_hist = le32_to_cpu(top->block_error_hist);
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
@@ -513,6 +514,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
 	top->dedupe_mode = cpu_to_le32(o->dedupe_mode);
 	top->dedupe_working_set_percentage = cpu_to_le32(o->dedupe_working_set_percentage);
+	top->dedupe_global = cpu_to_le32(o->dedupe_global);
 	top->block_error_hist = cpu_to_le32(o->block_error_hist);
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
diff --git a/dedupe.c b/dedupe.c
index fd116dfb..8214a786 100644
--- a/dedupe.c
+++ b/dedupe.c
@@ -1,13 +1,37 @@
 #include "fio.h"
 
-int init_dedupe_working_set_seeds(struct thread_data *td)
+/**
+ * initializes the global dedup workset.
+ * this needs to be called after all jobs' seeds
+ * have been initialized
+ */
+int init_global_dedupe_working_set_seeds(void)
 {
-	unsigned long long i, j, num_seed_advancements;
+	int i;
+	struct thread_data *td;
+
+	for_each_td(td, i) {
+		if (!td->o.dedupe_global)
+			continue;
+
+		if (init_dedupe_working_set_seeds(td, 1))
+			return 1;
+	}
+
+	return 0;
+}
+
+int init_dedupe_working_set_seeds(struct thread_data *td, bool global_dedup)
+{
+	int tindex;
+	struct thread_data *td_seed;
+	unsigned long long i, j, num_seed_advancements, pages_per_seed;
 	struct frand_state dedupe_working_set_state = {0};
 
 	if (!td->o.dedupe_percentage || !(td->o.dedupe_mode == DEDUPE_MODE_WORKING_SET))
 		return 0;
 
+	tindex = td->thread_number - 1;
 	num_seed_advancements = td->o.min_bs[DDIR_WRITE] /
 		min_not_zero(td->o.min_bs[DDIR_WRITE], (unsigned long long) td->o.compress_chunk);
 	/*
@@ -20,9 +44,11 @@ int init_dedupe_working_set_seeds(struct thread_data *td)
 		log_err("fio: could not allocate dedupe working set\n");
 		return 1;
 	}
+
 	frand_copy(&dedupe_working_set_state, &td->buf_state);
-	for (i = 0; i < td->num_unique_pages; i++) {
-		frand_copy(&td->dedupe_working_set_states[i], &dedupe_working_set_state);
+	frand_copy(&td->dedupe_working_set_states[0], &dedupe_working_set_state);
+	pages_per_seed = max(td->num_unique_pages / thread_number, 1ull);
+	for (i = 1; i < td->num_unique_pages; i++) {
 		/*
 		 * When compression is used the seed is advanced multiple times to
 		 * generate the buffer. We want to regenerate the same buffer when
@@ -30,6 +56,18 @@ int init_dedupe_working_set_seeds(struct thread_data *td)
 		 */
 		for (j = 0; j < num_seed_advancements; j++)
 			__get_next_seed(&dedupe_working_set_state);
+
+		/*
+		 * When global dedup is used, we rotate the seeds to allow
+		 * generating same buffers across different jobs. Deduplication buffers
+		 * are spread evenly across jobs participating in global dedupe
+		 */
+		if (global_dedup && i % pages_per_seed == 0) {
+			td_seed = tnumber_to_td(++tindex % thread_number);
+			frand_copy(&dedupe_working_set_state, &td_seed->buf_state);
+		}
+
+		frand_copy(&td->dedupe_working_set_states[i], &dedupe_working_set_state);
 	}
 
 	return 0;
diff --git a/dedupe.h b/dedupe.h
index d4c4dc37..bd1f9c0c 100644
--- a/dedupe.h
+++ b/dedupe.h
@@ -1,6 +1,7 @@
 #ifndef DEDUPE_H
 #define DEDUPE_H
 
-int init_dedupe_working_set_seeds(struct thread_data *td);
+int init_dedupe_working_set_seeds(struct thread_data *td, bool global_dedupe);
+int init_global_dedupe_working_set_seeds(void);
 
 #endif
diff --git a/examples/dedupe-global.fio b/examples/dedupe-global.fio
new file mode 100644
index 00000000..edaaad55
--- /dev/null
+++ b/examples/dedupe-global.fio
@@ -0,0 +1,57 @@
+# Writing to 2 files that share the duplicate blocks.
+# The dedupe working set is spread uniformly such that when
+# each of the jobs choose to perform a dedup operation they will
+# regenerate a buffer from the global space.
+# If you test the dedup ratio on either file by itself the result
+# is likely lower than if you test the ratio of the two files combined.
+#
+# Use `./t/fio-dedupe <file> -C 1 -c 1 -b 4096` to test the total
+# data reduction ratio.
+#
+#
+# Full example of test:
+# $ ./fio ./examples/dedupe-global.fio
+#
+# Checking ratio on a and b individually:
+# $ ./t/fio-dedupe a.0.0 -C 1 -c 1 -b 4096
+#
+# $ Extents=25600, Unique extents=16817 Duplicated extents=5735
+# $ De-dupe ratio: 1:0.52
+# $ De-dupe working set at least: 22.40%
+# $ Fio setting: dedupe_percentage=34
+# $ Unique capacity 33MB
+#
+# ./t/fio-dedupe b.0.0 -C 1 -c 1 -b 4096
+# $ Extents=25600, Unique extents=17009 Duplicated extents=5636
+# $ De-dupe ratio: 1:0.51
+# $ De-dupe working set at least: 22.02%
+# $ Fio setting: dedupe_percentage=34
+# $ Unique capacity 34MB
+#
+# Combining files:
+# $ cat a.0.0 > c.0.0
+# $ cat b.0.0 >> c.0.0
+#
+# Checking data reduction ratio on combined file:
+# $ ./t/fio-dedupe c.0.0 -C 1 -c 1 -b 4096
+# $ Extents=51200, Unique extents=25747 Duplicated extents=11028
+# $ De-dupe ratio: 1:0.99
+# $ De-dupe working set at least: 21.54%
+# $ Fio setting: dedupe_percentage=50
+# $ Unique capacity 51MB
+#
+[global]
+ioengine=libaio
+iodepth=256
+size=100m
+dedupe_mode=working_set
+dedupe_global=1
+dedupe_percentage=50
+blocksize=4k
+rw=write
+buffer_compress_percentage=50
+dedupe_working_set_percentage=50
+
+[a]
+
+[b]
diff --git a/fio.1 b/fio.1
index a2ec836f..609947dc 100644
--- a/fio.1
+++ b/fio.1
@@ -1553,6 +1553,15 @@ Note that \fBsize\fR needs to be explicitly provided and only 1 file
 per job is supported
 .RE
 .TP
+.BI dedupe_global \fR=\fPbool
+This controls whether the deduplication buffers will be shared amongst
+all jobs that have this option set. The buffers are spread evenly between
+participating jobs.
+.P
+.RS
+Note that \fBdedupe_mode\fR must be set to \fBworking_set\fR for this to work.
+Can be used in combination with compression
+.TP
 .BI invalidate \fR=\fPbool
 Invalidate the buffer/page cache parts of the files to be used prior to
 starting I/O if the platform and file type support it. Defaults to true.
diff --git a/init.c b/init.c
index 6f186051..f7d702f8 100644
--- a/init.c
+++ b/init.c
@@ -1541,7 +1541,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (fixup_options(td))
 		goto err;
 
-	if (init_dedupe_working_set_seeds(td))
+	if (!td->o.dedupe_global && init_dedupe_working_set_seeds(td, 0))
 		goto err;
 
 	/*
diff --git a/options.c b/options.c
index e06d9b66..3b83573b 100644
--- a/options.c
+++ b/options.c
@@ -4665,6 +4665,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
 	},
+	{
+		.name	= "dedupe_global",
+		.lname	= "Global deduplication",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, dedupe_global),
+		.help	= "Share deduplication buffers across jobs",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BUF,
+	},
 	{
 		.name	= "dedupe_mode",
 		.lname	= "Dedupe mode",
diff --git a/server.h b/server.h
index 0e62b6df..b0c5e2df 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 96,
+	FIO_SERVER_VER			= 97,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 4162c42f..634070af 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -263,6 +263,7 @@ struct thread_options {
 	unsigned int dedupe_percentage;
 	unsigned int dedupe_mode;
 	unsigned int dedupe_working_set_percentage;
+	unsigned int dedupe_global;
 	unsigned int time_based;
 	unsigned int disable_lat;
 	unsigned int disable_clat;
@@ -578,6 +579,7 @@ struct thread_options_pack {
 	uint32_t dedupe_percentage;
 	uint32_t dedupe_mode;
 	uint32_t dedupe_working_set_percentage;
+	uint32_t dedupe_global;
 	uint32_t time_based;
 	uint32_t disable_lat;
 	uint32_t disable_clat;
@@ -596,6 +598,7 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad5;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
