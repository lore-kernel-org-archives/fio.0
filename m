Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMNAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Nov 2020 08:00:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D5CC0613D1
        for <fio@vger.kernel.org>; Fri, 13 Nov 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdYgP-0007lW-05
        for fio@vger.kernel.org; Fri, 13 Nov 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201113130001.E85301BC0121@kernel.dk>
Date: Fri, 13 Nov 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e82ec77644f4fb7eccb3441485762c1c1c574b2f:

  t/latency_percentiles.py: correct terse parse (2020-11-09 12:13:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 84f9318fc16e33633ac9f789dcef7cc58c3b8595:

  t/latency_percentiles.py: tweak terse output parse (2020-11-12 11:26:58 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Makefile: fix fio version gen
      Fio 3.24
      t/latency_percentiles.py: tweak terse output parse

 FIO-VERSION-GEN          | 2 +-
 Makefile                 | 8 ++++----
 t/latency_percentiles.py | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 5ee7735c..86ea0c5d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.23
+DEF_VER=fio-3.24
 
 LF='
 '
diff --git a/Makefile b/Makefile
index 0d3c877e..ecfaa3e0 100644
--- a/Makefile
+++ b/Makefile
@@ -263,6 +263,10 @@ CFLAGS += $$($(1)_CFLAGS)
 endef
 endif
 
+FIO-VERSION-FILE: FORCE
+	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
+-include FIO-VERSION-FILE
+
 override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(FIO_CFLAGS) $(CFLAGS)
 
 $(foreach eng,$(ENGINES),$(eval $(call engine_template,$(eng))))
@@ -433,10 +437,6 @@ all: $(PROGS) $(T_TEST_PROGS) $(UT_PROGS) $(SCRIPTS) $(ENGS_OBJS) FORCE
 .PHONY: all install clean test
 .PHONY: FORCE cscope
 
-FIO-VERSION-FILE: FORCE
-	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
--include FIO-VERSION-FILE
-
 %.o : %.c
 	@mkdir -p $(dir $@)
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index a9aee019..cc437426 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -216,7 +216,7 @@ class FioLatTest():
             file_data = file.read()
 
         #
-        # Read the first few lines and see if any of them begin with '3;fio-'
+        # Read the first few lines and see if any of them begin with '3;'
         # If so, the line is probably terse output. Obviously, this only
         # works for fio terse version 3 and it does not work for
         # multi-line terse output
@@ -224,7 +224,7 @@ class FioLatTest():
         lines = file_data.splitlines()
         for i in range(8):
             file_data = lines[i]
-            if file_data.startswith('3;;latency'):
+            if file_data.startswith('3;'):
                 self.terse_data = file_data.split(';')
                 return True
 

