Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01243C4332F
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379722AbiAaVNS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:18 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15176 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344409AbiAaVNJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663589; x=1675199589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=69fVd2vbql1BkJXAsYJ6suNe45YenrgeEj+mIpK+3BY=;
  b=R97GNigjGxptQZlWB+nibg0EFVlLW/bxFGqO+8xomlH0pZS3vq8DsHlP
   fSGbM1uDqreUztMmTugS3lSa/c/65wxcbzovw7Algz7p9dWvexCWUHWNc
   E5P11kr92c2Wpralc8sqteM8GtkjgDeF9r7uyC2bKwL4s881N9uIt+05K
   noioeoXoo0+VI0fn0+Qe3+nkSHr/GSJI0cvCMIrWR5WXLtu/4fdi/tKbV
   oaGlC0+rjOyyDxcQU3PiI1VG3HjbHqB0o2gf1V3bls6fUre/FVFj2p7ve
   wOLF7YyLisPSE27zyPhiWC3IJ/8eI+2iNmkGgH+VathOmQDylqHXfXvN2
   w==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720260"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViJ/oowALu1ZaMHlDU9kTNacBymsUe9T829o+klNyyrdzYO9EnPTHwiT+5l7iVbwU523CPHfvktSpj0pLWsSrf7QroWzLZJhU1DBaFQwwkn2YIwCwvjF5GlGi6VCION+9hAge3pbnLSKz3of/VmTjWziZzOyVSgffJm5cVJGpLAg4aWFUy10Me00s0Xk6fCCtTydMdpN6ON7SEUBPKQLIzDt+3XnRUrxqgRAotAiv+RjsJq8jvMt6vaZMUcrP8ddZOpN3vUyPGXoB/2ItGdbWYzEU0xop4uw8qcoEbi2dj62OszcA6xwFOUWTA+v3nwXCMAfWBfZQhgWpQsD3afPEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wACKFP973/ugXQUDgpdQW+oY6xHzj5LEGqKNH3UQmeY=;
 b=TyvR0EYAlGICkcQAf6RTHdGRvIIXqtURxFZrAgl+yQHj9ry9ZzcMefta2Knp1Unk5Nes/nPugPE80snp1k8hh7RYYmOWH+z19YCh/jbtfHIswrq4I+CnWbvenU6qH98txyvPGcrYZvcHp7Ob+3pZBlPQLtu/2L1fohcfWvVpb9NDiXL2mIZ2U/qt4W1TD2u5q6ENuaVuLiKedfqigxPQvxnV3shywFWQgoNZau1tOsKBeuHy+mI7vzAXw8HP/6sKqPee/pBPBl+vZ+JKmVJ5LEEJZgrFPq3k6/vjf4UHmkk4OuxzWw6pj+qEB7/zbN7orQm1ewMNfStd2hoRp4EuOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wACKFP973/ugXQUDgpdQW+oY6xHzj5LEGqKNH3UQmeY=;
 b=jZfxCBGKl3q80eAavmVORfDRcFp3tEP89+fkcfhoCG6SepBuyfNW9HKRNoBPj8AAbis0UvwashvQrt/f6ppLeEfQEhyDfnom+4CTrChecVd9J4pl2P1qZ5X8f4M93ZsnTN44BaLL3EEp9aC/Rgd+zSiYjd2NhYzYLiYFnBEBIXg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:07 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:07 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 11/17] stat: add helper for resetting the latency buckets
