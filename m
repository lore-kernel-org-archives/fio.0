Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4941C64EC4
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjBGOGw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBGOGr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:47 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA84D53E
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778797; x=1707314797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ywXZIhHtaS68RJ7wimumEUrazlqgS1zjchGuAfVyqWM=;
  b=owQUnJ2SRDW8j0JHrrLq3r++Bqh7FBR89VhHvj+AhaEDAcSj+8ym7Ozl
   3+S+t2U/UGCYfMfj/NENSXJWbTV0Vx8+TmYGDLYoOEsrtSiDG4aXLvj1H
   pA//6b0KtJy3zZ0OmFwhU2gDiXTNr+yPfDZGbJ5peJiR5LSJjsn93TEKd
   0RH3ym904lz8hEuGSgTK92ufjDeDoKYYmgXdS0i8Vs/Dp9iAuS06I68bj
   HOmuX1+3PIDJv30gtqDQEQW5l/XES9DYqSVK13kaDe3ioA063ArNJLWd1
   i2QPwZdVyRHWMYopNmJmdsLMgoW2qQ9vptH2H/S+l+SgIpN62GL2C3dG8
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="222753299"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:06:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC5QZ859X2TZXifr8NZ8qealS/s+f3uaBxL3xnMyzJJB8qD1hYFEkbM9AxZBXGVvxgN5VPorGws7f+IowM3DceKjSW9KfgJoxgiBcEM545oiCdcO4rmCbXZ8U/P5tIWzMb4G4wbIGK8u/LlRUww/so3HvLNI9s0PFaa1s8LG6I3bkEeuoSzyMo5IcfQnOIb3dk9z7+wUoijsFmF9g0WtCbBM+nzXs2QAAY/O9La/csjBO2USL1ZjJ/uwt6AtSNpwa5vsZuG/3DjBSKWBK/TgwjXe+jkxL3MLm6IOK4pvmCYnhVAZ8Bgvpz3NfwW3HkzrMO4RqtdQBT81oksOfbll8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0G+5fRUQvBSEnpoIpgvm2X2eqWO32fqLH0USm8gJqk=;
 b=k9YJxYunGYeDXooTjcSFqot2SfwtwPYii/a/QIyV0DVSHP9b9nwsIrg6O23WP0JFnZCNvQ10KQWdUtVlKbH86x/X36asYJdgqrk/x5fwIhCOyrTFZ3wEWXyn0dvl69K3DNatwAl0i8SqTevL5BMR2GbkmAptf0EP2uKgT5bdU/jSY90lbCg1n1mPyPR6fqHiZnGczV/7n6pfCPrxzoJoMxQpJq4UbXPlpRFu6oHuzdSe89OdbsrEd/nJpaXI0Qf6qCcw+OP+Zz/Wn2UfgT6BxfDn9efbw9Nn40GjtiNiwVgp6bYEmV10mJf0+5SjKrB5v9iM6nN2Ah0ZSo+GYe679g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0G+5fRUQvBSEnpoIpgvm2X2eqWO32fqLH0USm8gJqk=;
 b=taVN25ixV6o20sXVCpocv8Pyikauu2uy1V1DlEQLULh/KBlNb4IFQQ9oS7HmwJtNVnRg2OUqleOuiS734JE2+UbO2aX89t0O7p+EWNEWEjzdOFzbuUY+THBafMrpFePZUYM4rs08u5A81D3qpmuIacpefxPdRXEeAQaW6O0csd8=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH7PR04MB8455.namprd04.prod.outlook.com (2603:10b6:510:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 14:06:32 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:06:32 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at
 file set up
Thread-Topic: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at
 file set up
Thread-Index: AQHZOr636sPQv1gG3EyY5zCqskmisK7DhUMA
Date:   Tue, 7 Feb 2023 14:06:32 +0000
Message-ID: <Y+Ja5jyZq/snxRpI@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-8-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-8-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH7PR04MB8455:EE_
x-ms-office365-filtering-correlation-id: 22915642-55f8-4a9f-38d1-08db09148417
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iw6tkS6Pqq/z1Pq9KLTGQlfCFW4m3kbT5c6iklfZW6xlr/GToAFhPOVZRuoJ7laM0/kHaYzxR5e77lPpp2p8gmBOnEQCxQv6fpX0c3BPHzYEw2JUt+NrGFvt+Eh6qiGnEQSJJqiDQ/A0z4i0ITmzNRoQp1v2xNGr1x69Lgl4svfNEevJKNzWYYZe2/ICnDQNvAT2M6hAjkMfq5ckpu905sbirrZBzn0QX8UEE7TmsZs7pcmmgXo41ash+IOaK3XWVJUpBsvpMJiibtnY7zEYT/hrPKwI8jASS5GVC7G6e1hl7oE3CPsx9hqkYncVvPSLj3eDhEqTrLP25ymLo0dvfvliCm4wOId9g08z+Hk7jzPp6fSwVsusVuQ7A1Xq+vPtYlH2Y+hWptoVxSIgmGm1BuH3CtWKxDjI/VPFz50XpLj0TSJF1jnc53fIW/zQTQem0RBpDuZJOLMDRb9BZmDtjvvdjCZo9bQOGdY8Ooe8n+UD35KIGSWb4TWgBf/bVthIc/HePb5+R5g4P3YOg/S8CndyfS3weNhWPuDupMUsKdwHyxT7LZ0wV9M+S6UqoE5MfEIwznJ4kIkp6DNpF138782KJ1LoPPoxcqLwrTP/5KbggBB7gs4jOPcFb9WMJeaN8EWMGgmWJDzD3P1hva22nWIlUgrvR2Gm5r4SApmuaNzOwbBrRLCuuLvmUJuuAfgj3ScWrlJ3jc2FSftYATKe0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199018)(86362001)(33716001)(38070700005)(38100700002)(122000001)(82960400001)(6636002)(6486002)(316002)(71200400001)(2906002)(54906003)(478600001)(6862004)(66946007)(6506007)(41300700001)(5660300002)(9686003)(76116006)(66556008)(91956017)(83380400001)(66446008)(8676002)(8936002)(4326008)(64756008)(6512007)(15650500001)(26005)(186003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0O/CqZXNn3r8gZkbaJf2GvNguq5d8h8D6/LwkYW7bixvX2IfouEncdk0HU8d?=
 =?us-ascii?Q?XYMjA4Qan77jsi4u94ubh2gzzE0LrevbfVcDTCDwtqIosxwfYhfPMxBrfB4H?=
 =?us-ascii?Q?C/M/T7pQ50D4fC7137jwjss8fV325fVAIkn7sN9NmogwfSFSJa3q1dGqDbtM?=
 =?us-ascii?Q?LJ0WMYnFBX5SR8jSEdt3aHEzI9KRn/0sAPGz6h2ha8Ms0E/ktogWUcgdlXxr?=
 =?us-ascii?Q?gZOvRJPaC+chN0OZzZXBtQAlH0n51493mUur4fLwIV1Wk0nfWa1fNFM3Z6TK?=
 =?us-ascii?Q?6qMKcdZodTUhZz2hqldZplmBbZ2jJv/eZFChJdzUen1214HTNiCZG6HhQ8m9?=
 =?us-ascii?Q?rJTD4vLionnrvsi12vEOFut4XfUQLTCCohWXhNO9+3QPfUUs8xuaML0PXw2o?=
 =?us-ascii?Q?53cTOghbR2c9JN5RJZnM5GhtYj+pWl2AFcLZ3QE/EoCMr3pAZAyCiTy1Kj/8?=
 =?us-ascii?Q?3cyPGp6wItWeXMU57EIPm6+Df2/HKhnKw+aTvU/7RfgfdSMP/0CJWwQL80E9?=
 =?us-ascii?Q?fuXDkMv8/lmRC5kkpbto8GovAeW1TXqFwT835ae70rRvX+hstiFZZPKKnGe+?=
 =?us-ascii?Q?1Ruozak29LpgqCxYjNYvXUumSb2hQnKve4O4Kd4R8/X8yidrZkQu1LpThOiO?=
 =?us-ascii?Q?6ZBg8hWn1qI+2wzsi1UD/FgrWryM8hfcv1AL18YDi0bJ3NEp/nR3kI/41Vok?=
 =?us-ascii?Q?hR9gWbZk7srGs5Icsoz0sa9urRJGvWQE5swYRwt+LEBsueNWkobQYugVkroW?=
 =?us-ascii?Q?jsupO136lkRG7flG8YWwX9CIWHrGWkf4crv9gK9jPxcdEkaKNrPI6EQ+q/bT?=
 =?us-ascii?Q?MACyUtyYwSztLUkaH/kMaSRo2OPMce/lH9XiI2w5illoonxRgpWhKHVS+u5L?=
 =?us-ascii?Q?s6n7z0KJHKJTzlG/GC6bjxPclfKdBoyX7WOHMAUSL23jefGIsorcOgjNcc6r?=
 =?us-ascii?Q?ByV0/mbL8Aw6QrxyCUk4SmES6HX7tcF/qgfNxK4ycAqOmACjW7OjfmJCpaoU?=
 =?us-ascii?Q?K+CgFj6WXkjVN/iMtcNR94PyAdm0SEZ/+6cetPlYS6b8qxjxXjho3bXSflS5?=
 =?us-ascii?Q?k1VuW7V/bbRM2ZYh7jyLIC3Fv0pDs+ZkJboRBNe8PAVUfjbva1z5r/gTac00?=
 =?us-ascii?Q?kHzpIeX2+JF/dd6iUr4izO7bztTHKZVBcGQZrDNyYv+FIJ2x52R1ew+OkJHG?=
 =?us-ascii?Q?yXwXLqSR7mHuYtpxzAB4C7XKwtQZ/REPFQ1NH0Iv9zwYuNsLUxdal7sy2/f0?=
 =?us-ascii?Q?YtUPw8zpP9hJ2XUWs/dcqg/fH+6kZUOmKpUO8x8MTblBxWK8IgsiTvSLmAS4?=
 =?us-ascii?Q?lwc2fWk6CxShzXBAX4173qS3sIqoanlFDEIA6N1U3FlbI6K7ArOiw4AEtqCD?=
 =?us-ascii?Q?N38R5ZcYoYE4tbm08rrD9JactTbcMC1eWf5bQxesmMyTq2hAXZPt94ixYDt+?=
 =?us-ascii?Q?fTqQZUwmLxA+6WkAiwpoUAoKEyH7GmWoKsbSgmhdhwpprRI94H8Wpu9y+0+V?=
 =?us-ascii?Q?6TgJb6ifsvavecUs9+DbQ8pi+HeLt/Q0AOW1ygG2XKiJ7infOd8GPlOAkf5o?=
 =?us-ascii?Q?YtZrEPQDZ2AAn9dny3oVDlLnAf+U8Oe19wdEB/coOU2QP60vR+3HDxO+ejQh?=
 =?us-ascii?Q?Sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <666E592C8751024A9006D6B1657E6408@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NTGs6vHttigFwD8QYrKgLNtOEPcDcfGUwqU2onJgIAPxTlr9grIEHvU+4EMcPEh42jw0GiCErQFZcjZMMt8qvwwajXBlsKrO0OvscWOSffe7L8nqE9vMxHsBSq47GibfE4MzseQlETPte5V8WVFozWls28kawcisQFY6hx1Lum4wBMZGYlTCDzsct8a7EkJgev2BQHqmq1aYvJDaK5DjwhO0a1O9e9l+UWTESUT8ziaZZqkPrWf8M/ZS43z/Yumj2a+9wfeDXzIhQCr5BmlK6iBZXDOlV+iABhtPwIS/X6u7awjzStXvh7/hFz3JLfpK1Z/UbpvMUohRUAGuwFc7qIIpIGt9DUuwmzSHfN67u4RXiwEgh+oJIdggAukmqx/kBe0odYDYwtsYuX1qK6DkjFeOKO6i0etcACIFDj/OeKOhfJol4H8khk7S+iU7MyzLj3LqJTnSxv4aUNmTOW/acSI6kCOkYl3eQe2yZXKV7zjtbx6x0pofxZYq8l3UXHROj3eSfCRxcsKy0gfRpMchwA4FQNGnKrfmFSAwJBojx/d6prvu0r+npEEoTvpCz31epM7kKVwTM2Hfsin8gBOVDGuldRaT7XstOPSDPrA/jGhstkv8uXB7AcVJFzKvMrqeluJhFdPqA0+sI6KCz8OwLpkYVOFhzht93Ja5tw2PkVb3O6dauUbTFbvrGiC5O/CXC4xgoaNbOBM2+qb/E005Eriyj2i13J6g4tp+pdpbkz6lSAFBrKW1use4gG0V14DyXPwchvPoDJamR7E8CH0CjHBGDWaXOaKKtuVlBhwL0meDfw4tqBPv/y3ZassVEcy1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22915642-55f8-4a9f-38d1-08db09148417
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:06:32.3011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uV5yjlsDKWYYO3Auy5TsDNLuO0MMgoR4oIi2tGrdND4bkjYDWwU5HNfmVMbpqHu71sIt8wy5sz1/I0CA+KL3lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8455
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:38PM +0900, Shin'ichiro Kawasaki wrote:
> The valid data bytes accounting field is initialized at file reset,
> after each job started. Each job locks zones to check write pointer
> positions of its write target zones. This can cause zone lock contention
> with write by other jobs.
>=20
> To avoid the zone lock contention, move the initialization from file
> reset to file set up before job start. It allows to access the write
> pointers and the accounting field without locks. Remove the lock and
> unlock codes which are no longer required. Ensure the locks are not
> required by checking run-state in the struct thread_data.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 93 ++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 44 insertions(+), 49 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index ca6816b9..a464d6df 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1074,6 +1074,44 @@ void zbd_recalc_options_with_zone_granularity(stru=
ct thread_data *td)
>  	}
>  }
> =20
> +static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_fil=
e *f)
> +{
> +	struct fio_zone_info *zb, *ze, *z;
> +	uint64_t wp_vdb =3D 0;
> +	struct zoned_block_device_info *zbdi =3D f->zbd_info;
> +
> +	assert(td->runstate < TD_RUNNING);
> +	assert(zbdi);
> +
> +	if (!accounting_vdb(td, f))
> +		return 0;

zbd_set_vdb() is also called from zbd_file_reset().

The code from here:

> +	if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
> +		if (zbdi->wp_write_min_zone !=3D f->min_zone ||
> +		    zbdi->wp_write_max_zone !=3D f->max_zone) {
> +			td_verror(td, EINVAL,
> +				  "multi-jobs with different write ranges are "
> +				  "not supported with zone_reset_threshold");
> +			log_err("multi-jobs with different write ranges are "
> +				"not supported with zone_reset_threshold\n");
> +		}
> +		return 0;
> +	}
> +
> +	zbdi->wp_write_min_zone =3D f->min_zone;
> +	zbdi->wp_write_max_zone =3D f->max_zone;

