Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bl2nam02on0105.outbound.protection.outlook.com ([104.47.38.105]:26600
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932517AbdDEQJS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Apr 2017 12:09:18 -0400
From: GV Govindasamy <gv.govindasamy@nutanix.com>
Subject: FIO does 2x IOPS with 'bssplit' option and 'rw=randwrite or
 rw=randread'
Date: Wed, 5 Apr 2017 16:09:16 +0000
Message-ID: <b83e861c86f9423b947b12336d08e75b9e6d80d437aa41ab8775f7673db0ecf8BL2PR02MB19712B5A9DD0B600FC59ABC8810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <279D9F0BDD7F4240A750DE7AB449BE53@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


Hello All

I would like to know what I observe is a bug or by design that I don't unde=
rstand. I expect to generate 100 random read ops or 100 random write ops in=
 the following examples with 90% 8k and 10% 16k. FIO also appears to target=
  for 100 IOPS, but ended up doing 2x in actual workload.=A0

Thanks,
+GV

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ ./fio-2.19 --version (compiled with:=A0./configure --build-static; make o=
n=A0CentOS release 6.7/3.10.0-229)
fio-2.19=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ cat output/fio/bssplit_readtest.fio
[global]
ioengine=3Dlibaio
direct=3D1
time_based
norandommap
group_reporting
disk_util=3D0
continue_on_error=3Dall
rate_process=3Dpoisson


[db-oltp-w]
bssplit=3D8k/90:16k/10,,
size=3D128G
filename=3D/dev/sdg
rw=3Drandread
iodepth=3D8
rate_iops=3D100

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ iostat -x 2 sdg

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.13 =A0 =A00.00 =A0 =A00.13 =A0 =A01.63 =A0 =A00.00=
 =A0 98.12
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0191.00 =A0 =A00.00 =A0=
3392.00 =A0 =A0 0.00 =A0 =A017.76 =A0 =A0 0.09 =A0 =A00.45 =A0 =A00.45 =A0 =
=A00.00 =A0 0.41 =A0 7.75

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.25 =A0 =A00.00 =A0 =A00.25 =A0 =A01.75 =A0 =A00.00=
 =A0 97.74
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0193.00 =A0 =A00.00 =A0=
3424.00 =A0 =A0 0.00 =A0 =A017.74 =A0 =A0 0.08 =A0 =A00.42 =A0 =A00.42 =A0 =
=A00.00 =A0 0.39 =A0 7.50

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.13 =A0 =A00.00 =A0 =A00.25 =A0 =A01.88 =A0 =A00.00=
 =A0 97.74
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0213.50 =A0 =A00.00 =A0=
3672.00 =A0 =A0 0.00 =A0 =A017.20 =A0 =A0 0.10 =A0 =A00.45 =A0 =A00.45 =A0 =
=A00.00 =A0 0.40 =A0 8.45 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

$ sudo ./fio-2.19 --runtime 120 --eta-newline=3D30 output/fio/bssplit_readt=
est.fio
db-oltp-w: (g=3D0): rw=3Drandread, bs=3D(R) 8192B-16.0KiB, (W) 4096B-4096B,=
 (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D8
fio-2.19
Starting 1 process
Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][26.4%][r=3D1632KiB/s,w=3D0KiB/s][r=3D19=
4,w=3D0 IOPS][eta 01m:29s]
Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][51.2%][r=3D1648KiB/s,w=3D0KiB/s][r=3D19=
0,w=3D0 IOPS][eta 00m:59s]
Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][76.0%][r=3D1760KiB/s,w=3D0KiB/s][r=3D19=
3,w=3D0 IOPS][eta 00m:29s]
Jobs: 1 (f=3D1), 0-100 IOPS: [r(1)][100.0%][r=3D1816KiB/s,w=3D0KiB/s][r=3D2=
02,w=3D0 IOPS][eta 00m:00s]
db-oltp-w: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1605: Wed Apr =A05 15:5=
3:00 2017
=A0 =A0read: IOPS=3D200, BW=3D1765KiB/s (1808kB/s)(207MiB/120013msec)
=A0 =A0 slat (usec): min=3D3, max=3D117, avg=3D30.53, stdev=3D11.20
=A0 =A0 clat (usec): min=3D120, max=3D8658, avg=3D413.81, stdev=3D216.67
=A0 =A0 =A0lat (usec): min=3D139, max=3D8697, avg=3D444.34, stdev=3D218.71
=A0 =A0 clat percentiles (usec):
=A0 =A0 =A0| =A01.00th=3D[ =A0175], =A05.00th=3D[ =A0221], 10.00th=3D[ =A02=
51], 20.00th=3D[ =A0290],
=A0 =A0 =A0| 30.00th=3D[ =A0338], 40.00th=3D[ =A0382], 50.00th=3D[ =A0406],=
 60.00th=3D[ =A0434],
