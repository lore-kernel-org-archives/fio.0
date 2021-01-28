Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhA1NA4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Jan 2021 08:00:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AD5C061573
        for <fio@vger.kernel.org>; Thu, 28 Jan 2021 05:00:15 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l56u6-008Tub-IR
        for fio@vger.kernel.org; Thu, 28 Jan 2021 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210128130002.44F1C1BC0135@kernel.dk>
Date: Thu, 28 Jan 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7216b664d93ef9c59ca5dbc8f54bad2118231ee3:

  Calculate min_rate with the consideration of thinktime (2021-01-26 08:58:42 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 119bb82143bd6c4a577c135ece4ed6b702443f50:

  Merge branch 'fio-fix-detecting-libpmem' of https://github.com/ldorau/fio (2021-01-27 09:51:01 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fio-fix-detecting-libpmem' of https://github.com/ldorau/fio

Lukasz Dorau (1):
      fio: fix detecting libpmem

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index e6e33d7f..748f7014 100755
--- a/configure
+++ b/configure
@@ -2055,7 +2055,7 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   int rc;
-  rc = pmem_is_pmem(NULL, NULL);
+  rc = pmem_is_pmem(NULL, 0);
   return 0;
 }
 EOF

