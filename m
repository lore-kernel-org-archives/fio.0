Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DB1C433EF
	for <fio@archiver.kernel.org>; Mon, 21 Mar 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbiCUMBd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347062AbiCUMBc (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Mar 2022 08:01:32 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF7347AF2
        for <fio@vger.kernel.org>; Mon, 21 Mar 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=RSap4L5uyYZgf7TxwlFAgzrijMbI6lrFYuKHzw9SjAI=; b=XHfuUeKmGQ8Y++jbm123z1ioad
        zYZALD16chddmGtLA58845wTfl0sdgIZZK6dZUSEZQlc4erwopt0szLu0+vopSLKcmDkcsKYlyKBr
        Rv95rcBxdG5Pz9IhQWQpmn4CXiTx4tK4tsuKImOPbZx+d5bEXkvo0moEmrQdKek8MSjpEoybm4bCV
        debzt8OA2dx5YH5nTJ5Xkl5kPAg3b+iSOFHg3IxN8HcoAAAKvKTZ0RBDrAO8IMZY/qk5+yuoSTK9e
        03MLmrMtojQxKmbxgGr1W+PrMjxItPazBB4gw9qqQdnKNIEIh9mbfF5PNQP+uy1diLUplVCefG6Iz
        RMabS6FA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nWGhg-00372T-V3
        for fio@vger.kernel.org; Mon, 21 Mar 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 648431BC011D; Mon, 21 Mar 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220321120002.648431BC011D@kernel.dk>
Date:   Mon, 21 Mar 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1953e1adb5a28ed21370e85991d7f5c3cdc699f3:

  Merge branch 'flags-fix' of https://github.com/albertofaria/fio (2022-03-15 17:21:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c822572d68e326384ce179b9484de0e4abf3d514:

  engines/null: use correct -include (2022-03-20 09:31:20 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      engines/null: update external engine compilation
      Merge branch 'master' of https://github.com/jnoc/fio
      engines/null: use correct -include

Jonathon Carter (1):
      Added citation.cff for easy APA/BibTeX citation directly from the Github repository

 CITATION.cff   | 11 +++++++++++
 engines/null.c |  7 ++++---
 2 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 CITATION.cff

---

Diff of recent changes:

diff --git a/CITATION.cff b/CITATION.cff
new file mode 100644
index 00000000..3df315e5
--- /dev/null
+++ b/CITATION.cff
@@ -0,0 +1,11 @@
+cff-version: 1.2.0
+preferred-citation:
+  type: software
+  authors:
+  - family-names: "Axboe"
+    given-names: "Jens"
+    email: axboe@kernel.dk
+  title: "Flexible I/O Tester"
+  year: 2022
+  url: "https://github.com/axboe/fio"
+licence: GNU GPL v2.0
diff --git a/engines/null.c b/engines/null.c
index 4cc0102b..8dcd1b21 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -6,7 +6,8 @@
  *
  * It also can act as external C++ engine - compiled with:
  *
- * g++ -O2 -g -shared -rdynamic -fPIC -o cpp_null null.c -DFIO_EXTERNAL_ENGINE
+ * g++ -O2 -g -shared -rdynamic -fPIC -o cpp_null null.c \
+ *	-include ../config-host.h -DFIO_EXTERNAL_ENGINE
  *
  * to test it execute:
  *
@@ -201,7 +202,7 @@ struct NullData {
 		return null_commit(td, impl_);
 	}
 
-	int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+	fio_q_status fio_null_queue(struct thread_data *td, struct io_u *io_u)
 	{
 		return null_queue(td, impl_, io_u);
 	}
@@ -233,7 +234,7 @@ static int fio_null_commit(struct thread_data *td)
 	return NullData::get(td)->fio_null_commit(td);
 }
 
-static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+static fio_q_status fio_null_queue(struct thread_data *td, struct io_u *io_u)
 {
 	return NullData::get(td)->fio_null_queue(td, io_u);
 }
