Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:48899 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1HDI6d (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Aug 2011 04:58:33 -0400
Message-ID: <4E3A5F36.5030608@kernel.dk>
Date: Thu, 04 Aug 2011 10:58:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Measuring IOPS
References: <201107291737.40463.Martin@lichtvoll.de> <201108032242.16778.Martin@lichtvoll.de> <201108032250.30096.Martin@lichtvoll.de> (sfid-20110803_225042_182315_A1EC7ADB) <201108041051.16366.Martin@lichtvoll.de>
In-Reply-To: <201108041051.16366.Martin@lichtvoll.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org

On 2011-08-04 10:51, Martin Steigerwald wrote:
> Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
>> Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
>>> Am Mittwoch, 3. August 2011 schrieben Sie:
>>>> Martin Steigerwald <Martin@lichtvoll.de> writes:
>> [...]
>>
>>> Does using iodepth > 1 need ioengine=3Dlibaio? Let=EF=BF=BDs see the ma=
npage:
>>>        iodepth=3Dint
>>>       =20
>>>               Number  of I/O units to keep in flight against the
>>>               file. Note that increasing iodepth beyond  1  will
>>>               not affect synchronous ioengines (except for small
>>>               degress when verify_async is in use).  Even  async
>>>               engines  my  impose  OS  restrictions  causing the
>>>               desired depth not to be achieved.  This may happen
>>>               on   Linux  when  using  libaio  and  not  setting
>>>               direct=3D1, since buffered IO is not async  on  that
>>>               OS.  Keep  an  eye on the IO depth distribution in
>>>               the fio output to verify that the  achieved  depth
>>>               is as expected. Default: 1.
>>>
>>> Okay, yes, it does. I start getting a hang on it. Its a bit puzzling
>>> to have two concepts of synchronous I/O around:
>>>
>>> 1) synchronous system call interfaces aka fio I/O engine
>>>
>>> 2) synchronous I/O requests aka O_SYNC
>>
>> But isn=EF=BF=BDt this a case for iodepth=3D1 if buffered I/O on Linux is
>> synchronous? I bet most regular applications except some databases use
>> buffered I/O.
>=20
> Thanks a lot for your answers, Jens, Jeff, DongJin.
>=20
> Now what about the above one?
>=20
> In what cases is iodepth > 1 relevant, when Linux buffered I/O is=20
> synchronous? For mutiple threads or processes?

iodepth controls what depth fio operates at, not the OS. You are right
in that with iodepth=3D1, for buffered writes you could be seeing a much
higher depth on the device side.

So think of iodepth as how many IO units fio can have in flight, nothing
else.

> One process / thread can only submit one I/O at a time with synchronous=20
> system call I/O, but the function returns when the stuff is in the page=20
> cache. So first why can=EF=BF=BDt Linux use iodepth > 1 when there is lot=
s of stuff=20
> in the page cache to be written out? That should help the single process =

> case.

Since the IO unit is done when the system call returns, you can never
have more than the one in flight for a sync engine. So iodepth > 1 makes
no sense for a sync engine.

> On the mutiple process/threadsa case Linux gets several I/O requests from=
=20
> mutiple processes/threads and thus iodepth > 1 does make sense?

No.

> Maybe it helps getting clear where in the stack iodepth is located at, is=
=20
> it
>=20
> process / thread
> systemcall
> pagecache
> blocklayer
> iodepth
> device driver
> device
>=20
> ? If so, why can=EF=BF=BDt Linux  not make use of iodepth > 1 with synchr=
onous=20
> system call I/O? Or is it further up on the system call level? But then=20

Because it is sync. The very nature of the sync system calls is that
submission and completion are one event. For libaio, you could submit a
bunch of requests before retrieving or waiting for completion of any one
of them.

The only example where a sync engine could drive a higher queue depth on
the device side is buffered writes. For any other case (reads, direct
writes), you need async submission to build up a higher queue depth.

> what sense would it make there, when using system calls that are=20
> asynchronous already?
> (Is that ordering above correct at all?)

Your ordering looks OK. Now consider where and how you end up waiting
for issued IO, that should tell you where queue depth could build up or
not.

--=20
Jens Axboe

