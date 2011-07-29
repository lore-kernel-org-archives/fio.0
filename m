Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Fri, 29 Jul 2011 18:14:34 +0200
References: <201107291737.40463.Martin@lichtvoll.de> (sfid-20110729_175656_507884_750F40C4)
In-Reply-To: <201107291737.40463.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201107291814.34500.Martin@lichtvoll.de>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Am Freitag, 29. Juli 2011 schrieb Martin Steigerwald:
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
>=20
> (small german dictionary:
> - zuf=C3=A4llig =3D> random
> - lesen =3D> read
> - schreiben =3D> write;)
[...]
> Do you think the above job file could give realistic results? Any
> suggestions?
>=20
>=20
> I got these results:

With a simpler read job I have different results that puzzle me:

martin@merkaba:~/Artikel/LinuxNewMedia/fio/Recherche/fio> cat zweierlei-
lesen-2gb-variable-blockgr=C3=B6=C3=9Fen.job
[global]
rw=3Drandread
size=3D2g
bsrange=3D2-16k

[zuf=C3=A4lliglesen]
stonewall
[sequentielllesen]
rw=3Dread

martin@merkaba:~[...]> ./fio zweierlei-lesen-2gb-variable-blockgr=C3=B6=C3=
=9Fen.job
zuf=C3=A4lliglesen: (g=3D0): rw=3Drandread, bs=3D2-16K/2-16K, ioengine=3Dsy=
nc,=20
iodepth=3D1
sequentielllesen: (g=3D0): rw=3Dread, bs=3D2-16K/2-16K, ioengine=3Dsync, io=
depth=3D1
fio 1.57
Starting 2 processes
Jobs: 1 (f=3D1): [r_] [100.0% done] [96146K/0K /s] [88.3K/0  iops] [eta=20
00m:00s] =20
zuf=C3=A4lliglesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D29273
  read : io=3D2048.0MB, bw=3D20915KB/s, iops=3D6389 , runt=3D100269msec
    clat (usec): min=3D0 , max=3D103772 , avg=3D150.09, stdev=3D1042.77
     lat (usec): min=3D0 , max=3D103772 , avg=3D150.34, stdev=3D1042.79
    bw (KB/s) : min=3D  131, max=3D112571, per=3D50.31%, avg=3D21045.54,=20
stdev=3D13225.53
  cpu          : usr=3D4.66%, sys=3D11.24%, ctx=3D262203, majf=3D0, minf=3D=
26
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D640622/0/0, short=3D0/0/0
     lat (usec): 2=3D23.94%, 4=3D26.21%, 10=3D7.86%, 20=3D1.39%, 50=3D0.15%
     lat (usec): 100=3D0.01%, 250=3D14.76%, 500=3D21.53%, 750=3D3.77%, 1000=
=3D0.10%
     lat (msec): 2=3D0.16%, 4=3D0.09%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%
     lat (msec): 100=3D0.01%, 250=3D0.01%
sequentielllesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D29274
  read : io=3D2048.0MB, bw=3D254108KB/s, iops=3D31748 , runt=3D  8253msec
    clat (usec): min=3D0 , max=3D4773 , avg=3D30.44, stdev=3D173.41
     lat (usec): min=3D0 , max=3D4773 , avg=3D30.54, stdev=3D173.41
    bw (KB/s) : min=3D229329, max=3D265720, per=3D607.79%, avg=3D254236.81,=
=20
stdev=3D8940.36
  cpu          : usr=3D4.02%, sys=3D16.97%, ctx=3D8407, majf=3D0, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D262021/0/0, short=3D0/0/0
     lat (usec): 2=3D30.07%, 4=3D46.83%, 10=3D17.84%, 20=3D1.91%, 50=3D0.19%
     lat (usec): 100=3D0.12%, 250=3D0.02%, 500=3D0.02%, 750=3D0.21%, 1000=
=3D2.52%
     lat (msec): 2=3D0.16%, 4=3D0.10%, 10=3D0.01%

Run status group 0 (all jobs):
   READ: io=3D4096.0MB, aggrb=3D41830KB/s, minb=3D21417KB/s, maxb=3D260206K=
B/s,=20
mint=3D8253msec, maxt=3D100269msec

Disk stats (read/write):
  dm-2: ios=3D267216/204, merge=3D0/0, ticks=3D95188/36, in_queue=3D95240,=
=20
util=3D80.52%, aggrios=3D266989/191, aggrmerge=3D267/175, aggrticks=3D94712=
/44,=20
aggrin_queue=3D94312, aggrutil=3D80.18%
    sda: ios=3D266989/191, merge=3D267/175, ticks=3D94712/44, in_queue=3D94=
312,=20
util=3D80.18%


What=C2=B4s going on here?  Where does the difference between 6389 IOPS for=
 this=20
simpler read job file versus 60635 IOPS for the IOPS job file come from?=20
These results compared to the results from the IOPS job do not make sense=20
to me. Is it just random versus zeros? Which values are more realistic? I=20
thought on an SSD random I/O versus sequential I/O should cause such a big=
=20
difference.

=46iles are laid out as follows:

martin@merkaba:~[=E2=80=A6]> sudo filefrag zuf=C3=A4lliglesen.1.0 sequentie=
lllesen.2.0=20
iops1=20
zuf=C3=A4lliglesen.1.0: 17 extents found
sequentielllesen.2.0: 17 extents found
iops1: 258 extents found

Not that it should matter much on an SSD.

This is on an ThinkPad T520 with Intel i5 Sandybridge Dual Core, 8 GB of=20
RAM and said Intel SSD 320. On Ext4 on LVM with Linux 3.0.0 debian=20
package.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

