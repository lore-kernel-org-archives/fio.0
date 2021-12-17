Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC35C433F5
	for <fio@archiver.kernel.org>; Fri, 17 Dec 2021 17:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhLQRBh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 17 Dec 2021 12:01:37 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58057 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhLQRBh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Dec 2021 12:01:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639760496; x=1671296496;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ld+RTvsUN3YTHc8Daz/fjVq01zoY5Gxgc8+sAhANG+g=;
  b=QAomRHit+FXrrOBlDpdIGZxU0eAUUrKXZCd4NVaepPTI2XXTq31vQkkH
   uLhJ1FY+GjJbtyZZSBgD7bk/zacHW3WQM8nTASiebqSSjEl3hA3JxQw3w
   hnyyMCSSUInLU5Y66FjV6c/XwmwXs/v9o/6lTgwmiXw8kdfxpn0FbDCs2
   OV8PjNc2Lyh92RAj9PeF8va3B0NLIJc+Jx65lQbHL5OJ9q2CkaraBBC37
   03xtWM1PLOUSYrhuheUDwqKaeReKUfMFLr1CEJMSkB5I6y3vttXWADkiG
   xpKBcfs/rLlHvTNO+OAKHhD/IzaSiN4xPdqx4y4JGa7j48CrOIXYhdH7M
   w==;
X-IronPort-AV: E=Sophos;i="5.88,213,1635177600"; 
   d="scan'208";a="188516829"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 18 Dec 2021 01:01:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5fhcEDStcYagQ9mofwBZdYlrhPRYZgBR3o1E2UVLmjI78LlaGHznLA0tLUM+/bMp+hQKHpW30Sf6S/FAX3Y7biK2lKGJYPzS3Sih1HpWHaURkCbU4/QgoputvYPjTgnI9LAHmVdVYW1D23uTFff4C1mDg0gepl81Srx4x5GcVLQIvQFrhi43kc5FwNYl7zRgOWpUpWgM5JQka9kCjVMM8lso53b7xbzDg98fGwX1tzzpepa6bwS5VJUbiIjx09f+MyCcODYl6PfuAHfZUC9v6jniMatyl/qbZruqgpxhPUC2kghNI214T5983E0zJPYCuzmM67a3yPMEcOtXaum/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjhEuMzgyAA4687AJ/EBvQlahxyX01n8YN6tG4I94AU=;
 b=lNxBGVMajrDydQlfJID+1Ait+kCs1Bqnws/2/aIFCU8ecKbuVDtFOWVSyM0ned3herZMg+9LcSiGhW0hdkzFdOIGdbu/0h4kyJMlE2Db8KqVwbqLxglHdwqPBHrrC1UTwdbULtxg5fkLpsFQy4EX8MjStS7QmZB3FINb+92quTYmIkRO9a15PjnIc2ATZH7G1+mpRYqeC1xL5Zk8pAmP/DIgfaDJE/1T/X6v+hbRsjIiXvYYgnJdlx/3uTHwcEIDgcTDx39tK5iN1nv7h4TE/9gbUz7Cl/BJIjY1+dP4o4I/n0uXmX7d+U1HGfmw6/ZaypPzpXBpQaNs3SoZgdYjyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjhEuMzgyAA4687AJ/EBvQlahxyX01n8YN6tG4I94AU=;
 b=Kt1l+GDGc6flv4BVgJLrP8jdJTvB1OKIBHrSUar9R6u7SlDlmt90uo/CJYrPDdXk3MLFkrAd2x6eV9S3Ua3l+nDchi2AatLh8pva5k9AI9QGqa8t54zWKdIK6dA1Zk0oBxnzURKNjl0EuUHHKLRayowBOoiMrCg/vlQ1UoNbeWo=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7301.namprd04.prod.outlook.com (2603:10b6:510:c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 17:01:35 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.019; Fri, 17 Dec 2021
 17:01:35 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] stat: remove unnecessary bool parameter to sum_thread_stats()
Thread-Topic: [PATCH] stat: remove unnecessary bool parameter to
 sum_thread_stats()
