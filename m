Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2632BC433F5
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 02:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhKTCLw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 Nov 2021 21:11:52 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19124 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhKTCLv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Nov 2021 21:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637374128; x=1668910128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ujvn1vWczg4hhvYYkv9xY8xehOLhcNc2f1PKgD/hJJQ=;
  b=Y/Lk/Tr1d6stF1wb+5ZeirnyV70li2NJ39r8A+2LuODvECnBb1DbX2xE
   KR//Nihxl6EK55uuKsR9GQpGh1FTPqbPvGZx6lXspuOcXYbZWu9+h3bUh
   bHNIPwkqNla7/rU2Q1jJwFPQcG3XMbmVOgO3baY+0EJUken6wxXOuDsr0
   Ux6EjkefZN4jfv6CLouHAvm7K/POsEpNY3wSOqyjFipFtELIE9yz2qJg4
   hUACkhZUiMfoJAmCsUTPibjh9uPvPSWbmbX5nK8iv9juq6IzisuBWeJD9
   Ll3sDC/0GRyqGgTG3VTXWtbfBbW4nUzEjt97XW4X9tlNugcnauSSKMDRK
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,249,1631548800"; 
   d="scan'208";a="190965459"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 10:08:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOVcY4fMQfI79Z8szincnbEbULKayvlHW+BjOWsmED53UzOnDAQbmKhTXEtSYwuWTuI5lfxxvoPwnHexuyd+SvdcTwcJpF9DDnQ9+vfipO0/lVRNKK/HPpETtsEabH/7lOUbHZg/ocEm3NOezWPGnTJdhv5M8d53GYG7R4gHwWYPORLRkCaemvEiMgs0Dt8dCpYyoLzF/SYfJuStE69KobkFkkajbuWfTzyhcRUXDcHB6GWYjtMKkFif+GWpWMT/C4qjiALjJkmghGvKqNtR8N7s63AyWKa9Bvfo2c3KtkFL7/ixClE87U2OiK3Wj9Ki+AlirHW5H0rL9EpYZBlNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/guzvGWaDFwce7/xxNyHX1rD2ULEtJ/ojcwYaEFg6w=;
 b=EHMb1S+xb+gheoIFZ3ZneN/G/qxHHdnD8c9bVZyNTQTgcDD4ITi5n/ZZB4g9uKy37Q8o6X0yZFP86JB7PSh9oyBEGWolwrGKh6kXc/DXj62BTWDZVbrtTPfX0kiyYfeL62ydO0TLFW57Vmf4oNAhuR/nVDM1IjdfTGkCb81xJfkOCfZo0CahwCt1oSrjTDVM8Eou51j/zx9u9n/CcEqSO20hkZxuJucm/IJa9Y6ywMsZIJhvn+rHB3TuBcuH1efKSOqxS9T6EtpQGzlIRIEgSRKJxWrXKtL6EciaImRRdxXdNe0nYcnNDYmmQeMyOWkHt6XxRyoey1JkkfWgyIXSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/guzvGWaDFwce7/xxNyHX1rD2ULEtJ/ojcwYaEFg6w=;
 b=Huuuna3SaxWuqlU+wdZlDmZOPMXuVnTSbIq9XrpE70xiswqlNtn76ARgGFw/7NaVHUmHicmUqJcEITU4oRZDm1A/MUmjqviUCL0YKSgewsHNAhf0FtGt+6eGPbwReurYJg7ilhZdlpZ05dFDpXKyJjrBJRUDmnNeGCAtjyoge98=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 02:08:46 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.022; Sat, 20 Nov 2021
 02:08:46 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 1/5] stat: rename add_lat_percentile_sample()
