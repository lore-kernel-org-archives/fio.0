Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:40567 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbeC2HYe (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Mar 2018 03:24:34 -0400
Received: by mail-wm0-f42.google.com with SMTP id x4so9546345wmh.5
        for <fio@vger.kernel.org>; Thu, 29 Mar 2018 00:24:33 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: random_generator=lfsr overhead with more disks?
From: Michael Green <mishagreen@gmail.com>
In-Reply-To: <CALjAwxhKo7grzp1_Pyhg8pgUs+MVLbrtWRDWyHrNhCh=mk=gog@mail.gmail.com>
Date: Thu, 29 Mar 2018 00:24:16 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C2C2792-A935-4C69-93CF-640A54B2C2D1@gmail.com>
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <13EF5126-4D32-4706-8495-B193C124826B@gmail.com>
 <BN3PR0401MB145715070B7B9F0C71A902318FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <902A0A2A-8708-4A94-A09E-5D3C9BFB48FF@gmail.com>
 <SN6PR04MB4064D865EBEB79DE2219218D8FD70@SN6PR04MB4064.namprd04.prod.outlook.com>
 <54DB864B-BBFF-4276-B86F-A069F22367F8@gmail.com>
 <CALjAwxhKo7grzp1_Pyhg8pgUs+MVLbrtWRDWyHrNhCh=mk=gog@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>

Sorry for the delay here. Please see below inline.

> On Mar 17, 2018, at 1:42 AM, Sitsofe Wheeler <sitsofe@gmail.com> =
wrote:
>=20
> Could you repeat the problem on a recent version of fio (see
> https://github.com/axboe/fio/releases for what we're up to)?

Sure. Here are the results with latest fio.

With LFSR

[root@sm28 fio-master]# fio --name=3Dglobal --thread=3D1 --direct=3D1 =
--group_reporting=3D1 --iomem_align=3D4k --name=3DPT7 --rw=3Drandrw =
--rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096 --size=3D450GiB=
 --runtime=3D120 =
--filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/e8b4:/dev/e8b5:=
/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e8b10:/dev/e8b11:/dev/e8b12:/=
dev/e8b13:/dev/e8b14:/dev/e8b15' --ioengine=3Dlibaio --numa_cpu_nodes=3D0 =
--random_generator=3Dlfsr
PT7: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) =
4096B-4096B, ioengine=3Dlibaio, iodepth=3D40
...
fio-3.5-80-gb348
Starting 8 threads
Jobs: 8 (f=3D128): [r(8)][100.0%][r=3D3532MiB/s,w=3D0KiB/s][r=3D904k,w=3D0=
 IOPS][eta 00m:00s]
PT7: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D28376: Thu Mar 29 07:35:44 =
2018
   read: IOPS=3D895k, BW=3D3496MiB/s (3666MB/s)(410GiB/120002msec)
    slat (nsec): min=3D1619, max=3D964358, avg=3D3682.85, stdev=3D4806.21
    clat (usec): min=3D25, max=3D13002, avg=3D353.13, stdev=3D192.55
     lat (usec): min=3D35, max=3D13007, avg=3D356.96, stdev=3D192.42
    clat percentiles (usec):
     |  1.00th=3D[   91],  5.00th=3D[  141], 10.00th=3D[  169], =
20.00th=3D[  206],
     | 30.00th=3D[  239], 40.00th=3D[  269], 50.00th=3D[  306], =
60.00th=3D[  347],
     | 70.00th=3D[  400], 80.00th=3D[  474], 90.00th=3D[  603], =
95.00th=3D[  742],
     | 99.00th=3D[ 1020], 99.50th=3D[ 1123], 99.90th=3D[ 1352], =
99.95th=3D[ 1434],
     | 99.99th=3D[ 1647]
   bw (  KiB/s): min=3D373440, max=3D481952, per=3D12.50%, =
avg=3D447480.00, stdev=3D12566.36, samples=3D1918
   iops        : min=3D93360, max=3D120488, avg=3D111869.99, =
stdev=3D3141.58, samples=3D1918
  lat (usec)   : 50=3D0.02%, 100=3D1.45%, 250=3D32.29%, 500=3D49.13%, =
750=3D12.35%
  lat (usec)   : 1000=3D3.60%
  lat (msec)   : 2=3D1.15%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%
  cpu          : usr=3D17.66%, sys=3D49.66%, ctx=3D9942380, majf=3D0, =
minf=3D4898
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.1%, >=3D64=3D0.0%
     issued rwts: total=3D107404316,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D40

Run status group 0 (all jobs):
   READ: bw=3D3496MiB/s (3666MB/s), 3496MiB/s-3496MiB/s =
(3666MB/s-3666MB/s), io=3D410GiB (440GB), run=3D120002-120002msec

Disk stats (read/write):
  e8b0: ios=3D6710489/0, merge=3D0/0, ticks=3D1818366/0, =
in_queue=3D1822176, util=3D99.74%
  e8b1: ios=3D6710487/0, merge=3D0/0, ticks=3D1993186/0, =
in_queue=3D1995781, util=3D99.75%
  e8b2: ios=3D6710490/0, merge=3D0/0, ticks=3D2076054/0, =
in_queue=3D2080427, util=3D99.76%
  e8b3: ios=3D6710491/0, merge=3D0/0, ticks=3D2101963/0, =
in_queue=3D2107744, util=3D99.80%
  e8b4: ios=3D6710493/0, merge=3D0/0, ticks=3D2167111/0, =
in_queue=3D2169552, util=3D99.79%
  e8b5: ios=3D6710496/0, merge=3D0/0, ticks=3D2149837/0, =
in_queue=3D2153109, util=3D99.85%
  e8b6: ios=3D6710497/0, merge=3D0/0, ticks=3D1966688/0, =
in_queue=3D1970940, util=3D99.85%
  e8b7: ios=3D6710496/0, merge=3D0/0, ticks=3D1984307/0, =
in_queue=3D1989317, util=3D99.87%
  e8b8: ios=3D6710497/0, merge=3D0/0, ticks=3D1985081/0, =
in_queue=3D1989662, util=3D99.88%
  e8b9: ios=3D6710498/0, merge=3D0/0, ticks=3D1995815/0, =
in_queue=3D2000669, util=3D99.92%
  e8b10: ios=3D6710498/0, merge=3D0/0, ticks=3D2005176/0, =
in_queue=3D2009368, util=3D99.94%
  e8b11: ios=3D6710498/0, merge=3D0/0, ticks=3D2022758/0, =
in_queue=3D2027682, util=3D99.99%
  e8b12: ios=3D6710499/0, merge=3D0/0, ticks=3D1996747/0, =
in_queue=3D2001118, util=3D100.00%
  e8b13: ios=3D6710502/0, merge=3D0/0, ticks=3D2034211/0, =
in_queue=3D2039490, util=3D100.00%
  e8b14: ios=3D6710502/0, merge=3D0/0, ticks=3D2035394/0, =
in_queue=3D2040469, util=3D100.00%
  e8b15: ios=3D6710505/0, merge=3D0/0, ticks=3D2010598/0, =
in_queue=3D2017014, util=3D100.00%


Without LFSR

[root@sm28 fio-master]# fio --name=3Dglobal --thread=3D1 --direct=3D1 =
--group_reporting=3D1 --iomem_align=3D4k --name=3DPT7 --rw=3Drandrw =
--rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096 --size=3D450GiB=
 --runtime=3D120 =
--filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/e8b4:/dev/e8b5:=
/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e8b10:/dev/e8b11:/dev/e8b12:/=
dev/e8b13:/dev/e8b14:/dev/e8b15' --ioengine=3Dlibaio --numa_cpu_nodes=3D0
PT7: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) =
4096B-4096B, ioengine=3Dlibaio, iodepth=3D40
...
fio-3.5-80-gb348
Starting 8 threads
Jobs: 8 (f=3D128): [r(8)][100.0%][r=3D3729MiB/s,w=3D0KiB/s][r=3D955k,w=3D0=
 IOPS][eta 00m:00s]
