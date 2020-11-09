Return-Path: <fio-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43440 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgKIQqp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Nov 2020 11:46:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] fix dynamic engine buil
Date: Mon,  9 Nov 2020 10:46:28 -0600
Message-Id: <1604940390-21215-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
References: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: sitsofe@yahoo.com, ykorman@gmail.com, rjones@redhat.com

Builds with --dynamic-libengines are currently broken, because the rule
to build the libraries was moved out of the template that creates them:

make: *** No rule to make target 'engines/libpmem.so', needed by 'all'.  Stop.
make: *** Waiting for unfinished jobs....

Fix this by moving the rule back into the template, calling the template
to create rules only after FIO_CFLAGS has been incorporated into CFLAGS,
and using CFLAGS + -fPIC in that rule rather than FIO_CFLAGS.

Fixes: 8a2cf08d29ac ("Makefile: introduce FIO_CFLAGS")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Makefile | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 8c8a8fc..b0b9f86 100644
--- a/Makefile
+++ b/Makefile
@@ -255,7 +255,9 @@ ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS := $(ENGINES)
 define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
-$$($(1)_OBJS): FIO_CFLAGS += -fPIC $$($(1)_CFLAGS)
+$$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
+engines/lib$(1).so: $$($(1)_OBJS)
+	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
 ENGS_OBJS += engines/lib$(1).so
 endef
 else # !CONFIG_DYNAMIC_ENGINES
@@ -266,6 +268,8 @@ CFLAGS += $$($(1)_CFLAGS)
 endef
 endif
 
+override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(FIO_CFLAGS) $(CFLAGS)
+
 $(foreach eng,$(ENGINES),$(eval $(call engine_template,$(eng))))
 
 OBJS := $(SOURCE:.c=.o)
@@ -438,8 +442,6 @@ FIO-VERSION-FILE: FORCE
 	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
 -include FIO-VERSION-FILE
 
-override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(FIO_CFLAGS) $(CFLAGS)
-
 %.o : %.c
 	@mkdir -p $(dir $@)
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
@@ -567,11 +569,6 @@ unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit $(LIBS)
 endif
 
-ifdef CONFIG_DYNAMIC_ENGINES
-engines/lib$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
-endif
-
 clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] engines/*.so profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -f t/fio-btrace2fio t/io_uring t/read-to-pipe-async
-- 
1.8.3.1


