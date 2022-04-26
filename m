Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23EDC433EF
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355375AbiDZVYc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355377AbiDZVYb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:24:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4800714CC39
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:21:23 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 3AC417E790;
        Tue, 26 Apr 2022 21:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008083;
        bh=pMZIVZau7iMXz/U97e6Tg4Bs5xKTzO08zHXSv9ZLmJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9dVWLginjP2DLwK+dp7zxCO+9jKC8TN17ykhbJAAfskuwWDA0Oh0L1agdIiXcoiM
         fPZ0idt0Rp34cua6i49eH9EOt6PRhmxgDnWzcsdk+skt3QLUAbwKFj6dJVbTr3Ybry
         di839n+O4fjuw8MYPcUBbjzDiUpJpVEukBTqd/lJNeSo2jNe+OJa6LMbp40gF6JkdD
         /zd1oUgD3uQxn2NRGV/1GAOSSjmdL7SdjNt/9wwU6019en1YBwL4UyUcq0P8Bi8FcZ
         S9rRyTTiwrekuEP648ms58Z7NobcG6K3xq/UpwPXxLnxtakNbjEMXToKWEI5pqF+QD
         /xYkENwkf7qtw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 4/6] engines/net: Replace `malloc()`+`memset()` with `calloc()`
Date:   Wed, 27 Apr 2022 04:20:42 +0700
Message-Id: <20220426212044.78898-5-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Replace `malloc()` + `memset()` with `calloc()`. While in there, handle
the ENOMEM case of it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 engines/net.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/engines/net.c b/engines/net.c
index c6cec584..8a898748 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1363,6 +1363,10 @@ static int fio_netio_setup(struct thread_data *td)
 {
 	struct netio_data *nd;
 
+	nd = calloc(1, sizeof(*nd));
+	if (!nd)
+		return 1;
+
 	if (!td->files_index) {
 		add_file(td, td->o.filename ?: "net", 0, 0);
 		td->o.nr_files = td->o.nr_files ?: 1;
@@ -1370,9 +1374,6 @@ static int fio_netio_setup(struct thread_data *td)
 	}
 
 	if (!td->io_ops_data) {
-		nd = malloc(sizeof(*nd));
-
-		memset(nd, 0, sizeof(*nd));
 		nd->listenfd = -1;
 		nd->pipes[0] = nd->pipes[1] = -1;
 		td->io_ops_data = nd;
@@ -1391,7 +1392,8 @@ static int fio_netio_setup_splice(struct thread_data *td)
 {
 	struct netio_data *nd;
 
-	fio_netio_setup(td);
+	if (fio_netio_setup(td))
+		return 1;
 
 	nd = td->io_ops_data;
 	if (nd) {
-- 
Ammar Faizi

