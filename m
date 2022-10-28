Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CC8ECAAA1
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJ1LmK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiJ1LmI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:42:08 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB581C8136
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666957325; x=1698493325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rRPxWQrlmH9zEjudH+GAhHRWX8mS85GpMQunyXh1dbc=;
  b=YW04VzLZ/n0RHn9bPrnwCef4tHW2afJW1BKwGucwoZCxJc7znGFIp26E
   xkZaOc7FddA/67kBPBcYoloSPNHu40mZSrr0eBh2Ty/8MkUDauX6F6D+A
   SuFYLbzDhRb0PYRPxcFuoTCm+ux5nvHid1RTqFB0NHhzDB9i/6z7J5LrJ
   OuYkzZ74cm+4Z0P/z+XIq6ehmEdlXb9ZTOpn5BAW7fCcSx09WkwnK3aC7
   1Sfxg96Nz9C6NQxVbi8P4547uefvzAHOhep3wFiCwegZpJ23unGl6d3JR
   MYTJDyOx10WRsSK5ubRwP7sPQnDWbamT7VrCX8TjUGw/IyPYwOlQkzEDw
   w==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="214967847"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:42:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOwmQ/7UGW053iAqKfVZSZi13nwbz7l8tjvZ150t4gQtYl0NUtNjDB/Cc218F2rDEeoBUoEhXGx1MX7xQdoAp1fMwsS1iiFAqOZRQfpxnOEj+hYttuFnaSDo1RK268TmfpM2BdqnknpdOIny8ShS7A+YXE20FNcr6r3vE5s/xkB7ZP2afTJfNXKtm5eHBQismEK7xp7gqDTI0H8s4rcme8ieZF1uURijHh/wH0Mpt0gUZyklQxwmBwFZ+dd3ZJQd/YLMBKh1YsoV/s3lD5LE1UPV533rbppKLa1h7n4Od53djhSHE0okcVwCcKyPOu6QK8cjxxxRM2iAJXE0sTjAyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIQfDUXQgqEciEQd1DPWUytaIyPvUyL0e4BuwjTDU/0=;
 b=nTOoZeyFkgazo7d18qCZOQlPmlu7OmT7qgR6Wh8QBQlsNOuFcg4zi1mMxIZ3QjIGkhitga7DNChkHbS6ADp26JP0+TBknjqZx0VwrH8kmFHZG8mwYichti1+bA91G7ReG0yzy1BSscJb5+RhNhd7PQj59Qmg/ofWX5qmfoVRr/3EY5DmX3YgKnFb/S/kj1uA4LTqePWfYNRhwwPfkoR9/qgqFgN64QCQeHyq6Bf3RsIUlaXHU9KC5zulS4Syy/YMFiofXPtdpsmCkZNZ2cbn5svrBtebjn7of/AgvZwgNmuo4Lg+edaG9Hzab7DUixdRArJ+PKkJUq1OsX0klehO7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIQfDUXQgqEciEQd1DPWUytaIyPvUyL0e4BuwjTDU/0=;
 b=i44IEtB6FQrkofjFWLTeeHwxGS3HkHBM6mmshHG4eTRk61djbCfXGATEUIf0GFQYcWXnSGS7zCCll2V/0suMJOzG4WrkLjNhpe9Zt6zcqV5sID9pwHCZRS8tYU0VvLUB+QZAz8DhkRfQKumgrST5F4fYbHpAMoS4oTEumCQS2/s=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SN6PR04MB5055.namprd04.prod.outlook.com (2603:10b6:805:a0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Fri, 28 Oct 2022 11:42:01 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 11:42:01 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 13/13] t/zbd: add test case to check
 experimental_verify option
Thread-Topic: [PATCH v2 13/13] t/zbd: add test case to check
 experimental_verify option
Thread-Index: AQHY6cmkaqzKHN2Nz0idlKzEVzmRTq4jsQEA
Date:   Fri, 28 Oct 2022 11:42:00 +0000
Message-ID: <20221028114200.24qdudnqm42jkmzd@shindev>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
 <20221027060139.952508-14-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221027060139.952508-14-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SN6PR04MB5055:EE_
