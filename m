Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611612;
	b=VKZ6vaLymFEWoo+hTgCXt65BfBn2fCiRRCDi273pHV4/ROOcD2AjgbSrU/408XWtpovK
	 5yeRUaEYfYMHVEGCUtHyzhHSxIp4Ih6L4WBK20+ZgoCVanIjW+7CkvhshEl6T67uYRiQm
	 tP951akjkYBJriOP54hcbRRo5am2UPPuXVu0Jb3INDhO2IpjiBXjcdd6rqmVBIRS6peOx
	 qZHHEGiHUkY8hITE6eyT2TcJchAwAglirMSk2Qasz797oHjQYR/WMKVLb+lvHT8LaIpdk
	 NQtsCtjrPJux8oKB6hq9OQ7g7cD+mv8Dl/SaMEpr9ShW+Sr5gsxcQJtwSXCf2IXds2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611612;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=LowJvdgYceyN1uAdecg97igSLla4qHS7bIsA1pBVSVs=;
	b=Rdsey3Rgc4BWmOIptJ2Z+luzgh+1A+KXbOHovlGIDZNotORvJIydOG/gyYEjSkUJIywe
	 2aKP9uj+0VbsiNeGUiN95IF/Jm6o2J2iVhUweGmnS3OemTm1qaXvpNT8HltpwKxu9u7Ps
	 tyOOfZlfaIjRyh30pFSxXdXCACc7l6D5d0lK1n04M4rMXwSQ5vPTdXZLbi9oIfFGcujtN
	 zjKAMLd80A1Gn4hMsVs8k1j1V8fsxLumtwOWaa/tJItf7w3kQiYfOKzyAE3DMVHaOAsVe
	 VzIe1XgbpjlTredSJv46QS73XEd0ZRdVulQZ5gfdh/fLIO9e+vKKbc4OfLwrtgsvHXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=e98wy0jp;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAEB606A681
	for <fio@vger.kernel.org>; Wed, 25 Nov 2026 13:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FAEB606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=e98wy0jp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=LowJvdgYceyN1uAdecg97igSLla4qHS7bIsA1pBVSVs=; b=e98wy0jpzsx6SwDptHn+eQaIar
	RWNNwISqtYI5OZa0sZKE6MTLyrhJM3PscXnCq9rQOGeoGkIsNuQjtSSIt5SdQ4ajyoLDMFKgTXVxm
	zZr53TgFeSMXpov168878WTYcZIztdQhn0euTsmtYdF5S3Nd7TnA5GBTTa/11ztd1NQQSxdlaBbte
	vWAzKPMgUQxDPPFKzoNlCRfkWk7DNUHY9S2jyeuPTYCSVbQdTHp2SwrFCDSeTWnmLdp3lpty6+yfn
	/eO26OAUY9Vza7A1jrkblIUFj7O98Hb9qr69dUCvlUYTisBwWNuLlrC7TNTgu4LBNalk0CAEtvonu
	oU0Mtbgw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWCbW-0000000EEaf-2ICV
	for fio@vger.kernel.org;
	Wed, 25 Nov 2026 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1E7761BC0142; Wed, 25 Nov 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 25 Nov 2026 06:00:02 -0700
Message-Id: <20261125130002.1E7761BC0142@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 1fe61cc8e693496b2ca69b69cb41183e14eaa461:

  configure: add clock_gettime probe with -lpthread (2026-11-23 18:16:58 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 62880886059572ee9975ecdca60e7729c6ae36a8:

  Merge branch 'docs-offset-increment-suffixes' of https://github.com/insistxc/fio (2026-11-24 11:33:41 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'docs-offset-increment-suffixes' of https://github.com/insistxc/fio

xuchenchen (1):
      doc: show size and offset suffixes in HOWTO

 HOWTO.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0421893a..c87abcb7 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1433,7 +1433,7 @@ I/O type
 	The values are all relative to each other, and no absolute meaning
 	should be associated with them.
 
-.. option:: offset=int
+.. option:: offset=int[%|z]
 
 	Start I/O at the provided offset in the file, given as either a fixed size in
 	bytes, zones or a percentage. If a percentage is given, the generated offset will be
@@ -1451,7 +1451,7 @@ I/O type
 	is aligned upwards to this value. Defaults to 0 meaning that a percentage
 	offset is aligned to the minimum block size.
 
-.. option:: offset_increment=int
+.. option:: offset_increment=int[%|z]
 
 	If this is provided, then the real offset becomes `offset + offset_increment
 	* thread_number`, where the thread number is a counter that starts at 0 and
@@ -2084,7 +2084,7 @@ Buffers and memory
 I/O size
 ~~~~~~~~
 
-.. option:: size=int
+.. option:: size=int[%|z]
 
 	The total size of file I/O for each thread of this job. Fio will run until
 	this many bytes has been transferred, unless runtime is altered by other means
@@ -2104,7 +2104,7 @@ I/O size
 	Can be combined with :option:`offset` to constrain the start and end range
 	that I/O will be done within.
 
-.. option:: io_size=int, io_limit=int
+.. option:: io_size=int[%|z], io_limit=int[%|z]
 
 	Normally fio operates within the region set by :option:`size`, which means
 	that the :option:`size` option sets both the region and size of I/O to be
