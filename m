Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275ECEB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 13:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjGRN5H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjGRN5G (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 09:57:06 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0895C170E
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 06:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689688595; x=1721224595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b3lK5b9u/qJ0rDoBMNBhDY/0Mw+jxCSmPuXFRlFIMKo=;
  b=IJroHlEIBgvHLfQcDUPib+ihrae8qTBn2TDYqe+i2SEqkA73soUYK9d2
   iLJbb80KuF3ZiCLPfJ5Gk2KJVoxPy9Tfp32crX+1SKzMpw2dzXGkDMTQK
   O9vajLdQVy7aeiaVrIeZxU4d1tgqgOqQerNX31qe9Y7V00xQvrbQDhfW6
   DiAegqSzSqoekAkMr96JFjPTI1tfIk2OmbsOeHttnKUY+IscQaI8A8eiA
   ol8RKvQ+G7AqGeSXuv36Gj5PrWB7sbnd9eILiPDZ8ETQK3CyJ0PclKn5n
   Y7sTGlDyPqiSfbh+8bCj3IEix5NzZI3J22dQrZ2g3X76+XudE03AA+uVC
   w==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="238769913"
Received: from mail-bn1nam02lp2049.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.49])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 21:56:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvRFGTXPzVvOKaEQrRae8rMAji0KC1yGkwWKCVrr7SKtkmpoVXFUE6BVfB2fvIQxb++n5pziF6VXp5EmdoNt8yQAy74uPxZhTuPgRDSJTBQ/1g92h7WfNwfRJ5H6/Y2rcpyDQiNLvR4bp1s6HFluHit7ghYI0T5eMfv6X2t0W/yB5wha5L9WELgzllWowrdDC9bNFG5aLmHBqqroGWAQIJVKIPUsy54GFXThObdZHAzx7Hoit33PPGay02YoY/RtT7aeXUu94t07OrYCfZtB5Mcl6BUriE+e/1cV0lRqAvuSv655HJc2na6qlxbhSrf8s3dbhoxvnoS4DtQQxa2A9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrlYsY2A1DV/cs90lpNa2qHfbyNedm3jYaX+twQhKqs=;
 b=c4MKTswb7sVA/9kTwks0BNoHqyHq0nj5bginF48rcMjf8FmSh84ejpbpCMN8mCMkK3/cLOrbCAEB265i48Kc3JQc0xy8H8GluTT9pOkxLdw4iTPhPy7K5DDh2IevN2EQNv98UN0PFzgHQs1jc8p4QoEEQFnTJajLz0c/cLGLFwWjPSZzhufznpV2oka2FefqJ/7+7oDxHoxtX5ytNDxOvlCCzjYKyeaR7PaHFSj2y0qIw31l2ScF1DnLNL+yCoi6WHM2OGmsU6RSJIiJoofo4bhyHcbthGfztkZTffXWEE4UwEiM3z2OOUxwpyZe+e1No597E3BjHc01csegttvbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrlYsY2A1DV/cs90lpNa2qHfbyNedm3jYaX+twQhKqs=;
 b=oEd4GapabQFt53EIs0GF6SqTwuBViveMfrOZLzMl4Wc/RqJ3S5iazTPoANTdqyrzLEBQaqWZZGD1Kf+6yY8M1JqrnrkpZTypKcutPQqOkA5v0cspK1rHn8w2AnlynI5iqD7F/eWKz17F1USTVJGrlcC2Aj1yCtbJMDmwyJHwgOA=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SA3PR04MB8748.namprd04.prod.outlook.com (2603:10b6:806:2f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 18 Jul
 2023 13:56:14 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:56:14 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 04/13] docs: modify max_open_zones option description
Thread-Topic: [PATCH 04/13] docs: modify max_open_zones option description
Thread-Index: AQHZsIFDitbM4lpl00uLnlhM7I2Jfq+/njMA
Date:   Tue, 18 Jul 2023 13:56:14 +0000
Message-ID: <ZLaZ+rxgwKALiHG2@x1-carbon>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230707031505.3468915-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SA3PR04MB8748:EE_
x-ms-office365-filtering-correlation-id: d8238e6c-e8aa-4463-4f40-08db8796c075
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1eIyF4Ff1HFrc9x61PEVz+ziBe7dQWc58BTCwZ4JKJkPZvASmGhXqIimg8cvi1qIqizc1elINe1qijV9NrSi5vb1tB2cH/WA69GNvwx1E+AI1/S12EpEzdSWu9c5tgZLsGg5of2VA7z0rBD/m0Mbzzfqj9sK1uByY1M0sJgEMt4bQxnNdBAhazLNGV0UG/dMs4UCfQmU4E8Mc7LF+qVCWiZemnpRC6ZGOkH6x2oLeKsumLGTR0HXhnI2IyNjK/jxYvu+15f5Zw5zGr4Dlw/UtmcwMgP1DFwQUEX5gPceEiXzGmxI51XHogL9XaNh5w6ghb9WWjU6ELSuzRs8xEjAJQ0tGklwpZAaY+eJpjYb5eF+gVH5HF68U7EV5gl34ovZMg98Z9OCxdwJgJz+rP13bZTXRjbMDNfFVvaAnKaojojCVAAfUJ9YH36uVzX3AxMyJ75O60CRB73JUNGic7ddADLB2pjBjfMebP6fK/c3AmLfxfW7Crr7HvCTD8pXWlDBu2aTzBnC3Kc2wOIjWcwy4aaJBDuQ7GN/YveEwy/fduwi83O3Euw4tH9nZFFDdEpgci/gww0pWZUekH8zxRz2av1N/9f2M+eWKJhIw/ZZXSBsosVhKwpHNOtFqqJG2PXeKolYp4z0VmXooaJRRKJdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(33716001)(2906002)(54906003)(6486002)(71200400001)(478600001)(76116006)(41300700001)(316002)(91956017)(66476007)(66946007)(66556008)(66446008)(64756008)(4326008)(8936002)(6636002)(6512007)(82960400001)(186003)(122000001)(83380400001)(38100700002)(86362001)(5660300002)(26005)(6862004)(38070700005)(8676002)(9686003)(6506007)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7AIie6nn6Jas6MGeSCKfVtR/nEpXs7VRhi1TE8ykfJ+mWg6fQUJHeA0qqZgj?=
 =?us-ascii?Q?Eso9hD1qFSrxn0vPYSfK4lP91PErc7nKYF8El8IgOamXUB0z/dlGVgfTeGCp?=
 =?us-ascii?Q?JoS4+nspkKeRNyWLXV3ZGiY7OcGCiMjKAwLwCMRtfZzmbVLvAChGZrz5c18Q?=
 =?us-ascii?Q?lUSYLwwwidkOsW2iFL1CKn9CiFBbcw8ebj1+rOM2HTwHGHVx03TgT3lbh1IE?=
 =?us-ascii?Q?iV+vGs+xM65ot31oLv7QECRBVtCKeAhxtcFXLOBjmgJm7BmqtKt8aTY3zqLQ?=
 =?us-ascii?Q?m49Eu9FE4oXIYtWYQa7Hr+ivC7Uomt5b6H08cwXF8iQs248K6CKXxXVD7zv8?=
 =?us-ascii?Q?oTLsfZ1+rEIhPtlqzZdPNsCOrOnj0BWY2iaqEQB7HjT8/i/I8KqfbusKSHfa?=
 =?us-ascii?Q?9AvlrALKxe99GQCw/sbTlkTG0iyTvYh0WdmuhlHbDJaX7uGGLXirpWqbhIP7?=
 =?us-ascii?Q?MSzwH4CceiJ6UaFBxWOL5tY/6QJU495H7YrYFZ6zcpF6TX1W5c7+rdl5nxYG?=
 =?us-ascii?Q?G1bHQViVrftRUxaD/N0YkuTW9tc6rK6emz4m6kP0VO2hIFcDcfyrTizPS7Ql?=
 =?us-ascii?Q?tNiysRYRmQe2qAXnLmmzWFIRVHPxp+u+qeEjYZaJoHqs6+jObRjgZtseztCm?=
 =?us-ascii?Q?FixJlRAlcoru8kiwVtLoxZOcufMUefJNsEeUnQC5XtOhrAoAMqy/R4OfFNFQ?=
 =?us-ascii?Q?tFSS7JPqmG9UbigNkmVzK14e4V0sLzBHlOdnxxbOFgOt6A4AKefJrHNnDEAK?=
 =?us-ascii?Q?SXhFdQhnBj6Dkevh4CU+olGY6nwm1czGhUoo7ehWjfr/k+T0Bcvf4j3MqLDs?=
 =?us-ascii?Q?HCb9LMfghLrUnEwKIGXWSg3V8wRtpt+vjJNevCrye+536qQru473Hx03/yu1?=
 =?us-ascii?Q?xyLELS/AM1DoENw+uIlmgeLVFnJD+kJgsPShvqdq/vxJNLJpn7iAFhePuTtG?=
 =?us-ascii?Q?0erju7rFWe5KVvCWPT7ddetmMBikJ62lyb/DToWujEdjlr2ZlKh4pVr8LQ/B?=
 =?us-ascii?Q?XgP91CeKIlY63xLD4n6DiA9hQRaDGafJcskltU/8GKpVPBz8OklTV8pW1yGv?=
 =?us-ascii?Q?C7X8q40aOqmgPAGTOV8/4aa9JGYSJZkKtQrxcuqf9J9ea84v28OX2vU9w8AH?=
 =?us-ascii?Q?gCO3hDfBTWoHQYUSwty05ulw+TY4HkFTCSUxgdMva4Sf2JfctI+4WC84bnra?=
 =?us-ascii?Q?+C/2C47JgIcXYHiRYK66+DVgShwRLvlag2J6w1Dtszg7J35fSMoXmAzQqqgj?=
 =?us-ascii?Q?9n6/5GDx4BxEqCVIlKQ2RW5gHPDLJzNEk24Dn/oTrAUMdy7EGmJy000FPj5H?=
 =?us-ascii?Q?m15VpwooCFtIqPsjk3agkJUJspetCK2Mr8MYEH6wK9B5vtodWbO/d5bQLz5Y?=
 =?us-ascii?Q?uEASltQepBU91h7QWx6/tBCIvZY+sunhOO8e3mHfb/kPoaM8dObL/zcTTEQh?=
 =?us-ascii?Q?0ZHRItOBG1LUXNveDZeGa4nC/UbKVqig/cV/VUpHQcbglnRVYV5u52+N5m2E?=
 =?us-ascii?Q?H/O6rieNdqj8UcuQPXf2mu6eDDuGgGsjRNiQe9o7AxEux3qyJwvRgpZezRBJ?=
 =?us-ascii?Q?T057mhidfpGKK4R5nqvHBjQkrYaEfbYeUpfIrQKNgQg4Y8XLZirQcHysb59+?=
 =?us-ascii?Q?uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA1AAB4A4D48B54CBFFD64144657D325@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: foyw/NGNmDDH4aaGQz88cItvkjobUN9NSSPuvpmNhrPopIIhobLv8xx5MKzH9Cza/+EFZhLtEPjPbE40DvEpVsOSPXBJ2QhwDe9xU3/u6gKypvcBKRTmLQE6cYROu+O1xNFwaarI7xe0SOzONbtLsaMKaM2tJ26nt7IcKaFS/m2DmZI/DhYuDr/Icwy+WHbaGjGOJ6QfBGroLdlRYq9ReOBplKXffPQLe0dO+YaDrP/bJCToQ5g2dLcvgg9knhfsWFpD0hHcB69UtOiWtK1voy+IlzfjWKfbmT58DSO7VLvTOBzO4+Ez2S0qB6C/4k+nfdPuZ+uMPe0gYUZBtgN/m3yVGkDbiwoX3hUGDnmRzSTOzy16vfuEkXHfxrD5dXj1II2bI/r8rxO2YFAojca4Aq736VIPdq/12TILfsCNrabzeNn4LwWi9ocj0hPLtipbyFdVr9MBrbop5y30sUAfO0AHhJ3stpl809anVSL0+jsrxRbFYJbyRLp2a1IXiHEmKG7M6YZ8QK4d2bFj/ec4ci0jeIqOIzmfj09RiiTNl+OoG/cB4fV/GzD5bb9NlSAu/cbkgUis9DPjtk+nFvLUEm/oEFtmDep4sfItU+iVWViQ6v9F+NVBYdJIzg18L/9jcei691yPmmPnueas02k7cscBx3f8/Pb7+m4P/A9O+dTXp2+B8cNFwxrqW3Xns4Y2VxTpcqFtQJV3wPS+Goawhfz0gbU0HQWYuTTXf+lkzptMTNZiwyT2qvcFew7nKmD388oOz589vYqIry1pjvE5fDjXCSlHDuAuvjx/U5BszEgUgnxY2Ls86CoVeYURgkuoRua4mLqcJxn1NZ/NaqvjUc1HR/lDqavQA0B1wDsxMz8=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8238e6c-e8aa-4463-4f40-08db8796c075
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 13:56:14.6406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W1AFDeEUzLdAhbtGCLx5rwJNTbmQcxBltSsgyrWiv5tffGx/VZ5A65Ltw1Bj82te2VzGkuKEUwYLx6tD8OSOyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8748
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jul 07, 2023 at 12:14:56PM +0900, Shin'ichiro Kawasaki wrote:
> A recent commit modified the max_open_zones option to improve handling
> of zoned block devices with max_active_zones limit. Modify description
> of the option to meet the change.
>=20
> For that purpose, explain the relation between the max_open_zones option
> and the device side limits max_active_zones and max_open_zones. Also
> mention about three zone conditions 'implicit open', 'explict open' and
> 'closed'. And replace the word 'zone state' with 'zone condition'.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  HOWTO.rst | 44 ++++++++++++++++++++++++++++----------------
>  fio.1     | 36 ++++++++++++++++++++++++------------
>  2 files changed, 52 insertions(+), 28 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 2e1e55c2..4d50ad41 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1056,22 +1056,34 @@ Target file/device
> =20
>  .. option:: max_open_zones=3Dint
> =20
> -	A zone of a zoned block device is in the open state when it is partiall=
y
> -	written (i.e. not all sectors of the zone have been written). Zoned
> -	block devices may have a limit on the total number of zones that can
> -	be simultaneously in the open state, that is, the number of zones that
> -	can be written to simultaneously. The :option:`max_open_zones` paramete=
r
> -	limits the number of zones to which write commands are issued by all fi=
o
> -	jobs, that is, limits the number of zones that will be in the open
> -	state. This parameter is relevant only if the :option:`zonemode` =3Dzbd=
 is
