Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38007 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWSxb (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 13:53:31 -0500
Received: by mail-wm0-f41.google.com with SMTP id r144so170902705wme.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 10:53:30 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <974E4982-D808-4CAF-ACCF-85866C0050A7@intel.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <c7fc722c-f3ca-4abe-7202-8ca67b5e59a0@gmail.com>
Date: Mon, 23 Jan 2017 19:53:28 +0100
MIME-Version: 1.0
In-Reply-To: <974E4982-D808-4CAF-ACCF-85866C0050A7@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Andrey,

thanks for your tips!

Am 23.01.2017 um 19:18 schrieb Kudryavtsev, Andrey O:
> Hi Tobias,
> MDRAID overhead is always there, but you can play with some tuning knobs.
> I recommend following:
> 1. You must use many thread/job with quite high QD configuration. Highest IOPS for Intel P3xxx drives achieved if you saturate them with 128 *4k IO per drive. This can be done in 32 jobs and QD4 or 16J/8QD and so on. With MDRAID on top of that, you should multiply by the number of drives in the array. So, I think currently the problem, that you’re simply not submitting enough IOs.

I get nearly 7 mio random 4k IOPS with engine=sync and threads=2800 on 
the 16 logical NVMe block devices (from 8 physical P3608 4TB).

The values I get with libaio are much lower (see my other reply).

My concrete problem is: I can't get these 7 mio IOPS through MD (striped 
over all 16 NVMe logical devices) .. MD hits a wall at 1.6 mio

Note: I also tried LVM striped volumes. Sluggish perf., much higher 
system load.

> 2. changing a HW SSD sector size to 4k may also help if you’re sure that your workload is always 4k granular

Background: my workload is 100% 8kB and current results are here

https://github.com/oberstet/scratchbox/raw/master/cruncher/sql19/Performance%20Results%20-%20NVMe%20Scaling%20with%20IO%20Concurrency.pdf

The sector size on the NVMes currently is

oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo isdct show -a 
-intelssd 0 | grep SectorSize
SectorSize : 512

Do you recommend changing that in my case?

> 3. and finally using “imsm” MDRAID extensions and latest MDADM build.

What is imsm?

Is that "Intel Matrix Storage Array"?

Is that fully open-source and in-tree kernel?

If not, I won't use it anyway, sorry, company policy.

We're running Debian 8 / Kernel 4.8 from backports (and soonish Debian 9).

> See some other hints there:
> http://www.slidesearchengine.com/slide/hands-on-lab-how-to-unleash-your-storage-performance-by-using-nvm-express-based-pci-express-solid-state-drives
>
> some config examples for NVMe are here:
> https://github.com/01org/fiovisualizer/tree/master/Workloads
>
>

What's your platform?

Eg on Windows, async IO is awesome. On *nix .. not. At least in my 
experience.

And then, my target workload (PostgreSQL) isn't doing AIO at all ..

Cheers,
/Tobias

