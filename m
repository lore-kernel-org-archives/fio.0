Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD333C636CC
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjBGOGK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjBGOGJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:09 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A401F924
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778765; x=1707314765;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nQMTBfgnmMZYROdcsHYVvfrH0yI+DtfFLkt5Jv8pfq4=;
  b=b26YZQM9tfIplWonIV1/HlRAcMQAg7lQJzcpoXH+ywnzjDgCWHJ884DP
   tXNYGfM5Ytz3TvdosiK8VJGV/5plxAe4A75C8xC46ZZe/nv/J8ciVbtm3
   e9Hn4Ql8l+EmsYHj7N7CYppGPh2ddqHDG7jHl2YEpjJ3P80thlS2XlLX0
   xmKick86vba7R6uhJvQYNxUjiUqkE7KVSq0oxIbpzDhCMEIjWLqPwTesv
   AE90J2JZfePAWmK+SIByr3CsDJVxYOiQi/wPAGCnCbjiPTZS9omyvZHEN
   4zo6XySe81as6qof7STgkOKH0HKecMZUlBhPnwapR+nFyYhPuHFpotXGc
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="227685239"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:06:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiahmXDwHk151SDZoqPbThUyiCNfzo2x+guBVHvgPlAj3yNqHsIoFY0h+H9n//yyIgNUU2HskCDLIdETdRvTkiQiDIeeEkUBgp/xr+YVpnPBXBEObcyK/vPxODK/DGjpXEzMeBjwCLmcOysO5V2yMN3Xz55pA/P/Q7B34/u43EJR5om/56FCX7cB/SvKb3lkelopHKBDpMaRIlVvLEUho7utoMUb3VhkfjvIPSOffUrzL45rFT9nCMld29GwKTAlohzVP8O3HCj4xx71BgoPzxEwIIf5Gns+JbFA0wrwN6YNOfJkH9Ip4sUo9adhpaQS+VJzTBMUy3a5ZcZ3Tpojww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TBOwMEw3TgAWhLTl5WuArA2V0LUkYB7Y/K0URA0WJM=;
 b=Motd8g/xnF+Aun0FuJDl9hJTBla2w028lPDkTCRcpOrLUWKEFmrGX0WHx8kyGm/z0WXtcttPUIppNteEbN3q5S5pxGwkiQnIrJKzmpQ2cmIEwn+lUUX7lyO2B2hvW0p2U0hsjhkKzCk2LejrVR+rUeZd8/aZPHgQDAUgYFwC9ZaGuioNzZ2aKKM2oYHLXK3nvu0yH/TPq9YHdGDxPqY2bHqzTjnGPbcn3NM90xa1aA/AZe3pKW0ubLoIX5mq/Zq9x+r/SEgRdYC1HM4n1eXz0QkikNZZsJrqzpavUMxuQCR8iFAJ5Lfvepe/cTGB+6z+76iRZcE5c8iy+RVYsfUNYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TBOwMEw3TgAWhLTl5WuArA2V0LUkYB7Y/K0URA0WJM=;
 b=fhGWTcMu8ocl2MoSsWhtv46iu97R97Pxmd5Xy2WsBG0MM17KSltXRhHAJkkTJ0WdnyTVX20/i0OvBmh52wUbp+VfDkmjklTiBgJH9pIU9xfl3/Tm8vucnqR7yNaY3y6NDRLgggXS6qRV1kffWbqAlsImYSJVBifwC+8UepyrTgM=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7042.namprd04.prod.outlook.com (2603:10b6:a03:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:06:02 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:06:02 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 3/8] zbd: rename the accounting 'sectors with data' to
 'valid data bytes'
Thread-Topic: [PATCH v2 3/8] zbd: rename the accounting 'sectors with data' to
 'valid data bytes'
