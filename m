Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D35FC433FE
	for <fio@archiver.kernel.org>; Fri, 14 Jan 2022 15:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiANPql (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Jan 2022 10:46:41 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55944 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbiANPql (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jan 2022 10:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642175200; x=1673711200;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Al2czZf8AwW/oXXJuwK3ePT2eazLANdJBgYL+LdR/lo=;
  b=jiUt5rGmIjDqYnMRw8FewTekktiskVZ+/7faVIWA4cAbQEg9XjNiPdfP
   zlfBSkpmltD6xR4ReG6Z8RxuSHVGEjTu0WxDqNGHLpWPc89+ttiv2g5EN
   fvJ3nuxqICSTQ1nBTP0AG+HHY97oIRcFN47f4NcVGtIKzNphRb5fkLqBq
   4+tHmlhgMAoiJ9qL6WISgB+fZpyG8celEVBSL3JANRvOPh4wnaZNIDUNY
   Dxlqyf6sNOy+2sNwegYLV12QCn2m7niOxmhu/wrxMU9bBMqRmp9S1yGg4
   kjV5VOYW10//+hyGG799c1NmvZvJNoLXOCBvH1vbP2JnjHUm84eJILhv+
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,289,1635177600"; 
   d="scan'208";a="302342651"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2022 23:46:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gd0GfVzF3l6gfD3qtqAJFNHn39d255hW//d6FySJwjVACGo0PChP1+c7B6Wh40obkaBLBTfVqiY8uNlyzOwVfviRHtU80F3YIaaBXqf5IF5/mfsYB2IG7yG6wHo3+7ZNmzo/Xkx6R/9gpMkUdmV65Pa+T1W7hIQS2PwJDcPK3tJq8BDqX7Vyfc3y5fDMTZmSXlWYKC6SpVqRiKxpFBig7oJsq5KJlhzQFdC4pQhvTPytS60jQKPzGgIb4ZDupRIiDOqWFu3yeGhXh6VF83KIRvLixKnCXEEDQdRBdSKssvegRboosHwqZ+W4VIBJdGTI6MVT5HHpk7OrrFisjc8CmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Tn8OfJBZjIRTJ8nxX0dh6Rr6mUtFy3nYTRynsGBt+M=;
 b=Jml44bzYLx2OvS22IHrmH13oV5Py6oCdej/mzwpLfgh4oQ/xa3ciMH8VW45GaUDDD7fEVY3LLIeg1XE/vib56RCawRKp3THQBkecQKFH8DXeMroy6rmkqaBbXzHebveQ1mARRd3cj/kB/hDCZpIcgVxtWgxdM7wzJ64iBq9Vk42Mwp0Uwj4G/31R1XvLur7H3NaWt+xQ4qx7Txs/SXHnyLhLgVyUbhGJ2El+ck0QZr9rl6fnqDsvgXdEEFOidl6On4oXxQtYjkp1VNmDG40obLzhQko6hLUZXb9JSSxiIh/Z01EjhKdLa3Zc2eEqa53UHIRQdzBEP2h1gyOdfI05Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Tn8OfJBZjIRTJ8nxX0dh6Rr6mUtFy3nYTRynsGBt+M=;
 b=Mq5znAChMXJVqVX5rFzZ7MsJiE3t+RrQYGvigU/RzKhk6i81QQNyVnVY1ooUn5VhQOETfofdxrB+ZEOxxT/rZKh3UEn0Tyf/X8/TNtpdGfMoeh9VWmzWRRG0QlLJDXrK+GCEJnszAps9wQTtqIB1oneacvFZ7eAUclztFLtT1lg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7413.namprd04.prod.outlook.com (2603:10b6:510:13::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 15:46:38 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 15:46:37 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 1/2] stat: remove duplicated code in show_mixed_ddir_status()
Thread-Topic: [PATCH 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
Thread-Index: AQHYCV3qULbg47GPj0aqavaTIlrKoA==
Date:   Fri, 14 Jan 2022 15:46:37 +0000
Message-ID: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c352a1dc-d2d2-4ae4-c97e-08d9d7750d02
x-ms-traffictypediagnostic: PH0PR04MB7413:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7413E9F1ED5EB2E0EEFF22DDF2549@PH0PR04MB7413.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WP9j+MxuUdHG8Aef8C0HKtcBSzko3fYvMe03UVfBu59ekKKh5A8pvN1s/+Q369wO1BbFYNARDCvTyga/FXAgvyCTWYSIfM78Us7RjNj+a6tTZL+huNbROiIQSs/lDxSLk079T+JP6Ji02yzH9Pj55rrU4e0HkHwz0mupnD+y8XGMtDYLisrUISmswMkq1EfQwrgtEcewSvdwXoZnRE9zuh0MQDUQ//AoFpCtK4J6bqQX8U1QKvWQycT1fSx4arg6UtcX7RhOzQsHdzLCIZIQmcgVzAvpWn/dx5jVJoAj+DJ/WedUmpKsbVUXvP57UiotNPOh7vn3WeLT5Pfj68xEhEBCJYN+Fn3nVfHblVRR+ojb4gkbxVKmE0Dom8UUSH+tF9jwWOhdZalrx8hrGsOc+mAF81fTaWh/u4Ze0A/1cvuGpvlRgIYfPKP9gNJYI8JLe0CRr1JQJW9rTLYva9Raa2qkmWJFVUit/aGQmnecZjPgtQH/HhlIx+9WIF25m6Vxaf+61Qyn7ctACOMgTWaiFYdG+sKg4CjEDkD9a/MplZrgFlqIJlGhf9zr9yGT5LUYwYrVQkrEeHndRpdobpXBVUzsagQ0HA1UMkmstuz0+mgAN2sC89CfuYyCQK7q/2yO+Buof7py/f6Ar4aX306sJHyrWcDDRTwGQiBQ/QSL++YE/jB/PpKUDvphtySXPWVO07gb37Ob0h+3k7ReS4NPNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(4326008)(38070700005)(71200400001)(8936002)(36756003)(2616005)(2906002)(6916009)(86362001)(316002)(1076003)(83380400001)(508600001)(6512007)(8676002)(66446008)(64756008)(66556008)(66476007)(38100700002)(66946007)(186003)(76116006)(91956017)(54906003)(6486002)(6506007)(5660300002)(122000001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sHLLaMxdR+KVgomp3kSgAkknDWO7IwjnAtHDr8l4s7NwtQxyKOjMqqnIh6?=
 =?iso-8859-1?Q?3gyWg+4tbV+xNbpXQO6kkbvJYSRLCTh6MSU+6iI2YpninV65n36fvIIu5H?=
 =?iso-8859-1?Q?ntCARRHfKAv1obe/wIVCvYklvmVXESXCM6ZhJSa5BidlWgFDvINHZFTUqk?=
 =?iso-8859-1?Q?zfCSCQLLDGSQ96BUbFjwTnVWIkbZYFmv+cB5XGfAZB//BYohsZB6K4dQlJ?=
 =?iso-8859-1?Q?PPOWZxMRlc/ZklQ/K7098OWxV8Q4+enahHZc8qHIwVmnZP+U0dBH7Q04nh?=
 =?iso-8859-1?Q?KV5aacrnXsyck/8VCMW6+hOS54cHsSsFCY+6D/uoPLWs1ATKKQl5m6ytcf?=
 =?iso-8859-1?Q?PS2WG+JwN7sy7V/EcRnfrlQaMTW1Xjtg/RyXgCEc2/dmrStPJPF8zWorbK?=
 =?iso-8859-1?Q?5lAtNgCwGseLeNvaQIk3V1s9mGympS3NYNpjIQUY1EGTjzgFY/P3xtDC4+?=
 =?iso-8859-1?Q?oPb/Pqm6c81Mym7OgYg+REiu73NbQyahQ8QHykPnU3WwJm85cu0G2pqbiT?=
 =?iso-8859-1?Q?xM2/75OXhGitKnrqbQN+2/6KzAboX5THirQDrkwFp+/tlgnfdI3jaBCODC?=
 =?iso-8859-1?Q?F4Go1F4s7kKGeIbc1KyfstnXYKT6Dn0+HKluF6q5G5RQk3tH6C1bXz8Vae?=
 =?iso-8859-1?Q?pMQQprh/04PrKcUhTLBxouulStTX7gcpGlN1yTfevFjI3awRE8d/M2Z/yJ?=
 =?iso-8859-1?Q?JQ2XLbR9ZMb6RS3+irIX1VpaXPD1D2SaD3qpgQ9SlGIWLGFanKPrsNz8Kt?=
 =?iso-8859-1?Q?MJ+5KT4/g1iwxe55uOsrMHnZWF2kvBumyAJDdo9FAAjrbTPOLPZjLAA8b7?=
 =?iso-8859-1?Q?H3mR4umzuzkm8xBF+VzFKhrfMr9tY3UONqiU7zFUMD3fO1ZL3GI2U/IBSh?=
 =?iso-8859-1?Q?dZMnF/TvaOuc2jqZRIlC/dcHoJOiMsN1UVVxQ9HkadUnTTbVVnxn1GesVi?=
 =?iso-8859-1?Q?6un5Iw8W49vrky33nsNopaDvdi4ByjBJkyunIZ6FHjuM8Vzr8V0L9yCbpn?=
 =?iso-8859-1?Q?IXFp0UAE+/qWrPjTNZ0l5rVqtI4f3tGhI65TSPS+9Dg0gRpwOO9vD0eX3W?=
 =?iso-8859-1?Q?FOdd2EyLGic9wpOo3sL7zXTRzAxN0hR59R4HwCM28tgQHu4crqUT2v96ep?=
 =?iso-8859-1?Q?XOB2eYSTWlSzjFOkfjWyO7vjJqe5Mvt54/oA5zB0/RPfiFOtWYlmeQIfeC?=
 =?iso-8859-1?Q?nQHkswPedkiqhzF+MiGsuwHaFpJwMOvbiksnpAa3+f0s8rpVsccvr3qVQS?=
 =?iso-8859-1?Q?fQPo2pwp6f6Bede6K0yKQwUQjETfi+ywnF2gXFNpl6WuBUKFGIIQlQiGws?=
 =?iso-8859-1?Q?u1fdfgd6uAfJkl3X50hdFBInFqyRdrxOR37MhiFtFut8J0CVJ9yK7ajVDB?=
 =?iso-8859-1?Q?AcPUfRu6Lc3AhhJ2L2M7JjhZhjc0Jy6C/BpBGgqMPapfZ9fx2EmZXkeItL?=
 =?iso-8859-1?Q?bf5TqGh+qik0pPfaAaJgR9p+LIvBuwIIQcfDrzAOYcSAuBWt38XFUHUrwT?=
 =?iso-8859-1?Q?PSnQG3hSFPNWOBP9b3wVzo9lt0NFfTivviSzYZy+Yq+sIh5FMuERaR8FLB?=
 =?iso-8859-1?Q?dNLJyK1kYKNPIrWbHf1WkKKc106Bhw6K/YPumvfQzls6JWL9UlkaeWp3jS?=
 =?iso-8859-1?Q?RABbi+5dOeNEuWzbqLnoSXUD6uAo0IfLMhpFb0Z8/7kmWIoCcoPTNHXRvJ?=
 =?iso-8859-1?Q?nglI7+PHYt7xXX0adp4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c352a1dc-d2d2-4ae4-c97e-08d9d7750d02
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 15:46:37.7661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sqiRIjonuJLMwuiEK0IJ6G9FtS9ySRwqCUdMUagu8fm2FY04zIaCh5ZBQjS94139a2xXtdB2HOvRtHVYz44p2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7413
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