PT7: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D28564: Thu Mar 29 07:40:09 =
2018
   read: IOPS=3D943k, BW=3D3684MiB/s (3863MB/s)(432GiB/120007msec)
    slat (nsec): min=3D1656, max=3D1601.7k, avg=3D4342.55, stdev=3D6792.60=

    clat (usec): min=3D31, max=3D12646, avg=3D333.84, stdev=3D102.52
     lat (usec): min=3D38, max=3D12648, avg=3D338.34, stdev=3D101.86
    clat percentiles (usec):
     |  1.00th=3D[  120],  5.00th=3D[  167], 10.00th=3D[  204], =
20.00th=3D[  249],
     | 30.00th=3D[  281], 40.00th=3D[  310], 50.00th=3D[  334], =
60.00th=3D[  363],
     | 70.00th=3D[  392], 80.00th=3D[  420], 90.00th=3D[  457], =
95.00th=3D[  482],
     | 99.00th=3D[  545], 99.50th=3D[  594], 99.90th=3D[  865], =
99.95th=3D[  955],
     | 99.99th=3D[ 1254]
   bw (  KiB/s): min=3D390520, max=3D518192, per=3D12.50%, =
avg=3D471560.73, stdev=3D13752.55, samples=3D1914
   iops        : min=3D97630, max=3D129548, avg=3D117890.14, =
