Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAF8C433EF
	for <fio@archiver.kernel.org>; Mon, 30 May 2022 10:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiE3KOH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 30 May 2022 06:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiE3KOG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 30 May 2022 06:14:06 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DC14505E
        for <fio@vger.kernel.org>; Mon, 30 May 2022 03:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653905644; x=1685441644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RtgQF0FrHbN41GuH/LtqJgj+jv3Ix3dRtkM293vglII=;
  b=oLld9MeqYJLvNpcu0DwkASVZy3WzCjXxZsB9UgEUJUSy/Uyr2vwJdTvD
   qU7PhgFN9/4BkdPjVxEZI3QP9iGLNAgG+qN+YCZS3/uMiBjCsmJVL2ga7
   PkOAEYRGGbheQCm3wN6E+Xd65LwJiAQ4DsIybrRvpd5m4VELS+VDjvyfb
   1nyOtJAjDkHwZ/tIZ3F8xBo2G1wmBf/xyrk5FU7EXryxX18/wZFLSb0Mm
   CW+UV3vu39FAKzv+K9YrQ22sdJW+s+88eO5EG15kW/bIS+wplZ7WH64xM
   tlGc1+0XGMSdfTjeXcmMwqL5rkGFyXPwVxjYfnP1fhphmrA2qlo5dfxGR
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647273600"; 
   d="scan'208";a="313810723"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 18:14:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2LATTIDbzveNa5utKttOEY+UXROPSPAVbMY21VxZnIHtbLmoFqtD8zU/7pLKvV7Ln+9RsLtEqA4a9ezDlORmJhHRIBe7oow344Oo+dghYWRh4NnG2UESj/FdaqOKRnQf8F/l5opZDGBsyGVHd+dPuc2nLI6NSp2n6fZoscrHMbf+gg8vvfQt7WMmLIpdOggHHZ2xqyGxzi1D5bzPx9Kh/NQacHi80fjq68ahENfo1v+cQaaP72QKGvctgodpZZN/K3SFG2FwyebOeQYK2ay1OanMTtyvtMcqjMQOj+sRS9+ullk7K3j+l5uUxKmeHj7yfZRWhW6LAB7RCG8WLZ/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqzrh6YFyCIKleVki/eAqCZuqWU9MXJz7B+dIbxSQls=;
 b=JMeaB8qV8MZYbO5k/Av/3ufcIArt6UO9bXgL1U75vmbPRdt7EfEvznDZCF2G1wN6f0sdF7qJ73OWDGeB+I94q9W1PKbhDOPb6o33E+T62TEHBw6U3BW4kFIjkGxgs3xjBlmhuz4CEMHUcsyJ7YrmjPNAZC//sPjLtdOiYuKZtxZ19NFqJ/kcZ16DxpFZ9Dwjzj4Zi9rjbQiA/jtPw9GFnWGck6iglR94lVvTA8G1sGIiBGgO4QS/sDRqTCc7YwD1M1b4Ee+XyArLtwfY8uAfEs7X/Xg1/id27CylNVI85WWNN96WOxqm42XnV8+7/pi98QglI81IGB6j7knRsQQ1uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqzrh6YFyCIKleVki/eAqCZuqWU9MXJz7B+dIbxSQls=;
 b=gYSYbY7906+BZ+AnEpynRr2R/ppuNo3dy4Hfm3Yto7D80eQYecPqPQu04lWGiWUvockXzSjgs1eG+4xOhOHExnnyO+h8wrV2d/Cqo1zqJEuyCpiVXLoCZOlNRgMP4spY/nY78KITaqWQLL3aCPVSXwje8Izkb6f/lrK0dvYzQRg=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8306.namprd04.prod.outlook.com (2603:10b6:a03:3f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Mon, 30 May
 2022 10:14:01 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 10:14:01 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: Re: [PATCH v2 6/8] zbd: Check for direct flag only if its block
 device
Thread-Topic: [PATCH v2 6/8] zbd: Check for direct flag only if its block
 device
Thread-Index: AQHYcSB3o4Tp4NvyKUWY+Z4mroeD9a03ObQA
Date:   Mon, 30 May 2022 10:14:01 +0000
Message-ID: <20220530101400.ft63dkg5y3dhjjj6@shindev>
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
 <CGME20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38@epcas5p2.samsung.com>
 <20220526144809.14877-7-ankit.kumar@samsung.com>
In-Reply-To: <20220526144809.14877-7-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 862c9bef-645a-49f2-4594-08da42251e30
x-ms-traffictypediagnostic: SJ0PR04MB8306:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB830637658D2C115F2D1E643BEDDD9@SJ0PR04MB8306.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wnpn8HstJysx/661KeTHcvfQksPcWOi09L8KI+0+lK2XVYjigITfA12v0QWKV2v8RXDv0jW3O3406zyVM6E7uVsREZ5kixWr8GgkLtP/Ug/Bqxlgzr8m9/nZxrvEpqIAqs+vzfLkrtboZ700nv0IUkR6MKsWSR4/OMDfIKtUWzhmnLboWpoxeI8Lf16AOTfAHiApxwi5zPYHPGuENl3jvLdJu56HqAODuUeB7+bIPI8r/7/dupyVISa4aEJB7hrcinEsPwccHxb3fKcV2kUjkm4J6SPos8wESENWurc+bq2Alo/eDAcEr/tgugowAcmaf7xfdVoTgWlxBTbTZSR/BK3uc458naA5N3bn6+OozPImptoJuKddsBfrLcvtwQfcKziSRoCKhG9RGQqTyHdDBeRU91aYv0rP1XT6YjXmnTgCBe9m2CBM/v/8cLZ7tleUPrObTISELMrtaFv1H2XLfzfPM3lcurI6mSzdQ/1XddwtAxyRWBDu8g+HD03WL+1Afp1FIn3034CgK9hpQl0zJgAmWMwQ+xbS8COj5N1wEULnjpfBCgcyFd05GQED54tv+utrWfv8GnXfRJrq7mFbiPBO4CkWDMQA7iDmrBMbldqLYDTsx3/8JaNnqEPKj6fQ9PJJjC6ocL2A71iLCMZQ1zKcyUO2eV4NgsNRhTCZ4GaWAv0QJ0/duQayYTbC3PfDl1LLeyr+J3PXGfrbDQFFDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6512007)(6506007)(9686003)(316002)(2906002)(33716001)(54906003)(26005)(6916009)(122000001)(38070700005)(83380400001)(82960400001)(38100700002)(5660300002)(86362001)(4326008)(66946007)(76116006)(8676002)(91956017)(66446008)(66476007)(64756008)(66556008)(44832011)(508600001)(6486002)(71200400001)(1076003)(186003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W7sWYNnBaok9FzfZe/2yxb1MIxgNCj5wzp0ozY6BaQDGNGjhoKuXaR20jiQS?=
 =?us-ascii?Q?ZEvXPUwL3RCXnpD/7CceN4AEs7Q5MKfZZrCaVkrtDFnUv/OZu1bPCZ0zXkpS?=
 =?us-ascii?Q?c5XR14w8gw55c6d8T/JH6/o5KdbkRWCFgLW/MhuL7nmfCsHRGCZRQQlKV+YX?=
 =?us-ascii?Q?vYXUNgCR/ViPfSWMWX2goKRBadtijTlAL/yZETLUw5MyslC03kVZd3k0pFpb?=
 =?us-ascii?Q?XJ85PtnDLQ0hJvm5fhdOamQ0ZgkVe/h7rvvUbmEt2EK0qStK41tDjPZ5Hint?=
 =?us-ascii?Q?zELJGNLow74Dh8KXKUH4cdFRm2gQ62wxbIffMR8LTw12SBQ9llgoj3FkrVaQ?=
 =?us-ascii?Q?U5i5wkIzDbe2bw3XH/Wq0BvCAFKyKOlYckE2kxlpm2tgGVKmrNHEpzK9ya/v?=
 =?us-ascii?Q?uRd0ovb6CsDx5RNHAcCnvZrpblwUVfJUd5AXf8nrPWfxk/fEt81CvtXhvt1x?=
 =?us-ascii?Q?gbDqhS0xXeN7IT37acENzQmo8WtD04BDjRlxsnq/nVzuhEg/yJ5cqx7DvGlA?=
 =?us-ascii?Q?x58fIhLMUngd6KsTUMbCRELCfurlS5wFELAYjRPB4jnMfY3mSJabZrdOCdv9?=
 =?us-ascii?Q?X5HFz0zDqmrofQXwYI3nOYR9Jh02RBGeahaFcOdvHLmlcaKj4T3OlI6b3oR2?=
 =?us-ascii?Q?oCfz8VfOdmr4vwjW0xVyr++TPB3/SWUookD9mO75BWZQxiBjpSsmb5oN5LUG?=
 =?us-ascii?Q?6sTAdLw5tJgqu42f0YjH0NfSz7K5pGWMq2VBltWxSzvatKUbrjocNSqXUAp5?=
 =?us-ascii?Q?TFLX3IbCCT/cj8MUhMMY+ASdQTJmMn1v21PQiGJLoKcggS/ivb6A+iS/G7mM?=
 =?us-ascii?Q?KUeenRJQXfAkuGReEU2M9dfvUnW4u56rYF3+08p7f8Sj+5ZQ1E+ugjlujIYk?=
 =?us-ascii?Q?BlICWPpS9k5OXHliizmDJ5B18ah5/hbyWHJNvPTuEjrwZBWxSWL9oeq0dtM4?=
 =?us-ascii?Q?v1e3gkUUm0+JQyykhCGwqWRZ8UrmQsmtohd2ZyH/LmuhwJDx9Bm6R4LpzR+E?=
 =?us-ascii?Q?faI57G7Tap4TEXt1/OIzghI8J/9mou5EeBXh0KEvDr6x3ahxiFCN45CqYOKQ?=
 =?us-ascii?Q?z8y+N6OSMmR710V4pKGdJhRoEvuJfC3cui2SmPvH8PDFTY+G7Y8BNfeVotOh?=
 =?us-ascii?Q?Cc0aVedYDCuhhTKnSZEjqVh2oqBgjH4blfO7pmJnrLiYhp9h5cZApMz0x1Kg?=
 =?us-ascii?Q?rL/uIT4ysd5DP/qVfjVkMAgJGhTEKM7IMS4Y+jsoAyqD8EzLIyHmQaYp+EdJ?=
 =?us-ascii?Q?7Qa/ritFjTaTTpBLgN8Z3N2m6e2f0VoZI7PIystzBiGpPZoaat8C420lX41b?=
 =?us-ascii?Q?ew7I1fyN+MPh+1tmcPPSyL75u2bFQM9ZTXFd+hYqsq+uP1ohdU9/zkojHKMc?=
 =?us-ascii?Q?nJo4aujw1Lo4+6ia+Yeh7UZZnr9KpWFRwKr91to6SAgMrcSYKVNWUSNf+ut4?=
 =?us-ascii?Q?AHK3DAGvYe1s3QtP89yjefFMWu7QHfpgnl/6VvCBKZd8z3C27+HJLpXG4cW7?=
 =?us-ascii?Q?sIjqv7aD/5MVUMu0xK0/rS09QgwUs9/dGG+0IazuYtYX7mGJibpzQ3KtfA9U?=
 =?us-ascii?Q?pSFVHK/43olv3WOOksejpmBgyFXBhgnAtlpZWCJDkAgjlT8Tf/P1YJf7JkjE?=
 =?us-ascii?Q?mccOsDJCDqSqGaObVVIboJ7f8hgTwr61oQrV4ojbtKIogbKHqCANolaHt8bF?=
 =?us-ascii?Q?FQR5GMc86nEQwdkhgXRiGJdhLrJfeMgSOBNyoQTjBdsxIdPe9gvVumoAymv9?=
 =?us-ascii?Q?Hd3YbFNGkqZ7GMcw/R49qfm8vPAOCsmjkz2sIPnEvp2quKsX22BQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B8BB3DABDCF2E458CF268405D2F3085@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862c9bef-645a-49f2-4594-08da42251e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 10:14:01.3424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+L8lcG7SUNM9totZXTf/fEev7f7PUAlYYVSuMXrdaiBKfQaF5D2NgVuyOaTD1GhazHfOziuhgsbsvX8bt5GFihP/utsCjoAaE1ofjw5UL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8306
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On May 26, 2022 / 20:18, Ankit Kumar wrote:
> nvme-ns generic character devices currently do not support O_DIRECT flag.
> Check for fio option for direct flag only if filetype is a block device.
>=20
> t/zbd skip test case #1 for character devices as don't require
> direct I/O.
>=20
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>  t/zbd/test-zbd-support | 3 ++-
>  zbd.c                  | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 7e2fff00..a1ec5684 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -251,8 +251,9 @@ require_conv_zones() {
>  	return 0
>  }
> =20
> -# Check whether buffered writes are refused.
> +# Check whether buffered writes are refused for regular block devices.
>  test1() {
> +    require_regular_block_dev || return $SKIP_TESTCASE

Hmm, this change skips this test case for character devices, but it also sk=
ips
for zoned block devices. Not good. This test case should not be skipped for
block devices for both zoned and non-zoned. The word "regular" in the the h=
elper
function require_regular_block_dev() means "non-zoned". So it ensures that =
the
test target device is a *non-zoned* block device.

To skip this test case for character devices and run for block devices, a n=
ew
helper function require_block_dev() will be needed.

>      run_fio --name=3Djob1 --filename=3D"$dev" --rw=3Dwrite --direct=3D0 =
--bs=3D4K	\
>  	    "$(ioengine "psync")" --size=3D"${zone_size}" --thread=3D1	\
>  	    --zonemode=3Dzbd --zonesize=3D"${zone_size}" 2>&1 |
> diff --git a/zbd.c b/zbd.c
> index b1fd6b4b..627fb968 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -466,7 +466,7 @@ out:
>  	return res;
>  }
> =20
> -/* Verify whether direct I/O is used for all host-managed zoned drives. =
*/
> +/* Verify whether direct I/O is used for all host-managed zoned block dr=
ives. */
>  static bool zbd_using_direct_io(void)
>  {
>  	struct thread_data *td;
> @@ -477,7 +477,7 @@ static bool zbd_using_direct_io(void)
>  		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
>  			continue;
>  		for_each_file(td, f, j) {
> -			if (f->zbd_info &&
> +			if (f->zbd_info && f->filetype =3D=3D FIO_TYPE_BLOCK &&
>  			    f->zbd_info->model =3D=3D ZBD_HOST_MANAGED)
>  				return false;
>  		}
> --=20
> 2.17.1
>=20

--=20
Shin'ichiro Kawasaki=
