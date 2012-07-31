Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp8.oregonstate.edu ([128.193.15.45]:54306 "EHLO
	smtp8.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GaT6q (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 15:58:46 -0400
Message-ID: <20120731124922.18191l6yyd1pno4k@webmail.oregonstate.edu>
Date: Tue, 31 Jul 2012 12:49:22 -0700
From: clinew@onid.orst.edu
Subject: [PATCH] Fix fallocate erroneously returning ENOSYS on Linux
 systems
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, kcastiglia@aereo.com

Currently, the helpers.c file provides a function defintion for Linux  
fallocate
that sets errno to ENOSYS and returns failure; this is useful for a non-Linux
OS. However, this definition will override the Linux implementation of
fallocate when 'fallocate=keep' is set. Adding a preprocessor macro to check
if Linux fallocate is defined fixes this issue.

Signed-off-by: Wade Cline <wcline@us.ibm.com>
---
  helpers.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/helpers.c b/helpers.c
index 9562567..714842e 100644
--- a/helpers.c
+++ b/helpers.c
@@ -9,11 +9,13 @@
  #include "arch/arch.h"
  #include "os/os.h"

+#ifndef FIO_HAVE_LINUX_FALLOCATE
  int _weak fallocate(int fd, int mode, off_t offset, off_t len)
  {
         errno = ENOSYS;
         return -1;
  }
+#endif

  #ifndef __NR_fallocate
  int _weak posix_fallocate(int fd, off_t offset, off_t len)
-- 
1.7.8.6
