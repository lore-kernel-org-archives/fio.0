Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS (solved, I think)
Date: Tue, 2 Aug 2011 16:32:00 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201107291814.34500.Martin@lichtvoll.de> (sfid-20110729_182258_773952_019EDFF6) (sfid-20110729_182258_773952_019EDFF6)
In-Reply-To: <201107291814.34500.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gpAOONAN8Ii58Xz"
Message-Id: <201108021632.00600.Martin@lichtvoll.de>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--Boundary-00=_gpAOONAN8Ii58Xz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, 29. Juli 2011 schrieb Martin Steigerwald:
> Am Freitag, 29. Juli 2011 schrieb Martin Steigerwald:
> > Hi!
> >=20
> > I am currently writing an article about fio for a german print
> > magazine after having packaged it for Debian and using it in
> > performance analysis & tuning trainings.
> >=20
> > After introducting into the concepts of fio with some basic job files
> > I=C2=B4d like how to do meaningful IOPS measurements that also work with
> > SSDs that compress.
> >=20
> > For some first tests I came up with:
> >=20
> > martin@merkaba:~[=E2=80=A6]> cat iops.job
> > [global]
> > size=3D2G
> > bsrange=3D2-16k
> > filename=3Diops1
> > numjobs=3D1
> > iodepth=3D1
> > # Zuf=C3=A4llige Daten f=C3=BCr SSDs, die komprimieren
> > refill_buffers=3D1
> >=20
> > [zuf=C3=A4lligschreiben]
> > rw=3Drandwrite
> > stonewall
> > [sequentiellschreiben]
> > rw=3Dwrite
> > stonewall
> >=20
> > [zuf=C3=A4lliglesen]
> > rw=3Drandread
> > stonewall
> > [sequentielllesen]
> > rw=3Dread
> >=20
> > (small german dictionary:
> > - zuf=C3=A4llig =3D> random
> > - lesen =3D> read
> > - schreiben =3D> write;)
>=20
> [...]
>=20
> > Do you think the above job file could give realistic results? Any
> > suggestions?
>=20
> > I got these results:
> With a simpler read job I have different results that puzzle me:
>=20
> martin@merkaba:~/Artikel/LinuxNewMedia/fio/Recherche/fio> cat
> zweierlei- lesen-2gb-variable-blockgr=C3=B6=C3=9Fen.job
> [global]
> rw=3Drandread
> size=3D2g
> bsrange=3D2-16k
>=20
> [zuf=C3=A4lliglesen]
> stonewall
> [sequentielllesen]
> rw=3Dread
[...]

> What=C2=B4s going on here?  Where does the difference between 6389 IOPS f=
or
> this simpler read job file versus 60635 IOPS for the IOPS job file
> come from? These results compared to the results from the IOPS job do
> not make sense to me. Is it just random versus zeros? Which values are
> more realistic? I thought on an SSD random I/O versus sequential I/O
> should cause such a big difference.
>=20
> Files are laid out as follows:
>=20
> martin@merkaba:~[=E2=80=A6]> sudo filefrag zuf=C3=A4lliglesen.1.0
> sequentielllesen.2.0 iops1
> zuf=C3=A4lliglesen.1.0: 17 extents found
> sequentielllesen.2.0: 17 extents found
> iops1: 258 extents found
>=20
> Not that it should matter much on an SSD.
>=20
> This is on an ThinkPad T520 with Intel i5 Sandybridge Dual Core, 8 GB
> of RAM and said Intel SSD 320. On Ext4 on LVM with Linux 3.0.0 debian
> package.

I think I found it.

It depends on whether I specify a filename explicitely *and* globally or=20
not. When I specify it the job runs fast. No matter whether there are=20
zeros or random data in the file - as expected for this SSD. When I do not=
=20
specify it or specify it in a section the job runs slow.


Now follows the complete investigation and explaination of why this was=20
so:

The only difference between job files is:

