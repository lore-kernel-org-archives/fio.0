Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC00C433F5
	for <fio@archiver.kernel.org>; Fri, 14 Jan 2022 15:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiANPql (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Jan 2022 10:46:41 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55944 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiANPqk (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jan 2022 10:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642175200; x=1673711200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d53g30qSRPPT8d2f2gWhnBOIJ4OIhL+PHuStkb5f7r0=;
  b=l3NfPChveBbw5p/JvYaFAbPCCRrDUAN6s3D0F5FobGTXZsqz15LcRgA1
   iEZRupG3LrR9QcVTkBrN7gMi4GbOJhzD+VqrXEfmiS28BJzkjQOiGza31
   dFuXxeFOdx/Kpckl9Fr7DBSzbq8IhqRNPVFquyJeCrv0buP2s2ZEXjv38
   O0jLwIqp7XCmZ+0uVNM5WXjdX30/o4MNUNMFsq1QQlLLanqWO7oJfskQW
   TtNoLpqx/hh0BwWCGzzZHM2zAHzTzmIYxk48nRYlzB/4UzhBmclDl/fRE
   g7ljeDMFJeQDXAQnlp2f8xaOOr5WAgba4gqBIW9XQXnxIqoZdWiksmQN0
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,289,1635177600"; 
   d="scan'208";a="302342650"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2022 23:46:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5lA4KT+igb5YegwGaoLm1sshnjuwwDXtkkB7patM8j8ThLHgqyFXdjog99NG020Xpj3Fi6vQhhNTPs1JSs2dUwh/IdYX/CDV4c8mJp0peankEEhjYcJeMfkpQHeqnWqsfWkRUynoc57WVVgRRxko+MBtAYPLzXvycXDa6y/ZplqJqRTNFdB3LwlvCl7Mi6HbcBAutmU8tZ38x0v7kXidGXZeH4Y7gqu0Qv+4gtwqt6bROmwOsXIZtGj0dEIXfPaMl8jihxdTUmZlY1Zi4lzkJLBP96Nh+h6z90ZO8NZ255iz6Z/c03EyTV19S0XX8b++oKtZtSTYxtwkxhDTxQGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PR12is7cLoZaR0OvLQD2+HdAe6lQn1yDKtMxqB8yr48=;
 b=lJcN+d7fhQ3iW6LNlwBefQBhq6RXcriWysq/qVu5hXe9cTIAmfCzYQ4Trw8eVcT2i4Z3wQv+59TTaA+DydME0Zcb+zK2/u5SLKhVjBJPsc1qPKV4gX4e1w6xLCaSHDanJQRqPyx/Gr5bmEL+0YoxZKQWkgkUQWU6Y/1Vj2QthOACL/eUkMQtsUKyQUTciX7EQUJfaeUovwoun8xXs0cGpeh66LFxV+3x9fbDsRtQWyrLxwFtOXpl9OlibYFlNJ0TXSoaHeWgaGbGq5rZYy9veN7ZuITePTicOiXdlunbusdlXTXDu7fe9iyVsoXlRZaJqecamtCsMCsPBxX7d8zNHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PR12is7cLoZaR0OvLQD2+HdAe6lQn1yDKtMxqB8yr48=;
 b=ANCzhQKiJ3SUuTSWVZH6kg+XnQUoJSJwk3gRfHNpiTDcp0pbzxwCwC3L/NGu5bcDFy+tWrDbHUnVexyoywEB0/fgkD5G6yo3f5DphTHePFWo9ZRqNkaDSGIn2yc4Lrhuh+Ey3SAEJg3gfPAE500kDbX3unicVXgxecG0P1Ma8iA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7413.namprd04.prod.outlook.com (2603:10b6:510:13::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 15:46:38 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 15:46:38 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/2] stat: move unified=both mixed allocation and calculation
 to new helper
Thread-Topic: [PATCH 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Index: AQHYCV3qgzDvXx6mtE25znxGKlXEVg==
Date:   Fri, 14 Jan 2022 15:46:38 +0000
Message-ID: <20220114154630.221288-2-Niklas.Cassel@wdc.com>
References: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 127d2fff-aeb6-4c6c-349f-08d9d7750d75
x-ms-traffictypediagnostic: PH0PR04MB7413:EE_
x-microsoft-antispam-prvs: <PH0PR04MB741311E6E8C4822F0F318EDAF2549@PH0PR04MB7413.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sf0BsBZ8XOGAe5gYhinfMpGuVm5AC53mLdvdjrh2Ei+kmitMvtxPISKjQIGbnLxGvmCKItoDT9cK8PUQyK+Z9s5cfXHAAD5RDkpS2/xalouDPUXOV9q+ncb6aIpvTdP8HMncv0EL7aqahG8pNEM3rM1N5izo5OWZKPePG3SV2KCyD2UIDEodIwwHQxIs1fDkeabASQ3MsdMRk4KmgDTeNPX7ba5U+dK4hY0dWc5Iwx5ZY9JCbYWIIijsr7XY5vXLwOtgZZS7nw/3f7DnZbRv1yeFzcyQTOHmTVAOBJaD2HdPGqUYLgHxZzNGRTeNETFCgwtIlCpRjut34MC1e1Bwf6SSwZOj5E434a77vxnoMM6IW/SOvNd4OKJZbnAZk1933YVov9P5HtOzyF5TnPPalzjhMLItGsLpKqZZ2HfUOe/ok+9TmFOsJ+Ag++X/Zwt23KFIuVMfO6Yw5WACKlGl/kNKS+Ju8YvVC282HLNhcO+Z83Csktzz6rVLlpMktLHB9uVML/T735dWKKKQSDynXzauk57KQVfkZl7386/4G0o1NItrN8j33ISNqXHO7gTxo41rBF1D2tAShVvDXIYY/zRmH2PRF0yr5YtdF1gSaWI1WFi622SZ++zm32WWSg2P1/LZrvaX+KB7B+DYm6F5js/MtSEF83BZW6ghKb5ChKTef5LxjLaJkBzDfSaOufGkmL+u8xrdcnj42KagZjcQ2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(4326008)(38070700005)(71200400001)(8936002)(36756003)(2616005)(2906002)(6916009)(86362001)(316002)(1076003)(83380400001)(508600001)(6512007)(8676002)(66446008)(64756008)(66556008)(66476007)(38100700002)(66946007)(186003)(76116006)(91956017)(54906003)(6486002)(6506007)(5660300002)(122000001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/cUODcAKR6ENwK2dGVIIL5PQj3EPJpaGM7YLxbC9x3TIJsZN80bd/Z6XfN?=
 =?iso-8859-1?Q?76YqrJyfmbt+UKY8C+xEC6tYEcwNvt1t9IERgM3g9Rg4jLhZLIyLeDLI42?=
 =?iso-8859-1?Q?cQUm3c/+YO0c/nCSQQdC1AnE0/vIPxQMN71aXNjWz8otfu4VUc/wanhct5?=
 =?iso-8859-1?Q?7OX4I70NkJiOvj5BPWOEi30eKvTO238s+zaAqPDC2b2jUYcY/NDo+2prQM?=
 =?iso-8859-1?Q?0sCO9SkLX9utEqRZM/Yx87caPBKwNhJ8moxalSOqpRqkNiy+FgegiHpBTf?=
 =?iso-8859-1?Q?0UFW1Gmsc8u4lPlvXVY8Co9iypSSiTpThpaP3hPr4lupgE94khoIL1bx21?=
 =?iso-8859-1?Q?1/87jRN6e+w7i5kzHn9BcRb6QtfWJKtq63RtCaGt1P/z4zOVlkfnfrX/Ig?=
 =?iso-8859-1?Q?H2tyLCfaPGLLwbQB6yRn8zsYMFhzynuIJdVZVm+JjEEQQHUL01DXXFSnb4?=
 =?iso-8859-1?Q?4bLvvz024z2MXYCYhJhTF89nE0IYZjGSn2izqzwKrdy5SC6YJLtRxnW/6t?=
 =?iso-8859-1?Q?X1ftFfDRGCBcvbeburCA1IUy2GA9GWTvgn3abn2h/1GW0oSNoxGBm7g4+y?=
 =?iso-8859-1?Q?P55rnh6zvjo87/LWMUq3FG7MnnEypF/sKl/s/jKO+xIB2AJsGXOA3zBA7J?=
 =?iso-8859-1?Q?5qSOgSi6DD2Oehipz98ilvV3DL+ggJElEKhrweR+BumkIy5BKBv+an2AT7?=
 =?iso-8859-1?Q?RqIaEiCRKVnysHr9QzRSvCzqlWdN+BZHIbBZlJH42I5lisjZjJsQA2uUq8?=
 =?iso-8859-1?Q?s83cn1t/pffZiycSPERmbdssK/R0dpzFyri3205oXcjVW/iPP6VF3CB2vR?=
 =?iso-8859-1?Q?pmEnPdmRNNWHV+dP1uXo4IZc+JdfoZNIA8MwFn8GanssCcsp+MXVL87Oe0?=
 =?iso-8859-1?Q?j9rHS4kpxw6Ji2PnyeJvX9/DozLOu1iuH2w3BlYOFX0bIaLXnendurM0cj?=
 =?iso-8859-1?Q?XmRxXxnYvj3ef7pBHKT8FwVX/YGQAN24JRmF1lUyFbCkuojUSpX90BdPLp?=
 =?iso-8859-1?Q?uX+YylG/8vioVRPYjrxv585QrMRydiJ17xmeiWx4KW/v2HB/kCi3Fw6N/d?=
 =?iso-8859-1?Q?CBx89ELNzgogS1897zYo6ZhVAd5YROZsuWU7uRESdDuQHJGrqJ891u7hfs?=
 =?iso-8859-1?Q?+qSBWPy+JjdU20Srs/+milNdtqDAZzi4CIpbrCenaPZl8U+xpQTyltujSO?=
 =?iso-8859-1?Q?uC3XKXE6BCWVdAUh7P0y23zErBGfYLX5vx4uIjl32I7/oTt9ahKj7LKGjs?=
 =?iso-8859-1?Q?NlqLYY6mb5zNq/CLN/dMYnOc3kAp+SQH1RTxKgi6vLxHdmQiXdXG1oPCVv?=
 =?iso-8859-1?Q?3M2HapCHiCphR0Hlyf31Twm3sQgfXwgii1FKUsX5IJN1tn4wRclIGxhnZ0?=
 =?iso-8859-1?Q?XdqgaSx5I1GHtp7G0nI1sqmrfNBdb1Khj4Pe0BUNA7JPnyuVRqvpGSkjcN?=
 =?iso-8859-1?Q?Unz5bilstaTr30UJRkU47UVmvQYB/DiaqknxFbRtRZOm5vPRwP1MVyHLo4?=
 =?iso-8859-1?Q?czU2C7Bxvq8sS+cnu13w/e1QGfd7oKBmv7arqkTqqgFRIIusGSrROK6nNV?=
 =?iso-8859-1?Q?hjdoqqW1D2ALwprUKi/E7rl7zMsqjdbyseKjQY3oQNShNjIGHYHic9Acjs?=
 =?iso-8859-1?Q?rYWb2ZEgly7LRcsspkhONSwgbsqI5bZ+UKMdNhAAS8vDF4OgXhBUr4tnl7?=
 =?iso-8859-1?Q?u4f3GV35ShcvHmwP9y0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127d2fff-aeb6-4c6c-349f-08d9d7750d75
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 15:46:38.4692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9TwtXBWe3z2SpAHp8eWZVuxwJMERM61nxJuivBQeDCIIyOEsQ5ib5+u9ZIcRa85GP9bwkhaJ4dpmamxjNMbOsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7413
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
 stat.c | 81 ++++++++++++++++++++--------------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/stat.c b/stat.c
index 2b3687bb..ff2393b0 100644
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
