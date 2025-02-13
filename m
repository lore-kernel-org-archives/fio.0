Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68731E48A
	for <fio@vger.kernel.org>; Thu, 13 Feb 2025 05:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739424324; cv=none; b=hyaGLd5IFPX9Rf1WxQQ0WjIDhLpr2yVimjpbitXqsKrYy1+5BdGxnyj/yJZgtkz7EglztB4fRXvxal1lXoDpACnTFgA0TVgkJbTV4NKI2055q3Y4aD0w4TvAiVycIyQl6qZSuRR2+SDKgZ3L+YZ4gLNr2woJNUl6tjOXaZcGAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739424324; c=relaxed/simple;
	bh=qFxww9h3KuCzR1gZva1ky+8D6PaioSBcFGVTnC3NAD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNR2aUInTbUUfx7z6KobSLMwib6qp7kgM0ck0HKXMTm5BmwMrcEUDAbXQUT33WCxFk5pQhEAhqF41yrh+55fDNRXbpDJbhBN+SWVLpuLsarP7f3eSjvLUpFUh04G1SAyzDEVmCngiydKb1g+F+L74YgAYZN8AHAbHIjoVkXsdO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gh/CsNhQ; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gh/CsNhQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739424322; x=1770960322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qFxww9h3KuCzR1gZva1ky+8D6PaioSBcFGVTnC3NAD0=;
  b=gh/CsNhQZ9ZlDbvawDQNkL+xBiqCR94XcjYXFSSCBl85z+iyZ4sJkOy0
   mPVlAbHuhhmz6wWkrSwP1Sr3s9PqIgrMIzxBn8neJ7f8i4Kii/oUYO1/y
   Biu/P7MWuEtNfIrWdrjM0UN492SiLKL9UVTuYBgNLU1n98tcAKF9+Vw6D
   uDsJB1113RD0H7CX6eiPVyByjKjFOSzqz3Gvvjj5oBr2JhIRwHpzR//Bo
   8DjOAM4Hy1GUAoAbL8t+ymq7q+YaRFk+LcDMtTbk/AyuU8zKCsHGX5RrS
   rbWOfOhF1R6f8kKDUghDHJ8qfJuV5CvMm+YymBt2RL/2oKuGFPQLwLdbY
   g==;
X-CSE-ConnectionGUID: qTfNSXt/RIOUwTMLa9uTdQ==
X-CSE-MsgGUID: X81qqyB/Q+6ey6IeujtmSA==
X-IronPort-AV: E=Sophos;i="6.13,282,1732550400"; 
   d="scan'208";a="38948611"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2025 13:25:14 +0800
IronPort-SDR: 67ad7487_JqhC+WhqRamOqjNyQTVa4rizwIGARSg8Ftoj7uyOAD6CtZQ
 QDG+DBqlLam6A0HlghGROqEeLKctWtpn5GElScQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Feb 2025 20:26:48 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Feb 2025 21:25:13 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/3] verify: double number of writes to save completions
Date: Thu, 13 Feb 2025 14:25:09 +0900
Message-ID: <20250213052510.1474423-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
References: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When asynchronous write workloads have the verify option and the
verify_state_save option enabled, fio saves the last write completions
in the verify state file. The number of writes saved in the verify state
file is equal to the I/O depth specified by the iodepth option. Let N
represent the iodepth. Subsequent verify workloads with the
verify_state_load option read the saved verify state file. As to the
last N verify I/Os, fio checks if they have corresponding write
completions saved by the write workloads. If not, fio does not perform
the verify I/Os since the verify data was not written. This approach
prevents the false-positive verify failures. Refer to the following two
commits for the detail:

 ca09be4b1a8e ("Add support for verify triggers and verify state saving")
 94a6e1bb4e7d ("Fix verify state for multiple files")

However, when the write workloads are asynchronous, the completion order
of writes can differ from their issue order. In such cases, a write
named "W_before_last_N", issued before the last N writes, may complete
slowly, fall within the last N completions, and be saved in the verify
state file. Conversely, one of the last issued N writes, named
"W_in_last_N", may complete early, and not be saved in the verify state
file. When the subsequent verify workload reads the verify state file
and runs, fio prepares the I/O for the "W_in_last_N" at some point. Fio
tries to find its offset in the verify state file, but that is not
found. Then fio stops the verify workload. This unexpected verify stop
confuses users.

