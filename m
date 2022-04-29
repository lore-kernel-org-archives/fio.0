Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA07C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 07:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245158AbiD2Ht4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355285AbiD2Htx (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 03:49:53 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0CB7175
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 00:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651218387; x=1682754387;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YiwAdq8EuUoW1oBhnfTqpRbwl0zP1hMluyr+9v62iWY=;
  b=FCqwW6X2Q4/d+BgAY1tSR2KD90j0opm7qxTnMMLublK1BNEBTeKVfedD
   jQthrSHM/gepVTtliAK4J3DnzHXzonzU3xQL3y5Gvgykids58XUK7Qb8C
   Dq+2MfdP/JBCjM9YgryUwY5L8CUG1iInFk6h7bsR6VsmBkDMnAgRvqyAH
   LPlXJ05C18sfN1HmTGzv+8vKa9fpukptHBcj2CwI42lzFbtISShTaafN1
   ROfK+ItRyGBukLawQGVB3RcHExux4ymUgzBwCqv24vDd+VsVEcti+PBqo
   8cNx2kV93V7w45Ft1+Kka/1BJUVxqmBkwpV91BUi5NVpcZqTSuIv3Xnf8
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; 
   d="scan'208";a="204013271"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2022 15:46:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfL8YvLWccSP2VWjz6bGHzXxa6TLVdYqMUOOcc1sqYhI7vS+xS2n7UitoYkJKp3dbzOAymOqu0IIVINouShyIp+WCxBneZdzKavJtnqGn1w/fTWaWsY/+2D2CTdb03JFgdlbhLFtr6SbSkQbk26RImeYeyxjXrrEoTE75gE6A5OyyyWog0MsJ9lzIxmL56luwCYNlMC1Zo+6cKnCAc/mBU6pxAsElHrJA55EYavMp5HW7l/WSrM7V9L9UQUdmTaRE5ZlEml7xUpBniM3FgK4h+mQLv66MRkfe/yVKF5lPdIv4mB/EpZB27CYSCyQ+krioUnWWgO3EUmN5+fomIEMiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trAKHO3wCx1DGGVTsH2SGaHy0dkPf5e0b5LmsA11Gh4=;
 b=Hb8n8fByWiBb4yffM5VZKi0nlOQcmBXNQ/3uBsSw0Lx4wz8pVslPwgVSo4+AMFnLAyku7e6rLUe6j0DHJOg2YU/EAaev4elG1LxCeTu077iSwnEXVjgZ6U+EBoIup3T9p2l10L3U6s/jpVL4zks1B2yB7dF7BYUaBqLb3zrCIUcXlaIXviKXUqV8khsHaM5unxsFyL4Ivh8f2Hirsas9YT76PlINBPFQjsJJrTaFPgGSVppQpzOoPX9Z9YHtcimWUaGnAoTaSSRd0u5kiqZanF65KaUis+VN0QWRnAnpMKsQTOLOnucQPEZkH+ApliTSIFsXMGWn387YD/GMtJvrfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trAKHO3wCx1DGGVTsH2SGaHy0dkPf5e0b5LmsA11Gh4=;
 b=zWzir4wehszH4vlrdZpyJdoAN8qfHUlK1Bv1MVTNPHVZ8uqali3j++icFnBolTx/yk8qSN3SyEW3mtpqd0KP4NCTiN/Hwtwgg5tR/8Jtp6M8WpxRVPrMqENttXM5nSg+4VDJMX4mHYVoHSmlNx1M7Lnj98BZWuoh4LiAYfpBiU8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB8388.namprd04.prod.outlook.com (2603:10b6:510:f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 07:46:25 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3cff:7ee8:c1b5:b4e7]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3cff:7ee8:c1b5:b4e7%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 07:46:24 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: Re: [PATCH v3 0/3] Small fio cleanups and fixes
Thread-Topic: [PATCH v3 0/3] Small fio cleanups and fixes
Thread-Index: AQHYW0AqYngcUICLlk+0Edue9HIU0K0Gg/GA
Date:   Fri, 29 Apr 2022 07:46:24 +0000
Message-ID: <YmuXz3e8F1LMXKNt@x1-carbon>
References: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cf7cad0-4b0d-4256-a43b-08da29b45c77
x-ms-traffictypediagnostic: PH0PR04MB8388:EE_
x-microsoft-antispam-prvs: <PH0PR04MB83882F3DF8E3F310BC4F1D61F2FC9@PH0PR04MB8388.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dJhpK6JBVuz4jpIaBgVvktZBLV8ftm8d1bmXORItUXReK5ReA7O3UizX1+w1XibOh9gaBYBE5AwDSyQNdF5d0F7DdwdmESZKWttb2IgspfhSBbySwjl+EF3RbLRG14Th/6josEaNwuFEUe+L2ODeX4HloP8yuGCYlrmPgq3APY3CslTgISlY87LjCC7zhBwW6x1uEs70MUBB4zOEpyb3A6UY+psUPBHyS/6g7/OVbX3ud3cmg7lyxGA5Jry4jQv3/iwDF+EyUOab0ON6V9NoRAoMqutDnLmtcVbF0eHTH+DlVWDE18H6+UX6RZAwoNLn6sQLjQiSTufLN96UZpb68m3EkCcT8x/qNI+edfDtx/pXm5nOBG+LVQI2L/QD/fLVsESFwquEJXgbrRgCPA4sfXS55mKecaSLHIK18hOmTCOdLsIC4zp6SpGwwzb2ahHKctALjDDvyqrt/hVFtazBEf5U0MvWT54WjND+DF+4NwpYNVLCcwui6fu3o877X+6bCk4WrHWSIYmAYI/5knZjVY5keD6u11OsJ7aULigESPo9bvU0a09YC5y/nV2pRRpOWEE5VBG1NnoWNOZgYgq+osJOwSu7CBm0zVoD5xk5E1u3eTLVWeexrvMl03kg7rhek5xbtPC+IfAyP8F/ZfEoyWZvgUrQ0++lH9jCrKDQVEgqAt/i/+hgefbbHBwFEWoIibJiLABCj13y8RaZQG2X7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66946007)(82960400001)(6506007)(76116006)(91956017)(66476007)(66556008)(38100700002)(66446008)(122000001)(8936002)(86362001)(316002)(64756008)(4326008)(5660300002)(8676002)(186003)(71200400001)(38070700005)(33716001)(6512007)(9686003)(83380400001)(26005)(508600001)(54906003)(2906002)(6916009)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gMN9NC41gK2IyWeQYn76s7Z9yzzxw5UzIqqvh+UaRTbXfTgY7yEvy2CSZzkj?=
 =?us-ascii?Q?vP/he4Vs6JkhZ6l0OA8o55qpO+Tjt9rVVThk0ZbNgqELxayhhMU8uBditDgZ?=
 =?us-ascii?Q?7GkK51rTA/J0HJp7zkxfilKq1I6jZ5AHDxbYPRWyJODIubhvolVwhecAl3ox?=
 =?us-ascii?Q?VgZMDUTbQABDX4VUHG+W8bVDyfTR/Cp/ITvtQKHoXKYbxx8az6FIklc+Zicu?=
 =?us-ascii?Q?+gSYdwumYWkpzxOjtmGCNqGeDZRz7gzSJljwXG+ESxEqf8BvhEHFWuEcZLqd?=
 =?us-ascii?Q?zAnpT1epzkunDRLyeD2xLH88JiCI/Fd7Rz1RLFuia2N3luESEaPD4MyOz9W/?=
 =?us-ascii?Q?bLEyYM38UGMCsZaxgrE/jlandb2ucpDkLucHoq6KJnm+vx9OF/Rh2UDlSzi9?=
 =?us-ascii?Q?mY3DquO3KtvOPkYwV0n3IamrY94W6EErPd3cEeryd339+hXhQBOp/5mCaZrc?=
 =?us-ascii?Q?Lk/bEkuicKrgiryQJf4IRV4bL3/xynBKFdXQsHmDoZXZMEjlDCzWY/VxAHAu?=
 =?us-ascii?Q?DNTzd2asqrLeEUnV463RfRn06dz3+SEinU761JMctDD9ZGC1pmTsBXHBKqeQ?=
 =?us-ascii?Q?0LrMVF4kYGBau+UonnXQjJnd6LJ8F00wLFIshH5sss1bz0dYsqNRm2Km2uVN?=
 =?us-ascii?Q?DbDCthJ2EpBMrLo14xjqk8oC959sGnftmYuf41bM6XqbO5UuXUdVC9ouJfhN?=
 =?us-ascii?Q?YBL4Eh1yj3EOzs6cXj4F/yC5yccSCXDE1iR4Yf2nnvuycfF9Mzd1TZRxpa0+?=
 =?us-ascii?Q?34VvhyL53XRga22VkQed7D8ovJ0Xgtq1hZLn2ViyT+fFMaoEF9IsrjBlX/MS?=
 =?us-ascii?Q?iZwVWD8qbMjp09yxcJW79pEjzyEwNl25m0FgcBy14N4g5/XDwSXx5zCZ55w6?=
 =?us-ascii?Q?/dT8MZ+VnbeR4tWqQ6aAeRfl0GjE0eqOme6cKDdEKqyw2U0+wHAtB9nzgKSc?=
 =?us-ascii?Q?xBkH3TPApYn7Mnlqvo4BTaU0oHgAgO2RydjNWfsfyOclQzt8FA6NTiboPuOE?=
 =?us-ascii?Q?7CFe3W4Rn4uy8+2Xnzms/22nzHnnV8XeCYcl2V5UgjqQ49bdoboP8657TYsD?=
 =?us-ascii?Q?OnD/xg7G2bJe7Sv4YI6NHxh7c8fzb2SpQ76l+WMFpV782YK/VGLi+7kkugLu?=
 =?us-ascii?Q?zG6ko1ZPpfgZIEC0ak6IPvc99NH9bqxj3IBoisDND1J4t055oejBbYjDpjCO?=
 =?us-ascii?Q?E/efNnLLGRpJ1L5K3IYi6CTk5iHKNjEzTIwSW/jqkJY5svqZ+9YOShUExhHj?=
 =?us-ascii?Q?Es0aT633ac7Utq3z/CLz3GhZ1ohaRLllsGrG/0mwJvj8VtxK8ZUsDF9Gsye8?=
 =?us-ascii?Q?RRTxXQOc4byX2JaZLk6X3r+GcM4uN/44o6cXYq2LKtNCJTtO7iPfHreuXoGk?=
 =?us-ascii?Q?GcRfutqRZuR9OaMTKS/0S+1VyBjCwXPe/x0aDo2VuM+dq3EiDfa7eeAXjhft?=
 =?us-ascii?Q?ZgOxytCqVy4OvTpaVzBJ480mNL6VM/z4cFi/iADCv1PUKNY/YSCtWzT8IERB?=
 =?us-ascii?Q?TVyzXMoD0wrlZxikZtCkdQamhkN6CWd+JE2JvBKob9wBvOa38+ZJT3zLDqh/?=
 =?us-ascii?Q?6Hr+MdYzHE7UYHKy3qXWZN8Fl9efIz4crwMlkrwiUojoJ4rzzH/TeuJ6VjuW?=
 =?us-ascii?Q?TOnYPTtQm9tSn3EE9pvNyZEDk+UT7elEzsF/Z6swHVHR91ePvw5Hj0RcHbWw?=
 =?us-ascii?Q?WaMZgE6/2iZYZl7UWjiCq2/i9ruETj3pRmrhyWM9RIdFFM73bGfpOoFgake3?=
 =?us-ascii?Q?5cwqNgGVPCrPH+XSUm8ikX/WaGvWuZ8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5BAE07EF5A594E44BE113962819441F5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf7cad0-4b0d-4256-a43b-08da29b45c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 07:46:24.8074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IQ9Iek6n8hSo8UzkYeJSTVIK/3/HiPOwG1FtoOZBR56jIyysHF7oLeRuvOgrmMgU8f2nIhUoGsNJ6s7LLAfu3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8388
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Apr 29, 2022 at 03:39:51AM +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>=20
> Hi Jens,
>=20
> This is the v3 series of small fio cleanups and fixes. I dropped
> the patches about ENOMEM handling this time. I will resend those
> in a different series later because I think we have many places
> to fix them, so I will dedicate more time to it.
>=20
> There are 3 patches in this series:
>=20
> 1. Trivial indentation fix.
> 2. Small optimization for the JSON code.
> 3. Fix `-Wimplicit-fallthrough` warning when compiling with clang-15.
>=20
> Please review, thanks!
>=20
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>=20
> Ammar Faizi (3):
>   backend: Fix indentation
>   json: Change `if (!strlen(str))` to `if (!str[0])`
>   Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`
>=20
>  Makefile  | 6 +++++-
>  backend.c | 2 +-
>  json.c    | 2 +-
>  3 files changed, 7 insertions(+), 3 deletions(-)
>=20
>=20
> base-commit: 5f2d43188c2d65674aaba6280e2a87107e5d7099
> --=20
> Ammar Faizi
>=20

For the series:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
