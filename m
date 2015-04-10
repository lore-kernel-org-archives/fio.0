Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbbDJMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Apr 2015 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YgXbR-00074O-V9
	for fio@vger.kernel.org; Fri, 10 Apr 2015 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150410120003.81BB140161@lyth.info>
Date: Fri, 10 Apr 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 87f5fce38c1b8fc979cea10c926973c2f2a76217:

  genzip: switch to jenkins hash (2015-04-08 16:25:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 92aef550de95c5b33c489cbabd2c1a70e59475b3:

  configure: update to changes in fusion-aw packaging (2015-04-09 08:24:38 -0600)

----------------------------------------------------------------
Akshita Rajendra Jain (1):
      configure: update to changes in fusion-aw packaging

 configure |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 892335b..c1a4915 100755
--- a/configure
+++ b/configure
@@ -856,8 +856,8 @@ int main(int argc, char **argv)
   return nvm_atomic_write(handle, 0, 0, 0);
 }
 EOF
-if compile_prog "" "-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -lvsl -ldl" "fusion-aw"; then
-  LIBS="-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -lvsl -ldl $LIBS"
+if compile_prog "" "-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthread" "fusion-aw"; then
+  LIBS="-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthread $LIBS"
   fusion_aw="yes"
 fi
 echo "Fusion-io atomic engine       $fusion_aw"
