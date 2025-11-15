Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DED329B204
	for <fio@vger.kernel.org>; Sat, 15 Nov 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763211616; cv=none; b=mlPp0A2OpumNx1m5st7jcepT/nE8nB19jN87gMTgHUfunL401OdyK6tOYW+V8esh6t7Nz2cIFKMYVbUatahGMQiSplmNrGZ2uNXxk2cH4wa1Sh9e2Htt8Kfm98MuCj/2uar5Hd366W88qdcqPCymJLBFIgbqGgT1hkLkFSK8Gk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763211616; c=relaxed/simple;
	bh=AK5Ih9KhB7lX4d4v8Dfa0cgVGf6cH9nDTn1YslbsNkM=;
	h=Subject:From:To:Date:Message-Id; b=YJnKwp6yUSbWT5AaVjVyR10987foGNjvYBxPot+BgIO23eXPnocvJLbFM6kqAlr93Q+H1jXBRxP0YzhZKKdJgVJZUHYU4G3D4t7e0f3lN3zKPGtzJLIXhtkTDSr2GudizRKiEvBMkkWOLpcsIgDoptZINA0uqkypMCb89itXlCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jEoz/kzD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jEoz/kzD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=3MciJgLz1+RIoGuiy8dwT/aVKa19WJgTGSZPWYBKmqk=; b=jEoz/kzDTRdoI7EBixbduTSKq8
	2BLuCh1JVwU5WKfI29h5jWUJb9EkSuA3RXdresfYiZ4d5+bLF1P+9ujvvfSUL3y65gtaJHL3vHCSb
	EsgkHTF/AOe7XXKmrLzXKc1rMy4cNO2PuRSRueKMOBWGiRbldo/CL4FX88t5Pu/kpQoGDy+gOwg3e
	p6BKTf6v/RsReu0KfvZldKmu+26t7mV5/wMxqtbVjtwk804vV3FHzg/2GhYQXJvLfLa4Law5y3NSx
	N+FXxkBpuIV2f4BIKG31WUhOQdtmussHJXcM7UO33yNZOjT3gdrXsH1lFPrxIp4dgqLoejjxQjZKa
	bzFZsqbg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vKF1E-00000004H7h-0y9b
	for fio@vger.kernel.org;
	Sat, 15 Nov 2025 12:04:40 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 58B9C1BC0131; Sat, 15 Nov 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 15 Nov 2025 06:00:01 -0700
Message-Id: <20251115130001.58B9C1BC0131@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f5b2f2366bc2a05876fcf6044e18098ab2a7f343:

  Merge branch 'end-fsync-io_u' of https://github.com/JeongJonghwi/fio (2025-11-05 18:33:39 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1ad9ac9f54641d737128183dd5639d76fbe24571:

  ci: switch to macos version 15 (2025-11-14 11:05:03 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      ci: switch to macos version 15

 .github/workflows/ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 94eec3d2..a162ad18 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -65,7 +65,7 @@ jobs:
           os: ubuntu-22.04
           cc: clang
         - build: macos
-          os: macos-13
+          os: macos-15
         - build: linux-i686-gcc
           os: ubuntu-22.04
           arch: i686
