Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C8AC433FE
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348127AbiBCTcS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:18 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1744 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353686AbiBCTcP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916736; x=1675452736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iAiaRrsGAGv2NuTfED3yfIdPCgJ+nuMBxbLpAP00LsM=;
  b=pUK1j+1lZNi9jg0ARc+HaL4xSWCQqvY+QEuAfy/Z8RlmdL/GJJhyWt7i
   pA7/H+SrHFWM1vjkCP7xSR+yAM+uaWKO46sCVIt0qHMWd8fumLPnPXC9e
   y4/fgjDYZ30JfuPIEhlEBidWJZBvzIDpmh4J0IpWB1WCN1lHBAVT+jtOg
   ML+FiQ9TbvBZbEgJGCQWkUCJIguLF0pW/t4q6W0l2tKMt4JjHe4rmDaEn
   h+YvQRjbNuQO9WG5uuzjddR88JATyMh6vczWXa9kpgvjXe8XRaCk8FmO7
   tjld+8GZxOzJFyr3ZhK7oYNZYoXeZfVDWj5Y80JTeSeceBrO5mUFXDpLo
   A==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095707"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkk0JI87wdHou3J3uUhro6MVUcZ6kzW5Dc6PNGi3nEzCltZQ+m2GDVn5ANXprJ8iJmYb6hlVlYMG6MFlKt35NnQB2SY3Z4LdYuFLL4dqlhudNcDPXMHe40vqUiQFaQ4y/1mU1Wh8ZkCVwoIN5WzbTI9IpPP3hFY2gI+UaOl3zExe7PYq7gptCcIhH8nzJe/+H0C6bZwYErwO6E+qvN/DN1YTj1A49oTU2expryd0zubmkleDi6AdZV/R8RQgrHup52fXd3ZpRV9tOhgQ4TnVy/u8PZ0R+OY7Ya70c06Gxf4BeOAT6LPY+o6WBBPARCHUCusP9C2bdX9ccAcZTIJzpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pq/mZWepXZrNKftdbcKtKt9PqDWfw+SqFHG5uDhwZMY=;
 b=I7EVZb4wWsDAY0v5+1ofvxVckqzZHTQjA/bR+MumAs/IZ/L9bpJT3Jt+ldKh3lEsEVxbrfuUd3E3YutrQhIel14me3vNKkVMWa2zv/l+3VsbrO/iVJ/QwqVuR6W3W5VUUOLNCmWm3udI8ZatJoNyy7IcfTj3huwEa4twxKIJAse4sImFqWgCcRC4kWWbRIZb1jW8HklazQA8/OuNav0onFjJQdOk1XcujxM9Xu/JDCwzCmg86S9qaRILCHCmVtfq9Jt3yaWv3hDI4f00mAYEr2Qe0MIccBUGPYpquV13lovQkbUeSwqzz0APVJe0AkDhGEU1Kr6d8HsxbTXN8YaKlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pq/mZWepXZrNKftdbcKtKt9PqDWfw+SqFHG5uDhwZMY=;
 b=GQooq4K10OJ1WKlBs1wukofHlYiqjsXEUZUdTR01UnKChn8MkIT/K/TEH9iSp9Dcb7f5MEQMR11hljzqTRrlagq+1adZmK9/4fz8SpvD1kHKoOIx7fzhOBCBnitkaG9/lSc8c9qI9LKCZxgeNuHMSP0pB567gv63GJfhibSL3cw=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:26 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 04/18] client/server: convert ss_data to use an offset
 instead of fixed position
Thread-Topic: [PATCH v2 04/18] client/server: convert ss_data to use an offset
 instead of fixed position
