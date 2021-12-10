Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FE3C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240833AbhLJMJw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:09:52 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21079 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbhLJMJv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:09:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137975; x=1670673975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KpWIH/p0LIkLMd4Q3MUbS0yEw24C4ytWJ9Lb5oC3Fb0=;
  b=rC+YRt/fM2bY4GCI06IOpsLRNoj0vZXvhWJ0A3DJGjekqOPrLDBMKyB6
   wu6zOfjpg1UNBSq9QGKp9eiqG+COPDsq7IhH9WNPWwQVLnepu4KZu1UuS
   OVgp3ERE1LkIS+PqI3+TtHKOyXiM1tGFTB5Wtu1LYZial6f/WSalVceo4
   F/O59o6sLqqxymQQYNUV8Rmdf6GbJyx7FTfdOGnX9de8INeJkMidBOG67
   K3qkdZNhmBwBdY/d7gi2tmujQMITP/FxoPa17PYzjyD/+GYjDb8XwNnVR
   mrWjmepPYHD7nBLiQHCNsGsGs6jNULH+f1VW64GS2AAc/sDFzvISvNaLQ
   w==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="187936304"
Received: from mail-mw2nam08lp2172.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.172])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:06:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOdqQ7j8GILF06SSZdjcTJBPq2bFMTA/p16ynQk9fT+5fO5wu70nruH8A9bDWkCHTgmeJ1usF0hcIiUgfoP2aa/MI5FhkYMXwnORzH9cIsVsvU/LAWruzMzno4xCDFdxFi38/2qMuPInqVR22sWPDd3l3gEEzNznZYT3hCw9vt3VWZnd+VP0rqFgBrkRIdWwAFz6oaF4rjlDZfHRrqqmhr7mqbPzW7UV5xtYFM701c1isovFWtVxwYKq1Ig16CVwxBCtaHrGP4PBvtdm2/71NBSG8dp6craW7MzYyjgnHoMG2BY2ebhayhpARxXUdfIG/uOz+07yJkt/J02MiZuxrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpWIH/p0LIkLMd4Q3MUbS0yEw24C4ytWJ9Lb5oC3Fb0=;
 b=ZORW+wKoEoAXO7s5CTfGXPXDDp1g0sSCt9MdVkjvtRTrwg6X81UIrFTXKWwq98mHgA3kF9EAM1sB/v48WTXrPJck/CGNEW9vfkRwlx3baOZy5smy4oWNunUw7zu1mmVDxV1Kq166xzZ7sv+eVUa1/oRef8DZqSsgrYXKJdjkihm698O7yKvzcllz3ydPBogOovWsoyqcQ1AYJS9NRXjuXFK4AmjD2wh4LWq0fI94vybc435yDRKJN9nwUnyb8G9n8zlysUvp6ZUL/qHpKCAnLPRPcOP6h7l/4knG2yitOxgT18vzfDumBn9c95KRbL9pf40qVrKw98prPBQScvNIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpWIH/p0LIkLMd4Q3MUbS0yEw24C4ytWJ9Lb5oC3Fb0=;
 b=I916hElQeTg4smy03u2rzxLnOFzDw0nfKj1a9WNA+VPztGoZ4WORHIW34mc3aCbOM2RbXzGsg7+lhN8adY9bjdAw4O0LvSdZTdOdBZmHfHquXGQ4YfJ5eLQGxv35c5xMgCdOi+HctWkKycx072NakEiZ+I6gBbsezGYfySF0HNc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7302.namprd04.prod.outlook.com (2603:10b6:510:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 10 Dec
 2021 12:06:14 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:06:14 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 08/11] zbd: simplify zbd_open_zone()
