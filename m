Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEEEC636D7
	for <fio@archiver.kernel.org>; Tue, 21 Feb 2023 15:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjBUPGf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Feb 2023 10:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbjBUPGf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Feb 2023 10:06:35 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26792BF25
        for <fio@vger.kernel.org>; Tue, 21 Feb 2023 07:06:17 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o14so3809601wms.1
        for <fio@vger.kernel.org>; Tue, 21 Feb 2023 07:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJjhi481pBVRYpPP2nGVdkcNwnJH6QeRCNz43PqhU5I=;
        b=bSkRSOH1OhThDpOPJkvZZJWQH8HzG68QVgcATUYv4am3tVcDyPilhA7doD23Up9/bR
         qQZYPtis/qEoNMup0twr6JP64qTsfZRqJ5ZDFCswUpnkpgNsYu41+VW2TRmmzCuDjvBy
         rTUGEgRCc9EtPwojgAHy6nU2ifQ7IKmZ0BPS29BgxWCsVdp86vSSSr5GXWX1QlKaMEol
         j/2Ho/BwZ3nrETn1sCP3vKwbS6Eu6nXcnSLD3t5BIQ8vFX2YI5dvOBlQ/0bhCu0MXXkQ
         zTjeMLA2pQd4JRVIfQr7ZZJTAcnTwTdAYSCKBQ3EATfXGMgG6PWknsTerCXEFi4E8sNU
         jUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJjhi481pBVRYpPP2nGVdkcNwnJH6QeRCNz43PqhU5I=;
        b=YeFnL7BO57XlwwS/H+ASYc6Fvluyl23N6+ttpqSWEU19YmOYNUxaNbxd854fWJhxen
         I/HARxo+F/CBFUmwXWvE+mWjFMw7CG31AYN6F/KBgvqLCTe5EUTAhbVpCbJnx1v5E0Ok
         UGgCZkZo8Tv47no+Fex4Jluy0WKDQ5FsEmZiw6cxBDEDjKxw3s77mmAt4TIB4VxQMoFt
         BDjY+ZcFJUcGmZKRX9V3iegAAoHhx+ZCnznllWBP2Fqe+eFn1s7s/+dl2YTSYlqtPPCJ
         5AFT2uS4DHom22Xlm6RcExMjoroLfeS/CThbBJxmLKkHtcrO6FcSZ9kwsOOoTXt/nSHp
         GyuA==
X-Gm-Message-State: AO0yUKXhsX+5qqEUyBgrTWn39XL6g6jchvOg9SLHv5KAcF9XOHjap+CK
        LtPs+qrhrmfZvyc1ToyXzkxHqTO1U9GxEdvRtTnEiyxXm1nCRjo3zks=
X-Google-Smtp-Source: AK7set+PkGaaZ6jiEVP1ONBL1jmVZUAClac78J/k2ZUd6px+/QDfMVKG6pHPkzW6bHh8fH0kbEilgM1SR2VH9Wvz/LA=
X-Received: by 2002:a05:600c:470d:b0:3dd:2823:e1a4 with SMTP id
 v13-20020a05600c470d00b003dd2823e1a4mr2207663wmo.153.1676991976240; Tue, 21
 Feb 2023 07:06:16 -0800 (PST)
MIME-Version: 1.0
References: <CAMtsHkrJbk8GCrAvfAzKAASYOkaudNX0--mdnWHQ=nnAzhnH0w@mail.gmail.com>
 <IA0PR17MB62759977BBEDE6BB9F718115A4A79@IA0PR17MB6275.namprd17.prod.outlook.com>
In-Reply-To: <IA0PR17MB62759977BBEDE6BB9F718115A4A79@IA0PR17MB6275.namprd17.prod.outlook.com>
From:   seyed mohammad <seymad.f1@gmail.com>
Date:   Tue, 21 Feb 2023 18:36:32 +0330
Message-ID: <CAMtsHkqzQoBo3kWEKsv==ZjgvaV5bNi1k-XXSd=fxx+JWpjz0A@mail.gmail.com>
Subject: Re: Problems with interpreting FIO output
To:     Adam Horshack <horshack@live.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Adam,
Just to give a little background, this happened when I was testing my
software RAID10 (mdadm) alongside BTRFS; I was checking the system
load with htop and it did not shoot through the roof.  Many thanks for
the test results. The same experiment with other FS, had much higher
system loads.

