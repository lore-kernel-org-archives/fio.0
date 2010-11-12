Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:60553 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301Ab0KLNwj (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Nov 2010 08:52:39 -0500
Date: Fri, 12 Nov 2010 14:43:59 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101112134359.GR28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <20101111162222.GO28050@sebastiankayser.de> <AANLkTi=hTTmURQ8q9SJgDrPGx80F+Gjn6E1EBdLkoVwz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTi=hTTmURQ8q9SJgDrPGx80F+Gjn6E1EBdLkoVwz@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

* Shawn Lewis <shawnlewis@google.com> wrote:
> On Thu, Nov 11, 2010 at 8:22 AM, Sebastian Kayser <sebastian@skayser.de> wrote:
> > Shawn Lewis sent me an email off-list and suggested that the disk itself
> > will still do write-caching (despite O_SYNC) unless this has been
> > explicitly disabled. I dug into the storage configuration and found an
> > option which sounded promising ("Drive Delayed Write", not to be confused
> > with the RAID controller write cache which was disabled from the start).
> > Disabled the delayed writes and the IOPS went down from ~240 to
> >
> > * ~100 for a filesystem test (size=100g out of 2TB)
> > * ~110 for a raw device test
> 
> Did any of your tests use the full device or were you still setting
> the size= parameter? Set size=2T or get rid of the size= parameter
> entirely for the raw device test and you should see more like 70 or 80
> iops.

Shibby. :) Raw device tests without size= deliver an average of 71 IOPS,
thus the disk actually delivers less than what the theoretical datasheet
calculation [1] suggests. Or the non-available specs for our desktop range
harddisk are simply a bit inferior.

root@ubuntu-804-x64:~# ./fio --section=iscsi-raw patterns.fio
iscsi-raw: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [w] [100.0% done] [0K/311K /s] [0/76 iops] [eta 00m:00s]
iscsi-raw: (groupid=0, jobs=1): err= 0: pid=5309
  write: io=515496KB, bw=293258B/s, iops=71, runt=1800008msec
...

> I believe part of the reason the gain is so huge with the drive cache
> is that you were also only using the outer diameter of the disk. If
> you use the full disk but enable drive cache I think you'll see about
> 140 or 150iops.

That's gold! Enabled the disk write cache again, tested without size=
and got 160-170 IOPS. Less caching effect than with size=100g.

So the moral of the story is "IOPS tests which don't utilize the full
device won't show its worst case IOPS performance and are pretty much
misleading (unless the application which will later be put onto the
device also only uses a similar subset of the device)"?!

I wonder how many times I saw someone - including myself - fire up
bonnie++ or iozone with a rather small test file compared to the full
disk size ... Thanks very much everyone! This was an (overdue) eye
opener.

Sebastian

[1] http://www.spinics.net/lists/fio/msg00558.html
