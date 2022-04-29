Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D822C433F5
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345730AbiD2Auy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352285AbiD2Aux (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:53 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66B8887B0
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:37 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 2C45D7E7B1;
        Fri, 29 Apr 2022 00:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193257;
        bh=wVUYuYjrBClYx4+2eUIdL3VhE7RbWuoQEVepQKvoDok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz2cWU5MeeleRbJK5nYBFxrQ75c5H1Ozo4Ul/stQBVzZJBSddHkeKJFQKrzgCSHGE
         xU3b5nsU3qGPBg8aH7nc0wdcZozxK5H0tvJDW30+FZ4uWCH1R6C8oa4DVhYmKDSnSQ
         vndlxpYc2B/TzCFPpJBp5A1GRUepAStvLevSBQWGnl2b8uaFbZl7ZiMGvTF1fux0Fu
         gvueDdoW7e4z1+vPVQFlKO18YlVnr4/pfv3hpRIZsKvTnf62Vv9kxaduf/b6v4a09Y
         LSYnByjQhYQZxZHIzchBOsZvEXU2lgS2E9+XJ7A9aSu4QiJ4RApSvj5QfIAvR7z96c
         bhlQB0EGZpl/A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 7/8] client: Add ENOMEM handling on `realloc()` calls
Date:   Fri, 29 Apr 2022 07:47:04 +0700
Message-Id: <20220429004705.260034-8-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

We need to use a temporary variable when calling `realloc()`. If we do:

    ptr = realloc(ptr, new_size);

the `ptr` will be NULL when the `realloc()` hits ENOMEM and the old
pointer will be leaked. This fixes several places that do the above
`realloc()` call.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 client.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/client.c b/client.c
index 605a3ce5..c93c90eb 100644
--- a/client.c
+++ b/client.c
@@ -338,9 +338,16 @@ static void __fio_client_add_cmd_option(struct fio_client *client,
 					const char *opt)
 {
 	int index;
+	void *tmp;
 
 	index = client->argc++;
-	client->argv = realloc(client->argv, sizeof(char *) * client->argc);
+	tmp = realloc(client->argv, sizeof(char *) * client->argc);
+	if (!tmp) {
+		log_err("fio: cannot reallocate client->argv in %s\n", __func__);
+		return;
+	}
+
+	client->argv = tmp;
 	client->argv[index] = strdup(opt);
 	dprint(FD_NET, "client: add cmd %d: %s\n", index, opt);
 }
@@ -1535,12 +1542,17 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
 	client->nr_stat = le32_to_cpu(pdu->stat_outputs);
 
 	if (client->jobs) {
+		void *tmp;
 		int i;
 
-		if (client->opt_lists)
+		tmp = realloc(client->opt_lists,
+			      client->jobs * sizeof(struct flist_head));
+		if (!tmp) {
 			free(client->opt_lists);
+			return;
+		}
+		client->opt_lists = tmp;
 
-		client->opt_lists = malloc(client->jobs * sizeof(struct flist_head));
 		for (i = 0; i < client->jobs; i++)
 			INIT_FLIST_HEAD(&client->opt_lists[i]);
 	}
@@ -1750,7 +1762,11 @@ fail:
 	}
 
 	size += sb.st_size;
-	rep = realloc(rep, size);
+	tmp = realloc(rep, size);
+	if (!tmp)
+		goto fail;
+
+	rep = tmp;
 	rep->size = cpu_to_le32((uint32_t) sb.st_size);
 
 	fd = open((char *)pdu->path, O_RDONLY);
-- 
Ammar Faizi

