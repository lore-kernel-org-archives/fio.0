Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60012 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2HNVYt convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 14 Aug 2012 17:24:49 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How to do strict synchronous i/o on Windows?
Date: Tue, 14 Aug 2012 23:24:48 +0200
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com> <201208142232.41100.Martin@lichtvoll.de> <CAHaS=QzFqSB_eo1fWCw4ddQjFfuhuuQaiU2VsV-7XSzSkCfp8A@mail.gmail.com> (sfid-20120814_230609_307367_9A7A281A)
In-Reply-To: <CAHaS=QzFqSB_eo1fWCw4ddQjFfuhuuQaiU2VsV-7XSzSkCfp8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201208142324.48504.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> >> On 15 August 2012 03:36, Martin Steigerwald <Martin@lichtvoll.de>
> >> >> wrote:
> >> >> > Hi Greg,
> >> > [=EF=BF=BD]
> >> >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >> >> >
> >> >> >> On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
> >> >> >> >
> >> >> >> > On 08/14/2012 08:24 AM, Greg Sullivan wrote:
[=EF=BF=BD]
> >> >> Is it possible to read from more than file in a single job, in a
> >> >> round-robin fashion? I tried putting more than one file in a single
> >> >> job, but it only opened one file. If you mean to just do random rea=
ds
> >> >> in a single file - I've tried that, and the throughput is
> >> >> unrealistically low. I suspect it's because the read-ahead buffer
> >> >> cannot be effective for random accesses.  Of course, reading
> >> >> sequentially from a single file will result in a throughput that is
> >> >> far too high to simulate the application.
> >> >
> >> > Have you tried
> >> >
> >> >        nrfiles=3Dint
> >> >               Number of files to use for this job.  Default: 1.
> >> >
> >> >        openfiles=3Dint
> >> >               Number of files to keep open at the same time.  Defaul=
t:
> >> >               nrfiles.
> >> >
> >> >        file_service_type=3Dstr
> > [=EF=BF=BD]
> >> > ? (see fio manpage).
> >> >
> >> > It seems to me that all you need is nrfiles. I=EF=BF=BDd bet that fio
> >> > distributes
> >> > the I/O size given among those files, but AFAIR there is something
> >> > about
> >> > that in fio documentation as well.
> >> >
> >> > Use the doc! ;)
> > [=EF=BF=BD]
> >> Yes, I have tried all that, and it works, except that it causes disk
> >> queuing, as I stated in my first post. I thought you meant to put all
> >> the files into a single [job name] section of the ini file, to enforce
> >> single threaded io.
> >
> > With just one job running at once?
> >
> > Can you post an example job file?
> >
> > Did you try the sync=3D1 / direct=3D1 suggestion from Bruce Chan?
> >
> > I only know the behaviour of fio on Linux where I/O depth of greater
> > than one is only possible with libaio and direct=3D1. The manpage hints
> > at I/O depth is one for all synchronous I/O engines, so I=EF=BF=BDd bet=
 that
> > refers to Windows as well.
> >
> > Other than that I have no idea.
[=EF=BF=BD]
> One INI file, but a seperate [job name] section for each file, yes.
> According to Jens, because each [job name] is a seperate thread, and
> iodepth acts at the thread level, there will still be queuing at the
> device level. If there were a way to do what I want I think Jens would
> have told me, unfortunately.   ;)
>=20
> direct io does at least allow me to do cache-less reads though - thankyou.

My suggestion is to use one job with several files.

martin@merkaba:/tmp> cat severalfiles.job=20
[global]
size=3D1G
nrfiles=3D100

[read]
rw=3Dread

[write]
stonewall
rw=3Dwrite

(now these are two jobs, but stonewall lets the write job run after the
read one with cache invalidation if not disabled and if supported by OS)

martin@merkaba:/tmp> fio severalfiles.job
read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
write: (g=3D1): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
2.0.8
Starting 2 processes
read: Laying out IO file(s) (100 file(s) / 1023MB)
write: Laying out IO file(s) (100 file(s) / 1023MB)
Jobs: 1 (f=3D100)
read: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D23377
[=EF=BF=BD lots of fast due to /tmp being a RAM-based filesystem =EF=BF=BD =
tmpfs =EF=BF=BD]


martin@merkaba:/tmp> ls -lh read.1.* | head
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.0
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.1
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.10
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.11
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.12
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.13
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.14
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.15
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.16
-rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.17
[=EF=BF=BD only first ten displayed =EF=BF=BD]

martin@merkaba:/tmp> find -name "read.1*" 2>/dev/null | wc -l
100

100 files a 11M, due to rounding issues that may nicely add up to
the one GiB.

Raw sizes are:

martin@merkaba:/tmp> ls -l read.1.* | head                 =20
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.0
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.1
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.10
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.11
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.12
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.13
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.14
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.15
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.16
-rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.17

Note: When I used filename, fio just created one files regardless of the
nrfiles setting. I would have expected it to use the filename as a prefix.
There might be some way to have it do that.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