Thread-Topic: [PATCH 11/17] stat: add helper for resetting the latency buckets
Thread-Index: AQHYFudXwo03H1kXiUO9FJ+7F0MhTA==
Date:   Mon, 31 Jan 2022 21:13:07 +0000
Message-ID: <20220131211249.106820-12-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 545734d5-5a59-43fc-cf28-08d9e4fe7a55
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576E299C35699594E76F5C9F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T76J53+NQW8yaleH279varY1BDSD0v0vIiORQsDG1ppnbawH67/aK3DgEY9SURda8MBKboDl5B/8f7w79EqdkgrnbLH1tOzZRN/6P1itqRk9rusBhCP1oh5nPf6XBDGLa4s6Bm8FVE9+7Kh4YVaIu3CE+G9tMGNspWJLRK75QXw4fTqnfIxYhuAAgOOrDG/qgGiaLVhjCUpDvBepGhlwqWpIPagZ6N1QHWJZasRKsAuQ6LsvchB7YvWRgmnSlaCNS1FMAPZNWyC+jHaJ1bnamDP0faukvDGCioLsxo1PsIoCSg3fl5ENJQYlIbe/fDlYdkvUcGfvdwfVhDOkuAH3+6zZomCZvkp45+6aZHe0/GG8KdwktUHe2142JKGZUk3b7BWY51hJR+tjeKtBfHdpR6Q4968hkcLRtduCPWarEI96S81m4PKq6M2ZdEH0QN1yIScauUmFG2Kvta0JmlLiOqc4yYheb3wSISzn5OOkMurzLxteJ+NwmY9qdJa/6wLp5HlwUBoWgnDEvkXiHvxIM7347RPQcRt390d/cY/HJs0BZsw9KChzpsNY4bsHurd9CQEbENWneJTmTqZCApL7R+YEEbRT8sT35XBTWC3qMsETxyyxpvl7mHzxY4j6Yl9elIBIffeAbP4/EnNTb1ik6SXJ5FffBukdjwHITeGQPVQb++QiQBddaKwh55NyVdS/m7/PvoyFoPsJJI7Wj//8rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?KQyhfynz+hlFMQF5po9MONtLM9nncBCV7oNOOvUuiUIM8qjLz70ljtvy4l?=
 =?iso-8859-1?Q?MM9u7P4vPXcnn/WzAtNy1jsYQOEZSrgehIa2LyObymhzWVq3/jXhXEyoIX?=
 =?iso-8859-1?Q?9tP3z8WhbmXLvemSIoFQxpuGYRCQbJAIx6z6wBVvbIMoygLKKVZ7vc/DgQ?=
 =?iso-8859-1?Q?EL1qZSVHWbWH9+5TC28HbzCzvWFzoDfvb29+iWrg99y+3D1j3Q4uwSWhQV?=
 =?iso-8859-1?Q?WajJMO1pebbNa4+G0hLfLSOPLVmqi8lchnvKXdId1VTE+CNm2O2AZmdTjM?=
 =?iso-8859-1?Q?CKng6nhoEssT6a6icknLGP38hqp3LEuI4awwiqCjSZUY9RvNsp/85gGXwd?=
 =?iso-8859-1?Q?kBAdUIWmBGW3G0yKLLQRgHQ0pUzfdhAoV5hDSqHbNXkE++LowUxVy2iD5X?=
 =?iso-8859-1?Q?UAW74XDOoOzUmRgxKv+4ibimud2leC0+AdMxTIlTR7Q2VWrOYdR0neEYkC?=
 =?iso-8859-1?Q?dasaREKvkah4d7abwAhXeZ8Oz4sIXfAR/Z10ITa99Xhawb0qjcM58q5P8b?=
 =?iso-8859-1?Q?4sA0rnA2Dz8t/6+F49K0jPtGqM5zQQwf0yqoZErh5t1ZXd8ZQ/DgApzRtE?=
 =?iso-8859-1?Q?pQ+VMncOBIA1gjrEgBb0IXZo21gW8tdwamGn+YpEtkHzPDvKgVKvClxJFX?=
 =?iso-8859-1?Q?zpKbsKTkqEq/LfjkkJRuiJ0TrXBF30L1e2DIiNQMorqDYHer1M68qBH5uh?=
 =?iso-8859-1?Q?zi537aGbLhzPF4+o7vnmMyShJ3HDtuKTLuMI0E4Y1HePDBD1UjYhB87ajs?=
 =?iso-8859-1?Q?+0K7Zo4EX3Y1RR1eMqxEsA/q/35JUMyStz81AcC+HrAkw90vH1qh/NjQfh?=
 =?iso-8859-1?Q?b6r5/Lr0zCnKaI1PltTDvCfE4yNdbFxBW4R61Pq+x78+KBRU3c35n8KATd?=
 =?iso-8859-1?Q?EMOY+rGNG0IlGWGPnWYtja/Jp7nVQv1B/llNcE7wz3sGe+7V1oMHOCnC+9?=
 =?iso-8859-1?Q?uBYq0asgXJq1RQa9dJzzP5+HRy9KA6e3/+txyDHFPLWDQsusimp8iSdH6O?=
 =?iso-8859-1?Q?bZXB07RsI82GW93R+qQJyZO0AuBlCudjgPM3VSQmlbMTwM113vKVpNgrE1?=
 =?iso-8859-1?Q?oLsgh9AJXOtkxYpZqtIWbfxADuTCigPazWen0/eA3y02qN6Q61iS8mEgY9?=
 =?iso-8859-1?Q?GkIMRfpgy7HcsN7NcSoRPCdBZfM3tyOjVUXw4e022irCCTPb/hW8YKYhy3?=
 =?iso-8859-1?Q?56SA6jmochPg8LDD/xIRd5iOwC36wDcsBMLkSZ++TVMmXvgY+eJjIVCUXp?=
 =?iso-8859-1?Q?x65g+BT0aSfiBwLgzM2Y2VSBgYCLCCrlzG123mS9Iuc2eMvB3dYLf+RPv6?=
 =?iso-8859-1?Q?1ePptI0o60Zws/MGd1Xr5ZNN686XcpcMmM0AOL+H+ol3J4M7GJD8rIbfom?=
 =?iso-8859-1?Q?UYHcGezeDFzZd08tcNVrxYsLO7V9evv5mQ39ld65phj+OU2zcf15TcML5A?=
 =?iso-8859-1?Q?oUlXG2owHZTb3ItVRg7wjF269+iAUpsmPyxPDOjefpY0N13AbJ1IrI1HB7?=
 =?iso-8859-1?Q?jdrfzOHxJCxJtxBB0K9+Wos0DgvaFv0iZ05YKQKXvrdyeJtIaHspPvit6X?=
 =?iso-8859-1?Q?WRaCiRvSPN4EFufaoRxjBOlvN6bGM0TcEJ+Xu7gAmCfKx+rbe+jiKchYPR?=
 =?iso-8859-1?Q?v/kh2IPI/5lfhCD/r+mt7xM5uVucOO7geY8yD9adLVp+hGN6M9yeKKrAGA?=
 =?iso-8859-1?Q?jjzDOpLP2p5fK0uLDdXE/5ejnODXjTdseeUOdy9l?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545734d5-5a59-43fc-cf28-08d9e4fe7a55
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:07.3656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Ss2jWHcZaZYNNx7PlxFR9EVAQbb/24HIX17ey2xRslKakon8q/3ps2SFRgvssusLzbaresUz7IIC3jNt0kSoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add a helper for resetting the latency buckets, and call it where
appropriate.

