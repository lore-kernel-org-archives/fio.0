Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90D2C433EF
	for <fio@archiver.kernel.org>; Mon,  8 Nov 2021 13:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BB8260E94
	for <fio@archiver.kernel.org>; Mon,  8 Nov 2021 13:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbhKHNO6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 08:14:58 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5985 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbhKHNO5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 08:14:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636377131; x=1667913131;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=puhfTSmX2LGcgxa6GyyDnMInnGX3hzug8WhXMf1+QyM=;
  b=ajUFK04GPyy3VJIJ749CqWaToOQuYtJ3zZwAJrHKiZ4gPc3dDBiZqfiG
   fUskYGBgTyMJxfLMr/GlV+cOuNJyhquzBfqfp9U9JS9AQE2PgoA4Qr/Sk
   W6jTvTh/QZhkyH6gfFQBOmz2dLxMuoZ/vt/iHLLTaB+2a3BjL1rurU8Ns
   MTW9SsITpBAY0qZkfseEOS/UjgtsND1XfY+p2vW/MpUtjKFFIvypGpm4r
   ejCJf3z1IneSOyqDJ1KS058j42kZpHboHfB/VmFGYdWNRVUy2r7GOKvBz
   8gSe5zzaDI1FGohaRvhOVbBIhy0I4UHFiG244iyozgvVa92Niw9VTrS2j
   w==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185019222"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2021 21:12:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGBqN8xIEGIo9k92llQzWZm/S97JL5YuwNDJn09lneV1Vuj3tC+m8UtB7vjdJvDXm5NVYfoJoVxnrV0nLKY9Aal3kJJ5Tp+ANCHZ1uLQ85B1Jko3hkkzwChh5tDMZ4ZJW35LbdRdP7Hx9OMGgl2LJBTcKX12f6/ZAIt8YKvFxDfPq2F+kTCqj6XNV978BAadCfs6FJv2juLaXs9RCqshqh9ws6WCh5Jk20JcYap+3n5GXESiObibyrKoO9WKdxTHi+Ii8yw6Y9i/8RsB07U93nFyq4MRjbKizRVd2OH6ijGB9vpHIkFwMeiPDpAYvuaYTKYdgRIZ7u7T7jTO6cuZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnQ/So5cOv47yRkRi9zR1peDaDYKhvm0br+/tDZt2SM=;
 b=WUXEP8eV9wvLck/i3qhXk7lp0ghg2hgZtDLoG0llAYlGN5aYBYyKDtFam0pXXox/ewhH3qfRY0iI/PEz+ALVTp6DFU+nw+kA3Q620NwMKEoU/2QzhWfZX+Ez77WWKy6mk60k9fjV+zdca7VEsyDbz3Joq2gT+AyXNPvT2OrOD5pHEwm5CmklvIkxYtXPmucJLlGf7tNQCwhVu36sJKpoWBKDSK1FwcWB6mKTdZQsuWWv4z8uilYQS1EFSokWdTGlywgBsTzOTaTtHBrbiGibB5yXXMFDW8zB5qBFOBBsrczAWMAZLLz9PQ2N++KJeRyIvg1P5MGXXoYCI85nuzsoAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnQ/So5cOv47yRkRi9zR1peDaDYKhvm0br+/tDZt2SM=;
 b=KR9Ow3/UKB5mslMFHU3SneoEXjhdKi4IbIiGtyy9d9QjXAKagpFMlvGmwGcgD0RwbVCMVc5r/NIPh398uEV0g0O7UjCj/HJG9A+D+7wsIvgeYFFvbRdVlSQ9GEVOevyVwFhfagUQJEDZwgW4vDJ7bc3vKNvpfysYvmltEGfIJS0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Mon, 8 Nov
 2021 13:12:09 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 13:12:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] stat: create a init_thread_stat_min_vals() helper
