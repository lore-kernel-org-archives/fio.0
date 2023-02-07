Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E82C636CD
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjBGOGj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjBGOGh (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:37 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589D1C5BE
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778781; x=1707314781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xtvR6VzpSWrr/zTNScSzliTUmn8yNSpbOu9Ydhrg/MY=;
  b=Msg9VH+hdmerrIXzHEZK2eYRfHjIIKzr5bL+zK8NxSYKuFsKDRfL1phL
   53DvmEZwpS11Ierh9ItHTU3yPyjFcfeokmoGasi968aqjB4crBrkqF3T2
   98jhFMLAmAr89/BOFrlgvN+lqnUsdlszdgj7ra9Bygxl5S9P+E0gC+2O5
   +z7N1CQlCG0adSqJ3mF++r40cogS1CRYy991DMUD0sO9zUb9Wgw5+YvLC
   2gi+orrLosk12bqe5Clxmjzc1BIIYL6XcV687GOeE330f8KJAqjMqQRqX
   7gn4upL/Xwzp+vU5qzDZeCLbzynj08XIym+7/uyfeHsCj4bexxxq4CmqT
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="221030810"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:06:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JahVzjaUUq69v3SmBW5qd2lSqBCsD9AoSVdU7d7HmR4dU4iKDN27Abo41p3UqE+hqfo5AAz22w2bTf5c1v1Q32NQ1CMrqOQksURqOKEezIvyd7NgM7tD08+GhzX77bdtYggzzUA0jR+nRaofC7Ub/Vy4cmcw6laBdqr3nJxJRu6ECRoMjW5l2aavc+e08MOtz+gK7wBxBwfq3Sqk2tf4QXJAoCn11latEH8PH3ldjUnWkkGdHroOsmnK5/BAL1Y/lBpK0oGWcZkmrl976tGfZbRGEHfcNAB/stN1QzsBgpy1s9yfqT6cNMpjLvCuVdJZ3j5+bNmeKutfsi263YShSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QupexVwgR8E9h0tOlBZLAe2+/5RR3+xL/cIm1+WsWw=;
 b=CPM4WjGBpFpbh6QBFVMbKjGrkDbofZdMu9AF1M4+kFQjLCafhhPUtEmt6S6I7V0xZ9aKqC8Cy0EjIP4cBdHSJ+WEZ6twroPQxyF6yilfsUrbSYz3uwMpCgJqNV3+ih8t6PBEKISVUuDQWt6b+zzCxV4DZhsZ5LtKOpCu5oN2NQ5p1CyJGMwtGbv+9kWQpy9q8jWPqXEhLCjpdSltK/TCs8rhc6EFqK2Evfu8EFiZB5VNk3boqpusbCzZkOZFc2mEZFednyxyKrugZ2XNuLuSgAiV9fNcXJvWlqT3VX+iLD5rAK4cKxQOLjh/sEtbirTQsCYNbg6LB69ToZ0cFPtxxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QupexVwgR8E9h0tOlBZLAe2+/5RR3+xL/cIm1+WsWw=;
 b=zWAKz+wsIexy5mquwKuC0MSH3Dd+XNno6BZ+IhE/lFSzRPQYS8oaWjizM/1HDX/s/cRVZflxC446H1L33nyWkF5uF/UvDXo9LRtfWdhhYLtvaJzNOn/EY2BioIc82jN+YWhTZQU4/qqlZ+fE+AtWuFUSC5xAWCR3skHif2Ta2Ow=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7042.namprd04.prod.outlook.com (2603:10b6:a03:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:06:17 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:06:17 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 5/8] zbd: account valid data bytes only for
 zone_reset_threshold option
Thread-Topic: [PATCH v2 5/8] zbd: account valid data bytes only for
 zone_reset_threshold option
Thread-Index: AQHZOr62V0jKQu23/kapmJ99qNdvw67DhTIA
Date:   Tue, 7 Feb 2023 14:06:17 +0000
Message-ID: <Y+Ja2HEYdHIsC230@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-6-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7042:EE_
x-ms-office365-filtering-correlation-id: e60e2386-d022-402b-c80b-08db09147b21
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QHVF/0mLKfR2CyNV2YNSpNYU7OH4y6kpBZJ5ojOHDypfc5xLQJDfD+gaMfcLUAhQdpMGV8q90AqwZaf/zCaf4zFqqne6hpdtSuprnnt2En5PaV09TfVioeTAavmbwZCXD2nIhIT0jebZvUNnSLJSplfgsBo9PHhQB2o1IL0pduNOJxMMu4RDH2vCk432ZJUiHj8q4EQEtEZh7mXoxyF0wjtJe5Ii9zgcEMihyfj7cfLil4jEYEz6jNALnxcqGmkNjp/rDQ7NgDyCjQTvlWN0CjeCgBCHJ/pmhPAAejXPynhQ9ka9Cy0p9h1qdCLs/yY+fC3Jiygw1bMN2otH0DNYBmozPHb5O4KajBtIMozARWM6LiE2TsJJ2JJitN8js6UBCZKXmeJhwV6pFgezstKK9Svz38zWUufgs0ZExAsZzKLiIFvC6m0KkYyPQ8Hg0FP4Hz8yWFrv59BZHuIv7z3FTLZMIms7S4g1qYe7f3aORtfU8DYP9r/jWKeWFFPc2fKqqy3J+eW9XylmPezxqY0H45U2qioLhvSNjlxriRbmpoou/RvPZJYs1sM+Ro6wXo5HcvyZt0ahE4Nmg4qcwQrJCz//MntCPjPkwDEUB65sf/lh737RNkEvmO3g/9Qbkc8z7MDBOOrMJzDPIBwINHmdl7vNbCgBA8Y9DsvZdPdMNxxZITQ0TG+YkvwLqRYZElB88NUTsq/rH7QftbPIu+IJYJ0FoLk810I8fYTEltCKXRc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(38070700005)(86362001)(122000001)(66946007)(54906003)(316002)(66556008)(66446008)(91956017)(8676002)(76116006)(38100700002)(64756008)(6486002)(4326008)(478600001)(66476007)(5660300002)(6636002)(2906002)(6862004)(33716001)(8936002)(41300700001)(15650500001)(26005)(6506007)(186003)(9686003)(6512007)(71200400001)(83380400001)(82960400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QjG0IUrxHoOMLskLOdWtfcjXkQAbJV1aGg2XcV+BlogN8Lh8+7qa0x5xpL+G?=
 =?us-ascii?Q?dJ0BZTBLSvDh4cpSXFpPzf5I015mfmcxs9p4sdU6x+PNXWZQwTw51TxjEG/P?=
 =?us-ascii?Q?r6pfpiFJQ5BuBRT8+ml7PD8FWhrybWBKq/8KV5YjKFahWUKfJBDjjtN0hLP8?=
 =?us-ascii?Q?6T9JHR7HH8i8AMChCYrNZJyDa8urQQPqP0/81x1MmwZmnZUfcPllXFu5M7Cs?=
 =?us-ascii?Q?0jPIcdb49EMh3Rdsl5RTxgUCKdg45PW7RcxkkndEHgqte8uaoIEMtlTLRaAt?=
 =?us-ascii?Q?7RatDNh3/WV6w34vmir0AoGZ0Wnb8osYrKOMyq8HeioHE7KkrNq1syDE6OuD?=
 =?us-ascii?Q?QVReUZPH1vgnzsP9GDsI0FLI6kIFxR7iuFAyn5Y5ErmqYH94HYrP8XlS5rYq?=
 =?us-ascii?Q?YS9Fko2o0rB6YbBA8cslV0swFsLbFdflGgCDkiQSV2NQvrCCHWxJfalTWhmR?=
 =?us-ascii?Q?L/DnhvcElb3+NZb7PjiSuCf5pvwWJvZQkUqS2U/viHMXg3pXE8uZbWZfWiWs?=
 =?us-ascii?Q?5HLlL1T3SWcSL1ciBu0HMQ3IAksqYW9n757/mvqxFRzGSz7uCA0f57KJAWZa?=
 =?us-ascii?Q?imMwKSe/fZWXjuNnBonMzBUTBiLYCZ7kqDJHisgPLsEmHuWWWJxXoYgXRwEF?=
 =?us-ascii?Q?QuFo/OSxrJfzpnbS5lX2yihIDW8HwmUYPPzL77A2C121LEg1u1VLsTHeDZ5f?=
 =?us-ascii?Q?1NKh11SP1J87ozgyQwxklyBjBJE8nnxaSkfW+z0ouKQpvgnJqe1HectDtZ0A?=
 =?us-ascii?Q?3QKWC4zyPvrIlpANfUV0dRwqsgACYoWa5Pb0/8alqvjrz0uAX8R5xiSSfcZ5?=
 =?us-ascii?Q?87FrXf2zoGNuYcU0r3VvZ6TLk6EYAPYgNFVupJVkpqS58BYypTiEN0YvhryL?=
 =?us-ascii?Q?RvvOOzzTRsvhIo3n7PAbhyEAU1Ismh7uouXMBphAovos2oVdmZPJnfHvRxD6?=
 =?us-ascii?Q?eG6dBMtSo1RTs5VLcBR62948l2hQRWV+AB3H6TFD32akcjWy+6c9KyGYXHqw?=
 =?us-ascii?Q?YzxqDNwHao4MS0UNCwoyTtpKWGQHgWWfbX8m5YBdHQrp3evVRtkVPD608cJi?=
 =?us-ascii?Q?NeLfAbrP8o3LTA5l4ETOSpHnoDEGfQq0uxcx5SGoAB8Z1LxN6oRNF1Qedsyc?=
 =?us-ascii?Q?0pS/9jJxcy4YTAdYZx4w7vDMqcKRrkMIIt6cTVM0of1PqIWpLVirJwQaeFyt?=
 =?us-ascii?Q?0cp66d1X3VGLMFtzyag4t7qTw9fddJa7nesoqi8lAhRXWsWO31UjL7Xayq8f?=
 =?us-ascii?Q?WM11iM2uDSRQB77Y8UulEVoEnm70qqY0pfbWB4dAgBpMe8B65fWBOB6ahEtt?=
 =?us-ascii?Q?UPOc2ShySgMMoV5dE+CGRaf8NH6VhSMrpbJaU+thpKAJkiEAdUHEopLwbfki?=
 =?us-ascii?Q?S7x8B2JDbqYckckp9FY5bJeyWNXhtOerKALawST9TPWrV/lWfRVbxGkxmGtQ?=
 =?us-ascii?Q?2SKp0uNKdLkuDi4j0D70+iGkry8+d8BmbHTWsUdGLpXV1bwBLDp/bRH9IC6n?=
 =?us-ascii?Q?Q/t1fAymd5STGbGwND4DLTCVQGQFerNEcHZa9HH8RVaa9G4anHy6fvDJWqf1?=
 =?us-ascii?Q?J8hyZMZ+rNG7W96WjZtE/gJSdhdd75yfZEjw/gmE8k5vHkweQFSD/E3Xfk/t?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63A4DC94B029254AA54EA43157DDAA4D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 92wEz16vioMGGP1MbLhh9E9VDF/FjgCtAckkG5o9yv5uUOXB2l3ZZo+M6rXPXPiJ787ZgVjWl00zDRGQiSFZdgmQWbVNhde6RsWM0mcjToKsaZwXhyaFS3EymlM5S4Qj5QTG/HRlZhxLPWNDrnkjGoUWxzedE/s1wCFlW95FnlgZjw57byiHOBGvsQsVPtI2f4uzkuhQle/lIJhUmxOF/kMUg/aJ7xHlrO7Aq4pn2MFIDTaADeEAiFnvP29DAqjT+ramiL5RUQEGUtPR1JT4yHP48nhbkYjPv9IKoVlHsgxjd/4SD10fnQ5aUqKNjbdXhvhzQJ7ZK9AIY2KiYcwBPGpAg8nuNUA2fGiKjufElK7OYzJA78YzPJ9pY3QqyuDXsvBtxHYxOK2C91yjK8i7l6Xz2zn7CxjPIGsC0cEHvcAAL7OCL65oPRaUR46GsW9yzwOMGKRJFi2aUK9QtDqz48RWgfXngZMXcSgwtKsoCJNvyh6MUXTFGUGJyQF9N0wY0f0/Ya9rjncGK18F1ERcls00PnxqNG+SGqHqenVyM9mZez9nq6ADdEYw3UhY2ZBAzLj6r9COOvyVgr0o/nzsx6OuCmOTgoKA4r2CY3sZMtHrr5DoCFNlZk0eMdR+KuZvCYXZ+ay7q1tkQOVTMBcFZBZk4Dds4EQuGScZzAYCiiWUXAhiXUktx7r/Bo2a+FuYegFUarXS5iYBNCo1Kxb5LgqkhY5z2WPL5hRPtu4RrRO4rkpXnpd9npbhDJTSkZTdkFFKVUs1CHZ+kth0lz0QKozD1egBGy/ghJcYDSlNhOwpajRJf14a1VhfZbiN75GB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e60e2386-d022-402b-c80b-08db09147b21
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:06:17.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UV7vrHgffJLYYdhgLUNDh7P0pwJVi9mbf6JYtdkx6kDiYSHebgdi4KPoAy0LCgBgdsOba1YfgxVz7GlbeBh5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:36PM +0900, Shin'ichiro Kawasaki wrote:
> The valid data bytes accounting is used only for zone_reset_threshold
> option. Avoid the accounting when the option is not specified.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 455dad53..6783acf9 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -147,6 +147,11 @@ zbd_offset_to_zone(const struct fio_file *f,  uint64=
_t offset)
>  	return zbd_get_zone(f, zbd_offset_to_zone_idx(f, offset));
>  }
> =20
> +static bool accounting_vdb(struct thread_data *td, const struct fio_file=
 *f)
