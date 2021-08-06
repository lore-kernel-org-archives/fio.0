Return-Path: <prvs=845b5b8a0=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 0/5] zbd: Support zone reset by trim
Date: Fri, 6 Aug 2021 01:06:13 +0000
Message-ID: <20210806010613.5lhbmifowzddfiwm@shindev>
References: <20210805032835.1119908-1-shinichiro.kawasaki@wdc.com>
 <2e8ed71710e1f5796a00824f04c03a56a3f22865.camel@wdc.com>
In-Reply-To: <2e8ed71710e1f5796a00824f04c03a56a3f22865.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <E006A1B0CF5FEE4A909D3F9C3937A9ED@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On Aug 05, 2021 / 19:04, Dmitry Fomichev wrote:
> On Thu, 2021-08-05 at 12:28 +0900, Shin'ichiro Kawasaki wrote:
> > Trim workload is currently not supported for zonemode=3Dzbd. This patch
> > series
> > enables it by resetting zones for trim I/Os. This allows fio to measure
> > performance of zoned block devices using more realistic workloads which
> > mixes
> > write and trim.
> >=20
> > The first patch prepares for trim support by modifying the helper
> > function
> > zbd_find_zone(). The second patch adds zone reset for trim. The third
> > patch
> > enables trim workload for libzbc I/O engine. The fourth patch adds a
> > test
> > case that exercises trim operation with zonemode=3Dzbd.
>=20
> The fourth patch updates the HOWTO file to describe the added
> functionality. The fifth patch adds a test case that exercises trim
> operation with zonemode=3Dzbd.

Thanks, I forgot to update this part.

>=20
> >=20
> > Changes from v1:
> > * Separated HOWTO/man changes from 2nd patch as 4th patch
> > * Reflected various comments on the list
> >=20
> > Shin'ichiro Kawasaki (5):
> > =A0 zbd: Add min_bytes argument to zbd_find_zone()
> > =A0 zbd: Support zone reset by trim
> > =A0 engines/libzbc: Enable trim for libzbc I/O engine
> > =A0 HOWTO/man: Describe trim support by zone reset for zoned devices
> > =A0 t/zbd: Add test #58 to test zone reset by trim workload
> >=20
> > =A0HOWTO=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 ++++=
+
> > =A0engines/libzbc.c=A0=A0=A0=A0=A0=A0 | 13 ++++---
> > =A0fio.1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +-
> > =A0io_u.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +++++
> > =A0t/zbd/test-zbd-support | 26 +++++++++++++
> > =A0zbd.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 85 ++++++=
+++++++++++++++++++++++++++++-------
> > =A0zbd.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> > =A07 files changed, 127 insertions(+), 21 deletions(-)
> >=20
>=20
> This series looks good to me. The suggested wording changes in the
> commit message and and in patch 4 are nits.
>=20
> Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Thank you. I will send out v3 soon, reflecting your comments on the patch 4=
.
Also, I'll add your Reviewed-by tags.

--=20
Best Regards,
Shin'ichiro Kawasaki=

