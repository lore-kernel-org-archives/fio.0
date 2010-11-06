Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50712 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab0KFFAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Nov 2010 01:00:05 -0400
Subject: Recent changes
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20101106050003.1398237A295@kernel.dk>
Date: Sat,  6 Nov 2010 06:00:03 +0100 (CET)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ca7e0ddb08fece35c95e9056ca877e0806f1e6ef:

  binject: ensure we get aligned memory (2010-10-28 08:52:13 -0600)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (1):
      Fio 1.44.2

 init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 3f29b91..2e443f6 100644
--- a/init.c
+++ b/init.c
@@ -22,7 +22,7 @@
 
 #include "lib/getopt.h"
 
-static char fio_version_string[] = "fio 1.44.1";
+static char fio_version_string[] = "fio 1.44.2";
 
 #define FIO_RANDSEED		(0xb1899bedUL)
 