> +{
> +	return td->o.zrt.u.f && td_write(td);
> +}
> +
>  /**
>   * zbd_get_zoned_model - Get a device zoned model
>   * @td: FIO thread data
> @@ -285,9 +290,11 @@ static int zbd_reset_zone(struct thread_data *td, st=
ruct fio_file *f,
>  		break;
>  	}
> =20
> -	pthread_mutex_lock(&f->zbd_info->mutex);
> -	f->zbd_info->wp_valid_data_bytes -=3D data_in_zone;
> -	pthread_mutex_unlock(&f->zbd_info->mutex);
> +	if (accounting_vdb(td, f)) {
> +		pthread_mutex_lock(&f->zbd_info->mutex);
> +		f->zbd_info->wp_valid_data_bytes -=3D data_in_zone;
> +		pthread_mutex_unlock(&f->zbd_info->mutex);
> +	}
> =20
>  	z->wp =3D z->start;
> =20
> @@ -1195,6 +1202,9 @@ static uint64_t zbd_set_vdb(struct thread_data *td,=
 const struct fio_file *f)
>  	struct fio_zone_info *zb, *ze, *z;
>  	uint64_t wp_vdb =3D 0;
> =20
> +	if (!accounting_vdb(td, f))
> +		return 0;
> +
>  	zb =3D zbd_get_zone(f, f->min_zone);
>  	ze =3D zbd_get_zone(f, f->max_zone);
>  	for (z =3D zb; z < ze; z++) {
> @@ -1605,10 +1615,11 @@ static void zbd_queue_io(struct thread_data *td, =
struct io_u *io_u, int q,
>  		 * z->wp > zone_end means that one or more I/O errors
>  		 * have occurred.
>  		 */
> -		pthread_mutex_lock(&zbd_info->mutex);
> -		if (z->wp <=3D zone_end)
> +		if (accounting_vdb(td, f) && z->wp <=3D zone_end) {
> +			pthread_mutex_lock(&zbd_info->mutex);
>  			zbd_info->wp_valid_data_bytes +=3D zone_end - z->wp;
> -		pthread_mutex_unlock(&zbd_info->mutex);
> +			pthread_mutex_unlock(&zbd_info->mutex);
> +		}
>  		z->wp =3D zone_end;
>  		break;
>  	default:
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
