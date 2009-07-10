Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:46542 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbZGJMjF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Jul 2009 08:39:05 -0400
Date: Fri, 10 Jul 2009 14:39:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: fio-1.31 release
Message-ID: <20090710123904.GX23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

It's been a while since I sent out an announcement for a new fio
release, but better late than never.

I just tagged version 1.31. The last few releases had a bug where the
completion latency numbers just read 0, I just noticed this today. So
that one is fixed. Recently I also improved the mmap engine a lot. It
now works better for 64-bit archs, and it supports large files for
32-bit archs as well. Apparently I have no users on sparc, since I found
and fixed a bug that prevented fio from actually running on sparc.

New in 1.31 is also support for verification offload, when doing verify
jobs. You can setup a number of threads (and bind them to specific CPUs)
with the verify_async and verify_async_cpus options. This is especially
handy for sync engine workloads, as you can then proceed to read in more
data while the verify is running.

Another new recent option is iomem_align. This allows you to specificy a
specific alignment of the IO memory buffers. By default fio doesn't
attempt to align, unless you are doing O_DIRECT IO. For that, it uses
page size alignment. In reality you only need sector size alignment on
disks, and for eg NFS O_DIRECT you don't even need specific alignment.

Fio also supports a pre_read option for reading in files in memory
before starting IO. This was contributed by Intel.

The man page is also lintian clean now, thanks to Debian packagers. Fio
should show up there soon.

And finally a plea to send questions or suggestions to the fio list.
Lots of people write me personally, it would be more helpful for
everyone on the list if those questions and suggestions were posted here
instead.

The next two weeks I'll be off on vacation, so it'll be quiet on the fio
front unless I manage to sneak out of the claws of family vacation every
now and then :-)

-- 
Jens Axboe

