Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3C4C7EE29
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 13:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbjFGNPl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 09:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240324AbjFGNPh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 09:15:37 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86B51735
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 06:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686143734; x=1717679734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/xfhu/nQslbYMH7WuKBFsP8C9StK0DFpGBU/GtPStLM=;
  b=PPfALOGO8CgkQ4aboTXJ5ZxmdXOQ/BxYWDoTgixSYIrenr0R3A/xpIkB
   gPcbBUJDlXijZDsRq84648NR5J2k98knthQOI6r/B3Q0mE91fsj7ITFOa
   zf7IAe+W5CiuJsrgwIaXmAbeKf+nMHynmxjdk1koNM12t/pP6zzB/XH6U
   oXUPpCvJ67ZKjm9PSZ5MbCKF89K8v96FUMqQvMsamFq06kmWppfG2oGBh
   HEgBKXASsE1baQJl1/vJY3dFwKia7ClvvJmmbpj9fLdFOZZ1XdMFv8Mqv
   9V9vfXFQM2pY6b86ZkOYFsTf25Gs8vjqfVlwfaG8TVTwABMjzl0QOxMR5
   w==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="231116925"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 21:15:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPvNmRKVa+ilMIRwd7RByg+q/KkcXKrYy6G1coEKbqGNvdZnNHxCo59r2BDEWTBnJgBKUGibHGZcFx3a+fTdxZjudhzRyMDoRhnn0zd5DpJORYxZSo7KGe5+wGBclqKSFOeEbnxr0OnUMariB+lTZQWsuXWH+ty3wsafldSJHGaoFOSqAS1K5uxbcgtz8iPc/403V93HZ/HWnbDI9x/Awu/X0I8EflW+e+ozHIc0gUsXqIQE617qBAf5QC6uvy+SyQrcjDtZXGN1AoI2WML5gYk2r2LFIsvbjtI4vOYwKegImRU9aXJKLVOGIKh5n9qU95F2aX85CB5zdTvwrGmPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDz799PKTsALZl79oC9emnrF1xj6Ka7d5X8C1lveSV0=;
 b=hgKT6t4VclGEnOLRohnzUhqx6tdpMFTjtqNaV6MoWHG/qm9Aduodj4Uj6m4tyxtaUIFcCaj/8d8rB2rd3GwK6eva8xcGSDxs55q9NihpwDqpQSIxnBPH43FbxjP9wo3ZGPH/vtRSX9MJos5smLDgAMiH7vFSMGgQaREZ9I5BWeYPNH9Rb6WmycxySh1tjSAqnLpqpD1Dz0/iNQw7qgyOI2PqzRgORE/Ejfe+GpCC9LEwg2Hsol8n/MHvqipwRQHo3uyHSdxJTDQHVR3SzqAg3b+o45TjiXaZtOR1DhhLD7mqhJS5PXsktWipJlQEiXuOea8XlQKz7f7YD3HHTSEvZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDz799PKTsALZl79oC9emnrF1xj6Ka7d5X8C1lveSV0=;
 b=wkylVLhWx75C+w9niC4Y2Eh/UY5eRYFvpyHrsl6hOyjK/gaEMsOZBRb1IXJIFeJPYbarMHCOnlfiakwtWmCGtmnSq+PXZxCiSwZHxMUWd759wglCvB4BtHi4EFa5sFFIfAMJcWfDgejk3H+AXw4TpX3rwHWr5XS5MKYEqzt96Eo=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7636.namprd04.prod.outlook.com (2603:10b6:303:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 13:15:31 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:15:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 2/7] zbd: do not reset extra zones in open conditions
