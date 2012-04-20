Return-Path: <Roger_Sibert@xyratex.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: RE: segfault runninng fio against 2048 jobs
Date: Fri, 20 Apr 2012 07:21:27 -0700
Message-ID: <0FEAAA2D70C89D49A62173478A6C4A5D02DECDC6@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <4F9104F9.2060308@kernel.dk>
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com> <4F8F0A62.80101@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com> <4F9104F9.2060308@kernel.dk>
From: "Roger Sibert" <Roger_Sibert@xyratex.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I was thinking along the lines of adding a command, job_size_allowed =3D
default, (l)arge, (xl)arge, (j)umbo with using those in where you do the
check FIO_MAX_JOBS or REAL_MAX_JOBS.

Default=3D1
Large=3D1.5
XLarge=3D2
Jumbo=3D3

char output[(REAL_MAX_JOBS*job_size_allowed) + 512], *p =3D output;

Sorry if the code is off/wrong, I have spent the last 5 days doing
nothing but perl and bash scripting along with a twist of SQL so my
brain is mush :P

I used to test RAID code for a living so I wasn't about to start digging
since I don't know the code well enough which means that if I push in on
one side something else will more than likely pop out on the other.

Looking at what your describing vs what I was thinking it sounds like
your approach of setting it up to allow for a more dynamic range would
be a more elegant approach that would serve better in the long run.

Thanks,
Roger

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Friday, April 20, 2012 2:41 AM
To: Roger Sibert
Cc: fio@vger.kernel.org
Subject: Re: segfault runninng fio against 2048 jobs

On 04/18/2012 09:46 PM, Roger Sibert wrote:
> I verified the patch in fio-2.0.7-11-g7907 and that does indeed look
to
> take care of the issue.  (Many thanks for that)
>=20
> Also in follow up I changed the max job limit to 5120 and it seems to
> run properly against that as well.
>=20
> Question though, is there any reason you have a REAL_MAX_JOBS in fio.h
> and then a FIO_MAX_JOBS in os.h.  First glance at it just shows that
the
> init.c code uses FIO_MAX_JOBS in for the thread check and then later
on
> it uses REAL_MAX_JOBS for the job check except that max_jobs is set
> equal to FIO_MAX_JOBS.  It may be that the answer to my question is
the
> os-mac.h file which means you have a smaller thread count ... maybe
then
> the result is just a small adjustment in the error print to show you
> have exceeded the max # of jobs and or max # of threads.

OSX has a seriously small max segment by default, hence the split and
smaller value there.

I should probably make the thread_data array be segmented, so that fio
could support an arbitrary number of jobs regardless of the max shm
segment size. So far it hasn't been a huge problem.

--=20
Jens Axboe

______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D

