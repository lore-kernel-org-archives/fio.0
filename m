Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:35857 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdK2AFC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Nov 2017 19:05:02 -0500
Received: by mail-ua0-f173.google.com with SMTP id w47so2134538uah.3
        for <fio@vger.kernel.org>; Tue, 28 Nov 2017 16:05:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB09915861B45D074FF2218C4FEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk> <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
 <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com> <TU4PR8401MB09915861B45D074FF2218C4FEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 29 Nov 2017 00:04:31 +0000
Message-ID: <CALjAwxgea5mo0671vb8mry+_RJQ_LCKVfyOR9ePjLSQiXLrALA@mail.gmail.com>
Subject: Re: fio 3.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>

Anton,

Did you see Elliot's suggestions (i.e. point 4) in his previous email
(http://www.spinics.net/lists/fio/msg06561.html ) for speeding things
up and how you are at the mercy of glibc?

On 28 November 2017 at 14:25, Gavriliuk, Anton (HPS Ukraine)
<anton.gavriliuk@hpe.com> wrote:
> Ok, now I fixed that.  Seems to be sequence of the keys is important.  I =
fixed that.  Now I have next issue :-)
>
> I trying to speed up customer=E2=80=99s script.
[snip]
>      lat (usec): min=3D1, max=3D77, avg=3D10.57, stdev=3D 6.01
>     clat percentiles (usec):
>      |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=
=3D[    0],
>      | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=
=3D[    0],
>      | 70.00th=3D[    0], 80.00th=3D[    1], 90.00th=3D[    1], 95.00th=
=3D[    1],
>      | 99.00th=3D[    1], 99.50th=3D[    1], 99.90th=3D[    1], 99.95th=
=3D[    1],
>      | 99.99th=3D[    1]
>     bw (KB  /s): min=3D38528, max=3D118396, per=3D6.36%, avg=3D103720.16,=
 stdev=3D8779.81
>   write: io=3D4559.9GB, bw=3D30234MB/s, iops=3D594518, runt=3D154436msec
>     slat (usec): min=3D1, max=3D787, avg=3D16.46, stdev=3D10.00
>     clat (usec): min=3D0, max=3D680, avg=3D 0.20, stdev=3D 0.41
>      lat (usec): min=3D1, max=3D789, avg=3D16.69, stdev=3D10.00
>     clat percentiles (usec):
>      |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=
=3D[    0],
>      | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=
=3D[    0],
>      | 70.00th=3D[    0], 80.00th=3D[    1], 90.00th=3D[    1], 95.00th=
=3D[    1],
>      | 99.00th=3D[    1], 99.50th=3D[    1], 99.90th=3D[    1], 99.95th=
=3D[    1],
>      | 99.99th=3D[    1]
>     bw (MB  /s): min=3D  731, max=3D 2015, per=3D6.36%, avg=3D1922.69, st=
dev=3D146.41
>     lat (usec) : 2=3D100.00%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.0=
1%
>     lat (usec) : 250=3D0.01%, 750=3D0.01%
>   cpu          : usr=3D35.61%, sys=3D64.37%, ctx=3D2509, majf=3D0, minf=
=3D930
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      issued    : total=3Dr=3D4836244/w=3D91815119/d=3D0, short=3Dr=3D0/w=
=3D0/d=3D0, drop=3Dr=3D0/w=3D0/d=3D0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>
> Run status group 0 (all jobs):
>    READ: io=3D245977MB, aggrb=3D1592.8MB/s, minb=3D1592.8MB/s, maxb=3D159=
2.8MB/s, mint=3D154436msec, maxt=3D154436msec
>   WRITE: io=3D4559.9GB, aggrb=3D30234MB/s, minb=3D30234MB/s, maxb=3D30234=
MB/s, mint=3D154436msec, maxt=3D154436msec
>
> Now I want saving customer=E2=80=99s I/O pattern, but switch to the DAX a=
ccess (/dev/dax0.0 raw device) with mmap engine, trying to bypass OS block =
device & system call layers.  So I modified script,
>
> dl560g10spmem01:~/FIO-PMEM_TestScripts/DAX # /usr/bin/fio --name=3D4-rand=
-rw-3xx --ioengine=3Dmmap --iodepth=3D1 --rw=3Drandrw --refill_buffers --no=
randommap --randrepeat=3D0 --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1=
:256k/1 --rwmixread=3D5 --size=3D290g --numjobs=3D16 --group_reporting --ru=
ntime=3D120 --filename=3D/dev/dax0.0
> 4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D4K-256K/4K-256K/4K-256K, ioengi=
ne=3Dmmap, iodepth=3D1
> ...
> fio-2.12
> Starting 16 processes
> Jobs: 12 (f=3D12): [m(3),_(2),m(1),_(1),m(6),_(1),m(2)] [78.6% done] [130=
4MB/24907MB/0KB /s] [25.7K/490K/0 iops] [eta 00m:33s]
> 4-rand-rw-3xx: (groupid=3D0, jobs=3D16): err=3D 0: pid=3D65032: Tue Nov 2=
8 06:58:09 2017
>   read : io=3D202831MB, bw=3D1690.3MB/s, iops=3D33231, runt=3D120001msec
>     clat (usec): min=3D0, max=3D211, avg=3D 8.88, stdev=3D 5.23
>      lat (usec): min=3D0, max=3D211, avg=3D 8.92, stdev=3D 5.23
>     clat percentiles (usec):
>      |  1.00th=3D[    1],  5.00th=3D[    1], 10.00th=3D[    2], 20.00th=
=3D[    4],
>      | 30.00th=3D[    6], 40.00th=3D[    8], 50.00th=3D[   10], 60.00th=
=3D[   11],
>      | 70.00th=3D[   11], 80.00th=3D[   12], 90.00th=3D[   13], 95.00th=
=3D[   14],
>      | 99.00th=3D[   29], 99.50th=3D[   43], 99.90th=3D[   48], 99.95th=
=3D[   49],
>      | 99.99th=3D[   53]
>     bw (KB  /s): min=3D86408, max=3D159184, per=3D6.36%, avg=3D110086.50,=
 stdev=3D19409.13
