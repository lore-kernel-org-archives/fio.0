Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF625C433EF
	for <fio@archiver.kernel.org>; Sun, 19 Dec 2021 22:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhLSWPG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 19 Dec 2021 17:15:06 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19946 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhLSWPF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 19 Dec 2021 17:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639952105; x=1671488105;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=dZGK2aQg6V5EaDo66foi9citmks/mMUUGHkTff/WG7c=;
  b=YW81GsMYIF4eYyY4xkr9hDTFm6J6KsDlRxq9i2eIqq4V/3dteT2IFIm3
   B5i0vycasCOj5RNPQtmWwlMW0mE5XlU1LchgeoCMLc/CqMbn8MJqoAM81
   pbiNRzbiFacQSj55AAMm4CnTTEoOULju88TnkCTf9Zq4kY5nriLTDgBI6
   b1f3aluIcFFEMBYYpI/4cd2AlGepXJUgsTLknkxLsgDVaF1Twoo+ZNJyP
   3J7ftFdwwQjRLiCww0E+Qun98P2vDrEq41OB+k0SlAXUlqVxrNLJ7ZwQj
   2ItqXBlWsS6+Iar7wKCE7PugT3pW1Edxwofw5XcY9julswdpKzHvZsMAy
   g==;
X-IronPort-AV: E=Sophos;i="5.88,219,1635177600"; 
   d="scan'208";a="188627681"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2021 06:15:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eugJ2bklLKm7/xXugy8em6djjLq6NZaGzQvwz+m30unBCEdWxfHXZrr58H3r/iPshEiqWYBM7DM+de7qGvybtiwTpx47csdGuwPae136VuxlABHlvvHbtgwBZVhf4k/xa7N7+g6yQ0deKG2CIovjkePMr+pY/yuCCQHMEA7GBFiMrw3FvAGa5+R8pXBpepLA9arCiF0UbVpLnfsOO95kvjvDlAClbmshj8+KUSHwncNjGeCcN1qm3pq5+HzJKMlnwtRLyL8u68NDTLuQAwDjkDLtlV5qE7bYUsvHGUxH9NXAk1pJ6xdEaGZz+Psu/+F0k+T7ews/DAn1DghymecVtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdaLWPCweizg/JO+zaZPEhM8EtWNIlIS5nOco+VPfY0=;
 b=m5ds8buRbijAEkIVCtmxGHDmV8bg6l+LcPnIUB56H1WRNLVI5suAR+k3q/g87f5EM2rMI6yf6Ngmw+TwvJx6z5xBP7C04AjAHKPVssiywyCYlIeVqp52LZQu3fRPN5xe6PG3Se4CvBqHl4bcO2HIdk+gt6W61a61r34PCSUJDa3Lfp6dhE39wnWUz1aFE+Sq4lTEdz4za32y2+oo4dWJG9/gm+8PNFQ5cj4uPVwrXP3iW3C949LCnFR3L3qezNvNnUe6h5NASmwrXOz7admMY2t/Yh4XWfEDH5JoQQNgm4PmG2Qfq8IQVP+VVJfJrgrkwkAwCC25hdynR8Ucwb+50g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdaLWPCweizg/JO+zaZPEhM8EtWNIlIS5nOco+VPfY0=;
 b=NqfQO4qpN6h3VbbIAzITYYnP3JBnJIUTYAuVWl039mfMQhUDpZVoYqiLaj+liLjthgIHkY6F7M/BQo+VwGfy6LmIP6Lpzcl+qlAzrOgKT8w41ySnz3FOp+zKRYo3GUMNZ9nDo99E5IE7a5TyRhenE185ytwEOuocpauuhRfN6Ew=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7255.namprd04.prod.outlook.com (2603:10b6:510:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.18; Sun, 19 Dec
 2021 22:15:03 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 22:15:03 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2] stat: remove unnecessary bool parameter to
 sum_thread_stats()
Thread-Topic: [PATCH v2] stat: remove unnecessary bool parameter to
 sum_thread_stats()
