Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327B5C433F5
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 09:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiD0JT3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 05:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiD0JT1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 05:19:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60ED92309
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 02:16:03 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 71DF97E7A7;
        Wed, 27 Apr 2022 09:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651050724;
        bh=k0PCt1kWnifDSQWCbe1tgCq3N+c43RE7JEOJR6Eg6XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DucWRR9cLoa8JamLeAxO0cBrvwrUr0opmyxV8OhDm3yyu/2CH+KKHJ6fdKListzuH
         uj/q9BuAcDqVt4J4SmDHKENd73+HjBV18tgzch7rdnMTrXihPfwqZc1Rc8stNKeln/
         TPQ+GcKpPKLeOv15c21TsLi0TFupgXY4T5yIWn0YzRNeBQhqp14NlCJlFBfD2uksct
         KQXsIaNCHlrfz9UbQfbXqRJ9qxQ/J3CEFD9gbayaxjDrzLWp3LRaIOoiJTonXdOWXP
         DoFwUSrdo2lSOPg4B0/sBoLqeU0XQIt56QKbUplT8wiumLcGdvEANA3uM0CNLpWjrd
         SeBdYk18+Z1IA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 4/6] engines/net: Replace `malloc()` + `memset()` with `calloc()`
Date:   Wed, 27 Apr 2022 16:11:23 +0700
Message-Id: <20220427091125.114146-5-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

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

