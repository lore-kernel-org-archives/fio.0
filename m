Return-Path: <fio-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:44717 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab1BQUQi (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Feb 2011 15:16:38 -0500
Received: from g5t0029.atlanta.hp.com (g5t0029.atlanta.hp.com [16.228.8.141])
	by g5t0009.atlanta.hp.com (Postfix) with ESMTP id 9656230418
	for <fio@vger.kernel.org>; Thu, 17 Feb 2011 20:16:37 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g5t0029.atlanta.hp.com (Postfix) with ESMTP id 71CDA20031
	for <fio@vger.kernel.org>; Thu, 17 Feb 2011 20:16:37 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [127.0.0.1])
	by beardog.cce.hp.com (8.13.8/8.13.8) with ESMTP id p1HKGbJA011709
	for <fio@vger.kernel.org>; Thu, 17 Feb 2011 14:16:37 -0600
Received: (from mikem@localhost)
	by beardog.cce.hp.com (8.13.8/8.13.8/Submit) id p1HKGap4011708
	for fio@vger.kernel.org; Thu, 17 Feb 2011 14:16:36 -0600
Date: Thu, 17 Feb 2011 14:16:36 -0600
From: Mike Miller <mike.miller@hp.com>
Subject: fio Makefile bug
Message-ID: <20110217201636.GA11681@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I ran across this when trying to run make on fio v1.50.

spike:/tmp/fio-1.50 # make
Makefile:25: Extraneous text after `else' directive
Makefile:30: Extraneous text after `else' directive
Makefile:30: *** only one `else' per conditional.  Stop.

OS info:

spike:/tmp/fio-1.50 # cat /etc/issue

Welcome to SUSE Linux Enterprise Server 10 SP4 RC2 (x86_64) - Kernel \r
(\l).

spike:/tmp/fio-1.50 # uname -a
Linux spike 2.6.16.60-0.81.1-smp #1 SMP Tue Feb 8 06:02:54 UTC 2011 x86_64
x86_64 x86_64 GNU/Linux

The offendinding lines:
else ifeq ($(UNAME), SunOS)
  SOURCE += fifo.c lib/strsep.c helpers.c solaris.c engines/posixaio.c \
                engines/solarisaio.c
  LIBS   += -lpthread -ldl -laio -lrt -lnsl -lsocket
  CPPFLAGS += -D__EXTENSIONS__
else ifeq ($(UNAME), FreeBSD)
  SOURCE += helpers.c engines/posixaio.c
  LIBS   += -lpthread -lrt
  CFLAGS += -rdynamic
else ifeq ($(UNAME), NetBSD)
  SOURCE += helpers.c engines/posixaio.c
  LIBS   += -lpthread -lrt
  CFLAGS += -rdynamic
else ifeq ($(UNAME), AIX)
  SOURCE += fifo.c helpers.c lib/getopt_long.c engines/posixaio.c
  LIBS   += -lpthread -ldl -lrt
  CFLAGS += -rdynamic
  CPPFLAGS += -D_LARGE_FILES -D__ppc__
else ifeq ($(UNAME), Darwin)
  SOURCE += helpers.c engines/posixaio.c
  LIBS   += -lpthread -ldl
else ifneq (,$(findstring CYGWIN,$(UNAME)))
  SOURCE += engines/windowsaio.c
  LIBS   += -lpthread -lrt

To workaround it I simply deleted those lines.

-- mikem
