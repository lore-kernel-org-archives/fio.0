Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78733C433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 11:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiAQLJp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 06:09:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:49762 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiAQLJo (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 06:09:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642417783; x=1673953783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vXJIG8L1H76BZOT2pNUIx2cscQ3OCksD9iTsD5UOPR8=;
  b=MuUTsElV4RSQTeKULCiuJMLmlogoy3sYEastABdN6Krul4CV8LMo64A7
   0fedCdmGZWbtqIrhADpW+uOhs2UJEFbFIyPKmT8UQiiOl8jcm/9MdqIvi
   vgqNbU2gHaz0ghvwpNjmlqJB9om1bXALRNmtC/J26LMpYGqMcBKdH/BEX
   iuWmebuRHpGGV9qjdv270EFFzhqw87OeV3JrQP0iKGIlt9OsCeAlrLWey
   uUl1OZalfsHgiaryKpTs8dtCl9BVi7wSmnqPh77U7BA+CXOBi0pc278c9
   jmyO25c+UI+P2l65W/VWKaiUupS8Qxhjd4ng5OYgCysOykLJirZvk4N1z
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="195440373"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 19:09:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INVB70qEe2GlybLiWWmspvUXBdYpM3QqnSKTKZIK9q5qdMKb0PI9cEGSwd238ca7d9rap0KimT0W8x5zMyLVJwAPjLlOhr7CdcSMKp9d0iiRxK5hZKh2CahC6gczy4+LiI+9eCYMT7yLigBh+7qmSnbjmD+rogFGH+MIEjMGUPDl6i/pb1npvf/HWAgHzfWuq7p/sHPzJaAKAuWGy4BwuWCuEWCamHuC5urmpVJFvoSRzOFSpBjABfPl2SmTmLzDa37xwBmHwxMtRN/FHDf9T7LkOvVsHrX/V0OXFmY44UmPWaSc1b/Q7aGFLrXzMz/CgQXjdeupPTqHhj0ezwldqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KsVkLemB5TWNhwh5Nf0hh5bMKr8Y6YctnuCcWx1Mdg=;
 b=L73i+eu4hXYbmerhwwGEnMowyX5zc+7QjY4az3TUWfyKR6QOhkQ6lyQ3BTQFcl/rhhYVNSx8WG3Pr3tVb/Ikvf2HHk5vKCoXiu5UK/AbQcBc7VLYDXsC0OuATND8U5BETURfBDNs4/6VEEF1ngLmQXO058TBdhvI9kEc0FRTA7u7YcZhXrB2o++w9caHtWeX9vIZ3JCZJBnl3ak7JZiuaAWwJ0jJkejMUQ6CljAmIWyoac80CKqqdH73728KBQID/4n79GHQ1iWuZMGWvpBalc3Va4gCXRC8zU67dKvhY0eYv8DWzXbYFI7iu7ldGpuyr6ciK2ZDoWP2FVohTheA3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KsVkLemB5TWNhwh5Nf0hh5bMKr8Y6YctnuCcWx1Mdg=;
 b=dIuZrtBozApHWn0pBYm4uxVxowvhw1xa0YNXf3vIlZOAXTYezFJKdn8NM1rpA0Vz7yz62PmX0IFDPFTQEDjDCU+hirHci/B+vOY+NygS+yE3gZriHIE+4NnaUpPFHPDHx2M8RZ/+7ZsEhHtGaqTLqlVgHQpIeqbDwJbww479CGM=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 11:09:42 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 11:09:42 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Topic: [PATCH v2 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Index: AQHYC5K6Hed6MXnej02cbO9IuzZXuw==
Date:   Mon, 17 Jan 2022 11:09:42 +0000
Message-ID: <20220117110932.300809-2-Niklas.Cassel@wdc.com>
References: <20220117110932.300809-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220117110932.300809-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e01d4e6-8944-4285-51b0-08d9d9a9dc94
x-ms-traffictypediagnostic: PH0PR04MB7383:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7383729E638EBF19027F2186F2579@PH0PR04MB7383.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2wZw1eDJzSBlUIFmZvy6Qo6CuJks809mjFt7oG4mKG/+OMFIEfYjovCdH7/W9qvz2q9qWmzt0vGnp/nhU4cr/RsGVZtBiBKUFPijA9CgxvAmbERJE3goJni8lOBa/UMcPWcgzcAWY7ZJkW//TS3bHE0tzorZbrcRASi/EdO+P6ZAdT3Te5eOpToPlr8XHDTDoLc+HjUj4/1PYl+YWGix30eFkYrsmNRee8JdswW6t/tjZvfHiWIm4ddD5K+9XNIW6cV9VdR3XGPcUnchrMnvc/J4P6PVYgIwmAawLn0zUTxQS8FFLpGr78VdGn8ur3Hh46K1IbL7ArcJc7WnwFxpW++C1mLwEx0Y9zvJAQ65x43lt/EjYb4l7KODlr06a/u9m15hkE2aRbTDmoaSaT4EhnktwaH4Pe8Wx638G0q6bvLAFggeW0YypE8Q7KRfGnR0clEaSXNFnUuVuAFXYinRJzUS7SqGzY700dAGWiMOD7r/3wEP9KIEef90dZMx3/QU4D7FHH8sGGV54voWGyLiCHyGbU6yLNuDpnZM9HxWniG9gHOV3cMVdsGM6A4nayzoEFjPW80EpJbWF0o8wn0WcnQfj95ReUghS/LI8jRl5msiia0wIxCz1xfckNMfWM8m80ujT8gSlBtPY7cRVJrMz8Uqj+SHhoHM1V8EPWjAMBaCe72+vDPdIbfCl/UJN/Q9w8upqN0tTslWLm4ZdEl/hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(186003)(91956017)(5660300002)(26005)(2906002)(38100700002)(6506007)(71200400001)(36756003)(76116006)(508600001)(122000001)(4326008)(66946007)(82960400001)(6916009)(1076003)(6486002)(316002)(66476007)(86362001)(66556008)(8676002)(54906003)(64756008)(8936002)(2616005)(66446008)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ESQwUgrqFwozKHATwaJBiKTqSyvLcGdpl+QOYw69/WAPApEVWonoLS5yH3?=
 =?iso-8859-1?Q?BuGST9Xil+Q1zbB2D9F0te9dWgNEgHE86YoO5bPMeiQ8Q64gPUP+SA15qd?=
 =?iso-8859-1?Q?GhctxT5eSAuY4Mo95b6uZDqcvR0O3ondNa1vfdFEzd9EjDGSlybbZRGSF5?=
 =?iso-8859-1?Q?uGEurEKSiPesxXMe9F0KXJ+whj4RP5J0yBgALdfOPlvo0hpM08IthHxmP9?=
 =?iso-8859-1?Q?yO1yM/OItnmX0SYJSHAwyuOevtVeW6hPU06fxwLq8iEwyKYTUsS1Hru4XO?=
 =?iso-8859-1?Q?rATay69yuwSGuX4Y0IYUhA5l6u7KKp758ki0tfWp82fUTL6DxRhx+k3LFT?=
 =?iso-8859-1?Q?fGoipD35WnNeJJVPFJLlTPHP0XH+G4MwCwrjxmkrYKDtsbCjG0ofot2nGk?=
 =?iso-8859-1?Q?0FWi3HZU47A+dRMcjt7TuMavKMrqEjATrtJIwa/yH8Klylfr9HooGLyf9h?=
 =?iso-8859-1?Q?NZ4hX/9sL+iZ0RFF7XpAseUT2ggGF0Sh7IPMTifWkHW1QIZrl80FyyhYLX?=
 =?iso-8859-1?Q?JS51T7nQwkgOteW17mrLVZEI5A7RP+FK0HaRnrotxIgxzxVf7kqZaJ0MmM?=
 =?iso-8859-1?Q?iNN+B0nkG29GkB4z54SEqzAqMSIS6pWriE2NwjU5CDbso29cb/6w27AgsM?=
 =?iso-8859-1?Q?zfoH6OpGQ49c1kkpc26ZKPc3mi2jZ06UGJWUEz8LgumkpCuX/bv80imCoq?=
 =?iso-8859-1?Q?u6jshh+YWo9CVzLEqCLy3OkDSzqxG7Axar7W1naVvZPQSkasIsUx/b9Jg/?=
 =?iso-8859-1?Q?9SdjICys0TMpPoSAjjvU4I9XEFzLxLXlUqx/89jQqDNeX8YiXGRvXtTGOX?=
 =?iso-8859-1?Q?uT8D/1QVMRfCCQtmn9SvFQBM+O8Rxy+wR5pe4Dyc0mgytpaRR1k7hJSPxW?=
 =?iso-8859-1?Q?iETABth6/gmj7jtttATuZGa0Q8Pj8P1upNhiPwW4LwYPHWEktFhEgHDvaW?=
 =?iso-8859-1?Q?qH3G7/65v3CRDcx9gQwWGQLsVEVGqBA7jsJafZ5cuAJlxQwdyPutGPeVkw?=
 =?iso-8859-1?Q?ewpPfstUFxnrLK7KVld/yWYHD7EbgXDIRQiS2xR3XLjEHiNlz43KAhZn1C?=
 =?iso-8859-1?Q?IjwwjpETHZWkOU6k4SZYwnXZZee/4KRISJUCN9V/2pO6Q3uSFp91Aozjs5?=
 =?iso-8859-1?Q?pg2wYmNiT8mFHHB05fXBzK+QwnFBys7+8D+W4X2zlwK7p+MlSFrBCvIIo/?=
 =?iso-8859-1?Q?yJiZBjGBNCqyD8x1nzJqFUXranNUyqgbwTrmwPq4lkmsQQ/tXDfVC2eT7r?=
 =?iso-8859-1?Q?l37YXYa4YKl7LzWzS/+euSrmK1HavYHlBNo11wLbgbNJM9HMd7y+fjyiQk?=
 =?iso-8859-1?Q?yV6r0s6fbEG+8u9LBUB0FJ30XgjbVK9ioVNoLDhtFPbJb3ziDfs8DSaebZ?=
 =?iso-8859-1?Q?FZZOjO5vzINn3vJTqavsGWM0oZ9H+Etdya25wG9AjSTaNMvo3NOURW08kp?=
 =?iso-8859-1?Q?EmWMYWfQcWHn0UYDpXGMRmegmbLRpLch9yqYyz/YJAZND+1faqB1hpVROd?=
 =?iso-8859-1?Q?Hb2iE8zXqom0IJfrHEFjSLwhFZdRRzZxqVrBHEDQLVGiOkGDsEsG4jD2ad?=
 =?iso-8859-1?Q?SWhQakTrZ8Zc+cfHb5in3WStngHz6Dw8zGLJCm5hCIKn2CaQzbhT9eRCUi?=
 =?iso-8859-1?Q?tOZTkrxl8dbTS3S+9Lo5x4iCr0nDzQWS1/S8J6DIol/QeuHsNwccDKZ2Xv?=
 =?iso-8859-1?Q?En8Ah4zvJzEHXCRDkus=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e01d4e6-8944-4285-51b0-08d9d9a9dc94
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 11:09:42.1950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nBe0ZLxXTPrqGlELj1aIy3R1OHJ1F160vl375uS00IA53unrFygsaguk7yVqHsTNFNV/c476bSPKIJH5dJS1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

When using unified_rw_reporting=3Dboth, we need to print both the
per ddir stats, as well as the mixed stats.

In order to print both, the regular printing functions are responsible
for printing the per ddir stats from the unmodified struct thread_stat,
and show_mixed_ddir_status(), show_mixed_ddir_status_terse()
or add_mixed_ddir_status_json() is responsible for calculating and
printing the mixed stats.

In order to keep the original struct thread_stat intact, these three
functions have to allocate a new local thread_stat, where the mixed ddir
result can be stored before printing.

Move the allocation and calculation of this new struct thread_stat to a
new helper function, so that the code is easier to follow.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Changes since V1:
-Use init_thread_stat() rather than duplicating the memset and
 the call to init_thread_stat_min_vals().

 stat.c | 81 ++++++++++++++++++++--------------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/stat.c b/stat.c
index 2b3687bb..36672d0b 100644
--- a/stat.c
+++ b/stat.c
@@ -462,6 +462,30 @@ static void display_lat(const char *name, unsigned lon=
g long min,
 	free(maxp);
 }
=20
+static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat=
 *ts)
+{
+	struct thread_stat *ts_lcl;
+
+	/*
+	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
+	 * Trims (ddir =3D 2)
+	 */
+	ts_lcl =3D malloc(sizeof(struct thread_stat));
+	init_thread_stat(ts_lcl);
+
+	/* calculate mixed stats  */
+	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
+	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
+	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
+	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
+	ts_lcl->percentile_precision =3D ts->percentile_precision;
+	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
+
+	sum_thread_stats(ts_lcl, ts);
+
+	return ts_lcl;
+}
+
 static double convert_agg_kbytes_percent(struct group_run_stats *rs, int d=
dir, int mean)
 {
 	double p_of_agg =3D 100.0;
@@ -644,24 +668,7 @@ static void show_mixed_ddir_status(struct group_run_st=
ats *rs,
 				   struct thread_stat *ts,
 				   struct buf_output *out)
 {
-	struct thread_stat *ts_lcl;
-
-	/*
-	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
-	 * Trims (ddir =3D 2)
-	 */
-	ts_lcl =3D malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
-	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
-	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
-	ts_lcl->percentile_precision =3D ts->percentile_precision;
-	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
-
-	sum_thread_stats(ts_lcl, ts);
+	struct thread_stat *ts_lcl =3D gen_mixed_ddir_stats_from_ts(ts);
=20
 	show_ddir_status(rs, ts_lcl, DDIR_READ, out);
 	free(ts_lcl);
@@ -1332,24 +1339,7 @@ static void show_mixed_ddir_status_terse(struct thre=
ad_stat *ts,
 				   struct group_run_stats *rs,
 				   int ver, struct buf_output *out)
 {
-	struct thread_stat *ts_lcl;
-
-	/*
-	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
-	 * Trims (ddir =3D 2)
-	 */
-	ts_lcl =3D malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
-	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
-	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
-	ts_lcl->percentile_precision =3D ts->percentile_precision;
-	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
-
-	sum_thread_stats(ts_lcl, ts);
+	struct thread_stat *ts_lcl =3D gen_mixed_ddir_stats_from_ts(ts);
=20
 	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
 	free(ts_lcl);
@@ -1529,24 +1519,7 @@ static void add_ddir_status_json(struct thread_stat =
*ts,
 static void add_mixed_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, struct json_object *parent)
 {
-	struct thread_stat *ts_lcl;
-
-	/*
-	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
-	 * Trims (ddir =3D 2)
-	 */
-	ts_lcl =3D malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
-	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
-	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
-	ts_lcl->percentile_precision =3D ts->percentile_precision;
-	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
-
-	sum_thread_stats(ts_lcl, ts);
+	struct thread_stat *ts_lcl =3D gen_mixed_ddir_stats_from_ts(ts);
=20
 	/* add the aggregated stats to json parent */
 	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
--=20
2.34.1
