Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27537C934
	for <fio@vger.kernel.org>; Thu, 21 May 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779364811; cv=none; b=C69OLIaiHEuvxE6W4+Saq+/DpdMrqiXcdbTIinllrCYhvurgA+o0bsLN4Myc2ymuS+UyW1eY0vExnwNWp2IEAgprSBXfXBM6ZltOlVUI9gBnGvsXsUkipBaZfWUmASAcHan6376Jf+EMaXFcj3boI2pxbqQkHTavRUQZE9XgJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779364811; c=relaxed/simple;
	bh=M7vTTOcrd/REmFrAAx2eY3jvr0Lr8c/PgPDt6EVzgP0=;
	h=Subject:From:To:Date:Message-Id; b=ABfj2TGTAJ8kumitXkLi5wGatqlcvL2gqPWTOffd74OMVCGgJzPe11rwOhiT3xFCdeOrQ04FlBM4MFBrUSvtTURCY1NS+tGLfqf/NHsx7k5j6nkAY81vbmW5DDqf/E/isvnEQNEXw5eqvnlEwutfn1tUrevA4dwMrFHAL9H9A9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U7AzSm5C; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U7AzSm5C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5/5EWqMx5kNi/4zVQwqxqLvu0+M69LwTOr/7h5F7NHA=; b=U7AzSm5C3As9n59W4ErS63Qmj8
	fq/17eE+LWzrX4I0rqR9T9xZdK0mlzRs8Y02GOylIAn3Zp1X11bHzFXgo1IqOlXIM5gvhXPXn3dL1
	7Qu0UdY49xZ/2ZFyDKz9CCBYHbjpJDI6b/XilNigpB9O2IfQnLw41XAik7sVltqDbqUI0n4ypzoSu
	qBC09n0vRtLt0nXFPTf4IczWlIkZzurwor6/KJtiW8ciqIng9XTZX0QbVDDShXrTDZbYMrXFwgD9s
	hf/XxEP7K6R4JMZAquAkbp6UZrnRjdd9XWDeG6Pnik+iYJwvMWf6n2QjTFkQvbpgWs70dHlddlR0X
	35w+smYw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ24L-00000001h94-3hEX
	for fio@vger.kernel.org;
	Thu, 21 May 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 67E711BC015A; Thu, 21 May 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 21 May 2026 06:00:01 -0600
Message-Id: <20260521120001.67E711BC015A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 4de5b267a716a9b7b71b212e0b948743f70c4d54:

  Merge branch 'pr-free-td-init' of https://github.com/malikoyv/fio (2026-05-15 08:03:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d569883e281076e0dec5f5768b828ef44392a11a:

  Merge branch 'skip-errored-offset' of https://github.com/minwooim/fio (2026-05-20 09:17:25 -0400)

----------------------------------------------------------------
Minwoo Im (1):
      verify: skip errored WRITE offset in verify

Vincent Fu (2):
      ci: run all non-QEMU tests on push/PR/schedule
      Merge branch 'skip-errored-offset' of https://github.com/minwooim/fio

 backend.c               | 58 ++++++++++++++++++++++++++++--
 ci/actions-full-test.sh | 16 ---------
 fio.h                   |  7 ++++
 io_u.c                  | 23 ++++++++++++
 verify-state.h          |  3 +-
 verify.c                | 95 ++++++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 173 insertions(+), 29 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 7a02ea11..f6023d0e 100644
