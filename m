Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Measuring IOPS
Date: Fri, 29 Jul 2011 17:37:40 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201107291737.40463.Martin@lichtvoll.de>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi!

I am currently writing an article about fio for a german print magazine=20
after having packaged it for Debian and using it in performance analysis &=
=20
tuning trainings.

After introducting into the concepts of fio with some basic job files I=C2=
=B4d=20
like how to do meaningful IOPS measurements that also work with SSDs that=20
compress.

=46or some first tests I came up with:

martin@merkaba:~[=E2=80=A6]> cat iops.job=20
[global]
size=3D2G
bsrange=3D2-16k
filename=3Diops1
numjobs=3D1
iodepth=3D1
# Zuf=C3=A4llige Daten f=C3=BCr SSDs, die komprimieren
refill_buffers=3D1

[zuf=C3=A4lligschreiben]
rw=3Drandwrite
stonewall
[sequentiellschreiben]
rw=3Dwrite
stonewall

[zuf=C3=A4lliglesen]
rw=3Drandread
stonewall
[sequentielllesen]
rw=3Dread

(small german dictionary:
=2D zuf=C3=A4llig =3D> random
=2D lesen =3D> read
=2D schreiben =3D> write;)

This takes the following into account:
=2D It is recommended to just use one process. Why actually? Why not just=20
filling the device with as much requests as possible and see what it can=20
handle?

=2D I do instruct fio first to write random data by even refilling the buff=
er=20
with different random data for each write - thats for compressing SSDs,=20
those with newer sandforce chips

=2D I let it do sync I/O cause I want to measure the device, not the cache=
=20
speed. I considered direct I/O, but at least with sync I/O engine it does=20
not work on Linux 3.0 with Ext4 on an LVM: invalid request. This may or=20
may not be expected. I wondering whether direct I/O is for complete=20
devices, not for filesystems.


Things I didn=C2=B4t consider:
=2D I do not use the complete device. For obvious reasons here: I tested on=
=20
a SSD that I use for production work as well ;).
  - Thus for a harddisk this might not be realistic enough, cause a=20
harddisk has different speeds at different cylinders. I think for 2-16 KB=20
request it shouldn=C2=B4t matter tough.
  - I am considering a read test on the complete device

=2D The test does not go directly to the device, so there might be some Ext=
4=20
/ LVM overhead. On the ThinkPad T520 with Intel i5 Sandybridge Dual Core=20
CPU I think this is negligible.

=2D 2 GB might not be enough for reliable measurements


Do you think the above job file could give realistic results? Any=20
suggestions?


I got these results:

martin@merkaba:~[=E2=80=A6]> ./fio iops.job=20
zuf=C3=A4lligschreiben: (g=3D0): rw=3Drandwrite, bs=3D2-16K/2-16K, ioengine=
=3Dsync,=20
iodepth=3D1
sequentiellschreiben: (g=3D1): rw=3Dwrite, bs=3D2-16K/2-16K, ioengine=3Dsyn=
c,=20
iodepth=3D1
zuf=C3=A4lliglesen: (g=3D2): rw=3Drandread, bs=3D2-16K/2-16K, ioengine=3Dsy=
nc,=20
iodepth=3D1
sequentielllesen: (g=3D2): rw=3Dread, bs=3D2-16K/2-16K, ioengine=3Dsync, io=
depth=3D1
fio 1.57
Starting 4 processes
Jobs: 1 (f=3D1): [__r_] [100.0% done] [561.9M/0K /s] [339K/0  iops] [eta=20
00m:00s]                 =20
zuf=C3=A4lligschreiben: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D23221
  write: io=3D2048.0MB, bw=3D16971KB/s, iops=3D5190 , runt=3D123573msec
    clat (usec): min=3D0 , max=3D275675 , avg=3D183.76, stdev=3D989.34
     lat (usec): min=3D0 , max=3D275675 , avg=3D184.02, stdev=3D989.36
    bw (KB/s) : min=3D  353, max=3D94417, per=3D99.87%, avg=3D16947.64,=20
stdev=3D11562.05
  cpu          : usr=3D5.39%, sys=3D14.47%, ctx=3D344861, majf=3D0, minf=3D=
30
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D0/641383/0, short=3D0/0/0
     lat (usec): 2=3D4.48%, 4=3D23.03%, 10=3D27.46%, 20=3D5.22%, 50=3D2.17%
     lat (usec): 100=3D0.08%, 250=3D10.16%, 500=3D21.35%, 750=3D4.79%, 1000=
=3D0.06%
     lat (msec): 2=3D0.13%, 4=3D0.64%, 10=3D0.40%, 20=3D0.01%, 50=3D0.01%
     lat (msec): 100=3D0.01%, 250=3D0.01%, 500=3D0.01%
