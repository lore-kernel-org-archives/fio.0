Return-Path: <fio-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42887 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752096AbcLERlG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 5 Dec 2016 12:41:06 -0500
Subject: [PATCH] fio: add debug compile flag to avoid compiler warning
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 05 Dec 2016 10:41:04 -0700
Message-ID: <148095966487.242344.5154555200954971050.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

When compile with debug, without the proper -O flag the compiler complains:
/usr/include/features.h:331:4: warning: #warning _FORTIFY_SOURCE requires
compiling with optimization (-O) [-Wcpp]
#  warning _FORTIFY_SOURCE requires compiling with optimization (-O)

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index b3a12dd..4e7a0b4 100644
--- a/Makefile
+++ b/Makefile
@@ -30,6 +30,8 @@ SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3
+else
+  CFLAGS += -O
 endif
 
 ifdef CONFIG_GFIO

