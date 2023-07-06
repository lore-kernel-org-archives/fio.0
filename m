Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0ECEB64DC
	for <fio@archiver.kernel.org>; Thu,  6 Jul 2023 08:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjGFInt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 04:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjGFIns (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 04:43:48 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91921BEA
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 01:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688633024; x=1720169024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C7+TTrHqa48EnmHMtd2frbOqcuCgecFN+ts+Bg00iLg=;
  b=lvd8LUUK1eZlAb1kNMQFHa9p+l5EsHHuoXYDn3zscLbHU6z9FSMv+SSo
   dA9Ao+PWW9damcqbLZDKmRNJt8xbWpIZ3CwlUsdFKznn9PSgYDh+Y8wdm
   9fbufff+y2YyaIY0rRh3McVKN7ioVfeLDryPk0i274hVLkzpeUmqMWCV+
   4WvjAP38pzNqREanxkRyR6K2wSd0gb+C6mPLdQ6ySfXRrxlelKVySx8z3
   SsLAUM3wUXCJ+fa5jAZLoZqnE7JwwweX9Oqi5ek6iDPr6XPb4K7j49wGy
   V/eIGiE/OJ1X9NVzrUNpBentzOByaoVarHi5dMxtOGCoyhVu2nm+5yoBF
   w==;
X-IronPort-AV: E=Sophos;i="6.01,185,1684771200"; 
   d="scan'208";a="242003384"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2023 16:43:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXzUpkSuKLaG+OE9pnZzL54e8tr1szXdBgwISiseMNje0HyWKfIqg3joMwteibOYViueyRQKrlViE3rn/XJsi0oqhwthwSDWHsYcnrVfY0r4Dyz34AVUOlGkZbTsiuHKdmaeL/bGk021PNu5vdP6gpDvXczH/k0Xwn65WPT7yGOE/PoMtS8ewdBJfW13NpWxtgqa8/EtDG49bzMQ9VNGmmFNVM5u3A2hP07aWt6O28rUX2RX4+sjzaX5/s0fpKaJXpA3qXciplW5czreLfoNiXslfOIFcQ6NkTa7VMvRbH6yWc2DRo4eeIfW1vu/OK42iQNi02HBmfq9e/+vgXEoPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0bNOXDZmzs5EIMDpxWQ9JjzwYlups2bp30nX8C0XPI=;
 b=jtuEUSdX6Qv42Ed5VByYcXWYh/xCDODti+517ULbp1BEM5izUa4BlIpd4E7BJDxjbfkNFkxRDCE1NIxGkME2w8BjS4+gv1JIa2EK36AvzK2dISaDzmK3sUFCgE+0LFvRIBzU9P2/RJO/D+qPZ1IMVS7H1Tv2cC10HOeKzjZoU4IT6J3p+cKgbYfNXE3ZAL1m2LtaXvt0jNqATZuNsQBXgt/OoJ1kdwFh5XBKLIPELoljXoFri+FejfgPDXfZ9ckKa7XZ4mZiDsdUnm6lJpBooY3HfkrWtjtRqWMztgoL2+phSm05PeQd7JbONWvJLnsL7TzLxIo7qZQ7lYQBMIaGWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0bNOXDZmzs5EIMDpxWQ9JjzwYlups2bp30nX8C0XPI=;
 b=HpLxgEjWSCKBr6FPlB7X81M1p+eIAqpU2wYl44lC9OnRlqZXjg6A1ANG5MrhDS7TOWjMkp4IEVDg/X/uT6D+pnvUJWSoxtm4r0RR+17YR08jE9myMEnek3a+hIps9AKV4FGidIhptMx+IS7QzsMfPIzJl9qu0oRHEolk7p1NFHI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB6680.namprd04.prod.outlook.com (2603:10b6:610:93::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.24; Thu, 6 Jul 2023 08:43:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::456e:ea7e:b4c:f106]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::456e:ea7e:b4c:f106%6]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 08:43:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: RE: [PATCH 0/4] Add support for IO priority hints
