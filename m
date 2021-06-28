Return-Path: <prvs=80640e188=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 1/3] zbd: create a local zbdi variable for f->zbd_info
Date: Mon, 28 Jun 2021 10:42:53 +0000
Message-ID: <YNmnrEjk4nJF30g/@x1-carbon.lan>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
 <20210624172256.37177-2-Niklas.Cassel@wdc.com>
 <YNTmZ3y8r+/DXyds@localhost.localdomain>
In-Reply-To: <YNTmZ3y8r+/DXyds@localhost.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EB9CD73E90D1A349AE0294CA21648E3D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On Thu, Jun 24, 2021 at 11:09:11PM +0300, Alexey Dobriyan wrote:
> On Thu, Jun 24, 2021 at 05:23:07PM +0000, Niklas Cassel wrote:
> > +	struct zoned_block_device_info *zbdi =3D f->zbd_info;
>=20
> It is unrelated to the patch. But! It is impossible to type
> "zoned_block_device_info" without autocompletion.
>=20
> Can it be renamed just to=20
>=20
> 	struct zbd * const zbd =3D f->zbd_info;
>=20
> "info" is kind of information free word, too.

Hello Alexey!


Like you say, such a change seems unrelated to this patch.

Feel free to send out a patch that renames struct zoned_block_device_info
to something else.
(Although, you might want to wait until this series has been merged.)

If we were to rename the struct, I personally think that "struct zbd_info"
is a better name than just "struct zbd".


Kind regards,
Niklas=

