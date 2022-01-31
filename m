Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC421C4321E
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344367AbiAaVNV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:21 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27057 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379546AbiAaVNS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663596; x=1675199596;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dOu5x2cpyEwGSPdaNGmDhNOWg/oTK8p+3/q3tervMVk=;
  b=Z5dm75MBCWaOSvHB24Np6p2beP7fIEhNAFcKeh9NPORdMZ1M2gK5xR+X
   tDRnOXzFOOameFWv80fDv5DQ34DkjCpcAT1JPnOqb5NaqtGyp5Ba3Hhhh
   HB4Pa45987O/bhAehbMOSK79CahqhfJiZYwhBGRw8E6BW5Fd7g59Agz/f
   +0DFKb4zMNboy+D+gpxxBOoD7UZiJOpohftxVZR6IMwf18vgdXafjlxFC
   hm11bpYxNbj9p/SFQTl8etUh9TygVtynizbYH8Pm1mKbwgxOtKiVbLAyg
   7eyJFBwR1TYyuYbOBFV9IQc2XUslXRDP2k/IWiq17HeNRpzQMLCGfvhf9
   w==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="196633907"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsR75fUANUqqHG6HrKT6O5k8DlwKJfpF79RZi1ezs8XFMgVsmeLkAqzpZCCTyn/qjh0472CFHnzf0nCThs8vzXGcMx6Pcno0EOtWtsY8Ma8d9KrzTDc3e4440mEu2w+5qYwuQIMovmnD//kruUfE6/XL3J3m820P8Gp79Jp/ks9RFyAhCSzYPmg7fICp673HAwV8yEfRr6x37XrSMriAHoL6oTd+zt647KIo5q+YJX7dpvXrzF1SdK+a88eXOhdCE04T+NuYkMqNEoCKirfag2j0nwzNnBOfg9WDTuVUp0DR3dlmDNyL6gpkV9vn8SHHKBFrwTj5zlHqbwEVuuBxEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grsJbK6UAC2T7TJMPGoNkwfjtUbCfQGvXoEz8rUoBCs=;
 b=geQFeoVx6gkQazUpZbvMrb1lG1ECONyUxlDH7MH53mumNNd14pAAtTl473ztCkrM5xIx5gMLoQJO4mh+okP/4bMhrlIiXR4CN40kJYNeE0DbhMuIPgXMLkscyr1WUvSRQ5al0jdkHKqWZGuQzbOKN1yqmGNmKAusTCnnNrG3Eg0dEoxpHdejdgNQ4XHtokRV1J3a0WeD3EQSog9o61e9MkwgGUS94jz4SpWXNBod6rA2B+NRQbL+l/fo3wIFz6qULqZ2r6hQ+2m/xDFBtnWm7AePWsqckI8nO4tf8rYUVz5TKS0EL8N/g3hgOLJwzZtEouG+G6Bbfi4ZWCQNQ/dhiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grsJbK6UAC2T7TJMPGoNkwfjtUbCfQGvXoEz8rUoBCs=;
 b=h4OeG3fV1Dj0Wz+EqPwFyOMLCNLGkvc6ox1mrKH5NeGDCRhyhZ+81leMT014fYX9uBdL1Wnw7t6lyn+vhSjY+1ydJ2hXKoXcGaZFnHxenpTBcpQc1+v6l+S6Z1HPp9SyoP/5G8pXrlX0r2hfKPv88ZXDvfjdQgc9VGwVErMPJUw=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB4881.namprd04.prod.outlook.com (2603:10b6:208:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 21:13:10 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:10 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 15/17] gfio: drop support for high/low priority latency
 results
Thread-Topic: [PATCH 15/17] gfio: drop support for high/low priority latency
 results
