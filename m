Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9F4C433FE
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiDZVY1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241799AbiDZVY1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:24:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303D914AAC8
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:21:19 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 8A18B7E790;
        Tue, 26 Apr 2022 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008078;
        bh=2J5EuS3ECV20EJ65AsdktrAOFU9MBGyYkv7gn790rsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoyAw8ugBoitrOnBRBIpzIQwvJaesiCLtOQwFW6XYjfSCAKou76iYPMr2FB04pEKm
         tFVF39a99x+hBRL27x/f7K+nLr1sqtUsT4n1NcxO8r0vdlNmLsWTN01lPQGJd3RcX5
         fBd/6MZkSc1ZncIxYoBYpB7wAvq+D+oKk/VgqBc2MuY3g2F3sxn6oOWsZ7xDtxSGYX
         msbZdTfqFgy18rR9ItG8/AZHYE0HB98NJv/ppPLTf1VE3wb2snILcRbejjUgfHELUa
         GRTu3tCRIPc+vQSMqrT3PYnRul3RYE/hIlUIPnANlNVuGICF6aXnGH4ba8K6ZFCmuD
         rBLnrnbURr7KQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 2/6] get_cgroup_root: Handle `ENOMEM` case on `malloc()` call
Date:   Wed, 27 Apr 2022 04:20:40 +0700
Message-Id: <20220426212044.78898-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Add error handling on malloc() call to prevent a NULL pointer
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

