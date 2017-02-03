Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40311 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdBCNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cZdTC-0001s0-Bc
        for fio@vger.kernel.org; Fri, 03 Feb 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170203130002.5D68A2C019D@kernel.dk>
Date: Fri,  3 Feb 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f75ede1d8fe9a255be06f1bf0bde4b99b75acef9:

  doc: document profiles, minor fixes (2017-01-30 13:25:52 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3dd2e8aa0519225da5ccc100aa02e55306bcc2f3:

  fix to replay_align on iolog previous code was rejecting all positive alignment values and only accepting align to 0 value, opposite of what it should be doing (2017-02-02 10:37:00 -0800)

----------------------------------------------------------------
Dylan Fairchild (1):
      fix to replay_align on iolog     previous code was rejecting all positive alignment values and     only accepting align to 0 value, opposite of what it should be doing

 iolog.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/iolog.h b/iolog.h
index 60ee3e9..37f27bc 100644
--- a/iolog.h
+++ b/iolog.h
@@ -271,7 +271,7 @@ static inline bool inline_log(struct io_log *log)
 
 static inline void ipo_bytes_align(unsigned int replay_align, struct io_piece *ipo)
 {
-	if (replay_align)
+	if (!replay_align)
 		return;
 
 	ipo->offset &= ~(replay_align - (uint64_t)1);