martin@merkaba:~[...]> cat zweierlei-lesen-2gb-variable-blockgr=C3=B6=C3=9F=
en-
jobfile-given.job
[global]
rw=3Drandread
size=3D2g
bsrange=3D2-16k
filename=3Dzuf=C3=A4lliglesen.1.0

[zuf=C3=A4lliglesen]
stonewall
[sequentielllesen]
rw=3Dread

The only difference of the implicit-jobfile job is that I commented the=20
filename option. But since the filename matches that what fio would choose =
by=20
itself, fio in both cases should use *the same* file.


Steps to (hopefully) reproduce it:

1. do the following once to have the job files created: fio zweierlei-
lesen-2gb-variable-blockgr=C3=B6=C3=9Fen-jobfile-given.job

2. do=20

su -c "echo 3 > /proc/sys/vm/drop_caches" ; fio zweierlei-lesen-2gb-
variable-blockgr=C3=B6=C3=9Fen-jobfile-implicit.job > zweierlei-lesen-2gb-v=
ariable-
blockgr=C3=B6=C3=9Fen-jobfile-implicit.results

fio runs slow.

3. do

su -c "echo 3 > /proc/sys/vm/drop_caches" ; fio zweierlei-lesen-2gb-
variable-blockgr=C3=B6=C3=9Fen-jobfile-given.job > zweierlei-lesen-2gb-vari=
able-
blockgr=C3=B6=C3=9Fen-jobfile-given.results

fio runs fast.

4. Use kompare, vimdiff or other side by side diff to compare the results.


I do think that echo 3 > /proc/sys/vm/drop_caches is not needed, as far as=
=20
I understand, fio clears caches if not told otherwise.


Aside from the speed difference I only found one difference that might=20
explain this fast

  cpu          : usr=3D11.54%, sys=3D9.26%, ctx=3D3392, majf=3D0, minf=3D28

versus  this slow

  cpu          : usr=3D4.87%, sys=3D11.20%, ctx=3D261968, majf=3D0, minf=3D=
26


Any hints why giving or not giving the filename makes such a big difference?

I also tested whether this might be an UTF-8 issue and rewrote the job=20
files to not use any umlauts. That didn=C2=B4t make any difference.

I made it a bit more narrow even:

martin@merkaba:~[...]> diff -u zweierlei-lesen-2gb-variable-blockgroessen-
jobfile-given-in-section-no-utf8.job zweierlei-lesen-2gb-variable-
blockgroessen-jobfile-given-no-utf8.job=20
=2D-- zweierlei-lesen-2gb-variable-blockgroessen-jobfile-given-in-section-n=
o-
utf8.job     2011-08-02 15:35:41.246226877 +0200
+++ zweierlei-lesen-2gb-variable-blockgroessen-jobfile-given-no-utf8.job   =
    =20
2011-08-02 15:50:00.073095677 +0200
@@ -2,9 +2,9 @@
 rw=3Drandread
 size=3D2g
 bsrange=3D2-16k
+filename=3Dzufaelliglesen.1.0
=20
 [zufaelliglesen]
=2Dfilename=3Dzufaelliglesen.1.0
 stonewall
 [sequentielllesen]
 rw=3Dread

makes the difference.


Okay, and now I understand it:

As I see from the progress display I see that fio runs the second job first=
=2E=20
When the filename is in the global section, both jobs use the same file. An=
d=20
with the missing stonewall option in the second job section the sequential=
=20
read job even runs in parallel. I wondered whether I had [rR] there.


Okay, then I know:

When I want to have mutiple jobs run one after another I need to do a=20
stonewall argument in *each* job. *Also the last one*, cause in the notion=
=20
of fio there is no last job, as fio sets up each job before it starts job=20
execution. And it seems that everything it runs everything that has no=20
stonewall option right away even if an earlier defined job file has a=20
stonewall option. Fio only thinks sequentially for the jobs that have a=20
stonewall option which might be a disadvantage, if I want to run groups of=
=20
jobs one after another:

[readjob]
blabla

[parallelwritejob]
blabla
stonewall

[randomreadjob]
blabla

[sequentialreadjob]
blabla
stonewall