stdev=3D3438.13, samples=3D1914
  lat (usec)   : 50=3D0.01%, 100=3D0.37%, 250=3D20.22%, 500=3D76.31%, =
750=3D2.87%
  lat (usec)   : 1000=3D0.20%
  lat (msec)   : 2=3D0.03%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%
  cpu          : usr=3D23.47%, sys=3D59.78%, ctx=3D10930907, majf=3D0, =
minf=3D299365
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.1%, >=3D64=3D0.0%
     issued rwts: total=3D113187098,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D40

Run status group 0 (all jobs):
   READ: bw=3D3684MiB/s (3863MB/s), 3684MiB/s-3684MiB/s =
(3863MB/s-3863MB/s), io=3D432GiB (464GB), run=3D120007-120007msec

Disk stats (read/write):
  e8b0: ios=3D7070562/0, merge=3D0/0, ticks=3D1862741/0, =
in_queue=3D1868144, util=3D99.78%
  e8b1: ios=3D7070570/0, merge=3D0/0, ticks=3D1996123/0, =
in_queue=3D1999170, util=3D99.79%
  e8b2: ios=3D7070580/0, merge=3D0/0, ticks=3D2019351/0, =
in_queue=3D2024920, util=3D99.78%
  e8b3: ios=3D7070581/0, merge=3D0/0, ticks=3D2018430/0, =
in_queue=3D2024167, util=3D99.80%
  e8b4: ios=3D7070585/0, merge=3D0/0, ticks=3D2069985/0, =
in_queue=3D2072530, util=3D99.78%
  e8b5: ios=3D7070586/0, merge=3D0/0, ticks=3D2032085/0, =
in_queue=3D2035097, util=3D99.81%
  e8b6: ios=3D7070586/0, merge=3D0/0, ticks=3D1838167/0, =
in_queue=3D1842676, util=3D99.79%
  e8b7: ios=3D7070589/0, merge=3D0/0, ticks=3D1838162/0, =
in_queue=3D1843175, util=3D99.83%
  e8b8: ios=3D7070587/0, merge=3D0/0, ticks=3D1837259/0, =
in_queue=3D1842283, util=3D99.86%
  e8b9: ios=3D7070595/0, merge=3D0/0, ticks=3D1836983/0, =