Thread-Topic: [PATCH 0/4] Add support for IO priority hints
Thread-Index: AQHZr43kp2He3c5CK0K6wxtYB0uH9q+sbCWQ
Date:   Thu, 6 Jul 2023 08:43:34 +0000
Message-ID: <DM6PR04MB65757567C626F9E8AED14CBFFC2CA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230705221302.430678-1-dlemoal@kernel.org>
In-Reply-To: <20230705221302.430678-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB6680:EE_
x-ms-office365-filtering-correlation-id: 993719e8-9757-4ccb-8674-08db7dfd15a9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HyhJqVpcQtkp8nweChcmWz+Y5YcZcaDMXovV9urvH1MkfzIiAw28arYxdhdZa8edH2Pq3eC0NEmle+X6/v3EMNRAncFe9v5Gba+YaT6VTOy7wTYzHxRPJFo92LoHWLFrNZR6Rib3Rxt1ZKwi0o8C7I+YuavHpCxyDj670HeGsO/0U10TLq6ctUwwM+ofxDmkKhHxxElmYiS+nt25EX7LSwgkQZn4r5S82dzpSVW20RUPfcxLkaGfJAwUg89of2Ac4hSGoKY2L3kKh7k8L33bxVYwv28CvxCrX26I5KPSNy3cKmHVyy8WQxaf/zKG+ghh//ukdLhliXJBodGq8/opUkjifny8lf5opysixnSGlGgeC++s8rv890CInogPqpY24r5fA4zsxLd955bRvw0CI4/YK95aMuw6/lYhjrY2Qqlp0Dm85lVmbZ0f9AyBSBIg63J1pCQJUvvU/pG941/3hUXtiea0O3UpHFhXnHSxXpxB7fRiEuI4NB9il8hmzXaanKlqLF9pWEfVKH17VaxAkK1UqxnE67fzCWtO2TG8kC4yT34fDSQ2gZHcnNoJuHAaUbJrw5BZdJLF9ci/dYTDeIxGY8luPWL7A/cMSe/KMxpa544r5qbBOgn6C7jVsgTa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(83380400001)(82960400001)(122000001)(33656002)(86362001)(38070700005)(55016003)(38100700002)(478600001)(110136005)(71200400001)(7696005)(8676002)(5660300002)(8936002)(52536014)(316002)(4326008)(41300700001)(2906002)(64756008)(66446008)(76116006)(66946007)(66556008)(66476007)(186003)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jDmdVp7a8oVS1ee9fDHF9n2bCPnTf9w9z2JrvF3dO0pbCfB7AKRUGcEvuVfT?=
 =?us-ascii?Q?KHDObrUqw9vgv2tP+TR9gh8pLuBlFzOH5bp0oGPK8+ZG+cnJjjYpwn/DZFQn?=
 =?us-ascii?Q?QVqx5qv8jamBFF0tKfv0ILb9jU/Yqv7sVZSJupaOPZUinruV9Clau2ftNE0y?=
 =?us-ascii?Q?2d4kLBz8Z6UnbC4dF14HAhK7SxWb1i3AGjIGyp4ZShj+X8IftLhgfL75AtZ3?=
 =?us-ascii?Q?kMn26vQ3Ng5PtlJPG2iWfXH468TicEgdbe/3Cv+rYcE+wGyeWSEkLTGskRa2?=
 =?us-ascii?Q?S6korzECrz1FGSWrVA2ADjHm8PYhzH0dV+/TJbNH9UHVVdcIiMdlIbYVg6oY?=
 =?us-ascii?Q?HEa0TK2H6d1UrEATA6mHMceiG/VVDrXYOppPOvp/30KcoFWNufgNHjwYsxq2?=
 =?us-ascii?Q?RoVbHE1bGVvrFWBplIk100OBvpkROcX1PIDkqZb+oC8zfA/n1zlIpBVYePzN?=
 =?us-ascii?Q?gy5Q0qCfZ/W1xFTGe2d8razAwf8aRsmYkbcgrD4pOqaN/m1Tv8bfpgWrnBGa?=
 =?us-ascii?Q?MjKM0GSZh+JE4mdYEUGpTKIhytxVAjr2NtVi+vlF0mmMTvQ3CjgSGm3J4y2Y?=
 =?us-ascii?Q?wjoxDI9Rmg3ujsUpFU3QQ2cGqulaovcpozZgQNA4VDXiSTZx0znVVw5iMJrT?=
 =?us-ascii?Q?VL3cpMa5IKDLspve95lCm+6MD+T1SJ7+WvCryDjDovfYh9uPx15G7mZZcpEa?=
 =?us-ascii?Q?D7qFzzU9Fvdd9cNrk+HN0judAr9KvGxjNuJ2/bXjAGv3p1bY9sH/oHj2oeIq?=
 =?us-ascii?Q?PM2A2glfXc2K4sPi0jdAKpP1pRuoeEjYfg4qzWouXLf6/Ixz8PMBr1fP5BwD?=
 =?us-ascii?Q?KGnqz9bihSLJy+DhcRqrjc8ALRyi23DTeTSb/lpKLkNP6t8hGzioMoRZODNb?=
 =?us-ascii?Q?9u5SQrAEwUvDqSFmmxHxfI6YM/xRwECwLLwHIv4HfIlfcQ8WM4pIEd8MKI0S?=
 =?us-ascii?Q?3Vl3uIeX5U+aS7tvI66LO0XPafjIe1eHZM7rW/y5LPi/Z0+eqEngVpkoSxfn?=
 =?us-ascii?Q?Z1ujyqfnJvSdR+YG6GCU7B8UgXjQgdZVYCBJQEkD+nw6qkfivFenaF6C5oWb?=
 =?us-ascii?Q?eh5dQd1BEMSYkNp37gIRiGFH9nN+z+WHpRFVJ5AAmdkiK+4YPJvaLsBvjYhJ?=
 =?us-ascii?Q?Q4aflJG9XnPfRM+2lr+Mmr6MFhA7AIow5srONzfY+He3TRLbkTuDgG3UzFKU?=
 =?us-ascii?Q?fp+yhV492Lcts0V8w4HmTMePE0qk5kQgknHyyDUPDYNvMPS1LY0unfbmNu+k?=
 =?us-ascii?Q?G78Upq2ZCLfum9sB9Mlwv7Xk/WPS7xNZDSgLuYmTtuZe6soWdWTJRDH9ZmFn?=
 =?us-ascii?Q?teQ/1aw22BgYkVmSu9LA+DCfyAkZZ/s7NrJGJEaRUky2+ykI4etqN+B8gRWp?=
 =?us-ascii?Q?J+YxQcPi3gJfy0T94v+QT750PXbM89Gp3rQHxNvcgz0vUr9H6lnoBbJNbM7v?=
 =?us-ascii?Q?DUPZOa3/c6dKCVvn7CDuSJCWhFtK0gDTa24mMSwLqZFVbcl/Y1HEsqX6zJ5Z?=
 =?us-ascii?Q?nwP2Gm33U7XKoCMPRkapmqpwS35EHaEn+F3w5i+5tAYSu4nCNG9/d91zTiFo?=
 =?us-ascii?Q?pOqr7KBxuExjak2zX+08XomQKsh4Kk+nKGktP9xh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dHax5oia2smuxqHSyd77LTRHOCAH2yEznypCCjYABJ3KtchVaMqpNfUvPtBwo5lvK5CS5qPuEOYOVamTW4Wmdz3Eq4RcpYJ4hYy3rumYdvj2U+kIsV8rJAUdHoHiTN0OvBHxr6HNKTBLhdmK2G5xEwKS81Q4a7CNUSCZjdTRc7wHjydxHb6qML7Ye7wJohvCbrMjzwrwVPM3FD59JZycMb5dK9qtohSVJbvY52UKBmxqUwyw3rIoSg+TWi0ep/DQ5T6vjt9/8K+QB7ERYypNi87ljNRS+OdkTChn0OCTDRsnvTP7B3TUlw34zCxTDGOEeooYMZfuFRHFOtgBSsVHI3MZi0/1a5b+LRbqUFurr3RzM8gpKmTVDHyLXH4Oys+vx21AFYFWcNyEVRfktzdxAhgG5GcC+032eQwAqglIFOzA2OB6gPHe4UdOjP6LiYMg1PQe+wAn4/lCGGmPt/pIoa6L1yRnq1yOm/kjRmZen1hMuxMRWkbUntxA5QFTRmwOoV8Cl26hhM95N/HI9KCGf26bUGJLyfKnV1/enfRHZ8wMU6LKWbRiubBnK7JTo/jZWgEguMgFwKYHXFMrW2VSvT6t4xkN0i4RVPnKIIWF28TzzfssPBEKzi4IvssGZ7oFbbVGCFc5ZbcsHiwa2s48hahQXX70AHEAzvggaobgPj7u4zwA2oHL5sTy6RtK4svE+2ArKCpgDDmAMPIunUD13UDtqTsxZH2B8imoRGJFWhfw1NE2bNoTdoPBtEiT8jfDTOzt13V91CL+xDZyj5D3JbbDXpaoMWMB3SGk99q/CvM+nTFl4WeDOtqN30RIbQmoAeOSJ/ZqLCWgPh92vk+fy4q8y8FFn5kJMkatnKbJoC8=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993719e8-9757-4ccb-8674-08db7dfd15a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2023 08:43:34.6570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tarhcYJ99WQwxoesSIp2XtV6atIUN5NNCtxOWEkzNae8Hp10QKb6nuOoeVF5ZIp3w5Kh7CIPkZc+jSQzSr52fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6680
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> Linux kernel 6.5 will add support for IO priority hints, which can be use=
d for
> now to specify a command duration limit for block devices supporting this
> feature.
>=20
> This patch series extends fio IO priority options and adds new options to=
 allow
