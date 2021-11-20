Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2B7C433F5
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 02:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhKTCL4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 Nov 2021 21:11:56 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45637 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhKTCLy (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Nov 2021 21:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637374132; x=1668910132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0z/f8+fIGQPHzpQ53Y5AKYqVqdVaakBRPxv8OAC3B7w=;
  b=U/s+sYVlxOLk97zY+W4TdkZBTF0IrpFBpsXwd7jYDfPzX6GXrzcV7mAU
   0FVAWKYo6mPGYAqv/Oa9+qxKS/lq1tQefADxyNT4PxEsy94vQLM9BWb6y
   8ORImxyGx/dWbFYdFtiEtO8R7e0CACfSQwQ/5MxjDFFSxYAcs0R+W2KgR
   0KgPr3NSblAXVn27zK4gCFNEqtG1I+5OJ1d8jSggqWMPs9msCqIBPnSu0
   wtZME/OFd3RW2Rx+WQaxPw9C4pP36hZYPbauaHAC0c5v6h3xww7ZYkhrm
   QHkvEk4OOxFon4hhqMeAnGTVrtWsd/juwyCOB4V7Ajll9dP8OglKrgjjq
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,249,1631548800"; 
   d="scan'208";a="185149905"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 10:08:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRQZvZX9sy4B1a8G/9BTDY/pOprMTlCZkSupfv7d4p1ZlligMVAvgVLNILBwGqfQcugqNxYfA810CpgdnVQvY5uVyRKyMwqGfYMSs2CRA3KChdJicGIQ1Ejbfk2xCsvhz+aquGvVxJsON+wEzzuKQm+AmX6PmKr4iY9ZF/+2AEB5ctHIwxuuKUtV6sCMU1vy69L+Gcz5S4caLj7iIrJPmgDxJwTy28ZETqYHvRn1Hd/KQmy8WG4Xg2DcBRaidn3ix8EwKs3l+53LYtjaRDv5xutkDX++b8VFuI3LJaa+RLYQmjsUojlINkeQc2hFmtAadQyT7DCobJ0LuWtPecWtTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FrBXNLUm3yMtfw8O0YC0XOBfnuF7y5Hb0pS5FZ5jsE=;
 b=haqjQBAXyspPAYZVoWVdzBZ/vdOgedkNjt3QPMhMEJLeZHNH2bF0Oo7IHYCbNfqgPJpgqDuIynCjuCji0O8B97h7iBBRH99eUXo14oat4Wm+FEmfEoWntVbQ3vt/nJcOcLJij2Y9xrHdC4PnYVW+0lJ2ppXyNaz6Pgt5HmJG4ap+b4Zq1+fNEEqvUjvxvOGKEe8NmaGeu85AU/RqH69B+t3efV+ApdjjSGNxuhqGQLc+TPJc4WtZmVesNELZYxvYAE52/WpaOjmS3+mmNGkGDdRqFEBTcjRtxS7oE88P5N8kB784y3RzH4DPH5k8Ri2g2q/IycK/33yVGJzSR9BYrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FrBXNLUm3yMtfw8O0YC0XOBfnuF7y5Hb0pS5FZ5jsE=;
 b=mJFynALHcvWO7b5CVk+L7WYw23aowBwpZML6S6o9fHSFzK52Zmjycj5BgkxTog9gUHTYGXuCgOrVH4K0ZSlLCQjidoqr9DA2RC33AMfpAb4p73k3ibjWf0WFEF4AVIWbOCwEVd3eKtEmJaJgWCe9YMJpMnWaECkKBJwTqLrruxs=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 02:08:49 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.022; Sat, 20 Nov 2021
 02:08:49 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 5/5] stat: add comments describing the quirky behavior of clat
 prio samples
Thread-Topic: [PATCH 5/5] stat: add comments describing the quirky behavior of
 clat prio samples
