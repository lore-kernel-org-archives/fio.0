Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9605AC433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbiBCTcP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:15 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1744 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiBCTcO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916735; x=1675452735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OsOHEsObQgHqYXAs8HNqaLVHKJ50uma2N332A3rMqOA=;
  b=bUuufMKnYq0vD+aX2pom/4LssCXJxUBbZ/2ZuxAVbh0vqsUzXND0eJaX
   FTXk13kysp54brLWdI6yYxgo1bUNgqAhzFcz+311MWSOAP/NV/rDh7qrW
   PcTTw1G+7Xp8Ms3UkF5B7jFxIeXvB2UKsuirwblP4kRCtYZm/pfB+MoNp
   x32boaX1m4AOQzWfAOhDrmXMBte/kT5p533gwdGRijyWMM8MoMPQBsv2U
   lN3OZydp+CW1KdlolG75dppDouhlEPKRVkmnwu30P/yi+SARKDG1Kdn+a
   63khHrJMD4O6l/wc5qMhovROLtFl4zOY/vP/Ab23WSI4P0L/Enc7cnfKM
   g==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095705"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsD1CawEfoEDbzrViYeIFhFmo5Lab96bSEl6PgGdPjGjwQaD/Q1oCTnSVqnjgfAlrixrvshD7MVDkZ4Y1+gBTgG3LvdPu25V1T/2wzJ6y92mPXIed8AbmKsj8LX7YRp9+eMjVjDLaswn5h6+GG5PurbIQoNaanvHCAXfjEoMNrwvf8TZRa5HORyCyQ9FVd/uYOSpeIbkZZINYYAk7t3tWgpxwHvXQYN3KImpO4NBPgNwnWvc4r+x3AQmzZ1LvIwKJIkggEykkBLES3ZtBNap727gfU0WWTUChwrmb69gZ+3NsN8C4N2e209VMGet6CI/LKr+7Yn+c62SUOtbP823Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8VNlX6A16HggQXACPwHlN3kpIO4T5/Db3nzkukwbtA=;
 b=BgrL1wZJjx5m2LAdqYF3Kooi8ImLFQY1NDfwTP77yZM+Dctds9crtias0oa110Hu5nLPBjRcPKcoz7N6PL5QUwUr1tCDC1b/u0QmckWiuNSzopB9QkxNNBw5J4mVTiH2M2yOVPVh7cvCKDt/kKpZG2m8O1Y/m55J4eHuYMSznLV5b5px0aMFF6VrWaU0IU4us1SNBHmEiIVim00iaIoSTht9oW57ZYMNhWvbKu0s/6002SY9RdxFtx1cXMQ/6/VT1EAbYyIXBskXIYVMUavUd9YFH0uGNn4o2X/tCZ5ORiU4jFZxBu6tbj8qBP7auG5R1NaSDEz5qasggE6rzn59aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8VNlX6A16HggQXACPwHlN3kpIO4T5/Db3nzkukwbtA=;
 b=Br0I4q7VQL/VPQqWGijqJo/tv1geJ1kGlqJdQ3+V9yBcfGSaLfpfDlhg1T2VvMW6JlEu6jEX8XAhxf3qDDqj7C0JzcN34DVboaXvwZe9cILsVal/KcgLSlTSePx/hRaNAHHdGeMxkJYFoSwJdGhSAeyUA30eGrv7dlvpN5iqenY=
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
Subject: [PATCH v2 02/18] backend: do ioprio_set() before calling the ioengine
 init callback
Thread-Topic: [PATCH v2 02/18] backend: do ioprio_set() before calling the
 ioengine init callback
