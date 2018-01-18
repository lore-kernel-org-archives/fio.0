Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t2353.austin.hpe.com ([15.233.44.26]:34036 "EHLO
        g2t2353.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbeARXxv (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Jan 2018 18:53:51 -0500
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2353.austin.hpe.com (Postfix) with ESMTP id 8DDE089
        for <fio@vger.kernel.org>; Thu, 18 Jan 2018 23:53:50 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [RFC PATCH 0/3] memtests for ioengines using mmap
Date: Thu, 18 Jan 2018 17:53:44 -0600
Message-Id: <20180118235347.30370-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Add memtest workloads for an ioengine using mmap to run within
the memory mapped region (not to/from another transfer buffer in
regular memory).  Useful for persistent memory testing.

Tests include:
  memcpy = copy with libc memcpy() (d = s)(one read, one write)
  memscan = read memory to registers (one read)
  memset = write memory from registers with libc memset() (one write)
  wmemset = write memory from registers with libc wmemset() (one write)
  streamcopy = STREAM copy (d = s)(one read, one write)
  streamadd = STREAM add (d = s1 + s2)(two reads, add, one write)
  streamscale = STREAM scale (d = 3 * s1)(one read, multiply, one write)
  streamtriad = STREAM triad (d = s1 + 3 * s2)(two reads, add and
                multiply, one write)

Open issues:
* make memscan architecture-independent (or make the test unavailable
  in non-x86). The initial generic memcsum attempt still results in the
  compiler generating memory writes.
* ensure fio is not allocating/filling unused xfer_buf
* ensure Read and Write statistics make sense for each memtest (e.g.
  streamadd should count 2x reads and 1x writes)
* make use_glibc_nt functional (needs to be earlier, may not even
  be possible)
* combine map_populate, glibc_nt, etc. to avoid creating too many
  top-level fio options
* add to dev-dax and libpmem ioengines

Robert Elliott (3):
  memcpytest: Add more sizes
  memcpytest: add more memcpy tests
  ioengines: add memtest workloads for ioengines using mmap

 HOWTO             |  37 +++++
 debug.h           |   1 +
 engines/dev-dax.c |  12 +-
 engines/libpmem.c |  18 +--
 engines/mmap.c    | 142 +++++++++++++++++--
 fio.1             |  37 +++++
 init.c            |   4 +
 io_ddir.h         |  27 +++-
 io_u.c            |   3 +-
 io_u.h            |   9 +-
 lib/memcpy.c      | 411 ++++++++++++++++++++++++++++++++++++++++++++++++------
 lib/memcpy.h      |   4 +
 options.c         |  91 ++++++++++++
 thread_options.h  |   7 +
 14 files changed, 733 insertions(+), 70 deletions(-)

-- 
2.14.3

