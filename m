Return-Path: <fio-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52294 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFCbg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Nov 2020 21:31:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: 8a2cf08d29 ("Makefile: introduce FIO_CFLAGS") broke dynamic engines
Message-ID: <838bb7e7-3702-b2c4-641b-4d397aa6a94a@sandeen.net>
Date: Thu, 5 Nov 2020 20:23:03 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>

Hi Sitsofe - 

Seems the commit in the subject broke builds with --dynamic-libengines:

make: *** No rule to make target 'engines/libpmem.so', needed by 'all'.  Stop.
make: *** Waiting for unfinished jobs....

It moved the rule for building the .so's out of the template:

 ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS := $(ENGINES)
 define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
-$$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
-engines/lib$(1).so: $$($(1)_OBJS)
-       $$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
+$$($(1)_OBJS): FIO_CFLAGS += -fPIC $$($(1)_CFLAGS)
 ENGS_OBJS += engines/lib$(1).so
-all install: $(ENGS_OBJS)

... to later in the makefile ...

+ifdef CONFIG_DYNAMIC_ENGINES
+engines/lib$(1).so: $$($(1)_OBJS)
+       $$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
+endif

this is supposed to be part of a template though, so this break things.
i.e. $(1) has no meaning here.

I was going to try to fix it, but Make makes my brain hurt and presumably you moved it
to try to make sure all the FIO_CFLAGS get built or something so ... figured I'd punt
this back to you?

Thanks,
-Eric