Thread-Index: AQHYGTQ2bYdGVRzdYk6nSPH98uZZWQ==
Date:   Thu, 3 Feb 2022 19:28:25 +0000
Message-ID: <20220203192814.18552-5-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: d20219c1-571f-46ac-2e87-08d9e74b59d8
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4632D0415E3ABB168E2FFB5EF2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b2Sgt6Jdj0EfwKR+nZ4nQGrsPqMF9hY+bUfM5bTPQ2SQj8UqmPNSmRYiK0DNYmzc8SRPcj3h1zSh8x0bcltdYFoEAv3qK1uJNSblI6Ud0EvhSbara7F7uuOkM35pNC8xS6a7v0GUDbcHt0RNldL595xabhp1QuEwCe59/sqgDbFpo0YqYAI6HJz2q3Rp/wIkXD/fEiJWgAZJvq4PVi+ZuBvjnFJExKFluVOYonh4e2RdmVEg3u0l0q5I7nP71XOGSaJmVs9Oo/HoBIsvEz7FAuWX7+BPvZcdVf32OkOQ8sbvU9TSVj8co09EstbIsqfzRY0w9WkAAKPcc/Uscvv++ZQD46A0iJ0C3NwHo4Wxf1VqpIiyrz2v5zOKyWuf6uoG9gCl97Tw+SK7nl7h7j84dazvzMJdSdmYPLQnoGwYbDix5p/ABfY3t9T4ZjfVBa7sB5wVElXogjVfuZDIUrsiDdMplpeq2VQe6T5k05BSFTuRQ6rHtvbJ0iiCh9PMw6irKZQ5TO6ju25H6TTE0jN9SSTuSNVHZhIE+i4FsW91P+xA2mImrz/uxHZZoJW8DXsNUxmSZ54mttqmAzb7i45hsDNrb2b9ZISFU25x2Rh2BUMzVFR0Xin+i/pcg1h/XlZ16v/JxJs28YUitHqGqd12mv5X7z23OZ/G3vPz0+tANplyuTpKOb9FFKbLFnXHtnGIywG93L65RpH3v3SALzYFBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?XGLNDySlb5apiz13O1Ur19d+e4lriw7V8OcHjXj6LdwiVPeKJJqCgvZ6/a?=
 =?iso-8859-1?Q?XZM+HMAvN1SyeYQq/KRl2VM+xYrxFMZm0yV/mum3XQ3vEmKBzuKU0oJdBZ?=
 =?iso-8859-1?Q?1YGvSZzFrYFdUdjpUQHsruD6jB5xRQn9NfrSKXFcqjHnXkEC4hr4sxSijA?=
 =?iso-8859-1?Q?WYaywKIrESBveCXDgy69r/7oxwxZBBfe+Dhy2WAS1tDljXJ3bGLsriqCzb?=
 =?iso-8859-1?Q?4Si2RwAblB72+0bVxwOHLzQG5K+2IGbOge1Ojs05OvvBiNFwq/1oPVJm0F?=
 =?iso-8859-1?Q?SRiNs96UI0F7JykZrf0XHK42kNL25nRXCRKksyvxM2N1VuwX0CZVFMqRhU?=
 =?iso-8859-1?Q?dqo/7JO2+0ftELcktwCeHGQ9WgE0iI2NctW4NgLq+590Gr/aQkI+ztCuB8?=
 =?iso-8859-1?Q?rfkIXplS7xxw9DlD3oiX3O+A4NJWN75GZHxXFYGLXl34Jwtzs9PVHrfvqz?=
 =?iso-8859-1?Q?s5zDvXtYYcvoDpu9AETWhQdquQYMXG1xryOTXvbky2MyxiYusrTML0/ns1?=
 =?iso-8859-1?Q?pTMQMRO5h5rlT7Uhyb5mRt0iPzh5v/mRSSnztw16VX3vOKCrZJhD4t5Odj?=
 =?iso-8859-1?Q?GLZfmDDe9qZJg+RjuFM0HaS201smhfYHXRjh7F81I/pX/haoFnns4Wlg+E?=
 =?iso-8859-1?Q?7GBLgosy49p32WrJ7tsXwtISnlDlRQUwwsPqFjmEqWGb1SG/qCIufezp72?=
 =?iso-8859-1?Q?rNi4kyUrkmrV6+vhndNg1wyqQsjkHto8A174xVee6sQGyL4sNkSfOpDKi+?=
 =?iso-8859-1?Q?qoikA76b0bcewEILPIyRsAE741902ojLmiE9c3u2wth6zPhX6/SZe325yu?=
 =?iso-8859-1?Q?wKMFg1b9jHtgNoKMEEVV1KjWjtUaXd5QRBT0j0j6uZyZHLLsDkrDxvKGDH?=
 =?iso-8859-1?Q?pFyZD/RXjDkUstjtOvDxErgAGe6x2xi1FkCer1hxrk5ZDVPi2ScscM8jZz?=
 =?iso-8859-1?Q?u3dlCPDAV39+j8xJ+eCNYLiCTQiXxonjO7SRVEWVDSd+JhiEU0W8b3K2eh?=
 =?iso-8859-1?Q?6m6j3n6I67YwjmrtJEtj999Bl+nAsL+EINwE90fgVVKAJ5DHmuTas/BBkt?=
 =?iso-8859-1?Q?XiFlPJSTIWM4Enx4TaHR/XckE5aacTf5aWXFYSYA5NZabblkzYGOb9RnFD?=
 =?iso-8859-1?Q?/w+A/+gJG4jRlRg4BnLAsRZGvemXv2ds0Qlipysg191XhDICkmTcecxxW4?=
 =?iso-8859-1?Q?6jQnr0oDB8jfhEHNDLCJTaxj1KI/oszoxbZzdHmKlYa6z2TN2tVKudeiIS?=
 =?iso-8859-1?Q?MFwa3T3fTkVfuOiSoJjCzuwMymX5CRZ0/LxHaX7S6U++bd4wXqlPY3onMP?=
 =?iso-8859-1?Q?BHcl12ygn6plsF+hSh9FKYGIPfZPlPHQrWw40k0xv+TNHyfyJmadZKXyo1?=
 =?iso-8859-1?Q?OegPAEg7xhbCpztLuiVh3PNOdWGkwahNoGbxrJZmEP0AEmnJg4J74GDhY3?=
 =?iso-8859-1?Q?DmEXfDeicHQfWLMil1BleEqaawDrEa0ScYizFwwCAq2LURETE7hWKHe53+?=
 =?iso-8859-1?Q?nL81HNMtG5/syQRJ2XRzP/5s9eA4l+K7/EjsNgdZaU7IAdF/bgdVVEM26Q?=
 =?iso-8859-1?Q?/QiT7mo45NJeRucuDFTMKJUUCTihhhEF7AiOt06F2Ft5aaXfwIMjV9S5di?=
 =?iso-8859-1?Q?I7t65KQMUYTeJMLpfB9IwxoH/eRhBdiFtfzGPlwrCohe5vBvvaoQjN+vYF?=
 =?iso-8859-1?Q?mC77q53a/eF4KD2IoIM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20219c1-571f-46ac-2e87-08d9e74b59d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:25.7884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpkdp4f8CzRBu7WRyMlKPO+tcGy00fW4bkqvQbABZFQQgag+lGJyx5L6m8iP/3vPSJbusRMtkaA/wA8VRbpRtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
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
in a later patch in the series. No need to bump it multiple times for the
same patch series.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 client.c | 10 ++++++----
 server.c | 59 ++++++++++++++++++++++++++++++++++++++++++--------------
 stat.h   | 10 ++++++++++
 3 files changed, 60 insertions(+), 19 deletions(-)

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
index af94cd78..9ec09345 100644
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
+		log_err("fio: failed to allocate FIO_NET_CMD_TS buffer\n");
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
index 3ce821a7..5fa20f74 100644
--- a/stat.h
+++ b/stat.h
@@ -262,11 +262,21 @@ struct thread_stat {
=20
 	union {
 		uint64_t *ss_iops_data;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t ss_iops_data_offset;
 		uint64_t pad4;
 	};
=20
 	union {
 		uint64_t *ss_bw_data;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t ss_bw_data_offset;
 		uint64_t pad5;
 	};
=20
--=20
2.34.1
