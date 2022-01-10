Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C42C4332F
	for <fio@archiver.kernel.org>; Mon, 10 Jan 2022 09:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbiAJJDn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 10 Jan 2022 04:03:43 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9390 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241878AbiAJJBm (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Jan 2022 04:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1641805303; x=1673341303;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=zTVltjpTCXOsH+jmbADmopYC8mrRtpqtAG7lqhxd+3Y=;
  b=QA83Sjr3kKOo2odGP3BYfM9ynhe8j6cAR0EYtfJXRM97z3CgZtNR5VsZ
   5S6Tm/mreEATITHv3pAKZY9NgtiMuD5IIGblm1pMIu3F5pcFzB9L7cphM
   fOjOpKnMVf3F3+tRZHz3HycwUuOrroogqccBrdXP8vWm9xXdZ6u/Ai9oy
   hhXRlEaKhjcVNb0O2b15DHhtWCNPyQXN5ts115+xysYGSepYZNCbZe/0C
   uIUS/nDzk6Ec14z5w0lhX0pf058YcNBJYArGW5WQn2a6hxsnMp7jm6mvH
   DUieMTh++NVBL9U7WmSX8XshcUl/OhExTYwmJvGfLlBBTds2RW78qeqAo
   A==;
X-IronPort-AV: E=Sophos;i="5.88,276,1635177600"; 
   d="scan'208";a="191099476"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2022 17:01:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXud14rJZ5D9EbqkPuo+WYbDmKhkAakGkG9/WVmh7OppN4vXnIJqHv2ooZSEgK0exPZEOedYbaFcJ3nAqYS0Q2oO++o/fpyF2NlB8Vo5u6PiIQ6ipwZ8y43soA2IF6LicjhrmV1DfHWm0gT8tHpw+zgnzyweBXbm06JkEqysLleHbUmn85WHJ3z0nuLYUyvFFGz2DI8AprEFEfkg86yeiyFvUMJRUMzeaestxC2YwvdHDlS9AHI2snbffkXr3GyVrhsBPZlHRdHE35AHrkxD0YzJnj2JcxWqCn/qM6YmFJehiix9e4l4YcVmRpck5ffm/hU2GKn+k3CsTqo0t5tvoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/q4MwTL1GGdblWZ5zUjJC/mdn+W7OGlbJ9CkYz/V7c=;
 b=PwQgw3W/Qbf6Aa5OCn5jke2a3GkLvxdEutb3PDyfTZotXqbjYlE08N0yM0LoWstiX5Gdojk02EsIrffxyMkNgmVwo3gqW7H/V4yEYHP0GeXIVyDZSvaNfCBJhtQQZSLRpqowZMTf072FkfngK8m1wRRjhhE4Glw1I0LeO8jmrxiv9itCHBig4i+BACt0kHAkJZfSyl4VdH+xP36hRGlWhuztbzoHUbPIbh7tXodVzrn4yIbLbLfIEBmgOswkP8EM5ERT0m7WFrg1iMJmR76FQrUrutTmC04KFcqE0f2pPrGUgObnDhQUgJN6e0aQ9oyPLmGCuuugOM9Ak+kQ+YCnTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/q4MwTL1GGdblWZ5zUjJC/mdn+W7OGlbJ9CkYz/V7c=;
 b=VTXwPVUn3jq/s8tpMeU48IWlV1OYmIT0EE5z+u8HcdILP1EO0169UWVwgi7pTVQMdATtxPTZnqV2pkzEuD20VOQDgTqhWyfqD0ChrDXWvSZzCl6XJC/JImVfbjvzPIffwdB0i1LNmHhOJ241uAvlkAkHJ2NYzlQEO7FK/hPtQLg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7397.namprd04.prod.outlook.com (2603:10b6:510:1d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 09:01:40 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%7]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 09:01:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v3] stat: remove unnecessary bool parameter to
 sum_thread_stats()
Thread-Topic: [PATCH v3] stat: remove unnecessary bool parameter to
 sum_thread_stats()
