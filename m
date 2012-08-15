Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab2HOOHR convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 15 Aug 2012 10:07:17 -0400
Received: by bkwj10 with SMTP id j10so533886bkw.19
        for <fio@vger.kernel.org>; Wed, 15 Aug 2012 07:07:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208151331.51420.Martin@lichtvoll.de>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
	<201208150927.03782.Martin@lichtvoll.de>
	<CAHaS=QyLn0Dy9pzv_gPUVC8r9pDCi39FemAz0qkROVKDei3Lnw@mail.gmail.com>
	<201208151331.51420.Martin@lichtvoll.de>
Date: Thu, 16 Aug 2012 00:07:15 +1000
Message-ID: <CAHaS=Qynp8RekMAXO2iV-fC=FRjyJ2eq_Wj75QzyT5i=RBfvzQ@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 15 August 2012 21:31, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Mittwoch, 15. August 2012 schrieb Greg Sullivan:
>> On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>> > Am Mittwoch, 15. August 2012 schrieb Greg Sullivan:
>> >> On 15 August 2012 07:24, Martin Steigerwald <Martin@lichtvoll.de> wro=
te:
>> >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
>> >> > > On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>> >> > > > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
>> >> > > >> On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>> >> > > >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
>> >> > > >> >> On 15 August 2012 03:36, Martin Steigerwald
>> >> > > >> >> <Martin@lichtvoll.de>
>> >> > > >> >>
>> >> > > >> >> wrote:
>> >> > > >> >> > Hi Greg,
>> >> > > >> >
>> >> > > >> > [=EF=BF=BD]
>> >> > > >> >
>> >> > > >> >> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
>> >> > > >> >> >> On Aug 14, 2012 11:06 PM, "Jens Axboe"
>> >> > > >> >> >> <axboe@kernel.dk>
>> >
>> > wrote:
>> >> > > >> >> >> > On 08/14/2012 08:24 AM, Greg Sullivan wrote:
>> >> > [=EF=BF=BD]
>> >> >
>> >> > > >> >> Is it possible to read from more than file in a single
>> >> > > >> >> job, in a round-robin fashion? I tried putting more than
>> >> > > >> >> one file in a single job, but it only opened one file. If
>> >> > > >> >> you mean to just do random reads in a single file - I've
>> >> > > >> >> tried that, and the throughput is unrealistically low. I
>> >> > > >> >> suspect it's because the read-ahead buffer cannot be
>> >> > > >> >> effective for random accesses.  Of course, reading
>> >> > > >> >> sequentially from a single file will result in a
>> >> > > >> >> throughput that is far too high to simulate the
>> >> > > >> >> application.
>> >> > > >> >
>> >> > > >> > Have you tried
>> >> > > >> >
>> >> > > >> >        nrfiles=3Dint
>> >> > > >> >
>> >> > > >> >               Number of files to use for this job.
>> >> > > >> >               Default: 1.
>> >> > > >> >
>> >> > > >> >        openfiles=3Dint
>> >> > > >> >
>> >> > > >> >               Number of files to keep open at the same
>> >> > > >> >               time. Default: nrfiles.
>> >> > > >> >
>> >> > > >> >        file_service_type=3Dstr
>> >> > > >
>> >> > > > [=EF=BF=BD]
>> >> > > >
>> >> > > >> > ? (see fio manpage).
>> >> > > >> >
>> >> > > >> > It seems to me that all you need is nrfiles. I=EF=BF=BDd bet=
 that
