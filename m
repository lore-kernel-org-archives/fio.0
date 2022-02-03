Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4660CC4332F
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353686AbiBCTcS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:18 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240903AbiBCTcP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916736; x=1675452736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+YCBtAkQ4AWBUAGHmAqLFy/JVd6Ge8O85h7ztRVU7So=;
  b=FGcVNGot5itYcUEfyqmUQF0Oq6EC9sO7k001SucabasLT6YRf5ralBsw
   kQ7KmJebIz+sQy/w+gyKuseiKKzp04kv07ncWUnS9TBI3aQ1NLwzOc5UA
   q01nIKe33NxI3FtvPUdUTiI1V44isOKE029CjpdYwCa9z737LlnipSg3f
   baOYMHeIW5g/UWViwN1yZjBShXFPzcqnicli8/EVv02RVVD1Hw32Kt3uC
   QqhzeWR0NC0Ud35so418tmZkRFeUEPMS4dmxZgCVrq+iVCCRu7kl5QTOh
   wccjkXai9LcFu0/Zm3fJ4f2VsQID5HVsgj1bfUf4JNwydGIueQAuKv0lc
   w==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095708"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANNNxIrcyy33aT+ibHJBqkh9ayeGoRfWWZKHqWovWgK+PDI0QPqNu1Qd4xROxA8Ny+1iKPbr4TR2rrf95sC5M4HYzhTTMcDBG0auNJ2Fk77AQhH28oduDvpgIkzIsjiK22QxPsTFaIzUAWPAaMRxjZhjiSACZvX2OIPzFW90+fwcy11/6xUbIY3rri+EyswmUReNM6VWt9NTULbhW+X6Yv1dnc0erIwz3IiFwt2UHljQAvhoIsTF6HMwdz0ZLGq9W8xv+XGBGcHrD0aNt2URjKxfefx0WCdAN31LvF8yam9780+Wq020dFy5Gm7yDQwGr2l1EIkEqd/nLuXopf1Gmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gx3DOf4ZYuSvZCP7VIFgjkfBbk3YUXdHPxsA50DEYIw=;
 b=LXeuGSVjHf1lRxlwdp6Lu8oTgPIfQZKJRy/Y0Epv2tapmrKbVMEUAzXxU/U6eOs7byK0sfRk+OiQ3mBfknAFhFxyMoFFc8lCl3tzRfq3UWDQ6XH5CG+6H5VpqTjppMC858YgF/YtImNNJeVnvLYfGA2UiIIhgNy+qGvJTVir2/VAcmXcPlmlQMQ4PMF/vJhMewSzWoaXEn4gdQMWSL7hbXwmzpF8g9pjwTYDRBMqgs75Kqr3Pb0euCx5xtcRlNpuP+aZsWTbA+odSlNDjiGvVAEja9WDUSs429K8cIMs2tZ3RSNMnQmBLwGWLWkysxEWE7LGcnOtxaZbdZNEbW1EWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx3DOf4ZYuSvZCP7VIFgjkfBbk3YUXdHPxsA50DEYIw=;
 b=JPsnOo1wKZr1v5o1V7t+K0mvSSbSBhL71AniVNqORiaXnDrPN6BKaa6bbcqssXPgFZ081m2f8iEhVSfVDfgbPbAUTBaCT1CWmmM4/3IrRropbanPt8Jec4NaG01vvqD3QdMhJorMNsCNPEONltGHUp96n9FKL4Th9zYC0PtJST0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:27 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:27 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 05/18] stat: add a new function to allocate a
 clat_prio_stat array
Thread-Topic: [PATCH v2 05/18] stat: add a new function to allocate a
 clat_prio_stat array
