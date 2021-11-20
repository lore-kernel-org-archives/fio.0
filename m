Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CABC433EF
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 02:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhKTCLz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 Nov 2021 21:11:55 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19124 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhKTCLw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Nov 2021 21:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637374128; x=1668910128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2nS4ECFDh8j+3ouH+hNMU1eXAeGt/0Cva9JUlnxnxkE=;
  b=oXT/xGzrF/ziJO/iOGiRXn2CcKMf76fgTIE4hD0ODM1JGApfjBQVCY7U
   lcK+DsNF8HDYdQqytjgE7ZspA3WCQyrUBzpiJO4XOKxyUsLBvPHvsVGL2
   N3oIu21s9/QdAps2UkR7SbraONCpftC/R8+ZYJM5+dO0wTUiUP9KgwEB2
   K+jFly6iOODeEFk87iGo8y6Iiwhoc2wDOkwkw2hsaEk/fdouJFNTtx92I
   suZ8UUkkvDaoHt7h1K78xGiw00Z1XgdkLup9nCVkJLDWpEnSKQVLbtIn+
   /bgAy8VXM7OWD+EZqZ2a/xabvPE8yR9RUwAvyBNqJQqEvJ2wdVT/amxmX
   w==;
X-IronPort-AV: E=Sophos;i="5.87,249,1631548800"; 
   d="scan'208";a="190965464"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 10:08:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGEq3cKkMjfHg5wAxxH9brrkXVEY6HVoqC3uFHCZ9cgNQMeVvP8Ysdsgj5Qvd4UOKLjK9Tb/ToXV1r3SLA0mLQ5hfW2KxBUMhA+7Arcog4Xw7SQC1G+jlCnEvtxmOzkpK99Dbzj4fpzLBlyoU7375dehWc/taNtSkqsBXgkp85wDxDy/CiHMGoFFaRT143UC0E7J97Xn4SCcMdqJuZzvjJo9pB/xOoZ7l8qso0glKBE/EGL69Kt05uzs6GwSs7ngdWQxXRDmbsw/wxEFJ3OftLCiTClsbr4n5McIxYERmVjzRpL6/djII55Y+UZKnkx+f0SAGXBPpFZO5NIGKu25WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yt3xpGtfyeMpIBddVOG5aIoJ3Roe01S9ojxaazKfLk=;
 b=ID6evBEL0V7aowdk2lPHdhXua5xHfRvczj2LIzkMrSPVzGYcxNto1vKtZp9BXMnwmzK+3ZN87tPJsAGiYcBXXo+E4W8/OBig89xqMnq0cykyfYl8reLfEKBq1XGMy5298hgNSOWqU9hUGto45uwYQR6Gg7RE3ounTSB3Vo5U+bGZQx6inen/BwHYlm2uPO19FpJ4KTPdV4Rp7HnysBbmgXi6DgekUHFz92VanBktB29pZ+KkVN6pAXyrD87q5nN+u7XkVSDbRMI6Uc/HIrs3WLH7+zA0vFb4jxogcjxHwM9EfYX+SUHrCNtOpqy9RgLKCyCx3pOtR/mLPz49aXb7Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yt3xpGtfyeMpIBddVOG5aIoJ3Roe01S9ojxaazKfLk=;
 b=oynvXTeJzmYZOIaZJ2Z3AwJNz1ZzC3LqAACnnlnkJ4eCY6MIe04D3dFpEKR1FmZhOc1n0g57kwXln3PEsy+B/UGXeD5YGrBMTOZWFjrn/B6ewGJ5NgEnEL+UAvOceOHGS1c7p5ui/L9fsPc43wLHsMzijO4EdsSi5TbxAli0Kzc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 02:08:48 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.022; Sat, 20 Nov 2021
 02:08:48 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 3/5] stat: simplify add_lat_percentile_prio_sample()