Thread-Index: AQHX82e/ab0y839A90OHugda8rtJSA==
Date:   Fri, 17 Dec 2021 17:01:34 +0000
Message-ID: <20211217170122.23071-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7210c307-9d9f-42dd-8535-08d9c17ee200
x-ms-traffictypediagnostic: PH0PR04MB7301:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7301CDA51084C70E79F7DB5DF2789@PH0PR04MB7301.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FU6+lB8umMv2IBK+X/s9tIjhcpTVTOrLq9qz8VZCp2WDyEkmmMpmNea5gRVRqsnVzDV5oP6uHd6BU6yXiWwpNrhi3BCI+wfp/cmc1rOu2ZaEnr4RC0QITMBVex63LhqxT83PwEcc3mSUKBIM2dEepy4MjVd4+g3f720NTk7HxtREyLvU0aPWyN5fZaVW4YneK1jORNDYGZPVFWZJD9QVdf4J4wCTg9Fr4PB/0c1zjebrZ5O31h+Y38taTVS2X/Ahy51SYpYxSQ9CxeYMqNYPo76d3xDrbTGs01qizdPhsp64+p2FqTLlBV+e+ruMYnbxi6p8vNLxFiyS5WZhzQUXmKmAeTY0SBjLOTFeZDVL15EkJdMPZ1M+4hyfwvx7y3yElrBae0q+8XTzT/lXasRCTaQzdBurEljxe49bb5mRJmP1skKyyc1NSt957xL6reKqgnHyJjJ3dnLtqIVWX38pFb6VynKuWBinCirhjBECt4ze6DrpI+ps5ugXj0FbtDursqnLPGrp//QmsqVaFIAT38+BVPMavPaItZrDeDAObI5yqhUN3zJn18gi0redx958fQDCPnD4bKaCOx0ujYo1dyMcEgbimnS3WGCOcR2o4uRwig40HA4pEKStfFWxHuRo1IRUiEKLkzsqygDTDjVN27hGU/HCabXZQGU9LW4somwzgBSJME27Sa66RsW1ikaik6W4giXJdEQ6hd49ptIg7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(83380400001)(316002)(54906003)(508600001)(122000001)(38070700005)(38100700002)(6916009)(186003)(8676002)(76116006)(82960400001)(91956017)(66446008)(64756008)(66556008)(1076003)(66476007)(86362001)(66946007)(6512007)(71200400001)(2616005)(8936002)(2906002)(6486002)(6506007)(36756003)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xknr/yeZd5CsZPq/R3vigeXcKweWOgzVxwIpI2Z//PiAUpp0GYeDbkoV0f?=
 =?iso-8859-1?Q?KIkNLfk2k3E8dOcKXeY8+JyoBp88G5xoVoqyuf3E95S3venrDS9qzVthKn?=
 =?iso-8859-1?Q?r6PWrfZ+SPxUrBU4ea6AmnjofQRRGF7DzXKjUZQ6H5+A54jOaK2FtULdcL?=
 =?iso-8859-1?Q?KI4yW+rstOHxEQit68SxAosRlaHeUfWFv/eMJnSk3HWSQbZRXhOcJ/7tT9?=
 =?iso-8859-1?Q?YV9CbTbxkyazVgWnrhT52jR7t6dYJOutl7FmeGjr3lU5jNPmOnbFJJR2mG?=
 =?iso-8859-1?Q?jS4UJmqDrRLYxi5br/r7v/gL3kdrCc9zg2vZynIvuPOJcrnXK3c/gJn69I?=
 =?iso-8859-1?Q?lrqwArnc/HEdbg/sInBNC8t+AgA91NPiLflNPSs+6R018SwdQfhoJcqRpe?=
 =?iso-8859-1?Q?rRUu0o0C5NG1hZzGUV6bV8tAFa6IVEi1leEvOdkH5mflS7Z3r59H4Ps3MJ?=
 =?iso-8859-1?Q?wIXFTfT7s/I53SIXBZExASWmQOYpH2J+mRIYsT16aqM1JkQyRooBaPVW2s?=
 =?iso-8859-1?Q?yQIItLJKqJFpX4jKc4/wyBMMj99anNS/MWxka9F4VFvjpzPDbBKLetpORZ?=
 =?iso-8859-1?Q?Xz+v7z5kcxmDZdmZSY3UJlf2V+Xb8ke4vqBK84xAmfcOqO60Lb5XOyM+/i?=
 =?iso-8859-1?Q?CQnVJmoEtYgRlD+MF3YMaDYeUhD4iO7TKAOwleG71v6LbatiM51AmHprm3?=
 =?iso-8859-1?Q?xkDEZkmJZMbS74bY9jesxMMgGiPp1AnBUY+jo/66/4jD1vjXzaaW8OU3Fx?=
 =?iso-8859-1?Q?RlYkhwheQG4JX5haQH8PlP5oGJpdAGnvEK9uS3f3lT42XLoko1tXRMreJJ?=
 =?iso-8859-1?Q?mwGjCSkqiAL8pWDloN+pt+e1sE1Ux9twPe4uPJSBXY677ZgIPCIqnK+nMD?=
 =?iso-8859-1?Q?//Z8rry+GGNbW7VlZn0QrivbCHQy67MGkTSa/PqPC200X2PjpxW6t89Wk9?=
 =?iso-8859-1?Q?9UtAB07XabslXyxBqwb/5FEtNslHP+1Ae/0rKILFLRox9Cpw7jEp6btqMF?=
 =?iso-8859-1?Q?zX+QTVarIiRlzOF7gPmZAI2NY3m5aMxqbkKzywjUyWi7Zh0rNrRi5rXhgy?=
 =?iso-8859-1?Q?oWMbdJo+IPAnmWC/oYQzNndrchQlDN9S+7l/xJpM/GZj80qLQao/VG/e3z?=
 =?iso-8859-1?Q?pooqMszfRGvvRlspQqhGjI2bVt3ZrKPjasBUjQedwI3MirEZJL2z/XQWxm?=
 =?iso-8859-1?Q?b+6UlB1lxNc+9NHEJJn+wGN0Mq5FVjn4vfyg48zmkeDadw1SmvbYt76Sx1?=
 =?iso-8859-1?Q?DkOPoWsSWRK3E5rGY9aMqMJds8JPPmUu64frWVX6BWoQ72qum/gSsN0/0D?=
 =?iso-8859-1?Q?OU1PXpl+J+VRlESAZ94MVDTffqMqMlpdJ+q06FlGOnpEQXjPAQJ1Bk4h8m?=
 =?iso-8859-1?Q?9XR9h8JwPRdm/SJJGvlGhoEXcAIq1orNv0TCil7kkuCNy86CKiM4vRfbMe?=
 =?iso-8859-1?Q?owaqvDYuUs8tY+vWI4Jn/i6kVdDvYsgFFPvU4zMd7ct22WRoa7ugutsTKo?=
 =?iso-8859-1?Q?TNuD6tqS/akfEhA2fys6XlZFV+mTOOMsAB3BW0UNUtL0C2gjOhUHbNawwu?=
 =?iso-8859-1?Q?tCtfPbpV1hZpq/L1E+O2Sxw0KjjZf2FaUiYDoXTGHWPiIJyax+sbgDwBJb?=
 =?iso-8859-1?Q?ENKkowFpoU4wWtMJRrq0OJi1aEn+VthoE/BjcebOyNSXWvzLg/pMuUTWv/?=
 =?iso-8859-1?Q?ebou0dIx7a8g6OdOYkc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7210c307-9d9f-42dd-8535-08d9c17ee200
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 17:01:35.0195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fM+wbWolK9pceJZvMeaT5vJu8Tb3tYr49KQrZNC67pnZwGSOnpzzlR9j39olZlrivM4O6LhXtnKVwBUTFUwy4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7301
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

