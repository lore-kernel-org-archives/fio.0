Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B76C38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJ1LtM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJ1LtK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:49:10 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1149F1D2B70
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666957747; x=1698493747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cZTJvhUR79lyLm3waC7rNS7ZWG2lahnHtxNiBU+fQ8c=;
  b=TR+LQRr3NCtkJBMHSYkrfCBDZY76qO+n+CtuaqLsj+bEGF1KfW71N2gS
   SGixmTWSniAonYWNjCCHqtsN/V7RSNg6GpQskwF/Z8OdeJJhlv1I46Vyv
   X4pZTaZd8aVFl7y7raPCeSrwS8UuVuvfAEwTaHutEMB3cOJrhLYndgsMK
   MCDIzoEy4IQHpejopus5as6kwTtOTISpJenD/gCwvtips6MhoFMfwYTlb
   xxwYQeGpf8HUWdvu9kxJI2mjrv/2B1bceQOcrYPOnKT3aDISNz4QAASDr
   G8Ru2KrjWZGIOUQ0qBgxA0cAM9q+siD15HwxOawDy29LhkgL/pseMBpxt
   A==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="213263838"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:49:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAiKpTYnAA8z9QrqXi8CXnuolGb5p+ZQdk5Gpf/c7Vlv7BTI6Emgh5OU+l/3rdk3hd2T/tnVQuxuCRW8H69uW0DzliWvFVdMbtpsEICqdtrdtJ3uXx9Hfdpa8rcwbk+Ik1NRpTRMrh3hd/X5DBcwpeT3qFd9s/qSdV/HB4IXk+CdTaWUrZF3NONirMpaxPCDGXuH+nAoxi8y/JWfc8tbfc+kkKCzg32+ZMKA44iHrr09xqncQaJw5M8fmQsle+o1Q+a807+aSuYRhHr4VpGAjFMI6t/6jCS9VtWoVf250fX5CwAjAKEu+SNiM77Xy4ANfrSWiMrJOa82314fh9mzKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZTJvhUR79lyLm3waC7rNS7ZWG2lahnHtxNiBU+fQ8c=;
 b=VnevCKGekxz2OR3cX6eKsQthGW2vmEPFNFuvmWIYbu0gVPa7e/NOwJHieFXsgNcmnilI5VIHO0WwgRaa/0AbuoasmpRAix/ACsvvzCdkUI2DGOu8thdc/b8FRI5ssWX+6adZfwyEkBRmLpuDwyd1f2QrgVfDTob/KNa3x5fMh2CTggwAmDpeCTqj+LD2OV2FL1G3tEPtRGLc2a8jUTwAc0PXgIP6pgyf8kuRMNG8ch3F9My+9yqlNdEjbUNnp/WCkzABiGx4p/8DBHXcfOGC3u/JDtXER4ik2Fs2ijwRhXaS3zJGU96rPUEJZmjflHaFM7F1LkR9lFCCCSbt8r5ppQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZTJvhUR79lyLm3waC7rNS7ZWG2lahnHtxNiBU+fQ8c=;
 b=Xx7pTuOIYFZnycGxGvcA4VVirh0fIjdJgVHnHSoUVVnha+MKgbCpIShBCBY6jeTZLE2NDt03ZFbmzESiWGU3C42fJMxYFKkPp69stqn9BwyPudDOu/qY57MdN0R0e3B1NOqiXDPbbYnmniZH9VwF0V78piMGfXo74AD/VEUC0IU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BL0PR04MB4865.namprd04.prod.outlook.com (2603:10b6:208:5d::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Fri, 28 Oct 2022 11:49:04 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 11:49:04 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 03/13] zbd: add zbd_zone_remainder() helper function
Thread-Topic: [PATCH v2 03/13] zbd: add zbd_zone_remainder() helper function
Thread-Index: AQHY6cmcY4sbXuz860+e/bilpPyIc64jEZOAgAChaAA=
Date:   Fri, 28 Oct 2022 11:49:04 +0000
Message-ID: <20221028114904.yg7e4xypbhhls4zx@shindev>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
 <20221027060139.952508-4-shinichiro.kawasaki@wdc.com>
 <75f4b490287caa45a46af0a31db9608426c767c5.camel@wdc.com>
