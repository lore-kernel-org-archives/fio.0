Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34687 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgB1HOn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Feb 2020 02:14:43 -0500
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 4/6] backend: always clean up pending aios
Date: Fri, 28 Feb 2020 16:12:46 +0900
Message-Id: <20200228071248.3981623-5-naohiro.aota@wdc.com>
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>

cleanup_pending_aios() is called when a thread exits with error, so all the
call site of this function is under "if (td->error)". However, commit
d28174f0189c ("workqueue: ensure we see deferred error for IOs"), for some
reason, added "if (td->error) return" at the head of this function, making
this function practically void. Revert this part to ensure cleaning up
pending aios.

Besides, cleanup_pending_aios() should not return even when
io_u_queued_complete() failed. Because, it keeps in-flight aios left.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 backend.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/backend.c b/backend.c
index 936203dcb1c4..feb34e51382f 100644
--- a/backend.c
+++ b/backend.c
@@ -237,15 +237,10 @@ static void cleanup_pending_aio(struct thread_data *td)
 {
 	int r;
 
-	if (td->error)
-		return;
-
 	/*
 	 * get immediately available events, if any
 	 */
 	r = io_u_queued_complete(td, 0);
-	if (r < 0)
-		return;
 
 	/*
 	 * now cancel remaining active events
-- 
2.25.1


