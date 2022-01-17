Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FEBC4332F
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 15:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiAQPu6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 10:50:58 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2102 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiAQPu5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 10:50:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642434658; x=1673970658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r0Ty8Bix+LBSqueXYuKVdDafLhPvfVNGKNnT/0Qz3xc=;
  b=Q9vLvZtuMam/OPIJnW0JNr6jAfXBHDOQBWET1xoL+ZW0w6remkiceeoy
   OBz32ajtbRjyZ59H+GvyMuEXakeDVc58qfB2UL4+otgODbEm2fzmdAjms
   jqm1OvBOqbbcenB7idY3a13EwFLw1g7JYz3qnPmXXuF5Gq/D9UxvIZ8TD
   XaeNl/ZZg+LvibQtiHW/vXBKEViGIdlyNgmet5iEpXPpWHeNPvWgonXTK
   lISe43j8FQzgYRYn6QkSfMiklxgQjiw8EMe70p9044PBB7ybuyKoAc2CD
   JOI0YmxpasFTGv40RKmuqXDUtBHbr5aemx7UB5t4azoLlRcqT2BanjEwH
   A==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="191670540"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 23:50:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8A/LofhLP+oSWUc9DjYRO17xuHzv5HX17BDV8FYUhri0/WjrzJ5SwXQFz+Pxf1bdmh7R386wg+pvb+ozhfLrdksX4OC9wgTkxxYfXlH3Sl5KH72oyICsVWrbSyOMup+VetFtcY+DfApVcWWuIl0H701loSUMluIJvlNOKUTmS4laybD5xCTzxJ/tM6NFWTKnkx3k3qTCCknwVQQnHGSfDSGefMLsomEalhxOGtbfsRhJbBdJ4PIGK8HTNgiXTLZGYGDGeO8CYiiKt7S7I9IbX1JPO/l7MXyX3fEt8SVCSiqBDS7dTM3GKteVx4JTLbFzKDa+CV2uu7G6fI7rvBnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vy8XJH0x9ltgI4pf03vxx3LfYhR/XmMzXwCe/8wZ6GM=;
 b=Ig6AIaPt8pt8JlEjqTnW0o1YYigG1mWw/V57lKAHA2nMN5lniyVzv0AxIj/5JHOENXCzsKc39SGDXt1msEz154ucf17IeMpfGX68D72XFCYRIRID1DnjBMR+ps+ofPARq5t6tMmtL/AYRabNwNfo5RkofljXConJOvi65QCCsBhYLkq9aCSyB7jW8eTjuoN0o4YVYHoQOMbGimQxBAjVCRJKDo4kL2hZ257aJpl7tQ3xpGgFF8J0pC0+YaqUqfh0l5B8LGobJl8W8IdYIyGnHI5LpkdeYoQMby7+OgLZpuW95iNM7tiMBGC8CCgVDtEeCu31IE2YXhZTeQR1NO7m9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy8XJH0x9ltgI4pf03vxx3LfYhR/XmMzXwCe/8wZ6GM=;
 b=N/YtPf/UVzAmfQC0aJNQF5JuDnLx88NLrqk/6ay1fpWubwATQxAtcsHX4HoCsbyhtwu3N1tbtheeMqj+oMRoY9jI+28rdW2X/Tl4XkUnSmjouxIMywecOWis3pZjGuQyMT+P5RnIOHNrK/ZsFh8+cnBHHPs2BONS2SUdqiJV4r0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SJ0PR04MB7758.namprd04.prod.outlook.com (2603:10b6:a03:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 15:50:54 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 15:50:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Topic: [PATCH v3 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Index: AQHYC7oC2LSwJ73poUqVH9eNMcTBHw==
Date:   Mon, 17 Jan 2022 15:50:54 +0000
Message-ID: <20220117155045.311453-3-Niklas.Cassel@wdc.com>
References: <20220117155045.311453-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220117155045.311453-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4790df39-c739-4485-0f50-08d9d9d12526
x-ms-traffictypediagnostic: SJ0PR04MB7758:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB775812081B11117B758016DDF2579@SJ0PR04MB7758.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8kB8qbZ24iecLYpKPH0d2g9oYxakgOA8VZ/eYI3qlf++P5tfUTS0uQFnhcdAtSnk0kLmt5kMMpIWrOvb5gshGDp1SWJGN+F6tnLjhOFZhjPzCwH5ERc5Z9Esd8U0CYFqCthiLBnvH2jUzz9KKjXzMMPD4dHVAVEoC4hhRnupckwQgYLmFSfWoOnS7y0S8jzIl0SXPe9+5UKGTF4mYtvxFmMfoJ8hUFXeYTQzuKxOOBvIs3MB1XEzqG0vmc8bijWmPxqYdeygR3oI7G1JjU3AhfSgaYZZuqJeYHZo9CQKjhKXOpecdueJV9YiPhyHAjzZbna6gNq2IjUSvZu6HCMTTEiz0uRZR6WpxG9JaZ4w1IhxIqaMA7u1wXDwTqfBafSWtV41Swe8RD6NQZwD8AL0xrqINVui8DKaRj4IlV98g9/hcgtBcq1aJJL5NKrCNQ3H7sOTWBqPa5wEXomtFbnrwSrJ5/4TGEHezvlQkmrzWRVfJj21XlgUcexibXrh7pKVBwKrIS5LI8dCJj0jQI2pbA17w2+r4CNXjSUMXMi1+GR1XTE/moIXKQj6niXjlT6rsuOO3JrscdNBWjIfIPL9IX6KPTJoDgn6Y6dOqvJRz7L+DxqQMO9nNOy1xSrOsaCVyXgX7ZBZcizWpVVhmCy0Jk89o1t2nIZ70wksZ1viVRyhXbZNFjFsWaUd1QlFobiXgmwxMhr7Ji55xmjO5Bs9MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(76116006)(66946007)(8676002)(6506007)(6512007)(71200400001)(316002)(54906003)(26005)(4326008)(66556008)(186003)(1076003)(8936002)(122000001)(38100700002)(64756008)(36756003)(5660300002)(66446008)(2616005)(508600001)(66476007)(82960400001)(86362001)(2906002)(6916009)(83380400001)(6486002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7Ev2Cx4JyJGdVAS/QZCu40LxldpT8SG4Pa4z9j+cDJzEPMxFZaDfoCPYi7?=
 =?iso-8859-1?Q?xZ+W1PtXM93ZAcXyIjC/D/9Ea6jhxchHOUDXP7+o1tf3LeldfOW+qEuPG0?=
 =?iso-8859-1?Q?gxLkTV32cgDUuiZ+6sW66FSZgxucJXgdK79qVwKESDfcFW14nwlFb5bo5B?=
 =?iso-8859-1?Q?o9SA0mL0xafcNu9IUkIZ/6K6Jxwaz8QdEwzL6GzB1YTJ2YjfiPg0ttGICT?=
 =?iso-8859-1?Q?J5bbZ86ZEdsRF1AXvPbfFTlwVVMvh51QZgrt7eY7g5YEEQKfQfBfvKbQW2?=
 =?iso-8859-1?Q?JxtIv0qNDNHfrz3fSFQWPpTRR86WtEsKa+xtmt8k1ZxmvejPHa0EjaZ8Zx?=
 =?iso-8859-1?Q?riy0MaL/vVxLDTVrBuZqTkKFz2yDcfHq3CYmk/uYNmxHN6jAcEhSb4LuV2?=
 =?iso-8859-1?Q?+Q7Q5CmnQGgc1aIWZfpz/ZCaiHO0bRrmkqpYQ1L2IG3ALKlN4YizV8mW6L?=
 =?iso-8859-1?Q?DfxZHC6MxN6LorslKS/gAQN/GLL1h2RY1iThwNzmiVP/2qm5bArWiCN2gy?=
 =?iso-8859-1?Q?dRdMmgNaW82+W/T8noGTW0HD5RYifjyHdVssAXOW984TsXS56ASqNBxu2W?=
 =?iso-8859-1?Q?w5O3fle7gGuUnfEGM+7+lrGZI8jO1NNaF+JLk/6CPwKD5uVgVSl23jX2PI?=
 =?iso-8859-1?Q?VdJhNbrvGl5a+jC9mHexbilEo6TwEps1gMiWa4nDU0iQgbtF9+GKCLizhr?=
 =?iso-8859-1?Q?b7Wr3/Dmhde4SB3dYwRwLTkOXpswyNHSXEJjRJMRc3cZ5ONo/i4xXUF+8C?=
 =?iso-8859-1?Q?nzL7OU+Ejv8TX6Q3XaA0p6whM4hA0JKMpgJuHAdZlRx4GIFYfCGmkFJzg2?=
 =?iso-8859-1?Q?V9gdNqDELVP6l0gfiPVt8O0sgiuPoSXZaUlhh4yzgUxXVzO4dq/+0VfVpL?=
 =?iso-8859-1?Q?KKzSECHMF4MI+cqzsYR3TpvYS58v2qryRrp59yJoIVoyUyMAWvtJssIZ+L?=
 =?iso-8859-1?Q?ZPMu7ZSrM65l1xDrC8I4vy82FHlEBmBIeEV63jVamQuKM/tpMdAI5xv/f/?=
 =?iso-8859-1?Q?VVwBPNLwEaMomTj5E2gCyszLEIIgOgfBd/AFHi2t15od9e03L/exwRoAoJ?=
 =?iso-8859-1?Q?8N6yHDp774XElpI257Iu5jgvEKimkKjb1HB6vdfvaFBtU9FY6mZBqUV5I4?=
 =?iso-8859-1?Q?Gu63jkeJitpYEWt0YMzcBP0+8tXS7j9cpjP0ZWcKRha/Th/yHrWbI5y6Zp?=
 =?iso-8859-1?Q?MLBIact8brZIsSPqMWMts4qolfreALVD2rsQ5K7xsPHZD8z5o0FVgMHFKJ?=
 =?iso-8859-1?Q?4MCSxCVR9EYF6tukDUKg8WYjargljVwKbotQBZcce1S0Tu3cEKnctXn7Du?=
 =?iso-8859-1?Q?lkZqZRTekJ828KdF0FvnIxXhJkeT0ZgRi91AioTaeDI2xJqp4QND1EL2Bc?=
 =?iso-8859-1?Q?dr31pd91Qp6uKS9at5u3SjHXgHhe9svAtnpLqwnEuFE9GZfzgii2AH4AvV?=
 =?iso-8859-1?Q?M99zmofZYrjvOTzSCGYGxv/xWgZnUZF1rczCa310tTeJANMb1cdK6+01sl?=
 =?iso-8859-1?Q?rWoDe6SRwrdApYNrtGc9TPcefggHDPsmR/ieSX7w0BaDJn2Hc4JNXrUB5L?=
 =?iso-8859-1?Q?2a/fCOvS+aF85Ynvd8X6xVgzNZPba7FakXNQp2KkLAp6l/nTubHcQNfEeg?=
 =?iso-8859-1?Q?5q3p6PkMlxCow7vyLDTDRCBLMU5zltAieTF3mtIO0iLJAwARvbGUgHQeHh?=
 =?iso-8859-1?Q?aGuklnFe0WEka7K/Nymg1pCEix/9MGI2PXMXmFma?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4790df39-c739-4485-0f50-08d9d9d12526
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 15:50:54.2872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2QhmiApWEvKm1IN1HtNs+ly9ENhBUH49fkDmNvrxn7zilcPLvfXEFhdbQIUj+hfRa8NVlaXuvZLDwnBXNx/D3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7758
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
 stat.c | 95 ++++++++++++++++++++++++----------------------------------
 1 file changed, 39 insertions(+), 56 deletions(-)

diff --git a/stat.c b/stat.c
index 42be600d..b08d2f25 100644
--- a/stat.c
+++ b/stat.c
@@ -462,6 +462,35 @@ static void display_lat(const char *name, unsigned lon=
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
+	if (!ts_lcl) {
+		log_err("fio: failed to allocate local thread stat\n");
+		return NULL;
+	}
+
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
@@ -644,26 +673,11 @@ static void show_mixed_ddir_status(struct group_run_s=
tats *rs,
 				   struct thread_stat *ts,
 				   struct buf_output *out)
 {
-	struct thread_stat *ts_lcl;
+	struct thread_stat *ts_lcl =3D gen_mixed_ddir_stats_from_ts(ts);
=20
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
+	if (ts_lcl)
+		show_ddir_status(rs, ts_lcl, DDIR_READ, out);
=20
-	show_ddir_status(rs, ts_lcl, DDIR_READ, out);
 	free(ts_lcl);
 }
=20
@@ -1332,27 +1346,11 @@ static void show_mixed_ddir_status_terse(struct thr=
ead_stat *ts,
 				   struct group_run_stats *rs,
 				   int ver, struct buf_output *out)
 {
-	struct thread_stat *ts_lcl;
+	struct thread_stat *ts_lcl =3D gen_mixed_ddir_stats_from_ts(ts);
=20
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
-=09
-	sum_thread_stats(ts_lcl, ts);
+	if (ts_lcl)
+		show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
=20
-	/* add the aggregated stats to json parent */
-	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
 	free(ts_lcl);
 }
=20
@@ -1530,27 +1528,12 @@ static void add_ddir_status_json(struct thread_stat=
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
-	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
+	if (ts_lcl)
+		add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
+
 	free(ts_lcl);
 }
=20
--=20
2.34.1
