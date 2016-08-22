Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35195 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbcHVVRo (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Aug 2016 17:17:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1bbwbF-0002Qw-Me
        for fio@vger.kernel.org; Mon, 22 Aug 2016 23:17:41 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: multiple entries for each second for bw/iop/xlat log files
Date: Mon, 22 Aug 2016 16:17:35 -0500
Message-ID: <npfq5d$74n$1@blaine.gmane.org>
References: <npf9p3$6e3$1@blaine.gmane.org> <caf6faa7-9584-724c-2c5b-a6fb1a2af441@kernel.dk> <npfodt$uqa$1@blaine.gmane.org> <CAJ9yE1AnR2s_c8iheFdMsOCk9D5wD+AqPR5CuyXsTJtZtQribw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Why are there duplicate entries for a time interval in the log file and 
the iop log file shows '1' iop througout
the entire file.  This doesn't seem right since fio reports up to 100K 
iops in the summary:

write: (groupid=0, jobs=1): err= 0: pid=12012: Mon Aug 22 20:25:25 2016
  write: io=11245MB, bw=95956KB/s, iops=23988, runt=120001msec
    slat (usec): min=7, max=31939, avg=38.82, stdev=41.96
    clat (usec): min=0, max=18067, avg= 0.65, stdev=10.68
     lat (usec): min=7, max=31950, avg=39.86, stdev=43.63
--
read: (groupid=1, jobs=1): err= 0: pid=12824: Mon Aug 22 20:25:25 2016
  read : io=221419MB, bw=472360KB/s, iops=118090, runt=480001msec
    slat (usec): min=3, max=5438, avg= 7.22, stdev= 4.77
    clat (usec): min=0, max=1287, avg= 0.27, stdev= 0.73
     lat (usec): min=3, max=5441, avg= 7.64, stdev= 5.35
On 2016-08-22 20:58:54 +0000, Karl Cronburg said:

> The format of the log is:
> 
> time, #iops, r/w direction, size
> 
> So the '1' you're seeing is saying "one read IOP of size 4096 bytes
> completed at 479.999 seconds". This happened 7 times, followed by
> another completion at 480.000 seconds (in your log excerpt).
> 
> -Karl Cronburg-
> 
> On Mon, Aug 22, 2016 at 4:47 PM, Saeed 
> <ionictea@gmail.com> wrote:
>> I'm still getting the same problem where there seems to be duplicate time
>> interval entries and no data for the iops log using the latest git:
>> 
>> 479999, 1, 0, 4096
>> 479999, 1, 0, 4096
>> 479999, 1, 0, 4096
>> 479999, 1, 0, 4096
>> 479999, 1, 0, 4096
>> 479999, 1, 0, 4096
>> 479999, 1, 0, 4096
>> 480000, 1, 0, 4096
>> 
>> I do see the following errors during the configure process but not sure if
>> its related:
>> 
>> /tmp/fio-conf--8430-.c:2:2: error: #error __ANDROID__ not defined
>> #error __ANDROID__ not defined
>> /tmp/fio-conf--8430-.c:2:2: error: #error __i386__ not defined
>> #error __i386__ not defined
>> /tmp/fio-conf--8430-.c:5:3: error: size of unnamed array is negative
>> collect2: error: ld returned 1 exit status
>> /tmp/fio-conf--8430-.c:2:24: fatal error: sys/asynch.h: No such file or
>> directory
>> /tmp/fio-conf--8430-.c:2:29: fatal error: infiniband/arch.h: No such file or
>> directory
>> /tmp/fio-conf--8430-.c:2:27: fatal error: rdma/rdma_cma.h: No such file or
>> directory
>> 
>> /tmp/fio-conf--8430-.c:5:24: error: 'CLOCK_MONOTONIC_PRECISE' undeclared
>> (first use in this function)
>> /tmp/fio-conf--8430-.c:5:22: error: storage size of 'me' isn't known
>> /tmp/fio-conf--8430-.c:6:19: error: 'EXT4_IOC_MOVE_EXT' undeclared (first
>> use in this function)
>> /tmp/fio-conf--8430-.c:1:19: fatal error: guasi.h: No such file or directory
>> /tmp/fio-conf--8430-.c:1:32: fatal error: nvm/nvm_primitives.h: No such file
>> or directory
>> /tmp/fio-conf--8430-.c:1:18: fatal error: numa.h: No such file or directory
>> collect2: error: ld returned 1 exit status
>> collect2: error: ld returned 1 exit status
>> /tmp/fio-conf--8430-.c:1:24: fatal error: rbd/librbd.h: No such file or
>> directory
>> /tmp/fio-conf--8430-.c:1:24: fatal error: rbd/librbd.h: No such file or
>> directory
>> /tmp/fio-conf--8430-.c:1:32: fatal error: glusterfs/api/glfs.h: No such file
>> or directory
>> /tmp/fio-conf--8430-.c:7: Error: unknown pseudo-op: `.machine'
>> /tmp/fio-conf--8430-.c:8: Error: unknown pseudo-op: `.machine'
>> /tmp/fio-conf--8430-.c:9: Error: no such instruction: `stfle %rcx'
>> /tmp/fio-conf--8430-.c:10: Error: unknown pseudo-op: `.machine'
>> /tmp/fio-conf--8430-.c:6:17: error: storage size of 'st' isn't known
>> /tmp/fio-conf--8430-.c:7:26: error: 'MNT_NOWAIT' undeclared (first use in
>> this function)
>> 
>> On 2016-08-22 17:33:13 +0000, Jens Axboe said:
>> 
>>> On 08/22/2016 10:37 AM, Saeed wrote:
>>>> 
>>>> Why are there multiple entries for each interval / second in the fio log
>>>> generated?
>>>> 
>>>> 1, 585142, 1, 4096
>>>> 1, 4096000, 1, 4096
>>>> 1, 4096000, 1, 4096
>>>> 1, 0, 1, 4096
>>>> 1, 0, 1, 4096
>>>> 1, 4096000, 1, 4096
>>>> 1, 0, 1, 4096
>>>> 1, 0, 1, 4096
>>>> 1, 4096000, 1, 4096
>>>> 1, 0, 1, 4096
>>>> 2, 4096000, 1, 4096
>>>> 2, 4096000, 1, 4096
>>>> 2, 4096000, 1, 4096
>>>> 2, 0, 1, 4096
>>>> 2, 4096000, 1, 4096
>>>> 2, 4096000, 1, 4096
>>>> 2, 4096000, 1, 4096
>>>> 2, 0, 1, 4096
>>>> 2, 0, 1, 4096
>>>> 2, 0, 1, 4096
>>> 
>>> 
>>> Ditto for this one, try current -git.
>> 
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



