Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C107BC4167B
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353756AbiBCT2k (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:40 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34997 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353764AbiBCT2h (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916516; x=1675452516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V0kmuMtblHnDJgM6i5YEqketqOgC2E8ZKAV+4K38/ZE=;
  b=kuAbqvOvv+LB2MZFWRi9oKnbaY96anNEZ1LgujRmpHmB6p1/LqNi/EtJ
   0pPoaa1ndAIG7x/ZFJicGjM4k6CNnP7HhI7EraFcJ9Jj1Rk3E2d1Og+JI
   zaC+ffGHBe3WfkUPzpY1kK6fYgymih31SQhPiuA8I7ZktFjBMm98hSAok
   81MxDZ82rqXIIJGmITcsSTKFHGapILdgtMeGJar6VWIXyISlEhvcH3cIq
   GRdoZKCoeiZta6hzpDIPQ3t4/jmJrPah4s5jQoCRRGgts5rq6DKHsA2mb
   /wYOUyDsBuPjMo9irD5nw+DdkV4smdrw3t1vGTQIkFgqcFJ7misA7g1/F
   g==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107562"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BP6bqR/VAUruvh94kDdQRSshRzQaXmgXwXnR40eHyEAICr3JRsJ7iIXH/32AUguyR+HBpyfK32iDLgtiJqkXJGPyGPH3kbMPcFIkmmckU2olZAydrUOmqrOTKxJj2RBWy0xSGDO2C6KmEt/9plDjeIIeHgT9PQ5JEeBDlIxPyOzNXw7RGqilpgk+NosTm5puHflUejmaIgcEFk0C8M9MrbDo8kOIqOivYC1fxgzR7d2qTJXqxm9Zkrq+XzM+UPCXbDHDqNujsXd9nhVDqT4DaGAn1uv9ZJWb3Ecgc/ak8pxgqLGibdw4HW1EgVREQijU9rdoKRwEXvqRB1/PY2Tazw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOaqLzXtz2QGg9U3WdP0fRsJKD/OjTK4N2gfvecm0sI=;
 b=XrY35qwWmGjl9agWD9Kx1j9APhO9wB0qARAjZnkCBhOOwXoucQpdeu4Mpo8yZnfQKOD7mW6DT5GvtjrpeQE04zrjogRZ0ThVZzqoJ+W+IeSi3xU8XfRq78dWmbxUSNfPyf6D3sTo2AU2zZpjsZBppCRutCo9//QVU81TGV0htnP/JotcZnHj2bFARCrKkZ42nBPvwxLZykdpSd1E5/HSZxjM80TfxwqoLWw8d5nSzvusTAIftBupm2IIsCJjzhJopcj3XJGSCxuWrnew4PYkLuIjClc9/EgKnA/V5k/O93yvbq0DVYYzHv2HlQ/ocnQ16gbonNG7Pc22TWPR8uYYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOaqLzXtz2QGg9U3WdP0fRsJKD/OjTK4N2gfvecm0sI=;
 b=OmsI4jJsYiwBQ7uP9rCAtif1VzsarB9a+kHb9AZluMk59qrIFTfgO5IXy4Vcx7x3Djbyc1ITe3LZXm4NX4Pl95PhF03pHVq/Dj38zgenvIuf2uOW93G40jr+sqXHaAwQyYEU3Q3yeq3VJiDw9qPacQy5fu7H/Efu+TL2q72wZ2I=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5423.namprd04.prod.outlook.com (2603:10b6:805:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 19:28:35 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:35 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 17/18] stat: remove unused high/low prio struct members
Thread-Topic: [PATCH v2 17/18] stat: remove unused high/low prio struct
 members
Thread-Index: AQHYGTQ6Tv8R2PGoMUeqjppDKdMQhA==
Date:   Thu, 3 Feb 2022 19:28:32 +0000
Message-ID: <20220203192814.18552-18-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 22d2dcea-5566-49f0-8d70-08d9e74b5f5e
x-ms-traffictypediagnostic: SN6PR04MB5423:EE_
x-microsoft-antispam-prvs: <SN6PR04MB54232758184A5CDC8E64CAE7F2289@SN6PR04MB5423.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:81;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kQOyNz6IdKfYzTW+kXkhrgIrEWayDL4Lx3UbCq0ytIFe+TI8S8ilUs3KClOotONcWS56gHAV9ZDkGFuX/i13Du4HU36wBBFVfUpc4ekn1YMCoiYHlxk/qMlGhAc23iFsCgDWDwQyLFclB6ATdmBso/ZT2Mfrxi93FrFzHByMEcYpbzCsYYXPRYYLS8s2RHCr4ouysf6QdpSyr/JilvxF3aAmYpy+SBb02l0VLJSPT48fQ5j7OfELC8jxc9xw3206disEVrjpUJj/lLBnb0wPyQIJNCma28BOV+Clqa2gxdMoXI6hmLNz5XYjhXA9Wj7hRQywTljznT6LjErJ5D7/1mFPs+Z9249ewleSKXXm39HOrp1D6aLXwJO0FVnRsnfDog39q9cExKNd5Q6zmKR7Z/9m+2hIcTDRXgXoRnBz7Mv83LQZ1w9qHmXjbPAF6H6CXUAW8EXMcGVPjB1fTU9svzX9HM0nFpBYzyc07IlLeCI6PHTaSq7UmBBztrTxYu1YF8/EvGjpY59muaOJZ0mu4Ht9e6lxZ4rxH2StV8tJ4miTLE/3bF1/UP12fqCCqeyIlWsclHcdQlVUoQR0vXPdvSb8ak4V0tHR8pYQpQBZYuLGW0q+wYWa81tR9pAGy/tr+2KH/LxGeevwrhwCtzwEo0NQYgRKtrbsF1Ch6UE47iAj5KfHw+wwav3GHfWimrXBM3SD9yVpa0jCqCY3VkIr+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(86362001)(66946007)(4744005)(6666004)(91956017)(5660300002)(64756008)(6486002)(71200400001)(6506007)(8936002)(66446008)(6512007)(508600001)(122000001)(4326008)(66476007)(66556008)(2906002)(38100700002)(316002)(2616005)(6916009)(186003)(83380400001)(26005)(82960400001)(36756003)(1076003)(8676002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?LrFg+ghbZF+BRp27IrI95v8+u8mTN9P4cCHR5O0LOr4YpSdR2lSHsE7N24?=
 =?iso-8859-1?Q?FVUNf0MTtVaaOJwLXfuH/JHzdFKf/arWSYfX9dJamRp/ZfLgToDjje3cli?=
 =?iso-8859-1?Q?sFUmgstvRsxdD9Nd1TOyWUxO5zk17fX/47y34bjEdsKn66HZEVwDniyuDD?=
 =?iso-8859-1?Q?06PE2jxC4D9Fa3f97Tg0fPwToEGIpmYQZOxtTFn089kn3Bk/DOR0joYa5j?=
 =?iso-8859-1?Q?6fpw8XW3/rviF2AgfEZv73F4Gj1OkE0kLrOcBuRf04nppvhqKfeovtRB9u?=
 =?iso-8859-1?Q?98Ete4Iy6Q50i2sSSiQ1Zo7WB7FJPoRMMwPJe31B7+yJ3bNKygcgHokseu?=
 =?iso-8859-1?Q?NdLuq4AvEPeWg/ZD3yQmQnYPUKLz4KhCTiTs3ZZq/V86clgExHgX+5hgvH?=
 =?iso-8859-1?Q?IYYh6YCzPRsdqcY0tNtED0ZhxnF0xTYR0iu8vkUYtLMHBnpXX0gp40h0CJ?=
 =?iso-8859-1?Q?iLtMS5sNkZgCpbLK/5DkbJ1cl1hkS0T+5MKw0EqRLQqvYsTaGP0pVK1wsP?=
 =?iso-8859-1?Q?q2hmezuL7fEK4iRnB8W5nHIcTmWe0JdEDcva28rLEbswsR6E2N+1UyZqhD?=
 =?iso-8859-1?Q?1usfJpl7JXdiV+QyoIg3oDSvz9WpJy7uZbaJ52TJCjeNpfnizGcV4Gh4fh?=
 =?iso-8859-1?Q?KDmWiBUiDbYD1m0746/3RTOnBIw9GlC0wbBUhqBCM6kIgMAIlGw2Y5hinC?=
 =?iso-8859-1?Q?lOzg+Umycmo9ryaxq0GJ8TYVHh8UdLgs0e9+9HqOdLEPR4zp2LnIAIj/7i?=
 =?iso-8859-1?Q?D4yBkw0LUv4tAj0CCsGKcLirUyDHH7YW6B19aGPTB6O5PyvnPyY6VnnzLy?=
 =?iso-8859-1?Q?sQ7gQMv6zjXOW+3QhwHKAHGETVn3iZx9ogVa1hL+ObgSYXDuqGvuQqYT+R?=
 =?iso-8859-1?Q?XmXV1WDLadGDnz7OXtT7qNgrDLhxpcvfxsASd9x3Yo++s8W5A0KQwkP04U?=
 =?iso-8859-1?Q?zVViAjc9IhW/SaSECXpKZRPSdroCroMc0LnR0yaU896ATPgC0zQgMk4r8D?=
 =?iso-8859-1?Q?t0tHRTsjur1ztnKk7/YHTTXwS8dB72n6wM8HysR/SeunIlLH0bzzi7EIy6?=
 =?iso-8859-1?Q?O+ZdMq6NLzZJwanQUNvZH53PR2fUdTMNkS2SshczjEtQjLlkKqMqLuzy3s?=
 =?iso-8859-1?Q?/eKTuseAWU24spRAUOVSKtoJRiSL9ycUSLMivnYex5+orK32sVb+dLef2P?=
 =?iso-8859-1?Q?8760fUzutFHleOvfqEozIXLiK5loxxIZrNy0957tX2wIxs35x/1hdJp/S3?=
 =?iso-8859-1?Q?a5L6CFqr+h/nIviKJlFzNKvNWV6aRLMe1OqlGqQMrWkh4msX6+LZiUlyvB?=
 =?iso-8859-1?Q?1e7AVyeN465tZmDT/Vqgm51j42/jAfHuJG58Sld7h716KdN5jU2kR4g23d?=
 =?iso-8859-1?Q?G5CVriDE3b+8dgZRpQXL3HGh63mEI3Kn/8zqewWvD864IesLow3A2HNpiR?=
 =?iso-8859-1?Q?RfPgY04XuR91XMFSS6T3RYjJ2mNMYV0q5AbFAKx3Rn65qhCr1WV8+TyCnd?=
 =?iso-8859-1?Q?jXIc+DMJKUexhzc74lKoJNu0TkfxvIMmDAa1Zr3CJpf87fAwfTrWldpjuC?=
 =?iso-8859-1?Q?giscbsnwjqGSevWvp/91kqIr0nN0dm3ym0VAB9OiTkbgGsjnCHa5iq059F?=
 =?iso-8859-1?Q?UbEZISELzdKypcesg43JeO9q1fBLht9NfoKUXe06i5iTBdBgJTgJ73tx8i?=
 =?iso-8859-1?Q?lJ2o+fNfC8xaq+osxdJQBYPyHvduwnznIb12UBnN?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d2dcea-5566-49f0-8d70-08d9e74b5f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:32.3694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vo2wjhrEFMDCXmzhNnqcVwYnkNKSO+Vh7ns7fl0HYoEmyU4xfA1GfM7nYZoIvRypgmBFBuclpcKtpctEUs6ANQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5423
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Now when all users have moved to the new clat_prio_stat arrays,
remove io_u_plat_high_prio, io_u_plat_low_prio, clat_high_prio_stat,
and clat_low_prio_stat, as they are no longer used.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/stat.h b/stat.h
index 05228fd2..dce0bb0d 100644
--- a/stat.h
+++ b/stat.h
@@ -262,11 +262,6 @@ struct thread_stat {
 	/* A mirror of td->ioprio. */
 	uint32_t ioprio;
=20
-	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribut=
e__((aligned(8)));;
-	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
-	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned=
(8)));
-	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
-
 	union {
 		uint64_t *ss_iops_data;
 		/*
--=20
2.34.1
