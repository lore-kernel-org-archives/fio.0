Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593FF367F32
	for <fio@vger.kernel.org>; Wed,  6 May 2026 06:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778050533; cv=none; b=hbbCJ1nh2ElK6Ng8Cxs9CAzfVLmjK+SQJb29bDZ8FgOJEHDxd6KGrB5tNxHZlM37FmAGKjIlO5SHVQoPeOrzqpKmIuoXZe+mc1pMFUGc8yk+cvNzVEbxNNSNcGb6DbUOcz/7y+Q0ODddQrR1oLM8khbJZVSyviMYUBkAOY71pSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778050533; c=relaxed/simple;
	bh=Ks5jdtBvals1UjfBykwgbvfcuJMuESzvHZGhzv08r5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRhwPIVua6VuxFlYBErT/EbyDGLX3rbakz3Z9V3BpPKj1zXqsu8FgP8ws/cX/Ix5TOjQkWmRKa8sQET3j2EAhBVbY6Stc8Mu79jKFYj/QTMS6MoRWyWrtxOo6bGpVpI5fxBmoM28RfyoYIm9LwZzI9PbV5mL6h+TgOxRI1G9/Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nxxbv9/9; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxxbv9/9"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so4792766fac.2
        for <fio@vger.kernel.org>; Tue, 05 May 2026 23:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778050528; x=1778655328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6SQvk/yUyY1MP2jrtHJ8uzx2T5jEUIVs5idinoD0s+M=;
        b=nxxbv9/9LHXUHqEkuzKUptvevCVN1obiz69kgp952QZOzMEckgB4Tma5kQXhA4HL3y
         Vq8fLP7uH6JLSIMLbAPoyYj6/Y4IvE7Mr+TPJPpot/82Kr/p8DwzUSW/qNjN/JT6YAE9
         7NRQNl5IBnXIXNm7QneEX0TWLJdUbc8v4OPX3tR2H8+pH5oRpSD2nT+yPLoNutVjI1Y8
         5jv0iC3EYayEFtgXJ/hXn1cvAnQp/F1MNVqXvNK2gGePFEVGa3gL+YtEHnZPoCJiAGdS
         yB+WiTb0xJX+Fl/Tp5na2K6xAZW4KleWb/+kbJBGZi/FrNrUGZREUkeV99XZFUkFAMmB
         8T+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778050528; x=1778655328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SQvk/yUyY1MP2jrtHJ8uzx2T5jEUIVs5idinoD0s+M=;
        b=cZpKwA7vI3ZnKPv6ui3dv2zeahUe20Pl6EZwHCRL+TH9nYD/v9ZwkQZxbHznKYzkc8
         u1azCWelRbMjODIqehZ4XmE/tasPa8f+uqE8l7ealuLj6KihdUIdo6eFIhvfxl4NllA5
         /tgmzTmgMPf40sVHgkISdGLuN31uwtE33qD1ex+VEjK+OZdapmXeJrWzqBTuyIl3nKHT
         ZhFhljGQAA5f/Z+aHgNihvavOX4E7jvLq8vmDPDDF2ZDU3NvhrZONYlu29ag/QcTBYEQ
         FckXKAph/C2ohygJDU4NQew1+QFVMAOWKA4py4ifnfeYqZWlBN+4cNsP+aKV1QSTfHNv
         7O+w==
X-Gm-Message-State: AOJu0YzIVjqw0tI+8rFrPAKCsaZyf7b0cnCrK4PVLDD/BRvgo+fTPQ5W
	QmRAR57jGAXEfJxKcRl0Nl/JWyjV1IS1AQKCci0aGExUSNIZZ92h0oOY7l/lAs5EvwRj6w==
X-Gm-Gg: AeBDieuR/hTo5gvoo5ve0CXuNLHOohfI98rTDjjG2iERb56EQiExuE1aQcDVcpn4oaZ
	mRmmbhYOdV7OQB6eGNWN70x42OG8t7+zU+m6Wfgw8P2C/8Q2iNu0LZFODpMLWyqoEbBtQGkDDpG
	iVDWlWt4JH04LkLDzE0XpvnA26tzMHRKWQMt/MZgeY7BebCkj1pGdILR5dVDlJzfgEFe2ee/6qv
	LjJ8OGTrM8650yCPorgd3nw4Wqqi9/9WibpqlpJz74qXYLOuzazpuyn106viUuJNdV8GQROZySF
	2d8Ex79dcMkLxV+mTbROD92xFvD4DGH4pxunpual7t5KI6fC5yPNNsw0CkAja8Yaz3W6bE45HqO
	jgyChXHdH44HIl+9LL1S8pXJke4KIWVrQmRghYJe2STSJt0rDs+hAWOib8EKrdDvIG0cp3IeWMZ
	a5zhmu6Mh9tNbemO8QInePtPKeRkupZKKXz+BN/ily6EqMmCBmVRNeBkb8PdlWhX8lstqW1OzCr
	j/N3/F248XKKhEW5vqdF2UpS8ut3sDklKdP/+oV1t0=
X-Received: by 2002:a05:6870:16f5:b0:430:2e5:df03 with SMTP id 586e51a60fabf-434f672ee29mr1437867fac.34.1778050528461;
        Tue, 05 May 2026 23:55:28 -0700 (PDT)
Received: from swethv-cloudtop.c.googlers.com.com (34.143.29.34.bc.googleusercontent.com. [34.29.143.34])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-434549540b2sm16183262fac.6.2026.05.05.23.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 23:55:27 -0700 (PDT)
From: swethav0411@gmail.com
To: fio@vger.kernel.org
Cc: vadlakondaswetha <swethav0411@gmail.com>
Subject: [PATCH] added new type of random distribution
Date: Wed,  6 May 2026 06:55:07 +0000
Message-ID: <20260506065507.2858172-1-swethav0411@gmail.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: vadlakondaswetha <swethav0411@gmail.com>