> -	used. The default value is always equal to maximum number of open zones
> -	of the target zoned block device and a value higher than this limit
> -	cannot be specified by users unless the option
> -	:option:`ignore_zone_limits` is specified. When
> -	:option:`ignore_zone_limits` is specified or the target device has no
> -	limit on the number of zones that can be in an open state,
> -	:option:`max_open_zones` can specify 0 to disable any limit on the
> -	number of zones that can be simultaneously written to by all jobs.
> +	When a zone of a zoned block device is partially written (i.e. not all
> +	sectors of the zone have been written), the zone is in one of three
> +	conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block
> +	devices may have a limit called 'max_open_zones' (same name as the
> +	parameter) on the total number of zones that can simultaneously be in
> +	the 'implicit open' or 'explicit open' conditions. Zoned block devices
> +	may have another limit called 'max_active_zones', on the total number o=
f
> +	zones that can simultaneously be in the three conditions. The
> +	:option:`max_open_zones` parameter limits the number of zones to which
> +	write commands are issued by all fio jobs, that is, limits the number o=
f
> +	zones that will be in the conditions. When the device has the
> +	max_open_zones limit and does not have the max_active_zones limit, the
> +	:option:`max_open_zones` parameter limits the number of zones in the tw=
o
> +	open conditions up to the limit. In this case, fio includes zones in th=
e
> +	two open conditions to the write target zones at fio start. When the
> +	device has both the max_open_zones and the max_active_zones limits, the
> +	:option:`max_open_zones` parameter limits the number of zones in the
> +	three conditions up to the limit. In this case, fio includes zones in
> +	the three conditions to the write target zones at fio start.
> +
> +	This parameter is relevant only if the :option:`zonemode` =3Dzbd is use=
d.
> +	The default value is always equal to the max_open_zones limit of the
> +	target zoned block device and a value higher than this limit cannot be
> +	specified by users unless the option :option:`ignore_zone_limits` is
> +	specified. When :option:`ignore_zone_limits` is specified or the target
> +	device does not have the max_open_zones limit, :option:`max_open_zones`
> +	can specify 0 to disable any limit on the number of zones that can be
> +	simultaneously written to by all jobs.

