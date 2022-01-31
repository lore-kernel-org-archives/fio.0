Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C73C43217
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379861AbiAaVNT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:19 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15176 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351142AbiAaVNJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663589; x=1675199589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=68cvvJQgEZIUX8SEuaH6V+/6ofRc/j/Vt32E6hYwU0M=;
  b=D0dXOZK2L8I4VIJ+Ig4E06UwIqfltugjaz0Ar4s+AQm1s6HmX9VVM87t
   8+Ai1zLASE4wujtnb+4LZHcuw4IZuoIYtNrEqPKJQbnXEQW5BGfmvpSV1
   +IJl9pPFVnQPRe2z0kIXFbSsOhj/bmomyfmgdlIwjvNmTYW4mW4RHsd6v
   aNeyJtAW+K8DT2zXMGWeYpjrA0Ojavt80koHNNTIPHApHxW3PCiqUqm7t
   vqfuxOVwjH2dW1yt99KMj6JO5hEMKY6Ei9KBVVcmLyn/C5Rqnpr90tOO0
   xfODAWnqppWmtD3m3u1B11kHpUuoB/gxqHx9gtuztU+kTiEyoLyvos1VM
   g==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720259"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1Y8yTI18RANvvNh3ecm3pMR4cBYnKQgH81iECqYOy9pugldlBa8Zobfx5vQi50o2XMIC0B6vu8JqLHILpOufU8UYsBKLqvWbovPYvUx0B6wuv/qOCccvrd2m+FfJzPbahSGoPF873xZGYdofK2BwQFolS5WbYjtPytbu7+OCrW1rUSzq58AvdnYJJLG6afwQCZIg9DlKWJymN/i+JLzGU+egLpno/7MuUJiNtbMqYCILufcPhSgAPh8Pfm8koLD6i/c5WWEHvLjYFcEubAE7A9TNfDsQq5bWADZ4MYiijBd12drzQHR/4gaFHt6y+jjaZ6fejQ7i9k0u6cBSxQmYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUS4Ich6mP8ooHgexoWmB65ZzAJtXXSCwStRqMjJCSQ=;
 b=YYHhN5RbXB1eH7q0kdjyX3QHAs7uASApqfxvWTYjVIIdcI/jT8Fo3w3auH/EBapauECgMiJwLndajawGbkVSEk+JDKAClRxXQgnlH0GZTjwvOxJb4sBQvQ2s/tOTiI4l1NVsBsL5G+NksqG8zKx8CyZVhsze92RSsKRUNt8d6S/bqn45VKa1NqEZYu+IL6T8SPgk0TRBE+0nCUvlNq+H05Hk+t8ahjdY8jX/Nvitk+iEw7HSt9IqLoPGDPQ00q/8iPiEcgXjjJrRik4hG2qcuqKlWHzmY3Z1wxeDCf95UZTh2PO6aHwwpgkjgfzeL1y+xmw0DsTE4cgLkv22X437RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUS4Ich6mP8ooHgexoWmB65ZzAJtXXSCwStRqMjJCSQ=;
 b=faeIEO6zF1Xyp5NpW6TdkCNrSSGy+t0GfEDSCsOQ5Bh50YasYqm9X9TIUBJ6OjRoP3ZAmEze1uequi4Ivk5JPwDG9jxeYssYbi011r2QqIGbWQ0Yrm1CV1aNuOsfI+yXiH5E1DATOrzE/KuggN6mNFrOogHUBkRjJnkkUVrU8rE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:06 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:06 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 10/17] stat: increment members counter after call to
 sum_thread_stats()
Thread-Topic: [PATCH 10/17] stat: increment members counter after call to
 sum_thread_stats()
