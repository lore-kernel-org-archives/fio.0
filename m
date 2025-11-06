Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D8D33B6F1
	for <fio@vger.kernel.org>; Thu,  6 Nov 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762434011; cv=none; b=Q3rIsSAFVM1XmMesZHkJczhsC48wyuKVRSb842IkR1x3uUJA2yaZdH3oa+F3Up0py6bu8r9LgajAQ1Xk8J/cQ6VGUl88MwlnVvCcXkOHVyKFFy58+gUZiiTAyWB23ixyWDLnDVREM+mn4BMRb0B5zU3naCe5YozSDWreEbUl364=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762434011; c=relaxed/simple;
	bh=H/4Ss/317YhqShJD8Hmpe/KMaLReaNdAGE0S+q9HUxY=;
	h=Subject:From:To:Date:Message-Id; b=cg2yFs5+VRrppkgJlVj9bdVLUTIOtDQwKDSJFpcOvSQ7yVIfAw5qu6SA1gR/a0pZnzBBlEgF2Ugu9KadtdLy2RQUobY58O9a//Qx/ypR/GYu+hwSMad2d8lJ6qYXjyZo2bSW1TusYmf8904xhnx08pal6TR6ugwpU9vYmOCHu8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BGXxerO6; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BGXxerO6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Tf9zRqJTRUWmAJX2NOwU1JU4V76qkpLtRpoqWIu9Kzg=; b=BGXxerO6+37+CgijcQzxbQf9pj
	T8c8lRMiBq/4f6hw1Iva/Wxl7ncNAOnQTaVzM3S7/ZFONB/u13ygb84/jdO/GiK/s36eoEr7EO/Y1
	3sVVFpa1tWntVSveLywwFkRDOpS7YXM2vjwSN+lNYfXRQFxfP4E4sHDn6nc2q2rXvA0QxLyymt2nu
	H7ze4XprPXTxRLcX64j3wSEOtDgl7JDdSo6PtLPrHsKu889IrOWuYAwO4NmfwAxYKfm9vgWAqJdqM
	syxEEuZNVgcgep6FawjPRhTVlQOx/Afh0BydJTzRqJqJry1fiySnQTsWSyczrcWu1oDQJnr8OlCTV
	hyn0pUew==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGzat-00000002MnY-2MMB
	for fio@vger.kernel.org;
	Thu, 06 Nov 2025 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C5B231BC0121; Thu,  6 Nov 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  6 Nov 2025 06:00:01 -0700
Message-Id: <20251106130001.C5B231BC0121@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9f87cd24973b122a8c8eda9bfbcee81edcac5112:

  engines/ftruncate: update git tree reference (2025-10-31 14:53:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f5b2f2366bc2a05876fcf6044e18098ab2a7f343:

  Merge branch 'end-fsync-io_u' of https://github.com/JeongJonghwi/fio (2025-11-05 18:33:39 -0500)

----------------------------------------------------------------
Jonghwi Jeong (1):
      io_u: put io_u->file from requeue in FSYNCING

Vincent Fu (1):
      Merge branch 'end-fsync-io_u' of https://github.com/JeongJonghwi/fio

 io_u.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index ab1bf7c9..ec3f668c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1727,9 +1727,13 @@ struct io_u *__get_io_u(struct thread_data *td)
 		__td_io_u_lock(td);
 
 again:
-	if (td->runstate != TD_FSYNCING && !io_u_rempty(&td->io_u_requeues)) {
+	if (!io_u_rempty(&td->io_u_requeues)) {
 		io_u = io_u_rpop(&td->io_u_requeues);
 		io_u->resid = 0;
+		if (io_u->file && td->runstate == TD_FSYNCING) {
+			put_file_log(td, io_u->file);
+			io_u->file = NULL;
+		}
 	} else if (!queue_full(td)) {
 		io_u = io_u_qpop(&td->io_u_freelist);
 
