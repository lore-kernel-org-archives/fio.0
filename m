Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6E6286293
	for <fio@vger.kernel.org>; Wed, 19 Feb 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970011; cv=none; b=guCnLPScm69g3/8HXBpSLhHHOkZIhSlI12sLOH0d6W8o+bqOXYffObHCjX75TqU96YaVHgduJs7mFvAfzUgu1P5TEFCG6zb5XVgqSy37PAhfBa0rvDFnzmReyBq10w3B/wcIerp4E5QmNNql78Xox02rNSWzp5A5mDq4yrceQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970011; c=relaxed/simple;
	bh=osZSPwJqtMvcZy/BGDpnN79xhydcHa6HXlbczfVIUIA=;
	h=Subject:From:To:Message-Id:Date; b=qLCjHYpgaxSx48q7sWIJJjqd9Nz15/rIUPZifkKR7OD2WXKOn0+ERXmep4k20/RWmutcrhCgR02zxbtaWByukuxQk3Ov+YIekPKrvwN6FPjORmbIysh31QA4R7PHnREs390SEsB2vsirtOJzNnZR2kqiKIn4LL36VEueSkUqb+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=njpJMvoP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="njpJMvoP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rSHJaYKa+U9lk3vYX2kTP289eRYEB05bgfVXMZe/IsQ=; b=njpJMvoPlooFhaWy5fFILRMcPm
	ejOZWM1gUjjzekCTNWGF1ZTlRdhofCL/sT+dPtSZ//mqmcUUWJ2vXJe7IlYTT01qu8aMfgRLn9pVl
	emw/zJxr6pafeu2iACz/FNrtN5FztKdQaV98zTr+lUlwL3NYc354CGf7vnFRGUuITiiprrSzranyt
	VAjXcPpEEawIaEOMIkrO3amM9Pg7ETqdPKAcmoZ4/FtZWJENuwd3LVnyApb5medAFL/i3Dxw7/TBm
	IUZJjKhbDQdx5vZ9D2Ru/+oLMLeVSNAfLAlcSfCimJxi9Ul8dA5axs2mS8FT/Hn0s+aRMhPRoHZVH
	pGTETbUA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkjgM-000000062Lg-1i6V
	for fio@vger.kernel.org;
	Wed, 19 Feb 2025 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 21C2D1BC015A; Wed, 19 Feb 2025 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250219130002.21C2D1BC015A@kernel.dk>
Date: Wed, 19 Feb 2025 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 3ee531989f41b242b73d9f6cb33186a686a7133c:

  crc/sha512: fix missing finalize part of sha512 hash (2025-02-17 16:30:07 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a6e474c9e896e4ba1eb40066a03402afb040710a:

  Fio 3.39 (2025-02-18 08:36:57 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.39

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 2393f394..623fd33d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.38
+DEF_VER=fio-3.39
 
 LF='
 '
