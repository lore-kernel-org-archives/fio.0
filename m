Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47157 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdFZMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Jun 2017 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dPSgX-0005nC-Qv
        for fio@vger.kernel.org; Mon, 26 Jun 2017 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170626120002.061F62C0235@kernel.dk>
Date: Mon, 26 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a2c95580b468a1ddd72ecb5532aca7d94f6efa5b:

  stat: Add iops stat and sample number information to terse format (2017-06-23 16:31:02 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 036a159982656aaa98b0a0490defc36c6065aa93:

  Android: fix missing sysmacros.h include (2017-06-25 09:51:13 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Android: fix missing sysmacros.h include

 diskutil.c               | 1 +
 os/os-android.h          | 1 +
 oslib/linux-dev-lookup.c | 1 +
 3 files changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/diskutil.c b/diskutil.c
index 4fe554f..618cae8 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -3,6 +3,7 @@
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <dirent.h>
 #include <libgen.h>
 #include <math.h>
diff --git a/os/os-android.h b/os/os-android.h
index c56d682..b217daa 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -7,6 +7,7 @@
 #include <sys/mman.h>
 #include <sys/uio.h>
 #include <sys/syscall.h>
+#include <sys/sysmacros.h>
 #include <sys/vfs.h>
 #include <unistd.h>
 #include <fcntl.h>
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 54017ff..1dda93f 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -1,5 +1,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <dirent.h>
 #include <string.h>
 #include <stdio.h>
