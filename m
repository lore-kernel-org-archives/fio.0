Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbbAONAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Jan 2015 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YBk1u-0002Ob-Dr
	for fio@vger.kernel.org; Thu, 15 Jan 2015 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150115130002.BA53F400D4@lyth.info>
Date: Thu, 15 Jan 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f9a33cc03d70ff34b740629cbde4cef22a120338:

  client: take better care to return failure from fio_handle_clients() (2015-01-13 21:47:43 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e298cc8ab1e007482be2ab1488ae8d547af82520:

  rbd example: 'invalidate=false' no longer necessary (2015-01-14 09:31:35 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      rbd example: 'invalidate=false' no longer necessary

 examples/rbd.fio |    1 -
 1 file changed, 1 deletion(-)

---

Diff of recent changes:

diff --git a/examples/rbd.fio b/examples/rbd.fio
index 9d73ca1..c6901f4 100644
--- a/examples/rbd.fio
+++ b/examples/rbd.fio
@@ -15,7 +15,6 @@ ioengine=rbd
 clientname=admin
 pool=rbd
 rbdname=fio_test
-invalidate=0	# mandatory
 rw=randwrite
 bs=4k
 
