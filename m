Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C33244688
	for <fio@vger.kernel.org>; Wed,  6 Aug 2025 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754481616; cv=none; b=Wjt9CRCH1jBfPqqKGsVGeITLcf2gJmgXat6utiYz253nEy5AuQ3VTqkxKqf6QqhbSzR3itMK4qIhnJZyWxS2c6IWt1DSSzrVPm2KzYw+eXKJaldkdMIW46WvqwROfwl3HBUieIrv4/Ork3ybaxGdxYGeOvzxHwqMIS0P3sWuELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754481616; c=relaxed/simple;
	bh=9GBvsQElvoLOQwHt/p2R7U0TK/Yyj8cXYbrB1a7XUwI=;
	h=Subject:From:To:Message-Id:Date; b=KnCCRRovVOSAt86ffXYRO+eTYGDyhGwKwoJ+jGcLSZSMLnYGs8YqxJ1euy0D/+SGK7s2EMejDsoCfNIRxQFg8vPEuQZMFyC4nwN4sQouFu2fpekTXxXl6UTej0AVmjvva5e7tStzc5EOJ1ii74jgj0zrm5AKo2wOh8KxKpfx9iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D4IDu9Wm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D4IDu9Wm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=enM8aPFGxWiWcMGYU6D4uza1m1m1o7HyAdRYwnlR560=; b=D4IDu9WmKi/g7WBcRNvDX0Kwpn
	joZ7nQMi51VgJe062KZZwKHwvPWr1luYMYj6IlA9spWKWu4I/Bq+knzp/MpTOFYbv8mh8pWgN2Oin
	2LGhc4tIZx3bm0gdKbF1p0qQniL4e0bQToNaY3KkojEfMF01jrFSH40dDBVc7ELJRqvvFi6PmpwPN
	1xKO9yo2R/tJkbWcHSrPaJE6Q8UjR+62f1IJcwMOcIElljipVfAUP1VRxaOMbfkcXNrgz5kSruFZp
	B5yWjxIDwJaI2Ayar5EQh7LDDXKGvso2kfRs2kT829vbNSxB7D3TxB67HRMjasz7bbgMKhj+8oUBl
	Vji8nv4A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujcoQ-00000003hKq-49HX
	for fio@vger.kernel.org;
	Wed, 06 Aug 2025 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 21AAF1BC016C; Wed,  6 Aug 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250806120002.21AAF1BC016C@kernel.dk>
Date: Wed,  6 Aug 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ef740f7cbe47d5552677fb018b15b4ab1f1de4f4:

  t/io_uring_pi: test script for io_uring PI (2025-08-02 09:40:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b1b07c8dfbb562a949afd127d693e9c0cb009827:

  ioengines: bump version number (2025-08-05 15:56:45 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'verify_inflight' of https://github.com/noclip-code/fio
      ioengines: bump version number

Riley Thomasson (5):
      verify: make numberio uint64_t
      verify: rework write tracking for use with verify_save_state()
      verify: plumb inflight write information through verify state
      verify: clear inflight log in between loops
      verify: add versioning to verify_header

 backend.c        | 157 +++++++++++++++++++++++++++++++++++++++++--------------
 file.h           |   7 ---
 fio.h            |  17 +++++-
 io_u.c           |  11 +---
 io_u.h           |   4 +-
 ioengines.h      |   2 +-
 iolog.h          |   2 +-
 libfio.c         |   2 +
 t/verify-state.c |  26 ++++-----
 verify-state.h   |  24 ++++-----
 verify.c         | 118 ++++++++++++-----------------------------
 verify.h         |  11 +++-
 12 files changed, 202 insertions(+), 179 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 0cdee864..922309a0 100644
--- a/backend.c
+++ b/backend.c
@@ -714,7 +714,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 		}
 
-		if (verify_state_should_stop(td, io_u)) {
+		if (verify_state_should_stop(td, io_u->numberio)) {
 			put_io_u(td, io_u);
 			break;
 		}
@@ -948,6 +948,102 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 	}
 }
 
