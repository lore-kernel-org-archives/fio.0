Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DB2C433EF
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E66261077
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhJMI37 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:29:59 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21259 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbhJMI36 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 04:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634113675; x=1665649675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ghrmxQmHu4lGwBHj0SEARQDjQjbowDd0GzUN9GflQZU=;
  b=DWOw/mSqmnXyl4VROj8tVZvKXUMXyg6LLCPvnHvj3xZ0UE/IY2g86Myh
   3YA4+A3yEsDuNdz2bTtK37IjNGuH4umgMu4tjbDw15l3xOtunuyhccchP
   p8RFgkOl/t0cm+ALSODx5ATUp+E9V0JAge3GDslIV/1EZBw4EIuurL1g8
   uvphbJml28c4/xg47jPToZSoYDvSprNwMdsGvrggrjjSiZTTWh+HKbfh/
   jRBnNTF/8/zILc7LVFXZ22FA6KFSekAjt7gWnr+vp1OMmPvMqIsVp+Wg6
   NW/kGv7iPCyRjJVen2UpmwqBFFw87fuaoESO4rs0tUHDAo8jK0bwmFFse
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="187486057"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 16:27:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lx/PTgRK0GIVfd5hutIx0oD1UGRMRP2iZI+XODzv5CyoP+CkL2Xq1T3jNjEOy0pw+zNigt0+rSw/evI1znpl7Gl0FN55N7/fYYtOGTUnVCt3vQNLLSt2YnpwOTzJgOytwXhPM15APjh3N6UeP+WIIfUxYGS4xnQj3/Ik4frWmprP/9abA8HvFvz4njJXeP1EyeXrhGKOQZHzkO0DiuIt+MG+/OGIeq5OHkzbNTO/8Jovzr+iHXmv/cdfUhx8W9+tzmMMJnbn2J4szvwjSFLvBqF/SNYJF2KNdZWz7GKn2Pb30xr5luuYXqvNMLr86PIQf9d1t4FfN9Y+lo+v3Aenug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghrmxQmHu4lGwBHj0SEARQDjQjbowDd0GzUN9GflQZU=;
 b=hAH0s5mOYe4LfD1kP/gE0qNcKtYVSb/cur4hclY5yV4XpdJxsoqoMhuKVl2pdsnZ/sPR6Yw9Dqs5X2UjT44KDRuoF4vSw5huZ6/73iSIHvR578zH2GoL74hrV0js8WQqSSpe/RnrCdA6R2J+bXExmGCuAC47VCVefVo1Z/IPmIwYo4trLenHw+RSk8juee3N4jmo/EkS2koqOJxQsiADznWn8TTmfUQmi4tLyjFE1iPiZwH8NJL5JL3R9QOP0QG7bPbtm+yJNJBgjm/l/YZYdmBFWQxl+CVfjEO3TehoEtM0/SvjVq+6FT1GwIu7Zzk8bh8g6+QSpL/OC9dS9kPPDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghrmxQmHu4lGwBHj0SEARQDjQjbowDd0GzUN9GflQZU=;
 b=ZVT46evjY7nE2ptrwlVj53uJ9r6W1N09LTBugPKtbFC//bDZr+/S61McU0EEEeDg/7ahuvtH7bur2vwdmSUFvSFXl6kHvzmeYLU/gl2TCrkfjehApSuDZJyoAViOVmQnDo58I2LXq2h4pAqHepHoHXXV2R4tGorVttyVLvuHwZc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7143.namprd04.prod.outlook.com (2603:10b6:510:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 08:27:50 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:27:44 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 3/5] t/zbd: Do not use too large block size in test case
 #4
Thread-Topic: [PATCH 3/5] t/zbd: Do not use too large block size in test case
 #4
Thread-Index: AQHXv/jaGU3pjZisa02mRs8sC+K0OKvQmG8A
Date:   Wed, 13 Oct 2021 08:27:43 +0000
Message-ID: <YWaYfrZmqW2YXf9f@x1-carbon>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
 <20211013060903.166543-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20211013060903.166543-4-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b467dded-1327-4ead-7ef4-08d98e235483
