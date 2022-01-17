Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F979C433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 11:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiAQLJp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 06:09:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:49762 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiAQLJp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 06:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642417784; x=1673953784;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Al2czZf8AwW/oXXJuwK3ePT2eazLANdJBgYL+LdR/lo=;
  b=bQvfu60nRyLAZDoif1UZepkMqf907/SVpQcWHGzh15kKJ12F26niihvN
   Isuzps4xLSxocC+RmAEPelHfr7ofUNhWlkpmab4uiq/ZWJBOLlUmSmEw7
   qOjLoRMCA9akg7uUpH/gxSZwyA0FVpEOGIKVdHFqXZnhH/cUPXLA3VCel
   X98+f1Nsz/2H1xXNiqioAFKoh4cOsyEt9+jyg7ziHQqGO7f3q5eZWPY2u
   sHPyMCF8ZXv7hb3Ky3+eDpUNSAQuQBwCowY/FNEmUqkU2XHkDYcHVN3c3
   4rtb08oZqrpS/KUk5lqb/ioGZzIGzRS+fKYY3rvIoodrocmYThCdNNzs7
   g==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="195440374"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 19:09:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bojw0MYS9HFV8DUEzZvFXCodYl2N9lhLXO4oangR7HV9dJ0UE1Tvvvv1L5VWKITU+x6JnOlb0ZoNqwA+cBFhMYCVz27xxaF2lRez3Xx99UD6tfm/DFXZv4wfZk6f4pEyUX3sxoA0LZ0n+90fOt7Gp21wCnRLPHMvGryzKXyicfqP7Gk0SyflpSpOehkDN2UJEPaKxB3B5aXOjTrSzq8DeutqusrO+wIUmC8t0Ie6SNC2kjed/udQBViHIWJtg1z2nzgEKmIm4CDQ5Cvs8DaTjda/z8OKUqywLJVhsFhpTYhrdxpYuLX8oYR6PmPePtXvq6QkKiJZCgQjyMlQXM+EXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Tn8OfJBZjIRTJ8nxX0dh6Rr6mUtFy3nYTRynsGBt+M=;
 b=MYifct2BwUnMt1WiVr2cfpid/36l2+uRvZO2habFuVCIfvyeg4DIDHZGaWFF4nbTUn0DNC4SsKS64/nL894OLmqAloxUBvpiyQKR/ruk9dJB58jCaI3EWJIb/oZfbOH2V+C99Fbgh4FMW4M2h+bRHM3jhdxtpRxibZcMSVjM0ntvhXSihZIFAWnQAxwL72TdLjjVdgejQH2NmEvE41CYqc1TNCSbCY3VsKj0zRymCK9hebWQum0tbofgaPiixXvGw+w+8Vb/8aJmO+3WHwuXVpeaNh8ZKv5s+oVgp+BxPvtR4GKBVgXaHbPNAcZLyPmiXHif0o+MA4thOTrpPST1oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Tn8OfJBZjIRTJ8nxX0dh6Rr6mUtFy3nYTRynsGBt+M=;
 b=ymDB43XC3NYtwQbbR82i1UMnJrp/70MH8vopkggquQI0QUfIQGOrzaOzYN9LsLUq4C/8A+8DEsxWXOeAZuWStWlftx1NoGN/hWkCDkUbAVqbquQufX644BsA6QNNrfWUJynEyjHskxwNq1IAjGlUGbVrQlGwsHUFhUvSda13PS4=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 11:09:41 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 11:09:41 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