sequentiellschreiben: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D23227
  write: io=3D2048.0MB, bw=3D49431KB/s, iops=3D6172 , runt=3D 42426msec
    clat (usec): min=3D0 , max=3D83105 , avg=3D134.18, stdev=3D1286.14
     lat (usec): min=3D0 , max=3D83105 , avg=3D134.53, stdev=3D1286.14
    bw (KB/s) : min=3D    0, max=3D73767, per=3D109.57%, avg=3D54162.16,=20
stdev=3D22989.92
  cpu          : usr=3D10.29%, sys=3D22.17%, ctx=3D232818, majf=3D0, minf=
=3D33
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D0/261869/0, short=3D0/0/0
     lat (usec): 2=3D0.10%, 4=3D1.16%, 10=3D9.97%, 20=3D1.14%, 50=3D0.09%
     lat (usec): 100=3D27.31%, 250=3D59.37%, 500=3D0.61%, 750=3D0.04%, 1000=
=3D0.02%
     lat (msec): 2=3D0.04%, 4=3D0.06%, 10=3D0.01%, 20=3D0.06%, 50=3D0.01%
     lat (msec): 100=3D0.03%
zuf=C3=A4lliglesen: (groupid=3D2, jobs=3D1): err=3D 0: pid=3D23564
  read : io=3D2048.0MB, bw=3D198312KB/s, iops=3D60635 , runt=3D 10575msec
    clat (usec): min=3D0 , max=3D103758 , avg=3D14.46, stdev=3D1058.66
     lat (usec): min=3D0 , max=3D103758 , avg=3D14.50, stdev=3D1058.66
    bw (KB/s) : min=3D   98, max=3D1996998, per=3D54.76%, avg=3D217197.79,=
=20
stdev=3D563543.94
  cpu          : usr=3D11.20%, sys=3D8.25%, ctx=3D513, majf=3D0, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D641220/0/0, short=3D0/0/0
     lat (usec): 2=3D77.54%, 4=3D21.11%, 10=3D1.19%, 20=3D0.09%, 50=3D0.01%
     lat (usec): 100=3D0.01%, 500=3D0.01%, 750=3D0.01%, 1000=3D0.01%
     lat (msec): 2=3D0.01%, 4=3D0.03%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%
     lat (msec): 100=3D0.01%, 250=3D0.01%
sequentielllesen: (groupid=3D2, jobs=3D1): err=3D 0: pid=3D23565
  read : io=3D2048.0MB, bw=3D235953KB/s, iops=3D29458 , runt=3D  8888msec
    clat (usec): min=3D0 , max=3D71904 , avg=3D30.61, stdev=3D278.25
     lat (usec): min=3D0 , max=3D71904 , avg=3D30.71, stdev=3D278.25
    bw (KB/s) : min=3D    2, max=3D266240, per=3D59.04%, avg=3D234162.53,=20
stdev=3D63283.64
  cpu          : usr=3D3.42%, sys=3D16.70%, ctx=3D8326, majf=3D0, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D261826/0/0, short=3D0/0/0
     lat (usec): 2=3D28.95%, 4=3D46.75%, 10=3D19.20%, 20=3D1.80%, 50=3D0.17%
     lat (usec): 100=3D0.11%, 250=3D0.05%, 500=3D0.05%, 750=3D0.24%, 1000=
=3D2.44%
     lat (msec): 2=3D0.15%, 4=3D0.08%, 10=3D0.01%, 20=3D0.01%, 100=3D0.01%

Run status group 0 (all jobs):
  WRITE: io=3D2048.0MB, aggrb=3D16970KB/s, minb=3D17378KB/s, maxb=3D17378KB=
/s,=20
mint=3D123573msec, maxt=3D123573msec

Run status group 1 (all jobs):
  WRITE: io=3D2048.0MB, aggrb=3D49430KB/s, minb=3D50617KB/s, maxb=3D50617KB=
/s,=20
mint=3D42426msec, maxt=3D42426msec

Run status group 2 (all jobs):
   READ: io=3D4096.0MB, aggrb=3D396624KB/s, minb=3D203071KB/s, maxb=3D24161=
6KB/s,=20
mint=3D8888msec, maxt=3D10575msec

Disk stats (read/write):
  dm-2: ios=3D577687/390944, merge=3D0/0, ticks=3D141180/6046100,=20
in_queue=3D6187964, util=3D76.63%, aggrios=3D577469/390258, aggrmerge=3D216=
/761,=20
aggrticks=3D140576/6004336, aggrin_queue=3D6144016, aggrutil=3D76.38%
    sda: ios=3D577469/390258, merge=3D216/761, ticks=3D140576/6004336,=20
in_queue=3D6144016, util=3D76.38%

Which looks quite fine, I believe ;). I didn=C2=B4t yet run this test on a=
=20
harddisk.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

