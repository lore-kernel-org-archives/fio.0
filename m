Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49800C433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348731AbhKYN1o (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:27:44 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32788 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349527AbhKYNZn (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846552; x=1669382552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ovHQYLffjDtiVFo/3eGVKoKsSQ6xjmJ7fY4dyhu0gHE=;
  b=kXahT51AD69sH1P8lv1QkjYs6ZUzRTAwOmNmxpbNvoj+lvvpyH/7/7Yp
   Qjjqy50fLkLFmKHZssfPo6RpGsd9k/PM7lZnTNste3onLwmidrDQk+VaG
   shbFkLFsAX9JhMnfPzYS8FdWOz5x4ZTkFbrXij/777vCI9nM8IYVSl6dx
   nzK62fI7g8eeUbwTT6T9Qymdbx9N2z0NiSHwAGnquFTSEY/wk1ETLnKs/
   UEys9yTFijQmHpl2xBjFylIUO7HxOa+Z0u0tvn4J8Pogc8YLEfwTGu00i
   ndtPQdvbfk8dt+8nWQS2lEbpzU6wiuFQgy+L/fsVEm5eredas+f+mgr+Y
   g==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="298461773"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXWjljnoFR4gp+vidR5brscVqDjG69sA0u5z0uuomn0BjFo/G6PDP80yL6ea93DrOxLfgMI1r/rzLM+MJ6dNiW3266V9PEg3KotVG5fwcnW0dAjvOB/aM/4fIi8JTa1+4Mij7iZ6gOA3WLitWpqVfAUL0guCNNPg/rAoMqB8Mtv1MxZ0yEe5www512xqTSGs0w4vO8qWOLFbww9sl/shIOrYQWO6Z9lmnMwtiolMuCi2tA0oxbo2pkQ8xwz5s09Wvg24a6dyxyDiEoYw/9XYc/SKIPmtVqF3gczMYlgbRPsavSd0eIZlAMnAhOf+VrbbsOPQaZTW36yocSo6OwKh+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1t5ikxtusZBAIZ0Zv5vRP3tk2Lr1ArvYiRKcxOfiFI=;
 b=WmQzecw5kn/7fRVlIeKICiTptl1soFCtKc3K+Dx4fPBBw8e90TaVZqqBgw38yh8+8o46zqcuZa3cRSsSubKLzy5dVp2DktjEDDdND9scZhQtza1qyDzRiKuorekJkg7Rf//brGAYMpkHu4HWYEwy+9N8pWudxZJCJiTJvM9+wB6M6upcnCuzYJNWO8SFPoOLYTFUlu2D9CPZLJxdg4ANyCVQ2aVYh7gO+p+c+dS16kl2fZOq9KbJm5NCq+gC1vcz6JhwG/gesE4VqKH92t/B1meq97czSr8BcUP9OGhdPqzCWS5QLXoJ0eviqspO4tqylUh/PNfiseQZqmkHrBKobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1t5ikxtusZBAIZ0Zv5vRP3tk2Lr1ArvYiRKcxOfiFI=;
 b=pLjqLDRsOt3a7VrZf//9N7IPoPgp7xlZpWrp3XSC180WnNFkFbFo9iUCFO1/rsMrCHmcsFKjhis3azTUDEIYG/JQpYkj3G7xI1PQDAzjSxccvleCziZWsTWbYPHtABQwN5ptiRimXdgEuMtmKacDAkjJC1v89GOwKEqkALwJI74=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7591.namprd04.prod.outlook.com (2603:10b6:510:4d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 13:20:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 13:20:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 2/6] stat: add comments describing the quirky behavior of
 clat prio samples
Thread-Topic: [PATCH v3 2/6] stat: add comments describing the quirky behavior
 of clat prio samples
Thread-Index: AQHX4f84bdaMuTokvE+8e3wkTHzBgw==
Date:   Thu, 25 Nov 2021 13:20:30 +0000
Message-ID: <20211125132020.109955-3-Niklas.Cassel@wdc.com>
References: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e381e3f9-2f60-4428-65b9-08d9b0165ad5
x-ms-traffictypediagnostic: PH0PR04MB7591:
x-microsoft-antispam-prvs: <PH0PR04MB7591D03E09A775798F7DE661F2629@PH0PR04MB7591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Xy8ggv+v3qQ9556m9sE0s3XEezMGB4Reid7NOwYT4xJ426iBPu0Gqm03g5FQtrWyL+RIRB9N9vko08fwIxoo37XmOXH02X7x6tpuZCxVSkkc0sGPYCjOAegv1ivz5ga5g1AkhoIjixXXcORtNS8rUlykGXHkGYYsfNPJK95MTna8nGe8QrHagWopCshVwZbagp6JJe5NELh0pMMnmie8NegWubZ9kzFe6Bv2qTRGUDfBoOHANiGS2w5E2X6IikAZhwxXpdPDh5BZ+CLZlQwL0rg1InEDmnGoZPyxxuDqltdRMM4bV+lf/Mm1DHGGXYyJeKeJ6tQWgisLibvtycNGOTbvm+AtPVV2WN8z+6jxAWBb43pkCW0N08KGQ2SbsNAnvJlf/unwCtYmK1g2RymKQZgMPIOpWu5wmy7sXjGrvzhLKjsVqRmFd6olZuCZ84k8QebnycYpfpnS1DcAw7tm7TkKUO+P63lF1edsH3XqeY8sQQsekHDyPcNIGIteC277tN5OmnZ1cfDXKXyXR51CfHmrfN56somemgLDI8qWuAlxZODcSxfatPLWrVQf8jsl7ec/9F4ToT/TngTYBcRr4vbCvHdYuyt6ig//dwFvsuT86VOE2wzzKy5JonV9HOF7ubzop4HDhaelvt2rzjGj1Ieqar8PfrLnxihg8RFOPSDojiceONiWm1OSl19xPl2kjmzqEh/AuHzHn+lc+0jpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66476007)(66556008)(64756008)(6486002)(6512007)(2906002)(38100700002)(8676002)(122000001)(38070700005)(5660300002)(186003)(8936002)(76116006)(6506007)(71200400001)(508600001)(54906003)(91956017)(6916009)(4326008)(1076003)(26005)(36756003)(2616005)(66946007)(316002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?N1duvCKisLdI6L+W3r6S87U7eCjmn+ctxJtVi2Vk7f8mHi/Jb86Ivovi6d?=
 =?iso-8859-1?Q?K55HYDuR9CW0zXYe0DThKjTD5Vc2m+Qrbm0kyas7DSl+I3vJNu7apaS+Dr?=
 =?iso-8859-1?Q?tFiw6VY2ssd/px70prrru8E7ozvXYXuosLnokKACQjWx79awDf0ww83G0U?=
 =?iso-8859-1?Q?4C6lPm5deAkPBRBSt10x/NVki3sQqaJHrCKO7WU01Ln4tY2rLb3DCVpopI?=
 =?iso-8859-1?Q?QdyStkWVjuweEPLrlTvvB+7qHj8ZtjOAxmk6so5gnIPQRcMIizuW9U/3s5?=
 =?iso-8859-1?Q?CIa8VxexJAWjZIVkN1Hmu+01FwoFprJaIdG1C1Ec0bKA0xnRo4kh/MKN2O?=
 =?iso-8859-1?Q?MEQsA2gzcqFTR2Xcm3NkscsvGMYtgEIMfJBMVALxlX3qwrxRVeRf2NiOfw?=
 =?iso-8859-1?Q?uSphbLd04Gix4UWHgaF5vwPDKm+gVdch6LjWgVVdyX1zY9cREeAtdPaPMA?=
 =?iso-8859-1?Q?wgvUKAaSaI8H4a77TEbI+ytozPJJApLRf75+aMEzhopP7aBaUEamSk95x7?=
 =?iso-8859-1?Q?2vkClM0/kOPTRQsqhKsWnaKQinSRaREZpqZ3SK2au1btRq0YAnSR9he2fn?=
 =?iso-8859-1?Q?Pl8JYbAmtXf7VuCSGDoq0dcmBWEZyLzAFzNpd0DqZF8GaRuaOmnvIEomW/?=
 =?iso-8859-1?Q?l2HlFZWRs72EIzmxzli0zCmlYqqJe/ieMxYv1m/gFM31aMBVWtdLJCKyX8?=
 =?iso-8859-1?Q?OlKPhPaC359jDt0pyzcLddjjqkclwqE3iGyTkgxqhWDTg619tBAaVqGWM6?=
 =?iso-8859-1?Q?szYW8Yljp3iFzqTeA+3Wnig4psLYij0XAAL2q5hI8BIwozG2tPd7SoRp0u?=
 =?iso-8859-1?Q?9T24CUPPlLe0Yp4kEdW3TB8YSaix4mv4MOO60PwcnFrwBEXHpmxwafn6MM?=
 =?iso-8859-1?Q?2kx0Xd3Knaly28DcoteXWuVxzjOB45uVy2FVMWwKDkdpTs07GFNK8RxR7M?=
 =?iso-8859-1?Q?ngu4dcsfe7QsXnat7yVjV8hl+SFLnzlJfUdS3hAUptYbT1S/6wzqVTdmpG?=
 =?iso-8859-1?Q?UA8jBNfRfuJiaDMm/U981Se1WfTijtsg4S7w5Buec/MXDi1d/uDYNMVFxG?=
 =?iso-8859-1?Q?YZ8hADoqqlgsJh4e1rtBAJlQmhVZHdYQhVS7hlcKQuhWWz1JQ7+16U0u4q?=
 =?iso-8859-1?Q?XR15du3vSHWEhjghO3divzoVPVvTrpQh9jg5/GAcl5hEiWJ/UXoscd9ERr?=
 =?iso-8859-1?Q?eFMY1z/WXR7hPrZPSAAz9eiTSaEnwsY7ultr35qcZSvuuhu+wiYyNFr0Jv?=
 =?iso-8859-1?Q?x+XA902DlGPlYQZA9GrRNGyz9vuqsLTdYeECSCFVIBcaoO7G4lg9THD7EK?=
 =?iso-8859-1?Q?aijnJCbPl7sV0h9dlMLqG0jfLgzRtMQ3oEYAMNf7JeDp+ivjRFk7V+AUcx?=
 =?iso-8859-1?Q?wbXoAxBDG6cObj7wfLdb6nYed4j2+bIpoSuUy78unzPx/0sBUv5sR9q3Ql?=
 =?iso-8859-1?Q?9p9c1oLY+puuMoq92/ZvcBn9pIrTUigbgWDFHaNYtlyfZx9Ecfo/MLUfhn?=
 =?iso-8859-1?Q?jHRSLHTm1UdNbFm9p66gwOMJz2IEenSDJpKU6f2mhqSFSiNfuJmolwCIf/?=
 =?iso-8859-1?Q?1egqa3Ajdy2F6UCube2Q338hfpSPdxdSUT/sbo6IZh3Y+CSxm+WTKPvb3o?=
 =?iso-8859-1?Q?DdigXCRDKJGv345P5oLdgNL9F490AvHf0ZlPhHH8wHuHmGf6GvJJ0Vc5Kx?=
 =?iso-8859-1?Q?PL8UV0lbnSe5H4Gs91Q=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e381e3f9-2f60-4428-65b9-08d9b0165ad5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:30.8284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lcw5DZeHEV8T19W4XihUSM4dkMgikWgdNp9Nvoa7r1L6xDx0Fq7agdtvskx46LhtCmWiiND1amGSURFJ8mEjfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7591
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 56440e63ac17 ("fio: report percentiles for slat, clat, lat")
together with commit 38ec5c514104 ("stat: make priority summary statistics
consistent with percentiles") changed so that per prio stats track either
completion latency (clat) or total latency (lat), depending on the option
lat_percentiles.

It is not obvious why add_clat_sample() shouldn't add a high/low clat prio
sample when option lat_percentiles is set, especially considering that
option lat_percentiles is usually used for controlling if total latency
percentiles should be displayed or not.

Add comments to describe why add_clat_sample() has to care about option
lat_percentiles.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/stat.c b/stat.c
index e0dc99b6..8bb49e4b 100644
--- a/stat.c
+++ b/stat.c
@@ -3089,6 +3089,15 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
=20
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
=20
+	/*
+	 * When lat_percentiles=3D1 (default 0), the reported high/low priority
+	 * percentiles and stats are used for describing total latency values,
+	 * even though the variable names themselves start with clat_.
+	 *
+	 * Because of the above definition, add a prio stat sample only when
+	 * lat_percentiles=3D0. add_lat_sample() will add the prio stat sample
+	 * when lat_percentiles=3D1.
+	 */
 	if (!ts->lat_percentiles) {
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
@@ -3101,6 +3110,11 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->clat_percentiles) {
+		/*
+		 * Because of the above definition, add a prio lat percentile
+		 * sample only when lat_percentiles=3D0. add_lat_sample() will add
+		 * the prio lat percentile sample when lat_percentiles=3D1.
+		 */
 		if (ts->lat_percentiles)
 			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
 		else
@@ -3194,6 +3208,16 @@ void add_lat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
 			       offset, ioprio);
=20
+	/*
+	 * When lat_percentiles=3D1 (default 0), the reported high/low priority
+	 * percentiles and stats are used for describing total latency values,
+	 * even though the variable names themselves start with clat_.
+	 *
+	 * Because of the above definition, add a prio stat and prio lat
+	 * percentile sample only when lat_percentiles=3D1. add_clat_sample() wil=
l
+	 * add the prio stat and prio lat percentile sample when
+	 * lat_percentiles=3D0.
+	 */
 	if (ts->lat_percentiles) {
 		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
 		if (high_prio)
--=20
2.33.1
