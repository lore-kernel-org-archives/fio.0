Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78D5C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343911AbiD2Auo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiD2Aun (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:43 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146DE888D2
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:28 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id DED407E39D;
        Fri, 29 Apr 2022 00:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193247;
        bh=BIVlGL8l8IAMglU2zlSp1iqYEowik/hP19802rC5wLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ra2z4IeIuhrj2gVuEMgIXJc7wKvqENFjdFE62VCFHhcAj41+iPgd1ZN98Fg5iezfw
         zVhyXO2Mqic+zqbheSAfqG0RVtC1MP4oT833Q/hUnGpgMRu2x5XUbLHzk5MowVTra0
         sjvEzGPAYIl62w9hOXgCUC/fQJoeWP2nZO1DbElfx1tW7K3MZaHsRYTcexdfUiaojG
         gM5QSKMaeeqagBJ1TwW0xUs91mt+35SxzHKVGyN1hwmq/Zl3QjPMBFJzZgxLdRGiI2
         w2qVdyjg9CMdNOe5lkiK5mHjYArGLk1wRQk1ndEcY9w78XfhG9G3Qqa38SDrNnz1YP
         HQsKrdoiikOSQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 3/8] engines/net: Add ENOMEM handling on a `malloc()` call
Date:   Fri, 29 Apr 2022 07:47:00 +0700
Message-Id: <20220429004705.260034-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Replace `malloc()` + `memset()` with `calloc()` to simplify the call.
`calloc()` zeroes the allocated memory, so we can avoid `memset()`.
Also, handle the `ENOMEM` case.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 engines/net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/engines/net.c b/engines/net.c
index c6cec584..24c1463d 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1370,9 +1370,9 @@ static int fio_netio_setup(struct thread_data *td)
 	}
 
 	if (!td->io_ops_data) {
-		nd = malloc(sizeof(*nd));
-
-		memset(nd, 0, sizeof(*nd));
+		nd = calloc(1, sizeof(*nd));
+		if (!nd)
+			return 1;
 		nd->listenfd = -1;
 		nd->pipes[0] = nd->pipes[1] = -1;
 		td->io_ops_data = nd;
@@ -1391,7 +1391,8 @@ static int fio_netio_setup_splice(struct thread_data *td)
 {
 	struct netio_data *nd;
 
-	fio_netio_setup(td);
+	if (fio_netio_setup(td))
+		return 1;
 
 	nd = td->io_ops_data;
 	if (nd) {
-- 
Ammar Faizi

