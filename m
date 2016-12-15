Return-Path: <dave.jiang@intel.com>
Subject: [PATCH] fio: move _FORTIFY_SOURCE to only when optimization is
 turned on
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Dec 2016 14:51:28 -0700
Message-ID: <148183868856.125259.7337489521608029445.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

When compile with debug, without the proper -O flag the compiler complains:
/usr/include/features.h:331:4: warning: #warning _FORTIFY_SOURCE requires
compiling with optimization (-O) [-Wcpp]
#  warning _FORTIFY_SOURCE requires compiling with optimization (-O)
Moving _FORTIFY_SOURCE to optimized compile option.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index b3a12dd..fa12008 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ all:
 include config-host.mak
 endif
 
-DEBUGFLAGS = -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
+DEBUGFLAGS = -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
@@ -29,7 +29,7 @@ PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/fio_latency2csv.py tools/hist/fiologparser_hist.py)
 
 ifndef CONFIG_FIO_NO_OPT
-  CFLAGS += -O3
+  CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 
 ifdef CONFIG_GFIO


