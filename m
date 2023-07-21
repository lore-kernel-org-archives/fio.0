Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D5FEB64DC
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjGULcO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjGULcN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:32:13 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C643E0
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689939131; x=1721475131;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gTsAMXrc7LPXK7zt/L7YDDvu6LEUrK6uOiqvSXloc00=;
  b=P6GzbBoPXn7H/lLGrErLbk7q1xGoR+MwUGI/708+GZ8LGCaZ4epduncR
   dsZ8/kSu2MgcT8Cj1b27RKuOMftMQ08UIXkAXIiRH5eqBr8mHGncxrSEB
   0KwoaLPDWI0UtlKRaUjbO/mZUOTkp8QnuR+znbdZu11fS+HsmYdQrTLup
   BAMqBIaOHSRhvaHzqMfNUqWSdR6gE9oqOlO6HrNsz8t2HI7gh6+Y1rGJL
   +aD7VWLxMYkiRGfzhHCVvJT0tcWWxOE3odsXp1d01zbjINxiMFUC4vgDI
   QlH9yn0s04i611Lxw3W7L3/M7DS4BXbJJXD0YhUXaulu8q8uqQtQKGDww
   A==;
X-IronPort-AV: E=Sophos;i="6.01,220,1684771200"; 
   d="scan'208";a="243351824"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2023 19:32:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGlvlEsBc1EoDIe/sbHtCFaQOQpD5qYPq1P2nEc+iTz8h+5pOfc9qRXBHYlUg4sjcmW0Q7M9W4rl0Lk0XBVisLlUJ83PRp+i9w28J8GH/wAz+dIlBzT+rU3bi9ireOs48WSdMRLOwzz5dH4Zdqu0DXD87K243XjPXtje9y7ogC/3HkQrIctCIkiTYel5bWEuc3Dl/WTijQnkIOWJcTx/DNKYNbxPL2+1J6KIenk36PjnhJLnomoHQ+RHo7Msy1A2umSwXZT+dogG+Pnjyg8CqXnhjJArN0CBREa9bYooA2ZVeqYi9OPxb1nxfx9KCn/iWKAM0pL9jljJ1lzgfRj+VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVVGdXgeAUagqej77pGPDutbGJeDZRLMOHcsWJjHpyY=;
 b=LGtoOY7ML2iX4XTWWNynwlH3UEMr4tyG8CO5SwMA4nqwI3dEssF3cKOzXsFpXsE1z0FVonS3amy8FdZ0AtPn4q+Hg1KLm70H6F0OzZkbEcKUD73/qbrM2N5Nm9WeQxaHbWLm7HAO2p5M40TC08VsCDiY4wIk1JraayRL0Pi7TIvnXA0a6nITbBhxoAnMkLSIzJvlfZ3gQwk3uXjlm1W24Vzr3LBpx0ein18LrnJJ8C2Po2UuHL0cVHrUtYtbDIKj2Ahg3tlVu2pA04mc0w7oHpeGExk/pFNTZ+HnmKAWhmOlUVzPLO6NxQWePLuzr/7b7fmavoHi0WHLlT54uUYPGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVVGdXgeAUagqej77pGPDutbGJeDZRLMOHcsWJjHpyY=;
 b=vPc0DPrejuvE7IiIo8YHtPckyoR9qEqW8gT5usGwc/KOqQrYkFCfQhLCubHIahHi5fXRwnGwT0BcNSH0YMilXLd8aOFMBUaOIh2QyT0V4viKXzAiFqRv1EIPyBron7YGJTFJWSdgMfmsRV9vWTKNrdrnSJNqpdG9TzXKfyhVpZs=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DS0PR04MB8741.namprd04.prod.outlook.com (2603:10b6:8:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Fri, 21 Jul
 2023 11:32:08 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 11:32:08 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 5/6] cmdprio: Add support for per I/O priority hint
Thread-Topic: [PATCH v3 5/6] cmdprio: Add support for per I/O priority hint
Thread-Index: AQHZu8M/RPR/UY38o0yx6yFAGmahNa/EFm+A
Date:   Fri, 21 Jul 2023 11:32:08 +0000
Message-ID: <ZLpst9InxlrZkRim@x1-carbon>
References: <20230721110510.44772-1-dlemoal@kernel.org>
 <20230721110510.44772-6-dlemoal@kernel.org>