We can deduce if it is the first struct io_stat src being added to the
struct io_stat dst by checking if the current amount of samples in dst
is zero.

Therefore, remove the bool parameter "first" to sum_stat().
Since sum_stat() was the only user of the bool parameter "first" to
the sum_thread_stats() function, we can remove it from sum_thread_stats()
as well.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 client.c      |  2 +-
 gclient.c     |  2 +-
 rate-submit.c |  2 +-
 stat.c        | 53 ++++++++++++++++++++++-----------------------------
 stat.h        |  2 +-
 5 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/client.c b/client.c
index 8b230617..be8411d8 100644
--- a/client.c
+++ b/client.c
@@ -1111,7 +1111,7 @@ static void handle_ts(struct fio_client *client, stru=
ct fio_net_cmd *cmd)
 	if (sum_stat_clients <=3D 1)
 		return;
=20
-	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr =3D=3D 1);
+	sum_thread_stats(&client_ts, &p->ts);
 	sum_group_stats(&client_gs, &p->rs);
=20
 	client_ts.members++;
diff --git a/gclient.c b/gclient.c
index e0e0e7bf..ac063536 100644
--- a/gclient.c
+++ b/gclient.c
@@ -292,7 +292,7 @@ static void gfio_thread_status_op(struct fio_client *cl=
ient,
 	if (sum_stat_clients =3D=3D 1)
 		return;
=20
-	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr =3D=3D 1);
+	sum_thread_stats(&client_ts, &p->ts);
 	sum_group_stats(&client_gs, &p->rs);
=20
 	client_ts.members++;
