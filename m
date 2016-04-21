Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbcDUMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Apr 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1atDH9-0002pX-J5
	for fio@vger.kernel.org; Thu, 21 Apr 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160421120002.178592C18E7@kernel.dk>
Date: Thu, 21 Apr 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4b1ddb7afd332431e83ef5f1b9ee0216aef197c4:

  Documentation: it's 'log_max_value', not 'log_max' (2016-04-18 16:54:12 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 250e878ab5f26b32facbb6e134f3738aa1aa0120:

  include sys/sysmacros.h for major/minor (2016-04-21 07:47:26 -0400)

----------------------------------------------------------------
Mike Frysinger (1):
      include sys/sysmacros.h for major/minor

 os/os-linux.h         | 1 +
 oslib/libmtd_common.h | 1 +
 2 files changed, 2 insertions(+)

---

Diff of recent changes:

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