--- a/backend.c
+++ b/backend.c
@@ -621,6 +621,7 @@ static enum fio_q_status io_u_submit(struct thread_data *td, struct io_u *io_u)
  */
 static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 {
+	uint64_t expected_numberio;
 	struct fio_file *f;
 	struct io_u *io_u;
 	unsigned int i;
@@ -649,6 +650,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	td_set_runstate(td, TD_VERIFYING);
 
 	io_u = NULL;
+	expected_numberio = UINT64_MAX;
 	while (!td->terminate) {
 		enum fio_ddir ddir;
 		int full;
@@ -677,6 +679,33 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 			}
 
+			/*
+			 * Advance verify_state to the seed that was used when
+			 * this block was written.  Any numberio gap between
+			 * @expected_numberio and @io_u->numberio represents
+			 * skipped writes due to errors (e.g., suppressed by
+			 * --ignore_error= in online verification, or skipped
+			 *  offsets from do_dry_run in offline verification).
+			 */
+			if (td->o.verify_header_seed && !td->o.verify_pattern_bytes) {
+				uint64_t seed = 0;
+				uint64_t from;
+
+				if (io_u->numberio < expected_numberio)
+					from = io_u->numberio;
+				else
+					from = expected_numberio;
+
+				for (uint64_t n = from; n <= io_u->numberio; n++) {
+					seed = __rand(&td->verify_state);
+					if (sizeof(int) != sizeof(long *))
+						seed *= __rand(&td->verify_state);
+				}
+
+				io_u->rand_seed = seed;
+				expected_numberio = io_u->numberio + 1;
+			}
+
 			if (td_io_prep(td, io_u)) {
 				put_io_u(td, io_u);
 				break;
@@ -1207,7 +1236,26 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 					io_u->rand_seed *= __rand(&td->verify_state);
 			}
 
-			if (verify_state_should_stop(td, td->io_issues[io_u->ddir])) {
+			/*
+			 * Assign numberio for read-only verify workloads. This
+			 * handles two cases: (1) rw=[rand]write with verify_only=1
+			 * and verify_state_load=1, where we replay a prior write
+			 * run; (2) a prior job ran with rw=[rand]write and
+			 * verify_state_save=1, and the current job runs with
+			 * rw=[rand]read and verify_state_load=1 to verify those
+			 * writes.
+			 */
+			if (!td_rw(td) && !(io_u->flags & IO_U_F_VER_LIST))
+				io_u->numberio = td->io_issues[io_u->ddir];
+
+			if (verify_state_should_skip(td, io_u->numberio)) {
+				/* Account for this I/O so we move to the next sequence */
+				td->io_issues[io_u->ddir]++;
+				put_io_u(td, io_u);
+				continue;
+			}
+
+			if (verify_state_should_stop(td, io_u->numberio)) {
 				put_io_u(td, io_u);
 				break;
 			}
@@ -1380,6 +1428,8 @@ static void free_inflight_logging(struct thread_data *td)
 {
 	if (td->inflight_numberio)
 		sfree(td->inflight_numberio);
+	if (td->failed_numberio)
+		free(td->failed_numberio);
 }
 
 static void cleanup_io_u(struct thread_data *td)
@@ -1780,8 +1830,10 @@ static uint64_t do_dry_run(struct thread_data *td)
 		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
 		    td->o.do_verify &&
 		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify)
-			log_io_piece(td, io_u);
+		    !td->o.experimental_verify) {
+			if (!verify_state_should_skip(td, io_u->numberio))
+				log_io_piece(td, io_u);
+		}
 
 		ret = io_u_sync_complete(td, io_u);
 		(void) ret;
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 14c2fcf7..56b5b31f 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -40,22 +40,6 @@ main() {
 
     fi
 
-    # If we are running a nightly test just run the verify tests.  Skip the
-    # verify test script with pull requests and pushes because it takes so
-    # long. When this workflow is run manually everything will be run.
-    if [ "${GITHUB_EVENT_NAME}" == "schedule" ]; then
-	args+=(
-	    --run-only
-	    1017
-	    -p
-	    "1017:--complete"
-	)
-    elif [ "${GITHUB_EVENT_NAME}" == "pull_request" ] || [ "${GITHUB_EVENT_NAME}" == "push" ]; then
-	skip+=(
-	    1017
-	)
-    fi
-
     echo python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
     python3 t/run-fio-tests.py -c --skip "${skip[@]}" "${args[@]}"
     make -C doc html
diff --git a/fio.h b/fio.h
index 18196123..3b6ff6c6 100644
--- a/fio.h
+++ b/fio.h
@@ -386,6 +386,13 @@ struct thread_data {
 	unsigned int next_inflight_numberio_idx;
 	uint64_t inflight_issued;
 
+	/*
+	 * Track failed write I/Os for offline verification (to exclude from verify state)
+	 */
+	uint64_t *failed_numberio;
+	unsigned int failed_numberio_count;
+	unsigned int failed_numberio_alloc;
+
 	/*
 	 * Completions
 	 */
diff --git a/io_u.c b/io_u.c
index 24d8b7de..1725a9ce 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2137,6 +2137,29 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	    !td_ioengine_flagged(td, FIO_SYNCIO))
 		zbd_recover_write_error(td, io_u);
 
+	/*
+	 * Track failed write I/Os for offline verification (independent of io_u->ipo).
+	 * This works even when do_verify=0 is set.  In case of online
+	 * verification, `unlog_io_piece()` will be called so that the ipo will
+	 * be removed from the `io_hist`.
+	 */
+	if (io_u->error && ddir == DDIR_WRITE && io_u->numberio != INVALID_NUMBERIO) {
+		if (td->failed_numberio_count >= td->failed_numberio_alloc) {
+			unsigned int new_alloc;
+
+			if (td->failed_numberio_alloc)
+				new_alloc = td->failed_numberio_alloc * 2;
+			else
+				new_alloc = 16;
+			td->failed_numberio = realloc(td->failed_numberio,
+						new_alloc * sizeof(uint64_t));
+			td->failed_numberio_alloc = new_alloc;
+		}
+		td->failed_numberio[td->failed_numberio_count++] = io_u->numberio;
+		dprint(FD_VERIFY, "Recorded failed write numberio=%"PRIu64"\n",
+			io_u->numberio);
+	}
+
 	/*
 	 * Mark IO ok to verify
 	 */
diff --git a/verify-state.h b/verify-state.h
index 27eb9e9a..03093ecd 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -41,7 +41,7 @@ struct all_io_list {
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION	0x05
+#define VSTATE_HDR_VERSION	0x06
 
 struct verify_state_hdr {
 	uint64_t version;
@@ -57,6 +57,7 @@ extern void __verify_save_state(struct all_io_list *, const char *);
 extern void verify_save_state(int mask);
 extern int verify_load_state(struct thread_data *, const char *);
 extern void verify_free_state(struct thread_data *);
+extern int verify_state_should_skip(struct thread_data *, uint64_t);
 extern int verify_state_should_stop(struct thread_data *, uint64_t);
 extern void verify_assign_state(struct thread_data *, void *);
 extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *);
diff --git a/verify.c b/verify.c
index 76da89eb..9dd9da7e 100644
--- a/verify.c
+++ b/verify.c
@@ -1474,11 +1474,6 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		free(ipo);
 		dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
 
-		if (!td->o.verify_pattern_bytes) {
-			io_u->rand_seed = __rand(&td->verify_state);
-			if (sizeof(int) != sizeof(long *))
-				io_u->rand_seed *= __rand(&td->verify_state);
-		}
 		return 0;
 	}
 
@@ -1655,7 +1650,8 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 			continue;
 		td->stop_io = 1;
 		td->flags |= TD_F_VSTATE_SAVED;
-		depth += (td->o.iodepth * td->o.nr_files);
+		/* Include both inflight and failed I/Os in the state */
+		depth += ((td->o.iodepth + td->failed_numberio_count) * td->o.nr_files);
 		nr++;
 	} end_for_each();
 
