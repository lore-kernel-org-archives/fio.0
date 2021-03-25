Return-Path: <prvs=7111401fc=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 2/2] t/zbd: test repeated async write with block size
 unaligned to zone size
Date: Thu, 25 Mar 2021 10:53:28 +0000
Message-ID: <20210325105328.rsv2stmobhhelyhi@shindev.dhcp.fujisawa.hgst.com>
References: <20210325021535.1531333-1-shinichiro.kawasaki@wdc.com>
 <20210325021535.1531333-3-shinichiro.kawasaki@wdc.com>
 <BL0PR04MB6514484184408C908D85258CE7629@BL0PR04MB6514.namprd04.prod.outlook.com>
In-Reply-To: 
 <BL0PR04MB6514484184408C908D85258CE7629@BL0PR04MB6514.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25B2E42CF0B99F409266C78099456653@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Mar 25, 2021 / 04:58, Damien Le Moal wrote:
> On 2021/03/25 11:15, Shin'ichiro Kawasaki wrote:
> > A recently fixed bug was caused by zone reset during asynchronous IOs
> > in-flight. The bug symptom was unaligned command error which was
> > observed using random write workload with libaio engine and block size
> > not a divisor of zone size. To confirm the bug fix and to prevent futur=
e
> > regression, add a test case which runs the workload.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  t/zbd/test-zbd-support | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >=20
> > diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> > index be129615..51c92e86 100755
> > --- a/t/zbd/test-zbd-support
> > +++ b/t/zbd/test-zbd-support
> > @@ -1201,6 +1201,24 @@ test56() {
> >  		>> "${logfile}.${test_number}" 2>&1 || return $?
> >  }
> > =20
> > +# Test that repeated async write job does not cause zone reset during =
writes
> > +# in-flight, when the block size is not a divisor of the zone size.
> > +test57() {
> > +	local bs off
> > +
> > +	require_zbd || return $SKIP_TESTCASE
> > +
> > +	bs=3D$((4096 * 7))
> > +	off=3D$((first_sequential_zone_sector * 512))
> > +
> > +	run_fio --name=3Djob --filename=3D"${dev}" --rw=3Drandwrite --bs=3D"$=
{bs}" \
> > +		--offset=3D"${off}" --size=3D$((4 * zone_size)) --iodepth=3D256 \
> > +		"$(ioengine "libaio")" --numjob=3D4 --time_based=3D1 --runtime=3D30s=
 \
>=20
> With a single job, there will be no lock contention, so more chances of s=
eeing
> the problem as you described in the cover letter. So may be remove numjob=
s=3D4 here ?

As far as I tried, no difference is observed by numjob difference. I kept i=
t
just because it was specified in the command line which found the problem. =
For
simplicity, I agree to remove it. Will reflect to v3.

>=20
> > +		--zonemode=3Dzbd --direct=3D1 --zonesize=3D"${zone_size}" \
> > +		${job_var_opts[@]} \
> > +		>> "${logfile}.${test_number}" 2>&1 || return $?
> > +}
> > +
> >  SECONDS=3D0
> >  tests=3D()
> >  dynamic_analyzer=3D()
> >=20
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research
>=20

--=20
Best Regards,
Shin'ichiro Kawasaki=

