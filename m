Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819333AD538
	for <fio@vger.kernel.org>; Sat, 27 Jun 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782561611; cv=none; b=K3ooWvng/9NoNNZ6Bt7ySCddwtVLqFqVE18RMJeTCETIo1Nmnr7q/qr08jxdSPtcLXmy85rlW/icaYDgWk/mZ5IbRGlQq80f5B8tA7Lvai8bJduUzk4u7KRhcc/Ndzm3WavGooU0sSUnBD7ozvAP5tUle7o3gL244RTUVVQyPh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782561611; c=relaxed/simple;
	bh=9S2Rwr1Iozvg3UUwTZsZyh9PM4tYQVT+F8gJO4aRP9k=;
	h=Subject:From:To:Date:Message-Id; b=ZLoSI4UNaIMCmy7ftNKVlJH0RMeQgoagYHURnG14X4ZFlN+oAIQ+rh37QO7ShIe1DieigW8TSOXfUaVjETzNzqabYXG0d88b0mglAhvQkF/n3AKUM26/LHWSqgcWSjgeUlKb7h0m0Hbkw1vuyR8odJMt6e936Fi4NsU4HBIOuNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ihESeF9K; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ihESeF9K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=tD5B5UamEbAQuWgQWWyC62+ruxFZ3hOzi6cJ2ulJXWo=; b=ihESeF9K3DZOVtdMCpE4/Xq8CS
	CpjhobOnP8w5p8tu99mXji/kx/KogA28OfzUjtfJJ1GQFT/EA4yn6OBQSsE9WshNcg55z0EITh1u1
	PAviyK/mprBUceNPiOh6PvYTfB7xJOqVlOgJVbph/oxNaKnWubBh2SRMS2sRwZLuW32o1l0EQ+MZD
	SmEe3EPPoymqjw517n5q2/LOi9PxBWcL3TcfbEBx4Vmyxa2B2RyHobbRum83LLE+dzV9UinZNuI/k
	UpP4CA/O2NyWGdh0l1d2wBTb7yQ5cUS3TJzsu4kn9YGwNeEnGqux/cTFE5SshIFGn19EufqaC0cfm
	Q8Vp9T8A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wdRhd-00000000GQ1-0Jcx
	for fio@vger.kernel.org;
	Sat, 27 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 388C81BC01B9; Sat, 27 Jun 2026 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 27 Jun 2026 06:00:02 -0600
Message-Id: <20260627120002.388C81BC01B9@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 360e4d6ae2fafcb17438df45499e514406f4d746:

  Merge branch 'master' of https://github.com/Krien/fio (2026-06-25 12:54:29 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 855d7e24e4188a357a150a7569c3150267106630:

  t/run-fio-tests: add t/sequence.py (2026-06-26 12:35:04 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      Merge branch 'rand_dist' of https://github.com/vadlakondaswetha/fio
      t/run-fio-tests: add t/sequence.py

vadlakondaswetha (1):
      Implement Sequence Distribution feature with Striding

 HOWTO.rst                          |  21 ++++++
 cconv.c                            |  22 ++++++
 examples/sequence-distribution.fio |  38 ++++++++++
 fio.1                              |  23 ++++++
 fio.h                              |   1 +
 io_u.c                             |  36 ++++++++++
 options.c                          |  94 ++++++++++++++++++++++++
 t/run-fio-tests.py                 |   8 +++
 t/sequence.py                      | 143 +++++++++++++++++++++++++++++++++++++
 thread_options.h                   |   7 ++
 10 files changed, 393 insertions(+)
 create mode 100644 examples/sequence-distribution.fio
 create mode 100755 t/sequence.py

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index f4663003..ece92563 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1572,6 +1572,9 @@ I/O type
 		**zoned_abs**
 				Zone absolute random distribution
 
+		**sequence**
+				Fixed deterministic sequence of block indices
+
 	When using a **zipf** or **pareto** distribution, an input value is also
 	needed to define the access pattern. For **zipf**, this is the `Zipf
 	theta`. For **pareto**, it's the `Pareto power`. Fio includes a test
@@ -1625,6 +1628,24 @@ I/O type
 	is given, it'll apply to all of them. This goes for both **zoned**
 	**zoned_abs** distributions.
 
+	For a **sequence** distribution, fio supports specifying a fixed deterministic
+	sequence of block indices to be accessed. For example, to access block indices
+	2, 0, and 1 in that exact order, the user would do::
+
+		random_distribution=sequence:2,0,1
+
+	This repeats the block access pattern indefinitely. Up to 64 sequence
+	elements are supported.
+
+.. option:: random_sequence_stride=bool
+
+	Controls the progression behavior of the ``sequence`` random distribution mode.
+	If set to false (0, default), the sequence is interpreted as fixed, absolute block
+	indices and repeated exactly. If set to true (1), the sequence is interpreted as a
+	relative pattern within a moving block group. After completing each full cycle of
+	the sequence, the base block index automatically advances by the sequence length,
+	creating a progressing "Strided Block Group" pattern across the file.
+
 .. option:: percentage_random=int[,int][,int]
 
 	For a random workload, set how big a percentage should be random. This
diff --git a/cconv.c b/cconv.c
index 753c55ab..ac4208e3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -56,6 +56,10 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 		free(o->bssplit[i]);
 		free(o->zone_split[i]);
 	}
