Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795698007;
	b=vWsEOTeQHXEn3BvSc0lDKOYWq2F9vTk+9G8vlSSEEY3fJMlovDLkP5v/P57VJGxuKCer
	 3TiQu7J7P/Y/U9RAhHplPdaA/nAEnqGr+WKDue+kBtqn/lWUsdTJDsxPz1WV8c9U4cOgU
	 +ls9YoX56lU3Rt00/aGrnsgvVenL9qozJxCKt2IRtqBgMVgmtkzxx1roznHY/jMj6rcUj
	 JKZPhC4XfX1C+MA6UZunT/AiaGHGatlj5kOo3N7nD5Bae1w7RViTk+Hjipi+CLQrE6CPX
	 Ud2rCM4MnAIDxZdfZ/27vP9/lu92qRBwy6hByWUSQwGbYPvoJIfhcEKUIbaKcjwbpcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795698007;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=tdAD42vTQZ4Cqw6/nSWFN8L01xUrRb/Ba+k72xDMuUE=;
	b=WzNyLz9Nmah1/lUzZaaF+/P5E5/vdww8tQrUrdfeBSmW746oU+r6EC+WJAzfFvu0/Y2T
	 rrxzXPZQVd+kuyfgYIURVWx+Aj+qSbZYWYWp0G7noJukWjO8LEQwObCOsFWTFqDMtMCiy
	 hvsyIz1XFW5GGbRrEkuN1lMpG/Jq6ocCHDnZ5i8wHFWQZ6MoiGqtUj10dFwlwaFbmFHwT
	 n9gsz06dJns2jfNmBAqW8jHir2EBu05GuB/tqya2EoKs1BL27N4iA4I+XYYJH2inRBdjN
	 gnBOnhVv5WKnZbxnstqa1+pjEYyqxqCojx8Cgl2hflNB5Mc/pRqsJBS6PwOunnfw0EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=BRjV2+Tw;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461A7606A332
	for <fio@vger.kernel.org>; Thu, 26 Nov 2026 13:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 461A7606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=BRjV2+Tw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=tdAD42vTQZ4Cqw6/nSWFN8L01xUrRb/Ba+k72xDMuUE=; b=BRjV2+TwYDKtd1lgJ5RRD8bUsT
	KcQDRe21HjE15CdF5DxICsMFjcNTVmgE555+zlPATYxwLsA7lWZ3gRpjhs1jM4dZZ2kTm0SDZMb+D
	g2d0l79HpTyj4DxNrRQhw/W3E9i31O+mDEHgg4SxmMWs/DllUyEpW/amRCGfqsuI48VJQgFX8aFXc
	hH3jrS50gGtPArYYmjM9zYB9vgH0Y8cEABBogOEteFSLzZsTnoWjvwpx72jAg9lz2z/7HWNIP+zli
	t9BV8+IMGKa8TNKBzI6iL1Sb2hmyYOhRETUHVsOm4y51HLVfxX6RwQLqYvQ6DFahHQXQ6Z93zEsaw
	uc8gvWVA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWZ52-00000003fU8-1qjJ
	for fio@vger.kernel.org;
	Thu, 26 Nov 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C0BBD1BC018E; Thu, 26 Nov 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 26 Nov 2026 06:00:01 -0700
Message-Id: <20261126130001.C0BBD1BC018E@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 62880886059572ee9975ecdca60e7729c6ae36a8:

  Merge branch 'docs-offset-increment-suffixes' of https://github.com/insistxc/fio (2026-11-24 11:33:41 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4b513f9591cc858c03bf9584f6aad3c3a40869e4:

  doc: synchronize zoneskip and io_size entries (2026-11-24 12:09:47 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      doc: synchronize zoneskip and io_size entries

 HOWTO.rst | 7 +++++--
 fio.1     | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index c87abcb7..918cefc5 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1077,7 +1077,7 @@ Target file/device
 	capacity is obtained from the device information and this option is
 	ignored.
 
-.. option:: zoneskip=int
+.. option:: zoneskip=int[z]
 
 	For :option:`zonemode` =strided, the number of bytes to skip after
 	:option:`zonesize` bytes of data have been transferred. This parameter
@@ -2114,7 +2114,10 @@ I/O size
 	will perform I/O within the first 20GiB but exit when 5GiB have been
 	done. The opposite is also possible -- if :option:`size` is set to 20GiB,
 	and :option:`io_size` is set to 40GiB, then fio will do 40GiB of I/O within
-	the 0..20GiB region.
+        the 0..20GiB region. Value can be set as percentage:
+        :option:`io_size` =N%. In this case :option:`io_size` multiplies
+        :option:`size` value. In ZBD mode, value can also be set as number of
+        zones using 'z'.
 
 .. option:: filesize=irange(int)
 
diff --git a/fio.1 b/fio.1
index e7a89860..1f9ec1f9 100644
--- a/fio.1
+++ b/fio.1
@@ -852,7 +852,8 @@ option is ignored.
 .TP
 .BI zoneskip \fR=\fPint[z]
 For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
-bytes of data have been transferred.
+bytes of data have been transferred. This parameter must be zero for
+\fBzonemode\fR=zbd.
 
 For \fBzonemode\fR=zbd, the \fBzonesize\fR aligned number of bytes to skip
 once a zone is fully written (write workloads) or all written data in the
