Return-Path: <prvs=46505dd82=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 6/6] t/zbd: Add test case to check zonecapacity option
Date: Wed, 22 Jul 2020 05:49:07 +0000
Message-ID: <20200722054906.y7pr6rb26zwck7xl@shindev>
References: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
 <20200717093637.139565-7-shinichiro.kawasaki@wdc.com>
 <CY4PR04MB3751E2D748344A90396E50C8E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: 
 <CY4PR04MB3751E2D748344A90396E50C8E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B5D0C383C3158D42BA15A3CCC52080FD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jul 21, 2020 / 09:59, Damien Le Moal wrote:
> On 2020/07/17 18:36, Shin'ichiro Kawasaki wrote:
> > From: Hans Holmberg <hans.holmberg@wdc.com>
> >=20
> > Add test case #49 which confirms the newly introduced zonecapacity
> > option is working as expected with regular block devices.
> >=20
> > Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> > ---
> >  t/zbd/test-zbd-support | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >=20
> > diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> > index 31718c95..e53a20c5 100755
> > --- a/t/zbd/test-zbd-support
> > +++ b/t/zbd/test-zbd-support
> > @@ -839,6 +839,26 @@ test48() {
> >  	    >> "${logfile}.${test_number}" 2>&1 || return $?
> >  }
> > =20
> > +# Check if fio handles --zonecapacity on a normal block device correct=
ly
> > +test49() {
> > +
> > +    if [ -n "$is_zbd" ]; then
> > +	echo "$dev is not a regular block device" \
> > +	     >>"${logfile}.${test_number}"
> > +	return 0
> > +    fi
> > +
> > +    size=3D$((2 * zone_size))
> > +    capacity=3D$((zone_size * 3 / 4))
> > +
> > +    run_one_fio_job "$(ioengine "psync")" --rw=3Dwrite \
> > +		    --zonemode=3Dzbd --zonesize=3D"${zone_size}" \
> > +		    --zonecapacity=3D${capacity} \
> > +		    --verify=3Dmd5  --size=3D${size} >>"${logfile}.${test_number}" 2=
>&1 ||
> > +	return $?
> > +    check_read $((capacity * 2)) || return $?
>=20
> The workload is rw=3Dwrite, but this is calling check_read. Is this inten=
ded ?

Yes, the workload has verify option then written data is read back. It chec=
ks
both written size and read size.

--=20
Best Regards,
Shin'ichiro Kawasaki=

