Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:44017 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZDUF2h (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Apr 2009 01:28:37 -0400
Date: Tue, 21 Apr 2009 07:28:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
Message-ID: <20090421052836.GP4593@kernel.dk>
References: <20090420180555.GH4593@kernel.dk> <248188.1200.qm@web63806.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <248188.1200.qm@web63806.mail.re1.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

On Mon, Apr 20 2009, Girish Satihal wrote:
> Hi Jens,
> Here is the job file. I am facing problem with Sequential Writes on
> ext3 file system.

You are starting to annoy me a bit... Are you reading my emails? What
did I ask you for? A cut down version that exhibits the problem. You are
using a piece of free software and expecting help/support with your
issue, the VERY least you can do is pay a bit of attention and provide
what is asked (or at least say WHY you didn't provide a cut down
version, perhaps you couldn't get it working etc).



> =EF=BF=BD
> Thanks,
> =EF=BF=BDGirish
>=20
> --- On Mon, 4/20/09, Jens Axboe <jens.axboe@oracle.com> wrote:
>=20
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: Recent changes
> To: "Girish Satihal" <girish.satihal@yahoo.com>
> Cc: fio@vger.kernel.org
> Date: Monday, April 20, 2009, 11:35 PM
>=20
> On Mon, Apr 20 2009, Girish Satihal wrote:
> >=20
> > Hi Jens,
> > This build is the latest build after version 1.24. This build was the
> > outcome of the request for adding blockalign/ba option. Can you please
> > help in resolving this issue of sequential writes on ext3 file system?
>=20
> I'd love to help you, but you have to help me a bit as well. I asked you
> for a job file that reproduces the problem. If you can send me such a
> job file (preferably cut down to just a single section that exhibits the
> problem), then I can probably find the error quickly.
>=20
> >=20
> > Thanks,
> > Girish=20
> >=20
> >=20
> > --- On Sat, 4/18/09, Jens Axboe <jens.axboe@oracle.com> wrote:
> >=20
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Subject: Re: Recent changes
> > > To: "Girish Satihal" <girish.satihal@yahoo.com>
> > > Cc: fio@vger.kernel.org
> > > Date: Saturday, April 18, 2009, 11:18 PM
> > > On Fri, Apr 17 2009, Girish Satihal wrote:
> > > > Hi Jens,
> > > > I am seeing a serious problem with fio testing. I
> > > tried running fio
> > > > test on ext3 partition with Sequential Reads and
> > > Writes. I keep
> > > > getting the I/O write error for Sequential writes. I
> > > tried with
> > > > multiple servers with different controllers and I
> > > still get the same
> > > > error. With Sequential Reads and Random Reads/Writes
> > > there is no issue
> > > > seen. Please find the attached fio results file for
> > > Sequential
> > > > Reads/Writes which has the error details pertaining to
> > > Sequential
> > > > writes on ext3 file system. Thanks, Girish
> > >=20
> > > That's pretty strange. Your test job(s) seem pretty
> > > massive, you don't
> > > happen to have a cut down version that exhibits the
> > > problem?
> > >=20
> > > There also seems to be parts of the error missing from
> > > io_u_log_error(),
> > > like the file associated with the error and the io_u
> > > details (offset=3D
> > > and buflen=3D, for instance).
> > >=20
> > > What version of fio are you using?
> > >=20
> > > --=20
> > > Jens Axboe
> > >=20
> > > --
> > > To unsubscribe from this list: send the line
> > > "unsubscribe fio" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at=20
> > > http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
> >      =20
>=20
> --=20
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
>      =20


--=20
Jens Axboe

