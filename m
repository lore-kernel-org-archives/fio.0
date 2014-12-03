Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLCNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Dec 2014 08:00:04 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xw9XH-0005RS-SR
	for fio@vger.kernel.org; Wed, 03 Dec 2014 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141203130002.D293440153@lyth.info>
Date: Wed,  3 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f5041ed9d2890116ecba4bd3fe2121b272e01776:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-12-01 09:44:02 -0700)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0c87ac2ac5df7e20b8c8d9cfc46b7667deeef683:

  fio: remove deprecated --latency-log from manpage (2014-12-02 13:54:32 -0700)

----------------------------------------------------------------
Elliott, Robert (Server Storage) (1):
      fio: remove deprecated --latency-log from manpage

 fio.1 |    3 ---
 1 file changed, 3 deletions(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index 89cbb82..fa2ac70 100644
--- a/fio.1
+++ b/fio.1
@@ -23,9 +23,6 @@ Write output to \fIfilename\fR.
 .BI \-\-runtime \fR=\fPruntime
 Limit run time to \fIruntime\fR seconds.
 .TP
-.B \-\-latency\-log
-Generate per-job latency logs.
-.TP
 .B \-\-bandwidth\-log
 Generate per-job bandwidth logs.
 .TP
