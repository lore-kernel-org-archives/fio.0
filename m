Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Thu, 4 Aug 2011 10:51:15 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108032242.16778.Martin@lichtvoll.de> <201108032250.30096.Martin@lichtvoll.de> (sfid-20110803_225042_182315_A1EC7ADB)
In-Reply-To: <201108032250.30096.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201108041051.16366.Martin@lichtvoll.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
> Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
> > Am Mittwoch, 3. August 2011 schrieben Sie:
> > > Martin Steigerwald <Martin@lichtvoll.de> writes:
> [...]
>=20
> > Does using iodepth > 1 need ioengine=3Dlibaio? Let=B4s see the manpage:
> >        iodepth=3Dint
> >       =20
> >               Number  of I/O units to keep in flight against the
> >               file. Note that increasing iodepth beyond  1  will
> >               not affect synchronous ioengines (except for small
> >               degress when verify_async is in use).  Even  async
> >               engines  my  impose  OS  restrictions  causing the
> >               desired depth not to be achieved.  This may happen
> >               on   Linux  when  using  libaio  and  not  setting
> >               direct=3D1, since buffered IO is not async  on  that
> >               OS.  Keep  an  eye on the IO depth distribution in
> >               the fio output to verify that the  achieved  depth
> >               is as expected. Default: 1.
> >=20
> > Okay, yes, it does. I start getting a hang on it. Its a bit puzzling
> > to have two concepts of synchronous I/O around:
> >=20
> > 1) synchronous system call interfaces aka fio I/O engine
> >=20
> > 2) synchronous I/O requests aka O_SYNC
>=20
> But isn=B4t this a case for iodepth=3D1 if buffered I/O on Linux is
> synchronous? I bet most regular applications except some databases use
> buffered I/O.

Thanks a lot for your answers, Jens, Jeff, DongJin.

Now what about the above one?

In what cases is iodepth > 1 relevant, when Linux buffered I/O is=20
synchronous? For mutiple threads or processes?

One process / thread can only submit one I/O at a time with synchronous=20
system call I/O, but the function returns when the stuff is in the page=20
cache. So first why can=B4t Linux use iodepth > 1 when there is lots of stu=
ff=20
in the page cache to be written out? That should help the single process=20
case.

On the mutiple process/threadsa case Linux gets several I/O requests from=20
mutiple processes/threads and thus iodepth > 1 does make sense?

Maybe it helps getting clear where in the stack iodepth is located at, is=20
it

process / thread
systemcall
pagecache
blocklayer
iodepth
device driver
device

? If so, why can=B4t Linux  not make use of iodepth > 1 with synchronous=20
system call I/O? Or is it further up on the system call level? But then=20
what sense would it make there, when using system calls that are=20
asynchronous already?
(Is that ordering above correct at all?)

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

