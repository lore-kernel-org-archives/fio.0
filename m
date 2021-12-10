Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B694BC433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbhLJMJm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:09:42 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:4265 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240833AbhLJMJl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:09:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137966; x=1670673966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VwCZ7XiXmUTlaTn9JcX2y5M7ZxP0vdqUxEMcmHQGLlg=;
  b=cbZwpO2sbbrS7Ex0eNskfTCyb6yH6BdAPx4tvCjRoYiOmPktAHuL75tg
   5kCKg0iqIBEGoPY4JKrzL86GjFlGNzvmub71hJ86iQV1jTafrhDpLFTed
   xaPOKQicsyyd296INcJ3ue0aEg9gpUWz5bVIzGBkk3/zu6zdjzeGYkeRF
   +G5EFR4Uod3e4tDsq5jW3Ey4im67QmM6ekfoo1SOuiw6ViSloWCfpjfi6
   FKb45kImZ9nnII5uowT/Gcy8jyCjbxgjKAB/mj6NZK2Qr5oKpGCnxRz7Z
   WS6bqJi0RDMS7tP9kw8iCEEcLOHm/jp2FbVzKbO3pymcdrjJ/LARl9F10
   g==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="299781032"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:06:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3BIjYGXEyXECUD/il8bUQbS3IKU2+6GiXNLcMGMeKXUwS1UxSp0YKQjwDLvl7aGvPyPPsBu6+I1Q+9oHst4fGoRptUfhO3/RtFFGOYaau1VyrmO3FoL6Qxr+66iq/1Qh6PzIEaLSvzRPECOziJ38S+xhhgwtFedoBreFzD48mj4OsW4ykUVOMzrCye8ZXIbuZQ8CyPLAMmWRrUK824nN2t6+8MNxxlcQUsmnn+tAYxCGh5pb85xSlo9bDNovEoqn2uI05gdfGmfrrywaUQxSq3GBj163g716XuoRTLyLwtJ0LwbdxwKpNl/6aFrWW/8r+/+R/2XCj3GoKVVWWt8wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwCZ7XiXmUTlaTn9JcX2y5M7ZxP0vdqUxEMcmHQGLlg=;
 b=hlj29sKr1R6sZFUtmMjVmVE8AWXyerLU8wsw3aigw9FiZ0HppKGmSSrRCjzP7IN+0uekvBLiC/L2SLfRbt91zUkP6r0z5Lyj7DY+e1v4TxNjqO9A9dQc0CvqXl3rsmdr8NTtcHUYs6OUHDX8myrrYp5eUJBUNyd5N9EddqJhmVwRxrLCgP07PSdUMpNxOdwtnl5XSwS+J3zPieFzmiCAYKh1SM3KzP9EF4yaaNsQtgpgZbBIZdaAuV8IT+W8igtWh4EizI+o1O3wPq6sZygqTXUt94lMR/c8JEyp0F3Yg18KyN8t984x1NdEkxZl/McVVIWQOFRRORiGD8OC8nEn6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwCZ7XiXmUTlaTn9JcX2y5M7ZxP0vdqUxEMcmHQGLlg=;
 b=tR3OywaEAZnvec+DAkr7gxCwTbLt4mLBFiYC3JV1GqOqhS7vyMvjG2EKV3v5FH2Xd+fEc8DfVD9uTcXyCZMuU2kMc/3dR28nbubTH/n+bGVyGIupk4Jtbmlk+wqLG3lPRMIb+8uoH6ZlVHwYnHCEb/r1b9ovMaTacmfilh9KZis=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7655.namprd04.prod.outlook.com (2603:10b6:510:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 10 Dec
 2021 12:06:05 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:06:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 07/11] zbd: simplify zbd_close_zone()