Thread-Topic: [PATCH] stat: create a init_thread_stat_min_vals() helper
Thread-Index: AQHX1KI83AMUEaJ6f0qlKoev9hIImQ==
Date:   Mon, 8 Nov 2021 13:12:09 +0000
Message-ID: <20211108131143.80158-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 772b5f96-188c-4a13-86f0-08d9a2b95f00
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB758902E6C6D6915B46ED5F99F2919@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WWji3avtcK8ahSrWPSL/SEQzV0gWFisdQR5IsLBXno7CyxIWcoAxmdKliCcIyDOr4UoqkdSaNXZZzvi11m9/yJVeGdmzLvNRK44t8YSRDl0QEETicQ1dMLDwhcu2y6udXLAeos5UDL7UHwENCw+n7DERsep+qfBv5s6sRgQdgzZ5kfsBefff2K9GMEcIOU3GhCOjrUbaHSCYFZ+Sl5MPH9EHn9hSmMoOZTKzGfmRjkff9NxlcjD5ve/xhK06d/LRiMVKosE5oz+BKZ1+NvREinPVeQElnlp15n1xPx8F3uypDDxLhpaptUM8o7IhePyzIFUAxJZSNWdLRiSIyI4GWFfSn2NtPhsaGxBkenP+CPB9qCbtHw9jXFnJznzrDoFcomWotBbSZkeO2nl8Maph4yOQZT4+YBOti+yTiW8yeYxLeKTPzneeDp61JICcxscwQjIw0w7LR2z0UzLkeOGAYRyolF2iuGk6JQMbIEyf+TZGfBFiJww9M02KCcBDxGoDnUrtvjZUGxVraANdZUF6SIFNxTRntKxbpOaohwukTQG+nIlMb/atEep6b7p+Yekx1gzexkEi3wayugWoO9Yqrb+5f89UnSkFil7IwPNZsL0PZJfUNzOxhtExzgPn2/023r/iNANdL0pKtzBPU4WZDBN1JGcDbv2pYD60dR4z3FvC/OQkzuX05YQ1bPU/lgShCcyLKgQU+uQbPnC0+B/KVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(38070700005)(186003)(2906002)(4326008)(64756008)(66556008)(82960400001)(122000001)(316002)(6506007)(83380400001)(86362001)(2616005)(38100700002)(71200400001)(26005)(66476007)(6486002)(6916009)(8936002)(54906003)(508600001)(8676002)(66946007)(1076003)(76116006)(91956017)(5660300002)(6512007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Un9E1ybnFZ56tDobxmc8h/UXRMDuGqPDxvkBd6u9H8Va7ixeB4+vTAFf2p?=
 =?iso-8859-1?Q?xgtq1fF4+/ZJ4d4sLEJoYgQRtmKmccLAdmi0C4nnnWU9RKDyEvKsRZ1B0X?=
 =?iso-8859-1?Q?8UBoK0kHgoht/1bQtnwouk19aeMdrlQ8g/1kn1j4XDekAWuO7fIwYJ0cUp?=
 =?iso-8859-1?Q?OD1EAI5oGpxP3IsUTLwXrVHI/O1uZ3uIvT+9UEhZsj/ZpqqypUKZLxC7Vu?=
 =?iso-8859-1?Q?4u6nluO2ZnebbDKN5vN+HlR+q1/tJcEOH+Uji5HocC9QbcDe/tLwQ39GgZ?=
 =?iso-8859-1?Q?MNjzISlErbLaKmc+yBTCmb8SxyIreuyJtxytUgzBG9KBZmJMrjKsKuv97m?=
 =?iso-8859-1?Q?dXj6aXrk3S6jRnxsrPe/XQwPFuYtNe0ns2QYcYTqh6aRbgTPqnu1jc94uD?=
 =?iso-8859-1?Q?6H/xjO4b6gyE0N5C6HZkpDD7WqEEA5gqUUG8hODxPVBc7C6W+ER6mAaClA?=
 =?iso-8859-1?Q?u8PP9E5tJlOpl2lOx1iMaXCYrIZnMx2SsWXFHdTTWPMicmyaBnnNg5bysB?=
 =?iso-8859-1?Q?zVDo3KgKsapvLJpiRu2DDzrkzC91aQAg9TEywibeiqIS8dMHazFZHLh4mw?=
 =?iso-8859-1?Q?RiqWfIFlP70O8ogoCTTBvRr2Q6OL1oy7hWcTDo6apsGRKdXkRr9i6A9xvZ?=
 =?iso-8859-1?Q?GZFeyB8Djr1SB9XKRvB5Pmhtcr5TaowlgVxWmdUh4s72IJlc+0nXvcXthJ?=
 =?iso-8859-1?Q?Rd3HMrswcOsbTPKyjPRUqlTVySoQ/xBaMNCc70YQ7kCWE3iJcFXmbSrEV2?=
 =?iso-8859-1?Q?vHw1mU4IVzkRctstY8OR4HMpNz53ifXPeNc0iLrOUEw9/RC7avKg4ozEd3?=
 =?iso-8859-1?Q?TcdO+5mTgQ9M59Zn+HHwvrgI6/MvNRV6OeXVXsyVXywhEB0l6VPNa4I/wt?=
 =?iso-8859-1?Q?SiufDQvCpkKIQ6IMZ8fbCuAcrtrrfE9GSo85T34P35NH6Puegl3XnURIbr?=
 =?iso-8859-1?Q?E5KCZ6ZHxQgre+2nmfAzvlTbEmKIg25/N3SdE/LRerQv10RZps+fdZ54e/?=
 =?iso-8859-1?Q?QVWX8WML/GGVd+kLbLpBPzY0kF6TBRzeukQ/dPpoHRVYRPBPvu5cD7mlQA?=
 =?iso-8859-1?Q?+Xn1lCCDS3PISPNzxr6QrDtZEDD4pEF1wW4QW0OTOMqD1nVJh36GoSMXCR?=
 =?iso-8859-1?Q?UnATsLOn5FoA8y/4f5IRsmVmWmN5LYjCXW784zKWO+5hFlXb3RxIfWclp2?=
 =?iso-8859-1?Q?psH+e6Z9wqcP0RAdJAwZ+S/GA4BnI20VnACuYUZO6Uh3hlJOl7AmNUR4Dw?=
 =?iso-8859-1?Q?jqsWaifSAaX6uPHTFqVJMGEpHH7dst+uFxL6d3pgK5rhrCLh7wkJ4zcB5+?=
 =?iso-8859-1?Q?Q9YMVSRSMT6tpJiSKjXUiizOB+EUlypCP4+8wXYSBVtATf8sWLV7Q4X7Ww?=
 =?iso-8859-1?Q?ER0wzcCkR/5jUGlQwKxcUZs0eByvHbVx9+022WJp85V6T6m41F2qUU7xNh?=
 =?iso-8859-1?Q?FyNbIulL4qr0cjM5HdG2VjaKLwIT8Z03bFHm8+rntlnmXKLD12+QPK7hcc?=
 =?iso-8859-1?Q?Fj62HcSF8PbdwSphNq4oUdcSoQfehEssllgz84sTgLuehUJEkLuKyTWwsE?=
 =?iso-8859-1?Q?X/4+nrdYStK2PrQF7gFY2LslKsqmmhX/oe0bKF/Uw1M7X71Qb4HddSw4yy?=
 =?iso-8859-1?Q?9WKjuiutTd9628pwdPAuc/Neg/6dnK5pe9lSdyRe2Q3CosrlzfuOgNeNtR?=
 =?iso-8859-1?Q?5AIdacdXDHh2jVfngoI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772b5f96-188c-4a13-86f0-08d9a2b95f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 13:12:09.4900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NQVE+4q8TBDycuLmD30rpmK7SjThJ8OtPa0aesFU3U57AQcZKJNswB7Kzze2JvXXZGmUUZLs+gMedgveIeVWPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Create a init_thread_stat_min_vals() helper so that we can remove
duplicated code.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 init.c | 11 +---------
 stat.c | 66 +++++++++++++++++++---------------------------------------
 stat.h |  1 +
 3 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/init.c b/init.c
index ec1a2cac..5f069d9a 100644
--- a/init.c
+++ b/init.c
@@ -1548,16 +1548,7 @@ static int add_job(struct thread_data *td, const cha=
r *jobname, int job_add_num,
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_l=
ist));
 	td->ts.sig_figs =3D o->sig_figs;
