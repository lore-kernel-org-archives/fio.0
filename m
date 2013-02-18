Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60205
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab3BRIqr (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Feb 2013 03:46:47 -0500
Date: Mon, 18 Feb 2013 09:45:19 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to get IOPS when using terse output
Message-ID: <20130218084519.GD6003@kernel.dk>
References: <20130218080829.GC6003@kernel.dk>
 <617220590.349712.1361176670900.JavaMail.root@thomas-krenn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <617220590.349712.1361176670900.JavaMail.root@thomas-krenn.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Georg =?iso-8859-1?Q?Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org, Peter Xu <xzpeter@gmail.com>

On Mon, Feb 18 2013, Georg Sch=EF=BF=BDnberger wrote:
> ----- Original Message -----
> > From: "Jens Axboe" <axboe@kernel.dk>
> > To: "Peter Xu" <xzpeter@gmail.com>
> > Cc: fio@vger.kernel.org
> > Sent: Monday, 18 February, 2013 9:08:29 AM
> > Subject: Re: How to get IOPS when using terse output
> >=20
> > On Wed, Feb 13 2013, Peter Xu wrote:
> > > Hi, all,
> > >=20
> > > I failed to find IOPS results for read/write under terse mode (with
> > > --minimal param when invoking fio program), while IOPS does exist
> > > in normal
> > > output without --minimal param.
> > >=20
> > > It seems that I even cannot calculate it out only with the tersed
> > > output
> > > (since I don't know the total number of IO). Then, how should I get
> > > IOPS
> > > results when using terse output?
> >=20
> > As Carl mentions, the IOPS are there. But let me make a suggestion to
> > move over to the json format instead. It's easy to parse by computers
> > and humans, and new performance metrics can be added without causing
> > breakage in existing setups. The minimal/csv format is somewhat
> > fragile
> > for that.
> >=20
> > That said, IOPS is there in the minimal output :-)
> >=20
> > --
> > Jens Axboe
> >=20
> Maybe you consider that version 3 of the terse output is only used
> since Fio version 2.0.3!  Before that I think that IOPS are not in the
> terse output (http://freecode.com/projects/fio/releases/341331).  In
> the current Debian (http://packages.debian.org/squeeze/fio) and Ubuntu
> LTS releases (http://packages.ubuntu.com/precise/fio) the Fio version
> is before 2.0.3 and therefore the terse output is not of version 3.

Ah yes, good point, I always seem to assume that people are running fio
out of the git repo. But yes, the IOPS is a recent(ish) addition. Though
2.0.3 is more than a year old at this point.

> As Jens said, you can also switch to JSON format instead.
> So maybe you are stuck to use Fio from the git repo to have a newer versi=
on.

Yep, json is an even newer addition than terse v3, so an update is in
order in any case.

--=20
Jens Axboe

