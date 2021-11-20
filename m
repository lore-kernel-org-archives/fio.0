Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00413C4332F
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 02:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhKTCLy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 Nov 2021 21:11:54 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19124 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhKTCLw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Nov 2021 21:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637374128; x=1668910128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PGZIdX3j2WzbiKMUDn4hgBt51nvB2hq5KsG5wgH4r/E=;
  b=L69/nw23uHobT8hMRvzZ+98/Qple19n8YKQ9mx36ETya+9CcuOSgXjsj
   AuYyWgApmuPauilAic74BYwit0Ixbo/vYaT4aiiKGp70AOFCttMQiI2Eq
   dLBF9AY8ZsSVT7cer0vI+np79K2huQDOeiMq9KH1rY3Hw0URFH+Ek9FFj
   AbAk+ZKRW/i6uV1ct8zShGZ9g9KHjApTv9B21AiJiWx2je4QaLTnSB9d/
   FvVciSpkGF9HhcBrcEg0xeSXB/uWe3FzVmpx94Tv2bab/Z+dd9T4oBCO8
   11SHyrx6Z8JRzjbqxjsOdnMBP2zxsFvdHeGxJRGuABF3R0z5T4Vxbuxr+
   A==;
X-IronPort-AV: E=Sophos;i="5.87,249,1631548800"; 
   d="scan'208";a="190965463"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 10:08:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFa/KAiw53XfP+m5D5hwcRkZLwHnK6t2EOigamUvp2QkyXU1u4w1eh9tyVIlrrmC5zkoXjKuuEMlXiy1jWwrxLRDrjQ9yT4HEaA2lZIbYpY5Hct76ikA5Im2MrviEQ2ro/FVeL29CbplF0mm8atJ9kO30Y/iwT9WPcVtTNGKDCT/ZVB3ZTt7KIeBtuH18j7N/DmxNbdjW8iB0nnIKUiOiWhqo3w8zCpNsbfzVPOxHt2LYAnVvjP8i31WlsRs8rfG6fiEXFSLOhu7I3kjaMZAJHNKK04fFVG5b+T4Vm19M3Gddwg80D1rD+dL3BXXWi46Yt4ID1MA0H8PX5AngPG8cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1jWKGA6xVVLRfZWCaVBPFbum6+jTxmLgpikccAQPWo=;
 b=Id7+a6ItDdRLvOZQ2jKatpBFV9srBOdyqwI+aGy5QvaDOs0d7RUojkyx66on2xVt2J8VF+G5Py9XCFBxPhsZNTxGMOzum3NM3Cf12clH/WxYmpsMbX9zc8rGqQGRGRvSJSgk3VJZXz0tBsqNXMCPmckaUh6u03jpacqmgIKRzw2/jyQuAL2NKFUofoAjZ9lqiKDgPjcJ9h3/gn4yNz9XCiKlqzlxABhOuc5A9bvULFcrUdWcWYBf6T6KM6f2v7DkkN3+wSlKCF8YidurLiVUI5oOUH+789ZyTXDZBm7vP9Fv7e7BGuE88CrpEwktnySbp7KKfgOLCNMKljdwSRkzAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1jWKGA6xVVLRfZWCaVBPFbum6+jTxmLgpikccAQPWo=;
 b=Pp1eFJi+ZKcxUkWxR2x1VdMz5F3m7bwj8/MJ4gR8GqgfYU6ESpmvKvqWOVkqAzidK9Cn8jhf0UJ1UfWKoCiYSKvLn8vx7uWmwyGSqKueJaJQoXoDTaJcFNMO0CvEf/7WCq77RUPGcaprd7S6+dvWccy2n0GVZdHphHJ/4yif0s0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 02:08:47 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.022; Sat, 20 Nov 2021
 02:08:47 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/5] stat: rename add_lat_percentile_sample_noprio()
