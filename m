Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3329C433EF
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 09:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiD0J0g (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 05:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiD0J0e (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 05:26:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1828729719C
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 02:22:19 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id EB5AE7E3A7;
        Wed, 27 Apr 2022 09:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651050720;
        bh=KNA3jC8GwYd6IxfZlrn8k5uvhuPqv+9FhIUxeLtP56I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQfByQ8cXauVtXu+6XY6XYeU6TpliBqtEk+Ij6/q5L1hcB1N8rxMN4mFs4wMwHddZ
         6PGEjRN7lVsMQ45BwRtq2x28oumP7NjcXGwn+uuZY+4frMJ4sC4ufUGwlXGjDDgBBF
         IIPTwbVkkf0OmvZ+4W1LNpD2lHOtWJWo34LocIbf5nWcF8cBciRMIwchgfoM505vhw
         DNarkV9ANOcPqxVhvABG+3orrZBFe55vOMeHNo2WDUscLoE+37B2zN307L0enpUpk6
         GVKu0pVb+7VyX+Xc++nXFI9b7DimzX3AWTRzMRKPyb0etyFVXaEg52PuiwUxWtee09
         3BOTI2NNBCpYQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 2/6] cgroup: Handle `ENOMEM` case on `malloc()` call
Date:   Wed, 27 Apr 2022 16:11:21 +0700
Message-Id: <20220427091125.114146-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add error handling on `malloc()` call to prevent a NULL pointer
dereference.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cgroup.c b/cgroup.c
index 77e31a4d..b559b70f 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -114,6 +114,8 @@ void cgroup_kill(struct flist_head *clist)
 static char *get_cgroup_root(struct thread_data *td, struct cgroup_mnt *mnt)
 {
 	char *str = malloc(64);
+	if (!str)
+		return NULL;
 
 	if (td->o.cgroup)
 		sprintf(str, "%s/%s", mnt->path, td->o.cgroup);
@@ -178,6 +180,8 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
 	 * Create container, if it doesn't exist
 	 */
 	root = get_cgroup_root(td, *mnt);
+	if (!root)
+		return 1;
 	if (mkdir(root, 0755) < 0) {
 		int __e = errno;
 
-- 
Ammar Faizi

