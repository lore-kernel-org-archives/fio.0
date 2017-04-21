Return-Path: <fio-owner@vger.kernel.org>
Received: from v150-95-18-100.b001.p.han1.static.cnode.io ([150.95.18.100]:53381
        "EHLO citigomail.webstarterz.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1031493AbdDUHLE (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 21 Apr 2017 03:11:04 -0400
From: "Son Chu" <son.ct@citigo.com.vn>
References: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn> <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com> <000201d2ba62$d6900610$83b01230$@citigo.com.vn> <CALjAwxjOc-hrLqgGatLKftxjK0GfonpHqG6Y_jL+W2pmrYA4dg@mail.gmail.com>
In-Reply-To: <CALjAwxjOc-hrLqgGatLKftxjK0GfonpHqG6Y_jL+W2pmrYA4dg@mail.gmail.com>
Subject: RE: Does fio really bypass page cache with option direct=1?
Date: Fri, 21 Apr 2017 14:10:58 +0700
Message-ID: <000501d2ba6e$6d308170$47918450$@citigo.com.vn>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: 'Srinivasa Chamarthy' <chamarthy.raju@gmail.com>, fio@vger.kernel.org

Hi,

Here is my dd command:
dd if=3D/dev/zero of=3D/opt/laptop.bin bs=3D1G count=3D5 oflag=3Ddirect

The file system of /opt is XFS:
[root@localhost opt]# df -T | awk '{print $1,$2,$NF}' | grep "^/dev"
/dev/mapper/cl-root xfs /
/dev/sda1 xfs /boot

And this is virtual machine on my dektop so I just use it to test fio =
tool only and there is no read/write running process. And I =
don=E2=80=99t think there is no problem between virtual machine and =
physical machine.

I have also tested on 1 VM where I  hosted using Virtuozzo. The page =
cache still increase.

Thank you very much.

Regards,
Son



-----Original Message-----
From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]=20
Sent: Friday, April 21, 2017 1:33 PM
To: Son Chu <son.ct@citigo.com.vn>
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>; fio@vger.kernel.org
Subject: Re: Does fio really bypass page cache with option direct=3D1?

Hi,

Can you show the exact dd command (options, "of" and all) you used?
Also which filesystem is /opt/ running on and are you sure you're =
looking at the page cache just for the file you're writing (e.g. is =
something writing/reading elsewhere on the system at the same time if =
you're looking at the whole system page cache stats)?

On 21 April 2017 at 06:48, Son Chu <son.ct@citigo.com.vn> wrote:
>
> I still got page cache increasing even when I used those option.
> Here is output without those option:
> fio --filename=3D/opt/test --size=3D1G --direct=3D1 --sync=3D1 =
--rw=3Drandrw=20
> --bs=3D4k --numjobs=3D1 --iodepth=3D8 --runtime=3D60 --time_based =
--group_reporting --name=3Djournal-test --invalidate=3D1 =
--gtod_reduce=3D1 --ioengine=3Dlibaio HITS MISSES DIRTIES RATIO =
BUFFERS_MB CACHE_MB
> 337        0        0   100.0%            0         95
>      411        0    89005   100.0%            0        664
>      337        0    38526   100.0%            0        816
>      337        0    26605   100.0%            0        920
>      591        0    19906   100.0%            0        998
>      337        0    12283   100.0%            0       1046
>      457        0    11351   100.0%            0       1090
>      337        0    12398   100.0%            0       1138
>      337        0    13252   100.0%            0       1190
>      337        0    11876   100.0%            0       1237
>      337        0     8723   100.0%            0       1271
>      337        0    12844   100.0%            0       1321
>      337        0     4612   100.0%            0       1340
>      457        0        0   100.0%            0       1340
>      337        0        3   100.0%            0       1340
>      457        0        0   100.0%            0       1340
>      457        0        0   100.0%            0       1340
>      337        0        0   100.0%            0       1340
>      336        1        0    99.7%            0        316
>
> And here is output with those option:
> fio --filename=3D/opt/test --size=3D1G --direct=3D1 --sync=3D1 =
--rw=3Drandrw=20
> --bs=3D4k --numjobs=3D1 --iodepth=3D8 --runtime=3D60 --time_based =
--group_reporting --name=3Djournal-test --invalidate=3D1 =
--gtod_reduce=3D1 --ioengine=3Dlibaio --create_on_open=3D1 =
--fallocate=3Dnone HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
> 337        0        0   100.0%            0         95
>      337        0        0   100.0%            0         95
>      337        0        0   100.0%            0         95
>      410        1        0    99.8%            0        316
>      337        0        9   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        3   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        0   100.0%            0        316
>     1828        0       10   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        0   100.0%            0        316
>
> As you can see the page cache still increase from 95 to 316 when using =
those option.
> I don't understand why the dd command with option oflag=3Ddirect gave =
no page cache increasing while fio increased page cache.

--
Sitsofe | http://sucs.org/~sits/

