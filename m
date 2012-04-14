Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2DNPXU (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 14 Apr 2012 11:23:20 -0400
Message-ID: <4F899663.8050406@kernel.dk>
Date: Sat, 14 Apr 2012 17:23:15 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running fio with offset Increment option
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
In-Reply-To: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-14 01:48, Suresh Dhanarajan wrote:
> Hi,
> 
> I wanted to use the "offset increment option" and  "numjobs" so that i
> can split the work load between ten jobs and reduce the run time.
> But what i am seeing is that the offset counter is not getting reset
> when the first job in the jobfile is completed.(is it that the offset
> is global for the job file and not for the Jobs inside the jobfile?)
> So  my read starts from the last offset set by the writes.
> 
> here is my job file,
> 
> [global]
> bs=64k
> direct=1
> numjobs=10
> size=1m
> group_reporting
> 
> [write-phase]
> offset_increment=1m
> filename=/dev/sdb
> rw=write
> write_iolog=verfywrite2
> 
> [read-phase]
> stonewall
> offset_increment=1m
> filename=/dev/sdb
> rw=read
> write_iolog=verfyread2
> 
> I tried using the offset=0 option in the read phase job but now every
> time the read happens from zeroth offsite.
> Now the offset increment option is not getting honored.
> 
> [write-phase]
> offset_increment=1m
> filename=/dev/sdb
> rw=write
> write_iolog=verfywrite2
> 
> [read-phase]
> stonewall
> offset=0
> offset_increment=1m
> filename=/dev/sdb
> rw=read
> write_iolog=verfyread2
> 
> I tried the same case with verify option.
> the behavior is same.
> 
> Is there any way that i can reset the offset counters once the job is completed?

Right now there isn't, but it does make sense to reset the counter
across stonewalls. At the moment, it'll just increment for each job.
Internally, fio sets up all the jobs, even across stonewalls, when it
starts up. It just starts some of them later on, depending on those
parameters. It does seem most useful to have it reset across a hard
barrier though, I can definitely change it to do that.

Let me brew up a patch later today that you can test.

-- 
Jens Axboe

