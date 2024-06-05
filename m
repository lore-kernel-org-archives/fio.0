Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426621946DE
	for <fio@vger.kernel.org>; Wed,  5 Jun 2024 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588818; cv=none; b=ZMWhRIXEWW+zeMjqqJRG+Qxlk2Ynm0CflzhG2l3dAVBkcBfCUqqevBPJAYdjt8/P6ifq3aoyPpA1Obr4Br+s9ERiP/SNfMug+lrl2RcpiAQJXGcqMtih6tDnc2dO3LJ2GmNLChg2T+8ou61wHk4X3+ANTDRDTpE8ss6u2SyzfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588818; c=relaxed/simple;
	bh=g71zma0sm0f/3pFByOmJIpZXBU1EmP3cVbRX2qBdnPU=;
	h=Subject:From:To:Message-Id:Date; b=Wcs18pECckUFnAmL+hb+8lbNxTvsVMnD+Ghe6z7kjT7UoicxapvuC5q7dz1FztvdQifMEoZsni9RXSvO5XXO2qDiBry8HYD38XdfjMsFKnWlytoHhjklfdeVWZehXeAFO/1zFGU4dNQ8R0DDMxOGveSYrgOlTHY9t06rQObeeAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MW8hOR1b; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MW8hOR1b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hCwNYbCe1EDhumdUO4I5jiZvxG8TylgoG6oGPMfMe2E=; b=MW8hOR1bDDlGnOxHNTqLh1TO4r
	7Vdr4m3SMDLhA4FiuVfI4+kq1yUSLv8evhPVDUjURZgEOxiDkArOmQfFUmyPHtoK9M0R+ra2z2pnb
	u3H9Svkd1o37CJwoK9Mts5gDau/yqWlwzYhlYimcu69Q+ICzeEfar1WksNIW/rkEr2hYt7QYtAi1S
	O4JAj5OXLw1BCCzg8CQBJ7bpXOsYjb9AVWI7l2Z8FooZPzm/94tFQjoLv+Z8jtzLQix1HISPNTJ7m
	jWTxSWHk+kz3vcI0gbYdqs0EKqv5Ob2Cb6hIzPkEho9v2io91zX0l4AAxa5op9UKj1wzfBfQwJZ2T
	Vwv4RBCA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEpJK-0000000Fmfu-1LdL
	for fio@vger.kernel.org;
	Wed, 05 Jun 2024 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 50AFE1BC0154; Wed,  5 Jun 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240605120001.50AFE1BC0154@kernel.dk>
Date: Wed,  5 Jun 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1757469a81cac5bd662b9cde26f1e5d4f0402181:

  Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio (2024-06-03 10:17:38 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6e039133f1fe30b1abf742423019836c4d1e8123:

  docs: fix operations misspellings (2024-06-04 08:53:07 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      docs: fix operations misspellings

 HOWTO.rst | 2 +-
 fio.1     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 33a6ad93..ec535911 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2865,7 +2865,7 @@ with the caveat that when used on the command line, they must come after the
                         Use Write commands for write operations
 
                 **uncor**
-                        Use Write Uncorrectable commands for write opreations
+                        Use Write Uncorrectable commands for write operations
 
                 **zeroes**
                         Use Write Zeroes commands for write operations
diff --git a/fio.1 b/fio.1
index 2649529b..1d1cdf85 100644
--- a/fio.1
+++ b/fio.1
@@ -2649,7 +2649,7 @@ Specifies the type of write operation.  Defaults to 'write'.
 Use Write commands for write operations
 .TP
 .B uncor
-Use Write Uncorrectable commands for write opreations
+Use Write Uncorrectable commands for write operations
 .TP
 .B zeroes
 Use Write Zeroes commands for write operations
