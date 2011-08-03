Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54436 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1HCTbi (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2011 15:31:38 -0400
Received: from merkaba.localnet (ppp-88-217-100-84.dynamic.mnet-online.de [88.217.100.84])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 04B9F197
	for <fio@vger.kernel.org>; Wed,  3 Aug 2011 21:31:37 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Wed, 3 Aug 2011 21:31:35 +0200
References: <201107291737.40463.Martin@lichtvoll.de> (sfid-20110729_175656_507884_750F40C4) (sfid-20110729_175656_507884_750F40C4)
In-Reply-To: <201107291737.40463.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YIaOOXYCuDh5J6R"
Message-Id: <201108032131.36188.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--Boundary-00=_YIaOOXYCuDh5J6R
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, 29. Juli 2011 schrieben Sie:
> Hi!
>=20
> I am currently writing an article about fio for a german print magazine
> after having packaged it for Debian and using it in performance
> analysis & tuning trainings.
>=20
> After introducting into the concepts of fio with some basic job files
> I=C2=B4d like how to do meaningful IOPS measurements that also work with
> SSDs that compress.
>=20
> For some first tests I came up with:
>=20
> martin@merkaba:~[=E2=80=A6]> cat iops.job
> [global]
> size=3D2G
> bsrange=3D2-16k
> filename=3Diops1
> numjobs=3D1
> iodepth=3D1
> # Zuf=C3=A4llige Daten f=C3=BCr SSDs, die komprimieren
> refill_buffers=3D1
>=20
> [zuf=C3=A4lligschreiben]
> rw=3Drandwrite
> stonewall
> [sequentiellschreiben]
> rw=3Dwrite
> stonewall
>=20
> [zuf=C3=A4lliglesen]
> rw=3Drandread
> stonewall
> [sequentielllesen]
> rw=3Dread

Even with the additional stonewall this still isn=C2=B4t accurate. I found =
this=20
by getting completely bogus values with a SoftRAID 1 on two SAS disks.

It needs the following additional changes:

=2D ioengine=3Dlibaio
=2D direct=3D1
=2D and then due to direct I/O alignment requirement: bsrange=3D2k-16k

So I now also fully understand that ioengine=3Dsync just refers to the=20
synchronous nature of the system calls used, not on whether the I/Os are=20
issued synchronously via sync=3D1 or by circumventing the page cache via=20
direct=3D1

Attached are results that bring down IOPS on read drastically! I first let=
=20
sequentiell.job write out the complete 2 gb with random data and then ran=20
the iops.job.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-00=_YIaOOXYCuDh5J6R
Content-Type: text/plain;
  charset="UTF-8";
  name="iops.job"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iops.job"

[global]
ioengine=3Dlibaio
direct=3D1
# F=C3=BCr zuf=C3=A4llige Daten vorher den Job sequentiell
# laufen lassen
# Wichtig f=C3=BCr SSDs, die komprimieren
filename=3Dtestdatei
size=3D2G
bsrange=3D2k-16k

# Das, was hier geschrieben wird, soll nat=C3=BCrlich
# auch wieder zuf=C3=A4llig sein
refill_buffers=3D1

[zuf=C3=A4lliglesen]
stonewall
rw=3Drandread
runtime=3D60

[sequentielllesen]
stonewall
rw=3Dread
runtime=3D60

[zuf=C3=A4lligschreiben]
stonewall
rw=3Drandwrite
runtime=3D60

[sequentiellschreiben]
stonewall
rw=3Dwrite
runtime=3D60


--Boundary-00=_YIaOOXYCuDh5J6R
Content-Type: text/x-log;
  charset="UTF-8";
  name="iops.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iops.log"

zuf=C3=A4lliglesen: (g=3D0): rw=3Drandread, bs=3D2K-16K/2K-16K, ioengine=3D=
libaio, iodepth=3D1
sequentielllesen: (g=3D1): rw=3Dread, bs=3D2K-16K/2K-16K, ioengine=3Dlibaio=
, iodepth=3D1
zuf=C3=A4lligschreiben: (g=3D2): rw=3Drandwrite, bs=3D2K-16K/2K-16K, ioengi=
ne=3Dlibaio, iodepth=3D1
sequentiellschreiben: (g=3D3): rw=3Dwrite, bs=3D2K-16K/2K-16K, ioengine=3Dl=
ibaio, iodepth=3D1
fio 1.57
Starting 4 processes

zuf=C3=A4lliglesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6954
  read : io=3D1322.9MB, bw=3D22563KB/s, iops=3D3194 , runt=3D 60001msec
    slat (usec): min=3D6 , max=3D1763 , avg=3D29.52, stdev=3D12.62
    clat (usec): min=3D2 , max=3D7206 , avg=3D274.52, stdev=3D114.08
     lat (usec): min=3D128 , max=3D7246 , avg=3D304.68, stdev=3D116.81
    bw (KB/s) : min=3D18844, max=3D25304, per=3D100.15%, avg=3D22596.20, st=
dev=3D1740.26
  cpu          : usr=3D4.15%, sys=3D10.50%, ctx=3D193490, majf=3D0, minf=3D=
23
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D191664/0/0, short=3D0/0/0
     lat (usec): 4=3D0.01%, 10=3D0.01%, 50=3D0.01%, 100=3D0.01%, 250=3D49.3=
2%
     lat (usec): 500=3D48.57%, 750=3D1.98%, 1000=3D0.05%
     lat (msec): 2=3D0.05%, 4=3D0.02%, 10=3D0.01%
sequentielllesen: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D6956
  read : io=3D2048.0MB, bw=3D72598KB/s, iops=3D8066 , runt=3D 28887msec
    slat (usec): min=3D5 , max=3D1909 , avg=3D26.76, stdev=3D 8.98
    clat (usec): min=3D1 , max=3D4631 , avg=3D91.18, stdev=3D36.03
     lat (usec): min=3D40 , max=3D4644 , avg=3D118.51, stdev=3D37.86
    bw (KB/s) : min=3D70224, max=3D77412, per=3D100.09%, avg=3D72663.79, st=
dev=3D1589.19
  cpu          : usr=3D6.47%, sys=3D24.83%, ctx=3D234568, majf=3D0, minf=3D=
25
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D233021/0/0, short=3D0/0/0
     lat (usec): 2=3D0.01%, 4=3D0.01%, 10=3D0.01%, 50=3D0.71%, 100=3D65.76%
     lat (usec): 250=3D33.16%, 500=3D0.29%, 750=3D0.05%, 1000=3D0.02%
     lat (msec): 2=3D0.01%, 4=3D0.01%, 10=3D0.01%
zuf=C3=A4lligschreiben: (groupid=3D2, jobs=3D1): err=3D 0: pid=3D6958
  write: io=3D2048.0MB, bw=3D36083KB/s, iops=3D6594 , runt=3D 58121msec
    slat (usec): min=3D6 , max=3D1952 , avg=3D31.79, stdev=3D 9.51
    clat (usec): min=3D0 , max=3D19882 , avg=3D113.47, stdev=3D216.71
     lat (usec): min=3D44 , max=3D19949 , avg=3D145.84, stdev=3D217.32
    bw (KB/s) : min=3D14000, max=3D58580, per=3D100.12%, avg=3D36125.51, st=
dev=3D10544.88
  cpu          : usr=3D5.66%, sys=3D23.66%, ctx=3D386270, majf=3D0, minf=3D=
17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D0/383305/0, short=3D0/0/0
     lat (usec): 2=3D0.01%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D1.92%
     lat (usec): 100=3D61.91%, 250=3D30.73%, 500=3D5.22%, 750=3D0.12%, 1000=
=3D0.04%
     lat (msec): 2=3D0.03%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%
sequentiellschreiben: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D6959
  write: io=3D2048.0MB, bw=3D63465KB/s, iops=3D7050 , runt=3D 33044msec
    slat (usec): min=3D6 , max=3D2854 , avg=3D30.54, stdev=3D11.23
    clat (usec): min=3D1 , max=3D19371 , avg=3D104.68, stdev=3D190.45
     lat (usec): min=3D43 , max=3D19417 , avg=3D135.81, stdev=3D191.17
    bw (KB/s) : min=3D22984, max=3D68224, per=3D100.07%, avg=3D63511.21, st=
dev=3D5443.51
  cpu          : usr=3D6.16%, sys=3D24.62%, ctx=3D234687, majf=3D0, minf=3D=
19
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D0/232969/0, short=3D0/0/0
     lat (usec): 2=3D0.01%, 4=3D0.01%, 10=3D0.01%, 50=3D0.68%, 100=3D51.92%
     lat (usec): 250=3D46.97%, 500=3D0.22%, 750=3D0.07%, 1000=3D0.07%
     lat (msec): 2=3D0.04%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%

Run status group 0 (all jobs):
   READ: io=3D1322.9MB, aggrb=3D22563KB/s, minb=3D23104KB/s, maxb=3D23104KB=
/s, mint=3D60001msec, maxt=3D60001msec

Run status group 1 (all jobs):
   READ: io=3D2048.0MB, aggrb=3D72598KB/s, minb=3D74340KB/s, maxb=3D74340KB=
/s, mint=3D28887msec, maxt=3D28887msec

Run status group 2 (all jobs):
  WRITE: io=3D2048.0MB, aggrb=3D36082KB/s, minb=3D36948KB/s, maxb=3D36948KB=
/s, mint=3D58121msec, maxt=3D58121msec

Run status group 3 (all jobs):
  WRITE: io=3D2048.0MB, aggrb=3D63465KB/s, minb=3D64988KB/s, maxb=3D64988KB=
/s, mint=3D33044msec, maxt=3D33044msec

Disk stats (read/write):
  dm-2: ios=3D424704/615629, merge=3D0/0, ticks=3D70028/59768, in_queue=3D1=
29796, util=3D71.90%, aggrios=3D424704/616498, aggrmerge=3D0/60, aggrticks=
=3D69568/60584, aggrin_queue=3D128920, aggrutil=3D71.33%
    sda: ios=3D424704/616498, merge=3D0/60, ticks=3D69568/60584, in_queue=
=3D128920, util=3D71.33%

--Boundary-00=_YIaOOXYCuDh5J6R
Content-Type: text/plain;
  charset="UTF-8";
  name="sequentiell.job"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="sequentiell.job"

[global]
ioengine=3Dlibaio
direct=3D1
filename=3Dtestdatei
size=3D2g
bs=3D4m

# Vollst=C3=A4ndig zuf=C3=A4llige Daten f=C3=BCr SSDs, die komprimieren
refill_buffers=3D1

[schreiben]
stonewall
rw=3Dwrite

[lesen]
stonewall
rw=3Dread

--Boundary-00=_YIaOOXYCuDh5J6R
Content-Type: text/x-log;
  charset="UTF-8";
  name="sequentiell.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sequentiell.log"

[global]
ioengine=libaio
direct=1
filename=testdatei
size=2g
bs=4m

[schreiben]
stonewall
rw=write

[lesen]
stonewall
rw=read
schreiben: (g=0): rw=write, bs=4M-4M/4M-4M, ioengine=libaio, iodepth=1
lesen: (g=1): rw=read, bs=4M-4M/4M-4M, ioengine=libaio, iodepth=1
fio 1.57
Starting 2 processes
schreiben: Laying out IO file(s) (1 file(s) / 2048MB)

schreiben: (groupid=0, jobs=1): err= 0: pid=5855
  write: io=2048.0MB, bw=220150KB/s, iops=53 , runt=  9526msec
    slat (usec): min=239 , max=1328 , avg=452.88, stdev=182.05
    clat (msec): min=17 , max=22 , avg=18.14, stdev= 1.10
     lat (msec): min=17 , max=23 , avg=18.59, stdev= 1.12
    bw (KB/s) : min=216422, max=223128, per=100.08%, avg=220331.94, stdev=2205.18
  cpu          : usr=0.17%, sys=2.44%, ctx=557, majf=0, minf=19
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/512/0, short=0/0/0

     lat (msec): 20=93.55%, 50=6.45%
lesen: (groupid=1, jobs=1): err= 0: pid=5856
  read : io=2048.0MB, bw=267460KB/s, iops=65 , runt=  7841msec
    slat (usec): min=251 , max=4071 , avg=581.06, stdev=300.62
    clat (usec): min=14517 , max=17700 , avg=14724.38, stdev=340.74
     lat (usec): min=14906 , max=20094 , avg=15306.37, stdev=451.23
    bw (KB/s) : min=264000, max=270336, per=100.07%, avg=267634.87, stdev=1787.07
  cpu          : usr=0.10%, sys=3.78%, ctx=569, majf=0, minf=1045
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=512/0/0, short=0/0/0

     lat (msec): 20=100.00%

Run status group 0 (all jobs):
  WRITE: io=2048.0MB, aggrb=220150KB/s, minb=225433KB/s, maxb=225433KB/s, mint=9526msec, maxt=9526msec

Run status group 1 (all jobs):
   READ: io=2048.0MB, aggrb=267459KB/s, minb=273878KB/s, maxb=273878KB/s, mint=7841msec, maxt=7841msec

Disk stats (read/write):
  dm-2: ios=3991/4196, merge=0/0, ticks=33880/43220, in_queue=77124, util=96.78%, aggrios=4112/4143, aggrmerge=0/56, aggrticks=34944/42968, aggrin_queue=77904, aggrutil=96.79%
    sda: ios=4112/4143, merge=0/56, ticks=34944/42968, in_queue=77904, util=96.79%

--Boundary-00=_YIaOOXYCuDh5J6R--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


