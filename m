Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359F0EB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 13:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbjGRNzj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjGRNzc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 09:55:32 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D37124
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 06:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689688524; x=1721224524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GiBPUWm78eOuVW2R3BsKqcaHC7b6KML9hTvXz5ITPlY=;
  b=Vqi+8oCG1kj9WbyC+EjQjx6Hjr1JS+xebiG7uCtWsjj4C8CM0iva/ckZ
   h+Zrr0XfooZbdCU7yxlk3W6055m2bmWgzP2cTmLrrbe0vg35AQH/cJphr
   UoL4GY+kZPdFxTImU7PBXXSj9xdKvNHxBeQDK6uaMeRPQ7pGKRqntY3zI
   qW5hYjM4TZtfficNNJFSWOrvvJ8JR8ikBVcbgpskgTfZg6mOf+dX4dz3n
   ykTZ3itX8X/Itqqe8+x/uIfxBx0QEN6UHPMhzdeUdAiJGNWl8+nboZnh0
   5rvhAy5ZoI/SRyAIv8g/7anIs/RfXalXTjloNryJJg6Dv+uy4A9uwX9u+
   g==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="343489030"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 21:55:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2qP4OuwzBNDc7G2iupmNr0VK58opRC7+J2FIsBqt2e+Wnk8KVKVqucdxpXNpBtwPbwVjBA14NkVimEL32RZ+VBgXM/UnRP73STo6ouRqRA/VAl3RztHOBYycFlJagd7kcHmN6ll1+PaqgiqQydE171T3ZrKqZ9Uh9mMGLVE3TD9UVRActZ+eVWI1Ojgj/YGKbUwT8BgK68fwwpNgNei12Gn1f5yS7UL+7CaJ5eVVKHpz3wSQy+mDU1Ij2malctNN0ORxzU3vmAB1BLOrJV88ZxkzMk5W9b23r5DmC1Qm2txWcuzpUxr5Y0nQMuDdYtT+u//P34o/IHzQCWkGQtu9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4javEBt4wZr+tpQisQdIwZNEJGB3UUDSOoKtoKYzbvs=;
 b=PaRbfrBtDv6UpfgldlLkBFuUsGkw23Z4GSTA6xASmp8o1tWm/fvhzPrBgptRj0ft0qMhua+9ydjKYgAu3gQkpU1VmR5wp2TaAaREd3UPoTTdSULa3v916ewzhWAHksszfXNU35HuwOuOJrVOQZtJ5TTiL9dta4ev2x/CpzKdFFzRQPB39EoVn5Ob2SKbMR1O3Je+lPe/Kgxx4GKDkVDmEcWS5nOH3pT0cW6zis0Zp7RwfSWdbq7HEp8y16U2r/9kJbNe07tXixFrFY9p2T4VYfeNr2PCiJRfNJQXcdFKjhpQO30ibEgY9pTgbx3mCz+57Dc4O5uPq+tJFW/ySryCow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4javEBt4wZr+tpQisQdIwZNEJGB3UUDSOoKtoKYzbvs=;
 b=mxUSFomh1HrRjD9/yigKs2nQckcVbABbxKnJpv1BCmMn0d70FAwI6DMfjTVPqBFjJXuAHctOLLH8lOKNpVpbK7PiJidwTN3PIFIg2cyOrEb5oqsnaeJGvQaUTOAILcXHFWrgaICqk9fMtYCrXo8UIPuF2Ve4v5wU+FprhM623n4=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ2PR04MB8485.namprd04.prod.outlook.com (2603:10b6:a03:4fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Tue, 18 Jul
 2023 13:55:21 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:55:21 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 02/13] zbd: write to closed zones on the devices with
 max_active_zones limit
Thread-Topic: [PATCH 02/13] zbd: write to closed zones on the devices with
 max_active_zones limit
