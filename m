Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F952EB64DC
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 03:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGSDP5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 23:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjGSDP4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 23:15:56 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE5E1BE8
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 20:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689736554; x=1721272554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WzrNx2d65v1x1dYYsWnb9cDzD3bHKXJI9+WDS4hC6uE=;
  b=rWPB8oKFKMkygk5BlxrPUvS15e0f9baXAwhe27dzAG6QA3laMtt/iQBm
   g8UuaegkApyE6cU/ItuzGX6M6Z/rNXfXQTMrPGed+eHNcm0SVpCaVbUdj
   eU+WZiIJ4G3bbjTTM/21yZE/hIZn+5tvDk3Z83ItiNMTL7gQR/bvIQXrW
   mxaN5e5ar4nTvwqljaLq9rm+Pa5UVZnM1reAqsD9EL0cFkOaEK03CqFoy
   hlGBw+J+WgiikGN+yOcT+m0ZWwPYirQrxheASTQjCjFuGuG07OMC+pRXm
   zty2JzT9dl2UxIfs+qWesVt7NvvpF/psNTfu8OfqL/oXabb/QH+UkabLp
   w==;
X-IronPort-AV: E=Sophos;i="6.01,215,1684771200"; 
   d="scan'208";a="236833739"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 11:15:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWjNYBGXdtoTcLOMCzD7/vGHKJbvCoCXGJcWlwrvxGhc28h50ddL50dPr15okAoMjR3vqCuFVslEtUK9yOvlv8clPoWnVruXpiAxKeKiDW9QsuTsmqujIqroqhvQM8l4dRRNkCT6HQo0z2D5xX9BMXHsQGcMvpIjwtDBU4qK9WUCx+ANgyIWor+kDQZDynDzLNiBVB0Cw+8YQ8UgTR47iyN+MfjSDlRFC8eLPOhlDaqekQTTt3VFkV1AwVHouNqIGq7qj0Z7n6ivIalYXOsTtmd2XI82MUedZYVI0cGSLI4+LIbnpSQD4IuTGs/JFSVDSMowljBw5jXPw8X9mjROyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xrc8uZPKiA9usPuI6WH+OzqlA1UN3NNVHZ3phHRxYcU=;
 b=hr1FerUZXL1Ii5s/7KOlAW68+cRm1xXENxu1nncFKvgyl2LefIGXn41q9+bYba2EeFKgHFNJjRxLYYhkFvGBp0iv5HMLUmFxqlc+GiZodA4pecNPoeAJuOUobeOADgXMTrPolocUGQHCnqjfujMZcZci1YmudyhKjeeRviPItsSXU/4CheY/4Yn8xcuj/4gngoHurDx9rLJhxDZXinwB9i6TmRkQJrdIxTD4/yuGh5285n0p3sqyPKrRvikYb3ZgCigfeAJ6kuV5DL7DXB0UI89RSB9MnYNhORpICbgpkVAGiUrw/SCDxKPqTRsaxYAv9I42GfoYGPHlRKAHt3CLoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xrc8uZPKiA9usPuI6WH+OzqlA1UN3NNVHZ3phHRxYcU=;
 b=n1TfrSrVcV7J7ApTpJZY4R9TPUbvZERj9wRzrq5xVZb4tEu3JEfPRsrGKG2/qBmdL0p6Yk7Ae6LvdKCHqZ+xMgHDHPzZP/I41y827uQCDHrIvy3VQKWfbGXj6MCLqv+C4bN/wzz2TviC7jxw67QkpU4dsLMSxzVuPessancPjK0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB8053.namprd04.prod.outlook.com (2603:10b6:8:c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.23; Wed, 19 Jul 2023 03:15:51 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9%7]) with mapi id 15.20.6609.022; Wed, 19 Jul 2023
 03:15:51 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 04/13] docs: modify max_open_zones option description
Thread-Topic: [PATCH 04/13] docs: modify max_open_zones option description
Thread-Index: Adm571JGBPUCpxIAF0qSifIratkJhA==
Date:   Wed, 19 Jul 2023 03:15:51 +0000
Message-ID: <mo2a2vkwapg42nj55qil6izm2ivkmcnmhssx6utjswpmcmkh2q@7xiz32u3rsn5>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-5-shinichiro.kawasaki@wdc.com>
 <ZLaZ+rxgwKALiHG2@x1-carbon>
