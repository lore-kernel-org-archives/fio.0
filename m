Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51800 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbaBQNNx (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 17 Feb 2014 08:13:53 -0500
From: Daniel Gollub <d.gollub@telekom.de>
Subject: [PATCH 2/3] fio.1: add rbd options to man page
Date: Mon, 17 Feb 2014 13:53:06 +0100
Message-Id: <1392641587-24803-2-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392641587-24803-1-git-send-email-d.gollub@telekom.de>
References: <1392641587-24803-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Danny Al-Gaaf <danny.al-gaaf@bisect.de>

From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>

Signed-off-by: Danny Al-Gaaf <danny.al-gaaf@bisect.de>

(cherry picked from commit 6e44a82a724b7ad0a559c22eec694e8afa7d2a20
git@github.com:dalgaaf/fio.git)
---
 fio.1 |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fio.1 b/fio.1
index ec10377..1df1cd1 100644
--- a/fio.1
+++ b/fio.1
@@ -557,6 +557,11 @@ transfer as fio ioengine
 .B e4defrag
 IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate defragment activity
 request to DDIR_WRITE event
+.TP
+.B rbd
+IO engine supporting direct access to Ceph Rados Block Devices (RBD) via librbd 
+without the need to use the kernel rbd driver. This ioengine defines engine specific 
+options.
 .RE
 .P
 .RE
@@ -1394,6 +1399,15 @@ Preallocate donor's file on init
 .BI 1:
 allocate space immediately inside defragment event, and free right after event
 .RE
+.TP
+.BI (rbd)rbdname \fR=\fPstr
+Specifies the name of the RBD.
+.TP
+.BI (rbd)pool \fR=\fPstr
+Specifies the name of the Ceph pool containing the RBD.
+.TP
+.BI (rbd)clientname \fR=\fPstr
+Specifies the username (without the 'client.' prefix) used to access the Ceph cluster.
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
 example:
-- 
1.7.10.4

