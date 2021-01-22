Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 34/38] t/zbd: add checks for offline zone condition
Date: Fri, 22 Jan 2021 09:06:36 +0000
Message-ID: <20210122090635.pxmyy3zim4cfo7wa@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-35-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-35-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27B8426FC939EB40AD1976E267D209A2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> Some tests, e.g. #39 an #40, try to read the first zone of the drive.
> It is assumed that the first zone is readable. However, if the first
> zone is offline, the read fails along with the entire test.
>=20
> This commit adds two functions to perform zone report and find the
> first and the last zones that are not offline. Several test cases
> now call these functions to avoid test failures described above.
>=20
> Fixes for two more test failures are included in this commit -
>=20
> Test #14 tries to write to conventional zones if they are found at
> the beginning of the LBA range of the drive, but it assumes that
> these zones are online. This may not always be the case. Add "offset"
> to avoid the i/o to be attempted to run against any preceding offline
> zones.
>=20
> Similarly, in test #17, the script tries to find the last zone.
> Check for the case when the last zone is offline. The test doesn't
> set the i/o file size, but it works OK in most of the cases because
> typically this test operates on the last physical zone. With the
> online lookup in place, this may not always be the case and if there
> are any offline zones that trail the last non-offline zone,
> then the i/o will try to access that zone and fail. Add the "size"
> to avoid the i/o to be attempted to run against any trailing offline
> zones.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

