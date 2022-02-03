Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68497C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353772AbiBCTcQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:16 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348127AbiBCTcP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916735; x=1675452735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CRY0uyCBtzuqRwpbIPrBHTohlYsKapw+Gc3S4y5CnAE=;
  b=GGkCPJXVUrV/nsYHJES2AjSduV0jBgwz1zlm5HPOrFtUbQ/DspInrITJ
   Lgz+O4RqN9ENpVfop3jgd4rDMF/6/XKVDgOWYT/CL0zDGmrF83xlJH2fg
   IIkFKmN2sbeyHbAAnq4ZSw8FvVm80n7SKjc0rkR7PvZE6Jq4bYPjz5ieO
   OOdpGt90ccgqzSd2NvvKPruoUjt54EFZ5zaOI5QmZGXV8BYYBthR0TBcW
   0cr1WnXalO8gIK/CxGHZavnMe5Zj0g2GCvCWzoTl6VlcIKA9W3Fr3a7Ve
   JEDWxEb0K+NwdkUS+pL0LXYA2PSimKa+0Au2yUgIWExGuiyfUbM4l+Zsm
   w==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095706"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHMNnyVRkazndfqBnzB1qrb/geGZyV1zFhStCKc6NA80mYZhZtP8ouyrJbcda0qTZsdeYTFN+W0asJkjvI7WKyWGe9XSZpQoeM8kuA+KlUCsHE3xLUM4e/oe+UIeTqoKSLhwFMryodwdKDASy20ZFuqYa4DH35n7z2i9XdJxukbXR8ArcyOPUQG0cq7JbVlzteTrSKv9RyznMOGuiP6t4MDDYQzirS4yiqTsTgj4jfibPdigGlsdl9/bGFMP4RTm9CDWQzcBA8a/N0tEEQtxh15hPxIfUBx/zxMm0VNdv0BdCDLw/h3+hXOwCXHXsfYPu0M0HYWQugjKpA1oupNHCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3HlJAhHpeVLQIr013aJl/SAnEOVPk3FzCvPEZhuPxs=;
 b=dYiR8Rbzsp/B6T3Ra6SsEaa6U1ysqnN3P2CZfp8T+CssOdBKG+oKxlYw+hQhnOuCA/+xZZsdc0yb7EblG0ThiHeITeXLjzEktmXJwJNyk12sX4B5a2nvmyGEAbEtBTqn8O9qboZizOmm7VsdxX9/6NDymMwbBfhpgQHLn6p/QStnUwS2IgrKVPhUjprl0a2yyc5fWVaa3EFmODAeGdirg8/0LCYrbC6W+6g9WYMVTqUVsSDqKdB7KXXT2a1EmYm33WLzkT9MNGuuMU7J5ESVtR466xRrKq4p7+tcokSiznWFMtWn6Xf/pMLWDvGijc4Bs7WgbyzvO17g695ggzM7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3HlJAhHpeVLQIr013aJl/SAnEOVPk3FzCvPEZhuPxs=;
 b=Zmljii+BcnedcBFTknJ5riRyxDr4MrGj3oNqsxPoYILBZh8YKTtvmD0LI4CgqP7PjfBGNbt3MadAm1sx4VyzvXD6GfjxE5d2HxcaMicByU6Lyh5z8Agtb8T4nRpnbhcwxT0Y50d6YHC1zNv5RnkfHUTV3vp7yQNLnk2LE/BRQyc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:25 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:25 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 03/18] stat: save the default ioprio in struct thread_stat
Thread-Topic: [PATCH v2 03/18] stat: save the default ioprio in struct
 thread_stat
