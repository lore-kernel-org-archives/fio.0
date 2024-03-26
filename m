Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A676E61E
	for <fio@vger.kernel.org>; Tue, 26 Mar 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711454419; cv=none; b=GjdjFzd3uNrcM1mFVA82UhZ/16Swtes1q/hh37U97BOT6H6WtoAtlAk2x9HW18ndUvMO9ebC021LgowiV5yDqhaBKfNQyaGYvzE00Sv3iQC5SZlgcOFjpvbSNdpmL268OBOn2Z+njXxq5KLUtPJnq2vFK2o4jTinhR0ciqYNQmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711454419; c=relaxed/simple;
	bh=OszE4R3Meyv4CNKqQgUVNWlsy/SzvOXAnrk1K3i3sAM=;
	h=Subject:From:To:Message-Id:Date; b=kknWeO6EM9YqzdXoW4B8dyZahRiyDeB7OT58jAhOPf/uq8gxv8WgLNuYjjKdiCN/fxGMEkUACU/GjsGto2Y+6lygIxrdZMeM4nlhQ9h0Z5ZbGs1GcjGyF3h14AM0AdyYEY8HgZj79aJPkyKmBajYY9Papm93RnFkigz1enHQFaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=drZuCxas; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="drZuCxas"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yqBL44wtw+RMcEqfagAEwBuMyINtYepEWVUtRPpmxT8=; b=drZuCxasH44RgX95R6XIMN0gzK
	+gWsARPhRT4gyVCDwgKFKlBRXwzNtpXH70MN+cZsOq5GQbcFG/FOQfN3nuuKapZ1PFa7220h5e6RI
	KcMfpOzcpW0rrjSZp0URJIYdohKv8riiw8SlXrvPm5cKQrx3UVMLcnL0Fh1swSMOEJCDJzL5/s/Xh
	tjRHjMfH1ifJunkWT8dtJHhh00aQxw+H71skVnrx4i4cKr3pzFkbwPEwvbnUOauYHH4HVhD1yiVg7
	n8hveD9KJEQg0k7GdjMhPcroP2GFVZWiN6H4Wr2Qp3UcKV5GYtl9yCtVY87L8F1BSfVs7sCv4wOJ6
	RSu9rPCg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rp5TM-0000000H8pA-4AIh
	for fio@vger.kernel.org;
	Tue, 26 Mar 2024 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id DA1E81BC0157; Tue, 26 Mar 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240326120001.DA1E81BC0157@kernel.dk>
Date: Tue, 26 Mar 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2b03792ceb7ed00bd50db5b59486fab902295df8:

  Merge branch 'issue-1735' of https://github.com/yygcode/fio (2024-03-22 10:39:37 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b2403d413ee734e8835539319d8bc3429a0777ac:

  Merge branch 'delete-instead-of-unlink' of https://github.com/edigaryev/fio (2024-03-25 10:45:13 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'delete-instead-of-unlink' of https://github.com/edigaryev/fio

Nikolay Edigaryev (1):
      docs: use "delete" term instead of "unlink", which is less common

 HOWTO.rst | 4 ++--
 fio.1     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index fb067fe5..6a204072 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -971,13 +971,13 @@ Target file/device
 
 .. option:: unlink=bool
 
-	Unlink the job files when done. Not the default, as repeated runs of that
+	Unlink (delete) the job files when done. Not the default, as repeated runs of that
 	job would then waste time recreating the file set again and again. Default:
 	false.
 
 .. option:: unlink_each_loop=bool
 
-	Unlink job files after each iteration or loop.  Default: false.
+	Unlink (delete) job files after each iteration or loop.  Default: false.
 
 .. option:: zonemode=str
 
diff --git a/fio.1 b/fio.1
index 63375c62..545bb872 100644
--- a/fio.1
+++ b/fio.1
@@ -749,12 +749,12 @@ same data multiple times. Thus it will not work on non-seekable I/O engines
 (e.g. network, splice). Default: false.
 .TP
 .BI unlink \fR=\fPbool
-Unlink the job files when done. Not the default, as repeated runs of that
+Unlink (delete) the job files when done. Not the default, as repeated runs of that
 job would then waste time recreating the file set again and again. Default:
 false.
 .TP
 .BI unlink_each_loop \fR=\fPbool
-Unlink job files after each iteration or loop. Default: false.
+Unlink (delete) job files after each iteration or loop. Default: false.
 .TP
 .BI zonemode \fR=\fPstr
 Accepted values are:
