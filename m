Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13D8EB64DD
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 15:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjGRPta (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjGRPt3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 11:49:29 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F152BB
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 08:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689695367; x=1721231367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=l3F2Fhsm+3JRj++cdR3B9eSKkG5/1ycPtgtLtdfP/t0=;
  b=dPFg7rTmbPvTHslO5H0auTV+y115KSJIG4f1tx+wuavXyzZFDhrDBCjv
   /V51YRHVdCdGjiPjYlnOfz20cY0BB8p03cN3qUCSKMlGjj6Onzz558Fhm
   aaFokVyP7/RuNhmQtbk8M0gdfqZhFNkXCeC9/0QPaur7P6LXTXtWekamV
   aCpMeNP41Ne2CZGuzqmydy/iT4xPAinIVHOEHG7e1uDISiQGTwSQ5graf
   dRuTT0bTkaz3/Ra0JoUO9u6VI292g42uXVllvxXsMOsemB0ev9i57yhIg
   lkxbjN4FiI7H+SSFU48SB/o8e1WIwVKp2VvEWPRK626BWTV5q4F6zoUGE
   w==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="238782330"
Received: from mail-dm6nam04lp2042.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.42])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 23:45:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QErG9N/s9hZ9sl6nHX2U+dvuBUjTgiPNckEQ8MTLUE3QbZVE23R+rXpGN4cZVR/yAfLX2uX/1nb6twriTVbqPJD/v3pwR43KmUjdBazQP+DaBOeQUETtq5FuxN3ihCahxXmPeV30ABCkcAoaiYcU1rXNZODA/tA4Cd4/yo/g467QsaehyoioTnqCWdlqzs9/ckV72aMxy5kTO5qW8olNtjxQhMXl4OLl+rJ8DgYvcYNF9yFu9Xt0fXRqoCIvNLDUh/GTozqAYa+9frMfnILtE7j4fPjdVuFprATRa3BKoAQUkyICcQc+uB/KCEtAZvcBKmCrn5JjczfNJuOc8wQ3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoYYQu4w3amUkuKnMUH22cTswlaK9544V+FHIyHCHJE=;
 b=fRYkUCaHBD4+iNdE+GTnJ699OV2ycyggb/7c1UFbwXa0v07o7gYCZGmXG8eIrCtKOvgGrrpn6l8qzUX0KQ5Zxp1KYHiBgfSx/6DYPKFd8bDXgEwdPzPmbBEvxUkCQj6RXfINev/tXI3byQVv1tzJMsBwcpgnQsv4wskAQ0gki7bNiWYQWk2GzLpC0RgmFv+u3N9IGjxLNlQKEbfT/taH6oYDXuV8yoCRDmwdeh/WVUG+G8u9zL2BtQUHhTYEQmE9BsCZvknyMDaXpBAwGex6+hEJeWI4Wadbxn6TQCOAGlNHVGAfgDtCkure/kIQljDb0cXcFeLlUOKmw0GlfsDiLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoYYQu4w3amUkuKnMUH22cTswlaK9544V+FHIyHCHJE=;
 b=JXOHhXHmBWlsEIsdlaGeF+tyUcs/DxrVKMbrMiTUxtr2mVWcYRAN6JwqCGZn147HJnwvXxCh+wU6rAmUXP012ImDd0sU5qUpDaL/Y24qCc73jacqNqlrr/zXHO9LJOpceLMtp9WCml9gzRfRTbw1mfvV93/WMgHxZHVjYHNsltU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7505.namprd04.prod.outlook.com (2603:10b6:303:a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 15:45:16 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 15:45:16 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] cmdprio: Add support for per I/O priority hint
Thread-Topic: [PATCH 3/4] cmdprio: Add support for per I/O priority hint
Thread-Index: AQHZr43k5bapZxsllEmjDQStZpv4N6+/vpEA
Date:   Tue, 18 Jul 2023 15:45:16 +0000
Message-ID: <ZLaziFy5Xi/jgyek@x1-carbon>
References: <20230705221302.430678-1-dlemoal@kernel.org>
 <20230705221302.430678-4-dlemoal@kernel.org>
