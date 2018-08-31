Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46884 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbeHaQHO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Aug 2018 12:07:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fvi5t-0006oX-2X
        for fio@vger.kernel.org; Fri, 31 Aug 2018 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180831120002.903522C00A1@kernel.dk>
Date: Fri, 31 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 26b3a1880d38bc24b633a643339c9ca31f303d1c:

  Make td_io_u_lock/unlock() explicit (2018-08-25 10:22:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c6cc1cfed2aec5ea348cbe8b8762ba8fd5fad966:

  Merge branch 'configure-help' of https://github.com/hahnjo/fio (2018-08-30 08:22:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'configure-help' of https://github.com/hahnjo/fio

Jonas Hahnfeld (1):
      configure: Document more switches to disable features

 configure | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index ab89df7..5e11195 100755
--- a/configure
+++ b/configure
@@ -226,6 +226,9 @@ if test "$show_help" = "yes" ; then
   echo "--enable-gfio           Enable building of gtk gfio"
   echo "--disable-numa          Disable libnuma even if found"
   echo "--disable-rdma          Disable RDMA support even if found"
+  echo "--disable-rados         Disable Rados support even if found"
+  echo "--disable-rbd           Disable Rados Block Device even if found"
+  echo "--disable-http          Disable HTTP support even if found"
   echo "--disable-gfapi         Disable gfapi"
   echo "--enable-libhdfs        Enable hdfs support"
   echo "--disable-lex           Disable use of lex/yacc for math"

