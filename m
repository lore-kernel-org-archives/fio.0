Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECA1C433F5
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9662C61077
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhJMI37 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:29:59 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21259 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbhJMI37 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 04:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634113675; x=1665649675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6fROO/nn66ciHU8ZQp3+46Nhkw7LXaMO6nrhZt1Qj/0=;
  b=pf27viNlYCKvtAywQ8Ofd7w3v76UVtAeBDH38EXXBSR7vyyWhszy1e1M
   L19xwzM+qsd78wPPJNqdQGD2/AdjASFiP+sR6cCOt5gZhQyBlQRoX60wN
   XdwXGb8s/fpD/pOGUs4eTQAvpWnvSBoztRDTUQ2zmm9SWaNSeXnLy3Y7F
   KogcTkIKcEBdzqY9iGb/kPa8aLQAptpS0hMvxX3fPwrrDGkJ++GQqZIQh
   qoqrNp6V+PMhEYJAUtfzHBE40CuTrKCRXx6WAfJi0a10wLS4D9Tsmay5m
   oELnUzs5cVwxYqICEs9zFWA7LDDrfwkdIs+IyAlr3GLU63dHzUnoVHRH+
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="187486058"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 16:27:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7X/glVIRiulsqkatRAZhgSoEIyxBN1nKLKn3cgidVbLmjBk6AySQvF8FDF24Fc6FhRcz8ZXpMSrxFY4rkXSk/uNZ5Yyf8meN/Tz2VuA7bkmBvPAUmkE3f+IVDIksd3Q3jRgmnEXnhygKTIBHwjMWdPIPB9Vbj5WFQYTQETtyPLjgA2r8XhwfXAs4idi5BxlLDQqtIAIr9YM6/fKiloRn4Qcj9QDjnrQtC/BLu95R8utInc+63RMnQiI6QFt56c2rbjzGQ4/GGPx8TWr3snHJrCByQGtJrXLQmIIgph7a6nxeyNh69Eq/7rdhwLkACgrzRvBfyK2p1unii9WHQsTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fROO/nn66ciHU8ZQp3+46Nhkw7LXaMO6nrhZt1Qj/0=;
 b=n4aj3j4vQ5CQO7gBuPLbqLLc0JUidBEN7EFk+bVqpZmEPx/LlwHUDAdMbf+/wDRg5uEnXX4xvsIrQiQov2UFOULhfVhGWqv4pHKXaY3uLcIbGjNH+S8nxr7BCpRPCzQaSq9JTAwsmbD/JAMmpfD98wdxhBxHS7VEoOGRN482JilI1KM/8NJNjUO9uco5KgKIvx0FLOfqhSuLeCoGgIBUlUvgVBpE/RWK+yqjsrvSZonrS897mwrYRhSOGwoM6YHoFQl++LzL+o3vGXz6y0gDXuydiKPruRQDSNnezBS62RXxBZMmcJW5h7QP+0sPBr9nTOti5/UnPE/8ikrPERSNMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fROO/nn66ciHU8ZQp3+46Nhkw7LXaMO6nrhZt1Qj/0=;
 b=BUBp+LiTYPGgedSIzhzUF3c7STywGliEafJy2NX6PqKsbcAunAfIvcobF+Lefzz1E1m2AHL5bsn7g8KLDp3F+Wt75lCPQwf0QG78FdDTAvUGBFe7eyIZJmDXv9u1n2m/qd6vhAHWTmwug1daKP0VLaHWWelNeL43LeLtRwbIDOc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7143.namprd04.prod.outlook.com (2603:10b6:510:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 08:27:54 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:27:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 4/5] t/zbd: Align block size to zone capacity
Thread-Topic: [PATCH 4/5] t/zbd: Align block size to zone capacity
Thread-Index: AQHXv/jbj6RptWW53k2xmLTZKIfqSKvQmHyA
Date:   Wed, 13 Oct 2021 08:27:54 +0000
Message-ID: <YWaYiU+KfB9OwpZb@x1-carbon>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
 <20211013060903.166543-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20211013060903.166543-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1dd0641-f7dc-4bd3-04ec-08d98e235ae4
