Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B86AC43217
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 23:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiKRX2t (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 18:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiKRX2M (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 18:28:12 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62004C050B
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 15:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=oHjAitIsfthnDROuhuyjJXxNebsJdffn2W39yU2wWGs=; b=lflL5lY1V966ZHX8iBzp/pfSkW
        J1rc9sS+MkUDlS4/cuJMuKaVC8UUz0q5Yajq7gLZSmEDqlW+LhzntCnP1orpvQtS3Jwb9xTOgtItx
        Hk0WP4baHJcL7PL7vDG6uzlzPfAp5F2S1HiOu3bM/QM+8G2ehditUSyrmADuuC411i8Je/XI5FlwO
        v7iOcbj/Tvt658FvQVqzfonytT9qV0UCfRu+hRWLSAI+cb7rJ1y3G5b8+X+Ls24IkGOoZ1g8CPv+q
        ZMLCt3LoZ/LkywYFxVGZ1rQSZI/vZPZugYYWBMaHC9jnGTMa/Dc4j2zSbeIkNYJ60nyCBRZYAJoM4
        wZW6S50A==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1owAab-005chq-J3; Fri, 18 Nov 2022 16:16:06 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1owAaZ-000MLa-Ah; Fri, 18 Nov 2022 16:16:03 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Fri, 18 Nov 2022 16:16:00 -0700
Message-Id: <20221118231601.85837-6-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221118231601.85837-1-logang@deltatee.com>
References: <20221118231601.85837-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v3 5/6] lib/pattern: Support binary pattern buffers on windows
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On windows, binary files used as pattern buffers may be mangled or
truncated seeing the files are openned in text mode.

Fix this by passing O_BINARY on windows when openning the file.

Suggested-by: Vincent Fu <vincentfu@gmail.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 lib/pattern.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/pattern.c b/lib/pattern.c
index 1ae05758f768..9be29af6bcf5 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -47,7 +47,11 @@ static const char *parse_file(const char *beg, char *out,
 	if (file == NULL)
 		goto err_out;
 
+#ifdef _WIN32
+	fd = open(file, O_RDONLY | O_BINARY);
+#else
 	fd = open(file, O_RDONLY);
+#endif
 	if (fd < 0)
 		goto err_free_out;
 
-- 
2.30.2