Thread-Topic: [PATCH 1/5] stat: rename add_lat_percentile_sample()
Thread-Index: AQHX3bONUCr9zbPpy0aPb5XD1O+v0w==
Date:   Sat, 20 Nov 2021 02:08:46 +0000
Message-ID: <20211120020837.127453-2-Niklas.Cassel@wdc.com>
References: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d3b3234-edcc-4eed-2c33-08d9abcaafb0
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB7622D92441792A7355ACBB42F29D9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9BxHJAdq+lFFukg7uKunHAPFmCaQGH0cR6FoAL21khlF9lUkdvWwZmzRjFVabLIFRn7HvijxztsFdyS6CcyNmnw5TeT4qxZcmE7qBULR/q0kisTIbOsV5E96n5FESsNdRqBRPOkNQM4g6yRPHNYFFsSvZqaQIIopiq8x7dPNvyHWShW73JGzfHekfrnrLDLoSxuKqiY3GVBOjJys/66TGpIGFk39Dk/a3WfiURYjhOVsiJvzzOQrVHfs/k0D8VTskI+ZhHXj4BglfErKF1xI78ur4XIycd79KwJv+OsvtsH31Cb5rFIkNedu6mlNSHARPY6xz5M5OGiDNfk5qW6qBD+WTQ1/kPNbtJa+Ta5eat62l1twrMtE3D8JAT5+MIYTNJjyuZ3WqAojM9H465r5bOp07sDv2T8XYr394LJgg6WM73t5E1V9fhlR6XgJzkI73KwW7Hr3/ci2dJb7LGZqiPDpQLO0mLLlwXtM1Dv9dvMrhol2pritE4FfYkBs6wC3sOMqnEPjHmV/EGGG6dCvDr5K/6g222Q13PpfwDH5TcTDSTUNkUE4QgMgT+9vmUfb6GRLwQJXl38RqShzXZlC0xBRz2MyCHoIRwvbdQuZO7YcwoSsxQhG+950+uyJz5denhj+wlouPj9l7dVP0HDMbnf9cX19V/pqEfNBG4sXUMfEKdxNbt9xnyr2YIIT8fJd34l4jQWf9B94BERmxWLeOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(8936002)(4326008)(38070700005)(8676002)(1076003)(26005)(86362001)(2906002)(91956017)(76116006)(66446008)(66556008)(64756008)(5660300002)(66476007)(186003)(66946007)(6512007)(6916009)(71200400001)(508600001)(316002)(36756003)(6486002)(2616005)(122000001)(83380400001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?eLMPyASQPtGL7FSKEjS46URyM6kW6acvF9vpOS/Mwm/z/Lr6X2sR/ru1Bs?=
 =?iso-8859-1?Q?fuTsRynjtY9p7H3ae06jzpaEnhz+7M59humQnFO5YkajCQVa1QTJpFZxPA?=
 =?iso-8859-1?Q?fcz+wC6UvbskT8VFQtyVR3nS34vKfMmjVvqNaQxeGwNH5Z4Nkdrd8OTbej?=
 =?iso-8859-1?Q?wxU+SXXshCBwjGx9Js+pf6h2ucxvuYfSmh8a4hM8YRaJdpND7T/y333tKI?=
 =?iso-8859-1?Q?c4sFKoNGh18z6TkLqFOPrl/+jbcIYfYgCnFKp8AU0MlE9EBdd9xteAdD9s?=
 =?iso-8859-1?Q?lPNeXCAjGS4HvLGJMS6sA5FNZ4vdGsn6ZU1FaPLJT9cO9Vi+JSaoq/wXyg?=
 =?iso-8859-1?Q?Ff7Ogi8tMQcMWD3iKXWQ5oWgu08LEbVTgWWXZsxEB7b1rXVCdViMY9A9a2?=
 =?iso-8859-1?Q?eod5zXnXLwjCpWZi2t8XkmkrrqZhG5wQ8ajgf0D/AHqhioimxI0UKAmuFX?=
 =?iso-8859-1?Q?KY+nSGJTY8BzZ/nZpV7DiLC8jxdZfBkfKqIpxs8va4Cb3nFtleOrjztB0m?=
 =?iso-8859-1?Q?p73CoZpqyA0OpKNZJAI5FLOaLdXm3s1WSwUFWcg7QcUxyGWlwHNVB/wtH2?=
 =?iso-8859-1?Q?0KyIgLVN/U1MLeWwg9HgOPwy6aQ3JHYSmUCap9S/EtBGMfS68MmSrsgQOy?=
 =?iso-8859-1?Q?YGJHmSIsRvPTurym0BMKUYtjbNYhuoUJlE19wq429M3/YcB8eRERvxjHeg?=
 =?iso-8859-1?Q?74SMUQFe4dIjC7UCwmcvmqnSuJXlG/qvnplzKNJDNXcogcLm9pL65M45au?=
 =?iso-8859-1?Q?8skBmijhQEsrkyjIDpH6zUSAtHAVblwzJeZM3xI3fUBAABaf0R7IXusc5R?=
 =?iso-8859-1?Q?3kc4eHyCPSwBoaKtv5jlucIyW3G2KJWfgG4yCLKJQ6UPnQXj5efridNDCE?=
 =?iso-8859-1?Q?w/PuETIZaSMkmcyctK7Z207JBs8bi8eKvPPb1Y4Xs/ow3zHRgqg3+arwTK?=
 =?iso-8859-1?Q?wAeTXUJTSUbwg1IpoayY/XytkcAd8jecsczh7n5BO/Erv/0Tjo+yl3KDTF?=
 =?iso-8859-1?Q?QvjcCpzwty3BkE96E0Q+YIkeRwfahef6DRt1ODXGWnMkcbXds9LxnF2Gtz?=
 =?iso-8859-1?Q?33zBEbuqXptjL05/mJpvHhS9pjhWqmysVIe31KIMKR0+4ZtEtx9o5rCeZ4?=
 =?iso-8859-1?Q?hEKAQYT7YDF4vcdcabIpjF89n0C6XJuVCTSqFG8itKVItcOCNqxHE0LUgy?=
 =?iso-8859-1?Q?SaPVqq1CqlEvoMHjMTXoDau6RkAeIF0VXK4HDCOyvAu47pk9a1eBKLzwKv?=
 =?iso-8859-1?Q?6ce5sqqlRdmjJ60+R56I5afb0lzlTQxXZWEHWbOYVmbBL1hAjeHHr+a/IZ?=
 =?iso-8859-1?Q?5YNdjnkbCE8CBKXSgfwhccQ/3ObELoqJNih1nv58HvJ2Mrz+6IveyB0B8G?=
 =?iso-8859-1?Q?eUko5HSOMqSuUGWmD7gpuaJuM1m9YqR2GaoOosJmIpakoW+oUdnJCoLNbb?=
 =?iso-8859-1?Q?41qEgcv5g/GMXHQdPvX8RMMIWn+gVweK+vjs6x7KrOHc9rHShU0QuFETh8?=
 =?iso-8859-1?Q?kmx25O6MkXwOogv2uCEYF/cfP25Baq7J+9k3M38s+hNfHtHV7/MQR11XgH?=
 =?iso-8859-1?Q?+gpv9gB8Ur9M1uIJujg8pGabbf5zmiVlDVbr+tVy7hJtj0WVhBFR4OVFKN?=
 =?iso-8859-1?Q?ryfxW9M6KNX+egMUKfBeUfht4+sM13CO+UgSVBlhrzjP/rTu9awk9Y+70I?=
 =?iso-8859-1?Q?CvFzCz8PPi+SZdAtpPI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3b3234-edcc-4eed-2c33-08d9abcaafb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2021 02:08:46.7364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p4UyMVf1gy6n7dh84NEg0FP/XnP77NjSVULyBwHY2jwKDp2hOkybNBZ85ZiJFrxcS1MikpW/bd9nyaFiZlUHCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The name for add_lat_percentile_sample() is confusing, since the function
actually adds a percentile sample to io_u_plat_{low,high}_prio,
yet it doesn't have prio as part of the function name.

Rename the function so that it is more obvious that this function should
be used if you want to add a prio percentile sample.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/stat.c b/stat.c
index e0dc99b6..93f3a8ff 100644
--- a/stat.c
+++ b/stat.c
@@ -3061,9 +3061,10 @@ static void add_lat_percentile_sample_noprio(struct =
thread_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
=20
-static void add_lat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir,
-				bool high_prio, enum fio_lat lat)
+static void add_lat_percentile_prio_sample(struct thread_stat *ts,
+					   unsigned long long nsec,
+					   enum fio_ddir ddir,
+					   bool high_prio, enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
@@ -3104,7 +3105,8 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		if (ts->lat_percentiles)
 			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
 		else
-			add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_CLAT);
+			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
+						       FIO_CLAT);
 	}
=20
 	if (iolog && iolog->hist_msec) {
@@ -3195,7 +3197,8 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->lat_percentiles) {
-		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
+		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
+					       FIO_LAT);
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
--=20
2.33.1
