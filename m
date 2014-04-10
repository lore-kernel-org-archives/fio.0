Return-Path: <prvs=1177ddc46d=mario.carino@aig.com>
From: "Carino, Mario" <Mario.Carino@AIG.com>
Date: Thu, 10 Apr 2014 11:30:19 -0400
Subject: RE: fio on AIX - fallocate error
Message-ID: <E2B4022DB0264A4B90C5F1B01B8E677D733228A3@LIVP3MMBX13.mail.aig.net>
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
 <5346A3FE.10106@kernel.dk>
In-Reply-To: <5346A3FE.10106@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Well, that's the thing. We can't get rid of the fallocate error regardless =
of how we set fallocate=3D in the job file. We've tried 0,1,none,posix and =
keep (which seems to be invalid now) and we ALWAYS get the fallocate error.=
 Sometimes the job continues to run, but the output file is only created at=
 zero byte length.

Regards.


Mario Carino
AIG
Database Administrator
IT Infrastructure | AIG Property Casualty
5 Wood Hollow Rd, 3rd Floor, Parsippany, NJ 07054
Tel +1 817 490-7145 | Cell +1 551 655-1443 | Direct +1 973 331-8558 (Mon/We=
d/Thu)
mario.carino@aig.com | www.aig.com


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, April 10, 2014 10:00 AM
To: Carino, Mario; fio@vger.kernel.org
Subject: Re: fio on AIX - fallocate error

On 2014-04-09 20:52, Carino, Mario wrote:
> Hi.
> We're trying to run fio 2.1.7 on AIX 6 and we can't seem to eliminate the=
se errors:
>
> fio: posix_fallocate fails: Invalid argument

This one you can ignore, or you can get rid of it by adding:

fallocate=3Dnone

to the job file.

> fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache,=20
> error=3DInvalid argument

Fio should probably just ignore these flush-cache warnings and continue on,=
 it's not really a fatal condition. I have attached a patch for you, can yo=
u apply that and give it a go?

> we always get one or the other. It doesn't matter too much what=20
> command we run, what options,  etc. We saw a web page which indicates=20
> that fio requires an Asynch IO package to be installed and running on=20
> AIX. Is that correct? We're
 > trying to find out if we have it installed on our test box.

You'd get a different error if that was your issue.

> (We're lowly non-root
 > DBA's so getting anything done requires a committee.)

Isn't that always the case with AIX? :-)

--
Jens Axboe


