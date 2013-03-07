Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:53907 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3CGFke convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 7 Mar 2013 00:40:34 -0500
Received: from vmwexceht01-prd.hq.netapp.com (exchsmtp.hq.netapp.com [10.106.76.239])
	by smtp1.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id r275eXMo010285
	for <fio@vger.kernel.org>; Wed, 6 Mar 2013 21:40:33 -0800 (PST)
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Fio 2.0.14 - Windows - Issues with rate_ops
Date: Thu, 7 Mar 2013 05:40:32 +0000
Message-ID: <843E15216120C047928F6879B0E2D92424B30720@SACEXCMBX02-PRD.hq.netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

I am trying to simulate the actual IO load as seen in the existing producti=
on environment which shows about 10 iops/user with 72% writes.
=20
I can=EF=BF=BDt get the rate_iops to work in fio. Most of the time the job =
does not complete, first the eta counts down from 10 then the eta time star=
ts increasing. Sometimes I get a report but most of the time I have to ctrl=
-c to escape. If there is a report it shows iops=3D0.

Does anyone have used that before?

Thank you very much

neto


-- FIO output

C:\Temp\VDI Test data>fio VDI_prodn.txt
VDI: (g=3D0): rw=3Drandrw, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dwindowsaio, i=
odepth=3D1
fio-2.0.14
Starting 1 thread
Jobs: 1 (f=3D1), CR=3D20/0 IOPS: [m] [0.0% done] [0K/0K/0K /s] [0 /0 /0  io=
ps] [eta 03d:15h:24m:57s]
fio: terminating on signal 2
Jobs: 1 (f=3D1), CR=3D20/0 IOPS: [m] [0.0% done] [0K/0K/0K /s] [0 /0 /0  io=
ps] [eta 04d:12h:07m:10s]
VDI: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4944: Wed Mar 06 17:20:07 2013
  Description  : [Emulation of one busy VDI desktop]
  read : io=3D8192 B, bw=3D173 B/s, iops=3D0 , runt=3D 47317msec
    slat (usec): min=3D106 , max=3D158 , avg=3D132.00, stdev=3D36.77
    clat (usec): min=3D1032 , max=3D1112 , avg=3D1072.00, stdev=3D56.57
     lat (usec): min=3D1190 , max=3D1218 , avg=3D1204.00, stdev=3D19.80
    clat percentiles (usec):
     |  1.00th=3D[ 1032],  5.00th=3D[ 1032], 10.00th=3D[ 1032], 20.00th=3D[=
 1032],
     | 30.00th=3D[ 1032], 40.00th=3D[ 1032], 50.00th=3D[ 1032], 60.00th=3D[=
 1112],
     | 70.00th=3D[ 1112], 80.00th=3D[ 1112], 90.00th=3D[ 1112], 95.00th=3D[=
 1112],
     | 99.00th=3D[ 1112], 99.50th=3D[ 1112], 99.90th=3D[ 1112], 99.95th=3D[=
 1112],
     | 99.99th=3D[ 1112]
    bw (KB/s)  : min=3D    0, max=3D    0, per=3D100.00%, avg=3D 0.00, stde=
v=3D 0.00
  write: io=3D8192 B, bw=3D173 B/s, iops=3D0 , runt=3D 47317msec
    slat (usec): min=3D191 , max=3D1736 , avg=3D963.50, stdev=3D1092.48
    clat (usec): min=3D1182 , max=3D1918 , avg=3D1550.00, stdev=3D520.43
     lat (usec): min=3D2109 , max=3D2918 , avg=3D2513.50, stdev=3D572.05
    clat percentiles (usec):
     |  1.00th=3D[ 1176],  5.00th=3D[ 1176], 10.00th=3D[ 1176], 20.00th=3D[=
 1176],
     | 30.00th=3D[ 1176], 40.00th=3D[ 1176], 50.00th=3D[ 1176], 60.00th=3D[=
 1912],
     | 70.00th=3D[ 1912], 80.00th=3D[ 1912], 90.00th=3D[ 1912], 95.00th=3D[=
 1912],
     | 99.00th=3D[ 1912], 99.50th=3D[ 1912], 99.90th=3D[ 1912], 99.95th=3D[=
 1912],
     | 99.99th=3D[ 1912]
    bw (KB/s)  : min=3D    0, max=3D    0, per=3D100.00%, avg=3D 0.00, stde=
v=3D 0.00
    lat (msec) : 2=3D100.00%
^C
C:\Temp\VDI Test data>
C:\Temp\VDI Test data>
C:\Temp\VDI Test data>fio VDI_prodn.txt
VDI: (g=3D0): rw=3Drandrw, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dwindowsaio, i=
odepth=3D1
fio-2.0.14
Starting 1 thread
Jobs: 1 (f=3D1), CR=3D20/0 IOPS: [m] [0.0% done] [0K/0K/0K /s] [0 /0 /0  io=
ps] [eta 01d:08h:12m:21s]
fio: terminating on signal 2
^Cbs: 1 (f=3D1), CR=3D20/0 IOPS: [m] [0.0% done] [0K/0K/0K /s] [0 /0 /0  io=
ps] [eta 05d:13h:25m:27s]
C:\Temp\VDI Test data>
C:\Temp\VDI Test data>



-- FIO config file

# This job file is to be used with 60 desktops to gather data to be used in=
 sizing for 480 busy VDI desktops
[global]
description=3DEmulation of one busy VDI desktop

[VDI]
bs=3D4k
ioengine=3Dwindowsaio
rw=3Drandrw
# with the actual disk IO has a high % of writes - 70 to 74%, use 72%
rwmixwrite=3D72
# iops based on actual of between 6.75 and 8.9 per user, use 10/VDI
rate_iops=3D10
runtime=3D10
time_based
# select data file based on actual of 2075GB for 395 users =3D 5.3GB per us=
er, use 5.5GB
filename=3D.\difference.dat
direct=3D1
# attempt to use only 20% of the date file
#size=3D20%
thread