To reduce the chance of the unexpected verify stop due to fluctuations
in the write completion order, increase the number of write completions
saved in the verify state file. Since this issue only occurs with
asynchronous writes, increase the number only for asynchronous
workloads. Add a new field "last_write_comp_depth" to struct thread_data
to store the number. To adjust the size of the verify state file, add a
new field "max_no_comps_per_file" to struct thread_io_list. This field
reflects the number of writes to be saved for each file and allows to
calculate the state file size. These changes affect the verify state
file format, then bump up the verify state header version from 3 to 4.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c      | 12 +++++++++++-
 fio.h          |  1 +
 io_u.c         |  2 +-
 verify-state.h |  9 +++++----
 verify.c       | 10 ++++++----
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/backend.c b/backend.c
index fe03eab3..f3e5b56a 100644
--- a/backend.c
+++ b/backend.c
@@ -1234,8 +1234,18 @@ static int init_file_completion_logging(struct thread_data *td,
 	if (td->o.verify == VERIFY_NONE || !td->o.verify_state_save)
 		return 0;
 
+	/*
+	 * Async IO completion order may be different from issue order. Double
+	 * the number of write completions to cover the case the writes issued
+	 * earlier complete slowly and fall in the last write log entries.
+	 */
+	td->last_write_comp_depth = depth;
+	if (!td_ioengine_flagged(td, FIO_SYNCIO))
+		td->last_write_comp_depth += depth;
+
 	for_each_file(td, f, i) {
-		f->last_write_comp = scalloc(depth, sizeof(uint64_t));
+		f->last_write_comp = scalloc(td->last_write_comp_depth,
+					     sizeof(uint64_t));
 		if (!f->last_write_comp)
 			goto cleanup;
 	}
diff --git a/fio.h b/fio.h
index 4bb6cfa7..b8cf3229 100644
--- a/fio.h
+++ b/fio.h
@@ -387,6 +387,7 @@ struct thread_data {
 	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	uint64_t bytes_verified;
+	uint32_t last_write_comp_depth;
 
 	uint64_t *thinktime_blocks_counter;
 	struct timespec last_thinktime;
diff --git a/io_u.c b/io_u.c
index b699169d..f7824717 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2074,7 +2074,7 @@ static void file_log_write_comp(const struct thread_data *td, struct fio_file *f
 
 	idx = f->last_write_idx++;
 	f->last_write_comp[idx] = offset;
-	if (f->last_write_idx == td->o.iodepth)
+	if (f->last_write_idx == td->last_write_comp_depth)
 		f->last_write_idx = 0;
 }
 
diff --git a/verify-state.h b/verify-state.h
index 6da1585b..603af70d 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -31,8 +31,9 @@ struct file_comp {
 };
 
 struct thread_io_list {
-	uint64_t no_comps;
-	uint32_t depth;
+	uint64_t no_comps; /* Number of completions saved for the thread */
+	uint32_t depth; /* I/O depth of the job that saves the verify state */
+	uint32_t max_no_comps_per_file;
 	uint32_t nofiles;
 	uint64_t numberio;
 	uint64_t index;
@@ -46,7 +47,7 @@ struct all_io_list {
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION	0x03
+#define VSTATE_HDR_VERSION	0x04
 
 struct verify_state_hdr {
 	uint64_t version;
@@ -73,7 +74,7 @@ static inline size_t __thread_io_list_sz(uint32_t depth, uint32_t nofiles)
 
 static inline size_t thread_io_list_sz(struct thread_io_list *s)
 {
-	return __thread_io_list_sz(le32_to_cpu(s->depth), le32_to_cpu(s->nofiles));
+	return __thread_io_list_sz(le32_to_cpu(s->max_no_comps_per_file), le32_to_cpu(s->nofiles));
 }
 
 static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
diff --git a/verify.c b/verify.c
index 63b63718..4dbf8d56 100644
--- a/verify.c
+++ b/verify.c
@@ -1551,15 +1551,15 @@ static int __fill_file_completions(struct thread_data *td,
 	if (!f->last_write_comp)
 		return 0;
 
-	if (td->io_blocks[DDIR_WRITE] < td->o.iodepth)
+	if (td->io_blocks[DDIR_WRITE] < td->last_write_comp_depth)
 		comps = td->io_blocks[DDIR_WRITE];
 	else
-		comps = td->o.iodepth;
+		comps = td->last_write_comp_depth;
 
 	j = f->last_write_idx - 1;
 	for (i = 0; i < comps; i++) {
 		if (j == -1)
-			j = td->o.iodepth - 1;
+			j = td->last_write_comp_depth - 1;
 		s->comps[*index].fileno = __cpu_to_le64(f->fileno);
 		s->comps[*index].offset = cpu_to_le64(f->last_write_comp[j]);
 		(*index)++;
@@ -1602,7 +1602,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 			continue;
 		td->stop_io = 1;
 		td->flags |= TD_F_VSTATE_SAVED;
-		depth += (td->o.iodepth * td->o.nr_files);
+		depth += (td->last_write_comp_depth * td->o.nr_files);
 		nr++;
 	} end_for_each();
 
@@ -1628,6 +1628,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 
 		s->no_comps = cpu_to_le64((uint64_t) comps);
 		s->depth = cpu_to_le32((uint32_t) td->o.iodepth);
+		s->max_no_comps_per_file = cpu_to_le32((uint32_t) td->last_write_comp_depth);
 		s->nofiles = cpu_to_le32((uint32_t) td->o.nr_files);
 		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
 		s->index = cpu_to_le64((uint64_t) __td_index);
@@ -1759,6 +1760,7 @@ void verify_assign_state(struct thread_data *td, void *p)
 
 	s->no_comps = le64_to_cpu(s->no_comps);
 	s->depth = le32_to_cpu(s->depth);
+	s->max_no_comps_per_file = le32_to_cpu(s->max_no_comps_per_file);
 	s->nofiles = le32_to_cpu(s->nofiles);
 	s->numberio = le64_to_cpu(s->numberio);
 	s->rand.use64 = le64_to_cpu(s->rand.use64);
-- 
2.47.0