>   write: io=3D3764.3GB, bw=3D32121MB/s, iops=3D631607, runt=3D120001msec
>     clat (usec): min=3D0, max=3D744, avg=3D15.16, stdev=3D10.09
>      lat (usec): min=3D0, max=3D744, avg=3D15.21, stdev=3D10.09
>     clat percentiles (usec):
>      |  1.00th=3D[    1],  5.00th=3D[    2], 10.00th=3D[    3], 20.00th=
=3D[    6],
>      | 30.00th=3D[   11], 40.00th=3D[   12], 50.00th=3D[   12], 60.00th=
=3D[   20],
>      | 70.00th=3D[   21], 80.00th=3D[   22], 90.00th=3D[   23], 95.00th=
=3D[   24],
>      | 99.00th=3D[   46], 99.50th=3D[   86], 99.90th=3D[   91], 99.95th=
=3D[   92],
>      | 99.99th=3D[   96]
>     bw (MB  /s): min=3D 1760, max=3D 2737, per=3D6.36%, avg=3D2043.01, st=
dev=3D353.05
>     lat (usec) : 2=3D4.63%, 4=3D8.45%, 10=3D11.27%, 20=3D32.41%, 50=3D42.=
58%
>     lat (usec) : 100=3D0.66%, 250=3D0.01%, 500=3D0.01%, 750=3D0.01%
>   cpu          : usr=3D99.74%, sys=3D0.24%, ctx=3D2791, majf=3D0, minf=3D=
2822710
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      issued    : total=3Dr=3D3987782/w=3D75793478/d=3D0, short=3Dr=3D0/w=
=3D0/d=3D0, drop=3Dr=3D0/w=3D0/d=3D0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>
> Run status group 0 (all jobs):
>    READ: io=3D202831MB, aggrb=3D1690.3MB/s, minb=3D1690.3MB/s, maxb=3D169=
0.3MB/s, mint=3D120001msec, maxt=3D120001msec
>   WRITE: io=3D3764.3GB, aggrb=3D32121MB/s, minb=3D32121MB/s, maxb=3D32121=
MB/s, mint=3D120001msec, maxt=3D120001msec
>
> No huge growth detected =E2=80=93 lat 16.69 vs 15.21, write bw =E2=80=93 =
30234Mb/s vs 32121Mb/s.
>
> Looking to the performance traces,
>
> PID 65043  /usr/bin/fio
>
>     HARDCLOCK entries
>        Count     Pct  State  Function
>         2210  66.29%  USER   __memcpy_avx_unaligned [/lib64/libc-2.22.so]
>         1122  33.65%  USER   UNKNOWN
>            2   0.06%  SYS    pagerange_is_ram_callback
>
>        Count     Pct  HARDCLOCK Stack trace
>        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            2   0.06%  pagerange_is_ram_callback  walk_system_ram_range  p=
at_pagerange_is_ram  lookup_memtype  track_pfn_insert  vmf_insert_pfn_pmd  =
dax_dev_pmd_fault  handle_mm_fault  __do_page_fault  do_page_fault  page_fa=
ult  unknown  |  __memcpy_avx_unaligned
>
>    25.620925 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.644924 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.656923 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.680925 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.692924 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.704925 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.716925 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.728923 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.764924 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>    25.776924 cpu=3D51 pid=3D65043 tgid=3D65043 hardclock state=3DUSER  [l=
ibc-2.22.so]:__memcpy_avx_unaligned+0x2b6
>
> Seems to be there lot's unaligned memory access, any ideas ?
>
> You could also look at the source code for fio to see what it=E2=80=99s d=
oing or put in some printf() statements so you can understand what the actu=
al alignment is.
>
> Anton

--=20
Sitsofe | http://sucs.org/~sits/
