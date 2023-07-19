Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21EEEB64DA
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 11:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjGSLJR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 07:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGSLJP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 07:09:15 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA741BF5
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 04:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764939; x=1721300939;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T5qyBCAgogE9WGxcy8qiWZ4CAzA35vNCx6qeuhuHWJE=;
  b=T2XPOdie8WqjjSeBe4H1hyjNc4sDj+gKgLusztS/0r2cpurN0O7xdS60
   gg6QHr31n967ADJSxPZEpdcC7DrmteApahmburmWfAMCDc/zaEokMH4bK
   dDms3qUUwVyUx2QRm+pYvv6CXbrc6tzBM8JVhcjpZttOOlqeqWqg+ZGdm
   hdO0A9oSmZPt0fNaERZAvhsZJZLsghG3aaX4Vb031wr0TsEy9/WaI1fNb
   uWiybeysxBGh9wdkXS3uDkYRa0d4wAJYHbp3wfs+zbuTyvNVxkTz8geJD
   HIu3j7ERWZNWPLrwClFqYGtIP0XWHm1a/ygbh59IReX9FMzABLSk2eaUL
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="350471287"
Received: from mail-bn1nam02lp2046.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.46])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 19:08:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLLaj7pvLqBHWVtLytR2BPjhnqHyxFhxBQ2LPCLUwoJfEMRvSkwAGiVPRGoOkb3zu7eWbYcNCqZJPL/rk03Y+cpu+gYeCvEielH+iKFbGxDq5W1v4PA3ACv3JEiM5EAd1fCL1/QJ0oaTvRsDHWOEAqRULTIyQZiNQ2d/CJNY0rO1AW50MAeJ9Az8iYtKfSnJZ+SVCfxe3UPTpxga2VV8A2ibnWzdx94s8AoChZ2MKdh9C9NFBWKPTQ2f7cEkOJM3RiWR5h8s5WM/KUNxsjs0pqkj2h2uaL2cfGcpbyhNp4w+PDVWIYhDl+UEEfxoJTQPN72tXXBCJc20qAW7tgC2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrHhPpch4Hp3ozTo6z0X4K2q5CA2eC60cb4pgc17mG4=;
 b=c17D/MAIwb46aGJZXxLLqF837OTISEKHW+7FhubjXyTyCOK2WvKIWHg1p0i47qBpZfzx1svZgL47GEcstJmsLWuJa8YYQ0jhusA9vOLTpz+HqGsoP4vlg+NxyFyCEvtoBwpKw/wNpt3u1jxZfqexRmYUFHZiWohhnm0njXsvhxEYT+WronAGEvvw4cZNPBCUXrnL5GjyaNV9zCaqwQ0yMcyc6T4h6N9X0Fo+NbnbPXm43vWrXwKkbU0InhUIPu35BDefulDbdcGDOTpjL/VR4rIo5M/KTImyIzUK1bcv2aed6a3zf4QmcRFjjCPtFSRW6yNOlCqLRANAOQYeihPj3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrHhPpch4Hp3ozTo6z0X4K2q5CA2eC60cb4pgc17mG4=;
 b=IS2XNa6t//5vRPC+2AaVc7sNkiJuiPg9Q8WHzNIHKtiLYNfW1RcPpPdeEYhM8HFNeUadWvST2kAzCuC//XfZfsMBsVdAPBvDzJGNgPBIhVPicDPWtq+BfLG8CjrC7Syj4ZRuFDKdnxY70YP55obYBZkWVrOFzf12RSmSCNvdGGs=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SN7PR04MB8530.namprd04.prod.outlook.com (2603:10b6:806:322::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Wed, 19 Jul
 2023 11:08:55 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.024; Wed, 19 Jul 2023
 11:08:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 01/13] zbd: get max_active_zones limit value from zoned
 devices
Thread-Topic: [PATCH v2 01/13] zbd: get max_active_zones limit value from
 zoned devices
Thread-Index: AQHZui/mU7ZY5+Oo+ki8SiNLmlQS1a/A7mmA
Date:   Wed, 19 Jul 2023 11:08:54 +0000
Message-ID: <ZLfEQbuAn7Ci1wpD@x1-carbon>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
 <20230719105756.553146-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230719105756.553146-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SN7PR04MB8530:EE_
