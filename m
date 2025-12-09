Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1209032FA3A
	for <fio@vger.kernel.org>; Tue,  9 Dec 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765285213; cv=none; b=VCmrNdhmTCRqZcPYLefyq4FS3XO0jj6Z7WStVFls4KpOCGevTp8AjUmfsDA8aZpFVtKDjyW8jpA45mJKCMlUdV4WzpduYhNFgDHl3J4GuioSUwqkzPQWAVlDiNvxT6z46KUMbUenw4CHqldbrjFZPR+5l9j0fFgvBkBgUPZlsOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765285213; c=relaxed/simple;
	bh=CyirsseFXS8pO7726meTESPUciosG4fAmq/TfiA4lxo=;
	h=Subject:From:To:Date:Message-Id; b=a8kSCfdFRN2mJLuBNAHzAF5ikRPc37CT8g17I5cZuI9J3U7BtfhZ7f2lOYBoVGRENHASlWr6Qhmpxt7zL8MvZpHkXCvGEWQtiH9REyvpbBr0JpchKytCwG3/qGeJcdA+LWzu2FScJXkRc5wFiu9pvX7Wkqd+3ju7EuIj7iUogNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IkwrJtr4; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IkwrJtr4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=m3EibZWfE1AIxLyv80xlCes0pATwXbfoSt02fglqovM=; b=IkwrJtr4KFaV4wyfKrX21tbz5y
	WR6cu6QdNsMJP2uhMfDZXtDir4tZxTtBkDEIlNwAAgouNhbgdqnIhWOLdjESaFpUie1b0ZWbDuAKK
	lR9u2BEVqfz8jB6yIGuqrxlELbcFcl5sYLJEP9U9gDa73f1lZOvGDHv8O23x2zWYSM6g9U443q2cw
	xnBwBYS3WrgvrkkV07V8UK0u6BgOlmkDcz2NqvLhwkIlyqi0jbEFSmBFuyNgY6+tIOVE/z/tqkhPV
	taORwPgfAfaFJDS7HL2dOJtlGVx9b3Vp7CNxs9WaCQCtqoX1HzYmd9lbrJUrT0WiHIba9P6ta8vBK
	9hFYrhCQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSwSX-0000000BmJK-0NRy
	for fio@vger.kernel.org;
	Tue, 09 Dec 2025 12:04:49 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 320E81BC0170; Tue,  9 Dec 2025 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue,  9 Dec 2025 06:00:02 -0700
Message-Id: <20251209130002.320E81BC0170@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit de3d5e68dd017a6d6099913b7831bb94f46e49cc:

  Merge branch 'mmap-fixes' of https://github.com/geertj/fio (2025-11-24 06:50:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 26c77cd375fc48511fda408e924416746ea878af:

  Merge branch 'patch-1' of https://github.com/fmayer/fio (2025-12-08 19:06:30 -0700)

----------------------------------------------------------------
Florian Mayer (1):
      backend: fix OOB access in usec_for_io() with DDIR_SYNC

Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/fmayer/fio

 backend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index e09c210a..13c77552 100644
--- a/backend.c
+++ b/backend.c
@@ -1194,7 +1194,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 				td->rate_io_issue_bytes[__ddir] += blen;
 			}
 
-			if (should_check_rate(td)) {
+			if (ddir_rw(__ddir) && should_check_rate(td)) {
 				td->rate_next_io_time[__ddir] = usec_for_io(td, __ddir);
 				fio_gettime(&comp_time, NULL);
 			}
@@ -1202,7 +1202,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		} else {
 			ret = io_u_submit(td, io_u);
 
-			if (should_check_rate(td))
+			if (ddir_rw(ddir) && should_check_rate(td))
 				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
 
 			if (io_queue_event(td, io_u, &ret, ddir, &bytes_issued, 0, &comp_time))
