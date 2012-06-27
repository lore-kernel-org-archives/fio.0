Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45305 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab2F0RC7 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 27 Jun 2012 13:02:59 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Single HDD , 700MB/s ??
Date: Wed, 27 Jun 2012 19:02:55 +0200
References: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com> (sfid-20120627_091303_981112_4A1EFFCF)
In-Reply-To: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201206271902.55287.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Homer Li <01jay.ly@gmail.com>
Cc: fio@vger.kernel.org

Am Mittwoch, 27. Juni 2012 schrieb Homer Li:
> Hello ,All;
> 
>         When I used fio benchmark single HDD,  the write speed could
> reached 700~800MB/s
>         The HDD model is WD2002FYPS-18U1B0 , 7200rpm, 2TB
>         In my raid config, there is only one HDD  in every Raid0
> group. like jbod.
> 
>         And then, I modify numjobs=8 to numjobs=1. the benchmark
> result is ok , it 's about 100MB/s.

Which is still quite fast. However that difference is puzzling.
 
> Raid controller: PERC 6/E (LSI SAS1068E)
> OS : CentOS 5.5 upgrade to 2.6.18-308.8.2.el5 x86_64
> 
> # fio -v
> fio 2.0.7
> 
> 
> # cat /tmp/fio2.cfg
> [global]
> rw=write
> ioengine=sync
> size=100g
> numjobs=8
> bssplit=128k/20:256k/20:512k/20:1024k/40
> nrfiles=2
> iodepth=128
> lockmem=1g
> zero_buffers
> timeout=120
> direct=1
> thread
> 
> [sdb]
> filename=/dev/sdb

I wonder whether this could be ioengine related, although I do not read
any limitations for sync engine regarding direct I/O out of the HOWTO:

direct=bool     If value is true, use non-buffered io. This is usually
                O_DIRECT. Note that ZFS on Solaris doesn't support direct io.
                On Windows the synchronous ioengines don't support direct io.

Please try with ioengine=libaio nonetheless.

> run
> #fio /tmp/fio2.cfg
> 
> 
> Run status group 0 (all jobs):
>   WRITE: io=68235MB, aggrb=582254KB/s, minb=72636KB/s, maxb=73052KB/s,
> mint=120001msec, maxt=120003msec

[…]

> Here is my Raid controller config:
> 
> this is sdb:
[…]
> Default Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
> if Bad BBU
> Current Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
> if Bad BBU

Or your RAID controller is caching the writes. I am not sure about the
direct option tough. Last time I had to do with a hardware RAID controller
has been quite some time ago.

Sounds more likely to me, but should affect numjobs=1 as well. Please 
try disabling the RAID controller caching or connect the disk you want
to test to a controller without caching.

Third thing could be some compression being active, but that seems unlikely,
cause it should affect the numjobs=1 workload as well. I never heard of any
compressing harddisk firmware, but newer Sandforce SSDs are doing it.

Still the RAID controller caching could play tricks with the zeros you
send to it with "zero_buffers". I would try without to make sure.

And then there could be a bug in fio.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