+/*
+ * Add numberio from io_u to the inflight log.
+ */
+void log_inflight(struct thread_data *td, struct io_u *io_u)
+{
+	int idx, i;
+
+	if (!td->inflight_numberio || io_u->ddir != DDIR_WRITE)
+		return;
+
+	if (io_u->inflight_idx != -1) {
+		log_err("inflight_idx already set: inflight_idx=%d\n",
+			io_u->inflight_idx);
+		abort();
+	}
+
+	if (td->inflight_issued != io_u->numberio) {
+		log_err("inflight_issued does not match: numberio=%"PRIu64", inflight_issued=%"PRIu64"\n",
+			io_u->numberio, td->inflight_issued);
+		abort();
+	}
+
+	/* Walk the inflight list until we find a free slot. */
+	idx = td->next_inflight_numberio_idx;
+	for (i = 0; i < td->o.iodepth; i++) {
+		if (td->inflight_numberio[idx] == INVALID_NUMBERIO) {
+			/*
+			 * The order here is important - we must "protect" this write in the
+			 * inflight list before making it visible in inflight_issued.
+			 */
+			atomic_store_release(&td->inflight_numberio[idx], io_u->numberio);
+			td->next_inflight_numberio_idx = (idx + 1) % td->o.iodepth;
+			io_u->inflight_idx = idx;
+
+			atomic_store_release(&td->inflight_issued, io_u->numberio + 1);
+			dprint(FD_VERIFY, "log_inflight: numberio=%"PRIu64", inflight_idx=%d\n",
+				io_u->numberio, idx);
+			return;
+		}
+		idx = (idx + 1) % td->o.iodepth;
+	}
+
+	log_err("failed to allocate inflight slot: next_inflight_numberio_idx=%u\n",
+		td->next_inflight_numberio_idx);
+	abort();
+}
+
+/*
+ * Invalidate inflight log entry.
+ */
+void invalidate_inflight(struct thread_data *td, struct io_u *io_u)
+{
+	if (!td->inflight_numberio ||
+		io_u->ddir != DDIR_WRITE ||
+		io_u->inflight_idx == -1) {
+		return;
+	}
+
+	dprint(FD_VERIFY, "invalidate_inflight: numberio=%"PRIu64", inflight_idx=%d\n",
+		io_u->numberio, io_u->inflight_idx);
+
+	if (td->inflight_numberio[io_u->inflight_idx] == INVALID_NUMBERIO) {
+		log_err("inflight entry already invalid: numberio=%"PRIu64", inflight_idx=%d\n",
+			io_u->numberio, io_u->inflight_idx);
+		abort();
+	} else if (td->inflight_numberio[io_u->inflight_idx] != io_u->numberio) {
+		log_err("inflight entry numberio does not match: expected numberio=%"PRIu64", observed numberio=%"PRIu64", inflight_idx=%d\n",
+			io_u->numberio, td->inflight_numberio[io_u->inflight_idx], io_u->inflight_idx);
+		abort();
+	}
+
+	atomic_store_release(&td->inflight_numberio[io_u->inflight_idx], INVALID_NUMBERIO);
+	io_u->inflight_idx = -1;
+}
+
+/*
+ * Clear inflight log.
+ */
+void clear_inflight(struct thread_data *td)
+{
+	int i;
+
+	if (!td->inflight_numberio)
+		return;
+
+	for (i = 0; i < td->o.iodepth; i++)
+		td->inflight_numberio[i] = INVALID_NUMBERIO;
+
+	td->next_inflight_numberio_idx = 0;
+	/*
+	 * Experimental verify can increment io_issues for writes, so catch
+	 * inflight_issued up in between loops.
+	 */
+	td->inflight_issued = td->io_issues[DDIR_WRITE];
+}
+
 /*
  * Main IO worker function. It retrieves io_u's to process and queues
  * and reaps them, checking for rate and errors along the way.
@@ -1059,6 +1155,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 				io_u_set(td, io_u, IO_U_F_PATTERN_DONE);
 				io_u->numberio = td->io_issues[io_u->ddir];
 				populate_verify_io_u(td, io_u);
+				log_inflight(td, io_u);
 			}
 		}
 
@@ -1083,7 +1180,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 					io_u->rand_seed *= __rand(&td->verify_state);
 			}
 
-			if (verify_state_should_stop(td, io_u)) {
+			if (verify_state_should_stop(td, td->io_issues[io_u->ddir])) {
 				put_io_u(td, io_u);
 				break;
 			}
@@ -1227,49 +1324,29 @@ reap:
 		bytes_done[i] = td->bytes_done[i] - bytes_done[i];
 }
 
-static void free_file_completion_logging(struct thread_data *td)
+static int init_inflight_logging(struct thread_data *td)
 {
-	struct fio_file *f;
-	unsigned int i;
-
-	for_each_file(td, f, i) {
-		if (!f->last_write_comp)
-			break;
-		sfree(f->last_write_comp);
-	}
-}
-
-static int init_file_completion_logging(struct thread_data *td,
-					unsigned int depth)
-{
-	struct fio_file *f;
 	unsigned int i;
 
 	if (td->o.verify == VERIFY_NONE || !td->o.verify_state_save)
 		return 0;
 
-	/*
-	 * Async IO completion order may be different from issue order. Double
-	 * the number of write completions to cover the case the writes issued
-	 * earlier complete slowly and fall in the last write log entries.
-	 */
-	td->last_write_comp_depth = depth;
-	if (!td_ioengine_flagged(td, FIO_SYNCIO))
-		td->last_write_comp_depth += depth;
-
-	for_each_file(td, f, i) {
-		f->last_write_comp = scalloc(td->last_write_comp_depth,
-					     sizeof(uint64_t));
-		if (!f->last_write_comp)
-			goto cleanup;
+	td->inflight_numberio = scalloc(td->o.iodepth, sizeof(uint64_t));
+	if (!td->inflight_numberio) {
+		log_err("fio: failed to alloc inflight write data\n");
+		return 1;
 	}
 
+	for (i = 0; i < td->o.iodepth; i++)
+		td->inflight_numberio[i] = INVALID_NUMBERIO;
+
 	return 0;
+}
 
