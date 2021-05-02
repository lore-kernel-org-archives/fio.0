Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhEBNrP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 2 May 2021 09:47:15 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98345C06174A
        for <fio@vger.kernel.org>; Sun,  2 May 2021 06:44:24 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l14so2838130wrx.5
        for <fio@vger.kernel.org>; Sun, 02 May 2021 06:44:24 -0700 (PDT)
Date: Sun, 2 May 2021 16:44:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: FIO ZNS Write Behavior not Matching Read Behavior
Message-ID: <YI6stDwuQsrkEk8C@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
List-Id: fio@vger.kernel.org
To: Jeff.Lien@wdc.com
Cc: fio@vger.kernel.org, Brandon.Paupore@wdc.com, Andy.Hibbard@wdc.com

> I have a question on why the ZNS write behavior does not match
> the read behavior.  In write workloads with an offset that
> results in a starting lba that is not on a zone boundary,
> the offset is rounded up to the next zone starting lba.  This is
> not done for read workloads though.  I'd like to know if there is
> a particular reason why or could I change this behavior to be
> the same for both reads and writes.

The root cause, so to speak, is that fio tries to be nice and
accomodating program and doesn't reject offsets unaligned to zone boundaries.
Unlike floating point where there is natural "round to nearest" rounding mode
zoned I/O does not have that property.

There are three ways
a) reject unaligned offset=
b) accept unaligned offset= but reject first I/O if write pointer is
   different

   this allows the following workload to work, at least conceptually

   	zonemode=zbd

	[a]
	rw=write
	io_size=4096

	[b]
	rw=write
	offset=4096
	io_size=4096

c) round down(!)
   this is natural given that zoned writes are "rounded down" to the WP

fio does none of the above.

> This causes a problem for one of our particular testcases that writes
> a particular pattern at an offset that ends up being rounded up
> to the next zone starting lba.  In the 2nd step of this testcase, a read
> with verify workload is done to verify the write workload.  This fails
> with a miscompare because the read workload is not starting at the same
> offset as the write workload.  Both fio workloads have "offset = 1%".

I think the best you could do it to fill the zone up the LBA and then
creates separate job which writes pattern and immediately verifies it.

	[a]
	rw=write
	io_size=4096
	offset=2z
	size=1z

	[b]
	stonewall
	rw=write
	io_size=4096
	offset=2z
	size=1z
	verify=xxhash
	do_verify=1

Note! Mainline fio supports 'z' suffix, which is much better
than percentages!

