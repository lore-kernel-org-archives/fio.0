Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43492 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752233AbeB0NAk (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Feb 2018 08:00:40 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eqes3-0006xK-Jp
        for fio@vger.kernel.org; Tue, 27 Feb 2018 13:00:39 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180227130002.729022C0085@kernel.dk>
Date: Tue, 27 Feb 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cd174b909109e527e41ca42ac761c5f7d29f25e5:

  Fio 3.5 (2018-02-20 15:30:28 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8aa33bf1b4363b706f7139e15b0a3e7b14bea16b:

  Merge branch 'wip-ifed-howto-update' of https://github.com/ifed01/fio (2018-02-26 11:59:54 -0700)

----------------------------------------------------------------
Igor Fedotov (1):
      Update HOWTO with RADOS information

Jens Axboe (1):
      Merge branch 'wip-ifed-howto-update' of https://github.com/ifed01/fio

 HOWTO | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 307b50d..f91a22e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1810,6 +1810,11 @@ I/O engine
 			I/O engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
 			defragment activity in request to DDIR_WRITE event.
 
+		**rados**
+			I/O engine supporting direct access to Ceph Reliable Autonomic
+			Distributed Object Store (RADOS) via librados. This ioengine
+			defines engine specific options.
+
 		**rbd**
 			I/O engine supporting direct access to Ceph Rados Block Devices
 			(RBD) via librbd without the need to use the kernel rbd driver. This
@@ -2011,7 +2016,7 @@ with the caveat that when used on the command line, they must come after the
 		Allocate space immediately inside defragment event, and free right
 		after event.
 
-.. option:: clustername=str : [rbd]
+.. option:: clustername=str : [rbd,rados]
 
 	Specifies the name of the Ceph cluster.
 
@@ -2019,17 +2024,22 @@ with the caveat that when used on the command line, they must come after the
 
 	Specifies the name of the RBD.
 
-.. option:: pool=str : [rbd]
+.. option:: pool=str : [rbd,rados]
 
-	Specifies the name of the Ceph pool containing RBD.
+	Specifies the name of the Ceph pool containing RBD or RADOS data.
 
-.. option:: clientname=str : [rbd]
+.. option:: clientname=str : [rbd,rados]
 
 	Specifies the username (without the 'client.' prefix) used to access the
 	Ceph cluster. If the *clustername* is specified, the *clientname* shall be
 	the full *type.id* string. If no type. prefix is given, fio will add
 	'client.' by default.
 
+.. option:: busy_poll=bool : [rbd,rados]
+
+        Poll store instead of waiting for completion. Usually this provides better
+        throughput at cost of higher(up to 100%) CPU utilization.
+
 .. option:: skip_bad=bool : [mtd]
 
 	Skip operations against known bad blocks.
