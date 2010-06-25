Return-Path: <fio-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22262 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab0FYPZX (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Jun 2010 11:25:23 -0400
Received: from g1t0039.austin.hp.com (g1t0039.austin.hp.com [16.236.32.45])
	by g1t0026.austin.hp.com (Postfix) with ESMTP id C9DD5C45E
	for <fio@vger.kernel.org>; Fri, 25 Jun 2010 15:25:22 +0000 (UTC)
Received: from blh01server01.usa.hp.com (blh01server01.usa.hp.com [16.125.125.3])
	by g1t0039.austin.hp.com (Postfix) with ESMTP id C031F345C2
	for <fio@vger.kernel.org>; Fri, 25 Jun 2010 15:25:22 +0000 (UTC)
Received: from w-gedwards.lhn.com (unknown [16.125.125.5])
	by blh01server01.usa.hp.com (Postfix) with ESMTP id A2C42F59D6
	for <fio@vger.kernel.org>; Fri, 25 Jun 2010 09:25:22 -0600 (MDT)
Date: Fri, 25 Jun 2010 09:25:22 -0600
From: Greg Edwards <greg.edwards@hp.com>
Subject: [PATCH] fix posix_fallocate() return value usage
Message-ID: <20100625152522.GB29790@w-gedwards.lhn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

posix_fallocate() returns the error number on failure.  Fix the return value
usage.

Signed-off-by: Greg Edwards <greg.edwards@hp.com>
---
 filesetup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index b90d12a..f088390 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -71,9 +71,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 							f->real_file_size);
 
 		r = posix_fallocate(f->fd, 0, f->real_file_size);
-		if (r < 0) {
+		if (r > 0) {
 			log_err("fio: posix_fallocate fails: %s\n",
-					strerror(-r));
+					strerror(r));
 		}
 	}
 #endif
-- 
1.7.0.5

