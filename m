Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46907 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2HOLbz convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 15 Aug 2012 07:31:55 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How to do strict synchronous i/o on Windows?
Date: Wed, 15 Aug 2012 13:31:51 +0200
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com> <201208150927.03782.Martin@lichtvoll.de> <CAHaS=QyLn0Dy9pzv_gPUVC8r9pDCi39FemAz0qkROVKDei3Lnw@mail.gmail.com> (sfid-20120815_132645_838029_57464B41)
In-Reply-To: <CAHaS=QyLn0Dy9pzv_gPUVC8r9pDCi39FemAz0qkROVKDei3Lnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201208151331.51420.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

Am Mittwoch, 15. August 2012 schrieb Greg Sullivan:
> On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Mittwoch, 15. August 2012 schrieb Greg Sullivan:
> >> On 15 August 2012 07:24, Martin Steigerwald <Martin@lichtvoll.de> wrot=
e:
> >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> > > On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> >> > > > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> > > >> On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> >> > > >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> > > >> >> On 15 August 2012 03:36, Martin Steigerwald
> >> > > >> >> <Martin@lichtvoll.de>
> >> > > >> >>=20
> >> > > >> >> wrote:
> >> > > >> >> > Hi Greg,
> >> > > >> >=20
> >> > > >> > [=EF=BF=BD]
> >> > > >> >=20
> >> > > >> >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> > > >> >> >> On Aug 14, 2012 11:06 PM, "Jens Axboe"
> >> > > >> >> >> <axboe@kernel.dk>
> >=20
> > wrote:
> >> > > >> >> >> > On 08/14/2012 08:24 AM, Greg Sullivan wrote:
> >> > [=EF=BF=BD]
> >> >=20
> >> > > >> >> Is it possible to read from more than file in a single
> >> > > >> >> job, in a round-robin fashion? I tried putting more than
> >> > > >> >> one file in a single job, but it only opened one file. If
> >> > > >> >> you mean to just do random reads in a single file - I've
> >> > > >> >> tried that, and the throughput is unrealistically low. I
> >> > > >> >> suspect it's because the read-ahead buffer cannot be
> >> > > >> >> effective for random accesses.  Of course, reading
> >> > > >> >> sequentially from a single file will result in a
> >> > > >> >> throughput that is far too high to simulate the
> >> > > >> >> application.
> >> > > >> >=20
> >> > > >> > Have you tried
> >> > > >> >=20
> >> > > >> >        nrfiles=3Dint
> >> > > >> >       =20
> >> > > >> >               Number of files to use for this job.=20
> >> > > >> >               Default: 1.
> >> > > >> >       =20
> >> > > >> >        openfiles=3Dint
> >> > > >> >       =20
> >> > > >> >               Number of files to keep open at the same
> >> > > >> >               time. Default: nrfiles.
> >> > > >> >       =20
> >> > > >> >        file_service_type=3Dstr
> >> > > >=20
> >> > > > [=EF=BF=BD]
> >> > > >=20
> >> > > >> > ? (see fio manpage).
> >> > > >> >=20
> >> > > >> > It seems to me that all you need is nrfiles. I=EF=BF=BDd bet =
that
> >> > > >> > fio distributes
> >> > > >> > the I/O size given among those files, but AFAIR there is
> >> > > >> > something about
> >> > > >> > that in fio documentation as well.
> >> > > >> >=20
> >> > > >> > Use the doc! ;)
> >> > > >=20
> >> > > > [=EF=BF=BD]
> >> > > >=20
> >> > > >> Yes, I have tried all that, and it works, except that it
> >> > > >> causes disk queuing, as I stated in my first post. I thought
> >> > > >> you meant to put all the files into a single [job name]
> >> > > >> section of the ini file, to enforce single threaded io.
> >> > > >=20
> >> > > > With just one job running at once?
> >> > > >=20
> >> > > > Can you post an example job file?
> >> > > >=20
> >> > > > Did you try the sync=3D1 / direct=3D1 suggestion from Bruce Chan?
> >> > > >=20
> >> > > > I only know the behaviour of fio on Linux where I/O depth of
> >> > > > greater than one is only possible with libaio and direct=3D1.
> >> > > > The manpage hints at I/O depth is one for all synchronous I/O
> >> > > > engines, so I=EF=BF=BDd bet that refers to Windows as well.
> >> > > >=20
> >> > > > Other than that I have no idea.
> >> >=20
> >> > [=EF=BF=BD]
> >> >=20
> >> > > One INI file, but a seperate [job name] section for each file,
> >> > > yes. According to Jens, because each [job name] is a seperate
> >> > > thread, and iodepth acts at the thread level, there will still
> >> > > be queuing at the device level. If there were a way to do what
> >> > > I want I think Jens would have told me, unfortunately.   ;)
> >> > >=20
> >> > > direct io does at least allow me to do cache-less reads though -
> >> > > thankyou.
> >> >=20
> >> > My suggestion is to use one job with several files.
> >> >=20
> >> > martin@merkaba:/tmp> cat severalfiles.job
> >> > [global]
> >> > size=3D1G
> >> > nrfiles=3D100
> >> >=20
> >> > [read]
> >> > rw=3Dread
> >> >=20
> >> > [write]
> >> > stonewall
> >> > rw=3Dwrite
> >> >=20
> >> > (now these are two jobs, but stonewall lets the write job run
> >> > after the read one with cache invalidation if not disabled and if
> >> > supported by OS)
> >> >=20
> >> > martin@merkaba:/tmp> fio severalfiles.job
> >> > read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1
> >> > write: (g=3D1): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodep=
th=3D1
> >> > 2.0.8
> >> > Starting 2 processes
> >> > read: Laying out IO file(s) (100 file(s) / 1023MB)
> >> > write: Laying out IO file(s) (100 file(s) / 1023MB)
> >> > Jobs: 1 (f=3D100)
> >> > read: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D23377
> >> > [=EF=BF=BD lots of fast due to /tmp being a RAM-based filesystem =EF=
=BF=BD tmpfs
> >> > =EF=BF=BD]
> >> >=20
> >> >=20
> >> > martin@merkaba:/tmp> ls -lh read.1.* | head
> >> > -rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.0
> >> > -rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.1
> >=20
> > [=EF=BF=BD]
> >=20
> >> > [=EF=BF=BD only first ten displayed =EF=BF=BD]
> >> >=20
> >> > martin@merkaba:/tmp> find -name "read.1*" 2>/dev/null | wc -l
> >> > 100
> >> >=20
> >> > 100 files a 11M, due to rounding issues that may nicely add up to
> >> > the one GiB.
> >> >=20
> >> > Raw sizes are:
> >> >=20
> >> > martin@merkaba:/tmp> ls -l read.1.* | head
> >> > -rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.0
> >> > -rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.1
> >=20
> > [=EF=BF=BD]
> >=20
> >> > Note: When I used filename, fio just created one files regardless
> >> > of the nrfiles setting. I would have expected it to use the
> >> > filename as a prefix. There might be some way to have it do that.
> >> >=20
> >> > Ciao,
> >>=20
> >> Thanks - that runs, but it's still queuing. As I said before, I
> >> can't use the sync engine - I receive an error. Is there a
> >> synchronous engine available for Windows? Perhaps that's the only
> >> problem. Can you check to see whether your system is queuing at the
> >> file system/device level when you run that test?
> >>=20
> >> I had attempted to put the files in a single job earlier - I think
> >> it may have been successfully accessing both files, but I didn't
> >> notice it in the output. I'm a raw beginner.
> >=20
> > Did you try with
> >=20
> > ioengine=3Dwindowsaio
> >=20
> > +
> >=20
> > iodepth=3D1 (should be default however I think)
> >=20
> >=20
> > Otherwise I have no idea. I never used fio on Windows so far.
> >=20
> > It might help when you try to explain exactly which problem you want
> > to solve by the fio measurements. Multimedia streaming. Is it to
> > slow? What is
> >=20
> > it why you want to do these measurements?
>=20
> They are both defaults, and the output shows that both are being used.
> If you could tell me whether your system is generating queuing it
> would help, because if yours queues even when using the sync io
> engine, it means I'm wasting my time and fio simply needs to be
> augmented to support strict single threaded operation over multiple
> files.
>=20
> I am wanting to determine whether the application in question is
> extracting a reasonable number of real time streams from any given
> storage system.

Just for the record since you got it working on Windows as well =EF=BF=BD i=
t works for me:

merkaba:/tmp> cat severalfiles.job=20
[global]
size=3D1G
nrfiles=3D100

[read]
rw=3Dread

merkaba:/tmp> fio severalfiles.job
read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
2.0.8
Starting 1 process

read: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4579
  read : io=3D1023.9MB, bw=3D2409.7MB/s, iops=3D616705 , runt=3D   425msec
    clat (usec): min=3D0 , max=3D54 , avg=3D 1.08, stdev=3D 0.64
     lat (usec): min=3D0 , max=3D54 , avg=3D 1.13, stdev=3D 0.66
    clat percentiles (usec):
     |  1.00th=3D[    0],  5.00th=3D[    1], 10.00th=3D[    1], 20.00th=3D[=
    1],
     | 30.00th=3D[    1], 40.00th=3D[    1], 50.00th=3D[    1], 60.00th=3D[=
    1],
     | 70.00th=3D[    1], 80.00th=3D[    1], 90.00th=3D[    1], 95.00th=3D[=
    2],
     | 99.00th=3D[    2], 99.50th=3D[    2], 99.90th=3D[   14], 99.95th=3D[=
   16],
     | 99.99th=3D[   23]
    lat (usec) : 2=3D92.14%, 4=3D7.74%, 10=3D0.01%, 20=3D0.10%, 50=3D0.01%
    lat (usec) : 100=3D0.01%
  cpu          : usr=3D22.41%, sys=3D76.42%, ctx=3D421, majf=3D0, minf=3D36
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D262100/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0

Run status group 0 (all jobs):
   READ: io=3D1023.9MB, aggrb=3D2409.7MB/s, minb=3D2409.7MB/s, maxb=3D2409.=
7MB/s, mint=3D425msec, maxt=3D425msec

(if you wonder about the figures =EF=BF=BD thats RAM testing =EF=BF=BD Linu=
x tmpfs ;)

100% at IO depth 1.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