Thread-Index: AQHZOr6x65rj4v7yAUCrJtMn7a0N0K7DhR8A
Date:   Tue, 7 Feb 2023 14:06:02 +0000
Message-ID: <Y+JayPYxd4tzsftE@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-4-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7042:EE_
x-ms-office365-filtering-correlation-id: f7ce12e7-d60a-457d-b991-08db0914722e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u0vo6amXX5S5tqpHpSdHwWGAG58JpFqDeWZKK7Y692kLm4Un+ASMIj/on+2DXFZuR+baGhn45Uj6b7SKQZSETmFG4rcVlW2pyC+o23Cz3XPuAVs/aed3P/b6F8SZivTpqUIrRjjypPkoAb2YS/x1KHOI4XPyhCpSeewJYuGx7/n9i0NG8nFhcEUBrc59mLPpWmR0Q2rX/RuG3jjSNntybJ5XbJ6874rwvFzsgHqINagDHeUhn8cElXWzmpALcSWc3hFCSIOrVeEWC2WzQOl9zdCiRh91hv41ZpaTiDKnxACwWLE5IGRHE9x6DgINgpfHZ+3wbVOIB/6YYFsfbNjucHy/1xjIRYwAG3kANBjKs9WhPRFzYunrhDxJkqpNBCUWjKoTaaqMceCWgkMNieEGHArYUiGO8TMOAw1KZXhKUgcQHiAz6xH1R2GNbOeHtCTIC9kBev8C5ABMh5qrpJrEyUm4xKQfxfwND019CmQ54Cd0ejofgArVH3WEb46IPBxzC/7+gdIIQobzF2rI5X0OlTOkuFDzmMSlbYYheJdd4XoQBfRgmGVCU1a1c0SN+l5dJVU9ZuX3hbcia66H1EAyJRmoI2r6t+m+k99qSMsZe62wOVynmmnRYRSVl60YoUj0qVbjBW8YgUFiq3yygxz/EVd5IWfBt46nt0ABohH/NxRegLruR4FigbjFAi8W2oRfTIzS1h4J8G7QESuPNolxnLyEi2FkuVxEh0pvqq1onOA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(38070700005)(86362001)(122000001)(66946007)(54906003)(316002)(66556008)(66446008)(91956017)(8676002)(76116006)(38100700002)(64756008)(6486002)(4326008)(478600001)(66476007)(5660300002)(6636002)(2906002)(6862004)(33716001)(8936002)(41300700001)(15650500001)(26005)(6506007)(186003)(9686003)(6512007)(71200400001)(83380400001)(82960400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kKh4iOJJ44fS0Jnd4VazGRr4E53KtjinKs2QlNwRDNu6KH3w8UAwF92luaEH?=
 =?us-ascii?Q?aZUzXNMeyUVkdwQ9GbCgt0vIC/bIxw+F6jxrb+tPfU349QYkBnsZLolO/FDj?=
 =?us-ascii?Q?RjbQ3K1wZnDbcn2kj+qIxkBAq+2EFSKE7qsYbx7Zepl0cRecMFkiN6PY8lOn?=
 =?us-ascii?Q?xmBqB7gvbjQnQHTz6MkqQjq1s8BdF227KpPd5+pnTb6I6eeQthy02fFt2WUl?=
 =?us-ascii?Q?HtvvQvRGHVD1w/x/g79TdBMNoZiHaSRFls/kYXvojUfPHlx1SozQp4bxyv2V?=
 =?us-ascii?Q?qb41zWY0EtNCUYq88bCnNUPqzeLBRLlvoasjifsMRF++JsOLKXADFBLCIACu?=
 =?us-ascii?Q?IrvyQkZulKBE5MxpzrNu0EkqiW9fiu3NfoHBNfpzUoCF/fjUPk9n0jlS4g6S?=
 =?us-ascii?Q?T7E37SXBWEUQnOsq8fAqZDMNXfbE6nT2MaXNSd8/yCMHz9NxexutKiCuUifD?=
 =?us-ascii?Q?SH3IoYik8P4RTINYkWG9iUwl9t1v449dHsvYmmroh6FfQZLGREPTfVLUDUDa?=
 =?us-ascii?Q?GmiZovViZlG/CHfXdnyi9fqFjFuOtlnc4AulOI6V+wwzs+qP1ZlML2Bl6jHb?=
 =?us-ascii?Q?VW6ZvErrIdFJMGgrn4iYGYsQbghIfXSMWViN2VYGiZa/rx4A0sBpodxRMstT?=
 =?us-ascii?Q?/JklOd6aM1cYY0y1AnhgyIutAvvbwEYRI4mV7Uw3fhm9KifIvyWP1GkXPD/n?=
 =?us-ascii?Q?+A7NXqsMHprSd5NoVzClAeLkD19gdxmee4znqcovFtrBldVyjUYr+OPdVd1V?=
 =?us-ascii?Q?MTdsbwOvGSoKC+uV4EXU7s3CMkJO3hQ3gMT8Qq5PD18vAAG7fmh2bPraHm+2?=
 =?us-ascii?Q?EYTh4PMgE5BK220piKEod6zB5Lmfw0r+cCqOpeufv/rjceSecz8ux7b5Bf8I?=
 =?us-ascii?Q?5XVGst4la9/+V+ZgbjLK+H1ZIULAM+zqshH0elbaY/2fGcC+8nwRDX94PWYw?=
 =?us-ascii?Q?QmRhnFfGJgBChNyNI0UhRW/q0gaiJCiA1sst+gAb3BFAps8/eS4CzaHZexAI?=
 =?us-ascii?Q?eqPOj+8KZCnIZM6TjIrp87wa8F5Gz0lUP/N/ydJDIlIPMsiVBH9UZ9RJMxU+?=
 =?us-ascii?Q?S+87gMmnNeGkQjhfuJUVMYJNXxC1Y5ggawsrITJvCvd9VS3QhjIxbecAqtXh?=
 =?us-ascii?Q?79nPd3og5kLttXckB2XJAZ4AI0U02Eft6Oj71BlAO18hN/6afZ0uxB8j3mjj?=
 =?us-ascii?Q?8f8AetodIOgnIzQIU9D//M5j/kRzMDjamJOHsYgzT7oT19KGvdZZEgZI0qKf?=
 =?us-ascii?Q?rMRfKAy3Zli9Wre6f6UXpMGyb4ceqZPVdMWDu+HYHDWGsdZUazT40hOF1Zok?=
 =?us-ascii?Q?n9xEavLg92GIsfOOSzSY1PtqzFf0+QE8H0/BIlWLtwmdqWa4DpBpn1XJOzh6?=
 =?us-ascii?Q?m/wF/54Msjh5CqSJJyLVpibF9Vt8vPDEnpzcNhcFacQy0q4hCaIuNJemMY7w?=
 =?us-ascii?Q?DXx7PYgOIaXvbXOzTKjr/AbjO3A/qy8et1l2XPfjIC92PjSTplp7uqQAFHkx?=
 =?us-ascii?Q?CysxoVmkvyz8G8erKjuExX9oPCMe4bHapo9jeM38pakJs6bm5iP25PtOQ5Jf?=
 =?us-ascii?Q?3nTQmE3vC/2fncYgpGSEK35NB669hzZzMNo/x48E13IvsqgcYlvUjsttLXgZ?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7149C296EB1654289D64D76E91A6E8A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: maQtYycvOnzxfu9n1v4VC+r+lZDRStZYajrGSYI5khFeBXStb5m6pFy1F+kIbgqEi13kbvUEivv+e3T5c7qIZT6fhziImTyiuXo839o/T7AGBKTpzGoljj4dMOUt6ydmM8kOK8inIlZxoxYf0xTMYi6IxFJ12Pn/TU8XRwmIa+H4psaHGtdCEVedIZoI1qatKFPGltQhqkl1NyH6B6tKAUdCIRMMfVb5Kj8FxUF04QR9O7QCC0xRR3Hq9ou8BSjjrxZDpzQuSeE68rd/76IuqfJmb4ju3P1lSj5xnZQaSRwXPJTn/aaz4i6IsD1lL9eEhxQppsB8zl2eEkSzFimSQrlwOXarKOYg3fLKKpoapfGJerBMYmBa8LgYyX8y1U+qJxxXDB/8yc0B2W1t8ATyvpKDvPz+UxUF+SDF8aGvWI/tooHgoHG6X2nnBGCaWpod3Q0YwbOi1Ern2PFhiD8BZie2TsAGn5FwZBbDF3qyv6WLcFY5bPffYrSOjcsOtfJgJE5iSmntsCFg5Jt3bYqD3HsQsOzb10Y4wobWWH40lIg2zXvPCsnJAAscnki8xVyN3nr0EFq4dF5NHvKAGrKBrS5udu1blmGdyMkKOPrc4sEr6MUsgUJl8jNUyOdi0uYgvRRfhhh7L0e8IV0K6+yP8fQ+RPTn7R/4Psff87UDGe2YgVHEwZgKSps22b7FiumbESfb00tryE2RdHOrriMz8Qeuc3ypN2VXFMzN4h5sP7DmfHg9qZo9/5mAMSMAodD5EhvLt5vxAaW3BFLnv6mkaUeXO98wwXc/R2f1G7/vGqfr5kgybFrXMUyvmLx80adM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ce12e7-d60a-457d-b991-08db0914722e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:06:02.2249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QX0SeaOiMrje5cHkt1h6kkVw0L2Vbm2LmpU+Pj5eXkAduRSN22Nrww6IvKBrc1qCej+szHIidx2M4eNoEU032w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:34PM +0900, Shin'ichiro Kawasaki wrote:
> The 'sectors with data' accounting was designed to have 'sector' as its
> unit. Then related variables have the word 'sector' in their names. Also
> related code comments use the words 'sector' or 'logical blocks'.
> However, actually it was implemented to have 'byte' as unit. Rename
> related variables and comments to indicate the byte unit. Also replace
> the abbreviation swd to vdb.
>=20
> Fixes: a7c2b6fc2959 ("Add support for resetting zones periodically")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  t/zbd/test-zbd-support |  4 ++--
>  zbd.c                  | 25 +++++++++++++------------
>  zbd.h                  |  5 ++---
>  3 files changed, 17 insertions(+), 17 deletions(-)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 4091d9ac..c32953c4 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1110,8 +1110,8 @@ test51() {
>  	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
>  }
> =20
> -# Verify that zone_reset_threshold only takes logical blocks from seq
> -# zones into account, and logical blocks of conv zones are not counted.
> +# Verify that zone_reset_threshold only accounts written bytes in seq
> +# zones, and written data bytes of conv zones are not counted.
>  test52() {
>  	local off io_size
> =20
> diff --git a/zbd.c b/zbd.c
> index b6cf2a93..455dad53 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -286,7 +286,7 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,
>  	}
> =20
>  	pthread_mutex_lock(&f->zbd_info->mutex);
> -	f->zbd_info->wp_sectors_with_data -=3D data_in_zone;
> +	f->zbd_info->wp_valid_data_bytes -=3D data_in_zone;
>  	pthread_mutex_unlock(&f->zbd_info->mutex);
> =20
>  	z->wp =3D z->start;
> @@ -1190,35 +1190,35 @@ static bool zbd_dec_and_reset_write_cnt(const str=
uct thread_data *td,
>  	return write_cnt =3D=3D 0;
>  }
> =20
> -static uint64_t zbd_set_swd(struct thread_data *td, const struct fio_fil=
e *f)
> +static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_fil=
e *f)
>  {
>  	struct fio_zone_info *zb, *ze, *z;
> -	uint64_t wp_swd =3D 0;
> +	uint64_t wp_vdb =3D 0;
> =20
>  	zb =3D zbd_get_zone(f, f->min_zone);
>  	ze =3D zbd_get_zone(f, f->max_zone);
>  	for (z =3D zb; z < ze; z++) {
>  		if (z->has_wp) {
>  			zone_lock(td, f, z);
> -			wp_swd +=3D z->wp - z->start;
> +			wp_vdb +=3D z->wp - z->start;
>  		}
>  	}
> =20
>  	pthread_mutex_lock(&f->zbd_info->mutex);
> -	f->zbd_info->wp_sectors_with_data =3D wp_swd;
> +	f->zbd_info->wp_valid_data_bytes =3D wp_vdb;
>  	pthread_mutex_unlock(&f->zbd_info->mutex);
> =20
>  	for (z =3D zb; z < ze; z++)
>  		if (z->has_wp)
>  			zone_unlock(z);
> =20
> -	return wp_swd;
> +	return wp_vdb;
>  }
> =20
>  void zbd_file_reset(struct thread_data *td, struct fio_file *f)
>  {
>  	struct fio_zone_info *zb, *ze;
> -	uint64_t swd;
> +	uint64_t vdb;
>  	bool verify_data_left =3D false;
> =20
>  	if (!f->zbd_info || !td_write(td))
> @@ -1226,10 +1226,10 @@ void zbd_file_reset(struct thread_data *td, struc=
t fio_file *f)
> =20
>  	zb =3D zbd_get_zone(f, f->min_zone);
>  	ze =3D zbd_get_zone(f, f->max_zone);
> -	swd =3D zbd_set_swd(td, f);
> +	vdb =3D zbd_set_vdb(td, f);
> =20
> -	dprint(FD_ZBD, "%s(%s): swd =3D %" PRIu64 "\n",
> -	       __func__, f->file_name, swd);
> +	dprint(FD_ZBD, "%s(%s): valid data bytes =3D %" PRIu64 "\n",
> +	       __func__, f->file_name, vdb);
> =20
>  	/*
>  	 * If data verification is enabled reset the affected zones before
> @@ -1607,7 +1607,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
>  		 */
>  		pthread_mutex_lock(&zbd_info->mutex);
>  		if (z->wp <=3D zone_end)
> -			zbd_info->wp_sectors_with_data +=3D zone_end - z->wp;
> +			zbd_info->wp_valid_data_bytes +=3D zone_end - z->wp;
>  		pthread_mutex_unlock(&zbd_info->mutex);
>  		z->wp =3D zone_end;
>  		break;
> @@ -1960,7 +1960,8 @@ retry:
> =20
>  		/* Check whether the zone reset threshold has been exceeded */
>  		if (td->o.zrf.u.f) {
> -			if (zbdi->wp_sectors_with_data >=3D f->io_size * td->o.zrt.u.f &&
> +			if (zbdi->wp_valid_data_bytes >=3D
> +			    f->io_size * td->o.zrt.u.f &&
>  			    zbd_dec_and_reset_write_cnt(td, f))
>  				zb->reset_zone =3D 1;
>  		}
> diff --git a/zbd.h b/zbd.h
> index 9ab25c47..20b2fe17 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -54,8 +54,7 @@ struct fio_zone_info {
>   * @mutex: Protects the modifiable members in this structure (refcount a=
nd
>   *		num_open_zones).
>   * @zone_size: size of a single zone in bytes.
> - * @wp_sectors_with_data: total size of data in zones with write pointer=
s in
> - *                        units of 512 bytes
> + * @wp_valid_data_bytes: total size of data in zones with write pointers
>   * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2=
 or 0
>   *		if the zone size is not a power of 2.
>   * @nr_zones: number of zones
> @@ -75,7 +74,7 @@ struct zoned_block_device_info {
>  	uint32_t		max_open_zones;
>  	pthread_mutex_t		mutex;
>  	uint64_t		zone_size;
> -	uint64_t		wp_sectors_with_data;
> +	uint64_t		wp_valid_data_bytes;
>  	uint32_t		zone_size_log2;
>  	uint32_t		nr_zones;
>  	uint32_t		refcount;
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
