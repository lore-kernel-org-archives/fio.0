Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363684418E3
	for <fio@vger.kernel.org>; Tue, 16 Jun 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611211; cv=none; b=nx37i7LcHMuKfLkYe3NoUzGW+s9ntrZb5k6C5oQQg0cIWY4W9F14/xNQBO9TZdtsUzoMUjZgqS3CsPYRogQvQkO9yfcbX3EJMB5b++p7633c5xPO2oqGxyABGL1aNLKVyJuVn04vju0nCIYonmtPu0XeXQxuBCkxUkAaAlUHhk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611211; c=relaxed/simple;
	bh=satR9zDsXwflViLDXIeRRUolaR28qU+bcFaUz6dkSdM=;
	h=Subject:From:To:Date:Message-Id; b=IB/MOx9MpZZx2je9wY60YLCSQ5MObGdnQACzgFf9DspfX/qwgawdBlrRqJbbKf50gq9DDJ2vXj/9eJx7dryH8d7fdBJGILG6MxwWrwWg45urVmJS5c4Q/So/izwJ67T1wVLPtKhdwTsAddYIrAjUAFRTfor6JLj1heIi6yLa1Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TsLAExcG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TsLAExcG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YquR7dw9AnxJcp4ZSjOiKSjL4CV0kvrbl+DtVHv507g=; b=TsLAExcGhAj+lWXe4NCBvX+fmJ
	bjQz+V3b/OxZo84UwF00uI8MFgy3p9fjBcOTg2yR+FmIUN9Ke7FqIgPcukbJ51TflXg9/IkBBreOb
	K0M481vUvTbAs238KVJ4bx6WesEtz8VA+Yyl04WJo/uU0xPWPfUAs0SNBKrs3QpwUpi+jxycbMdEt
	0weBxR2Q8NxbByuEvmMw5HXBGJTjij4WewWQrBgILp1FcESirpGn763W+xUVgFo0FEOeIIJHKIcIa
	zmmjxdeR4LfVqMirE6PE2GMh46GVZHGTblS8orC+B12JiHqDASRoKqOt3YiewjBmvVvVtnLYd25x3
	JzSvtPSQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZSSa-0000000Agtk-1aeD
	for fio@vger.kernel.org;
	Tue, 16 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B84781BC0171; Tue, 16 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 16 Jun 2026 06:00:01 -0600
Message-Id: <20260616120001.B84781BC0171@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 19a6a29c6ba25ceb2caa89f1a601cc3a08ab981a:

  engines/io_uring: code style tweak (2026-06-13 06:32:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fb5b6ae8913be8032beb6cbfe0a4772c74d78cb2:

  Merge branch 'pr-speed-up-norandommap-read-bw' of https://github.com/malikoyv/fio (2026-06-15 11:29:22 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'pr-speed-up-norandommap-read-bw' of https://github.com/malikoyv/fio

Yehor Malikov (2):
      verify: fix verify starvation with norandommap
      iolog: fix io_piece leak on overlapping in-flight writes

 io_u.c   | 20 ++++++++++++++++----
 iolog.c  |  1 +
 verify.c | 18 +++++++++++++-----
 3 files changed, 30 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index c3327f16..5d704a33 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2167,11 +2167,23 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		/*
 		 * Remove errored entry from the verification list
 		 */
-		if (io_u->error)
+		if (io_u->error) {
 			unlog_io_piece(td, io_u);
-		else {
-			atomic_store_release(&io_u->ipo->flags,
-					io_u->ipo->flags & ~IP_F_IN_FLIGHT);
+		} else {
+			unsigned int flags = io_u->ipo->flags & ~IP_F_IN_FLIGHT;
+
+			/*
+			 * If the io_piece was evicted from the verification
+			 * tree due to an overlapping write while in-flight,
+			 * it is no longer reachable for verification. Free
+			 * it here to avoid a memory leak.
+			 */
+			if (!(flags & (IP_F_ONRB | IP_F_ONLIST))) {
+				free(io_u->ipo);
+				io_u->ipo = NULL;
+			} else {
+				atomic_store_release(&io_u->ipo->flags, flags);
+			}
 		}
 	}
 
diff --git a/iolog.c b/iolog.c
index df862ea6..36fcad37 100644
--- a/iolog.c
+++ b/iolog.c
@@ -353,6 +353,7 @@ restart:
 				ipo->offset, ipo->len);
 			td->io_hist_len--;
 			rb_erase(parent, &td->io_hist_tree);
+			__ipo->flags &= ~IP_F_ONRB;
 			remove_trim_entry(td, __ipo);
 			if (!(__ipo->flags & IP_F_IN_FLIGHT))
 				free(__ipo);
diff --git a/verify.c b/verify.c
index d8312815..633a9bb2 100644
--- a/verify.c
+++ b/verify.c
@@ -1425,15 +1425,23 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 	if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {
 		struct fio_rb_node *n = rb_first(&td->io_hist_tree);
 
-		ipo = rb_entry(n, struct io_piece, rb_node);
-
 		/*
-		 * Ensure that the associated IO has completed
+		 * Walk the tree to find the first entry whose IO has
+		 * completed. The tree is sorted by offset, so the first
+		 * entry may still be in-flight while later entries are
+		 * already done.
 		 */
-		if (atomic_load_acquire(&ipo->flags) & IP_F_IN_FLIGHT)
+		while (n) {
+			ipo = rb_entry(n, struct io_piece, rb_node);
+			if (!(atomic_load_acquire(&ipo->flags) & IP_F_IN_FLIGHT))
+				break;
+			n = rb_next(n);
+		}
+
+		if (!n)
 			goto nothing;
 
-		rb_erase(n, &td->io_hist_tree);
+		rb_erase(&ipo->rb_node, &td->io_hist_tree);
 		assert(ipo->flags & IP_F_ONRB);
 		ipo->flags &= ~IP_F_ONRB;
 	} else if (!flist_empty(&td->io_hist_list)) {
