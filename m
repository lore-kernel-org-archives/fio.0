Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330DBC433F5
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F4661077
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhJMIaP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:30:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50692 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbhJMIaO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 04:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634113691; x=1665649691;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1C9veBe+MXPvTGEjljIEl+XVVyFCONWI09YCT9IMfiI=;
  b=oNFTCJzCzb7uJqp3007/cdMcvf4g0Bwz+ee7yJzHTkRoF1EjtMSVQSoR
   gBkaWi8QNwzHqiaSfV8gqhdUiImYjo0iAx74sSK8ij8ubD6mFC/L6RmfA
   kiiJAmgiRFGIX1K02cvwhnAPD2umWaRwMYwXJ6ce42xD/Vsx8AMQHlmPI
   qwAXcQKyxSUxAEXwZ4bz5OycTff95CpwOHvBr2oXmUJNr4siXunEb2WyT
   o1Vsg7jblF8nfU8vPYGumIEnOUCQZYb9iJ1ANX2y0L37lZGkCJjkqEXjp
   QNMBgoJMHdcKc0iFZF3zZxqglD3a2NiDeNbAkmkc+dC/rNgbBl08P6C9O
   w==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="182712610"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 16:28:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFZOvrpUKGXsbPUpTcRIPx5AAvyxzdKNKtQRtNFMxHhqjlOoVaQAVmrk15Rtd/C7SkIz3+6GUTMkpe3VWmPCxo5eGiriiZiH9/RFHK1jnPO6ni36KiOwauKHtOZQj1Zxa9Anm1E/0qRS7S39nLpCBsbTwoEYvE2Kn32fW7wnDzhPiVKPtQCmJDJKdyYx6EfNuQ5UHyfyiORJZsZSHaS12vk8bZHNypxOsisqGUAO+6/eMlBK89jA24D9mLH/8KJKKhDtcXsrXBRFIXHfPx67rrgEXSYk6Kqs3Q2p8uOmLmq3bdoXHXZcx7GElIIYVMp2FRS7elW8SERRbuQiFkaqCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1C9veBe+MXPvTGEjljIEl+XVVyFCONWI09YCT9IMfiI=;
 b=i2fgB+ZU6mVr8eJh9Hb8YcM3vLFNteMbCKEPOsRu1A/BLKA4Q1VsKSWVQxADh/k3OwNkybLG6HMFwWYxupF44q4JEaJCpyhgRZe/4DJm6mK752mAacb1Z3NOiQE+Xbrn5/YauX1i7W7e0oiQM5DbMZIS2ywQeGC8eVrv8oLZSuLXhPPvOecs+mpqPaekH0+gkZsdkaglFi58u2FddTh7BnHnBKIKzGF7CGytmUBkO5N+IpushJf0dBzzeLyNTKMsKOtdWnJhY89j1DJZrr3BGtKzUc1ABaMByXqQKLbMZp2zKACQRTeoo+8+T0G1w5FLVtUo7hRXEjdvzS+G6H6JAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1C9veBe+MXPvTGEjljIEl+XVVyFCONWI09YCT9IMfiI=;
 b=eJwqfZhZYvb9SSON/0YXLPbHEpOUW0DtgfDbelFc8+r7mnaHuDpeDtaLnFIltfyo5vAKUCkrUDpAXQs8YbbhQYkU4+qEOb2Il6FnDOGbljuwX9lVjfwXd1cxrZwBQGk6BpCOKGbSg3VnMod+WmoO9ltXFJi2kayKIRtGF+XDsz4=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7735.namprd04.prod.outlook.com (2603:10b6:510:4c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 08:28:08 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:28:08 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 5/5] t/zbd: Add -w option to ensure no open zone before
 write tests
Thread-Topic: [PATCH 5/5] t/zbd: Add -w option to ensure no open zone before
 write tests
Thread-Index: AQHXv/jaO7XNQejT4k2+d9OS2/pQ7qvQmIcA
Date:   Wed, 13 Oct 2021 08:28:07 +0000
Message-ID: <YWaYkieIOBhRQqub@x1-carbon>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
 <20211013060903.166543-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20211013060903.166543-6-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb587f8e-3440-4005-b231-08d98e2362c8