Thread-Topic: [PATCH 08/11] zbd: simplify zbd_open_zone()
Thread-Index: AQHX7WwAv4+2mawem06fapZSp0unEKwroc0A
Date:   Fri, 10 Dec 2021 12:06:14 +0000
Message-ID: <YbNCtCf5rnYZ9w2J@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-9-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-9-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8bd6e0d-d25c-482c-1e6f-08d9bbd57700
x-ms-traffictypediagnostic: PH0PR04MB7302:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7302C0615B9E7A2C755036DFF2719@PH0PR04MB7302.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDO9eWYArhN61kw/YbJblo8VkCgU1rGNIHQr8GAaxQ5WGdZ/Gwp8QwQcUH3xbkBNzSilS2oHaIXRU+RKhNzkg/Q1amU+jZxqcY/zyK5SiBEqip5IS3Z5oQh2ljhXf1UKDWqf8gRAzGMtyP1VOhdVeu4LFhTtrH/1W2n8srG8Cch0zryHt+OagenA2o+9Cm4CZdtm8HRwtYe7pXnf1ThVlBoyg1+nrY5FAl0SGuMuut/8LaGmm6WeyW018+rDL1IScF+jODXIuRt5ZG1RIIx0CW3wzSU2Pg+JjWqvWplQZAocJiMwQJM/Em95RgDWhdXH8Lt6M7SWV+fJqPs0pRlA93+ySkYkGmOsOJTDYCKonT+xYGJiHScidNeFQOoiYzoN7iOY/8B/iVjDaK5VuK1pSvNiw06IHTN+4Y9TKtbZeNMYlFeHNuAoyHwafT037uEHOPpSkNCrQFIHPigy16/AD3h3eQpCDEBacqMYCq3/zC8x22EV3x1vm0BXDMMCWqBMYKcvRfemJu0RaY/crDovpTalo+XGYee4opkwK/BITBqFwn9ycfttHMSTGgPXATw1TMwp7o7CWPm6RbQhkoe2s6q8DRx3xrXyzQ685ijizOQFlURNmVAu8X9tOOlOXmThRWKa6Tek7MWciXu1QWKylD+MkGG5IfCDSg2xkGcs0pW/M8jccm0S8PEgixtWHXxsM04pq5fUVk+Xawam7GymFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(2906002)(91956017)(33716001)(8676002)(76116006)(122000001)(6512007)(38100700002)(508600001)(316002)(66946007)(66446008)(66556008)(66476007)(64756008)(54906003)(9686003)(83380400001)(82960400001)(186003)(6506007)(71200400001)(4326008)(4744005)(8936002)(6486002)(6862004)(38070700005)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cGs0ok9d4zxU5jRkcNb1ZUyO4X7ytIMstvETWZI+i+pVJIsJnHyyeL/VPfop?=
 =?us-ascii?Q?rPt8cmFRf/60yv9Ae8uZAi1a9pfwTfWRz7JiD7BU/P9Zl7UQjVaLitmQBSWN?=
 =?us-ascii?Q?gPC+/es1BsJq+0URB20PT/Waqfbg16X7Aytpl/j68DimQUaBmIsKEo69GyNY?=
 =?us-ascii?Q?/QT6k/mUdkr48H6Xavpl5kw439VHON7psFQnELaUzJ2IVqhOOZ/OwNeo/VS4?=
 =?us-ascii?Q?Okak302DtnFOrp/ne5655WvVaR0j4RsLCQS9Q4sSs+BwugS1f3ej3kSQnX82?=
 =?us-ascii?Q?jbTc5UZ/xIa7X1zgRONkSgdgobUimmuAhwWw1ciN9kKTfgQpsEFumduyuoME?=
 =?us-ascii?Q?Qrjv8FmTK0ZSwpGkpwkE4HA8Umsx1POxoz2lQYCHs9eDvcrySM/qvYFYlszW?=
 =?us-ascii?Q?tIat3cBf3qHwSAFG5rZTeXl2oYZpxkkCXiV0mlimPXKWRZAeS1c/S9cshQLX?=
 =?us-ascii?Q?lDAH1aL8Y7XyvKMbYFnrDpGi/SnAWMF0lLzke4epnfGKJKVqxhacsyBs9A8R?=
 =?us-ascii?Q?gapk1DQKhUvjyIm+3ETopBMZHpM8jxTum33QAeZaazSgQ/KydSb9O1lbVOVJ?=
 =?us-ascii?Q?6DZVINRILWKJrRR5uoJjQv1jPW6iy/7bl+13n/9WbzQFMktUavLTBmXXXVQR?=
 =?us-ascii?Q?o5I2O39K2EkOry8pfEQuPwq15yIRvFI4ml2i5/Hv1sk1NERbJrMY0xUaeFNn?=
 =?us-ascii?Q?ZDZyospK37qo94CzS9b95nld9HUb1mV7Zs5LA3Ufus4nkW4+WQK2ybpxJbhP?=
 =?us-ascii?Q?Su4M7EVeiiVeFwhc5qxMVICKxjN/yDq6rmqx68sOkm6a4eh0CduRl8ctUmu8?=
 =?us-ascii?Q?2PhiTEQyOXAS+uDkjOoEVWpxVIzvFL4lDtHuK06WMXpXoZ/suJG3+ij0yCSP?=
 =?us-ascii?Q?CxHSnG7gdwsJMifFEbh9g/jVrPQMieislq3KuDPCR0tKhFc1Uua06WUR801w?=
 =?us-ascii?Q?8fl9vkogk03lS91lIsBDK7Zh2Kpe7HKYPPbCMsQzfhTn1UcGi5M1KnZ5z1VG?=
 =?us-ascii?Q?eQcdC1RzmHhB4bQ+bPBHY6U9m5xqd72thhNG96s7sjHzK+HVppsnNH5/UL0w?=
 =?us-ascii?Q?B0lFjjxdnFLCHlJK6RTlWrwhzMYhbm9K8DuFPGbWpKcBFzqDLd0Eu8a8M8jc?=
 =?us-ascii?Q?M7Alqva/rhfXOWHJbHVcSPGmXhrXcd9Er0n4oUoOqDZVvso94vFFX3jN/1Lk?=
 =?us-ascii?Q?grbXzg+WHkO/n4qBJXxsuWj6ErIp5DcdH2zmcAEgeyal39I8//Kw5lvWANGA?=
 =?us-ascii?Q?8u50ajBxzGSIgmWEwLDCNiqD/w7Bi4gTlqPcHmT29LMp52m/QGAdYRQpqij1?=
 =?us-ascii?Q?TxgB7eUcouBgIbHUvbMLDZC8ofAd+jTXMv8AKBOOhkb6G67hFruwni9+fFP7?=
 =?us-ascii?Q?1nz46u/cJp+7kXIOFF5v9sMXeYKybGS0ARjQZQEObLUI3/2qTN/4b3Mko3w3?=
 =?us-ascii?Q?iHE46Efl4zmJHjdO60wQ2kJMhs7WgJoY7uzhWFri4yQFll41qTi/6ukkPg2X?=
 =?us-ascii?Q?+Y2RpDDJiZ9sPMOi6OS3h2GcImzVy5Mf0xDjyDty1DYF3LiKsH/QD8LpN5mX?=
 =?us-ascii?Q?8Vok9gKjYOmzNVS14JDSSBRlPqbqMHMoOG9vxdptw4O4ep/7sVSQTj3pBPnD?=
 =?us-ascii?Q?0ibRdNXPesaGSsz0G6Ohd5k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C23A99336BE15B408D7B46ECE57A5836@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8bd6e0d-d25c-482c-1e6f-08d9bbd57700
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:06:14.6519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jgz5RyfiSjq6RqbLUakhnxQZ0wlNw0HBdvg7RXfkr7qNtTrLvS+mUtso7QvI6oMdJlLDlQg1ZOZG0g4TfGm1KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7302
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:38AM +0900, Damien Le Moal wrote:
> Similarly to zbd_close_zone(), directly pass a pointer to a zone
> information structure to zbd_open_zone() instead of a zone number.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Nice cleanup!

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
