Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38697 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbbKDJLQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Nov 2015 04:11:16 -0500
Received: by wmeg8 with SMTP id g8so35794223wme.1
        for <fio@vger.kernel.org>; Wed, 04 Nov 2015 01:11:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR1001MB11371E8F71C42CBCAD5EEC7FBC2B0@BN3PR1001MB1137.namprd10.prod.outlook.com>
References: <BN3PR1001MB11371E8F71C42CBCAD5EEC7FBC2B0@BN3PR1001MB1137.namprd10.prod.outlook.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 4 Nov 2015 12:10:56 +0300
Message-ID: <CANvN+e=8kT5F1SuaXE_+4Doc90EFXnbECm2ZM63T-jPhPS+kbQ@mail.gmail.com>
Subject: Re: Trying to understand a weird timeout when using fio and multipath IO
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Todd Lawall <tlawall@nexgenstorage.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Nov 4, 2015 at 12:22 AM, Todd Lawall <tlawall@nexgenstorage.com> wrote:
> Hello,
>
> I'm trying to understand a behavior, and I am hoping to further my
> understanding of what Fio is doing.  In the specific case in question,
> I'm seeing a seven minute wait in resuming IO after a failover.  In other
>  variations on this job file, the seven minute wait disappears, and it
>  drops back down to the 40 second wait that I see with usual IO
> loads that are run.
>
> The setup:
> - I have one Windows 2012 R2 host, with two NICs.
> - I have one storage array, with 2 controllers A and B, with 2 10GbE ports
>    for each side, making 4 ports, with failover capability between the two
>    sides.
> - I have iSCSI and MPIO setup so that there is one login from each NIC to
>    each side, so four sessions total for each volume.   The map looks
>    something like this:
>
>            nic1                 nic2
>            /  \                 /  \
>           /    \               /    \
>      side A   side B       side A  side B
>      port 0   port 0       port 1  port 1
>
> - I have the fio job below.  It is basically 256k blocks, 1 iodepth, one
>    worker with 48 drives.
>
> [global]
> do_verify=0
> ioengine=windowsaio
> numjobs=1
> iodepth=1
> offset=0
> direct=1
> thread
>
> [fio-0]
> blocksize=256k
> readwrite=rw
> filename=\\.\PHYSICALDRIVE19
> filename=\\.\PHYSICALDRIVE20
> <snipped out the other 44 drives>
> filename=\\.\PHYSICALDRIVE13
> filename=\\.\PHYSICALDRIVE14
> size=100%
>

If my understanding of how multi-pathing works doesn't fool me, you
problem with the above setup is fairly straightforward. You are
running an asynchronous engine with single I/O queue depth
single-threaded against multiple files, which means running
synchronous I/O against one file at a time (FIO switches files for you
round-robin, unless specifically instructed to do it any other way).

So when a path fails, your job does roughly 11 path failovers
(slightly more, depending on whether a device the current I/O was
running against is on the failed path) one by one, which should take
11x40s = 440 s or roughly 7 minutes.

> If I alter the job in any of the following ways, IO keeps going after the
>  failover period which is about 40 seconds.  To summarize:
>
> Doesn't work:
>  - multiple disks, single job, 1 iodepth
>
> Works:
>  - Single disk, one job, 1 iodepth
>  - multiple disks, one job with all disks, same iodepth as # of disks (e.g.
>    if there's 48 disks, iodepth is set to 48)
>  - multiple disks, one job per disk, 1 iodepth

All above setups differ from the original in that failover for each
drive run in parallel, taking roughly 40 s.

Hope this helps,
Andrey

>
> Would anyone have any idea why that one arrangement causes a
> significant delay before IO is resumed?
>
> Thanks in advance,
> Todd
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