x-ms-traffictypediagnostic: PH0PR04MB7143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7143088767DE57CA24837BDFF2B79@PH0PR04MB7143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GbbAhUYm2to+UHastMSs1WXHvTREWIik2mB0zrsRKy0RQzh6G74x4z/mtXRu1wo3Ep/0ffnfcbqhGqzC/prx5Zqs3EDQGjN1MxnFkud+5yz6arHPm3MKaBUKkkqyAaAGugJ4oi1hHg9nJC/RVpqTYD9y10ErXxEUEL0VCFQh7pFitarYI7AhlYxBEJlj+3hAZ+m0ncmLHsq82OGiB3Mt/hHI1fN2zJ6ExC2PrjXLDqEUJ9HEc0ePliLILX7HhhYilvAPPjisifF7Gr/P/pY5O6uX+M6W4wBbpmr/6QpHyPhYHtpgUtxGyGUhF2mXsYIYI25JibBQjabtifwJ7lcxCGTSkn3B0i5OMrYftnX4CXO6qgGTR6d5W7fN3ibMHzqcLF2e4G2ZpuGrZAdC3qXYc/2EPcOHm4/wwW9eq9oHy/B/0XnJ5xNzpzQRybJehsEvgb43hq06jBqH44Xk4oTPvp8jXiGrXxz/JA4vjOjn/FZAUKZTJ/nXUZXXtW9XEUDHme90dv7Hzh4G24C0rn24lWK9yhuA7Dg3AJx3L8MZRkqm8LKKOFAxx0vah1Ab17FzDiTIh4hB6ZqZEO8vZPIINYIrc+iiVv4OqSWXlqnHVJgGW1r5EENxJxEKcaMP5JBNXb8k5VXEtTVv3ttHN28k8lPPn/DCDWtaMx6iWGNi1KPDYZk9ghYOYRvG+W57oaFDikcQMXy4A5R4sZKb3M8jtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66556008)(71200400001)(66476007)(66946007)(38070700005)(91956017)(64756008)(76116006)(508600001)(6512007)(9686003)(54906003)(82960400001)(66446008)(316002)(26005)(8676002)(5660300002)(6506007)(83380400001)(8936002)(6486002)(186003)(33716001)(38100700002)(86362001)(4326008)(4744005)(6862004)(2906002)(122000001)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+HskkrWvyMJFAXaUIHhpN16v+9KO4S6RvhkBuwj6NXrxrA4B6ZPE5cRhexvd?=
 =?us-ascii?Q?eCXghpeONvWuswcAI9YzL2TVnu4f0fu6nf3I+nYGNYLtztiaR1O/mVmhD9E5?=
 =?us-ascii?Q?6B3JiUSLLKDy484N+VYseD/53iBc+0ew6QRrRgr39ilybjK0uqPakZ75+Egr?=
 =?us-ascii?Q?mZVT9/11HvqXR5r8TurvW0OyYsQ/WxUJkPlfeqlL6aIMGaIJrmzo9DSFi5qm?=
 =?us-ascii?Q?94QMIkSRQgLSgEC3xNPccKYL2uGMzBeLNmfUK4ZXd+uHll25Z11TJMKrN1tg?=
 =?us-ascii?Q?jH5/tk5IrH2Ucf4q0bRHgrl3+5V8U8Rd0qlmsWa2+wTsN2idwXDhvvjDKCQp?=
 =?us-ascii?Q?9kYgLLYzu6k+wBGv9WD1wPc+bAHbK0q+J+VlwpwHUA9Mmco/J/DX2yqNi3CU?=
 =?us-ascii?Q?BItmFELzOEdid2O2dLGvcL0v24+Iw0wGjACeYPqUYp7+1D2iFoSz8FN8o3Zi?=
 =?us-ascii?Q?LixbUVDk23Zob/WrzSauHvtj8WXq1UH1B2G+XtfaIHHTyfxnWBfuVqqUlkLn?=
 =?us-ascii?Q?sT56SsRzgZ0I849NmYswSd/fzUKOQGg+eiRu84Upr7ak7wDhJ3165wH+hIdG?=
 =?us-ascii?Q?doN09MuI7/wSX4c0x/fV495VhL4TSZG5aQtspdPkXpXHyXRwShyHynVDqI6h?=
 =?us-ascii?Q?zeFvRF5urGWt7oQaqklJxGE0WOH8QiPd9xWPeQUAeaXZSsIu3KA2bq6VnYec?=
 =?us-ascii?Q?42DSs+F2q+srRzVBZ8fcFMtO9FQPJsvM4apHc+lXBgXYuoIFG5PuUhFQ3XJ3?=
 =?us-ascii?Q?BrsI+f75r6BetwdX31cqpjQ+efHQLsluVgf/Iv8hqjnWQLssDsMmK4lq3ayK?=
 =?us-ascii?Q?Gbz6yOIAmDj6af8KfVQkJx0Dw78Dcy8cY1G2G5QisfIH2RagBtWeaEidWAoQ?=
 =?us-ascii?Q?PY08FpZPsnd+5lotfx+/pyZDnaIW2iKeyqEvVapCfVru+Di6jeqUVFMgRCpn?=
 =?us-ascii?Q?HwHTs8GWaXFE2lNt1pDBfA+kITV8qoG0d/EFVyDKABMAlTop1Mm6eYp95sAl?=
 =?us-ascii?Q?3A40lr0w5A6cagz39yZqtMSKkPdx9Dr8BgOA/fdDVHdyfkG+a8w6bEYPHYjT?=
 =?us-ascii?Q?8zSgppeDbTnmNIAEpm+CR9RFgQphaNrajxytc+AukLxDgGBRd9cuD5z3XRKE?=
 =?us-ascii?Q?SPtdPqTu37XIsx97PVIkpToQb+hYymqB79D03chPCy/tg9Jg68mFX9gDlAvS?=
 =?us-ascii?Q?ZCzo6Em08qNAAnyCK9scFmSllbWfAcKX2tWvmoGuGWKna7arCA6zybe9vhVx?=
 =?us-ascii?Q?8vyDJzQE/ofMYKw1jYHGrhCfBFvtBxyRTl1f9nczox0atZKwzuYxEMZueK/p?=
 =?us-ascii?Q?sAQClM4v3ChdRNk5s2i5a6bHXQdLl+PqvipApH1pKGq0hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DE5283F180621B439B411C264FE2D686@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b467dded-1327-4ead-7ef4-08d98e235483
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:27:43.9413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R1l+TTUiKkVuvtyxCEg6UDTLruNdBPY2aoj3ey92im14bOqji2wN/ucHexqfGVZkqCcZZO9Wc3dR9EzRGnK+Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7143
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Oct 13, 2021 at 03:09:01PM +0900, Shin'ichiro Kawasaki wrote:
> The test case #4 specifies zone size as block size to read a zone. For
> some devices, zone size is very large in GB order, then single pread64
> system call can not complete the request. This makes the test case fail.
>=20
> To avoid the failure, keep the block size adequate. If zone size is too
> large, use logical_block_size * 256 as the block size.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
