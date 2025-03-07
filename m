Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1FC218E85
	for <fio@vger.kernel.org>; Fri,  7 Mar 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741352412; cv=none; b=RcxOVejFK8oyWeThUB/ZjhFXYIuViWeoqxjzL51+MhRQTnzyh/lnveGU3Oc7MeTrKT3LvzcvXW4oi/0XqZiWLJxjBoNEo1nd4+C0YhtKNcZ3kfc0CPmT2ZJ02pL4ImAXeBx2qeJ2+DCRV3BdAtS4xKqkRoY1h78uKGYwriyimaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741352412; c=relaxed/simple;
	bh=ssYudc5skkrtCXNOdx5+2SqeTR6RGfSOf3VS4JXNma4=;
	h=Subject:From:To:Message-Id:Date; b=JEKjR+6rCq17jErRw41uH/TL8JwDRuZvBOsHgY154VXBYNKEBrbmvMZSDnWoOGIWsbIUjmqa84ETJa9FyXQT/TWgMrImLwe4rnUy829QKoWJO7CQOOshgM4koY78xspPAzAEaPRz/eXZSovrPb+L4WrAbeqjOrYyruIenHye4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m1CgqWLo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m1CgqWLo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=0XuCzNMBWu0bT80qdDxjH8pUWUAmkfuKhYiZXqcj0ho=; b=m1CgqWLoO6OmERQk20bXrm06kK
	op5nwCqv58M+rXrJelaWlmQJ4xwjze7bDbFWF6lgjMpT239TCcFCmLBCfoaP2N6ZINWbbhkzmjIGQ
	PYxEHYsviC3w+MXNFXxFiIcHJBOZ1kEV8Vw2xBCVt4D2mI/ilv4JehnWTFmbboQKxZ2Vp3+2ePywJ
	iJqEMtGeN5OKJEussjyfvRUopG0hp7BRKrooDs7qHLjhv93DXIWtdEHROWG0VrPROpsT/p1zVFsbM
	+wpoUrDzoWrRdPbhMixbf21KlhQMTnhPCDu0+trdBf2t+5Mh3mIMIxxeZh/BFqOAlTjnm9clEvQ4U
	ecUsH0DA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tqXJ5-0000000CSok-3czZ
	for fio@vger.kernel.org;
	Fri, 07 Mar 2025 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 6089F1BC0171; Fri,  7 Mar 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250307130001.6089F1BC0171@kernel.dk>
Date: Fri,  7 Mar 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit df60924e4d854cd6fdf4b730d37282c6b6b4c0a1:

  Merge branch 'update-docs-for-compare' of https://github.com/minwooim/fio (2025-03-05 12:05:52 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a72fed7a4900e43035cf4e7e653fd11b6671c726:

  ci: add nightly test for verify (2025-03-06 13:58:43 -0500)

----------------------------------------------------------------
Ankit Kumar (14):
      filesetup: remove unnecessary check
      verify: add missing client/server support for verify_write_sequence
      init: write sequence behavior change for verify_only mode
      fio: add verify_header_seed option
      verify: disable header seed checking instead of overwriting it
      verify: enable header seed check for 100% write jobs
      verify: disable header seed check for verify_only jobs
      verify: header seed check for read only workloads
      verify: fix verify issues with norandommap
      verify: disable write sequence checks with norandommap and iodepth > 1
      backend: fix verify issue during readwrite
      init: fixup verify_offset option
      verify: fix verify issue with offest modifiers
      verify: adjust fio_offset_overlap_risk to include randommap

Vincent Fu (7):
      t/fiotestcommon: do not require nvmecdev argument for Requirements
      t/fiotestlib: improve JSON decoding
      t/fiotestlib: display stderr size when it is not empty but should be
      t/verify.py: Add verify test script
      t/fiotestcommon: add a success pattern for long tests
      t/run-fio-test: add t/verify.py
      ci: add nightly test for verify

 .github/workflows/ci.yml |   2 +
 HOWTO.rst                |  52 ++-
 backend.c                |  18 +-
 cconv.c                  |   4 +
 ci/actions-full-test.sh  |  13 +
 filesetup.c              |  14 +-
 fio.1                    |  46 ++-
 fio.h                    |   9 +
 init.c                   |  43 ++-
 iolog.c                  |   9 +-
 options.c                |  11 +
 server.h                 |   2 +-
 t/fiotestcommon.py       |   7 +-
 t/fiotestlib.py          |  20 +-
 t/run-fio-tests.py       |   8 +
 t/verify.py              | 803 +++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h         |   3 +
 verify.c                 |  10 +-
 18 files changed, 1009 insertions(+), 65 deletions(-)
 create mode 100755 t/verify.py

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index d20a2d01..94eec3d2 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -4,6 +4,8 @@ on:
   push:
   pull_request:
   workflow_dispatch:
+  schedule:
+    - cron: "35 5 * * *"  # 5:35 UTC which is 0:35 ET
 
 jobs:
   build-containers:
diff --git a/HOWTO.rst b/HOWTO.rst
index 62537b65..bde3496e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1185,7 +1185,9 @@ I/O type
 	pattern, then the *<nr>* value specified will be **added** to the generated
 	offset for each I/O turning sequential I/O into sequential I/O with holes.
 	For instance, using ``rw=write:4k`` will skip 4k for every write.  Also see
-	the :option:`rw_sequencer` option.
+	the :option:`rw_sequencer` option. If this is used with :option:`verify`
+	then :option:`verify_header_seed` will be disabled, unless its explicitly
+	enabled.
 
 .. option:: rw_sequencer=str
 
