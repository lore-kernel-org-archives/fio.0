Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5225FC433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 08:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhLNIdm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:33:42 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:64119 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhLNIdm (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 03:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639470822; x=1671006822;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=annpgPr6H35fI2wBpTnUjCinQktHBL8pf2IMBgtEO5w=;
  b=O8e3RX0uUhLUMkm6hAIeT/ny/mji8BeDP8r6A//yVOFD2jClonevJR3R
   aKbf6CuUcNLMXv9U6CJ9Iy6g7iKtThiABKBfHdbbxkAj01ZfRGyo1xgR9
   N5UA1H7qDgAJIzHOjGNf9wNJcwI7yBCcZ2zJRLQmWKIU/0S0D0jWUTv+G
   0dBgrIi4rO1t49guC3iBgjO0zK3PZYisQja0DzkOyvmR3sWEph+d06Qfm
   QvhSgMZtCpRVMBeQXcd2CBtCi7vq9rDAYovsKCBKWLFX6lZbn7IMMGxgz
   7fXW13G3r6TP01bvIH6GJ9uwP8Q8PDxfbcW/6P2tZR5xCCg6aHuhTLC+w
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300043809"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 16:33:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebRv6yKVwnNpYM+JH51prKEUn5RwHFaMr4Ax58fKVqpV9uJftvA+AGhoquqFYaqhKT0g7f2cgDQ3I8dyF+MolI+zvNP6yDEVeqxzdbUjDjJtSXJ4WZCOSgfuMOMcVtKS6CjlUdjPLmZDFrBK3duO+/UPWJC4/s7/95YPokAgDyHvC1i/43GV0yrxRmJ2ZkoKxXYTX2jApjOtL7j6/0J3XhJffozEGnxrpT+GEInn5izrgJRC44mUys7aGXRl+/4oPjdxyudAymMzoHS0ryIEU2ETjFbxw27KxdRK5mHRgjRD8wIz98R+y8oScFejzf1XtmeuA2CWLyVtbPNEPgvhow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=annpgPr6H35fI2wBpTnUjCinQktHBL8pf2IMBgtEO5w=;
 b=GhpwvrLZc7uOCesN/zpRpN4f1xstuReLaFJKZdejVfaLeCL6TCvcwpeGVYUoz7ezTnnr/fskXShWE/clXVBr8DEKt04bPS3+kwNjnSdX0Yr8jrtZhooXHJ/bSQCzQkjNK0VZXWKeeQ6B8xHNYj03fa6AQGLmyX+rKszChiqD2h/Pmorcukdma514Un/VADU4DnN36loY+kyuMxZdUGbveQSTE5JKjC+AXa6BivBy0C32H2wZ4oVkyAA4SH/CIJGUO//pMefSVTh2rqleF8jXPqcjFTR6Wl2ZEhp7I+Swces6aF0dXJmcpXhALWQ001x5YNVO5xzZCaIsxj+4SkphEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=annpgPr6H35fI2wBpTnUjCinQktHBL8pf2IMBgtEO5w=;
 b=vZDvqnWiECW08AsbptLI5uPETkcrI0XF8vVIyqnsvjuZz+Ml5xzyFkY5Ral/J5Mw2XCKk4O1mggEhAg+BmLdqBuGkEUs246r4zrxZBEakwQX65wmdfsQ1G3RWsRS238XntHph5BjzIYyhZ2OLEHMNjm9X9jl+Rv43Ov8WCOEBT0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7527.namprd04.prod.outlook.com (2603:10b6:510:4c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:33:40 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:33:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 05/12] zbd: introduce zbd_zone_align_file_sizes()
 helper
Thread-Topic: [PATCH v2 05/12] zbd: introduce zbd_zone_align_file_sizes()
 helper
Thread-Index: AQHX8IlUYqzuJ9RTuEieCqLAlgrTcKwxqYOA
Date:   Tue, 14 Dec 2021 08:33:40 +0000
Message-ID: <YbhW46wg2hquOmK2@x1-carbon>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
 <20211214012413.464798-6-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211214012413.464798-6-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8b474e3-1f09-4b92-101d-08d9bedc6ea8
x-ms-traffictypediagnostic: PH0PR04MB7527:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7527EB27304D6B372CEFBA02F2759@PH0PR04MB7527.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bgNlIm7DucZnclyLqsQkfpXkcjkZm2/KOHkC9QXIXCfrgmd42SFPGotHaJhUEBgq24slUQrCZRhGtxnAxLA6VT83hQgj2DXoDLuRCwrOAKNTSIIGCsWw9DCYqnPRVWVy3fXDcmgY/CLhh5ymOwz8gvZHUe1KlXN0qskaUcZbt3iBZVG/krsW1zdbFHgJzutBqDct6jckfR3VbwLEGfMGuedtbe5G5s1OzeyrcF2MowwmGi+5UfCeJTXtxLj+Br8c8Mj9DYybj+wNhMxd+GTMJvmGIbLkhlXwmtx9tcEusiPwzNp9lDR8YOQL5+j4ngVYJoacKOSCWTzqMGefsd7JAu/erpv/Jz+dsHKLSOuQa8hEw76XJjVbkS7gBtNUZb1+OarWKRLJvRM1h0kl0RtPsYk0N6nES+yyhX69IpHH0M6B7TPTDvchFzpbeCg3FNzcmYPxa0KWvKqYvP2L55zmI4fzmH2jo7T1pzSPlfTWgCWxpWM95VH+cMwx9XYDAbfECiQtFqap1pqSM28V52qQ7Cd74+udavFllF89rty8Dp0Uz+iWXMTyampwPHpvoSXDgQAtYv+CZCL4aSVNzjN82QngWFOEKJpcEdUFbTPhS0E13yg7udHnL/sAyqZmLS1SYNnkvxRAi2wdShhjxL6D9jCT+dRDmlTYdLyUi1M/1ka8tjUdZK8qXu7Zc5ryqZHWg5GSPf1g3r9ObzIbMlurMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8936002)(4744005)(2906002)(6486002)(6506007)(83380400001)(122000001)(64756008)(82960400001)(8676002)(38100700002)(66556008)(66446008)(71200400001)(508600001)(9686003)(54906003)(6512007)(76116006)(91956017)(33716001)(26005)(6862004)(66476007)(86362001)(66946007)(38070700005)(186003)(316002)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AobO4S7oqdHZ8Q9r9zYoqzRXIpQkfPT0xJxTOMGQ0kCrBr+SXyo+vNBDlh/C?=
 =?us-ascii?Q?eWIJ44EOLXQJ21nDP/qvc7ljZfTIQLJQ/BeWELHyEwacoEu6KA3/P4ySvioV?=
 =?us-ascii?Q?iodYXL8zxVuBcBHKdy6X27bompvtyCL+I4Na7xWFHxxBqOKh0g22islcG7Dy?=
 =?us-ascii?Q?Yd2ey6hU///pdqfVbrJFHiWQOeto7YPmcO99QxZL+f/Zksd1HIUxduSco1OD?=
 =?us-ascii?Q?73v5uPbkQpJYhhIZ093JJjf1YiiRyW7hClqXKD1y21uUA6FpuzUk8Q8xUoWk?=
 =?us-ascii?Q?NUScWQhIfdc+7Tta3KO0FLncEgikZRH/3OPBpQ2YrJOyvo6q0Pz4W8gNHMfX?=
 =?us-ascii?Q?mqFJRQP/u1/YyBdUMX+g2mDPyesBYvpikO7NT71Uqx+2441lQwzq323KgLVX?=
 =?us-ascii?Q?I2Q61suHYffXENh35xUG7xqcDsughZiK01V1I1rQ1ndKPy3UimLNcatKCApw?=
 =?us-ascii?Q?kLC7kZjpEQnnXHBK32axye++2y9NztPTlIPfWSt+vwglJFDYXDiQc9RIHWQQ?=
 =?us-ascii?Q?9YolAoD8aef9HQPeDFBW2KTNCd3eL0eIKdHXNoC2PjWnQ3ctQXGCB4G8fFC5?=
 =?us-ascii?Q?KyUKo7VQP8gIFLaQQ/ZTvgb2N8ewYL878dL4i9hyiqP21RlJ/5WJWRZ8TL6l?=
 =?us-ascii?Q?J7iG4smDY5+rXaoLJitPAFLkPIprPEAWg5dFlNX9JA3EdwocOpuzBCArTGdl?=
 =?us-ascii?Q?6zno5+HwyHzpAidfB0XAMR9v0OfJf9kz/aN8/dH/oGeGe46n4aB/TB+4+nr9?=
 =?us-ascii?Q?qgMrY4lmgKlZ7xxBq5rMMEC290ZCaZCFyTeGG4kRxgjBA7eTN6gRY1hFPfKO?=
 =?us-ascii?Q?8KmNqM3sa7SS9d9nrbhQEWWnaoGBHST71vvIrzXBq0qDRuauXkAOc9Z6BY2u?=
 =?us-ascii?Q?DWYURGcyL4YTMLvn9i1VJPBmjULBRFRku6Vma7VstH2DzCI+tY2p+QlG34WT?=
 =?us-ascii?Q?j6UsD2cHSSUZHgLM0XtJ53NxB2brip2Q1Zf8Fry7Jb8kDmaOR7yImgc+MzY/?=
 =?us-ascii?Q?kLGmKP2IwxLVFpE2S+bAg7wK2mt4PM9oXWZEkJq6yKsY0AGPTqZrirAB42pW?=
 =?us-ascii?Q?vdoKFuDzb+//udOLjjl+Q3oybkmZFsj/XvGPOKdx6tomQxXTVgGh7fEV8rL+?=
 =?us-ascii?Q?G032w1dOximPS1EfpWHpxIf5HxKMWrUU0OZboLhkCFUWhjq26vj6ZV83a0O/?=
 =?us-ascii?Q?Oi77blJmgqp+DkQpxTqoFgwxL8huAxFM4XP7/1KDqAN8N6ohxPZXbvX52K/n?=
 =?us-ascii?Q?vjPJH7jVEIKXTpH/CBr30lVn+xaqGTVrIsKZy15BYLTzTgwGqym+L4jxDFGk?=
 =?us-ascii?Q?AntEGypD5ugrK75PQXfCM5axX+t0YP2rLF30IVKnYgORlbXCxKaFiA+XXf+D?=
 =?us-ascii?Q?PPAenrdX+lo9AiJWlmhA5xVLgw4UAmMU1TktrzDJPrPZ1SFZfadfBzguoNZ1?=
 =?us-ascii?Q?Q502udYU9vZMfSEBupIFVJpElHNcH+Y8WlnCIw9wAJ/SdbX6KjS40eGFqQsC?=
 =?us-ascii?Q?P5ugHV8qi7srkZZewpHKJOG+FDEgJpM8Eh8CDhK1CrbcsCs1S8NCx1LU1s98?=
 =?us-ascii?Q?SqQm2lmUhi/8U7M4IOzqOqPxy5SouA8b/z1UAeDc107Y6JHRdYrEXu78M32E?=
 =?us-ascii?Q?UY/d++S9Mwv+4sy4dZki4ys=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <07E136252E200E4EA4344A36BCCBEFD2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b474e3-1f09-4b92-101d-08d9bedc6ea8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 08:33:40.7310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: syW6K2vv0Gz51/n+vklf2nW+y/JCn0vKJ/0URv8+n2KnClRzlMD26vefwQS4qDI+2+hXpDq4OALYrobac7lwpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7527
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Dec 14, 2021 at 10:24:06AM +0900, Damien Le Moal wrote:
> Move the code for the innermost loop of the function zbd_verify_sizes()
> to the new helper function zbd_zone_align_file_sizes(). This helper
> avoids large indentation of the code in zbd_verify_sizes() and makes
> the code easier to read.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
