Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54775 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfIOGnX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 15 Sep 2019 02:43:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so6645802wmp.4
        for <fio@vger.kernel.org>; Sat, 14 Sep 2019 23:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-fpuOi6u8w8-L5G+sZ7KhvPy9SC3hqXh+q6PReVTxbCA@mail.gmail.com>
In-Reply-To: <CABO+gV-fpuOi6u8w8-L5G+sZ7KhvPy9SC3hqXh+q6PReVTxbCA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 15 Sep 2019 07:42:59 +0100
Message-ID: <CALjAwxi3L-N1-fW5PNJbMU0SjY6G2eRXrL4=5Z7egL3w=apPcQ@mail.gmail.com>
Subject: Re: Disk slows down while empting write buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Sat, 14 Sep 2019 at 22:18, Elliott Balsley <elliott@altsystems.com> wrote:
>
> I am trying to figure out why end_fsync causes the overall disk write
> to take longer.  I'm aware that without this option, the test may
> return before all data is flushed to disk, but I am monitoring actual
> disk writes with iostat.  At the beginning of the test, iostat shows
> 165MBps writing to each disk, and fio shows over 3000MBps (because
> it's writing to the buffer, and the buffer is simultaneously going to
> disk).
> Near the end, fio drops to 0MBps which means it's waiting for fsync to
> finish.  At this time, iostat drops to 120MBps per disk.
>
> fio --name=w --rw=write --bs=1M --size=30G --directory=/mnt/stripe --end_fsync=1
>
> If I instead run this command with end_fsync=0 then iostat shows
> steady 165MBps the whole time.
>
> I have observed this issue on CentOS with an mdadm soft RAID with XFS.
> And also on FreeBSD with a ZFS pool.  If I instead run it on a single
> disk formatted XFS then it does not use the cache at all, it just
> writes steady at 165MBps, I'm not sure why that is.

Hmm, I doubt this is an fio specific question and likely applies to
I/O through filesystems in general.

When you're working with RAID-like devices you have to get
acknowledgement from ALL disks in the RAID to know data has reached
non-volatile storage (due to striping). As fsync also ensures metadata
makes it down to the non-volatile storage too (in additional to
regular data), it could be that you end up waiting on metadata to be
flushed in-between sending data (this is a wild guess) thus resulting
in a slower speed (the fsync might be being done as a drain and
flush). Another wild idea is that it could be that the filesystem now
prioritises getting smaller chunks of data to disk as soon as possible
over throughput. You would likely have to talk to a filesystem
developer (e.g. via
http://vger.kernel.org/vger-lists.html#linux-fsdevel ) or otherwise
trace what was happening at the filesystem level to know anything for
sure though... If you do find out a definitive answer please let us
know :-)

You can (somewhat) rule out a given layer by doing writes straight to
a block device (THIS WILL DESTROY ANY FILESYSTEM AND DATA ON THE
DEVICE) and seeing if you get the same behavior. Another idea is to
see if things change when you use fdatasync
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-fdatasync
) with a number very close to the total number of I/Os (30720) you are
doing to see if its metadata related on Linux (I don't think FreeBSD
supports that operation and fio just fallsback to doing fsync).

> disk formatted XFS then it does not use the cache at all, it just

I'd be surprised if it bypassed the cache entirely and you would
likely have to watch what was happening in /proc/meminfo while your
test was running to determine this. It's also worth monitoring what
the utilization of your disks (which you will see when you add -x to
the end of iostat) to see if the system thinks there's spare I/O
capacity or whether they are being pushed to their limit.

-- 
Sitsofe | http://sucs.org/~sits/

