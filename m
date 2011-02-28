Return-Path: <Hsiao.Su@marklogic.com>
MIME-Version: 1.0
From: Hsiao Su <Hsiao.Su@marklogic.com>
Date: Mon, 28 Feb 2011 13:16:17 -0700
Subject: RE: using blktrace, blkparse, and fio
Message-ID: <E9E9B636B25C054B8E6B9131614B925A0399ECD9@EXCHG-BE.marklogic.com>
References: 
 <E9E9B636B25C054B8E6B9131614B925A039043FE@EXCHG-BE.marklogic.com>
 <4D676108.1060700@fusionio.com>
 <E9E9B636B25C054B8E6B9131614B925A039046CC@EXCHG-BE.marklogic.com>
 <4D6B9DEC.2080805@fusionio.com>
In-Reply-To: <4D6B9DEC.2080805@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


Thanks.

Still trying to think of possible workarounds for this.  This is a differen=
t idea:

Suppose that I re-partition the /dev/sda device into 2.  (Not sure exactly =
how to do this yet, either via LVM or use some other utility.)  And I use t=
he first partition for real work, and the second partition for fio replay (=
using captures from blktrace/blkparse).

Now, this would corrupt any filesystem that I have on the second partition.=
  But would it corrupt the first partition?

I would think the answer is no.  Could you confirm?

---
Hsiao "Shao" Su
MarkLogic
Senior Performance Engineer
650 287 2545 (W)


-----Original Message-----
From: Jens Axboe [mailto:jaxboe@fusionio.com]=20
Sent: Monday, February 28, 2011 5:07 AM
To: Hsiao Su
Cc: fio@vger.kernel.org
Subject: Re: using blktrace, blkparse, and fio

On 2011-02-25 13:24, Hsiao Su wrote:
>=20
> Thanks,
>=20
> A follow up question.  Suppose that I use fio directly, without
> blktrace and blkparse.  In this case, I would have to guess the real
> IO workload that my app is doing, and specify that in the job file.
> Would I still have to worry about file system corruption?
>=20
> My guess is no for this one, that fio would create its own file for
> replaying the workload.

Depends on what the job looks like. If you stick to writing to files in
a mounted fs, it'll work fine. If you tell fio to use
--filename=3D/dev/sda or whatever the device is, you'll corrupt the file
system(s) if that job file is doing writes.

--=20
Jens Axboe