In-Reply-To: <ZLaZ+rxgwKALiHG2@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM8PR04MB8053:EE_
x-ms-office365-filtering-correlation-id: 850377f9-789c-41c7-4869-08db880674c2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oqry5OSpLRI1KIT1BLBZq0fA1HgWtgnJYNVly32/3TJcPohnASrOo8Wysa2RypzzkwWGVO1QQA1oInoNR6k+8dhOZeBys/CKJ8lp7yWp18o98b0l3myya9uOixl9OGYKHl3GfRm2ViG5Erp+RYrLmfEBMZ9gK+Y8jCOAWf3qV6fBQ0H4jBI+SeVFGA3vzZvZXoivsqOzOEvakr8wM1wNejXpP6T+yx4ZJdYeRwUvxEKsW5sMGboT1gm2WENPT2y2LRGBhiBEI4jQBkd0PVQSwRifcD5jyWjenVOmdrWDPmQPyaD3qF63KpnFCpGAflibNDgiPr760LM80WGy6t4O6uwTM3+sWt5eWgzJtge2QnLhWv9JdYW9aBFv99fYF4blOS3jMUnQQvKp+pYOUdvlY2RT1QmZ69eTloKYwANJpEqQDJR6tTROOjPpIM5di5JbfFeD6re7uVGGZmj6ANk7/5/cQBwRyB+DSOvoubQwC8VbTOpkGEDND1rKxY8f8Z9GKRdLilX5XxK4J1vyG0H/rrpe5zgT9q4X8jV7W6zkbGGGe5udCY/cWJ7LcmbDO07zp7fBR3zc9S1utSQ4Q8dPIFDqOyQ1C0VDBaKtmsiet1iN4Tc73of/hX1hM7l15Rwj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199021)(2906002)(44832011)(8936002)(8676002)(33716001)(66556008)(64756008)(66476007)(6862004)(4326008)(6636002)(66946007)(316002)(41300700001)(5660300002)(66446008)(9686003)(26005)(91956017)(6512007)(6506007)(6486002)(186003)(76116006)(478600001)(71200400001)(54906003)(83380400001)(38100700002)(122000001)(82960400001)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9fjla+vW+2TQv/MQY7au2LcrqaRBqZiMthZilqckt+CdK3eydyja2vUDFgtS?=
 =?us-ascii?Q?e/xnxGoXaCGoQZ26ZB0xlNdkgVNv9wmM3Je/QSVxd6uDzXPv9ASS6MwMVMsj?=
 =?us-ascii?Q?w2VHKWVNts8Z+qeKZ3wq4v22RHsfBP/GjPzJgRGE2SjX2UYcO1gFnASxP/oS?=
 =?us-ascii?Q?WmsCeqjW1PRwyDBRX79AcznSXR5lCbXUCyM6/1wCiW82rkHbB3rx5jvHAjD3?=
 =?us-ascii?Q?2emE+BKa148rDFd+twu8tEMFLI2pT7w60NuJq7moxBh15yBBupugGioUBhRu?=
 =?us-ascii?Q?VS6rAraU4IDSuhyzwPnbCd4Ss+jEUyvT5qHZyuUkWBoEb1NEY0ZL+zWwE9kt?=
 =?us-ascii?Q?Aii3PxM9zYqWOd/JSw8vWbr4gs4UdkXrEQr5YdtIHJORKOSggdlxqhfWHtmk?=
 =?us-ascii?Q?6OpyMkewae8SvlGRpOsbTbk9hREa4CEajCTJll9dAGnN5zmZHtVZyKqYMtJg?=
 =?us-ascii?Q?5+L+e/FdrlPhTAXEMWv3jafAcDvLhGwmBcW+7soX0h2I/KceXvYD0YtVObuk?=
 =?us-ascii?Q?rW5R3gfMYisSZawxc/nbMfugakLxv2A2IQ+pFzbDXGeF1GaTZfbdGXZ6MuO7?=
 =?us-ascii?Q?Ye85pEkCMK7bur1eUKH8PpRzsFg2w+KUyX7cL63U+FNUAXgOo4JxkTz3zDVc?=
 =?us-ascii?Q?ewwEYCTUlwa8XukHJDOgMOPRKwKmYVwLxmvZLxShJTUIOk52jEsjfuEYoixH?=
 =?us-ascii?Q?bJ4MtS3Ig9rckjwTYWpNcrVYJZSKg/F/hLQrit8KMjrrAviaW7UrdyEHmSQ6?=
 =?us-ascii?Q?qyxmxPXs8qM4C3JtnD+vRGGjitQnw48azhWBzbczonb4jB9SdNYY25zHGlMp?=
 =?us-ascii?Q?NQAS9+qNP8v7g4l7OcsRu8s8c5te1fU8DN3ZdubrtCnebsllhl2T7V/yCxEY?=
 =?us-ascii?Q?aqEKVRaM+yFQv9fcXkOmUTNVsE6xpSgWJ/50JjX2qm37A8rj0lpdR9fFD48H?=
 =?us-ascii?Q?zJCjGeOLXN6LsiNNvX//xhIBXFjbibQlB6gbSfFHPD00Ptg+TLpL7nEy5gJU?=
 =?us-ascii?Q?bqt9JGxjIcc4YRfm2JV1/T7tiNN0EIKLlH63OSSPXGxMQ2Xpoq8gBekceRFx?=
 =?us-ascii?Q?MORV6HwrqU/lx9FMdjkC/Kn6n50D2gV/irt0nTH5BvFi6UmS+HiKC+4K2/4e?=
 =?us-ascii?Q?+pLDWzFfxcNin+j4r+XR/keBueIoQ1y2d6ZRuA+ASyjKD+nF7jfUnyEiIGf/?=
 =?us-ascii?Q?mI96cdVaw81xZAbqRrN5pQMaA9aLrITTG9qIInWUhamWoUpGHtRivzqkm2on?=
 =?us-ascii?Q?OUP1uef0Gd8sn11EuKmA+SSWf0/xFLC7Jteyukk7pQWIWraTspZK6ahJazSM?=
 =?us-ascii?Q?biheNgbzJknHHr7JLSvgFjkl2OAxrnoyhuZ2nmc4XRyorYcAzZYg99TQIX3a?=
 =?us-ascii?Q?2gvfqXXtdQSZ+5w4Hl6PUMamg9xPKZSMMbRzMnH3VWW6n+GHNyb1wY45i7ZV?=
 =?us-ascii?Q?VCxeyyh3+SBihaGtkFohZJr2YxpqUbB6Lgt6B24fpEuHpdvA8ZWHF0G0s/Cc?=
 =?us-ascii?Q?896JT+FqcIBmtIiVuMDV1sLCsevovQN6X80UjNfF+eC7w+oP8V39oVkbZOL1?=
 =?us-ascii?Q?CbFDXjM6LbdB3v2xq63Sal22cn5ZeIRcqw1YJBD1v4SFOYS4dytz0Z3ID3uN?=
 =?us-ascii?Q?9MY3lfijWt2VeXBqQea85AI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4EAF74ED154F0D41B8B54DA30146DA9F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: L+ZOC5H44DbAliCs8OJ/kNVeyqM01bWi1XHmnZwjSV4ehfTEm+meAEr6XVC0NcFwA+4ZxVYuhEdiq9WR4JLiYP2oiDLs4SBKzmkKIL07HySAnTOYGyXykBqYx69KVi8QJ78zk7PwlaS+DDOmrhltEq+fdh3vwEoHddlfmmdd/0Rj3Q1WwON9KR+K1evx9TCqRDPcVX+4Lie9fX0BgJdHM1G6yeUoDOqTo4uYyONGLHK1VX4bygRmQUTsXlQ/Pp2TrXhb984NAQnwt/xJPy0F3oVFuA2j18Mp4VD4Rhq7BBfy1Uelky+cuyuwC0e+27wkXQvcZfpwF6hR/dj2bIV+p75mAiy9XZ8IDJPkLep8PzT/PaM5Y5dZDILNGza4QerwercG2GzU+9PFYECtuFuv6WFge2CJAW/miuPAV3S5ghJZLhnl+ChS4gnARHJMIdpzwp4VyGk5awLC55z3T9xP2xTB727ZaRvMLB+ac6rzWVcT3t4X3nXJiQFF6kG1r+FPj68ja5rmhWonKZYbb28PR0LRMxcA20oXy9zI+g7bo/+tckI8pQRIuHt0+3IRQtT668X6yckN6ZOAz297W/vyjbT/dkun5YwhsZT42UfzEomJstT/u0UY7Q0UiGaNUuezDXj/fD496uqWl8ItTQorqpzEy3+vhJzMv+y/KatBpodXHSbhAA8ss59xMKHVaBB6sU5NcmrDvp/+TBk/OZP5uzImbLkikiH3+TwQxifQY/l6R+19zVpQMYnNDptzUYftBJ0UQXYER97bqdJlnDtkfkgO8jMEQtfrdPZzzBcDiETS+8qI04MvBP+eIm9Hcj4ANtDMWjo2EMCWYLGHU/HSDwm2ApmtCOaLMACZxpw0YNg=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850377f9-789c-41c7-4869-08db880674c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 03:15:51.2987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xx9615917bOhKJIywQrf2gOieQcyf4Ltt8aTUK0nVYzq8RYh05mOzMm5WCkbbNpLCIS5HwdjOP4XeYu7qhmJUB5+SB45URKppo4GCmbdnJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8053
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jul 18, 2023 / 13:56, Niklas Cassel wrote:
> On Fri, Jul 07, 2023 at 12:14:56PM +0900, Shin'ichiro Kawasaki wrote:
> > A recent commit modified the max_open_zones option to improve handling
> > of zoned block devices with max_active_zones limit. Modify description
> > of the option to meet the change.
> >=20
> > For that purpose, explain the relation between the max_open_zones optio=
n
> > and the device side limits max_active_zones and max_open_zones. Also
> > mention about three zone conditions 'implicit open', 'explict open' and
> > 'closed'. And replace the word 'zone state' with 'zone condition'.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  HOWTO.rst | 44 ++++++++++++++++++++++++++++----------------
> >  fio.1     | 36 ++++++++++++++++++++++++------------
> >  2 files changed, 52 insertions(+), 28 deletions(-)
> >=20
> > diff --git a/HOWTO.rst b/HOWTO.rst
> > index 2e1e55c2..4d50ad41 100644
> > --- a/HOWTO.rst
> > +++ b/HOWTO.rst
> > @@ -1056,22 +1056,34 @@ Target file/device
> > =20
> >  .. option:: max_open_zones=3Dint
> > =20
> > -	A zone of a zoned block device is in the open state when it is partia=
lly
> > -	written (i.e. not all sectors of the zone have been written). Zoned
> > -	block devices may have a limit on the total number of zones that can
> > -	be simultaneously in the open state, that is, the number of zones tha=
t
> > -	can be written to simultaneously. The :option:`max_open_zones` parame=
ter
> > -	limits the number of zones to which write commands are issued by all =
fio
> > -	jobs, that is, limits the number of zones that will be in the open
> > -	state. This parameter is relevant only if the :option:`zonemode` =3Dz=
bd is
> > -	used. The default value is always equal to maximum number of open zon=
es
> > -	of the target zoned block device and a value higher than this limit
> > -	cannot be specified by users unless the option
> > -	:option:`ignore_zone_limits` is specified. When
> > -	:option:`ignore_zone_limits` is specified or the target device has no
> > -	limit on the number of zones that can be in an open state,
> > -	:option:`max_open_zones` can specify 0 to disable any limit on the
> > -	number of zones that can be simultaneously written to by all jobs.
> > +	When a zone of a zoned block device is partially written (i.e. not al=
l
> > +	sectors of the zone have been written), the zone is in one of three
> > +	conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block
> > +	devices may have a limit called 'max_open_zones' (same name as the
> > +	parameter) on the total number of zones that can simultaneously be in
> > +	the 'implicit open' or 'explicit open' conditions. Zoned block device=
s
> > +	may have another limit called 'max_active_zones', on the total number=
 of