As far as I understand it, Fio would then run the both jobs without a=20
stonewall option straight away while it also starts the first job with a=20
stonewall option. Then, the jobs without the stonewall option might still=20
running or not, fio starts the second job without the stonewall option.

So I understand it now. Personally I would prefer, if fio runs the first tw=
o=20
jobs in parallel then does the stonewall, and then the second two jobs in=20
parallel. Is this possible somehow?



With an additional "stonewall" for the last job in the iops.job file I made=
=20
up it also works when the filename is specified globally.

Thus there we go:

martin@merkaba:~[...]> fio iops-done-right.job=20
zuf=C3=A4lligschreiben: (g=3D0): rw=3Drandwrite, bs=3D2-16K/2-16K, ioengine=
=3Dsync,=20
iodepth=3D1
sequentiellschreiben: (g=3D1): rw=3Dwrite, bs=3D2-16K/2-16K, ioengine=3Dsyn=
c,=20
iodepth=3D1
zuf=C3=A4lliglesen: (g=3D2): rw=3Drandread, bs=3D2-16K/2-16K, ioengine=3Dsy=
nc,=20
iodepth=3D1
sequentielllesen: (g=3D3): rw=3Dread, bs=3D2-16K/2-16K, ioengine=3Dsync, io=
depth=3D1
fio 1.57
Starting 4 processes
Jobs: 1 (f=3D1): [___R] [100.0% done] [268.3M/0K /s] [33.6K/0  iops] [eta=20
00m:00s]               =20
zuf=C3=A4lligschreiben: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D20474
  write: io=3D2048.0MB, bw=3D16686KB/s, iops=3D5096 , runt=3D125687msec
    clat (usec): min=3D0 , max=3D292792 , avg=3D188.16, stdev=3D933.01
     lat (usec): min=3D0 , max=3D292792 , avg=3D188.42, stdev=3D933.04
    bw (KB/s) : min=3D  320, max=3D63259, per=3D100.00%, avg=3D16684.86,=20
stdev=3D9052.82
  cpu          : usr=3D4.60%, sys=3D13.58%, ctx=3D344489, majf=3D0, minf=3D=
31
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D0/640575/0, short=3D0/0/0
     lat (usec): 2=3D4.55%, 4=3D23.30%, 10=3D27.49%, 20=3D5.00%, 50=3D2.07%
     lat (usec): 100=3D0.09%, 250=3D12.02%, 500=3D20.41%, 750=3D3.46%, 1000=
=3D0.11%
     lat (msec): 2=3D0.31%, 4=3D0.78%, 10=3D0.40%, 20=3D0.01%, 50=3D0.01%
     lat (msec): 100=3D0.01%, 250=3D0.01%, 500=3D0.01%
sequentiellschreiben: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D20482
  write: io=3D2048.0MB, bw=3D49401KB/s, iops=3D6176 , runt=3D 42452msec
    clat (usec): min=3D0 , max=3D213632 , avg=3D132.32, stdev=3D1355.16
     lat (usec): min=3D1 , max=3D213632 , avg=3D132.65, stdev=3D1355.16
    bw (KB/s) : min=3D    2, max=3D79902, per=3D110.53%, avg=3D54600.95,=20
stdev=3D24636.03
  cpu          : usr=3D10.83%, sys=3D21.02%, ctx=3D232933, majf=3D0, minf=
=3D34
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D0/262197/0, short=3D0/0/0
     lat (usec): 2=3D0.09%, 4=3D1.07%, 10=3D10.43%, 20=3D0.89%, 50=3D0.07%
     lat (usec): 100=3D35.03%, 250=3D51.57%, 500=3D0.57%, 750=3D0.03%, 1000=
=3D0.01%
     lat (msec): 2=3D0.04%, 4=3D0.08%, 10=3D0.02%, 20=3D0.06%, 50=3D0.01%
     lat (msec): 100=3D0.03%, 250=3D0.01%
