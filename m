Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:16280 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab0KLSAg convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Nov 2010 13:00:36 -0500
Received: from kpbe13.cbf.corp.google.com (kpbe13.cbf.corp.google.com [172.25.105.77])
	by smtp-out.google.com with ESMTP id oACI0YoL004285
	for <fio@vger.kernel.org>; Fri, 12 Nov 2010 10:00:35 -0800
Received: from iwn36 (iwn36.prod.google.com [10.241.68.100])
	by kpbe13.cbf.corp.google.com with ESMTP id oACHwgxx026825
	for <fio@vger.kernel.org>; Fri, 12 Nov 2010 10:00:33 -0800
Received: by iwn36 with SMTP id 36so3828426iwn.32
        for <fio@vger.kernel.org>; Fri, 12 Nov 2010 10:00:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101112134359.GR28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de>
	<AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
	<20101110082223.GB14261@sebastiankayser.de>
	<20101111162222.GO28050@sebastiankayser.de>
	<AANLkTi=hTTmURQ8q9SJgDrPGx80F+Gjn6E1EBdLkoVwz@mail.gmail.com>
	<20101112134359.GR28050@sebastiankayser.de>
Date: Fri, 12 Nov 2010 10:00:32 -0800
Message-ID: <AANLkTik5=tSj9h-O8O5Bub8J86rRiyYrTx7mmX5asgqC@mail.gmail.com>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
From: Shawn Lewis <shawnlewis@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On Fri, Nov 12, 2010 at 5:43 AM, Sebastian Kayser <sebastian@skayser.de> wr=
ote:
> * Shawn Lewis <shawnlewis@google.com> wrote:
>> On Thu, Nov 11, 2010 at 8:22 AM, Sebastian Kayser <sebastian@skayser.de>=
 wrote:
>> > Shawn Lewis sent me an email off-list and suggested that the disk itse=
lf
>> > will still do write-caching (despite O_SYNC) unless this has been
>> > explicitly disabled. I dug into the storage configuration and found an
>> > option which sounded promising ("Drive Delayed Write", not to be confu=
sed
>> > with the RAID controller write cache which was disabled from the start=
).
>> > Disabled the delayed writes and the IOPS went down from ~240 to
>> >
>> > * ~100 for a filesystem test (size=3D100g out of 2TB)
>> > * ~110 for a raw device test
>>
>> Did any of your tests use the full device or were you still setting
>> the size=3D parameter? Set size=3D2T or get rid of the size=3D parameter
>> entirely for the raw device test and you should see more like 70 or 80
>> iops.
>
> Shibby. :) Raw device tests without size=3D deliver an average of 71 IOPS,
> thus the disk actually delivers less than what the theoretical datasheet
> calculation [1] suggests. Or the non-available specs for our desktop range
> harddisk are simply a bit inferior.
>
> root@ubuntu-804-x64:~# ./fio --section=3Discsi-raw patterns.fio
> iscsi-raw: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, io=
depth=3D1
> Starting 1 process
> Jobs: 1 (f=3D1): [w] [100.0% done] [0K/311K /s] [0/76 iops] [eta 00m:00s]
> iscsi-raw: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5309
> =EF=BF=BDwrite: io=3D515496KB, bw=3D293258B/s, iops=3D71, runt=3D1800008m=
sec
> ...
>
>> I believe part of the reason the gain is so huge with the drive cache
>> is that you were also only using the outer diameter of the disk. If
>> you use the full disk but enable drive cache I think you'll see about
>> 140 or 150iops.
>
> That's gold! Enabled the disk write cache again, tested without size=3D
> and got 160-170 IOPS. Less caching effect than with size=3D100g.
>
> So the moral of the story is "IOPS tests which don't utilize the full
> device won't show its worst case IOPS performance and are pretty much
> misleading (unless the application which will later be put onto the
> device also only uses a similar subset of the device)"?!
>
> I wonder how many times I saw someone - including myself - fire up
> bonnie++ or iozone with a rather small test file compared to the full
> disk size ... Thanks very much everyone! This was an (overdue) eye
> opener.
In addition, testing with a file is dependent on the state of the file
system. For example, if you're using a 100GB file and there's not enough
contiguous free space to lay it out in one chunk you could have regions on
different parts of the disk. Further, even there is enough space, that space
could be near the inner or outer diameter which would also affect
performance.

There is a way to get a file address to lba map (which would give you some
insight into how a file is laid out). I think there's a syscall. Jens should
know.
>
> Sebastian
>
> [1] http://www.spinics.net/lists/fio/msg00558.html
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>
