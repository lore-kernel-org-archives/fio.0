Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42212 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdLDNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Dec 2017 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eLqLw-0000K6-Vz
        for fio@vger.kernel.org; Mon, 04 Dec 2017 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171204130002.075892C0137@kernel.dk>
Date: Mon,  4 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit af7fb4aa2835b82847701237783c9ebe8ec8239a:

  steadystate: style cleanup (2017-12-02 16:29:44 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 67bfebe6af2e6d030ec739fa45ccb211f3e50a0e:

  Merge branch 'wip-cleanup' of https://github.com/ZVampirEM77/fio (2017-12-03 10:11:53 -0700)

----------------------------------------------------------------
Enming Zhang (1):
      configure: fix typos

Jens Axboe (1):
      Merge branch 'wip-cleanup' of https://github.com/ZVampirEM77/fio

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 31ba822..d92bb0f 100755
--- a/configure
+++ b/configure
@@ -1586,7 +1586,7 @@ print_config "rbd_poll" "$rbd_poll"
 fi
 
 ##########################################
-# check for rbd_invaidate_cache()
+# check for rbd_invalidate_cache()
 if test "$rbd_inval" != "yes" ; then
   rbd_inval="no"
 fi
