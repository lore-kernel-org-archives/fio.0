Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AF7C4321E
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353762AbiBCT2j (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:39 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18768 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353755AbiBCT2h (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916517; x=1675452517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GMym5Hvuy2dvK9apc+J6rEMXD71Lz4KKGTUa917mQ1o=;
  b=OlExiUUKE1KvgQjBEOlIhCZ/djKZVwu/GbRILLRXZTljooYRztUJtMXr
   C91zhfNLXozJDr9Ip8Zq8IDpeoDTd88pqffW4SFk7YJf2DH5k7wf2bVq7
   v+jDKZyuYuBNcl0L7xjqtTqvbUHyu+Rx5W1rbVwa9WPFAFvDmSJVd5OU5
   KvYGqs2Bep25vDorI1G9QmryaK6VYpR3UfewNgLQuQ0Bcd8jZvgg51mE2
   ib0S7N/YKAu4ksXTftG8G902DKrupYd3JnGlZG5NptsxZ/LGTbuWWS2sk
   FSZQLPFK3BOzh5LfSZ2dJvz5mj/zeoa55NxAvmu/zIiJqjB8PbCIFCR/Y
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="196918791"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=le6Qh90yB/mbUQr8cKZ/BhPB9U2LAKXSQhQ/YZVInMfbNAKO1lVoD68OJqwbyA7yLrRAkhKO/ie2DAm/xC4FUA0lNDoKbdP99r6CsoxqqtTelbF7bH1gZKw3uivusS493zQ2EfukmEJOJAp3FXzcYCHkBn/pWzkQiwYR4b86MGyCq7IcO7c1qX5BYv5x0dYoCsoziymxNjwIXRAtJADlZ2QeGRJyIh4e5Og9kfVs/DDesAq2xutu4ZWD9SigjCizdsY+EK59oZQUridc5jIZgVV9DSbd/vrAiESXovihL9mzsX68jwZ8GnyPZDUx0L581+W2oXrw8WX707fnN8TSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQR+AJL4RSGSh+IofPEyGBJc54SW7KZXbKTau+517yY=;
 b=FiP9vlKlM2Fh8fq+wM5BeGzfoQPMKIl2WB9v/V7f/ddgIekoAdzjhY9lmcakAHtN4nh59T8TL/HXxp/H6tVuhCYsTSY3WqqdMHt6VUQcKDJMsmbCIUWWRXB4MziO0mF+JfaQyXipzbjuShjm8ZeHAuvRFoGcHg4kF+vTWQ3DQ4FUvuvAsMJtx9MMErxTYFsrB7FfCVJd1OU6ljNVnrB2vgcF4kqIBH9uwK0HVxlXVX8484vjchoY3mJSL0u1scY6eYJzKlPuMlr2ER+oK6K38oo0VQMn7AuAI6OxlsuF8X+aHI0ZBVRquUI9vTKsmFKAwjZEXOngWQPCvHkqIdtI2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQR+AJL4RSGSh+IofPEyGBJc54SW7KZXbKTau+517yY=;
 b=jMmCA1KeS2onxicWDsT+UK4Bk7WUYDORnQSxPg1fdRt24yKL75Ie4m4p0Cest8dWPHh9QQyTmPpBD8eur5zOWBY/jrFUHtmC53nD8QiN7RBXBlSHtpmkNS5zk+JD1taucnSf+/5IHaSio85nmwa5O8uRI6O/HccVGF6s+zHEnIs=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:31 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 10/18] stat: use enum fio_ddir consistently
Thread-Topic: [PATCH v2 10/18] stat: use enum fio_ddir consistently
Thread-Index: AQHYGTQ435XW0RV7NEOkiBBhhEnvVw==
Date:   Thu, 3 Feb 2022 19:28:28 +0000
Message-ID: <20220203192814.18552-11-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: dc08a338-dcc4-415d-47af-08d9e74b5c8e
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB46329F52B46B676C0A900BBEF2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ttJoYpiwzzPbz6wISSPwGzLUvE9nYSccDG4y2/fnPgA1u/Xg+gGa0VTz/TrbWu7iLHmFoLxKTqLxdtIAeHWNlvb/ws385/kNC0ajuD2VbUdutgCxNQdRu5cLH/itdqLvh5KdbA/Hhtw3Ze2GUvPh/9iYL0ba8COFf1Y3uz4JGKuAUtKXOeOZ/EsQ3Ncm4OJm56KX56wEPvLmjKtYGn0wxTScuUwhQddkdS23YMY6JumrnWGRxymRd7J+OJu2fC1t+PytQ7BWeupof1uUZu2Fnk+MDbHUll9uZGdHMUxDbZlHvsRYqWRnrVl5wT6t0bus8lIInLRy/aD1FpCyjWgFaC0wsCa62XnsAB8BURmmPE2I17LvkDbsRbw8HChgCWrjG00qJC2nIVEgm6zwy+k5brhP1d5Wyvd5NVKK7yWxuOts2OJDY/N5m+OgoLOk8jR3ZZVA6q830xJL1tcAJTaFONxy6xkTFHafw5szxCaxkJoeiDYb4zOXRzpyfmhbniCJM+stGvikgf1kNT3RmFqxZ+8cuT4DExxL1+A7AuNttxR1aCEBXUfKw05lUI6PPMqOAKG8sR8HRAEnKNYvufumILTDTT2LY9yA8b1pZl64Xg5w3BVa93LkAtlqqrqcVxqDDpryOG+VtZy96q0fTJe+ItkgnRKkBMzQBSfR1sYLi8g7wviapPQX7x9KqnOBfzKeHmY2T8ijMmD9N8g4hLZ5ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(6666004)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZLlFnHDFpTALLweD4a3IqvJkPA3hqJw7FOCf2esX6Fn3z7GPfH9GlY/1S2?=
 =?iso-8859-1?Q?pBprz/NkGIGB0rh4+RDZbfl7DVa6LWV7WkzLRkROg3X1ufhfM2XPFe7s0p?=
 =?iso-8859-1?Q?6LeFeA23SCmhXmVe5GP0BMndSyfci9Nw2WE+w3ycNhhj6Bu84Y1v3LbNoV?=
 =?iso-8859-1?Q?QwfCWaJ0WLpg6qh4vnDFZs4E97YeGHgLPGaBlt7h55weH1XnLAdAWHBfMe?=
 =?iso-8859-1?Q?tH9kHVWT+kF9bfCIxDNhijxBoiE1QQIkj222/gOoj+bB4Oez36BkkugkHa?=
 =?iso-8859-1?Q?ZU39rLE0msAH+usnk+nN2dOMWHQC1DZAN2bMozlKLH1CDm36hdGQRlgX2o?=
 =?iso-8859-1?Q?VVxhMhb00I5Xy5hadYGyt2O/AfJcWsFGdZO+h3YgZZnDeO/ofFSVe2z4rb?=
 =?iso-8859-1?Q?Y1OxOnM6rRPoD8Kil2UfcrfDPVE2bzLtNm7NJ1lfAXiiP3cEC9X924SEe7?=
 =?iso-8859-1?Q?dq7B4XDvc/dS4epu3+J1TsrUtJF6WuxRTf0otos4FRR+E9W/gxwOJ2vsZm?=
 =?iso-8859-1?Q?LMa8tKP0EfmSqSopkSPNLQ0pYU5pYfpsE3sRY/CgJ4QR1jzZwfd0eekrNN?=
 =?iso-8859-1?Q?TzlUjFtjwsBZE4Wf4ymjjXyRBK4JKtgYpg19PWjdqQGYVnFYarAeeTfxpR?=
 =?iso-8859-1?Q?xbeAto396lj8c5n8ujwfHrb3RV6pK4eUy4s5RxHevs3W455HgsKmRfNMBt?=
 =?iso-8859-1?Q?LR56tOtruvDjYP8Tmim4zBA9Sjj35B2nNIEMJZAN1Ms9X8o7Z2+5DmLerp?=
 =?iso-8859-1?Q?zzJ+fwp50Gw2CVbFY7NaqzrXuqOyUGOLD/7zpnCzkD/gAefXvzk814l521?=
 =?iso-8859-1?Q?FRZSS5VetK7ycuSd2VZ3dvyezs2lAqm8HXdTGsbTODCLWaWQIqRHS/e9lJ?=
 =?iso-8859-1?Q?0UGpFO419LM5yeRFyYaXtbq9Ft9hjmVaBhNwWoISsh43L3/2ov64kpKzx/?=
 =?iso-8859-1?Q?Jy0QQGucsaDMe2z3xnoTKWXBlccLNktsFNQDLUfd612peZXXluNVXJZXxt?=
 =?iso-8859-1?Q?xanEwjUAtPVWEolErYXdFn9Ln4rAD+e0BD6ryo0KWvlDxJXYkZ2peA8DyS?=
 =?iso-8859-1?Q?drQgHZelRPrLA5Ba7RvKP0rP8S4ib2jXtZkIQdtZa/bv2b44WPyR4xEidM?=
 =?iso-8859-1?Q?9N2sckn73+CJE+rrLfvCIDOno5s8S6xitu1FHeXYa0arZ8n+SJaQpeT8ZR?=
 =?iso-8859-1?Q?hxnnBYZgULyOlDXbbs4gmjzkRK6Gn8VKaPoOnVzM/Su1T6hu0x6FBt0o0P?=
 =?iso-8859-1?Q?LhNd1/4F1/6BPcNblYlQDNsoSwun6MycxukHdnMS5vVFwIoE1msM91DVe7?=
 =?iso-8859-1?Q?+xVk/3IYnBWxTf8DkKCBMY1DYSPkI7uqWvdAZ6Xed+7J7b7v8VNwfOeMQ5?=
 =?iso-8859-1?Q?1h/hVax8hsPWawyRy7sLMUinRBDwV+1N8xBs6upLk2imfiUWltkwmuAbZS?=
 =?iso-8859-1?Q?tubOuG74lC+/7AvBYMBfCxEROhC62UoS481ZUCtpagwEH6TsWciuPqVU1K?=
 =?iso-8859-1?Q?q8c7CyDKZJQtiCHeQWrtIP1dE3su2mKmi4JnmIJ2L1f2qiZZhH7MnbFi8c?=
 =?iso-8859-1?Q?E4jp+sMmtMX+7OFQrT0G9r5ozsaZjl/qqhC4mOSVXE6erSy5UCcpouqTZi?=
 =?iso-8859-1?Q?Dqa3Hqknhr8NRDkmgmwbU/bSCXAnTi6C4vLuauafj2nwQ5RGUIe6jx3aIq?=
 =?iso-8859-1?Q?JBRWWYQFRbPYNSiexVQ913MzC5tL4aIAC9HlvVeC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc08a338-dcc4-415d-47af-08d9e74b5c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:28.9454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pAUMVVUHvQMbzbt/MyreDWAKDaBkFZAoLUqFfNOJ4Sv3E+ppCUFgvR59X0v54gb+iBnVnqifh+4Li08+VrvVjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Most functions in stat.c uses enum fio_ddir dir both as a parameter
and as a local variable in functions.

int ddir is used in a very few places.

Convert the int ddir uses to enum fio_ddir dir so that the code is
consistent.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/stat.c b/stat.c
index c8680a67..d7f7362b 100644
--- a/stat.c
+++ b/stat.c
@@ -491,7 +491,8 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts=
(struct thread_stat *ts)
 	return ts_lcl;
 }
