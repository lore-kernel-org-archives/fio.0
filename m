Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35553 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932659AbdDFGNM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Apr 2017 02:13:12 -0400
Received: by mail-oi0-f51.google.com with SMTP id f193so40444386oib.2
        for <fio@vger.kernel.org>; Wed, 05 Apr 2017 23:13:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b83e861c86f9423b947b12336d08e75b9e6d80d437aa41ab8775f7673db0ecf8BL2PR02MB19712B5A9DD0B600FC59ABC8810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
References: <b83e861c86f9423b947b12336d08e75b9e6d80d437aa41ab8775f7673db0ecf8BL2PR02MB19712B5A9DD0B600FC59ABC8810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Thu, 6 Apr 2017 14:13:10 +0800
Message-ID: <CABtFm2UGCb55eCivd9rG6f8Nz7h0HNTK+cCFY-BwoCo3q8+bYA@mail.gmail.com>
Subject: Re: FIO does 2x IOPS with 'bssplit' option and 'rw=randwrite or rw=randread'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: GV Govindasamy <gv.govindasamy@nutanix.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Could you remove rate_process=3Dpoisson and try, with the same profile
without rate_poisson, i am getting a bit less than 100 IOPS expected.

# fio -name=3Drate
--filename=3D/dev/mapper/3600601602d003e0002cde5580011c8fb
--ioengine=3Dlibaio --direct=3D1 --fill_device=3D1 --group_reporting
--rw=3Drandwrite --rate_iops=3D100 --iodepth=3D8 --norandommap
--bsrange=3D8k-16k --
bssplit=3D8k/90:16k/10

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.25    0.00    0.38    1.13    0.00   98.24

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
dm-18             0.00     0.00    0.00   91.00     0.00   800.00
17.58     0.38    4.20    0.00    4.20   3.96  36.00

--
Srinivasa R Chamarthy