Up until here. (Basically the code added in patch 6/8.)
Should probably only be called by zbd_setup_files().

Or do we need to perform the verification for every single file reset?

> +
> +	zb =3D zbd_get_zone(f, f->min_zone);
> +	ze =3D zbd_get_zone(f, f->max_zone);
> +	for (z =3D zb; z < ze; z++)
> +		if (z->has_wp)
> +			wp_vdb +=3D z->wp - z->start;
> +
> +	zbdi->wp_valid_data_bytes =3D wp_vdb;
> +
> +	return wp_vdb;
> +}
> +
>  int zbd_setup_files(struct thread_data *td)
>  {
>  	struct fio_file *f;
> @@ -1099,6 +1137,7 @@ int zbd_setup_files(struct thread_data *td)
>  		struct zoned_block_device_info *zbd =3D f->zbd_info;
>  		struct fio_zone_info *z;
>  		int zi;
> +		uint64_t vdb;
> =20
>  		assert(zbd);
> =20
> @@ -1106,6 +1145,11 @@ int zbd_setup_files(struct thread_data *td)
>  		f->max_zone =3D
>  			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
> =20
> +		vdb =3D zbd_set_vdb(td, f);
> +
> +		dprint(FD_ZBD, "%s(%s): valid data bytes =3D %" PRIu64 "\n",
> +		       __func__, f->file_name, vdb);
> +
>  		/*
>  		 * When all zones in the I/O range are conventional, io_size
>  		 * can be smaller than zone size, making min_zone the same
> @@ -1197,54 +1241,9 @@ static bool zbd_dec_and_reset_write_cnt(const stru=
ct thread_data *td,
>  	return write_cnt =3D=3D 0;
>  }
> =20
> -static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_fil=
e *f)
> -{
> -	struct fio_zone_info *zb, *ze, *z;
> -	uint64_t wp_vdb =3D 0;
> -	struct zoned_block_device_info *zbdi =3D f->zbd_info;
> -
> -	if (!accounting_vdb(td, f))
> -		return 0;
> -
> -	if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
> -		if (zbdi->wp_write_min_zone !=3D f->min_zone ||
> -		    zbdi->wp_write_max_zone !=3D f->max_zone) {
> -			td_verror(td, EINVAL,
> -				  "multi-jobs with different write ranges are "
> -				  "not supported with zone_reset_threshold");
> -			log_err("multi-jobs with different write ranges are "
> -				"not supported with zone_reset_threshold\n");
> -		}
> -		return 0;
> -	}
> -
> -	zbdi->wp_write_min_zone =3D f->min_zone;
> -	zbdi->wp_write_max_zone =3D f->max_zone;
> -
> -	zb =3D zbd_get_zone(f, f->min_zone);
> -	ze =3D zbd_get_zone(f, f->max_zone);
> -	for (z =3D zb; z < ze; z++) {
> -		if (z->has_wp) {
> -			zone_lock(td, f, z);
> -			wp_vdb +=3D z->wp - z->start;
> -		}
> -	}
> -
> -	pthread_mutex_lock(&zbdi->mutex);
> -	zbdi->wp_valid_data_bytes =3D wp_vdb;
> -	pthread_mutex_unlock(&zbdi->mutex);
> -
> -	for (z =3D zb; z < ze; z++)
> -		if (z->has_wp)
> -			zone_unlock(z);
> -
> -	return wp_vdb;
> -}
> -
>  void zbd_file_reset(struct thread_data *td, struct fio_file *f)
>  {
>  	struct fio_zone_info *zb, *ze;
> -	uint64_t vdb;
>  	bool verify_data_left =3D false;
> =20
>  	if (!f->zbd_info || !td_write(td))
> @@ -1252,10 +1251,6 @@ void zbd_file_reset(struct thread_data *td, struct=
 fio_file *f)
> =20
>  	zb =3D zbd_get_zone(f, f->min_zone);
>  	ze =3D zbd_get_zone(f, f->max_zone);
> -	vdb =3D zbd_set_vdb(td, f);
> -
> -	dprint(FD_ZBD, "%s(%s): valid data bytes =3D %" PRIu64 "\n",
> -	       __func__, f->file_name, vdb);
> =20
>  	/*
>  	 * If data verification is enabled reset the affected zones before
> --=20
> 2.38.1
> =