in_queue=3D1841398, util=3D99.89%
  e8b10: ios=3D7070601/0, merge=3D0/0, ticks=3D1835967/0, =
in_queue=3D1840679, util=3D99.91%
  e8b11: ios=3D7070605/0, merge=3D0/0, ticks=3D1835374/0, =
in_queue=3D1840121, util=3D99.94%
  e8b12: ios=3D7070609/0, merge=3D0/0, ticks=3D1834964/0, =
in_queue=3D1839546, util=3D99.98%
  e8b13: ios=3D7070609/0, merge=3D0/0, ticks=3D1835191/0, =
in_queue=3D1839604, util=3D100.00%
  e8b14: ios=3D7070608/0, merge=3D0/0, ticks=3D1835130/0, =
in_queue=3D1840084, util=3D100.00%
  e8b15: ios=3D7070611/0, merge=3D0/0, ticks=3D1835606/0, =
in_queue=3D1842956, util=3D100.00%


Initially, I thought that there is a clear improvement here as the =
latency gap is smaller now. But then I decided to follow your advice of =
stripping the command down to the bare minimum.

>  It would also
> help if you strip the line you are using down to the bare minimum that
> still shows the problem (e.g. if you can remove numa, lock it to CPUs
> make it happen on a pure randread workload etc).


Now when it comes to removing the flags, I didn=E2=80=99t want to remove =
the --numa flag because in E8 architecture that may adversely affect =
latency standard deviation. Reason being that FIO may occasionally get =
scheduled to run on the same core where where e8 driver is running. So =
the two flags that I could get rid of were --iomem_align and --size.  =
After experimenting a bit, I eventually set out to run a series of tests =
with every permutation of the two flags, including a test without them. =
For every permutation, the test was repeated 3 times and latencies =
recorded. Nothing else was running on either the storage controller or =
the host during the testing.=20

base command was=20
fio --name=3Dglobal --thread=3D1 --direct=3D1 --group_reporting=3D1 =
--name=3DPT7 --rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 =
--bs=3D4096 --runtime=3D120 =
--filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/e8b4:/dev/e8b5:=
/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e
8b10:/dev/e8b11:/dev/e8b12:/dev/e8b13:/dev/e8b14:/dev/e8b15' =
--ioengine=3Dlibaio --random_generator=3Dlfsr

and=20

fio --name=3Dglobal --thread=3D1 --direct=3D1 --group_reporting=3D1 =
--name=3DPT7 --rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 =
--bs=3D4096 --runtime=3D120 =
--filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/e8b4:/dev/e8b5:=
/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e
8b10:/dev/e8b11:/dev/e8b12:/dev/e8b13:/dev/e8b14:/dev/e8b15' =
--ioengine=3Dlibaio=20

The only difference is  --random_generator=3Dlfsr or not.
The iomem and size flags were iomem_align=3D4k and size=3D450GiB

Here are the latency numbers I=E2=80=99ve got:

LFSR

+ iomem + size =3D 348.07, 347.68, 347.59
nothing =3D 344.28, 344.84, 345.04
+ size=3D349.28, 348.37, 348.37
+ iomem =3D 346.81, 346.05, 344.74

NO LFSR

+ iomem + size =3D  344.03, 344.29, 345.47
nothing =3D 347.05, 346.00, 346.03
+ size =3D 345.43, 343.55, 343.98
+ iomem =3D 347.87, 347.02, 347.84

It appears that with both flags, LFSR is still behind NO LFSR even so =
minimally. When both flags are omitted the picture reverses.=20
Looking at the overall picture, I cannot identify clear winner here. =
It=E2=80=99s almost like the differences are within measurement error.




> If it
> happens there we could do with the output from Linux's perf

Not sure what =E2=80=9CLinux=E2=80=99s perf=E2=80=9D exactly means.


Michael

