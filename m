Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401D8C43334
	for <fio@archiver.kernel.org>; Wed, 20 Jul 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiGTMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 20 Jul 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiGTMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Jul 2022 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E28B55
        for <fio@vger.kernel.org>; Wed, 20 Jul 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=x9SML4b2GVOxB0ia77EjG/itfzDR4Cdd+vNIkmRem9A=; b=gg3eAaUhDxS3B8Z7+2yUn8bZWW
        Ap6Fkr9u+F+br+MkIvwWZz0yOViQAEuCZUQ0kF7OoH+FOU8nQ6G8IcakcwPhFsxUjoMjWUBWqv0JC
        2znbiaTsLkhMOn3hZpW5kEI4dwsb4f4LxOoXo+yuJ+EzFYk4PY5e8P9d73ILKr2Dbr29+qdTl0/T9
        r7m8u7ZUnOUbZU7cpgbrR76ajqNGubuDRqZ7oro0xNznrIzwfPDu7IsWAiRYoafBSkDKEYM07tr0p
        sNcbrVVH/RR+7Biv9xU6RyV/YJZnaBWhM4M9AG1PLfOjrOpFLUZzld5jRvfCKTdFovNLVfMvK3Tfc
        eB+5FWDw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oE8N2-005JlQ-DD
        for fio@vger.kernel.org; Wed, 20 Jul 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4A0B11BC017F; Wed, 20 Jul 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220720120002.4A0B11BC017F@kernel.dk>
Date:   Wed, 20 Jul 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d6225c1550827077c0c0f9e1b8816b4f35cd5304:

  Update README.rst to specify secure protocols where possible (2022-07-11 07:53:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9c1c1a8d6a4f30eba9595da951d18db1685c03d8:

  engines/http: silence openssl 3.0 deprecation warnings (2022-07-19 13:21:19 -0600)

----------------------------------------------------------------
Giuseppe Baccini (1):
      Fixed misplaced goto in http.c

Jens Axboe (1):
      engines/http: silence openssl 3.0 deprecation warnings

Vincent Fu (1):
      Merge branch 'giubacc-misplaced-goto'

 engines/http.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/http.c b/engines/http.c
index 696febe1..1de9e66c 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -29,6 +29,10 @@
 #include "fio.h"
 #include "../optgroup.h"
 
+/*
+ * Silence OpenSSL 3.0 deprecated function warnings
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
 
 enum {
 	FIO_HTTP_WEBDAV	    = 0,
@@ -526,8 +530,8 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 			if (status == 100 || (status >= 200 && status <= 204))
 				goto out;
 			log_err("DDIR_WRITE failed with HTTP status code %ld\n", status);
-			goto err;
 		}
+		goto err;
 	} else if (io_u->ddir == DDIR_READ) {
 		curl_easy_setopt(http->curl, CURLOPT_READDATA, NULL);
 		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, &_curl_stream);