Thread-Index: AQHX3bOOttdDQ8a5ZEeejDvIb2Nw0Q==
Date:   Sat, 20 Nov 2021 02:08:49 +0000
Message-ID: <20211120020837.127453-6-Niklas.Cassel@wdc.com>
References: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b22b70f2-febd-407a-7709-08d9abcab12f
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB7622E751995682737E1590F2F29D9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XwncDdA0eC5Crw+P9BWykTE0LL4iShM58BF9PFdkEVvm69RxBE1ObXXG2R6ZPm28XlelTdeJkoO6kGeks2uH+dhTelSfgsANw5EVxjgEgs49QoLFvuwmQ+ql7ye7Yq2eP82oMD9uQSI9rtHbnhznuIKW1YZ5iK/d3SboEYJaGHD3qIUq6I38slogbNsoY1nucv5flGpwXfo/MgVyYU+JhUMh49XFj9t5RDNSNs3Np8lGxQZnB0F7H0JOUS6aNCZ/2XYEWrfOllbb2RWURug1vQVmu+NeBwp1WDZDNuKduDRcw+4qaXYYJS3Sl63O3W5p3oFBVElKy8Utu/EZsbfuijGFYRX8FJNbWsuANPYDkSSD0gn5TrGEce6JNU9KHqFJ97jMwOSnuAcfu4+1XYiX92R8FTdpN9birVZAcS5vX8VMWiHn0mrpDcLbSv0J/8T70Hz2XJa3ykHzZoPpS8I43Ap6VR4NpMqfyZrMU+OM4UIqgQ5l9BW+i0DG+is8NSJYwHGApYVhLD6FPFHyOTOiscF3QonbnKSzkSZwc3bqicRnR2J+BbOwrSmpi91pmCD6wzxfOAouZG/tvjcPq0dMmYAaB/CxCxaxBXQdlztEfpeCbzd0rdx7eIr9zP5DpSqqp+3ImemX8LHEx44vHCPkYiQ2XasZ4mizjKmeYQ/Xaixf9nNxlQLBbKF03mCB95iUPI2Y4F1epXtwX0cVhPxxwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(8936002)(4326008)(38070700005)(8676002)(1076003)(26005)(86362001)(2906002)(91956017)(76116006)(66446008)(66556008)(64756008)(5660300002)(66476007)(186003)(66946007)(6512007)(6916009)(71200400001)(508600001)(316002)(36756003)(6486002)(2616005)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fHa+J4os/uoSTii1RUwcLcZpcEsjc7T518K0qP3zIl2zoensxDKWu3V7lh?=
 =?iso-8859-1?Q?JqtnyyYfUfXZKXsBsg0g7WneHyePpJ9Lwm/xm6tG2oKhSYUmzFKa8xAAyV?=
 =?iso-8859-1?Q?8WHCCZpNjDD/vY6vZhnA7iOj5c4nnzRLLhlSIgBAZBNkU0SJQlR8zKeB4J?=
 =?iso-8859-1?Q?YeKbmQHprh81X2OK+r5VRgYYwJ1VgXPH0YOPR2LexP4X6iWiHa5hAzx2s9?=
 =?iso-8859-1?Q?cl60uq+WVhHcy/xG0+oCVawn6c9+CLXuM5BI3HntKNHH3OhfHRRPzFTKLA?=
 =?iso-8859-1?Q?mF/K6p0Ib9b6CdyqaafCC6EoV1ppEkDpHvf4rVkFgehCAGEvhxqy8luM9y?=
 =?iso-8859-1?Q?fxg0W2/81/S/IGn4ly4ax8MtcJefoMJChmW/FOQDMzRowH0q+iRag0njmL?=
 =?iso-8859-1?Q?yvF5Paib7bxJ1FyifZgQn/g7zRqJ5votgSJl1fwTygpofGM0HdMFtlh/o8?=
 =?iso-8859-1?Q?Fg0/IUCXkEzPCZDHJgiYvfKlFq/lfo2Go/V6Jr5GqvlbPddAwq6Vvgi6/u?=
 =?iso-8859-1?Q?BFqNEYD/x0dHmpMgrV2mv1zgr86Vd9H5fYGePlDrp45NFhHqy79/vyQGfm?=
 =?iso-8859-1?Q?8zyHAKZgpGAmtNkXzApJimfzZLTlIMaOwTpLOHB6CLY99GYj3+jw7hr80Q?=
 =?iso-8859-1?Q?MbKDI1A6kItnOuPBwjGWTgAm8bkceG8TyS5rQNE4Vn9RmAGRXnQ1epsMPM?=
 =?iso-8859-1?Q?OtjbDqKabnWSbQ0hH58eUS7459uU0/woOdTySMjNkc2gElV9R1RwEQNcAe?=
 =?iso-8859-1?Q?0+Axu/yxml6lZHRVpc2a2OWYtyJcvkPx/8E0FPWcmivyEYbnuDwgJ/2JId?=
 =?iso-8859-1?Q?iZOCLSZ6OyboDKOGCumztqwDd09RsoYZIZiNsAk+osFahE7fo/elkFF+8k?=
 =?iso-8859-1?Q?3Jw309BMut9lra3wf+vRsAURqE8GM9SRNChLzey5d/lB3fZjg1ksRXZW7F?=
 =?iso-8859-1?Q?dNKfGRVdmttAXzijkKCs5a4pxu94oWg5bucZIqqDJBlSlubdeNJecLQwDN?=
 =?iso-8859-1?Q?SAg/+93G8S4J6Ezb84hmdSeUzjGf26DP0VJgJVZ9IB4mWy3uWhCWRSc8ij?=
 =?iso-8859-1?Q?g4J3IP99IzqMevSlowthU6Al77WGXdPXjdl29NbG73kxs6HNklALXmjLXF?=
 =?iso-8859-1?Q?FHuxzpMum0BRZ8sCyIprTc3xYlmYa/Zt5XTB9iPNAddURYCDJ4a9DFLDhZ?=
 =?iso-8859-1?Q?BZDHn1ieiiWeosFimUkJ4G2A3dZifUVdoUxFzf4Z2GdSscv1At7QwtbGp+?=
 =?iso-8859-1?Q?r8ph9763ZayvBFG67G2n47LMwc9hKrb6pY0p9wnjLeOkyyLjVcfPjjc5wJ?=
 =?iso-8859-1?Q?2FxErOT3UB1owbPX3MSySkmzOAnjBNX/fDHHIeMuPisTOTqD83ufeZ9AWF?=
 =?iso-8859-1?Q?7mv7dplPnXo1LewVrAXJ1juR7guKx5DDxWv00hIFVbEnxQ0uVz7735nsZL?=
 =?iso-8859-1?Q?SFLk2gtSMzEozAPjQ81TWmvsnI1vyMGFFs94hCRQM1krgkSJz3diP5Cjmw?=
 =?iso-8859-1?Q?nn30CwZc8/mrFkdV4K5hywz74wtCdIosTGTUaZVGynu8gMsxDnLbNbVYLC?=
 =?iso-8859-1?Q?lLf0RY5W/9zrxQxGLVL1FmagrJk2UIxs4Hi6arVH0Wp+ZsjwguK9lA7L5F?=
 =?iso-8859-1?Q?OpT04jDp+R3wgIxYHYmchd79wj+WshUxKb7Qlv+1sTQTYTggxctnso/uUM?=
 =?iso-8859-1?Q?c53YIOoVCd7f+jLOcek=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22b70f2-febd-407a-7709-08d9abcab12f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2021 02:08:49.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eu1D4Tzke1ipVd4RcNuTQe/RJNkmiTfQKvNN5G17pSqRPNJ1CSE0yUtjuKbVN1jVesfzEshfSHERW0mt9gdaNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

