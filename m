Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:53735 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbbAIXHp (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Jan 2015 18:07:45 -0500
Received: by mail-qc0-f181.google.com with SMTP id m20so11523084qcx.12
        for <fio@vger.kernel.org>; Fri, 09 Jan 2015 15:07:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
References: <D0D596A1.FF42%andrey.o.kudryavtsev@intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
Date: Fri, 9 Jan 2015 15:07:44 -0800
Message-ID: <CAM8G_B+rtT7sTK6n2=ZxXLGYH1_yZL=yzAoKNg_HGoa8oiSe=w@mail.gmail.com>
Subject: Re: REPORT: FIO random read performance degradation without
 "norandommap" option
From: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Excellent!! atleast this explains me how to get out of crazy eta's , I
think the hang may be possible due to low RAM with combination of high
iodepth/blocksize/numjobs.

On Fri, Jan 9, 2015 at 2:49 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Kudryavtsev, Andrey O
>> Sent: Friday, 09 January, 2015 4:42 PM
>> To: fio@vger.kernel.org
>> Subject: REPORT: FIO random read performance degradation without
>> "norandommap" option
>>
>> Colleagues,
>> I executed 2-hour runs of 4KRR to understand performance changes across
>> the time on the specific very fast NVMe SSD with 1.6TB capacity.
>> I noticed the side effect of "norandommap" parameter performing full span
>> test on the block device.
>> Here is the example of the result with random map (I.e. without
>> "norandommap" option) within 120 minutes windows.
>> [cid:E6872B64-35D1-4447-A0CF-32E6411D9BDB]
>> (IOPS in blue)
>>
>> As soon as I enabled "norandommap" option the curve has changed into the
>> straight line as expected.
>
> It takes resources to maintain the random map table.  I always run with
> norandommap unless using verify, which has to remember which ones have
> been accessed.
>
> Here's a description I gave someone a while back:
> With a huge device (e.g., 5.8 TB from RAID-0 made from 16 SSDs),
> if you do not use "norandommap", fio allocates a bitmap for all
> the disk blocks to keep track of where it has read or written.
> It uses this to avoid accessing the same blocks until all
> the blocks have been accessed, and to know which blocks it
> needs to verify if verify=<something> is enabled.
>
> For 5.8 TB, that is 1562714136 = 1.5 GB.  Not many of those
> huge allocations work, so it
> * hangs the system for a while
> * generates estimates like
>         [eta 1158050440d:06h:50m:22s]
> * and eventually reports
>         smalloc: failed adding pool
>         fio: failed allocating random map. If running a large number of jobs, try the 'norandommap' option or set 'softrandommap'. Or give a larger --alloc-size to fio.
>
> fio continues to run after that; I think it verifies only
> the devices for which the allocation worked and ignores
> the rest.
>
>
> ---
> Rob Elliott    HP Server Storage
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
