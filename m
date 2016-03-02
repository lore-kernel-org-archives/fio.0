Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35261 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcCBI1M (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Mar 2016 03:27:12 -0500
Received: by mail-lf0-f51.google.com with SMTP id j186so55559231lfg.2
        for <fio@vger.kernel.org>; Wed, 02 Mar 2016 00:27:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D525E1.6010407@vlnb.net>
References: <56D525E1.6010407@vlnb.net>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 2 Mar 2016 11:26:50 +0300
Message-ID: <CANvN+enRXmL5dZaaQX3q2Fi7FmADwBU4_kePWiG7c5L9So2T6A@mail.gmail.com>
Subject: Re: Fio high IOPS measurement mistake
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Mar 1, 2016 at 8:17 AM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
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

If you believe fio to be 'mistaken', please profile your runs with
perf and publish the profile,
pointing out what you believe to be a mistake.

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

I suggest you start with switching the random map off as it's known to
be expensive and,
for some reason, is being maintained even in read-only workloads.

Regards,
Andrey

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
>
> [file1]
>
> [file2]
>
> I'm working on million+ IOPS range.
>
> Thanks,
> Vlad
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
