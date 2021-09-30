Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D5CC433F5
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 08:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67AC061881
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 08:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348325AbhI3IsL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:48:11 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:57383 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348233AbhI3IsL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Sep 2021 04:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632991588; x=1664527588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u5cTpQBhtQllhmGmemGVfCti3uNDPJE6R+iQJ2DFRVQ=;
  b=Lzn/UdSiSuWWNLM3D6YaGGEzSyGLdcAHeV98fZ0Hk6eZenSQFkVyKENE
   pp9Yvq7VjhdTHVvE5to6usufU9xAUAYiwKWfyU39ab/cdCFvGwEjU527t
   ReY3yTe/XdMFqtgMBiyy9ZGDCVJG1fZHRlGxhytwWtsVmtv+/c16zS0Q0
   cJ/jMjfRA8ovoU+LXXDX4L6ng5e43DJNPvsrqZP7ucOZj4BZF48L7X4gm
   ec13nY8a6QQr8N/o2CETvGqTF7P4LlsQfVMHlQqNlDTiL29rZTiuWtMdm
   cN3KsKr2BV/W3kOEQiod5DUiMH6wOy+gxAUBBfGUckCJkD4FUxsGHYZdZ
   w==;
X-IronPort-AV: E=Sophos;i="5.85,335,1624291200"; 
   d="scan'208";a="180466598"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 Sep 2021 16:46:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV+suW0nyPio9/SNC2ANSJYdoKAKFvkAZnuzzT8+xtVE+UXQ0ypMDgerniIt/p4HgmkUJkCNHjO/Ppnwh7cds4wf3Hev/8GtkusS/oiMWPS50ropcEJfXQ2B6akK9r6Dd/NfWUpZnjlayqpWuTuNNIcJkt3D793D6de7BkJH4EXYTZzEtx58VJAV+yvRKJBt81e31IzJnznuSvNH3ebplFAtDQq+VnBky0NRhMwvNujqTd+K3KproGwVmQ1TkA1DuWpd+oE8c9oIZQOiKc/dOOvXrWNVkhbXUcAKBhRt8XqU0h62QwKMcyM45KKcnKw8p+gidFQL2AMVZL+wXcVIZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oJqbRNavJfr6xlYI/90iqSk+XD1/2bmXXXexlhnTujk=;
 b=QBuynC6ADnhuho4MJlHUS0/X/4w+geDuxZYzUzDdCV/+GXTsBbB1WpVgtEMlt+gTU2eP1BJGW6EYxLU2ysBIoklon14ozTL90i2Cs/I9GNoDzluRgNBuSGnKgI9Y8KOiW9mDr5kiz5nfC0KORnOOkdx3LY4tZssDWvpVW/TWOGXokYMU4SDx/XpiA18XAKTD3OIEwYOx8/YsOjfs7DI0HV6LdZM3G/piLzbkuuBAOQEvxhil2NKYjf3yBXvWCJb2uxAHPV7Q+KHfOvCPPFqcnQelvs7RkVy4qM/8pYydm9JcdV6AOJvb7udhT/+9NbDH3aa+d8pAfaMrySdeEjw9MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJqbRNavJfr6xlYI/90iqSk+XD1/2bmXXXexlhnTujk=;
 b=TLsHCAlqg+XhImBUTA1Jgii7OJPALsvfMhWxXgRP9VVWVZbeG+gkm6Z+qEf6VHV16lLWp9ySihA970F2rQM2sYck/BAbkuUELuaY9D7RdHlXav4RqQ0/5KJs1n9SGKnKD/RBVj7vc1dNlQ7csp2q/ImPE83mDivrvJ7smxabgpg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7701.namprd04.prod.outlook.com (2603:10b6:510:59::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 08:46:26 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3d04:c2fb:e69f:27e8]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3d04:c2fb:e69f:27e8%6]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 08:46:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH] zbd: Fix unexpected job termination by open zone search
 failure
Thread-Topic: [PATCH] zbd: Fix unexpected job termination by open zone search
 failure
