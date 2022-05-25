Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5137FC433EF
	for <fio@archiver.kernel.org>; Wed, 25 May 2022 10:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiEYKIR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 25 May 2022 06:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242014AbiEYKIF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 May 2022 06:08:05 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DB9941BD
        for <fio@vger.kernel.org>; Wed, 25 May 2022 03:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653473279; x=1685009279;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MssIPafSXR/ekVG82ZSrn9Or4lHKoLwDa5SWoTVqiLo=;
  b=i4IG9XlCDVIpVby5jT0DwoeAeqTAKAQwiNP4zFLKnhOmESYooto2BvEG
   /FwKjpedW8Rnl6akufcog+njunRYUQTIu1gxSq0JygXO/SXRmkK9Z12Xj
   TIs1ZGFUy4ZTQx6VnZAcBeBfh87PFqqzXJ+QOliv73XhW+xGep8YWZ4Nz
   MANdNlIPFozizaUc/aWbjWc+df2V7oEDr6GCvL0cwSLxmAfcv4HJeGvQT
   1FBGb1HYNm92AqyN9VQyKjdXlRHmloD8Mqg68Wgl4vD6VOBH+LaLXhjK5
   k2YYiEzwQ5ZrwcmpxD+qZ9hWp3cB6yBqC5DdDjWkraapfSk0kB0j+uh5R
   w==;
