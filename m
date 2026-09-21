Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951AE46EC84
	for <fio@vger.kernel.org>; Mon, 21 Sep 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992019; cv=none; b=lf8DQC8Hv+JicHYG3QqhypWw+BnVEjhxm9xoBWEQ/0tJo8otiEdeiCmx8076yNssCFfc/f8ki7Qo3qVMPgRezVM4FajHyO6KvefwH5ReU7BuZeQTWjYp/xgH+1FxqcXn/XZ5CFeIOx2SrTXlx1djP+UzvrP1d3W13mR1Q/bnVmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992019; c=relaxed/simple;
	bh=X3O3EQSciQpzWBTgnm81J3FcFhMgqThPWmwCizxGgnA=;
	h=Subject:From:To:Date:Message-Id; b=lIv0WvGV8rm5TiVu4FL9irh/r64lGMXFHmZ0+2Z9HlyWWeys4DR3IqF5i/czH4bqom4fSz3Am1Jrs8EvjknrMTqlutSFhXWjZo9sfyyoRTibHsdAmm2MCnEXYIHBS25NfoxWdLw93PENY72jLeFEsi1WzXyoKHEdlnRskmPh4XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TVO8nMtI; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TVO8nMtI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=F+UcdyxSAGKoHh7+LxfbzrjHxa48W8Bx3Ouiil8S0jo=; b=TVO8nMtId5KdpwKXtBVGhdD944
	HY/IWINJ5xFUN8133W+oQOtoNx7RkEEib9uSvfUiCPVAOcSXMM0VcBmkXLf+7K9bPuYtmWwIQKcRk
	iYPg6q+hLXqpCx5/nC3sunq5aOdA/YRmJPZGLtZBZ/j/ZpzVXy53sI7rRbzcUKDUh87OdFYIfC9LI
	TKT7GK5EJZKA7tCs0zuyFCBtiUhIQUOQr3/9hVtMXsAmTiTY7Euwt/xivhuUnDUZUtk9Z0zQO5CDo
	4NURIshYMcyGI7yJhFhB7kvbF6SLFbJxyyPdrvfU4l5g95+r1LHbm40PVGrtUY4m50rDhAsik+ehK
	9i9e63sA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x8cgn-0000000CFUG-01MT
	for fio@vger.kernel.org;
	Mon, 21 Sep 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 72FB41BC0175; Mon, 21 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Mon, 21 Sep 2026 06:00:01 -0600
Message-Id: <20260921120001.72FB41BC0175@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 162e8fb3d059c090caa56255e4a6a92bfa6e47b3:

  client: don't send uninitialized data in fio_send_file error replies (2026-09-17 14:57:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ef248b912406bb4cfe54aa45295a84924d00f46:

  Merge branch 'readme-typo' of github.com:vic233333/fio (2026-09-21 03:14:52 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'readme-typo' of github.com:vic233333/fio

Xinchen Shen (1):
      README: fix unclosed angle bracket in maintainer email

 README.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index 06fa971e..e484efde 100644
--- a/README.rst
+++ b/README.rst
@@ -83,7 +83,7 @@ Jens Axboe <axboe@kernel.dk> 20060905
 Maintainers
 -----------
 
-Fio is maintained by Jens Axboe <axboe@kernel.dk and
+Fio is maintained by Jens Axboe <axboe@kernel.dk> and
 Vincent Fu <vincentfu@gmail.com> - however, for reporting bugs please use
 the fio reflector or the GitHub page rather than email any of them
 directly. By using the public resources, others will be able to learn from