@@ -1672,6 +1668,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	next = &rep->state[0];
 	for_each_td(td) {
 		struct thread_io_list *s = next;
+		unsigned int total_depth;
 
 		if (save_mask != IO_LIST_ALL && (__td_index + 1) != save_mask)
 			continue;
@@ -1685,7 +1682,15 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		for (int i = 0; td->inflight_numberio && i < td->o.iodepth; i++)
 			s->inflight[i].numberio = cpu_to_le64(atomic_load_acquire(&td->inflight_numberio[i]));
 
-		s->depth = cpu_to_le32((uint32_t) td->o.iodepth);
+		/* Then, append failed I/Os to exclude them from verification */
+		for (unsigned int i = 0; i < td->failed_numberio_count; i++) {
+			s->inflight[td->o.iodepth + i].numberio = cpu_to_le64(td->failed_numberio[i]);
+			dprint(FD_VERIFY, "Added failed numberio=%"PRIu64" to inflight list\n",
+				td->failed_numberio[i]);
+		}
+
+		total_depth = td->o.iodepth + td->failed_numberio_count;
+		s->depth = cpu_to_le32((uint32_t) total_depth);
 		s->numberio = cpu_to_le64((uint64_t) atomic_load_acquire(&td->inflight_issued));
 		s->index = cpu_to_le64((uint64_t) __td_index);
 		if (td->offset_state.use64) {
@@ -1809,6 +1814,18 @@ void verify_free_state(struct thread_data *td)
 		free(td->vstate);
 }
 
+static int verify_u64_cmp(const void *a, const void *b)
+{
+	uint64_t x = *(const uint64_t *) a;
+	uint64_t y = *(const uint64_t *) b;
+
+	if (x < y)
+		return -1;
+	if (x > y)
+		return 1;
+	return 0;
+}
+
 void verify_assign_state(struct thread_data *td, void *p)
 {
 	struct thread_io_list *s = p;
@@ -1831,6 +1848,30 @@ void verify_assign_state(struct thread_data *td, void *p)
 		dprint(FD_VERIFY, "verify_assign_state numberio=%"PRIu64", inflight[%d]=%"PRIu64"\n", s->numberio, i, s->inflight[i].numberio);
 	}
 
+	/*
+	 * Restore failed I/Os from state. Failed I/Os are appended after
+	 * the regular inflight array (starting at index td->o.iodepth).
+	 */
+	if (s->depth > td->o.iodepth) {
+		unsigned int failed_count = s->depth - td->o.iodepth;
+
+		td->failed_numberio = malloc(failed_count * sizeof(uint64_t));
+		td->failed_numberio_alloc = failed_count;
+		td->failed_numberio_count = 0;
+
+		for (i = td->o.iodepth; i < s->depth; i++) {
+			uint64_t nio = s->inflight[i].numberio;
+			if (nio != INVALID_NUMBERIO) {
+				td->failed_numberio[td->failed_numberio_count++] = nio;
+				dprint(FD_VERIFY, "Restored failed numberio=%"PRIu64"\n", nio);
+			}
+		}
+
+		/* Sort for O(log n) binary search in verify_state_should_skip() */
+		qsort(td->failed_numberio, td->failed_numberio_count,
+		      sizeof(uint64_t), verify_u64_cmp);
+	}
+
 	td->vstate = p;
 }
 
