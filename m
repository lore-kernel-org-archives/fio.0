Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C34C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhLJMIN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:08:13 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48826 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbhLJMIL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:08:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137877; x=1670673877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zx6ABQnexq9iUTXqJjHp75YSXGUXmrg/3jFwgBAEIso=;
  b=O5neSEyKpz32+dIkAfimxtexqRkbULb46VgQ0Y33A1nVy1bbU2dyxAYS
   LzTaYUWhqXjwQDh+2Ymsg+YHfWaiGk738VNVM79CdhAlzlLKVnVFuqWce
   uQWsU9CS8qbujp4wPSrUAnijDbBhfi13Jc4QDbpnVUaBdriE3MPHd1gi3
   gMd+KNKSt8rfoKAF+DBwO3pCizqAWapYX6ZCFbRXoWvqggWx8kcAaQxuv
   iSqAMaYRYeQxHTG35yN+7odt/BoD7kEX6dmuqdwhJfpTASRqvMUl2HnzH
   qbga1LmLTCN8+a3QOZLA6nA7ZWq4bbK8C6+uV0kvcMKEo+ZYNfIfV8pQ4
   w==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="299780962"
Received: from mail-sn1anam02lp2046.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.46])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:04:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPD2mLjNrmNC7ooyf2Q3FytVyVJ2QhVk2+fFOnyKsEnOuxKds6DyAHQ54uZMbVmqYHFdiPCDj/FEv3ssxAauT1MhTqFJtMHpnksuTng+bbZN6R4BEOGDcK92tbyth21x4Vg5cn3MZuVCmadMrBm3jEKejlRyKxt5S8yVb2AwG2MoKag8h2vjop2OQkkxmQtqRXs3dlBzemneZ34vFQdpACMvpzfAeK+qH9+JxqOo3XRW+K8cpVjh4ma5ziw5eAmDOyUis7IrrMevEp9PXWWLuUXFzlicBmtajxaCAOpXSTVbXoIxKkiFd7tTZYB4rVOXeMwIRsuTaP6DxJSop0B+KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zx6ABQnexq9iUTXqJjHp75YSXGUXmrg/3jFwgBAEIso=;
 b=CKCOJOXQXONbRXu4zpBZUHCjTZgRfmW2bup1dCaLuoVEBiKUWVezHGoPjKCKuE8YdLzpBXA3sr0V+xPpV2TfQG89vdaLgdFLAhRoUtxuCek30La4/5Xcz/J8SQM9obX5NxRbz1DIjmr7o9Ngupvwv6x3OfrcKQ9QIV9rj1EE4I/z0DbEFug/YYnpbGhTa4R8MwtrzUqgdBTfCJ7o1ZqCBcsN0F8AS4IVaAUYFECeV+3eMOStodmC9iDDy4Gzt9oyXGvKlsMVyneqZsWt0gtOVdLrgbKAMiEI1+dFcgx3Rl7yzzUBcgvY6otfPrQPw3QGITH/4RPvXIHmXeOgCEUONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zx6ABQnexq9iUTXqJjHp75YSXGUXmrg/3jFwgBAEIso=;
 b=vDJMGdWfVGFSQUlCUyjbDOr7FMKnSGWNIExAKmtdq748kSIeTpW6sKBHl8GFYZlrzOjCTLQFPW1VbrogV6AtLCSaCorGnFq9Y6oAvchfuO/C1/sfP29idxk1qooZTl83kaLCms9fP+3fITrz3gNAJqV/fwli6nPNgS8087SKJfc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 12:04:34 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:04:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 02/11] zbd: define local functions as static