> > +	zones that can simultaneously be in the three conditions. The
> > +	:option:`max_open_zones` parameter limits the number of zones to whic=
h
> > +	write commands are issued by all fio jobs, that is, limits the number=
 of
> > +	zones that will be in the conditions. When the device has the
> > +	max_open_zones limit and does not have the max_active_zones limit, th=
e
> > +	:option:`max_open_zones` parameter limits the number of zones in the =
two
> > +	open conditions up to the limit. In this case, fio includes zones in =
the
> > +	two open conditions to the write target zones at fio start. When the
> > +	device has both the max_open_zones and the max_active_zones limits, t=
he
> > +	:option:`max_open_zones` parameter limits the number of zones in the
> > +	three conditions up to the limit. In this case, fio includes zones in
> > +	the three conditions to the write target zones at fio start.
> > +
> > +	This parameter is relevant only if the :option:`zonemode` =3Dzbd is u=
sed.
> > +	The default value is always equal to the max_open_zones limit of the
> > +	target zoned block device and a value higher than this limit cannot b=
e
> > +	specified by users unless the option :option:`ignore_zone_limits` is
> > +	specified. When :option:`ignore_zone_limits` is specified or the targ=
et
> > +	device does not have the max_open_zones limit, :option:`max_open_zone=
s`
> > +	can specify 0 to disable any limit on the number of zones that can be
> > +	simultaneously written to by all jobs.
>=20
> While this is a wall of text, I don't really see a better way.
>=20
> This option really controls the maximum number of zones that fio will
> issue writes to simultaneously.
>=20
> For clarity, I guess we could introduce a --max_write_zones option
> and move this description there, and make --max_open_zones an alias
> for --max_write_zones... But I'm not sure if it would be worth it.

Actually, I also thought about the new option --max_write_zones. But I was =
not
sure either if that is good for users, and just chose to keep the current o=
ption
name. Let me keep it as it is, in v2.=
