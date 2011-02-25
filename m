Return-Path: <Hsiao.Su@marklogic.com>
MIME-Version: 1.0
From: Hsiao Su <Hsiao.Su@marklogic.com>
Date: Fri, 25 Feb 2011 11:24:31 -0700
Subject: RE: using blktrace, blkparse, and fio
Message-ID: <E9E9B636B25C054B8E6B9131614B925A039046CC@EXCHG-BE.marklogic.com>
References: 
 <E9E9B636B25C054B8E6B9131614B925A039043FE@EXCHG-BE.marklogic.com>
 <4D676108.1060700@fusionio.com>
In-Reply-To: <4D676108.1060700@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


Thanks,

A follow up question.  Suppose that I use fio directly, without blktrace an=
d blkparse.  In this case, I would have to guess the real IO workload that =
my app is doing, and specify that in the job file.  Would I still have to w=
orry about file system corruption?

My guess is no for this one, that fio would create its own file for replayi=
ng the workload.

---
Hsiao "Shao" Su
MarkLogic
Senior Performance Engineer
650 287 2545 (W)


-----Original Message-----
From: Jens Axboe [mailto:jaxboe@fusionio.com]=20
Sent: Thursday, February 24, 2011 11:58 PM
To: Hsiao Su
Cc: fio@vger.kernel.org
Subject: Re: using blktrace, blkparse, and fio

On 2011-02-24 20:13, Hsiao Su wrote:
>=20
> Hi,
>=20
> I'm trying to use these 3 tools to capture the IO workload of an
> application.  This application uses several different IO libraries.
> However, I'm not sure if I'm doing this right, so I've been trying to
> do this on a much smaller scale.  For this small scale test, my
> workload is simply to use the cp command to copy a large file onto the
> same filesystem, then use blktrace/blkparse/fio to replay that.
>=20
> Some questions:
>=20
> 1) Is using blkparse necessary?  I've actually found that you can skip
> blkparse, and simply use the output of blktrace and input it into fio.
> The result is that the replay is much much longer.  My cp command took
> only 1.5 minutes, but if I skip blkparse, the replay via fio would
> take almost an hour.
>=20
> 2) Because of #1, I suspect that blkparse is a must.  So I've included
> the blkparse step.  But when I replay it via fio on the same device,
> it took about 4-5 minutes.  Does this sound about right?  Should I
> expect the fio replay to be 3-4 times longer than the original
> workload?  I was expecting that their time should be the same.

These are really the same question, so I'll answer here. You need to run
blkparse to generate a binary trace file for fio. It'll have the same
format as the origina file(s), the difference is that blkparse will
collect them into a single unified trace. It's what blkparse does for
the ascii display of events as well.

As to performance, what fio version are you using? You could try and use
replay_no_stall=3D1 option to see if that improves things.

> 3) I'm seeing so possible file system corruption now.  When I remove a
> file, I get an Input/Output Error.  Is this possibly due to what I had
> done in #1 and #2?  In general, when using fio, what steps should I
> take to prevent a file system corruption?

Since blktrace replay works on the device in question and not through
the file system, it will screw up the data on the device. So never use
it on anything you can't just regenerate, like test data. In general be
careful with raw device access, ideally use a dedicated drive for that
so you don't risk corrupting data you care about.

--=20
Jens Axboe


