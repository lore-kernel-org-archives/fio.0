Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbeAKNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Jan 2018 08:00:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eZcSq-0004wl-Ok
        for fio@vger.kernel.org; Thu, 11 Jan 2018 13:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180111130002.425D12C0098@kernel.dk>
Date: Thu, 11 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 702bd977555105292f3d60dee896cd35ff8b11ef:

  stat: don't add duplicate clat entries for json (2018-01-06 14:47:01 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9d5fe300085759c0f764a62be27355fe80b5fd8f:

  io/examples/fio-seq-read: use direct=1 (2018-01-10 08:30:07 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      io/examples/fio-seq-read: use direct=1

 examples/fio-seq-read.job | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/examples/fio-seq-read.job b/examples/fio-seq-read.job
index 74b1b30..28de93c 100644
--- a/examples/fio-seq-read.job
+++ b/examples/fio-seq-read.job
@@ -3,7 +3,7 @@ name=fio-seq-reads
 filename=fio-seq-reads
 rw=read
 bs=256K
-direct=0
+direct=1
 numjobs=1
 time_based=1
 runtime=900
