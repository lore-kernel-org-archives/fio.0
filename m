Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10854 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgHNHYv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Aug 2020 03:24:51 -0400
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] zbd: don't read past the WP on a read only workload with
 verify
Date: Fri, 14 Aug 2020 07:24:47 +0000
Message-ID: <20200814072446.abniokrckafgytlb@shindev.dhcp.fujisawa.hgst.com>
References: <20200813150148.14655-1-niklas.cassel@wdc.com>
In-Reply-To: <20200813150148.14655-1-niklas.cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2318B0D95AFD934AA6EFB93AE86C35FB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>

On Aug 13, 2020 / 17:01, Niklas Cassel wrote:
> From: Aravind Ramesh <aravind.ramesh@wdc.com>
>=20
> When running a read only workload with verify option enabled,
> fio continues to read beyond the write pointer, and thus
> reads a deallocated block, which contains data of a predefined
> pattern, thus causing the verify to fail.
>=20
> Thus, we cannot simply jump to accept for a read only workload
> with verify option enabled, we must let the regular flow of
> execution to continue, so that the check if offset > wp is
> performed, so that we will return the address to a new zone,
> rather than an address that is past the wp.
>=20
> Reading past the wp is not a recent bug, it is possible to
> reproduce this bug even before zone capacity was introduced.
>=20
> However, with the introduction of zone capacity, filling a
> zone now only writes up to zone capacity of a zone, making
> it much easier to reproduce this bug.
>=20
> Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