This makes the code easier to read, and puts the reset of the DDIR_SYNC
latency buckets together with the other statements for DDIR_SYNC.

A follow up patch will also make use of this new helper function.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/stat.c b/stat.c
index ff33174e..7f134d35 100644
--- a/stat.c
+++ b/stat.c
@@ -2786,10 +2786,18 @@ static inline void reset_io_stat(struct io_stat *io=
s)
 	ios->mean.u.f =3D ios->S.u.f =3D 0;
 }
=20
+static inline void reset_io_u_plat(uint64_t *io_u_plat)
+{
+	int i;
+
+	for (i =3D 0; i < FIO_IO_U_PLAT_NR; i++)
+		io_u_plat[i] =3D 0;
+}
+
 void reset_io_stats(struct thread_data *td)
 {
 	struct thread_stat *ts =3D &td->ts;
-	int i, j, k;
+	int i, j;
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		reset_io_stat(&ts->clat_high_prio_stat[i]);
@@ -2806,20 +2814,16 @@ void reset_io_stats(struct thread_data *td)
 		ts->short_io_u[i] =3D 0;
 		ts->drop_io_u[i] =3D 0;
=20
-		for (j =3D 0; j < FIO_IO_U_PLAT_NR; j++) {
-			ts->io_u_plat_high_prio[i][j] =3D 0;
-			ts->io_u_plat_low_prio[i][j] =3D 0;
-			if (!i)
-				ts->io_u_sync_plat[j] =3D 0;
-		}
+		reset_io_u_plat(ts->io_u_plat_high_prio[i]);
+		reset_io_u_plat(ts->io_u_plat_low_prio[i]);
 	}
=20
 	for (i =3D 0; i < FIO_LAT_CNT; i++)
 		for (j =3D 0; j < DDIR_RWDIR_CNT; j++)
-			for (k =3D 0; k < FIO_IO_U_PLAT_NR; k++)
-				ts->io_u_plat[i][j][k] =3D 0;
+			reset_io_u_plat(ts->io_u_plat[i][j]);
=20
 	ts->total_io_u[DDIR_SYNC] =3D 0;
+	reset_io_u_plat(ts->io_u_sync_plat);
=20
 	for (i =3D 0; i < FIO_IO_U_MAP_NR; i++) {
 		ts->io_u_map[i] =3D 0;
--=20
2.34.1
