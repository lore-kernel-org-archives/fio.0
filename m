Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30D0C001DE
	for <fio@archiver.kernel.org>; Fri, 28 Jul 2023 12:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbjG1MA6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbjG1MAw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jul 2023 08:00:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B10449C
        for <fio@vger.kernel.org>; Fri, 28 Jul 2023 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QcqA6MkZviZJJNwLe57HIu29ZK8cKnikrPxhI0hLEDA=; b=o8RVzFyBsXGS87j7wkIRLXkdb4
        4BcO9Wj/4jDiUr6J76XhQIsIF9BWVSn+jVekk8gt4HNRQNihQ0gEWsdNzGRwLujmj6lG4IWpr/Je1
        +HxjM+0rMrJrOT+6KosqR5Q5CPwnCz398feLzorco4TdSEwFHdo7Dm0Mfji4WwBu4FzChGy8y32pH
        9nqWFQ72A9F02limTnuQ0Nra3eWMu2/26S99x4g1CpfrYPB2+hQiCck/oDqgIGgsjpjX+EY6jyUZ4
        BoEGKaSQgHHnx2Tv47Z6OqpxTaXsqdYESIlqp0NcePDvrAGBh1/kzxjpYTHNEcunK1v46ujcB03q8
        gncgCD+g==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qPM8c-008THO-Vm
        for fio@vger.kernel.org; Fri, 28 Jul 2023 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id DCCC71BC018C; Fri, 28 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230728120001.DCCC71BC018C@kernel.dk>
Date:   Fri, 28 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0b47b2cf3dab1d26d72f52ed8c19f782a8277d3a:

  Merge branch 'prio-hints' (2023-07-21 15:23:40 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 45eb1cf5ce883ae3b170f102db38204616c8e4b1:

  Merge branch 'helper_thread-fix-missing-stdbool-header' of https://github.com/dpronin/fio (2023-07-27 13:48:26 -0600)

----------------------------------------------------------------
Denis Pronin (3):
      diskutil.h: fix missing headers wanted by the header
      helper_thread.h: include missing stdbool.h because 'bool' type is used
      helper_thread.h: forwardly declare structures fio_sem and sk_out

Jens Axboe (2):
      Merge branch 'diskutil-fix-missing-headers' of https://github.com/dpronin/fio
      Merge branch 'helper_thread-fix-missing-stdbool-header' of https://github.com/dpronin/fio

 diskutil.h      | 3 +++
 helper_thread.h | 5 +++++
 2 files changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/diskutil.h b/diskutil.h
index 9dca42c4..9b283799 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -2,10 +2,13 @@
 #define FIO_DISKUTIL_H
 #define FIO_DU_NAME_SZ		64
 
+#include <stdint.h>
 #include <limits.h>
 
 #include "helper_thread.h"
 #include "fio_sem.h"
+#include "flist.h"
+#include "lib/ieee754.h"
 
 /**
  * @ios: Number of I/O operations that have been completed successfully.
diff --git a/helper_thread.h b/helper_thread.h
index d7df6c4d..1c8167e8 100644
--- a/helper_thread.h
+++ b/helper_thread.h
@@ -1,6 +1,11 @@
 #ifndef FIO_HELPER_THREAD_H
 #define FIO_HELPER_THREAD_H
 
+#include <stdbool.h>
+
+struct fio_sem;
+struct sk_out;
+
 extern void helper_reset(void);
 extern void helper_do_stat(void);
 extern bool helper_should_exit(void);
