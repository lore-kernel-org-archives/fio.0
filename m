Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49232 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbAJJUa convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 10 Jan 2015 04:20:30 -0500
Received: by mail-lb0-f169.google.com with SMTP id p9so11556077lbv.0
        for <fio@vger.kernel.org>; Sat, 10 Jan 2015 01:20:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D0D59CE2.FF94%andrey.o.kudryavtsev@intel.com>
References: <D0D596A1.FF42%andrey.o.kudryavtsev@intel.com> <94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
 <D0D59CE2.FF94%andrey.o.kudryavtsev@intel.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sat, 10 Jan 2015 12:20:07 +0300
Message-ID: <CANvN+e=i1bs71VjQL+mw-5ud0b2+H=vMG1Cwr0KWudVfHma=QQ@mail.gmail.com>
Subject: Re: REPORT: FIO random read performance degradation without
 "norandommap" option
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, Jan 10, 2015 at 2:01 AM, Kudryavtsev, Andrey O
<andrey.o.kudryavtsev@intel.com> wrote:
> Robert, thanks for the reply.
> Thatąs exactly confirms my findings. Any idea if LBA map is generated for
> every job in case of multiple numjobs?
>
> The fact of the performance recovery after degradation was completely
> confusing too. Iąm glad the solution was so easy.

My guess is the problem is not not with the option itself, but with
the way you're trying to use it. randommap tracks written blocks to
avoid rewrite, in particular when one wants to verify data integrity
after the run. In read/write workloads, the option might be utilized
to avoid reading unallocated space on a thin-provisioned volume. In
read-only workloads, there is no point in using random map.

Regarding random map RAM footprint, it's quite modest (around 1.01
bits per minimum block size of the workload, 4K in your case), so one
should only see the memory pressure with capacities in the tenths of
TB range.

Regards,
Andrey

>
> Jens, are there any chance to add the note into the documentation?
>
> --
> Andrey Kudryavtsev,
>
> SSD Solution Architect
> Intel Corp.
>
>
>
> On 1/9/15, 2:49 PM, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
> wrote:
>
>>
>>> -----Original Message-----
>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>>> Behalf Of Kudryavtsev, Andrey O
>>> Sent: Friday, 09 January, 2015 4:42 PM
>>> To: fio@vger.kernel.org
>>> Subject: REPORT: FIO random read performance degradation without
>>> "norandommap" option
>>>
>>> Colleagues,
>>> I executed 2-hour runs of 4KRR to understand performance changes across
>>> the time on the specific very fast NVMe SSD with 1.6TB capacity.
>>> I noticed the side effect of łnorandommap˛ parameter performing full
>>>span
>>> test on the block device.
>>> Here is the example of the result with random map (I.e. without
>>> "norandommap" option) within 120 minutes windows.
>>> [cid:E6872B64-35D1-4447-A0CF-32E6411D9BDB]
>>> (IOPS in blue)
>>>
>>> As soon as I enabled łnorandommap˛ option the curve has changed into the
>>> straight line as expected.
>>
>>It takes resources to maintain the random map table.  I always run with
>>norandommap unless using verify, which has to remember which ones have
>>been accessed.
>>
>>Here's a description I gave someone a while back:
>>With a huge device (e.g., 5.8 TB from RAID-0 made from 16 SSDs),
>>if you do not use "norandommap", fio allocates a bitmap for all
>>the disk blocks to keep track of where it has read or written.
>>It uses this to avoid accessing the same blocks until all
>>the blocks have been accessed, and to know which blocks it
>>needs to verify if verify=<something> is enabled.
>>
>>For 5.8 TB, that is 1562714136 = 1.5 GB.  Not many of those
>>huge allocations work, so it
>>* hangs the system for a while
>>* generates estimates like
>>        [eta 1158050440d:06h:50m:22s]
>>* and eventually reports
>>        smalloc: failed adding pool
>>        fio: failed allocating random map. If running a large number of
>>jobs, try the 'norandommap' option or set 'softrandommap'. Or give a
>>larger --alloc-size to fio.
>>
>>fio continues to run after that; I think it verifies only
>>the devices for which the allocation worked and ignores
>>the rest.
>>
>>
>>---
>>Rob Elliott    HP Server Storage
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
