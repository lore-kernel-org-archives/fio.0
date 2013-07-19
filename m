Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:32992 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab3GSSYc (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 19 Jul 2013 14:24:32 -0400
Received: by mail-oa0-f41.google.com with SMTP id n10so6606103oag.28
        for <fio@vger.kernel.org>; Fri, 19 Jul 2013 11:24:31 -0700 (PDT)
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 4/5] net: fix recvfrom error message
Date: Fri, 19 Jul 2013 13:24:09 -0500
Message-Id: <1374258250-9801-4-git-send-email-sbohrer@rgmadvisors.com>
In-Reply-To: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>

The error is from recvfrom not sendto.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 engines/net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/engines/net.c b/engines/net.c
index 257ab8f..5bd98df 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -685,7 +685,7 @@ static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 
 	ret = recvfrom(f->fd, (void *) &msg, sizeof(msg), MSG_WAITALL, to, &len);
 	if (ret < 0) {
-		td_verror(td, errno, "sendto udp link open");
+		td_verror(td, errno, "recvfrom udp link open");
 		return ret;
 	}
 
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
