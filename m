Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BEFC001DC
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 11:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjGSLJS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 07:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjGSLJR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 07:09:17 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9979B19A
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 04:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764955; x=1721300955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vUODfTna4GGGLioS/AnmgQSF82zsCrw9z/3l8ho+q+I=;
  b=LzrwU4k2+6vyd6d68w7aOP90I6mxP8w2tx1VNJR4wOm5hz+NFJWgIMhJ
   wthITtNHW6lzqxzW12H8aBBHBlsapb+0PQ3cM4P1+XMptU2KZLYoPwprz
   G0Pg4pblidMDb1gP93ojVvbTloEZY1Yda13ziQQ4rRYFYRwnQTUZyUZ7G
   Vqw+EWVRH/e3ADcRWmLsmzfRrsMIlTN9TyIGQYvWbvdzT2IVz+bYDR+HQ
   1YFx0G3r2RFbObrOc/oy8RUgMGXv0NQei6LfcylilNV97pjskfCKunNAC
   VVQHuRKq4HGVYWHpToNBLSzStHAYtcodujFtzJNwRbX8O449IB8uAf+PV
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236861416"
Received: from mail-mw2nam04lp2169.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.169])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 19:09:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf+MKeJQAj2HdZyX5E1MJ2l9U04vBzlbI833Nrejv/Er9dyWVRNikNWumPeS5kn5avq07ZYjzH/IqNoEZlHZYU7lqt/+ZNp5DkItRAfxuuFQ1+1gTb4m/Pd7FJpVafaM7qV8IpZv3P+Ott9sXzKZp0xkKRNqtNHGMOuGQp5c7Zm1Ghy87EkLSDLj2IK38bfNaUyxXxWO++hjBEWNPNqauMe42Ur0b+Hign/EKC2JkcKykI6tKPeGz3KYtB+3raRNhX3coz871wkKy41XTFx49W3bBqGPkPCD0/hVwpg40BmQ/OWetq8nnpIJVelSplxEYMQsCWATCyy43qNWFBkEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zbPJJxgDS4d7GxQJhUYi5+5xCq8UetUU8nYaLvmSmk=;
 b=aw0bV2tzXJI0uKLdiDvrFtuxJ06432aUhA8cRMesBrZ0Fzryc/FuTQXZDnflIansp0n5B4C4NIz2YhvM0bsEglG24JaTtZNxnIf4n8/Kx8nzWEepZYxNLqCwNu7tPGxOQR9Oayh/ncxyIlnHPE2dljBY3yFa+/CPOZ2QVWecdx73BuRvggGoIS5XaSDhFWJ8RXslxS4Fcau7kFmPO9iE5klG8kQ6TV6lmNEHDkLOqMXxxCUvF90UolvyhGYU8ILK5LshVAmkl9q/YeLm9xlhKPy/4blHhZZHZ6IIHd4EwYgW0GEZ8esMj1x2gn7plk2zpCSJIyzDtq9EnYl48fK76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zbPJJxgDS4d7GxQJhUYi5+5xCq8UetUU8nYaLvmSmk=;
 b=aA4cPMJq3CE/sontpjMc+pC5KFFFMTyjtWqDuBUNbbW60hjtd+AJMzlYCW8v1X5lDiwFzZX5ZjjgIImyheHahy04dn4gaBhElkXuDI7bsMrB+Jyq0GUbBiHCDL9uD1tgxoDQNUae4fSpboeNl+UZoI5blmkiBWlFNCCZIf7HntI=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SN7PR04MB8530.namprd04.prod.outlook.com (2603:10b6:806:322::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Wed, 19 Jul
 2023 11:09:12 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.024; Wed, 19 Jul 2023
 11:09:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 03/13] zbd: print max_active_zones limit error message
Thread-Topic: [PATCH v2 03/13] zbd: print max_active_zones limit error message
Thread-Index: AQHZui/nhG1DxRmsr0qiMBQZj7X8HK/A7oAA
Date:   Wed, 19 Jul 2023 11:09:12 +0000
Message-ID: <ZLfEVJlCoPQOiH9a@x1-carbon>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
 <20230719105756.553146-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230719105756.553146-4-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SN7PR04MB8530:EE_
