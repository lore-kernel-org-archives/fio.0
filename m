Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] v2: ZBD fix with random zone index logic and missing
 documentation
Date: Wed, 4 Aug 2021 11:07:33 +0000
Message-ID: <20210804110731.7yqxy6k7dr6evrrg@shindev>
References: 
 <CGME20210804092848epcas5p43713e1728116d2ea38c910a2b8991c42@epcas5p4.samsung.com>
 <20210804092450.28782-1-ankit.kumar@samsung.com>
In-Reply-To: <20210804092450.28782-1-ankit.kumar@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5C7775A6C31E54438AC640E77A3B0B14@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "krish.reddy@samsung.com" <krish.reddy@samsung.com>, "prakash.v@samsung.com" <prakash.v@samsung.com>
List-ID: <fio@vger.kernel.org>

On Aug 04, 2021 / 14:54, Ankit Kumar wrote:
> v1 -> v2
>=20
>  - Addressed the commit message review comments for both the patches
>=20
> Ankit Kumar (2):
>   HOWTO: Add missing documentation for job_max_open_zones
>   zbd: Improve random zone index generation logic

Ankit, when I commented the v1 patches, I overlooked that your commit messa=
ges
do not include your Signed-off-by tags. Many of the fio commits have the ta=
gs.
To clarify who contributed, I suggest to add it to the two patches.

--=20
Best Regards,
Shin'ichiro Kawasaki=

