Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2A2EB64DC
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 03:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjGSDKt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 23:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjGSDKr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 23:10:47 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17EE1FEC
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 20:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689736237; x=1721272237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AZt+dzMmAcvCP0HPgJWER84hQ0iTfTjbU4YgUgOafBg=;
  b=KOb8zqr1Had76MlLNkjkijlFtgbRUSp9ePeDjXc7jWuGS8v1AjD0WxaE
   ybq3WzTZ96U/OVINawEtRbXkF0FnnGt+SqWdcFy0V+InST3cP5LpW8FH3
   8wV7sfCFmryh6phQ9XuabjBmn58vOlKYAeEebkZV98ky/1+308qS+x4B1
   SImcyvSUzMm7ORM/zcTyk1sGu2vp+tz9USCRBpGmK1c7n9rSMDn50WkWc
   vdZJgZfxmKRF+40B5q7Xphop8x8LK1QJFgcJXkj/EX9vNQYtRw3R8SaAT
   zofEp8VtQzPNwlEj7N78smPuj4yDhVBYeTKW1dm5rca6jvbWwxajfRhTz
   g==;
X-IronPort-AV: E=Sophos;i="6.01,215,1684771200"; 
   d="scan'208";a="243117614"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 11:10:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWwER+a3m1UUmBAqTkAckCGRuVN9Ktdeh3EdE+O1NzgyKX/0CwS482N1HLcDe0ztd9E5u/DTYVj/0bsmXoz2aDT55Ev+hqLvBB0PJyXdPkMG35vBq+Cbfrh/hP6kizW4CNONt1ndXLEy0VR8KRqwrLSWHb9SM3YPD5BNKWEGJQjA3wjpnxbUPx0BBwPsUPEUyRIAtjlQ2LkStPrp4nz4JOs5op3+u0b1Vq/fFlYuI4iiEMw9XXkvADOvoI8y9ocJOzBnoJAOb95ygKhVelRduQMxO1Ur0591Ujq1IG53Yt1Cvz2o4S9hjfaeAJbs9VN6jjY++7mknq/1H2IR+JdAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9l14f87NhMzhY5mItZBbumt/H1SLWYL9NMIS+FvvEac=;
 b=jF8uG3gKBrqAEi6ygE7+8hba6Buzvro7m3WtOisbjxFzvAt47irNa1lZOQ9Iagh29FzvUvuDvNLkgusmY8x51At6dr+dNV9nddw5GxJigtvm2piCsTYTyT6dvcz43+J3bhPSCX/Kk4HHV/XdelDcPiv6hCUNSbu4irav6Wedigd1lpOpajsYtlso1sSvIEheNZWZrxgyQkIxXky9k34s1taTz38YiM3ehe/VhgJzUgOBpC7xRfpzxgjWiUVKWTp0eLbJMMeedRu23762jA6nSCnXRaPjqshHCnDo02OEPr7ILTGkHU3aoHxk09slB+WA3dyTcAwdYTdM9SE7D68yyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9l14f87NhMzhY5mItZBbumt/H1SLWYL9NMIS+FvvEac=;
 b=IdTnhw4YTkaiudAJC29lP/ra7T3aIfI4nliaqzqRUIUuDAKMcT+Wk3dAlrKQPwUUVprQInS07Qj7hamylCz5Yx8bbNZqbKHcSof3CiTLs9rzSYh+c9wJ+vueqCSedZ2A1ZfqnRajBqzp5wZSav2nfkewcM1Oxii2pdm9zTwu/rE=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Wed, 19 Jul
 2023 03:10:34 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9%7]) with mapi id 15.20.6609.022; Wed, 19 Jul 2023
 03:10:33 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 01/13] zbd: refer max_active_zones sysfs attribute
Thread-Topic: [PATCH 01/13] zbd: refer max_active_zones sysfs attribute
Thread-Index: Adm57pSuc96E6yerrUuHReIYdC7mLA==
Date:   Wed, 19 Jul 2023 03:10:33 +0000
Message-ID: <mfisx4lyf55sxvarhqtw2vgqhr4w5qtkjzgl7pre3ryrifi2zj@ro5dxghnzyip>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-2-shinichiro.kawasaki@wdc.com>
 <ZLaZuZFe5oQBWlNw@x1-carbon>