Thread-Index: AQHYGTQ2tDXvJ3mCkUylIdBHCZcbFA==
Date:   Thu, 3 Feb 2022 19:28:25 +0000
Message-ID: <20220203192814.18552-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: dbd0a076-28c8-4cfc-25a7-08d9e74b5968
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4632E4354EEE74EE5B68FC3AF2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 518lyNu//4NYKZwGp668DYk000WVfTXBbM9SOc+QTBh1I/OLejkJrlCjrkJJz7ii7QDPC/lLm9SkXtj/erfrJ8O5Boi8W0wMZjlYlQMIzn1R2q+9Kxb5D1xQt+mIOIJe7ymQzWet2J68mFd/+WhTa5rrEPaC7KDHlvmD1qF/McTaU16Sbfd4ORfp9nHf2qsQJiR5v4aqK0BRrSlxYEzvo71zElpqGLpxKf4kjlCmzwBrIcMt2d2kjGeQz/OkJ36xXrULQYgJrFRMQzB4qvaqUeHNJ5RFJc47jrhP27YYVYwdSBxtyeuvmq6iQHu0AtHN+hJoTGFl/RertTurhqkQklPchJ28c7Sf8r8FzdJU3sLLvHBT45+ughl12w10y0F1OqOHEQN+fXdSVf2kACxpvkxyX9wYmhwzYTvQIO4y1keSXJICOYRriKrwSfHdaKaf4qxfXy4eBt6G66WHYWGLVdlIcsdwQp8ZZE2l9RSKSpNYu4uL8816frQhOIhIdZYDboLU9e5dox0hlCtzelYSXSQAPePPAcDLgtO05lqm4Q/7p7qrghB296gbucWi6wDzFmM7c+wWtIEemP0BO3z5Hh+tr4eSM1vBLhsSDo1bmTPZ10HV8qc/nO2oiseJfnTxFBrsyORMjE+Q0B8hMPAlcXNBKWfufIVUr43jdooOPnumKl4BcycAx7WJjGMwXmOvIEE2zDfJ6qssQWETFJYSxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uJCTxtb+sfHLGQ7ls/ulqaQ4tPZ7kgkbiBhV+V7sgJxMAstGMnUj/DqVNV?=
 =?iso-8859-1?Q?k00PjLz9YhCFU1X58APmEBptAjeNgaAjemAUoPlfKW9arK91lLx9ZDaMtx?=
 =?iso-8859-1?Q?49pV8/LAYTy7jCdWJOLPveWbiwCQrL7y1yZ57/L1V1JUUFjtAWafWZNdnh?=
 =?iso-8859-1?Q?DNghPumb+xFwDXZgff3Euv7iEoiiPJLSi0ho+xfS5a7BAfcIV2YjXJlCKk?=
 =?iso-8859-1?Q?s4C6+9a7hcb6HfAndMAOLBNuU1Nny5mO/Zf7xD8zU1okkP6QDVSO7lF2EF?=
 =?iso-8859-1?Q?XjOFhHZ81MVzyTpEjw6qbzU+10ZFxTZq7vqaQ7B62MFowg+NlgCnhYl/Mu?=
 =?iso-8859-1?Q?lp4KdcSif99Da0zWaob6QoZ69yYx9nQ5Em2NXzwlgTpXzHHpfgshGriFyn?=
 =?iso-8859-1?Q?42ukW/MCh4H1OhGbsLQvG9t7Xus8QoMLE+1nPT2mh6/1KSPvjQJLkyT3+B?=
 =?iso-8859-1?Q?SaKkM9TmlTbix9XwASp2BGmKPnaz4KvCge5mtLjlbH9EaE3ZE320lUdwnd?=
 =?iso-8859-1?Q?PFv7K9krbd9qNj2SvHT227dFKpLLwOKrbyya+MxBu6eAH5ZFLyoUvVTZGS?=
 =?iso-8859-1?Q?raa3n29oMbohi5CDF037ieDB0oLzrQtePtTb5SkpuzHZCmtokBSj/mwacT?=
 =?iso-8859-1?Q?cPoQ/S+m1C9VO+ma2cEhG7r6ns3ITw7IKQnvNU+a1fBGPLzTkXmEfbZAH/?=
 =?iso-8859-1?Q?WgZGpu6YSBWG/noD04dhj16uuvqu7TWYywoBqGetv/uXBXM4v2HNtzVuaw?=
 =?iso-8859-1?Q?Kn7OiIqYlR6+bFp5KQtu26DnpjNZcUzXRx5D3xw72QR0qip3W6yJu6H6ft?=
 =?iso-8859-1?Q?+SkfGqaeZ4ImUMAbfGSTaNbvKeWSzNhFf+W6JuTb04XJ8Ej0QlO7QmEc46?=
 =?iso-8859-1?Q?6lE4hP1Qx9n2s9JncKL+3NhHS7T5tA1tcQ3bkrVuSW00ds489zevwgcUBX?=
 =?iso-8859-1?Q?i/LwT3iMbUJfvOhyTpT3d4ZAK/5dXcnK7HHp0D9N1DA3k8yJJNqYfL+pw3?=
 =?iso-8859-1?Q?LL5Y+MINq7tEeHnzYAwcX0jv8C2oZ/aLbgiQanmbz71rYw6GXqE4dB+zef?=
 =?iso-8859-1?Q?3ytFQOMqd0pIkIaXWZYKgrtYWXJqoiqi3WeIIVCBOwUeb1KhE0XQU7IwbX?=
 =?iso-8859-1?Q?yWSNEp21w9o72i7BFuzywnzdYg+H2odm+Gza0GyVLVqTXYgQq5IYL6hyvd?=
 =?iso-8859-1?Q?Kiw7GFHQVE0sQpDHF0DhdRIp/kslv4HT1Yxi4h18N4fIUXgSBHebpTTLGN?=
 =?iso-8859-1?Q?zV6M567VIgrPrE0Zw38Fbssmg5Kp4JjlVWlDVbhEcX6QGNfT2JczqMVh3g?=
 =?iso-8859-1?Q?+t8AzXYySzPLOmuhWDLiIyjABRWElWyZz4lCDxT0clW2cz2JMlOXQloF+N?=
 =?iso-8859-1?Q?mL2ySO45L+8+xOsweQ1W2hBsS+F6re0bVYJlVUdrTtbVmg1D/eAoIARl6U?=
 =?iso-8859-1?Q?4Gif6KVcbh6nAEc3HBk57N3//MQo8vSAXvRFZZxD9Esmd3uw39YL1hz4oE?=
 =?iso-8859-1?Q?5tv+EQGrEAMGSY3yhVR9n/+lqdRrC3XW7ejB4nT3pkjufOfmt9plCvgn37?=
 =?iso-8859-1?Q?g7FChjnNoCYaekyNrdcvaP/TnF43qOUxPbBgloE5TLOIo1LqdVJJCQcte1?=
 =?iso-8859-1?Q?OBZtIgcrlRYlwUp659UzwBl+7C0T0KDtgSJ2wZNqjPBOPZZLKlDtBvkSPi?=
 =?iso-8859-1?Q?22GaLeJVR3pOjtpIGGs=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd0a076-28c8-4cfc-25a7-08d9e74b5968
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:25.1934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEWZl1rVRM/ih0u78Jd4Cl5pqzoWZon11Z6RFm8FTv5DtID4mQvMSclgvIjUzu48QzyS8aIp8TN+rDX8qdTFRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