x-ms-traffictypediagnostic: PH0PR04MB7143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7143CD2CF4D0D1D54931A9BFF2B79@PH0PR04MB7143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xpfKz+fdpDyFr36AkIuzdH53atAs2Cx5WIH1Vo0AjqWaKtnTBU42n+3xDSDC7vqZW9vBPqz3qBRdTd/35zg6b5ARMI7r5w/a93gKapmAEF/7iJIh/tCVzyhIMPchcUwzAgQ1Gb97AlVQTxtKfxyi2lxQH4J4dfeXaT+kEXiM9Uij9WuTJXNj/z3BW4s++M7diK/tBxOyJbIMEXRvwyeWnlgyGeis9Yageucplfa6LlFcJCSf5jGOuq3jygownOZsbQGLCRZaeWzRN7evPvNXWVcTkRYjA85B0+2DhbAL5ieSrXGCMwrFkW1lPrN6isTzjPMEY9taQEsXhxYllQIyqpB3AOa1+t1P3IRq226jRbDcdRxJ5Wd1lBFdMiqhj9ZKTnK1FAn+yCZenHZsdOCW2RU5BALJLyZoCx86VbXZnmsmU2oPR2i0xkxEiIvh0GLeQuSqSIYOFd3VHaAtZS88qk/ECPssZiAnScXS0tHVyZqaTm7QnTg9BKrNOy9xXlngwQd1Cb1m/ITxwL6KYOI4ryXOUhFET1N9hYuFxD+CEL0Qp8yywJ9KEG1lv00i4QmpXmQTEV/LvrhYcif3FicOUvH0nvsfcZrnCGyGWgR+guFkKUrUrNOm/Vwejxi9QeckNIceJNFRQIaoUC/LUW6XZTToAL4TviNpr+irAm3OmZFvrT6w0h6tm/8eAMop80luD3XYXLSNDVLhbYDJ3BkIrgmuQncLAuM6Ab1cxEsFy7M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66556008)(71200400001)(66476007)(66946007)(38070700005)(91956017)(64756008)(76116006)(508600001)(6512007)(9686003)(54906003)(82960400001)(66446008)(316002)(26005)(8676002)(5660300002)(6506007)(83380400001)(8936002)(6486002)(186003)(33716001)(38100700002)(86362001)(4326008)(4744005)(6862004)(2906002)(122000001)(6636002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SrIM6nMkAi4l6LOskCuTXJbDImTZ1/0GgZvaxZLaJeuDDS85XUoWn4vwldyQ?=
 =?us-ascii?Q?TE8zBoN2L5s5xXBt6p9ddxRVEVgjYJAVoRtcciy2sxh259Y1yGWZxwaNWHp6?=
 =?us-ascii?Q?/P98f6vtXec5IrpnNOD5RON1o+49K+XSPVvW6GOO6IBYGAB1QZJQW+9Qp+6V?=
 =?us-ascii?Q?lGSxNyI/hzgMPjZPFkftoTCclmn+0WTtOicYwYbnUu2B1lg3kTK5gpQ36hb3?=
 =?us-ascii?Q?jo1akINcdVHf2TtGg/KiUXEBnucby53Wg3J7y+LN8agbCQ4o0YUiNZuXRpxR?=
 =?us-ascii?Q?05fIudVqdQEeeVmHkrJFvSN7Lj/3OQxXurKXcJ4PAX7AC0n3GkR+vkTelPXw?=
 =?us-ascii?Q?K/KRlvFsxh0UW2oSaFl31hdnIj69OvQacd6AVxbdLKwt5voYmpJ2Cr/CWKQp?=
 =?us-ascii?Q?D6l0YMUvuJTvb02Hd8S4gPl9cpl0fJMdPAFlbvNiKrf11DXot4Ji3g9J8eVs?=
 =?us-ascii?Q?zQ8NzV/f7xhbaevv8qMJne1XgJLzA4NWy1gXKaZh6rhJpw1OW2+fVZRytlv6?=
 =?us-ascii?Q?C6WAzAK2c2+rnSWtgLowrChAqNok2x0S5bKBs+XbqtfKkyhz5Cd8308AB1Iy?=
 =?us-ascii?Q?hQwt8nPaA0ORdESZI9Cv5S3/2N0nBkU730uy13Ixh/HNJPYJbBWNMNcmtCqu?=
 =?us-ascii?Q?RNVjWt38Iumm8b91idZX96Z4USIcc9DoSn3+GeJ306dm8y23gMrIzW299gPw?=
 =?us-ascii?Q?opUz3+wFMOvBnBRfkBB1TVTbXgIFLgAobx4SgojTx0OG7Zrp0t3D2TiGpD4D?=
 =?us-ascii?Q?FafuK0TBys1s5+/cyNAFizzjD3Do+ehjXv2v7bFurR/DzNi5kKDHaFgnytbD?=
 =?us-ascii?Q?xkAgh/EGJkD4kLM7XDf6T30JbiZz/QT67ZN6ajq8KG2HwKg/kTohqc5y1+nh?=
 =?us-ascii?Q?yGk7Oy4H+P7Jm0MAPPTX0J90tfvFmYlcHCuvO8DoffxOqhZLB2jXkmSJzucR?=
 =?us-ascii?Q?hOUIhInyJamTkNTYoanwbWax9lAwik0nP71F+N+xU/RzTY9oFB/J7dYaeKjJ?=
 =?us-ascii?Q?LE/6N1gugdyb+fLJIIeWsIwA82KDiXMS+BrmYSXjdEM92UWQL8getGUJJHSu?=
 =?us-ascii?Q?zZZ7bYIXNSJX12EyuEKV4uVCYo+kKzxRMX13+0oAj+sccL2r6gF5sPw5FCn6?=
 =?us-ascii?Q?aWQe+RN9iQjbOBpJTpEC/trQ+tgfVeydx9w02Fh6bWA86eQb1MVBOpLKaS78?=
 =?us-ascii?Q?CEQA1r9UVZHOdOMiSS3cSEU+XhWHgmzJKBrF7FjiDmYRXc/vzlf9B6lsYRcs?=
 =?us-ascii?Q?ULiToOZxKE7jc2gBMyDD04RvRFgT4qasoXJKCdqXcak+/ordoIw9+lJ5bRF4?=
 =?us-ascii?Q?DZQSIZAgJUeN74inG6/SYh+AC+mKalHbintyq+cggGKncQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E5E7407C04FCE4B82A7CDA92B912DD7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1dd0641-f7dc-4bd3-04ec-08d98e235ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:27:54.7726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4CyN4enZMqzNrRv2IEx/n68wGip2I0uyHTnE1ZLy5UjnNzR+KWkRehSbWEYqZGnCKhSfs3/i1vO1rePWMQXGbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7143
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Oct 13, 2021 at 03:09:02PM +0900, Shin'ichiro Kawasaki wrote:
> The test cases #5, #6, #15 and #37 writes data and read it back (or
> write with verify option for read back). When test target zones have
> zone capacity unaligned to the block size, read request can not be made
> to all of the written data, and the test cases fail.
>=20
> To avoid the failures, check zone capacity of zones and get block size
> which can align to the zone capacities. Then use the block size for the
> test cases.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