On Sun, Feb 19, 2023 at 9:06 PM Adam Horshack <horshack@live.com> wrote:
>
> Hi Seyed,
>
> As you probably know, IOPS represents total #I/Os / total time and iops r=
epresents the per-interval averages. The default averaging interval for IOP=
s is 500ms (--iopsavgtime=3D500).
>
> fio is reporting 12,469 interval samples for your run. I would expect 400=
 (jobs) x 31.279 (actual runtime secs) x 2 (samples per second, ie 1000/500=
) =3D 25,023 interval samples. It's not unusual for total # samples to depa=
rt vs expected under heavy loads. Your reported IOPS is 2x your iops (199K =
vs 397k for reads), implying the #samples discrepancy is related to the IOP=
s discrepancy.
>
> I was able to reproduce your IOPs vs iops discrepancy on a ramdisk using =
100 vs 1,000 jobs. Read IOPs for 5 second run:
>
> 100 jobs: #samples=3D910 vs #expected=3D1,000, IOPS=3D84.3k vs iops=3D83.=
4k
> 1000 jobs: #samples=3D1,470 vs #expected=3D10,000, IOPS=3D107k vs iops=3D=
172k
>
> If I enable IOPs logging with a 500ms interval (--write_iops_log and --lo=
g_avg_msec=3D500) I get the following samples for one of the jobs:
>
> 100 job run
> 563, 717, 0, 0, 0
> 1062, 759, 0, 0, 0
> 1562, 784, 0, 0, 0
> 2062, 772, 0, 0, 0
> 2562, 774, 0, 0, 0
> 3062, 769, 0, 0, 0
> 3563, 778, 0, 0, 0
> 4064, 706, 0, 0, 0
> 4563, 757, 0, 0, 0
>
> 1000 job run:
> 892, 128, 0, 0, 0
> 2660, 95, 0, 0, 0
>
> First column is elapsed time ms, second is average IOPs over that interva=
l. Notice the 1,000 job run has fewer samples. Some jobs in the 1,000 job r=
un have zero samples. The IOPS vs iops discrepancy is likely sampling error=
 from insufficient samples captured due to CPU load. I'm not too familiar w=
ith the back-end stats capture but I think it runs as a single thread. Perh=
aps its priority could be boosted.
>
> Adam
>
> From: seyed mohammad <seymad.f1@gmail.com>
> Sent: Sunday, February 19, 2023 12:42 AM
> To: fio@vger.kernel.org <fio@vger.kernel.org>
> Subject: Problems with interpreting FIO output
>
> I've run a random read/write FIO test with 400 jobs to benchmark a
> RAID setup. The output IOPS and the iops statistics (the average/avg)
> are divergent; how can this be interpreted? Should these two values
> converge?
>
> Test results for read:
> job1: (groupid=3D0, jobs=3D400): err=3D 0: pid=3D25204:
>   read: IOPS=3D199k, BW=3D778MiB/s (816MB/s)(23.8GiB/31279msec)
>     slat (usec): min=3D3, max=3D1401.7k, avg=3D1423.58, stdev=3D38712.03
>     clat (usec): min=3D60, max=3D2683.7k, avg=3D86310.45, stdev=3D289174.=
76
>      lat (usec): min=3D70, max=3D2683.7k, avg=3D87730.40, stdev=3D291369.=
20
>     clat percentiles (usec):
>      |  1.00th=3D[    239],  5.00th=3D[    562], 10.00th=3D[    717],
>      | 20.00th=3D[    816], 30.00th=3D[    865], 40.00th=3D[    906],
>      | 50.00th=3D[    947], 60.00th=3D[    988], 70.00th=3D[   1057],
>      | 80.00th=3D[   1156], 90.00th=3D[   2147], 95.00th=3D[ 935330],
>      | 99.00th=3D[1266680], 99.50th=3D[1300235], 99.90th=3D[1350566],
>      | 99.95th=3D[1384121], 99.99th=3D[1803551]
>    bw (  MiB/s): min=3D  228, max=3D 3556, per=3D100.00%, avg=3D1553.73,
> stdev=3D 2.08, samples=3D12469
>    iops        : min=3D58376, max=3D910489, avg=3D397711.45, stdev=3D532.=
63,
> samples=3D12469
>
> Test results for write:
>  write: IOPS=3D85.1k, BW=3D334MiB/s (350MB/s)(10.2GiB/31279msec); 0 zone =
resets
>     slat (usec): min=3D7, max=3D1397.5k, avg=3D1430.09, stdev=3D38675.97
>     clat (usec): min=3D14, max=3D2684.1k, avg=3D97398.93, stdev=3D306662.=
71
>      lat (usec): min=3D28, max=3D2684.1k, avg=3D98825.72, stdev=3D308705.=
23
>     clat percentiles (usec):
>      |  1.00th=3D[    314],  5.00th=3D[    635], 10.00th=3D[    717],
>      | 20.00th=3D[    791], 30.00th=3D[    840], 40.00th=3D[    881],
>      | 50.00th=3D[    922], 60.00th=3D[    971], 70.00th=3D[   1057],
>      | 80.00th=3D[   1270], 90.00th=3D[  10290], 95.00th=3D[1044382],
>      | 99.00th=3D[1266680], 99.50th=3D[1300235], 99.90th=3D[1350566],
>      | 99.95th=3D[1384121], 99.99th=3D[1769997]
>    bw (  KiB/s): min=3D98765, max=3D1568174, per=3D100.00%, avg=3D681623.=
43,
> stdev=3D924.60, samples=3D12469
>    iops        : min=3D24675, max=3D391998, avg=3D170363.71, stdev=3D231.=
14,
> samples=3D12469
>
>
> The FIO job:
> [global]
> name=3D4k random read 4 ios
> ioengine=3Dlibaio
> direct=3D1
> readwrite=3Drandrw
> rwmixread=3D70
> iodepth=3D64
> buffered=3D0
> size=3D400M
> runtime=3D30
> time_based
> randrepeat=3D0
> norandommap
> refill_buffers
> ramp_time=3D10
> bs=3D4k
> numjobs=3D400
> group_reporting=3D1
