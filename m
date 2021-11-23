Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C656FC4332F
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhKWOah (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:37 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhKWOag (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677648; x=1669213648;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cNFCUxIFJch3vGibrgAxRWFhGMz/SCKkebTm6lAwq0A=;
  b=lIe3eP8TJ6c54/9flCl9wOq+j/YFCxGOsjA/Xt/s3CdOeqaBNHpbphet
   2F8DHsJ7F5iE51tcrar5hDTamc0thO+b19FlZw/CoJv1H7YGMW9dvyH4I
   VD9SM7x3JIJgF7DakwZ/SfD/bD/3i8FVjBQvt/yWj3y8rv3+BKjYSPsEE
   czLqA4o+SBxDbRIQ3bLNA7vYAdWHlyzhb38Jms2pj8XMnQMmuobVvwKwy
   lgAaYpkkdR0vaL4jpgnibg4SqyGKra6yiecNzvBMHW3kxISwlrHgOfLks
   MM3QenTXwzp33i1Vvkk5Bp0fLt/CoAomvYyTJ3yr7T6qkiKBgnahlF/LM
   A==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250420"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8kXD/2Ud6ddTvjEwFftCAvHPDcIhqahADG2vSaTXqtL8mmPkf/G7OSJ00kwyDojsY6lFxZROGktPaSGEDBf8H+0nQvHmtJl/x0XOBX4eu2ekbFEq/D9hfzBe2Uv65tFHz/nB24zFj33cENwycG68NeXpsq97PEOS5bJvEDo4Xk5PMPJeNkOLqNtHiOpST+yV3ijVgzYXnpzQSAIjZGfVOxONTY0e67VSRcPzEKOd0dS/XTXM57Oy1niKoRkYgvknFF/zUrUzGTOkPh1GgUObNjzP3Lb9Jq8dwSpwVF0Vya7dqfrBI4uDW0KLRKQh9syu3PBzeq+ADPQ4viWZ02dRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhHaQQYNAlQ8EMIXnxTboz6Xntee3xbFYQ7NJ3vFB4M=;
 b=PdBe+mAG3Mod9y158ZuwbONaIScWoPyGpmiayq0WIycAegKJl+YKh1VVLKzVM9+ZwVsIw5yaEuMVgs9SXmxQ0ALFyvYatZLPDdbGVaxoqhPnffZm6FTyCNNbhXGPK9aJURCFuBPmlpd9GDBGzh/vo8HDjDmSlcE2J8xg1I8yD0KmzB2Pr/PaUe/CAUw1Vi1/3VohPszyIHr6g5qO6g33ONRfTWdIUlFdpQTRMAZtDkZdE9Ld855TWumHjXG6HRgasUCV5ueckLBGzCPov1gI7VkT5XY8bLRukNITWYZrfgfVN/OeZDYXzPMzNZ+tHcDIRRA53mnHvbWf7OhQoa5BvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhHaQQYNAlQ8EMIXnxTboz6Xntee3xbFYQ7NJ3vFB4M=;
 b=grOFwuxfhFPwhS+/0lXxQKkiDdGckd+9hFVZNaKGXYObK0956Y6stuR+auC/oKLJES0ngoqaLwyy8nOIxYLANNMcFDJlda0dJ1c1961E56XADk96z59U/w5y/Ty8lwlvM9doRznMLP7q2NLqYtqvyqocLRRQr4PK6aEIa2W5PnE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:26 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 2/6] stat: add comments describing the quirky behavior of
 clat prio samples
Thread-Topic: [PATCH v2 2/6] stat: add comments describing the quirky behavior
 of clat prio samples
Thread-Index: AQHX4HY8hmFdc8GYjkGehCBkvnOxrw==
Date:   Tue, 23 Nov 2021 14:27:26 +0000
Message-ID: <20211123142708.48867-3-Niklas.Cassel@wdc.com>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2002b17-e1e8-440b-0928-08d9ae8d5f78
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB758927DFAA49AD1DA2323D7AF2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xPitjv9s+ATt4A9cHM2fz1nF+34y+V4KSftjNYZYEAVJnTWkdbo3mdJDGoKf53VgCyd6egz5/PUUAlMugE6/h6B5wO6Q4mdUj4pJaVscC4/d+dUJPj2K2NtS6OkirtxCOYeWllJeeU0vLqdnDALPpzaFK1cRWoJJh8HsKeHZ29o4hspEXxPE/ClruTCIsYJwmRaNuRbY/yAKtePRq8C0Ine2fjvp126EaUowlz3RQA3j0AbqKdJbXBhj/A8JqxW31JNC0Ik+yB5bCd1UdSaezEbuY4GzvW36eavpOWMJx14gbmR4ejvuT9ypbzVNx5470vubO02BUqTaiGJ8AxeiPwbRwlUf9OK0qiSaXqfFKiLAdYiiyZ6wL4PQZzJAX9q1uMTq87XgFXb+mg1i5RFT0TDHQpR/SVOTVS76Zk4VtYSXVzB6jkR8ojDCrM1dbCo8CLSQhZxgUP+JZK5r0CcBwbUiV8NJ0qkKdJhqPmVGIAq800REorzNKWqVbz1ZCL7iTTgVgkwTuqORG1yt6aADqxK5KgBI/aZ1sGL0dBGiVvKRNIf+9Uy7B/vuvABgdn3I6UhYLAvlqIXXszTE9qHOolQUjn3JMxVleFfUJbLrKYsMDbw1ohMihJaWZjbCmfIGtgPyFUbFM3VPphh0myE2svus9GEnhIAXum/pMaE3poiqdRuSLCY/7kdF40JN27uOZmZki07Nu6MAVAb6GTRQcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?vZwgdjDMKOBlfIuLvUtRfKDW+8QHBdgJ2dXi21gq6WAqIsTAqFcepF7GYr?=
 =?iso-8859-1?Q?CeyXK2qm1BhYpz9Wh2oI8Nx7xtnYyFL0oo8BdDo6uSgnDjT8UjkZDloJVA?=
 =?iso-8859-1?Q?/Vq+jD3nuN8r8b5XAqdCPIdggmQ2XHJIA0QcnqKBBIVunKF91Jx81mJyv2?=
 =?iso-8859-1?Q?8pYaY7d3+RIv+pa/WewBEA9Jumd6MhHwxuyJaE67VZYmmWO3U+b5Rgv+6T?=
 =?iso-8859-1?Q?TB9k93VnA45xMBvPQIv8lpww7Fhnj4+ldeHxYncHWmTWGluTxImbbHo3Ok?=
 =?iso-8859-1?Q?o4SbfJE/k9kolVzCdIyYijGKaVrmBdwRx5Jg/YRAbvG1OMTaFddHXu8Geu?=
 =?iso-8859-1?Q?Hyj78kOnE8zNMzpkQ5n8J6hyJcOE1gTr7zqhXK+SyA93a2oepIblEWfQGn?=
 =?iso-8859-1?Q?RieQxgk46K3AM+tiDkYg5XCW4wREEeXc5A5uqWFhMwXs6XBlaHt6zXRnxw?=
 =?iso-8859-1?Q?uqbRTCvW9sBWzubZMhMpQRvYGmCmoH7o7mcOMt/y0WsweRh/7CC61fqrfb?=
 =?iso-8859-1?Q?TGNtF5zlzCfws9t6m4y/mDaU5hbOXwCTSwZ4FbOFoX8Hs4qW+XANd3sHrZ?=
 =?iso-8859-1?Q?Ttuc55jcQIS0mK81cDXRFVSInSFRTuWRQ3OfOotfDdHIIHxxN6seK9KTE8?=
 =?iso-8859-1?Q?YivYG7/ZxtyIsqUnpyB2P9xRKWxMYfV21m/06HxWF/rc5NAruXU8GjEX+e?=
 =?iso-8859-1?Q?HBfP8yqGxHqjWtmmfs1i9p2fbrdmMQqLmVlutJd38dODLbmsF7nD9OR/km?=
 =?iso-8859-1?Q?HRSIvn3pFx4Ht+UvJd+hRQpttbPX6N59EHEzt1sgSTiAC2M9XsUzSQqE4Q?=
 =?iso-8859-1?Q?4syYbrXPbgq/Nes/W67UL4keNtVOeXAFEXXxgsCja8EXHnTOkWnEQ5eM0n?=
 =?iso-8859-1?Q?0nJ5DoRcErPGa0s6SnTZrslUeoFUrgm0wn9cjyNL6wBHpsq7jwiNYIANIk?=
 =?iso-8859-1?Q?6XP6rMPRqJ6Ii78QfOY+xarBytMF7C+9pwdpUsow0SzoP23+P5woI0QfvS?=
 =?iso-8859-1?Q?IOgwxCXUbGX2x9KwKwSRUSRaIYNjbzB7ulG/5NItyPVUwJKrg5jXJFEwjS?=
 =?iso-8859-1?Q?h92C9hPbw3lX4zI+pBKuQoVgJA8Jwm1Lt/rtxiGCU7zxEcb1zpvAUdtf4f?=
 =?iso-8859-1?Q?YrYZv5/ThfwtJFbD1sFULBz98Qz5zwE44CJ0BOfcO7rTSx63UsMR4DdADw?=
 =?iso-8859-1?Q?MWS+sHgLA0ca2m08rUviKntzh/if+ZDLVsV1d7PsDOHxq5ypB5BuJaL0WS?=
 =?iso-8859-1?Q?l3eFuNf9fHZFFMxtjMiXZ4nX6jy7xCLwTskYkgiO2tOlGH9R2eiyPscOHz?=
 =?iso-8859-1?Q?T8NyUkahwQw9jSiTEE4+UPcr8ls9TzRLLiTwrmvh04KKH/y+rpeKTDdxbz?=
 =?iso-8859-1?Q?ZIFbf6rlQ/1F43I+7TDc7lmSDqQ9Vv0jDPKqlKQlSSRnthESPOtfPDU2kz?=
 =?iso-8859-1?Q?RzaRWUI3Qe+DAzso1rIhRuwt9Lnh4NAGcE/ztNpoPaV4KPHmwgEZ9eiNMB?=
 =?iso-8859-1?Q?Il0h7PpzjLxfUSHG4I/ZqEMXPJW/1pDxJuFKkhoCLYXa0MvOdqY6gViYdZ?=
 =?iso-8859-1?Q?7frMxxNzIPUuo7ua1fGyYBVACM9lhbd92knYHdDymY7iH9kicGxnyiNn12?=
 =?iso-8859-1?Q?DbX446V8DTkOA+VaHojl5UD82ZIx2Od7CttnmLg1hIPvJK693qedt639hh?=
 =?iso-8859-1?Q?VyWN1VlQ/dz+Kw5SfsE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2002b17-e1e8-440b-0928-08d9ae8d5f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:26.3376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXJZNk7ZIDXy+A3MafJACH8ZM5x+Rz6K1G3H0pjEqqClw07z0JJ/x8I6fUP0EXVFnZBzHxBVYR1ZjkstbyB4QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 56440e63ac17 ("fio: report percentiles for slat, clat, lat")
together with commit 38ec5c514104 ("stat: make priority summary statistics
consistent with percentiles") changed so that per prio stats track either
completion latency (clat) or total latency (lat), depending on the option
lat_percentiles.

It is not obvious why add_clat_sample() shouldn't add a high/low clat prio
sample when option lat_percentiles is set, especially considering that
option lat_percentiles is usually used for controlling if total latency
percentiles should be displayed or not.

Add comments to describe why add_clat_sample() has to care about option
lat_percentiles.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/stat.c b/stat.c
index e0dc99b6..44ca3894 100644
--- a/stat.c
+++ b/stat.c
@@ -3089,6 +3089,15 @@ void add_clat_sample(struct thread_data *td, enum fi=
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
@@ -3101,6 +3110,12 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->clat_percentiles) {
+		/*
+		 * Because of the above definition, only let this function add a
+		 * prio lat percentile sample when lat_percentiles=3D0
+		 * (add_lat_sample() will add the prio lat percentile sample
+		 * when lat_percentiles=3D1).
+		 */
 		if (ts->lat_percentiles)
 			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
 		else
@@ -3194,6 +3209,16 @@ void add_lat_sample(struct thread_data *td, enum fio=
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
 		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
 		if (high_prio)
--=20
2.33.1