Thread-Topic: [PATCH 3/5] stat: simplify add_lat_percentile_prio_sample()
Thread-Index: AQHX3bONZEdiWVo5BEq8WJRAy9h99Q==
Date:   Sat, 20 Nov 2021 02:08:48 +0000
Message-ID: <20211120020837.127453-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 4baeabca-1c68-4675-dea9-08d9abcab071
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB76229288D549389EC24412F1F29D9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C6qRdCoZ2q5SkzUtec8cMYNbf1lkMLJELa6CdCnop2oDQwZePjYgZYx0rDMaFwGvk06x+VbfUI4UQUmMDrmgZ+Diu2xyyKGzFVcwgaI5rceJzzgfXBGly5BehvmZ1B78yvr0Ctt5XhkHMnrVxToy0c8uSRuTkNR5vAewTBecqw7y+PAHPCf4Y2GuRlaelt1Zg0agv8qiEwOP/V89UGnKkEc+zI+fNw37fjXfzN7ZYUr+yJzJFk6xhz7p2UtY4+VvJpx8VBIa2gwqdtrcRe8tbAcGxCxTHHPG33fOFx/gqJLy4AmEkLeS2xdruNczBB8vEOqAA+V1WPchVcxIxmIsQM0cIqS2hUSCvhmj1+0Ew4u59qQXuRXyIsetIBLZ2CZG4Fy6j0DiQx2HHDD2IeiFq4v9D2LM+PBGZP0hM+6eHIP+wAMsLicGohYEU6+8+aS56MasTWvRJcfsjgDUNX88YJydBG4SQvluoPfCeELWE2AkMfeWgkANgjOyI2W64o//7Y6DBJ+sz3ZL0yGvZ87/TMjEvsVzPwIPfopcvNgJGnxoVFuW4Cv6i4rrjKqIIP8llRpRIGictn9UKK6Omby2x5651aqa6zXdNudsM3j41P1ayJK+Zz7UBa0VFChPGXUkipQJwFrzy4TU+4OaD2sO3vAicAAp9204N4rX6UT8z1ZCnLoQRIHrRZufZAopwbSldwCNRK+ha6uiLAUrjnxpsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(8936002)(4326008)(38070700005)(8676002)(1076003)(26005)(86362001)(2906002)(91956017)(76116006)(66446008)(66556008)(64756008)(5660300002)(66476007)(186003)(66946007)(6512007)(6916009)(71200400001)(508600001)(316002)(36756003)(6486002)(2616005)(122000001)(83380400001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Nq+vEr8GJk0m6rdw9jRo5IH9f32hDs1xHqei3F1TQ83HJiDO42tJpRdHkZ?=
 =?iso-8859-1?Q?yBOcZlSIEgh/uMRqbs19TKa1K/nUekR4KOMa2swJoou8S9K0wZYCsjJTto?=
 =?iso-8859-1?Q?nkSyxbzn4ycaPo8wj/8BugcxR/KZyTF+jYgUelqcbTXrvB/qmb7htxhUZD?=
 =?iso-8859-1?Q?YgUwUOzV13TNj2Xy2mma62irRLNgJbQH1/Z7Ra2jOO1ulSPCLV5uotoO4f?=
 =?iso-8859-1?Q?uCBCyVQsXGlyBquGx1PwgzQTm6tmQ1qIArzk5fk2rPATFril06dCGUkJJP?=
 =?iso-8859-1?Q?FE9ZKdKKhcOqsqo+9caTeiujK0bknnuT1b3qQo2BVWoIw/FoWSIRXuloQk?=
 =?iso-8859-1?Q?PdLBT48kBjzGQOJ5M/oMv3CYpo8Nh1OHcyq2mpuZtOqW5lj5oPy8q4A03t?=
 =?iso-8859-1?Q?xeVUdeqKlyoBX3b1v4l3WYQ4GghFYDvhheXp/2sYawzex0DSUbU1py5Vlx?=
 =?iso-8859-1?Q?VRxgYXA/bcuQuiU2OTkmkDyM15R6Ahs23eFtLQ/2wewPHOATNAQOWoUdA4?=
 =?iso-8859-1?Q?4RYTPNI7/DUUWxxTr6/+q+QdwWUShijsPywtezTT3HYE+su+YtpHt0eSdV?=
 =?iso-8859-1?Q?aqGAXrk1gOLrFoVn3uyBr8DhczKBvQpObeL3Z1ldBE84jrG6Tg/VCU5ZlO?=
 =?iso-8859-1?Q?ijl3nSFFK10S4vClTWCi4qkELOfzSN1tLAWaSth5amQlAToaNuwBitUIz1?=
 =?iso-8859-1?Q?Uo6H1paHbRFNNZR73Jx8qfYQoq0ylVsGp1EWYaXVj8pc5mDDcIeHwzi+um?=
 =?iso-8859-1?Q?en+KHxIXrITSHsbCmrb79SmZm0hOc2TIbYH8Q9P0XAmrbOjc43VZ/0Qn70?=
 =?iso-8859-1?Q?6H011ys72qM8BWHbe3KcolK797ynoAcgXqbVQvFWOcRlfo/GAPAUDWqB0T?=
 =?iso-8859-1?Q?hb+W6eidpZlij0mxZe7gHh66RZPtvJK8faiMj3Z7LIrPn1ouOTIkbRjjMl?=
 =?iso-8859-1?Q?jnidSYaX1OwfR4Q7sGmf/b6SoLb1JrDUZ+ZqFeTfer/i0YbkMn2L9bBNSa?=
 =?iso-8859-1?Q?Fk7Tj/AwvPIJVvQS4+jB2Y1vgXQwgv6cN14Sz9PydfsusPfFL6v8pEfO3h?=
 =?iso-8859-1?Q?eiwVdRNLJI4MgpDTXnde0ywkngtJwZ8KooAYDoSA8mysh15CEBKUCXeyIN?=
 =?iso-8859-1?Q?aAgvx0cizgUvmfW+/V3ptrRGej1lva83i114rTw9wlRwRXHT9YdiAG/lfF?=
 =?iso-8859-1?Q?CisrUHZZC4jpsVzJOXVNYrHwVjNy6XS0Fkr5QIgW0VU49ZGMik6k1q4dQs?=
 =?iso-8859-1?Q?13YYsglpCiUHyWc/ysreS0pcNdpcLzr5NWIuGQyics5xMKGbfijvUoQXRR?=
 =?iso-8859-1?Q?vrKMtj5o8XP24pPsRYKs29ERAy4NSfwJSHvPzTi6lYUxXs5sY62it7PGwd?=
 =?iso-8859-1?Q?Fc2NdE6z3uxDgG1mM+MELsWvkrRO8NSFK+oYMK5dZsclecfnZGQ3uGU61K?=
 =?iso-8859-1?Q?o1tqz7Df5f0bUltrtENIJGfVYpdimI24sUZM090oSNKugzoCKfi7nEp5Th?=
 =?iso-8859-1?Q?/z67tdEb0Qn/4/9DivgQnuvXpRIsACDfOhXiACyTj40kNBPZEaPnopVwer?=
 =?iso-8859-1?Q?yLHzMe7IDPYL7LFAHmOuk+HbKcMPamjONUTVFV6IjFporX4wA0A2NiiYe1?=
 =?iso-8859-1?Q?1eIr0IsOo5ale9D8xSjpzeaWPtakbIhYKFoZaDf4lUDpNcotzUfCjlXTlX?=
 =?iso-8859-1?Q?yxLNgiIcCdqRevBIY4U=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4baeabca-1c68-4675-dea9-08d9abcab071
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2021 02:08:48.0287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +CGV7yfLP4PE0iMGYb4xz6nNmrBKE+n5zUXMHS5B2X/H7NzAkkywyFWbmrMCCG/oRk6L1LctylcR7tRnIPfy6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

When trying the understand the how clat and lat samples are handled,
the natural place to start looking is add_clat_sample() and
add_clat_sample().

However, from looking at these functions, it is not obvious to see that
add_lat_percentile_prio_sample() will add both a prio sample, as well
as a regular sample.

Since these are two completely different samples being added, make this
fact more obvious to the reader by calling each function separately.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/stat.c b/stat.c
index d08510d0..74f48dee 100644
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
@@ -3103,11 +3101,10 @@ void add_clat_sample(struct thread_data *td, enum f=
io_ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->clat_percentiles) {
-		if (ts->lat_percentiles)
-			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
-		else
-			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
-						       FIO_CLAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
+		if (!ts->lat_percentiles)
+			add_lat_percentile_prio_sample(ts, nsec, ddir,
+						       high_prio);
 	}
=20
 	if (iolog && iolog->hist_msec) {
@@ -3198,8 +3195,8 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 			       offset, ioprio);
=20
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