=A0 =A0 =A0| 70.00th=3D[ =A0462], 80.00th=3D[ =A0498], 90.00th=3D[ =A0556],=
 95.00th=3D[ =A0620],
=A0 =A0 =A0| 99.00th=3D[ =A0756], 99.50th=3D[ =A0932], 99.90th=3D[ 3632], 9=
9.95th=3D[ 4704],
=A0 =A0 =A0| 99.99th=3D[ 6368]
=A0 =A0 lat (usec) : 250=3D9.84%, 500=3D70.75%, 750=3D18.34%, 1000=3D0.60%
=A0 =A0 lat (msec) : 2=3D0.26%, 4=3D0.12%, 10=3D0.08%
=A0 cpu =A0 =A0 =A0 =A0 =A0: usr=3D0.37%, sys=3D0.84%, ctx=3D44140, majf=3D=
0, minf=3D60
=A0 IO depths =A0 =A0: 1=3D91.3%, 2=3D8.6%, 4=3D0.1%, 8=3D0.1%, 16=3D0.0%, =
32=3D0.0%, >=3D64=3D0.0%
=A0 =A0 =A0submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%
=A0 =A0 =A0complete =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
=A0 =A0 =A0issued rwt: total=3D24072,0,0, short=3D0,0,0, dropped=3D0,0,0
=A0 =A0 =A0errors =A0 =A0: total=3D0, first_error=3D0/<Success>
=A0 =A0 =A0latency =A0 : target=3D0, window=3D0, percentile=3D100.00%, dept=
h=3D8

Run status group 0 (all jobs):
=A0 =A0READ: bw=3D1765KiB/s (1808kB/s), 1765KiB/s-1765KiB/s (1808kB/s-1808k=
B/s), io=3D207MiB (217MB), run=3D120013-120013msec
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

$ cat output/fio/bssplit_writetest.fio
[global]
ioengine=3Dlibaio
direct=3D1
time_based
norandommap
group_reporting
disk_util=3D0
continue_on_error=3Dall
rate_process=3Dpoisson

[db-oltp-w]
bssplit=3D,8k/90:16k/10,
size=3D128G
filename=3D/dev/sdg
rw=3Drandwrite
iodepth=3D8
rate_iops=3D100
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ iostat -x 2 sdg

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.13 =A0 =A00.00 =A0 =A00.25 =A0 =A04.89 =A0 =A00.00=
 =A0 94.74
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0195.00 =A0=
 =A0 0.00 =A03480.00 =A0 =A017.85 =A0 =A0 0.28 =A0 =A01.43 =A0 =A00.00 =A0 =
=A01.43 =A0 1.06 =A020.65

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.13 =A0 =A00.00 =A0 =A00.38 =A0 =A04.38 =A0 =A00.00=
 =A0 95.12
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0202.50 =A0=
 =A0 0.00 =A03632.00 =A0 =A017.94 =A0 =A0 0.24 =A0 =A01.18 =A0 =A00.00 =A0 =
=A01.18 =A0 0.92 =A018.60

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.00 =A0 =A00.00 =A0 =A00.25 =A0 =A03.76 =A0 =A00.00=
 =A0 95.98
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0179.00 =A0=
 =A0 0.00 =A03072.00 =A0 =A017.16 =A0 =A0 0.21 =A0 =A01.15 =A0 =A00.00 =A0 =
=A01.15 =A0 0.92 =A016.45

avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
=A0 =A0 =A0 =A0 =A0 =A00.13 =A0 =A00.00 =A0 =A00.25 =A0 =A04.52 =A0 =A00.00=
 =A0 95.11
Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 rsec/=
s =A0 wsec/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
sdg =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0199.50 =A0=
 =A0 0.00 =A03472.00 =A0 =A017.40 =A0 =A0 0.25 =A0 =A01.24 =A0 =A00.00 =A0 =
=A01.24 =A0 0.98 =A019.55=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

$ sudo ./fio-2.19 --runtime 120 --eta-newline=3D30 output/fio/bssplit_write=
test.fio
db-oltp-w: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 8192B-16.0KiB=
, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D8
fio-2.19
Starting 1 process
Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][26.4%][r=3D0KiB/s,w=3D1632KiB/s][r=3D0,=
w=3D194 IOPS][eta 01m:29s]
Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][51.2%][r=3D0KiB/s,w=3D1648KiB/s][r=3D0,=
w=3D190 IOPS][eta 00m:59s]
Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][76.0%][r=3D0KiB/s,w=3D1760KiB/s][r=3D0,=
w=3D193 IOPS][eta 00m:29s]
Jobs: 1 (f=3D1), 0-100 IOPS: [w(1)][100.0%][r=3D0KiB/s,w=3D1816KiB/s][r=3D0=
,w=3D202 IOPS][eta 00m:00s]
db-oltp-w: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1616: Wed Apr =A05 15:5=
7:04 2017
=A0 write: IOPS=3D200, BW=3D1765KiB/s (1807kB/s)(207MiB/120014msec)
=A0 =A0 slat (usec): min=3D5, max=3D125, avg=3D31.91, stdev=3D12.20
=A0 =A0 clat (usec): min=3D500, max=3D26437, avg=3D1170.96, stdev=3D849.81
=A0 =A0 =A0lat (usec): min=3D516, max=3D26448, avg=3D1202.87, stdev=3D849.5=
5
=A0 =A0 clat percentiles (usec):
=A0 =A0 =A0| =A01.00th=3D[ =A0644], =A05.00th=3D[ =A0732], 10.00th=3D[ =A07=
88], 20.00th=3D[ =A0868],
=A0 =A0 =A0| 30.00th=3D[ =A0932], 40.00th=3D[ =A0996], 50.00th=3D[ 1048], 6=
0.00th=3D[ 1128],
=A0 =A0 =A0| 70.00th=3D[ 1192], 80.00th=3D[ 1288], 90.00th=3D[ 1448], 95.00=
th=3D[ 1608],
=A0 =A0 =A0| 99.00th=3D[ 4832], 99.50th=3D[ 5920], 99.90th=3D[12480], 99.95=
th=3D[13760],
=A0 =A0 =A0| 99.99th=3D[26496]
=A0 =A0 lat (usec) : 750=3D6.15%, 1000=3D34.93%
=A0 =A0 lat (msec) : 2=3D56.35%, 4=3D1.15%, 10=3D1.27%, 20=3D0.11%, 50=3D0.=
03%
=A0 cpu =A0 =A0 =A0 =A0 =A0: usr=3D0.39%, sys=3D0.79%, ctx=3D38562, majf=3D=
0, minf=3D34
=A0 IO depths =A0 =A0: 1=3D80.2%, 2=3D19.3%, 4=3D0.4%, 8=3D0.1%, 16=3D0.0%,=
 32=3D0.0%, >=3D64=3D0.0%
=A0 =A0 =A0submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%
=A0 =A0 =A0complete =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
=A0 =A0 =A0issued rwt: total=3D0,24072,0, short=3D0,0,0, dropped=3D0,0,0
=A0 =A0 =A0errors =A0 =A0: total=3D0, first_error=3D0/<Success>
=A0 =A0 =A0latency =A0 : target=3D0, window=3D0, percentile=3D100.00%, dept=
h=3D8

Run status group 0 (all jobs):
=A0 WRITE: bw=3D1765KiB/s (1807kB/s), 1765KiB/s-1765KiB/s (1807kB/s-1807kB/=
s), io=3D207MiB (217MB), run=3D120014-120014msec
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
