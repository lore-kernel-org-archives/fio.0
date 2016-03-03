Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:60671 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbcCCDCz (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Mar 2016 22:02:55 -0500
Message-ID: <56D7A959.4060809@vlnb.net>
Date: Wed, 02 Mar 2016 19:02:49 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CANvN+enRXmL5dZaaQX3q2Fi7FmADwBU4_kePWiG7c5L9So2T6A@mail.gmail.com>
In-Reply-To: <CANvN+enRXmL5dZaaQX3q2Fi7FmADwBU4_kePWiG7c5L9So2T6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Andrey Kuzmin wrote on 03/02/2016 12:26 AM:
> On Tue, Mar 1, 2016 at 8:17 AM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Hello,
>>
>> I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
>> thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
>> and direct=1, so user space CPU consumption should be virtually zero.
>>
>> That 30% user CPU consumption makes me suspect that this is overhead for internal fio
>> housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
>> hope, I'm using correct English terms).
> 
> If you believe fio to be 'mistaken', please profile your runs with
> perf and publish the profile,
> pointing out what you believe to be a mistake.

I had done it, see my yesterday's e-mail.

>> Can anybody comment it and suggest how to decrease this user space CPU consumption?
>>
>> Here is my full fio job:
>>
>> [global]
>> ioengine=libaio
>> buffered=0
>> sync=0
>> direct=1
>> randrepeat=1
>> softrandommap=1
> 
> I suggest you start with switching the random map off as it's known to
> be expensive and,
> for some reason, is being maintained even in read-only workloads.

Also done, see the same my e-mail.

Thanks,
Vlad

> Regards,
> Andrey
> 
>> rw=randread
>> bs=4k
>> filename=./nvram (it's a link to a block device)
>> exitall=1
>> thread=1
>> disable_lat=1
>> disable_slat=1
>> disable_clat=1
>> loops=10
>> iodepth=16
>>
>> [file1]
>>
>> [file2]
>>
>> I'm working on million+ IOPS range.
>>
>> Thanks,
>> Vlad