Thread-Topic: [PATCH 02/11] zbd: define local functions as static
Thread-Index: AQHX7Wv7SW5lc1QJS0iV/r3ze12MYawroVYA
Date:   Fri, 10 Dec 2021 12:04:34 +0000
Message-ID: <YbNCUIHA+ItWwZpI@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-3-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-3-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2824f25-fa99-47b3-c363-08d9bbd53b5d
x-ms-traffictypediagnostic: PH0PR04MB7622:EE_
x-microsoft-antispam-prvs: <PH0PR04MB762207B97D9514E6CD46CFF7F2719@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L4dAi+TqhLkTMbX92ME/ZRsKX2v73adUaDfX/2ow0J+ZNnMNwK8f+LTkLae6ssZwvOUo4OegyicLbOawpNK1qsaL9r+59i1dLIzw9hHJKoRNlch/vPboQ8tReV7sBv8OZ8r74CLLYqgV6K2SLR5ZvV+ngPB5W9lNGTIhby/KUuAZX0pKxgF7Q6Z0KDmsm6gOLeCo29TpZjgu2VgJIp7nerC1rVnMgcXd/FO1VUSq01VlOHcmNBxLmLlJesyFTXjiLCteL9C3EzEk4+dlp1tOUmLlIaUAen0LzSrSEClhipjGNoGh4N+tF7ayqvtQgDPYYXtrHd6JFX51y+HvttcKAioouq1twfuGC63fCaIs/0GzlIjv/RmWlQMd5ok/W3Uc2z4lvsl5GwRlpomsalVgSvwRQuFgKocBtDI9CXSSQSjqlMxE3ec8aWA8V46HnMiZeP0kUJdwMYeL0kAExS5ngHYw2YIW/XMt18klouy3GTtvX1NlwlpgZHSXh7EKO/l3ys58m5KG1t6xa2+Y3YJD+xAloXbYzlQ5eSn2PNbZj0lX3n+T68LsqeUYrEDT6rhYo3eao1qYx+vWigEFFMgycCGq3SvgznSqpS/RT+kFyXso2Y3zOT6B8ZmgMdUMf4wSDJshrT7+OL7QF7xX6p/1OXHHpA2ci0QbmYz9wxFglYfGRrmafV8UDjFyFqSc0uWxjbbztZspGe6QEGo+QWM7S1FGXpf/F/AWGAYza2iqo/s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(186003)(6862004)(38100700002)(4326008)(38070700005)(122000001)(76116006)(71200400001)(66446008)(82960400001)(86362001)(9686003)(6486002)(8936002)(508600001)(66476007)(8676002)(4744005)(6506007)(33716001)(2906002)(66946007)(66556008)(316002)(5660300002)(6512007)(64756008)(91956017)(54906003)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N7RaG5Vk7NsDDI/2i3VVf7MAeT7E6k+9y4dLSkKnDdqRnzjUohc1aBQjZLQv?=
 =?us-ascii?Q?GUyTpwF5rbIbdzaIhOfZEttK74RllnKUdZYIrKX7Xw3qV91aTLzGprYsZAny?=
 =?us-ascii?Q?jXUF2VewXXLgwXVEmE8o/uRIsXydD8e5mcCcAHNTC8280iKqWJtoXf/L8owc?=
 =?us-ascii?Q?H7e7XP55r6z3d6FCzjy3qc9iCgNapzfCDa7/r3UyZTriH6gf8bM4RmDSXGV4?=
 =?us-ascii?Q?tSVS3Dpp8HmPftj64JMAhqaZpVUQuFbGKeIGyHV57e/Bnu4vzRWdQ+aS9JvR?=
 =?us-ascii?Q?7+geNGGx4x4aFMjHG1Ri94shsn5RD7c9L0JL2/4fUmf+L3hEYZS70LF8k3zj?=
 =?us-ascii?Q?VccNJ10WfVw9J3h6Gve1Hvz7jvPCFF+Kf1NgTR9u4FbIPFfhQoIgy0YhPQij?=
 =?us-ascii?Q?mDg6TAdWGsT+IOoVDsQ6qUbX5CqYyaUxD2/8caT6/DsUz9I8t2Pc+UzMAxfN?=
 =?us-ascii?Q?xLNt/AoDc9/KF+x8LpcH4GYY/5YJYqWqHyUdz65UkSpSTpZWhG2DNqXjy4Ca?=
 =?us-ascii?Q?L4zcIUMoapNXXq6kYB25Ei5g+45/r9+kN1dYGJeSAVhVRym3M2/7DATasbRq?=
 =?us-ascii?Q?7KaVANS+0Ao83um1nSJ7GJb/qTueJCI3TrFC8OD01FtoUIqgIlPVrRTGkEOM?=
 =?us-ascii?Q?GuEwVymTXbBwRigc7YG8pgK7r0wpEgMr/Clfa3y4Ez40v85vPvHQOFJ4m3Fw?=
 =?us-ascii?Q?DP4mxvjS0gVrrOQ5BqfPezOGiB+YZddkwTXa8Xsez2aXEflOf7LXITc/C+6E?=
 =?us-ascii?Q?rdC3oTefLHA05tw8F/lJTPwCSLwy/C2umHYjD4t7ZRm2sRZ8WpmyxmK4ShDX?=
 =?us-ascii?Q?WNMq0ziijrqqXpVWx+KwE2U48EmVVI3+RT+qdFFaUgNVfyRc10mwZLqiwE2c?=
 =?us-ascii?Q?SzGGmq+zrHojYxv+Sha9DNDBPVEPi1Eso6Y1cABRyaKUifV5T99VxTm2LW9p?=
 =?us-ascii?Q?3/TOlFxLArj0WpKkC6h1DFW5r1W4HzWj+1tVWFOST6ZYMcQyENrNhwzHPOHJ?=
 =?us-ascii?Q?6d7Gs6ZLERJDlgWvkiL7+r1dNRo2aMyTFNvh6M4V6s2FCDksUHhA+zf/x2tr?=
 =?us-ascii?Q?nMyg7U+Q6OGEhYCO0uy8cFx87UdN6emwj65CZ3sSS/qAzlR7mNhDcwuNMLeG?=
 =?us-ascii?Q?cUqZIRszJmMJDvnk5OrqwEgU5EHQceNpbNuioUJurSOKpXOuq4gGLE/g0mnu?=
 =?us-ascii?Q?e9LeIT2xKo/p01jAgJT5EFoU8zREn2uwAQ0I5r6gixyPqSqUgI890DMzIqBL?=
 =?us-ascii?Q?XzMs67Szi+Ve5zzA81HSqKufDx+/j8/GXSyJApKH1b5bQdO+5Qh7y+JPRiCx?=
 =?us-ascii?Q?LlrqQNGBK2qIH+VAvFOCN29/Z09QERe1NqvAIl4VQanjRlTXgmjaYro6RUF4?=
 =?us-ascii?Q?k1Xg58EDkLBeOa/ywDQ9qjBkLu7GMAPm8xyryjJTU7qoF34AwZZCxxQ7wQVz?=
 =?us-ascii?Q?qle+Z9RBNqMVY+2hoI0RWWi/y63y88m6s7pclB4x4+ywZ3VTcwqwMreumXG0?=
 =?us-ascii?Q?ysLe9prCg+cFMpzarPOLReudiqbrkeuKQzGMEgwZ8J0jaxduoBMxVE95TqIj?=
 =?us-ascii?Q?MbDnIasLHMBTssguJZu9RWWkzfsmOpeF2BtTbdl+IVWtvVboqTWeXmkRjQFW?=
 =?us-ascii?Q?9zRZmg//HLAzxrtv/tzcqWs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16221AB5DE54174CB4CD064BA75CC49B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2824f25-fa99-47b3-c363-08d9bbd53b5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:04:34.6690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Miq4Njx6KX/eaMrhkojVQiGA80WGVAHfH6gLF+bh+Ph+dhlR1uq/VTMHgLRdgN1unPsIzURV7fgTzOyZYotabw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:32AM +0900, Damien Le Moal wrote:
> Define zbd_get_zoned_model(), zbd_report_zones(), zbd_reset_wp() and
> zbd_get_max_open_zones() as static since these functions are used
> locally only.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
