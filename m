Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC75C4332F
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbiAaVNI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15171 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344367AbiAaVNH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663587; x=1675199587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZSotWcRnTCuPEUliyNVM1Dw8/8Vjcq5Msekv/nNSyrM=;
  b=LgCl1ccxNpQ/3oM6Rnn7pvq2Ijqav8vhV2DKDsipIkfNf6xld56g/a5f
   cT6X9bzfbVSEJRayQBXHVlcSsRgUGuwc6LUKxalO/Ne6keLvUK/8L4kjG
   8QvxKVp6eGOE3eri1kVelaS7jvdhn9W27yh8yfTQFUgN8WNvq957GtdsJ
   FLzHU+V8Iesv1qTiFEPLmJZwPaelHX1oefB6Rsr9fuyBXVsE3w9c8r4iT
   QKkLuYKOIGyAuYYvXscLXsnC1tnZwWhLvfZg+zJ8m75xZNxvqOu0kYGPH
   Qjlxr69PsnjaN6wrucqBZfGQ3Bc652Q7JZ2wmMIYNMemeXBKMd5qpSviR
   g==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720254"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yo05DSHyHGux8ApWFXWk9k1hqnNZAW4b1KGbBkuDDHFhRDvNSKi76WOxCI9zRFgfVmGl9um1P5Y672Sr/dhY/O8GHpFKGSGRlKQnNBWTJ5drRWL9nV0WCoCQwAWPpXwfw5V48QZ4KD1p7gdejwviosmGJDZ1ivDq9ZtSwEcofVVKRTFLP1Tn+R8jlxkdW5uXMCJ4Si9Hzh2o1a7fc9Df7IVDKL5Yy9kBdXN4YzWJAz4rqw4tBTjjC4ras9VlO3esAgSkZPgv+WiDf+z9efhR3GWH2AI9xGPN/tB2XPB5yXpM7Z1gk+xbKFIexdvoctKAnygf2duBhOtk3X+hZnfI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCFwsKQR+Mns/WRkuzgykM63fYp8WcvuPQ22f9dCxeY=;
 b=ONtrwULRYsdzlTWJCiy3rCuMKXDUzSuWCsft3+wSrVDK5dgPPYFJHOqdF1KxvI4N7Iqx3oxcWdPu3JKT5IR6Dl8HYbY383d5fgDSuz/o0sdYb3KSeQX9/MfSnuWHAft5VOElqUeCfa2XY3JAXokj0+IDF9FsLlXFY8C3CE0YsqEiv0ZG9CnoqFWLeQky4OjYqGMXM1JZRIlQbtEMjkgT5JuCBV3XVNGb/9V1LlaTWWncAW6S2PQ73WznzqO57W8FLFUFuLZCaSgrMRqlNjJHqHEo1e/BIn+8dIBpcjmUspvffWXNm6paN9MtEW/THrYBNV4WrQfW3WN6FHMnNdX2EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCFwsKQR+Mns/WRkuzgykM63fYp8WcvuPQ22f9dCxeY=;
 b=siaKMimKaf0JMitjIdy3vWpQxthoj8kbyCWc5Lh8mPCsPjlH4VMpXTAnd9poPBp1aDUGwhEzCKj7Cx7F9APliGPLhWtQKTtqPUYQ84GmI3zoitI3bPX8nAmHd/9l1sI11v1b1FPMIKfH6BCw6KHxFwqz9vBh9A/pAAJaPTavCr4=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:04 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:04 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 05/17] stat: add a new function to allocate a clat_prio_stat
 array
Thread-Topic: [PATCH 05/17] stat: add a new function to allocate a
 clat_prio_stat array
