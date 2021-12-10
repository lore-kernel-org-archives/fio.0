Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7701C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbhLJMIl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:08:41 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48884 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbhLJMIl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137906; x=1670673906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9qpC7SqP8+uPaU6McAz+GGEGm2/IJxcivFkDWNqCwQc=;
  b=qDxNElM1KuULvzsn4Ahf1K/79JJLAjrVCmX25bBWeJaFeondXC69poAQ
   X6fS7QBs4JzfhJ+x7iSry5pJQhV9t93sAewo7O0mvh0252oBExt4IHknX
   fyVA0BRQd5rosLU58s3Zm1yS58tInmpTQ1ilJ3a4evDOr2tcK8JbhTe3D
   vhHiZVcZPcqYdBM+qQ5nkjZIPZTRDKnYE62vin2xDm3HM1cVdiY8LYfLi
   joW+XDPpxv0LM2ZAfUpP8v5dehQxJYicJ0sWrVFiSoJj3dndb7e6ZW85+
   4R5AL8970aPCNMY38qlmD8fZy6T1fgwgY4ULRii0vDeQgDO7ixqUDI5T/
   w==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="299780989"
Received: from mail-sn1anam02lp2042.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.42])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:05:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvo60C101Z/QkEdM/h0SwwL8wgyO95MIo/OvH7K6+nvCf+UVDQJzb5gcUFDrz0X0OzNyd9NVB/0SJC9beEpTkcqDy8yOZtUVrKZXBMgo2L1+pVRRSXDSjxFOUKSNP/ZqVLo5dF4222cRkyJd4941TXX4TdrTpddvZPGsTtkpl4GpFCbDHv+KyyWBWMdg4N3BuJgUrccpERVk0oiwqFvBRQ0UvHZsq9s6gTLO0QdVCoXYrODJafU380Afs4E4+St/aybzIQHmcokLHGqq82YsgZZrWQXByIfzFj+HE6rJxJM4oXjrb8x34OCrW5B3pg46xT9D5ZWAfWaYH0GQ3NfeHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qpC7SqP8+uPaU6McAz+GGEGm2/IJxcivFkDWNqCwQc=;
 b=ltzU4WO4ZqVATVXpAX2FTUGvFWBkKu+AYwB97t+wnyhxoTH2PndYZK+ij/xIRBTQX46giXfGYs21CtvlrpeLTdTZBjIYRGZuh+gt07p2RJ696y5PDna6EV1v2mS015WixGF1HrlOuUW0VLBgRNT898bMYQO1sw1D4dlv6xAl1ICIOeY92DsPq//EecjokilJ/jg5Cpw96qXJkiXlMdh9Na4qFRypF1xgS2N8wLZ1s8gnAEZ5Jg1NxC17XPptvtdHm3oiSkxJle8Wlc3hq3FUJ2mRynFXcIUmas+cxMRxqOlCsEzWNxpaFyqQEv12RygR3YRt5r8q0xUjPecUbQ06aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qpC7SqP8+uPaU6McAz+GGEGm2/IJxcivFkDWNqCwQc=;
 b=SLsbi+118aTrr3Ct5JwkgvCXITNFep/Efw5RMy3MlEDTq+1FaVaqKdf97d2codLxwn0G4cjWWz79tPXleH1iG7c5voIy1tmFoG7IJkSkcvuGC4ApHan9d/ptEzpF3iQjKokOFpc+jNI3YrJw71qcLFkRIwLrdj/TrV8oNkdsZ9s=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 12:05:05 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:05:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/11] zbd: remove is_zone_open() helper