It is not obvious why add_clat_sample() shouldn't add a high/low
clat prio sample when ts->lat_percentiles is set.

Especially considering that ts->lat_percentiles is used for controlling
if total latency percentiles should be displayed or not.

Neither did I manage to find anything in the man page related to this.

Luckily, I managed to find commit 38ec5c514104 ("stat: make priority
summary statistics consistent with percentiles") that describes why
things are implemented the way they are.

Add comments to describe why add_clat_sample() has to care about
ts->lat_percentiles.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/stat.c b/stat.c
index 514f08eb..48c70072 100644
--- a/stat.c
+++ b/stat.c
@@ -3090,6 +3090,15 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
=20
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
=20
+	/*
+	 * When lat_percentiles=3D1 (default 0), the reported high/low priority
+	 * percentiles and stats are used for describing total latency values,
+	 * even though the variable names themselves start with clat_.
+	 *
+	 * Because of the above definition, only let this function add a prio
+	 * stat sample when lat_percentiles=3D0 (add_lat_sample() will add the
+	 * prio stat sample when lat_percentiles=3D1).
+	 */
 	if (!ts->lat_percentiles) {
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
@@ -3103,6 +3112,12 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
=20
 	if (ts->clat_percentiles) {
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
+		/*
+		 * Because of the above definition, only let this function add a
+		 * prio lat percentile sample when lat_percentiles=3D0
+		 * (add_lat_sample() will add the prio lat percentile sample
+		 * when lat_percentiles=3D1).
+		 */
 		if (!ts->lat_percentiles)
 			add_lat_percentile_prio_sample(ts, nsec, ddir,
 						       high_prio);
@@ -3195,6 +3210,16 @@ void add_lat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
 			       offset, ioprio);
=20
+	/*
+	 * When lat_percentiles=3D1 (default 0), the reported high/low priority
+	 * percentiles and stats are used for describing total latency values,
+	 * even though the variable names themselves start with clat_.
+	 *
+	 * Because of the above definition, only let this function add a prio
+	 * stat and prio lat percentile sample when lat_percentiles=3D1
+	 * (add_clat_sample() will add the prio stat and prio lat percentile
+	 * sample when lat_percentiles=3D0).
+	 */
 	if (ts->lat_percentiles) {
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
 		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
--=20
2.33.1