x-ms-office365-filtering-correlation-id: ab485826-2436-4a2d-2a82-08db88489501
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4JsMneust/KR9u1NPnH8g63yH9n1E7kZLzqzYT3KYD0cYEhTgnO7PndgPhFdBKWcBRywYeR25X4izBTX+ykcYFJTSVAmIWGlaW178UIIBp4rx6HTIUIWzvRBgh/7u+lz5WvNVIhTz3/VTWFs6xU7BpFwUNQRIW4S94RyHPTSUbWloHGVXo1RBdAJCvii2qZGRn/mXLPtBu5RqADkAe6KxrI+aOqUYgDc6YIcfu57Bgz0RXOaJqNYA0iVujK6LeMc5etjT8rf3N4CNrF1AYAK+nzfKt3nZGc6sZ79T1xvpYJggfdbnZa8er1mh05Ytnr9rvPDvvJV+Jwsm+b8NBBvy++itYp6JLaTk3eSn6MMzhP8tMdAUUZvLCPcY5EPazDVEO73V1BH9hghO9Gw9sTj1JsjTeieS3nYMP2uey+1D9uLSZNHBYvbrK9rSCtqFmCq0LEnbvXi0vt0PezZMd9IMZCmv2R+7T2++5l77E6zasv3IfdCzsSHaZL12sYC0ZPLuALR971kc1+WSsoq5uvcLS9exrcqlj1AQQpDuZTVBH6+dAYoXrfhfdOAA2cIXQMtwxYYDjPJI3yxdJdpsCjYKoFqmo6UQN2KjK/ZBSjGg8l9vREjDLnzVP9NaQcyY/GY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(66476007)(122000001)(83380400001)(6506007)(26005)(6486002)(66556008)(71200400001)(82960400001)(4326008)(54906003)(38100700002)(91956017)(478600001)(76116006)(66946007)(66446008)(64756008)(2906002)(8936002)(38070700005)(186003)(6862004)(8676002)(5660300002)(6636002)(15650500001)(33716001)(316002)(41300700001)(86362001)(6512007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NpEXHVosiAJ4TADaFUHEh5pmQrPHPszCAAnalsWFaMCjmtQZxnS/wUBgfuiC?=
 =?us-ascii?Q?Ljb0Rqqpuvidfbde3pwsazhDKlXR/xIvwYx3uVRucn4GnzY08IA96OaKFJn7?=
 =?us-ascii?Q?wpfeVwkxGR06YSZwAPjYY8Ec18itLgRcccAM3dgEZl9gDCJaFQ89lFCT7bKh?=
 =?us-ascii?Q?uP3ccW0VBwtRUrK9Rhdul2UF3M+6tswO1Y4wbWchTvotH2aGbgLRgyjKM/OE?=
 =?us-ascii?Q?9r9zdYnDNide/5PfYdEB9G+XiaUQFWtDKbs50ueeB5pKRpqsLhe3QzfwRrP+?=
 =?us-ascii?Q?m47/ajhwh05jXCWdYAgKR/eM1DlvM0wHeBxWCBByME2tvb08vx8sTBtphKH+?=
 =?us-ascii?Q?R3UmuJBzifGKyfBl4Hx7COsHLOhEjJFMIYJJLyFcXL2rmvxstc/UIS9+0pfm?=
 =?us-ascii?Q?klgslv/b92B4HvsvUbMLGlsmDMNO+ZDyqURq3DXL+HVXz2PUV97943jGEviK?=
 =?us-ascii?Q?Dn3iLVWG5846WP14Q/TW/dsAAGC+sQKIB53K7tTU0WYH3tqhlSaXW9bWLO9B?=
 =?us-ascii?Q?Y8I2G0lrqW/kwzJ1/VsdYT0O6QmgNDO+JWjgDnUakWzqtDhgFfGyM4t8DZHJ?=
 =?us-ascii?Q?QKkTfRyFKLYAuPpdt1yADINUtsMomZAZHS6K7owvxhGiHkABTZJaPHTxIkIA?=
 =?us-ascii?Q?cz9Y9xgogMNjOBqZ0B1+tDaxsNge/zkJCur6UHszmmIveZrohzAmfQND85Ev?=
 =?us-ascii?Q?JXwERWkx981TNOtuF5Au/h69n2HQRXGul+kskMpvqVdO47iBqA2udtaA5SYL?=
 =?us-ascii?Q?HwU849loEXXdAyyy3s9pXv65LgfEPmxosU1kyc8DEIky7tZooKKG516dElpP?=
 =?us-ascii?Q?5/SOFcl6LVZu+9tFF07fFkGGcwbUDH9KN+wRqdOkIz6Mrrpjlb/cxELlUYlz?=
 =?us-ascii?Q?wkYkrrCLKcFJrO/0zBxW5uQnqLQX4qkNT+oQiVeZpGSqheDphHOfJof9q1Ya?=
 =?us-ascii?Q?m7mI8U2/dhdrIcucNx5I5NGC6/seZe1qVsVeGi8mEAhCb2jrA5XnkcvCLF/x?=
 =?us-ascii?Q?Rfs05sW/frTSbTQw747dbSGqsy/rToMg1v5ho+EMd591vtERFZCl5pD1rU9K?=
 =?us-ascii?Q?uOOEs4LQZ7QapNje6+Ac07VHgYkndIgNzVMtGk7DEYB/bsp1U+z8GKc5k5K6?=
 =?us-ascii?Q?t2yR29YlB3C4udn9DWdiPzsrRCGPXJ39rrKxrvXBL7bLc5nm5u9vCQ+MR4M0?=
 =?us-ascii?Q?TIqhwxU/Mg5znejngWKbeo55UVPgGGZJVlAOKp8E/3g5zRTgNPN3rZNDJBow?=
 =?us-ascii?Q?qNM5UXUBQLjSZrUGMQw9uQetpygTxmpQ5366WamHUrgqFXPAy0S1ClYFz8RW?=
 =?us-ascii?Q?9Lnvmn80ItDamO78YxOcJA+cQQ+uTM2dYeRh/Sn1DsDg3suKfXAM8kXMJZoB?=
 =?us-ascii?Q?0MGKs1zYEaI85k5RUCdByWp/N4vQ3rXBmVowE3hRDzy6u8N9FRc+Gu94AkXo?=
 =?us-ascii?Q?DkCzT1ZFlnBkIHipMf4h/mnuq3oQnG22/0y0VFTNvB6dZEkD2d3TohCUBzBj?=
 =?us-ascii?Q?xno2WnzqtVF90fxF60wn9dLYipPGg1BLx/XK9wBfSeM/MQYD2uy6XKvQi/Hb?=
 =?us-ascii?Q?MtPeYMFOK9uQdmnnLRfXjuul5w9jVXtuD7rYcxdY6gf3JLj3klMhF9zqncbQ?=
 =?us-ascii?Q?cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25972A08D39C8042956C73DEA6385170@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iaR5NOLElPQ3hSp+/H9Pks4OF3qcAJaYZFljPerXVTveJDYeXUjUYmER0MtwRDw5D3/kZwNNLfKkIyZWQ9ZBJ8EKNhN8n+duuk+DsZUcPpe9tL3M30HCkAXzbp18qGo7Xf8BVvct3+BMioFXdZrj+BHPJGqgKRpoN/xFFDFoAI/eVnJb10Vd6Z1yJXAo90HjQypAXzrtD+1dGRORpVXsv/oXKejzDWmJyio5XWez1jffuv+Lm4J09DesFMiW7F44GLA39WIIVHHjPPdR5VHL+umnscbg11/Q9aG1THhwdVvVOvgfBTHnCFx/4nuFQYIkYyXZFdZAo9i3kWQ6xe9W81RrorP1x+fTzrpTxK7T9ZLZFSAr+s7JlDFLTqLUqQHEYO7aBJAa9YKIGhR2RKGw6zSS4lhKIOEzCcGqMCFnEWpmeAQSObDKULLzkN2MSgfp6so7a0Lv6N7bgPgZf8oEfMo2EEXzyAFU9QvGQNIybxKPwgYFqOMyFalGoXUzrtM153+ZMyU+yEPx2TMNhInFo5fsf+u63c68k/QE9iHINXP57yJqZ+rAh8uCcw7Iof6SjVdtJ7yF+s/Pa4B3ULO/bV7cqx0ssOa4TVp9YL1IF9xilkAFOTF4bIqhaRhFVZ6NO9VytSCRrn/r2JlTAo06ZzxtzF2m2IX35iGQKL/uiunLZ5rcj4Top+rctiWKuiD6CcfMW1LspI7IIKXQw0eSyiWi7YxqoYp8oP+GDijQ+WnA6Yc8F7vEssdUOee9EcqqSEpvlHM2fhVuxtDiOE+3/43YUwVtienMaGdU4TrTOVGmlRb4b7L+F4zT6Gsd3o3dbXxRnzrYihPPIehmKkw7C8ZsOKESCJE7fWCcKTk5xOQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab485826-2436-4a2d-2a82-08db88489501
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 11:09:12.1957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yNZvmZszR48ZViwbVX82eDiMGGTbeU/EyZM2JRov72cISoqaapxinKMwkEAXG56DAW4jty3iTV+rrHT8lQghwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8530
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jul 19, 2023 at 07:57:46PM +0900, Shin'ichiro Kawasaki wrote:
> When zoned block devices have max_active_zones limit and when write
> operations exceed that limit, Linux block sub-system reports EOVERFLOW.
> However, the strerror() string for EOVERFLOW does not mention about
> max_active_zones then it confuses users.
>=20
> To avoid the confusion, print additional error message to indicate the
> max_active_zones limit. For this purpose, add a hook function
> zbd_log_err() and call it from __io_u_log_error().
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  io_u.c |  2 ++
>  zbd.c  | 12 ++++++++++++
>  zbd.h  |  1 +
>  3 files changed, 15 insertions(+)
>=20
> diff --git a/io_u.c b/io_u.c
> index 27b6c92a..07e5bac5 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1879,6 +1879,8 @@ static void __io_u_log_error(struct thread_data *td=
, struct io_u *io_u)
>  		io_ddir_name(io_u->ddir),
>  		io_u->offset, io_u->xfer_buflen);
> =20
> +	zbd_log_err(td, io_u);
> +
>  	if (td->io_ops->errdetails) {
>  		char *err =3D td->io_ops->errdetails(io_u);
> =20
> diff --git a/zbd.c b/zbd.c
> index b05d2360..caac68bb 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -2243,3 +2243,15 @@ int zbd_do_io_u_trim(struct thread_data *td, struc=
t io_u *io_u)
> =20
>  	return io_u_completed;
>  }
> +
> +void zbd_log_err(const struct thread_data *td, const struct io_u *io_u)
> +{
> +	const struct fio_file *f =3D io_u->file;
> +
> +	if (td->o.zone_mode !=3D ZONE_MODE_ZBD)
> +		return;
> +
> +	if (io_u->error =3D=3D EOVERFLOW)
> +		log_err("%s: Exceeded max_active_zones limit. Check conditions of zone=
s out of I/O ranges.\n",
> +			f->file_name);
> +}
> diff --git a/zbd.h b/zbd.h
> index a5cf59d1..5750a0b8 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -105,6 +105,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td,=
 struct io_u *io_u,
>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *i=
o_u);
>  char *zbd_write_status(const struct thread_stat *ts);
>  int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
> +void zbd_log_err(const struct thread_data *td, const struct io_u *io_u);
> =20
>  static inline void zbd_close_file(struct fio_file *f)
>  {
> --=20
> 2.40.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
