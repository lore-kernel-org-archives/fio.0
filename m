Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2nam03on0138.outbound.protection.outlook.com ([104.47.42.138]:45338
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753803AbdDEQZt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Apr 2017 12:25:49 -0400
From: GV Govindasamy <gv.govindasamy@nutanix.com>
Subject: FIO achieves only 50:50 of read:write IOPS when rwmix is not 50:50
 and achieves only about 40% of total IOPS
Date: Wed, 5 Apr 2017 16:25:46 +0000
Message-ID: <BL2PR02MB19714074E460C8EA219FFA85810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello All

In the following example, I would like 90 read ops and 10 write ops. Regard=
less of the values in "bssplit" or "bs" and "rwmixread/rwmixwrite" values, =
not able to see FIO doing 90:10 read:writes and total ops turns out to be ~=
20+~20 =3D ~40 IOPS instead of 100.

Am I missing something here?

Thanks
+GV

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ ./fio-2.19 --version (compiled with: ./configure --build-static; make on =
CentOS release 6.7/3.10.0-229)
fio-2.19

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
$ cat output/fio/bssplit_rwmix.fio
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
bssplit=3D8k/90:16k/10
size=3D128G
filename=3D/dev/sdg
rw=3Drandrw
iodepth=3D8
rwmixread=3D90
rwmixwrite=3D10
rate_iops=3D90,10,0

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
$ iostat -x 2 sdg
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.13    0.88    0.00   99.00
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz =
avgqu-sz   await r_await w_await  svctm  %util
sdg               0.00     0.00   17.50   17.50   288.00   312.00    17.14 =
    0.03    0.93    0.31    1.54   0.93   3.25

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.12    0.00    0.12    1.00    0.00   98.75
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz =
avgqu-sz   await r_await w_await  svctm  %util
sdg               0.00     0.00   20.00   19.50   352.00   336.00    17.42 =
    0.04    1.03    0.45    1.62   0.92   3.65

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.00    1.00    0.00   99.00
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz =
avgqu-sz   await r_await w_await  svctm  %util
sdg               0.00     0.00   22.00   21.00   400.00   352.00    17.49 =
    0.05    1.12    0.48    1.79   1.06   4.55

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
$ sudo ./fio-2.19 --runtime 120 --eta-newline=3D30 output/fio/bssplit_rwmix=
.fio
db-oltp-w: (g=3D0): rw=3Drandrw, bs=3D(R) 8192B-16.0KiB, (W) 8192B-16.0KiB,=
 (T) 8192B-16.0KiB, ioengine=3Dlibaio, iodepth=3D8
fio-2.19
Starting 1 process
Jobs: 1 (f=3D1), 0-100 IOPS: [m(1)][26.4%][r=3D200KiB/s,w=3D176KiB/s][r=3D2=
2,w=3D21 IOPS][eta 01m:29s]
Jobs: 1 (f=3D1), 0-100 IOPS: [m(1)][51.2%][r=3D176KiB/s,w=3D168KiB/s][r=3D2=
0,w=3D20 IOPS][eta 00m:59s]
Jobs: 1 (f=3D1), 0-100 IOPS: [m(1)][76.0%][r=3D128KiB/s,w=3D128KiB/s][r=3D1=
6,w=3D16 IOPS][eta 00m:29s]
Jobs: 1 (f=3D1), 0-100 IOPS: [m(1)][100.0%][r=3D144KiB/s,w=3D112KiB/s][r=3D=
15,w=3D14 IOPS][eta 00m:00s]
db-oltp-w: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1663: Wed Apr  5 16:15:=
29 2017
   read: IOPS=3D18, BW=3D164KiB/s (168kB/s)(19.3MiB/120160msec)
    slat (usec): min=3D5, max=3D72, avg=3D32.59, stdev=3D10.66
    clat (usec): min=3D195, max=3D6884, avg=3D520.15, stdev=3D342.01
     lat (usec): min=3D211, max=3D6915, avg=3D552.73, stdev=3D341.11
    clat percentiles (usec):
     |  1.00th=3D[  235],  5.00th=3D[  294], 10.00th=3D[  342], 20.00th=3D[=
  398],
     | 30.00th=3D[  430], 40.00th=3D[  454], 50.00th=3D[  482], 60.00th=3D[=
  516],
     | 70.00th=3D[  548], 80.00th=3D[  596], 90.00th=3D[  668], 95.00th=3D[=
  756],
     | 99.00th=3D[  972], 99.50th=3D[ 3120], 99.90th=3D[ 5280], 99.95th=3D[=
 6304],
     | 99.99th=3D[ 6880]
  write: IOPS=3D18, BW=3D161KiB/s (165kB/s)(18.9MiB/120160msec)
    slat (usec): min=3D8, max=3D101, avg=3D40.08, stdev=3D 9.08
    clat (usec): min=3D817, max=3D12413, avg=3D1720.19, stdev=3D692.15
     lat (usec): min=3D853, max=3D12449, avg=3D1760.27, stdev=3D692.64
    clat percentiles (usec):
     |  1.00th=3D[ 1032],  5.00th=3D[ 1176], 10.00th=3D[ 1256], 20.00th=3D[=
 1384],
     | 30.00th=3D[ 1480], 40.00th=3D[ 1576], 50.00th=3D[ 1640], 60.00th=3D[=
 1704],
     | 70.00th=3D[ 1800], 80.00th=3D[ 1896], 90.00th=3D[ 2040], 95.00th=3D[=
 2192],
     | 99.00th=3D[ 5408], 99.50th=3D[ 6496], 99.90th=3D[ 8512], 99.95th=3D[=
 9920],
     | 99.99th=3D[12352]
    lat (usec) : 250=3D0.86%, 500=3D26.90%, 750=3D19.85%, 1000=3D2.40%
    lat (msec) : 2=3D43.75%, 4=3D5.22%, 10=3D1.00%, 20=3D0.02%
  cpu          : usr=3D0.08%, sys=3D0.17%, ctx=3D8407, majf=3D0, minf=3D34
  IO depths    : 1=3D91.7%, 2=3D8.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.0%, 32=3D0=
.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwt: total=3D2213,2196,0, short=3D0,0,0, dropped=3D0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8

Run status group 0 (all jobs):
   READ: bw=3D164KiB/s (168kB/s), 164KiB/s-164KiB/s (168kB/s-168kB/s), io=
=3D19.3MiB (20.2MB), run=3D120160-120160msec
  WRITE: bw=3D161KiB/s (165kB/s), 161KiB/s-161KiB/s (165kB/s-165kB/s), io=
=3D18.9MiB (19.8MB), run=3D120160-120160msec
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=
