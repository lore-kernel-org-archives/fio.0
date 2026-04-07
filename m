Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE43B27F0
	for <fio@vger.kernel.org>; Tue,  7 Apr 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775563209; cv=none; b=Spnu17L5p7SsiNlyhUAu7BGfN6WDoDkmayNeDXLrUSt5NVlTa5bUSnUQCiILMVgaHbyhz08zbytEh25JYoDG6epT7pxhgH/jB6N8GBRbPvf+XZLRWTGVwYJ05RKyKTrsq5xUSfIWA7tJVh70FJY7tjVCXzk+86OhHLxz7kfOTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775563209; c=relaxed/simple;
	bh=fwa4F+HvOh2eJPiRAD/3gPrl79kR4L3B26LKNskFajE=;
	h=Subject:From:To:Date:Message-Id; b=Dd+PmqAbWWiUfiPDJkA2BWvolaWJq/HLry4R/gn9IhZ4l4LwzGpq0n9aEwWiZbyJ1D/yqprlucj5CiBwGgY1TMA3HJ1WO1D3W7mfr0s96gG9FFmD9tg4cYlMybfhMru4M7r0Ri6j4MNSYt4KV6irM0FK58h1WeGis4P3FDUh3Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HMggGov8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HMggGov8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=irOQAC7Idbu/qgUpFvT1QwYRZ7J4XvMOyX4F/aBin88=; b=HMggGov8Z7apXTQrUsdubpDXU0
	SXaSLjHaYphzM4JQzC++NL4qqjJ8QuKMa3oo5V4tZ4eQ3wDezFiP2Na/vfES4zy19Q8TXdNZBz55S
	iyCqZlTzWTF+zwIeusfGTtwX46WOyB8MLi29gNLcV08xvLHcZI7vjuYyDyWymjy6/vUU7D4GcJFSY
	Q5sIFhYUMre8pa2zrM8P7iPYdYdfAq2e9Bf/u9tIE9eQCl0fiZ/YpoDTdy4YSRcEdsVo04kM47hbw
	/lUXb7IPq5ldO2DfJddDmUVhJjezXwgMDoZ2BSXZEGHiI3JBINQg9lF1tLjC+QNqQWsLT4dL5ukqa
	loNa2pYw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA56D-00000008CAD-1fIU
	for fio@vger.kernel.org;
	Tue, 07 Apr 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C03E01BC01B3; Tue,  7 Apr 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue,  7 Apr 2026 06:00:01 -0600
Message-Id: <20260407120001.C03E01BC01B3@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d0218ba66e9dc8402f1ac366b964277a1f2f2797:

  Merge branch 'fix_statsem_deadlock' of https://github.com/RyanTedrick/fio (2026-04-01 09:08:08 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ab77643023f5d7e3c1b71a7576a564f368bf577a:

  Fio 3.42 (2026-04-06 20:11:47 -0600)

----------------------------------------------------------------
Haeun Kim (1):
      iolog: free io_piece log on thread cleanup

Jens Axboe (2):
      Merge branch 'ipo' of https://github.com/minwooim/fio
      Fio 3.42

 FIO-VERSION-GEN | 2 +-
 backend.c       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f92f5a46..e5ada1de 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.41
+DEF_VER=fio-3.42
 
 LF='
 '
diff --git a/backend.c b/backend.c
index 4ce3d07f..230d7fd0 100644
--- a/backend.c
+++ b/backend.c
@@ -2209,6 +2209,7 @@ err:
 		verify_async_exit(td);
 
 	close_and_free_files(td);
+	prune_io_piece_log(td);
 	cleanup_io_u(td);
 	close_ioengine(td);
 	cgroup_shutdown(td, cgroup_mnt);
