Return-Path: <fio-owner@vger.kernel.org>
Received: from o1.dev.nutanix.com ([198.21.4.205]:51939 "EHLO
        o1.dev.nutanix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405031AbgE2C3d (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 May 2020 22:29:33 -0400
From: Raphael Norwitz <raphael.norwitz@nutanix.com>
Subject: [PATCH] Fix typo in libiscsi error message
Date: Fri, 29 May 2020 02:24:24 +0000 (UTC)
Message-Id: <1588795197-3341-1-git-send-email-raphael.norwitz@nutanix.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: raphael.s.norwitz@gmail.com, Raphael Norwitz <raphael.norwitz@nutanix.com>

On authentication failure when connecting to an iscsi server, fio will
print "sicsi: failed to connect to LUN : Failed to log in to target.".

This change fixes a typo, changing sicsi to iscsi.

Signed-off-by: Raphael Norwitz <raphael.norwitz@nutanix.com>
---
 engines/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/libiscsi.c b/engines/libiscsi.c
index 58667fb..35761a6 100644
--- a/engines/libiscsi.c
+++ b/engines/libiscsi.c
@@ -109,7 +109,7 @@ static int fio_iscsi_setup_lun(struct iscsi_info *iscsi_info,
 	if (iscsi_full_connect_sync(iscsi_lun->iscsi,
 				    iscsi_lun->url->portal,
 				    iscsi_lun->url->lun)) {
-		log_err("sicsi: failed to connect to LUN : %s\n",
+		log_err("iscsi: failed to connect to LUN : %s\n",
 			iscsi_get_error(iscsi_lun->iscsi));
 		ret = EINVAL;
 		goto out;
-- 
1.8.3.1


