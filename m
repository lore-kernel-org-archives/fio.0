Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgE3MAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 May 2020 08:00:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB9C03E969
        for <fio@vger.kernel.org>; Sat, 30 May 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jf09m-0002pH-5X
        for fio@vger.kernel.org; Sat, 30 May 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200530120001.7E1581BC01A2@kernel.dk>
Date: Sat, 30 May 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dacac3b936092aa73e29257fefcb7bf5658ec7cb:

  Merge branch 'python3-testing' of https://github.com/vincentkfu/fio (2020-05-28 13:27:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2f6cbfdcf0ce3b53e83713e3a6b5a0bb6a76a1e9:

  Merge branch 'pshared1' of https://github.com/kusumi/fio (2020-05-29 08:16:10 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'pshared1' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      pshared: fix comment on supported platforms

 pshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/pshared.c b/pshared.c
index 791faf95..e671c87f 100644
--- a/pshared.c
+++ b/pshared.c
@@ -51,7 +51,7 @@ int mutex_init_pshared_with_type(pthread_mutex_t *mutex, int type)
 	}
 
 	/*
-	 * Not all platforms support process shared mutexes (FreeBSD)
+	 * Not all platforms support process shared mutexes (NetBSD/OpenBSD)
 	 */
 #ifdef CONFIG_PSHARED
 	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);

