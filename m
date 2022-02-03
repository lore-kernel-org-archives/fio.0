Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1409C43219
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353767AbiBCT2i (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:38 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34997 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353762AbiBCT2h (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916516; x=1675452516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S1WQ0KuODHHEtZR6QwXEPjSWG7KyQ4fsNRiYipgn4ZE=;
  b=NP7+hYjbxdd5lzxoHQ8FiX8qPCkIgyM2sEWdIQinI73aS9S+Dc0UG1Wb
   QVl845mekCG71Wir4AcY5XpHYAPAXnV3THVBkDLpikCKrX/pfzwhpo7Hw
   VmvexD4Ju7tOqOfY1TSbdFKyWw08IfAuX948bN1cgFfGreW4UgOfSUo1l
   lvlUjZid4Gy57qwvvVO5LtKiNu1+yZZDTPUOWeRq7JDWb8LzcGXhI1TzK
   cdQ8FLo1qw6+F9hbp1Nj1RLvDpd0/rsUILUjLZePSOJv3RoeRLE7rt6NE
   uWjWzpyC9KuUYyeYXMEml6C9t5qqFZu5nFaooxk2Ct4iJGWU186Mk1H9J
   w==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107559"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBlQabhGK90H/rtQ1ukwWIO+jEPk22GpqnNDmQVvrgSs+eNgNxvZS0wr6dmCoxZkl0chgOOcWamJDECEEQzvEDtmzRLhsxduqaUIvGQ0cPBZ1K/93wf/WXf3ePq+64ZUddqSJk3mkm0/ZcHi62d5+a0NcJU1zA0igQLickKp0jxteBP7a7VXCF+LAIzvvj34XS24+Un9IvK+DvBfaon1Av0v9wmh6Dyzou08kwhnoG1X/DdY5fiBCHNkVyEjETk4v2+qRhoMU4Pcdu+VFmFQtUCaY5CX2qQNzlRfcoFKKpYw9Tesjga5cMG5fzXBNDi7YN00iax8jwWUYCf1+4CjIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkCnHfx/W+1+jO0TEjCVf1lHxiMSHTOoljymJlstvVY=;
 b=L+x3AHxfF134SwYcUmcAUTtnsjkxLFivvOieh3UUzihVpkNlRmy5ojD6F1rEthotVLmzn5Rc83v16ZyPN4QnO+tKWJIVZOY/Gcr8tHYPbsnkNpIvceZaVOazEaRw/ZUkJTUEXT7AUB5Ag3XgP5xM3EjXLUlpGLPo6EJe/VkY9Y/GSBeWYCDxU1pEiw6uPPdUZ0+rmJcmRNNpoZNVZeK8kOLKUmgk7cC7CoVoojOm0/XlU+mPqsQ9Ppfre7slWk5LzBqS9RXfWX1kkzVHbK1ZkHU9HPRm33F/9bY3KTyRDD2t51Ts7aRPjKZwnAJMJxdEpRg8AowVbp1x499fP6ebtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkCnHfx/W+1+jO0TEjCVf1lHxiMSHTOoljymJlstvVY=;
 b=bTBeLrOCGqU3BiDPgz1foe9nAgKCO4roGdQzxLKIrI9Yed5bhBYUgov63GGVVvxpdymN9CkFAGC3wR8symbyB2OGP7Uy/cDinpFDxQfrA0tO9rKxYaEoZCs8X5rHJQs030uVZXJH3gpl3pCZ5a/CY/HQNIdwelF+ECh5orHAOpQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5423.namprd04.prod.outlook.com (2603:10b6:805:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 19:28:34 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 16/18] gfio: drop support for high/low priority latency
 results
Thread-Topic: [PATCH v2 16/18] gfio: drop support for high/low priority
 latency results
Thread-Index: AQHYGTQ6qVx8k1n9d0aRzHm8L/OSYQ==
Date:   Thu, 3 Feb 2022 19:28:31 +0000
Message-ID: <20220203192814.18552-17-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fe0f106-df97-4cfe-b723-08d9e74b5ed1
x-ms-traffictypediagnostic: SN6PR04MB5423:EE_
x-microsoft-antispam-prvs: <SN6PR04MB5423B3F69328F672EC67BF26F2289@SN6PR04MB5423.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gGeC66rZvokOqV+YRje3lOdfd4XCcOZ0EuljvaGCh9SrrLrZDJ8x6shrxARnUTc3ZaQn8S+xI0NEFvmpRskkX8WtCLdmm6t3cr715cWn4BlZSA8Gw/Qto6+3G/8kO4fWFqNnhyVZQdowyZ050Sg3xSpJFq7GUNqSYnXlz/uq5ZVQlJsvaB0T8pwpRH4RYuFoELNlUV8+l8YwyRmKgPw6PqsuW2f+vFF0e49Ea8UzK70tUsKb3waSj2VYGqlg/+NDWILLLIhdkpj3i7katmjRqOcGmyzXN2cAlGcvrPKr//M8/E0JNJ3i/Gyj6sfPIz53o9/SoFdARSnqoOPRfRJybP8A0l/Akpy/gjLLPPswcv49Y/kARnjA7vaurUy1uiFCApMx2NfLOYv6ANX/+OFmLXd89w68U8ZUIGM9D8/1vNqofFXGim5HFX3kbqqc7KVXlFEu/by7o6ZS64wsJC+3p517eGNMnJdi0vaM3d5u75Wy9qv+9CDiXG4c7WxBaHqBbMMNOHHNiy01kgdnCnqfoosRcNIev8YiX+xYlfIc5TWWddChzlB+X68+n92LHoknQLUddOjBHtqoymAkCayiaEVJ5ZG/5Jizn4IY/uBDpX+XymGm5H/YtA1oB/X6wQ0hrPoCb6hqLQ3rvNB+KI4FQ3x3A/RVUpv3RAkdZbp/3tELeOFXKyuNow9HTkmLRCpr6vaKOmtNn/AlHF0Oo9KzyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(86362001)(66946007)(6666004)(91956017)(5660300002)(64756008)(6486002)(71200400001)(6506007)(8936002)(66446008)(6512007)(508600001)(122000001)(4326008)(66476007)(66556008)(2906002)(38100700002)(316002)(2616005)(6916009)(186003)(83380400001)(26005)(82960400001)(36756003)(1076003)(8676002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?5fQiRKqFCz4LAbkiUzEGFKXhgHllgJ1eonVcv34WudbebNmUlOVpJ5h9ht?=
 =?iso-8859-1?Q?erh6fZ1hhnPK5cOnUnZhYLgi/cr6E6aKbsgVOjj8drchXAXpWl+9GTlJBZ?=
 =?iso-8859-1?Q?3NGWKaUbvMjCTYZr0UFc0CCG4kKzXrca1a773rDjgXGj4R8z4/PFruxdko?=
 =?iso-8859-1?Q?qQTZFx+FLx2c3cNhWtZQLpN9UOYdGbXPCunUOi2Gs27IW7AZGXFQbrp7Xl?=
 =?iso-8859-1?Q?iS3I13loTW8nvKimJ7vYobGIRlORES1qoEdy7TPCiwf61dLFYjlw/RdalU?=
 =?iso-8859-1?Q?o2OGmI/XwEcockc/SjzjcDpoqLHssC5hKAnStX7wHKpw4+NEZMk5dgD9V6?=
 =?iso-8859-1?Q?ohT0+PZZ+phirD5YSrbXtuWN3tjznNJPPt95jmrZBC91oVa4rUEEaLYZRv?=
 =?iso-8859-1?Q?Sv2qVF5xgpJRxc9QLASBwzGwijk4PsqOyjGfZfYeBgvSFWX/BEGNO2olou?=
 =?iso-8859-1?Q?TYMwEIE1hDSOwF7+opHmOK5IvApL/JIiA+DsHN1dJBitD6fPUFVgT+q1u2?=
 =?iso-8859-1?Q?Rm61AeD56YXHDNpv44ZBMoctIZoHlDtOchvBFjzyLtK+OmovRqp0/TeIpI?=
 =?iso-8859-1?Q?pdiFPqQks+bWlaCcfx4cCnXCuH9J82qGcNzmt4LBJBNSvObj0X0EgqeKdX?=
 =?iso-8859-1?Q?e2Gx96/jNHfrQgZt1mRaX2pyPw7h45fuFmdXt8E9G0pgKkH25YSeafUfIX?=
 =?iso-8859-1?Q?H/QfP93+PeCtRPv3Qp9DejxsI2JyzYq2dZ1j01GKZK9Dk3zeL/UNUxnWzk?=
 =?iso-8859-1?Q?pdeZCppx8yDruQty982C492pW7HFeIZYhBfnV3G+oOicX2rvgSK1PBub83?=
 =?iso-8859-1?Q?R4WTw/7kOEmepegevVSjhKx3hDUhfOv92uemLg/KGOpDlrHICiGNUd2YW8?=
 =?iso-8859-1?Q?3yZo6UFuvVDiZathoor8Q8PMKJMgdZD5VCqkbGUsr8QgeQP3WfbhE0uN8I?=
 =?iso-8859-1?Q?/fPzgoHE+EgcQ3SyH6cTNQhuhNVe2/olxZzuTSigd+qWp0ovFihYOX1OKb?=
 =?iso-8859-1?Q?ipqcM783ovMSaHwoiA8NdRZNjhVHyo67EHK6Gnqs6LNkzH9ADX4G7dRYxG?=
 =?iso-8859-1?Q?dewSTWvuFXI1vwsqMrgb0watrllmW3bQ1Q1Ib6hfQh4nschhzc7Ou9dB+l?=
 =?iso-8859-1?Q?tAJQEd5sMNu8Wl7pXXHp8TSIFdoHoi2yJ06tK+OIQwVdg7GFwq+7Y7PR7Q?=
 =?iso-8859-1?Q?xfGBJpDiYX5wQu7F7ifGr7yp/VYwHXzBGQZ5zub3taKFmX+he9g8qETAFu?=
 =?iso-8859-1?Q?vql0QzifsbDJ9PC4XshqK8kyUeHdtpq9FunHHP2rRUGNVYv5lKB70djegG?=
 =?iso-8859-1?Q?qT6tgdYozRsufs4Hzp0zmf6p3wX+Vd3IbUphf1mX2jt8bPUxkkqkaL8SUq?=
 =?iso-8859-1?Q?JwGf3GtM3D7fsH+GQLwVVht6DxcfuDGf2jg6VfODBM4N+QHdLf94VVSb05?=
 =?iso-8859-1?Q?V1amFceyDsE1j3CCaFhXLjC9NomEH/M7YPYnjlkA7esif6CelZ4xvAjd0u?=
 =?iso-8859-1?Q?EUM/ykYbIUbxzG+6LyC4rtt3uZsvMnTu/v0iK66rcMDyyoX2Wk7h82STyJ?=
 =?iso-8859-1?Q?vymkoQtEhwAoP/Hnf2s4XQcJ2eHWVsgWY1FJluiSqfds+KQn/F+XlKIwt+?=
 =?iso-8859-1?Q?Kpza/Yo9OsteDJrwEVDEeukAUpOnJB80JeNjSBHfjfRz193HYJBFLqB1Hr?=
 =?iso-8859-1?Q?+5vdQeKU3DscWq0pFu4ft3uuTCxb4fXH9NWeCb+5?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe0f106-df97-4cfe-b723-08d9e74b5ed1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:31.9007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aCgfpDn9T++RQ1YZK5ukCV3Y8lNLCMI3LfCcvpDMolvekNjhLfkBZhMQAxheF0tAniY/5SAUroWsB67GCYhapw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5423
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

High/low priority latencies have been replaced by a per prio array.
This allows us to have latency results for more than just two priorities.

Unfortunately this currently means that we have to drop the support for
visualizing the high/low priority latencies.

If someone wants to know the per prio latency results, both the regular
output and the json output contain this information.

The GUI could be extended to support the new per priority format at a
later time, if anyone has a huge need for this feature.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 gclient.c | 55 ++++---------------------------------------------------
 1 file changed, 4 insertions(+), 51 deletions(-)

diff --git a/gclient.c b/gclient.c
index ac063536..c59bcfe2 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1155,21 +1155,18 @@ out:
 #define GFIO_CLAT	1
 #define GFIO_SLAT	2
 #define GFIO_LAT	4
-#define GFIO_HILAT	8
-#define GFIO_LOLAT	16
=20
 static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				  struct group_run_stats *rs,
 				  struct thread_stat *ts, int ddir)
 {
 	const char *ddir_label[3] =3D { "Read", "Write", "Trim" };
-	const char *hilat, *lolat;
 	GtkWidget *frame, *label, *box, *vbox, *main_vbox;
-	unsigned long long min[5], max[5];
+	unsigned long long min[3], max[3];
 	unsigned long runt;
 	unsigned long long bw, iops;
 	unsigned int flags =3D 0;
-	double mean[5], dev[5];
+	double mean[3], dev[3];
 	char *io_p, *io_palt, *bw_p, *bw_palt, *iops_p;
 	char tmp[128];
 	int i2p;
@@ -1268,14 +1265,6 @@ static void gfio_show_ddir_status(struct gfio_client=
 *gc, GtkWidget *mbox,
 		flags |=3D GFIO_CLAT;
 	if (calc_lat(&ts->lat_stat[ddir], &min[2], &max[2], &mean[2], &dev[2]))
 		flags |=3D GFIO_LAT;
-	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min[3], &max[3], &mean[3], =
&dev[3])) {
-		flags |=3D GFIO_HILAT;
-		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min[4], &max[4], &mean[4], =
&dev[4]))
-			flags |=3D GFIO_LOLAT;
-		/* we only want to print low priority statistics if other IOs were
-		 * submitted with the priority bit set
-		 */
-	}
=20
 	if (flags) {
 		frame =3D gtk_frame_new("Latency");
@@ -1284,24 +1273,12 @@ static void gfio_show_ddir_status(struct gfio_clien=
t *gc, GtkWidget *mbox,
 		vbox =3D gtk_vbox_new(FALSE, 3);
 		gtk_container_add(GTK_CONTAINER(frame), vbox);
=20
-		if (ts->lat_percentiles) {
-			hilat =3D "High priority total latency";
-			lolat =3D "Low priority total latency";
-		} else {
-			hilat =3D "High priority completion latency";
-			lolat =3D "Low priority completion latency";
-		}
-
 		if (flags & GFIO_SLAT)
 			gfio_show_lat(vbox, "Submission latency", min[0], max[0], mean[0], dev[=
0]);
 		if (flags & GFIO_CLAT)
 			gfio_show_lat(vbox, "Completion latency", min[1], max[1], mean[1], dev[=
1]);
 		if (flags & GFIO_LAT)
 			gfio_show_lat(vbox, "Total latency", min[2], max[2], mean[2], dev[2]);
-		if (flags & GFIO_HILAT)
-			gfio_show_lat(vbox, hilat, min[3], max[3], mean[3], dev[3]);
-		if (flags & GFIO_LOLAT)
-			gfio_show_lat(vbox, lolat, min[4], max[4], mean[4], dev[4]);
 	}
=20
 	if (ts->slat_percentiles && flags & GFIO_SLAT)
@@ -1309,40 +1286,16 @@ static void gfio_show_ddir_status(struct gfio_clien=
t *gc, GtkWidget *mbox,
 				ts->io_u_plat[FIO_SLAT][ddir],
 				ts->slat_stat[ddir].samples,
 				"Submission");
-	if (ts->clat_percentiles && flags & GFIO_CLAT) {
+	if (ts->clat_percentiles && flags & GFIO_CLAT)
 		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
 				ts->io_u_plat[FIO_CLAT][ddir],
 				ts->clat_stat[ddir].samples,
 				"Completion");
-		if (!ts->lat_percentiles) {
-			if (flags & GFIO_HILAT)
-				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-						ts->io_u_plat_high_prio[ddir],
-						ts->clat_high_prio_stat[ddir].samples,
-						"High priority completion");
-			if (flags & GFIO_LOLAT)
-				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-						ts->io_u_plat_low_prio[ddir],
-						ts->clat_low_prio_stat[ddir].samples,
-						"Low priority completion");
-		}
-	}
-	if (ts->lat_percentiles && flags & GFIO_LAT) {
+	if (ts->lat_percentiles && flags & GFIO_LAT)
 		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
 				ts->io_u_plat[FIO_LAT][ddir],
 				ts->lat_stat[ddir].samples,
 				"Total");
-		if (flags & GFIO_HILAT)
-			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-					ts->io_u_plat_high_prio[ddir],
-					ts->clat_high_prio_stat[ddir].samples,
-					"High priority total");
-		if (flags & GFIO_LOLAT)
-			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-					ts->io_u_plat_low_prio[ddir],
-					ts->clat_low_prio_stat[ddir].samples,
-					"Low priority total");
-	}
=20
 	free(io_p);
 	free(bw_p);
--=20
2.34.1
