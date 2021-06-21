Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFUMCt (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Jun 2021 08:02:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47BBC061574
        for <fio@vger.kernel.org>; Mon, 21 Jun 2021 05:00:33 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvIay-00D3Zj-IS
        for fio@vger.kernel.org; Mon, 21 Jun 2021 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210621120002.3555E1BC013B@kernel.dk>
Date: Mon, 21 Jun 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit afa37b56c6637967180e4409adbb682b2ce16bcb:

  filehash: ignore hashed file with fd == -1 (2021-06-17 10:55:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d3dacdc61dfe878fda0c363084c4330492e38b2b:

  Merge branch 'pkg_config_1' of https://github.com/kusumi/fio (2021-06-20 10:44:49 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'pkg_config_1' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      configure: silence "pkg-config: not found"

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 8b763700..84ccce04 100755
--- a/configure
+++ b/configure
@@ -2285,7 +2285,7 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 ##########################################
 # Check if we have libnfs (for userspace nfs support).
 if test "$disable_nfs" != "yes"; then
-  if $(pkg-config libnfs); then
+  if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
     libnfs_cflags=$(pkg-config --cflags libnfs)
     libnfs_libs=$(pkg-config --libs libnfs)

