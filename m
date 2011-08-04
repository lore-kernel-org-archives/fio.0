Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Thu, 4 Aug 2011 11:34:32 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108041051.16366.Martin@lichtvoll.de> <4E3A5F36.5030608@kernel.dk> (sfid-20110804_110426_432256_D90EC7B3)
In-Reply-To: <4E3A5F36.5030608@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201108041134.33127.Martin@lichtvoll.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am Donnerstag, 4. August 2011 schrieb Jens Axboe:
> On 2011-08-04 10:51, Martin Steigerwald wrote:
> > Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
> >> Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
> >>> Am Mittwoch, 3. August 2011 schrieben Sie:
> >>>> Martin Steigerwald <Martin@lichtvoll.de> writes:
> >> [...]
> >>=20
> >>> Does using iodepth > 1 need ioengine=3Dlibaio? Let=B4s see the manpag=
e:
> >>>        iodepth=3Dint
> >>>       =20
> >>>               Number  of I/O units to keep in flight against the
> >>>               file. Note that increasing iodepth beyond  1  will
> >>>               not affect synchronous ioengines (except for small
> >>>               degress when verify_async is in use).  Even  async
> >>>               engines  my  impose  OS  restrictions  causing the
> >>>               desired depth not to be achieved.  This may happen
> >>>               on   Linux  when  using  libaio  and  not  setting
> >>>               direct=3D1, since buffered IO is not async  on  that
> >>>               OS.  Keep  an  eye on the IO depth distribution in
> >>>               the fio output to verify that the  achieved  depth
> >>>               is as expected. Default: 1.
> >>>=20
> >>> Okay, yes, it does. I start getting a hang on it. Its a bit
> >>> puzzling to have two concepts of synchronous I/O around:
> >>>=20
> >>> 1) synchronous system call interfaces aka fio I/O engine
> >>>=20
> >>> 2) synchronous I/O requests aka O_SYNC
> >>=20
> >> But isn=B4t this a case for iodepth=3D1 if buffered I/O on Linux is
> >> synchronous? I bet most regular applications except some databases
> >> use buffered I/O.
> >=20
> > Thanks a lot for your answers, Jens, Jeff, DongJin.
> >=20
> > Now what about the above one?
> >=20
> > In what cases is iodepth > 1 relevant, when Linux buffered I/O is
> > synchronous? For mutiple threads or processes?
>=20
> iodepth controls what depth fio operates at, not the OS. You are right
> in that with iodepth=3D1, for buffered writes you could be seeing a much
> higher depth on the device side.
>=20
> So think of iodepth as how many IO units fio can have in flight,
> nothing else.

Ah okay. So when using iodepth=3D64 and ioengine=3Dlibaio with fio then fio=
=20
issues 64 I/O requests at once before it bothers waiting for I/O requests=20
to complete. And as the block layer completes I/O requests fio fills up the=
=20
64 I/O requests queue. Right?

Now when I do have two jobs running at once and iodepth=3D64, will each=20
process submit 64 I/O requests before waiting thus having at most 128 I/O=20
requests in flight? Or will each process use 32 I/O requests? My bet is=20
that iodepth is per job, per process.

> > One process / thread can only submit one I/O at a time with
> > synchronous system call I/O, but the function returns when the stuff
> > is in the page cache. So first why can=B4t Linux use iodepth > 1 when
> > there is lots of stuff in the page cache to be written out? That
> > should help the single process case.
>=20
> Since the IO unit is done when the system call returns, you can never
> have more than the one in flight for a sync engine. So iodepth > 1
> makes no sense for a sync engine.

Makes perfect sense then I understand that iodepth option related to what=20
the fio processes do.

> > On the mutiple process/threadsa case Linux gets several I/O requests
> > from mutiple processes/threads and thus iodepth > 1 does make sense?
>=20
> No.

Since each synchronous system call I/O fio job still submits one I/O at a=20
time...

> > Maybe it helps getting clear where in the stack iodepth is located
> > at, is it
> >=20
> > process / thread
> > systemcall
> > pagecache
> > blocklayer
> > iodepth
> > device driver
> > device
> >=20
> > ? If so, why can=B4t Linux  not make use of iodepth > 1 with
> > synchronous system call I/O? Or is it further up on the system call
> > level? But then
>=20
> Because it is sync. The very nature of the sync system calls is that
> submission and completion are one event. For libaio, you could submit a
> bunch of requests before retrieving or waiting for completion of any
> one of them.
>=20
> The only example where a sync engine could drive a higher queue depth
> on the device side is buffered writes. For any other case (reads,
> direct writes), you need async submission to build up a higher queue
> depth.

Great! I think that makes it pretty clear.

Thus when I want to read subsequent blocks 1, 2, 3, 4, 5, 6, 7, 8, 9 and=20
10 from a file at once and then wait I need async I/O.  Block might be of=20
arbitrary size.

What when I use 10 processes, each reading one of these blocks as once?=20
Couldn=B4t this fill up the queue at the device level? But then different=20
processes usually read different files...

=2E.. my question hints at how I/O depths might accumulate at the device=20
level, when several processes are issuing read and/or write requests at=20
once.

> > what sense would it make there, when using system calls that are
> > asynchronous already?
> > (Is that ordering above correct at all?)
>=20
> Your ordering looks OK. Now consider where and how you end up waiting
> for issued IO, that should tell you where queue depth could build up or
> not.

So we have several levels of queue depth.

=2D queue depth at the system call level=20
=2D queue depth at device level

=3D=3D=3D sync I/O engines =3D=3D=3D
queue depth at the system call level =3D 1

=3D=3D reads =3D=3D
queue depth at the device level =3D 1
since read() returns when the data is in RAM and thus is synchronous I/O=20
on the lower level by nature

page cache will be used unless direct=3D1, so one might be measuring RAM /=
=20
read ahead performance, especially when several read jobs are running=20
concurrently.=20

writes might not hit the device unless direct=3D1 and thus one should use=20
larger than RAM file size.

=3D=3D writes =3D=3D
queue depth at the device level =3D depending on the workload upto what the=
=20
device supports

unless direct=3D1, cause then write() is doing synchronous I/O on the lower=
=20
level and only returns when data is at least in drive cache


=3D=3D=3D libaio =3D=3D=3D
queue depth at the system call level =3D iodepth option of fio

as long as direct=3D1, since libaio falls back to synchronous system calls=
=20
with buffered writes

queue depth at the device level =3D same

fio submits as much I/Os as specified by iodepth and only then waits. As th=
e=20
block layer completes I/Os fio fills up the queue.


conclusion:

thus when I want to measure higher I/O depths at read I need libaio and=20
direct=3D1. but then I am measuring something that does not have any=20
practical effect on processes that use synchronous system call I/O.

so for regular applications ioengine=3Dsync + iodepth=3D64 gives more=20
realistic results - even when its then just I/O depth 1 for reads - and=20
for databases that use direct I/O ioengine=3Dlibaio makes sense and will=20
cause higher I/O depths on the device side if it supports it.

anything without direct=3D1 (or the slower sync=3D1) is potentially measuri=
ng=20
RAM performance. direct=3D1 omits the page cache. sync=3D1 basically disabl=
es=20
caching on the device / controller side as well.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