To be able to report clat stats on a per priority granularity (instead of
only high/low priority), we need to be able to get the priority value that
was used for the stats in clat_stat.

When a thread is using a single priority (e.g. option prio/prioclass is
used (without any cmdprio options)), all the clat stats for this thread
will be stored in clat_stat. The problem with this is sum_thread_stats()
does not know the priority value that corresponds to the stats stored in
clat_stat.

Since we cannot access td->ioprio from sum_thread_stats(), simply mirror
td->ioprio inside struct thread_stat.

This way, sum_thread_stats() will be able to reuse the global clat stats
in clat_stat, without the need to duplicate the data for per priority
stats, in the case where there is only a single priority in use.

Server version is intentionally not incremented, as it will be incremented
in a later patch in the series. No need to bump it multiple times for the
same patch series.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 backend.c | 1 +
 client.c  | 1 +
 server.c  | 1 +
 stat.h    | 3 +++
 4 files changed, 6 insertions(+)

diff --git a/backend.c b/backend.c
index f7398b23..abaaeeb8 100644
--- a/backend.c
+++ b/backend.c
@@ -1786,6 +1786,7 @@ static void *thread_main(void *data)
 			goto err;
 		}
 		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio);
+		td->ts.ioprio =3D td->ioprio;
 	}
=20
 	if (td_io_init(td))
diff --git a/client.c b/client.c
index be8411d8..381af054 100644
--- a/client.c
+++ b/client.c
@@ -953,6 +953,7 @@ static void convert_ts(struct thread_stat *dst, struct =
thread_stat *src)
 	dst->pid		=3D le32_to_cpu(src->pid);
 	dst->members		=3D le32_to_cpu(src->members);
 	dst->unified_rw_rep	=3D le32_to_cpu(src->unified_rw_rep);
+	dst->ioprio		=3D le32_to_cpu(src->ioprio);
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
diff --git a/server.c b/server.c
index 90c52e01..af94cd78 100644
--- a/server.c
+++ b/server.c
@@ -1483,6 +1483,7 @@ void fio_server_send_ts(struct thread_stat *ts, struc=
t group_run_stats *rs)
 	p.ts.pid		=3D cpu_to_le32(ts->pid);
 	p.ts.members		=3D cpu_to_le32(ts->members);
 	p.ts.unified_rw_rep	=3D cpu_to_le32(ts->unified_rw_rep);
+	p.ts.ioprio		=3D cpu_to_le32(ts->ioprio);
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
diff --git a/stat.h b/stat.h
index 15ca4eff..3ce821a7 100644
--- a/stat.h
+++ b/stat.h
@@ -252,6 +252,9 @@ struct thread_stat {
 	fio_fp64_t ss_deviation;
 	fio_fp64_t ss_criterion;
=20
+	/* A mirror of td->ioprio. */
+	uint32_t ioprio;
+
 	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribut=
e__((aligned(8)));;
 	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
 	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned=
(8)));
--=20
2.34.1
