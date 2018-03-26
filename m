Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:44320 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeCZQB5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Mar 2018 12:01:57 -0400
Received: by mail-vk0-f46.google.com with SMTP id r184so2567643vke.11
        for <fio@vger.kernel.org>; Mon, 26 Mar 2018 09:01:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116191E688201AE89DA270381AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
 <CALjAwxjN890tChPL2cOw2NsU_M-85GcEJKq8XwotYNOoDgxEtA@mail.gmail.com> <CY1PR0401MB1116191E688201AE89DA270381AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 26 Mar 2018 17:01:24 +0100
Message-ID: <CALjAwxhhXogm8x_7RbdOBq0wOEFSrguL2S-qTpN=7ahO=HZ_0g@mail.gmail.com>
Subject: Re: "No I/O performed by <engine>" reporting bug?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Itay Ben Yaacov <Itay.BenYaacov@wdc.com>

Hi Kris,

On 26 March 2018 at 16:49, Kris Davis <Kris.Davis@wdc.com> wrote:
>
> Thanks.   I gave it a try and no longer see the error message.   However, it doesn't appear that the loop count is being used any longer when number_ios option is set.  The following runs is less about a second:
>
> $ fio --ioengine=libaio --loops=32 --direct=1 --numjobs=1 --norandommap --randrepeat=0 --size=16GB --filename=/dev/sdb --name=Random-read-4K-QD1 --rw=randread --bs=4K --iodepth=1 --number_ios=8192
> Random-read-4K-QD1: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
> fio-3.5
> Starting 1 process
> Jobs: 1 (f=1)
> Random-read-4K-QD1: (groupid=0, jobs=1): err= 0: pid=31578: Mon Mar 26 10:37:06 2018
>    read: IOPS=7433, BW=29.0MiB/s (30.4MB/s)(32.0MiB/1102msec)
>     slat (nsec): min=4564, max=43459, avg=6011.65, stdev=662.43
> ...
> Run status group 0 (all jobs):
>    READ: bw=29.0MiB/s (30.4MB/s), 29.0MiB/s-29.0MiB/s (30.4MB/s-30.4MB/s), io=32.0MiB (33.6MB), run=1102-1102msec

Is this a bad thing? I was aiming for that behaviour (for number_ios to
behave per job rather than per loop)...

> But, if I use io_size=32MB, it does actually run for about 30 seconds as expected:
>
> $  fio --ioengine=libaio --loops=32 --direct=1 --numjobs=1 --norandommap --randrepeat=0 --size=16GB --filename=/dev/sdb --name=Random-read-4K-QD1 --rw=randread --bs=4K --iodepth=1 --io_size=32MB
> Random-read-4K-QD1: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
> fio-3.5
> Starting 1 process
> Random-read-4K-QD1: No I/O performed by libaio, perhaps try --debug=io option for details?

^^^ Have you found another problem here?

> Random-read-4K-QD1: (groupid=0, jobs=1): err= 0: pid=31998: Mon Mar 26 10:46:45 2018
>    read: IOPS=7790, BW=30.4MiB/s (31.9MB/s)(1024MiB/33650msec)
>     slat (nsec): min=4443, max=43457, avg=4831.99, stdev=286.39
> ...
> Run status group 0 (all jobs):
>    READ: bw=30.4MiB/s (31.9MB/s), 30.4MiB/s-30.4MiB/s (31.9MB/s-31.9MB/s), io=1024MiB (1074MB), run=33650-33650msec
>
> Disk stats (read/write):
>   sdb: ios=262130/0, merge=0/0, ticks=31453/0, in_queue=31396, util=93.06%

-- 
Sitsofe | http://sucs.org/~sits/
