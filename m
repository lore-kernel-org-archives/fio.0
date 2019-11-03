Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51664 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfKCNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 3 Nov 2019 08:00:08 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRFUD-0001uC-NU
        for fio@vger.kernel.org; Sun, 03 Nov 2019 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191103130001.8D5E42C0085@kernel.dk>
Date: Sun,  3 Nov 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8c302eb9706963e07d6d79998e15bede77b94520:

  Merge branch 'patch-1' of https://github.com/hannesweisbach/fio (2019-10-29 13:39:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f89cfed7d28f76e99ee7520d6d350b9847fab07c:

  engines/libaio.c: remove unused 'hipri' setting (2019-11-02 14:48:24 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      engines/libaio.c: remove unused 'hipri' setting

 engines/libaio.c | 1 -
 1 file changed, 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index cd5b89f9..b047b746 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -44,7 +44,6 @@ struct libaio_data {
 struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
-	unsigned int hipri;
 };
 
 static struct fio_option options[] = {