zuf=C3=A4lliglesen: (groupid=3D2, jobs=3D1): err=3D 0: pid=3D20484
  read : io=3D2048.0MB, bw=3D23151KB/s, iops=3D7050 , runt=3D 90584msec
    clat (usec): min=3D0 , max=3D70235 , avg=3D134.92, stdev=3D212.70
     lat (usec): min=3D0 , max=3D70236 , avg=3D135.16, stdev=3D212.79
    bw (KB/s) : min=3D    5, max=3D118959, per=3D100.36%, avg=3D23233.61,=20
stdev=3D12885.69
  cpu          : usr=3D4.55%, sys=3D13.30%, ctx=3D259109, majf=3D0, minf=3D=
27
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D638666/0/0, short=3D0/0/0
     lat (usec): 2=3D21.65%, 4=3D30.12%, 10=3D7.42%, 20=3D0.69%, 50=3D0.06%
     lat (usec): 100=3D0.01%, 250=3D14.58%, 500=3D21.58%, 750=3D3.85%, 1000=
=3D0.01%
     lat (msec): 2=3D0.02%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%
     lat (msec): 100=3D0.01%
sequentielllesen: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D20820
  read : io=3D2048.0MB, bw=3D267392KB/s, iops=3D33432 , runt=3D  7843msec
    clat (usec): min=3D0 , max=3D4098 , avg=3D28.40, stdev=3D143.49
     lat (usec): min=3D0 , max=3D4098 , avg=3D28.51, stdev=3D143.49
    bw (KB/s) : min=3D176584, max=3D275993, per=3D100.04%, avg=3D267511.13,=
=20
stdev=3D25285.86
  cpu          : usr=3D4.18%, sys=3D21.27%, ctx=3D8616, majf=3D0, minf=3D29
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,=20
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
>=3D64=3D0.0%
     issued r/w/d: total=3D262210/0/0, short=3D0/0/0
     lat (usec): 2=3D26.04%, 4=3D47.22%, 10=3D21.85%, 20=3D1.61%, 50=3D0.13%
     lat (usec): 100=3D0.02%, 250=3D0.01%, 500=3D0.01%, 750=3D0.14%, 1000=
=3D2.96%
     lat (msec): 2=3D0.01%, 4=3D0.01%, 10=3D0.01%

Run status group 0 (all jobs):
  WRITE: io=3D2048.0MB, aggrb=3D16685KB/s, minb=3D17085KB/s, maxb=3D17085KB=
/s,=20
mint=3D125687msec, maxt=3D125687msec

Run status group 1 (all jobs):
  WRITE: io=3D2048.0MB, aggrb=3D49400KB/s, minb=3D50586KB/s, maxb=3D50586KB=
/s,=20
mint=3D42452msec, maxt=3D42452msec

Run status group 2 (all jobs):
   READ: io=3D2048.0MB, aggrb=3D23151KB/s, minb=3D23707KB/s, maxb=3D23707KB=
/s,=20
mint=3D90584msec, maxt=3D90584msec

Run status group 3 (all jobs):
   READ: io=3D2048.0MB, aggrb=3D267391KB/s, minb=3D273808KB/s, maxb=3D27380=
8KB/s,=20
mint=3D7843msec, maxt=3D7843msec

Disk stats (read/write):
  dm-2: ios=3D832862/416089, merge=3D0/0, ticks=3D206456/6699696,=20
in_queue=3D6907728, util=3D78.36%, aggrios=3D833046/418069, aggrmerge=3D95/=
663,=20
aggrticks=3D206032/6668768, aggrin_queue=3D6873712, aggrutil=3D77.80%
    sda: ios=3D833046/418069, merge=3D95/663, ticks=3D206032/6668768,=20
in_queue=3D6873712, util=3D77.80%

martin@merkaba:~[...]> diff -u iops.job iops-done-right.job=20
=2D-- iops.job    2011-07-29 16:40:41.776809061 +0200
+++ iops-done-right.job 2011-08-02 16:15:06.055626894 +0200
@@ -19,4 +19,5 @@
 stonewall
 [sequentielllesen]
 rw=3Dread
+stonewall


So always question results that don=C2=B4t make sense.