While this is a wall of text, I don't really see a better way.

This option really controls the maximum number of zones that fio will
issue writes to simultaneously.

For clarity, I guess we could introduce a --max_write_zones option
and move this description there, and make --max_open_zones an alias
for --max_write_zones... But I'm not sure if it would be worth it.

Either way:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>


Kind regards,
Niklas

> =20
>  .. option:: job_max_open_zones=3Dint
> =20
> diff --git a/fio.1 b/fio.1
> index 73b7e8c9..e8bc4f33 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -832,18 +832,30 @@ numbers fio only reads beyond the write pointer if =
explicitly told to do
>  so. Default: false.
>  .TP
>  .BI max_open_zones \fR=3D\fPint
> -A zone of a zoned block device is in the open state when it is partially=
 written
> -(i.e. not all sectors of the zone have been written). Zoned block device=
s may
> -have limit a on the total number of zones that can be simultaneously in =
the
> -open state, that is, the number of zones that can be written to simultan=
eously.
> -The \fBmax_open_zones\fR parameter limits the number of zones to which w=
rite
> -commands are issued by all fio jobs, that is, limits the number of zones=
 that
> -will be in the open state. This parameter is relevant only if the
> -\fBzonemode=3Dzbd\fR is used. The default value is always equal to maxim=
um number
> -of open zones of the target zoned block device and a value higher than t=
his
> -limit cannot be specified by users unless the option \fBignore_zone_limi=
ts\fR is
> -specified. When \fBignore_zone_limits\fR is specified or the target devi=
ce has
> -no limit on the number of zones that can be in an open state,
> +When a zone of a zoned block device is partially written (i.e. not all s=
ectors
> +of the zone have been written), the zone is in one of three
> +conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block de=
vices
> +may have a limit called 'max_open_zones' (same name as the parameter) on=
 the