> users to specify IO priority hints.
Maybe while at it, remove the write_hint option that was deprecated in the =
kernel a while ago.

Otherwise, this series looks good to me.

Thanks,
Avri

>=20
> Damien Le Moal (4):
>   os-linux: add initial support for IO priority hints
>   options: add priohint option
>   cmdprio: Add support for per I/O priority hint
>   stats: Add hint information to per priority level stats
>=20
>  HOWTO.rst          | 31 +++++++++++++++++++++++++++----
>  backend.c          |  9 ++++++---
>  cconv.c            |  2 ++
>  engines/cmdprio.c  |  9 ++++++---
>  engines/cmdprio.h  |  1 +
>  engines/io_uring.c | 25 +++++++++++++++++++++++--
>  engines/libaio.c   | 21 +++++++++++++++++++++
>  fio.1              | 28 +++++++++++++++++++++++++---
>  options.c          | 31 ++++++++++++++++++++++++++++---
>  os/os-dragonfly.h  |  4 ++--
>  os/os-linux.h      | 21 +++++++++++++++++----
>  os/os.h            |  7 +++++--
>  stat.c             | 10 +++++++---
>  thread_options.h   |  3 ++-
>  14 files changed, 172 insertions(+), 30 deletions(-)
>=20
> --
> 2.41.0

