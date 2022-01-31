Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8010C433F5
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346934AbiAaVNI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15171 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344870AbiAaVNH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663587; x=1675199587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=beH0qANNPWmJCDxoPK12SvagRPUL9sj2kWTzZZwchpw=;
  b=fyLLYmsuR7IdLBSEjVpArDYdnNImyxGV63+0ZzZ9rL78pU81e7tcHGT+
   Ip4vk/Sp8W2uaArihuIjf99ldPHQMzgi9PRjjwer9Lb4Eg24Ea6k/kdLU
   Xn/BsFYcYsTDFPlqJ5oVRMo6prwsWVLfTbWyqRoSAImYqxAW4IRs3x0BX
   4u/c//4KeypjWdU+Fq8WiLllqefLM0weQ1p8E8NC+Pgho+dcxNpBkcShV
   t0c8N52NaSJp7SuYLuaGJ93uTGLIreWaecC+HiI9YTZIcTj9I36xgKX1B
   rO/2mrwDm45QY280gVZcoun7oPTEOaaJGVbO5s1BCfBEd/nIwQnp0jK7g
   g==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720252"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoFia3qDjzSCyF8oN+PzW60t46NTgHNJE84xae9K9OtC6qU85hcZb9Irij/FY2ZVzRZKhf3pNpGcbYcoylFcY8f59ZiIH3hXpaf8tCs+n+XX7Lr04/PQHPDPVa1lCKbJuMrZwoS5DhNM60HtqjoFlRJoBd/XjxbG8EbT/89x6p8kpEhGlblixm2C8kxLNVyZl1vfiE+Q087yew0hCvN0pWzwl+6jxOLkAvYE/EAk6NASUEP4uyDxQ9i4+cy+ipwvF7iNvog+KhSFvLcRVbyKnRggOH3O7Lgk4Zuv8w1Q9gWIRKkSx3KIPlDi8E8mfITcsNrQBXCfx0Gj3qCb9d1LFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izK8ohHwBIz8jduyhop5K3w6Fhu6qAvycnWqSKgBh6E=;
 b=eZ0cJpoqPQJMm4c3BhhsTSL+U0LhlKTDmRGRkrrw9pQfdCudq4mATPm8Qy4Uh0fR2V1l2gFk5BTPp2igXcBnDsgUKfw/4vwWqV65Jj3Qv9yaP4wCbbp4VQmN68bNMRDalNtJXvietE10IimNZCiEyO/cCqeM48MEMI1ibsWAu3wFWP47ZTwVowTVn8jel4OwaY0qD8NAEUhgV0RQtQ92p9x4L20Le11NahIWKzBHfa7KLlSeO2zzKUbBgPBJB76CdBjB9HDOQmobuLf5DK4f52mnTUahjaw/bdp2LD+hPBncDd7QXHcyJG8NTAryAWIakdx4GhtXAKcaZTw5tzIGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izK8ohHwBIz8jduyhop5K3w6Fhu6qAvycnWqSKgBh6E=;
 b=H94QPPIHce+C4+De3xe+e9S6g3x8+kagqkvpxCynGWy+CXYHO2Nxl5O5xZxFSoyRtq5n/7jFesxrAR0Y6yw1otrsxzPFm+0bfRvLphMhvtGZhjhZZetf05RT6Pf+3Jhbgv72Ytda1xZAxs/ck4nORYzueq0vJr//V07pf+OmYFc=
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
Subject: [PATCH 04/17] client/server: convert ss_data to use an offset instead
 of fixed position
Thread-Topic: [PATCH 04/17] client/server: convert ss_data to use an offset
 instead of fixed position
