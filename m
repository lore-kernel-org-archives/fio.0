Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52527
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1JNGUD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 14 Oct 2011 02:20:03 -0400
Received: from [192.168.0.33] (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTPA id 9B8355658C
	for <fio@vger.kernel.org>; Fri, 14 Oct 2011 08:20:01 +0200 (CEST)
Message-ID: <4E97D492.8080305@kernel.dk>
Date: Fri, 14 Oct 2011 08:20:02 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Fio 2.0 coming (was "Re: Recent changes")
References: <20111014040002.95902484001@kernel.dk>
In-Reply-To: <20111014040002.95902484001@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

As you may have noticed from the change email this morning, I pulled the
client-server branch into the master branch. The old master branch now
lives in stable-1.x, which is a maintenance branch for 1.60 and on. Only
bug fixes should go into that branch from now on, all new developments
should go into the 'master' (or 2.x) branch. For now the version is
still 1.99.6, I'll release 2.0 once it's seen a few weeks of testing.

Highlights of changes between stable-1.x and master:

- Basic support for client/server. I wrote about this in here before, I
  wont bore you with more details. See the included documentation for
  how to play with that, if you are interested.

- Completion latency percentiles is a great feature of 1.x, but I don't
  think a lot of people have used it. I've prettied up the output and
  turned it on by default.

- Terse output format has been modified, new additions are:

        Fio version
        IOPS
        Completion latency percentiles
        Disk utilization

  I've wanted to add IOPS and disk utilization for a while, now seems a
  good time to introduce a modified format and get all of them done in
  one sweep.

- Support has been added for write_iops_log. It's similar to
  write_bw_log, but writes the IOPS instead. For mixed block size
  workloads, it's not possible to deduct IOPS from the bandwidth.

- Network IO engine has support for local unix domain sockets as well,
  plus the format for configuring it has been modified to appropriately
  support that.

- Build is clang clean, and works fine with it (for some quick testing,
  clang 2.8 used here). There were in fact only 2-3 warnings prior.

Especially the client/server split-up has been an exercise in
refactoring lots of code into network friendly structures, and splitting
previous "show these results" code into "calculate these results" and
"display these results" parts instead.

Please give the current master branch (or the 1.99.x releases) a good
testing, it should work fine. I care more about generic testing just
moving to the 2.x/master branch than specific client/server
functionality testing, since that feature will be stabilized soonish and
regressions are the worst enemy of something like fio. As you perhaps
saw from the 'Recent changes' email, there's been a few changes since
1.60 in the current branch:

  62 files changed, 5162 insertions(+), 1395 deletions(-)

So we do need a few weeks to ensure that everything is fine before I tag
2.0 and release it.

Martin, can I talk you into taking a look at the man page to see whether
it's clean (it's not, I guarantee it)?

And folks running on non-linux, please try and build it at least (extra
brownie points for actually running it, too).

Thanks!

-- 
Jens Axboe

