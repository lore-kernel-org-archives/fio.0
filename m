Return-Path: <prvs=565f703da=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] zbd: Fix test case #48 failure
Date: Fri, 30 Oct 2020 07:03:37 +0000
Message-ID: <20201030070336.lqbgbjwosk4ayjfz@shindev.dhcp.fujisawa.hgst.com>
References: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
 <20201029074259.sesqdwbkysw552yl@shindev.dhcp.fujisawa.hgst.com>
 <c8735dd3-9b7d-52f5-735c-c7aa6e006a43@kernel.dk>
In-Reply-To: <c8735dd3-9b7d-52f5-735c-c7aa6e006a43@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CEAC27561196E347930D870BA0A240C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-ID: <fio@vger.kernel.org>

On Oct 29, 2020 / 08:00, Jens Axboe wrote:
> On 10/29/20 1:43 AM, Shinichiro Kawasaki wrote:
> > On Oct 13, 2020 / 15:49, Shin'ichiro Kawasaki wrote:
> >> When t/zbd/test-zoned-support is run for zoned block devices with slow=
 zone
> >> reset command operation, test case #48 fails. This series addresses th=
e failure
> >> with two fixes. First patch avoids excessive and repeated zone resets =
which
> >> resulted in too long runtime and test timeout. Second patch fixes wron=
g test
> >> target range of the test case which triggered unnecessary zone resets.
> >=20
> > Hi Jens, could you consider to pick this series up for the upstream?
> > Thanks in advance.
>=20
> I don't seem to have the actual patches in my mailbox, just the cover
> letter. Can you resend them?

Sure, I have resent v2. I added reviewed-by tag to the patches.
Hope the patches will reach you.

--=20
Best Regards,
Shin'ichiro Kawasaki=

