Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhEGMBH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 May 2021 08:01:07 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B740CC061574
        for <fio@vger.kernel.org>; Fri,  7 May 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lez9J-0071CQ-QN
        for fio@vger.kernel.org; Fri, 07 May 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210507120001.DB2B91BC0144@kernel.dk>
Date: Fri,  7 May 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6308ef297145e73add65ba86bfdbeaf967957d1f:

  ioengines: don't call zbd_put_io_u() for engines not implementing commit (2021-04-27 11:56:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cffe80a41cbf9b26446c803177a27f7695f94a31:

  configure: fix check_min_lib_version() eval (2021-05-06 10:24:58 -0600)

----------------------------------------------------------------
Stefan Hajnoczi (1):
      configure: fix check_min_lib_version() eval

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index a7d82be0..e886bdc8 100755
--- a/configure
+++ b/configure
@@ -142,7 +142,7 @@ check_min_lib_version() {
   fi
   : "${_feature:=${1}}"
   if "${cross_prefix}"pkg-config --version > /dev/null 2>&1; then
-    if eval "echo \$$_feature" = "yes" ; then
+    if test "$(eval echo \"\$$_feature\")" = "yes" ; then
       feature_not_found "$_feature" "$1 >= $2"
     fi
   else