Thread-Index: AQHYGTQ2wf+U3CHfg0Sz4IB5CN9naQ==
Date:   Thu, 3 Feb 2022 19:28:24 +0000
Message-ID: <20220203192814.18552-3-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 848973a8-187e-4888-c4b5-08d9e74b58d1
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB46321A98B37036484E2F57E0F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l+DKG+eMc2jdhqot2y6dt9xwX0pUgWw7M/L976TDo80NnwAyTvyfbrri+G613CGlaRf/yafCIqhOz21EXvD/fpKDvDtDnbtfMeLrAE+qwGuqACNMeG8GxIy+WTL1VpXttcJ9WwHGNCtHV7TBEHRXCigE+XhovvFQPQV8PDxg2nCDe821D+whquYWe8+pdFpjDfD9ZCN/gEham1TM0STXqK591LQadERD2Gwjkeg9yDVU2w7rjHHY57zCUVo7ZGHl7bZbwDHEeD11doR5IJnHCIivlaPfhTJkHkSyjGErHYFdnYogqEffzr1r8WhVZk6PrqgJLjD8CZJ0iJnAXxVeLwnGB1sVm2weVQVSPMQvzxlv7QQHuTUe1/srm2Q7Kf7uQdcz1f5F71KTwBN92jVOlNZ6/Gt7AZyj1dV9y9PtYR5yamRAZaQKZA00DEtnuGtkuqsArQI/W3PkjBXdtx1zyOVDsqwaQNqyupPoFSLToi415wW238zVhp+Nq47pdGpJbymGgNNHVKhaTxqIAdSDDDpJnEQWq1WdxFAB6pfuzqXwlX2Jpu1bAdinPNGeD8uCSrl8GwkWNeT4/Wj32HxapYwPbj/Y6XsEYU9C/LkCyY0b/4Y9T1HIigiMX8nKPXhEbaYtmULT6WGY8d4ND0n2gUwe5td/NgpdJ2JIFJIrfw+ncKsYJ+NvqGveK5Z0UtYt1Sb/EbutPUcVAOTf4160lQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YJmcNmO3dENcdpYonCNBldJVg8c2I4HnLRJAQA8ogPsWuQb0ozWHKpGxDG?=
 =?iso-8859-1?Q?0byKAUkw4YmZkuhdg9ZS/LWb/o9HrrWCZYOGFAgiekkBs4j3lE/gnBolh3?=
 =?iso-8859-1?Q?DuU3Xd+ZkwG7it4lrEdPhL/toMybsKT4Xxh/6V8RsYFIpHtByGhaXCSJ9G?=
 =?iso-8859-1?Q?pfF0XKd0KDCUPw/VIalcpXtyrHieof7zIMcLzw/vF64+U+xGHmQ9ZZzaUB?=
 =?iso-8859-1?Q?xZXK3Z/323ox5Rhl2rQ/OXxEAFBi5m9+J3yt4e5Nea6Ofrs58UYFmv1Ilr?=
 =?iso-8859-1?Q?hbq4BKftOC8A3CLawgdbg2FxiFH4FJNwr+DYqF27IUENsEocfEoIMuc2qS?=
 =?iso-8859-1?Q?5/y10ZYpkXrZu1BeVB36ceySrsWODhofa3YM4TPmKZfsP1j/3SmMaYMTxt?=
 =?iso-8859-1?Q?i3n+hZpNOMPW4/z+qr6DL3f4Nu2hKEsonv4lrpUHZV/ekC/e1Veb6amrMJ?=
 =?iso-8859-1?Q?bnIGfueePfpiVKm9/DTHYs0Sxi+bsCzh2OeVKvLgqNjVWMJMgTuWAqdnqF?=
 =?iso-8859-1?Q?EriAycQdH9ZClB2W/T9nIp5uSK1G+p+5MVWpJQwSmEUoO8AXwElhHcH4iT?=
 =?iso-8859-1?Q?Xrsm1r7Kd6E98wG592bZ23AbOtmnV51e4LLMdGF7Z7ZYrrus5VueNSEUiF?=
 =?iso-8859-1?Q?ROkqF7M/4+OvEbDjEf0fTdY2Up+498bQHvPjyunDmmTpDZOiWRxWZqTpV+?=
 =?iso-8859-1?Q?uPpxzqFoI1rABBdb6DWugCbmvwhed/e7v/aAB9Vau+IiubVZejfoWoPsZX?=
 =?iso-8859-1?Q?xgCLQxeSyJPkyHu0nTZCETBbr5jAkRn/zHcRaB8KmTxd6sVygvEaqLGEEO?=
 =?iso-8859-1?Q?85JwnUAjm1Hvpa3vmkXxzsbgp3Nvf2CePJqYTEqxt2eDIki+YqJ9fPAibu?=
 =?iso-8859-1?Q?nHKxqPDCrClhkNJo1D++OFCH3ngKbTyd5m5WXo7RwgUlA3MbNH0tnMgXTq?=
 =?iso-8859-1?Q?PCz+ttNLOnzaESNmoqNmZwTTVG0BaQkjD3oiuw+F9IO2qJAUrAQCDlpvV4?=
 =?iso-8859-1?Q?uTEp2eQZwXqrIE6R/mG23/IqH/p7/YyoqixgZHd0ndVQKqRC+kqL+Kgvs1?=
 =?iso-8859-1?Q?RahcKFKFYxely7lXq8XMLGA0Otx1ihg35ctDvFNdKcX/GxyngQEc/3r05D?=
 =?iso-8859-1?Q?vfzSRDWEsRB8xqNOd1kcKfcHrNf7NYw6XqdV85uZtKIDcjoCjh9u1eM/JA?=
 =?iso-8859-1?Q?sNmzkrxsQfED/EBqDxyx2nCgL5mHr+jKZuSax3unOy2JuK1VxLbC1UIszD?=
 =?iso-8859-1?Q?sLY4NoB9Dx79TvDUexBwAY71t/aboC45ms296+ARJ5JsnlMkXHV5N4vduW?=
 =?iso-8859-1?Q?9CEH8IqcTGjPwE7Ff2VOcbBqMklMuAKFBy4z9ZQ/ePtdVxW70ty/pnYp0A?=
 =?iso-8859-1?Q?ai48tz0JtqtXpcNFhgj1jdJlS5mhCl2BlI4sILTvrE221qoQJwSfK48t/C?=
 =?iso-8859-1?Q?2NRl0UnmM5Xbj0YsRFzebyn+ktLUXWCWOVabP+qqLk4lp5bc8d+L0jvRTb?=
 =?iso-8859-1?Q?Q3Q7U/4D6sRyzZBwK8B2MOklX+TBfrZ7eI40LudUtZqRR+WvD35bWO3y5J?=
 =?iso-8859-1?Q?aqN0OHDwy7fcDbzbHbmS0Zq/icRKYQ/pj+Xknsew1Qt4qTkBQ9DHlaZRg5?=
 =?iso-8859-1?Q?LOpspCvxcmPW/RhObMbARvKmqFGVZbOGElM08YeCGFDA78cGcalmEdLEM6?=
 =?iso-8859-1?Q?kiPwg1GWnYgZVwHLio8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848973a8-187e-4888-c4b5-08d9e74b58d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:24.6623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHuKPKHMBNjknajloWsjZlOEWGX/KGJmxSUZAlY6bbRLrKUNltcf3NWqtsJY0xBQwqrWj2eBCwR8KAgrRlnwBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
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
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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
