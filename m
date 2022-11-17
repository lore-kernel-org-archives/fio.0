Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EE3C4321E
	for <fio@archiver.kernel.org>; Thu, 17 Nov 2022 22:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbiKQWGf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241131AbiKQWGL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Nov 2022 17:06:11 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF9F19C11
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 14:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=T6tAESJTj/S70pSq5NKTSnwsyBQSiMeyJpLdJx4MFUU=; b=cwPTLI+9f4OlaM7I6/a9Q0f0U7
        8v5WOSmxYnM2zdNkVKghbQA6a+xVyxwL76p48ZxNMtbFGkC4w37fyAXvM2fPJh/IgIZhQxO/a2kHr
        LbxvI+k1J22SA3rMVuJjWS1gd+V4zmitEzJU2dE2J2dxpe5/Q1nzBnjJCIALGcNaAqVaHXndXo4hk
        gHlGW3vFl+HczJ2dmzdHLpWdL+g1dbI3D1J8XkZgNxzksupa/bhf/llTzg9eisbjOoDuykF8bDJgK
        7M4mKtRDxDcdSIq3CeqOG33XKiuTYhUFCIfEZZxysWgXj7cQXJJcvdmeOTVFkVX6NK7g7p8VBVKoj
        pPvO1+fA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0i-004pDC-If; Thu, 17 Nov 2022 15:05:29 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0i-000Ljn-2r; Thu, 17 Nov 2022 15:05:28 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 17 Nov 2022 15:05:21 -0700
Message-Id: <20221117220523.83501-4-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117220523.83501-1-logang@deltatee.com>
References: <20221117220523.83501-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v2 3/5] lib/pattern: Support short repeated read calls when loading from file
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Once a pattern file can be much larger, it will be possible that
kernel will return a short read while loading the file and thus may
randomly only load part of the file.

Fix this by putting the read in a loop so the entire file will be
read.
---
 lib/pattern.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/lib/pattern.c b/lib/pattern.c
index 70d0313d237e..d324263c2b34 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -32,7 +32,7 @@ static const char *parse_file(const char *beg, char *out,
 	const char *end;
 	char *file;
 	int fd;
-	ssize_t count;
+	ssize_t rc, count = 0;
 
 	if (!out_len)
 		goto err_out;
@@ -52,9 +52,16 @@ static const char *parse_file(const char *beg, char *out,
 		goto err_free_out;
 
 	if (out) {
-		count = read(fd, out, out_len);
-		if (count == -1)
-			goto err_free_close_out;
+		while (1) {
+			rc = read(fd, out, out_len - count);
+			if (rc == 0)
+				break;
+			if (rc == -1)
+				goto err_free_close_out;
+
+			count += rc;
+			out += rc;
+		}
 	} else {
 		count = lseek(fd, 0, SEEK_END);
 		if (count == -1)
-- 
2.30.2