Thread-Topic: [PATCH 2/5] stat: rename add_lat_percentile_sample_noprio()
Thread-Index: AQHX3bONcNckDG5k9k+9as5SElT41A==
Date:   Sat, 20 Nov 2021 02:08:47 +0000
Message-ID: <20211120020837.127453-3-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 36d03d01-96df-47cf-7081-08d9abcab014
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB76222D4252DA568D9EFA6772F29D9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TkcAbSWcMn/ZwDzPOSd1lTrS0USrVJJtlSmsxCyEzKgAm4s8V36CMazdWGYsawP3eGhCyzXbUZ1+tii9QWSHOE+ujEiFu/zpEXoW453KKJnYkx/JPMjcZK5QlNFvkf2mrdGAxnB1kQGHlHVSJGKaafi9xFfk+j56SUnjg2SYwYhqcVO0s+Dd9K+VJJ9T4/dXwunerMAaShas38541QFLfS18+WDOGs/hCdH7DbCM0OTHaKHwQ39BvAxic05YS5azOCwCF/06CXHpIyoZtwP3oe4uzgpm7qMSCGeMNVl9LTxrSTLbUFyr69ZpK7gFUt0cbWM0rVGqL97WLsJ5mAxfDjF7SK3mTcJWXBOZ8p1+f60XEQho8o8j1YMFtNYTMKVKXsby7ZWnsMnBJZIZ4PdW3V2ZVe28bGyNbut9OoNK0qhWkpxU7XDk4HYX93hhAEui4ZAoX85McqwMf34dhIfgflstNX0ejiCjCVeE4lyw65B/iFHZs4wd/+2q9ajp3ahjGnykyfqCpEqQkhaNB4Ur9efhovNb62TQStI31zKaSxCL6RPoZJg5muPBZooYVrWkjbpy46y3j2z3v9s6SgUc4+AbaLfU2ddzjGupDweSzgOnXQ/Hu+AvolZLtu23hxlnFap0rKxznunoQS+e04oVLuHpfrjGB1ArdqN6rCar8VDfPrjr7jhIVW7r3gctU4uKYhvekVN3V/CVvUOV1M7JKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(8936002)(4326008)(38070700005)(8676002)(1076003)(26005)(86362001)(2906002)(91956017)(76116006)(66446008)(66556008)(64756008)(5660300002)(66476007)(186003)(66946007)(6512007)(6916009)(71200400001)(508600001)(316002)(36756003)(6486002)(2616005)(122000001)(83380400001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uDWCbpMdqZT+Tk+gQc79mix3vekZb/F9YKVUn+z0MmdoAolkhVztqSujl3?=
 =?iso-8859-1?Q?OPToo7GXZbOinvOlTk+RV+TPjhy8rjDuWq7FKHd7Lugwtd/EUWSP1Ion8U?=
 =?iso-8859-1?Q?uIgfaqXXuVsXmNGy7TSUhw+/86s03HmM6jYBzfziLfTpBZAsRiBTYZNIq4?=
 =?iso-8859-1?Q?J35wbnxehwmNMig8BVrPHBdR6kAgsSu6lhDqAwVRyP5cWlUGxK3fsP8WBD?=
 =?iso-8859-1?Q?TC3XA8r4ZKoUhVJ0/F5AymFFIswcEmxx6JtgdtWmauhzbYhi5Cfd4ZVWEV?=
 =?iso-8859-1?Q?utqpdtQxWWoAaxL+xuq0PvIXM5YxiH1JePb8leNqPcvoc9Bm2mqreKqqTL?=
 =?iso-8859-1?Q?YZga/Qdm65O6q5za+90vVCpt8OnhQqEIuKPYdW+AJw/pvgeSAUZA/epHRG?=
 =?iso-8859-1?Q?QRYS0Bmg/Yr+tAeSH4p9iaPHU0uQkDmzr/PkSKOfqD2BMWYVBTBStQxzVf?=
 =?iso-8859-1?Q?MaCBxdiRJvLxcr2nop03aabIit+K1b+RH2Dmmk7vugH7qR2VGBSD2So8W8?=
 =?iso-8859-1?Q?Yhw0qTaoAi/FRGKMymgZAUWi0XOETg6LfxkiT2tDpnsPD9H2PNxfLAfQ3g?=
 =?iso-8859-1?Q?gJuowyQ0M1iNPfZBh1J4OKJqgGB0lPFHwVzIEtuZoBw5xQhj8mdWJxpPGZ?=
 =?iso-8859-1?Q?yHDt0+B8/Gu5Zs+S8gORhl8mN/AYNT4Ok+boCz8Wy27OEeCuoBmsndYU79?=
 =?iso-8859-1?Q?Ze5jXS70JG3KMRmDB+7qWRix3jhIZZyITeeJCJ/3Mae9niQ1S4dhpQIy8+?=
 =?iso-8859-1?Q?tpBXZZ3cyETBMMmjla2t8Fc+f29kxkr7Ved/eMX3rMVa+6VGtkDdPhc+F9?=
 =?iso-8859-1?Q?i3BlS4PW/8paky8cvArjIWRcnI06LeFrygDknB5Pyzhfy8s/GEz+XvY0lH?=
 =?iso-8859-1?Q?CiRFmpcZrDbZGqx1V3pAXTsS/YIISVAuztWFGmUsQi5bhUp2ez5mLYJ442?=
 =?iso-8859-1?Q?1PhwVBRX6YXdvrF8nRa0C0eAOlab0L2AAJhHMB0uUQK6xMNvYTJT5uzRfV?=
 =?iso-8859-1?Q?SS9DR3PAbug0PcARW098V8ml4ARl1UBMxh7OA++1CtHUhJqaZQSgHmIMD5?=
 =?iso-8859-1?Q?lLaJouXH+Q7HbnhGDSGQId4dR9yJ9HgZX0dH/rzOLFOl/1CnICudnOLWxG?=
 =?iso-8859-1?Q?eJjYaQGLgVY62POgH19KUu9jRXYCH0OyO2tEXf9IkcpaNqqDtoTsiwbqqf?=
 =?iso-8859-1?Q?rAMGb/LLY5vJ57YgwtUl1p9VuKTHlj42cxQ7xCCHL8ikHcYIFi5AZV0uMi?=
 =?iso-8859-1?Q?5N0+XY0eof/buHmORKDwaKTrWs1H3CdP2yL+qHABEOMTiI6ffNCZcj+O7o?=
 =?iso-8859-1?Q?qi9f9MHwIZ/wXJ3uLI0xWeOefabRK4LATGnKKlul+tgfXkSLSNzj6CnfI5?=
 =?iso-8859-1?Q?YX3sAxBlBBpj2vOBTGMROdj5RkmePpfyZd3e9Knb29h5i3KdjqXm/3INu1?=
 =?iso-8859-1?Q?/BL8ZGO2tXO0RqRDfiJwiE48FX7R69vpT4g4FkUbr5ja0BxmtcgU3eqn8t?=
 =?iso-8859-1?Q?yUNBFXEnSY2htFRDlo5CUkKYifiUg0uI1/3oIu2kffpn4TiS/O2/aHr+1C?=
 =?iso-8859-1?Q?AXQG1zUiMwDKEL0Rofo/jBSbSswotAXP6NXUugUW8D1lpdgmV7+pt+ztBT?=
 =?iso-8859-1?Q?iagQoV+NEXIb9v4g19TLr/Aa/6Mhu+S2cEIpVtwfGUHL3eI8Hj2l18Qozo?=
 =?iso-8859-1?Q?GbDGD+spRyn1/NNni+E=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d03d01-96df-47cf-7081-08d9abcab014
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2021 02:08:47.3736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1dQLnzq8zGVad4mMQhEdANo4F4zc1r6DnFZmG60xPmNipyOwUJe8gKWqHr9F80hiKv1GFbkQL/zJiWCUXWDq8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

add_lat_percentile_sample_noprio() is the regular function to add a
latency percentile, and is called by e.g. add_slat_sample(), which
has no sense of high/low priority samples whatsoever.

Drop the _noprio suffix from add_lat_percentile_sample_noprio(),
to make it more obvious that this function should be used if you
want to add a regular percentile sample.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/stat.c b/stat.c
index 93f3a8ff..d08510d0 100644
--- a/stat.c
+++ b/stat.c
@@ -3052,8 +3052,9 @@ void add_sync_clat_sample(struct thread_stat *ts, uns=
igned long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
=20
-static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir, enum fio_lat lat)
+static void add_lat_percentile_sample(struct thread_stat *ts,
+				      unsigned long long nsec,
+				      enum fio_ddir ddir, enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
@@ -3068,7 +3069,7 @@ static void add_lat_percentile_prio_sample(struct thr=
ead_stat *ts,
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
-	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
+	add_lat_percentile_sample(ts, nsec, ddir, lat);
=20
 	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
@@ -3103,7 +3104,7 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
=20
 	if (ts->clat_percentiles) {
 		if (ts->lat_percentiles)
-			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
+			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
 		else
 			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
 						       FIO_CLAT);
@@ -3171,7 +3172,7 @@ void add_slat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->slat_percentiles)
-		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
=20
 	if (needs_lock)
 		__td_io_u_unlock(td);
--=20
2.33.1
