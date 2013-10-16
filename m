Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50754 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab3JPJi7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Oct 2013 05:38:59 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so632345pde.38
        for <fio@vger.kernel.org>; Wed, 16 Oct 2013 02:38:58 -0700 (PDT)
From: Hong Zhiguo <honkiko@gmail.com>
Subject: [PATCH] client.c: fix free of wrong pointer
Date: Wed, 16 Oct 2013 17:37:27 +0800
Message-Id: <1381916247-9947-1-git-send-email-zhiguohong@tencent.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Hong Zhiguo <zhiguohong@tencent.com>

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
---
 client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/client.c b/client.c
index b20d6dc..1fefda8 100644
--- a/client.c
+++ b/client.c
@@ -625,7 +625,7 @@ static int __fio_client_send_ini(struct fio_client *client, const char *filename
 	if (len) {
 		log_err("fio: failed reading job file %s\n", filename);
 		close(fd);
-		free(buf);
+		free(pdu);
 		return 1;
 	}
 
-- 
1.8.1.2

