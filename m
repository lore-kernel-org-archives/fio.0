Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:64940 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbcCCDDJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Mar 2016 22:03:09 -0500
Message-ID: <56D7A964.3040809@vlnb.net>
Date: Wed, 02 Mar 2016 19:03:00 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com> <56D66B1C.6050506@vlnb.net> <94D0CD8314A33A4D9D801C0FE68B40295C349408@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295C349408@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Elliott, Robert (Persistent Memory) wrote on 03/02/2016 10:37 AM:
>>>> Here is my full fio job:
>>>>
>>>> [global]
>>>> ioengine=libaio
>>>> buffered=0
>>>> sync=0
>>>> direct=1
>>>> randrepeat=1
>>>> softrandommap=1
>>>> rw=randread
>>>> bs=4k
>>>> filename=./nvram (it's a link to a block device)
>>>> exitall=1
>>>> thread=1
>>>> disable_lat=1
>>>> disable_slat=1
>>>> disable_clat=1
>>>> loops=10
>>>> iodepth=16
>>>
>>> You appear to be missing gtod_reduce
>>> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L1668 ) or
>>> gettimeofday cpu pinning. You also aren't using batching
>>> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L815 ).
>>
> ...
>> Jobs	IOPS(M)	%user	%sys
>> 1	4.3	78	22
>> 2	7.6	67	33
>> 3	10.5	65	35
>> 4	7.7	61	38
>> 5	4.8	78	22
>> 6	4.7	83	17
>> 7	4.8	84	15
> 
> Use cpus_allowed_policy=split to keep threads or processes
> from wandering across CPUs.

Tried, no help, which is easily explainable, because I'm always running num jobs < num
CPUs.

> If the system is NUMA, split the NVDIMMs based on that
> and use cpus_allowed to just have threads access local
> NVDIMMs.

No, it's single socket.

> As someone else mentioned, the random map overhead is
> noticeable, especially for large capacity devices.  Use
> norandommap and randrepeat=0.

Had done, see the job file in my message you didn't quote.

> There was a problem in 2014 requiring invalidate=0 for
> small capacities; I don't recall if that was fixed.
> 
> If you're using the pmem driver, it is incapable of queuing
> (submissions are immediately completed), so iodepth is
> irrelevant.
> 
> There are other system and OS settings to tune, like: 
> * use the performance governor. The userspace governor
> spends a lot of time making acpi_os_write calls

Had done, see not quoted part of my e-mail.

> * turn off auditing (audit=0 on the kernel command line)
> * turn off C states

Tried too.

Overall, I appreciate your help, but again, question is not how to improve my results.
The question is how to _decrease fio overhead_ with libaio, see subject of this e-mail.
It's very different question.

Thanks,
Vlad