In-Reply-To: <ZLaZuZFe5oQBWlNw@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB8377:EE_
x-ms-office365-filtering-correlation-id: 641b43c1-7203-4cec-c9e3-08db8805b731
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uJwGukInki7I7+5lAgFeM/4jdbH14RCSMVErlYeu0cVraxt3pkVtWvBvJM+nroZMBX2KqP5VlIs7B+yZDwxzr3ZqFcpRH0bZALplDDRI5kkbJzmtNPCrlGIIAb5Bbe/q7JFbYGGEGwM/jsGA9BEmz0fTQU/ZI5/85kiqR8Z1ZA+zfioznUibOkYA/gbEExmor2LT6ZWfprB4oEYsfidswY30sUEZr5cl50Z8y3IqDY8D0bNOJztQZm/W5NA49+2lHHI/x4FRbs1VrOYvFjuK+sl3dC/els8RulFHb2eOBziWzvZsUjUbnGwnx/2kgavK90hhjAUEk7ZZe5ozmZre79qQCYFxmQHLcWaOQXI+FsVLMmzZucASFVsqUnasV4oxy98Q2Q69XRs1a0SF1FvYIFiL+uL6ig2+2AtencI0krFa6KpNv6MydGfkM+rgsAiog2euAoJo/21u61OkrVK4Bu07aHcb28bF9f9nnjTBFBPpL1oH0Xx5YZHjvuD+HIxPmfImBF3Lj+fqCcXDssEso7UbmR4OA1Rq2d4PkbRbY7NurfuLGw1d2SKZr2++D1drlQpd4fXg7Q1elOzGtXlKh8e77+TBBvrAb+aappv659oXz9cOzM44G1o854JKr6uw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(82960400001)(478600001)(6506007)(26005)(9686003)(6512007)(6486002)(71200400001)(6862004)(4326008)(83380400001)(8676002)(44832011)(38070700005)(5660300002)(316002)(6636002)(41300700001)(33716001)(86362001)(2906002)(8936002)(186003)(122000001)(38100700002)(66946007)(76116006)(54906003)(66476007)(66446008)(91956017)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BKjPnH8dZwHh/WS3LegcY/6KPZ8KQRpdBAHeqb2uLTPfMOUuF6wzi0mkxHpu?=
 =?us-ascii?Q?CiHd1DBsOG1uOeM4DTFRFzW8Nn7/YbYZArM0M4d0BcS5R/c0U/yt8+NYkx3l?=
 =?us-ascii?Q?S/H+kRbQXMJ9jeWqagvQOEQK3ur5xJtWt0UIVH+zkBrOsaLofQPoEl78+GDr?=
 =?us-ascii?Q?g07OtMBL14s6u7jZtaMQ4j9/L2aJBEnYQ6BVTciGzB0/Lc6LrfC6qM8v5/5T?=
 =?us-ascii?Q?ASBUUZoNxbk2wgPlX20hAUlwGW13jGZdG0IqekOgaoHu/IU/Gl4mazrJSQwM?=
 =?us-ascii?Q?zBc4OHkK2R5BdaKP20GelZgyQCyQQ7yJrlY0mrEjr8sXVTTF2MIeqXSieUHl?=
 =?us-ascii?Q?aShc1nDucuabGIdB+rswDGvvHftIMBboAP72KqldpiJivKT241tAGOU8jxxs?=
 =?us-ascii?Q?SLNt2C7tFmS22jkaXPg0gd8LbDWYLjTwiz+pBRKFKcBqfBEiP87gBCRuU8Q9?=
 =?us-ascii?Q?haEqjsqoD9DPOaL9xkYwabBQcKETaY1Ii3KwU9lArlD0eiDtWU0zE0Elp2Ji?=
 =?us-ascii?Q?mH8ONBwzZTzd6QNeVAvMdPpTQn9hLK0KJTl9YKtrH2mYF3ecoKbrMx6I7MEs?=
 =?us-ascii?Q?znPQCOQIY9uG8T70QBl6tW60aXeKniGdMjufk7Vx/D8omSYCHeY4Lt+4tXXJ?=
 =?us-ascii?Q?FXYJxut8T2k9w0IQMke4ZzxN+ZPD8fYw5KOzRAJE/Ushq44KA1dq590ETFiv?=
 =?us-ascii?Q?w7nkVoKH6xgmwdr4Ds3MeawJ03nVo4X0iUGjxsC3i7CzWZIJ6JaxMj6sFxqv?=
 =?us-ascii?Q?dbIIadC5C/oMsPbg31OHY8oWy4fz/4bOWMongvUi15rB9x+MoNRD02VlXJix?=
 =?us-ascii?Q?l1y20+6CVPh7+kt6VkhbAFw1zW3fouk6UZioRw/Td1EOdmOI5aCdqYqVasXb?=
 =?us-ascii?Q?kB6SoovIG5FRhlPUUepsPiCD35fXcO+hSPo/FT1UMnaUCNBKIhpnAi5SbXZc?=
 =?us-ascii?Q?PVdddjxSbPXb+UcnYFWKFWYOVfWLKjSBRlJP244eW5QiMXFYywDxvmkTZ3TY?=
 =?us-ascii?Q?jjk41CkcNJtij0Ro6wRLwSRpJqC73J6uQgu2TGKesmVUn3v01WOFH4ItqW3o?=
 =?us-ascii?Q?t+9jhONsadu1spfuUYBQnHUyNPRjkMp4Y9wWi6FLIEfraKFCS/i30YKePBVX?=
 =?us-ascii?Q?BqkpUf+uFFK57FHnv/CbCElvT/6222kcus4RUiQWe9m2viI/doGaM2jrn4ju?=
 =?us-ascii?Q?B3K+sPlcPM/oDH6ukVkzBkfeABeaS1ydtIrwXuML0UQL7kmW//7rm9ONy8YF?=
 =?us-ascii?Q?NVXlDh6WlVgh0k6xk6Y+n9Ahco/E2uMH7qw4OgzDcaYKkPZaL3LTcQKNnBId?=
 =?us-ascii?Q?cG2Lmx9wdt/J2l+9dGJkq6nSrMWFvBkTZ8Qry/O20lmEZuZXnsy33j9Wa1RZ?=
 =?us-ascii?Q?ynfB2giYKcFbbPOLpoUaQ1lSApU49poyzRQtOhFTGXW7UBzSrD1VE5qOM3Je?=
 =?us-ascii?Q?cNLcJw+qkQGDs08k4RGjSnA10PE2cghTvHA+cjm2lGs8OrwJTz2jmMPSoO7e?=
 =?us-ascii?Q?wrY0Srgn+8/vRe3pVnzCApaz4d421bgLUxzC0SiwWdCZLBkNsWq2M2iCD2BO?=
 =?us-ascii?Q?Vr6DX13gpThHkkXNqT0IkJOEvu2mRdDfRxulkQegU2DbKt4mD/kPLunn+VDU?=
 =?us-ascii?Q?dUyr9Ye1p8lgFgLUHXVJAKs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <186602CCCD77E5448344B9F2637EFC17@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ePKH1dkNEd/245GRuUXAGC1zBmBLjKpGTVOTQoxzT4pdDkc3mIvX8uyH/51IchaOTP3uD/Lrg8iPyxX8QUHZgQRAH8HB1Ze1m3kpge7BapdjAQOCpfw7YTDHczUTB8gTDqmkIKKWokQGoto52xK3p22wSmSyOqihfsoQKQuPBNi1UwW9cJRtB1HK3TWX8AFVhmq79+OWE9h0+v9CvE4ZxSxrBGjsDiKJT0ljmhb8GGvU2faG2sUtoxAP0tTkZQ30q88pjs0DQUCSl5oIe6glmzy2HM/lvPj658BYHjAnPKyImiHzhn7qp8i9dxUCm/806Txo5MqrdQ8rFdjS+m1m4WiAg+iOUMDJRL405tCT4/yqeyuRLWUdi+kwcXsq9vXd2Oo93uvB6fnDfTDkK30ebEM+IgZZzB2I4oPlpjbRNYl/pTH/tBBhCqeRGsat2Y0dcx6TSaa7HnlCmN4zzfocJdpQ7Pkelvn7Cu11igVEpdjOkrzg3z/O/HltJaXD/W5b9MI+I8d/7Kswt/MuuAk5vMyYf5nOcBa1AWxkWFc9pH08r71thNFEajc1I/1z0N95jOnvn7nW2yls33IfURUKdSvkqfv8jHI1k2QSXFz3HTh2UUTGYzJ9mdXOB3gxmKgGFRBYAVtPI6QGMXur98VaLByeCE84BE2QzrrwdnxEWFl/DT5byDilruiNr6FmMjRvJIf+/hvmBiMUaJV/BAdojmu25kbdt8NKV77oZAb2YbATTjN0YTThBTR8bBGyKYO/FzuX86jJNnp1DgxbUFbKCvcBXye+9MFSjz6WJMs6WCgRuqlvAagqHoCumYb58M/nWCDHRfJddg25rq6Zd7Zg/Pd2OlDsybj1Smgg84EdLkk=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 641b43c1-7203-4cec-c9e3-08db8805b731
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 03:10:33.2534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AOSVw9KXwpz7d62iM7+/W3ANppZampDvNRD91G3mJo9uxtv7Uqfs+aUMEmLRVswJ9JeUr/ofPto3g92fjeN55+OkB34eS1iZjgrAadm7lmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jul 18, 2023 / 13:55, Niklas Cassel wrote:
> On Fri, Jul 07, 2023 at 12:14:53PM +0900, Shin'ichiro Kawasaki wrote:
> > As a preparation to improve open zones accounting for devices with the
> > max_active_zones limit, refer max_active_zones sysfs attribute. Then
> > keep the limit value in the struct zoned_block_device_info.
> >
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  oslib/blkzoned.h       |  9 +++++++++
> >  oslib/linux-blkzoned.c | 23 +++++++++++++++++++++++
> >  zbd.c                  |  8 ++++++++
> >  zbd.h                  |  4 ++++
> >  4 files changed, 44 insertions(+)
> >
> > diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
> > index 29fb034f..e598bd4f 100644
> > --- a/oslib/blkzoned.h
> > +++ b/oslib/blkzoned.h
> > @@ -18,6 +18,9 @@ extern int blkzoned_reset_wp(struct thread_data *td, =
struct fio_file *f,
> >				uint64_t offset, uint64_t length);
> >  extern int blkzoned_get_max_open_zones(struct thread_data *td, struct =
fio_file *f,
> >				       unsigned int *max_open_zones);
> > +extern int blkzoned_get_max_active_zones(struct thread_data *td,
> > +					 struct fio_file *f,
> > +					 unsigned int *max_active_zones);
> >  extern int blkzoned_finish_zone(struct thread_data *td, struct fio_fil=
e *f,
> >				uint64_t offset, uint64_t length);
> >  #else
> > @@ -53,6 +56,12 @@ static inline int blkzoned_get_max_open_zones(struct=
 thread_data *td, struct fio
> >  {
> >	return -EIO;
> >  }
> > +static inline int blkzoned_get_max_active_zones(struct thread_data *td=
,
> > +						struct fio_file *f,
> > +						unsigned int *max_open_zones)
> > +{
> > +	return -EIO;
> > +}
> >  static inline int blkzoned_finish_zone(struct thread_data *td,
> >				       struct fio_file *f,
> >				       uint64_t offset, uint64_t length)
> > diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
> > index 722e0992..2c3ecf33 100644
> > --- a/oslib/linux-blkzoned.c
> > +++ b/oslib/linux-blkzoned.c
> > @@ -186,6 +186,29 @@ int blkzoned_get_max_open_zones(struct thread_data=
 *td, struct fio_file *f,
> >	return 0;
> >  }
> >
> > +int blkzoned_get_max_active_zones(struct thread_data *td, struct fio_f=
ile *f,
> > +				  unsigned int *max_active_zones)
> > +{
> > +	char *max_active_str;
> > +
> > +	if (f->filetype !=3D FIO_TYPE_BLOCK)
> > +		return -EIO;
> > +
> > +	max_active_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/max_a=
ctive_zones");
> > +	if (!max_active_str) {
> > +		*max_active_zones =3D 0;
> > +		return 0;
> > +	}
> > +
> > +	dprint(FD_ZBD, "%s: max active zones supported by device: %s\n",
> > +	       f->file_name, max_active_str);
> > +	*max_active_zones =3D atoll(max_active_str);
> > +
> > +	free(max_active_str);
> > +
> > +	return 0;
> > +}
> > +
> >  static uint64_t zone_capacity(struct blk_zone_report *hdr,
> >			      struct blk_zone *blkz)
> >  {
> > diff --git a/zbd.c b/zbd.c
> > index d4565215..9743b60e 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -922,6 +922,14 @@ static int parse_zone_info(struct thread_data *td,=
 struct fio_file *f)
> >	/* a sentinel */
> >	zbd_info->zone_info[nr_zones].start =3D offset;
> >
> > +	ret =3D blkzoned_get_max_active_zones(td, f,
> > +					    &zbd_info->max_active_zones);
>=20
>=20
> For max_open_zones, we have a get_max_open_zones function pointer in stru=
ct
> ioengine_ops.
>=20
> And then we have a function:
> static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file=
 *f,
> 				  unsigned int *max_open_zones)
> {
> 	if (td->io_ops && td->io_ops->get_max_open_zones)
> 		ret =3D td->io_ops->get_max_open_zones(td, f, max_open_zones);
> 	else
> 		ret =3D blkzoned_get_max_open_zones(td, f, max_open_zones);
>=20
> }
> in zbd.c.
>=20
>=20
> I do realize that the engines/libzbc.c ioengine will not provide a custom
> implementation for get_max_active_zones, since max active zones does not
> exist in ZBC/ZAC, however, perhaps we should be nice/consistent and provi=
de
> a .get_max_active_zones function pointer anyway, I can imagine that the
> in-tree ioengine engines/xnvme.c might want to implement it, and I could
> also see the out-of-tree SPDK ioengine plugin(s) wanting to implement it.
> (Even if introducing a new function pointer  means that we need to bump
> FIO_IOOPS_VERSION.)

Thanks for the review. I agree that this idea will be nice and consistent.
Another IO engine to support .get_max_active_zones will be io_uring engine.
I will rework this patch to add the callback to struct ioengine_ops.=
