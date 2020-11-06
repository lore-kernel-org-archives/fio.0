Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbgKFS3s (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 6 Nov 2020 13:29:48 -0500
Subject: [PATCH V2] fix dynamic engine build
From: Eric Sandeen <sandeen@redhat.com>
References: <838bb7e7-3702-b2c4-641b-4d397aa6a94a@sandeen.net>
 <3329513a-9330-a96e-d410-1cf1576ef8d2@redhat.com>
Message-ID: <81ca8a21-5a79-82f5-f0b0-832f2793099b@redhat.com>
Date: Fri, 6 Nov 2020 12:29:41 -0600
MIME-Version: 1.0
In-Reply-To: <3329513a-9330-a96e-d410-1cf1576ef8d2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>

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

V1: Broke built-in engine build.

V2: move cflags override and template generation high enough in the Makefile
to actually generate the built-in engine rules in time.

Now... I think /this/ is correct, but I would still appreciate a review from Sitsofe. :)


diff --git a/Makefile b/Makefile
index 8c8a8fce..b0b9f864 100644
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


