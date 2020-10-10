Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731345AbgJJTxq (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Oct 2020 15:53:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138CAC0613BF
        for <fio@vger.kernel.org>; Sat, 10 Oct 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kRDXg-0004cQ-7f
        for fio@vger.kernel.org; Sat, 10 Oct 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201010120002.052601BC0111@kernel.dk>
Date: Sat, 10 Oct 2020 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7064f8942a3b8070acf60b8e5fabc16f8221ae40:

  Merge branch 'msys2' of https://github.com/sitsofe/fio into master (2020-09-14 19:43:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 729071019ee23804d52bed47357e4324be6b06bf:

  Merge branch 'master' of https://github.com/chengli-rutgers/fio into master (2020-10-09 07:28:55 -0600)

----------------------------------------------------------------
Cheng Li (1):
      td_var: avoid arithmetic on a pointer to void cast (#1096)

Jens Axboe (1):
      Merge branch 'master' of https://github.com/chengli-rutgers/fio into master

 parse.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/parse.h b/parse.h
index 1d2cbf74..e6663ed4 100644
--- a/parse.h
+++ b/parse.h
@@ -125,7 +125,7 @@ static inline void *td_var(void *to, const struct fio_option *o,
 	else
 		ret = to;
 
-	return ret + offset;
+	return (void *) ((uintptr_t) ret + offset);
 }
 
 static inline int parse_is_percent(unsigned long long val)