@@ -1564,11 +1566,12 @@ I/O type
 	this option is given, fio will just get a new random offset without looking
 	at past I/O history. This means that some blocks may not be read or written,
 	and that some blocks may be read/written more than once. If this option is
-	used with :option:`verify` and multiple blocksizes (via :option:`bsrange`),
-	only intact blocks are verified, i.e., partially-overwritten blocks are
-	ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
-	the same block to be overwritten, which can cause verification errors.  Either
-	do not use norandommap in this case, or also use the lfsr random generator.
+	used with :option:`verify` then :option:`verify_header_seed` will be
+	disabled. If this option is used with :option:`verify` and multiple blocksizes
+	(via :option:`bsrange`), only intact blocks are verified, i.e.,
+	partially-overwritten blocks are ignored. With an async I/O engine and an I/O
+	depth > 1, header write sequence number verification will be disabled. See
+	:option:`verify_write_sequence`.
 
 .. option:: softrandommap=bool
 
@@ -3818,7 +3821,9 @@ Verification
 	invocation of this workload. This option allows one to check data multiple
 	times at a later date without overwriting it. This option makes sense only
 	for workloads that write data, and does not support workloads with the
-	:option:`time_based` option set.
+	:option:`time_based` option set. :option:`verify_write_sequence` and
+	:option:`verify_header_seed` will be disabled in this mode, unless they are
+	explicitly enabled.
 
 .. option:: do_verify=bool
 
@@ -3831,8 +3836,9 @@ Verification
 	of the job. Each verification method also implies verification of special
 	header, which is written to the beginning of each block. This header also
 	includes meta information, like offset of the block, block number, timestamp
-	when block was written, etc.  :option:`verify` can be combined with
-	:option:`verify_pattern` option.  The allowed values are:
+	when block was written, initial seed value used to generate the buffer
+	contents etc. :option:`verify` can be combined with :option:`verify_pattern`
+	option.  The allowed values are:
 
 		**md5**
 			Use an md5 sum of the data area and store it in the header of
@@ -3906,10 +3912,18 @@ Verification
 			:option:`ioengine`\=null, not for much else.
 
 	This option can be used for repeated burn-in tests of a system to make sure
-	that the written data is also correctly read back. If the data direction
-	given is a read or random read, fio will assume that it should verify a
-	previously written file. If the data direction includes any form of write,
-	the verify will be of the newly written data.
+	that the written data is also correctly read back.
+
+	If the data direction given is a read or random read, fio will assume that
+	it should verify a previously written file. In this scenario fio will not
+	verify the block number written in the header. The header seed won't be
+	verified, unless its explicitly requested by setting
+	:option:`verify_header_seed`. Note in this scenario the header seed check
+	will only work if the read invocation exactly matches the original write
+	invocation.
+
+	If the data direction includes any form of write, the verify will be of the
+	newly written data.
 
 	To avoid false verification errors, do not use the norandommap option when
 	verifying data with async I/O engines and I/O depths > 1.  Or use the
@@ -3919,7 +3933,8 @@ Verification
 .. option:: verify_offset=int
 
 	Swap the verification header with data somewhere else in the block before
-	writing. It is swapped back before verifying.
+	writing. It is swapped back before verifying. This should be within the
+	range of :option:`verify_interval`.
 
 .. option:: verify_interval=int
 
@@ -4030,6 +4045,15 @@ Verification
         fail).
         Defaults to true.
 
+.. option:: verify_header_seed=bool
+
+	Verify the header seed value which was used to generate the buffer contents.
+	In certain scenarios with read / verify only workloads, when
+	:option:`norandommap` is enabled, with offset modifiers
+	(refer :option:`readwrite` and :option:`rw_sequencer`) etc verification of
+	header seed may fail. Disabling this option will mean that header seed
+	checking is skipped. Defaults to true.
+
 .. option:: trim_percentage=int
 
 	Number of verify blocks to discard/trim.
diff --git a/backend.c b/backend.c
index f3e5b56a..b75eea80 100644
--- a/backend.c
+++ b/backend.c
@@ -978,8 +978,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	if (td_write(td) && td_random(td) && td->o.norandommap)
 		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
 