diff --git a/rate-submit.c b/rate-submit.c
index 13dbe7a2..752c30a5 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -195,7 +195,7 @@ static void io_workqueue_exit_worker_fn(struct submit_w=
orker *sw,
 	struct thread_data *td =3D sw->priv;
=20
 	(*sum_cnt)++;
-	sum_thread_stats(&sw->wq->td->ts, &td->ts, *sum_cnt =3D=3D 1);
+	sum_thread_stats(&sw->wq->td->ts, &td->ts);
=20
 	fio_options_free(td);
 	close_and_free_files(td);
diff --git a/stat.c b/stat.c
index ec44c79e..77242eb1 100644
--- a/stat.c
+++ b/stat.c
@@ -491,7 +491,7 @@ static void show_mixed_ddir_status(struct group_run_sta=
ts *rs, struct thread_sta
 	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;               /* calculate mixe=
d stats  */
 	init_thread_stat_min_vals(ts_lcl);
=20
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
=20
 	assert(ddir_rw(ddir));
=20
@@ -1469,7 +1469,7 @@ static void show_mixed_ddir_status_terse(struct threa=
d_stat *ts,
 	ts_lcl->percentile_precision =3D ts->percentile_precision;	=09
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
 =09
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
=20
 	/* add the aggregated stats to json parent */
 	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
@@ -1661,7 +1661,7 @@ static void add_mixed_ddir_status_json(struct thread_=
stat *ts,
 	ts_lcl->percentile_precision =3D ts->percentile_precision;	=09
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
=20
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
=20
 	/* add the aggregated stats to json parent */
 	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
@@ -2073,9 +2073,10 @@ static void __sum_stat(struct io_stat *dst, struct i=
o_stat *src, bool first)
  * numbers. For group_reporting, we should just add those up, not make
  * them the mean of everything.
  */
-static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first,
-		     bool pure_sum)
+static void sum_stat(struct io_stat *dst, struct io_stat *src, bool pure_s=
um)
 {
+	bool first =3D dst->samples =3D=3D 0;
+
 	if (src->samples =3D=3D 0)
 		return;
=20
@@ -2125,49 +2126,41 @@ void sum_group_stats(struct group_run_stats *dst, s=
truct group_run_stats *src)
 		dst->sig_figs =3D src->sig_figs;
 }
=20
-void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
-		      bool first)
+void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 {
 	int k, l, m;
=20
-	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
-
 	for (l =3D 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!(dst->unified_rw_rep =3D=3D UNIFIED_MIXED)) {
-			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
-			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], fi=
rst, false);
-			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], firs=
t, false);
-			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first, false);
-			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first, false);
-			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first, true);
-			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first, true);
+			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], false);
+			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], fa=
lse);
+			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], fals=
e);
+			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], false);
+			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], false);
+			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], true);
+			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], true);
=20
 			dst->io_bytes[l] +=3D src->io_bytes[l];
=20
 			if (dst->runtime[l] < src->runtime[l])
 				dst->runtime[l] =3D src->runtime[l];
 		} else {
-			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first, false);
-			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], fi=
rst, false);
-			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], firs=
t, false);
-			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first, false);
-			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first, false);
-			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first, true);
-			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first, true);
+			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], false);
+			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], fa=
lse);
+			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], fals=
e);
+			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], false);
+			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], false);
+			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], true);
+			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], true);
=20
 			dst->io_bytes[0] +=3D src->io_bytes[l];
=20
 			if (dst->runtime[0] < src->runtime[l])
 				dst->runtime[0] =3D src->runtime[l];
-
-			/*
-			 * We're summing to the same destination, so override
-			 * 'first' after the first iteration of the loop
-			 */
-			first =3D false;
 		}
 	}
=20
+	sum_stat(&dst->sync_stat, &src->sync_stat, false);
 	dst->usr_time +=3D src->usr_time;
 	dst->sys_time +=3D src->sys_time;
 	dst->ctx +=3D src->ctx;
@@ -2401,7 +2394,7 @@ void __show_run_stats(void)
 		for (k =3D 0; k < ts->nr_block_infos; k++)
 			ts->block_infos[k] =3D td->ts.block_infos[k];
=20
-		sum_thread_stats(ts, &td->ts, idx =3D=3D 1);
+		sum_thread_stats(ts, &td->ts);
=20
 		if (td->o.ss_dur) {
 			ts->ss_state =3D td->ss.state;
diff --git a/stat.h b/stat.h
index 9ef8caa4..15ca4eff 100644
--- a/stat.h
+++ b/stat.h
@@ -325,7 +325,7 @@ extern void __show_run_stats(void);
 extern int __show_running_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
-extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *=
src, bool first);
+extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *=
src);
 extern void sum_group_stats(struct group_run_stats *dst, struct group_run_=
stats *src);
 extern void init_thread_stat_min_vals(struct thread_stat *ts);
 extern void init_thread_stat(struct thread_stat *ts);
--=20
2.33.1