In-Reply-To: <20230705221302.430678-4-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7505:EE_
x-ms-office365-filtering-correlation-id: 58f3e4e8-9cf4-421c-5da5-08db87a5fb89
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XlTCva8DfjhAHxdGE5fEHeTU4dNdhnvHtnIsbfxxN6zaPUhmDswSpf7DLIFxCRZruYa8WIdk5Zz70UwfRgHh2AB5fEaT9Cse2XI9OFPnoIG7ZUw8eVT6u5/gZB5xypCvSenLviZ/lncClg4RIlQdTW40ri9LgvX0gVxvcMFitjjFUo2ukFmt3uZ2WvlK2+385RI2GdJNRC/p+x0lnHk6rQ2V4lp02ukGNHfaO7+MOTjFJ7cG9hKYLmnRsQsS9NeZ8lSoVFwA89ARQMjfVu0rNf/rfxNp68eHLxLUkqwiGRNJrhsNzdq0inVmDAcfCBoGcTBw4kXNT4sY3Clzxr8wsCQcRz/8uy19Y6KsGvpMWwW/78U8mhC7mPxIbL3xZPJdnsLndv+MLj60jSi/pg/XybIlRE2rMqt7jsluRdmfB//g5hTkFLB6+FnNdsuXDkDuoSeuZM+i6qSFPpyQE7ld+ayguIMcyfXfmk1UCWYJZ+sAc1pNR+iJrKbTBLdOWr4hxrjtxQsN54fKbTOZO779jBkuY/foM51Yn1fJAzq4QtsVJqyhKs6fYpXMzpyNrHLVNOXdFYL4NjC3VHlrG8uM9gxqa6c/EV3NMGs/My8uc5dttMws3NpQXy5Io39snGaV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199021)(8676002)(82960400001)(41300700001)(86362001)(5660300002)(8936002)(38100700002)(6916009)(4326008)(316002)(83380400001)(9686003)(76116006)(122000001)(66476007)(66446008)(64756008)(66556008)(66946007)(91956017)(30864003)(2906002)(38070700005)(33716001)(54906003)(478600001)(6486002)(6512007)(186003)(26005)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U3T4hIPPlT/MstcwIT/eZI2cwziENDzl/fyJAGUGVXAf7kwbIrgfw/AQewlp?=
 =?us-ascii?Q?IEDhCfcdIybDvXNOGaQiCfTb+2xpgaV0ALt3UVXoWX/TaK0kPsxMlmuCxpLf?=
 =?us-ascii?Q?JsPj6p4AOzyC2A7aQqNx8txk/NQW+SWKpkTnbg6lMNOK7EhJPiHYv8MiGUEj?=
 =?us-ascii?Q?BKs22Dqdrh1eb1nXTvXlnv96D3EUa2FRVidUInC5hhgqyYfmEFM9lHp49mE+?=
 =?us-ascii?Q?/cQqb8wdaTHJZLi1HJ4bwduU/WDI2+qa6uXPg2Mrm/cyDi098gvznSCAbPBS?=
 =?us-ascii?Q?HyJILHEIsSSB/ILu9mKwU+JKOV+GtHHwl83iWaU4LXvfSidGiE5OElzpoo1Q?=
 =?us-ascii?Q?zlkVh0v4Ai/WtH7dj+koLLx6FN0HWFe55b8xzCU1RRUsFmh9fi4vXS1V6urS?=
 =?us-ascii?Q?wPYXBV133oRQoFYA5hHUYgFNd68DAu6ZK8NN3AtOKOo86tLrX4p1TgUUoBQ2?=
 =?us-ascii?Q?dBQ35rfCw/YnTdHzlVJAV2RnQyvyUWVtvgz0jLbjj2LPFuPhJWZH3mr44job?=
 =?us-ascii?Q?pBv5YF7xQsWCxpD2FY5Bs3G/h0LaTwJlKxJVasJuB7aqzoDpedpD0TBAOoKf?=
 =?us-ascii?Q?L0U7VHS6Fq2LqC74Wqsi+0l6fSu0z0kPfl9ghZrPWaZmfo5iZHooN+4aoeFP?=
 =?us-ascii?Q?+PQayaC+f0L7qXsPYXLEImE5fcD8ircGBvOIC7IV37cGqktgoe6VQ76qtg9R?=
 =?us-ascii?Q?vg62GSF04hgdBxQEQHRdprOWNsGJgVoxuIRvddd/DtnaAzFP3z2vu567FY0M?=
 =?us-ascii?Q?5uZfpJcL4ThHla91SQyZayl8DskNPGoFI5X5RFO4hIZstxNObqZ9WsMh3r5v?=
 =?us-ascii?Q?fNASG+At4Bp8Rx3IbQca/HJtMqbxVEIS+F//XL4o+IPgDqYUO8K/gJZ1euhY?=
 =?us-ascii?Q?+PAt1Q00Gk1MZedoFtSVfhqCEIiAjP6vkFqKFE5c/69eFaIfebSLRF+2tD4I?=
 =?us-ascii?Q?0zxNZeHkB6a4TZiz95o/4GLCwqwhjJ7MpXrposhLN8JN+EMOuQuaUMCEhAdW?=
 =?us-ascii?Q?z00kVuPhhUzGPQ8cE7psWL3Y3DcHXIy703wTm2nIBjdfo71y2iu7GEy25mlP?=
 =?us-ascii?Q?Cw+/BdPeYvtSVgqupFbgM6MM02/o1sFPbZEQi//M0n7dAA0e8Bnvt9tx1KzB?=
 =?us-ascii?Q?uzrElTeTcwZzfXwmK1brcbc0WRh4T8oqLclXDRZacWVPkgevUL/QMKIgpEBV?=
 =?us-ascii?Q?CSVMW5ciGmm6wbXaR2Qu6l7L8AQc2HPime5VFCL5Tq/8Zt7+v51E1GEh7Xir?=
 =?us-ascii?Q?RGofYGnk55axd3/JuheS8YLsCarFM8mzRceWYLwubo9ppqXWIfXrPNWcsCZN?=
 =?us-ascii?Q?al3/tgH+NVsRc96F1eY+qzRefiOUucxhK7mW/ySGyHkktLxyiO17lR59DwpZ?=
 =?us-ascii?Q?1ah1o9e3AQAXv3hmz5gBkn5O/wPqe6SR+FJbRIR9arI8vEIq8b93ZmDwMyAS?=
 =?us-ascii?Q?U6M5bpcXFvEPCqnhPKmdZDurQMxNBIqSPBUBiOoZpuM6hhrRhbcA4epX/YmF?=
 =?us-ascii?Q?T3UvM3V7YhBQirBPnvGfB7gJ5HfmahcjvayBn67A/UmtUfkeCrqUOcbuM/YR?=
 =?us-ascii?Q?Ga5J99w835FurTicI2/YAtNZOSR1qrv1IS93OTIjcOEe62xXopMaC7K/0wOO?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BEF3D213A2D2AA4FA8A79C1F8BED88B7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: W4kzWXQwH1zDcf2u/rjxhOzACXxL9wiqMDV8tdt5rWOI17BTHnnI0PRwxc+qONZ/BrNzjUV5fqTQAtSFJlvbKoWgwcPGTLayo/MDOlUZybgiGvzFcKoFmxVpoASYTyYTGvRBboSKZOMd/mxlxjrFwz6hyAAmc7hrnqse8L1/O03fT1U6aPDGp1Mx+x73HkooOilBn9pHQ7YsLZ0RoiKnwqgUPFviwzNC7CGpwuINeY2gbwFJn669FaB9VDNG7KkCipWcxEL1c51rQySlglHvz7T4wbu98Xbra2TgDU2Ga6c9F412f0ZOsh0Yojn9qBPgNmkuB1ZMtAq62RQnYjweRpUKicDW4rOLUCPXzFtG4rZ0C4E5xoxW/D4fq3B0KdjGyByKlYSC3vFggBft+NGyGDyM5PI+XClQrD/hytiuLl8aGBfsdvwBteaVJtr9ezODB9ixD/C7/OUkYG7lxOMqrOalpaiUA8gUMFbmG0HH2+bXB0kCW6VO96/aJ39shc5B6BhLiwrUxVg0MO2XHRlWgaCuLCMu7cRmz1lape8Bo/v8/lD9WGktGAwZwlWp/lg333A5P2PPVNotLa9+qIycDmkN/693DTuckdAvWW27867wc9WVve2AMdILpT5MHjJLCoHB2zVkTrFI7aOJm7GrwWw2JMI3jpviyoOQOks7UuiVKISTsF1Y9Ua1fdFMuqY3IQo0US5UWVLTY8abGQQW3Qw/a4aTR1BM31KcfxEpNdntkGBRUrI4x95q/PwHh1f3GJYMVH+rraXsFOaal/elBAhva3aT5iYhOiuBtAvrbPVqRRoCkas89t0MYt0FEsdj+s+WLPDLefgGoAMArDk8rOr90kjQ3Bt4F5d8EPlEbqM=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f3e4e8-9cf4-421c-5da5-08db87a5fb89
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 15:45:16.1878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8J15DHqD5tByIzidssAZ6mHjL8iWR17j9+8Sl3MloQ/NaazO3sccwm36ZTJEPU9McP6tu9PBusLtDdZAesXO8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7505
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jul 06, 2023 at 07:13:01AM +0900, Damien Le Moal wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
> Introduce the new option cmdprio_hint to allow specifying I/O priority
> hints per IO with the iouring and libaio IO engines. A third acceptable
> format for the cmdprio_bssplit option is also introduced to allow
> specifying an IO hint in addition to a priority class and level.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  HOWTO.rst          | 25 +++++++++++++++++++++----
>  engines/cmdprio.c  |  9 ++++++---
>  engines/cmdprio.h  |  1 +
>  engines/io_uring.c | 25 +++++++++++++++++++++++--
>  engines/libaio.c   | 21 +++++++++++++++++++++
>  fio.1              | 24 +++++++++++++++++++++---
>  options.c          | 13 ++++++++++---
>  7 files changed, 103 insertions(+), 15 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 359d606b..16985269 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2275,6 +2275,16 @@ with the caveat that when used on the command line=
, they must come after the
>  	reads and writes. See :manpage:`ionice(1)`. See also the
>  	:option:`prioclass` option.
> =20
> +.. option:: cmdprio_hint=3Dint[,int] : [io_uring] [libaio]
> +
> +	Set the I/O priority hint to use for I/Os that must be issued with
> +	a priority when :option:`cmdprio_percentage` or
> +	:option:`cmdprio_bssplit` is set. If not specified when
> +	:option:`cmdprio_percentage` or :option:`cmdprio_bssplit` is set,
> +	this defaults to 0 (no hint). A single value applies to reads and
> +	writes. Comma-separated values may be specified for reads and writes.
> +	See also the :option:`priohint` option.
> +
>  .. option:: cmdprio=3Dint[,int] : [io_uring] [libaio]
> =20
>  	Set the I/O priority value to use for I/Os that must be issued with
> @@ -2301,9 +2311,9 @@ with the caveat that when used on the command line,=
 they must come after the