> +total number of zones that can simultaneously be in the 'implicit open'
> +or 'explicit open' conditions. Zoned block devices may have another limi=
t
> +called 'max_active_zones', on the total number of zones that can simulta=
neously
> +be in the three conditions. The \fBmax_open_zones\fR parameter limits
> +the number of zones to which write commands are issued by all fio jobs, =
that is,
> +limits the number of zones that will be in the conditions. When the devi=
ce has
> +the max_open_zones limit and does not have the max_active_zones limit, t=
he
> +\fBmax_open_zones\fR parameter limits the number of zones in the two ope=
n
> +conditions up to the limit. In this case, fio includes zones in the two =
open
> +conditions to the write target zones at fio start. When the device has b=
oth the
> +max_open_zones and the max_active_zones limits, the \fBmax_open_zones\fR
> +parameter limits the number of zones in the three conditions up to the l=
imit.
> +In this case, fio includes zones in the three conditions to the write ta=
rget
> +zones at fio start.
> +
> +This parameter is relevant only if the \fBzonemode=3Dzbd\fR is used. The=
 default
> +value is always equal to the max_open_zones limit of the target zoned bl=
ock
> +device and a value higher than this limit cannot be specified by users u=
nless
> +the option \fBignore_zone_limits\fR is specified. When \fBignore_zone_li=
mits\fR
> +is specified or the target device does not have the max_open_zones limit=
,
>  \fBmax_open_zones\fR can specify 0 to disable any limit on the number of=
 zones
>  that can be simultaneously written to by all jobs.
>  .TP
> --=20
> 2.40.1
> =
