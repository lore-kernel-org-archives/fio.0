Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbeB1NAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Feb 2018 08:00:10 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1er1L7-0002Ob-QO
        for fio@vger.kernel.org; Wed, 28 Feb 2018 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180228130002.348322C0085@kernel.dk>
Date: Wed, 28 Feb 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8aa33bf1b4363b706f7139e15b0a3e7b14bea16b:

  Merge branch 'wip-ifed-howto-update' of https://github.com/ifed01/fio (2018-02-26 11:59:54 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 68ae273e7544ebafeef721281b9bda5d42d66f4c:

  Merge branch 'master' of https://github.com/brycepg/fio (2018-02-27 16:15:22 -0700)

----------------------------------------------------------------
Bryce Guinta (1):
      Refer to zlib-static package in zlib static build warning

Jens Axboe (1):
      Merge branch 'master' of https://github.com/brycepg/fio

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 5d283d7..2b99ce9 100755
--- a/configure
+++ b/configure
@@ -2376,7 +2376,7 @@ if test "$disable_opt" = "yes" ; then
   output_sym "CONFIG_DISABLE_OPTIMIZATIONS"
 fi
 if test "$zlib" = "no" ; then
-  echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
+  echo "Consider installing zlib-dev (zlib-devel or zlib-static), some fio features depend on it."
 fi
 if test "$cuda" = "yes" ; then
   output_sym "CONFIG_CUDA"