>> >> > > >> > fio distributes
>> >> > > >> > the I/O size given among those files, but AFAIR there is
>> >> > > >> > something about
>> >> > > >> > that in fio documentation as well.
>> >> > > >> >
>> >> > > >> > Use the doc! ;)
>> >> > > >
>> >> > > > [=EF=BF=BD]
>> >> > > >
>> >> > > >> Yes, I have tried all that, and it works, except that it
>> >> > > >> causes disk queuing, as I stated in my first post. I thought
>> >> > > >> you meant to put all the files into a single [job name]
>> >> > > >> section of the ini file, to enforce single threaded io.
>> >> > > >
>> >> > > > With just one job running at once?
>> >> > > >
>> >> > > > Can you post an example job file?
>> >> > > >
>> >> > > > Did you try the sync=3D1 / direct=3D1 suggestion from Bruce Cha=
n?
>> >> > > >
>> >> > > > I only know the behaviour of fio on Linux where I/O depth of
>> >> > > > greater than one is only possible with libaio and direct=3D1.
>> >> > > > The manpage hints at I/O depth is one for all synchronous I/O
>> >> > > > engines, so I=EF=BF=BDd bet that refers to Windows as well.
>> >> > > >
>> >> > > > Other than that I have no idea.
>> >> >
>> >> > [=EF=BF=BD]
>> >> >
>> >> > > One INI file, but a seperate [job name] section for each file,
>> >> > > yes. According to Jens, because each [job name] is a seperate
>> >> > > thread, and iodepth acts at the thread level, there will still
>> >> > > be queuing at the device level. If there were a way to do what
>> >> > > I want I think Jens would have told me, unfortunately.   ;)
>> >> > >
>> >> > > direct io does at least allow me to do cache-less reads though -
>> >> > > thankyou.
>> >> >
>> >> > My suggestion is to use one job with several files.
>> >> >
>> >> > martin@merkaba:/tmp> cat severalfiles.job
>> >> > [global]
>> >> > size=3D1G
>> >> > nrfiles=3D100
>> >> >
>> >> > [read]
>> >> > rw=3Dread
>> >> >
>> >> > [write]
>> >> > stonewall
>> >> > rw=3Dwrite
>> >> >
>> >> > (now these are two jobs, but stonewall lets the write job run
>> >> > after the read one with cache invalidation if not disabled and if
>> >> > supported by OS)
>> >> >
>> >> > martin@merkaba:/tmp> fio severalfiles.job
>> >> > read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodept=
h=3D1
>> >> > write: (g=3D1): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iode=
pth=3D1
>> >> > 2.0.8
>> >> > Starting 2 processes
>> >> > read: Laying out IO file(s) (100 file(s) / 1023MB)
>> >> > write: Laying out IO file(s) (100 file(s) / 1023MB)
>> >> > Jobs: 1 (f=3D100)
>> >> > read: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D23377
>> >> > [=EF=BF=BD lots of fast due to /tmp being a RAM-based filesystem =
=EF=BF=BD tmpfs
>> >> > =EF=BF=BD]
>> >> >
>> >> >
>> >> > martin@merkaba:/tmp> ls -lh read.1.* | head
>> >> > -rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.0
>> >> > -rw-r--r-- 1 martin martin 11M Aug 14 23:15 read.1.1
>> >
>> > [=EF=BF=BD]
>> >
>> >> > [=EF=BF=BD only first ten displayed =EF=BF=BD]
>> >> >
>> >> > martin@merkaba:/tmp> find -name "read.1*" 2>/dev/null | wc -l
>> >> > 100
>> >> >
>> >> > 100 files a 11M, due to rounding issues that may nicely add up to
>> >> > the one GiB.
>> >> >
>> >> > Raw sizes are:
>> >> >
>> >> > martin@merkaba:/tmp> ls -l read.1.* | head
>> >> > -rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.0
>> >> > -rw-r--r-- 1 martin martin 10737418 Aug 14 23:20 read.1.1
>> >
>> > [=EF=BF=BD]
>> >
>> >> > Note: When I used filename, fio just created one files regardless
>> >> > of the nrfiles setting. I would have expected it to use the
>> >> > filename as a prefix. There might be some way to have it do that.
>> >> >
>> >> > Ciao,
>> >>
>> >> Thanks - that runs, but it's still queuing. As I said before, I
>> >> can't use the sync engine - I receive an error. Is there a
>> >> synchronous engine available for Windows? Perhaps that's the only
>> >> problem. Can you check to see whether your system is queuing at the
>> >> file system/device level when you run that test?
>> >>
>> >> I had attempted to put the files in a single job earlier - I think
>> >> it may have been successfully accessing both files, but I didn't
>> >> notice it in the output. I'm a raw beginner.
>> >
>> > Did you try with
>> >
>> > ioengine=3Dwindowsaio
>> >
>> > +
>> >
>> > iodepth=3D1 (should be default however I think)
>> >
>> >
>> > Otherwise I have no idea. I never used fio on Windows so far.
>> >
>> > It might help when you try to explain exactly which problem you want
>> > to solve by the fio measurements. Multimedia streaming. Is it to
>> > slow? What is
>> >
>> > it why you want to do these measurements?
>>
>> They are both defaults, and the output shows that both are being used.
>> If you could tell me whether your system is generating queuing it
>> would help, because if yours queues even when using the sync io
>> engine, it means I'm wasting my time and fio simply needs to be
>> augmented to support strict single threaded operation over multiple
>> files.
>>
>> I am wanting to determine whether the application in question is
>> extracting a reasonable number of real time streams from any given
>> storage system.
>
> Just for the record since you got it working on Windows as well =EF=BF=BD=
 it works for me:
