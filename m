Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2268EC433EF
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbhKWOai (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:38 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238095AbhKWOai (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677650; x=1669213650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g93FHfnheY7b7Si+0hG4bjxYqs7QHmgLL9ghHsk/eAo=;
  b=PKWYyTFlDk6fDoy2npaEDuHXebeMBI/rzlnQA75tt754sFpzpl9I0Kdf
   2MP4zEkUfaVxTBD0mQazY22ZsL8uAA0EiV1VfZ5m0HGopuAkIx5jwc4gl
   GBJpVOCwx1Axf5s8zFUoz5252JDB5RfhsqmO5U525KrMYU2u9RkzTzurT
   z5WJLV/xidqPLICKPEgjit+LSsA4j741lodr94piWB1diuiu5Awu//VRF
   gI4YiXfuGDFz3imqE1Xtvf1Lixc5Sj5jODjhux6qKIpXz3eV4upU5AsZu
   Kj4uYsNsx0q2xni/vOBJvHFGWuKDFQS0JX8UZOfIdlu5UjA38XKZiFRFu
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250425"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWGHiD802hMkUvhegTdM5G3ktNPKlalBOg/rf0G7m9Oav+7YoVuAf8IZlv/FfUdadHmpUxNqbh3sUhgetaX9cxlbNQBusEnjnH1U2ohgikfnIyN1rTFLIyXWjuwLNRF6kf0+hSLY64QoQWeeVXDNCrj5hreqPqNKkMs/jbmq4txnA7d3f+b6yZOQIte/8yT6dmViuHE0wXe8nlkyv7zYjSRnxVpVHBpAeHSsa2CrVMRtH5lRwQzHNjwkxxEUm6rDAMJ5DXxgzZo8HHO6axOpImAzKxE4mzL8LnHDb72hs4l9TXaSIlp6OJFBqe/XViTty77nftsBC0HQQEI/Yq6U+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6/M3HqIzCKMeumYcvpxbPxxAkfjvg5vL6qqWPt5/RQ=;
 b=iKUZC0h0Y4rd4qyS71EY/8a/UbX5pkqhxWS/4LpwgLvEPez8wRWqCbK+WLncQLdePgSQmZUerp/1jZAHPBCbi/AFrG54SioJdPHgZcPBow245W2oNp8tSQMgOH+l/TCuaod1ysyONbpPhgFF0iOTjL9T2HYokCa9cS0SYaCNpAsZKeTVuG2KF7XesB+xiZ5LEVRHPUuTqdbUw/nuGPdYOPBnk6E3opkhMvBj7HKNTOem/WSdMxaxunPl16NvZoasoZMENEppCdsupizIK98sdQCyreP5/QDZFtviPMT7aNp01DhSwr/mSmrhk6zbkLUt0xTWuu0TAxmZihr7b/Rs5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6/M3HqIzCKMeumYcvpxbPxxAkfjvg5vL6qqWPt5/RQ=;
 b=yYB9Odq1rYjayxIY+vFHIIjKv1pZE/gVX9MzvZHAPsVJ8nPiBZKzuE0eCvdhN7lA/3V7Gc540a9Yx6BRfXkrVgTwAvbL6UieOKbsS3wo4nOY5P/6NZWBAhQwS7rir3wMvLEqlRK+b9ykhTM32J5VUUUQpNDTfQKjertT+XE9BIk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:28 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 5/6] stat: simplify add_lat_percentile_prio_sample()
Thread-Topic: [PATCH v2 5/6] stat: simplify add_lat_percentile_prio_sample()
Thread-Index: AQHX4HY+IMYg9P6z0EaNRJPlms00Rg==
Date:   Tue, 23 Nov 2021 14:27:28 +0000
Message-ID: <20211123142708.48867-6-Niklas.Cassel@wdc.com>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb649028-3ba9-4c80-286c-08d9ae8d60ce
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB7589ECBCE7E798A7B38F7E7FF2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HfdV9ofT4QYqaU/id80WynA0aNW6UMqofHpCiYVNV8uIDhakw8Mn3hkmNpayG9/UwHeftjSUTTNT38bjSSoMVecp5TuR96CaeJPb2/R11Ql6W9wqdztFXRt7FjQVcDnpEl6K0H0OOOeCZO8KPd32nr0O56ojOqju58XHqJnNUXU65k0klfq2oqxCUfvx1AA0RGWhJmLTwCV5aQ0NBPfM0MpMtsSGvv3GqBgYuDZX5rEI33kl1t/oTDK7nf2goPapXxjUgmSqOVk3GLq5cJEb9IMYLriZhiU4ftXJnunHNCzSh6n7jxmqGlowFXkCbLsTOH35WmlVPr2/seKgKkjNUZxTuMIxHM00SAUkA/fiKwkwecJpyGcQM3yvPpL1N13/YaOtYzpj4qvyKSbZf0zukQXW4Ih0dTYY1F9Hh/oBdSfyCJzTn7s8dnRkbYcZyFnNeCkIXqnc9hy3O1XorthuwyY2Xad1Za30Qf2UyfBmTNdNgm5HlCLujwGM1KqOLm8QmaYvJpNEdpAYSIhbZHGO6WrrgJGdW0eu2OG0uN5kHUtJGP+ILs7WIZfDpO4l9kigrVJ13iwwFWAR4l8pFMcJp91G9eJOvPW5kA57wBj8jTWrJB3uzKjq0ZZaQiA1TAJujYgA3HYzSbZB4VwNpgwpiawlJT9hOaI8cKyV5S4I9hrf1MaXWQ1wofbfmniQP2X2ud1fWAkcQxGqdbt0knyegg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(83380400001)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Xlu7FV5aworXn7XsXGkWlLVqxeS4JjAlUGfvifdpH1plyg0xHEhBVwBVsD?=
 =?iso-8859-1?Q?ktaYQs+G+//lMUzAmktESl8HzOyrGEx5/P7xqRi5r2pEvnka4RwyUjN2jS?=
 =?iso-8859-1?Q?UnhGXcvX5MEm6ffl7Mgq9ZepENV3TeR/642JfGMDDq+vQAuDgbU/E8bmC+?=
 =?iso-8859-1?Q?najkkBPdg6UxM6I+bhrDProEHhUHKDy2fFfv9HctzeBuS/nbAM+C+7huWt?=
 =?iso-8859-1?Q?0igEGqmiyT7XfOgAkhwYIoblSdLAlw1SIop4cSBfOvesY2WMim/ZnFwDU8?=
 =?iso-8859-1?Q?g/oHdwN42i7tPESrDvJDPXv9pSDS8aWs1vvdkDmqFsd4YLEADX+29pE38C?=
 =?iso-8859-1?Q?GZPh3EiPrTHfzjfoNTpdJdjRoYLMP6hrEcX5inKV7Na1/rB3ItE9DFXFxI?=
 =?iso-8859-1?Q?gHrKd1abS4DroXIkMgnMcN5ST+DbRuTdVYoIYY9sDZ2TRbk4M4ed73o+V9?=
 =?iso-8859-1?Q?rg1zjfQJL+K9Z9RSthJgUIRmeBF++d9lAMy9KR3hBaeXh9oY8S7OODUEbP?=
 =?iso-8859-1?Q?mohAlIZcaO7TfaeOV9cBKqrv7M5c4+Z2Pn44RqflPMef/qK6R5X9QTm37m?=
 =?iso-8859-1?Q?MYHGKwKU3i/C1Xz8Pi3oHHJw7+7P3JZLbfWNcQ7jdp7fxw6AjU97ST7dQX?=
 =?iso-8859-1?Q?6YYNlsXbfTdQtMIpyuO9riP90SgZxRDRR7e28qRwqwTu7iHpyJNJS7bviA?=
 =?iso-8859-1?Q?LPfmNb4WBc+UYYyhxo1TYm/YhcARmusLWrmaBkM2EjAXQa8xuDdGB+LSJs?=
 =?iso-8859-1?Q?oQQIZ6Qh/ppqO6U6OpXogErPqGcyM7ocOfVnf3BL5rTvMNzg/MpyUhX6e4?=
 =?iso-8859-1?Q?bk8w0C6N+qywXnVaLOCVXeIvGWLlMPLo5f3xC0bSTaeQRK4kuAPOC2iBj2?=
 =?iso-8859-1?Q?4z5oaDuTAQJg8r8foL7PK2VtFdMKipJi6y8l46Knyi00D1juArq1Uw3vt6?=
 =?iso-8859-1?Q?SLpwIMiiHwv5Ea7OY+WT+FDN+YjYqTuYidcPCUUDFFXNDvTroWAn6fdU26?=
 =?iso-8859-1?Q?VcfNZZmczWprQUrGJQcr4UJgv96O9y1Grcs0mnC7ytX3IpRlubVqJdmnn5?=
 =?iso-8859-1?Q?Yd5b8B9R+hRQHB8rm9DwrJ2LDWQsNnhw97pfhDopsQIu2YbknVnRDBWcEn?=
 =?iso-8859-1?Q?yW4H++ZrJCHcwp6uvkv9RQtSoOujMhdsU5oTUamOFbK7AOxqlw+xUzy2oO?=
 =?iso-8859-1?Q?3m53gLz3YfhCDXbiHqI46XP0J+vLrsJ8ZcQ8U1Jdk3naCRYX+b6H+ORtg7?=
 =?iso-8859-1?Q?vS3JHL5cmM86q642h8P08A+Q9O6bWz1UnCALkk9uWQm6TAuu5uf6xA31ZJ?=
 =?iso-8859-1?Q?Zk+gf6k3YLVrRXroxSRTLKfn4EfCnmlBixjaCNcfISQ5Rjtf/yBBsl/d1y?=
 =?iso-8859-1?Q?1ZCVE0+y8vaKSyyZrGjoNimdr2X3p1mnEN1CSafigIW1iTTPpudqfKo+e6?=
 =?iso-8859-1?Q?GFo+8Q0tbwVDs7Ch7UQQUPOvxcr75U4oCBwyXa2d0bj7T2l1IH/fhSGHXI?=
 =?iso-8859-1?Q?RKD0h4DyweivLy0BKt3udjEqdvoK/fNMsUNFh+HmXqM08myvKrGIxBW/ic?=
 =?iso-8859-1?Q?SfnJSIrzz1h9MzhDU1Fcl4rIa7X6MiGbQaOb7tyzi7Sw8pQe4yBubxEMVN?=
 =?iso-8859-1?Q?8S25UwsLdBYOlTx7oBmB1jW7R9OE2PlS3PeXcwck6AlENgNI2cwwT+rSfF?=
 =?iso-8859-1?Q?C5C34UjH9n13XDeNE4k=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb649028-3ba9-4c80-286c-08d9ae8d60ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:28.6196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ZlU6LbQ7Rx2fQHT4JGApCoYcDlBozzUyM/epADfL2fNTLITdtakNQdsjt63+cmgilEOnHRT68LgOXh5xU4T5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

add_lat_percentile_prio_sample() currently adds both a per priority sample
and a regular sample.

Since these two samples are completely unrelated, it is very confusing that
the add_lat_percentile_prio_sample() also adds a regular sample.

Remove the add_lat_percentile_sample() function call from
add_lat_percentile_prio_sample(), and let functions calling
add_lat_percentile_prio_sample() call add_lat_percentile_sample()
explicitly. This makes the flow in e.g. add_clat_sample() much easier to
follow.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/stat.c b/stat.c
index 4eeb1c02..678fe953 100644
--- a/stat.c
+++ b/stat.c
@@ -3065,12 +3065,10 @@ static void add_lat_percentile_sample(struct thread=
_stat *ts,
 static void add_lat_percentile_prio_sample(struct thread_stat *ts,
 					   unsigned long long nsec,
 					   enum fio_ddir ddir,
-					   bool high_prio, enum fio_lat lat)
+					   bool high_prio)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
-	add_lat_percentile_sample(ts, nsec, ddir, lat);
-
 	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
 	else
@@ -3112,17 +3110,16 @@ void add_clat_sample(struct thread_data *td, enum f=
io_ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->clat_percentiles) {
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
 		/*
 		 * Because of the above definition, only let this function add a
 		 * prio lat percentile sample when lat_percentiles=3D0
 		 * (add_lat_sample() will add the prio lat percentile sample
 		 * when lat_percentiles=3D1).
 		 */
-		if (ts->lat_percentiles)
-			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
-		else
-			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
-						       FIO_CLAT);
+		if (!ts->lat_percentiles)
+			add_lat_percentile_prio_sample(ts, nsec, ddir,
+						       high_prio);
 	}
=20
 	if (iolog && iolog->hist_msec) {
@@ -3223,8 +3220,8 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 	 * sample when lat_percentiles=3D0).
 	 */
 	if (ts->lat_percentiles) {
-		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
-					       FIO_LAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
+		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
--=20
2.33.1
