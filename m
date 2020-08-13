Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20747 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgHMPCA (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Aug 2020 11:02:00 -0400
From: Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH] zbd: don't read past the WP on a read only workload with verify
Date: Thu, 13 Aug 2020 17:01:48 +0200
Message-Id: <20200813150148.14655-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: damien.lemoal@wdc.com, shinichiro.kawasaki@wdc.com, Aravind Ramesh <aravind.ramesh@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>

From: Aravind Ramesh <aravind.ramesh@wdc.com>

When running a read only workload with verify option enabled,
fio continues to read beyond the write pointer, and thus
reads a deallocated block, which contains data of a predefined
pattern, thus causing the verify to fail.

Thus, we cannot simply jump to accept for a read only workload
with verify option enabled, we must let the regular flow of
execution to continue, so that the check if offset > wp is
performed, so that we will return the address to a new zone,
rather than an address that is past the wp.

Reading past the wp is not a recent bug, it is possible to
reproduce this bug even before zone capacity was introduced.

However, with the introduction of zone capacity, filling a
zone now only writes up to zone capacity of a zone, making
it much easier to reproduce this bug.

Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Patch made by Aravind, I simply rewrote the commit message.

 zbd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/zbd.c b/zbd.c
index e4a480b7..92936fe8 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1467,9 +1467,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING) {
-			if (td_write(td))
-				zb = zbd_replay_write_order(td, io_u, zb);
+		if (td->runstate == TD_VERIFYING && td_write(td)) {
+			zb = zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
 		/*
-- 
2.26.2