Thread-Index: AQHX9SXex3tjn82/6ki5TlDDxL9zBg==
Date:   Sun, 19 Dec 2021 22:15:02 +0000
Message-ID: <20211219221440.67551-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9209d31-eb24-4a0e-f46c-08d9c33d0157
x-ms-traffictypediagnostic: PH0PR04MB7255:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7255878A27B3D8BF40256305F27A9@PH0PR04MB7255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPf+7Mw/LQvIKpW9hFDBnISBYi2C5ff6FDoQXMfxA45TfhG0RuB2IQ2P0mXMtP6Xg7kpdSgqUMAbbQaIx7KTJTXhGr+EHhOI2x6L2q0GMSbxTo+FhuT/TmIQDZZomtXFFOfpxov49X4XOTXnur/OP+eGrnwHtMtObtPoa9sp7CkKjb0SnQ3nl7SYUyxgH55SJKcbhh6Kt6YJWKhuOsnHBoLFcSPjryWWco9tSI2x5aOsuXWNiK58PmDzWaFNrxbkLcVlmuzDU5FKmXrIrZzfaIRS5uMdRGNGwucWZNTWwZriU2JhPyncXhhdMFlu8y1HkYNhl+6nSD+dt9t+uKeSSt+u6Wy0/sw3Y2q+Y3bbf+6d31TTDnBSuP8pleLKk6NVTVhsbWs+8ucMgykng6eSv0c+tfqcxFnXbn3zoD3FdSS9vO/T8hJxbPtafYxFEywUg4TW222Z0pDSsubfc3AqX8JKFlyyuOc1egmxj+/w5EO5dinQwlh5FoUbs+Gko1NQrNnNkKr/qa/YXJsDOlhx5GoyO5rASlVR+7mzFwEnL1eQutIN69lg61WSSjKf8KWW1vZQLf5SquCeyIZMUVtOvnwF3eYv3IK6hNPelv3JMNoXizrdSsb2FR1uT9Du7DWS3KIjrDKkVAeV6e/SCc97OlxQq9FNAIKoLV8ePIK8Q0k4vHLUv1uiUaR2B/1Q4xQsGIc+FulLTTMp0JZCmi0JUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(26005)(6506007)(4326008)(508600001)(2616005)(316002)(186003)(2906002)(54906003)(6512007)(71200400001)(83380400001)(8676002)(1076003)(64756008)(91956017)(122000001)(38100700002)(86362001)(82960400001)(66946007)(76116006)(66556008)(6486002)(66446008)(66476007)(8936002)(5660300002)(6916009)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?E8GJQFFKJGhF3Bm+YRS5bVMwmbRJK53Tneq+du8uCUK8Damg7GVVD/mmtp?=
 =?iso-8859-1?Q?cEaeF8m+pYpYt2CsIMrlnVp5ADvSEwLwT0jcUdcs7nLnbUAh9fCxn8pR8s?=
 =?iso-8859-1?Q?oAOy2MzY5s8n+eslFQJt6AtXxLGNnhzlSjjb6j6xL9b5j5RJr+djYoQCAw?=
 =?iso-8859-1?Q?s4ptMmipYPBbrgDzWyt4GEBp5YLux3fWppz7CIyfK35q7ClGl1Wi1lVqPm?=
 =?iso-8859-1?Q?+HkVMa0llY+CxcegOEGw2wsTQD7yrHkUqae5iKW3phPdnRFSslAqgg8duA?=
 =?iso-8859-1?Q?mueA6qAOqO+Bmlnm1Qi81/3ZKkmCKD7vcqPopkDGeUxaCSB9oWNmTy3Kgy?=
 =?iso-8859-1?Q?hCVZWQR7ezKqL8qp0JbtTrC0SVcjZwiBiuf1FJ0woFam75bIHFy4ymcIYb?=
 =?iso-8859-1?Q?UXLpV+do3jW0ld4sThTn1qs0wes/gdqIF4ZFeNTivzXJgDHxEDmrxENHU6?=
 =?iso-8859-1?Q?VAAbKmyXobSXXKdjNAoRiOkiHaCRXarHWvz4aVnsSkzUN5KWgGr8xLEk7T?=
 =?iso-8859-1?Q?lL7tKQUUl4Ria21rSQEHBVXG+tIqksj59cgDtjMnsRsCVZW+QixcolrVw9?=
 =?iso-8859-1?Q?qP8agUuvZKX352yxRuCo1A4Rxs6LOqU9IdEP04u5F48xFr/GKeGlboAMAL?=
 =?iso-8859-1?Q?w17jYUeiOMwYhw/7n/XKH29qIOv/Kw0XGlqVzmkfmtoGO9+fEd9nONTgB/?=
 =?iso-8859-1?Q?uCJRROnpsjaSvIs+eg2HUgzB5GrYMN/X619Po1gGUQHxrPGIw7Cz6uHDIN?=
 =?iso-8859-1?Q?nSuqD414gak+Kz0k3hDI+w6YQmPOZ6RQqZX1Ldr9IJkG+dVS4YqzKEIB+C?=
 =?iso-8859-1?Q?6fa79nUjvlrRBzXVA/j7XwmMakgnnLNeszSc+UMX00s3ayTAd1cNdeaefV?=
 =?iso-8859-1?Q?gGQm5yyO5B+JpS0U5M8YpwWC17ktMpHlaK3BYyk42jPBNhU/yBgb8udWod?=
 =?iso-8859-1?Q?TkIm9HmtQ7Ybdx7EoN3dgFliOA9yTTMWmbvCzOYiLCUA/7y85XYl5FfuJV?=
 =?iso-8859-1?Q?Rf8v84uPyfNc82Mq0pi/zqOoasCE76cj64yc0fJ4vTlpc5tx8+sWPwPvZk?=
 =?iso-8859-1?Q?VlY+K/rIyKU3KxF4UhjTh/MDI4vh8DuM5kfcjeMCw4uTw0UrVikEKw4ciX?=
 =?iso-8859-1?Q?hi7BzpfnxmB8S7VoMXmBZcwezNiD8tvo2IYzBAOpZ4slPzDtukN5D9TpZL?=
 =?iso-8859-1?Q?awH05pziGY8m4cLTAYH+d+9IGg9Kc2PpDGP6FlRv0oAqMLR2mZ3vT3Pc7h?=
 =?iso-8859-1?Q?6lf4x1uWUIRZL/HFFPcws0hjxszQoh1Z9APoqk75TuvLMFj7gRLexqQr3u?=
 =?iso-8859-1?Q?2Bu/vMMxxvOXL+WXTGc5ysfc94Oy9syARysRk5sYAg/7nr4QznFps+Allg?=
 =?iso-8859-1?Q?HbOpYU2arlJzM1Zg/FWih3zbgwQeQPQ0wSGx5Ac7IdexqPwO/zFJvtXgXg?=
 =?iso-8859-1?Q?fy3XHxm+VbjCK46GprXVNzIAIf/h2Tv3Y0b55+EoDhdiUNyCxKbz1AIXa8?=
 =?iso-8859-1?Q?b6sxksdFpCRksm8HfnLOMHcMEzFV2vU9hHoz0oofJvILUdQfdk/mbdm1ur?=
 =?iso-8859-1?Q?wloW4/6ly8pH9tIEmG+2EOE3s4pakF9Kay/5wu1V745hrAWwh8RKekx+DT?=
 =?iso-8859-1?Q?R0SWE+v6bvbyaNBaSVmdREb+Vw7ouC2h0n26PxtQgiYGcFFhOvEEnGi3yg?=
 =?iso-8859-1?Q?diJ5M5TQ7gEV6gE43a4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9209d31-eb24-4a0e-f46c-08d9c33d0157
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 22:15:03.0896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QrTwELoWGQh7AUqazE7EF7EGfMc1o57eG0eRrfYwtQqZrNJNzmItm05azGs3Kp80e9cwa7X+mDB4CwMkPl7VKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7255
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
Changes since v1:
- Rebased so that the patch can be applied without conflicts.

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
2.33.1
