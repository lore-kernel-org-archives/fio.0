Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:50512 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbaD3JZ7 (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 30 Apr 2014 05:25:59 -0400
From: Daniel Gollub <d.gollub@telekom.de>
Subject: fio headers as build dependency for external-ioengines
Date: Wed, 30 Apr 2014 11:25:03 +0200
Message-Id: <1398849904-6013-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

Hi,

I am working right now in preparing for the Ceph project an external
fio ioengine, which depends on Ceph-internal libraries. So I thought
about building this ioengine as an external ioengine. (Thats why I
send couple of weeks/month ago this C++-compiler-issues-fixes for
fio.h)

Since fio is not (yet) distributed with a -dev/-devel package in
linux distribution and was very likely not yet consider doing so
I wanted to start the discussion here if this in interested of the
project "exporting"/"installing" the required fio headers to build
external ioengines. So fio can be later a "packaged" build-dependency.

For time-being I thought about solving this like this:

One can introduce in the external project's build-env a parameter
like: --with-fio=~/projects/fio/ and the resulting build-env will
pass this path as include directory as compiler flags for the
external ioengine build.

Unfortunately there are some issues with double-declaration and
one ambiguous header file name (e.g. time.h - see provided patch)

Double-declaration issues of defines/macros/... I hit while building
the Ceph filestore external ioengine:

 * ARRAY_SIZE
 * CONFIG_CPU_COUNT
 * le16_to_cpu
 * le32_to_cpu
 * le64_to_cpu


If you want to reproduce the described issue with ceph,
checkout following revision:
https://github.com/gollub/ceph/commit/079c08c67f811c0173e70201dc91168b60d2e86b
( Working branch: https://github.com/gollub/ceph/tree/fio_filestore_v2 )

And run:
./configure --with-fio-dir=/path/to/fio/
cd src
make libfio_ceph_filestore.la


This could be solved/workaround on the external ioengine side, as well
as in the fio header. One possibility on the fio side could be to relax
fio.h header a bit, so only mandatory declarations and further
includes are part of it to successfully build an external-ioengine.
I am happy to help on this if fio decides to go this route.

Thoughts?

Best Regards
Daniel




Daniel Gollub (1):
  Rename time.h for third-party include of fio.h

 fio.h      |    2 +-
 fio_time.h |   19 +++++++++++++++++++
 mutex.c    |    2 +-
 time.h     |   19 -------------------
 4 files changed, 21 insertions(+), 21 deletions(-)
 create mode 100644 fio_time.h
 delete mode 100644 time.h

-- 
1.7.10.4

