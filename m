Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A23C221F20
	for <fio@vger.kernel.org>; Sun, 14 Dec 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765717212; cv=none; b=NoGrNOhwu+QmL2cdcCAffUXcEGlpnQ+YTah97/t1T1jdyFaW0Y+Sa2UrlxyShQFWPfOHOrWgad5ToFXKJcwUd2AhxAea9YsTzU58RsQBk3twXfm7IgpTP/rhFCq5HqtJX6HYN17h5qlbCA07jvE4MFf/G+LSVl9H426XaHqb8zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765717212; c=relaxed/simple;
	bh=6mJjslrOtfQKAd8NFeGC1qTFfGpMm8CX1iU0whaFioI=;
	h=Subject:From:To:Date:Message-Id; b=MEaJaqqGmu8niOvUuNrGBfo2ur0Cj6si+dkHLFq8DkkV17g46CbmXRzWYKlgUu+fmm8z+5XOd5d+Qc+mcz/dwsPAuiWEOOnOs2N4LfvJPy4HuWweuEC/UK8eYxU5KIWvHLvN0wHwDIX2npXiTfS2G3MjgrJyG4ryXUkOSfRMDrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZfOXkkFf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZfOXkkFf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ps/7E91zaRsnfOHDW6JKqLn+NifCjgetxqBoX5ND+yw=; b=ZfOXkkFfM6UJ+2KW5DloI5ECti
	dZhdbhbkHOR29xAk4Vdv3ghktNk78Gls1bdtOSWBH+4Fr/dA7UnTWaHIQ8167Aa5pRhTwf/EEGEfS
	84ebKjV2dIGD3df71fCTXH0jCby0h8GvD03TQ33ilu8u4jJBig4G4CWgyCLckJ9zyBzNDZ7eS4sT8
	DR7s4N96fNlQDRKdw3REVcdD5L8b4a9Prc/5YZ1apQAb4+Y9R9if/zTbmgThf4xGqph6iZjNwqsAX
	LtPWXI3xxeZKapfaE0i62rAP2zWTTNW6PzyQ/dDHGO2WuuUn1Yc/TYV37anB8uLUmRe+6VCihONQ6
	8TeJCbiw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vUkqH-00000001Pce-10Ca
	for fio@vger.kernel.org;
	Sun, 14 Dec 2025 12:04:49 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 673E41BC0162; Sun, 14 Dec 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sun, 14 Dec 2025 06:00:01 -0700
Message-Id: <20251214130001.673E41BC0162@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 26c77cd375fc48511fda408e924416746ea878af:

  Merge branch 'patch-1' of https://github.com/fmayer/fio (2025-12-08 19:06:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9af9614ba9578a61f08d0b780441d122790d4fed:

  Merge branch 'baloo/push-lxolyxxkxkpv' of https://github.com/baloo/fio (2025-12-13 23:29:10 -0700)

----------------------------------------------------------------
Arthur Gautier (1):
      fix musl builds

Jens Axboe (1):
      Merge branch 'baloo/push-lxolyxxkxkpv' of https://github.com/baloo/fio

 oslib/linux-blkzoned.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 78e25fca..c45ef623 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -25,6 +25,7 @@
 #ifndef BLKFINISHZONE
 #define BLKFINISHZONE _IOW(0x12, 136, struct blk_zone_range)
 #endif
+#include <linux/falloc.h>
 
 /*
  * If the uapi headers installed on the system lacks zone capacity support,