@@ -1911,6 +1952,35 @@ err:
 	return 1;
 }
 
+/*
+ * Check if this I/O should be skipped during verification (because it failed during write).
+ * failed_numberio[] is sorted in verify_assign_state(), so we use binary search: O(log n).
+ */
+int verify_state_should_skip(struct thread_data *td, uint64_t numberio)
+{
+	unsigned int lo, hi;
+
+	if (!td->failed_numberio || td->failed_numberio_count == 0)
+		return 0;
+
+	lo = 0;
+	hi = td->failed_numberio_count;
+	while (lo < hi) {
+		unsigned int mid = lo + (hi - lo) / 2;
+
+		if (td->failed_numberio[mid] == numberio) {
+			dprint(FD_VERIFY, "Skipping failed numberio=%"PRIu64"\n", numberio);
+			return 1;
+		} else if (td->failed_numberio[mid] < numberio) {
+			lo = mid + 1;
+		} else {
+			hi = mid;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Use the loaded verify state to know when to stop doing verification
  */
@@ -1924,10 +1994,17 @@ int verify_state_should_stop(struct thread_data *td, uint64_t numberio)
 		return 0;
 
 	/* If the current seq is lower than the max issued seq, check to make sure
-	 * the write was not inflight.
+	 * the write was not inflight (but exclude failed writes, they should be skipped not stopped).
 	 */
 	if (numberio < s->numberio) {
-		for (i = 0; i < s->depth; i++) {
+		/* Check only the actual inflight array (first td->o.iodepth entries) */
+		int actual_depth;
+
+		if (s->depth > td->o.iodepth)
+			actual_depth = td->o.iodepth;
+		else
+			actual_depth = s->depth;
+		for (i = 0; i < actual_depth; i++) {
 			if (s->inflight[i].numberio == numberio) {
 				log_info("Stop verify because seq %"PRIu64" was an inflight write\n",
 					numberio);
