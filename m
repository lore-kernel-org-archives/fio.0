Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9886BC433EF
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 01:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiFBBxV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 21:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiFBBxU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 21:53:20 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19A1258DE5
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 18:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654134798; x=1685670798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=95CCYxsEe2KcP/ZyusqRxJ7gZmZb1YCZT8AIqM+flpQ=;
  b=BuhbJpvkigQ8t6wqy6pN5LwPn3ErmPlffNbHAmqceulSfInJs4vAvZuS
   uaFb0SXiWAGlT+uisOQNl6jtDeUWIY858dE5KJJY0gyXRIxN1y77PCNYG
   14u9mg2y32FR93DuEtINpL/ty+8u1aduAPx+bjcJcDNbGXk1b559i9jvb
   JbSORSY5ij8Oi+/TGmQETYNBV0zFz98I6KmbiRq8UlrJamUbMFi8b+d2r
   JyeBsPaEij8VStrQz4srUCO3UoxXaYzLhfrIMu22tQ0qu45uP8BH7IA3h
   MCxabwa4va9DFn4nUkRc2R3Ram4uewEr7y/mGChgHaJ6ZWdEkeKHq35Ll
   A==;
X-IronPort-AV: E=Sophos;i="5.91,270,1647273600"; 
   d="scan'208";a="206911412"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2022 09:53:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2nOsqkbokHjBfEwdweHC9689Hfg+pr4iBSl4fRFf521H+cm6BzlPbSgllK60z6voF8Mp9AqIOGNfAZY8H9C5ArW1WpCCmSXKDhQ9nqi99qBfQaz9vZYVJ9y6vOyhjNenqC+Z9FPrekSuR/URg9p1gGYFX/FyVoAKIpjqcbn1DXQbgLQL8/on0Zn53PeQwuxtbqv3dMleW4RaRZrveOn1mGVMwN3OSY3ry7DnvUNDFeUzHFFhI78c0PZOc2jOEX9qQlW6FTe1u9wEaZezK6TMRWUy8Li3P3S4NYMPGtvKGNmjTaSh1D2c8cBh893Jhe+VTYS44UBgZlk/pUXgXLYjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95CCYxsEe2KcP/ZyusqRxJ7gZmZb1YCZT8AIqM+flpQ=;
 b=ObPuFUSBaoOw6ZGVKD0NXyurpCCGJEZA79FIMIsa3DMULSgdQQ+zjRL3xHEA9xzPMzF4YgAwCzEckUfYhUMQU46V6tJiLEDRSZy1GufTZFArWH8qq87ZFUAn6Z8Fyn+oYmWYehOdabv4yH3skHoicIbXh4ao4EvotgyMS6x8DTB9riT2Nnb1B3OACP20XnqoR765oXxs/p05LAvoQ2bahXj0EVxwEfZzrIHNIDGAf7FRrtwpADDAo8K7S3qD5UxT7+eAWd++sqv9lVf5YMQEPsazwSHI53qnAZqAz/JyhqLNBF5JzM2juvCK53pmXFeihMlTFkOWt/LHARjTIselTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95CCYxsEe2KcP/ZyusqRxJ7gZmZb1YCZT8AIqM+flpQ=;
 b=Xsa4D9QkUipoEpa4VJJB44fTfME58/GbT1Pen8cWR+bPpnY1dpWuYcusY/lCq4Xu1wOYBsNi5ILnN+EyZsnQqw0fL6lqn36clX3377ukrDyKJ3SmKydBE1PoNfxfF0LPQvGcjkwEomMcxqwX/lr+pR/vS9JTXaavd5FsBaeeF5Y=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN6PR04MB0339.namprd04.prod.outlook.com (2603:10b6:404:17::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.16; Thu, 2 Jun 2022 01:53:17 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 01:53:17 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Vincent Fu <vincent.fu@samsung.com>
CC:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: Re: [PATCH v3 7/9] zbd: Check for direct flag only if its block
 device
Thread-Topic: [PATCH v3 7/9] zbd: Check for direct flag only if its block
 device
Thread-Index: AQHYdZu1+yDl6fdLbEqY06BAXhRfF607AlUAgABZgAA=
Date:   Thu, 2 Jun 2022 01:53:17 +0000
Message-ID: <20220602015316.6ismlexb22fwd5ko@shindev>
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
 <CGME20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8@epcas5p1.samsung.com>
 <20220531133155.17493-8-ankit.kumar@samsung.com>
 <547f643d9ae54ee5a5f173115808b6da@samsung.com>
In-Reply-To: <547f643d9ae54ee5a5f173115808b6da@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6cbb7de0-94ec-4dc9-62b0-08da443aa9b2
x-ms-traffictypediagnostic: BN6PR04MB0339:EE_
x-microsoft-antispam-prvs: <BN6PR04MB03398D78C7D646B3B88C0B7AEDDE9@BN6PR04MB0339.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: USzTERnFcITWQBIVp987d7OgNgVg7UA3F8APYE2BgEnXUbx4vcZK/Ypaq6BaqKWalvaZRAwna3sCNRCDv9Etps4Jbddaj9JSab6vJDq8cUZUsUr2Xkp0pAaBfTVZdc+dON/Jms2TWPUSGjuDjAlYCd/dZeKtdpNdsQMcMQwv1626D545caf5z5kL8Kwn7V66M69RD79IL6ItheFSRPtw3fA0wyWOrRfnbEwDcW0vyin/bZj239EZ0YPYLkLFd+09DNmUmOSPx5LqHqrHnIBOZJCZ211rs4SamIj9uSsxMpnOI0UOErHojslJvoailek9IjUQTEOsXE2hH59kT7nYRLgkx0O85Wj7gXOdxuIHnsfakCGCeey722RgZiL7at0hCgDjlErE6eNxj4Md4fStt6c4vI3SnFwyEV9EMdKvX0+ErQ/PO3xs6Hgl9/J+tiOP5hfqDpqlqZh0A6gGimcK/QZSQG7d7WvXJies+v/i72I1rYubPjFF/0hFIYeOh6Fi11qHCPXI69BKOeDuxPsguzMvuTUCo6pv+yJBD5OS6qprM8wz2iHBOvIhbZyU3P7H5RJzaHjCIrixBJSOITPL4ICck/SaGffGZiOIa0UKTbhBQWZKFcxn+u43YyPo/5qidjoko16hPNQ5n+U/2vTSEVPW7p2h7Zts/c9R2K0Yffdxn1D1gtQ1y4l+SrzhafGShQCGYHEXx1kWOxDo2dzSAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(44832011)(86362001)(38070700005)(316002)(6916009)(5660300002)(2906002)(83380400001)(66946007)(508600001)(1076003)(66556008)(66476007)(66446008)(64756008)(33716001)(76116006)(38100700002)(4326008)(91956017)(186003)(54906003)(8936002)(82960400001)(71200400001)(122000001)(6486002)(6506007)(9686003)(6512007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hdkAYZH9rdAUGmJFucDPwCbd6bD5Y5xTj7veczpuCcDOyN7w635SuixZV6lj?=
 =?us-ascii?Q?aGZvZn+ys+pt4p96ddDNxYYg+RN4q0p/8t4ohF4v81/Cj/DTS5YD8mHsh7qU?=
 =?us-ascii?Q?xTOjYYA2ak51P1Z5GgM5FvCWZH+st1t2aJ7mabqqGeCM/PI7X3IYegXzBPMT?=
 =?us-ascii?Q?b0uNZKXgTeXWE6fvqtsbz60h8Xtnfse+dEsxeGKRlLkNALxGMBjlInYeby16?=
 =?us-ascii?Q?/665YjWXyXNufCE9w4EvjNDbB3PuDCbtIwr9vJUk6lDwDr+Pf87KNleZ6YMJ?=
 =?us-ascii?Q?B8fDh4f3tEtaDyXY7/MhKmEdfnZXVbfOJL5T8sElt6ylUhBfceLoBVx7lb3k?=
 =?us-ascii?Q?iomIvOlrKLUr0UH6vzILPm+tlOjYyy+rj9WVq0JkuyjhY5aqT4H0uqRu5tEo?=
 =?us-ascii?Q?mupiigZCuZfXslkCb/4alZB3VPjA8I2RfHvB9POxyh8aXD3HVzgInzzxNWru?=
 =?us-ascii?Q?9FTzRxZN1TrTfsmxkCoFmfAX0VBTzxFGFUoVn10Ix7g3LIjRA42JnYTLFrMl?=
 =?us-ascii?Q?efUpBUkfCZhJwjfGae+jO5NKkRO77UUR3Xhbz5pV2HRCat0zOl4Bv/LIhI85?=
 =?us-ascii?Q?2cN+gJcshFA1DjqqD1g71y3HZwvYkb+mG3oGawr1lNEkVfBbR+P1Wk/lzgWJ?=
 =?us-ascii?Q?6kyZ3nPHaR8RAxx1SLKsSE2kOPHCp4a6tpbTPjIF/y38srY6yk+BtHaAcTZt?=
 =?us-ascii?Q?Q6WPksFEW6HXNI8IadL3suJEqasz6XBjmRc8HrX4KnNLYb47uKJMSecwOase?=
 =?us-ascii?Q?mMmuSb37/TpmY58SJTIv9G7NqzDQOZ+SUOatpQQC5XTD/qUtjklrj4kRagEV?=
 =?us-ascii?Q?47vY9NN2Lvi/OqUmhYFg50116/eIADJ0qJgTGN90Px4W9Xa5m1+3NpL0dykw?=
 =?us-ascii?Q?J2oJFYr0K1J3DT+DrPL6IHsDc/3NBgBb00uxtE8tUGJwJEKGNkhID/xSDFP9?=
 =?us-ascii?Q?uR+lU8nxs0ropFntZ+4iVJs06WmYXDz+/zocAR9kl2TiyNqiMyMmA3k6nxv2?=
 =?us-ascii?Q?jNGFM5Ma0BvpaYFeNyYSX4gJe1eT+54sx0rUYWJHPqQkSfFaLN8OxHuAB/iV?=
 =?us-ascii?Q?wBx6WrnOKg1qrBjwnAciDEiIbO5QxiGzyYgyGUtFXMpihj98E38CKfw9Gmg9?=
 =?us-ascii?Q?sfZPGZmSpJdNnbWrFQFAFd3RgiNovWwy0CcfuzF4oZ8J/dvonDjd0t5Jp69J?=
 =?us-ascii?Q?uJNgp18lmtnw+zXiIhggcdx8JE9qn4Di4hUvLIeiQcP5olmIgKlS87p4IX3A?=
 =?us-ascii?Q?3FLeRR32JgwY5OgeYR4R54bKyLNtAMpbSPs/nuM9+xVI6H9tHrAS9xfT9DFq?=
 =?us-ascii?Q?AA/wo1VgRIRgVMZyAzOoiMr92ZWnX+C3NT+55FLTsJuB8/+73RIoWDm540ju?=
 =?us-ascii?Q?whCoaZwYzswgQgIzr8EDeOhAdDvX4u9/xtn6SqBF9ye+knoimy6CLMgCulEJ?=
 =?us-ascii?Q?12fWEgOJ3gI9gPzGC9j0Zu015wCgTNTOxU7pZx4OggW9fmpt7BooJW5SnFMX?=
 =?us-ascii?Q?8n388goEc/hXxGys2TrU1FKUQ4svLaCKX86kIou7A+uKQEAe31pmdh+jhsJt?=
 =?us-ascii?Q?TT54M1MzePQk52yYEJdc7SWod+xVelnPSv9vxkj+/KYzFf5O2dxAHb6zyHiP?=
 =?us-ascii?Q?Si7Cq0F+xRzgghfPJvRChjLvcZvKLXS3FXMNEhSW/UcFBRxk1nX1fnbhyC/a?=
 =?us-ascii?Q?UFVv1BrkPnEmHF8cmZgDcMoXaEdplUieT7l+36sivT3Fl5EM+RTVf6z6avtO?=
 =?us-ascii?Q?Cs4Z0+dnP8iSu3LsUn88IOqYiIQhQl+ZzmZpKPuA1jD3kMFnisi4?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8B42C70AAEF6924598C346CC5C32ED0F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbb7de0-94ec-4dc9-62b0-08da443aa9b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 01:53:17.1709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i2Eau7qZNhsFzfZyq18mZHqIXB8x/MuXA+pmRwo6py1/SlFgc4RBU7l02Q6rjeniJpUq+mJCfRlCaf7XWN/TG8OL9w+ujFDRG9FhCwfn5oY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0339
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jun 01, 2022 / 20:32, Vincent Fu wrote:

[...]

> I ran
>=20
> t/zbd/run-tests-against-nullb
>=20
> and Test 1 ran for all sections. There were no test failures.
>=20
> I also created a zoned device with:
>=20
> modprobe scsi_debug zbc=3D2 zone_nr_conv=3D0
>=20
> and then ran:
>=20
> t/zbd/test-zbd-support -l /dev/sg2
>=20
> and all tests except Test 13 passed. The failure seems unrelated to this =
patch. The failure appears to be related to libzbc reporting max open zones=
 incorrectly.

I agree this test #13 failure has nothing to do with this change.

I was able to recreate the test #13 failure in my test system. As far as I =
see,
it is not related to libzbc, since it can be recreated with block device fi=
le
without libzbc I/O engine.

I found that the scsi_debug device created with the modprobe command above =
has
very small max_open_zones attribute value '1'. The test case requires
max_open_zones=3D4 or larger, then failed. By creating scsi_debug device wi=
th
larger device size and larger number of zones, I observed the device has la=
rger
max_open_zones and the test case passes.

Later on, I will post a patch to skip the test case for devices with
max_open_zones smaller than 4.

--=20
Shin'ichiro Kawasaki=
