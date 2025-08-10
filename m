Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F871B2186
	for <fio@vger.kernel.org>; Sun, 10 Aug 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754827211; cv=none; b=rreSLr4gZQet5U7A8C+Z5Wjm2XMyY+VgfOh71obQXR/c5eBd/2yRCXz27ggHuIhDRv29GXN7iGx+a3T6Z2wWJW+l1m08W4J2HVVRG94Vfxwd8tM5WzkGEjeD4e1CivYpX31QcOyRGmU2KwrAVKQwv2puKEe+iD18NNT9IQsl4as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754827211; c=relaxed/simple;
	bh=O7OwjwoVsOzPNzBucJNjKVv8WkQOjagAM39de6IbF3Q=;
	h=Subject:From:To:Message-Id:Date; b=aKgeWK5y+FAAMzLM0b9QeQWFSOzh6u/tc6oXJfYAtZWIGC40rw20qOVCgWPyvxzCRLEPn3JzYl+ljJG6o7KdZCl947hLTJ8n/mupaJkGn7MCUB+MsHY6j1JWXwXB3KTnO9Th+55W4vVfQtpL8ZQuwBimYqZPlj3PQDLgNZKzBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FOuWY7+z; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FOuWY7+z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CnKYgPJe8/ZNRPFCAm/HKrDhVy6zvQ1Clq5EMf6yw2Q=; b=FOuWY7+zFox9AVUYOeHd6Iq8cG
	ZJenOq+ebOegUIXlME6Q2h7KHYbfcS8EQb+/Oend4of+NTWGUX56bT0uEIYifW+yZr/F2z/Zm7jiF
	aMPSdEFnsM0EttwM6VWe42JwRJP1Dv5JhL7hDwh6KHQluW1Pkp1hTZJsvI3m4FtNezL0qm09IEz+C
	sUAIV8KJC8VI2ro3EWFGvCbKlrayNyPQ+YFy91FbmLAeGKuI1ON43L+uIORAu+F0sAX4rfiHcPtex
	tXzKmuybbGVjV2L0Fa586G/tgBvtMpnhfiDUG5bbDuHnZl9x3xjSvSJ6R875qZRCDCv424mdTEs8z
	o/jlF8OQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ul4iZ-00000008Rrf-26jB
	for fio@vger.kernel.org;
	Sun, 10 Aug 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 539271BC0178; Sun, 10 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250810120001.539271BC0178@kernel.dk>
Date: Sun, 10 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f95cf49e1d2a8d2babb8aa385fb902d927533644:

  crc: use ISA-L for crc64 NVMe if available (2025-08-07 10:54:04 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a52833b3295f0fae160eb3d4937a371756d6d929:

  verify: bump up verify state file version (2025-08-09 08:27:59 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      verify: fix write tracking in error cases
      verify: bump up verify state file version

 backend.c      |  2 ++
 io_u.c         | 11 +++++++++--
 verify-state.h |  2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 922309a0..858506c4 100644
--- a/backend.c
+++ b/backend.c
@@ -449,6 +449,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 	case FIO_Q_COMPLETED:
 		if (io_u->error) {
 			*ret = -io_u->error;
+			invalidate_inflight(td, io_u);
 			clear_io_u(td, io_u);
 		} else if (io_u->resid) {
 			long long bytes = io_u->xfer_buflen - io_u->resid;
@@ -467,6 +468,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 				if (!from_verify)
 					unlog_io_piece(td, io_u);
 				td_verror(td, EIO, "full resid");
+				invalidate_inflight(td, io_u);
 				clear_io_u(td, io_u);
 				break;
 			}
diff --git a/io_u.c b/io_u.c
index 6d0f32a8..78dbac9c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -869,9 +869,16 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 		__td_io_u_unlock(td);
 }
 
+static inline void io_u_clear_inflight_flags(struct thread_data *td,
+					      struct io_u *io_u)
+{
+	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK |
+		   IO_U_F_PATTERN_DONE);
+}
+
 void clear_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	io_u_clear(td, io_u, IO_U_F_FLIGHT);
+	io_u_clear_inflight_flags(td, io_u);
 	put_io_u(td, io_u);
 }
 
@@ -2090,7 +2097,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	dprint_io_u(io_u, "complete");
 
 	assert(io_u->flags & IO_U_F_FLIGHT);
-	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK | IO_U_F_PATTERN_DONE);
+	io_u_clear_inflight_flags(td, io_u);
 	invalidate_inflight(td, io_u);
 
 	if (td->o.zone_mode == ZONE_MODE_ZBD && td->o.recover_zbd_write_error &&
diff --git a/verify-state.h b/verify-state.h
index c055008e..d8997ace 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -41,7 +41,7 @@ struct all_io_list {
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION	0x04
+#define VSTATE_HDR_VERSION	0x05
 
 struct verify_state_hdr {
 	uint64_t version;
