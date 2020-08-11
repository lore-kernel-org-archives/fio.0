Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbgHKMAZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Aug 2020 08:00:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF6BC06174A
        for <fio@vger.kernel.org>; Tue, 11 Aug 2020 05:00:25 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5Sws-0001uQ-2O
        for fio@vger.kernel.org; Tue, 11 Aug 2020 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200811120002.75B6A1BC01AA@kernel.dk>
Date: Tue, 11 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f0ed01ed095cf1ca7c1945a5a0267e8f73b7b4a9:

  Merge branch 'master' of https://github.com/donny372/fio into master (2020-08-07 18:21:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cb7d7abbab67e03c901bfaf9517e0cae40a548bf:

  io_u: set io_u->verify_offset in fill_io_u() (2020-08-10 21:40:59 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      engines/io_uring: make sure state is updated for requeues
      io_u: reset ->resid on starting a requeue IO
      io_uring: notice short IO on completion path
      verify: use origina offset for verification
      io_u: get_next_offset() should always set io_u->verify_offset
      io_u: set io_u->verify_offset in fill_io_u()

 engines/io_uring.c | 16 ++++++++++++----
 io_u.c             | 23 +++++++++++++++++++++--
 io_u.h             |  3 ++-
 iolog.c            |  1 +
 verify.c           | 27 ++++++++++++++-------------
 5 files changed, 50 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 0ccd2318..57925594 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -234,13 +234,21 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
+			struct iovec *iov = &ld->iovecs[io_u->index];
+
+			/*
+			 * Update based on actual io_u, requeue could have
+			 * adjusted these
+			 */
+			iov->iov_base = io_u->xfer_buf;
+			iov->iov_len = io_u->xfer_buflen;
+
 			sqe->opcode = ddir_to_op[io_u->ddir][!!o->nonvectored];
 			if (o->nonvectored) {
-				sqe->addr = (unsigned long)
-						ld->iovecs[io_u->index].iov_base;
-				sqe->len = ld->iovecs[io_u->index].iov_len;
+				sqe->addr = (unsigned long) iov->iov_base;
+				sqe->len = iov->iov_len;
 			} else {
-				sqe->addr = (unsigned long) &ld->iovecs[io_u->index];
+				sqe->addr = (unsigned long) iov;
 				sqe->len = 1;
 			}
 		}
diff --git a/io_u.c b/io_u.c
index 6a729e51..dbb0a6f8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -464,6 +464,7 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 			log_err("fio: bug in offset generation: offset=%llu, b=%llu\n", (unsigned long long) offset, (unsigned long long) b);
 			ret = 1;
 		}
+		io_u->verify_offset = io_u->offset;
 	}
 
 	return ret;
@@ -506,6 +507,7 @@ static int get_next_offset(struct thread_data *td, struct io_u *io_u,
 		return 1;
 	}
 
+	io_u->verify_offset = io_u->offset;
 	return 0;
 }
 
@@ -964,6 +966,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 
 out:
 	dprint_io_u(io_u, "fill");
+	io_u->verify_offset = io_u->offset;
 	td->zone_bytes += io_u->buflen;
 	return 0;
 }
@@ -1564,9 +1567,10 @@ struct io_u *__get_io_u(struct thread_data *td)
 		__td_io_u_lock(td);
 
 again:
