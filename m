Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:44010 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbeGNAf3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Jul 2018 20:35:29 -0400
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 70ABE63289
        for <fio@vger.kernel.org>; Sat, 14 Jul 2018 00:18:33 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id CD6E59C
        for <fio@vger.kernel.org>; Sat, 14 Jul 2018 00:18:32 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [RFC] mmap: under direct=1, only call msync and madvise on writes
Date: Fri, 13 Jul 2018 19:19:24 -0500
Message-Id: <20180714001924.34861-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

While using the mmap engine with direct=1 (an artificial combination),
only call msync() and madvise(DONTNEED) for writes; don't worry about
reads.

This better simulates an application that periodically wants to flush
updated data to disk, but wants to keep read data in memory.

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 engines/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/mmap.c b/engines/mmap.c
index 308b4665..cacf1768 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -205,7 +205,7 @@ static enum fio_q_status fio_mmapio_queue(struct thread_data *td,
 	/*
 	 * not really direct, but should drop the pages from the cache
 	 */
-	if (td->o.odirect && ddir_rw(io_u->ddir)) {
+	if (td->o.odirect && (io_u->ddir == DDIR_WRITE || io_u->ddir == DDIR_TRIM)) {
 		if (msync(io_u->mmap_data, io_u->xfer_buflen, MS_SYNC) < 0) {
 			io_u->error = errno;
 			td_verror(td, io_u->error, "msync");
-- 
2.14.4