=20
-static double convert_agg_kbytes_percent(struct group_run_stats *rs, int d=
dir, int mean)
+static double convert_agg_kbytes_percent(struct group_run_stats *rs,
+					 enum fio_ddir ddir, int mean)
 {
 	double p_of_agg =3D 100.0;
 	if (rs && rs->agg[ddir] > 1024) {
@@ -504,7 +505,7 @@ static double convert_agg_kbytes_percent(struct group_r=
un_stats *rs, int ddir, i
 }
=20
 static void show_ddir_status(struct group_run_stats *rs, struct thread_sta=
t *ts,
-			     int ddir, struct buf_output *out)
+			     enum fio_ddir ddir, struct buf_output *out)
 {
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
@@ -1251,8 +1252,9 @@ static void show_thread_status_normal(struct thread_s=
tat *ts,
 }
=20
 static void show_ddir_status_terse(struct thread_stat *ts,
-				   struct group_run_stats *rs, int ddir,
-				   int ver, struct buf_output *out)
+				   struct group_run_stats *rs,
+				   enum fio_ddir ddir, int ver,
+				   struct buf_output *out)
 {
 	unsigned long long min, max, minv, maxv, bw, iops;
 	unsigned long long *ovals =3D NULL;
@@ -1407,7 +1409,8 @@ static struct json_object *add_ddir_lat_json(struct t=
hread_stat *ts,
 }
=20
 static void add_ddir_status_json(struct thread_stat *ts,
-		struct group_run_stats *rs, int ddir, struct json_object *parent)
+				 struct group_run_stats *rs, enum fio_ddir ddir,
+				 struct json_object *parent)
 {
 	unsigned long long min, max;
 	unsigned long long bw_bytes, bw;
@@ -2353,7 +2356,7 @@ void __show_run_stats(void)
 	}
=20
 	for (i =3D 0; i < groupid + 1; i++) {
-		int ddir;
+		enum fio_ddir ddir;
=20
 		rs =3D &runstats[i];
=20
@@ -2861,7 +2864,7 @@ static void __add_stat_to_log(struct io_log *iolog, e=
num fio_ddir ddir,
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 			     bool log_max)
 {
-	int ddir;
+	enum fio_ddir ddir;
=20
 	for (ddir =3D 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		__add_stat_to_log(iolog, ddir, elapsed, log_max);
--=20
2.34.1
