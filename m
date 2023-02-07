Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72960C636CC
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjBGOGb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjBGOGa (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:30 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C818EF8F
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778775; x=1707314775;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rzDCe/u6Ppiz2X4Z4ZyRrUXHWZFlr8yEHLxmTbSdGQA=;
  b=e4h+wrZvce/dI4E4swgCMkxKf80J5Vfut2fiKCDMaKfEw5x3X3O2oAyH
   K7DyQPXtph/4Rsf8b7VJkx+34yS7NkJKmGli3JoJYnJXZHkCmji7agCz6
   JYGH+ImvOIuZOMg8FuJiMYd3SKoleyOKmUxdHi1u9bIb2ucoRPxEZB840
   hREecKjSg6M50ZmE41bszm/f0iHIs/BZdLIKQDPPgw14rCuXqfzfeHkqZ
   fa2KS6Ph+B3PGDlMaraX/87nJ7ihzvRz93CCCRC7HWcBm+eYjGzgr6II4
   uyh35qN6Mi58s/ZNde6O7ZLuT8n8N/pN+T5OMVN7YGARa4BWT5s8O4y8r
   w==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="221030800"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:06:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHUSwBMBbllNAteigmxk8oT93nvHgZWkFkBOqCqdJNz/NUASMQOk9vzIZ4OfL5QT5pt0woLRuERa/2AdMU4vuK4wVj06h3kGfmjn1twT9tUAYqIk3ZHvFoexPU2LJmisCYORbbMoEpQGIzLrQTqZSg+FvaLXh9jHQ64tYRKlbxkGcybgu311nU1SSfaL4JZiv34RIIgr6URnfE491Fr+j4az5tp/51i2qovaa05RfmNTHdlVea3I7A8V/it8ZVEkzTC5LAcedAeb919LgIcBwUUYMT+rQ/wJhiJVyGbWTUQc9ZmezPLEWLXM4yF9cpCseYk0BQw3mmlrATWK0GMDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFawfSuFg9dPY2UCO9O28lAB4WLHdbhfdn2t4FrPEq0=;
 b=IXQsTJwsfG1v+dkiDkUQsKe/CyIx5BIE2vruJlKI02jgqop4ZNVl5OSUNssFsUbCebGQMvMaAK+bN6ZBtgswZS45kF1GwwZE4Y6eHxCAWjvOzhInJLQvg3TERXxc41wZhAd1ztTcd59jbmxETXZl4UqQAEarxe2fA1IeAk5hPRFmswCgZqJ4rx/bs7ARyjAAaropAOKGKKDsWoqiBwXSODiNNwEnsniYdQGPNRBzki0Jvz7wVRMcFGli9ocOYUQXsX7NOKfkEiEgwDFh/dHUM9CsXLTHfRzo34ZFwvwp3sOrj8hGClGyjGHvAB1n5FWqKSjX+e4i2QArtDn05zu+HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFawfSuFg9dPY2UCO9O28lAB4WLHdbhfdn2t4FrPEq0=;
 b=HBIWwxtqMt9tuPocaZ6I3r1u9Qqh5XuoLBiyjtF7Eoeei7Ll9ypEAVgEN7QT5iSNxNhTaXzUnxANXT+Zl43vYRZWGaDkAwAl8Rr0m6Yt8biGoWoM5msJNeMESi4toJP7O8uTPumzRnP7FgO/23OXBTe8iHJNam40rXYiK5Jx8w0=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7042.namprd04.prod.outlook.com (2603:10b6:a03:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:06:10 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:06:10 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 4/8] doc: fix unit of zone_reset_threshold and relation
 to other option
Thread-Topic: [PATCH v2 4/8] doc: fix unit of zone_reset_threshold and
 relation to other option
Thread-Index: AQHZOr60wM4MeUQ5eEa3Ug47rOORmq7DhSgA
Date:   Tue, 7 Feb 2023 14:06:10 +0000
Message-ID: <Y+Ja0MV6GDYGybDk@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7042:EE_
x-ms-office365-filtering-correlation-id: c29fd4ce-c1bd-4a2e-bbf9-08db091476f5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9hyBDVSiz171N3kcbYCeOEFiD9wvOnN2Zgzgo7FLEX6UfuftpOdCO89iuGgtFsWZGIMZy01RA0hGszVcHU3CiI9xLD2F2gw3GnGUaJ2hICQvHWL8cmsKyj7ZJ0vAj8yEwHVMjSgkewm2aLovZ2LNKMCTDHf96P6WTfq3y2Wy6aRxryAgiB/P7j3Avo4HHrecZqoMZZi4vgF9hwcQ5Vo5bX3Yth+NZc+ZZpzN9NWfvZgdcRGq4ua1/Mh48d3z6ROtkT0Pz4bSGOpxUf+8QmtyEnSCDCg4YhZND1aPoYVz8UxyFJg2M52q8SJOwflsac1S5O8T8U7r2z0uUtAabRN8HhmjVeaG51SMmwUcikJ0C5Bi7zm0ltjQQnA+2TwzJSnsebdwz8PgK87zlN2MBzA2ZVh8Ufg1oY4LvwWKDMq3r6vbDXGWCupq89opzFc/5yAo0EmkwF6FHEEl/jYIKvoxNDTd9pYqPhiXohOdNqdOV9JGMniSDFfu9MUEZ0JqOsl9/AX4x7l5s+CN7dnprVR2wJwclwU37clPylyZuS/OYk87gYfxKnXacI9Cep6aD7EhX7drYVM5DlEnATJDnVZ8thqb32BnWmcfKMOG+EQZUytZw7k5cer04FisRJsanI4ekz3czYlwFG9+Xhn3DMYm+Pci+a4TDOQ3uW+wbjawK461Tt6ZJG24p8ohot68zc6Fy/W5A9bt8/WrUqaUlxes9VhH8q0rFofT6uTt+p9oOBQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(38070700005)(86362001)(122000001)(66946007)(54906003)(316002)(66556008)(66446008)(91956017)(8676002)(76116006)(38100700002)(64756008)(6486002)(4326008)(478600001)(66476007)(5660300002)(6636002)(2906002)(6862004)(33716001)(8936002)(41300700001)(26005)(6506007)(186003)(9686003)(6512007)(71200400001)(83380400001)(82960400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A+exs4UCCM+hUtxEEl7E6tM0+6UVtxBDQBHoJchgPXbakQw1mx+haIlPg1Oc?=
 =?us-ascii?Q?Lho5m7hDe+yNA1RTS+Z/m9xLpBYkPaNR2W9ONioHa4KivFwSiEZsgrKnTc/c?=
 =?us-ascii?Q?eQErTqRQddgpWpf6oy02sMnAYgj1Fz0c3W9TF3oZbfmj5ZyKhnvMwO7E+mhi?=
 =?us-ascii?Q?K+ToMJO/DG81Uz9NZpFCMkozXA9Y4baS3zZnALqI0aQUuJOx6qXEqX6Z8Z2y?=
 =?us-ascii?Q?49QJOFcp4bg33o3rr9LfnUz3FQmanGSnlTkr01gZ8IM3GEhoud4tlyOBcVYJ?=
 =?us-ascii?Q?S/TKVtk/AAw0UV01UH4y06Syqnx5IJfUI5aFPRpuiEU9ej2hyaZ1ZfGXECJ5?=
 =?us-ascii?Q?Z8Pnx2rQUodAeZQ1HsXJXlYyqVFl8KaoCUmcBSrFqWVO8kkgxmoqM9C8Ex7H?=
 =?us-ascii?Q?YMQiwkmCfDAg/ZVIgZofEh5SUyOIeaUmhEdEDFVl9Ew1gkh9QV54fc98oJkc?=
 =?us-ascii?Q?kvkCCc15u1zBQXuOtSh0OnasFd2bVVyUXEwCyWfsTOl5tFxmOTBpyMgwue96?=
 =?us-ascii?Q?eZN+xDTy7l0pIjyBcXbAInMAPz4etDn5o3mlVf45ic9t0IA0CsWa36aABAf2?=
 =?us-ascii?Q?4P9x4zEOIEyAtcwWtnbQ5BDnAO0x372ahjrJ1N1N8FnrN4wvFIXzjWnK0iEe?=
 =?us-ascii?Q?61IPhTAGLcoG0Gxx8PqHXZYT8rEeGmxoo3sknZ0qQdyE7vcjK+UEd+59UGcO?=
 =?us-ascii?Q?wArhFXK8mVJo8qAJP29kEp9JW/s8+tnZt512INYe2k7tvXdCjSae5WVaXGEz?=
 =?us-ascii?Q?1ag2yFzdJLf+4vhaPXS/rMQ4UxLxpTUwJQVMwNzJX+56TcK3ZLM0BckHyLmM?=
 =?us-ascii?Q?eTIOauPXiE5B/naC5kJXSyA0srjSFGMoxyeq21VpOenm+fo2/FD9KPHFFp+L?=
 =?us-ascii?Q?fRv6D+gm25ENUxdV/oiXboRddNqxXwtvDci31CDP62rRcoMnwxEarHJclxYy?=
 =?us-ascii?Q?NaOTP58fvYqp6o7tv0yDPEHrVGysXiNBuq5Ai10edXiWR9UZNhDraxniWxT4?=
 =?us-ascii?Q?Hm382maahY+PLt4BURezEMsUIwRyWHbms8PaRw3ZiOlMUWJFNgkEo9EnSEN5?=
 =?us-ascii?Q?s4ai/Ra1zkytIvRv639/PSieu4e2q4yfhNCp+74nP2Rhqv3eA5cmsdNTe8bs?=
 =?us-ascii?Q?jqeP8jhuIrNRGDXB6nwSuEc/Gvee7FcUx9eemR5CoyV156fHZpsjMgtaWXup?=
 =?us-ascii?Q?twAEezm0yTvHOTAs3MbCoF5MOBhOG7vEyGb626pDXKaqvHoa+WFY02LzebCe?=
 =?us-ascii?Q?WWdloTfKC8dDZ/VV9GxtX0teD2+7/SgMHF6cKb0f2kLC/AzZlOUxYqkHhvbp?=
 =?us-ascii?Q?5zlMrJt7Z0msYGTahmFSvfSYjt1JjWYIr9zaEtEtDxSMANfdA64OqCuHHJCC?=
 =?us-ascii?Q?QjK5Evfnbf6g69oOTZ+rH3C0MwtEfAJgge7vHVJNu9Wa8HebvW3brwAxf2aZ?=
 =?us-ascii?Q?OUfHhy5MoaNvggM4S/lNFs+rGXl1zVgr34wq/Y3YCD5sONxypeMl9OpE58NK?=
 =?us-ascii?Q?0XecuDUa79T9NC+5+EYNoxcmsm/+3RzyhZFPjF48eiim5NKcQuDOmeBxdvUb?=
 =?us-ascii?Q?6BjAmVIRMvm9qP0y63N8TTHi/wYTJVML74ESsH/O0Ub+C86AcBXaTbIfHc2X?=
 =?us-ascii?Q?+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8DD5BD5DF85C3542B8732B25C7981150@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wJI7pD9MtDTY52aCNGbrpXnuaGNBXT0DkPeRDnFhuY6LhVLbSZb4WufbwjeGJuDbpBgOuefu1fv+DUwRRCtTdutHFsD23chNiYDcam6tuVRzECWJu2VP7dYpU0xSo2T+AZ2C9Pyea/xwOOLSCorDg4hHfZ0xd6gMxSI3DYNJQfzEwvMrkRWtjIoR1SvFrnfOkD4PFnCnkp6X9/Vxv5WJ4taNcGNbDZ0UsLPs4Gk6/7Yc/zmzAkq/3K8imkkBKU/i68n5MHeccCM32KsbDV2TmTuVG0sw9fp945AR/0TllTc09v8jdT7UQY7UhiNZ47WLE+dwfdJyj60waS5q4Db9Kkpl7BIK4QBX0R6nS6wdqwYftikhMNCfp7jzcjK9giCYM2NfSlq5gQXqwEKqq9XgrlJuLu5NfSsVCwA/hs50aSwKJ7+nnmxncnBCmU3wRkjz53u4skgUiFWJ4EZIl8MHDZluuKVV0bkrXJcrtnIcBFu9x2CtsZy5rMWYkFwxnQFpkuMVOF8m2qQg1112iS2xSHXTKbImEZ/d8SmHkKFvNpgdNKlB1UKyFysr6O+ph6Vve29CZmDLIoQQlJMCFuQMPMGhxJ2WLpxu6sV5mDZgSQNkZeRzwdt5IKrYv11oCASxWn3rFqybZtZx1VkWwKS+OIqtvp8g51kzLN67Sze5a3Yues2Q2LxvuKWpBz93/nwi6gCbP5q6lI1w1/sneAn6+tjTUhAAGlhCho3VO1DPRR8UsYjAgzIkz6VW/qr2+4NgrtnpdRL60U41DDBWtHlvsEsrazPl8TFQL3e/rDZQw0YKT+HgwjZ6nKZsTr/F53oW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c29fd4ce-c1bd-4a2e-bbf9-08db091476f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:06:10.2712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eG4Be4PBG3+qCvOm9Il1GLomD6SufZvhqE+njLYOefIHex197mV8fPF8HnFWj7Z/GWzQZTlbMkllqKrcI2lHCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:35PM +0900, Shin'ichiro Kawasaki wrote:
> The zone_reset_threshold option uses the 'sectors with data' accounting
> then it was described to have 'logical block' as its unit. However, the
> accounting was implement with 'byte' unit. Fix the description of the

nit: s/implement/implemented/

> option.
>=20
> Also, the zone_reset_threshold option works together with the
> zone_reset_frequency option. Describe this relation also.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  HOWTO.rst | 7 ++++---
>  fio.1     | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 17caaf5d..d08f8a18 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1085,9 +1085,10 @@ Target file/device
> =20
>  .. option:: zone_reset_threshold=3Dfloat
> =20
> -	A number between zero and one that indicates the ratio of logical
> -	blocks with data to the total number of logical blocks in the test
> -	above which zones should be reset periodically.
> +	A number between zero and one that indicates the ratio of written bytes
> +	to the total size of the zones with write pointers in the IO range. Whe=
n
> +	current ratio is above this ratio, zones are reset periodically as
> +	:option:`zone_reset_frequency` specifies.
> =20
>  .. option:: zone_reset_frequency=3Dfloat
> =20
> diff --git a/fio.1 b/fio.1
> index 527b3d46..54d2c403 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -854,9 +854,10 @@ of the zoned block device in use, thus allowing the =
option \fBmax_open_zones\fR
>  value to be larger than the device reported limit. Default: false.
>  .TP
>  .BI zone_reset_threshold \fR=3D\fPfloat
> -A number between zero and one that indicates the ratio of logical blocks=
 with
> -data to the total number of logical blocks in the test above which zones
> -should be reset periodically.
> +A number between zero and one that indicates the ratio of written bytes =
to the
> +total size of the zones with write pointers in the IO range. When curren=
t ratio
> +is above this ratio, zones are reset periodically as \fBzone_reset_frequ=
ency\fR
> +specifies.
>  .TP
>  .BI zone_reset_frequency \fR=3D\fPfloat
>  A number between zero and one that indicates how often a zone reset shou=
ld be
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
