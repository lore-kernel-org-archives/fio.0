Return-Path: <prvs=1177ddc46d=mario.carino@aig.com>
From: "Carino, Mario" <Mario.Carino@AIG.com>
Date: Thu, 10 Apr 2014 11:56:23 -0400
Subject: RE: fio on AIX - fallocate error
Message-ID: <E2B4022DB0264A4B90C5F1B01B8E677D73322909@LIVP3MMBX13.mail.aig.net>
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
 <5346A3FE.10106@kernel.dk>
 <E2B4022DB0264A4B90C5F1B01B8E677D733228A3@LIVP3MMBX13.mail.aig.net>
 <5346B9FE.10409@kernel.dk>
In-Reply-To: <5346B9FE.10409@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Here's the job file:

[4ktest]
fallocate=3D1
direct=3D1
rw=3Drandwrite
refill_buffers
norandommap
randrepeat=3D0
size=3D2G
bs=3D4k
iodepth=3D16
numjobs=3D16
runtime=3D60
group_reporting

This job file was created based on a sample command line I was given:

fio --filename=3D/oradata2/o18g2/IO/fiotest4 --direct=3D1 --rw=3Drandwrite =
--refill_buffers --norandommap --randrepeat=3D0 --size=3D2G --bs=3D4k  --io=
depth=3D16 --numjobs=3D16 --runtime=3D60 --group_reporting --name=3D4ktest

I think I understand enough that I need to run a rw=3Dwrite job first befor=
e running the above job, correct?

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
Sent: Thursday, April 10, 2014 11:34 AM
To: Carino, Mario; fio@vger.kernel.org
Subject: Re: fio on AIX - fallocate error

On 04/10/2014 09:30 AM, Carino, Mario wrote:
> Hi Jens,
>
> Well, that's the thing. We can't get rid of the fallocate error=20
> regardless of how we set fallocate=3D in the job file. We've tried
 > 0,1,none,posix and keep (which seems to be invalid now) and we ALWAYS  >=
 get the fallocate error. Sometimes the job continues to run, but the  > ou=
tput file is only created at zero byte length.

Can you send me the job file you are using?

--
Jens Axboe