Thread-Index: AQHYFudVA97ykvGUIkyv8Mh1y8xJaA==
Date:   Mon, 31 Jan 2022 21:13:03 +0000
Message-ID: <20220131211249.106820-5-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: cf4a583e-663e-4c4f-9917-08d9e4fe7863
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576C7FE08C2906274165B56F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kc32IszsOhK9zvxO2BSKTmqJebAfq2ssVr0QFiXftk2/mCui1uxOexKitmboxsjSW1NUzIDCv5OdkwBNQYQ3dGTaaW/FiBbU8nVD4VQiymolZkyXy32Ba8+rwVhmsdyWRogveh1xs9OInS24cjdUfZrr/g4+YwWbBmyuJvox4Ceb/+qrJvH4+N6jXFih9NQCZz61HE1qVuS/gEA2x3l7rtWl3Exe4bv7GauS56IhyfDbCZwf71mpEkpvLtiC72AxsD4TQx4Kgyi/aeAI3spv5mNMQ17nlu24gBNYiaaMOYTT2SGFUVhd8Gw7JulXFwBL4aMXDPuYJlHpu+iB7nv315Mc31bnTs0Yz3oXDpDoHM8iwqGvzt7QIdxxkREoTQz3r1DFYr8tYWj2X9JTktbYziVtrLeQNqKhNVZrHuKTeTuSYATwzQAvArqapUk+a9aMqYP5LLBtspVpFl+MAM+o8oMdYi5EgtdQOpWHCRvOjE2RTkVFNixj/AuaXG7XYw41BDsMtxEVPnrHxm4gau0N9O/svp4gSIAxbNv6q8q4i0DYeQfNgv8xeEIwCXISD60kAGnIB1Bo1KD4wz293qaJUyG8O4SHGBzVXAamD5zd7aXV87cVjlIAksIj1PQYd2eyD2V1wFr9zIwfE4PJBsxJ5NGyJvjuCr3pW7LEhugHU96iDjoq+YMfmtg3IulLHpGEC/aoLM+5dvEinmIQUVMFeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?GG4f87c+BG3j8mrUi10myHdCpXF9NzodtYhSxky8kWXKldTzNDtVyqF9cp?=
 =?iso-8859-1?Q?GRBMrnsb0cKVEvxlG+oEoynt+drPibNM7+GG0cGCoV+euh03Buyp3PPtb2?=
 =?iso-8859-1?Q?cjJglD/9uK27q/CBzlTbpI2bakedr7invqEdrrVqzmKfU2fjlKr/yQhl0k?=
 =?iso-8859-1?Q?dc9YG9wuHS318xJqN1m/0vhnvLvRm+aqrIs0kjAl2I8WwoVkmXzNMqXxgu?=
 =?iso-8859-1?Q?0wvbCgwReqEgYNfou+qA56FxqtKnZa13GuG7Pd95toyOCWj2N4dTPrqXwB?=
 =?iso-8859-1?Q?1VOSw8t1JeoJfcwUaREhfCrfz0hzMbtrOQeu87JcwEV5nCsFKpBDUnzrBh?=
 =?iso-8859-1?Q?OJ9JNH8/DaSOyvNhC8/KNrAE1Lc/EEMC/w9czb1cy5TU4z+EXzKZD+IOZC?=
 =?iso-8859-1?Q?9k9AzLTVjOZTji9n6Pfj9KJ+SonrCIPlAZDiITZHerH7+QasUefTnYJ/Hg?=
 =?iso-8859-1?Q?rYxj/Y44WfESFMgiJmKXuesBY1HsMS4J3TgSxo2pHr//RWIG076MmpI7fg?=
 =?iso-8859-1?Q?gLEtILjpSOByxdqsQPyoGrXoVFNFe/a6ksvA1tzeDV4cCPsC2aVIgWSmM0?=
 =?iso-8859-1?Q?3o8vhIvtBWg9E/CBZLcc7/85OhD9+2gEQL/GRjH+cBgBt7huDpB/r5sMiF?=
 =?iso-8859-1?Q?CjAXt3NPmJ3nFKNH94XwYXJaS4IC+jP6m7eskmzpoWZ7YiwrLNsMw5eYD3?=
 =?iso-8859-1?Q?jjUXQwdU7y2MMHASHhg8ngMWAzxvbIxSSyJh3/Tw5pqA3vhOe+poZR1Td1?=
 =?iso-8859-1?Q?rbU/ljGQ7vDYf/oU2r1hAQkiO1hr7l3SLlwxeRrxYWifQ1caZt5eIoLAfB?=
 =?iso-8859-1?Q?VFnB9qpB0R7XCnPeUuvSzk2awy0xHi16e780QObp8vOeRqZ5cr+1RhaPVl?=
 =?iso-8859-1?Q?86fH61LPjMJ5NcmIo2rVfPKZJ4cya1QSIavQyILPkpYRkPphER5RAbj3K8?=
 =?iso-8859-1?Q?n84ZIe6icz6fG7T28me2T3klRf6oQ3QzUTjrTQGuvjBmWtcwfSXmqmloUQ?=
 =?iso-8859-1?Q?qj8h6nhzMoZSbfwvkxF4pIJbJy4yksltLPj5ufD6xREvXjM8u9HmA/U/+/?=
 =?iso-8859-1?Q?CAqapehH3GenCBAa7W+s6UK6wJanxNQVgs9t9OxsqaOTjGL5D6YU3Qw+qR?=
 =?iso-8859-1?Q?06mmo4zJtUG9/b5pw1hVEQFAMnzHxm7WWCbF2i1yvTz6ieMAn4sprQDw91?=
 =?iso-8859-1?Q?ex/J+O5rgoFmp3BNRQUCQtefCv8Qbr1s8eR8MX9/qY1N7as+xjxEjkCGnv?=
 =?iso-8859-1?Q?Jy6/gbSrlFQXNGKDdg/JDIX2R4C9mnN42VlvoeWvbOkSw+7MEeaVqxum+/?=
 =?iso-8859-1?Q?FvnJ7/amkpXfCI60eeuwLw7v09a1MsbFtdwGjJuyQgiO2gnd50Fx2+YEof?=
 =?iso-8859-1?Q?X4N7YnLMBPSqioUVcw96O91zHXiZQmqbJBoQ/bINVHJ5QzzxQJgPvx9Tqg?=
 =?iso-8859-1?Q?YIOf9DYMPwDGnkmKsi9z4g36zehAWcgrYRulcYkHK2CSSTY2FGIQJ++i7b?=
 =?iso-8859-1?Q?lLZOjZvj6+sFVaisvwCOzvHNv0A26uUekNr5dcfedGpUhIItOnv/sya4Nx?=
 =?iso-8859-1?Q?6tOSYz9bHVhQknHc4DQLZaePsQ6jQqfZ11/kSfWwuqCRLB60jrkEBRPsN3?=
 =?iso-8859-1?Q?NCESgROt8YsE5uGw20KWUCTqFywv542X5U81+F29fx0QziUsgUewflz4MQ?=
 =?iso-8859-1?Q?Bxizh1aYH2fWM9P24o1lm+8bNPFxev/uJ9eqTVXh?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4a583e-663e-4c4f-9917-08d9e4fe7863
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:03.0214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DSU+qB4mlufVuAlVoOBrarlgzOovxw79485TqW0nLVQ3bxUbigFej1y/iaF/PVXpvpC9cKCe/fvA4nbYxGiYwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Store the location of the ss_data in the payload itself, rather than
assuming that it is always located at a fixed location, directly after
the cmd_ts_pdu data.

