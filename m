Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF4DC433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349400AbiBCT2f (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:35 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34997 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353753AbiBCT2e (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916513; x=1675452513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/KVIz5ga25czTtgAA6Xr3sDuEbX9BoF0AW5jkXiQ+1Y=;
  b=izSuqceihGHt/8efVe7mnGzj++XUhn1mYIxuUvvcZx2r5Gv5PV2caf4h
   c9EieUJ7+QsG37dO3BRwWfuFTZ0b9o9b+tWtC0W9cCZRbeP1Jk1NxKVuV
   Ye016u//qhuOHU1hcUkEdx7NkuPYZQ1O0QFzrH3jTEXdP4L3sYNQ0WxAK
   YNk0KXPkctqmGkHWjZf2J94Bi63Lsp0FKWim9mqmzuVbEpgm6w7UeRA+B
   jOm4igq/Baxcpkv69UWfY2NcjURXRJnqi7TAcjUfteIjasG2vjKB3T8HK
   OT8JiCsggjevywKxTqofwfxBbpwJZT9muRbWUed+TPhR57URo+fsAgd8O
   w==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107552"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9BdwJ1bcgnoZtMnx/bv5EkJ17yzOsmehh3SVkw+8b5p91PMYgyrInJkaO5fHhrPOsUF5ZEbDG8mXHEtnNcO3Nx/JlVVTIlY0Y8NFD/aZw5UEOMcDXUKIFk+eDETxJ36mVuY8hL4nsZVB55FWMHFMs5o35B3GzvwJqRcSUu7SWSJCvIyonZK4dzWgyP2iP4LlbCI/Pec6bltDT3VYALsdgh1qehjVfyZ3h5mTKv74LqKvQYZyFAdlvatiJJGU2dpNDOT24Wcgv0XLy5gN4IkiTSjWJH20l+zuT8aZqCYGYLAUXqXrLySV9Y9MSPzLIIKXc8U0LhlaC1KwT+JdmX5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwXX6Lnh0EXS8Bsbuax+5w4iz29mA9OECxNOz3Oan6o=;
 b=jsTSSshEjQvpTH+Ca0qBe0n5MFxX7HSTV423s3A+kADZwFE8cdsa5FWlnbkX14okFuz2X9gXwBa4B9BFu8nYnClNyDVXcS7+9UJ1XTyxZirSFyFU3Mqkr4Hg4jZRMRtoAcfrP1kqEpB8bw1ZA82goO2sm7FjuJmwLJhzGN+TWVHiQ1S3z1verQdQcPLc3pvTLGfVZvgGra2CO5zI8o4V+MKIq4CVcAg2EuMNx2Ox5R99WOGCXmWKKIsNa8o2s55iA1mx3t2kkeyHu7wW1DA/Upq+aX4Zw1+fwXUDWCVqJFt/VXUVkVHDzoUDUS+LnvR2Qyovv+sPFFa/je8IUHmh2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwXX6Lnh0EXS8Bsbuax+5w4iz29mA9OECxNOz3Oan6o=;
 b=xybD0DXnP20I5A2Da/dSUJIklLLX5vQhI1kuJiDVOvh/j0J3V5uE+kVwhyBXye1KJoFUKmyWI71KHSCHfuQckATn5l/txBZaqobR+5zNBg7Z+sJHsM/mgnn+zYj086ReOkE5zU2HC1jVB5D2LyOHc9DQhhSAJVIBVMvj3Fuauek=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5423.namprd04.prod.outlook.com (2603:10b6:805:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 19:28:32 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:32 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 12/18] stat: add helper for resetting the latency buckets
Thread-Topic: [PATCH v2 12/18] stat: add helper for resetting the latency
 buckets
Thread-Index: AQHYGTQ5rmt56ZXkVUmU6N2Hrse4Qw==
Date:   Thu, 3 Feb 2022 19:28:29 +0000
Message-ID: <20220203192814.18552-13-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98089cf8-db83-4eda-1b4d-08d9e74b5d3a
x-ms-traffictypediagnostic: SN6PR04MB5423:EE_
x-microsoft-antispam-prvs: <SN6PR04MB542392A77359B17A6E7A780BF2289@SN6PR04MB5423.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: itM3QfMHZIscHiNE70xwwzK7ayOwf9udnwadHHQSesPzzjSiBzuQt+fvVPz7PLBIiE8VBSbVcfXPA6rskfvlxZzS/rywOYh5Q+XeLEtGKV0FXgVg/2B3cdoUusBpYFoPZQBBGVqkJpCyxgVXtzMTTgR/JuXqo8U4NTEy5+JvokT22pmjJ9Zcipmcgi85ER3xix0u7WySt130nEVbloGsNFaGJ56ofJXhKGY8md+QkI7xfLxS/WUejd7bU/opXuTZonIzZn7yTi43a/hvuN/Kkhnxt/AQxp/tcoSdw0F9autu/7PagxYYLCmLZOn60jCERstsfIgT3NYSmQWz7VB9WE6FsljsDn2sC0mTuXnOdrvXA+2o7t5DCy0niOjow65lwnQXt1geLk4MYtKNhFyBanE00A56R9SeUCW+FQUAbxtw6vlB607k979iQIiv7sR/YpcUdNBD6qFX7yNedSNN7/+CeRFh/S0ZT0WtX8T3QvUkO9/Hmcj/EBrRuUQMoo42/OJX1PdsvJwC4lD8i+1flb3CAhguv9s7whzkFf3zH9GRIG1I4ywup5UiBpf+pId07FGo9PhLWXph0bndItIBkWIe59dzh7bsDcHZqG0eC83XfqxllPRqT1HJi114BgfJuljCADusAnAqWkHMVK7EqwsjMSmvW6EwjWAX1kVosFzyGzeVkGjEOgVxfjHC7DArA4dFg7tuK04I6i5887QOsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(86362001)(66946007)(6666004)(91956017)(5660300002)(64756008)(6486002)(71200400001)(6506007)(8936002)(66446008)(6512007)(508600001)(122000001)(4326008)(66476007)(66556008)(2906002)(38100700002)(316002)(2616005)(6916009)(186003)(83380400001)(26005)(82960400001)(36756003)(1076003)(8676002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?80jQQd0uHVtLtzM1XLzD0p+Qh0A7AspRI5d24tPn4cGZGXuXzLRKN/Ha26?=
 =?iso-8859-1?Q?4jcrZEwHfl1KYsC3n/zkpFWYh6tpE6ZJ0WLcAncrDFyYquiN/HP1/eUrbw?=
 =?iso-8859-1?Q?R0lZdlXDjAjn7ig0a9EN54mUBIE78E2Dl+ZTRPP98Vh0frFEHS7oE7S589?=
 =?iso-8859-1?Q?olvmM+7/deQeOJWN/d5OqyCo0UocBUh1fhvXaqirFf/MyEQGPQd19dNqhd?=
 =?iso-8859-1?Q?5aKfUI3VCTY7rmuAzh9pZ+Kp96x9gTdJshWMwpqjK+KiIocNToX4TLbGwu?=
 =?iso-8859-1?Q?EEl1Ad6DL05Rjkd37NasGV4NGjbpF0oDISgiLrUic8a7q/FA0iEan3p8Ad?=
 =?iso-8859-1?Q?SsDV5OvHugrlgRr/1+W+IhFdhzr4P8zFo9sW4/LZUamIGXNwQZ732MpGTg?=
 =?iso-8859-1?Q?TP2aVdppyDOPmu5NLW4FgHMdqWrr4zsDzdK06HyFcK8htvojZ0i6labcbF?=
 =?iso-8859-1?Q?zw017pDxlGV4ns1PFdBeizO9uriFvmvtnPgcaV105F0x8l/fcTLVZwcFXn?=
 =?iso-8859-1?Q?+Gd3olPFKuHyrADMjg2A4+T1QO7hOm+bsXC+6gqlij0wRoMEbvpkzLKuiW?=
 =?iso-8859-1?Q?9eqpbSz534tfutIwKhPMIlaJKiNRByIGSVa59VYMr7PXA2B0MRTJZO6saA?=
 =?iso-8859-1?Q?CGeVKbSQo1xi0/0UwsJ/uxXkwQ0RuoLtM8iCk8ermaAZyKipuJt/+dLh0B?=
 =?iso-8859-1?Q?K+oT4zrkFXwA1MtYovb4MvBxojA4KQ4+KzdxcyiCVM//RGZTR9jLinxCKp?=
 =?iso-8859-1?Q?6eYijqUDKslLI7v80jldTpzad26jir0P9w5lge1eT6wsqW2i8gTJvRvBVZ?=
 =?iso-8859-1?Q?FYpcZTi3gCPAlR3QakF7jhbuxQkF3qtYqO5aZ13oybT7djD3BW28iiYdQy?=
 =?iso-8859-1?Q?O5CVXd+Q95Oi8JfqNDFDjTjnwEFobuASwIPF3xFXNCw4R7azS/VFyESqiQ?=
 =?iso-8859-1?Q?t8L+eOahc2B1uTrdp/Wv+wiTAPhN4ifkvfpaATFrT1XCvk3ioBjbT5qY54?=
 =?iso-8859-1?Q?oM08mh84SC5BT3HZV0tdxfcqAbnKpFWwf62DgqVjnBHArUwL9GQFxEMASJ?=
 =?iso-8859-1?Q?lnB/6O+5SsubYl1Hw+NMMw0jY072nzaGsa1Y20Ids/ZEmOBN776RexAy8r?=
 =?iso-8859-1?Q?0HcVwDv61h+N5jGKO7wIh1NrJ5uc0bOR0ES4seG5GOVaZfolSUwKOIucfC?=
 =?iso-8859-1?Q?vwcZwAH8YsjfeAe7sIXPSX7eyTftJiCwR06OgKTUiRIc0tQgpMg3DYCC8S?=
 =?iso-8859-1?Q?SIFLYhecRrPTK7gflkY5Ymu90xmuBwrnfOnyTePh04EPUMhC6oAAUFOT3m?=
 =?iso-8859-1?Q?Rzhr2vycVlZ72ZJhs8aordTgXI0T4s/4UuFybbpCX+VwQXveuLbDKMr6ao?=
 =?iso-8859-1?Q?HeYjG09ZsdVj+oNthYF7VjBSugq0Cr9IPyOwH62w3YXCHxv2v/TbkmeUJZ?=
 =?iso-8859-1?Q?D6lz+NZrVV437aU7n6gFMWqdMXsANWLWgftXhIU6/V8Mrd/Y83JNmpdatm?=
 =?iso-8859-1?Q?i2TeR2T49oAT8zPgO3J8hcTtbEqzLdNF+eDw2UP+nBG9TyQRaQtVIRwvX3?=
 =?iso-8859-1?Q?9ODasFIWGMCarDcqAA03MqDXpJo4O/wMArLIVuTxRqO+edTOXaGv9kCZoI?=
 =?iso-8859-1?Q?cXVngBLhIOPJyPVM5Ho9nbJ72+D8puKCwGaT5x0p/3qxiXQ/OOV+lH67Xf?=
 =?iso-8859-1?Q?hI9Trb0AN6CQkwcuDRGvKCpEOCcOFTqo9RBcaJaW?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98089cf8-db83-4eda-1b4d-08d9e74b5d3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:29.9142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/NdGMojEWm4kZGhWAcKZZsam59Dq+P9ap0VIb67Y/dZqHLLmE7CardEnUgW2tp2VFe5vWhQQ/uzPgX2ug+azw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5423
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add a helper for resetting the latency buckets, and call it where
appropriate.

This makes the code easier to read, and puts the reset of the DDIR_SYNC
latency buckets together with the other statements for DDIR_SYNC.

A follow up patch will also make use of this new helper function.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/stat.c b/stat.c
index 63341512..baaa29f2 100644
--- a/stat.c
+++ b/stat.c
@@ -2786,10 +2786,18 @@ static inline void reset_io_stat(struct io_stat *io=
s)
 	ios->mean.u.f =3D ios->S.u.f =3D 0;
 }
=20
+static inline void reset_io_u_plat(uint64_t *io_u_plat)
+{
+	int i;
+
+	for (i =3D 0; i < FIO_IO_U_PLAT_NR; i++)
+		io_u_plat[i] =3D 0;
+}
+
 void reset_io_stats(struct thread_data *td)
 {
 	struct thread_stat *ts =3D &td->ts;
-	int i, j, k;
+	int i, j;
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		reset_io_stat(&ts->clat_high_prio_stat[i]);
@@ -2806,20 +2814,16 @@ void reset_io_stats(struct thread_data *td)
 		ts->short_io_u[i] =3D 0;
 		ts->drop_io_u[i] =3D 0;
=20
-		for (j =3D 0; j < FIO_IO_U_PLAT_NR; j++) {
-			ts->io_u_plat_high_prio[i][j] =3D 0;
-			ts->io_u_plat_low_prio[i][j] =3D 0;
-			if (!i)
-				ts->io_u_sync_plat[j] =3D 0;
-		}
+		reset_io_u_plat(ts->io_u_plat_high_prio[i]);
+		reset_io_u_plat(ts->io_u_plat_low_prio[i]);
 	}
=20
 	for (i =3D 0; i < FIO_LAT_CNT; i++)
 		for (j =3D 0; j < DDIR_RWDIR_CNT; j++)
-			for (k =3D 0; k < FIO_IO_U_PLAT_NR; k++)
-				ts->io_u_plat[i][j][k] =3D 0;
+			reset_io_u_plat(ts->io_u_plat[i][j]);
=20
 	ts->total_io_u[DDIR_SYNC] =3D 0;
+	reset_io_u_plat(ts->io_u_sync_plat);
=20
 	for (i =3D 0; i < FIO_IO_U_MAP_NR; i++) {
 		ts->io_u_map[i] =3D 0;
--=20
2.34.1
