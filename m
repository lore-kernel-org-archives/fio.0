Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:35760 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfBWIzX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 23 Feb 2019 03:55:23 -0500
Received: by mail-wr1-f48.google.com with SMTP id t18so4801258wrx.2
        for <fio@vger.kernel.org>; Sat, 23 Feb 2019 00:55:22 -0800 (PST)
MIME-Version: 1.0
References: <CO2PR04MB2374AD34FB3EE52EC16FE6419F7F0@CO2PR04MB2374.namprd04.prod.outlook.com>
 <CALjAwxg=j1OJ_uqV+S8NdSstOJk=23i9V3yo7bxWXcF91PT3Ow@mail.gmail.com> <x49h8cvv4gm.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49h8cvv4gm.fsf@segfault.boston.devel.redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 23 Feb 2019 08:54:55 +0000
Message-ID: <CALjAwxh7Ke74yVR43nUGCuoK_qd1_FVbPV4zC4+AZKSeG+sX0Q@mail.gmail.com>
Subject: Re: Question: can anyone tell me what QD exactly a device is received
 from this test script
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jing Booth <Jing.Booth@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, 22 Feb 2019 at 22:33, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Sitsofe Wheeler <sitsofe@gmail.com> writes:
>
> > Hi,
> >
> > On Fri, 22 Feb 2019 at 16:19, Jing Booth <Jing.Booth@wdc.com> wrote:
> >>
> >> Hi all,
> >>
> >> In the test script shown below, it has [global] section and
> >> [nvme0n1] section. The test script is used to test a storage
> >> device. What queue depth does the storage device receive? Thanks
> >>
> >> fio --name=global --ba=16K --bs=16K --buffered=0 --ioengine=libaio
> >> --nice=-10 --rw=randrw --size=100% --status-interval=1 --ramp_time=2
> >> --runtime=5 --time_based --rwmixread=25 --group_reporting
> >> --numjobs=4 --iodepth=16 --norandommap
> >> --random_generator=tausworthe64 --randrepeat=0
> >> --percentile_list=99:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999999
> >> --name=nvme0n1 --filename=/dev/nvme0n1 --iodepth=64
> >
> > Something like 4 if you count all jobs together (because numjobs is 4)
> > but you can check for yourself by looking at the submit line in the IO
> > depths output that fio produces.
> >
> > Did you see the warnings with the libaio engine in the
> > manual/documentation
> > (https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-engine ) or the
> > warning in the iodepth option section
> > (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth
> > )?
>
> He specified buffered=0.  The end result will by 64 * 4 = 256.  Of
> course, at the device things may differ due to splitting and/or merging
> of I/O in the kernel.

I stand corrected (I did a quick search for direct=1 in the line
posted and missed buffered=0), thanks Jeff!

I would still recommend looking at what fio reports back and you can
also use external tools like iostat to see what the lower level are
reporting too.

-- 
Sitsofe | http://sucs.org/~sits/

