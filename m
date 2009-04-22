Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52683 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZDVICO (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2009 04:02:14 -0400
Date: Wed, 22 Apr 2009 10:02:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: fio 1.26 tagged
Message-ID: <20090422080213.GY4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I tagged a new release today, since there were a few unfortunate issues
with 1.25. The major issue was the throughput reporting being off by
1024/1000, which was very unfortunate. It would present higher
throughputs than was really generated. Terse outputs were not affected,
but the normal outputs were. From that output, the bw= reported for the
specific job was off, as well as the aggrb=, minb=, maxb= in the group
status report. All other numbers were correct.

Another important fix is the one from Carl Henrik Lunde, where an
off-by-one would cause fio to crash with multiple files. Likewise the
fix from Radha Ramachandran fixes cases where we generated offsets that
were too large, causing either early exit of fio or IO verification
failures (if run with verify enabled).

On the feature side, the bssplit= option now accepts different weights
for reads and writes. The format is identical to previously, but you can
now separate the read and write side with a ",". As an example, this:

bssplit=4k/90:8k/10,4k/20:8k/80

would generate 90% 4k reads and 10% 8k reads on the read side, while
generating 20% 4k and 80% 8k writes on the write side.

I also added a simple job file to get some quick performance numbers of
out SSD drives. It's basically just a test of sequential read and write
and random read and write with 4k block sizes, to enable a quick check
of whether the drive is crap or not. The 4k rand write test is the most
interesting one, the others are mainly just sanity checks.

Grab the new release from:

http://brick.kernel.dk/snaps/fio-1.26.tar.bz2

or with git from:

git://git.kernel.dk/fio.git

or just git pull from your repo, if you are already using git.

-- 
Jens Axboe

