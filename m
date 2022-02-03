Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E228C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244633AbiBCTcO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:14 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1744 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiBCTcN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916734; x=1675452734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IbpM/0lkMLzgJOaDl4s8kdNGeKTdRBtMQkJ6WDEBZAA=;
  b=oXp35oCoGergWU3vWeUMcDMbMCGz33GSynx3qefzfLEXEcSxCRpT/LBF
   Zq4aVIV5cJjYi1gZSmwGhrQFftGPElYoy4zhIs4s/kNCvxPgJ7Oh44PYi
   sw5HqRy5p9Yk7XCXI0N1UuEK+cUloh20RsYnAsmnVu7PcU58Itpz3MCWo
   r1icSlpXIttWmjStzrPBojuZ8MKFXFXhyL/uqw3OLUHl5R0/HGZpkkeOw
   tu2js+qI/5V1rC+JgF7mZFIe2uO/uDMv0ljoAnplGPDgnX1hUHSdWBzVg
   lgWWhpH6HFpXPOxcKcbGvAS0cFubbADzwKJj7HdBPuoy2gkTCkahRnaQi
   g==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095704"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgUFmLr+2HscI6R3N6EdeYqvJw5wl9lZa7hC8rhTTu4Cu1ahP3uuC4NeVYz85Gdw126RFLIylLNg2giwLOVKS9TnlrDSKcODuiZoBtWIHCH3UOX0x3P5lKYTXMk36rKmyVgOJ0tYbLyYlVURLKPdaVMGxwdHz/UPloxrK1EDNlvrZAHWwRBsd1ge2JNfElgZP1eQUWQiJRRJ1ClTFjxHSfsNpQ2VMKoaBQ8Z2PlpQs53Y4I4OGZmNmmDRiUt4TpleBNkU2TetvBnZKzSxSFZZ/0Aol52Xg5bUn/k96gPo/Y22c1e7aYfzL+bZnKBGaA5n18NN8y9LuCslj84FAi3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kGBcVscVoIYv1sl+88HxH9+xDk01dVHfy9OAt5ovAo=;
 b=KDeiqrBEiIsGLO3LzvgecGApHolc4Pd8rl7NBtBXnUDheq7z4iLhBIMtwVCAKlopeMyf3qHotpKaTw52MlvI+KuqlDULGmrr6FtGk5pxQ9S1zA1d/krdQKcV2JfIfKiSeVqh3//Uvu6JcwrBX8GOZIBSGL2/5b04gKkqDMrJ69719vLYbFbxHygJPoovGthOQoFZdr0A6Qa+rjEARS6bkjvJSDePC84kmhKHig66brL+owWECanpF7myPjK+Sob/tII8nS3A12EvMkHyOJhAJDE507bEz6VsNBDvaXXaP91LqOenG3khwow/OlvDTf8v2mupT8u63EQ0CthmmQjVew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kGBcVscVoIYv1sl+88HxH9+xDk01dVHfy9OAt5ovAo=;
 b=uh+OZxvDMSyyvhXPJ4nPyT98KCHniE18BDCfviwGRuTzpHlhLV8JRZZqKb8jik41UFKp/DUaZQJdJoJLCfqIjT0hIvmjjhLWFx+J5iw60pXnF2nHPr0PiSt0cx+NXb0qTicmNmMM2FWlP/1SM7ziX8UsxOcJFCu+IfsFoGwTr0c=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:24 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:24 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 01/18] init: verify option lat_percentiles consistency for
 all jobs in group
Thread-Topic: [PATCH v2 01/18] init: verify option lat_percentiles consistency
 for all jobs in group
