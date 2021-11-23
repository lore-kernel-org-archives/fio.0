Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A913C433F5
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhKWOah (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:37 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbhKWOah (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677648; x=1669213648;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6NBIVRpGuprEPigblvJ1MDCb9JceLCuo1aIqbR8oODo=;
  b=OeZGoQ8kgFK/Y+aYTpOTd0l4FA1cV0nPcAqaph0q0HqyeCoYRYsnmkEA
   SED8q45qRkQkpfSNOK+AcL1rKqj5FF+7wSnLjE0p/7Q16BwDe8EnP2UVf
   xzrSg8Yyg5HcVbVtzL+MCQXzoZqT2RZvcwW7o7bjoedossOrXgGkDSAH+
   vqw74BVdLJXseL727XUacMMnpQtrl9lhODL42JUTHJnu8BxZQ4dNJOhwl
   laVcqqeYrhjag31A21iffrObrNc9gNbiPTvlUzTW7/ADWikLNyt0fedaX
   MwkQqgJ3B4dEha2NhhCxZdFsLQOahb7+BMeB/w3Pz1YbcyO/1OuNIdSrD
   w==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250421"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILWfYocyoHk3LDfqK7/Y6mjvB9rV+M7YUB5fI+b+4E5ODynz4NcSJ0OsFmuHK62cpHwiORFiUvSGapCScuJpv8dKVTjfvJmLraguecYGX1HGA8jCUsK/3TwltzxejaYSKgWmRapdwKggQiX+zHCHTdPkZxndDkmPd2EL6+JZqy6+d7VKN6TjbsFfmrP1jRHtifCUufH69D83yZJ5/1TZiV6esxcZe65OSXpenI3qbTAdbwciVlcasmqQ/Ow4SF2P8PSZlkp/LeGv32woT9yF8k+/lVys5litP8sYZtnN8v2qIQc91mfUFptLA2VQJTbburumei2l7bosR5YbJ//KRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AYbhxo/plAMII4+SFtf4cGNXb+QGDNWoECxNURaKkU=;
 b=h0ZEjsnxsE2iKrQifQ0DB461/zVQk76K3ZXECbSsSThWcwIameWE9qeoq7mUEvOUvKZTMw1ftnA8fvAc3hMj+ixPQc7qha6Xtan1tNGS56N3CqzEqda+eqpi3WfijjQMGaIE4mHUADHaAi1enEI6k8LhpneMIueA0sd8izVEupvtSYDQkGXkkjgD0tPPJqLSusgHzdCvHJAY56cAY89w7pGWqVjdii/StH+RsR/IwCMo8P8apaLhQmhjgYgxi95NBGZ+DcF8IRMuLNPZmOGOosYwSmcokX4E5cs76SqP06YwP2LqHWdv7pGzDP10Lo+8GENXGyfZ7vKgWHW8TXLM1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AYbhxo/plAMII4+SFtf4cGNXb+QGDNWoECxNURaKkU=;
 b=hV2ESjOYcz0av6gIFWlIvMOUGIsk2M5qRvtr4VugLQPpjJBl03Oyuixl8GDm//rCROIxHht1lOrm6ahDPlt8T2wlyDlXPYwn0EUGaXAykky6f1Q/uzqkkUyjZu1EXEhre6lBys17R4ruKfoRYlAADdwjbNhgvYh0sQRrg4AHZjA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:27 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:27 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 3/6] stat: rename add_lat_percentile_sample()
Thread-Topic: [PATCH v2 3/6] stat: rename add_lat_percentile_sample()
Thread-Index: AQHX4HY9dMn51vrJHkWTspVPF/gUGQ==
Date:   Tue, 23 Nov 2021 14:27:27 +0000
Message-ID: <20211123142708.48867-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 7ea365a9-f188-4031-356e-08d9ae8d6014
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB75898A0580E250EB6562D655F2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /3aOCTRcKlSEE9WhRKFIo2fL6huRIsxh+XAwRI1B4wZhiwFY8q2hARGb0ewm0guJHK9NQVOLMAeiOOdcMALL+qk+h8+Y4AmK0IV0dJ/64+ECSmtpxnwYUCKaYBn3J3JeDWR/NHwDjFl60cRikvmUtEx4aAY0ArqjKZ1DN6YbZdiR8sth9soicP/VDPcmLxaMwYopkGQ6CZwAYNAmu2tf6S8roDQDIrtVKxFEtryzgF0yDqw9PW+gMg6ga1hwA6gRx2pRFSlXluZNY0vmuvI7gQ99p//YMCRSfSu5mJWf7pCG0VRPby/wYr/yCuhG1GYmkhoRuKPdyhshdEKrktsefmhLysEgLVww9SINKuqSC7sERwqfLmewyAuB1G9UpCmzSisus43frOeHw10X1ERO6pdhvNM2gZtoxCunKquTXqbuFGGr5Gpxz/QrVN2pRDOTP4LxxO33SYLGX/uRgk0IZSm/LOC1P26jWC4xKrU6tl97GPSYHt0zoJ4dKVzpJxP/cmk9nctvGOIJZ5eJBtsAhYDxCXALnb93yokbuUzvzEk0wxO+DuKKJTxG+gsaP63tBotBhjZY43W8PVfcxVtafvR7AEwjyKln2vPeU1zE7yOFPgtpWdJAKakaLTgB/LJwIOwN71HvrVGmvi6Jf9vuqvRXxWyNEIItxzEXGb/0rhZO29y1Zr9ByYVVU36IPmCqhU83PvIML1K/c4imH8oeoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(83380400001)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Ew/qKqXq6pFZwjuxZKJ+1XktEcyk5GUebUvoOAbN9Ati4U2kU0uIuEAMSB?=
 =?iso-8859-1?Q?QqWXPSQTZT7QCAkNyJbuyeoSKLmOq0nvw2HtiA7CvSK+9acaIA6Fhmz4aT?=
 =?iso-8859-1?Q?oNtgUc22GsvM5dBCEsDzFNOYSugylnEB2MmWNWHX5Yx2m2Jf9NkU/CrDSn?=
 =?iso-8859-1?Q?tkmtTDN9QqX2PBt5wuW59OSdbLrGJqjP9QbvoTbno9uciT1+y5vUDctgG7?=
 =?iso-8859-1?Q?AR1hKwJt9IyeI2TMsXeeVnwx2J/eEJgEirS9NXeM11dxmH0G46aDCFNzb7?=
 =?iso-8859-1?Q?vddBUqCrPi9mNY6LtjpGMSPqmwiJjwc6oUSm8CtnW2DkZeGrB8fKr7mbit?=
 =?iso-8859-1?Q?zHfeR3sVql0CXgyYZEKy7rqgn66VWjukdsCgpqSmKpksPR/l173wuej+6v?=
 =?iso-8859-1?Q?IJMfStyKWz8gCKlBtGQhJw77iblSOlj0ee6qIMUEoVD67uLMrEx+YlJcow?=
 =?iso-8859-1?Q?W1voKD5AmCD0dAWF/EDkvgsi7f746bz7jOmLChxFpNbJCKXCl5AW3jsaBz?=
 =?iso-8859-1?Q?t3P5sufro8Ke9V/NuOyWt526hebNZ0oFzDJm3E/pOdovhmTJmXBMwmYXik?=
 =?iso-8859-1?Q?SM+aLw6Gp8s1KcN0Bt09fjbTPklSe/aR7f35hl2Wvnr+0auhv9gWupusCD?=
 =?iso-8859-1?Q?Cgg8+dXSVup4cm5fRxvE8ipC7WXfEtle/6TnA3QdmTez9GUsWpB+HSsDp3?=
 =?iso-8859-1?Q?OM/JfY1anmsAQhhxhBaaY+3rSJwgeg8ct9vqw1gcghorFNLqy66H/V+oIA?=
 =?iso-8859-1?Q?tCbsJ46wMEPtY6nZxyvH1kJ08ThDEDlkEHlV/DgQpLXn8N5u6KCl3gel+e?=
 =?iso-8859-1?Q?4j+AD6jkIwyunPW4TcgKpDg/9ipg3HXCjp3QC0HjDEtrxBOspfI/2qv9nH?=
 =?iso-8859-1?Q?HsZRbcEWTPf/NQofqQpNxwhRJrVR2dxbj3NQPRlwMPGh0UQCSS+n5kbSyc?=
 =?iso-8859-1?Q?+azmHVM/FtiJ+oSan6B4IEReGjzlPAwg+J+30ggTzZeMv+pLYJll4vdUqO?=
 =?iso-8859-1?Q?EJeshK8asA61s/GJNeQ/FroRdGE1sAnWRJLvWlIoT2hGYz4A4rGCgTDPsH?=
 =?iso-8859-1?Q?6lfMGph1DBj2NeKjVAxIbduezv9QmIyvgUSzuZlddYGW/goWaCXlEGJB7i?=
 =?iso-8859-1?Q?mHWsKEdSeT13/uZMEKqydmQRS8kOpD2ruZGHn6gbqu4lrA6Xhc5hx1GiLJ?=
 =?iso-8859-1?Q?3sTMYp99zrRJ33E8pCDZiEfECYJWnU8/npScJRdygDLm+Ve0rNZQltijy9?=
 =?iso-8859-1?Q?fkfgod/qfRSsyIDgtePdFWtGhAov3F6F1fxrwEwvl87E0QUQhxUDoZyJuI?=
 =?iso-8859-1?Q?ioFnGOndFCZmhIeLQ9PoioAgroXGfBMnZfTUgHQt0sEeQs/BQkzgBR7Clk?=
 =?iso-8859-1?Q?Uh5uMst+9CcvaHjHvbVGC5XUBcztVQPTra0jrSnb0+n0vK6ShTOSz86mvi?=
 =?iso-8859-1?Q?9R/THse6jVkiLd3yisol5UlSClhZXYhjbhc8A6g6z5xZSxkFtYfspKusTC?=
 =?iso-8859-1?Q?p8pcitZ3eawG7j4+Mrrvn6lsLWRVg1gsgFootEkcwjM0ThOVQvMdQug7wI?=
 =?iso-8859-1?Q?bGhTlugnEpH2aeCqpIDh8jmTauH0F/ixJyDzZMKxo79Cuh5RbxwE25kVMl?=
 =?iso-8859-1?Q?fV8VNtc6PuO4S6L+lF3lsbPYRYj4xqTHqY5ejTlSRZ913vBrSqQfP9RtVp?=
 =?iso-8859-1?Q?hsrFgWnv+ethpQefbIU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea365a9-f188-4031-356e-08d9ae8d6014
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:27.3661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+ostNyAX7Tgx140hXbMgO6FPypkzClIo0wjTueZ4pV+PatcVz4h1eSmmsM+BDd+36nRNDWGDz8VqA1AkwwPlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The name for add_lat_percentile_sample() is confusing, since the function
actually adds a per priority percentile sample (it also adds a regular
sample), yet it doesn't have prio as part of the function name.

Rename the function so that it is more obvious that this function should
be used if you want to add a prio percentile sample.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/stat.c b/stat.c
index 44ca3894..f5d5cd24 100644
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
@@ -3119,7 +3120,8 @@ void add_clat_sample(struct thread_data *td, enum fio=
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
@@ -3220,7 +3222,8 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 	 * sample when lat_percentiles=3D0).
 	 */
 	if (ts->lat_percentiles) {
-		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
+		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
+					       FIO_LAT);
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
--=20
2.33.1