=20
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		td->ts.clat_stat[i].min_val =3D ULONG_MAX;
-		td->ts.slat_stat[i].min_val =3D ULONG_MAX;
-		td->ts.lat_stat[i].min_val =3D ULONG_MAX;
-		td->ts.bw_stat[i].min_val =3D ULONG_MAX;
-		td->ts.iops_stat[i].min_val =3D ULONG_MAX;
-		td->ts.clat_high_prio_stat[i].min_val =3D ULONG_MAX;
-		td->ts.clat_low_prio_stat[i].min_val =3D ULONG_MAX;
-	}
-	td->ts.sync_stat.min_val =3D ULONG_MAX;
+	init_thread_stat_min_vals(&td->ts);
 	td->ddir_seq_nr =3D o->ddir_seq_nr;
=20
 	if ((o->stonewall || o->new_group) && prev_group_jobs) {
diff --git a/stat.c b/stat.c
index 30f9b5c1..cd35b114 100644
--- a/stat.c
+++ b/stat.c
@@ -483,22 +483,13 @@ static void show_mixed_ddir_status(struct group_run_s=
tats *rs, struct thread_sta
 	struct thread_stat *ts_lcl;
=20
 	int i2p;
-	int ddir =3D 0, i;
+	int ddir =3D 0;
=20
 	/* Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and Tri=
ms (ddir =3D 2) */
 	ts_lcl =3D malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
 	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;               /* calculate mixe=
d stats  */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		ts_lcl->clat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->slat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->lat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->bw_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->iops_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->clat_high_prio_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->clat_low_prio_stat[i].min_val =3D ULONG_MAX;
-	}
-	ts_lcl->sync_stat.min_val =3D ULONG_MAX;
+	init_thread_stat_min_vals(ts_lcl);
=20
 	sum_thread_stats(ts_lcl, ts, 1);
=20
@@ -1466,22 +1457,12 @@ static void show_mixed_ddir_status_terse(struct thr=
ead_stat *ts,
 				   int ver, struct buf_output *out)
 {
 	struct thread_stat *ts_lcl;
-	int i;
=20
 	/* Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and Tri=
ms (ddir =3D 2) */
 	ts_lcl =3D malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
 	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;               /* calculate mixe=
d stats  */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		ts_lcl->clat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->slat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->lat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->bw_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->iops_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->clat_high_prio_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->clat_low_prio_stat[i].min_val =3D ULONG_MAX;
-	}
-	ts_lcl->sync_stat.min_val =3D ULONG_MAX;
+	init_thread_stat_min_vals(ts_lcl);
 	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
 	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
 	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
@@ -1668,22 +1649,12 @@ static void add_mixed_ddir_status_json(struct threa=
d_stat *ts,
 		struct group_run_stats *rs, struct json_object *parent)
 {
 	struct thread_stat *ts_lcl;
-	int i;
=20
 	/* Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and Tri=
ms (ddir =3D 2) */
 	ts_lcl =3D malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
 	ts_lcl->unified_rw_rep =3D UNIFIED_MIXED;               /* calculate mixe=
d stats  */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		ts_lcl->clat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->slat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->lat_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->bw_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->iops_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->clat_high_prio_stat[i].min_val =3D ULONG_MAX;
-		ts_lcl->clat_low_prio_stat[i].min_val =3D ULONG_MAX;
-	}
-	ts_lcl->sync_stat.min_val =3D ULONG_MAX;
+	init_thread_stat_min_vals(ts_lcl);
 	ts_lcl->lat_percentiles =3D ts->lat_percentiles;
 	ts_lcl->clat_percentiles =3D ts->clat_percentiles;
 	ts_lcl->slat_percentiles =3D ts->slat_percentiles;
@@ -2270,22 +2241,27 @@ void init_group_run_stat(struct group_run_stats *gs=
)
 		gs->min_bw[i] =3D gs->min_run[i] =3D ~0UL;
 }