X-IronPort-AV: E=Sophos;i="5.91,250,1647273600"; 
   d="scan'208";a="206255724"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2022 18:07:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPE4OPwkzbwqWUzZ5IlEx+gLNreDPhvigoNPiprikkrfGl/Iz0AGGLkFBGhuSNqHb6Qagbnf5KRFlm5S7a1gQj/sEGkyva0+IPtt2I1EJCfi0GlhgpAqmJVCilac0vE5ngB1BhWbvMLmjJp+yZkZgalYKF9diyrMvdb1JCG8Bo9V2CMH/Fp2ZVJcy9TtjEvEUyn5HN2nctCcT3ObA4YsvJuR9E7OwYKS4TQ8dOXiupiS1YY0yk6f0V217+4d5gfC21Mv3GpyQGuhomtdn3jJAu1MBnWq63MRudbUO/EDn282i8zMLneXAN+93mhrfuYW2jaLRE9/TLfxxjGCDZozhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MssIPafSXR/ekVG82ZSrn9Or4lHKoLwDa5SWoTVqiLo=;
 b=IuGNS39eXxpEQmNSF7w8/wGygWusaJ390Rh1w3jQHwsVn0+Sis6w+IdSyQ7byDALj2Ym4SY1PVrnp7qnPTaoRFk/OY22JNPAkVel8zT2gQvIy1UUzR6BACyQ8DFvA0hlFnAk5mKtVEIJHj5H+To51Z1hQCVHl/km/HN/13NEiyo1o4Ye5xXGtNKCbBqdBxudOhBBwnDM5WfXULq064S1cBouY/E/Av857IiFCowMVfAz67VB1pEwyCQAs5IygkbSOYYv/9Fe2FJcuUQ1KMjopDMCzgg/EbeQmywJx8EddfsrWHwY2UKFLNHBy7YksOgfhPBeJY+MrYfmf6yKhGoeuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MssIPafSXR/ekVG82ZSrn9Or4lHKoLwDa5SWoTVqiLo=;
 b=Wt+aiRs95IU0RKk7P2oyH/BYlFNKt8Gdf0r3HrGugmjCIDxyjlpESyZt8qSdUk1aLe3iMskBhosgW4KumVI6Hrl02NvTBgYAdzMiW/+3ukCW3PYBjcUypByy+MCiII/vA+7HkO/Xo2N6O+xR4aYckpiokdHb/5L45+BqclemI8o=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN8PR04MB5844.namprd04.prod.outlook.com (2603:10b6:408:a6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Wed, 25 May 2022 10:07:56 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 10:07:56 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: Re: [PATCH 5/7] zbd: Check for direct flag only if its block device
Thread-Topic: [PATCH 5/7] zbd: Check for direct flag only if its block device
Thread-Index: AQHYbsJHXGvrDfuVbkmIRwyoyyAIaK0vYRWA
Date:   Wed, 25 May 2022 10:07:56 +0000
Message-ID: <20220525100755.gmd5vcprrunsxf7g@shindev>
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
 <CGME20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527@epcas5p4.samsung.com>
 <20220523131039.17697-6-ankit.kumar@samsung.com>
In-Reply-To: <20220523131039.17697-6-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac07f923-c336-4d43-59ec-08da3e367068
x-ms-traffictypediagnostic: BN8PR04MB5844:EE_
x-microsoft-antispam-prvs: <BN8PR04MB5844C55DB0502AB7A9169955EDD69@BN8PR04MB5844.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 23JkgTCTBvic7Fg8acsEZB3HwYTM1kRVzAP8jzBr5k1kteqSIhIOvBP2Tvc4YhE/etLDsPzbCemgfCqz2G0xrM87a02d/tMFJecqsTuxyZyE1+ValOsmdtic+TdRAVq0uyCHCJK8foK0sGUSHE8ZdicBJFlbedDAITvkcWoMoPQYQ7qvX6znVhvTWixFW5fqeYfj+JkLyWQVYM9s+Hy3nuMute6Za7rfaTZv3JITdVHfXycWYO2vw6Fpk04dd/xz6tqC8VRgZm5nREDFY89NFSmrlJJ9qC/1XZTWjjWh0mP/Wp1Pg0+aArWP7Sqb+86huWFijDayBuSdTyu6BzZIZ7YpvgSwaY23s0ci2ItB1vjXJXR0QNb19yHbGGUDFxN695S5sEuj8PKHOoc/02p+A6oMUOkLOzNIfhfQiaxz4mLe831eFGujw05gGWdlI3Z7Ycfv8IR8dqePXCtDLvFww+uqQC9ETP6M2D96AJ8YSyCntGRt+drV2GyitU7s5aZ7xeB5+CFuHEZgrIa8LbVw3XG2xCm5CB9oV+BH7WK4L5NXcW5IZGZ8pRQMJV5bf/Boa/xPVFNVb0AYXaNPM7O3rR2Z9fHJuCSEcn+QOB9F/U1bwX1+r6aDChaqkRmMjX4sOMiaeztVa0RpMKimu0i46Is3cxE2DAOob0Hqhol7G9lHcksDRj0EB02wwePflqJdlsarUU5EXOP37OwCmfUNzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(186003)(83380400001)(82960400001)(33716001)(122000001)(38100700002)(1076003)(38070700005)(6506007)(6486002)(54906003)(64756008)(66476007)(2906002)(4326008)(66446008)(76116006)(66946007)(6916009)(8936002)(316002)(508600001)(91956017)(26005)(4744005)(8676002)(44832011)(5660300002)(66556008)(86362001)(6512007)(9686003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8E/qwRllgdlbTjhSxb1HCMQ/m2NReVfXg9WTg7Sq028PIP1o4Fa6sf12P5Pt?=
 =?us-ascii?Q?s8oVNPiqXX9P1fXbZLosuRCda7ZcCo49FxOHv8beSKvt04asfJkFP+pjdiF3?=
 =?us-ascii?Q?jYv+/JtTYbC1jdIPKEhFKhwngyZEcBjk8FMHLIkQH82pBvHGafUk4adhfvMZ?=
 =?us-ascii?Q?YTZh4QkYbtiyhJBIv6MlaRdGAFrfA8392kzlYkaUMCmxURxtkashEdgB8PUN?=
 =?us-ascii?Q?C5G/yN3w2l22Cu9mCqh2YUV2IYeH+PZGsLxl+MAZeAPEcrhzSITHruF/62hv?=
 =?us-ascii?Q?gYSCGjyXQRpak5OnfVbDKVlPVCCzRRAdSS2kleQ/4qnrD1k3QZPmkCj6siJj?=
 =?us-ascii?Q?BJLKqJZkc94XJ7pWoFK0g7SpKjJ4gQ49DCMwMoSb0ARzu54SnYWFxM+HWUTS?=
 =?us-ascii?Q?tnQmbwx3l6slCnO2TG/ioc2RiTDL58mWCUco/plWjcFCl5njNBQMNHfFt771?=
 =?us-ascii?Q?Jwh9nPJl8cPkwzyt0Qvzv3w/2qf5puTHDISxk15jYtY7lHr3XYNI+o3KYRcp?=
 =?us-ascii?Q?xK1FzbsiWQfwyjsWOEt+jOYFfDRlEPh0QgoSfd0cJzjZYOXQekwIsVHaFkpU?=
 =?us-ascii?Q?A89nNi2Ro651mjHHznDqlYF8J95k+0KZg9FUfwrI0XCTaEIMH/fpOOHu633g?=
 =?us-ascii?Q?Z6U/26AvjDkL6jvqPFt0IA2PagpT/ahM+mxz0rIuLvQt54GEpxF3ZKmcPJQi?=
 =?us-ascii?Q?ztIBKdyY94RuVvo/0Wlh6HTfduOAyd4Vfy0jxL2dsVjUBbJBz2j6NZVNhiuG?=
 =?us-ascii?Q?DnC6oWPRE5t9zhNpE66y2wyAc6V76K2iTAq3v8fO1KHdFmvBAnqO8dKMw4cq?=
 =?us-ascii?Q?dyhHcZCvzJbEXS1OGm6YJgY1GOUJ7n0jq2vnvZ3vg8LoYgTwG2MAA7cJtg45?=
 =?us-ascii?Q?2cziYhhASnhTPYjcwCeNW9JsTN+PJ5rZt0Ep0KKkJlvZKJXQCTHJa3hmDuzF?=
 =?us-ascii?Q?nt2m6wz+yXRm0jO6QlsxeZ2y0mf5Eler/kQh+0M51jurzeMA9D+eH9FFXG52?=
 =?us-ascii?Q?k/vN5LOE83vTPrs5lFpCqj/xvxodU0sqBlSZWzZ0jkggaWbtsaRcztosjTgl?=
 =?us-ascii?Q?uVOQKR2NsjbBc5puK0dVsfLGe5sVO6ytzu8kmG/DmwcDX6YLRfvfeo7MUsT0?=
 =?us-ascii?Q?Nzh20tucW8ldo6lbUZenHFaiVRkNF9iRFhMGqpKMQBV/2IdVulcLQ4aj6kiw?=
 =?us-ascii?Q?HiIwrUF8dy7dAlP2b8CpbBFHeahkQrCDXWu3MXFviqvCBs6kTHmrDjxjSdhN?=
 =?us-ascii?Q?7A51ON0D+W8s6lJRQAXOHilNefzgnjTOI6oQMM8esHMvUsGXg3O9ouyGMrYS?=
 =?us-ascii?Q?c1lhulcZOcjaW6Oou18tOrM0H3Uk/eDS9TPP+vcB0USCsYMTBSXtAZy+xTAm?=
 =?us-ascii?Q?SbnsOOHaiOraMAIjIWEAJFLKBiNcZQ23uAxWMcy9C8Czv/nseSK34MNwJ/Zr?=
 =?us-ascii?Q?xoQaoighiU+Ms1iweN0JSoyHRwjQwM1QIn+CxoBRiGD++aa5iFVdui/yyKbc?=
 =?us-ascii?Q?K5EqQj7xGVJVVExPNY4UmRP1u7cs7O7jA/ahdsbfE3oVmRu2G5vprBPKb2rF?=
 =?us-ascii?Q?C3CcfrcHLX2J6V14W5/+I5YzHsT9FL9wuoq4DVSmKCdCbX1lTcCDqxLNEytM?=
 =?us-ascii?Q?xuQN+SOQtyHxqTgLm92F1YP8NuCQOsZOQ7TxgMiYl6REvpdzLhBz4Ek7wUD5?=
 =?us-ascii?Q?NaMH3JfwBUJMywrSsCDGFGwJ+Epbgoks/lBn2J63pb5xSEghV2Ca4y9khcMf?=
 =?us-ascii?Q?gyoNvKvCzupGs7tpfx2kqx01fWuN1Z4xAPMHPN+NE9dvmctwV6HH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC3242D5110B9240B7EA3AB78621F0EE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac07f923-c336-4d43-59ec-08da3e367068
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 10:07:56.0920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R0kypbuEkTxWnMbNzQo8JDDw2fD3YirJYa0MQK2XBP7M5oLPGgcHU4QY7/Apn1yU1DngihPpZaRHUkz5gwRSqXJBeoCrXc+t+2o9dju9qxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5844
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On May 23, 2022 / 18:40, Ankit Kumar wrote:
> nvme-ns generic character devices currently do not support
> O_DIRECT flag. Check for fio option direct flag only if
> filetype is a block device.
>=20
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>

Hi Ankit,

This change skips the direct option check not only for the nvme-ns generic
character devices but also SCSI generic character devices. And it triggers
failure of the test case #1 in t/zbd/test-zbd-support script. The failure
happens when the script is run for a SCSI generic device with libzbc I/O en=
gine
(-l option). The test case confirms that direct=3D0 reports an error, but t=
est
test will not be required after applying this patch. Could you care to fix =
the
test case to skip for character devices?

--=20
Best Regards,
Shin'ichiro Kawasaki=