Thread-Index: AQHYFudV3flLCKzB3EqHcfjqHmXixg==
Date:   Mon, 31 Jan 2022 21:13:03 +0000
Message-ID: <20220131211249.106820-6-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 0641e90b-df26-4585-1f0f-08d9e4fe788c
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB75763E91A1C0E152F8663C2EF2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wDA+6Q9QWS7DLV2cZ3nAw3/2dOi/sS/LJq3HkWeFLc2R4bcPLRNZgBC2Hmp6AHAcRBrlPMI2zAfFj7pfteFnAgWjjfLzapQeiH9Ph92O86alq1NTuAc0vQSQegqn3oKRml6tlokg2k/Cl1+Gvh/Bku0EQKkxVL0DLko3hFhgVJy4dcvP8XFIBk6r+n9pwNe2tq65qFxtam/9SE9JgRVu8L2uFhVPJnizc54foLkabrYPkLuzQ7+5jJUe8txIuiz7NhPWIxawE6B1pv3OGreeAQqZVu7ZXyOcDintyAtax/DN/84LimrDxCJPV2ZSMZKL11F2Ynw2NHGe9GxVJdRgYqGyPSBFiZoDvTdfYsLBC+J0gMot2e9s1o+JLu/VTlUUzdIyboJLZZEaF2tl7cSoGwXZppryn9slzl/tGdcebW/Izw+qo7UOLdI4ujcJ5oq81vneubOdYIoi1RvJxgRbvzKYsx59Xwb+YAVlDMNQGbVM8xp1piL4zVukVPKYSvLydfZiwDKnIOZmpn6t9dB9ji0bOyPQ3Lcp3xxHOKtOvNrymM6vtoVKy+NfuU0jp+6wGTEeGldV2jyfeqvkVxenQvPBwWG1dv4FuQrIyy/DAi4CSpvdkkh+Je9t3JeGsSjWOnbPfRNYciU5ZH9d1MfBS5gdXwf2Hx7ja4A8ohu77yN7u99AU8FH2Bkb1XAkUHD647tzM5JOmjkgGspGHJHIlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PkELDq1Snqem9so4t3hQGNhmWKN8qKmGEhu1Y2vSgjj4QYmG/Ldc6lah9k?=
 =?iso-8859-1?Q?MblNCkSwlXZduIJqap5IthzuDMfGw0JytPtbX6glQVBLO4tjRueoruois6?=
 =?iso-8859-1?Q?DWZwTN2zj1ci/4JphYpql3HQchaFfvq1Sz9OCSoWVlHjqvkAYs5SLwQUsV?=
 =?iso-8859-1?Q?aQzm2lZmjqKI5O12ivz0aJMPa5RpxJM2zI7WJGBPV0gj4csIQeIxi8o9tY?=
 =?iso-8859-1?Q?wFFmv3tvx+2a9E7OAQmhPRoRcVxEyHY2FiwrmVudzNgzsYD+uVem8oou41?=
 =?iso-8859-1?Q?M/twgqfgcdBhSPK15DclVJ7OeMv1otKMp1e18ZtNU8hWjSt+ot5NW7LjJH?=
 =?iso-8859-1?Q?ras6sENANbqOI0x/Phm7oHxaw9R3Xyya+LJjkd4F70s1yS6S69tSV763o3?=
 =?iso-8859-1?Q?Fnq1JQr1ojxTSKjBBsVwPFBqBpVs4qj2ECbJr+gfzarRniNf64Vif9rE3g?=
 =?iso-8859-1?Q?okQeIpomx2mpusqL5Aq1O9MxLfp7GbPe63xQQ9hlSHhpXdyjHjJdBy9emu?=
 =?iso-8859-1?Q?wEGKHoxjKv8O/ifbAKGFqLkHhQCyzLFGyU10dV39rSzudU9imj1HTx+wtd?=
 =?iso-8859-1?Q?RobCSJCVvjE58XrwnMC2R7CgsU+fdnJ2NAmErDwR1ERUT3ySrZxJxgNFgQ?=
 =?iso-8859-1?Q?AzT3qb5VIGIFRhJcz8r1UmU0HqUhnsbYkEfkW+eIa/u93JJeQ07UEQv4wR?=
 =?iso-8859-1?Q?dZK1i2Qe1Torf+HoyjaONUoOQaQNCqLkgTOst3nvmplQvwo6Mp4BBC/mT2?=
 =?iso-8859-1?Q?+94UNJEp3I9NN885I1Nbh21IA0q7TAG94HQwe6ejxbseifL82vV8mpwpUL?=
 =?iso-8859-1?Q?rkffqcXrPNqIhqgD3XaHYvFZ69M0XQRsERe3nhrMccyG5cXaZahGcG0YYC?=
 =?iso-8859-1?Q?RIC+nO5ALaaNUzRjIE/YoVS25wylMaJNZneNUeVOZ0s1szkjOkLl0N8GOB?=
 =?iso-8859-1?Q?Lm6VKvBJZXcnlmOH/dO5e8rYod8KcEXdMf+lLbhY2mbC1LY7jNb9utfbFU?=
 =?iso-8859-1?Q?fR4IA0Np75CN95t/uBjdxc9hA/dkKFu8K20JJbD2n3rmSm2UDJeC57VeyP?=
 =?iso-8859-1?Q?Y9IJdGgJ6ZMIYxE3AxjZvSqH3LAwve/4MyoSmRkRSbmwgcmEyRfgc1bNhi?=
 =?iso-8859-1?Q?ZODVYdxUtjkdJxBsk/E/3UaH9qOvijpt1CK091cozk3118cDIGf/J576jz?=
 =?iso-8859-1?Q?fGvfERM9W8+uJlENJi3UcB2B3fGklhkTQqjMYbY7l2k8odXJH6p3e5KGjC?=
 =?iso-8859-1?Q?nDnJ+Ek+9vU6yz9AfW/9QcQ0nxSJUF9WockCrLq6Ai0oJhaTa/u8VimKx2?=
 =?iso-8859-1?Q?fRbBVPY97AQNcfBXD/pRqBTD4Q3BU9QAk7TKFtE4ioOxP98xNNU9Z2+Vj4?=
 =?iso-8859-1?Q?nBHiy8TYyiBo8R1K4OS9RR3eFOgwQra77nOSqQjwoJWC3IuXr8jt2KU2OP?=
 =?iso-8859-1?Q?T7ZFFXiAqHDXF0c2822Eb2sw5bkea0cdoxYbI2ZBuWDWBB5T5Bcwb8qZHy?=
 =?iso-8859-1?Q?TfQwsvBfwG2ZW93FfGJ+SHEeqjxaLg/CG/Bzh+I978wx1hRrm7Fo5ptdpn?=
 =?iso-8859-1?Q?JjC7/ka4qiYbOy7mIJ+1l7m2FuVzCMIJhC3XA0+TbK93LEXLJ1N99D6YHI?=
 =?iso-8859-1?Q?HtvEEeoOKm3xVxTYj7Ee6TV+j6rGcHRJPFkb/1tLDUaDqRrMOqqP6wz0bi?=
 =?iso-8859-1?Q?d7u3UZDZwSrcYpLni7HGxsOXaPeM6qFnr1tXjC0z?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0641e90b-df26-4585-1f0f-08d9e4fe788c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:03.5681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v7RnQ3W+L55joBELo8wfz9RlrdmqRgCW11Sft0NZ2MT3S+SD1asdH7zjtTw+feuxmUyRXOGpXfz2zZLRFA3gXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
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
---
 stat.c | 40 ++++++++++++++++++++++++++++++++++++++++
 stat.h | 19 +++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/stat.c b/stat.c
index b08d2f25..9894ba7c 100644
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
+		log_err("fio: failed to alloc ts clat data\n");
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
index 711df24a..1e720ad8 100644
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
@@ -260,6 +266,17 @@ struct thread_stat {
 	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned=
(8)));
 	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
=20
+	union {
+		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 * (The union is also needed to pad this field on 32-bit.)
+		 */
+		uint64_t clat_prio_offset[DDIR_RWDIR_CNT];
+	};
+	uint32_t nr_clat_prio[DDIR_RWDIR_CNT];
+
 	union {
 		uint64_t *ss_iops_data;
 		/*
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