> =20
>  		cmdprio_bssplit=3Dblocksize/percentage:blocksize/percentage
> =20
> -	In this case, each entry will use the priority class and priority
> -	level defined by the options :option:`cmdprio_class` and
> -	:option:`cmdprio` respectively.
> +	In this case, each entry will use the priority class, priority hint
> +	and priority level defined by the options :option:`cmdprio_class`,
> +        :option:`cmdprio` and :option:`cmdprio_hint` respectively.
> =20
>  	The second accepted format for this option is:
> =20
> @@ -2314,7 +2324,14 @@ with the caveat that when used on the command line=
, they must come after the
>  	accepted format does not restrict all entries to have the same priority
>  	class and priority level.
> =20
> -	For both formats, only the read and write data directions are supported=
,
> +	The third accepted format for this option is:
> +
> +		cmdprio_bssplit=3Dblocksize/percentage/class/level/hint:...
> +
> +	This is an extension of the second accepted format that allows to also
> +	specify a priority hint.
> +
> +	For all formats, only the read and write data directions are supported,
>  	values for trim IOs are ignored. This option is mutually exclusive with
>  	the :option:`cmdprio_percentage` option.
> =20
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index e6ff1fc2..153e3691 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -267,7 +267,8 @@ static int fio_cmdprio_percentage(struct cmdprio *cmd=
prio, struct io_u *io_u,
>   * to be set. If the random percentage value is within the user specifie=
d
>   * percentage of I/Os that should use a cmdprio priority value (rather t=
han
>   * the default priority), then this function updates the io_u with an io=
prio
> - * value as defined by the cmdprio/cmdprio_class or cmdprio_bssplit opti=
ons.
> + * value as defined by the cmdprio/cmdprio_hint/cmdprio_class or
> + * cmdprio_bssplit options.
>   *
>   * Return true if the io_u ioprio was changed and false otherwise.
>   */
> @@ -342,7 +343,8 @@ static int fio_cmdprio_gen_perc(struct thread_data *t=
d, struct cmdprio *cmdprio)
>  		prio =3D &cmdprio->perc_entry[ddir];
>  		prio->perc =3D options->percentage[ddir];
>  		prio->prio =3D ioprio_value(options->class[ddir],
> -					  options->level[ddir], 0);
> +					  options->level[ddir],
> +					  options->hint[ddir]);
>  		assign_clat_prio_index(prio, &values[ddir]);
> =20
>  		ret =3D init_ts_clat_prio(ts, ddir, &values[ddir]);
> @@ -400,7 +402,8 @@ static int fio_cmdprio_parse_and_gen_bssplit(struct t=
hread_data *td,
>  			goto err;
> =20
>  		implicit_cmdprio =3D ioprio_value(options->class[ddir],
> -						options->level[ddir], 0);
> +						options->level[ddir],
> +						options->hint[ddir]);
> =20
>  		ret =3D fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
>  						       &parse_res[ddir],
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index 755da8d0..9b351828 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -39,6 +39,7 @@ struct cmdprio_options {
>  	unsigned int percentage[CMDPRIO_RWDIR_CNT];
>  	unsigned int class[CMDPRIO_RWDIR_CNT];
>  	unsigned int level[CMDPRIO_RWDIR_CNT];
> +	unsigned int hint[CMDPRIO_RWDIR_CNT];
>  	char *bssplit_str;
>  };
> =20
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 5021239e..975a0a4d 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -157,6 +157,21 @@ static struct fio_option options[] =3D {
>  		.category =3D FIO_OPT_C_ENGINE,
>  		.group	=3D FIO_OPT_G_IOURING,
>  	},
> +	{
> +		.name	=3D "cmdprio_hint",
> +		.lname	=3D "Asynchronous I/O priority hint",
> +		.type	=3D FIO_OPT_INT,
> +		.off1	=3D offsetof(struct ioring_options,
> +				   cmdprio_options.hint[DDIR_READ]),
> +		.off2	=3D offsetof(struct ioring_options,
> +				   cmdprio_options.hint[DDIR_WRITE]),
> +		.help	=3D "Set asynchronous IO priority hint",
> +		.minval	=3D IOPRIO_MIN_PRIO_HINT,
> +		.maxval	=3D IOPRIO_MAX_PRIO_HINT,
> +		.interval =3D 1,
> +		.category =3D FIO_OPT_C_ENGINE,
> +		.group	=3D FIO_OPT_G_IOURING,
> +	},
>  	{
>  		.name	=3D "cmdprio",
>  		.lname	=3D "Asynchronous I/O priority level",
> @@ -195,6 +210,12 @@ static struct fio_option options[] =3D {
>  		.type	=3D FIO_OPT_UNSUPPORTED,
>  		.help	=3D "Your platform does not support I/O priority classes",
>  	},
> +	{
> +		.name	=3D "cmdprio_hint",
> +		.lname	=3D "Asynchronous I/O priority hint",
> +		.type	=3D FIO_OPT_UNSUPPORTED,
> +		.help	=3D "Your platform does not support I/O priority classes",
> +	},
>  	{
>  		.name	=3D "cmdprio",
>  		.lname	=3D "Asynchronous I/O priority level",
> @@ -365,8 +386,8 @@ static int fio_ioring_prep(struct thread_data *td, st=
ruct io_u *io_u)
>  		/*
>  		 * Since io_uring can have a submission context (sqthread_poll)
>  		 * that is different from the process context, we cannot rely on
> -		 * the IO priority set by ioprio_set() (option prio/prioclass)
> -		 * to be inherited.
> +		 * the IO priority set by ioprio_set() (options prio, prioclass,
> +		 * and priohint) to be inherited.
>  		 * td->ioprio will have the value of the "default prio", so set
>  		 * this unconditionally. This value might get overridden by
>  		 * fio_ioring_cmdprio_prep() if the option cmdprio_percentage or
> diff --git a/engines/libaio.c b/engines/libaio.c
> index 6a0745aa..c52d05fe 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -102,6 +102,21 @@ static struct fio_option options[] =3D {
>  		.category =3D FIO_OPT_C_ENGINE,
>  		.group	=3D FIO_OPT_G_LIBAIO,
>  	},
> +	{
> +		.name	=3D "cmdprio_hint",
> +		.lname	=3D "Asynchronous I/O priority hint",
> +		.type	=3D FIO_OPT_INT,
> +		.off1	=3D offsetof(struct libaio_options,
> +				   cmdprio_options.hint[DDIR_READ]),
> +		.off2	=3D offsetof(struct libaio_options,
> +				   cmdprio_options.hint[DDIR_WRITE]),
> +		.help	=3D "Set asynchronous IO priority hint",
> +		.minval	=3D IOPRIO_MIN_PRIO_HINT,
> +		.maxval	=3D IOPRIO_MAX_PRIO_HINT,
> +		.interval =3D 1,
> +		.category =3D FIO_OPT_C_ENGINE,
> +		.group	=3D FIO_OPT_G_LIBAIO,
> +	},
>  	{
>  		.name	=3D "cmdprio",
>  		.lname	=3D "Asynchronous I/O priority level",
> @@ -140,6 +155,12 @@ static struct fio_option options[] =3D {
>  		.type	=3D FIO_OPT_UNSUPPORTED,
>  		.help	=3D "Your platform does not support I/O priority classes",
>  	},
> +	{
> +		.name	=3D "cmdprio_hint",
> +		.lname	=3D "Asynchronous I/O priority hint",
> +		.type	=3D FIO_OPT_UNSUPPORTED,
> +		.help	=3D "Your platform does not support I/O priority classes",
> +	},
>  	{
>  		.name	=3D "cmdprio",
>  		.lname	=3D "Asynchronous I/O priority level",
> diff --git a/fio.1 b/fio.1
> index 6dbdb293..72afff65 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2072,6 +2072,14 @@ is set, this defaults to the highest priority clas=
s. A single value applies
>  to reads and writes. Comma-separated values may be specified for reads a=
nd
>  writes. See man \fBionice\fR\|(1). See also the \fBprioclass\fR option.
>  .TP
> +.BI (io_uring,libaio)cmdprio_hint \fR=3D\fPint[,int]
> +Set the I/O priority hint to use for I/Os that must be issued with a
> +priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
> +If not specified when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR
> +is set, this defaults to 0 (no hint). A single value applies to reads an=
d
> +writes. Comma-separated values may be specified for reads and writes.
> +See also the \fBpriohint\fR option.
> +.TP
>  .BI (io_uring,libaio)cmdprio \fR=3D\fPint[,int]
>  Set the I/O priority value to use for I/Os that must be issued with a
>  priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
> @@ -2097,8 +2105,9 @@ The first accepted format for this option is the sa=
me as the format of the
>  cmdprio_bssplit=3Dblocksize/percentage:blocksize/percentage
>  .RE
>  .P
> -In this case, each entry will use the priority class and priority level =
defined
> -by the options \fBcmdprio_class\fR and \fBcmdprio\fR respectively.
> +In this case, each entry will use the priority class, priority hint and
> +priority level defined by the options \fBcmdprio_class\fR, \fBcmdprio\fR
> +and \fBcmdprio_hint\fR respectively.
>  .P
>  The second accepted format for this option is:
>  .RS
> @@ -2111,7 +2120,16 @@ entry. In comparison with the first accepted forma=
t, the second accepted format
>  does not restrict all entries to have the same priority class and priori=
ty
>  level.
>  .P
> -For both formats, only the read and write data directions are supported,=
 values
> +The third accepted format for this option is:
> +.RS
> +.P
> +cmdprio_bssplit=3Dblocksize/percentage/class/level/hint:...
> +.RE
> +.P
> +This is an extension of the second accepted format that allows to also
> +specify a priority hint.
> +.P
> +For all formats, only the read and write data directions are supported, =
values
>  for trim IOs are ignored. This option is mutually exclusive with the
>  \fBcmdprio_percentage\fR option.
>  .RE
> diff --git a/options.c b/options.c
> index c1246297..3fcbd2b3 100644
> --- a/options.c
> +++ b/options.c
> @@ -313,15 +313,17 @@ static int parse_cmdprio_bssplit_entry(struct threa=
d_options *o,
>  	int matches =3D 0;
>  	char *bs_str =3D NULL;
>  	long long bs_val;
> -	unsigned int perc =3D 0, class, level;
> +	unsigned int perc =3D 0, class, level, hint;
> =20
>  	/*
>  	 * valid entry formats:
>  	 * bs/ - %s/ - set perc to 0, prio to -1.
>  	 * bs/perc - %s/%u - set prio to -1.
>  	 * bs/perc/class/level - %s/%u/%u/%u
> +	 * bs/perc/class/level/hint - %s/%u/%u/%u/%u
>  	 */
> -	matches =3D sscanf(str, "%m[^/]/%u/%u/%u", &bs_str, &perc, &class, &lev=
el);
> +	matches =3D sscanf(str, "%m[^/]/%u/%u/%u/%u",
> +			 &bs_str, &perc, &class, &level, &hint);
>  	if (matches < 1) {
>  		log_err("fio: invalid cmdprio_bssplit format\n");
>  		return 1;
> @@ -342,9 +344,14 @@ static int parse_cmdprio_bssplit_entry(struct thread=
_options *o,
>  	case 2: /* bs/perc case */
>  		break;
>  	case 4: /* bs/perc/class/level case */
> +	case 5: /* bs/perc/class/level/hint case */
>  		class =3D min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
>  		level =3D min(level, (unsigned int) IOPRIO_MAX_PRIO);
> -		entry->prio =3D ioprio_value(class, level, 0);
> +		if (matches =3D=3D 5)
> +			hint =3D min(hint, (unsigned int) IOPRIO_MAX_PRIO_HINT);
> +		else
> +			hint =3D 0;
> +		entry->prio =3D ioprio_value(class, level, hint);
>  		break;
>  	default:
>  		log_err("fio: invalid cmdprio_bssplit format\n");
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
