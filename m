Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60070 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934843AbdKPNAd (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Nov 2017 08:00:33 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eFJmT-000305-12
        for fio@vger.kernel.org; Thu, 16 Nov 2017 13:00:33 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171116130002.556E22C0083@kernel.dk>
Date: Thu, 16 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3b973af558aa0802e2c8193e9afac4cd49af3ca0:

  Merge branch 'fix-libhdfs' of https://github.com/follitude/fio (2017-11-06 09:11:07 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 522c29f69a31542170d94611e05e1780e4c08dbd:

  man page: fix bad case for 'pre-reading file' state (2017-11-15 09:53:14 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      man page: fix bad case for 'pre-reading file' state

 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index 63d32a5..1f9fffc 100644
--- a/fio.1
+++ b/fio.1
@@ -2730,7 +2730,7 @@ Thread created.
 .B I
 Thread initialized, waiting or generating necessary data.
 .TP
-.B P
+.B p
 Thread running pre\-reading file(s).
 .TP
 .B /
