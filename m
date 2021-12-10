Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DFEC433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhLJMI3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:08:29 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54344 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbhLJMI3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137894; x=1670673894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OIvU8W3gpHqpbd7jk3Ih/UXTFfsDB/Bw9E4V5LlyLNg=;
  b=Bhr5ujWnQGrxr19qI4VgZ+LDlLlFYJBcjF2r67Uv+l/7dZVLUlVCcwO6
   MRVyz9dow3EyhG0BHl+O417jNBrZ5SqIxwmDJ0+rRUdahmQ/PXVXCjkm8
   +7H2yDXKT2QkLb4D2n2WKWrHVUgU6kFudKzszAPaIzF5OZdWOBz8Yr+o9
   Ii2YC6BbRraSZBXWB11nv4UZbushsTyqqN8Y8XQUYUnlw66nX2bTKwi3m
   XCMTv0JbE833BxY7x/uAkzt8QpsCfXNIaVg9liYL65gh2nd6sfrhf8d01
   6OQpUKjAQfLfFIWfE70kJXsHLl/fTZ2B77zdm7MpVEM89vqLUTN9MRc0Y
   A==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="188944323"
Received: from mail-sn1anam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:04:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHR0Zb6ohqglyg7I4k7TFDFXjoUZE2GgLgkGQaB8YksqmwTGeblYHEehSN+sDfaybpiLvGF4+UWTGei3zgsN51AGXgPbMEmQgyfxUUKp927p7Gp4OwnzkY/mI0Tv+Fujc42m4aFdL6SHDsBFT+RPjwpK+4nv0yFRyR7B5ErarAfbPUbU2Cgoz8ZE2sjLnkbWjiqwIgDBAN9KOq/uVmtFFDpwNjXw/DClUhP71C4chCuQptVYFeYocNGdzbtjU49P7EZsKfUQDJzUO+Et9kSCBOQdwpboeNNXVT8chq9Ry049SRTa88vnUA5Th6h4OhyZLcC68998fPrlSzG/QOvtkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIvU8W3gpHqpbd7jk3Ih/UXTFfsDB/Bw9E4V5LlyLNg=;
 b=bis5zmOeRE7b+ZPwf9asU/MEPkcSou/FxOQ8tCVKeDpBxWcseFU0wv/GQxHJmiTzsSV0xu7rkK86OHgiNg7KXoiMa+nrjxzIsjmdShlPeSGVBnJvJvEqAtLh9DHB90S3EoCsFBllXvdEFLuNFnMaNrWDx2KoiUx4u3aod2DYEBOw2YpEVwXffjHCyP9/k8UgAH8mB1Ae49Rlzkr0Jhzm4O6Ja0CksiRQ9CjdDm3ZYAdzpWCJ471eer92VNB4Gs1SANrqUSL7NKdW1v/FDL/rjvvoc97OOKEWr62pP3P9uYdhrRkkbjyb2ebhmY4vVJpADudkveHsu8bnBc+ZdQXHsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIvU8W3gpHqpbd7jk3Ih/UXTFfsDB/Bw9E4V5LlyLNg=;
 b=beOcYFBGkemJfrEYIcYY04uxc+KALmr6M76LROWbatg25Fo9lU5Ib1F2/2h9NxIDUz6HM0M9x2iIjOlMzvOp/Y0KEJaC+KjkEX8j9bQrrCNKEnX8K/q2K/4TWAbjlRhYN8ypyJP0S1z+wBcpq0enB7NjL5Is9I2uTlvnP6DfEoU=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 12:04:52 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:04:52 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 03/11] zbd: move and cleanup code