+	if (o->random_sequence) {
+		free(o->random_sequence);
+		o->random_sequence = NULL;
+	}
 }
 
 size_t thread_options_pack_size(struct thread_options *o)
@@ -240,6 +244,13 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
 	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
 	o->random_distribution = le32_to_cpu(top->random_distribution);
+	o->random_sequence_nr = le32_to_cpu(top->random_sequence_nr);
+	if (o->random_sequence_nr) {
+		o->random_sequence = malloc(o->random_sequence_nr * sizeof(unsigned int));
+		for (j = 0; j < o->random_sequence_nr; j++)
+			o->random_sequence[j] = le32_to_cpu(top->random_sequence[j]);
+	}
+	o->random_sequence_stride = le32_to_cpu(top->random_sequence_stride);
 	o->exitall_error = le32_to_cpu(top->exitall_error);
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
@@ -497,6 +508,17 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
 	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
 	top->random_distribution = cpu_to_le32(o->random_distribution);
+	top->random_sequence_nr = cpu_to_le32(o->random_sequence_nr);
+	if (o->random_sequence_nr) {
+		unsigned int seq_nr = o->random_sequence_nr;
+		if (seq_nr > FIO_SEQ_MAX) {
+			log_err("fio: FIO_SEQ_MAX is too small\n");
+			seq_nr = FIO_SEQ_MAX;
+		}
+		for (j = 0; j < seq_nr; j++)
+			top->random_sequence[j] = cpu_to_le32(o->random_sequence[j]);
+	}
+	top->random_sequence_stride = cpu_to_le32(o->random_sequence_stride);
 	top->exitall_error = cpu_to_le32(o->exitall_error);
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
diff --git a/examples/sequence-distribution.fio b/examples/sequence-distribution.fio
new file mode 100644
index 00000000..f45f2fc4
--- /dev/null
+++ b/examples/sequence-distribution.fio
@@ -0,0 +1,38 @@
+# This job file demonstrates the use of the 'sequence' random distribution.
+# The 'sequence' distribution allows you to specify a precise, deterministic
+# order of block indices to be accessed during a non-sequential workload.
+#
+# See HOWTO.rst for full documentation.
+
+[global]
+ioengine=null
+rw=randread
+bs=4k
+size=48k
+io_size=24k
+
+# ==============================================================================
+# Job 1: Fixed Repeating Sequence
+# ==============================================================================
+# With random_sequence_stride=0 (default), fio repeats the absolute block
+# indices (2, then 0, then 1) over and over until io_size is reached.
+#
+# Accessed block indices: 2, 0, 1, 2, 0, 1
+[repeating_sequence]
+random_distribution=sequence:2,0,1
+random_sequence_stride=0
+
+# ==============================================================================
+# Job 2: Progressing Strided Sequence
+# ==============================================================================
+# With random_sequence_stride=1, the sequence is treated as a relative pattern
+# inside a moving block group. After each cycle, the base index advances by
+# the length of the sequence, scanning through the file.
+#
+# Accessed block indices:
+# - Cycle 1 (Group 0): 2, 0, 1
+# - Cycle 2 (Group 1): 5, 3, 4
+[strided_sequence]
+stonewall
+random_distribution=sequence:2,0,1
+random_sequence_stride=1
diff --git a/fio.1 b/fio.1
index 13bc01de..fa281caa 100644
--- a/fio.1
+++ b/fio.1
@@ -1350,8 +1350,12 @@ Normal (Gaussian) distribution
 .TP
 .B zoned
 Zoned random distribution
