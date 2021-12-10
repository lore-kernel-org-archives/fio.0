Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F48C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhLJMLp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:11:45 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43665 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240885AbhLJMLo (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639138089; x=1670674089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dZHDupDwm/kdQYHcFiFDJE1e6r/1qusyWEKPJqz2skY=;
  b=fEdsTd6zaQX2khZ+goQkzFz8kSeOllwylOhg4qhpf/j3kP4ipERpr71G
   px7hmY2rN2x7j3EXK08j/MJ8OAASVgDslljqLSjFMwTlFcLKMUByZZDne
   sDxNKMz5QasCVqmZpyA2Z8f9wzPtpqna3rg6NJths7eJFdaa3hJxtjVvB
   OefhX5Hyqx/mMRUJUKg512JoYCKHNzJTG78WQGK9bprrv6LugIKhXWf7G
   95RsLgEHjgJmGh7y9rQeYzh9LiIUw7hUOL138KwV3ZE424v1G656qn9j9
   Y3KR3ubi301YmSxNszxQ62XdozXJIKlCdOiEg6lKqz0QAdNF4JVR+PJfH
   A==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="291920076"
Received: from mail-mw2nam08lp2170.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:08:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+C5QbTHFXJyZ4GUkEPnNypTMgG9c3iGAVNqCkDVCGE36RFS7tZpv4SSKkDdb1dv1/z9FkOvkQLuuE/15Unv8a/M8Iux7CFR/jrMtVXAYz8koHRSQt16VMVZ1WC7DewGMuF5cH1mLqb4UeIf8tvhXNbvsNfOxQuPsaG7dJuvHFkYqIjU0F3hk9psytbUdT2E8GC1PxSUIpGZuH8mii/obf1ZUbnQmVJNdl+Y33r/0N7T3iq0lO0ZraMf3ACQMBxF0HE7KOq5fA3yvsV15elGRKFeMVDVILSxZQTZ/khiw/+Ja+u+/t9kqKH+yTVM8XGfZ1feD/i020iBEUzUP/eS/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZHDupDwm/kdQYHcFiFDJE1e6r/1qusyWEKPJqz2skY=;
 b=gD4I3bN6LUFLoSkWyBQCnVx0rXkbmjOZ/Z3D6JgtHwKSZwAjT7JWod8VFcS01E226Yrm+LaQ4HHLUnIcAMnv2gaOF2ATat6KhBfIjJ5IlkkmIw3Hpzpw2Bz2xopevP7UKK+4DI8gQPj15JC91mEV13xRjGylTahVGpDbiETo3F9SPB5rdLO+u+scBwztr8zwtUbhTlobdWbOnVMlcLHCI51/3LKkZuU9y2RKz96rJIfP/rUsqsy7jNBm8omZD2XLpuDpq39uWwlFgNC5xBw0WkPD8kTafHtvuyDFF9TJ0BfAnoWFoiGkjdsrzwlbHy7Y3uO9a/ZSnMiAVHDJWDeEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZHDupDwm/kdQYHcFiFDJE1e6r/1qusyWEKPJqz2skY=;
 b=q+cSkGObraqMylK6gW9jQjQKtV4HyFfC/cNa1Bj37H0biy24iGLVXRawcmSrO8QkjtJrvWyYZTGf14LIg8ZB+sbcqtA7CylvZLDBnUUcoKOJ/ZTi2/7RukVITN0NQGu9a2RehqKJnZdtyQp2LaBOAWov9ycxLLPzNLLA7x07B1I=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7302.namprd04.prod.outlook.com (2603:10b6:510:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 10 Dec
 2021 12:08:08 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:08:08 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 10/11] zbd: rename get_zone()
Thread-Topic: [PATCH 10/11] zbd: rename get_zone()
Thread-Index: AQHX7WwBsPXeI6zcHk2ucGGxFbGBF6wrolUA
Date:   Fri, 10 Dec 2021 12:08:08 +0000
Message-ID: <YbNDJlt8CropNmCH@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-11-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-11-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59e259df-1f4a-4dfa-1fba-08d9bbd5bacc
x-ms-traffictypediagnostic: PH0PR04MB7302:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7302FC3517B9892B441F27D2F2719@PH0PR04MB7302.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Yi/ny/+nfcGbrXjjWx37pcvZ4RZDVwPszOK3iyb8HMmzQOpNzsP5Jl8qfX5TqCvchUiQhHc9kZrCm8RdHOSPzrJ9iVdVma+YZedZVXRck+Ej94gl1s7KHZT3Ec1b23CjtwjjgIzaDY/opvui8sVxgza0l4y6oRHQ7dvSHNnG61L9eEwgB4pXVNSg6uKmRskByryjlGM8ZxzXNJhez/oG08aU55/Szjtkhw1h79Y4ehXuhhDta10iyjPjKtP5mPuVPQvBbMYs2ETB2XXlmdjcY0WZznMWylo5liSIPfNIabMzY+3JFsOaCdP13BQYsvb59TOKw4UUSRbOyaMS+1fEqnXkXQvU84X4SSD5WjfqIsFbfvZW56FjOG13D+OHuNyN8l2+/G6+lgv9YpManTJIIQ8ilYm/XAMF3UpWxs9sXGdxUYftopGNR7hmean2Uto4dq1yn0Yujit/0E49ARptwWIMxZKJavwD5tyKBW8X7zrlaJKeRRDpjPxpjTd+EcTv/Fx/fCeEgaY1euQzSc2QFVtYf82rlfv+RdfrRvo7mxXcuuassDAmyLWqs39EK20Nuy2lAJtriS6T3bUnp/H2LxdGRiPwrgQNpWPKB1JHMZS/JTprA83aml9D57XwcTjIEEd/UX+H6A6wfdNg6LuQTgYcvC+NO6CY6fYRulLpNlxoCeA6x7oZ5u0tmkCFD4htbzehRjT/kTe5akTn/Tcbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(2906002)(91956017)(33716001)(8676002)(76116006)(122000001)(6512007)(38100700002)(508600001)(316002)(66946007)(66446008)(66556008)(66476007)(64756008)(54906003)(9686003)(558084003)(82960400001)(186003)(6506007)(71200400001)(4326008)(8936002)(6486002)(6862004)(38070700005)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NuCYlIQIIq7ygACJIgS2E3vTCGPYpDxbGcZ9U9gOP9IArapX8gYPf4eEkwbr?=
 =?us-ascii?Q?YM2+J5a0q8b9+WNz7zeGVj3ui9OyzbOM++pQELERU14mr7N3WQgMndjWpAHr?=
 =?us-ascii?Q?Rk5LGM43pjkPzIWWyMiYDRl0mPh3M9b3ye6TABzTg6aI+XDVCTx5tdjrZdLi?=
 =?us-ascii?Q?OVB2rcpBk8ZFPAx6z+e6w1tW0312LPGfUB3Km+36Ijc+u8+JLc2m2lef8300?=
 =?us-ascii?Q?7J6NjLF1BxKOAJ2j/VkMMCQYhsx/YDpPaP8tQQk29uSVqvw/SwC7icQaiREl?=
 =?us-ascii?Q?nd1/TdZ303iubdXWErhO4PCTNCmKkZbedjUUkM6Pzo5uY+7WJStvuF3Bju3X?=
 =?us-ascii?Q?BVz8w5C5wirDBa4Ws+G9UJwQDGlQ61bnFAgcghQErLvJ+ZRukZopC/KOT7sN?=
 =?us-ascii?Q?rZDTWXoq3dSbp8AL5M/C+JqUsgA/HjoAH2tQhR/QORXrg03ZHijsY/YpU/ke?=
 =?us-ascii?Q?w5Fpc0Eg1f8ahGUDwi3gLlzPidMAp6VI0g6fWUX+J9rECKeFu0qjvMBska85?=
 =?us-ascii?Q?+TF0lEhEreqv9KtMw2Ui7GOJ5CxHXPpCn5d+dixEWvlGHHLY03vi7+t8anJ0?=
 =?us-ascii?Q?Yjht96XK+hoMvFJ+70hQvn2cDWorEOyKgppDZ9m5TqBLFRMhv1GcWVC+eS48?=
 =?us-ascii?Q?9C3Nv/fkLZDpy/J1fN68YgBYyxqVKI34k3KbZspARGL/uZTSgZC7NGMkhbp7?=
 =?us-ascii?Q?n9nreMDxGhM2hp3jdS8ArBNBqp/CGRCb2mrRvLGWVbtIyOXZQaht+v1pvjMe?=
 =?us-ascii?Q?8DaeY1UKiVNDX/qcFcM5z4z2Bn1+LR2XqzkMVOlUTFoNmmp8eYtOeYyGtm+z?=
 =?us-ascii?Q?9U6bRThlRzwqkc4x0aobH6yTV+YZunwlvT62qxi9g2sbw0UiQ/xC0W+ncnWI?=
 =?us-ascii?Q?wj3aiXr5/BsZC2T1Tc9EjyeLaILX4jDXTFaoOEtEseYlRDZDKPQuDHQUalmq?=
 =?us-ascii?Q?Zj04J45QtYra0Q35pHP588AuJ7HzQDgLYobfjKRomZxjmuup3yT5tcl7pc32?=
 =?us-ascii?Q?qKsTDic/9sDxETp7A7axsa+vdjJ2XVWHaUhdr5TBOrvmokH7rRZ8o1CSWqni?=
 =?us-ascii?Q?VPrBKh4qQFjiG/UkATRPilc7DizTXIIaz5iCRDAW9K9rsDmQJB/dlfBGcHHI?=
 =?us-ascii?Q?hR1rQrnmMDY5l49tBO0fairUrvBwULvhHKpkA2E0ypEKkCL8eyXS6+84yLNo?=
 =?us-ascii?Q?KzrI8QoepXgLatgD06JUD58rpBT6ph/uUhjcgQfDuGdxQfRqtk9Fyx/AHokG?=
 =?us-ascii?Q?XiRvoWpuEUjit5wl1t5GWV5S3t76XeXTe5AETpKwQj9Rgg2ZjyDMNJq20fiV?=
 =?us-ascii?Q?TDv41FxngUq+Sa3X3u/us+g2s8G3GW+vhKtfRWkWzgVlabzknuUH6vw/ghOa?=
 =?us-ascii?Q?cGHWKNPJkeHTKr2hlDKm29ZwwwseyBXCGfhAfTGXkTvM3mlAKPayBs1q0nm/?=
 =?us-ascii?Q?7bhJCMdHon7nGcnKuACB3GXzcCU60uZfw8fDGIyYNo8X+dyvUhfkeO46g8RD?=
 =?us-ascii?Q?Qs7at36wkpzxZ/rKyoRjOJr1h96oLdGeIiZSwjZNf8ATghkw7J2xP7XPoaK6?=
 =?us-ascii?Q?61UDv4n57VilBP3x79yGpX4ZiLf6m6BzAxP0yfSd2LpKPtSkN91ogHynB/OM?=
 =?us-ascii?Q?evp4IVJ+pmsK0+6gqkGwxAZUmAOO+LmHTiuivR4hFzQH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01919BCCAD8F5C428F521BC39028FF8B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e259df-1f4a-4dfa-1fba-08d9bbd5bacc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:08:08.4699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AyyhWyyqizO2Zg1Yv8jpSQM+rl5Gdz2x1etQJBvnxdFt1Tzh6Og52bWy+anvnji7/cWVCvCz1lFtAN1h9WLqgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7302
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:40AM +0900, Damien Le Moal wrote:
> Rename get_zone() to zbd_get_zone() to be consistent with the naming
> pattern of most zbd functions.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