This is done as a cleanup patch in order to be able to handle
clat_prio_stats, which just like ss_data, may or may not be part of the
payload.

Server version is intentionally not incremented, as it will be incremented
in a later patch in the series. No need to bump it twice for the same patch
series.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 client.c | 10 ++++++----
 server.c | 59 ++++++++++++++++++++++++++++++++++++++++++--------------
 stat.h   | 14 ++++++++++++--
 3 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/client.c b/client.c
index 381af054..e51138ee 100644
--- a/client.c
+++ b/client.c
@@ -1761,7 +1761,6 @@ int fio_handle_client(struct fio_client *client)
 {
 	struct client_ops *ops =3D client->ops;
 	struct fio_net_cmd *cmd;
-	int size;
=20
 	dprint(FD_NET, "client: handle %s\n", client->hostname);
=20
@@ -1795,14 +1794,17 @@ int fio_handle_client(struct fio_client *client)
 		}
 	case FIO_NET_CMD_TS: {
 		struct cmd_ts_pdu *p =3D (struct cmd_ts_pdu *) cmd->payload;
+		uint64_t offset;
=20
 		dprint(FD_NET, "client: ts->ss_state =3D %u\n", (unsigned int) le32_to_c=
pu(p->ts.ss_state));
 		if (le32_to_cpu(p->ts.ss_state) & FIO_SS_DATA) {
 			dprint(FD_NET, "client: received steadystate ring buffers\n");
=20
-			size =3D le64_to_cpu(p->ts.ss_dur);
-			p->ts.ss_iops_data =3D (uint64_t *) ((struct cmd_ts_pdu *)cmd->payload =
+ 1);
-			p->ts.ss_bw_data =3D p->ts.ss_iops_data + size;
+			offset =3D le64_to_cpu(p->ts.ss_iops_data_offset);
+			p->ts.ss_iops_data =3D (uint64_t *)((char *)p + offset);
+
+			offset =3D le64_to_cpu(p->ts.ss_bw_data_offset);
+			p->ts.ss_bw_data =3D (uint64_t *)((char *)p + offset);
 		}
=20
 		convert_ts(&p->ts, &p->ts);
diff --git a/server.c b/server.c
index af94cd78..4ddf682b 100644
--- a/server.c
+++ b/server.c
@@ -1465,8 +1465,10 @@ void fio_server_send_ts(struct thread_stat *ts, stru=
ct group_run_stats *rs)
 {
 	struct cmd_ts_pdu p;
 	int i, j, k;
-	void *ss_buf;
-	uint64_t *ss_iops, *ss_bw;
+	size_t ss_extra_size =3D 0;
+	size_t extended_buf_size =3D 0;
+	void *extended_buf;
+	void *extended_buf_wp;
=20
 	dprint(FD_NET, "server sending end stats\n");
=20
@@ -1590,26 +1592,53 @@ void fio_server_send_ts(struct thread_stat *ts, str=
uct group_run_stats *rs)
 	convert_gs(&p.rs, rs);
=20
 	dprint(FD_NET, "ts->ss_state =3D %d\n", ts->ss_state);
-	if (ts->ss_state & FIO_SS_DATA) {
-		dprint(FD_NET, "server sending steadystate ring buffers\n");
+	if (ts->ss_state & FIO_SS_DATA)
+		ss_extra_size =3D 2 * ts->ss_dur * sizeof(uint64_t);
=20
-		ss_buf =3D malloc(sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t));
+	extended_buf_size +=3D ss_extra_size;
+	if (!extended_buf_size) {
+		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
+		return;
+	}
=20
-		memcpy(ss_buf, &p, sizeof(p));
+	extended_buf_size +=3D sizeof(p);
+	extended_buf =3D calloc(1, extended_buf_size);
+	if (!extended_buf) {
+		log_err("fio: failed to alloc FIO_NET_CMD_TS buffer\n");
+		return;
+	}
+
+	memcpy(extended_buf, &p, sizeof(p));
+	extended_buf_wp =3D (struct cmd_ts_pdu *)extended_buf + 1;
=20
-		ss_iops =3D (uint64_t *) ((struct cmd_ts_pdu *)ss_buf + 1);
-		ss_bw =3D ss_iops + (int) ts->ss_dur;
-		for (i =3D 0; i < ts->ss_dur; i++) {
+	if (ss_extra_size) {
+		uint64_t *ss_iops, *ss_bw;
+		uint64_t offset;
+		struct cmd_ts_pdu *ptr =3D extended_buf;
+
+		dprint(FD_NET, "server sending steadystate ring buffers\n");
+
+		/* ss iops */
+		ss_iops =3D (uint64_t *) extended_buf_wp;
+		for (i =3D 0; i < ts->ss_dur; i++)
 			ss_iops[i] =3D cpu_to_le64(ts->ss_iops_data[i]);
-			ss_bw[i] =3D cpu_to_le64(ts->ss_bw_data[i]);
-		}
=20
-		fio_net_queue_cmd(FIO_NET_CMD_TS, ss_buf, sizeof(p) + 2*ts->ss_dur*sizeo=
f(uint64_t), NULL, SK_F_COPY);
+		offset =3D (char *)extended_buf_wp - (char *)extended_buf;
+		ptr->ts.ss_iops_data_offset =3D cpu_to_le64(offset);
+		extended_buf_wp =3D ss_iops + (int) ts->ss_dur;
+
+		/* ss bw */
+		ss_bw =3D extended_buf_wp;
+		for (i =3D 0; i < ts->ss_dur; i++)
+			ss_bw[i] =3D cpu_to_le64(ts->ss_bw_data[i]);
=20
-		free(ss_buf);
+		offset =3D (char *)extended_buf_wp - (char *)extended_buf;
+		ptr->ts.ss_bw_data_offset =3D cpu_to_le64(offset);
+		extended_buf_wp =3D ss_bw + (int) ts->ss_dur;
 	}
-	else
-		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
+
+	fio_net_queue_cmd(FIO_NET_CMD_TS, extended_buf, extended_buf_size, NULL, =
SK_F_COPY);
+	free(extended_buf);
 }
=20
 void fio_server_send_gs(struct group_run_stats *rs)
diff --git a/stat.h b/stat.h
index 3ce821a7..711df24a 100644
--- a/stat.h
+++ b/stat.h
@@ -262,12 +262,22 @@ struct thread_stat {
=20
 	union {
 		uint64_t *ss_iops_data;
-		uint64_t pad4;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 * (The union is also needed to pad this field on 32-bit.)
+		 */
+		uint64_t ss_iops_data_offset;
 	};
=20
 	union {
 		uint64_t *ss_bw_data;
-		uint64_t pad5;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 * (The union is also needed to pad this field on 32-bit.)
+		 */
+		uint64_t ss_bw_data_offset;
 	};
=20
 	uint64_t cachehit;
--=20
2.34.1