x-ms-traffictypediagnostic: PH0PR04MB7735:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7735B7A3D8124FF7793F4876F2B79@PH0PR04MB7735.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PNMBvG8wryVXCr0jbUdBEOOGVEIOM09+XoObe38+JiGFxT0sQZr/jHEQHWYv5kutcdLRZEVWei5oBHbJxxHpukXpRs/tNVw++i7uU+MGjuPT/RQjcBRpHaYLVeoSfg1z9OR3ay+VngwQjc7o41fylkAx3oE6vsRX7FJVbEWBExB/mJslBi5nMJHDR3EPHgLrBfVd0WhRQnHyEfaHTNmfJt9W0wVranh9u1BhxueW+r7MCVwWlu4DTpphM+w8+Paoy04KE5a+q9p9T+snFZ6sFEZ+oDETge9RURETdRU80jseJQ1HFH5oYr0DqB6IEfTBIuc/TWnAEYkaTIVf6iQwBI9Eb6uDPYyMmG8RjTqoL4mRf72nyCkHxAiUbgW4YyJEPurUgHOgVJoCSB7fUVnQFzKIZDkTTWGEDYAvQpBeQzvIsRvulDNki20AYkWj+Gw6N7Udc7HPJ/W6bjU6J0DVXZe+dCn6wNtUQj6xYzeZFP2PkwaavPrIL5O7yZgdQManyJsT8nsLsQ7kfqiqIrcMVxyKzVjs5C/owrHHyLpQbMiBbY1yfePMBFXMo5UqGCA1R+6PgJXko5ciZ7JQSnnnF6su33UcR+qqiQMYn1DcGWQafAlHJDK9Wxs3/ndmn4glIJrX1X/VK/55PgYUZkaTppVQRxaOV9c89dn4ZbpzmAh1lGQADBtTWU8JySbS623JPXlqPtunNwBcN3w3ujSGPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(5660300002)(8936002)(186003)(8676002)(9686003)(6512007)(83380400001)(6506007)(71200400001)(508600001)(6862004)(38070700005)(6636002)(86362001)(4326008)(38100700002)(66446008)(64756008)(91956017)(66476007)(54906003)(2906002)(66556008)(122000001)(76116006)(66946007)(316002)(6486002)(33716001)(82960400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1Yt1CLVNL4hfVRnrikzrgFSoq5K5oYIFdH+i8LfPbYWUiiOUKau06OKuwEpV?=
 =?us-ascii?Q?Bjh2FC7lvcTgBUAYEATjHVGM45/gq718TQ6QXHYxVrir4Ux6+T+i54OI2SOU?=
 =?us-ascii?Q?DImfMFmh9Z56vhQd9VqbscNvIHDPkDgETrKJoHsmPsBiEJs7ox/XGSMifIZ/?=
 =?us-ascii?Q?AU0WDMhCvH+eR+6kdIAtzZNz+EOonmx2YxqmfzWqKNlTnYvXXleyiuhX8HDa?=
 =?us-ascii?Q?ciFCJHnJYRZRSEfVpWLX3/aT8mh7+LJm5BNafxpFm0f1ItcylbWhpwxRYN+/?=
 =?us-ascii?Q?QeJ/MahV+rWsjYSVeWbbE3xehyaELvwCBPNp21R23Dmv24t0N+j1S46RhbZb?=
 =?us-ascii?Q?uWKiRg3SuNryUaUKGoyYUTCn9Ai6sXO5/C5vzV1zZ5YT77T1KMz/3SEKQQzu?=
 =?us-ascii?Q?jnVDxn9+fnf4r5j5o5r+WhfHwBuPb6LfTLehkNzrWmz4S77nZ4FEbuCQh2l8?=
 =?us-ascii?Q?p6KDO/yiKiD7kXskOrjPo1vPXS9R80dP6DsXFIzfftQXAXiL3+aOMPoYERju?=
 =?us-ascii?Q?pW21VAf8cVWgSXoN+2LHBbDYtxt/6Dh1qoT4hOMPH4J/erQTsDBvGpRCmI3u?=
 =?us-ascii?Q?cVer0IcvE1GD+NYs81u0i7GnriRCdS7Le4WGlBAiRPwd1wtWvaaNCXaEfcPY?=
 =?us-ascii?Q?CsGMqtokkD0L8aOxzdjBgiHenTHnsjdPfYD3VDvTwfWgSL62aZ6KxQok7px9?=
 =?us-ascii?Q?6/KUfsE+YfFhyCxD6gVKR7cw6/5LZDlSYJ2a3Shz0/qdcQxgAv+jM5Vfh0TQ?=
 =?us-ascii?Q?K8AbyoBmgwvL7wTIqLd4bovxMnuZw0PVVuG77ZzRKpzDl++lqFgibA0AYTUR?=
 =?us-ascii?Q?Z9l6j7Yu0j5yZKjC3OWwjrxbYPfwDGW9uANk6nVjtuBhoiWJ0IoWoFdtsRik?=
 =?us-ascii?Q?pODckv6pzlTOXq7cDKV9vJH9Ru0YgJIpFCg3tF5qzrB1ZOGo2lVPzsmUGgqm?=
 =?us-ascii?Q?j+uRiRxa4BqeLuf+up/94J7Fgj2X26reREfSFo39Mx8wK0t+BtaWj8yYzIwk?=
 =?us-ascii?Q?/nZoBvsQbSKt2XPPrX41UBd2Dl+VDsk0+n1Clj+2SPWqC0fymbH7ee6+l84n?=
 =?us-ascii?Q?YYCkf2kp7j5uHOnFx1kjDNIUyR3PAVne7CaaCMnQSYEGb2X0KFt/OPPE6rzr?=
 =?us-ascii?Q?/Cb2MfoL8j/t7uh7nsH6jFRrJYb+0j86A9/qTxWvL+nV8gp8i2qO7xF5raOp?=
 =?us-ascii?Q?MC6WXzTRMUa8LMmD/FrHcqGAh9HSk5ZgOftUBN4ohi8GfYbTiZdkt7DkWBul?=
 =?us-ascii?Q?wssbEkvc4Zsu7OQnceOOJlIdx6fgrA7h+7xh5/3ZphFLoZjd4KNo4oR3tU0x?=
 =?us-ascii?Q?WN3AaLeN33j4uioXSW6F3nYQmB3wOzsQ5KDS7Wyc4A4cQA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8BE859B7CB09CE49B5738BEE8A8A147D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb587f8e-3440-4005-b231-08d98e2362c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:28:07.5971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eQrj0kMyOs3GD7N5IEahrIXyAVxjzAmkoA2EwQyIYqUXBf348Kc0reokbWGbcn/nj9hDt3Oe0XEZ1hMACWnitA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7735
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Oct 13, 2021 at 03:09:03PM +0900, Shin'ichiro Kawasaki wrote:
> The commit b34eb155e4a6 ("t/zbd: Reset all zones before test when max
> open zones is specified") introduced -o max_open_zones option to the
> script t/zbd/test-zbd-support. It passes max_open_zones value to fio and
> resets all zones of the test target device before each test case run
> with write operation. This zone reset by the script ensures that no zone
> out of the IO range is in open status and the write operation do not
> exceed the max_open_zones limit.
>=20
> On the other hand, since commit d2f442bc0bd5 ("ioengines: add
> get_max_open_zones zoned block device operation"), fio automatically
> fetches the max_open_zones value. So it is no longer required to pass
> the max_open_zones value from the script to fio. To simplify the script
> usage, introduce -w option which does not require max_open_zones value.
> This option just resets zones before test cases with write operation.
>=20
> Of note is that fio itself resets the zones exceeding max_open_zones
> limit since the commit 954217b90191 ("zbd: Initialize open zones list
> referring zone status at fio start"), but it just resets zones within
> the fio IO range. Still zone reset by the test script is required for
> zones out of IO range. Zone reset out of IO range by fio is not
> implemented since it may cause unexpected data erasure.
>=20
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