Thread-Index: AQHYGTQ3GajoN6uESUiht2ZHtaljuQ==
Date:   Thu, 3 Feb 2022 19:28:26 +0000
Message-ID: <20220203192814.18552-6-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 4c1a6793-47da-4f93-b6cc-08d9e74b5a75
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4632B7283499AB31082E0730F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wp6pnKCIB2c9Iz0KDfrava1fIfZBOCAG3OJo7Bbaxio0ydsdViW1ZO/t6kVRh0bbcOyB2Q8DtK6eXUPtl2YvjOl89PEdZiqu3tmQzrdzY8odZENs6r7UFo/htD16rpQ2C4LPbOf7cI1FG8qBQwFWPyqz292b1M351+oP4utLCrk2va5Tg29KFVahYrGETaJBL332M3zNoTEOxlf43ym9/Yl3NEdC+ooezRPG2MOv/2h0XMinM6tWsnLB78H0ziTSlwZwvRd34LQfciW3oUAD1BJhedImQxm82xoyFqyrDA3mRi4H4sr2SjPdhoJuItA1kmIx6YOANOhDYxIpEtUtqVc2geHWesGAgzG2vdFouH4l4pW2s7a5xBwY4WSrMECe809AQALnVZIt0+h2Vr5j9HoFin1mvfylokdA0MuYk2auVCSlY/46d0RxHhNBJ4ZimNttVTmHUL7eH77svCpoM97moXuPMhyX7edSbcuzOz0gdtt5Eb3LQyChWR00VeTMIlOthKhGoYLZgfiviu0redUI8xHxtd7BH9Ht0qfoivws8KdZLnC2Xm7hLk1IYLEk6cEcq/nxmNrdBArBwBiX42xebU8nAita9EAjv3ZQLuxcBT8mzCXu15JZX1MPEzP8ceFckCPwu0d3S9bW1oa1LbAJn3bAJfn0X4J1GzH4a8Iicxfb/Gd9gN/S0gz1KWVI64iQat2b+XzH7xg6epKhSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZtMStnUg68L2c5iT68OcdYYDsYNEpa9ttLcmKJ1KViCRTIzwjh5h3Ewb8d?=
 =?iso-8859-1?Q?J6YGztChFYwpg+HsInIGpUrgt6UmeVyVGMsKHFYRErECo3LfOrTvW1y99t?=
 =?iso-8859-1?Q?GdbNzEeTYX/nxrBCHMwlA1k/lEhaC6OALxeRPSg3moPbFOA7Pj+mjpFPVQ?=
 =?iso-8859-1?Q?04GN/AAbH44Z+axM6tU1T9YUnUAde9qDpxOl/PpIiVfX/gkM5BMF3elNni?=
 =?iso-8859-1?Q?VZojBWvhfhbosAQSIXsoMRE2ye2eeC9H0X2//qrhzR9sXqZDwQTD0AyAIn?=
 =?iso-8859-1?Q?G9vn7d0mQIizAqYKkQToFnzZUmj2nnuZnxyXrodhuQI2BwArtoMkc1Cflb?=
 =?iso-8859-1?Q?Tb4jzZdCa0sbeLL0dfzdJN1aIK0UiSFhtSL6wBotX0WpmkRu8ApiwO45sH?=
 =?iso-8859-1?Q?J8MvyrYQQ1w86Lx1pN32KY0CWXTeTbZysiLm22vY9KH1wA38tSAsiTWpL1?=
 =?iso-8859-1?Q?F/v57tYXF4u3QMSCsCkvIavwGvhE/2OnIuM3sfBkNVtZfe3Z1/+qgY3zoE?=
 =?iso-8859-1?Q?voKdnsnoV3XCRWxf55aBH08AR8gils5Cha888PwVamOS2gafeDm1d0rcGN?=
 =?iso-8859-1?Q?PXu+hputuYEZCIitxxROYKY9lERqsOPIGYL0pHwHifEe/NiGEqPivMqclv?=
 =?iso-8859-1?Q?c7oBo57ZhI92lc++ACoUNGwZU7yqL+EyuUvV9f20UEHa/m2CrXYtT4d8sW?=
 =?iso-8859-1?Q?HytRQHjycOeddx3zpqYrG8OGYXhsfiDimTQHpqli9BqAlEpjlGO3sw97CD?=
 =?iso-8859-1?Q?odxRCXZqVrofmZr+bw5GKEmmtSMuCcCIAXpJNp/q7kmwP8g3q4NCdsqJRI?=
 =?iso-8859-1?Q?s8x7odqDxk/sF9jwjE7vnavHE60NwLv/1DypxkjnD5MbNg1QIhzykFQbnC?=
 =?iso-8859-1?Q?m/G2p94sW58J3v/b9L2U/RDFU+cujSvZm0LSOdxY66wLvOVbZuQ2KScmod?=
 =?iso-8859-1?Q?2wUTB7lH82YQAcOMPk6NuTgHmmWr51PbZIUvMpEtQ193KxddFMdPnfKSTg?=
 =?iso-8859-1?Q?NSLZRlbMka7WCZsrDborYW71ejwHNuQ+sL9W2SeG/Khg6Uufw+NHEN7SqQ?=
 =?iso-8859-1?Q?E6RNCSjkmJ6RHi/Lwfr7KqS0OoJrhZ4t6PAg/sET8+MtewQylHG6PDpGec?=
 =?iso-8859-1?Q?+a6Fhh/4e7eozZSRsyioZJDpFCMNYoDSgEg/Q5AEIRq1N33gVFnXYApEeW?=
 =?iso-8859-1?Q?WTNyz7kVMt3UGyrTGfZHVSr5m4PCFiMeFWJnv6kv9kpQVjc8109bws+rZ8?=
 =?iso-8859-1?Q?XrjaVYy9ys0kkLOEslUF8KCjb+puZK9vGbnDd6HAZR6q8ba0oTth4S3DzJ?=
 =?iso-8859-1?Q?PBoA74BqVr7GYe23wwST27QT+S4KWOqT1IWKPFmtnHXGrIfUYMbR54cPFw?=
 =?iso-8859-1?Q?nXIJVWZogk83TxZxJOEmXgzWw5dcEJVyhfImtzg/9tUv0T+UN2wbF7qcLx?=
 =?iso-8859-1?Q?gOcewho0mVabGPpwL6lcCQaNYcIHoq9EnHIZjYJ1EeCqnXLh1Jm6oh6hdn?=
 =?iso-8859-1?Q?CnTENYiBHRHeLafLkFGqPrZovdb5LRPL6/dQ7X0g7SOqbPZGaZ/tbZNMN4?=
 =?iso-8859-1?Q?mB3Q1gSG1ywBHc8wP0O2/pv5mHh3diX5XxOfs+YAujg4VEamxKdwvrDsf3?=
 =?iso-8859-1?Q?pSO3v6QuvLc4EpDEzVQKFUUZWoKM2fXSZmxKMJFi0wym+f7JSmXdI0jvqt?=
 =?iso-8859-1?Q?GQqpdWJXmfFdKH9ZPRo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1a6793-47da-4f93-b6cc-08d9e74b5a75
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:26.3508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: htH0dFjvuFN8I5H4ZRDIgu74PtdLxSllGRarmWDq3eqMXAmbRqPdiL1nEWOBsHlm0uYGA4POVasVoQrGlaqyGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