x-ms-office365-filtering-correlation-id: 9f7615d8-ba74-48d1-7fad-08db88488aa8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+Qtaal1N38DMRCOk9Ns5d686TyOuJxI/3xq9A7eoY4g2+6IjmMyPSCUlGStSz1GSxyldCSgGw1SkElsjlPtBEDU4WmF8UOV/Ani8f5//TrVUthLsl5GQkLPg8516DKhnYYAi2K5dIKQyg32YBQKlO/4+c5TEKfSnHlXrar/wHaxPfWbo22HjMOd0b/ApLbNSTJLehIl6L25MZC1iK24VPXZvyhROS0dYFFwXg7WXm3twy5SqOuFe1cJBW5lJgWUNdi5ob3R9JVZs/7b3DPuwS85mpBCekw1JK9MLhVpQEC5fwE8aPpNBM2UPq2nOkwKPdNgByzr5LosiZQB+STTkdMO7BoYMXXjd7XpR17l5D346kLFlyqi0QrcXFJOe2VRF1Ug+Dy8Zysn57Gsv0LrGQEpbAj2S+oTO2Ap6Uf33EwtTBIjk/Dd2Q6y2EeSc5DiS5nHXiPGLxIgOK1Tq0xwJzJaXX/6cwGElSQRz3P08ANhMbmEIZxvnVc0RoLWDGEuLvOL2F5WJ42b19xYB8tBLvRia3DQh8mVDI9sv02ZM0Q2jdWBUcahgRHV99n+MwAY5iMesyDAZPfQ5KgysXtXDuWztBRvgh+l2b2UhR0YOVjUyvXHYZnI4gZwmjCT7mmU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(66476007)(122000001)(83380400001)(6506007)(26005)(6486002)(66556008)(71200400001)(82960400001)(4326008)(54906003)(38100700002)(91956017)(478600001)(76116006)(66946007)(66446008)(64756008)(2906002)(8936002)(38070700005)(186003)(6862004)(8676002)(5660300002)(6636002)(33716001)(316002)(41300700001)(86362001)(6512007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BCxg2tsNTDmlHKdeXpNM7oVIs76hBvl4/+0Edgjx8mKUOrUSDFAtjVdMfUj4?=
 =?us-ascii?Q?ijO917t+dJm5lDV6dcJMag3zexESMoQ/QDsTH/ITDWkn6ffHiBXN5eDd6gWM?=
 =?us-ascii?Q?0RPQOlXpJxAT3+jTkxTjKK+eATjTMRsQ1lHLcMONizakS7NzE9xj7bmsDcos?=
 =?us-ascii?Q?37O2lUaXkTJ2JUriBbVnLdSt02yCqo/CatzETig4VAqtcIvbgq3RKJx9OHF6?=
 =?us-ascii?Q?ulp9owHRShixOxRflQq1C5oNJvLAcqzUGdcsdj8nSFYL/JnobUNxaVd3i6U6?=
 =?us-ascii?Q?KHa6hB2ya8LGtLbXGR3Cb3s53C50d7mrT1mhVQNyEMEUqAz8s0LCdmJPyqg1?=
 =?us-ascii?Q?NzLMfUXbEDllQg9aERB0M4Zb0ysFOooVnQxpoczLu9rs04+tveeYAV9fRAlY?=
 =?us-ascii?Q?SL6uXAstmLlakX+hMc3r7FmyUDDeCHlt2ulu9J8kmqY+kMkvYB5mZs2aBVsG?=
 =?us-ascii?Q?ZOLJjRkp62gzr92dFdsk7p9qSu9O+WRc1PjWqx06y3LKWHP2PuKx7wQgpypL?=
 =?us-ascii?Q?9hAkHjnVH76U5E4Ap9PjGkkH/Nc8VZd3sIUFOkRD93yWCAhgNcOvkyRenSco?=
 =?us-ascii?Q?QnWaDrmWCEoIBVyumk8nBkuL0bP8VgLVMqkzVqoNV22wAy98t6BBwGvPv87Y?=
 =?us-ascii?Q?P1DyTwKuqH4DMd7Z9YGaCiTjDSaFBkSDbV7BfoOiusB6WO+tOX2JHp7vlYwN?=
 =?us-ascii?Q?88MB3Fx+Y55MzCAgVFiMmARNfZLF1XWSLOsmfTJ7xlcof3LQX4UxZ9IOXZ/u?=
 =?us-ascii?Q?MiTElfRnFAhnsTm9Y82V5o+ED/EPfP+IE3zsxiENoTRFkbeOwa3sRsyNGH8v?=
 =?us-ascii?Q?3a4pIeOuRGuQ/QUTHqcMzx/oCf6b/w0NZ4nzxNYR4++/SD5RYVkTBDOCHdCd?=
 =?us-ascii?Q?DpL/NZ+WBdxR5IMXdy+4YO8FcpVKxcNZ0Gkj1EzI9ivkXqde3jTmL/NyEHy5?=
 =?us-ascii?Q?8QaJJbif8VaOfscLVF3uRfdO9PFJuzXm4H3cry/8yHXsP3NO5kecc7AQnOUT?=
 =?us-ascii?Q?EfrGZZVS+Yhy7F5Ta+qqL0twCZul0E3ppJ71K3HeGkUT5uLot5Jycr0pX9nD?=
 =?us-ascii?Q?fvn2ljrlK6N56V/Z+64sqSZ8HXzkdLou9D5xExUjITYaQrPoMehHEawUEWS4?=
 =?us-ascii?Q?6KdX9raC17KE5o616mFafYfp6tn4fmkjvGGIJLhEeW4YqiYgrhu0+Qp1d5dz?=
 =?us-ascii?Q?hcxihh8tH9YII0yfzSAKo6NLb/UVBez3T60mQY+EiiH9MwAQJqv2V6ZBzdez?=
 =?us-ascii?Q?kxplqo++S0JY2B0vznQm2an9RXxF1KU610i8zJlfZ+IVV5sQ60qQZqXvpt6Q?=
 =?us-ascii?Q?9Ql489nj9lfBSsiV3UUZXNK+zsDPwz685kRIHTyuCoJGI/iboyTO529DKnW4?=
 =?us-ascii?Q?vTCraaYA1+WqNledZSYSgnX1cyK0rcnub26gwCEsbZlBBAbfb8bM+a3N2J/J?=
 =?us-ascii?Q?5wlKR4De5U7HQI8FTYJaHbRFeFNeuAEg6DjfdCGumuVycujw8uhokrYLl19z?=
 =?us-ascii?Q?mITee8+IVuwRWE0cxZqb/9fBpyct+W5ivK8JPzzKwRI8p/3SwwwNDZv6zwhp?=
 =?us-ascii?Q?CBWdsHKt6lMGGXATzNLInr02pGN+bR8EyiQGLkUVO4yNbXdPLdVJ8g7JjC6C?=
 =?us-ascii?Q?IA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B217152F9DA69A4CA2C793B46FB780FF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: esIjD77LnyX8q+uBBC8E4yBaXdM6U+sKgSTSZpdl0kAouNscvW7M9d8f8lEwm+LmqykZubGHx3vnvRYRNd0nbvVmbska7q6Bjv4URnybQJvC6aCM/2RUU6QHf+8s4HkcM49Db7H/hDDUG/6+Cji+AdsR61CbbPlVTo2IVcnwlzawNkUu6jkjN5bvYR06dtbd3gg1RkZSLCEO/NtZjpSSuNg/vVkH72h3sHsSQVUpK3vpWV4MkLPd5jEjvyS1P0Oszmiy9ZFQdMW2NY3PfgFl8MATz/tT/S7JaZsrN1xTXacP4p4Rses7x7FGg3BAFelZK4y4lJqYx5K1/qk5Vt5L1EfnzXKylWVNHJgdZnVYyFR8jcNbu3zyNZS7jpx6oRu80Mu9C1jjkq4QrHAHuQxRSaiJHBGaxDNmLYl3QAKHGg2XH1FaJ1Ouqost7t2YAfodWyutE3WWxIYjB/MtasNf+l0H77vcweXTMzQpMzavQKIjqjwOJcBJKMKcCvexUZR3EoUnDuwtSo5b+ZhDJ25loCR/XHglKR6C/Xw+msgc+Gz5i6+Wv004nqaNbkkVBo2I1Pbxy4NcOyvj778Q8pReaFy2A6+A5n2S0Ggq/F+FAN2xHm2+CcodAKQm0zppqgcw2aDGt0VufVPYZk1X3vcgpbem4mSIQ4DU/KqIBXYSl7CDVefMMTd/P/AMmim9k4lajhyA5jCJJ+MGGCHaauiJGzMT8Bgh2GXMCsWuOoVdnRdFYgc2AQG/R/OCWFsNzj/DaWrh9n9Nb4JHcVDfZXQd0IBTdEcDec+rx6arQhyU5yL+IoSDVE1PBU2oTYwT4iZ49AfM6AwWYX9RBOH43KjD3VZxYftjbET72IFyd0QpumU=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7615d8-ba74-48d1-7fad-08db88488aa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 11:08:54.8088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rPd4CqzSSjGNvTVlg9QupZcuN+ypJ1CiJiy40ozqJE7X+LUgPWA0pRfwfA0Lr+YEjFFY0VqwXLgRAng+CnHdtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8530
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jul 19, 2023 at 07:57:44PM +0900, Shin'ichiro Kawasaki wrote:
> As a preparation to improve open zones accounting for devices with the
> max_active_zones limit, get the limit from the devices. In same manner
> as max_open_zones, call get_max_active_zones callback if the I/O engine
> supports it. Add the new call back to the I/O engine API and bump up
> FIO_IOOPS_VERSION. It is expected that io_uring and xnvme engines to
> support the callback later. When the callback is not available, refer
> max_active_zones sysfs attribute for block devices. When the limit value
> is not available, use zero value which means no limit. Keep the obtained
> limit value in the struct zoned_block_device_info.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  ioengines.h            |  4 +++-
>  oslib/blkzoned.h       |  9 +++++++++
>  oslib/linux-blkzoned.c | 23 +++++++++++++++++++++++
>  zbd.c                  | 29 +++++++++++++++++++++++++++++
>  zbd.h                  |  4 ++++
>  5 files changed, 68 insertions(+), 1 deletion(-)
>=20
> diff --git a/ioengines.h b/ioengines.h
> index 9484265e..4391b31e 100644
> --- a/ioengines.h
> +++ b/ioengines.h
> @@ -9,7 +9,7 @@
>  #include "zbd_types.h"
>  #include "fdp.h"
> =20
> -#define FIO_IOOPS_VERSION	32
> +#define FIO_IOOPS_VERSION	33
> =20
>  #ifndef CONFIG_DYNAMIC_ENGINES
>  #define FIO_STATIC	static
> @@ -62,6 +62,8 @@ struct ioengine_ops {
>  			uint64_t, uint64_t);
>  	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
>  				  unsigned int *);
> +	int (*get_max_active_zones)(struct thread_data *, struct fio_file *,
> +				    unsigned int *);
>  	int (*finish_zone)(struct thread_data *, struct fio_file *,
>  			   uint64_t, uint64_t);
>  	int (*fdp_fetch_ruhs)(struct thread_data *, struct fio_file *,
> diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
> index 29fb034f..e598bd4f 100644
> --- a/oslib/blkzoned.h
> +++ b/oslib/blkzoned.h
> @@ -18,6 +18,9 @@ extern int blkzoned_reset_wp(struct thread_data *td, st=
ruct fio_file *f,
>  				uint64_t offset, uint64_t length);
>  extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fi=
o_file *f,
>  				       unsigned int *max_open_zones);
> +extern int blkzoned_get_max_active_zones(struct thread_data *td,
> +					 struct fio_file *f,
> +					 unsigned int *max_active_zones);
>  extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file =
*f,
>  				uint64_t offset, uint64_t length);
>  #else
> @@ -53,6 +56,12 @@ static inline int blkzoned_get_max_open_zones(struct t=
hread_data *td, struct fio
>  {
>  	return -EIO;
>  }
> +static inline int blkzoned_get_max_active_zones(struct thread_data *td,
> +						struct fio_file *f,
> +						unsigned int *max_open_zones)
> +{
> +	return -EIO;
> +}
>  static inline int blkzoned_finish_zone(struct thread_data *td,
>  				       struct fio_file *f,
>  				       uint64_t offset, uint64_t length)
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
> index 722e0992..2c3ecf33 100644
> --- a/oslib/linux-blkzoned.c
> +++ b/oslib/linux-blkzoned.c
> @@ -186,6 +186,29 @@ int blkzoned_get_max_open_zones(struct thread_data *=
td, struct fio_file *f,
>  	return 0;
>  }
> =20
> +int blkzoned_get_max_active_zones(struct thread_data *td, struct fio_fil=
e *f,
> +				  unsigned int *max_active_zones)
> +{
> +	char *max_active_str;
> +
> +	if (f->filetype !=3D FIO_TYPE_BLOCK)
> +		return -EIO;
> +
> +	max_active_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/max_act=
ive_zones");
> +	if (!max_active_str) {
> +		*max_active_zones =3D 0;
> +		return 0;
> +	}
> +
> +	dprint(FD_ZBD, "%s: max active zones supported by device: %s\n",
> +	       f->file_name, max_active_str);
> +	*max_active_zones =3D atoll(max_active_str);
> +
> +	free(max_active_str);
> +
> +	return 0;
> +}
> +
>  static uint64_t zone_capacity(struct blk_zone_report *hdr,
>  			      struct blk_zone *blkz)
>  {
> diff --git a/zbd.c b/zbd.c
> index d4565215..a5cb34d2 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -471,6 +471,34 @@ static int zbd_get_max_open_zones(struct thread_data=
 *td, struct fio_file *f,
>  	return ret;
>  }
> =20
> +/**
> + * zbd_get_max_active_zones - Get the maximum number of active zones
> + * @td: FIO thread data
> + * @f: FIO file for which to get max active zones
> + *
> + * Returns max_active_zones limit value of the target file if it is avai=
lable.
> + * Otherwise return zero, which means no limit.
> + */
> +static unsigned int zbd_get_max_active_zones(struct thread_data *td,
> +					     struct fio_file *f)
> +{
> +	unsigned int max_active_zones;
> +	int ret;
> +
> +	if (td->io_ops && td->io_ops->get_max_active_zones)
> +		ret =3D td->io_ops->get_max_active_zones(td, f,
> +						       &max_active_zones);
> +	else
> +		ret =3D blkzoned_get_max_active_zones(td, f, &max_active_zones);
> +	if (ret < 0) {
> +		dprint(FD_ZBD, "%s: max_active_zones is not available\n",
> +		       f->file_name);
> +		return 0;
> +	}
> +
> +	return max_active_zones;
> +}
> +
>  /**
>   * __zbd_write_zone_get - Add a zone to the array of write zones.
>   * @td: fio thread data.
> @@ -927,6 +955,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)
>  	f->zbd_info->zone_size_log2 =3D is_power_of_2(zone_size) ?
>  		ilog2(zone_size) : 0;
>  	f->zbd_info->nr_zones =3D nr_zones;
> +	f->zbd_info->max_active_zones =3D zbd_get_max_active_zones(td, f);
> =20
>  	if (same_zone_cap)
>  		dprint(FD_ZBD, "Zone capacity =3D %"PRIu64" KB\n",
> diff --git a/zbd.h b/zbd.h
> index f0ac9876..a5cf59d1 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -52,6 +52,9 @@ struct fio_zone_info {
>   *      are simultaneously written. A zero value means unlimited zones o=
f
>   *      simultaneous writes and that write target zones will not be trac=
ked in
>   *      the write_zones array.
> + * @max_active_zones: device side limit on the number of sequential writ=
e zones
> + *	in open or closed conditions. A zero value means unlimited number of
> + *	zones in the conditions.
>   * @mutex: Protects the modifiable members in this structure (refcount a=
nd
>   *		num_open_zones).
>   * @zone_size: size of a single zone in bytes.
> @@ -75,6 +78,7 @@ struct fio_zone_info {
>  struct zoned_block_device_info {
>  	enum zbd_zoned_model	model;
>  	uint32_t		max_write_zones;
> +	uint32_t		max_active_zones;
>  	pthread_mutex_t		mutex;
>  	uint64_t		zone_size;
>  	uint64_t		wp_valid_data_bytes;
> --=20
> 2.40.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