In-Reply-To: <75f4b490287caa45a46af0a31db9608426c767c5.camel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BL0PR04MB4865:EE_
x-ms-office365-filtering-correlation-id: 6948d1cc-b986-4a9e-6fb0-08dab8da6a03
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p7KT/IWF+FDSo1fsgT+XPbTf+vHbyCa2LOqG4FRXBFF9hwku0KP8jhs34PWHj3PPezTwjqd/OFjXCl7+1dnfxbPtNHAviXrKntbHLv7VUMaZvPe04X0O+e31tQaSNlnZqA5lmjW2Qk+KpmAP/xZ/Dl9SBWf5Gi7mymp1EJNoIY1/Ok6JmME0RlzxCyHPqnDqDtvVFGMUhYnChcY1oEI6f4VihJN0UjzakrR2tM/juIUHBwyIe23KJT63dGo+/0ISX8iEmZsMlYWmBFteWuJDUoHzAqBhcsDv3afM+uj4BvoZLkrn8AEuGC9Tx16VMCFjkyV+hcyrs5XEowNaJVxRBf5Z1Kf/js+YYd5YXWMs5E87z6ydeaWZdURoQvSTwogPz/m4u4Cs//2qXJT9aTGyj5k6+Xh2VVwM2I+2RGBxY0AktWebw93g33fWIS7tpM7aDQh3XNBkt+eCxugLHsvkJwrbHaBPMmV/YkOsM4otRhXS9tIUf2z2snqSxwqTs4mRgZMvmJiOUnyO5/NqF/1dqhbSGtKVTTahnuK0y0qc5AkshJ7VRaZ2M/L+fJhka2f+bhhxuwMbrbaJBjoLFdUifFwERIhMGj1Wj0VikRDnKuF8YxKXnAT3aYJGJS8tnzBeE35Mut4FuOdpQL4qduoYuVv3RKDBexRIjHUf6INDB/Lf+LEu6JoOnSC1JClwjLzNylGz39T+YtnLc975c/DGOS1UWx7EP7m8v9l9v/3mbuGZzsqFLRMjk8zHM2870r1Kvnuk8Lia3npvkmxTlZwevQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199015)(1076003)(186003)(26005)(6512007)(9686003)(6506007)(83380400001)(4744005)(44832011)(2906002)(4001150100001)(33716001)(5660300002)(54906003)(316002)(6636002)(478600001)(6486002)(76116006)(71200400001)(6862004)(41300700001)(8936002)(91956017)(4326008)(8676002)(64756008)(66476007)(66556008)(66446008)(66946007)(86362001)(82960400001)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eodkrNC4/EjTHEbPnE+20ehoigOoolFZypvsHaga2pU+iNMIPk6/yqWNn7Vw?=
 =?us-ascii?Q?KfoaR+Nerq3b+MEndeILwEOekkhcgxsqoPjCZHk8XrzkU1FcqL5rSSr0t3lg?=
 =?us-ascii?Q?qEZqQjZ6sIXyk0+fs9I1h1RB4X4gCmRYrCVja/TdkQ3Vk+AaMkDqKdRc2//9?=
 =?us-ascii?Q?boZe6P5WUv25uEfufc1TnFs3b/mjaWGoNma8KdvRLjatvU9SufRBWeh7fHuD?=
 =?us-ascii?Q?67rocLTcCRJu4FLPW0e8g3S7TSPx6DKWMwocx0l5zRr/o6hcvImIeXi9Me4p?=
 =?us-ascii?Q?rDniL+JNfd5cL1/ciab0/CqB4NrYQWLrcfW4VNiDf60jftol6rK8/Kd1q3y8?=
 =?us-ascii?Q?PUhPHFOd+ifHhJmD11Gj91amF8M7Yun6drDiiMMUxQ7ft8AgKzzPNGU5EKPP?=
 =?us-ascii?Q?0bnR37NcAhA2B8Z93Z6I/azVcaZL06cHKFJJN6DTJC9WZ6a/9rUZDBN6VWmV?=
 =?us-ascii?Q?2iTbirhUFvQewNG0u7cx1LTF0bfe6WqwRVXr4Py5KjCRTArmhjubLer21EpL?=
 =?us-ascii?Q?/jUiqE2ZwGoUJwKczqKkDqYY87K31YE5wj+330vc3joWeJd1Qebsk374755+?=
 =?us-ascii?Q?VZUDQ/DsjhahGLGX0inJiWDFgUVCa1vdyIwTjz23b1xEATSuC+H6xmsk3MZb?=
 =?us-ascii?Q?f0dxAyWkmtbVSu8S06/fu8E3fuKOcNo5QNfPs4F7+8k9g2XVVPGboSaKCzIW?=
 =?us-ascii?Q?ky/NFjjHISK7+/27qTO37mRAEXezwZ9MOivbf80Exl7nFczMeINAwWcwBTQ9?=
 =?us-ascii?Q?kz9tN58+npp9iScjPD2DDHFFCg/MiFyizC7nTg6nPYmtwiZ3s5zN1UDEg9Kl?=
 =?us-ascii?Q?glxP0ex88/kZadOgvymw1itFlGZ06uYuLEhBth5t8m10ktOsEm5HfNpFydKy?=
 =?us-ascii?Q?Y2usAroiaWNShE3yY36mAVvwxhqJXh+K/0Iyx4cvJdDUD3RpR2LG6QDX+qc6?=
 =?us-ascii?Q?gMH2VZaoAqRvy7Hkz+LX7vTPOufs501URp0tdrXHcY9DNKHzF1LoMt0EwLfR?=
 =?us-ascii?Q?qKILSeHyrZj2R3r3IrTRKbXR9pGNjxhLChxQQCSdGRKh/ndKg2KiqzHip+T8?=
 =?us-ascii?Q?aIvcl+3bVCNtbbM1pv0gWDVK22sWKOH1LecIJyH+ceG99mVzFmsM5mQPXsSZ?=
 =?us-ascii?Q?Yw2HVOeP6yIvfww7Ouzy9JlH8J3EE6RFyycJvr6uSZmWkZ+ciKp7fBwgMxuk?=
 =?us-ascii?Q?YiHMneYRg8kteEMgFXpZ4TTombYpWqmIzCLRwRCjg+LNlBuCoWiVaQWr9WQN?=
 =?us-ascii?Q?yKhmWpur+RCejFGt5dAdIY+khI895Wmw+kMPIQSQVyvoaZFbKFYHmFVojGB+?=
 =?us-ascii?Q?YmCOEkc61wYIy5g+uvbLCicaxjzpc475iFXvE+rQP/dEtPFZfyNi29C2u4g2?=
 =?us-ascii?Q?Dq0S1Lhd/To3qV9xyDuUMChuZoj/1H4Ue2oZdCCK2UVT5N1JSimrqszNGj0i?=
 =?us-ascii?Q?yVKb+cM9iXEkCd5t4aY0UZ7/UWcMvgk3OgvFy9Hmu0U8nYLlqerKLYtQZ+hh?=
 =?us-ascii?Q?Y5dZ9R4/mz1wwMhIUX6iQptjPwdlGZ61VroCwhiKijN7nC9bv8FL5t1TKAIg?=
 =?us-ascii?Q?Uu8oXoHh0Giyz71yWhTLDpfRbbsOkhTduMR1d7INXRzCi2l7659QtI8umCLF?=
 =?us-ascii?Q?VxD862CohFwEc00mq7IT3Aw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB4B0EAA693BAF4DAAEB03AA5A047C3B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6948d1cc-b986-4a9e-6fb0-08dab8da6a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 11:49:04.6869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gRidGOtNNN0KzG7mvs71Fd0v7rcJWq/pc7ICT4FWzTdv783d1ouYkCgBZF6+yoWd0FXzKPDxsOjsNODgMscITygTu0AZqkWIjpfOBGMeelA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4865
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Oct 28, 2022 / 02:11, Dmitry Fomichev wrote:
> On Thu, 2022-10-27 at 15:01 +0900, Shin'ichiro Kawasaki wrote:
> > Add the helper function zbd_zone_remainder(), which returns bytes can b=
e
> > written to the zone. Use this function to improve readability. It will
> >=20
>=20
> Nit: the "bytes can be written to the zone" part could be phrased a bit b=
etter by
> saying "the number of bytes that are still available for writing before t=
he zone
> gets full" instead.

Thanks. Will improve the commit message as suggested. The function header
comment has same text. Will update it also.

--=20
Shin'ichiro Kawasaki=
