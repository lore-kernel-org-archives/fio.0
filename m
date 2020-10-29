Return-Path: <prvs=564bbd043=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] zbd: Fix test case #48 failure
Date: Thu, 29 Oct 2020 07:43:00 +0000
Message-ID: <20201029074259.sesqdwbkysw552yl@shindev.dhcp.fujisawa.hgst.com>
References: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BD764DFC9216240B867562BD1B730C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-ID: <fio@vger.kernel.org>

On Oct 13, 2020 / 15:49, Shin'ichiro Kawasaki wrote:
> When t/zbd/test-zoned-support is run for zoned block devices with slow zo=
ne
> reset command operation, test case #48 fails. This series addresses the f=
ailure
> with two fixes. First patch avoids excessive and repeated zone resets whi=
ch
> resulted in too long runtime and test timeout. Second patch fixes wrong t=
est
> target range of the test case which triggered unnecessary zone resets.

Hi Jens, could you consider to pick this series up for the upstream?
Thanks in advance.

--=20
Best Regards,
Shin'ichiro Kawasaki=