Thread-Index: AQHXtY5+jYilK2Lqj0mq0Uu36Is9Mqu8RC8A
Date:   Thu, 30 Sep 2021 08:46:25 +0000
Message-ID: <YVV5YICLtufsB8D0@x1-carbon>
References: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ae51770-78aa-467d-a7e8-08d983eec9d7
x-ms-traffictypediagnostic: PH0PR04MB7701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB77015DF33B57691E97FDC797F2AA9@PH0PR04MB7701.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zG0lITHFRLcwtm2PXQgK55AXpwa8JmXvzR+Hg76RKNOt6HeZm+L6HmfIprjCZhMNt59/9RwEn0IYt/DuJD0CCMRMMB4P1raTDZKuViNRHshSY7lYT3CVBIsB+Zotyhoqnthqd7YmOGrJhLVC2TDbdJrJeJS3dlgay21+RQj9RzQ73Z7sItNJjLL9aiHnR79coJk+5tsis8rWBTNR3Hdz+pMhmimk+sYurr4JFLlZE1wtQJGxZxVE9mjY0I+kWEQJS6aGgCndBTRLgXIiXHkkSz5K3bobY8X6z2GVWzEZXj2b1CCjbpjokcVWOESdxZhAEAAKK5dHxvflQQjXi0x19vr1loPfuulsQDe56iOVILUNQ9BAbFi5o958S4pUj5rwzAUBCy8Y/D4aqbPBXMbczFgOs50HQTcGY51+1ihbsD7jrApTqo3/rOSkgUXkLQzqe+8o0hFpLV4IpxsVHInjrtIcOl91h0PDQ57a+ffvehTzizR6LzMxTdJE2ofrMB35nTj7nTOHF9dPhASCMYmyqxCoatO/XhvI7farWnXCEMo2FH0YL8k7TWbBjmZQsKd6GYb34CKxiFqMq6OT2srIb/7L9xcrdJJJOdCYfrF88AgZIPwq4YDAZyRLt0RiLUAiDrZZTmzGbf6rS1nvrK0xwqVZlUSBPkLdP2nrU7BPl5DzHRhX39wBlTkebrPTDHeMPIKIXd6FOI3if5O7KUXaqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(508600001)(38070700005)(8936002)(316002)(186003)(9686003)(2906002)(6512007)(54906003)(8676002)(26005)(6486002)(38100700002)(6636002)(66946007)(6506007)(71200400001)(6862004)(64756008)(4326008)(66446008)(76116006)(122000001)(86362001)(5660300002)(91956017)(66556008)(66476007)(33716001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S6CK/+FIF/nklQnbl/NdXS4OQ9DvYr/ix0+Owo/7DWWmyItalHujvEnRfUi5?=
 =?us-ascii?Q?ymsImm8ZJoycmZxBLCGRMzCu+Hl6NtJ7ZYU+4m5PAfyLpJhhDfSt5bHRT9PY?=
 =?us-ascii?Q?g4mVqzEW+UFAq74Ru73nWFYkfwYhEatj7VgfQUqT9laVT2VqRw6G0E/wQQ3x?=
 =?us-ascii?Q?aRNSsD9ZBJvB94cEqEf2bfGv1qgrhndy4YURzj+Qfk0UspLr4smfsdrGNdVw?=
 =?us-ascii?Q?L10XoBKcCuq6CumuZDqz3swEHzuZEQl95G9uRTn85VGP6bamW4P0XuC9facf?=
 =?us-ascii?Q?YTjCRbswiWy4GBEYbjcuxNsF707Qsux+Oq+EvkKne4mPecGGtb+OK92p5gw/?=
 =?us-ascii?Q?u/GErBRX5vGj3VaTCTeMZaMjiLXHSl82MosHj5LUCM8XeRZy5P+fVTh/mBSY?=
 =?us-ascii?Q?fJ8Y6yOzAiE3yz9ZUGMXa/+patqMx83RDyRDrJNKrCBAPuhMlyt6xJAeNUtE?=
 =?us-ascii?Q?SvogzS/rp3VHuauq6j+4RW6MyfevkrKSuf9qBXJ0HnUEK9TiLdbYhl3BvdiB?=
 =?us-ascii?Q?jK6ucKRNltDq5h45KxoJnbfNEHIKKuFnv9VFlmAs4irx2IKNdm+mOFtCBpCf?=
 =?us-ascii?Q?HRkArnQoWY8Pe+u12+kAYICIRxagKV1qjNkbpt5/03Bh1fjmVEKtqIFRI7er?=
 =?us-ascii?Q?03gL6W+ME4Kw891tjbUnbcGFyy1cdOVeasrQtiR2qgaJBhRF6Pn6UhYOpa99?=
 =?us-ascii?Q?5CfKWMYVbHkg65gPTAMLh/W0uNXlceu+2F0HX1/VnseaWG+gujZ6bHYMHDWm?=
 =?us-ascii?Q?HTu+JM/zojo1Wpv8wpyMZQzj05Ll5Fa0QCyTuULblGRD4v78QPf+m2wTjeXp?=
 =?us-ascii?Q?oclLtVp5NkxpDqlSH7hNP842Xyqz2az8gA1EOmFVYy8KA+mWDYCPhmHZXQzN?=
 =?us-ascii?Q?wdZpDoCoIrFo8tFtv1C41LK7rO7qMrGqk83WGp6aeRHwVi0SCxk7zYKVWgmY?=
 =?us-ascii?Q?mFSdoW+yAagxXBWMCO1Pif/mDy8bcyoUoRkIAc+qyCE7/KSVRaJtGOvjzevs?=
 =?us-ascii?Q?aLO2v5WlEiFqowXWK3csIrQRbiVieiyVhRpKp37QZBjhybLnsXbruHbmoZQ+?=
 =?us-ascii?Q?coMODHKTh6u6QMBszH79ZayMfguUUCONHJkJtK5WBBeLqnJMk8BouIJyfier?=
 =?us-ascii?Q?ujHSIoqWWorWWx5BSJ0rsdhTanqTbccH3+LhNcq7ZOqfks5jGcisz1f4tv5G?=
 =?us-ascii?Q?9gdAMYWoX4JdPq6Itzlb8lih4SWDriKpDgmK9hGnBxcG7oIaudsE7AsnJZfd?=
 =?us-ascii?Q?NfTRR+rcydvGw5vSriHltrLRDRbq+jRV9A3cqQPzHoV44wXIqlCqESkJCzKZ?=
 =?us-ascii?Q?gGQ26ry6x8K99CGG2F81SPZA9q9CrrbSRlkcnF0D/dTHBg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <876CF0582D3B51498B0DC003994C3064@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae51770-78aa-467d-a7e8-08d983eec9d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 08:46:25.7213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Qd8a0iqHsxp6b8ryEpcBCbbSELHQrbWpx27K9kOCJq+MSCvSO7FhRvmt1X40WJGEvoJGTH+kNfyJ4TiwphxKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7701
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Sep 30, 2021 at 09:02:36AM +0900, Shin'ichiro Kawasaki wrote:
> Test case #46 in t/zbd/test-zbd-support fails when it is repeated
> hundreds of times on null_blk zoned devices. The test case uses libaio
> IO engine to run 8 random write jobs on 4 sequential write required
> zones. When all of the 4 zones get almost full but still open for
> in-flight writes, the helper function zbd_convert_to_open_zone() fails
> to get an opened zone for next write. This results in unexpected job
> termination.
>=20
> To avoid the unexpected job termination, retry the steps in
> zbd_convert_to_open_zone(). Before retry, call io_u_quiesce() to ensure
> that the in-flight writes get completed.
>=20
> To prevent infinite loop by the retry, retry only when any IOs are
> in-flight or in-flight IOs get completed. To check in-flight IO count of
> all jobs, add a new helper function any_io_in_flight().
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>=20
> diff --git a/zbd.c b/zbd.c
> index 64415d2b..c0b0b81c 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1204,6 +1204,19 @@ static uint32_t pick_random_zone_idx(const struct =
fio_file *f,
>  		f->io_size;
>  }
> =20
> +static bool any_io_in_flight(void)
> +{
> +	struct thread_data *td;
> +	int i;
> +
> +	for_each_td(td, i) {
> +		if (td->io_u_in_flight)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Modify the offset of an I/O unit that does not refer to an open zone =
such
>   * that it refers to an open zone. Close an open zone and open a new zon=
e if
> @@ -1223,6 +1236,8 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
>  	uint32_t zone_idx, new_zone_idx;
>  	int i;
>  	bool wait_zone_close;
> +	bool in_flight;
> +	bool should_retry =3D true;
> =20
>  	assert(is_valid_offset(f, io_u->offset));
> =20
> @@ -1337,6 +1352,7 @@ open_other_zone:
>  		io_u_quiesce(td);
>  	}
> =20
> +retry:
>  	/* Zone 'z' is full, so try to open a new zone. */
>  	for (i =3D f->io_size / zbdi->zone_size; i > 0; i--) {
>  		zone_idx++;
> @@ -1376,6 +1392,24 @@ open_other_zone:
>  			goto out;
>  		pthread_mutex_lock(&zbdi->mutex);
>  	}
> +
> +	/*
> +	 * When any I/O is in-flight or when all I/Os in-flight get completed,
> +	 * the I/Os might have closed zones then retry the steps to open a zone=
.
> +	 * Before retry, call io_u_quiesce() to complete in-flight writes.
> +	 */
> +	in_flight =3D any_io_in_flight();
> +	if (in_flight || should_retry) {
> +		dprint(FD_ZBD, "%s(%s): wait zone close and retry open zones\n",
> +		       __func__, f->file_name);
> +		pthread_mutex_unlock(&zbdi->mutex);
> +		zone_unlock(z);
> +		io_u_quiesce(td);
> +		zone_lock(td, f, z);
> +		should_retry =3D in_flight;
> +		goto retry;
> +	}
> +
>  	pthread_mutex_unlock(&zbdi->mutex);
>  	zone_unlock(z);
>  	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
> --=20
> 2.31.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
