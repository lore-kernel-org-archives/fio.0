Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbhAXNBA (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 24 Jan 2021 08:01:00 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C74C061574
        for <fio@vger.kernel.org>; Sun, 24 Jan 2021 05:00:08 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l3ezs-0007LA-Pn
        for fio@vger.kernel.org; Sun, 24 Jan 2021 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210124130002.140111BC013D@kernel.dk>
Date: Sun, 24 Jan 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 548b363c08875165a018788195e8fd2304c2ce24:

  Merge branch 'fix_filename_overrun' of https://github.com/sitsofe/fio (2021-01-16 13:36:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 42664db2e3ba38faae8ee4c8375f8958206a8c5d:

  Merge branch 'esx-timerfd-bypass' of https://github.com/brianredbeard/fio (2021-01-23 11:04:54 -0700)

----------------------------------------------------------------
Brian 'Redbeard' Harrington (1):
      configure: ESX does not have timerfd support

Jens Axboe (1):
      Merge branch 'esx-timerfd-bypass' of https://github.com/brianredbeard/fio

 configure | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 1306f1b3..e6e33d7f 100755
--- a/configure
+++ b/configure
@@ -2695,6 +2695,7 @@ print_config "Windows PDB generation" "$pdb"
 ##########################################
 # check for timerfd support
 timerfd_create="no"
+if test "$esx" != "yes" ; then
 cat > $TMPC << EOF
 #include <sys/time.h>
 #include <sys/timerfd.h>
@@ -2704,8 +2705,9 @@ int main(int argc, char **argv)
 	return timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
 }
 EOF
-if compile_prog "" "" "timerfd_create"; then
-  timerfd_create="yes"
+  if compile_prog "" "" "timerfd_create"; then
+    timerfd_create="yes"
+  fi
 fi
 print_config "timerfd_create" "$timerfd_create"
 

