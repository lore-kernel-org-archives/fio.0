Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33804 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcCAGBH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Mar 2016 01:01:07 -0500
Received: by mail-vk0-f43.google.com with SMTP id e185so157426230vkb.1
        for <fio@vger.kernel.org>; Mon, 29 Feb 2016 22:01:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D525E1.6010407@vlnb.net>
References: <56D525E1.6010407@vlnb.net>
Date: Tue, 1 Mar 2016 06:01:06 +0000
Message-ID: <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
Subject: Re: Fio high IOPS measurement mistake
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 1 March 2016 at 05:17, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Hello,
>
> I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
> thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
> and direct=1, so user space CPU consumption should be virtually zero.
>
> That 30% user CPU consumption makes me suspect that this is overhead for internal fio
> housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
> hope, I'm using correct English terms).
>
> Can anybody comment it and suggest how to decrease this user space CPU consumption?
>
> Here is my full fio job:
>
> [global]
> ioengine=libaio
> buffered=0
> sync=0
> direct=1
> randrepeat=1
> softrandommap=1
> rw=randread
> bs=4k
> filename=./nvram (it's a link to a block device)
> exitall=1
> thread=1
> disable_lat=1
> disable_slat=1
> disable_clat=1
> loops=10
> iodepth=16

You appear to be missing gtod_reduce
(https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L1668 ) or
gettimeofday cpu pinning. You also aren't using batching
(https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L815 ).

You may want to look at what fio settings your flash vendor recommends
for benchmarking purposes...

-- 
Sitsofe | http://sucs.org/~sits/