Thread-Index: AQHYBgCuqz1UQ7u0lUCkDY21cukmsw==
Date:   Mon, 10 Jan 2022 09:01:39 +0000
Message-ID: <20220110090133.69955-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7579394-baab-41d8-0c78-08d9d417d0bb
x-ms-traffictypediagnostic: PH0PR04MB7397:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7397DE93AF654BD8D4E6CC22F2509@PH0PR04MB7397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvUA4Vi8VWYidQOShAi/JLQrLy2VuZ+TkirJgRGsV+3ADReRyHHczIcLZUUZnaDNmbYsvqVrZ18i4cfD51jp4wJlcSkVDFzoOPwV/a55r2c1eGR41hwPlIJmEy5coAwfADRZtia7KWkYSvduYKzuCOyB3jm8D+bIPr7AKpooMZMcKttdYz6mWl4bPD8RxRhV32ndFg6A9RZkvgQdoWyjJfRfXHbqzWbOVl3UIhwbFbB6osI8RJLTHEUYxAR0Cch4z7Ifr3FGukzNG7mWi7PMzcDai5t8qjixZmPe/El85NVp9pEY2+8GR38D5wGaGFgvxbiJzRVCr6CRT2FG+1ivlSJndF7OGZgO5QOv3jQE6esqV/kyHmXXkfWxn9A/VODOI2Srueu41MPl4hBIasrV0lB4hzJzsH17oL5OYFqC//Ai/7bTp86xqp+0kVGLj0JvaYWIlIoLiDu4bNy3nP9ftTGzfF51RadIIPdHBscmaXAeufcxFWg8n0MM4mWgu1xzJ9boQhfZgmJ8NuSL8t37F+Zu0qgK9YyIE3g1/YfmgoDFJSzZbN8f3iAFaxk44bW/kfxQFB99U6SdKusm5qHQtm9fh7VSorFz+Fj8QXvkTeGY6Zc6se/jlNO4DCWZvX/YQeaxMfeaL2C4z64yw9yoB15LDCgHVTEntdGezs98VQYwN5oWtkMjE4wmtvqrQWTa3v3Qfhs21Y+uWFAu+BNmKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(71200400001)(26005)(8936002)(6506007)(8676002)(54906003)(316002)(82960400001)(86362001)(2616005)(4326008)(2906002)(6916009)(36756003)(508600001)(83380400001)(66476007)(66946007)(66556008)(38070700005)(6486002)(64756008)(76116006)(5660300002)(122000001)(66446008)(38100700002)(6512007)(1076003)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?p8N5hq1vFH7UvDM6nMkYdOTpblqQXiA2z6vl/tx5ItNOri4Ptee50a/RBF?=
 =?iso-8859-1?Q?RsFSTR2Ugs9+LPfob3K+b3H0AOoYWt4vGDYdX+k2KLoyD+21TucMDl+3Iw?=
 =?iso-8859-1?Q?oPe5PX7LmSe/savoX4ehUGQfYEzPIbmHTcwcoKT83lyvHgvxAqlQrXCVe7?=
 =?iso-8859-1?Q?29zuBrO4FRONRVIT+emP6Wy5103Yp1p0ORi+ZjaaHqmwfelP2YZ53wZ6Yo?=
 =?iso-8859-1?Q?KUqngcqKH86DqnxAe/NNXRq2f2/nEuKYVmWEj1B8/sJE+040eP8DGDLKKQ?=
 =?iso-8859-1?Q?XwNyzRKODuE2ww3CHTF/lE8DQoayUwlE5Pcti6gsliazvxoLTnoc59QhrN?=
 =?iso-8859-1?Q?cS4MbCFQ3pOUz5A+ixe1ixIE1YRCXI4OdQ/R+Qv89WpjPI8kMk/czV4OPm?=
 =?iso-8859-1?Q?Z4qV9bZD4aMVJYes+icmsxomTTH3tOWEdP+yIJvxAZr0WTIl5YSK9gA79C?=
 =?iso-8859-1?Q?zVdAdENTCJ7gzsD7UxWbMwZlll7BOMVBAkxCB3OLqd4YUrMZqAcFvB8T/6?=
 =?iso-8859-1?Q?/PsR6nf3fuz4BOtKGG1YVdBtUAsfd+CcXq/c7Cz4a+2Wq1lRPHqpHipO/6?=
 =?iso-8859-1?Q?xrsdRsEpbmeJ6fw32frIQog43ZOev58UbJYM81Dc10k9CdAbZV1zf/LPdC?=
 =?iso-8859-1?Q?ob1IzAUHEvV34HOt0CfVBhit947HQdcHd+1IGg6QoZRyqWeQh11brrdQdH?=
 =?iso-8859-1?Q?iS1DJ/ilWmOB+8bS4GmBugcmjL1KHPOp7Ttl+oSiATsOMFXd56ipDnV8/M?=
 =?iso-8859-1?Q?jPBlgi5kPEgXRyT8rqjItSWMR5s1UHgWn221UjrjJUQL+T/grM0PSxjROV?=
 =?iso-8859-1?Q?yG5dpdOE0DwlclPNhpUoitIXWgyn0r554DF4RiRD246ePuS1gSaE4vGNIa?=
 =?iso-8859-1?Q?es//R4wQKb4xrGemvmzaA7EoMCQmAQNqLd5ujf7OrChVhPII3Tc5qD34AK?=
 =?iso-8859-1?Q?ZyGc/CmwHG9EDAy/7Yd4VKhw1oTiYgY/avAQ8qT14DkLfXnIa66l6/YMwU?=
 =?iso-8859-1?Q?6yiuxaeQNSsbMwwe3d/a6ivXjQhTR/h+813sGHYAiTZyct6fwbnAdPCVoh?=
 =?iso-8859-1?Q?+UxRzd7LoRipd+wR/RfwKO2H8QUajmFBemu6ZF0D8pjpMMJaTiZ4KHrifO?=
 =?iso-8859-1?Q?VUUw/zBRMpO3edCQPQclGjnuGAiFDfe6Ba91psG59huy00XUJvEq1OwAsl?=
 =?iso-8859-1?Q?imXlwzjGT3CqhJYcOY0jeBUQLAb8PwL8+s+fRRFntc8zf7xNgIc0CIi1Br?=
 =?iso-8859-1?Q?Z9nE00VgFHP0YUYfnJHE2zEiXnRzkHE/M+nuqyUsjO1MMeIsM+eOnN7tll?=
 =?iso-8859-1?Q?YNSAuoHPijRd8BlJE3csvn+thEybPxaDATjnT4JDJy1KNW1RdwEi+AOh6j?=
 =?iso-8859-1?Q?02LSG7lhSGQ7VKpV5o29/+VLgBXnCXbjvXq0fDaxx4XzJnKt+tmCLpDxnv?=
 =?iso-8859-1?Q?kaayfISp727AG3TZ1RjkozX66NjR5FQNRkwfpm75nTOJe3UfkEghlrbiNb?=
 =?iso-8859-1?Q?0D7WUHwIQlR3hg8gKbfA1vmEp6J4pOkwLQ+wFSi31Xagm4JwINjK5Dv0wW?=
 =?iso-8859-1?Q?Ov+Nz+drmwsNl6ahmdYJxXBGTlUEGLNhD3gJFSzkJwOhxV+B4B4hzIyNqf?=
 =?iso-8859-1?Q?QCxmQDSSETaNR6lhWtW5vgEJ8jKfsUlj7j4Su1k8PCv1OUId85YkSyKi2u?=
 =?iso-8859-1?Q?XfR6k93p6h+7665XepA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7579394-baab-41d8-0c78-08d9d417d0bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 09:01:39.9329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2QtfUexa3/WnLcYuht0xvFdgBkCOWRTPJDP13qgRKQtan3NjQc6+57T8ETA0/cGlyIM41XXOyl4my5wxWDq6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7397
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
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
Changes since v2:
- Picked up Damien's Reviewed-by tag.

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
index 99de1294..36742a25 100644
--- a/stat.c
+++ b/stat.c
@@ -495,7 +495,7 @@ static void show_mixed_ddir_status(struct group_run_sta=
ts *rs,
 	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;
 	init_thread_stat_min_vals(ts_lcl);
=20
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
=20
 	assert(ddir_rw(ddir));
=20
@@ -1479,7 +1479,7 @@ static void show_mixed_ddir_status_terse(struct threa=
d_stat *ts,
 	ts_lcl->percentile_precision =3D ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
 =09
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
=20
 	/* add the aggregated stats to json parent */
 	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
@@ -1677,7 +1677,7 @@ static void add_mixed_ddir_status_json(struct thread_=
stat *ts,
 	ts_lcl->percentile_precision =3D ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentil=
e_list));
=20
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
=20
 	/* add the aggregated stats to json parent */
 	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
@@ -2089,9 +2089,10 @@ static void __sum_stat(struct io_stat *dst, struct i=
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
@@ -2141,49 +2142,41 @@ void sum_group_stats(struct group_run_stats *dst, s=
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
 		if (dst->unified_rw_rep !=3D UNIFIED_MIXED) {
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
@@ -2417,7 +2410,7 @@ void __show_run_stats(void)
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
2.34.1
