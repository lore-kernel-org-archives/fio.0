Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919F9C433F5
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiD2Aul (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352988AbiD2Auk (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFD4BC848
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:22 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 376C07E7B0;
        Fri, 29 Apr 2022 00:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193242;
        bh=UD9tdoFOe/+of16y2OO6Wb2hSL0cbFS2TCSCXi1jsNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flMQptcck/jwrf8dJPP5dSli9SBwtOYAUS+Z/cBCMLL+EQAYhRY2fkG1UwL3wMk0s
         Usq6lk6EPVScJxSvOPDZ4cKeAcVaknGHjERYHNyuPuohTWzICk59X7Kh9UcnpZZ/Fh
         TBMcXBQRMuEfr7kQW5ekT65wibUczsNjh4tkFg/XtljHs016jYbHGxEKya2nSaoV29
         zuEK9lZQPjX/qWl6Ewd672pVULnB0QAM/Q+cBjgzWgHHIGRXHffbPGRLJuKsySBjDH
         rXZZpCc4HtRMbAuYRohH+d0fnLSRgNevRy5HDS6KdWds1k/AvXtbIzFUBmF225yDUo
         1JbSBFhlpijlA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 1/8] cgroup: Add ENOMEM handling on a `malloc()` call
Date:   Fri, 29 Apr 2022 07:46:58 +0700
Message-Id: <20220429004705.260034-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Avoid a NULL pointer dereference bug when `ENOMEM`.

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

