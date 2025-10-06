Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1F52773E4
	for <fio@vger.kernel.org>; Mon,  6 Oct 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759752015; cv=none; b=MafEsm5D59N81BQ4cKAdj8W1aNLrWFYRmLdUwwMfHpc7pqEAp8TOtL7Vldm0I2Tza4GxpYBvO2z0mEhaK2Y3LvyodIRhhKvQmD0dVG1utNYtFerE3jtHf4nDKCQmU39HJXkfU8ksS8A0inyYxCiVZ/M60GlwYSVjYc3PaGpuyxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759752015; c=relaxed/simple;
	bh=2WMfgu1U5f7syupgxLUdTSzqi+7pQovjGyHmL4NuEHg=;
	h=Subject:From:To:Date:Message-Id; b=B59UcKQFlB3uvivdJs9RB8sBYKAe0XQ1SJJnSc1m/HOVsfls9q8g0FKMubKrUZAjVbSLpdQ2ZTHe648SclZdVqJ9drW1Nv8MZhciFSUtjo7FWbfIEBDFCI3/blHNIZ+aS+SI6Q4OsefrBS7Jqih6sdmPIbfdl6c8MaVLJn9zvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T8z/UCx6; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T8z/UCx6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vwZh4XPmQTNEy+ozpQnXAiQqgtIU8vKe5GmLTJuhQoo=; b=T8z/UCx6XlpxysnFAqm454BBmO
	PyraotIieFTdf6NfY4lcBNAvZg6e09nGiH7IfSNBccbOzHIo4jZalBeyE2mxlr8tYXp4SrqLiqyIk
	wvEcNh8rVrK+CEv9vxYFmkU97XYZcthLMihNzh/ewCYPyi12+YhFRdrKfsM7cP2vLwFzkMnHwfO2i
	+lFUGaCs7cYbPYTKMC+L2nuNuASAYRlU7LKQp8b1g8hdDwVoxrftVKmMpJfwl0XaNvaRmgvmvj1J2
	S7u8CqZd6LJbFp/+3WHD12tGWreLGG4XwxTXOjGYJWdMSbMSPN7UUPXti2GJWm9OuCJW5H4ituY5P
	IldauU/A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5jst-0000000Gtl7-2BFK
	for fio@vger.kernel.org;
	Mon, 06 Oct 2025 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3E1601BC0150; Mon,  6 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.14)
Date: Mon,  6 Oct 2025 06:00:01 -0600
Message-Id: <20251006120001.3E1601BC0150@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9806424ae0ce388c8dad1687864b02dee3d8e0d2:

  REPORTING-BUGS: add note about reports on malicious job files (2025-10-04 16:57:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 925a31571d2d28c319a20b70d37513463b7fad30:

  Merge branch 'uncached_doc' of https://github.com/Panky-codes/fio (2025-10-05 14:25:54 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'uncached_doc' of https://github.com/Panky-codes/fio

Pankaj Raghav (1):
      doc: add documentation for uncached buffered I/O

 HOWTO.rst | 13 +++++++++++++
 fio.1     | 12 ++++++++++++
 2 files changed, 25 insertions(+)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 3a4e018f..9f55a73b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2565,6 +2565,19 @@ with the caveat that when used on the command line, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't required,
 	file blocks are fully allocated and the disk request could be issued immediately.
 
+.. option:: uncached=int : [pvsync2] [io_uring]
+
+	This option will perform buffered IO without retaining data in the
+	page cache after the operation completes.
+
+	Reads work like a normal buffered read but pages are evicted immediately
+	after data is copied to userspace. Writes work like buffered writes but
+	a writeback is initiated before the syscall returns. Pages are evicted
+	once the writeback completes.
+
+	This option sets the RWF_UNCACHED flag (supported from the 6.14 Linux kernel) on
+	a per-IO basis.
+
 .. option:: atomic=bool : [pvsync2] [libaio] [io_uring]
 
 	This option means that writes are issued with torn-write protection, meaning
diff --git a/fio.1 b/fio.1
index bee06048..5036b4f9 100644
--- a/fio.1
+++ b/fio.1
@@ -2320,6 +2320,18 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't required,
 file blocks are fully allocated and the disk request could be issued immediately.
 .TP
+.BI (pvsync2,io_uring)uncached \fR=\fPint
+This option will perform buffered IO without retaining data in the
+page cache after the operation completes.
+
+Reads work like a normal buffered read but pages are evicted immediately
+after data is copied to userspace. Writes work like buffered writes but
+a writeback is initiated before the syscall returns. Pages are evicted
+once the writeback completes.
+
+This option sets the RWF_UNCACHED flag (supported from the 6.14 Linux kernel) on
+a per-IO basis.
+.TP
 .BI (pvsync2,libaio,io_uring)atomic \fR=\fPbool
 This option means that writes are issued with torn-write protection, meaning
 that for a power fail or kernel crash, all or none of the data from the write
