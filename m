Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36828 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbeCMTX5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Mar 2018 15:23:57 -0400
Received: by mail-wm0-f42.google.com with SMTP id i194so7263wmg.1
        for <fio@vger.kernel.org>; Tue, 13 Mar 2018 12:23:56 -0700 (PDT)
Received: from [192.168.29.142] (24-151-137-62.dhcp.oxfr.ma.charter.com. [24.151.137.62])
        by smtp.gmail.com with ESMTPSA id 7sm1368220wry.18.2018.03.13.12.23.53
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Mar 2018 12:23:54 -0700 (PDT)
From: Michael Green <mishagreen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: random_generator=lfsr overhead with more disks?
Message-Id: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
Date: Tue, 13 Mar 2018 15:23:51 -0400
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello collective wisdom,

First post here, apologize if this has been asked before and would =
appreciate appropriate pointers or tips how to search the archives more =
effectively.

I work for E8 Storage and been testing our product with FIO for quite =
some time now. I=E2=80=99ve encountered this interesting affect that =
random_generator=3Dlfsr seems to have on the results. Would appreciate =
your thoughts.

Here are two jobs. Both are 4k 100 RR, attacking 1 volume. The first job =
is with lfsr, the second without.

[root@sm28 csv]#  /opt/E8/bin/fio --name=3Dglobal --thread=3D1 =
--direct=3D1 --group_reporting=3D1 --iomem_align=3D4k --name=3DPT7 =
--rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096 =
--size=3D450GiB --runtime=3D120 --filename=3D'/dev/e8b0' =
--ioengine=3Dlibaio --numa_cpu_nodes=3D0 --random_generator=3Dlfsr
PT7: (g=3D0): rw=3Drandrw, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D40
...
fio-2.2.11
Starting 8 threads
Jobs: 8 (f=3D8): [r(8)] [100.0% done] [3774MB/0KB/0KB /s] [966K/0/0 =
iops] [eta 00m:00s]
PT7: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D25976: Tue Mar 13 20:56:48 =
2018
  read : io=3D447350MB, bw=3D3727.1MB/s, iops=3D954339, runt=3D120001msec
    slat (usec): min=3D1, max=3D540, avg=3D 3.81, stdev=3D 4.14
    clat (usec): min=3D46, max=3D4793, avg=3D330.67, stdev=3D76.39
     lat (usec): min=3D50, max=3D4838, avg=3D334.65, stdev=3D76.47



[root@sm28 csv]#  /opt/E8/bin/fio --name=3Dglobal --thread=3D1 =
--direct=3D1 --group_reporting=3D1 --iomem_align=3D4k --name=3DPT7 =
--rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096 =
--size=3D450GiB --runtime=3D120 --filename=3D'/dev/e8b0' =
--ioengine=3Dlibaio --numa_cpu_nodes=3D0
PT7: (g=3D0): rw=3Drandrw, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D40
...
fio-2.2.11
Starting 8 threads
Jobs: 8 (f=3D8): [r(8)] [100.0% done] [3729MB/0KB/0KB /s] [955K/0/0 =
iops] [eta 00m:00s]
PT7: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D18605: Tue Mar 13 20:17:27 =
2018
  read : io=3D447243MB, bw=3D3726.2MB/s, iops=3D954110, runt=3D120001msec
    slat (usec): min=3D1, max=3D629, avg=3D 3.73, stdev=3D 4.08
    clat (usec): min=3D45, max=3D4327, avg=3D330.66, stdev=3D77.61
     lat (usec): min=3D47, max=3D4329, avg=3D334.55, stdev=3D77.65


Now the same with 16 volumes. Notice how latency went up and IOPS down =
with lfsr generator:

[root@sm28 csv]#  /opt/E8/bin/fio --name=3Dglobal --thread=3D1 =
--direct=3D1 --group_reporting=3D1 --iomem_align=3D4k --name=3DPT7 =
--rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096 =
--size=3D450GiB --runtime=3D120
=
--filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/e8b4:/dev/e8b5:=
/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e8b10:/dev/e8b11:/dev/e8b12:/=
dev/e8b13:/dev/e8b14:/dev/e8b15' --ioengine=3Dlibaio --numa_cpu_nodes=3D0
PT7: (g=3D0): rw=3Drandrw, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D40
...
fio-2.2.11
Starting 8 threads
Jobs: 8 (f=3D0): [r(8)] [12.7% done] [3641MB/0KB/0KB /s] [932K/0/0 iops] =
[eta 13m:50s] s]
PT7: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D27644: Tue Mar 13 21:04:24 =
2018
  read : io=3D443136MB, bw=3D3692.8MB/s, iops=3D945349, runt=3D120001msec
    slat (usec): min=3D1, max=3D1409, avg=3D 4.41, stdev=3D 6.90
    clat (usec): min=3D24, max=3D5222, avg=3D332.95, stdev=3D113.74
     lat (usec): min=3D38, max=3D5250, avg=3D337.53, stdev=3D113.11

[root@sm28 csv]#  /opt/E8/bin/fio --name=3Dglobal --thread=3D1 =
--direct=3D1 --group_reporting=3D1 --iomem_align=3D4k --name=3DPT7 =
--rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096 =
--size=3D450GiB --runtime=3D120
=
--filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/e8b4:/dev/e8b5:=
/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e8b10:/dev/e8b11:/dev/e8b12:/=
dev/e8b13:/dev/e8b14:/dev/e8b15' --ioengine=3Dlibaio --numa_cpu_nodes=3D0 =
--random_generator=3Dlfsr
PT7: (g=3D0): rw=3Drandrw, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D40
...
fio-2.2.11
Starting 8 threads
Jobs: 8 (f=3D128): [r(8)] [100.0% done] [3199MB/0KB/0KB /s] [819K/0/0 =
iops] [eta 00m:00s]
PT7: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D29711: Tue Mar 13 21:16:13 =
2018
  read : io=3D382920MB, bw=3D3190.1MB/s, iops=3D816888, runt=3D120001msec
    slat (usec): min=3D1, max=3D1069, avg=3D 3.77, stdev=3D 4.33
    clat (usec): min=3D16, max=3D3593, avg=3D387.12, stdev=3D189.09
     lat (usec): min=3D36, max=3D3613, avg=3D391.06, stdev=3D189.05

Between 1 and 16, I=E2=80=99ve tried 4, 8 and 12 volumes. The =
performance gradually worsens with LFSR as the number of volumes =
increases, but stays flat without LFSR.
--
Thanks,
Michael Green=