>
> merkaba:/tmp> cat severalfiles.job
> [global]
> size=3D1G
> nrfiles=3D100
>
> [read]
> rw=3Dread
>
> merkaba:/tmp> fio severalfiles.job
> read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
> 2.0.8
> Starting 1 process
>
> read: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4579
>   read : io=3D1023.9MB, bw=3D2409.7MB/s, iops=3D616705 , runt=3D   425msec
>     clat (usec): min=3D0 , max=3D54 , avg=3D 1.08, stdev=3D 0.64
>      lat (usec): min=3D0 , max=3D54 , avg=3D 1.13, stdev=3D 0.66
>     clat percentiles (usec):
>      |  1.00th=3D[    0],  5.00th=3D[    1], 10.00th=3D[    1], 20.00th=
=3D[    1],
>      | 30.00th=3D[    1], 40.00th=3D[    1], 50.00th=3D[    1], 60.00th=
=3D[    1],
>      | 70.00th=3D[    1], 80.00th=3D[    1], 90.00th=3D[    1], 95.00th=
=3D[    2],
>      | 99.00th=3D[    2], 99.50th=3D[    2], 99.90th=3D[   14], 99.95th=
=3D[   16],
>      | 99.99th=3D[   23]
>     lat (usec) : 2=3D92.14%, 4=3D7.74%, 10=3D0.01%, 20=3D0.10%, 50=3D0.01%
>     lat (usec) : 100=3D0.01%
>   cpu          : usr=3D22.41%, sys=3D76.42%, ctx=3D421, majf=3D0, minf=3D=
36
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>      issued    : total=3Dr=3D262100/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0
>
> Run status group 0 (all jobs):
>    READ: io=3D1023.9MB, aggrb=3D2409.7MB/s, minb=3D2409.7MB/s, maxb=3D240=
9.7MB/s, mint=3D425msec, maxt=3D425msec
>
> (if you wonder about the figures =EF=BF=BD thats RAM testing =EF=BF=BD Li=
nux tmpfs ;)
>
> 100% at IO depth 1.
>
> Ciao,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Are you sure that the "100% at IO depth 1" actually means that there
is no queuing at the device? I.e - doesn't that IO depth simply mean
that each thread reached an IO depth of 1, without necessarily
referring to the disk queue?  I'm actually checking my physical disk
queue. Before I was using direct io, the io depths were 100% at 1 just
like yours, but ios were being queued at the device level. I now have
confidence that it probably is working for you, of course, but I'm not
yet convinced that you are doing the correct checking, that's all. ;^)

Greg.