x-ms-office365-filtering-correlation-id: a21f0ef3-a75e-4ea6-3d3a-08dab8d96d83
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6uUcku4LWcDcDcnYX4/s8qKkqdT+qTiTiiF70eG+sv0v5WyE3pWwPtWtkY6PrjQqJqTz7mRjVhG1UP2W/rielHwjmnW4wwii+a2dhoP+pMCI4X1QmNPlH5Xz/c6PYyrfrkd4aDYofZ68Qv3n0k3LLBRfq6kCX5flLY079zdDK8LhcZDP9jRvQN7D6Rh8weWRHsYrxjKqwX79hIxUAlUM6OcfYmOvEE0dRgyGJYCnH7fdzZJ3r+83hBv716Nf9uDjgc3Nttw146EL71QDXy00iy40IA5nYY0yY7DEzvodVs69dh2mnElSp9tO1d+bOurIZoUZQSUwNW5TuT5HIAZndp2Av63kgj05KUlPcy4vIBms6AgOfpglzNh8Tco9T6+/k/O2WHS4xqQ9X4j5ZxSr6mbWntC3At5nkoAnGzev2RmfqM2jEORyHvrtRwdE1fO+kp26/XXZYocc7kd2iH84KBV7IYf3nAWjee1PfnrUsWxS4vBZT9p7LdRyBD3OY/kMbYMf+irLuYryPbWmWSbUkVixGi7hNgQRUGKiXjUhaplV+1Avb7/Phd6gSsLACv52jmXuxblLL6+B/s33Gx4/QBojys+neZYBdgTUxOr0WUinugob5r4anMViVhUXRn1R8Vx3L4ZCGbOPDNDNrjQtbmiT+4iB3p4w/pKPC+liTYMK5Pv0WN8btkzId8kY9YsEsvMgYZxf4fBTqlvMUD0OCwn8di9C1WAT3Pz7yjIcViSPZ2EVOlncdEkS5QySywXLoilK/WL6OcWg5n+wc75b4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199015)(71200400001)(478600001)(6486002)(66556008)(91956017)(66946007)(76116006)(110136005)(54906003)(86362001)(316002)(33716001)(6506007)(41300700001)(4326008)(64756008)(26005)(66446008)(8676002)(38070700005)(8936002)(44832011)(5660300002)(9686003)(122000001)(38100700002)(186003)(82960400001)(1076003)(2906002)(6512007)(83380400001)(66476007)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?51asbaJ5V21S687Nfb+Mh40tho8h5nHkuu5m326Bg63s6curvrefSbYv08xS?=
 =?us-ascii?Q?FCzQ0NbVmfnO6L+eh8dfPCVLYShE43EQ7ONuVGf0mxFaPh2ZOVlap+FjanC9?=
 =?us-ascii?Q?USejyA6BmnUH2NvYvAHVuOG7add4rEX+IS8FhXfrpFYVVK1KgD06uWvr5ccn?=
 =?us-ascii?Q?Xn4GYnd/zsTvd8sNHXx1XBY+ELpet12CMPvM5CbuRWxzb+CLLWWqATlieY0u?=
 =?us-ascii?Q?4FmVG+FbFJ75Jg9T9PKHTb9DxPlZ5+6aC6W8x/iSoMT8j8yWX/hABmxSzQ6G?=
 =?us-ascii?Q?OeyqoY+neZPuqCu45GPHrgnNqlDUkKRflRLiFthkFF0k6xffozUK83ogzWX3?=
 =?us-ascii?Q?BIdiMaEijMGJLIJK1Kp3kwjugHPRjn/R2mU/vT7dkVyJ2kI2DVI1uTXOwq1S?=
 =?us-ascii?Q?tpxSXwx00BYimI9aSubR1zSLT0BeIu2yLJFJRpS5TnP+78B7rBbK9o7nF1mi?=
 =?us-ascii?Q?+rx/m2C2vwCQJv94DFFP7HeARMhRRDAunhVs3g0cuyxpWM+oqQrY5rG2rlKY?=
 =?us-ascii?Q?NsEMjd/J6aq6oUpeMN/ocFdD9LphOYxDW9U3k2VAcwrtu6Gc2dFBNTaG4q1s?=
 =?us-ascii?Q?mH24yJL6J6WUtY7PtwghCot36josNZLnRposb0KYKGfxfQBRj8ikPRivUaQH?=
 =?us-ascii?Q?ZpISTBY47d8SOvjjTTllay8j5A2BvToeXquJkTKMMJQZoHJJLbRYvX7Ykdxd?=
 =?us-ascii?Q?qSIFAPLhVeHVb64NZnWq9Z/ryyfE6e3o18hDExsSxSN41SDQIyiwuHyQEJNx?=
 =?us-ascii?Q?Fmr+OjLdw4U4Z6BFksrJ0x/Yxyq9uorkP0LIIBrLCbXSD+5JhaM6V8I0tuWd?=
 =?us-ascii?Q?RNb3v/Q74qTaPvj8KXJ4p0WHqRYeqw0pajF6e27JHtql5Tn+4REcgvEQF/z8?=
 =?us-ascii?Q?qpaCdiZcXQwKhVIKNeRVPlrZGQS45k5/1Zf0pyeu8X5ai/DorhBQeGYkr7Rp?=
 =?us-ascii?Q?zrFzAsM7K3dmAycLWue7dI7BjM0J3njDZk+KeKBmoB3YCdbccc3EtFXqqYK8?=
 =?us-ascii?Q?gfzWS3fJdMsRViT3HVj4keXcFmogN59NZzxWinYfYYT9Fty5dDWFAZ0Q1om9?=
 =?us-ascii?Q?3kkL8RNSrz3kuS/CjtA7MbcKb6FTO3utQ1WnEBJA3cAqKKXG95XVqYEkpQWS?=
 =?us-ascii?Q?7CjuusBHhE6UlgnTW04b/oqWFBPAFhQQ/5ENvOyJrUlW8i9NZYpNsF6Q7oI3?=
 =?us-ascii?Q?eUw9R2eyE9vQctyBXA2uDXk2SQhR5D8GtO7MLEzuLWid7vRP52B0XfEmnR7n?=
 =?us-ascii?Q?7tfVvwimU7Rkwa1YJGGKGMKOOmxDi10/kTSSKXlng55RnaRd7Z4yFYb2NS+0?=
 =?us-ascii?Q?wezL3OaefhVXk0TeLeHK2wAASspUj8gOomjg6Aa9JgL7zgNWJCCdGeorr5+b?=
 =?us-ascii?Q?ptOAU5QTX2U73uu6ENLxdrNecKbrF4ae5w1JGQq+vhKjD0Xolq9Rhy8OhX36?=
 =?us-ascii?Q?S2kG2O33CixsS3EeiHuEuG7nPSVKLDs6Uy2/PmXGofUC16mJCK9ya1UG0sol?=
 =?us-ascii?Q?ZC5Z6TIrUFoDmCdtBBmUluJG85aJ8RpHBMgv8EcGhUpeRjLWK+kYZJ0Ttlo/?=
 =?us-ascii?Q?sBRnON+39d481tg3qEo7ahscGlYy96hPXmOxgEzquNvZgaIs8iJoNd738BRd?=
 =?us-ascii?Q?EpnSTIMcHZ2lG0WoqvIj1C0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87C1F978679B0D4790EE2C2C56FC9F59@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a21f0ef3-a75e-4ea6-3d3a-08dab8d96d83
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 11:42:01.0452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n5DycQo2EJVRRFqQX2yoREzPusNhpHuF4QsDIHNx6r1z3C6+Dlk8D7KNdf+1IFgYWyQnc8n1JAq661amFj45ofSUwWirdIsIUvCipH9e6lY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5055
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Oct 27, 2022 / 15:01, Shin'ichiro Kawasaki wrote:
> The option experimental_verify does not work with zonemode=3Dzbd. Add a
> test case to check that fio errors out when the both options are
> specified.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  t/zbd/test-zbd-support | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index ce4a5916..7f5e9b1f 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1289,6 +1289,14 @@ test59() {
>  		       >> "${logfile}.${test_number}" 2>&1 || return $?
>  }
> =20
> +# Test fio erros out experimental_verify option with zonemode=3Dzbd.

I found the word "erros" is typo of "errors". Will fix it in v3.

--=20
Shin'ichiro Kawasaki=