Thread-Topic: [PATCH 03/11] zbd: move and cleanup code
Thread-Index: AQHX7WwBLlZMWXfHlkOatA3nvoPmZawroW2A
Date:   Fri, 10 Dec 2021 12:04:52 +0000
Message-ID: <YbNCYw2Ug+VjfoV9@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-4-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-4-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dad57d6-e631-463e-1f64-08d9bbd5462d
x-ms-traffictypediagnostic: PH0PR04MB7622:EE_
x-microsoft-antispam-prvs: <PH0PR04MB76220060B544175A08A1C353F2719@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yoi7ZPriP8uJHn+agPff/K6zq8do36QspWEqHCWK1eSXzrVWwug3d+jTm8eMj5JeG2gr/KOX/IvKhhQFrk4UScDhiue12COBQQiivxafSJwTdztmqD4MX79Z4pqaDvMXvZXGFyt/1dzAOAS1hW2j0yQuOX6K8rfga3/wsbc2PdCjRAdus5/UhUSA3rB2+1tJTh71+tA+t460kyv7uwo4NIvzzWJyx1Z6hVwht93SMvVT6RdQZHsVGPtTL+fQATNY9Fn+0LPN7x84piOh4mT4t0/eN7Pj/eh9viYaFpDA5fRitkvBNlcY6qV8SxEhDzd4xmrqxayN4z7sYkGQPT+z5d8l5AhuWhyIHYRe7Ei+YwW69CYYgYQzo2lleNwt3aM5BzVBesso7Dkjm/YXk88wX9/SAiGA20jqFa4S69C+1C7AKm/AX321h8WmtF6Q2lGGajg7sIm5rVgyvR4V0Qti2EGjkL5RBitYmlYoeS7V1AraGzjVCvGXsXLcCpeIz1RJEgE/XSr8jS3sWleE5idN39ZhmM7D976b+m3ALlk62nXbDIm7lMC7al8qlpm2FlQgBi55/KvE2nOnfwukENvXjnG7jLgh2dH2ca9KtTngQRvUOjmsGiLIwMD8x5+/fMIRODisr9by27yt5KdBk9ct/O1KUz5aI7E93h/WpUbz6dZajuHwGuf3OrBBk8A9ntC2B1GfGIKEklYi+TwsZbDX1g/4Ua28RPBUGB9cC5pIAWQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(186003)(6862004)(38100700002)(4326008)(38070700005)(122000001)(76116006)(71200400001)(66446008)(82960400001)(86362001)(9686003)(6486002)(8936002)(508600001)(66476007)(8676002)(4744005)(6506007)(33716001)(2906002)(66946007)(66556008)(316002)(5660300002)(6512007)(64756008)(91956017)(54906003)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y3KFCrrVXDIbhAr72KN8pBxHqiRwrh3/cW2LZc6STQOvB0b0TITGj4hPvFyv?=
 =?us-ascii?Q?tts1xz+IWOJ1rU9F+mrci7sBg4YcGbqr3H2ivK8JOhd5duUYGQUsSQOUs6Uq?=
 =?us-ascii?Q?NI4BcXLlvZtZH4txKap7FDRXm+6zbxhELd1aOG5qBTdyRZ9m/VEhqCxxUTpL?=
 =?us-ascii?Q?7p5OeUpcpVYyuOu2jYDZZSFL/A+fhn7uBAUmJuWM/xU2e39tpQBYQ3je+dIT?=
 =?us-ascii?Q?5SKcMYzxufKSE27C4frN89Cy0UvIGBWy59u/aHHhFGR+5CVdndOau5DTWxOt?=
 =?us-ascii?Q?Nxa7+rqIGgr9J1yHzShomrjcf9vOsNkI5uhb3aGcZfo7wuY+LdS2JxQlo9p8?=
 =?us-ascii?Q?HV+zFiaIZaR7nWWI8TFrc1weF6Dsef1gKAuHu/SGauXYnaihXQKP/5nQvee6?=
 =?us-ascii?Q?ngfGIwuqT1+C2PhAGKMJc17x5cau9Kb3AA+PT27zjFBbo1+IL3JbemccYaNa?=
 =?us-ascii?Q?SmNV+Wnt5D42otcQMcXh021eul5bVNBpvxuo6slAyRckJeZe6E9u08NcljcW?=
 =?us-ascii?Q?90N+ZCHVQPRW6ZQ4KyZ2rXjQCQUw1m6Bpos5DfGxciK+gXrfiFglHnbpqQUm?=
 =?us-ascii?Q?2jD5bUThj6uqgp67zBzhMdHUf82CdvqXRiAMF/Q3CNi3nkMNYd5zHAhM/5qH?=
 =?us-ascii?Q?n9BbkaevFD6JK3WN1MNfchcaAZloxbuBsA/06mpnnIs7a4XkSgfz4zSaQ4tz?=
 =?us-ascii?Q?HWqrDoIoURSdyWRlL36Knb8qNrwr+vWg2nNYfig3d98Nhy5o30LAFG1oJO24?=
 =?us-ascii?Q?B9FOxD8kmkocv/ZFhrY4UfJDmbyqiaBBhkDCVl6J62xeOPXZylyc3Iuyiva4?=
 =?us-ascii?Q?PVKo9WkPcP8IgruksC9jCNxq9pxhgN0sJE8Ja3RIk5zOQ5iKMblkGQXXXx81?=
 =?us-ascii?Q?L7feaEXMfKFPMDR4AHjtWsHS794GPUtgQO5DrbxExnXbhZx4F5tq3G8LX+Q5?=
 =?us-ascii?Q?xnKscmDXgapIIUIi0SFFb0sKWb/YK3XzviGrhAcKZJtrVv5n6YYtexY6hHrP?=
 =?us-ascii?Q?pRakdmbrSPWMZLfrrgFbZTpThS2WC1gE/awTG/As6g8fLWfh+Kj3IhJrROvG?=
 =?us-ascii?Q?9xn+nlqscSRN1+j26/ITOptAqpDaRCXXP1167Ktipms7oo7pThBXC6JFDbJY?=
 =?us-ascii?Q?pA6uBU1Sgkj+IMn2j0ndupV2sT2vxTH9DK9pU474V7Ry5FgfLYV1R9EzNrNR?=
 =?us-ascii?Q?1Ytsh3GlqLJCLmuEvI2vE8FzywraCjLQrnA2Url48t18l6WRfQS/e9xtwNIl?=
 =?us-ascii?Q?pULkdPMX4I/NCBkJt1PBZOftaK0qqEU2Fl4bLYayH+MlClGZZLWUQdIUucmr?=
 =?us-ascii?Q?7y6fMmPua8FlJURpqx2pp1z4LvYOWlphQCIHzLHCzojIaPBnke7EcVVAjzlI?=
 =?us-ascii?Q?sxS3H/XZXZ399ZDSkABb8knLpa3uwhVSP7jg4e0EmfUVw4JMUODDXZeunJad?=
 =?us-ascii?Q?BF/aVsp41GVxNADtzNR1VLmqE7kHzv1mAZgvQ4IGzUmc+HiJLV/hhTkE5nv/?=
 =?us-ascii?Q?RCxUrcC4U758V32i7p9BEHnLw5IJuSfwb94tP/FoPcGfvkL1aTO9CvmINW9p?=
 =?us-ascii?Q?glYFJtGT0DJloV5OooyWArkOsKj7R/dAUcgswWuHoJjp4as4f/jwqzW39MaM?=
 =?us-ascii?Q?NFBY1G179QYOtrnUeAc48dg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <370EEF61A789E64E9DDA95C6E079B109@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dad57d6-e631-463e-1f64-08d9bbd5462d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:04:52.7614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ea3hlCprgXTSRNYwYNytziBW1SUq1dE4LYheY04YDBrauOE+tR+JiW1ugoteq1kIBUpyVO6lmut/v1SatraAGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:33AM +0900, Damien Le Moal wrote:
> Move zone manipulation helper functions at the beginning of the zbd.c
> file to avoid forward declarations and to group these functions
> together apart from the IO manipulation functions.
> Also fix function comments.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Would have been much easier to review this if the function comment
changes were in a separate patch.

Regardless:

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