Thread-Index: AQHYFudXCeZ5Oz/1GkyaI63BKzc+9g==
Date:   Mon, 31 Jan 2022 21:13:06 +0000
Message-ID: <20220131211249.106820-11-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: c0669b93-e758-4d44-9c96-08d9e4fe79fd
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB757666AE7A8D6A57BD95D0F3F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PyLzjJJ2pe5JjL2OhBWKsx1qTkxytVuJFIibdohMlFZtRD/mTvcUWAuR0lO7YVowa1KCTkF0w4zdZXBEUuVDw6h4E5eHbIiaRxqFEo4jyv8wmnFlWs98vyucodb0FxiGbBLNI3ohEOMx4P1PvjfHGnGIe8mWtLmFf/dgF/FZ8Nj/ohd5uWwP+XorwTM6pLNq72qoir0Wk78i13nNUM4vqLMUJz9cTrItP3Bk90XntFoG18BaccFQWxsG5pZJk3LqYQDdYlSnVv4WW8OqSwqGwwf2F83YKY1HSBsQcMBxITQV8oBTnZEXXhGwnksB/mzfY8oA7bn6XpduQfhf9n5JugCbpUlgAjPd7mwydGShTQ4z4BdO9AW+qDRADWUrXkYWq0gu+15hR8CsLQLhMumrdJRE6FgWHXmFHaw7rl/p4tCLPVNKwhpdnLkEU20FuoF+0qYbeIA6CWSbXl9CKLU/FhGOoVTIQCdzxzFMDbvOVA5zy2RIXOatUOedYYxOGErd3tmffyTXhnUCnWm0uEjNzGgPaxiD/eN7Q59TqIB2imMVEucuhpKovuUktZ8mGVhs/Pr2LWhwEgi/JZSV50iqB9a7UUKflMEYgafEAZ0mYwTAUc9eVgKwFOF+pkWZWHAaYwzu2Jl5YGgcX9+j/fn9VVpXOsPyqbGz9/+cHixQ5LAMrVIkBv9kJMFo9abUFtFOGhAoDpOs1xNgzlyAGtsMVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fEmCi983t4aksoxylVMIXTVPwOjK3rmo+v30vqTHKSUii7CpPxVPJ6ljkT?=
 =?iso-8859-1?Q?MjTIUtG0OydOru6b1IeABvA2f5IUA8c+Y0QO3By/03coBy6b+eqiICcVDT?=
 =?iso-8859-1?Q?1bgjZSIw/2Z2qRHjbmwFVlPli2t4dwVr6YaRVZuZpBblu6WFKvdqoCqtMr?=
 =?iso-8859-1?Q?Z1k/+OO0ZmTJ2KfLcMqo3eH21EMKSfg53eT2jNJJf7gI1FIzu10H55CFtm?=
 =?iso-8859-1?Q?80JQlBsb3sFklE7ir9qrO1dWr27IOk45JcTsE0+GiGF2sTJZhAJtjvVcex?=
 =?iso-8859-1?Q?7+pXX5uMTFvO+tLofIWiPeIbzT/2bFSX9r37P4EYnGeMRxRuCxyMwIr420?=
 =?iso-8859-1?Q?vOtUBqRtvXBsp2PXE6F2qx+Y6Lnq4LwtPQnZGZHMYBe1PG7REhUY1IkEJI?=
 =?iso-8859-1?Q?bztB7B9tYO5bFsE36uzqQnyikqQniRzin79aKYhO9rSdpgwVNpZeVah+8h?=
 =?iso-8859-1?Q?YDAGK527E9TjI0evs6aiReRL9CqKtPy9sCUilR2YEDFpITok4FQlRmBRv4?=
 =?iso-8859-1?Q?x0TUiz5rgZ6JXomgKl4qhswflvTCh8o8WzdTrF/07+WzYnSzPh5fe5d4gp?=
 =?iso-8859-1?Q?6dDtrqCR/xrCGS0vLAykh/2GAcVqUitdHD1Fdi4GjikZzRVSbuM7cy/4+b?=
 =?iso-8859-1?Q?mm1eIKA1OHitmH4+Uco5pezrDpZcXr3nWLn7GKH820S1hoAoIbRkSvoWe3?=
 =?iso-8859-1?Q?4sR1ksf47ipRYwh9sDksfbjtODF0V+8/k5CD+ic4Kh6iI4Q8Nvj1NLIs1Y?=
 =?iso-8859-1?Q?xjH5lRGQ5XZ8feOGz4PzYm9LT7L4v6l6bBFaVI6pIy5OA7zG/7TMkGrEa2?=
 =?iso-8859-1?Q?QOJFnmnC8d2Ya/QaF7pDTXQnxf7xycWl8ZU8YH8W0uTYHxFVs4XEMQic1S?=
 =?iso-8859-1?Q?aapKzQbynNhO01IMJj9bUc01YsPl7PbZsb0vnO1VRbJqsbWhPTA6udxj2R?=
 =?iso-8859-1?Q?jp0Ze9Ivf9UPU9S0uSq9MTglU5O+a3HLDrRQ4PI3yaoa+YsRN6cQa6cKbY?=
 =?iso-8859-1?Q?VIeoFK2dQJY9lxtU8zt0+k+WDqLsOzcNIhM7KKQudjrUWlRpHAtREsVP/q?=
 =?iso-8859-1?Q?0zA9p5R2Qf6mXY2vypJZcTVhe1NianvoY5ugOLEf3Y49AoFfCZHUn+CHz5?=
 =?iso-8859-1?Q?Y8bWnLien11gN7WnsHCZx77OUFFwudo/cuEO3c1n840uiFaGm1r0fqFHa0?=
 =?iso-8859-1?Q?kNl8ZiqhbZggTVfr97bX/47RgKyyCICTq6/8WGaBc2CUwWoUq4kAKI+6q2?=
 =?iso-8859-1?Q?9mIB6YdgPQUM8aiFs9bID7zliYQBNsbUJB8rtb3/SKPEBEh0Wa2s4qadjg?=
 =?iso-8859-1?Q?lw1Yai6m5drQSItD5eeThvcddZrYRsgr7NcU7RJDiwafBhtEeDENPCJoFy?=
 =?iso-8859-1?Q?OdcPzT+fj2PpFcs9VpRMtHnD3caFin8YSX9RoY03YGZkYtJV4pSC4Zk1oE?=
 =?iso-8859-1?Q?6S7j6Bxtz71xgOxTu5hwdEIvrz3lSHOzu1a5J3xXuzO4lq/CY9kb193cb9?=
 =?iso-8859-1?Q?N78uqYeJbDv6aoQ3+H+FwoNiyRTJkCEM5BmA0bF5Xm+oYyOUfYAbZ4EZXW?=
 =?iso-8859-1?Q?JvTtBiBSqK7xbCQHudWyg/oXnekawTNa7+mtbbn8o/WftmktSbSn+Bvhov?=
 =?iso-8859-1?Q?OK9rGR1pClL+juoojB4NapQpizhwToCcD//QP/jxkn0pT5L3OEUrrtt9M9?=
 =?iso-8859-1?Q?Dh45WRSOZIJyfg0i6bZTqGk44WOQxnw61aJ1R31r?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0669b93-e758-4d44-9c96-08d9e4fe79fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:06.8032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0PmDfrK1+z1BJzNHqzzGNCrbN4BsvUEJvsowBVX4Uuho/XT9dEEJPmt8fBcGptecmhkOYvG8p0QHppJwpvHtqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Increment ts->members after the call to sum_thread_stats(), just like how
it's done in client.c and gclient.c.

There is no reason why stat.c should increment ts->members before calling
sum_thread_stats(). Change stat.c so that it is consistent with client.c
and gclient.c. This way, sum_thread_stats() could actually make use of
ts->members (if it wanted to), since it is now being updated consistently.

No logical change, as currently, ts->members is only used in
show_thread_status_normal(), which is always called after the call to
sum_thread_stats().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index 5aa6d588..ff33174e 100644
--- a/stat.c
+++ b/stat.c
@@ -2241,7 +2241,6 @@ void __show_run_stats(void)
 		opt_lists[j] =3D &td->opt_list;
=20
 		idx++;
-		ts->members++;
=20
 		if (ts->groupid =3D=3D -1) {
 			/*
@@ -2308,6 +2307,8 @@ void __show_run_stats(void)
=20
 		sum_thread_stats(ts, &td->ts);
=20
+		ts->members++;
+
 		if (td->o.ss_dur) {
 			ts->ss_state =3D td->ss.state;
 			ts->ss_dur =3D td->ss.dur;
--=20
2.34.1
