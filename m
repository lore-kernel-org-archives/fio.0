Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37115 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F1NSf (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 28 Jun 2012 09:18:35 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Single HDD , 700MB/s ??
Date: Thu, 28 Jun 2012 15:18:33 +0200
References: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com> <201206271902.55287.Martin@lichtvoll.de> <CAG1+85EfnBsny09pyr9PFjVs162zDjBAau08e1OwLVTeP6jmDg@mail.gmail.com> (sfid-20120628_144416_213484_E265D730)
In-Reply-To: <CAG1+85EfnBsny09pyr9PFjVs162zDjBAau08e1OwLVTeP6jmDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206281518.33611.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Homer Li <01jay.ly@gmail.com>
Cc: fio@vger.kernel.org

Am Donnerstag, 28. Juni 2012 schrieb Homer Li:
> Hi ,Martin,

Hi Homer,

I prefer http://learn.to/quote (there is a english text as well).

>      When I enabled the Raid controller cache, there is not much
> different in the libaio and sync.

No wonder.

>      When I disabled the Raid controller cache, the HDD speed is not
> crazy.
> 
>      And then, I disabled raid controller cache and HDD cache.
>      1 write thread in sync engine is the slowest.

I do not know at the moment why sync and libaio are that different. Oh, 
well maybe I do: iodepth. I think sync engine cannot do iodepth!=1. I 
think this should be documented somewhere, so you can verify my saying.

>      By the way, you said ,it could be some compression being active,
>      Is it possible some compress in raid controller cache ? because
> when I disabled raid controller cache and  enabled HDD cache.  8 write
> threads is near close 1 write thread.

Its just some wild guessing. To verify remove zero_buffers and use random 
data. That should at least decrease any possible compression effects.

Maybe the RAID Controller cache is playing other tricks. I do not know. I 
am no expert regarding hardware RAID controllers and their firmwares.

> 
>     Thanks for your help.  ^_^
> 
> Detail :
> 
> Disabled raid controller and HDD cache:
> 
> 8 jobs libaio
> Run status group 0 (all jobs):
>   WRITE: io=10084MB, aggrb=85652KB/s, minb=9935KB/s, maxb=11208KB/s,
> mint=120424msec, maxt=120554msec
> 
> 1 job libaio
> Run status group 0 (all jobs):
>  WRITE: io=13443MB, aggrb=114403KB/s, minb=114403KB/s,
> maxb=114403KB/s, mint=120326msec, maxt=120326msec

Sounds sensible. One job is still quite fast. And 8 jobs should generate 
some seeks.

> 8 jobs sync
> Run status group 0 (all jobs):
>   WRITE: io=4811.2MB, aggrb=52954KB/s, minb=6227KB/s, maxb=7043KB/s,
> mint=92948msec, maxt=93035msec
> 
> 1job sync
> Run status group 0 (all jobs):
>   WRITE: io=4236.0MB, aggrb=36143KB/s, minb=36143KB/s, maxb=36143KB/s,
> mint=120013msec, maxt=120013msec

Look at iodepth statistics. I think it will use higher iodepths, i.e. more 
requests in flight and that gives chance to reorder requests and whatnot. 
Although with disable write cache the harddisk firmware should not be able 
to do it, Linux might give presorted requests. I am a bit unsure about the 
exact behavior here.

> enable disk cache:
> 1 job sync:
> Run status group 0 (all jobs):
>   WRITE: io=5602.3MB, aggrb=114722KB/s, minb=114722KB/s,
> maxb=114722KB/s, mint=50005msec, maxt=50005msec
> 
> 8 jobs sync:
> Run status group 0 (all jobs):
>   WRITE: io=3998.3MB, aggrb=81843KB/s, minb=10039KB/s, maxb=10590KB/s,
> mint=50010msec, maxt=50025msec
> 
> 1 jobs libaio:
> Run status group 0 (all jobs):
>   WRITE: io=5633.8MB, aggrb=114586KB/s, minb=114586KB/s,
> maxb=114586KB/s, mint=50346msec, maxt=50346msec
> 
> 8 jobs libaio:
> Run status group 0 (all jobs):
>   WRITE: io=4583.7MB, aggrb=92884KB/s, minb=11405KB/s, maxb=12263KB/s,
> mint=50470msec, maxt=50532mse

Again verify the iodepth.

Also look in hdparm -I on the disk for the iodepth the disk supports and 
try with twice as much in order to always satisfy the queue to the 
harddisk.

> sdb raid config:
> Adapter 0 -- Virtual Drive Information:
> Virtual Drive: 0 (Target Id: 0)
> Name                :
> RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
> Size                : 1.818 TB
> State               : Optimal
> Stripe Size         : 64 KB
> Number Of Drives    : 1
> Span Depth          : 1
> Default Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write
> Cache if Bad BBU
> Current Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write
> Cache if Bad BBU
> Access Policy       : Read/Write
> Disk Cache Policy   : Disabled
> Encryption Type     : None

Sounds sane if you want to test without caching.

For production workloads and production workload performance measurements 
I recommend to turn write caching on again in case your controller has a 
battery (BBU). In that case disable barriers / cache flushes in the 
filesystem to get further speed boosts.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