In-Reply-To: <20230721110510.44772-6-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DS0PR04MB8741:EE_
x-ms-office365-filtering-correlation-id: 54d5d769-547c-4273-b48d-08db89de1dff
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frv8kJvYhmx+XF04kiasUgHYOIbiN8StnZt/db/8ENRF8z+mrg/e5hP4KOdgQ4MF9Ibw6C0EDbhyTEWjUhzd/X3CTSEZa+R+P16flDtzrghlKUIjGj377DiP6p2GlwV2poqhtRE2+tjMzLCNMHT6d/uwg9MwHmKG/M5H2MqsfnEWZKtczs2FfbPzUWJHN57NxABBJLwv88Uw0xKyhnO//uvvUE5YmjNNAUq5pthfBvw2MnEJJNipjAt6gZ8RiIzXCzIAKNj2KC6yeLpV58L5MUAbeWi8crrubydcOmnUhofunLTeb4Vu+6lUtcP9BKiBf7lKmJcxt08/uyyzpmgMKM9pnX4C5PADKkHE+rtEu4i665aHehwHjABG9hqqgnIvHfwjZH5wZFrIkZt53StdreJIKcrkQN920Lx2NQouGoVdyVUWHArN+WTMPCt8DO5O6QgfTONIzrCZC/BFPaHwNY4Ru62E0Gw9cixzjfvXNkX099/ZslmixlYNdQW2V6mZeCzXeDDJXbuo/7VVUxDMBNZlI3o41d+PlmENvHrQONiYebKSSFO+xx3uOH7/7zVn50+m6l5i5PPxvp3GwNLD3xDpf7s3w2EHI+sqzeXNkGSJ4lQ1u5jBu2F1VGOsVCHM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(66946007)(6506007)(9686003)(6512007)(122000001)(66556008)(8936002)(26005)(38100700002)(5660300002)(83380400001)(82960400001)(186003)(38070700005)(64756008)(33716001)(30864003)(2906002)(8676002)(91956017)(54906003)(66476007)(86362001)(76116006)(4326008)(41300700001)(478600001)(6916009)(71200400001)(6486002)(66446008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ykuJg/n/FrJ9JOYTi1iz/uZ5wF7ISZu/0EWATsjMe5TBXFnCymUtAQfkMkfY?=
 =?us-ascii?Q?GZqikUOwuQ4WGLduC0y4Hr2IMK2/hMWnBY1CDL1EhtO6AE6ROAQsUGtXTleS?=
 =?us-ascii?Q?qg1FYV8f7PHEf4HeNyBewqvHQsYSL+QLaVcYTIf7ZPPZQa4R/nMn0DZgST9w?=
 =?us-ascii?Q?bhNuSGWovC/KMmSwtJiMaC5NZVgdU5zS54l/c7gILd+7i80I0VUSBtjCDam/?=
 =?us-ascii?Q?vNPWLBcLcHSd9lRYBdcBVuEgf5i6bRTgdApMYNRvKLnqeDQVd2ATEuDDuXSx?=
 =?us-ascii?Q?fVgAYQ8ulvSEAgKDRdvoVyWehq+2lmqQpQAue3yUze8yR1wpFcy7kVGFkPIj?=
 =?us-ascii?Q?g2mqkzQbef/sP8hwrsZAl3jtbYn97riSX358mOE4YtCT2LnSOTRsf0S9VasO?=
 =?us-ascii?Q?Wj+WTFXplVPPzZMQXeNgqjJHZiE0lkeaWZInmRJNutkbikVAQj6gq7SBDiVg?=
 =?us-ascii?Q?r2iwqrUuUY1xe95a8PtUSLh88GkvjpewRsQVsLfvmoqOxR57+gMbqxATfML4?=
 =?us-ascii?Q?hRoOIhAGq7zc5lOFNP9tlCb+MIbDmCSBZXiVRu4jm+N4aauqH14Cg2PiVkCq?=
 =?us-ascii?Q?492U+kmChQoF3R5NeHJvulNsu79E5/GlofwRrSVc8XDkMECZorRoTHNxWfmw?=
 =?us-ascii?Q?r/ZWe/HHR7dv+ahKpEPENKoIEhUs8KwKu/91ahambgutMvAS9jn33dkORWZJ?=
 =?us-ascii?Q?e23zIQQcnH/DQA9xnbuXNCYnr4RTwEVZfO0OkJR4HJg+hxK7BQbEiTuMxNFE?=
 =?us-ascii?Q?KtJyYvyw0qJpWDibrlOCe11meoMO+ujBiVBtL+UfSLwitW75c/p+olyJbXT1?=
 =?us-ascii?Q?tkxsS2+GpFNK0vx97sn78e299165nWoZnV8yAbfWAi8yMPTF/Jr+Medp9ZGH?=
 =?us-ascii?Q?HMOeI9g8mi+mNAiC+RyVVN7mFzk3d4OmHgsugqi71BGCM1JwyQViw1AxaR3b?=
 =?us-ascii?Q?Bpdo306ZTDm0PTYotr+YOcY3v+MCZwJzSDyw2AzkYeZR77Gq/3fF8F4K9meh?=
 =?us-ascii?Q?gXve2qB0b91Vz6LGrsc4YPRc8sflQeOauQkveJHuRQwy0aqAOKuRIvfwPRjl?=
 =?us-ascii?Q?na/JWTBK9GB7MGheVdodwegZ/aXhaZRNcy5+w92MnWAPo6F1fWQNjoezfK9B?=
 =?us-ascii?Q?2vRdA2bWiZl5GmONSyPsLB4pgM0s6urVtdVJNPUM5tY3LD/eEi6JyWbaxN+G?=
 =?us-ascii?Q?Fg4tfarktIubaN4Nc7XgrnNswXbR7hYVRIuoxVvWXx10phNuFvlFElGwIFnV?=
 =?us-ascii?Q?Q/WzzNrCcQj4ShaDqba+IVPpyRxBOTHSNhKabS6hy2chOfOm3C+1vm5JRBrY?=
 =?us-ascii?Q?G7/a0LHSjHC+4XTkRQQplnPoNNwjGtMhRjiqJrcP1uW+W32p4H0Yw0+SecAJ?=
 =?us-ascii?Q?IMdWpjecx3/0omyuo96bqBfTK89mEWUzhP8Z67HJ+SMN3itKQ2g+X/cX4hqH?=
 =?us-ascii?Q?3lyQ3tV99dK/iSMCaswqec/EgxXgGntk9PyWcsosFnrZONg9iOJXoLiOn6X3?=
 =?us-ascii?Q?rH+/+vYwXB2fdfrDnL2tGfVRE/Jja/J1MrSDnDShwTNQlEQo8grznnlHgEuy?=
 =?us-ascii?Q?YWclCsLa27cLJfo6WplxHDODmAdEYsRJnw6lAucVf9VEz9HaYaLKtd5G/cFQ?=
 =?us-ascii?Q?eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A939128361FFEE4FB1EF33225C9D222E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xLF8cvEn3wQBlmXRmXJCJpvqLNr7e0nMSWoLaXDu5iezQJSY3QV5p37XdqlXpKTzZaUcjI9HGFE3/4mnDnHEo8XI4yU7+gMAaEJ5Jx6KVhFHXpYL9Dov3Li/hGKSTG4ZYDe94XxYjxgtzwt+eenAJ39pAHuwMWbvAWI8TtzFsp+5fd3YZ0xoeFnGZBZdYvYcmHfQZFbrRO7T0ebMvDMmqqXV5/3vNNGCRzhMBFaVUecnKuMh0i4xtZK9y8eElrcupDGhgTVOfajBFPnznJ34GHAo/QPTKM24ErkklSgEkj9PEt8uU2jPMKke6rQMQJ4g/dDY2iLJ2B1DBjkqvKvZBF5xLtU+jr91oOr2bNy8/ZniFPdkNisT7zkUe0IBTZPSD3twffPZpSpSGJCSPoroVml/b9t6XvwrOfNbr1pmaollJXnJSRpllPSCI2tL72F1JaEdxRhYNigl4G9I/1knbKobitdJklaeCwQ8dqvgB6FZskvdyoGFCBk31x0E+MIcXwGCttSwYcmdzkkFrb+ksqFzvL53kFEacpRkeAw1eYubP54Ei5OBDVRrhozfg6aok4ThAbZIIZacuq+4cLHPeGXnQLejaTxv5Oi92VVaBdgTnOW21r1ayipeiQVwaHXZMmtHlLft5Wxj+vZ+KmXNiUYaFhQv9zFqNWZYKU9ekZKrgWKTuFml+A61kv2I1GWQjiWNddJrSgdR6oRAGFPeiSSaKcUtOLkdbJ36AxOyNympwoF3xJZKgKviktJ8s7590mWwT0n5eVrN1DfDhybmqys+IT/U5jEVnkNthEJ7vF/CB+i9xmO6eBdssyKIJOiXY5oVT92xInepIZr5yvm53rWcBpe7p1WPjK4vzYiCWnA=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d5d769-547c-4273-b48d-08db89de1dff
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 11:32:08.2029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /fzBPD//ficgWnTzNbDsM9vnUdLdGrqzobWsTK9AoZDhlG6fjkOsl4jN5q78Bq+V/zuGnLjIwgt0KzToxv1uaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB8741
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jul 21, 2023 at 08:05:09PM +0900, Damien Le Moal wrote:
> Introduce the new option cmdprio_hint to allow specifying I/O priority
> hints per IO with the io_uring and libaio IO engines. A third acceptable
> format for the cmdprio_bssplit option is also introduced to allow
> specifying an I/O hint in addition to a priority class and level.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  HOWTO.rst          | 28 ++++++++++++++++++++++++----
>  engines/cmdprio.c  |  9 ++++++---
>  engines/cmdprio.h  | 22 ++++++++++++++++++++++
>  engines/io_uring.c |  4 ++--
>  fio.1              | 27 +++++++++++++++++++++++----
>  options.c          | 13 ++++++++++---
>  6 files changed, 87 insertions(+), 16 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index d1a476e4..ac8314f3 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2287,6 +2287,16 @@ with the caveat that when used on the command line=
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
> @@ -2313,9 +2323,9 @@ with the caveat that when used on the command line,=
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
> @@ -2326,7 +2336,14 @@ with the caveat that when used on the command line=
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
> @@ -3445,6 +3462,9 @@ Threads, processes and job synchronization
>  	of I/Os so that the device can optimize its internal command scheduling
>  	according to the latency limits indicated by the user.
> =20
> +	For per-I/O priority hint setting, see the I/O engine specific
> +	:option:`cmdprio_hint` option.
> +
>  .. option:: cpus_allowed=3Dstr
> =20
>  	Controls the same options as :option:`cpumask`, but accepts a textual
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
> index 2c9d87bc..81e6c390 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -40,6 +40,7 @@ struct cmdprio_options {
>  	unsigned int percentage[CMDPRIO_RWDIR_CNT];
>  	unsigned int class[CMDPRIO_RWDIR_CNT];
>  	unsigned int level[CMDPRIO_RWDIR_CNT];
> +	unsigned int hint[CMDPRIO_RWDIR_CNT];
>  	char *bssplit_str;
>  };
> =20
> @@ -74,6 +75,21 @@ struct cmdprio_options {
>  		.category =3D FIO_OPT_C_ENGINE,					\
>  		.group	=3D opt_group,						\
>  	},									\
> +	{									\
> +		.name	=3D "cmdprio_hint",					\
> +		.lname	=3D "Asynchronous I/O priority hint",			\
> +		.type	=3D FIO_OPT_INT,						\
> +		.off1	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.hint[DDIR_READ]),		\
> +		.off2	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.hint[DDIR_WRITE]),		\
> +		.help	=3D "Set asynchronous IO priority hint",			\
> +		.minval	=3D IOPRIO_MIN_PRIO_HINT,					\
> +		.maxval	=3D IOPRIO_MAX_PRIO_HINT,					\
> +		.interval =3D 1,							\
> +		.category =3D FIO_OPT_C_ENGINE,					\
> +		.group	=3D opt_group,						\
> +	},									\
>  	{									\
>  		.name	=3D "cmdprio",						\
>  		.lname	=3D "Asynchronous I/O priority level",			\
> @@ -112,6 +128,12 @@ struct cmdprio_options {
>  		.type	=3D FIO_OPT_UNSUPPORTED,					\
>  		.help	=3D "Platform does not support I/O priority classes",	\
>  	},									\
> +	{									\
> +		.name	=3D "cmdprio_hint",					\
> +		.lname	=3D "Asynchronous I/O priority hint",			\
> +		.type	=3D FIO_OPT_UNSUPPORTED,					\
> +		.help	=3D "Platform does not support I/O priority classes",	\
> +	},									\
>  	{									\
>  		.name	=3D "cmdprio",						\
>  		.lname	=3D "Asynchronous I/O priority level",			\
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 5613c4c6..e1abf688 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -285,8 +285,8 @@ static int fio_ioring_prep(struct thread_data *td, st=
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
> diff --git a/fio.1 b/fio.1
> index e2a36327..f62617e7 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2084,6 +2084,14 @@ is set, this defaults to the highest priority clas=
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
> @@ -2109,8 +2117,9 @@ The first accepted format for this option is the sa=
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
> @@ -2123,7 +2132,16 @@ entry. In comparison with the first accepted forma=
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
> @@ -3150,7 +3168,8 @@ I/O priority classes and to devices with features c=
ontrolled through priority
>  hints, e.g. block devices supporting command duration limits, or CDL. CD=
L is a
>  way to indicate the desired maximum latency of I/Os so that the device c=
an
>  optimize its internal command scheduling according to the latency limits
> -indicated by the user.
> +indicated by the user. For per-I/O priority hint setting, see the I/O en=
gine
> +specific \fBcmdprio_hint\fB option.
>  .TP
>  .BI cpus_allowed \fR=3D\fPstr
>  Controls the same options as \fBcpumask\fR, but accepts a textual
> diff --git a/options.c b/options.c
> index 56672960..48aa0d7b 100644
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