Thread-Topic: [PATCH 2/7] zbd: do not reset extra zones in open conditions
Thread-Index: AQHZmRqdb6py+6+oZUqO5Np6GTZNea9/UgcA
Date:   Wed, 7 Jun 2023 13:15:30 +0000
Message-ID: <ZICC7EVX4HQa2Cc2@x1-carbon>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230607083230.1178573-3-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7636:EE_
x-ms-office365-filtering-correlation-id: c1ddccdd-95b4-4749-2df5-08db675944eb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o7t6VLmeo4wtXDOcAdjfsCDMmEsy83pBoqgEKgfZuss4ugnI3+QmcQGB3Et0av0x3V47wJeyWhHXhBR5Rv2ysjXPQcQdCLL/MfcwM/wCpy5z5rnwR6qP1BCR9g5gBW5Yb+JLeco3U4psF5RTQD+yGIh201BeQ9nO9au4h+B5xUFUw6D6bAGs0uXYVTbUcYsfkZKQDBHBfolIJTNgglVI4iVXTQVrPLvgPHLl6mnfuYc02JflDgKNEi5p7g1F3VNWMIfRccJWrgMfTLD00HbR8FJf6gOyyColKACbRNeavLq+i0/Xm5Zv6WPnqrXmTnsbVqqCf7znymjui0xvOV8uutJ9yXcH8m4QseIFG4H6TqkiiO2GDI9oD0YVPwBIo6RdPOl/iXw8VAOwcAiNGkdXQ6Xi0YhCfq8zejieHSp6976qKCXG3ZU6gBG8KiHLNshVoNySBV6CalVtcA7QD6AzAg++tl7cLl61FkG3o9V7yQiohEtRu2BYKguHM+t9CyO1OWbd+itZ0M7rVL1PKIjMCdLTq7OoM//OrYPZvFSZCU7rOJlO38j175JH1GEdt+UN1tinytpA8itjOB9J8Eo7gZzpZrcnThwanMMs870UnnLS1zWQKb5agVCv7KENAk6g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(6862004)(8676002)(76116006)(6636002)(4326008)(66556008)(66476007)(66446008)(64756008)(8936002)(66946007)(91956017)(316002)(5660300002)(41300700001)(54906003)(2906002)(478600001)(26005)(33716001)(82960400001)(122000001)(38100700002)(9686003)(6512007)(86362001)(6506007)(186003)(71200400001)(6486002)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hkUqApf9iw8PZBwLT4rLTzIb26ph6kE6OdMUiJhs2FT/vpbsSWwcwwJ10hG8?=
 =?us-ascii?Q?J4b4j8NSyiAX5N2eX69Lg3IF8RnZC8nJNlOkF7xaDvqvuubuJzx7jE9o6+o5?=
 =?us-ascii?Q?JUfuQNdWHOVpl8/yO9JzqIInDY7aDe6OUYqa+caqHpesqEscS6b964vaEZxS?=
 =?us-ascii?Q?dfBgnr3UJaNIlyEuY4XQpcLQjg2vJCxrPp1UQDt4eZhHSesZEbJ15ORyuQMX?=
 =?us-ascii?Q?iTjAVwYSyr9AipOKiBPNdLLxCz5Qn4VNQhrFs95P9zqmJA1IbwAUjTqJBoFA?=
 =?us-ascii?Q?7BlpsiSru87A27N+lsjc5XMTGnNvejj6j0veSHA8qvoW22jYqoRl4MIdGFE1?=
 =?us-ascii?Q?n/g7kGHFqhgGX5061xxpQlADyskPYSAcbUb/I732Na46iShBsMBzrw67aIQA?=
 =?us-ascii?Q?jxitlR8R9HtGGvmqLVXQ7kW82DEUEsRZaqwMYFor0vKy6IzcwwMA6eHbt8QK?=
 =?us-ascii?Q?CyMtApYp/gNWMfzKYqLbG3RC80WFW9Rud89YzNQyBK8TSpq1KkgTrL28+N+O?=
 =?us-ascii?Q?GtQJQxF/PGF9LuiS4hB4ygc9YNaT8vM4dDMpCzFflRNk2MMAxu99ihqJA+0N?=
 =?us-ascii?Q?GmdUEprvPrGJq916UfZL7SdQ7i6kHzpjm5x4JUtfrc37X+pwRN70xCoyE/CQ?=
 =?us-ascii?Q?UufYQxoE0+nsjv2Tc1R4n5E3CbrETQfd7umX6dz8BhmzEeF6gM12Gcq44XCw?=
 =?us-ascii?Q?/c78Ko6ZO9rWf5wrmNNWvk04qgRSAJEWgfbaW3RENEysoERFiOmGu8Kkd/sf?=
 =?us-ascii?Q?4eWRW8qMSyK2l3Uyvfssz8DfwyiZ/JSa9U46b/Ivdd0T/W82HEhRnvYn/DXc?=
 =?us-ascii?Q?O5otI5d5h6Y0SZ1RqRZOfUOcUBwH1G8MZMC9tEl0u5NSLltlQOQjuP++9aJU?=
 =?us-ascii?Q?6PxfBoFUD1/+AohoCRzX4sHC0hWjhr3G+V9YLSoQPbmKMKK0wVD+D6eOvNTM?=
 =?us-ascii?Q?HEWNkpqSuaDZW7dpSSU0Wt9Hz1fagGIeDlAKEqIkU7ugS9FkXcbumZyReYaV?=
 =?us-ascii?Q?WU3f4ZaDNuSKU4NC9eOEsDotzVMnx2Lh+rUntqXBYEI43hcKhvFoxbWoI5P9?=
 =?us-ascii?Q?/KIq0Qjjn3TvnRWvV6ELeT1AbxjMDi3iMmq4i/OUpNSn11w+lDkaiLs/B4Pl?=
 =?us-ascii?Q?OjaCd/bj29bTRRS2RvR1E+iuTgZxQwyb9KGr8pP8peMxf5aqxt42J0mJLawc?=
 =?us-ascii?Q?LYFAEnfqRA80aOw4hgy/2jPB0uqed+tGtyIB3CQI7WN9WYdVMJwYoBN+KI4t?=
 =?us-ascii?Q?KQuxVmmmVl18mTdnvjp0dRDthJCfZd5mmaHG0jKQEkTexfE8sBJX+MTQp5ar?=
 =?us-ascii?Q?Lh9cDASQlZ5Wxz7Aqm+cUqiBbv7Gs/ALnjT0PwoGIecA2niNrs8ivrfPYNsl?=
 =?us-ascii?Q?vDLH9XEtZod2Cv3owpBmUd5iqtQkbUMSMvv+fB8TOoqF9PSGk8dx5tOK+x+E?=
 =?us-ascii?Q?0/8UB+X4bY6tWtud6j1Gr8Tm2w4HZdvpx3sDap4YiaAUcKqL5nVEDz4Ddc9b?=
 =?us-ascii?Q?/XFi/AcFV8oZ3+HHMhWvnTFUZlB5kAVQleySnR3uP0CuFb7MSKopCd0Wta60?=
 =?us-ascii?Q?NgGTppeMXT5NMTCr7FxwYriRnd8cszTw9PANSdWgjk0unlWm6uled5J/nTf9?=
 =?us-ascii?Q?Bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3288264BE98BF47859C23BB8C987C74@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TzSzrRKZXg2x379F25ZAhSukbFtLyV8g2h/NsX3EFeVgwQrPNE+jEb+rp82e8DaOMH1odcUxn6USxcB/WyOhGfyP8zc8xVs1qXjp0J//DcpaL8kgHeXr1Jo/otXgNw2+DrI+ud1SZ13ez8rTGbDPmI2Dw4h2j4K7gvZROlQQlPaVZTwVnlXUqAsK2jYmrsGhbiBSBVdxBj7OTNW7Uf9RkpPhBUh9Fb/cRsxgHltx7EpVomr4jASLNrz4COpU2RTO+qRCgGa2PfcBNX26KRoFWnxgc7LtuA/RhWshm125dvs3VMgQ5hiIZBZBXaSG4aaD4Jm2lfI79ZZPj7A5vWlyysxN4d+mzkE5DJCRHYYpHrVFlhZmn6OSJuJ3nSwRNMO7fGXCUBgTXfuSXtD6z59YvdWCbZaUEqzeQ57ztriE/ihwgci4LpQIv3W4dMJ9cYX6up87LLDBgWb925qGfHKw40K5yNxXzF49jgRm/jYziVgN2clyWTlYGrydaRXZp9xHnYX6TeNhF1lMC85MPXl5y8bG4o9rETH7b5hNFTGR8YZlAlTp08lDAIk0T8YccC7VFpMisOtCz1bZFyYayGy/eGEEHPyaqIlFzMwinvzosslB4oj0Y5igtQ94dZdq6RQlalrOPMmYRHscgRemwIef/hPrac+gopmzttaJVp//BsZ59ARVXFgH6DVgVsf6+Abm86m4ZXFGDGtIb2Xy+rEO4NA08dTOeMcwV5n0ldAhmWiOgMX2UlhUfwaegF/5J62LiKc8ML7LcPY5kr8ifNiSLX/rzbhJ+hxhlayzkw5nayv/uJcag3PzdoJEnGxXF3LtLqudpu7Q9jy32ABUZihevjPSgClNQBKcA7OG3fkqZbM=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ddccdd-95b4-4749-2df5-08db675944eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 13:15:30.8684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: srsIfRDoujd9Tm0A7CBhzCdD1v3e3jSHMlORlzuRWSHBGozVckxKT2MvJ+wOValwoa1K0B+jkihd5P/Z40CQ9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7636
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jun 07, 2023 at 05:32:25PM +0900, Shin'ichiro Kawasaki wrote:
> The commit 954217b90191 ("zbd: Initialize open zones list referring zone
> status at fio start") introduced zone resets for zones in open condition
> which exceeds the limit of max_open_zones. However, this zone reset may
> break data in the zones even when fio does no write to them. Avoid the
> zone reset and report it as an error.
>=20
> Fixes: 954217b90191 ("zbd: Initialize open zones list referring zone stat=
us at fio start")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 7529e68b..832868cb 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1206,12 +1206,10 @@ int zbd_setup_files(struct thread_data *td)
>  				continue;
>  			/*
>  			 * If the number of open zones exceeds specified limits,
> -			 * reset all extra open zones.
> +			 * error out.
>  			 */
> -			if (zbd_reset_zone(td, f, z) < 0) {
> -				log_err("Failed to reest zone %d\n", zi);
> -				return 1;
> -			}
> +			log_err("Number of open zones exceeds max_open_zones limit\n");
> +			return 1;
>  		}
>  	}
> =20
> --=20
> 2.40.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
