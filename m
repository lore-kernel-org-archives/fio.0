Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB64EC433EF
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349872AbiAaVNI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15171 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344409AbiAaVNH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663587; x=1675199587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PwgZBVIxaPsn88XfyGcV9zR8LBbXB0IW/PbUCK8RbA8=;
  b=d5HI0MDcCIo6E1ibA8QLiWGjxLyZEhIH1rkFmTSORMvI7PC7CrWGgc/p
   MNnDuVOcFBHXsDMC0DGxOM8xIJOKDNo8Gq4N+q9dEfAB/mDsryF6vfI0v
   Y70jEmq2O7KmjANr1BByhKXsUjqH+CnttWsj4knRLzYK2UDJSOTsgesMI
   MTCDmA0/gfjAsbzLC/zxDPolXwa3T40LhXyDoSrf1+stjWjUOn1lHSfOs
   BciMCsz4NnOozDOc35LP0w+Q/eGQNEtYOE8ctqNsM6oRs34WXo4HFSVLf
   C59FmFhYv7m/JcmSm1IwZo8E0Wvdqg5eUolXs88wz2ctQRUFLbd3jVPo7
   A==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720253"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIpd89hkl6tUNRZLmCRixXMS3ZCt9nCAHTC2Cd+2dlcrDxxgwUsMqP9M1oRnekXCo2Sh6SxPRLkL+dgrFwWYbSNporeJTLOahDMFWuxpkec40nzribEyrpyVPXKXlQZvPJYAyRoYvfiMYXsM2RBryCE+t429DxqOz736K+4/F0lV8QD7ocmuk6OIMnjEI4K5HwV2nueIKddGkDwswjeC93aoIjvv2WgmFQeYmtBtdnp+ya6AeQK2xRFUyh3aBaiMhhZhsN5agR59/oBwmODkVHxPpSJZve+yqSPtKtkOf6RflKyWv3XZgSbnCAhom+3cujAXFSbHOCEpU/UcnpZBRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+vrmolhr/6EQCt4HSylhJSW154mmGhSO6jhe0xQ1zM=;
 b=Pua0oPJVLbmjFs/DldcTPbDlhCPoIhgKZBgZgGS5JYrQ76hGhGi8WHIVmqgR7jGo2grtK5SB89cEFu6LNJqIcMw+p9YmPRthg9oRWiro2pAqz7CuKW5iuTNxMNJTmPfPXgs5r4Jj6JtXTIaAvy6NVzRRIM3mFaBucICRFQv/m2ThP75Wl7ll7lBhK/Ux1xinU67wy/PRrMne/R+GQH+l8FN4Xg8Pyw+blpCauMAiVSwPa5NKS1X029vVPRiHz/QwhQG3i0XJA1KERYY3qS53titlWpJx39uc8rQBXEOhkZMHbIjFZPm7Q46GZVpsL7hHIIhbbqhT2eJqxyhhtIW/XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+vrmolhr/6EQCt4HSylhJSW154mmGhSO6jhe0xQ1zM=;
 b=ngQxHsVMZynLUmIkHuMc86oyg84Y6c3u0WXbOUG8qNvpX3DH/c9yT25AN3Haf6254YUBjetie0848Q19l32s+Flqby24vY9ksPj30F1ru3TahwlJrbk0koDospr5LpO6+7C+Sh+aL41D4PDMcp/yD+xTynNMs+MGP3ZWYf1NiVE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:03 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:03 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 03/17] stat: save the default ioprio in struct thread_stat
Thread-Topic: [PATCH 03/17] stat: save the default ioprio in struct
 thread_stat