Thread-Topic: [PATCH 07/11] zbd: simplify zbd_close_zone()
Thread-Index: AQHX7Wv7rKO66wVDUkG0fXA/DyZjoqwrocQA
Date:   Fri, 10 Dec 2021 12:06:05 +0000
Message-ID: <YbNCrOcNpacEkcyO@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-8-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-8-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93c7867d-f24f-4a8f-820c-08d9bbd57162
x-ms-traffictypediagnostic: PH0PR04MB7655:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7655F37FD4D44738745326D4F2719@PH0PR04MB7655.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qNOiGwTybjWydAsz/pyNLyPwXoXPhua0pxahjE/l0li8InIOgDQJ0wfKX9OpAvL1Y+cUOJ7/OLWhZQv1bwh+79nmiyrAlBBKKbeaZMJzkVaWdGVclW0FzWt/rEs57MlxxbzOFNSKZQEuNn2hqTpl2xwU8S0y1FsIMb4uLkFueJ5EIvgUu0SDGKWu0/0BNsRzeu7kOldTO+GOLJvNuvSTEJXTEsik4BuSpPlEo15ncQzLsSOV5ToGe80APazXovzZ3YqzabYrxhw5wCuDLVJ1eQzFm8q9ug48fnWcLQ37JD8wcHLthAId9CIhGiubD4DzA4FFhXKGXIuJ41gDQVj68tqjwVRDdu166BvntG46dvSe+8cWZLaFN+OtosaaIfOE5CaLKFKkt+dWGK8vn/H8U0O7yqRweO3gxK4PX4RvdjSny3WBBUN2m5QUXZBMm32vKNfoPhxuTy39hNyTva4lQlYvVOQdp3SkEvisdgAwAyvwEAo4hbYO1TpdGQ3621Q5aoA/6+iS12UGY+K4WKltoe9wgn2zGf/s30PJg6RQRSijqXlmlNP+Gru386MbfYuB++pVzg5q9bjkE9acuIutoKYdMEXi33iOafItJpy+hHlSiqYG5+ybnwI5LCTPuBJMNxxBIQY61/e/hgfmMfVT39LnPrGvm1cp8z3Bya4yYZNWznapQulEPkw18DtTqYbDC+jpXpePNY6BRgAcakya0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(2906002)(186003)(4326008)(8936002)(71200400001)(91956017)(76116006)(66946007)(6486002)(6512007)(54906003)(6862004)(9686003)(38070700005)(82960400001)(66446008)(8676002)(38100700002)(122000001)(4744005)(6506007)(5660300002)(86362001)(26005)(83380400001)(508600001)(33716001)(66556008)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mg7C/hnA9F9GzvhndFrhLznPmkG1pwGPFLh6St10NLUmmg7v0zPfXxb/gLR0?=
 =?us-ascii?Q?eAFelRhhq0JdCHm8R7XeeLspMxqlLHRU7k564uB9fwTmDdy2nOUsLN1RqOOz?=
 =?us-ascii?Q?8OH3wVZ2MbyGVXFsuak1zIxDzvrzqMpjvcN8+1E5h0lU/cYQb+elyjrUT0Tp?=
 =?us-ascii?Q?DWV2dazrYIqFQ16vmOZweTA2YFVuO6LWFLDe4YY8VxOOBCjQyZPsf74l9BoG?=
 =?us-ascii?Q?QkgoW+zv6ldN57/sC8ShcVixKNy2cqKAneHu6/uKr6hp0DZtOBRPwZL81wzy?=
 =?us-ascii?Q?dVWw3SsGtnfL6WeTJtvCi3GXsD1FLKZ760/g6C5h/oyH0dlki2UTL+bd92bf?=
 =?us-ascii?Q?ugYmRqyjicCPik9TbRCmyMZNHo8nBy9eke4fM/6iUJmmXlDbjbMvvXPf+mho?=
 =?us-ascii?Q?IfeBCWNIgjdQ1mgDRNCgz3paUKNQb0a0X79MZmCy548AaGHUvzDheb9f+vtC?=
 =?us-ascii?Q?LxcHYRC+YFdsNNzTUnJRfeW+BKvYs+hSYD+9eoJUserm969mr94MwSAkGI4/?=
 =?us-ascii?Q?XeWDkVG6eP0+iC0rbuw3WmFn08uBEvFyFt7tGp0kVPlVRM7QlrlO2OSG7zuD?=
 =?us-ascii?Q?M4Cm7SGp8MIz9hzX18Jh2etD28ssn/uBP/f2PZSEuQtNd+qk3w/2M5SLR+3Z?=
 =?us-ascii?Q?w5kG5vzdrt09rPWAwXvrq5YkzoxpWtbVvyfb1zcd+GBS+sWbUswK3mvcHi6B?=
 =?us-ascii?Q?tsJeVplO9DZD/BtvX6cN9GbkqCzl5rGY4UHKvnYaMe10kv37GCEYoXADebP5?=
 =?us-ascii?Q?7dLaPE2ekT4M+fNFvhobJeg4XwISaYgnaClZdWICyMwfCY+wKGvMf5Rz9nnq?=
 =?us-ascii?Q?wABOi7s2MLX0j22dafqOfcJwzJD9764n7wernqfeIDYXeYvhYWjrBtZGFC+3?=
 =?us-ascii?Q?Opb+DtEDOI0fsX+NXpc7IjcncljOzNKTvQQBUAbO5nSPxGkZdaeyfAOrFt0a?=
 =?us-ascii?Q?Cx5WErCe2JdCJRpSgyXfBv684qzdu1bnbgs9RHV87U/87wrsGZqkgqfiNHos?=
 =?us-ascii?Q?fdz0njqij5sxJhrQ+yaEqwpVEG+RjKWfsC7b2dLt+e00zwSOep6+sd9lEY+y?=
 =?us-ascii?Q?uneEFXN4J2xYDZDgNLIb2Hf2+jjCZXAS10MDjp27ry2ADJT/fvBmguPNuAnJ?=
 =?us-ascii?Q?cRvpgyWSCb3nUId9OzHXiTEYfMlHPhINGhG6YANQi18RDqI/CaTllZtCroIR?=
 =?us-ascii?Q?mDzeQlByVG6BdfU1Phm15g45x1DP+t01/H/hpWCea8/Qf7Ba08JY6q5gU1gK?=
 =?us-ascii?Q?2SwJm24lmlQ1oWyRreANJuqvCjUqtwqVcpGWauweIUKAdgCFMqd1vDSj2L5v?=
 =?us-ascii?Q?6q/ROHVRhTrbmGmU6FkLDsR4x5htJPWx+fT0dlGn4YCfO7BiNfWnI+b7Nrye?=
 =?us-ascii?Q?0fF2xwRBHZ9reaoItWZa+2GO6j/LboxjlTGe3N+OyZtSabe0ogUAVYfukovk?=
 =?us-ascii?Q?KfbxpPeiJ2ybP142u9sJFxYYbFxYewwtZKSFj/NoVpLoVzGkKCIpxDwtidxb?=
 =?us-ascii?Q?A3dfwT0TUtBCOyceegYq1EIgFRtRwBn0BpJIAsVpZhq+UCus8JbQhN795Xpf?=
 =?us-ascii?Q?yBrZhwP+7SY+XyhtF3ZkRKjccPi242BQbF22XWvnH7HRhrwqRuhts22kEkvF?=
 =?us-ascii?Q?8dOGjdkWWPto/MwqjHstFhg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75CFA7F5BD84404F89413E98EAC88105@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c7867d-f24f-4a8f-820c-08d9bbd57162
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:06:05.2981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pfl/NcLHpf7+kZH29WO26rfqszRqJhkAHFkRfZN8XB9DKWah4eQ382l7WM/8OvI751NtBsJhxkH0CQDCz1G81Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7655
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:37AM +0900, Damien Le Moal wrote:
> Change the interface of zbd_close_zone() to directly use a pointer to a
> zone information structure as all callers already have this information.
> Also do nothing for zones that are not marked as open instead of
> figuring out this fact by searching the array of open zones.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Nice cleanup!

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
