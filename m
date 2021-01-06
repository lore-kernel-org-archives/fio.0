Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbhAFNCs (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Jan 2021 08:02:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5268BC06134C
        for <fio@vger.kernel.org>; Wed,  6 Jan 2021 05:02:07 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kx8Q3-002LXa-2U
        for fio@vger.kernel.org; Wed, 06 Jan 2021 13:01:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210106130001.C00371BC0148@kernel.dk>
Date: Wed,  6 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a64b7d6e9b3e5174e034f7c147de71e4b51b2a01:

  Merge branch 'fix-get-next-file' of https://github.com/aclamk/fio (2020-12-29 16:36:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4065c6a4949fa85e5f2d8de8a5556130231dd680:

  log: only compile log_prevalist() if FIO_INC_DEBUG is set (2021-01-05 13:14:28 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      log: only compile log_prevalist() if FIO_INC_DEBUG is set

 log.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/log.c b/log.c
index 6c36813d..562a29aa 100644
--- a/log.c
+++ b/log.c
@@ -42,6 +42,7 @@ size_t log_valist(const char *fmt, va_list args)
 }
 
 /* add prefix for the specified type in front of the valist */
+#ifdef FIO_INC_DEBUG
 void log_prevalist(int type, const char *fmt, va_list args)
 {
 	char *buf1, *buf2;
@@ -64,6 +65,7 @@ void log_prevalist(int type, const char *fmt, va_list args)
 	len = log_info_buf(buf2, len);
 	free(buf2);
 }
+#endif
 
 ssize_t log_info(const char *format, ...)
 {

