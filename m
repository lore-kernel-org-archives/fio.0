Return-Path: <prvs=71044fd06=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] zbd: fix zone reset during asynchronous IOs
Date: Wed, 24 Mar 2021 03:35:24 +0000
Message-ID: <20210324033523.jwzd5u4caugthvgx@shindev.dhcp.fujisawa.hgst.com>
References: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <995B42B36611D146BFFAF5F4118DC4CC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Mar 23, 2021 / 10:13, Shin'ichiro Kawasaki wrote:
> Repeated random write jobs to zones with libaio engine trigger unaligned =
command
> errors because of zone resets for file reset during asynchronous writes i=
n-
> flight. The first patch of this series addresses the problem by waiting t=
he
> asynchronous IOs to complete before zone reset. The second patch adds a n=
ew test
> case to confirm the problem fix and to prevent future regression.

The fix in this series may not be the best. It adds the overhead to wait fo=
r
in-flight IOs. The zone resets to repeat jobs could be avoided. I will thin=
k
about how to improve the patches and send v2.

--=20
Best Regards,
Shin'ichiro Kawasaki=