Thread-Index: AQHYFudZOLSoK8J73k+LbpZXydb4eg==
Date:   Mon, 31 Jan 2022 21:13:09 +0000
Message-ID: <20220131211249.106820-16-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fce6fd6d-576a-4f64-69bb-08d9e4fe7bec
x-ms-traffictypediagnostic: BL0PR04MB4881:EE_
x-microsoft-antispam-prvs: <BL0PR04MB488123D29E51BB420CE20A57F2259@BL0PR04MB4881.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WEdQ1HgIuUaC7JZnF7jjrBIa4TJns/ueBCfqlFlVfkwFPZKg12nTJKqkKjtNCuqXp8O7En1S9m/QclEiwZY2P4aymFd85gTgkVv0dKoRSDE4fyl0YSpS9L+QguzXcSH8mVgfsE1GH7GGFvsJjvY3Tj72bonPvJmatXStXSPak8QJ5i4h41/pG01ESDTzw/nlFPq9d5WmD2WNLychZqljJrYX1eQsUrCafTd+j3A9F4zvLESZGK0KnGeIpEPGJpP2jnILPmX+JxLI3YF16KA5AnHPfowxv22ULMSTKhsLOyNG+RDAh+XPLz50T8a0aT4pgEK1APq7P5dW138noaAg6b3cNl7nkVjp3G/V39KToAHWECp+BqP+W+09UfcYVlAOM2tou+S1QN6qbcI6mp13a++699apYqrqpN9e9BJ7lsfZHDAc2pyug4Ups+2lOJw99dCvGJ4T3vhcctrSPDc3fntX8Hv/qqT0I7PlHNl4Q7GqP51Z81IUjAwi5eWRoUr0iqWnHmRe3Srg0rbS+tfng9mX91QiAjKlQU3fc/kFeGxUqnQ4gGpmYr3Rbt5fDLFACZHZA/nhlPIBgakeGLk0Bsd6qv2Va97johA3C/v1PCY3t15q5Mtc2iOTQqScXUGbGi1FVyvV1hQti6CsBtT9Nt7tJ4wNjQtnz07q0U5EVipAc0VVgp0Bq/RKt1AgkR5/luex+zNaXmuUQ5kDuy0Bxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(54906003)(91956017)(6916009)(6506007)(76116006)(508600001)(316002)(5660300002)(71200400001)(186003)(1076003)(2616005)(26005)(6486002)(36756003)(8936002)(86362001)(4326008)(66556008)(8676002)(2906002)(66446008)(38100700002)(38070700005)(122000001)(66476007)(64756008)(83380400001)(82960400001)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?z805bJ4lFdyw7yjAO3N0PMwAJ1Sd5lHHaU7JpZDzV9g58Rf2kyQbqudUpa?=
 =?iso-8859-1?Q?07czsGAdkwZXZ+ut8OiHiLfFIzb4NjTo6gqCOH6ocyeVnQXGg7Kh4X/LKy?=
 =?iso-8859-1?Q?ciVcxPWijRgiZBXVparTc/lXYkStm0DLTD4oc9nOYtTXVP4FFkrje4HUZP?=
 =?iso-8859-1?Q?jgxfcvo3wHMFy+DrxRAInpk0PPFBzhfmsePNDL6TPg6eSDDUchPsp+Fo+w?=
 =?iso-8859-1?Q?uTMlefWnD3Nt0dn7x9QNNxfsBiRHqafVhA5g3D0RJEiUmW3dO2JM86cwQ+?=
 =?iso-8859-1?Q?paO3m6GbIs1M9aV9vdmRzrzDbc4pC9d9ZKTs8HuV7SG+GtIoAyATdMgV94?=
 =?iso-8859-1?Q?DCVmymHF6CzlfEG77LmBAgsF6SkzCSzhquW2cBJVARnSnq51JHA2ti7Kvb?=
 =?iso-8859-1?Q?VXzxUGU0MDsG3M14KyiQ+EyQuB9zMDuVR3kuTwxh2XBafkUQ/hwaZr5FL5?=
 =?iso-8859-1?Q?0X7NQg1p/oFfss7MeZhdb8iKXc+e6cVQwpS6SGsBrIjZc1ou4PHgOcLBep?=
 =?iso-8859-1?Q?Ur+yNpYxNevpRBwILOfJTMGI+oFsZlkrYPKu7SuT/PXPR7QD0UYb5ONRnH?=
 =?iso-8859-1?Q?xx+0kjLqq6wZOLASbk9uOn/wD7CpWMpcROuyX0RzdHDXPwn95U1KBWjGrj?=
 =?iso-8859-1?Q?czfeh4PwJkGtMt16NZkZC2Yj9T7dBdoK/MdlH/5wQ6aEvR+kBxh1HrX1Dc?=
 =?iso-8859-1?Q?1bJrY7wfPW/NXWazi+KwUskV3M33emKbaqm1zxu1dhjJp2G0Xo81o/KMpM?=
 =?iso-8859-1?Q?Kh1IlXdRskfkCpoYPVkHCI5n3TWoQKAn6/+4IYGuV6nCTckhDU53XhaGd/?=
 =?iso-8859-1?Q?Jr7T13PR/1qGf0xUuWsfc2qJeAIYlcbcvbnjwI2oYT3Xk0Nei7rt5R8JV7?=
 =?iso-8859-1?Q?eMKMHiqSl+QpskD5qCKHvXZlEEQtc0aURtrPuZvzopGbmEpE6WCZ7pcN23?=
 =?iso-8859-1?Q?h0k9xSKUSchCVRj8q6oovR5xTO2GQqBizTDVfjE5H+Thcj59aNJSJ7jawC?=
 =?iso-8859-1?Q?h2jWxy7s65YaLvzFkDi13rFvDo3SCBDxxFP49gZQm2unuCF1v8lhmPPtx7?=
 =?iso-8859-1?Q?wS01q22bUDnYGuU+bMcr8uaabB5AR0k/9+ZXokB8CFGlTzSxCAZgZtQc0Z?=
 =?iso-8859-1?Q?wUSmuZCp9c9BZAyw5iRQ+h6z0OrncnFmjwMYwmgZfgzGuYESJ8x023xtuq?=
 =?iso-8859-1?Q?a0dBevkXWD0LVxeSnA51LZ1jwgxw1B0A+EmUCmXVFpMBHykEnOahobjWaE?=
 =?iso-8859-1?Q?Q2l73424SBAbSoTKOiZIrG16Bp05ijkkdPz6v9QhzolWBQLPUWNOYKmSG+?=
 =?iso-8859-1?Q?oz1/ukjexaH5nm+fRcspckcvnA0GoRrZdOJfZTgQUrp10O6FnhqQht1UIc?=
 =?iso-8859-1?Q?lJ3bxXBEytekv+Wm5TDY6vy8NnJhHnSsbCZYLmymW15XQ2OAMF+DLYmrbq?=
 =?iso-8859-1?Q?zjGPqXPBiPUfk9JAvcepe+RQYGI1d2Wobl10+cmFUGnrqxRWdJbQ3IHpUH?=
 =?iso-8859-1?Q?drjds5APQudTamIID6U9zx4pQ6+a1K4jmKFa/FA+k8HZTISKiK/oXM/wLn?=
 =?iso-8859-1?Q?a93mSzlXznJNNMUB4V0zsdS/SeScvFJTu/1aJctaSyTjYX1aDqyz3oeZmx?=
 =?iso-8859-1?Q?yJYEy3c7DH/3uQrpqKvltmj/mPJfK29exd8QW9Hu5L3s9PCZcqMRk6F32p?=
 =?iso-8859-1?Q?AU8j3O6ski7tnQk3wClYfK6Obg81R/OEydvXo0Te?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce6fd6d-576a-4f64-69bb-08d9e4fe7bec
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:09.9991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bkCbTB3HoM5gKbG2hvABfFiTDG2qgNoftxSzjHcNptCGL6nq+n603fAich2Uwjiz/0AAFpIfriewzLjuRzVGfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4881
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
