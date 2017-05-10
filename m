Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40531 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbdEJMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 May 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d8QHj-0000CS-5x
        for fio@vger.kernel.org; Wed, 10 May 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170510120002.61A152C0099@kernel.dk>
Date: Wed, 10 May 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c55fae03f7d5c0981e55241fc9003d762f7a5fd9:

  options: force refill_buffers with pattern and any reads (2017-05-04 08:43:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c78997bf625ffcca49c18e11ab0f5448b26d7452:

  man page: include reference to version 4 of the terse format (2017-05-09 21:08:12 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      man page: include reference to version 4 of the terse format

 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index 138bcbb..0167c23 100644
--- a/fio.1
+++ b/fio.1
@@ -43,7 +43,7 @@ Deprecated, use \-\-output-format instead to select multiple formats.
 Display version information and exit.
 .TP
 .BI \-\-terse\-version \fR=\fPversion
-Set terse version output format (Current version 3, or older version 2).
+Set terse version output format (default 3, or 2 or 4)
 .TP
 .B \-\-help
 Display usage information and exit.