To be able to report clat stats on a per priority granularity (instead of
only high/low priority), we need a new function which allocates a
clat_prio_stat array. This array will hold the clat stats for all the
different priorities that will be used by the struct td.

The clat_prio_stat array will eventually replace io_u_plat_high_prio,
io_u_plat_low_prio, clat_high_prio_stat, and clat_low_prio_stat.

A follow up patch will convert stat.c to use the new array.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 40 ++++++++++++++++++++++++++++++++++++++++
 stat.h | 19 +++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/stat.c b/stat.c
index b08d2f25..c8680a67 100644
--- a/stat.c
+++ b/stat.c
@@ -1995,6 +1995,46 @@ void sum_group_stats(struct group_run_stats *dst, st=
ruct group_run_stats *src)
 		dst->sig_figs =3D src->sig_figs;
 }
=20
+/*
+ * Free the clat_prio_stat arrays allocated by alloc_clat_prio_stat_ddir()=
.
+ */
+void free_clat_prio_stats(struct thread_stat *ts)
+{
+	enum fio_ddir ddir;
+
+	for (ddir =3D 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+		sfree(ts->clat_prio[ddir]);
+		ts->clat_prio[ddir] =3D NULL;
+		ts->nr_clat_prio[ddir] =3D 0;
+	}
+}
+
+/*
+ * Allocate a clat_prio_stat array. The array has to be allocated/freed us=
ing
+ * smalloc/sfree, so that it is accessible by the process/thread summing t=
he
+ * thread_stats.
+ */
+int alloc_clat_prio_stat_ddir(struct thread_stat *ts, enum fio_ddir ddir,
+			      int nr_prios)
+{
+	struct clat_prio_stat *clat_prio;
+	int i;
+
+	clat_prio =3D scalloc(nr_prios, sizeof(*ts->clat_prio[ddir]));
+	if (!clat_prio) {
+		log_err("fio: failed to allocate ts clat data\n");
+		return 1;
+	}
+
+	for (i =3D 0; i < nr_prios; i++)
+		clat_prio[i].clat_stat.min_val =3D ULONG_MAX;
+
+	ts->clat_prio[ddir] =3D clat_prio;
+	ts->nr_clat_prio[ddir] =3D nr_prios;
+
+	return 0;
+}
+
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 {
 	int k, l, m;
diff --git a/stat.h b/stat.h
index 5fa20f74..188c57f3 100644
--- a/stat.h
+++ b/stat.h
@@ -158,6 +158,12 @@ enum fio_lat {
 	FIO_LAT_CNT =3D 3,
 };
=20
+struct clat_prio_stat {
+	uint64_t io_u_plat[FIO_IO_U_PLAT_NR];
+	struct io_stat clat_stat;
+	uint32_t ioprio;
+};
+
 struct thread_stat {
 	char name[FIO_JOBNAME_SIZE];
 	char verror[FIO_VERROR_SIZE];
@@ -280,6 +286,17 @@ struct thread_stat {
 		uint64_t pad5;
 	};
=20
+	union {
+		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t clat_prio_offset[DDIR_RWDIR_CNT];
+		uint64_t pad6;
+	};
+	uint32_t nr_clat_prio[DDIR_RWDIR_CNT];
+
 	uint64_t cachehit;
 	uint64_t cachemiss;
 } __attribute__((packed));
@@ -368,6 +385,8 @@ extern void add_bw_sample(struct thread_data *, struct =
io_u *,
 extern void add_sync_clat_sample(struct thread_stat *ts,
 				unsigned long long nsec);
 extern int calc_log_samples(void);
+extern void free_clat_prio_stats(struct thread_stat *);
+extern int alloc_clat_prio_stat_ddir(struct thread_stat *, enum fio_ddir, =
int);
=20
 extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg =
*, int terse, struct buf_output *);
 extern void json_array_add_disk_util(struct disk_util_stat *dus,
--=20
2.34.1