-	if (!io_u_rempty(&td->io_u_requeues))
+	if (!io_u_rempty(&td->io_u_requeues)) {
 		io_u = io_u_rpop(&td->io_u_requeues);
-	else if (!queue_full(td)) {
+		io_u->resid = 0;
+	} else if (!queue_full(td)) {
 		io_u = io_u_qpop(&td->io_u_freelist);
 
 		io_u->file = NULL;
@@ -1976,6 +1980,21 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		unsigned long long bytes = io_u->buflen - io_u->resid;
 		int ret;
 
+		/*
+		 * Make sure we notice short IO from here, and requeue them
+		 * appropriately!
+		 */
+		if (io_u->resid) {
+			io_u->xfer_buflen = io_u->resid;
+			io_u->xfer_buf += bytes;
+			io_u->offset += bytes;
+			td->ts.short_io_u[io_u->ddir]++;
+			if (io_u->offset < io_u->file->real_file_size) {
+				requeue_io_u(td, io_u_ptr);
+				return;
+			}
+		}
+
 		td->io_blocks[ddir]++;
 		td->io_bytes[ddir] += bytes;
 
diff --git a/io_u.h b/io_u.h
index 87c29201..31100928 100644
--- a/io_u.h
+++ b/io_u.h
@@ -53,7 +53,8 @@ struct io_u {
 	 * Allocated/set buffer and length
 	 */
 	unsigned long long buflen;
-	unsigned long long offset;
+	unsigned long long offset;	/* is really ->xfer_offset... */
+	unsigned long long verify_offset;	/* is really ->offset */
 	void *buf;
 
 	/*
diff --git a/iolog.c b/iolog.c
index 7f21be51..fa40c857 100644
--- a/iolog.c
+++ b/iolog.c
@@ -174,6 +174,7 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 		io_u->ddir = ipo->ddir;
 		if (ipo->ddir != DDIR_WAIT) {
 			io_u->offset = ipo->offset;
+			io_u->verify_offset = ipo->offset;
 			io_u->buflen = ipo->len;
 			io_u->file = td->files[ipo->fileno];
 			get_file(io_u->file);
diff --git a/verify.c b/verify.c
index 5ee0029d..a418c054 100644
--- a/verify.c
+++ b/verify.c
@@ -302,7 +302,7 @@ static void __dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 	 */
 	hdr_offset = vc->hdr_num * hdr->len;
 
-	dump_buf(io_u->buf + hdr_offset, hdr->len, io_u->offset + hdr_offset,
+	dump_buf(io_u->buf + hdr_offset, hdr->len, io_u->verify_offset + hdr_offset,
 			"received", vc->io_u->file);
 
 	/*
@@ -317,7 +317,7 @@ static void __dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 
 	fill_pattern_headers(td, &dummy, hdr->rand_seed, 1);
 
-	dump_buf(buf + hdr_offset, hdr->len, io_u->offset + hdr_offset,
+	dump_buf(buf + hdr_offset, hdr->len, io_u->verify_offset + hdr_offset,
 			"expected", vc->io_u->file);
 	free(buf);
 }
@@ -339,12 +339,12 @@ static void log_verify_failure(struct verify_header *hdr, struct vcont *vc)
 {
 	unsigned long long offset;
 
-	offset = vc->io_u->offset;
+	offset = vc->io_u->verify_offset;
 	offset += vc->hdr_num * hdr->len;
 	log_err("%.8s: verify failed at file %s offset %llu, length %u"
-			" (requested block: offset=%llu, length=%llu)\n",
+			" (requested block: offset=%llu, length=%llu, flags=%x)\n",
 			vc->name, vc->io_u->file->file_name, offset, hdr->len,
-			vc->io_u->offset, vc->io_u->buflen);
+			vc->io_u->verify_offset, vc->io_u->buflen, vc->io_u->flags);
 
 	if (vc->good_crc && vc->bad_crc) {
 		log_err("       Expected CRC: ");
@@ -801,7 +801,7 @@ static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
 
 	log_err("trim: verify failed at file %s offset %llu, length %llu"
 		", block offset %lu\n",
-			io_u->file->file_name, io_u->offset, io_u->buflen,
+			io_u->file->file_name, io_u->verify_offset, io_u->buflen,
 			(unsigned long) offset);
 	return EILSEQ;
 }
@@ -829,10 +829,10 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 			hdr->rand_seed, io_u->rand_seed);
 		goto err;
 	}
-	if (hdr->offset != io_u->offset + hdr_num * td->o.verify_interval) {
+	if (hdr->offset != io_u->verify_offset + hdr_num * td->o.verify_interval) {
 		log_err("verify: bad header offset %"PRIu64
 			", wanted %llu",
-			hdr->offset, io_u->offset);
+			hdr->offset, io_u->verify_offset);
 		goto err;
 	}
 
@@ -864,11 +864,11 @@ err:
 	log_err(" at file %s offset %llu, length %u"
 		" (requested block: offset=%llu, length=%llu)\n",
 		io_u->file->file_name,
-		io_u->offset + hdr_num * hdr_len, hdr_len,
-		io_u->offset, io_u->buflen);
+		io_u->verify_offset + hdr_num * hdr_len, hdr_len,
+		io_u->verify_offset, io_u->buflen);
 
 	if (td->o.verify_dump)
-		dump_buf(p, hdr_len, io_u->offset + hdr_num * hdr_len,
+		dump_buf(p, hdr_len, io_u->verify_offset + hdr_num * hdr_len,
 				"hdr_fail", io_u->file);
 
 	return EILSEQ;
@@ -1156,7 +1156,7 @@ static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
 	hdr->verify_type = td->o.verify;
 	hdr->len = header_len;
 	hdr->rand_seed = rand_seed;
-	hdr->offset = io_u->offset + header_num * td->o.verify_interval;
+	hdr->offset = io_u->verify_offset + header_num * td->o.verify_interval;
 	hdr->time_sec = io_u->start_time.tv_sec;
 	hdr->time_nsec = io_u->start_time.tv_nsec;
 	hdr->thread = td->thread_number;
@@ -1334,6 +1334,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		td->io_hist_len--;
 
 		io_u->offset = ipo->offset;
+		io_u->verify_offset = ipo->offset;
 		io_u->buflen = ipo->len;
 		io_u->numberio = ipo->numberio;
 		io_u->file = ipo->file;
@@ -1866,7 +1867,7 @@ int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 	for (i = 0; i < s->no_comps; i++) {
 		if (s->comps[i].fileno != f->fileno)
 			continue;
-		if (io_u->offset == s->comps[i].offset)
+		if (io_u->verify_offset == s->comps[i].offset)
 			return 0;
 	}
 

