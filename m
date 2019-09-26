Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfIZMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Sep 2019 08:00:13 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDSRP-0005rY-Ni
        for fio@vger.kernel.org; Thu, 26 Sep 2019 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190926120001.DF1632C02C4@kernel.dk>
Date: Thu, 26 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3c029ac46c3478243932f76cadf04ca10b64ab3e:

  filesetup: Extend file size for 'null' and 'filecreate' ioengines (2019-09-25 03:12:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 106a71cd6c24f31fce9d95c49e00ff4b28aa6fdc:

  t/zbd: Avoid magic number of test case count (2019-09-26 00:47:14 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      t/zbd: Avoid magic number of test case count

 t/zbd/test-zbd-support | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 90f9f87b..5d079a8b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -826,9 +826,8 @@ case "$(<"/sys/class/block/$basename/queue/zoned")" in
 esac
 
 if [ "${#tests[@]}" = 0 ]; then
-    for ((i=1;i<=46;i++)); do
-	tests+=("$i")
-    done
+    readarray -t tests < <(declare -F | grep "test[0-9]*" | \
+				   tr -c -d "[:digit:]\n" | sort -n)
 fi
 
 logfile=$0.log