=20
-void init_thread_stat(struct thread_stat *ts)
+void init_thread_stat_min_vals(struct thread_stat *ts)
 {
-	int j;
+	int i;
=20
+	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		ts->clat_stat[i].min_val =3D ULONG_MAX;
+		ts->slat_stat[i].min_val =3D ULONG_MAX;
+		ts->lat_stat[i].min_val =3D ULONG_MAX;
+		ts->bw_stat[i].min_val =3D ULONG_MAX;
+		ts->iops_stat[i].min_val =3D ULONG_MAX;
+		ts->clat_high_prio_stat[i].min_val =3D ULONG_MAX;
+		ts->clat_low_prio_stat[i].min_val =3D ULONG_MAX;
+	}
+	ts->sync_stat.min_val =3D ULONG_MAX;
+}
+
+void init_thread_stat(struct thread_stat *ts)
+{
 	memset(ts, 0, sizeof(*ts));
=20
-	for (j =3D 0; j < DDIR_RWDIR_CNT; j++) {
-		ts->lat_stat[j].min_val =3D -1UL;
-		ts->clat_stat[j].min_val =3D -1UL;
-		ts->slat_stat[j].min_val =3D -1UL;
-		ts->bw_stat[j].min_val =3D -1UL;
-		ts->iops_stat[j].min_val =3D -1UL;
-		ts->clat_high_prio_stat[j].min_val =3D -1UL;
-		ts->clat_low_prio_stat[j].min_val =3D -1UL;
-	}
-	ts->sync_stat.min_val =3D -1UL;
+	init_thread_stat_min_vals(ts);
 	ts->groupid =3D -1;
 }
=20
diff --git a/stat.h b/stat.h
index a06237e7..9ef8caa4 100644
--- a/stat.h
+++ b/stat.h
@@ -327,6 +327,7 @@ extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
 extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *=
src, bool first);
 extern void sum_group_stats(struct group_run_stats *dst, struct group_run_=
stats *src);
+extern void init_thread_stat_min_vals(struct thread_stat *ts);
 extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
--=20
2.33.1