Thread-Index: AQHZsIFBJ85YZQjxgUa26ETI35YmdK+/nfSA
Date:   Tue, 18 Jul 2023 13:55:20 +0000
Message-ID: <ZLaZxWyOoIJkh9tb@x1-carbon>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230707031505.3468915-3-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ2PR04MB8485:EE_
x-ms-office365-filtering-correlation-id: c5cfa4be-99ab-41d9-9679-08db8796a08d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: niGap8AZOnRv5p4u66faDvxzqPxbWQD7z+x+5MtZ2MDMaw2icxWg4EMpSnNYiWN8XdsPN3RHd4d8bmxM0V+DM5lWWrAjzKfPas3c6C9SQpdfKo51V3hi7V+WC1yQcmWdRAWghtyevn4Dd5/BhG8krdJ2yWfhALGF6F3AKJKer8ueWXyP8LqzVC/DmW40hMDPRvYICOChNsA1qowv5FYgYi1ATWMdCbtftLm3lZgwzHYF5t3ojFobheHsmS5U7x45BYWqe5yIm77VNqbuYQDmkx3HSb9rDUk5r5JXr+u2wz8EiOTLZH9GsJvw+afv6vUZBbxkdDnMAVmCKZkSSfzI7s5XfyUcaCFkTN/R41vddsiGK1LwDqh9qyuotlezOkKxUAIoAvZ+P/j2lzr0a5c9oLvB8UaD63Ik8x+CdqlFmhqDTC3gPswVy8MdE15LsPdvruVndh2du9p0Na1wm1K6qoVX8nd0oQWWbZlptOMS8UY9uxZf097iWDe91gtHNDVqX7gF4080ao53F7tXp8bV+2tTb81ZITGsoYxMmFSRKOajzLNXrAHqpGyUXIsEx3r4HZV4SQG7owhUsMaXIC/FLUZ6C92mgpj2S6YJoonRjTx6++tG4M7rgWssDBKPwqPzMKnFBR9Zo+FoROB6X9pVcirzCaP7BLJKz30uuEamsj0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199021)(76116006)(66476007)(6636002)(91956017)(66556008)(66446008)(64756008)(4326008)(66946007)(2906002)(41300700001)(316002)(6862004)(8676002)(478600001)(8936002)(5660300002)(54906003)(71200400001)(6486002)(6512007)(9686003)(26005)(33716001)(186003)(6506007)(83380400001)(122000001)(82960400001)(38100700002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y9bvk8iRCPa+iZN0dla7eRfpCqgSOi5LuDfJyH69CZeLgFq6Fl/tr1813dpg?=
 =?us-ascii?Q?Z1Q1VLgAEjjsudKZ8U5fk3Tma7ObbtnPPPcVA5HDe608OlmS8T5/g93Epw0S?=
 =?us-ascii?Q?qGsC7tNaAuw6MDgoMJ5diAa/WM+henhNhWcBfd/ls6/ryoPfKVektNgKDAp7?=
 =?us-ascii?Q?iZi1Z7mmQwk6dstq/o/ocAv4ezDVRGqFWNs0hfG2u9VPgb0WOJuNs60FdxcH?=
 =?us-ascii?Q?IhbqnUpME5N/5mMfKeOpezXiBUezeNr08AObd4u8okKgQMxAPoN1/l42V4oD?=
 =?us-ascii?Q?eKlTwBJ7xPzucZkr5OeGMOU9W8j6SI4LWotB9zsRcF7nTtXAKAViEYcg6iUN?=
 =?us-ascii?Q?W0TeIePMDfjBEFqX6yTRxiYtJEmmy2B7mQyy3m/M/0XLW0+9mJWXbshhZcDp?=
 =?us-ascii?Q?iswejo390dvqDjNQ+JaGtzeQwGNw0NQxpR5/+i8ctIzQ7aRquM2Qdxu/IvmN?=
 =?us-ascii?Q?yWZw5v+DWP9U2pD/6UvKJlh0XlgkSAzOXMzl2p7MCBsyRpAWLEeGaljPY8I0?=
 =?us-ascii?Q?hVoANzQZHs2AOQzwfbMinzu/+yg5/9jzK3gyBzqIrHXAEmXd5TlzJhtSxT92?=
 =?us-ascii?Q?apV4QaO8is0tdQ7Ut+5+Wb7NEqfeujVacXyK6EMpbeH7fNZFkphp3j5mSiB6?=
 =?us-ascii?Q?AOl4JZqqI1GnH54I8CtmwytBP82YGr79xCSNrDgOiP5jpOK91FQI+dZwIBJu?=
 =?us-ascii?Q?oVm1wVqBbroIVmswhnX5PzZiLZwa78Tyjn7O7STRvNPjpZP3yFqDLmWIr4EY?=
 =?us-ascii?Q?3+5eJwA8aMpebbIxbbdsi8/aoNghxtXQ40+NZmjW+9QbnDjLwdr0HN+6TIlL?=
 =?us-ascii?Q?AvOGc0lorpstDoEsKZP9A5bJrcCml6edOMdfgHg+b/nWiz9O2oZTwDjxQ9mi?=
 =?us-ascii?Q?r3OgFqef9z3RhbAmkflVdqw34uqNzNek06pBTroYU7LmD/I/y9kggn8qU35W?=
 =?us-ascii?Q?IoG2QZOLgOn0s/x2P1dDDCgZ6Nz46d6a82jXXony26/DXyLdAoMtWkg5unOu?=
 =?us-ascii?Q?5NL8FRqZBoy7N39PKelTsN49SFnDW1355manT0/wXv8anYshwYlldSqHttVw?=
 =?us-ascii?Q?lM+lmY2UVMJfWp/hLtHHDYTKNw9al7AgiB0+xm2w1ct6C1sENQGNB6gwskDV?=
 =?us-ascii?Q?Q6zxGEch5WBwgHc9DuPXnEU+nX++eidSUftJ1MFHsD2lbePrhDgJzUqkRIAp?=
 =?us-ascii?Q?RZcl0BkB/OqtvQ9utRQMGY+VzzK7DcORBlGwcYhqmpfFGNbvCBAsEK/XqytX?=
 =?us-ascii?Q?9Wl2jyhHxShf5Izqedl8eMCLHY0n3qW4lSVzf9r8TeJ3TMxrmriS9/3vpmR5?=
 =?us-ascii?Q?VuIf7Rbt+rYVDxTcX7XqUVRcKJduVSWfRC3yM6WdfeHohYcgQNV40KZCpq8F?=
 =?us-ascii?Q?QdnFGqz1eMgjNaXgU2JF2vCaZEgwZKtuiu0rbo6bWPOArn2/V/HdwEhFDjI0?=
 =?us-ascii?Q?x50r80go0c538HRDTCpIGBUgpbVLPOhoI1Vs1hvCVesBS/5ohB1ECH6Q4gnk?=
 =?us-ascii?Q?+KICS5nrfnrAB8j7WvDEwJFZEBBWNI7dysj05ABdk6PqiPe0MOPS+Dkcs9OE?=
 =?us-ascii?Q?OxvIV18MxDriA0yvv7WvOy7Md+8pUyXRMln8E96QrHXlz6A/TVIxlxdDqHeP?=
 =?us-ascii?Q?+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <64BAC3E5280DA34AB376EAD5DD763C3F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1Te0UtE5K8GvLSInstQ2RAuhIV9WFmn1UDSxAoYEKDu9HoHFdBTD9HC/+NawL+qj3TloAQar9TFxoXd8TOsXxXt/LIUq5nBIX33vRraEy6zQW4ggvAQd2HARyfsfzSRP401WrmBs/Q9PK8VCQDD86FnysLaa6Oxu+L1wrgoljb+XJGSIp6zRa4Q79dXjl/ycfiCoeEt2hLY3oV80R4rm4T4Am7zzHVQSHDD3Axo+0drssG83OCEhxa8ba2gvnTLdmFOupzPR+IyxcqcjvnCch8TZa5khdGl6swEly5m5RgmXEFnNhDjjFrIgyc4S1Dvsnyzi4DqjWdMXh+RIiaclxDM7WESVMIyQyQzSCg+5mXFCYU/CZNJbhgWgFrx63KGum+cWMBzzWxpYoCqmKNq5j6PUmw7UXYbBCfExLmZ73YXHPArGrVz5QEN986BNs7Wcby1lQ9vlQCbZHbJOCckh43S6EVl8DyCtat4g3T10rAvRHy3CuGl86YAzx//ploPk7MJb5W6pwcWLZCMAS8zK2ZzOkTvp6gV9WZvp/5I9WJp1f1oB9t2yyCYGa8u8IB5P3CFDhxxZqpKBhBiPj7dBd87FcigKuQFOtJQ4Si4FgfLAOLK26pQ13UZmf8Kz33+dwye24kbZS5QNu+9zZnRYsz3ol5jvcgroJpTN2KtYWzhN1JaCRGRpSw4Y1vJnb6sbz+oCFaQlrW2yvFPQUokHj77wYIyVg9C/JRFjS5Yo/o5vGz+4xKPvqndgQGMgYdcUteSIDJULiq5shLpvHxmnHyntedVJeRaoFHAZEiMZttfhy9vgoStN4lDtf1gry2MRhUpAl/POuvgIfhWL3pPsCV3SzQrLi+3N0Oe5PoDlwJw=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cfa4be-99ab-41d9-9679-08db8796a08d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 13:55:21.1383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AT4KEch8MyWggLo2hj2qmIaKNQu7X7D1ufJfzSAa2ob88hr4mqmc9DTTGGD/5yrZ0FppN905/w4crexINAFVXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8485
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jul 07, 2023 at 12:14:54PM +0900, Shin'ichiro Kawasaki wrote:
> Current fio implementation does not handle zones in closed condition as
> write target zones. When the device has max_active_zones limit, the
> write to other zones may cause errors by exceeding the limit, since the
> zones in closed condition consume the device resource for the
> max_active_zones limit.
>=20
> To avoid the error, handle the zones in closed condition as write target
> in same manner as the zones in open condition when the device has the
> max_active_zones limit. At the job start, check each condition of the
> zones in the IO ranges and if it has closed condition, pass the zone
> to zbd_write_zones_get() in same manner as the zones in open condition.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 9743b60e..3069ad1d 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1255,7 +1255,11 @@ int zbd_setup_files(struct thread_data *td)
>  		for (zi =3D f->min_zone; zi < f->max_zone; zi++) {
>  			z =3D &zbd->zone_info[zi];
>  			if (z->cond !=3D ZBD_ZONE_COND_IMP_OPEN &&
> -			    z->cond !=3D ZBD_ZONE_COND_EXP_OPEN)
> +			    z->cond !=3D ZBD_ZONE_COND_EXP_OPEN &&
> +			    z->cond !=3D ZBD_ZONE_COND_CLOSED)
> +				continue;
> +			if (!zbd->max_active_zones &&
> +			    z->cond =3D=3D ZBD_ZONE_COND_CLOSED)
>  				continue;
>  			if (__zbd_write_zone_get(td, f, z))
>  				continue;
> --=20
> 2.40.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
