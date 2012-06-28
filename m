Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40600 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2F1IP5 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 28 Jun 2012 04:15:57 -0400
Received: by yenl2 with SMTP id l2so1616950yen.19
        for <fio@vger.kernel.org>; Thu, 28 Jun 2012 01:15:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206271902.55287.Martin@lichtvoll.de>
References: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com>
	<201206271902.55287.Martin@lichtvoll.de>
Date: Thu, 28 Jun 2012 16:15:56 +0800
Message-ID: <CAG1+85EfnBsny09pyr9PFjVs162zDjBAau08e1OwLVTeP6jmDg@mail.gmail.com>
Subject: Re: Single HDD , 700MB/s ??
From: Homer Li <01jay.ly@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

Hi ,Martin,

     When I enabled the Raid controller cache, there is not much
different in the libaio and sync.

     When I disabled the Raid controller cache, the HDD speed is not crazy.

     And then, I disabled raid controller cache and HDD cache.
     1 write thread in sync engine is the slowest.

     By the way, you said ,it could be some compression being active,
     Is it possible some compress in raid controller cache ? because
when I disabled raid controller cache and  enabled HDD cache.  8 write
threads is near close 1 write thread.

    Thanks for your help.  ^_^

Detail :

Disabled raid controller and HDD cache:

8 jobs libaio
Run status group 0 (all jobs):
  WRITE: io=10084MB, aggrb=85652KB/s, minb=9935KB/s, maxb=11208KB/s,
mint=120424msec, maxt=120554msec

1 job libaio
Run status group 0 (all jobs):
 WRITE: io=13443MB, aggrb=114403KB/s, minb=114403KB/s,
maxb=114403KB/s, mint=120326msec, maxt=120326msec

8 jobs sync
Run status group 0 (all jobs):
  WRITE: io=4811.2MB, aggrb=52954KB/s, minb=6227KB/s, maxb=7043KB/s,
mint=92948msec, maxt=93035msec

1job sync
Run status group 0 (all jobs):
  WRITE: io=4236.0MB, aggrb=36143KB/s, minb=36143KB/s, maxb=36143KB/s,
mint=120013msec, maxt=120013msec

enable disk cache:
1 job sync:
Run status group 0 (all jobs):
  WRITE: io=5602.3MB, aggrb=114722KB/s, minb=114722KB/s,
maxb=114722KB/s, mint=50005msec, maxt=50005msec

8 jobs sync:
Run status group 0 (all jobs):
  WRITE: io=3998.3MB, aggrb=81843KB/s, minb=10039KB/s, maxb=10590KB/s,
mint=50010msec, maxt=50025msec

1 jobs libaio:
Run status group 0 (all jobs):
  WRITE: io=5633.8MB, aggrb=114586KB/s, minb=114586KB/s,
maxb=114586KB/s, mint=50346msec, maxt=50346msec

8 jobs libaio:
Run status group 0 (all jobs):
  WRITE: io=4583.7MB, aggrb=92884KB/s, minb=11405KB/s, maxb=12263KB/s,
mint=50470msec, maxt=50532mse


sdb raid config:
Adapter 0 -- Virtual Drive Information:
Virtual Drive: 0 (Target Id: 0)
Name                :
RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
Size                : 1.818 TB
State               : Optimal
Stripe Size         : 64 KB
Number Of Drives    : 1
Span Depth          : 1
Default Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write
Cache if Bad BBU
Current Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write
Cache if Bad BBU
Access Policy       : Read/Write
Disk Cache Policy   : Disabled
Encryption Type     : None



2012/6/28 Martin Steigerwald <Martin@lichtvoll.de>:
> Am Mittwoch, 27. Juni 2012 schrieb Homer Li:
>> Hello ,All;
>>
>>         When I used fio benchmark single HDD,  the write speed could
>> reached 700~800MB/s
>>         The HDD model is WD2002FYPS-18U1B0 , 7200rpm, 2TB
>>         In my raid config, there is only one HDD  in every Raid0
>> group. like jbod.
>>
>>         And then, I modify numjobs=8 to numjobs=1. the benchmark
>> result is ok , it 's about 100MB/s.
>
> Which is still quite fast. However that difference is puzzling.
>
>> Raid controller: PERC 6/E (LSI SAS1068E)
>> OS : CentOS 5.5 upgrade to 2.6.18-308.8.2.el5 x86_64
>>
>> # fio -v
>> fio 2.0.7
>>
>>
>> # cat /tmp/fio2.cfg
>> [global]
>> rw=write
>> ioengine=sync
>> size=100g
>> numjobs=8
>> bssplit=128k/20:256k/20:512k/20:1024k/40
>> nrfiles=2
>> iodepth=128
>> lockmem=1g
>> zero_buffers
>> timeout=120
>> direct=1
>> thread
>>
>> [sdb]
>> filename=/dev/sdb
>
> I wonder whether this could be ioengine related, although I do not read
> any limitations for sync engine regarding direct I/O out of the HOWTO:
>
> direct=bool     If value is true, use non-buffered io. This is usually
>                O_DIRECT. Note that ZFS on Solaris doesn't support direct
> io.
>                On Windows the synchronous ioengines don't support direct
> io.
>
> Please try with ioengine=libaio nonetheless.
>
>> run
>> #fio /tmp/fio2.cfg
>>
>>
>> Run status group 0 (all jobs):
>>   WRITE: io=68235MB, aggrb=582254KB/s, minb=72636KB/s, maxb=73052KB/s,
>> mint=120001msec, maxt=120003msec
>
> […]
>
>> Here is my Raid controller config:
>>
>> this is sdb:
> […]
>> Default Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
>> if Bad BBU
>> Current Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
>> if Bad BBU
>
> Or your RAID controller is caching the writes. I am not sure about the
> direct option tough. Last time I had to do with a hardware RAID controller
> has been quite some time ago.
>
> Sounds more likely to me, but should affect numjobs=1 as well. Please
> try disabling the RAID controller caching or connect the disk you want
> to test to a controller without caching.
>
> Third thing could be some compression being active, but that seems
> unlikely,
> cause it should affect the numjobs=1 workload as well. I never heard of
> any
> compressing harddisk firmware, but newer Sandforce SSDs are doing it.
>
> Still the RAID controller caching could play tricks with the zeros you
> send to it with "zero_buffers". I would try without to make sure.
>
> And then there could be a bug in fio.
>
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7



--
Let one live alone doing no evil, care-free, like an elephant in the
elephant forest
