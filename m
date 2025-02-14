Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D77263F4C
	for <fio@vger.kernel.org>; Fri, 14 Feb 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538012; cv=none; b=NUrusiAic7Wk5Ke5yYYk5pitCvFRomLvkuO8O3qEVPcV8jeK8AyLnN0Wo8kE6UIABw1rOesZ/ErK6IPRYgp4AINagGZWw5ep8I9Hm77myXSOaVdN+3Bg9hG2Ynp2SxeDi1rRIjRQgDzzBzdBX6PtOLfKKwJXAVAiJTxhxlDjw44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538012; c=relaxed/simple;
	bh=Mv8Xd9BzwHgPsqmY2FcfNhLqALAwItQwqOFf0r+waVI=;
	h=Subject:From:To:Message-Id:Date; b=dwO/TkEfhRZeUJumerCoUNKhYqEidyZALfRB9An82iGmWDFGjmrvpys9Thtf2DRGAQs1nVrDvx3s2kbqwvpBrSqisiJm86pxJT7/UC1BxVNFG44Ep0ny62kFB+AkCnC4906nn3QMIezm/c5AV2eqqO2y6/T72IWOuofpRw+R+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=czoHz8QO; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="czoHz8QO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=cRFZAINKlui4yLFCts3ZuSOLb8kUSd2CfoOURhwZGZQ=; b=czoHz8QOYyn4zMO2pD9y9QkuhL
	cj5nR9Ow15nRpn8zaOklfam0IFLKnLIMlyaJlIDaLEPdmc2wbEyjdGE0nYT6AcX/kvbDkg8jcivk4
	yGGKg3C5JAF0Ta9JdJBehxfSU/2cWJqRYpdMJxYpqtOGDxTaitnM1FY38dJdjdPTs1LzqzjbuLSQR
	YRUMKDmS69TMi6MB3qP5T9bvoU0XCVfwWIhIQPGYXDmfTlwn9NdzSwvVzSzp6d3uV967rPEvl6y4c
	2zZTLolJngdkZK+VJroRzlb5C24/rtJ4O4cO7kgqD40XgqNBYGHhVhMi57MWsEHFkjgIBjx+spKOp
	LCDt5rTA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tivIc-00000001FLs-1fpQ
	for fio@vger.kernel.org;
	Fri, 14 Feb 2025 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 538AE1BC0178; Fri, 14 Feb 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250214130001.538AE1BC0178@kernel.dk>
Date: Fri, 14 Feb 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 46559adef82f7d0a0712ac31b20d98fa6b0bd7af:

  t/run-fio-tests: add client/server test script (2025-01-23 12:57:42 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e2d375856c5a443b340b06a33fb40740dda7fee9:

  t/io_uring: fix passthrough fixed buffer support (2025-02-13 08:58:17 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: fix passthrough fixed buffer support

Shin'ichiro Kawasaki (3):
      verify: print message when verify_state_should_stop() returns false
      verify: double number of writes to save completions
      t/verify-state.c: adjust to verify state format change

 backend.c        | 12 +++++++++++-
 fio.h            |  1 +
 io_u.c           |  2 +-
 t/io_uring.c     |  2 +-
 t/verify-state.c |  8 +++++---
 verify-state.h   |  9 +++++----
 verify.c         | 12 ++++++++----
 7 files changed, 32 insertions(+), 14 deletions(-)

---

Diff of recent changes:

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
 
diff --git a/t/io_uring.c b/t/io_uring.c
index eea5fe0a..581cfe53 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -628,7 +628,7 @@ static void init_io_pt(struct submitter *s, unsigned index)
 	cmd->data_len = bs;
 	if (fixedbufs) {
 		sqe->uring_cmd_flags = IORING_URING_CMD_FIXED;
-		sqe->buf_index = index;
+		sqe->buf_index = 0;
 	}
 	cmd->nsid = f->nsid;
 	cmd->opcode = 2;
diff --git a/t/verify-state.c b/t/verify-state.c
index 734c1e4c..f8787e9a 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -23,6 +23,7 @@ static void show_s(struct thread_io_list *s, unsigned int no_s)
 	printf("Name:\t\t%s\n", s->name);
 	printf("Completions:\t%llu\n", (unsigned long long) s->no_comps);
 	printf("Depth:\t\t%llu\n", (unsigned long long) s->depth);
+	printf("Max completions per file:\t\t%lu\n", (unsigned long) s->max_no_comps_per_file);
 	printf("Number IOs:\t%llu\n", (unsigned long long) s->numberio);
 	printf("Index:\t\t%llu\n", (unsigned long long) s->index);
 
@@ -46,6 +47,7 @@ static void show(struct thread_io_list *s, size_t size)
 
 		s->no_comps = le64_to_cpu(s->no_comps);
 		s->depth = le32_to_cpu(s->depth);
+		s->max_no_comps_per_file = le32_to_cpu(s->max_no_comps_per_file);
 		s->nofiles = le32_to_cpu(s->nofiles);
 		s->numberio = le64_to_cpu(s->numberio);
 		s->index = le64_to_cpu(s->index);
@@ -57,9 +59,9 @@ static void show(struct thread_io_list *s, size_t size)
 
 		show_s(s, no_s);
 		no_s++;
-		size -= __thread_io_list_sz(s->depth, s->nofiles);
+		size -= __thread_io_list_sz(s->max_no_comps_per_file, s->nofiles);
 		s = (struct thread_io_list *)((char *) s +
-			__thread_io_list_sz(s->depth, s->nofiles));
+			__thread_io_list_sz(s->max_no_comps_per_file, s->nofiles));
 	} while (size != 0);
 }
 
@@ -90,7 +92,7 @@ static void show_verify_state(void *buf, size_t size)
 		return;
 	}
 
-	if (hdr->version == 0x03)
+	if (hdr->version == 0x04)
 		show(s, size);
 	else
 		log_err("Unsupported version %d\n", (int) hdr->version);
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
index 2e113862..4dbf8d56 100644
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
@@ -1892,5 +1894,7 @@ int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * Not found, we have to stop
 	 */
+	log_info("Stop verify because offset %llu in %s is not recorded in verify state\n",
+		 io_u->verify_offset, f->file_name);
 	return 1;
 }