Thread-Index: AQHYGTQ156TJPXpssUmOm4oxmLLpTA==
Date:   Thu, 3 Feb 2022 19:28:24 +0000
Message-ID: <20220203192814.18552-2-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 106981d7-127e-4981-c2bd-08d9e74b5879
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB46329C41592998E6ECCB2B98F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Fp1E1rq8n88yOOh4gYKif9fPwm+2kfzcMAbpSDXzXyVVhtM0YJwy5LghBw0Cqrsw7A47XDYv7BxMzu+qncREzUojY4Tk8kMLd+bT9iY3vROknZbwCZi0Pib8wGTNs59e+/WMir3RmMkHBXcmZprD91uy+1nSZeyF3OKr6jlRYnGyeSJm7y+JEsPKJ+kY6IY+4KB5jeTFNPpIxl2BQsSY/txDkjlcn9fZlB/RrCXzoL1ys2ecoHcWjp9DCzELWnaYbolQr9h0xssO1ZGwOHzTCkGGyqFSiTV3QXXLChXpGqD1YfJGBrrhGO2PH8gQooOJjG/e6RgUUxJtx5PG2X3TBk+8nDc1jtgFPdoRj5FDnFB3WWKbM/xRQWaflgk5JAP2XqsxKkhOMJsLS4kKGs6g1jk5sqvzW7hFtWEMCTLf9ArJ7Oe22NdbWiHs/v0fZ05WEjsWFIBSTcwO/irkkEh1CmknDv1QDfGVRm5+4ZcfutsHTD59yToFjyukKnxPRW7RzzwyOsvnlRS9XqO24OJ+IHlq0mMF4RkJsMqamD+3Yoc3lhIaNRTZBiGE09sCLLbw9/ShCrUVW5rosJKbDo0eagMK2nOMAEiY4TxI/lrSOWxnJfqe3ctGA+bA2VXmd8ME31sBkiC55A7tiRzQq/eGzpr/B7aA3Ia2JyhwLJlX9DiUh2T6dbj/AYnp+J9lkMKMnkg240K2GnRhXAumqj8JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(15650500001)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?XVMzCPN5XPKG1TvFRxdsvRebMYyGMordTzTQ+/2cnad4Q5zsPyy/hJd4b2?=
 =?iso-8859-1?Q?/M+Mu9cfDnmocayHfbFByV/K77T+S7eVnQ0dhJJStKBk+10wdK3+XzS+3Z?=
 =?iso-8859-1?Q?gj6by8xkNFhu+tGZ0Jq5njSnXmOnbcsDN6ZS3LNWo1uQWkNjFBHVx0Mjd0?=
 =?iso-8859-1?Q?RfI1nPnxvWjM7Kgkh0YQdM7S/1nhoBXr51cP8QgpGclpg0WNs2d7irtqV2?=
 =?iso-8859-1?Q?WuBSxAhk7148Fi2BkNGhEuTlBNIq75wWKWp6NGCfnAng3087zBKV3hqEEK?=
 =?iso-8859-1?Q?ILumbt6+VZyeIQcpqxsyNBFECyZhhH4XX768zXcIxiYh4hbd/igtyoC71C?=
 =?iso-8859-1?Q?5kAGhGsskf5QjlgIOrYvURuZTQaHS/47VZStuSLsGxgzVNcWUlUrNsEuHi?=
 =?iso-8859-1?Q?mqnKnWf41BrRhsB/MzSNy+LdLEvgriZ86RB1y2qJ29i4TiQQZ+Uqfmm7J9?=
 =?iso-8859-1?Q?KDc3/bhkuTqdfi9T/52h51TCZpN+hYaJXmnE4S62rDwX4t1qAR6c7NVDtX?=
 =?iso-8859-1?Q?p04dN9xFx7HrwD7V90kw/jU4RF5UBIvonlzrY7oFFKnRAg7KLoxnhxH3pD?=
 =?iso-8859-1?Q?YYAXODkO6S4kyEQSA7P3tLHjlkFhdEqDAfMrmizKJe+apuZM2124re/aIl?=
 =?iso-8859-1?Q?5WroiAN7IoY9Alr/5fZmrklNBUeRkPNGBSwJ7jOG3SafsmIp+l71HuRxCG?=
 =?iso-8859-1?Q?pjsB5v4+tJ6aZQRNaM+3/ZbRD8FVxZOoNI1eZV4DFT0Nah3RfaOObMOo/z?=
 =?iso-8859-1?Q?UsrKKD+hkAinSdETargOf3K5XBGC3HFEm3lkIKHGSLyyRbhk2I7DFQcmjv?=
 =?iso-8859-1?Q?Oavuo4oVKBR6aIPxf0N6GbxaTZvZvYNpdVq4H8W1Iw1AG3cbgsD5OOLIpQ?=
 =?iso-8859-1?Q?db0K0FxP9h0vD5atdXBGGVKeTCbsE4qmM9juRMN9F8vdRBCptJEurnT0MT?=
 =?iso-8859-1?Q?Zp9Ayxwt0zJUrfmubvCs/ETltL2lx7S2hwWm7R1e/IknF4midq/tLjOyFc?=
 =?iso-8859-1?Q?Da8p25gsHisM7E6asg0W+ieXTWZxzcjpw/csvyOzgtM52Mw5XSqS/UnEkM?=
 =?iso-8859-1?Q?goVuad9YIfy20YibyjjiNMI5PP+gCY3SQW4GRJfTgmxIvItweAN+Dib2hv?=
 =?iso-8859-1?Q?gMH2Gc7X0nShBwp1iBil8w/9Wrr0i4Nj01K3wL4va1Q74/tRE/oyWby5Dq?=
 =?iso-8859-1?Q?A1UTzR/YB1TI23qOsN33okytsXnEwRxS3LFzx0M7ctjekAQRlSH5XNNgwa?=
 =?iso-8859-1?Q?VDxeypNSuxNYWdEHXnQGaQe9mP872AyHfOBqVWvWylfPJh3TrszrebQhB6?=
 =?iso-8859-1?Q?ECpuoCU45JJFwdXjD4CuiiE4C5o/ADH/f/En9Hkt4HTgm4MI9/1CmIYAIT?=
 =?iso-8859-1?Q?x+GMGYWx6BRgVIyd88l2YaoMmnKcWtfwidPR5asnGEgLD/DoQHR9Nfvznt?=
 =?iso-8859-1?Q?PQJR/GVtd5bImzBuU8wGIOsUwaKocYka3oIry5WXh80D8d3ZIe+JZ43MI7?=
 =?iso-8859-1?Q?s+vKjZIv7l/nxA1lXWS7GDnWdNnBVdydYe8TowWlT4NMcSts5XekBhNFsl?=
 =?iso-8859-1?Q?09ksd7Z9gFOp888fgRpUcd57+HhWY0heEw9qmLxWrm0ZNhsVWecSdX3Z4o?=
 =?iso-8859-1?Q?nr2XKt5ZJEEyTWNgRfF1ip0KYq3f2sKYvw7UYwXIWrNJO+AO2VXjXAN8Do?=
 =?iso-8859-1?Q?enS1UGFEC61z8ynhVuM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106981d7-127e-4981-c2bd-08d9e74b5879
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:24.0855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tyUa0BZlxFK8MHvMmqW5SyQs5rL7pmtlJKNITdbUrxe4Oz96XyoX3CE+Slg6vyG9+2pWWc5o/Wj2jmwq+KgTrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

