Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866F5C433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 15:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiAQPu5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 10:50:57 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2102 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiAQPu4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 10:50:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642434657; x=1673970657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q2Cl75Jpi37/Cf/g5IckcdIO5nP03m9RQsdtRd5UBjg=;
  b=iLCI8GhZyAQFUxDqbuyCeK6rb1JpgPCkbKZQp3f/1KRPOnyY4/3NnR4W
   bAxjvR7819nQiLgFMhRgxsPzx2BRnvqxyGtVXxikZGmI8hODNfmTw+21l
   G70tWRJGKYJy9dWkRf5fUhl/fm88NlpktWfzbiLwrkKY+b58xxPXtNTH4
   JwwvW2RpneY7bJkrlCerLfV6Nb23QEy4onCIzhVJq1y9k6FinHXUImlvj
   RihmxeAIHgOyDPdOi3LPc8pqpYzaThL8gRegH4OUmezWCO38LaTJsXSjR
   vEb/tz7dai4oZ2XKA/T4GBoNZQcs6kY4UJ3QRldEqSdnNE4aM2gvpgqC2
   w==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="191670538"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 23:50:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYqADKcn7ehMLWZyKa99Nwf7wtDc12Dezq4inSMAIB2rfXxfaACr0wAGh/FfLMarviavuR1OrFOI6lAcJD+rKqlrAkso/OhTHRcqWKvY4VW0v3Ae1ZUGBhQonC3sCGeYnInqQXHSPQUcmM67KkmJObTuDz9MBkyMcmMleuACqG5p1CLoc1WEmjChb2rX9cA55gPlwk7SRfDvpfBtQDhM8aTdQ6U7H99NW6gHr9TCSa9GZdqR+avigG8kH1TdvxZIULZaIDDinohTA8b2H3hqagGGe0qq0J0M59ay8V+z3lnJ/OMbQJBjnEhESfDN+aVhyyYmj73vWSClgF/xx8xHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQa2NnzzZ/TZC9nK/YiBZMjvgczW1gHH8vYOArNWGE4=;
 b=FQ7KO/vUSexww8bbssa7QvL/tbCeKvsqysvEwQIODRIZeioI4au3l5voiykgF0VXcKqmQUS5gf/1ujYgt7HrQkyURRHnp5SUjORHmZbv6zk7M9S2zFhvXDPgYGfsLiygbfjQP72ZVxC7zMB2s7rygsPF4hzdp06IBbxOamJprWygol5C1YZq4LJRDkvPBea5KsL85gOTOnNH2Iwl4q4tcRA5VE2KR/omOyiw4q9XW9hDr/bMtj0mo2vuACZa92+QyH2IqoNuLkABXtxgWko1zx7yVLkInSRLHB7wLox0J7dHnZr8cc4aOTTldB4OfhP6Q4QFqI9FvIaaw3OJ8e9FCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQa2NnzzZ/TZC9nK/YiBZMjvgczW1gHH8vYOArNWGE4=;
 b=L36OL4vYNIZpknKo735lj0KamLUb43r9wOquuSNRhbjnkC8dLMJwuT/7+YrSlyzFR1ukIZ4PKq3buXx3ANUIXReCkqpQda2Iej7VuULCPKW5B152clF3+Wqh7Dqruz3e2184wiEGbD/Lh8c7IMSxz+hwG76W9B67+yqLvskdmz8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SJ0PR04MB7758.namprd04.prod.outlook.com (2603:10b6:a03:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 15:50:53 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 15:50:53 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
Thread-Topic: [PATCH v3 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
Thread-Index: AQHYC7oC+VmpWFLYeka9fAcpB48TkQ==
Date:   Mon, 17 Jan 2022 15:50:53 +0000
Message-ID: <20220117155045.311453-2-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 1a3f6e29-f428-4834-b33c-08d9d9d124c6
x-ms-traffictypediagnostic: SJ0PR04MB7758:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB77588341F398E39515EB8667F2579@SJ0PR04MB7758.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RsQFAa1x9uDjImHlDH/pW0o5nrXDtUaVOl7JlhnFuwMG2Zz61IbW6YW25YH/7YTOeRZr18ndFIGyThNMQwE6V4S8iURyXhQoE48sMdvDOFe6pJOklaOm5Slg0jItMOBQYaBwqunGBsW9tNMp2lz2tEkMUd5H+Af/GrMSmPqbXLn7C1RB7aJkC2aRtNSNPePXniVpuEukdslvUxpNQE76uMoNEd3YP9IOYMWGszKRFPJr9UWMF4jI4etIGMxH5NeLSHMNWLMAeutDxrCNMMEfsniv8GHSctr7hLRCZNhKoBKCZi8TRWfoltvkO4ZZ9G5CgyxOfPmdzXDScgB8xEU5kHFTn9uOMDb6FqychjpL6rtuJCuzHbXNW+QJlfVfuq0PxHxYRxwfYhZybi6ITzKI7g15+e2KbL9ELQuFEsSlotu+5s44HCFe0Vy5cb8GxQ2iNdO35ct6YpvJ8BjyakWgfpY1IGf6ans8GM92zYoSuTeirvhbtJXB8HZaHHyI7t/LbjMXokKIxp5f0FP+sd7fIF8veo57kXDCxI6Asgsy45uv2dKB0J6lP1xyhaN8eQ9EhzwUpjfH+tQMMVaYC/UEbuY8JH/iIonMFStorPyoBl2Xo9e2xf46WpF6KitSPQf9aau00fdWoQBfi72EraLVex/2jwKq8NPYhoXCVsqPByxi5xoo7I915e+zIjzHNhGM/u6izx9+VrKkmu3DF4QZ8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(76116006)(66946007)(8676002)(6506007)(6512007)(71200400001)(316002)(54906003)(26005)(4326008)(66556008)(186003)(1076003)(8936002)(122000001)(38100700002)(64756008)(36756003)(5660300002)(66446008)(2616005)(508600001)(66476007)(82960400001)(86362001)(2906002)(6916009)(83380400001)(6486002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lP/aA2zFxvHci7V+Wi+4zHIgvzpL+PZngU7GoC46FKEtP9YLk93M/izGm0?=
 =?iso-8859-1?Q?lXXfk5/tapVVUI1QRZuOXa9Kgug2pW1bhnSQ7bAyR31jjXIsOQxjo5KYe6?=
 =?iso-8859-1?Q?DxGHVZ90dFsGsq+5ulqYCCmO6FnuGex8E0tkUwK9CknAzrIvYJxLWZ8bpM?=
 =?iso-8859-1?Q?GR+GzvyYHv1VEOz+Nw4gn9PivEngiHqpGP1WRpHCIKPAzOwS6hkmDnqaFy?=
 =?iso-8859-1?Q?B7tnY/RTYyXQRHYmIrQpkRsReJGy2pTS37cgAcO1V2V3ipWFPPqZa6j7/L?=
 =?iso-8859-1?Q?ZLIOM9wvwjlfbxv1wX756SYwoOJMsZwKZhsLe2fJbjJtH+HgOTe8iKu5qY?=
 =?iso-8859-1?Q?d0bWQzpK8U4o4Vh925eOkgqTGyuxCxBX1TYCixuXk2Fmz5LfSkGF41+X7n?=
 =?iso-8859-1?Q?onRL5SbA/N/2j9FHoKHKgN524Af6ouz5xqcEoSKWQ8+xMYIje6AXEb9GeP?=
 =?iso-8859-1?Q?N1eI/rDk3jqyo7uCZelk9ehVxKFiYiB8g0VGO9gUrsKEnZQWffRF9e4L0s?=
 =?iso-8859-1?Q?ZdxLPUTK8SRs+jGMMmo8CjLxLwXx5szMVLYBqExFojRBk5ADzoBy2RecOL?=
 =?iso-8859-1?Q?WOUipg2lFfCa6JljL1dX5Wlep1GkyI+bP5qFm7D4oImByg8YuCzzs8U8qq?=
 =?iso-8859-1?Q?z7JL1myB4s6iA1xVvLlv27YllkD38uWdhHl9Dyt5iIRWfZKPxdRMAR9vzN?=
 =?iso-8859-1?Q?V/iFPdT4SGHyXgVnFbz0kQQGkAPGtAn6l332RsDf/xSPfaxhjdk/XjWded?=
 =?iso-8859-1?Q?zstzz9ckCAcIRVYAezffQfKQL00meIH05tSvkGLuBaAdajlsKV/obf/lFK?=
 =?iso-8859-1?Q?y6q53vjJ+iVdysXFYsKXJ+TOP0+nLzzW1aH1Rfna1Q8LeCMI+EBkNInhgC?=
 =?iso-8859-1?Q?PcURFXN9A74bvw1YHt3IUgXfG84aiGfdsphlHGD+SAs9QNhDR2Xk5D4IeD?=
 =?iso-8859-1?Q?cGVE8CIqEjwY5BZO7HSdUrCIXVhZPEXFHdb9HzrSmsf3wJ7RLKQywxtqe0?=
 =?iso-8859-1?Q?X83YbTnTuxuDfBg518fwRhbslv6uqv/nyQ9PfEiA6QhXWoeDlsfOTMqZQV?=
 =?iso-8859-1?Q?MhXUMH3aE0t4cYAr3/nSEb78ulv34m8/O9Kx9Ja9WtTCUwOvE7bOiJX+QC?=
 =?iso-8859-1?Q?QgwCv8aPNgS2azIZ7A6zx7MND8+wbxlXY9Rnm6z9i0UJvOiEiPlq6yI7Cb?=
 =?iso-8859-1?Q?zqoZTdOcBn93h9eFy5KtqGglIDstIsjmX7PdECtk+D/ArPkNRf8ViyhcNm?=
 =?iso-8859-1?Q?5Tm+7ryqLnsjD7FhLrxJHQC9+fw+/irelBH1SCFLEUVnLYpYkP8JQaI7V+?=
 =?iso-8859-1?Q?LyqWVjCYM1/qWH8NSrd1Z0R0hE4VOrfxsksdEfWbcgxj0W1bDnbnSruGcw?=
 =?iso-8859-1?Q?yqLzV+KQg9AqiwhNsC4mYAWOYH+2dzIj9MY1WwLOF2tv6UC/tJcBhoz5Nc?=
 =?iso-8859-1?Q?PmFJ1XPhncFpF0RS2XfjpwXWbmPMs5jDDvGQrKPRS5F9Z6ULcYoNo/NnAe?=
 =?iso-8859-1?Q?Lv1hq8gmLkPL7HY8T9X/c4crqs+1TRj1zCPyAwyLLzdQAwytQ30wOox5iL?=
 =?iso-8859-1?Q?n9FlrmXvxRnWeZt7Nwk77a/ajHKmaz+f0W3bE9jfVI3ikAusuF19vUhWl3?=
 =?iso-8859-1?Q?I8xMDDUjIo4mV3jk6/uE/HqELjl/awXZbnUSACUpqZ71FA4/CeJw+QYHMT?=
 =?iso-8859-1?Q?2oh/CKlzj6Dei8ATzDQmBrL2mLN6l/zmIV7+FkGH?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3f6e29-f428-4834-b33c-08d9d9d124c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 15:50:53.6780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xOu4eqha7lYCv4EFPF5OhsvKihbLnJEqAKj70d8HBJIo9lECwA0iu8bSO/LaW8CPZ9sWVOyJLmFhfzcN6/fL2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7758
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
 stat.c | 184 +++++++++------------------------------------------------
 1 file changed, 27 insertions(+), 157 deletions(-)

diff --git a/stat.c b/stat.c
index 36742a25..42be600d 100644
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
--=20
2.34.1
