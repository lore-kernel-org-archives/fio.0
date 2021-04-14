Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbhDNMAb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Apr 2021 08:00:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA75C061574
        for <fio@vger.kernel.org>; Wed, 14 Apr 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lWeBg-00CWfQ-MU
        for fio@vger.kernel.org; Wed, 14 Apr 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210414120001.AD0901BC015F@kernel.dk>
Date: Wed, 14 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9b6253bc6af3b38d4677f7470f42a1ff22492ef3:

  t/zbd: test repeated async write with block size unaligned to zone size (2021-04-12 06:56:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a2aa490a0677771e070e1e2d9e6fd1ad19cfe1fd:

  Merge branch 'parse-signedness-warn' of https://github.com/floatious/fio (2021-04-13 07:51:17 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'parse-signedness-warn' of https://github.com/floatious/fio

Niklas Cassel (1):
      parse: fix parse_is_percent() warning

 parse.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/parse.h b/parse.h
index 4cf08fd2..d68484ea 100644
--- a/parse.h
+++ b/parse.h
@@ -131,7 +131,7 @@ static inline void *td_var(void *to, const struct fio_option *o,
 
 static inline int parse_is_percent(unsigned long long val)
 {
-	return val >= -101;
+	return val >= -101ULL;
 }
 
 #define ZONE_BASE_VAL ((-1ULL >> 1) + 1)

