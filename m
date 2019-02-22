Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfBVWdP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Feb 2019 17:33:15 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Question: can anyone tell me what QD exactly a device is received from this test script
References: <CO2PR04MB2374AD34FB3EE52EC16FE6419F7F0@CO2PR04MB2374.namprd04.prod.outlook.com>
        <CALjAwxg=j1OJ_uqV+S8NdSstOJk=23i9V3yo7bxWXcF91PT3Ow@mail.gmail.com>
Date: Fri, 22 Feb 2019 17:33:13 -0500
In-Reply-To: <CALjAwxg=j1OJ_uqV+S8NdSstOJk=23i9V3yo7bxWXcF91PT3Ow@mail.gmail.com>
        (Sitsofe Wheeler's message of "Fri, 22 Feb 2019 22:11:49 +0000")
Message-ID: <x49h8cvv4gm.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jing Booth <Jing.Booth@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Sitsofe Wheeler <sitsofe@gmail.com> writes:

> Hi,
>
> On Fri, 22 Feb 2019 at 16:19, Jing Booth <Jing.Booth@wdc.com> wrote:
>>
>> Hi all,
>>
>> In the test script shown below, it has [global] section and
>> [nvme0n1] section. The test script is used to test a storage
>> device. What queue depth does the storage device receive? Thanks
>>
>> fio --name=global --ba=16K --bs=16K --buffered=0 --ioengine=libaio
>> --nice=-10 --rw=randrw --size=100% --status-interval=1 --ramp_time=2
>> --runtime=5 --time_based --rwmixread=25 --group_reporting
>> --numjobs=4 --iodepth=16 --norandommap
>> --random_generator=tausworthe64 --randrepeat=0
>> --percentile_list=99:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999999
>> --name=nvme0n1 --filename=/dev/nvme0n1 --iodepth=64
>
> Something like 4 if you count all jobs together (because numjobs is 4)
> but you can check for yourself by looking at the submit line in the IO
> depths output that fio produces.
>
> Did you see the warnings with the libaio engine in the
> manual/documentation
> (https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-engine ) or the
> warning in the iodepth option section
> (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth
> )?

He specified buffered=0.  The end result will by 64 * 4 = 256.  Of
course, at the device things may differ due to splitting and/or merging
of I/O in the kernel.

Cheers,
Jeff

