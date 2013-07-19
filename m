Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47889 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761065Ab3GSSaX (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 19 Jul 2013 14:30:23 -0400
Received: by mail-oa0-f48.google.com with SMTP id f4so6429432oah.7
        for <fio@vger.kernel.org>; Fri, 19 Jul 2013 11:30:21 -0700 (PDT)
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 5/5] net: close socket on error
Date: Fri, 19 Jul 2013 13:24:10 -0500
Message-Id: <1374258250-9801-5-git-send-email-sbohrer@rgmadvisors.com>
In-Reply-To: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 engines/net.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/engines/net.c b/engines/net.c
index 5bd98df..0c90e1c 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -862,11 +862,13 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 	opt = 1;
 	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void *) &opt, sizeof(opt)) < 0) {
 		td_verror(td, errno, "setsockopt");
+		close(fd);
 		return 1;
 	}
 #ifdef SO_REUSEPORT
 	if (setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, (void *) &opt, sizeof(opt)) < 0) {
 		td_verror(td, errno, "setsockopt");
+		close(fd);
 		return 1;
 	}
 #endif
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