+.TP
 .B zoned_abs
 Zoned absolute random distribution
+.TP
+.B sequence
+Fixed deterministic sequence of block indices
 .RE
 .P
 When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
@@ -1422,8 +1426,27 @@ Similarly to how \fBbssplit\fR works for setting ranges and percentages
 of block sizes. Like \fBbssplit\fR, it's possible to specify separate
 zones for reads, writes, and trims. If just one set is given, it'll apply to
 all of them.
+.P
+For a \fBsequence\fR distribution, fio supports specifying a fixed deterministic
+sequence of block indices to be accessed. For example, to access block indices
+2, 0, and 1 in that exact order, the user would do:
+.RS
+.P
+random_distribution=sequence:2,0,1
+.RE
+.P
+This repeats the block access pattern indefinitely. Up to 64 sequence
+elements are supported.
 .RE
 .TP
+.BI random_sequence_stride \fR=\fPbool
+Controls the progression behavior of the \fBsequence\fR random distribution mode.
+If set to false (0, default), the sequence is interpreted as fixed, absolute block
+indices and repeated exactly. If set to true (1), the sequence is interpreted as a
+relative pattern within a moving block group. After completing each full cycle of
+the sequence, the base block index automatically advances by the sequence length,
+creating a progressing "Strided Block Group" pattern across the file.
+.TP
 .BI percentage_random \fR=\fPint[,int][,int]
 For a random workload, set how big a percentage should be random. This
 defaults to 100%, in which case the workload is fully random. It can be set
diff --git a/fio.h b/fio.h
index b05abf77..494959a6 100644
--- a/fio.h
+++ b/fio.h
@@ -968,6 +968,7 @@ enum {
 	FIO_RAND_DIST_GAUSS,
 	FIO_RAND_DIST_ZONED,
 	FIO_RAND_DIST_ZONED_ABS,
+	FIO_RAND_DIST_SEQUENCE,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/io_u.c b/io_u.c
index 5d704a33..9a7422bb 100644
--- a/io_u.c
+++ b/io_u.c
@@ -291,6 +291,40 @@ bail:
 	return 0;
 }
 
