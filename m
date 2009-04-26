Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:40389 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZDZGhT (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 26 Apr 2009 02:37:19 -0400
Date: Sun, 26 Apr 2009 08:37:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: "directory=" option not working??
Message-ID: <20090426063718.GQ4593@kernel.dk>
References: <6863f0c90904251938v2fd125egaf900257c1eb33dd@mail.gmail.com> <6863f0c90904251948o5d4e8c36y75c9042c0ae800cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6863f0c90904251948o5d4e8c36y75c9042c0ae800cd@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Cagle <jcagle@gmail.com>
Cc: fio@vger.kernel.org

On Sat, Apr 25 2009, John Cagle wrote:
> More info:  It looks like the [global] filename is not affected by the
> [global] directory, but if you move the filename down into a job
> section, it will get the directory name prepended...

Ah, good catch! Fio does do sorting, but not across sections. Weird that
in then fails for global, I'll take a look at this tomorrow.

>=20
> John
>=20
> On Sat, Apr 25, 2009 at 9:38 PM, John Cagle <jcagle@gmail.com> wrote:
> > I just tried the new ssd-test config file, and it uses a "directory=3D"
> > option in the global section.
> >
> > I specify "directory=3D/mnt" but it doesn't work. =EF=BF=BDI have an SS=
D mounted
> > at /mnt, but the files created by fio keep appearing in the cwd.
> >
> > Can someone double check this on their system? =EF=BF=BDI'm working wit=
h the
> > latest source of fio, building it on Ubuntu x86_64.
> >
> > John
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jens Axboe