On Thu, Apr 6, 2017 at 12:09 AM, GV Govindasamy
<gv.govindasamy@nutanix.com> wrote:
>
> Hello All
>
> I would like to know what I observe is a bug or by design that I don't un=
derstand. I expect to generate 100 random read ops or 100 random write ops =
in the following examples with 90% 8k and 10% 16k. FIO also appears to targ=
et  for 100 IOPS, but ended up doing 2x in actual workload.
>
> Thanks,
> +GV
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> $ ./fio-2.19 --version (compiled with: ./configure --build-static; make o=
n CentOS release 6.7/3.10.0-229)
> fio-2.19
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> $ cat output/fio/bssplit_readtest.fio
> [global]
> ioengine=3Dlibaio
> direct=3D1
> time_based
> norandommap
> group_reporting
> disk_util=3D0
> continue_on_error=3Dall
> rate_process=3Dpoisson
>
>
> [db-oltp-w]
> bssplit=3D8k/90:16k/10,,
> size=3D128G
> filename=3D/dev/sdg
> rw=3Drandread
> iodepth=3D8
> rate_iops=3D100
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> $ iostat -x 2 sdg
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.13    0.00    0.13    1.63    0.00   98.12
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00  191.00    0.00  3392.00     0.00    17.7=
6     0.09    0.45    0.45    0.00   0.41   7.75
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.25    0.00    0.25    1.75    0.00   97.74
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00  193.00    0.00  3424.00     0.00    17.7=
4     0.08    0.42    0.42    0.00   0.39   7.50
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.13    0.00    0.25    1.88    0.00   97.74
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00  213.50    0.00  3672.00     0.00    17.2=
0     0.10    0.45    0.45    0.00   0.40   8.45 =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> $ sudo ./fio-2.19 --runtime 120 --eta-newline=3D30 output/fio/bssplit_rea=
dtest.fio
> db-oltp-w: (g=3D0): rw=3Drandread, bs=3D(R) 8192B-16.0KiB, (W) 4096B-4096=
B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D8
> fio-2.19
> Starting 1 process
> Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][26.4%][r=3D1632KiB/s,w=3D0KiB/s][r=3D=
194,w=3D0 IOPS][eta 01m:29s]
> Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][51.2%][r=3D1648KiB/s,w=3D0KiB/s][r=3D=
190,w=3D0 IOPS][eta 00m:59s]
> Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][76.0%][r=3D1760KiB/s,w=3D0KiB/s][r=3D=
193,w=3D0 IOPS][eta 00m:29s]
> Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][100.0%][r=3D1816KiB/s,w=3D0KiB/s][r=
=3D202,w=3D0 IOPS][eta 00m:00s]
> db-oltp-w: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1605: Wed Apr  5 15:5=
3:00 2017
>    read: IOPS=3D200, BW=3D1765KiB/s (1808kB/s)(207MiB/120013msec)
>     slat (usec): min=3D3, max=3D117, avg=3D30.53, stdev=3D11.20
>     clat (usec): min=3D120, max=3D8658, avg=3D413.81, stdev=3D216.67
>      lat (usec): min=3D139, max=3D8697, avg=3D444.34, stdev=3D218.71
>     clat percentiles (usec):
>      |  1.00th=3D[  175],  5.00th=3D[  221], 10.00th=3D[  251], 20.00th=
=3D[  290],
>      | 30.00th=3D[  338], 40.00th=3D[  382], 50.00th=3D[  406], 60.00th=
=3D[  434],
>      | 70.00th=3D[  462], 80.00th=3D[  498], 90.00th=3D[  556], 95.00th=
=3D[  620],
>      | 99.00th=3D[  756], 99.50th=3D[  932], 99.90th=3D[ 3632], 99.95th=
=3D[ 4704],
>      | 99.99th=3D[ 6368]
>     lat (usec) : 250=3D9.84%, 500=3D70.75%, 750=3D18.34%, 1000=3D0.60%
>     lat (msec) : 2=3D0.26%, 4=3D0.12%, 10=3D0.08%
>   cpu          : usr=3D0.37%, sys=3D0.84%, ctx=3D44140, majf=3D0, minf=3D=
60
>   IO depths    : 1=3D91.3%, 2=3D8.6%, 4=3D0.1%, 8=3D0.1%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      issued rwt: total=3D24072,0,0, short=3D0,0,0, dropped=3D0,0,0
>      errors    : total=3D0, first_error=3D0/<Success>
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8
>
> Run status group 0 (all jobs):
>    READ: bw=3D1765KiB/s (1808kB/s), 1765KiB/s-1765KiB/s (1808kB/s-1808kB/=
s), io=3D207MiB (217MB), run=3D120013-120013msec
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> $ cat output/fio/bssplit_writetest.fio
> [global]
> ioengine=3Dlibaio
> direct=3D1
> time_based
> norandommap
> group_reporting
> disk_util=3D0
> continue_on_error=3Dall
> rate_process=3Dpoisson
>
> [db-oltp-w]
> bssplit=3D,8k/90:16k/10,
> size=3D128G
> filename=3D/dev/sdg
> rw=3Drandwrite
> iodepth=3D8
> rate_iops=3D100
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> $ iostat -x 2 sdg
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.13    0.00    0.25    4.89    0.00   94.74
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00    0.00  195.00     0.00  3480.00    17.8=
5     0.28    1.43    0.00    1.43   1.06  20.65
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.13    0.00    0.38    4.38    0.00   95.12
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00    0.00  202.50     0.00  3632.00    17.9=
4     0.24    1.18    0.00    1.18   0.92  18.60
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00    0.25    3.76    0.00   95.98
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00    0.00  179.00     0.00  3072.00    17.1=
6     0.21    1.15    0.00    1.15   0.92  16.45
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.13    0.00    0.25    4.52    0.00   95.11
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdg               0.00     0.00    0.00  199.50     0.00  3472.00    17.4=
0     0.25    1.24    0.00    1.24   0.98  19.55
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> $ sudo ./fio-2.19 --runtime 120 --eta-newline=3D30 output/fio/bssplit_wri=
tetest.fio
> db-oltp-w: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 8192B-16.0K=
iB, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D8
> fio-2.19
> Starting 1 process
> Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][26.4%][r=3D0KiB/s,w=3D1632KiB/s][r=3D=
0,w=3D194 IOPS][eta 01m:29s]
> Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][51.2%][r=3D0KiB/s,w=3D1648KiB/s][r=3D=
0,w=3D190 IOPS][eta 00m:59s]
> Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][76.0%][r=3D0KiB/s,w=3D1760KiB/s][r=3D=
0,w=3D193 IOPS][eta 00m:29s]
> Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][100.0%][r=3D0KiB/s,w=3D1816KiB/s][r=
=3D0,w=3D202 IOPS][eta 00m:00s]
> db-oltp-w: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1616: Wed Apr  5 15:5=
7:04 2017
>   write: IOPS=3D200, BW=3D1765KiB/s (1807kB/s)(207MiB/120014msec)
>     slat (usec): min=3D5, max=3D125, avg=3D31.91, stdev=3D12.20
>     clat (usec): min=3D500, max=3D26437, avg=3D1170.96, stdev=3D849.81
>      lat (usec): min=3D516, max=3D26448, avg=3D1202.87, stdev=3D849.55
>     clat percentiles (usec):
>      |  1.00th=3D[  644],  5.00th=3D[  732], 10.00th=3D[  788], 20.00th=
=3D[  868],
>      | 30.00th=3D[  932], 40.00th=3D[  996], 50.00th=3D[ 1048], 60.00th=
=3D[ 1128],
>      | 70.00th=3D[ 1192], 80.00th=3D[ 1288], 90.00th=3D[ 1448], 95.00th=
=3D[ 1608],
>      | 99.00th=3D[ 4832], 99.50th=3D[ 5920], 99.90th=3D[12480], 99.95th=
=3D[13760],
>      | 99.99th=3D[26496]
>     lat (usec) : 750=3D6.15%, 1000=3D34.93%
>     lat (msec) : 2=3D56.35%, 4=3D1.15%, 10=3D1.27%, 20=3D0.11%, 50=3D0.03=
%
>   cpu          : usr=3D0.39%, sys=3D0.79%, ctx=3D38562, majf=3D0, minf=3D=
34
>   IO depths    : 1=3D80.2%, 2=3D19.3%, 4=3D0.4%, 8=3D0.1%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      issued rwt: total=3D0,24072,0, short=3D0,0,0, dropped=3D0,0,0
>      errors    : total=3D0, first_error=3D0/<Success>
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8
>
> Run status group 0 (all jobs):
>   WRITE: bw=3D1765KiB/s (1807kB/s), 1765KiB/s-1765KiB/s (1807kB/s-1807kB/=
s), io=3D207MiB (217MB), run=3D120014-120014msec
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
