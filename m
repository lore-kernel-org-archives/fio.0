Return-Path: <jmcvay@micron.com>
From: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Subject: RE: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme
 latencies
Date: Wed, 26 Sep 2012 16:30:25 +0000
Message-ID: <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com>
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com>
 <50605FEF.5020103@cran.org.uk>
In-Reply-To: <50605FEF.5020103@cran.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Bruce Cran
> Sent: Monday, September 24, 2012 6:28 AM
> To: Jeffrey McVay (jmcvay)
> Cc: fio@vger.kernel.org; Jens Axboe
> Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme
> latencies
>=20
> On 24/09/2012 06:41, Jeffrey McVay (jmcvay) wrote:
> >
> > On windows runing 4kB random Writes to a ramdisk with numjobs=3D4 and
> > iodepth=3D64 FIO reports clat and lat maximums times that match the
> > runtime of the test. Changing the numjobs=3D1 and iodepth=3D1 yields ma=
x
> > latencies that meet expectations.  As a further sanity test I ran
> > similar workloads using IOMeter with max response times that were in
> > line with expectations.
> >
> > To reproduce:
> >
> > 1.Download and install the freeware version of Dataram ramdisk from
> > http://memory.dataram.com/products-and-services/software/ramdisk
> >
> > 2.Run FIO 2.0.9 with PhysD1_Fio_4kRandWr_4x64
> >
> > 3.Notice the max entries for clat and lat
> >
> > 4.For comparison run FIO with PhysD1_Fio4kRandWr_1x1
> >
> > Attached are the FIO jobfiles, latency logs for the two FIO runs,
> > IOMeter ICF files, IOMeter csv files, and screenshots comparing
> > similar runs of FIO and IOMeter.
> >
>=20
> Thanks. I've replicated the problem and will work out what's going
> wrong.
>=20
Any updates?=20
Is there anything I can do to help?
I have a personal goal to convert our IOMeter testing to FIO.
--Jeff
> --
> Bruce Cran
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

