Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaKSNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xr4rd-0008Kq-BR
	for fio@vger.kernel.org; Wed, 19 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141119130003.8180D400E3@lyth.info>
Date: Wed, 19 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 42da5c8b2cdd53427145b623293bc5b915fb5f05:

  Fix some shadow warnings for some gcc variants (2014-11-12 11:11:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 21750a254b5481f78ac3c6697754abf3cfa63e89:

  Kill off -Wshadow again (2014-11-18 20:14:23 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      verify: allow empty/no trigger file
      Kill off -Wshadow again

 Makefile |    2 +-
 init.c   |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index b7c1645..8a28f62 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ endif
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -O3 -g -ffast-math
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wshadow -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
+CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio
diff --git a/init.c b/init.c
index c7fdcdd..108f2b8 100644
--- a/init.c
+++ b/init.c
@@ -2212,8 +2212,10 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 
 			sz = split - optarg;
-			trigger_file = calloc(1, sz + 1);
-			strncpy(trigger_file, optarg, sz);
+			if (sz) {
+				trigger_file = calloc(1, sz + 1);
+				strncpy(trigger_file, optarg, sz);
+			}
 
 			split++;
 			cmd = trigger_cmd = strdup(split);