Thread-Topic: [PATCH v2 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
Thread-Index: AQHYC5K5gtqaoHgPB06E9VhYFZ9Ehw==
Date:   Mon, 17 Jan 2022 11:09:41 +0000
Message-ID: <20220117110932.300809-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4cc6f34-155f-4b4c-d1b1-08d9d9a9dc2d
x-ms-traffictypediagnostic: PH0PR04MB7383:EE_
x-microsoft-antispam-prvs: <PH0PR04MB73835D3AFF59E6DC83BDA454F2579@PH0PR04MB7383.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LAwWFT9NtL4SpkCDARW0qvGfuQM0Gcs7KsY5mcQH08BeXSaM2bjoZHP7ygNd+6fzWLE6nefTiX2VPMouFWm2NPS5CbR/fogrN8M7fCM0wk3KR4DqK2HA2FbQ5+jCGPXfWJi8J2nSrq+MtSpRjBw8/xjy1a9F0oz4P6//5e4tAcJMUdxje2GYdOxprt2t9XoddxoHShWZyefQtKeQYC8zZcQNM5EGfbSQ6h2ORk9SCJF1jmWFGXsNBiaKBqe2sx65LujIfUnkiCwuZaszHAEtuERU6dVnrwqVyqqCeifZ59Iu5/ZdMupUNglPwh2KFAPcr7Ae/n9aKm28hSYnPuzFP6WkWeuDOVAhnYbIghkazj0OM3DgC10NVh6S2iEfhwrdelt8/UlVkZsMgg34xAvtNcGPKUh80n+vimphxgqfk9rcx8EvmaLyDSGTSvxgp7I9vFFX4Xr7z3bcdlcupreSAtPCiZZvHXb/RzmfTW7v1VuMZsg3uHwnMpVJM21wu5X+exehSTYtZhhVns/Dnk93ahC/2vJgcYLsl5KPxkYp5rk4w1i0wmiZlOZn2p5Osy831qmQ064zyM5teU5M9PSSl8VJusy0Gh7tphaH0yPIXIowEaYso09JPGtferpqCnRhPS7gqhQMwJpA/VynGZlCGFpYlswTrb3oiQmrOkmYMLi+mW6Ht/jwVBGog7CmCYRgh5SfNqeFNDp38uOFy8W4Kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(186003)(91956017)(5660300002)(26005)(2906002)(38100700002)(6506007)(71200400001)(36756003)(76116006)(508600001)(122000001)(4326008)(66946007)(82960400001)(6916009)(1076003)(6486002)(316002)(66476007)(86362001)(66556008)(8676002)(54906003)(64756008)(8936002)(2616005)(66446008)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?mM5g6Hd0vMjFifOldOA7lY2RJwDRb7akUfGsxZDv5q6P1HRU41dxJqO9CB?=
 =?iso-8859-1?Q?eNhz5kVGKAjCrhQHj9MymQXEVMc7zXW/fgqJiJcKdPd/T0l61GaSfOeLkj?=
 =?iso-8859-1?Q?OCCvBBhk75ZnlLM6hajmD5Crx3B4k2Yl9cquEHF4ZEmSmh9v5C4eDq04GG?=
 =?iso-8859-1?Q?iKHLPk6Y057P6hNgGYtoHpQKxvysRtGxpC8OEpT2027UaEWQV4Zpr8J4Pn?=
 =?iso-8859-1?Q?u+JPNDK31g6ZmQXxoDP0IkVMuOCwh8qMuI/Gp/2zp+IuFjjisVPeeWo73P?=
 =?iso-8859-1?Q?o22zfAdd3p0Wulw12H6Q7UMGTD47W+cvF9cWOk+7u7D7TvQ7f2hOFrwLyX?=
 =?iso-8859-1?Q?0bPK1S5+X9SvWg1eUK3iJsJ19Kt4dwjGqoRiWrU5TO0pfiCrHjh6ULwfhz?=
 =?iso-8859-1?Q?HazwgpidTBtSBgzHeGqNIr3A2XZbbvIwfYZsm5Y5E7FVr9B0FM8sJSO8S3?=
 =?iso-8859-1?Q?uYXvRuMqC43k+L8PHM9MNn4kgVkoIkM0dpuYW0hg5YOWsKAiFEFvla9WDC?=
 =?iso-8859-1?Q?LdSJk4Guz/ytfdM+arOe0hQLr72VRJitX/kZH0GWRdNq144h8xCdBq7Ztz?=
 =?iso-8859-1?Q?Tb0S0+MPrca/3IEatWgGACmBDlZPmf1sfghObZsjxu5jWX5UavtCAfbHuB?=
 =?iso-8859-1?Q?+kq8thAUBGJROAb3rvJGYo+q1sXcPtmQCNqoMIrvLo48ecwxDQ/EGU38xm?=
 =?iso-8859-1?Q?q0IVnL9JhWlpcIE2I0S2bzVbz5Jd8kKmpDItq9zg3zPsWdp9z9dZ9vs7FH?=
 =?iso-8859-1?Q?cohps28Vvy0s/HU1Q9fg5xYSrVF++Lhzw6uxe1Fafg/6s/8jIyCKGnBFdv?=
 =?iso-8859-1?Q?cf3G7x4osfEtRws4/aWVXiv91L5L1z4R1NP/D+JwPJvjnlJ1cYqxPerZc/?=
 =?iso-8859-1?Q?X4Op2VAU0H3MibxaH4j0/pUTNuG5gvvq8ArZFrtYzgIEg9mNoqWhApGoJS?=
 =?iso-8859-1?Q?ygj2ElCfpNbuHPoQJR5/l2rNxNBnJVg88VhdK0vQpRm/wpz4maZFXEQoHg?=
 =?iso-8859-1?Q?QjZMO2YcQ6oxVvuojYl0krxdGx9k3awEKmuGECe1eR42cWD4a4ZeEVrIbY?=
 =?iso-8859-1?Q?S5+V09Ob1m0jtn6GOFR2dDMkhuMnoS1rKOK3nXVv+gcHPBS86i9LGwM1r6?=
 =?iso-8859-1?Q?CGdfV3gjWFDw61Zq8iJcYpgIyQ/WSKl/7LbZ6NJw6FGhzfgsVKCn9tVLS9?=
 =?iso-8859-1?Q?Hqe5ocY++JyyhozPn0rzafwmU82MpsujMN7VYLNETfq8y1X//036v8iiZQ?=
 =?iso-8859-1?Q?cMVuxfZfhMOGe4dNS4YjX8NhUi8Q1rKEvKHbShsh8T0XdbUsXhRrRK7Nb1?=
 =?iso-8859-1?Q?OO9IsdmjRzLCBFv1vd6oGkRtljuPephpyXT51B/oSmK5f+/AjdpDh0YL5J?=
 =?iso-8859-1?Q?pzKpAI3cPmpdy3qN5gGMLYgF1LoirmF7CQbC/bGTaur8Od7mqJZwQGmRUm?=
 =?iso-8859-1?Q?rfMmbConkTqfOS+zRMO1rDf9JC65LM6C73ibrmIXMcCBIcgcdIG/l0yJ2/?=
 =?iso-8859-1?Q?sY9Vz0YZ6A1mTuyMWwrPXgKdjICW+OFLJIwNXxIvkuR4qCgXQMvFuG4Fzn?=
 =?iso-8859-1?Q?0k3xyZVDLJQxwCbklIoOYd7ErBtd5Fq4BL0la/IGCRGkfmncNIyCpn3hsu?=
 =?iso-8859-1?Q?NTctBOdDUtwzTbpwm+DRK98BB2VDOIuKyqAWWTQgEcWoyjXa6/+XFg3xCO?=
 =?iso-8859-1?Q?VUwbbLggReVvbsZlq+g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cc6f34-155f-4b4c-d1b1-08d9d9a9dc2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 11:09:41.4764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXyBHT22t6gDbwA2WlVj4ko22OMC1qPq4PrjlR+ySCjIsLrLYVZJwKMbF+Ln2Pnx8ufCxPpPk7EcRtxoEv7z0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

When using unified_rw_reporting=3Dmixed, show_ddir_status() is called,
and is solely responsible for printing the mixed stats.

When using unified_rw_reporting=3Dboth, show_ddir_status() is called
and prints the regular output, after that, show_mixed_ddir_status()
is called to print the mixed stats.

The way that show_mixed_ddir_status_terse() and
add_mixed_ddir_status_json() is implemented, is to alloc a new local ts
that will hold the mixed result, and then simply call the regular non-mixed
print function show_ddir_status_terse()/add_ddir_status_json() with this
local ts.

show_mixed_ddir_status() also allocates a new local ts, but fails to
initialize the lat percentiles and the percentile_list in the new local ts.
Therefore, show_mixed_ddir_status() has duplicated all the code from
show_ddir_status(), except that it uses the lat percentiles and the
percentile_list from the original ts.

Simplify show_mixed_ddir_status(), to behave in the same way as
show_mixed_ddir_status_terse() and add_mixed_ddir_status_json().

In other words, initialize the lat percentiles and the percentile_list in
the new local ts, and replace all the duplicated code with a simple call to
the regular non-mixed print function (show_ddir_status()).

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 187 +++++++++------------------------------------------------
 1 file changed, 28 insertions(+), 159 deletions(-)

diff --git a/stat.c b/stat.c
index 36742a25..2b3687bb 100644
--- a/stat.c
+++ b/stat.c
@@ -474,163 +474,6 @@ static double convert_agg_kbytes_percent(struct group=
_run_stats *rs, int ddir, i
 	return p_of_agg;
 }
=20
-static void show_mixed_ddir_status(struct group_run_stats *rs,
-				   struct thread_stat *ts,
-				   struct buf_output *out)
-{
-	unsigned long runt;
-	unsigned long long min, max, bw, iops;
-	double mean, dev;
-	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st =3D NULL;
-	struct thread_stat *ts_lcl;
-	int i2p;
-	int ddir =3D 0;
-
-	/*
-	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
-	 * Trims (ddir =3D 2) */
-	ts_lcl =3D malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-
-	sum_thread_stats(ts_lcl, ts);
-
-	assert(ddir_rw(ddir));
-
-	if (!ts_lcl->runtime[ddir]) {
-		free(ts_lcl);
-		return;
-	}
-
-	i2p =3D is_power_of_2(rs->kb_base);
-	runt =3D ts_lcl->runtime[ddir];
-
-	bw =3D (1000 * ts_lcl->io_bytes[ddir]) / runt;
-	io_p =3D num2str(ts_lcl->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
-	bw_p =3D num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
-	bw_p_alt =3D num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
-
-	iops =3D (1000 * ts_lcl->total_io_u[ddir]) / runt;
-	iops_p =3D num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
-
-	log_buf(out, "  mixed: IOPS=3D%s, BW=3D%s (%s)(%s/%llumsec)%s\n",
-			iops_p, bw_p, bw_p_alt, io_p,
-			(unsigned long long) ts_lcl->runtime[ddir],
-			post_st ? : "");
-
-	free(post_st);
-	free(io_p);
-	free(bw_p);
-	free(bw_p_alt);
-	free(iops_p);
-
-	if (calc_lat(&ts_lcl->slat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("slat", min, max, mean, dev, out);
-	if (calc_lat(&ts_lcl->clat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("clat", min, max, mean, dev, out);
-	if (calc_lat(&ts_lcl->lat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat(" lat", min, max, mean, dev, out);
-	if (calc_lat(&ts_lcl->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)=
) {
-		display_lat(ts_lcl->lat_percentiles ? "high prio_lat" : "high prio_clat"=
,
-				min, max, mean, dev, out);
-		if (calc_lat(&ts_lcl->clat_low_prio_stat[ddir], &min, &max, &mean, &dev)=
)
-			display_lat(ts_lcl->lat_percentiles ? "low prio_lat" : "low prio_clat",
-					min, max, mean, dev, out);
-	}
-
-	if (ts->slat_percentiles && ts_lcl->slat_stat[ddir].samples > 0)
-		show_clat_percentiles(ts_lcl->io_u_plat[FIO_SLAT][ddir],
-				ts_lcl->slat_stat[ddir].samples,
-				ts->percentile_list,
-				ts->percentile_precision, "slat", out);
-	if (ts->clat_percentiles && ts_lcl->clat_stat[ddir].samples > 0)
-		show_clat_percentiles(ts_lcl->io_u_plat[FIO_CLAT][ddir],
-				ts_lcl->clat_stat[ddir].samples,
-				ts->percentile_list,
-				ts->percentile_precision, "clat", out);
-	if (ts->lat_percentiles && ts_lcl->lat_stat[ddir].samples > 0)
-		show_clat_percentiles(ts_lcl->io_u_plat[FIO_LAT][ddir],
-				ts_lcl->lat_stat[ddir].samples,
-				ts->percentile_list,
-				ts->percentile_precision, "lat", out);
-
-	if (ts->clat_percentiles || ts->lat_percentiles) {
-		const char *name =3D ts->lat_percentiles ? "lat" : "clat";
-		char prio_name[32];
-		uint64_t samples;
-
-		if (ts->lat_percentiles)
-			samples =3D ts_lcl->lat_stat[ddir].samples;
-		else
-			samples =3D ts_lcl->clat_stat[ddir].samples;
-
-		/* Only print if high and low priority stats were collected */
-		if (ts_lcl->clat_high_prio_stat[ddir].samples > 0 &&
-				ts_lcl->clat_low_prio_stat[ddir].samples > 0) {
-			sprintf(prio_name, "high prio (%.2f%%) %s",
-					100. * (double) ts_lcl->clat_high_prio_stat[ddir].samples / (double) =
samples,
-					name);
-			show_clat_percentiles(ts_lcl->io_u_plat_high_prio[ddir],
-					ts_lcl->clat_high_prio_stat[ddir].samples,
-					ts->percentile_list,
-					ts->percentile_precision, prio_name, out);
-
-			sprintf(prio_name, "low prio (%.2f%%) %s",
-					100. * (double) ts_lcl->clat_low_prio_stat[ddir].samples / (double) s=
amples,
-					name);
-			show_clat_percentiles(ts_lcl->io_u_plat_low_prio[ddir],
-					ts_lcl->clat_low_prio_stat[ddir].samples,
-					ts->percentile_list,
-					ts->percentile_precision, prio_name, out);
-		}
-	}
-
-	if (calc_lat(&ts_lcl->bw_stat[ddir], &min, &max, &mean, &dev)) {
-		double p_of_agg =3D 100.0, fkb_base =3D (double)rs->kb_base;
-		const char *bw_str;
-
-		if ((rs->unit_base =3D=3D 1) && i2p)
-			bw_str =3D "Kibit";
-		else if (rs->unit_base =3D=3D 1)
-			bw_str =3D "kbit";
-		else if (i2p)
-			bw_str =3D "KiB";
-		else
-			bw_str =3D "kB";
-
-		p_of_agg =3D convert_agg_kbytes_percent(rs, ddir, mean);
-
-		if (rs->unit_base =3D=3D 1) {
-			min *=3D 8.0;
-			max *=3D 8.0;
-			mean *=3D 8.0;
-			dev *=3D 8.0;
-		}
-
-		if (mean > fkb_base * fkb_base) {
-			min /=3D fkb_base;
-			max /=3D fkb_base;
-			mean /=3D fkb_base;
-			dev /=3D fkb_base;
-			bw_str =3D (rs->unit_base =3D=3D 1 ? "Mibit" : "MiB");
-		}
-
-		log_buf(out, "   bw (%5s/s): min=3D%5llu, max=3D%5llu, per=3D%3.2f%%, "
-			"avg=3D%5.02f, stdev=3D%5.02f, samples=3D%" PRIu64 "\n",
-			bw_str, min, max, p_of_agg, mean, dev,
-			(&ts_lcl->bw_stat[ddir])->samples);
-	}
-	if (calc_lat(&ts_lcl->iops_stat[ddir], &min, &max, &mean, &dev)) {
-		log_buf(out, "   iops        : min=3D%5llu, max=3D%5llu, "
-			"avg=3D%5.02f, stdev=3D%5.02f, samples=3D%" PRIu64 "\n",
-			min, max, mean, dev, (&ts_lcl->iops_stat[ddir])->samples);
-	}
-
-	free(ts_lcl);
-}
-
 static void show_ddir_status(struct group_run_stats *rs, struct thread_sta=
t *ts,
 			     int ddir, struct buf_output *out)
 {
@@ -797,6 +640,33 @@ static void show_ddir_status(struct group_run_stats *r=
s, struct thread_stat *ts,
 	}
 }
=20
+static void show_mixed_ddir_status(struct group_run_stats *rs,
+				   struct thread_stat *ts,
+				   struct buf_output *out)
+{
+	struct thread_stat *ts_lcl;
+
+	/*
+	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
+	 * Trims (ddir =3D 2)
+	 */
+	ts_lcl =3D malloc(sizeof(struct thread_stat));
+	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
+	/* calculate mixed stats  */
+	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
+	init_thread_stat_min_vals(ts_lcl);
+	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
+	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
+	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
+	ts_lcl->percentile_precision =3D ts->percentile_precision;
+	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
+
+	sum_thread_stats(ts_lcl, ts);
+
+	show_ddir_status(rs, ts_lcl, DDIR_READ, out);
+	free(ts_lcl);
+}
+
 static bool show_lat(double *io_u_lat, int nr, const char **ranges,
 		     const char *msg, struct buf_output *out)
 {
@@ -1478,10 +1348,9 @@ static void show_mixed_ddir_status_terse(struct thre=
ad_stat *ts,
 	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
 	ts_lcl->percentile_precision =3D ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
-=09
+
 	sum_thread_stats(ts_lcl, ts);
=20
-	/* add the aggregated stats to json parent */
 	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
 	free(ts_lcl);
 }
--=20
2.34.1
