Return-Path: <fio-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:60724 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab1HFSjI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Aug 2011 14:39:08 -0400
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] RDMA engine: rewrite header comment block and man page section
Date: Sat, 6 Aug 2011 20:20:06 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108062020.06625.bvanassche@acm.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>, Ren Yufei <renyufei83@yahoo.com.cn>

Spelling and grammar fixes for the header comment. Also make it clear that
users can choose between the RDMA software provided by their Linux distributor
and OFED. Update a related paragraph in the man page too.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Ren Yufei <renyufei83@yahoo.com.cn>
Cc: Jens Axboe <jaxboe@fusionio.com>
---
 engines/rdma.c |   13 +++++++------
 fio.1          |    4 ++--
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/engines/rdma.c b/engines/rdma.c
index 61a90b8..fa94865 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -1,16 +1,17 @@
 /*
- * rdma engine
+ * RDMA I/O engine
  *
- * RDMA IO engine using OFED library.
- * Support both RDMA memory semantic and channel semantic
- *   in InfiniBand, RoCE and iWarp environment.
+ * RDMA I/O engine based on the IB verbs and RDMA/CM user space libraries.
+ * Supports both RDMA memory semantics and channel semantics
+ *   for the InfiniBand, RoCE and iWARP protocols.
  *
- * This is currently disabled. To enable it, execute:
+ * This I/O engine is disabled by default. To enable it, execute:
  *
  * $ export EXTFLAGS="-DFIO_HAVE_RDMA"
  * $ export EXTLIBS="-libverbs -lrdmacm"
  *
- * before running make. You'll need the OFED as well:
+ * before running make. You will need the Linux RDMA software as well, either
+ * from your Linux distributor or directly from openfabrics.org:
  *
  * http://www.openfabrics.org/downloads/OFED/
  *
diff --git a/fio.1 b/fio.1
index 65877d2..21ccda5 100644
--- a/fio.1
+++ b/fio.1
@@ -411,8 +411,8 @@ approach to asycnronous I/O.
 See <http://www.xmailserver.org/guasi\-lib.html>.
 .TP
 .B rdma
-The RDMA I/O engine supports both RDMA memory semantic(RDMA_WRITE/RDMA_READ)
-and channel semantic(Send/Recv) in InfiniBand, RoCE and iWarp environment.
+The RDMA I/O engine supports both RDMA memory semantics (RDMA_WRITE/RDMA_READ)
+and channel semantics (Send/Recv) for the InfiniBand, RoCE and iWARP protocols.
 .TP
 .B external
 Loads an external I/O engine object file.  Append the engine filename as
-- 
1.7.3.4

