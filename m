Return-Path: <fio-owner@vger.kernel.org>
Received: from n1c.bullet.cnmail.cnb.yahoo.com ([202.43.217.65]:40499 "HELO
	n1c.bullet.cnmail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755536Ab1ESCBU convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 May 2011 22:01:20 -0400
Message-ID: <306004.16881.qm@web15804.mail.cnb.yahoo.com>
Date: Thu, 19 May 2011 09:55:24 +0800 (CST)
From: ren yufei <renyufei83@yahoo.com.cn>
Reply-To: ren yufei <renyufei83@yahoo.com.cn>
Subject: comparision sync io
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I have tested fio with sync engine and my simple io app based on read in th=
e same environment. fio is more efficient in the same testbed. I check the =
fio sync logic, but I didn't get the reason. Could anyone explain for me? H=
ow could fio utilize cpu to get better bandwidth?


bandwidth result
--
fio:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD 805.26 MBytes/sec: aggrb=3D824579KB/s=20
my app: 555.00 MBytes/sec

cpu usage
--
fio: 39%
my app: 26%


my app logic
--
thread 1:

bufsiz =3D 1MB


open(O_RDONLY)

while ( (cl =3D read(fd, buf, bufsiz)) > 0)
=EF=BF=BD=EF=BF=BD=EF=BF=BD totallen +=3D cl;

thread 2:
calculate the bandwidth every few seconds.


fio
--

1) jobfile

[global]
ioengine=3Dsync
direct=3D0
bs=3D1M
rw=3Dread
directory=3D/data/fio
ioscheduler=3Ddeadline
time_based
runtime=3D60

[job]
filename=3Dreadhg
size=3D100g
iodepth=3D16

2) test result

job: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Dsync, iodepth=3D16
fio 1.54
Starting 1 process
Jobs: 1 (f=3D1): [R] [100.0% done] [777.1M/0K /s] [759 /0=EF=BF=BD iops] [e=
ta=20

00m:00s]
job: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D15733
=EF=BF=BD read : io=3D48316MB, bw=3D824579KB/s, iops=3D805 , runt=3D 60001m=
sec
=EF=BF=BD=EF=BF=BD=EF=BF=BD clat (usec): min=3D826 , max=3D38326 , avg=3D12=
38.18, stdev=3D294.26
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD lat (usec): min=3D826 , max=3D38327 , =
avg=3D1238.47, stdev=3D294.25
=EF=BF=BD=EF=BF=BD=EF=BF=BD bw (KB/s) : min=3D731136, max=3D976896, per=3D1=
00.14%, avg=3D825702.05,=20

stdev=3D51012.43
=EF=BF=BD cpu=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD : usr=3D0.43%, sys=3D43.70%, ctx=3D102003, majf=3D0, =
minf=3D280
=EF=BF=BD IO depths=EF=BF=BD=EF=BF=BD=EF=BF=BD : 1=3D100.0%, 2=3D0.0%, 4=3D=
0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=20

>=3D64=3D0.0%
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD submit=EF=BF=BD=EF=BF=BD=EF=BF=BD : 0=
=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%,=20

>=3D64=3D0.0%
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD complete=EF=BF=BD : 0=3D0.0%, 4=3D100.=
0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%,=20

>=3D64=3D0.0%
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD issued r/w/d: total=3D48316/0/0, short=
=3D0/0/0
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD lat (usec): 1000=3D3.90%
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD lat (msec): 2=3D95.95%, 4=3D0.06%, 10=
=3D0.09%, 20=3D0.01%, 50=3D0.01%

Run status group 0 (all jobs):
=EF=BF=BD=EF=BF=BD READ: io=3D48316MB, aggrb=3D824579KB/s, minb=3D844369KB/=
s, maxb=3D844369KB/s,=20

mint=3D60001msec, maxt=3D60001msec

Disk stats (read/write):
=EF=BF=BD sdb: ios=3D193022/22, merge=3D0/11, ticks=3D67943/112, in_queue=
=3D81657,=20

util=3D80.52%



notes
--
each time before i do the test, the cache is cleaned.
# sync; echo 3 > /proc/sys/vm/drop_caches


Thanks.

Yufei


