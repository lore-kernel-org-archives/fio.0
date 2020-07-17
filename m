Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2859 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgGQG7x (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Jul 2020 02:59:53 -0400
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 4/6] t/zbd: Support testing zone capacity smaller than
 zone size
Date: Fri, 17 Jul 2020 06:59:49 +0000
Message-ID: <20200717065948.lycsnwsvu6rtlfaj@shindev.dhcp.fujisawa.hgst.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
 <20200715064141.116415-5-shinichiro.kawasaki@wdc.com>
 <CY4PR04MB3751443B7CD688F5691C2280E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB3751443B7CD688F5691C2280E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EC1F791265D464083B78590CF4BD81B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>

On Jul 17, 2020 / 02:01, Damien Le Moal wrote:
> On 2020/07/15 15:41, Shin'ichiro Kawasaki wrote:
> > From: Hans Holmberg <hans.holmberg@wdc.com>
> >=20
> > Add support for testing zoned block devices where zone capacity is less
> > than zone size. If the test case runs sequential workloads or workloads
> > with verify, use zone capacity instead of zone size to complete.
> >=20
> > To use zone capacity of the test target zones, introduce a helper
> > function total_zone_capacity() which sums up zone capacity numbers of t=
he
> > test target zones.
> >=20
> > Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  t/zbd/functions        |  37 +++++++++++++++
> >  t/zbd/test-zbd-support | 100 ++++++++++++++++++++++++++---------------
> >  2 files changed, 102 insertions(+), 35 deletions(-)
> >=20
> > diff --git a/t/zbd/functions b/t/zbd/functions
> > index 344836c8..82d64f5c 100644
> > --- a/t/zbd/functions
> > +++ b/t/zbd/functions
> > @@ -84,6 +84,43 @@ first_sequential_zone() {
> >      fi
> >  }
> > =20
> > +# Reports the summed zone capacity of $1 number of zones starting from=
 offset $2
> > +# on device $3.
> > +total_zone_capacity() {
> > +	local nr_zones=3D$1
> > +	local sector=3D$(($2 / 512))
> > +	local dev=3D$3
> > +	local capacity=3D0 num
> > +	local grep_str
> > +
> > +	if [ -z "$is_zbd" ]; then
> > +		# For regular block devices, handle zone size as zone capacity.
> > +		echo $((zone_size * nr_zones))
> > +		return
> > +	fi
> > +
> > +	if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
> > +		if blkzone_reports_capacity "${dev}"; then
> > +			grep_str=3D'cap \K[0-9a-zA-Z]*'
> > +		else
> > +			# If zone capacity is not reported, refer zone length.
> > +			grep_str=3D'len \K[0-9a-zA-Z]*'
> > +		fi
> > +		while read num; do
> > +			capacity=3D$((capacity + num))
> > +		done < <(${blkzone} report -c "$nr_zones" -o "$sector" "$dev" |
> > +				grep -Po "${grep_str}")
>=20
> Why the space in "< <" ? Why not "<<" ?

"<()" is the bash syntax "process substitution". To separate it from redire=
ct, a
space is required between "<" and "<()".

Other than this, I will reflect all of your comments to v3. Thank you for t=
he
valuable comments.

--=20
Best Regards,
Shin'ichiro Kawasaki=

