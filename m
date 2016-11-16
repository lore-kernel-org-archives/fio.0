Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44561 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbcKPNAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Nov 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zoo-0008BJ-J8
        for fio@vger.kernel.org; Wed, 16 Nov 2016 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161116130001.87E912C008C@kernel.dk>
Date: Wed, 16 Nov 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 471bb52b2e75413d18e8def5bb7d301aab7541e9:

  Fix memory leak on tmp_buf (2016-11-14 00:05:37 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to effe99e4b18eb5c345629d7bbaae1879a2594b20:

  posixaio: fix bad type passed to memset (2016-11-15 10:42:58 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      posixaio: fix bad type passed to memset

 engines/posixaio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/posixaio.c b/engines/posixaio.c
index e5411b7..bddb1ec 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -109,7 +109,7 @@ static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 
 	r = 0;
 restart:
-	memset(suspend_list, 0, sizeof(*suspend_list));
+	memset(suspend_list, 0, sizeof(suspend_list));
 	suspend_entries = 0;
 	io_u_qiter(&td->io_u_all, io_u, i) {
 		int err;