May this serve as pointer should anyone stumple upon something like this=20
;)

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-00=_gpAOONAN8Ii58Xz
Content-Type: text/plain;
  charset="UTF-8";
  name*=UTF-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-given%2Ejob
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename*=utf-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-given%2Ejob

[global]
rw=3Drandread
size=3D2g
bsrange=3D2-16k
filename=3Dzuf=C3=A4lliglesen.1.0

[zuf=C3=A4lliglesen]
stonewall
[sequentielllesen]
rw=3Dread

--Boundary-00=_gpAOONAN8Ii58Xz
Content-Type: text/plain;
  charset="UTF-8";
  name*=UTF-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-given%2Eresults
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename*=utf-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-given%2Eresults

zuf=C3=A4lliglesen: (g=3D0): rw=3Drandread, bs=3D2-16K/2-16K, ioengine=3Dsy=
nc, iodepth=3D1
sequentielllesen: (g=3D0): rw=3Dread, bs=3D2-16K/2-16K, ioengine=3Dsync, io=
depth=3D1
fio 1.57
Starting 2 processes

zuf=C3=A4lliglesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14723
  read : io=3D2048.0MB, bw=3D186066KB/s, iops=3D56794 , runt=3D 11271msec
    clat (usec): min=3D0 , max=3D103559 , avg=3D15.57, stdev=3D1069.35
     lat (usec): min=3D0 , max=3D103559 , avg=3D15.62, stdev=3D1069.35
    bw (KB/s) : min=3D  243, max=3D843245, per=3D53.37%, avg=3D198607.29, s=
tdev=3D327979.47
  cpu          : usr=3D11.54%, sys=3D9.26%, ctx=3D3392, majf=3D0, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D640132/0/0, short=3D0/0/0
     lat (usec): 2=3D67.88%, 4=3D25.43%, 10=3D5.79%, 20=3D0.36%, 50=3D0.05%
     lat (usec): 100=3D0.01%, 250=3D0.15%, 500=3D0.26%, 750=3D0.04%, 1000=
=3D0.01%
     lat (msec): 2=3D0.01%, 4=3D0.03%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%
     lat (msec): 100=3D0.01%, 250=3D0.01%
sequentielllesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14724
  read : io=3D2048.0MB, bw=3D255813KB/s, iops=3D31989 , runt=3D  8198msec
    clat (usec): min=3D0 , max=3D22658 , avg=3D30.46, stdev=3D171.40
     lat (usec): min=3D0 , max=3D22658 , avg=3D30.56, stdev=3D171.39
    bw (KB/s) : min=3D240308, max=3D264524, per=3D68.85%, avg=3D256220.81, =
stdev=3D6556.93
  cpu          : usr=3D4.39%, sys=3D17.18%, ctx=3D8630, majf=3D0, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D262251/0/0, short=3D0/0/0
     lat (usec): 2=3D26.88%, 4=3D48.21%, 10=3D19.94%, 20=3D1.59%, 50=3D0.16%
     lat (usec): 100=3D0.09%, 250=3D0.04%, 500=3D0.05%, 750=3D0.16%, 1000=
=3D2.60%
     lat (msec): 2=3D0.21%, 4=3D0.06%, 50=3D0.01%

Run status group 0 (all jobs):
   READ: io=3D4096.0MB, aggrb=3D372132KB/s, minb=3D190531KB/s, maxb=3D26195=
2KB/s, mint=3D8198msec, maxt=3D11271msec

Disk stats (read/write):
  dm-2: ios=3D11567/15, merge=3D0/0, ticks=3D23592/508, in_queue=3D24100, u=
til=3D79.23%, aggrios=3D11473/353, aggrmerge=3D156/14, aggrticks=3D24556/23=
32, aggrin_queue=3D26864, aggrutil=3D77.77%
    sda: ios=3D11473/353, merge=3D156/14, ticks=3D24556/2332, in_queue=3D26=
864, util=3D77.77%

