Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19D3ECDFA1
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiJZTk3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiJZTk2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:40:28 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9941D419A7
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=KTOhoheYBntt1rgBNXpkSQJ7xA/XK3xI94yTYvkXkE0=; b=rerInKJ9XuT0wQLJmEoJ6JTqGQ
        GefBv/8hwYjOVDJs61jQnztlysiRRAaFUCPVdzoyHcKNeZznfcLWxer3xA3l8bSS39PtqPJQ87aVB
        aQUl7Bv9kZmaEQpCFHBHYuLLDFsc8BZFnv4ckuo/SeXXehLgEq9jU5L3miQfVzTC6z93mPuCfDVz/
        B77N2+6tcAwvFElAeQiV6QJKjgw1ZnJqbrkmGjwwNogpc+0g3ZChOQHIzMbLV8Wm66hNePKBfhnhn
        wq5Srz6ob2ImSZCpxy0hyPF7zAxb1TiPqO7S3dVdgcmlAHVoO2gsa3MBhsY8gK28QJyrYVI7GM/IK
        6CK2Z9gg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmGG-000HiL-Ii; Wed, 26 Oct 2022 13:40:25 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmGG-0008Xd-77; Wed, 26 Oct 2022 13:40:24 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logan.gunthorpe@eideticom.com>
Date:   Wed, 26 Oct 2022 13:40:18 -0600
Message-Id: <20221026194019.32776-4-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026194019.32776-1-logang@deltatee.com>
References: <20221026194019.32776-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, sbates@raithlin.com, David.Sloan@eideticom.com, logan.gunthorpe@eideticom.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH 3/4] lib/pattern: Support short repeated read calls when loading from file
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Logan Gunthorpe <logan.gunthorpe@eideticom.com>

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

