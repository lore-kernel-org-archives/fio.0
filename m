Return-Path: <fio-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46779 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1HMNZZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 13 Aug 2011 09:25:25 -0400
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] RDMA engine: Change wording of HOWTO section
Date: Sat, 13 Aug 2011 15:25:16 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108131525.16410.bvanassche@acm.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Ren Yufei <renyufei83@yahoo.com.cn>

Change "iWarp" into "iWARP" ("iWarp" is the name of a supercomputer) and
"engines" into "protocols".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Ren Yufei <renyufei83@yahoo.com.cn>
---
 HOWTO |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3b60f58..72a29a9 100644
--- a/HOWTO
+++ b/HOWTO
@@ -570,9 +570,9 @@ ioengine=str	Defines how the job issues io to the file. The following
 				for more info on GUASI.
 
 			rdma    The RDMA I/O engine  supports  both  RDMA
-				memory semantic(RDMA_WRITE/RDMA_READ) and
-				channel semantic(Send/Recv) in InfiniBand, RoCE
-				and iWarp environment.
+				memory semantics (RDMA_WRITE/RDMA_READ) and
+				channel semantics (Send/Recv) for the
+				InfiniBand, RoCE and iWARP protocols.
 
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
-- 
1.7.3.4

