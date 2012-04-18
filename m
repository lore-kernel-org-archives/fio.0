Return-Path: <Roger_Sibert@xyratex.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: RE: segfault runninng fio against 2048 jobs
Date: Wed, 18 Apr 2012 12:46:03 -0700
Message-ID: <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <4F8F0A62.80101@kernel.dk>
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com> <4F8F0A62.80101@kernel.dk>
From: "Roger Sibert" <Roger_Sibert@xyratex.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I verified the patch in fio-2.0.7-11-g7907 and that does indeed look to
take care of the issue.  (Many thanks for that)

Also in follow up I changed the max job limit to 5120 and it seems to
run properly against that as well.

Question though, is there any reason you have a REAL_MAX_JOBS in fio.h
and then a FIO_MAX_JOBS in os.h.  First glance at it just shows that the
init.c code uses FIO_MAX_JOBS in for the thread check and then later on
it uses REAL_MAX_JOBS for the job check except that max_jobs is set
equal to FIO_MAX_JOBS.  It may be that the answer to my question is the
os-mac.h file which means you have a smaller thread count ... maybe then
the result is just a small adjustment in the error print to show you
have exceeded the max # of jobs and or max # of threads.
=20
Thanks,
Roger



-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, April 18, 2012 2:40 PM
To: Roger Sibert
Cc: fio@vger.kernel.org
Subject: Re: segfault runninng fio against 2048 jobs

On 2012-04-18 19:27, Roger Sibert wrote:
> Heres hoping Outlook doesn't inject html into the message again.
>=20
> [global]
> direct=3D1
> ioengine=3Dlibaio
> zonesize=3D1g
> randrepeat=3D1
> write_bw_log
> write_lat_log
> time_based
> ramp_time=3D15s
> runtime=3D15s
> ;
> [sdf-iodepth1-rw-readwrite_mix_5050-bs128k-2048]
> description=3D[sdf-iodepth1-rw-readwrite_mix_5050-bs128k-2048]
> stonewall
> filename=3D/dev/sdf
> iodepth=3D1
> rw=3Drw
> rwmixread=3D50
> rwmixwrite=3D50
> bs=3D128k
>=20
> Running just the 2048 job on its own doesn't cause any issues.
>=20
> I did a fresh git clone and ended up with fio-2.0.7-10-g8430 (which
was
> compiled on the local system without making any changes to the code)
and
> re-ran the test using the full 2048 to verify that the segfault still
> occurs, which it does.  I also noted that the segfault is about
> immediate once seeing Jobs: 1 (f=3Dxxx) print and stays that way until
you
> reduce it down to 535.  At about 535 it runs for about 15 or so
seconds
> before segfaulting, 500 is still running after about 3 minutes.

OK, pretty silly error. Guess not that many people use more than ~500
jobs. What you run into is a simple stack smash. The below should help,
I'm committing it now.

diff --git a/eta.c b/eta.c
index 7e837ba..4679a21 100644
--- a/eta.c
+++ b/eta.c
@@ -360,7 +360,7 @@ void display_thread_status(struct jobs_eta *je)
 {
 	static int linelen_last;
 	static int eta_good;
-	char output[512], *p =3D output;
+	char output[REAL_MAX_JOBS + 512], *p =3D output;
 	char eta_str[128];
 	double perc =3D 0.0;
 	int i2p =3D 0;
@@ -385,6 +385,7 @@ void display_thread_status(struct jobs_eta *je)
 		char perc_str[32];
 		char *iops_str[2];
 		char *rate_str[2];
+		size_t left;
 		int l;
=20
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp =3D=3D
je->nr_running)
@@ -401,7 +402,9 @@ void display_thread_status(struct jobs_eta *je)
 		iops_str[0] =3D num2str(je->iops[0], 4, 1, 0);
 		iops_str[1] =3D num2str(je->iops[1], 4, 1, 0);
=20
-		l =3D sprintf(p, ": [%s] [%s] [%s/%s /s] [%s/%s iops] [eta
%s]",
+		left =3D sizeof(output) - (p - output) - 1;
+
+		l =3D snprintf(p, left, ": [%s] [%s] [%s/%s /s] [%s/%s
iops] [eta %s]",
 				je->run_str, perc_str, rate_str[0],
 				rate_str[1], iops_str[0], iops_str[1],
eta_str);
 		p +=3D l;

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

