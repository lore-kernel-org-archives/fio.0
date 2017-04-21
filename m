Return-Path: <fio-owner@vger.kernel.org>
Received: from v150-95-18-100.b001.p.han1.static.cnode.io ([150.95.18.100]:38108
        "EHLO citigomail.webstarterz.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1035718AbdDUFsH (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 21 Apr 2017 01:48:07 -0400
From: "Son Chu" <son.ct@citigo.com.vn>
References: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn> <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com>
In-Reply-To: <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com>
Subject: RE: Does fio really bypass page cache with option direct=1?
Date: Fri, 21 Apr 2017 12:48:00 +0700
Message-ID: <000201d2ba62$d6900610$83b01230$@citigo.com.vn>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Srinivasa Chamarthy' <chamarthy.raju@gmail.com>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>, fio@vger.kernel.org

Hi Srinivasa.

I still got page cache increasing even when I used those option.=20
Here is output without those option:
fio --filename=3D/opt/test --size=3D1G --direct=3D1 --sync=3D1 =
--rw=3Drandrw --bs=3D4k --numjobs=3D1 --iodepth=3D8 --runtime=3D60 =
--time_based --group_reporting --name=3Djournal-test --invalidate=3D1 =
--gtod_reduce=3D1 --ioengine=3Dlibaio
HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
337        0        0   100.0%            0         95
     411        0    89005   100.0%            0        664
     337        0    38526   100.0%            0        816
     337        0    26605   100.0%            0        920
     591        0    19906   100.0%            0        998
     337        0    12283   100.0%            0       1046
     457        0    11351   100.0%            0       1090
     337        0    12398   100.0%            0       1138
     337        0    13252   100.0%            0       1190
     337        0    11876   100.0%            0       1237
     337        0     8723   100.0%            0       1271
     337        0    12844   100.0%            0       1321
     337        0     4612   100.0%            0       1340
     457        0        0   100.0%            0       1340
     337        0        3   100.0%            0       1340
     457        0        0   100.0%            0       1340
     457        0        0   100.0%            0       1340
     337        0        0   100.0%            0       1340
     336        1        0    99.7%            0        316

And here is output with those option:
fio --filename=3D/opt/test --size=3D1G --direct=3D1 --sync=3D1 =
--rw=3Drandrw --bs=3D4k --numjobs=3D1 --iodepth=3D8 --runtime=3D60 =
--time_based --group_reporting --name=3Djournal-test --invalidate=3D1 =
--gtod_reduce=3D1 --ioengine=3Dlibaio --create_on_open=3D1 =
--fallocate=3Dnone
HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
337        0        0   100.0%            0         95
     337        0        0   100.0%            0         95
     337        0        0   100.0%            0         95
     410        1        0    99.8%            0        316
     337        0        9   100.0%            0        316
     337        0        0   100.0%            0        316
     337        0        3   100.0%            0        316
     337        0        0   100.0%            0        316
     337        0        0   100.0%            0        316
    1828        0       10   100.0%            0        316
     337        0        0   100.0%            0        316
     337        0        0   100.0%            0        316
     337        0        0   100.0%            0        316

As you can see the page cache still increase from 95 to 316 when using =
those option.=20
I don't understand why the dd command with option oflag=3Ddirect gave no =
page cache increasing while fio increased page cache.

Could you help me please?

Thanks a lot in advance.

Regards,
Son


-----Original Message-----
From: Srinivasa Chamarthy [mailto:chamarthy.raju@gmail.com]=20
Sent: Friday, April 21, 2017 12:07 PM
To: Son Chu <son.ct@citigo.com.vn>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>; fio@vger.kernel.org
Subject: Re: Does fio really bypass page cache with option direct=3D1?

You may use options --create_on_open=3D1 --fallocate=3Dnone. By default =
FIO will prepare the file of the size (creates a sparse file) and then =
performs IO. The options --create_on_open=3D1 and --fallocate=3Dnone =
should skip the step.

--
Srinivasa R Chamarthy


On Fri, Apr 21, 2017 at 9:54 AM, Son Chu <son.ct@citigo.com.vn> wrote:
> Hi Sitsofe,
>
> Sorry if this email troubled you but I could not find any useful=20
> information for this. I am getting the question with fio page cache=20
> bypass option (direct=3D1 ioengine=3Dlibaio)
>
> I am using fio version 2.19 with command:
>
> fio --filename=3D/opt/test --direct=3D1 --rw=3Drandrw --randrepeat=3D0 =

> --ioengine=3Dlibaio --bs=3D4k --rwmixread=3D75 --iodepth=3D16 =
--numjobs=3D1=20
> --name=3D4ktest --size=3D1G
>
> and i used cachestat tool from here to monitor:=20
> https://github.com/brendangregg/perf-tools
>
> The output was:
>
> Counting cache functions... Output every 1 seconds.
>
> HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
>
> 1399 42 0 97.1% 2 31
>
> 1408 0 0 100.0% 2 31
>
> -68699 39 71478 100.1% 3 532
>
> -21325 0 22886 100.0% 3 621
>
> -19956 0 21492 100.0% 3 705
>
> -13739 0 15254 100.0% 3 765
>
> As far as i know the buffer cache and page cache was unified from =
Linux kernel version 2.4. So i wondered why fio with option direct=3D1 =
that didn=E2=80=99t bypass page cache as it should?
>
> I didn=E2=80=99t see page cache increasing when using dd with =
oflag=3Ddirect to copy or write file to disk.
>
> Please correct me if i am wrong.
>
> Thanks a lot in advance.
>
> Regards,
> Son
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the=20
> body of a message to majordomo@vger.kernel.org More majordomo info at  =

> http://vger.kernel.org/majordomo-info.html

