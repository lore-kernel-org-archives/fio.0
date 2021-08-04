Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 2/2] zbd: Improve random zone index generation logic
Date: Wed, 4 Aug 2021 12:04:15 +0000
Message-ID: <20210804120415.nhaecaxouupintm5@shindev>
References: <20210804112308.28062-1-ankit.kumar@samsung.com>
 <CGME20210804112710epcas5p4d9ef2bfa2d2327b6e4ae27e1cad3aba6@epcas5p4.samsung.com>
 <20210804112308.28062-3-ankit.kumar@samsung.com>
In-Reply-To: <20210804112308.28062-3-ankit.kumar@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D029D692D950E145829901B51804847B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "krish.reddy@samsung.com" <krish.reddy@samsung.com>, "prakash.v@samsung.com" <prakash.v@samsung.com>
List-ID: <fio@vger.kernel.org>

On Aug 04, 2021 / 16:53, Ankit Kumar wrote:
> Existing random zone index generation logic is dependent on the file size=
.
> For smaller I/O sizes the random zone index always return a particular
> section of open zones. As this index is used to return one of the open zo=
nes,
> it was observed that after one of the max_open_zones / job_max_open_zones=
 limit
> is reached all further I/O's are redirected to only a few open zones till=
 they
> are full.
>=20
> This patch modifies the random zone index genration logic so that it is u=
niform
> across all the open zones.
>=20
> It reverts part of the commit 6463db6c1
> ('fio: fix interaction between offset/size limited threads and
> "max_open_zones"')
>=20
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>

Looks good to me. Also, I confirmed that this patch improves the randomness=
 of
open zone selection, and it preserves the intent of the commit 6463db6c1.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

