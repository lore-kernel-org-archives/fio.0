Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33396 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbcDTQwY (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 20 Apr 2016 12:52:24 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id A22E3340B81
	for <fio@vger.kernel.org>; Wed, 20 Apr 2016 16:52:22 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] include sys/sysmacros.h for major/minor
Date: Wed, 20 Apr 2016 12:52:19 -0400
Message-Id: <1461171139-20616-1-git-send-email-vapier@gentoo.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

These functions have always been defined in sys/sysmacros.h under
Linux C libraries.  For some, including sys/types.h implicitly
includes that as well, but glibc wants to deprecate that, and some
others already have.  Include the header explicitly for the funcs.

The mtd change is already in upstream mtd-utils too.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 os/os-linux.h         | 1 +
 oslib/libmtd_common.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/os/os-linux.h b/os/os-linux.h
index 9e708f0..23c16b6 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -6,6 +6,7 @@
 #include <sys/ioctl.h>
 #include <sys/uio.h>
 #include <sys/syscall.h>
+#include <sys/sysmacros.h>
 #include <sys/vfs.h>
 #include <sys/mman.h>
 #include <unistd.h>
diff --git a/oslib/libmtd_common.h b/oslib/libmtd_common.h
index a123323..9768066 100644
--- a/oslib/libmtd_common.h
+++ b/oslib/libmtd_common.h
@@ -30,6 +30,7 @@
 #include <errno.h>
 #include <features.h>
 #include <inttypes.h>
+#include <sys/sysmacros.h>
 
 #ifndef PROGRAM_NAME
 # error "You must define PROGRAM_NAME before including this header"
-- 
2.7.4

