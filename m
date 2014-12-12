Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: fio main thread got stuck over the weekend
Date: Fri, 12 Dec 2014 20:32:43 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
References: <20140811154423.GE7486@beardog.cce.hp.com>
 <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk>
 <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk>
In-Reply-To: <53F795E0.3090806@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Jens Axboe
> Sent: Friday, 22 August, 2014 2:11 PM
> To: scameron@beardog.cce.hp.com
...
> On 2014-08-22 14:09, scameron@beardog.cce.hp.com wrote:
> > On Fri, Aug 22, 2014 at 02:04:34PM -0500, Jens Axboe wrote:
> >> On 2014-08-11 11:04, scameron@beardog.cce.hp.com wrote:
> >>> On Mon, Aug 11, 2014 at 10:44:23AM -0500, scameron@beardog.cce.hp.com
> >>> wrote:
> >>>>
...
> >>>
> >> >from eta.c:
> >>>
> >>> void print_thread_status(void)
> >>> {
> >>>          struct jobs_eta *je;
> >>>          size_t size;
> >>>
> >>>          je =3D get_jobs_eta(0, &size);
> >>>          if (je)
> >>>                  display_thread_status(je);
> >>>
> >>>          free(je);
> >>> }
> >>>
> >>> Maybe that je is coming back false?  which is
> >>> probably the return value of calc_thread_status() which, well,
> >>> at a glance, I'm not sure what calc_thread_status() is doing.
> >>
> >> I'll take a look at this next week, been away at a conference since
> last
> >> weekend.
> >
> > Ok.  Meantime, I had to reclaim the machine for testing, so I no longer
> > have it just sitting there to debug, and I have not sseen the problem
> again
> > that I know of.
>=20
> Clearly a hardware issue :-)
>=20
> --
> Jens Axboe

Rerunning a multi-day job to test out the 64-bit counter fixes,
I just saw the same thing after about 2 days - eta updates stop,=20
although IO is still running.

Jobs: 210 (f=3D210): [r(98),X(14),r(112)] [31.5% done] [2388MB/0KB/0KB /s] =
[4891K/0/0 iops] [eta 01d:17h:05m:24s]

I notice that get_jobs_eta makes a malloc() call without=20
checking for NULL - maybe that happened?



commit 4b9d6e40b90029f42c378ee82b130af9ceafffd7
Author: Robert Elliott <elliott@hp.com>
Date:   Fri Dec 12 14:04:11 2014 -0600

    eta.c: check malloc return code
   =20
    Check the malloc return code in get_jobs_eta.
   =20
    Signed-off-by: Robert Elliott <elliott@hp.com>

diff --git a/eta.c b/eta.c
index a90f1fb47637..167bf5f62b21 100644
--- a/eta.c
+++ b/eta.c
@@ -572,6 +572,8 @@ struct jobs_eta *get_jobs_eta(int force, size_t *size)
=20
 	*size =3D sizeof(*je) + THREAD_RUNSTR_SZ;
 	je =3D malloc(*size);
+	if (!je)
+		return NULL;
 	memset(je, 0, *size);
=20
 	if (!calc_thread_status(je, force)) {


---
Rob Elliott    HP Server Storage






