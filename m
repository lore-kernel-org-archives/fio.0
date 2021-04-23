Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhDWMBp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Apr 2021 08:01:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9095EC061574
        for <fio@vger.kernel.org>; Fri, 23 Apr 2021 05:01:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lZuTd-001oZF-PZ
        for fio@vger.kernel.org; Fri, 23 Apr 2021 12:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210423120002.4CA671BC0158@kernel.dk>
Date: Fri, 23 Apr 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5592e99219864e21b425cfc66fa05ece5b514259:

  backend: fix switch_ioscheduler() (2021-04-16 10:25:24 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1b65668b6a50392436947802a49896e891feb0f8:

  Merge branch 'zbd-no-parallel-init' of https://github.com/floatious/fio (2021-04-22 11:18:23 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'zbd-no-parallel-init' of https://github.com/floatious/fio

Niklas Cassel (1):
      init: zonemode=zbd does not work with create_serialize=0

 init.c | 5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 37bff876..60c7cff4 100644
--- a/init.c
+++ b/init.c
@@ -633,6 +633,11 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
+	if (o->zone_mode == ZONE_MODE_ZBD && !o->create_serialize) {
+		log_err("fio: --zonemode=zbd and --create_serialize=0 are not compatible.\n");
+		ret |= 1;
+	}
+
 	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_size) {
 		log_err("fio: --zonesize must be specified when using --zonemode=strided.\n");
 		ret |= 1;