Thread-Topic: [PATCH 04/11] zbd: remove is_zone_open() helper
Thread-Index: AQHX7WwBtQLHEv+Tt06KN5rX2BstN6wroXwA
Date:   Fri, 10 Dec 2021 12:05:05 +0000
Message-ID: <YbNCcIznyw/x2qCJ@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-5-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-5-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99c6b634-f5e3-4944-394b-08d9bbd54d89
x-ms-traffictypediagnostic: PH0PR04MB7622:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7622ECFFB0DE583C965D6A36F2719@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ylgqvQugBtDUFgl/kKbD4xtM2uNOBpBY3sYl41RPYy53ppnRucqvD5CkaCXPW57vjByecWZkH550ZSF58FVg/A7aOnvdOtmFYAFwdCbaDNF0x5WUKhsm4xIjDG0d9etYhFks+9aFwk3dVd8XnZ0sEnJc8apyxsnPDQOtzpgTELa63sz0eD9tb4eHggFE5zlSFg+4K7KlKtU+rhtmFBtlmjf/1mRC8oQS5NZrkWZr6AAo5ZD8qEEHLP6fwx4f7EXE/G2NusbvgoKINS+wgEzCNFFFBhDG1/kxcVKm26GKrd8wPBCSDx5ntQIMtTaBbaBADYz+tKeamy+iPfhxdjQ31zpwMM/TyqZJvZZJ9zV7666IO17nVHr2AgwHSPordvMJaDmwg6EPLTR83oqQ66x618HKonhm9gfelJJtcoors//mRBrP3bo7WZR482EozXtg1VzlNMfejbx6jL/+I5xtiLcRge489yR1xL15E5RxtQ7Ftoxi3L2RafSPuGOBIkQUO/1EHEVvlhic8RQFrzjLM7xaACWWzDM5L6ry5fNfrFphwnyEbDLZaDKkMcE6jKVRQxktREc+kznwNcufm7i4vlKS6ySbCa6FiyW70zmBefW6oa4MK3vzpa+bcD1z01XdzqwfjDd+QUyLWTWv/GyTesWcRZw2cXilwy+OQs744ju7v+Cjrl474Q/9rXJMOXIY1zuap4ZWatVGu+GKkw8Akg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(186003)(6862004)(38100700002)(4326008)(38070700005)(122000001)(76116006)(71200400001)(66446008)(82960400001)(86362001)(9686003)(6486002)(8936002)(508600001)(66476007)(8676002)(4744005)(6506007)(33716001)(2906002)(66946007)(66556008)(316002)(5660300002)(6512007)(64756008)(91956017)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8YezUq0559jFnu7p35Kv1lX3OMdDLys+jf1zvWedcbXcLNhEaG7y1Nx5YNxT?=
 =?us-ascii?Q?aZ+PlfJ2a3BcZ+DcwiyF0t0G+Bgp+AESXAw6QcR8Im6DcRjhgsnqUB7W3yCj?=
 =?us-ascii?Q?PDbQg5WAhTuk2h7WoAuJ3bvumXRb1D+WnhkjSL14KscRtpIpGw3n6+/m0IPU?=
 =?us-ascii?Q?ZB8PYcZOfKfcjKpqSY4PYEm5tGE17RLXX5Dapo1wCrFGzuprsBea/8lwRLCT?=
 =?us-ascii?Q?sJmi2aglH+vrldBBmHoJaU9z648+2Yg4pY8sQFTbeXdZVrJRgAuOGz9KzVjO?=
 =?us-ascii?Q?aPa5sQRckIQ+/tw2CVkSNrvTzr/65k6xcQ5eEZ19+XSKZ4YkBzt6PETFKK8Y?=
 =?us-ascii?Q?wbWbNW74372JALTWTFvbYjDY4zK9rXHC3L4zVBkAjBfC2Fu7nkvw4W2Uz9GT?=
 =?us-ascii?Q?B5K+APC0a+gYZ8mRWS/SY+0dIe2BbWCHR4kE/2SFl3q8b4gK7vw4keL5A8MU?=
 =?us-ascii?Q?ltRGNVFWd6sTWv52ZkJ60Oldo1lWVHWyMWezhtu3VL/oONV671wIBV1yUCdy?=
 =?us-ascii?Q?HbSscqxq7kEIy0QtM9IKCHMkZVk3JdlEDCEXHJiyZIHZayKCU5LGemokee+W?=
 =?us-ascii?Q?nvC4NNR+3tZPZSPXU8eB6xkxhaLp0mF1J73+ru7f8/xPQQYWQfCsVek1Wf+6?=
 =?us-ascii?Q?ZNk2TLkV6STZeCPM6r+qGLvcyEPHKgnH7zEKCSGfeIjdd8cFDmVKI9kbPrak?=
 =?us-ascii?Q?F30gfzT7LpVUbkgoPBpezPn3Uc0/X1/r9q15wlgJnmkMZ+rSzhZKVGWr+BeK?=
 =?us-ascii?Q?GlAQKNqB4QAXQZrat4siyCYDBlfsZBA8pgTDfAzElVj69Wqdx9308yMVJ36w?=
 =?us-ascii?Q?eJrXhS6OvSxudW0gygApXkx51Irr35OXbBxUbAXXi+a7sTqgpwFMW3dei0UZ?=
 =?us-ascii?Q?IhVyD1DUDtKUrs/r7HU896tFf0E1yXfhlvLMUPqYb06OUz2ij0nZcm9010HH?=
 =?us-ascii?Q?iTdtVR4HM3/mRo1K8ThryFkY8ZiM7rCuD3dNucGN7pBlrCWTxI5GHVXvHc0w?=
 =?us-ascii?Q?i/FLMNlQ7iRPFK6C8Wg83YBNJAg/g/WkrWHSJVEGxHlyFR9MFcOsWwPO3stC?=
 =?us-ascii?Q?HKlmzVVm5B84JB9S/rLQLFLtNtwdF0kKEV/asTxF/z0wz3snKX/q/3LZmN8g?=
 =?us-ascii?Q?HXVInoahQfyLwxy0SBKi2w488sP4sq1UxX5qc57Krkhxk5SszWEtmnP43iuk?=
 =?us-ascii?Q?h/oXS00TfV3pEpKR1hKBTZykzw5SVh9tXJGEvLrFwrGenAel+pEYe91iZd5B?=
 =?us-ascii?Q?fX34gyxw4jdZ8qBxCZwR8RKQe2NK15zwm14dItaXZOiFgTjCgXzgErE/fsCb?=
 =?us-ascii?Q?X9U8vytNUZRFED5btn91pL/HH2LoVWoRUERX9Pn2nFpLNcUnyBPwI+ayi9Tt?=
 =?us-ascii?Q?IldUaPthhHs6N+LwpjnSJe4H5flnX1Kh+zG8/JASfGvGKV8hdeTFHHTuIm1U?=
 =?us-ascii?Q?17OWgDa2HIcGlHn4xJd4mQcO7SJS3kskyZbEyhCLAX0C4yNoieFV+lD8mkQK?=
 =?us-ascii?Q?IZl0oxqO9zLzs4gVXBMBHx/UHujsgfR4cHua6gOe4BqdCl4ITeIPR4kqduwe?=
 =?us-ascii?Q?qiLiJh8181AkKi5DSf/O+SVk0BSe/Lm+0fdb9yKaNJUlLPLoJOohhRqzHNm6?=
 =?us-ascii?Q?fFDMip1I05M5K4JCekUQfSE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8147AC6A0BE7F24E9C9259A7E8A7F911@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c6b634-f5e3-4944-394b-08d9bbd54d89
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:05:05.1678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v6TytxOuOtjnF/+mKz7WvuZdAdf9T/aKRzihlKKm2IjMXttwzcvL5Dfe/Zn7TW/mSfg9SSVMfsM24kAlbGYUaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:34AM +0900, Damien Le Moal wrote:
> The helper function is_zone_open() is useless as a each zone has an open
> flag indicating if it is part of the array of open zones. Remove this
> function code and use the zone open flag in zbd_open_zone().
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