lat_percentiles is used to control if the high/low latency statistics
(which are saved in ts->io_u_plat_high_prio/ts->io_u_plat_low_prio)
should collect and display total latencies instead of completion latencies.

When doing group reporting, stat.c:__show_run_stats() happily overwrites
the dst ts with the setting of each job, which means that the summing can
take total lat samples for some jobs, and clat samples for some jobs, while
adding samples into the same group result.

The output summary will claim that the results are of whatever type the
final job in the group is set to.

To make sure that this cannot happen, verify that the option
lat_percentiles is consistent for all jobs in group.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 init.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/init.c b/init.c
index 07daaa84..7d5f2221 100644
--- a/init.c
+++ b/init.c
@@ -1445,6 +1445,26 @@ static bool wait_for_ok(const char *jobname, struct =
thread_options *o)
 	return true;
 }
=20
+static int verify_per_group_options(struct thread_data *td, const char *jo=
bname)
+{
+	struct thread_data *td2;
+	int i;
+
+	for_each_td(td2, i) {
+		if (td->groupid !=3D td2->groupid)
+			continue;
+
+		if (td->o.stats &&
+		    td->o.lat_percentiles !=3D td2->o.lat_percentiles) {
+			log_err("fio: lat_percentiles in job: %s differs from group\n",
+				jobname);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Treat an empty log file name the same as a one not given
  */
@@ -1563,6 +1583,10 @@ static int add_job(struct thread_data *td, const cha=
r *jobname, int job_add_num,
 	td->groupid =3D groupid;
 	prev_group_jobs++;
=20
+	if (td->o.group_reporting && prev_group_jobs > 1 &&
+	    verify_per_group_options(td, jobname))
+		goto err;
+
 	if (setup_rate(td))
 		goto err;
=20
--=20
2.34.1