-cleanup:
-	free_file_completion_logging(td);
-	log_err("fio: failed to alloc write comp data\n");
-	return 1;
+static void free_inflight_logging(struct thread_data *td)
+{
+	if (td->inflight_numberio)
+		sfree(td->inflight_numberio);
 }
 
 static void cleanup_io_u(struct thread_data *td)
@@ -1294,16 +1371,15 @@ static void cleanup_io_u(struct thread_data *td)
 	io_u_qexit(&td->io_u_freelist, false);
 	io_u_qexit(&td->io_u_all, td_offload_overlap(td));
 
-	free_file_completion_logging(td);
+	free_inflight_logging(td);
 }
 
 static int init_io_u(struct thread_data *td)
 {
 	struct io_u *io_u;
-	int cl_align, i, max_units;
+	int cl_align, i;
 	int err;
 
-	max_units = td->o.iodepth;
 
 	err = 0;
 	err += !io_u_rinit(&td->io_u_requeues, td->o.iodepth);
@@ -1317,7 +1393,7 @@ static int init_io_u(struct thread_data *td)
 
 	cl_align = os_cache_line_size();
 
-	for (i = 0; i < max_units; i++) {
+	for (i = 0; i < td->o.iodepth; i++) {
 		void *ptr;
 
 		if (td->terminate)
@@ -1334,6 +1410,7 @@ static int init_io_u(struct thread_data *td)
 		INIT_FLIST_HEAD(&io_u->verify_list);
 		dprint(FD_MEM, "io_u alloc %p, index %u\n", io_u, i);
 
+		io_u->inflight_idx = -1;
 		io_u->index = i;
 		io_u->flags = IO_U_F_FREE;
 		io_u_qpush(&td->io_u_freelist, io_u);
@@ -1357,7 +1434,7 @@ static int init_io_u(struct thread_data *td)
 	if (init_io_u_buffers(td))
 		return 1;
 
-	if (init_file_completion_logging(td, max_units))
+	if (init_inflight_logging(td))
 		return 1;
 
 	return 0;
diff --git a/file.h b/file.h
index e38ed2f1..8fd40cdf 100644
--- a/file.h
+++ b/file.h
@@ -122,13 +122,6 @@ struct fio_file {
 	uint64_t first_write;
 	uint64_t last_write;
 
-	/*
-	 * Tracks the last iodepth number of completed writes, if data
-	 * verification is enabled
-	 */
-	uint64_t *last_write_comp;
-	unsigned int last_write_idx;
-
 	/*
 	 * For use by the io engine to store offset
 	 */
diff --git a/fio.h b/fio.h
index 00f0f09b..e11b9261 100644
--- a/fio.h
+++ b/fio.h
@@ -73,6 +73,8 @@ struct fio_sem;
 
 #define MAX_TRIM_RANGE	256
 
+#define INVALID_NUMBERIO UINT64_MAX
+
 /*
  * Range for trim command
  */
@@ -376,6 +378,13 @@ struct thread_data {
 	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
 	uint64_t loops;
 
+	/*
+	 * Keep track of inflight write sequence numbers (numberio) which are used to save verify state.
+	 */
+	uint64_t *inflight_numberio;
+	unsigned int next_inflight_numberio_idx;
+	uint64_t inflight_issued;
+
 	/*
 	 * Completions
 	 */
@@ -388,7 +397,6 @@ struct thread_data {
 	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	uint64_t bytes_verified;
-	uint32_t last_write_comp_depth;
 
 	uint64_t *thinktime_blocks_counter;
 	struct timespec last_thinktime;
@@ -782,6 +790,13 @@ extern void lat_target_check(struct thread_data *);
 extern void lat_target_init(struct thread_data *);
 extern void lat_target_reset(struct thread_data *);
 
+/*
+ * Inflight log
+ */
+extern void log_inflight(struct thread_data *, struct io_u *);
+extern void invalidate_inflight(struct thread_data *, struct io_u *);
+extern void clear_inflight(struct thread_data *);
+
 /*
  * Iterates all threads/processes within all the defined jobs
  * Usage:
diff --git a/io_u.c b/io_u.c
index ca97f388..6d0f32a8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2065,8 +2065,6 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 static void file_log_write_comp(const struct thread_data *td, struct fio_file *f,
 				uint64_t offset, unsigned int bytes)
 {
-	int idx;
-
 	if (!f)
 		return;
 
@@ -2074,14 +2072,6 @@ static void file_log_write_comp(const struct thread_data *td, struct fio_file *f
 		f->first_write = offset;
 	if (f->last_write == -1ULL || ((offset + bytes) > f->last_write))
 		f->last_write = offset + bytes;
-
-	if (!f->last_write_comp)
-		return;
-
-	idx = f->last_write_idx++;
-	f->last_write_comp[idx] = offset;
-	if (f->last_write_idx == td->last_write_comp_depth)
-		f->last_write_idx = 0;
 }
 
 static bool should_account(struct thread_data *td)
@@ -2101,6 +2091,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 
 	assert(io_u->flags & IO_U_F_FLIGHT);
 	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK | IO_U_F_PATTERN_DONE);
+	invalidate_inflight(td, io_u);
 
 	if (td->o.zone_mode == ZONE_MODE_ZBD && td->o.recover_zbd_write_error &&
 	    io_u->error && io_u->ddir == DDIR_WRITE &&
diff --git a/io_u.h b/io_u.h
index 2d20a2b2..68771eba 100644
--- a/io_u.h
+++ b/io_u.h
@@ -46,7 +46,7 @@ struct io_u {
 	/*
 	 * Write generation
 	 */
-	unsigned short numberio;
+	uint64_t numberio;
 
 	/*
 	 * IO priority.
@@ -90,6 +90,8 @@ struct io_u {
 	unsigned long long resid;
 	unsigned int error;
 
+	int inflight_idx;
+
 	/*
 	 * io engine private data
 	 */
diff --git a/ioengines.h b/ioengines.h
index bd5d189c..afafeeb9 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	37
+#define FIO_IOOPS_VERSION	38
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
diff --git a/iolog.h b/iolog.h
index e864d169..b52ae87d 100644
--- a/iolog.h
+++ b/iolog.h
@@ -260,7 +260,7 @@ struct io_piece {
 		struct fio_file *file;
 	};
 	unsigned long long offset;
-	unsigned short numberio;
+	uint64_t numberio;
 	unsigned long len;
 	unsigned int flags;
 	enum fio_ddir ddir;
diff --git a/libfio.c b/libfio.c
index 2596ae5a..3503c65e 100644
--- a/libfio.c
+++ b/libfio.c
@@ -128,6 +128,8 @@ void clear_io_state(struct thread_data *td, int all)
 	 */
 	if (td->o.rand_repeatable)
 		td_fill_rand_seeds(td);
+
+	clear_inflight(td);
 }
 
 void reset_all_stats(struct thread_data *td)
diff --git a/t/verify-state.c b/t/verify-state.c
index f8787e9a..e1b92ee8 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -21,19 +21,16 @@ static void show_s(struct thread_io_list *s, unsigned int no_s)
 
 	printf("Thread:\t\t%u\n", no_s);
 	printf("Name:\t\t%s\n", s->name);
-	printf("Completions:\t%llu\n", (unsigned long long) s->no_comps);
 	printf("Depth:\t\t%llu\n", (unsigned long long) s->depth);
-	printf("Max completions per file:\t\t%lu\n", (unsigned long) s->max_no_comps_per_file);
 	printf("Number IOs:\t%llu\n", (unsigned long long) s->numberio);
 	printf("Index:\t\t%llu\n", (unsigned long long) s->index);
 
-	printf("Completions:\n");
-	if (!s->no_comps)
+	printf("Inflight writes:\n");
+	if (!s->depth)
 		return;
-	for (i = s->no_comps - 1; i >= 0; i--) {
-		printf("\t(file=%2llu) %llu\n",
-				(unsigned long long) s->comps[i].fileno,
-				(unsigned long long) s->comps[i].offset);
+	for (i = s->depth - 1; i >= 0; i--) {
+		printf("\t%llu\n",
+				(unsigned long long) s->inflight[i].numberio);
 	}
 }
 
@@ -45,23 +42,18 @@ static void show(struct thread_io_list *s, size_t size)
 	do {
 		int i;
 
-		s->no_comps = le64_to_cpu(s->no_comps);
 		s->depth = le32_to_cpu(s->depth);
-		s->max_no_comps_per_file = le32_to_cpu(s->max_no_comps_per_file);
-		s->nofiles = le32_to_cpu(s->nofiles);
 		s->numberio = le64_to_cpu(s->numberio);
 		s->index = le64_to_cpu(s->index);
 
-		for (i = 0; i < s->no_comps; i++) {
-			s->comps[i].fileno = le64_to_cpu(s->comps[i].fileno);
-			s->comps[i].offset = le64_to_cpu(s->comps[i].offset);
-		}
+		for (i = 0; i < s->depth; i++)
+			s->inflight[i].numberio = le64_to_cpu(s->inflight[i].numberio);
 
 		show_s(s, no_s);
 		no_s++;
-		size -= __thread_io_list_sz(s->max_no_comps_per_file, s->nofiles);
+		size -= __thread_io_list_sz(s->depth);
 		s = (struct thread_io_list *)((char *) s +
-			__thread_io_list_sz(s->max_no_comps_per_file, s->nofiles));
+			__thread_io_list_sz(s->depth));
 	} while (size != 0);
 }
 
diff --git a/verify-state.h b/verify-state.h
index 603af70d..c055008e 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -22,24 +22,18 @@ struct thread_rand_state {
 	};
 };
 
-/*
- * For dumping current write state
- */
-struct file_comp {
-	uint64_t fileno;
-	uint64_t offset;
+/* a single inflight write */
+struct inflight_write {
+	uint64_t numberio;
 };
 
 struct thread_io_list {
-	uint64_t no_comps; /* Number of completions saved for the thread */
 	uint32_t depth; /* I/O depth of the job that saves the verify state */
-	uint32_t max_no_comps_per_file;
-	uint32_t nofiles;
-	uint64_t numberio;
+	uint64_t numberio; /* Number of issued writes */
 	uint64_t index;
 	struct thread_rand_state rand;
 	uint8_t name[64];
-	struct file_comp comps[0];
+	struct inflight_write inflight[0];
 };
 
 struct all_io_list {
@@ -63,18 +57,18 @@ extern void __verify_save_state(struct all_io_list *, const char *);
 extern void verify_save_state(int mask);
 extern int verify_load_state(struct thread_data *, const char *);
 extern void verify_free_state(struct thread_data *);
-extern int verify_state_should_stop(struct thread_data *, struct io_u *);
+extern int verify_state_should_stop(struct thread_data *, uint64_t);
 extern void verify_assign_state(struct thread_data *, void *);
 extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *);
 
-static inline size_t __thread_io_list_sz(uint32_t depth, uint32_t nofiles)
+static inline size_t __thread_io_list_sz(uint32_t depth)
 {
-	return sizeof(struct thread_io_list) + depth * nofiles * sizeof(struct file_comp);
+	return sizeof(struct thread_io_list) + depth * sizeof(struct inflight_write);
 }
 
 static inline size_t thread_io_list_sz(struct thread_io_list *s)
 {
-	return __thread_io_list_sz(le32_to_cpu(s->max_no_comps_per_file), le32_to_cpu(s->nofiles));
+	return __thread_io_list_sz(le32_to_cpu(s->depth));
 }
 
 static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
diff --git a/verify.c b/verify.c
index 04718f30..c7f43c06 100644
--- a/verify.c
+++ b/verify.c
@@ -922,6 +922,11 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 			hdr->magic, FIO_HDR_MAGIC);
 		goto err;
 	}
+	if (hdr->version != VERIFY_HEADER_VERSION) {
+		log_err("verify: unsupported header version %x, wanted %x. Are you trying to verify across versions of fio?",
+			hdr->version, VERIFY_HEADER_VERSION);
+		goto err;
+	}
 	if (hdr->len != hdr_len) {
 		log_err("verify: bad header length %u, wanted %u",
 			hdr->len, hdr_len);
@@ -951,8 +956,8 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	    !td->o.time_based)
 		if (td->o.verify_write_sequence)
 			if (hdr->numberio != io_u->numberio) {
-				log_err("verify: bad header numberio %"PRIu16
-					", wanted %"PRIu16,
+				log_err("verify: bad header numberio %"PRIu64
+					", wanted %"PRIu64,
 					hdr->numberio, io_u->numberio);
 				goto err;
 			}
@@ -1260,6 +1265,7 @@ static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
 	void *p = hdr;
 
 	hdr->magic = FIO_HDR_MAGIC;
+	hdr->version = VERIFY_HEADER_VERSION;
 	hdr->verify_type = td->o.verify;
 	hdr->len = header_len;
 	hdr->rand_seed = rand_seed;
@@ -1629,47 +1635,6 @@ int paste_blockoff(char *buf, unsigned int len, void *priv)
 	return 0;
 }
 
-static int __fill_file_completions(struct thread_data *td,
-				   struct thread_io_list *s,
-				   struct fio_file *f, unsigned int *index)
-{
-	unsigned int comps;
-	int i, j;
-
-	if (!f->last_write_comp)
-		return 0;
-
-	if (td->io_blocks[DDIR_WRITE] < td->last_write_comp_depth)
-		comps = td->io_blocks[DDIR_WRITE];
-	else
-		comps = td->last_write_comp_depth;
-
-	j = f->last_write_idx - 1;
-	for (i = 0; i < comps; i++) {
-		if (j == -1)
-			j = td->last_write_comp_depth - 1;
-		s->comps[*index].fileno = __cpu_to_le64(f->fileno);
-		s->comps[*index].offset = cpu_to_le64(f->last_write_comp[j]);
-		(*index)++;
-		j--;
-	}
-
-	return comps;
-}
-
-static int fill_file_completions(struct thread_data *td,
-				 struct thread_io_list *s, unsigned int *index)
-{
-	struct fio_file *f;
-	unsigned int i;
-	int comps = 0;
-
-	for_each_file(td, f, i)
-		comps += __fill_file_completions(td, s, f, index);
-
-	return comps;
-}
-
 struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 {
 	struct all_io_list *rep;
@@ -1690,7 +1655,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 			continue;
 		td->stop_io = 1;
 		td->flags |= TD_F_VSTATE_SAVED;
-		depth += (td->last_write_comp_depth * td->o.nr_files);
+		depth += (td->o.iodepth * td->o.nr_files);
 		nr++;
 	} end_for_each();
 
@@ -1699,7 +1664,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 
 	*sz = sizeof(*rep);
 	*sz += nr * sizeof(struct thread_io_list);
-	*sz += depth * sizeof(struct file_comp);
+	*sz += depth * sizeof(struct inflight_write);
 	rep = calloc(1, *sz);
 
 	rep->threads = cpu_to_le64((uint64_t) nr);
@@ -1707,18 +1672,15 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	next = &rep->state[0];
 	for_each_td(td) {
 		struct thread_io_list *s = next;
-		unsigned int comps, index = 0;
 
 		if (save_mask != IO_LIST_ALL && (__td_index + 1) != save_mask)
 			continue;
 
-		comps = fill_file_completions(td, s, &index);
+		for (int i = 0; i < td->o.iodepth; i++)
+			s->inflight[i].numberio = cpu_to_le64(atomic_load_acquire(&td->inflight_numberio[i]));
 
-		s->no_comps = cpu_to_le64((uint64_t) comps);
 		s->depth = cpu_to_le32((uint32_t) td->o.iodepth);
-		s->max_no_comps_per_file = cpu_to_le32((uint32_t) td->last_write_comp_depth);
-		s->nofiles = cpu_to_le32((uint32_t) td->o.nr_files);
-		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
+		s->numberio = cpu_to_le64((uint64_t) atomic_load_acquire(&td->inflight_issued));
 		s->index = cpu_to_le64((uint64_t) __td_index);
 		if (td->random_state.use64) {
 			s->rand.state64.s[0] = cpu_to_le64(td->random_state.state64.s1);
@@ -1846,10 +1808,7 @@ void verify_assign_state(struct thread_data *td, void *p)
 	struct thread_io_list *s = p;
 	int i;
 
-	s->no_comps = le64_to_cpu(s->no_comps);
 	s->depth = le32_to_cpu(s->depth);
-	s->max_no_comps_per_file = le32_to_cpu(s->max_no_comps_per_file);
-	s->nofiles = le32_to_cpu(s->nofiles);
 	s->numberio = le64_to_cpu(s->numberio);
 	s->rand.use64 = le64_to_cpu(s->rand.use64);
 
@@ -1861,9 +1820,9 @@ void verify_assign_state(struct thread_data *td, void *p)
 			s->rand.state32.s[i] = le32_to_cpu(s->rand.state32.s[i]);
 	}
 
-	for (i = 0; i < s->no_comps; i++) {
-		s->comps[i].fileno = le64_to_cpu(s->comps[i].fileno);
-		s->comps[i].offset = le64_to_cpu(s->comps[i].offset);
+	for (i = 0; i < s->depth; i++) {
+		s->inflight[i].numberio = le64_to_cpu(s->inflight[i].numberio);
+		dprint(FD_VERIFY, "verify_assign_state numberio=%"PRIu64", inflight[%d]=%"PRIu64"\n", s->numberio, i, s->inflight[i].numberio);
 	}
 
 	td->vstate = p;
@@ -1949,40 +1908,31 @@ err:
 /*
  * Use the loaded verify state to know when to stop doing verification
  */
-int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
+int verify_state_should_stop(struct thread_data *td, uint64_t numberio)
 {
 	struct thread_io_list *s = td->vstate;
-	struct fio_file *f = io_u->file;
 	int i;
 
-	if (!s || !f)
+	dprint(FD_VERIFY, "verify_state_should_stop numberio=%"PRIu64"\n", numberio);
+	if (!s)
 		return 0;
 
-	/*
-	 * If we're not into the window of issues - depth yet, continue. If
-	 * issue is shorter than depth, do check.
-	 */
-	if ((td->io_blocks[DDIR_READ] < s->depth ||
-	    s->numberio - td->io_blocks[DDIR_READ] > s->depth) &&
-	    s->numberio > s->depth)
-		return 0;
-
-	/*
-	 * We're in the window of having to check if this io was
-	 * completed or not. If the IO was seen as completed, then
-	 * lets verify it.
+	/* If the current seq is lower than the max issued seq, check to make sure
+	 * the write was not inflight.
 	 */
-	for (i = 0; i < s->no_comps; i++) {
-		if (s->comps[i].fileno != f->fileno)
-			continue;
-		if (io_u->verify_offset == s->comps[i].offset)
-			return 0;
+	if (numberio < s->numberio) {
+		for (i = 0; i < s->depth; i++) {
+			if (s->inflight[i].numberio == numberio) {
+				log_info("Stop verify because seq %"PRIu64" was an inflight write\n",
+					numberio);
+				return 1;
+			}
+		}
+	} else {
+		log_info("Stop verify because seq %"PRIu64" >= %"PRIu64"\n",
+			numberio, s->numberio);
+		return 1;
 	}
 
-	/*
-	 * Not found, we have to stop
-	 */
-	log_info("Stop verify because offset %llu in %s is not recorded in verify state\n",
-		 io_u->verify_offset, f->file_name);
-	return 1;
+	return 0;
 }
diff --git a/verify.h b/verify.h
index 539e6f6c..e361337c 100644
--- a/verify.h
+++ b/verify.h
@@ -32,6 +32,12 @@ enum {
 	VERIFY_NULL,			/* pretend to verify */
 };
 
+/*
+ * Set the high bit to distinguish versioned headers from older
+ * non-versioned headers.
+ */
+#define VERIFY_HEADER_VERSION 0x81
+
 /*
  * A header structure associated with each checksummed data block. It is
  * followed by a checksum specific header that contains the verification
@@ -39,14 +45,15 @@ enum {
  */
 struct verify_header {
 	uint16_t magic;
-	uint16_t verify_type;
+	uint8_t version;
+	uint8_t verify_type;
 	uint32_t len;
 	uint64_t rand_seed;
 	uint64_t offset;
 	uint32_t time_sec;
 	uint32_t time_nsec;
+	uint64_t numberio;
 	uint16_t thread;
-	uint16_t numberio;
 	uint32_t crc32;
 };
 
