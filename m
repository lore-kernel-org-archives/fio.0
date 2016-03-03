Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:53740 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbcCCDCo (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Mar 2016 22:02:44 -0500
Message-ID: <56D7A94D.1010708@vlnb.net>
Date: Wed, 02 Mar 2016 19:02:37 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net>	<CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>	<56D66B1C.6050506@vlnb.net> <CALjAwxgT1OHUWfx6p3=SZ=SnM2KyPTEs6xdMnb2dYjbzzq+zhA@mail.gmail.com>
In-Reply-To: <CALjAwxgT1OHUWfx6p3=SZ=SnM2KyPTEs6xdMnb2dYjbzzq+zhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Sitsofe Wheeler wrote on 03/01/2016 11:38 PM:
> On 2 March 2016 at 04:25, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Hi,
>>
>> Sitsofe Wheeler wrote on 02/29/2016 10:01 PM:
>>> Hi,
>>>
>>> On 1 March 2016 at 05:17, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>>> Hello,
>>>>
>>>> I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
>>>> thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
>>>> and direct=1, so user space CPU consumption should be virtually zero.
>>>>
>>>> That 30% user CPU consumption makes me suspect that this is overhead for internal fio
>>>> housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
>>>> hope, I'm using correct English terms).
>>>>
>>>> Can anybody comment it and suggest how to decrease this user space CPU consumption?
>>>>
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
>> Thanks, I tried them, but they did not make any significant difference. The biggest
> 
> There was no cpu reduction from setting both iodepth_batch and
> iodepth_batch_complete together?

No, no significant difference.

I also forgot to mention that I had tried gtod_cpu=11 as well, and it only made things
worse.

>> difference I had was when I changed CPU governor to "performance". Now I have 20-25%
>> user space, measured by fio itself, it's coherent with top. Note, I'm considering
>> per-thread CPU consumption, to see it in top you need to press '1' (one line per each CPU).
> 
> Have you applied the points mentioned in
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/chap-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Performance_Features_in_RednbspHat_EnterprisenbspLinuxnbsp7.html
> ? Things like the scheduler granularity (as changed by Red Hat's
> tuned-adm) can have a large impact...

Thanks for your help and feedback, but you are trying to improve my results, while I'm
asking how to _decrease fio overhead_ on high IOPS with libaio. It's very different
question.

>> The full job file was:
>>
>> [global]
>> ioengine=sync
>> buffered=0
>> sync=0
>> direct=1
> [...]
>> iodepth=8 /* does not matter */
> ^^^ It's worth noting that direct and iodepth don't really have an
> impact on synchronous ioengines -
> https://github.com/axboe/fio/blob/master/HOWTO#L804

Yes, sure, this is why I commented it as "doesn't matter".

Thanks,
Vlad
