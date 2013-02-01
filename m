Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34560
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892Ab3BAKOS (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 1 Feb 2013 05:14:18 -0500
Date: Fri, 1 Feb 2013 11:13:22 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130201101322.GJ25524@kernel.dk>
References: <20130129130212.GB8800@kernel.dk>
 <1591158599.146984.1359700554967.JavaMail.root@thomas-krenn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1591158599.146984.1359700554967.JavaMail.root@thomas-krenn.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Georg =?iso-8859-1?Q?Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org, Antonio Jose Rodrigues Neto <Antonio.Jose.Rodrigues.Neto@netapp.com>

On Fri, Feb 01 2013, Georg Sch=EF=BF=BDnberger wrote:
> > On Mon, Jan 28 2013, Neto, Antonio Jose Rodrigues wrote:
> > > Hi All,
> > >=20
> > > This is neto from Brazil
> > >=20
> > > How are you?
> > >=20
> > > I just need a help to make sure I understood correctly the report
> > > (see below --Output).
> > >=20
> > > Trying to generate 80% Read and 20% Write - 8KB block size
> > >=20
> > > Reads
> > > IOPS: 15330
> > > Latency: (clat) 628usecs - 0.628ms
> >=20
> > Correct. Well 629 really, if rounded properly.
> >=20
> > > Writes
> > > IOPS: 3827
> > > Latency: (clat) 577usecs - 0.577ms
> >=20
> > Correct too.
> >=20
> > > Am I doing the correct analysis?
> >=20
> > Yep.
> >=20
> > > One question is: Is it possible to have global IOPS and latency?
> >=20
> > You mean for both read and write combined? Fio does not report that,
> > but
> > for IOPS you could just add them. For latency, the larger of the two.
> >=20
>=20
> Hi Jens,
>=20
> you say here that the total Latency for a mixed workload is the larger of=
 the two.
> Why is it not the sum of the two i.e.
> Total Latency Read + Total Latency Write ?

What I meant that it would be most logical to report the minimum of the
two for minimum latency, and the larger of the two for maximum latency.
That is what would have happened if there were indeed all the same type.
Mean and stddev should be summed appropriately.

For reporting, by definition of setting unified_rw_reporting, there is
not 'latency read' and 'latency write' (or 'latency trim'). There is
just single IO latency.

--=20
Jens Axboe

