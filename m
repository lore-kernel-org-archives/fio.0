Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33728 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcCBHii (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Mar 2016 02:38:38 -0500
Received: by mail-vk0-f43.google.com with SMTP id k196so194379300vka.0
        for <fio@vger.kernel.org>; Tue, 01 Mar 2016 23:38:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D66B1C.6050506@vlnb.net>
References: <56D525E1.6010407@vlnb.net>
	<CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
	<56D66B1C.6050506@vlnb.net>
Date: Wed, 2 Mar 2016 07:38:37 +0000
Message-ID: <CALjAwxgT1OHUWfx6p3=SZ=SnM2KyPTEs6xdMnb2dYjbzzq+zhA@mail.gmail.com>
Subject: Re: Fio high IOPS measurement mistake
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2 March 2016 at 04:25, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Hi,
>
> Sitsofe Wheeler wrote on 02/29/2016 10:01 PM:
>> Hi,
>>
>> On 1 March 2016 at 05:17, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> Hello,
>>>
>>> I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
>>> thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
>>> and direct=1, so user space CPU consumption should be virtually zero.
>>>
>>> That 30% user CPU consumption makes me suspect that this is overhead for internal fio
>>> housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
>>> hope, I'm using correct English terms).
>>>
>>> Can anybody comment it and suggest how to decrease this user space CPU consumption?
>>>
>>> Here is my full fio job:
>>>
>>> [global]
>>> ioengine=libaio
>>> buffered=0
>>> sync=0
>>> direct=1
>>> randrepeat=1
>>> softrandommap=1
>>> rw=randread
>>> bs=4k
>>> filename=./nvram (it's a link to a block device)
>>> exitall=1
>>> thread=1
>>> disable_lat=1
>>> disable_slat=1
>>> disable_clat=1
>>> loops=10
>>> iodepth=16
>>
>> You appear to be missing gtod_reduce
>> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L1668 ) or
>> gettimeofday cpu pinning. You also aren't using batching
>> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L815 ).
>
> Thanks, I tried them, but they did not make any significant difference. The biggest

There was no cpu reduction from setting both iodepth_batch and
iodepth_batch_complete together?

> difference I had was when I changed CPU governor to "performance". Now I have 20-25%
> user space, measured by fio itself, it's coherent with top. Note, I'm considering
> per-thread CPU consumption, to see it in top you need to press '1' (one line per each CPU).

Have you applied the points mentioned in
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/chap-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Performance_Features_in_RednbspHat_EnterprisenbspLinuxnbsp7.html
? Things like the scheduler granularity (as changed by Red Hat's
tuned-adm) can have a large impact...

> The full job file was:
>
> [global]
> ioengine=sync
> buffered=0
> sync=0
> direct=1
[...]
> iodepth=8 /* does not matter */
^^^ It's worth noting that direct and iodepth don't really have an
impact on synchronous ioengines -
https://github.com/axboe/fio/blob/master/HOWTO#L804 .

-- 
Sitsofe | http://sucs.org/~sits/