This PR introduces a new generic random distribution primitive: sequence.

While fio currently provides excellent primitives for linear, pseudo-random
(randread), and strided access patterns, it lacks a mechanism to simulate
deterministic, local non-linearity within a repeating stride.

This access pattern has become a critical benchmark vector for modern
workloads, most notably:

*LLM Inference Weights Loading*
Reading .safetensors model files which contain a list of tensor files.
Even though the file is read in sequential mode, within a tensor, data 
will be requested out of order.

*Database Engine Log-Merging / LSM-Trees*
Scenarios where specific block indices (like parity blocks or metadata 
headers) must be systematically read out-of-order within every repeating 
chunk or block group.

Using a generated `read_iolog` for multi-terabyte model benchmarks is
sub-optimal as the trace files become massive, unscalable, and lack
dynamic flexibility across varying block sizes. The `sequence` 
distribution resolves this by calculating offsets algorithmically on 
the fly.

NEW OPTIONS INTRODUCED
----------------------

*random_distribution=sequence:N1,N2,N3*
Intercepts the random offset generator to utilize the pattern sequence.

*random_sequence_stride*
Boolean option to modify `sequence` distribution behavior. 
- When disabled (0, default), the sequence loops over absolute block 
  indices.
- When enabled (1), it switches to a Strided Block Group pattern, 
  advancing the base block index by the sequence length after each 
  cycle to progress through the file.

Signed-off-by: vadlakondaswetha <swethav0411@gmail.com>
---
 cconv.c          |  22 ++++++++
 fio.h            |   1 +
 io_u.c           |  24 ++++++++
 options.c        |  84 ++++++++++++++++++++++++++++
 t/sequence.py    | 140 +++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h |   7 +++
 6 files changed, 278 insertions(+)
 create mode 100644 t/sequence.py

diff --git a/cconv.c b/cconv.c
index 1c1b7273..c8e99f07 100644
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
@@ -239,6 +243,13 @@ int convert_thread_options_to_cpu(struct thread_options *o,
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
@@ -495,6 +506,17 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
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
diff --git a/fio.h b/fio.h
index 18196123..b0d1e8dd 100644
--- a/fio.h
+++ b/fio.h
@@ -957,6 +957,7 @@ enum {
 	FIO_RAND_DIST_GAUSS,
 	FIO_RAND_DIST_ZONED,
 	FIO_RAND_DIST_ZONED_ABS,
+	FIO_RAND_DIST_SEQUENCE,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/io_u.c b/io_u.c
index 24d8b7de..e4b863b2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -291,6 +291,28 @@ bail:
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
+	return 0;
+}
+
 static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				enum fio_ddir ddir, uint64_t *b)
 {
@@ -314,6 +336,8 @@ static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 		return __get_next_rand_offset_zoned(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
 		return __get_next_rand_offset_zoned_abs(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_SEQUENCE)
+		return __get_next_rand_offset_sequence(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
diff --git a/options.c b/options.c
index f418179b..ac5a09bf 100644
--- a/options.c
+++ b/options.c
@@ -1340,6 +1340,54 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input,
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
+		if (*n == '\0') {
+			log_err("fio: empty element in random_sequence\n");
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
@@ -1357,6 +1405,8 @@ static int str_random_distribution_cb(void *data, const char *str)
 		return parse_zoned_distribution(td, str, false);
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
 		return parse_zoned_distribution(td, str, true);
+	else if (td->o.random_distribution == FIO_RAND_DIST_SEQUENCE)
+		return parse_sequence_distribution(td, str);
 	else
 		return 0;
 
@@ -1404,6 +1454,9 @@ static int str_random_distribution_cb(void *data, const char *str)
 	return 0;
 }
 
+
+
+
 static bool is_valid_steadystate(unsigned int state)
 {
 	return (state == FIO_SS_IOPS || state == FIO_SS_IOPS_SLOPE ||
@@ -2811,10 +2864,24 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
@@ -6151,6 +6218,18 @@ void fio_options_mem_dupe(struct thread_data *td)
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
 
@@ -6263,6 +6342,11 @@ void del_opt_posval(const char *optname, const char *ival)
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
diff --git a/t/sequence.py b/t/sequence.py
new file mode 100644
index 00000000..bf640020
--- /dev/null
+++ b/t/sequence.py
@@ -0,0 +1,140 @@
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
+    fio_path = str(Path(args.fio).absolute()) if args.fio else 'fio'
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
index 1b7f67eb..165ca640 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -43,6 +43,7 @@ enum dedupe_mode {
 
 #define BSSPLIT_MAX	64
 #define ZONESPLIT_MAX	256
+#define FIO_SEQ_MAX	64
 
 struct split {
 	unsigned int nr;
@@ -190,6 +191,9 @@ struct thread_options {
 	unsigned int verify_only;
 
 	unsigned int random_distribution;
+	unsigned int *random_sequence;
+	unsigned int random_sequence_nr;
+	unsigned int random_sequence_stride;
 	unsigned int exitall_error;
 
 	struct zone_split *zone_split[DDIR_RWDIR_CNT];
@@ -527,6 +531,9 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
+	uint32_t random_sequence[FIO_SEQ_MAX];
+	uint32_t random_sequence_nr;
+	uint32_t random_sequence_stride;
 	uint32_t exitall_error;
 
 	uint32_t sync_file_range;
-- 
2.54.0.545.g6539524ca2-goog