Thread-Index: AQHYFudUE3EKwxML4EyqgkTyuYiQGg==
Date:   Mon, 31 Jan 2022 21:13:02 +0000
Message-ID: <20220131211249.106820-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 4a50fab4-675f-4435-982d-08d9e4fe782c
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576E56C0FAEB4AE9DAD23F0F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGz6LMjgBbPuyacejxkbWdjPmxeJz/WBgm0SN+FEQcvdsgwVNFZ/36/cEyvFMm3WHvse8NOKrmh9Tq2alDytoPVO4adlxNkyKTqV7d0y5Z1VT8KAd+dKJ4TU/qeSNTxMHFaTPWwnfSM2CqMFjWWrpQtUnE4xIbQxObGG5qlOpkq3EEXzKYhfOO6vF7m7scXEfkjFUWN3S+j01KvhEnQic+uArRLurr9/GNub6A0UPmqzvOwQwwY/SZzOMF8iSof11HB0DWQYprbCA9i+9twey+a+6GADANBAtM15xgAhpcLftPKHsRD20ERTHaGPbvINLeEqspQ7c0lfnBF1izmmsNuCMSeny9QmFLpElWGAQI3AyEUZYc2DJZU4P4lOT/GBY3000kpMe1Agr82qEKMLTcPhuuozTk7GY0IRM0da72He9SdbxA1PVixqgfmnP9XE+9paV3GvpVTbaYB+ELVcKHvvAFdo7oTH0IbYwxYb1S/rd6hsvxQAQCwUgyELpSDHd+Wv97IlmzDxICSZFlPbCccna5XBlB8BHe6B2oPRQkJW1AIIt+AS38xEjAoa+MfQsryMJ1ngab+54jN0ToeROYD76afvW6BQNp+Ax0QAxHhn9/bisNkiURL5gRe+3F8xWecryqMhB4H4H82z7jr5bZjdNqhHW9E6Y7D4y9uc/kwsJyptIdBNhIXneN48+sC6esRTFe5O32aN6/01/fRMFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RXQzRGNlydj6DSyIdDgLJjJ50YANo7GP+W5gg0mHLRjRVup/V+Jb4RlX9+?=
 =?iso-8859-1?Q?7/zqhrHVJXo+QsVnW4XkRRiCdyi0/9iYncNL7zS8DUE6hMYRY5mfsRFHB9?=
 =?iso-8859-1?Q?0RuqeVyW4n+hu6CoxVRE3KE7xRDUz4Be/Qy2KbNDtPWfFsx5VY427tHxYN?=
 =?iso-8859-1?Q?qdwqazPoPPIwQVW7cceJXxjxE8zquLX93um9CRbO5fHR0CPVawdB1Q+HB8?=
 =?iso-8859-1?Q?5lLgbKDb6QfvHUD8UyRZX7RhAB7hmn96emJEI9TZLDIRrTql3h4XhcLqHB?=
 =?iso-8859-1?Q?bO8Wr/cAkpn4DBP7Pu10rAlFlppTWUDQ91gWhJ6C9RG0rKea78Y9Hx5HTA?=
 =?iso-8859-1?Q?omvrbalPWVJ8azjbSgx3lJOfPvPM1mqI29w8AHg+Uav4Veae0+wE/lGRvK?=
 =?iso-8859-1?Q?vDB9bSF4TfSbRQQWokwjx6S3hZvdQDz60+QEfP408SyjBFcDhB1g3fh8q4?=
 =?iso-8859-1?Q?UB1/MKY74vX/H3ffJTAuRV6+E8O0TOKOxfSO1TbOdEtkZI8uQGK/9fVC+r?=
 =?iso-8859-1?Q?zo8kcOepndGPoP6H6IoC+Siaa0iI+DV1n3zTh9F4tnAKN8XZPQuWPJ9ms6?=
 =?iso-8859-1?Q?usU8HBSlIbrXWsyv2EDpKDO0V6qALMozJ5jC0u/yrRgkVUze46dnS1Xo+l?=
 =?iso-8859-1?Q?uFYixRHDwLjCMK3eo4PgfqTBnQD/vLrsu5UsVWqW+IRTlrCQ2IwMh/80vr?=
 =?iso-8859-1?Q?1+BbIxLpeLndYjHzfs/j10Jbq5NwfwPmcNYmBRiS8gT5IzSv1bssyPerx1?=
 =?iso-8859-1?Q?+2R291QpKM8cggcf5vbfcxvzmES9WAOocL+4/AhG9jNUiNdeNGsVxZTepJ?=
 =?iso-8859-1?Q?9rUhvJzhoJ7+uurEKqQjrbDydiVLhcSNhFygA0SuLEZObyEEghWad+Zh8q?=
 =?iso-8859-1?Q?aGyyb7Nqxl6FKp3CIY5qfof74e9YmXQrdhC8C4YUAER28Dwbu7gpmpFuFM?=
 =?iso-8859-1?Q?Z9pwY036Wz9I5oZV1REYD1JR8FURz0e2nbj0k0E1tUB9y0c8Swp6j20o2p?=
 =?iso-8859-1?Q?/OyobL8uNOthoat3CHaSjfEnjOO7IWUuDv0YVu4gr23cEmqtE7XzG0NB3k?=
 =?iso-8859-1?Q?F7UkHNXa5sNrbL/hbQyeMibDSm4RkS2HfQhhka3bHwEpx2oEVUACYzc4sy?=
 =?iso-8859-1?Q?JWWiqYIMth03zmQ5cq86dhJ16gW2OXvYZW0zI1aGucfy/sde0PCLDLYgFU?=
 =?iso-8859-1?Q?72pnjrfkE0/yW4Ov7yq6YndvlkuTd6PCYHSGIL+mcwrEJy7I1WvM4SMKGl?=
 =?iso-8859-1?Q?dkDYv9T4OBGFiZb1xrE6d2kbmLdlqtxkN5m/oNmo7Ynj+dVt5u3H4u8hWK?=
 =?iso-8859-1?Q?O4BHEfqZXzCsXeYo61SLExGJXKif4qSNOqaKkYcE/8vk6o/dKEG6sBiFLF?=
 =?iso-8859-1?Q?SebzpVt9kQjJUBue8sqajjTf1cvLCh+oAE7Qb6xRDaNjGm8TdpoK4PoSsC?=
 =?iso-8859-1?Q?GtaJc5C8r9JMfdrgw2AW01Hf/MiHdEYynqFSYrGIDQGwMxYxqRQ7W7Bkkw?=
 =?iso-8859-1?Q?o4Q3B4uElTcGOWhqoUeefGS/YYvMR6JAIj9G5iR5FLDpZB+ounQ1mF7HGI?=
 =?iso-8859-1?Q?hexnbk/YEULyjd0wfHLugWfClQ7NP7y8LiAZ6c1jB/BdYbuGNUJsKtGbxm?=
 =?iso-8859-1?Q?u5iLfkd+qO9qfv7AImyrI16TCclHTM0psST1spbS2+EP4M4iJhskBRSvi2?=
 =?iso-8859-1?Q?TqUyx9agujqsx8Onf0M=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a50fab4-675f-4435-982d-08d9e4fe782c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:02.3641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: isbwXTAKH81+BIdm7/PVYjK/9DgGgZdTSs9zn4GaZdrWnVix+DuXcngWeGmGCYMSIhcSSY01XT+RYxVAN6A12w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
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

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
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
