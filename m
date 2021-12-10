Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE25C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbhLJMIB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:08:01 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:50241 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbhLJMIA (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137865; x=1670673865;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OtMee2kq0i07lKTxXVTLQ80eQeXTx3MktSTtvHVa1V4=;
  b=pUJADd4eNE7HNcKe4u2QxzM3CwuMEvpjxrMsm9+GUXj4jnqIX7qgTbou
   PFvNY1N2/0qRe6MOkhHsbheyut2WAf6P9QGqtA6m+2XtqWeesDXF3w9Dp
   NTjD/GBgb/xDq/OFONQsTcb0qh5394jWYvfKCClDAtvnHNfnYrF7Jk6lU
   J+4fTGWjpzVAOz/M93icqbmjiKw3HXDekvrDPbL/aC92K5QKnMy57cSzS
   BMuWvNnxzIjc5ndGjlwYT+m1OBL9asSBzVJnLiZOLAzRZKMRcBdt+vEsJ
   W0Jxs3BZPs28K3F43ASeQU8AoKoTglJ2Yh5ryuHx/rtSu4wmaCvU1Uu9O
   w==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="192716872"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:04:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DY3HkxS0WRxlnRiuD3QLvrrSNYYPfo+WEBPMjHL9CacOpX4eo2VW0ZbGxUm2nW4sm36w3bQUcsB8IfVLjXMR8cwmiZdd/ZOS6qV2P8IqriIokMzxChwMvSSFBrVf344dxYpcidHcLLoBlGPiFKlRrWtsjp4viUrRC5oZcx0hpkxdAhJ+gHzLmwVzR4gFG71y+UU4L4rDcKl0DCsqNcjeEtBN3wb5brLTAW+HZNQcvYBRNxBKssRenc908nQB9vWzh/nR34nD4gyVh9DmCWxX51d4jnWpOd0q36DEerwKWFUh7uvR8wTpcaWIU+Loo9M3Td+8+dKnPYTRUb8tGh9ggQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtMee2kq0i07lKTxXVTLQ80eQeXTx3MktSTtvHVa1V4=;
 b=VBgBj+8f+dC0SlP4Mdcb8xlWd6utqrHEiptNrGmEUjTYlzt/5AZb1P6++nG5c2Nth5V+wym6iXAlosr5IQFclQmPA8nkheR00RdN4Oq2Pjdk0w6ubSzuUxczQ2TkyMk6TJ10/u3GnxI5Sen7N4DBSDfhj9VEWFYx8IwgPHGJ9QkF4pjmjbEtIyGTslfzpi4IWDS/i55CcrOtWi0gueMa4oHwHXQctYzqWe7nTgO8gcoDNM/8Wj0ODCCfQMDdAxPtSvDQK407MJJeHjLzeZj2KBRuf+dFmAZCLVysXm/MctLjR6oE69OVJ8plf0LPWHJi+6Sl0uhN91MEb0dV30UzDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtMee2kq0i07lKTxXVTLQ80eQeXTx3MktSTtvHVa1V4=;
 b=Ll6QhFke1MUvOfIeD3YNIFPHMl8QiEgjINWglJgYSQpAdkXgWMhPfr+vkuDs44uxJ99UoHLAU+FVJsQkCLL/9+xvsxU85RTsKUDzkEzH7NVhirOz+q/qAIG1KLTP5gHv7/mhMJKyZY3vejpgx2Fm9Odw9AfhX3/3U9HNjdbqYe8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7464.namprd04.prod.outlook.com (2603:10b6:510:15::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 10 Dec
 2021 12:04:22 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:04:22 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/11] fio: Improve documentation of ignore_zone_limits
 option
Thread-Topic: [PATCH 01/11] fio: Improve documentation of ignore_zone_limits
 option
Thread-Index: AQHX7Wvz7/Lx0xp3j0SgzWvyq/adfKwroUgA
Date:   Fri, 10 Dec 2021 12:04:22 +0000
Message-ID: <YbNCRL9Qbl321eeb@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-2-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-2-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38e6331c-7564-44a9-2871-08d9bbd53411
x-ms-traffictypediagnostic: PH0PR04MB7464:EE_
x-microsoft-antispam-prvs: <PH0PR04MB74649E0776828DA2E91A2DB9F2719@PH0PR04MB7464.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3TvJWYluyhkkMqe8TE2r41qyQp2awejlS+VmYkSVqOu3ALTGvQIdwg/S/HykF5ugM206XmPHhznM1h+9AEkudufPhATbXGOca0CYBV7imFRM3qj6sXTh22LyPto+5Sv880vehpsWez0v6kZgBC63OJN7m+yL9C3F9ecUH+j6FNYt2dJPAffAsoB4tFgtz5frTOjjNiH4NFMoIezddBH+vZs3WP4liEqRuqDFznrmwC433NTMGpiISC4Lb5EpmHTOemnpjLSyfS6fqTwenkj2i41wAaMdTAWMq3f/DaeExGvgaf04knGW+5XWR2ufYFSHb2hLG/rH0d6wHW1qXFuzcdWb+wvDSwDv9E6f8gwZ0R1Hiik++FAc0ZDeD3DAfk+BHRkOp1PNKxH8b01Cf9EEefqp/+nc2D7JVsTqHwSI2TAIGfwapdFCPdmLFReL2rCzIN9q2W3Yt2zJbVwaTAsViyecdcCgDHCnuR2hbimJEw4xeeG7SBauTWHEXLRj31PVE32p+CKGKoiF0ppJm0MsXef3VfzJofJH58I0HpdK972Swobo4n84hsZb9nYZTZAepnBXJX4/QPxptO/G9HLqM2ogZ1zzgihpraokSzmRJKkwJPN+41ORcpGZadSsICG1rvtemK+Dt/cLkk47dFyvuvSRT6RXF5cq0ozsNqs/YC+g6zj/UB+ZTx0FEJzQV0klZY0ReCRCi8OKa4Rov5xFDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6486002)(38100700002)(6506007)(83380400001)(82960400001)(316002)(4744005)(508600001)(8936002)(76116006)(66556008)(91956017)(6512007)(64756008)(2906002)(9686003)(66476007)(66946007)(66446008)(122000001)(26005)(38070700005)(8676002)(54906003)(4326008)(33716001)(71200400001)(6862004)(5660300002)(186003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Cbu+ltCJD4mOFj7sDw9IZ6B298XoleLWK/PEgeMH6FAPvQ00UE5IVPx4mBwY?=
 =?us-ascii?Q?/7wtGfnKbShHAE7j13+dgiiK/KrvCoQfpVU7TGLPk3R6mZI+yr2BKaiLmVmL?=
 =?us-ascii?Q?CS3SOx8ej2hViNXhn6PlHGoC+redOU2WeiVCrawpfnjCnz1gpOGV1RNyWnnR?=
 =?us-ascii?Q?odceKAtzlcjAahrGoS3TyDLtTkgvHuBCEb0JjUaD0nz0Nfyxb6TMk07aB/Ny?=
 =?us-ascii?Q?ul5aac+iMegdv3+MWKfIUx4Fpw0WdayEljkk6XN13iwOqiHyBDYcAj/dTF5Q?=
 =?us-ascii?Q?6XkLsWr/EpePvc1e8UUfLhwdmRQeDC8qj0YiBJGXzVDwxvBQhbfrd0MSXui4?=
 =?us-ascii?Q?/AQpTC2quJnWEI3BGo+1MSdzGxDpfG80uBMXEXjAGeeXQOpBmgskEvK2ceya?=
 =?us-ascii?Q?2VYm1YgoSGsrZ/2IuHnfUzSjc2y7hUu+TW03sRfjlmQx9dgDN0xz808pU3fg?=
 =?us-ascii?Q?VDQtJ0ZzRhQwG29B0zlxjYFVB2Hv54vf54W2G+5isP7PKiJaxgf6BI89X/2L?=
 =?us-ascii?Q?z/BkNPaltfwjnPCywyk1FUlUkUze8GGfA5N2dCFD+qlY2+5Pai0erfPnOKEE?=
 =?us-ascii?Q?1Ft4UNQiYAUC8VCKceuwGNrbRs15FbN5mwqClLIvOFPcJm9JO2ApRrmMkbfZ?=
 =?us-ascii?Q?d5YQZt/YRxluxUGYBjtQtP41lGi8NU/+ilpTaxV6H4GBftNFsTitfz0Ux6ff?=
 =?us-ascii?Q?/qfLl2cqDoeQWX025kepjCYG/WlBZkptGhgA9rKu6J4sBUfn5i5aJCdKoyNl?=
 =?us-ascii?Q?5KMX67cL2a6DMBaF7uN/fG7+3OIhuEjKDMCbfOxCy3S/ceuJxJ6Lody9ooan?=
 =?us-ascii?Q?+3DKMTZJoh+kUuChSVOGUhEjawCY+s4AznSLNEPs+ojXNw76rAaYFZdr5QNY?=
 =?us-ascii?Q?e6hMqvoZNGJ3+t5dtkF2I/Tb/I4N3URg1FQydKW1AnH+PCOPI9tMiB2J01RY?=
 =?us-ascii?Q?mL9r7NWCJ3+7iLTR4p5xnFvVUO/QBUUaQNp3UOaLLlzbGmt1TanOUy7bRVJu?=
 =?us-ascii?Q?PEWN1tqEUKaKxQbKqXdu3k1xksRQc3SWvNPcR32Cops2W/tH9m3EsNWBWR+6?=
 =?us-ascii?Q?jKzuHlASSJPqOKOMi1tHZMOgnDQkZo+Tjy2IcOUe6ihGBh/qOpTnBkmMxttB?=
 =?us-ascii?Q?FRmjsAUaNSh9TZgATTZqakdGxRMklNSzpKNu2oaeILCh5b6attYQAjrXMLnF?=
 =?us-ascii?Q?a31HF0he+pkxhiKc+7vkrkemIPG7L0Axw1p0wHQzfYUJfhF3DNi3ip5eLKUo?=
 =?us-ascii?Q?CRZ9UwVqc6xrXpCpkBryOm+xt2l9kCs2XWsHxWKkCoPJ9SieW5LFz3yelBrf?=
 =?us-ascii?Q?nifIeixtzGDdyfm/dD7R3z2tuK0Iojb+Z5Dc7G8vmdQRSgBmWwUMMirGCLRb?=
 =?us-ascii?Q?p00VktAteUvoO4aVHqSfAtYufV956ZtSOIHII9UMTjuUTArp8RyqT62fIW/s?=
 =?us-ascii?Q?R4j11Ksiich53Zie2LjTBocNVzLqg/1ixSOOmkIb2wnZkVqAFvrwcYHR63N6?=
 =?us-ascii?Q?PwR3bV2yrjq03/I33IWXXJNhuqYXglHmeufXEXYC//pymBq09SEDgLN4aIGA?=
 =?us-ascii?Q?PZgAwAyr5cuPFI9JEKkIpYsWPoGFLsi0v0wxr11KiN/8WkCusfC8WEqDcDTm?=
 =?us-ascii?Q?GfkiBu/rzrNQmgxx24COPGI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB849E02C349A643B2C71BE087EE6EE1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e6331c-7564-44a9-2871-08d9bbd53411
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:04:22.4299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0WbpVtPpagUKw7hrVc7rfIkA+PS//PD081ZRiEnrcHqReg4El3HjPHACkq+lyE2hypbfER6QbNxBBkouRBOSAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7464
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:31AM +0900, Damien Le Moal wrote:
> In the manual pages, change the description of the option
> ignore_zone_limits to its action when set, instead of the confusing text
> describing what happens when it is not set. Also add the description
> of this option in the HOWTO file as it is missing.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