+static int __get_next_rand_offset_sequence(struct thread_data *td,
+					   struct fio_file *f, enum fio_ddir ddir,
+					   uint64_t *b)
+{
+	uint64_t io_count;
+	unsigned int idx;
+
+	if (!td->o.random_sequence_nr)
+		return 1;
+
+	io_count = td->io_issues[ddir];
+	idx = io_count % td->o.random_sequence_nr;
+
+	if (td->o.random_sequence_stride) {
+		uint64_t group_idx = io_count / td->o.random_sequence_nr;
+		*b = group_idx * td->o.random_sequence_nr + td->o.random_sequence[idx];
+	} else {
+		*b = td->o.random_sequence[idx];
+	}
+
+	if (f->io_size) {
+		uint64_t max_blocks = f->io_size / td->o.min_bs[ddir];
+		if (*b >= max_blocks) {
+			if (td->o.random_sequence[idx] >= max_blocks) {
+				log_err("fio: sequence access block %u in base pattern out of bounds (max %llu) for file %s\n",
+					td->o.random_sequence[idx], (unsigned long long) max_blocks, f->file_name);
+				td_verror(td, EINVAL, "sequence block out of bounds");
+			}
+			return 1;
+		}
+	}
+	return 0;
+}
+
 static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				enum fio_ddir ddir, uint64_t *b)
 {
@@ -314,6 +348,8 @@ static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 		return __get_next_rand_offset_zoned(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
 		return __get_next_rand_offset_zoned_abs(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_SEQUENCE)
+		return __get_next_rand_offset_sequence(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
diff --git a/options.c b/options.c
index 0df0f87f..a7535e5c 100644
--- a/options.c
+++ b/options.c
@@ -1340,6 +1340,67 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input,
 	return ret;
 }
 
+static int parse_sequence_distribution(struct thread_data *td, const char *input)
+{
+	char *str, *p, *n;
+	unsigned int i = 0;
+
+	p = str = get_opt_postfix(input);
+	if (!str) {
+		log_err("fio: missing pattern in sequence distribution\n");
+		return 1;
+	}
+
+	/* Count elements first to allocate memory */
+	td->o.random_sequence_nr = 1;
+	while ((n = strchr(p, ',')) != NULL) {
+		td->o.random_sequence_nr++;
+		p = n + 1;
+	}
+
+	if (td->o.random_sequence_nr > FIO_SEQ_MAX) {
+		log_err("fio: sequence distribution supports up to %d elements (got %d)\n",
+			FIO_SEQ_MAX, td->o.random_sequence_nr);
+		td->o.random_sequence_nr = 0;
+		free(str);
+		return 1;
+	}
+
+	if (td->o.random_sequence) {
+		free(td->o.random_sequence);
+		td->o.random_sequence = NULL;
+	}
+
+	td->o.random_sequence = malloc(td->o.random_sequence_nr * sizeof(unsigned int));
+	if (!td->o.random_sequence) {
+		free(str);
+		return 1;
+	}
+
+	p = str;
+	while ((n = strsep(&p, ",")) != NULL) {
+		size_t len;
+
+		strip_blank_front(&n);
+		strip_blank_end(n);
+		len = strlen(n);
+		if (len == 0 || strspn(n, "0123456789") != len) {
+			log_err("fio: invalid or negative element <%s> in random_sequence\n", n);
+			goto err;
+		}
+		td->o.random_sequence[i++] = atoi(n);
+	}
+
+	free(str);
+	return 0;
+err:
+	free(td->o.random_sequence);
+	td->o.random_sequence = NULL;
+	td->o.random_sequence_nr = 0;
+	free(str);
+	return 1;
+}
+
 static int str_random_distribution_cb(void *data, const char *str)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -1357,6 +1418,8 @@ static int str_random_distribution_cb(void *data, const char *str)
 		return parse_zoned_distribution(td, str, false);
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
 		return parse_zoned_distribution(td, str, true);
+	else if (td->o.random_distribution == FIO_RAND_DIST_SEQUENCE)
+		return parse_sequence_distribution(td, str);
 	else
 		return 0;
 
@@ -2811,10 +2874,24 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_DIST_ZONED_ABS,
 			    .help = "Zoned absolute random distribution",
 			  },
+			  { .ival = "sequence",
+			    .oval = FIO_RAND_DIST_SEQUENCE,
+			    .help = "Fixed sequence of blocks",
+			  },
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
+	{
+		.name	= "random_sequence_stride",
+		.lname	= "Random Sequence Stride",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, random_sequence_stride),
+		.help	= "Stride sequence of blocks for random distribution",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
 	{
 		.name	= "percentage_random",
 		.lname	= "Percentage Random",
@@ -6175,6 +6252,18 @@ void fio_options_mem_dupe(struct thread_data *td)
 {
 	options_mem_dupe(fio_options, &td->o);
 
+	if (td->o.random_sequence) {
+		unsigned int size = td->o.random_sequence_nr * sizeof(unsigned int);
+		unsigned int *seq = malloc(size);
+		if (seq) {
+			memcpy(seq, td->o.random_sequence, size);
+			td->o.random_sequence = seq;
+		} else {
+			td->o.random_sequence = NULL;
+			td->o.random_sequence_nr = 0;
+		}
+	}
+
 	if (td->o.ioengine_so_path)
 		td->o.ioengine_so_path = strdup(td->o.ioengine_so_path);
 
@@ -6287,6 +6376,11 @@ void del_opt_posval(const char *optname, const char *ival)
 void fio_options_free(struct thread_data *td)
 {
 	options_free(fio_options, &td->o);
+	if (td->o.random_sequence) {
+		free(td->o.random_sequence);
+		td->o.random_sequence = NULL;
+		td->o.random_sequence_nr = 0;
+	}
 	if (td->o.ioengine_so_path) {
 		free(td->o.ioengine_so_path);
 		td->o.ioengine_so_path = NULL;
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index aef2d026..47d1e65e 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1163,6 +1163,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1024,
+        'test_class':       FioExeTest,
+        'exe':              't/sequence.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
diff --git a/t/sequence.py b/t/sequence.py
new file mode 100755
index 00000000..c9224824
--- /dev/null
+++ b/t/sequence.py
@@ -0,0 +1,143 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+
+"""
+# sequence.py
+#
+# Test random_distribution=sequence and random_sequence_stride.
+#
+"""
+
+import os
+import sys
+import time
+import argparse
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+
+
+class SequenceTest(FioJobCmdTest):
+    """Test random_distribution=sequence."""
+
+    def setup(self, parameters):
+        fio_args = [
+                    "--name=sequence",
+                    "--rw=randread",
+                    f"--write_iops_log={self.filenames['iopslog']}",
+                    f"--output={self.filenames['output']}",
+                    f"--random_distribution=sequence:{self.fio_opts['random_sequence']}",
+                    f"--bs={self.fio_opts['bs']}",
+                    f"--size={self.fio_opts['size']}",
+                    f"--io_size={self.fio_opts['io_size']}",
+                    "--log_offset=1",
+                    "--ioengine=null",
+                   ]
+        if 'random_sequence_stride' in self.fio_opts:
+            fio_args.append(f"--random_sequence_stride={self.fio_opts['random_sequence_stride']}")
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+        if not self.passed:
+            return
+
+        seq_str = self.fio_opts['random_sequence']
+        expected_seq = [int(x) for x in seq_str.split(',')]
+        seq_len = len(expected_seq)
+        bs = self.fio_opts['bs']
+        stride = self.fio_opts.get('random_sequence_stride', 0)
+
+        lines = self.iops_log_lines.split('\n')
+        io_count = 0
+
+        for line in lines:
+            if len(line) == 0:
+                continue
+
+            tokens = line.split(',')
+            offset = int(tokens[4])
+
+            idx = io_count % seq_len
+            if stride:
+                group_idx = io_count // seq_len
+                expected_block = group_idx * seq_len + expected_seq[idx]
+            else:
+                expected_block = expected_seq[idx]
+
+            expected_offset = expected_block * bs
+
+            if offset != expected_offset:
+                print(f"IO {io_count}: Expected offset {expected_offset} (block {expected_block}), got {offset}")
+                self.passed = False
+                return
+
+            io_count += 1
+
+
+TEST_LIST = [
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "random_sequence": "2,0,1",
+            "bs": 4096,
+            "size": "48k",
+            "io_size": "24k",
+            "random_sequence_stride": 0,
+            },
+        "test_class": SequenceTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "random_sequence": "2,0,1",
+            "bs": 4096,
+            "size": "48k",
+            "io_size": "24k",
+            "random_sequence_stride": 1,
+            },
+        "test_class": SequenceTest,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    return parser.parse_args()
+
+
+def main():
+    """Run sequence tests."""
+    args = parse_args()
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"sequence-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'sequence',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/thread_options.h b/thread_options.h
index 65114dc9..45324b64 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -43,6 +43,7 @@ enum dedupe_mode {
 
 #define BSSPLIT_MAX	64
 #define ZONESPLIT_MAX	256
+#define FIO_SEQ_MAX	64
 
 struct split {
 	unsigned int nr;
@@ -191,6 +192,9 @@ struct thread_options {
 	unsigned int verify_only;
 
 	unsigned int random_distribution;
+	unsigned int *random_sequence;
+	unsigned int random_sequence_nr;
+	unsigned int random_sequence_stride;
 	unsigned int exitall_error;
 
 	struct zone_split *zone_split[DDIR_RWDIR_CNT];
@@ -529,6 +533,9 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
+	uint32_t random_sequence[FIO_SEQ_MAX];
+	uint32_t random_sequence_nr;
+	uint32_t random_sequence_stride;
 	uint32_t exitall_error;
 
 	uint32_t sync_file_range;