-	/* Don't break too early if io_size > size */
-	if (td_rw(td) && !td_random(td))
+	/*
+	 * Don't break too early if io_size > size. The exception is when
+	 * verify is enabled.
+	 */
+	if (td_rw(td) && !td_random(td) && td->o.verify == VERIFY_NONE)
 		total_bytes = max(total_bytes, (uint64_t)td->o.io_size);
 
 	/*
@@ -1069,6 +1072,17 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
 
+			/*
+			 * For read only workloads generate the seed. This way
+			 * we can still verify header seed at any later
+			 * invocation.
+			 */
+			if (!td_write(td) && !td->o.verify_pattern_bytes) {
+				io_u->rand_seed = __rand(&td->verify_state);
+				if (sizeof(int) != sizeof(long *))
+					io_u->rand_seed *= __rand(&td->verify_state);
+			}
+
 			if (verify_state_should_stop(td, io_u)) {
 				put_io_u(td, io_u);
 				break;
diff --git a/cconv.c b/cconv.c
index 9571f1a8..df841703 100644
--- a/cconv.c
+++ b/cconv.c
@@ -182,6 +182,8 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_state = le32_to_cpu(top->verify_state);
 	o->verify_interval = le32_to_cpu(top->verify_interval);
 	o->verify_offset = le32_to_cpu(top->verify_offset);
+	o->verify_write_sequence = le32_to_cpu(top->verify_write_sequence);
+	o->verify_header_seed = le32_to_cpu(top->verify_header_seed);
 
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
 	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
@@ -442,6 +444,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verify_state = cpu_to_le32(o->verify_state);
 	top->verify_interval = cpu_to_le32(o->verify_interval);
 	top->verify_offset = cpu_to_le32(o->verify_offset);
+	top->verify_write_sequence = cpu_to_le32(o->verify_write_sequence);
+	top->verify_header_seed = cpu_to_le32(o->verify_header_seed);
 	top->verify_pattern_bytes = cpu_to_le32(o->verify_pattern_bytes);
 	top->verify_fatal = cpu_to_le32(o->verify_fatal);
 	top->verify_dump = cpu_to_le32(o->verify_dump);
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 23bdd219..854788c1 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -33,6 +33,19 @@ main() {
 
     fi
 
+    # If we are running a nightly test just run the verify tests.
+    # Otherwise skip the verify test script because it takes so long.
+    if [ "${GITHUB_EVENT_NAME}" == "schedule" ]; then
+	args+=(
+	    --run-only
+	    1017
+	)
+    else
+	skip+=(
+	    1017
+	)
+    fi
+
     echo python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
     python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
     make -C doc html
diff --git a/filesetup.c b/filesetup.c
index cb42a852..50406c69 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1388,16 +1388,10 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
-	/*
-	 * iolog already set the total io size, if we read back
-	 * stored entries.
-	 */
-	if (!o->read_iolog_file) {
-		if (o->io_size)
-			td->total_io_size = o->io_size * o->loops;
-		else
-			td->total_io_size = o->size * o->loops;
-	}
+	if (o->io_size)
+		td->total_io_size = o->io_size * o->loops;
+	else
+		td->total_io_size = o->size * o->loops;
 
 done:
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
diff --git a/fio.1 b/fio.1
index 1581797a..0ea239b8 100644
--- a/fio.1
+++ b/fio.1
@@ -955,7 +955,9 @@ modifier with a value of 8. If the suffix is used with a sequential I/O
 pattern, then the `<nr>' value specified will be added to the generated
 offset for each I/O turning sequential I/O into sequential I/O with holes.
 For instance, using `rw=write:4k' will skip 4k for every write. Also see
-the \fBrw_sequencer\fR option.
+the \fBrw_sequencer\fR option. If this is used with \fBverify\fR then
+\fBverify_header_seed\fR option will be disabled, unless its explicitly
+enabled.
 .RE
 .TP
 .BI rw_sequencer \fR=\fPstr
@@ -1368,11 +1370,11 @@ Normally fio will cover every block of the file when doing random I/O. If
 this option is given, fio will just get a new random offset without looking
 at past I/O history. This means that some blocks may not be read or written,
 and that some blocks may be read/written more than once. If this option is
-used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
+used with \fBverify\fR then \fBverify_header_seed\fR will be disabled. If this
+option is used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
 only intact blocks are verified, i.e., partially-overwritten blocks are
-ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
-the same block to be overwritten, which can cause verification errors.  Either
-do not use norandommap in this case, or also use the lfsr random generator.
+ignored. With an async I/O engine and an I/O depth > 1, header write sequence
+number verification will be disabled. See \fBverify_write_sequence\fR.
 .TP
 .BI softrandommap \fR=\fPbool
 See \fBnorandommap\fR. If fio runs with the random block map enabled and
@@ -3544,7 +3546,9 @@ Do not perform specified workload, only verify data still matches previous
 invocation of this workload. This option allows one to check data multiple
 times at a later date without overwriting it. This option makes sense only
 for workloads that write data, and does not support workloads with the
-\fBtime_based\fR option set.
+\fBtime_based\fR option set. Options \fBverify_write_sequence\fR and
+\fBverify_header_seed\fR will be disabled in this mode, unless they are
+explicitly enabled.
 .TP
 .BI do_verify \fR=\fPbool
 Run the verify phase after a write phase. Only valid if \fBverify\fR is
@@ -3555,8 +3559,9 @@ If writing to a file, fio can verify the file contents after each iteration
 of the job. Each verification method also implies verification of special
 header, which is written to the beginning of each block. This header also
 includes meta information, like offset of the block, block number, timestamp
-when block was written, etc. \fBverify\fR can be combined with
-\fBverify_pattern\fR option. The allowed values are:
+when block was written, initial seed value used to generate the buffer
+contents, etc. \fBverify\fR can be combined with \fBverify_pattern\fR option.
+The allowed values are:
 .RS
 .RS
 .TP
@@ -3633,10 +3638,17 @@ Only pretend to verify. Useful for testing internals with
 .RE
 .P
 This option can be used for repeated burn\-in tests of a system to make sure
-that the written data is also correctly read back. If the data direction
-given is a read or random read, fio will assume that it should verify a
-previously written file. If the data direction includes any form of write,
-the verify will be of the newly written data.
+that the written data is also correctly read back.
+.P
+If the data direction given is a read or random read, fio will assume that it
+should verify a previously written file. In this scenario fio will not verify
+the block number written in the header. The header seed won't be verified,
+unless its explicitly requested by setting \fBverify_header_seed\fR option.
+Note in this scenario the header seed check will only work if the read
+invocation exactly matches the original write invocation.
+.P
+If the data direction includes any form of write, the verify will be of the
+newly written data.
 .P
 To avoid false verification errors, do not use the norandommap option when
 verifying data with async I/O engines and I/O depths > 1.  Or use the
@@ -3646,7 +3658,8 @@ same offset with multiple outstanding I/Os.
 .TP
 .BI verify_offset \fR=\fPint
 Swap the verification header with data somewhere else in the block before
-writing. It is swapped back before verifying.
+writing. It is swapped back before verifying. This should be within the range
+of \fBverify_interval\fR.
 .TP
 .BI verify_interval \fR=\fPint
 Write the verification header at a finer granularity than the
@@ -3752,6 +3765,13 @@ useful for testing atomic writes, as it means that checksum verification can
 still be attempted. For when \fBatomic\fR is enabled, checksum verification
 is expected to succeed (while write sequence checking can still fail).
 .TP
+.BI verify_header_seed \fR=\fPbool
+Verify the header seed value which was used to generate the buffer contents.
+In certain scenarios with read / verify only workloads, when \fBnorandommap\fR
+is enabled, with offset modifiers (refer options \fBreadwrite\fR and
+\fBrw_sequencer\fR), etc verification of header seed may fail. Disabling this
+option will mean that header seed checking is skipped. Defaults to true.
+.TP
 .BI trim_percentage \fR=\fPint
 Number of verify blocks to discard/trim.
 .TP
diff --git a/fio.h b/fio.h
index b8cf3229..d6423258 100644
--- a/fio.h
+++ b/fio.h
@@ -800,6 +800,15 @@ extern void lat_target_reset(struct thread_data *);
 	    	 (i) < (td)->o.nr_files && ((f) = (td)->files[i]) != NULL; \
 		 (i)++)
 
+static inline bool fio_offset_overlap_risk(struct thread_data *td)
+{
+	if (td->o.norandommap || td->o.softrandommap ||
+	    td->o.ddir_seq_add || (td->o.ddir_seq_nr > 1))
+		return true;
+
+	return false;
+}
+
 static inline bool fio_fill_issue_time(struct thread_data *td)
 {
 	if (td->o.read_iolog_file ||
diff --git a/init.c b/init.c
index 96a03d98..95f2179d 100644
--- a/init.c
+++ b/init.c
@@ -854,8 +854,47 @@ static int fixup_options(struct thread_data *td)
 			o->verify_interval = gcd(o->min_bs[DDIR_WRITE],
 							o->max_bs[DDIR_WRITE]);
 
-		if (td->o.verify_only)
-			o->verify_write_sequence = 0;
+		if (o->verify_only) {
+			if (!fio_option_is_set(o, verify_write_sequence))
+				o->verify_write_sequence = 0;
+
+			if (!fio_option_is_set(o, verify_header_seed))
+				o->verify_header_seed = 0;
+		}
+
+		if (o->norandommap && !td_ioengine_flagged(td, FIO_SYNCIO) &&
+		    o->iodepth > 1) {
+			/*
+			 * Disable write sequence checks with norandommap and
+			 * iodepth > 1.
+			 * Unless we were explicitly asked to enable it.
+			 */
+			if (!fio_option_is_set(o, verify_write_sequence))
+				o->verify_write_sequence = 0;
+		}
+
+		/*
+		 * Verify header should not be offset beyond the verify
+		 * interval.
+		 */
+		if (o->verify_offset + sizeof(struct verify_header) >
+		    o->verify_interval) {
+			log_err("fio: cannot offset verify header beyond the "
+				"verify interval.\n");
+			ret |= 1;
+		}
+
+		/*
+		 * Disable rand_seed check when we have verify_backlog,
+		 * zone reset frequency for zonemode=zbd, or if we are using
+		 * an RB tree for IO history logs.
+		 * Unless we were explicitly asked to enable it.
+		 */
+		if (!td_write(td) || (td->flags & TD_F_VER_BACKLOG) ||
+		    o->zrf.u.f || fio_offset_overlap_risk(td)) {
+			if (!fio_option_is_set(o, verify_header_seed))
+				o->verify_header_seed = 0;
+		}
 	}
 
 	if (td->o.oatomic) {
diff --git a/iolog.c b/iolog.c
index ef173b09..dcf6083c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -301,11 +301,12 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	}
 
 	/*
-	 * Only sort writes if we don't have a random map in which case we need
-	 * to check for duplicate blocks and drop the old one, which we rely on
-	 * the rb insert/lookup for handling.
+	 * Sort writes if we don't have a random map in which case we need to
+	 * check for duplicate blocks and drop the old one, which we rely on
+	 * the rb insert/lookup for handling. Sort writes if we have offset
+	 * modifier which can also create duplicate blocks.
 	 */
-	if (file_randommap(td, ipo->file)) {
+	if (!fio_offset_overlap_risk(td)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
diff --git a/options.c b/options.c
index c35878f7..416bc91c 100644
--- a/options.c
+++ b/options.c
@@ -3408,6 +3408,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_header_seed",
+		.lname	= "Verify header seed",
+		.off1	= offsetof(struct thread_options, verify_header_seed),
+		.type	= FIO_OPT_BOOL,
+		.def	= "1",
+		.help	= "Verify the header seed used to generate the buffer contents",
+		.parent	= "verify",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
 #ifdef FIO_HAVE_TRIM
 	{
 		.name	= "trim_percentage",
diff --git a/server.h b/server.h
index 449c18cf..e5968112 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 107,
+	FIO_SERVER_VER			= 109,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
index f5012c82..9003b4c1 100644
--- a/t/fiotestcommon.py
+++ b/t/fiotestcommon.py
@@ -19,6 +19,11 @@ SUCCESS_DEFAULT = {
     'stderr_empty': True,
     'timeout': 600,
     }
+SUCCESS_LONG = {
+    'zero_return': True,
+    'stderr_empty': True,
+    'timeout': 1800,
+    }
 SUCCESS_NONZERO = {
     'zero_return': False,
     'stderr_empty': False,
@@ -101,7 +106,7 @@ class Requirements():
         Requirements._unittests = os.path.exists(unittest_path)
 
         Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
-        Requirements._nvmecdev = args.nvmecdev
+        Requirements._nvmecdev = args.nvmecdev if hasattr(args, 'nvmecdev') else False
 
         req_list = [
                 Requirements.linux,
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 61adca14..913cb605 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -139,7 +139,7 @@ class FioExeTest(FioTest):
         if 'stderr_empty' in self.success:
             if self.success['stderr_empty']:
                 if stderr_size != 0:
-                    self.failure_reason = f"{self.failure_reason} stderr not empty,"
+                    self.failure_reason = f"{self.failure_reason} stderr not empty size {stderr_size},"
                     self.passed = False
             else:
                 if stderr_size == 0:
@@ -260,12 +260,13 @@ class FioJobFileTest(FioExeTest):
             return
 
         #
-        # Sometimes fio informational messages are included at the top of the
-        # JSON output, especially under Windows. Try to decode output as JSON
-        # data, skipping everything until the first {
+        # Sometimes fio informational messages are included outside the JSON
+        # output, especially under Windows. Try to decode output as JSON data,
+        # skipping outside the first { and last }
         #
         lines = file_data.splitlines()
-        file_data = '\n'.join(lines[lines.index("{"):])
+        last = len(lines) - lines[::-1].index("}")
+        file_data = '\n'.join(lines[lines.index("{"):last])
         try:
             self.json_data = json.loads(file_data)
         except json.JSONDecodeError:
@@ -320,12 +321,13 @@ class FioJobCmdTest(FioExeTest):
             file_data = file.read()
 
         #
-        # Sometimes fio informational messages are included at the top of the
-        # JSON output, especially under Windows. Try to decode output as JSON
-        # data, skipping everything until the first {
+        # Sometimes fio informational messages are included outside the JSON
+        # output, especially under Windows. Try to decode output as JSON data,
+        # skipping outside the first { and last }
         #
         lines = file_data.splitlines()
-        file_data = '\n'.join(lines[lines.index("{"):])
+        last = len(lines) - lines[::-1].index("}")
+        file_data = '\n'.join(lines[lines.index("{"):last])
         try:
             self.json_data = json.loads(file_data)
         except json.JSONDecodeError:
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 101e95f7..7ceda067 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1107,6 +1107,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux],
     },
+    {
+        'test_id':          1017,
+        'test_class':       FioExeTest,
+        'exe':              't/verify.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_LONG,
+        'requirements':     [],
+    },
 ]
 
 
diff --git a/t/verify.py b/t/verify.py
new file mode 100755
index 00000000..e48bad28
--- /dev/null
+++ b/t/verify.py
@@ -0,0 +1,803 @@
+#!/usr/bin/env python3
+"""
+# verify.py
+#
+# Test fio's verify options.
+#
+# USAGE
+# see python3 verify.py --help
+#
+# EXAMPLES
+# python3 t/verify.py
+# python3 t/verify.py --fio ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# - 4 CPUs
+#
+"""
+import os
+import sys
+import time
+import errno
+import logging
+import argparse
+import platform
+import itertools
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_DEFAULT, SUCCESS_NONZERO, Requirements
+
+
+VERIFY_OPT_LIST = [
+    'direct',
+    'iodepth',
+    'filesize',
+    'bs',
+    'time_based',
+    'runtime',
+    'io_size',
+    'offset',
+    'number_ios',
+    'output-format',
+    'directory',
+    'norandommap',
+    'numjobs',
+    'nrfiles',
+    'openfiles',
+    'cpus_allowed',
+    'fallocate',
+    'experimental_verify',
+    'verify_backlog',
+    'verify_backlog_batch',
+    'verify_interval',
+    'verify_offset',
+    'verify_async',
+    'verify_async_cpus',
+    'verify_pattern',
+    'verify_only',
+]
+
+class VerifyTest(FioJobCmdTest):
+    """
+    Verify test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=verify",
+            "--fallocate=truncate",
+            f"--ioengine={self.fio_opts['ioengine']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--verify={self.fio_opts['verify']}",
+            f"--output={self.filenames['output']}",
+        ]
+        for opt in VERIFY_OPT_LIST:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+
+        if not self.passed:
+            with open(self.filenames['stderr'], "r") as se:
+                contents = se.read()
+                logging.info("stderr: %s", contents)
+
+            with open(self.filenames['stdout'], "r") as so:
+                contents = so.read()
+                logging.info("stdout: %s", contents)
+
+            with open(self.filenames['output'], "r") as out:
+                contents = out.read()
+                logging.info("output: %s", contents)
+
+class VerifyCSUMTest(FioJobCmdTest):
+    """
+    Verify test class. Run standard verify jobs, modify the data, and then run
+    more verify jobs. Hopefully fio will detect that the data has chagned.
+    """
+
+    @staticmethod
+    def add_verify_opts(opt_list, adds):
+        """Add optional options."""
+
+        fio_opts = []
+
+        for opt in adds:
+            if opt in opt_list:
+                option = f"--{opt}={opt_list[opt]}"
+                fio_opts.append(option)
+
+        return fio_opts
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        logging.debug("ioengine is %s", self.fio_opts['ioengine'])
+        fio_args_base = [
+            "--fallocate=truncate",
+            "--filename=verify",
+            "--stonewall",
+            f"--ioengine={self.fio_opts['ioengine']}",
+        ]
+
+        extra_options = self.add_verify_opts(self.fio_opts, VERIFY_OPT_LIST)
+
+        verify_only = [
+            "--verify_only",
+            f"--rw={self.fio_opts['rw']}",
+            f"--verify={self.fio_opts['verify']}",
+        ] + fio_args_base + extra_options
+
+        verify_read = [
+            "--rw=randread" if 'rand' in self.fio_opts['rw'] else "--rw=read",
+            f"--verify={self.fio_opts['verify']}",
+        ] + fio_args_base + extra_options
+
+        layout = [
+            "--name=layout",
+            f"--rw={self.fio_opts['rw']}",
+            f"--verify={self.fio_opts['verify']}",
+        ] + fio_args_base + extra_options
+
+        success_only = ["--name=success_only"] + verify_only
+        success_read = ["--name=success_read"] + verify_read
+
+        mangle = [
+            "--name=mangle",
+            "--rw=randwrite",
+            "--randrepeat=0",
+            f"--bs={self.fio_opts['mangle_bs']}",
+            "--number_ios=1",
+        ] + fio_args_base + self.add_verify_opts(self.fio_opts, ['filesize'])
+
+        failure_only = ["--name=failure_only"] + verify_only
+        failure_read = ["--name=failure_read"] + verify_read
+
+        fio_args = layout + success_only + success_read + mangle + failure_only + failure_read + [f"--output={self.filenames['output']}"]
+        logging.debug("fio_args: %s", fio_args)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+
+        checked = {}
+
+        for job in self.json_data['jobs']:
+            if job['jobname'] == 'layout':
+                checked[job['jobname']] = True
+                if job['error']:
+                    self.passed = False
+                    self.failure_reason += " layout job failed"
+            elif 'success' in job['jobname']:
+                checked[job['jobname']] = True
+                if job['error']:
+                    self.passed = False
+                    self.failure_reason += f" verify pass {job['jobname']} that should have succeeded actually failed"
+            elif job['jobname'] == 'mangle':
+                checked[job['jobname']] = True
+                if job['error']:
+                    self.passed = False
+                    self.failure_reason += " mangle job failed"
+            elif 'failure' in job['jobname']:
+                checked[job['jobname']] = True
+                if self.fio_opts['verify'] == 'null' and not job['error']:
+                    continue
+                if job['error'] != errno.EILSEQ:
+                    self.passed = False
+                    self.failure_reason += f" verify job {job['jobname']} produced {job['error']} instead of errno {errno.EILSEQ} Illegal byte sequence"
+                    logging.debug(self.json_data)
+            else:
+                self.passed = False
+                self.failure_reason += " unknown job name"
+
+        if len(checked) != 6:
+            self.passed = False
+            self.failure_reason += " six phases not completed"
+
+        with open(self.filenames['stderr'], "r") as se:
+            contents = se.read()
+            logging.debug("stderr: %s", contents)
+
+
+#
+# These tests exercise fio's decisions about verifying the sequence number and
+# random seed in the verify header.
+#
+TEST_LIST_HEADER = [
+    {
+        # Basic test with options at default values
+        "test_id": 2000,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test with iodepth 16
+        "test_id": 2001,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "iodepth": 16,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test with 3 files
+        "test_id": 2002,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "nrfiles": 3,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test with iodepth 16 and 3 files
+        "test_id": 2003,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "iodepth": 16,
+            "nrfiles": 3,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+]
+
+#
+# These tests are mainly intended to assess the checksum functions. They write
+# out data, run some verify jobs, then modify the data, and try to verify the
+# data again, expecting to see failures.
+#
+TEST_LIST_CSUM = [
+    {
+        # basic seq write verify job
+        "test_id": 1000,
+        "fio_opts": {
+            "ioengine": "psync",
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "write",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic rand write verify job
+        "test_id": 1001,
+        "fio_opts": {
+            "ioengine": "psync",
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "randwrite",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic libaio seq write test
+        "test_id": 1002,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 16,
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "write",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic libaio rand write test
+        "test_id": 1003,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 16,
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "randwrite",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+]
+
+#
+# These tests are run for all combinations of data direction and checksum
+# methods.
+#
+TEST_LIST = [
+    {
+        # norandommap with verify backlog
+        "test_id": 1,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "2M",
+            "norandommap": 1,
+            "bs": 512,
+            "time_based": 1,
+            "runtime": 3,
+            "verify_backlog": 128,
+            "verify_backlog_batch": 64,
+            },
+        "test_class": VerifyTest,
+    },
+    {
+        # norandommap with verify offset and interval
+        "test_id": 2,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "2M",
+            "io_size": "4M",
+            "norandommap": 1,
+            "bs": 4096,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            },
+        "test_class": VerifyTest,
+    },
+    {
+        # norandommap with verify offload to async threads
+        "test_id": 3,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "2M",
+            "norandommap": 1,
+            "bs": 4096,
+            "cpus_allowed": "0-3",
+            "verify_async": 2,
+            "verify_async_cpus": "0-1",
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        # tausworthe combine all verify options
+        "test_id": 4,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "4M",
+            "bs": 4096,
+            "cpus_allowed": "0-3",
+            "time_based": 1,
+            "random_generator": "tausworthe",
+            "runtime": 3,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            "verify_backlog": 128,
+            "verify_backlog_batch": 128,
+            "verify_async": 2,
+            "verify_async_cpus": "0-1",
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        # norandommap combine all verify options
+        "test_id": 5,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "4M",
+            "norandommap": 1,
+            "bs": 4096,
+            "cpus_allowed": "0-3",
+            "time_based": 1,
+            "runtime": 3,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            "verify_backlog": 128,
+            "verify_backlog_batch": 128,
+            "verify_async": 2,
+            "verify_async_cpus": "0-1",
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        # multiple jobs and files with verify
+        "test_id": 6,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "512K",
+            "nrfiles": 3,
+            "openfiles": 2,
+            "numjobs": 2,
+            "norandommap": 1,
+            "bs": 4096,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            "verify_backlog": 16,
+            "verify_backlog_batch": 16,
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,],
+        # Skip this test on macOS because it is flaky. With rw=write it can
+        # fail to complete even after 10min which prevents the rw=read instance
+        # from passing because the read instance depends on the file created by
+        # the write instance. See failure here:
+        # https://github.com/vincentkfu/fio/actions/runs/13683127191/job/38260091800#step:14:258
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-r', '--fio-root', help='fio root path')
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-c', '--complete', help='Enable all checksums', action='store_true')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
+    parser.add_argument('--csum', nargs='+', type=str,
+                        help='list of checksum methods to use, skipping all others')
+    args = parser.parse_args()
+
+    return args
+
+
+def verify_test_header(test_env, args, csum, mode, sequence):
+    """
+    Adjust test arguments based on values of mode and sequence. Then run the
+    tests. This function is intended to run a set of tests that test
+    conditions under which the header random seed and sequence number are
+    checked.
+
+    The result should be a matrix with these combinations:
+        {write, write w/verify_only, read/write, read/write w/verify_only, read} x
+        {sequential, random w/randommap, random w/norandommap, sequence modifiers}
+    """
+    for test in TEST_LIST_HEADER:
+        # experimental_verify does not work in verify_only=1 mode
+        if "_vo" in mode and 'experimental_verify' in test['fio_opts'] and \
+        test['fio_opts']['experimental_verify']:
+            test['force_skip'] = True
+        else:
+            test['force_skip'] = False
+
+        test['fio_opts']['verify'] = csum
+        if csum == 'pattern':
+            test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+        else:
+            test['fio_opts'].pop('verify_pattern', None)
+
+        if 'norandommap' in sequence:
+            test['fio_opts']['norandommap'] = 1
+        else:
+            test['fio_opts']['norandommap'] = 0
+
+        if 'randommap' in sequence:
+            prefix = "rand"
+        else:
+            prefix = ""
+
+        if 'sequence_modifier' in sequence:
+            suffix = ":4096"
+        else:
+            suffix = ""
+
+        if 'readwrite' in mode:
+            fio_ddir = 'rw'
+        elif 'write' in mode:
+            fio_ddir = 'write'
+        elif 'read' in mode:
+            fio_ddir = 'read'
+        else:
+            fio_ddir = ""
+            # TODO throw an exception here
+        test['fio_opts']['rw'] = prefix + fio_ddir + suffix
+        logging.debug("ddir is %s", test['fio_opts']['rw'])
+
+        if '_vo' in mode:
+            vo = 1
+        else:
+            vo = 0
+        test['fio_opts']['verify_only'] = vo
+
+        # For 100% read workloads we need to read a file that was written with
+        # verify enabled. Use a previous test case for this by pointing fio to
+        # write to a file in a specific directory.
+        #
+        # For verify_only tests we also need to point fio to a file that was
+        # written with verify enabled
+        if mode == 'read':
+            directory = os.path.join(test_env['artifact_root'].replace(f'mode_{mode}','mode_write'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+        elif vo:
+            directory = os.path.join(test_env['artifact_root'].replace('write_vo','write'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+        else:
+            test['fio_opts'].pop('directory', None)
+
+    return run_fio_tests(TEST_LIST_HEADER, test_env, args)
+
+
+MANGLE_JOB_BS = 0
+def verify_test_csum(test_env, args, mbs, csum):
+    """
+    Adjust test arguments based on values of csum. Then run the tests.
+    This function is designed for a series of tests that check that checksum
+    methods can reliably detect data integrity issues.
+    """
+    for test in TEST_LIST_CSUM:
+        test['force_skip'] = False
+        test['fio_opts']['verify'] = csum
+
+        if csum == 'pattern':
+            test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+        else:
+            test['fio_opts'].pop('verify_pattern', None)
+
+        if mbs == MANGLE_JOB_BS:
+            test['fio_opts']['mangle_bs'] = test['fio_opts']['bs']
+        else:
+            test['fio_opts']['mangle_bs'] = mbs
+
+        # These tests produce verification failures but not when verify=null,
+        # so adjust the success criterion.
+        if csum == 'null':
+            test['success'] = SUCCESS_DEFAULT
+        else:
+            test['success'] = SUCCESS_NONZERO
+
+    return run_fio_tests(TEST_LIST_CSUM, test_env, args)
+
+
+def verify_test(test_env, args, ddir, csum):
+    """
+    Adjust test arguments based on values of ddir and csum.  Then run
+    the tests.
+    """
+    for test in TEST_LIST:
+        test['force_skip'] = False
+
+        test['fio_opts']['rw'] = ddir
+        test['fio_opts']['verify'] = csum
+
+        if csum == 'pattern':
+            test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+        else:
+            test['fio_opts'].pop('verify_pattern', None)
+
+        # For 100% read data directions we need the write file that was written with
+        # verify enabled. Use a previous test case for this by telling fio to
+        # write to a file in a specific directory.
+        if ddir == 'read':
+            directory = os.path.join(test_env['artifact_root'].replace(f'ddir_{ddir}','ddir_write'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+        elif ddir == 'randread':
+            directory = os.path.join(test_env['artifact_root'].replace(f'ddir_{ddir}','ddir_randwrite'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+        else:
+            test['fio_opts'].pop('directory', None)
+
+    return run_fio_tests(TEST_LIST, test_env, args)
+
+
+# 100% read workloads below must follow write workloads so that the 100% read
+# workloads will be reading data written with verification enabled.
+DDIR_LIST = [
+        'write',
+        'readwrite',
+        'read',
+        'randwrite',
+        'randrw',
+        'randread',
+             ]
+CSUM_LIST1 = [
+        'md5',
+        'crc64',
+        'pattern',
+             ]
+CSUM_LIST2 = [
+        'md5',
+        'crc64',
+        'crc32c',
+        'crc32c-intel',
+        'crc16',
+        'crc7',
+        'xxhash',
+        'sha512',
+        'sha256',
+        'sha1',
+        'sha3-224',
+        'sha3-384',
+        'sha3-512',
+        'pattern',
+        'null',
+             ]
+
+def main():
+    """
+    Run tests for fio's verify feature.
+    """
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"verify-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    if args.fio_root:
+        fio_root = args.fio_root
+    else:
+        fio_root = str(Path(__file__).absolute().parent.parent)
+    print(f"fio root is {fio_root}")
+
+    if not args.skip_req:
+        Requirements(fio_root, args)
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'verify',
+              }
+
+    if platform.system() == 'Linux':
+        aio = 'libaio'
+        sync = 'psync'
+    elif platform.system() == 'Windows':
+        aio = 'windowsaio'
+        sync = 'sync'
+    else:
+        aio = 'posixaio'
+        sync = 'psync'
+    for test in TEST_LIST:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
+    for test in TEST_LIST_CSUM:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
+    for test in TEST_LIST_HEADER:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    if args.complete:
+        csum_list = CSUM_LIST2
+    else:
+        csum_list = CSUM_LIST1
+
+    if args.csum:
+        csum_list = args.csum
+
+    try:
+        for ddir, csum in itertools.product(DDIR_LIST, csum_list):
+            print(f"\nddir: {ddir}, checksum: {csum}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                                                     f"ddir_{ddir}_csum_{csum}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test(test_env, args, ddir, csum)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+        # MANGLE_JOB_BS means to mangle an entire block which should result in
+        #  a header magic number error
+        # 4 means to mangle 4 bytes which should result in a checksum error
+        #  unless the 4 bytes occur in the verification header
+        mangle_bs = [MANGLE_JOB_BS, 4]
+        for mbs, csum in itertools.product(mangle_bs, csum_list):
+            print(f"\nmangle block size: {mbs}, checksum: {csum}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                                                     f"mbs_{mbs}_csum_{csum}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test_csum(test_env, args, mbs, csum)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+        # The loop below tests combinations of options that exercise fio's
+        # decisions about disabling checks for the sequence number and random
+        # seed in the verify header.
+        mode_list = [ "write", "write_vo", "readwrite", "readwrite_vo", "read" ]
+        sequence_list = [ "sequential", "randommap", "norandommap", "sequence_modifier" ]
+        for mode, sequence in itertools.product(mode_list, sequence_list):
+            print(f"\nmode: {mode}, sequence: {sequence}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                                                     f"mode_{mode}_seq_{sequence}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test_header(test_env, args, 'md5', mode, sequence)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+    except KeyboardInterrupt:
+        pass
+
+    print(f"\n\n{total['passed']} test(s) passed, {total['failed']} failed, " \
+            f"{total['skipped']} skipped")
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
diff --git a/thread_options.h b/thread_options.h
index d0e0a4ae..d25ba891 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -157,6 +157,7 @@ struct thread_options {
 	unsigned int verify_state;
 	unsigned int verify_state_save;
 	unsigned int verify_write_sequence;
+	unsigned int verify_header_seed;
 	unsigned int use_thread;
 	unsigned int unlink;
 	unsigned int unlink_each_loop;
@@ -484,6 +485,8 @@ struct thread_options_pack {
 	uint32_t experimental_verify;
 	uint32_t verify_state;
 	uint32_t verify_state_save;
+	uint32_t verify_write_sequence;
+	uint32_t verify_header_seed;
 	uint32_t use_thread;
 	uint32_t unlink;
 	uint32_t unlink_each_loop;
diff --git a/verify.c b/verify.c
index 570c888f..928bdd54 100644
--- a/verify.c
+++ b/verify.c
@@ -833,7 +833,7 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 			hdr->len, hdr_len);
 		goto err;
 	}
-	if (hdr->rand_seed != io_u->rand_seed) {
+	if (td->o.verify_header_seed && (hdr->rand_seed != io_u->rand_seed)) {
 		log_err("verify: bad header rand_seed %"PRIu64
 			", wanted %"PRIu64,
 			hdr->rand_seed, io_u->rand_seed);
@@ -934,14 +934,6 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			memswp(p, p + td->o.verify_offset, header_size);
 		hdr = p;
 
-		/*
-		 * Make rand_seed check pass when have verify_backlog or
-		 * zone reset frequency for zonemode=zbd.
-		 */
-		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
-		    td->o.zrf.u.f)
-			io_u->rand_seed = hdr->rand_seed;
-
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
 			ret = verify_header(io_u, td, hdr, hdr_num, hdr_inc);
 			if (ret)