--Boundary-00=_gpAOONAN8Ii58Xz
Content-Type: text/plain;
  charset="UTF-8";
  name*=UTF-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-implicit%2Ejob
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename*=utf-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-implicit%2Ejob

[global]
rw=3Drandread
size=3D2g
bsrange=3D2-16k
#filename=3Dzuf=C3=A4lliglesen.1.0

[zuf=C3=A4lliglesen]
stonewall
[sequentielllesen]
rw=3Dread

--Boundary-00=_gpAOONAN8Ii58Xz
Content-Type: text/plain;
  charset="UTF-8";
  name*=UTF-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-implicit%2Eresults
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename*=utf-8''zweierlei-lesen-2gb-variable-blockgr%C3%B6%C3%9Fen-jobfile-implicit%2Eresults

zuf=C3=A4lliglesen: (g=3D0): rw=3Drandread, bs=3D2-16K/2-16K, ioengine=3Dsy=
nc, iodepth=3D1
sequentielllesen: (g=3D0): rw=3Dread, bs=3D2-16K/2-16K, ioengine=3Dsync, io=
depth=3D1
fio 1.57
Starting 2 processes

zuf=C3=A4lliglesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14745
  read : io=3D2048.0MB, bw=3D21516KB/s, iops=3D6567 , runt=3D 97469msec
    clat (usec): min=3D0 , max=3D103566 , avg=3D146.45, stdev=3D1099.54
     lat (usec): min=3D0 , max=3D103566 , avg=3D146.68, stdev=3D1099.56
    bw (KB/s) : min=3D  132, max=3D118508, per=3D49.82%, avg=3D21437.43, st=
dev=3D13479.42
  cpu          : usr=3D4.87%, sys=3D11.20%, ctx=3D261968, majf=3D0, minf=3D=
26
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D640153/0/0, short=3D0/0/0
     lat (usec): 2=3D21.55%, 4=3D30.22%, 10=3D7.16%, 20=3D0.58%, 50=3D0.06%
     lat (usec): 100=3D0.01%, 250=3D15.55%, 500=3D21.14%, 750=3D3.68%, 1000=
=3D0.01%
     lat (msec): 2=3D0.01%, 4=3D0.03%, 20=3D0.01%, 50=3D0.01%, 100=3D0.01%
     lat (msec): 250=3D0.01%
sequentielllesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14746
  read : io=3D2048.0MB, bw=3D256909KB/s, iops=3D32115 , runt=3D  8163msec
    clat (usec): min=3D0 , max=3D3979 , avg=3D30.33, stdev=3D166.59
     lat (usec): min=3D0 , max=3D3979 , avg=3D30.44, stdev=3D166.58
    bw (KB/s) : min=3D245618, max=3D267008, per=3D597.43%, avg=3D257087.19,=
 stdev=3D6569.89
  cpu          : usr=3D3.97%, sys=3D17.30%, ctx=3D8475, majf=3D0, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D262162/0/0, short=3D0/0/0
     lat (usec): 2=3D28.30%, 4=3D47.36%, 10=3D19.41%, 20=3D1.64%, 50=3D0.15%
     lat (usec): 100=3D0.06%, 250=3D0.01%, 500=3D0.01%, 750=3D0.11%, 1000=
=3D2.69%
     lat (msec): 2=3D0.20%, 4=3D0.06%

Run status group 0 (all jobs):
   READ: io=3D4096.0MB, aggrb=3D43032KB/s, minb=3D22032KB/s, maxb=3D263075K=
B/s, mint=3D8163msec, maxt=3D97469msec

Disk stats (read/write):
  dm-2: ios=3D267158/84, merge=3D0/0, ticks=3D94852/676, in_queue=3D95528, =
util=3D82.25%, aggrios=3D267040/962, aggrmerge=3D164/37, aggrticks=3D94356/=
5816, aggrin_queue=3D99820, aggrutil=3D81.77%
    sda: ios=3D267040/962, merge=3D164/37, ticks=3D94356/5816, in_queue=3D9=
9820, util=3D81.77%

--Boundary-00=_gpAOONAN8Ii58Xz--


