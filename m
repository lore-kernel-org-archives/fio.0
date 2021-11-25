Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55512C433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355292AbhKYNZn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:25:43 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32788 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349428AbhKYNXn (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846432; x=1669382432;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=1rii5OIsJ2md3ScjvER1aZaN6Mc+m9xYEc5NcOq1jQs=;
  b=PXDJzWT3xg7eNAdyGPJDZtiU5Fy/SYqUhfjdhC5NOo6K1t7MyACl5FkJ
   oQErsOxGsb/t7Wj6iubedAgjFJZ2sYZVG1B+A5qK0S/NNcoFiliukbNY4
   +MNr54s1XZkUV0UQbNhoWnjee0drm3mKQMgUd1ubwN25HflLdLyUOmpYu
   F4QX5g+9qqtbW9/Y7+IagDYtS2q1EFhCJ3xWCNQcu7JsTaV8fUm6xw1cT
   UXgiP9uzdxSIt1YeRIeoWLFe3C+aZ+N0pwLOH03c/NTcvOKid9hMyf6Kx
   ud/rympRIt8o+SIK+yWKFdk6Zdnhvw9mSa2DUgqH0T4v0P6AOc3LgG+GT
   w==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="298461771"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ybacf/idHosuRB0YtazM3SRHMQeG2WAxAms4hF0M5lbvzKR6rvNbhQ8RP4XjhatCmsnV+LMwZ1ulSHIyq374+2Qkq9KNhqXa7HvkWBNX5f0nJO7st0tns+AoFea6GASswK2rK3OM5LZ0vlx/XsQODAURP8kfqp+ARtL/W3z2JrzlIKN/uXfvYpu4Rt2gzBhIdywf0eOv8AdolXw2OvGPwSeN97aNKykD3bGuatXzBHLlW+x5x0IQPV0RWXlefjqKWVC38x1hkueR/zzekPO+oD6PuQCs4GcqEUeuzw+gbt5pzyudU2LFJy6qBGRDqsYv6Gu4pCjbDLR9SOuQXOVQnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFwun+9V80KFRd1/OBFy0fdmwypvdcJvknWLQfyUpyM=;
 b=irfk4z2y2mqqrUwrykGNQodOinN5jKIOj6gR00k13P4AHX9kzBrcyqkEs9dKqtei57iRjjctQ1aDv1GrIxdTeq9CFvHw3W0OoRc4XbdlqrOUpXeNH71QjTJx5KsFuCYtsv09jGHnOiDBEQRigV6c8hGobPx3Xzc/K/wPnVa50GP7KXZYbY6oynXiRbnk8TFjoT4Zpgc3Lfb1DcIUGgvaHZmGnP+HbztD9kVJqz1XkUDOGD6Q9JrCr29p34K0BqiT3dPsMvHLV7xc97UWfU7VXf8IZ5Gr/vJgBRPl5YEYjzG8k6mOXBtkWbZg7uVuP+MA3bPyYYs9E0gRh2D0LAB5Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFwun+9V80KFRd1/OBFy0fdmwypvdcJvknWLQfyUpyM=;
 b=zwEL7cNzvQ+G6akxE+VmuWfzZVim3L9a9XZ390OZGHYtMOxccGoMQzESgvXwLgBmF2Urtdhd7EHJisWGJAzRp2DBE3WBvkjYksSMoykC++Px1hREiFk8j7sf7CQHgMFf90w8duljk4cZoWRrKHuuNwpXBLYPBK2/cSuzvB9aP/s=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7591.namprd04.prod.outlook.com (2603:10b6:510:4d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 13:20:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 13:20:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 0/6] cleanup clat prio stat handling
Thread-Topic: [PATCH v3 0/6] cleanup clat prio stat handling
Thread-Index: AQHX4f83ui/kQsA5Mk2ojZIYT/5AYA==
Date:   Thu, 25 Nov 2021 13:20:29 +0000
Message-ID: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbac2362-74da-45fc-d5e8-08d9b0165a51
x-ms-traffictypediagnostic: PH0PR04MB7591:
x-microsoft-antispam-prvs: <PH0PR04MB7591AD39B1889377154740A6F2629@PH0PR04MB7591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OdfShszm/icB4Uk360/IGVpXVmQsTIehGp1AaPqcbtLB8MjSS5eHgze8cZPxLSV5nV6WmAoIKXRKarxc25qjj3RroO4Q5UrnVhpAxdIHo48BT59KrUniqvDtcxQenOBmRezW9zVUTuM1c8PW/o7SpYuodnvYbSQk/1sp1My+vIILYVFLvDbuEUyv0vRd4INiXRgyJhgn4iWr1+5gTZ2pICFbfwfk17CU4hDCGmWcllJPz4m6WzzwVVvvOufXuMiEuCqA2MPHoNlSyraFQiFxhVJBs4RrHvu6RCR1rJECPLrMpH+pCEwEJkT0s4vWfu+H+qQShygEzmdhPiavo9XB+iULu/YNsSItyKNzqUZMfvxtDadm5uNKxgj+jVYbj3998Z41j21trBmulTrlA7MjjUvgsn9ULPqQ48Sliu1tpc/tDX9tUo32uDCOCRqXt7omnM8H2asVCHY7EkC6WiOE9KjfpMmGUWH/X5FY/Uu4SZmr1MeEopdiiDBkwoCbRJegPewBj3a/S2lsF7fgIKnKf38162HxXvGZQCNhjHofXxQkYZFGoIckDChyZeTwELNEA6ofTZSPnF6kCIjZx9j1uyony+akvgssiaLWy9glbI+HMCeWE+MvmgtyxQEAk15LwU8Ev2MLXv/t5+4zhTS1ejiXfIVJyNhoWGfM+oJzhge5MzyaTKEt0lqNe7jrsNFMqEwztdfzxUTvNUtd6StKig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66476007)(66556008)(64756008)(6486002)(6512007)(2906002)(38100700002)(8676002)(122000001)(38070700005)(5660300002)(186003)(8936002)(76116006)(6506007)(71200400001)(508600001)(4744005)(54906003)(91956017)(83380400001)(6916009)(4326008)(1076003)(26005)(36756003)(2616005)(66946007)(316002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3MY4fS2kZQ4HyscqTHehqrVIulE8LHGXspdkIDSVf+eZEXUM0rTpu0Akbq?=
 =?iso-8859-1?Q?sbxGNqrYs+Lg3MZZmLP1ui6FRa1bqHe0X8iTgTVTd0r9LPx3iUgbktZL3g?=
 =?iso-8859-1?Q?Z8Zr9wWUReOWAI1Sf0wfF/Qrmg3+vxkbmBf1k1xugwVx7rFjvjVGSP7Coe?=
 =?iso-8859-1?Q?c7ZI9429iPaDH+85ASSQDwGKOgVVuZohC5W0JiUaZUpi5otzWEXyfnI0Yl?=
 =?iso-8859-1?Q?a24AtTTI63ruPGHRdRz8t/0mMDn2hrpdi1SYYBeS3NDCLVawgEwyabfqrV?=
 =?iso-8859-1?Q?tWsjCr/YDqPdkkGD8dsyq6P9mMrOvFN8wL0waGscVzdWmfO3c7Fs0arUi5?=
 =?iso-8859-1?Q?Fe2oI023MQMWi4gb097dYskhgKx8ZdM50gv1093JwL1R5w2IVuD8LXaj/k?=
 =?iso-8859-1?Q?MRN3ypkxoMbU1DRYWlugMbKR2NTu44Oe1ifFVz/qZiTEUtheUIgGqB6q5l?=
 =?iso-8859-1?Q?DCsFLP6WDrrdtyAkXeU2guqYde6mTTpn+wL3MLZoAUuhIfUBGooWv5KJ/z?=
 =?iso-8859-1?Q?VCVa3DBbP+JFxAC1d07inUBtxD4UdkD6zniUVp8GjIYRqpRilA+t5OYKI5?=
 =?iso-8859-1?Q?WHjwyxxvcpncOMxpz5XUSohM8xnld6xnsQTbfepv2fw9C/EBJ6zQPsXRYE?=
 =?iso-8859-1?Q?Tx8wyB7TIMDVmE6rI2CIk+7MN6OfvFiTtJ1GGA8cnXPMdgnMcg/Sm4XE6R?=
 =?iso-8859-1?Q?KckU4cq0/NayF1tqT1Y3OYi56S8cnEV/ejEGfiMqqf+OVFTPIGmE42fhan?=
 =?iso-8859-1?Q?zOo8sRRfKhfxnw698W93kkWMbUf8iU2Tc8MmcsIGHGLWqHcK6u8vF5iD+f?=
 =?iso-8859-1?Q?/9jexOZqJ0k4dXhLNyE8zwbBaDOH9U3M/WeqcmT3+BM4u3LNypmq4TOJyu?=
 =?iso-8859-1?Q?1vDceNzvG7lOILlKWBVzd6FwJgM1LlcIBS4bf5EVG/KaBzuFDTxXba0iEj?=
 =?iso-8859-1?Q?kKVkb97JwwNiZyniw94Gfjipr3XHTTgzXivAswsjdxvPElz7F09dS63Bx/?=
 =?iso-8859-1?Q?r13VBPaga4CsQ7ESE+eqMsULkgX0iMtiSzjngc/MwQQSHDLXa2wIP3endH?=
 =?iso-8859-1?Q?LvJlgqRMzZhvfpSiQgtIKDUXffFDlgeTFby1rQ9mrFNmpO/6nacKVJaWzq?=
 =?iso-8859-1?Q?jNzbeS9g7HIn6uPxOlAltj2lMY+u7eXdXQ/cWYoCy5/jxH9Wre8axhMOmM?=
 =?iso-8859-1?Q?wm7+V5eqSXVDQ/YDoIpgHFr/zKiC902bjlA1lLS7qgIMGhurYtLOPglCdy?=
 =?iso-8859-1?Q?bT4yMpS/8ZFpklgY1Ylz8xge4Y5A1sSPplLtcUtbDn+y0ro0H2fy+cYN/O?=
 =?iso-8859-1?Q?/6x8QLTZ5xLXC+0ID0WojtruVpJtVwoU363sv03tx0U9qV7i0MY2a8lQY6?=
 =?iso-8859-1?Q?eQzLFWHksyTKTFUBCCgj49OXunojGHnNZL0ufwchXH6waNUFI9DRkQL4Ex?=
 =?iso-8859-1?Q?LA13HWhjr3P724jG+hqAKyYsSt5m+PB4uyBCNDJlmLK+Bx2jNaMe40VN1V?=
 =?iso-8859-1?Q?IHPeUK+XnLmKcDAPabJyYW2TyCW2HfB1/DtsuydfhJ7qSrQJy6vnhR95gM?=
 =?iso-8859-1?Q?2igJYZNTZ8PQDQEegcnm6rAfMktyjzDHBSVdj236jKf8LxpDytJGd78iIl?=
 =?iso-8859-1?Q?LHSa6AALuSk2qYKW+E+s/xPHDYHrEkx0LQvrMCfTtl9xEof0q1gxcZ7tXm?=
 =?iso-8859-1?Q?VtwVVrmfZ+duWhtvTiQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbac2362-74da-45fc-d5e8-08d9b0165a51
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:29.9044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3CEzneKW/S1waD9+J1T6AIvwgmpyfP4oeovXh7yP3wHnBYH8YHXiLtTYFxwzOV2fxdw/ZTYihuKmvgmsptTcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7591
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello Jens,

Please consider this minor series which adds missing information about the
existing behavior of the per priority stats.
It also cleans up the per priority stat code, no functional changes,
so that it is easier to follow.

Changes since v2:
-Picked up tags from Damien.
-Fixed minor nit by Damien in commit message of patch 6,
 and minor rewording of the code comments in patch 2.


Kind regards,
Niklas

Niklas Cassel (6):
  docs: document quirky implementation of per priority stats reporting
  stat: add comments describing the quirky behavior of clat prio samples
  stat: rename add_lat_percentile_sample()
  stat: rename add_lat_percentile_sample_noprio()
  stat: simplify add_lat_percentile_prio_sample()
  stat: make add lat percentile functions inline

 HOWTO  |  6 +++++-
 fio.1  |  5 ++++-
 stat.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 48 insertions(+), 15 deletions(-)

--=20
2.33.1
