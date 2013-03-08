Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:29327 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759867Ab3CHS3u (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 8 Mar 2013 13:29:50 -0500
Received: from localhost.admin.grnet.gr (conf-205.admin.grnet.gr [195.251.28.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id 8491918051
	for <fio@vger.kernel.org>; Fri,  8 Mar 2013 20:29:48 +0200 (EET)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH 0/2] Proposed LFSR implementation
Date: Fri,  8 Mar 2013 20:30:01 +0200
Message-Id: <1362767403-2001-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens and list,

Due to the open-source nature of fio, I figured I'd share with you
something I've created while working on Archipelago[1], a storage
backend for synnefo[2] VMs.

We wanted to have an entity that can do random permutations fast, so
we've created an XNOR Galois LFSR (more details about the implementation
in the following patches) that should perform "better" than the generic
one for I/O related tasks.

By "better", I don't mean only in terms of speed - since by definition
LFSRs are insanely fast - but also in terms of their properties as
PRNGs. The main issue with LFSRs that can't make them a serious
candidate for I/O tasks is that due to their shifting nature, they
cannot produce a sequence of numbers that differs widely from one to the
next. This implementation should tackle this problem and should make
LFSRs promising candidates at least for randrepeat jobs.

I actually went one step further and tested this implementation against
the TESTU01 suite. A generic LFSR fails all the tests as expected, but
this LFSR passes 3 to 5 out the 10 entry level tests of the suite. This
shows that they are far from suitable as stand-alone PRNGs for
cryptography, but should be pretty decent for I/O tasks.

Anyways, hopefully you will find this patch set interesting for
inclusion in your code. If you have any questions, feel free to ask.

Thanks,
Alex

[1] http://synnefo-software.blogspot.gr/2013/02/we-are-happy-to-announce-that-synnefo_11.html
[2] http://www.synnefo.org/
[3] http://www.iro.umontreal.ca/~simardr/testu01/tu01.html



Alex Pyrgiotis (2):
  Improve LFSR implementation
  Add a simple test for LFSR generator

 Makefile      |   9 ++
 filesetup.c   |   2 +-
 lib/lfsr.c    | 421 ++++++++++++++++++++++++++--------------------------------
 lib/lfsr.h    |  12 +-
 t/axmap.c     |   2 +-
 t/lfsr-test.c | 127 ++++++++++++++++++
 6 files changed, 334 insertions(+), 239 deletions(-)
 create mode 100644 t/lfsr-test.c

-- 
1.8.1.4

