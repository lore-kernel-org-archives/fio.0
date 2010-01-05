Return-Path: <fio-owner@vger.kernel.org>
Received: from web55001.mail.re4.yahoo.com ([206.190.58.135]:24267 "HELO
	web55001.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751612Ab0AEA1M convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Mon, 4 Jan 2010 19:27:12 -0500
Message-ID: <488960.95882.qm@web55001.mail.re4.yahoo.com>
Date: Mon, 4 Jan 2010 16:27:10 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: io scheduler merges control
In-Reply-To: <f3177b9e1001040652r574e12a4m7fb4b988bb22b250@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

Chris,

see bellow my answers

--- On Mon, 1/4/10, Chris Worley <worleys@gmail.com> wrote:

> From: Chris Worley <worleys@gmail.com>
> Subject: Re: io scheduler merges control
> To: "john smith" <whalajam@yahoo.com>
> Cc: fio@vger.kernel.org
> Date: Monday, January 4, 2010, 6:52 AM
> On Thu, Dec 24, 2009 at 12:12 PM,
> john smith <whalajam@yahoo.com>
> wrote:
> > IOPS-reported numbers for a test vary (more than 30%
> in my case) from one run to another depending on kernel io
> scheduler merges (reported in "Disk
> stats/merges=3Dreads/writes") making it hard to
> measure/compare performance of block drivers, for instance.
>=20
> Are you trying to measure sequential I/O?=EF=BF=BD Most
> application traces
> I've seen show that despite the sequential/random mix
> reported, the
> vast majority of "sequential" accesses are two
> blocks.=EF=BF=BD Of course this
> isn't true for applications that only do logging and a few
> others...
> but, it means that for most applications, there really
> isn't any
> sequential access to worry about.

I'm doing 512B sequential reads.
=20
> Are you disabling the VM Cache w/ Direct I/O?

Yes.
=20
> Maybe tell us more about what you're trying to test.=EF=BF=BD
> It may be more a
> matter of control and preconditioning than a fio issue.

I'm trying to compare two block drivers, when running "fio" I get from the =
first driver larger "iops" number but also larger "merges" number; the othe=
r driver has lower "iops" and no merges.
Not sure why one driver has merges and the other doesn't but I'm trying to =
prevent merges (on both) in order to compare the drivers performance.

John
=20
> Chris
> >
> > I don't see any way to turn off kernel io scheduler
> merges (cfq or others)
> > and I'd ask if you would consider adding support for
> it, disabling the merges per individual device, using sys-fs
> maybe?
> >
> > If you do, adding an option to fio for controlling the
> merges would be useful too,
> >
> > thanks,
> > John
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.h=
tml
> >
> --
> To unsubscribe from this list: send the line "unsubscribe
> fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=EF=BF=BD http://vger.kernel.org/majordomo-info.html
>=20


     =20
