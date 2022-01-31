Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CEBC433FE
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbiAaVNG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:06 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6676 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344367AbiAaVNF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663585; x=1675199585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SVvT+jO6ZdoD6+ax8zfynWHdzoX4bfMialer5bVVkTw=;
  b=aICtqR2BOqbaIdF/uyuLJ2zabjaElMK8mRuB4+gp42QWYB7LwzOUqXb7
   p84G2BVcJ4sBL007N66NWd+zVLeaVYUNrnnBX1Wyv2JGld140Qr3/2yr0
   PqjpZiOaAWDGe6HzOZUn3elIb4Awrr+T52KlTlpQYBWjkZ3LaPTzBglcd
   AC63RWNVVlPyiBw9Rw1avMxRvBGXi/64KQ1tVIi+6juho8MIUmSanzOxT
   YqDYGB7k8U0nVPgoPzMLendkxjGG/sdsMpge1KcfKSXcvITXsxZwSD5aL
   IrgFeGeVQ9UNXLTvLFCeJPAiHyOLYhuDcBp0SntR7Z5b+N/KGq3peodOT
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="192828124"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpimgGw1ju6Oyzz4nfm20kWY9qG2nk94WS6BjFXJ1QMPW24YIHkWCEQ5/vdJnQC8ovhMpxW1B0ofj7gDoxgKi8hgJKrOnc1JFwVxRQK2s7yt/LE/OXPiEdm/tH//cleP/vbfMfD4Rq6Q/ye3QnBJ+5fBQDpOwSm4lisXzH5LHJgtbSxmepAisWuEyhYcSK4ggLBUXLMGuT9RuCC5yUCPRgllw0Y6IOJveSDiyI0/Jq1SzWrmOUEEcYRJlcQYGZyFLWQV9LMa/FxaqF0nFt+uVXT97kgYX54VtYQFwW9IzG1xM0LSBU4tMRK9hVe+ToibKObQJ7dHm7e3kXs6uYODRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urhqKl1iJco6GJbHkbIzNKk6cst00mH7rOmVi+E55VQ=;
 b=aN7zMmpZvg3weitLDbhmr8xJTckqw8j3GZ3+SzBGJ6aN68Ukw+QWorBeJPkj1tSZStJZlklE4FX1devJAYbgiPA83TEer511CKVeCz02i4XDq539dlTMc1lRWyxzJl8CW9BnDYGBaBBe99jzowyIysb97V8qkS6nd6K0bZH/fFsjKiSnr8Lpz1XMU+94+nZoaOxCN3LmhvyJtjptwKFz2Kon43UKry05iQUnbnZpwGoLQZKyAQaNeSj3Romxq+n+aC1LzTzUTd2LETcfu/CkpE9RwB3F6ZZZSEYMNOpsK9nUP3Dz6px7AdTu7OX2XJqPm8a6YUdtnDAYUXOloIy85g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urhqKl1iJco6GJbHkbIzNKk6cst00mH7rOmVi+E55VQ=;
 b=D/BIDxV7K1NBiSny616wLkXnCCjRJpU8e/Q6YDCbHv2jP0Gs3/NeBUbMyLl69qx+5R43AMMwOnn/rLU08CTmunKrxZnYGYLpXHU5sCBxon9D9M0+zemryCpz6QClkS1VwA2FFie5UJpMkaI/nd2eIC6U3gs9yUIMC+TsRy94k2o=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB5154.namprd04.prod.outlook.com (2603:10b6:208:5a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
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
Subject: [PATCH 02/17] backend: do ioprio_set() before calling the ioengine
 init callback
Thread-Topic: [PATCH 02/17] backend: do ioprio_set() before calling the
 ioengine init callback
Thread-Index: AQHYFudUV3tM6pjOgkuCsR6qjL5Kpw==
Date:   Mon, 31 Jan 2022 21:13:01 +0000
Message-ID: <20220131211249.106820-3-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: a07ee200-25e2-4051-0489-08d9e4fe77b3
x-ms-traffictypediagnostic: BL0PR04MB5154:EE_
x-microsoft-antispam-prvs: <BL0PR04MB51547DEF0684F896A2E58824F2259@BL0PR04MB5154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SxcbbZ9y1h3P8HiuyptT0vFVBS5FEaXwStvp4+OivrQUsUfyHNV8jqztnhWfc54+islSH6WAzKujJ9A5HRZ9wGFI16ByGWwXus/QPZVC6QKWayOApwhe9ENFi3Uw0P6on/hiRBQQqzAAWc6DLI409Vg7/rFFApxj1VG2SypXq0FxMmubvj8xRhdVFVPZFLi0CbJo2Jh2rARetev2jjvvnulrDXh6HJippiRLQcJiCAsDDlIIB3gXnDRix38D4coBGr0Xk1HYtT0/zDbRPh9kJaa4GrIPvSXbPKDI3wQNFCfInte0fDUfVM8St55m/4nLFLPy5ay0Xj5OKhf/2fraj76RG3PJQrs47wc5NyrLDmZZIh0mA9ap+A65FnAOZlEx3MkgU2hosjXcmIiPURS4GJ4D0K5cx3hCMafJz97CVhiAZ5I3HXfGOd07Y5IIyAca3crgPBWQ70taAwcI+C+OuVFVrnxNIerok3nxM4oMWsGDud/GwJV1IR0w2ggJtPv6VJ7hFCxUPbQEDbxiydu0Lv5XD1I8014CKrDQNPshZYfeyAWcZcWQ10LFfAcuzfsAnFELlpmvTeNaXHEqiyHZhRePh9QVk7uabNXK+pQ39Ik44SeDHgzpGppUnf5ZBp5Qagh0ynICXb7u3c/yuyjrBOpiLrHCqVjfFNJPgPKQYGMKU7NrarL6A/6G+cnGTZfi5QGjXifLJi4O6BszRK9IkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(66446008)(66476007)(6916009)(66946007)(66556008)(2906002)(64756008)(54906003)(76116006)(4326008)(8676002)(8936002)(91956017)(36756003)(82960400001)(5660300002)(2616005)(71200400001)(38100700002)(26005)(1076003)(186003)(6486002)(316002)(83380400001)(38070700005)(86362001)(6506007)(6512007)(508600001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Tf28yIYzsvNThsbkrxQ1R/Kr9sVRFlUzDVI/XvJwbHQsBkXU9rv/BCRPP6?=
 =?iso-8859-1?Q?6qUUzWDm31XL7egqFeBt8xZlJ0y2ZPm9qIRtg0tMmhs36pDkhb7FXbg6DC?=
 =?iso-8859-1?Q?EzzpD+McVorS0GRE5NwZ0vlTD6PxEgaPuBRj5fw/3eeX3LXojVKiur3L4i?=
 =?iso-8859-1?Q?y82dv2m8GCGk18HHZ6LJa/xDimJHktiJgil5t1bNKcbn/39VJk1Pd/9b1p?=
 =?iso-8859-1?Q?F4G1/LlANx2DMxOCQAGvK4l35EXQ3WcdAdke1D3wiVN6Db5Kn0sSDFwBAz?=
 =?iso-8859-1?Q?kobYjKAk8OJf2i+G23IINOPP0dKWthAeDSa6AnNO6pTuXmjWwo5P2MusUo?=
 =?iso-8859-1?Q?X/v++OiTSu4qJK7fTCQDjWJ3/OCaLY9yxNM97ivT0h6l6PNRC7VKY366qy?=
 =?iso-8859-1?Q?wZLVZFhXVuW8ZvG9zVOptyp1oyMThfhPjO7qUwFLB2C0FBeTEmdGrgFJAx?=
 =?iso-8859-1?Q?V+Agssoy0XDOLu35B8euBmTmqWPmc5lCe2/zvjcRz57z6fsvueFQ3A0E0k?=
 =?iso-8859-1?Q?3RjP+3Umppcb3sCj6IaVwdV95njOlScG14dwrM7QCDO2H+rulSTn6rfu7R?=
 =?iso-8859-1?Q?86dvPaOtVvMOkwSnI3SrpFz+ZOpZkO/XOJ3Puyz7lNVXnNSIdLvEJ/ZC/T?=
 =?iso-8859-1?Q?AQuxcKRUJl+R/AzKOzRpgKgE5p5Gj8aIQvaPI3+3/dZCrjmJfzlRCtMFQC?=
 =?iso-8859-1?Q?MCNy8FzugAk6+HCmJl5N/hMwoQiw/RKZhRXGpZf0LtFS65rZj5jqGYa8ed?=
 =?iso-8859-1?Q?jN6miobe3WbAmyfhE7a7Z5cBfbDNq8u65/TmC2QnT9p60prBcmha3I05SR?=
 =?iso-8859-1?Q?pUxD6gfUzgxCz8EiYAljuV1nb24iUsx+xi+D12/Yf+1jHyFiQ+4Fr8RsLl?=
 =?iso-8859-1?Q?HyLHbpbrjnJznOK4eJ7cPzWaksrzQ/90/Z/5jwu3IBHK53+H5vGGAoJbfo?=
 =?iso-8859-1?Q?OiKcG3yCm50eKAjMUgJV98tcy0OE0TfHTt5LTHFv9IRwAXNUT2PoLhOz3S?=
 =?iso-8859-1?Q?/Hj1sp5JtU6436BVwcDwvpaf+1gI4f17Vqsj1MISyt1B+5Dj9eyoBmBh0k?=
 =?iso-8859-1?Q?2M46mOIEYhub5swOCljnwOKVSyw2gAsA447qjJYc5r1esKwtsVdAFZhzLn?=
 =?iso-8859-1?Q?xJIQUC+9wXGroEsrU3oaJ+6dbwRIiPjdwPEDk/MOj+jJEp2XhAYZLFmvXa?=
 =?iso-8859-1?Q?XRjo4O+jeoZlDrTUvNuFlXyAcqKlx5l25cX3GoCuMRW1hABQ7K0M/371Ro?=
 =?iso-8859-1?Q?OCza1DDE2asZu2dVkpIeKq3KV/COBCIr1zESUNSbCjvjhazYstaGN3WbmZ?=
 =?iso-8859-1?Q?1+d9UW/w8w39WxphgBGhMskqIpKyQApQJ7ehTvI+o/yuVtEPRoD9ZMEF1n?=
 =?iso-8859-1?Q?FaLs678xQF5F1cP6mMokv1E7KKtHZG1SZ7MsTf3wijROqWIx8OOeeV5Mky?=
 =?iso-8859-1?Q?7rw7sEQlN7hqUFC1ONCnnPgVKoJWv7ZYse9jr64trOEXz+myC1JrBKcMTj?=
 =?iso-8859-1?Q?uuRMhRq8s4ad14Fv+J1IfUlDNmwoGdVigW8/pzbBvyYoHNpFPSmxGWtIVo?=
 =?iso-8859-1?Q?RXAMN/Rdxh6VEiQE6d4K/v5avD3e1AeBP65V6fYFfz/MNoUZfYGKAgJo8c?=
 =?iso-8859-1?Q?7RPsaj3aoIt+BpiBxRjURUFZ47qphD8QAXKdiiu5W/XkeQM5SND4UvuNt5?=
 =?iso-8859-1?Q?DKgBZFQH8o5O8X0mnzU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a07ee200-25e2-4051-0489-08d9e4fe77b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:01.8160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pjrFJsrl1GX/CXlTuqA3i0KCdkqzMH7c2/kJrsksHbly9NxgVVvqrdMazHPDyPWWhBWRNYbbkpWezGdcKHUkBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5154
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

To be able to report clat stats on a per priority granularity (instead of
only high/low priority), we need to do ioprio_set(), and the matching
td->ioprio assignment, before calling the io engine init callback.

When a thread is using more than a single priority (e.g. option
cmdprio_percentage is used), fio_cmdprio_init() will need to allocate and
initialize an array that will hold the clat stats for all the different
priorities that will be used by the struct td.

For fio_cmdprio_init() to be able to initialize a per priority clat array
properly, we need to assign td->ioprio before calling td_io_init().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 backend.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/backend.c b/backend.c
index c167f908..f7398b23 100644
--- a/backend.c
+++ b/backend.c
@@ -1777,6 +1777,17 @@ static void *thread_main(void *data)
 	if (!init_iolog(td))
 		goto err;
=20
+	/* ioprio_set() has to be done before td_io_init() */
+	if (fio_option_is_set(o, ioprio) ||
+	    fio_option_is_set(o, ioprio_class)) {
+		ret =3D ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
+		if (ret =3D=3D -1) {
+			td_verror(td, errno, "ioprio_set");
+			goto err;
+		}
+		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio);
+	}
+
 	if (td_io_init(td))
 		goto err;
=20
@@ -1789,16 +1800,6 @@ static void *thread_main(void *data)
 	if (o->verify_async && verify_async_init(td))
 		goto err;
=20
-	if (fio_option_is_set(o, ioprio) ||
-	    fio_option_is_set(o, ioprio_class)) {
-		ret =3D ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
-		if (ret =3D=3D -1) {
-			td_verror(td, errno, "ioprio_set");
-			goto err;
-		}
-		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio);
-	}
-
 	if (o->cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
 		goto err;
=20
--=20
2.34.1
