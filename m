Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C94EC6FA99
	for <fio@archiver.kernel.org>; Fri, 10 Mar 2023 13:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCJNU7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Mar 2023 08:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCJNU5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Mar 2023 08:20:57 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DCAED6AD
        for <fio@vger.kernel.org>; Fri, 10 Mar 2023 05:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678454450; x=1709990450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Sk5uaRGbbk3wATxE2bfUQEV17lrGLf5q7wfyB55pBVg=;
  b=cE73wOgSfiFoeIMAH156DVHjBeFRr+alKE095MpOfbo/pA3KHdWcxSXm
   0sHRDnttQxYC8coEa2CfPlakXQ8PS2x8tFkr/gy8IDcUpqutzkBhrZZ7P
   FOs1puk9x4+5Kov2zg9idk+pVpsKwuPKfIZJhqukEbPx/3OIiGIOeN4Wp
   2RDCeDLDPJVO9HVN1T2+yQaeARO/sJ464TfyqTun+j25h+Q54v0dm/t9L
   YB457bmt6DF2xsU3YUWn/sxjtYlyr5TQt4//NiRqZHrQ6RvqTIz17paoG
   ip/F01QIYl33uWiwA6ImBce9rYFmLvOTUlDGmSNbu5qRV6QkUI5JazEYW
   w==;
X-IronPort-AV: E=Sophos;i="5.98,249,1673884800"; 
   d="scan'208";a="225103639"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 21:20:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcUor2EyrDY+ImGYfGsc75V65IaDB2saPohrf0yNbaFpbEHiw63M99n7wzuYAESMHz2JKfzM69jlpim9/arM7KPBQSSYMKLuRm9qt4njCEw0+D28z1cxUpvb+sMpz4tJjlL8KDfAKwVcUOW/r2DUpgwLyTLeSmxioGQavh0zJHN/f/DBS5a7JSq6pS2PbOYJXEjgrtSAhTTONB7rPofY/7uZGPRPE2+3ZSVzz6DYfyAJZViaaHczPwo5Ug8FoaRNJPTQm8l4IXY2nV23TtXIN7KHG7TD5101l47mdYuduYSHUEIU162SwxCucqtgd3t+amJTwunW4eT4BfetFawopQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/RR8syBZBaXXDTv6G404p8RseKQEO6MqaMFFBWiLy0=;
 b=iyYEbjCuWC3IBqwmEeCTdqBDIxdqthfZ7J1CtE5M1T5pU88NZ4WXWTpgiU8TTOYoRMrjhbKwU/h/8qtOhVCtHKiSGcHulZw/MoqbXt1f1f9Mg4Q5TSZviKglc0HF9ovXbMra3+o2DmnnyrAamJZ+xCdm0UiLwjqJaQ/LVlbrmBglZgErm+1sz0EmOFSFzqEzRCM0FG/8ZTmDRV9GSSz/9qzvzlx1z6iYG77WOa+PS3RujL3W+0f+os+rnhlx9Wa02UzXyn4X/uf9l15ltTr34+X6Uw3NT9BP/anC/4ETL6X4g3ah4Gz7HjAy18yrhuiAUSM+Tt/InsdgerkyNPujIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/RR8syBZBaXXDTv6G404p8RseKQEO6MqaMFFBWiLy0=;
 b=r/2m8caimdCUYcFvggHuoqeV/Dm/amZuYwxQEA3+Dp9JEHi9z/ca0xjdB92OJI7Y4D8gDJaoSzDGFY3rTLEmsU31cgnVr5Zn1DqVFEON0xKJ24BGxNtw7+8al7ZQe3yarDHL7w7jr5DYtvL/FKcKXhfxwKITvsjlxSIzCsmGsIk=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SN6PR04MB4158.namprd04.prod.outlook.com (2603:10b6:805:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Fri, 10 Mar
 2023 13:20:41 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 13:20:41 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] stat: Fix ioprio print
Thread-Topic: [PATCH] stat: Fix ioprio print
Thread-Index: AQHZUu+obHHHSIunxUOS8eAOSYnioK70AFgA
Date:   Fri, 10 Mar 2023 13:20:41 +0000
Message-ID: <ZAsuqKYx3BHz5pcW@x1-carbon>
References: <20230310012839.9532-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20230310012839.9532-1-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SN6PR04MB4158:EE_
x-ms-office365-filtering-correlation-id: a53b8060-c315-46be-0278-08db216a3f37
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ML1ZUi1QeRrlkGd+TyjSIx74D3Ptexn3VH9NNoHxZwp8yO53JMxibsblQ7AD8ySGNxAaR8yJ2DhTCoGCYAQWmfQlnA9snERrSZJdmuxMXzyK3G2Bm6+zZhR6H96nOTcNd/oDO/n0/L6mCEz0vEV5yZfnSpxXTJPmPoI5+fftxfVYfM7+h2kTfwKzpFte8Gye6a5lu3kkoDvdyRsSnaJ2ExOQCFuXxfyjp9o/Uh//cydPJMt6ZjloQG1N/XC9PbiGhRSoeYSYAk5pRzao1WQm2S/EulXHPEqnS+kWafOvAvhhe/wNDRGMSGXkAHrSGGe6xZdULG3FfNiCCWI333M3Pjr2jsdxApX6OUZ6ZqsGSnS8usCNjHVzvis/vfSsQVye4mTu3KpWtCrEUprjamTua2Vzyt0tE+1m05Hol1MEQtx5v5tVomM5CfxhXDacnKbVFSbzxw0VCruMPyaM8zyQhDEfxHndoyY02V//KGrZFShuzgnKgju2K6UORfaeFwBQLGSJORbWnYBFOEGbSedCPXeo53T+dGds0fsk0i3Q/qxUTjQjLnrh4u3rAjAi10JJSjMrO6E6ohXVqZDR8U8gxzx588NVFGB99IAU4/OmDuPPVcR3gTEIsa8zhvnPW4FPTDDjPxvFtlcqxOCHcXkLi0axiYFQRQ208ElsREV0Xd304pvKYH9Ds+cr8R3ui+Ckq5iVRf/u49t0CRcv283ZGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199018)(478600001)(6506007)(83380400001)(6862004)(9686003)(38070700005)(186003)(41300700001)(6486002)(5660300002)(6512007)(66946007)(91956017)(2906002)(64756008)(66476007)(86362001)(8676002)(76116006)(66446008)(4326008)(82960400001)(8936002)(66556008)(26005)(316002)(54906003)(38100700002)(122000001)(71200400001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XgyQ2c0sHOFDh/pE2Lf7Dd49IxBvdagwQ+CCmD4Tw2bCEHEHoMIpvhHY4D23?=
 =?us-ascii?Q?35uOiiNVNuvifdFqeYsnraq8wxW8nRpzPG7KACc+Si7GHaKVhLxSG4MxwXCz?=
 =?us-ascii?Q?O71/YcnE78OCOVIWANIhObPVt3cWNYK3fK8O20sxh89+6dSsS5imSI7R6NbU?=
 =?us-ascii?Q?X083pDmb4UEfUHvBNg233AtPGXz0nHByt5JrfPVLI8H2jx0AeW9js8D0PX+8?=
 =?us-ascii?Q?56GgsIduz8LKVhV71pNoVWPlXRFYfhTY1xn4/oYPqw3IBOTf56ZR1USHwDjA?=
 =?us-ascii?Q?YMmW6r6LNoyqNBr4N88ny0isS7AG5KRDaHAsk+l57xFoFsezdx8vvSbtdcuD?=
 =?us-ascii?Q?zLeJCukbCNOUJDiD04/qEXgy+IqlY+/e8Uvm+Vk7h6oZE34x+2WsG2Vg75U2?=
 =?us-ascii?Q?XZdL3mBBRfUZJxcTx57nfC6MKIpo0mnF77KfxVMnUX95XzbImmXiBwhvWJlU?=
 =?us-ascii?Q?hGwgptw0JFevH9hcgZwmBAA3G9cqZqeek16ci2Af3fWc+FZ3wGzcnYTKYHcd?=
 =?us-ascii?Q?UQyv3Q6sJzL09tMQu+oExsJR1E5F67jPCgmJ7bCEXDs+d594rz2xXwa2YGcJ?=
 =?us-ascii?Q?eq5XfTWGgofASxI51wT2BOb1dP9EOuZt8bWUOaS8sM/CfJ9LSZBL6tOQ+amw?=
 =?us-ascii?Q?rWBi5ml4OOdlk5rglvR1c9AbSbj/Lsh6D1rG/ZeQ11/ww07C7Pplazl2UjVl?=
 =?us-ascii?Q?2VhF+MqvN0zefRPo400eC4WjqNGwuGmSDSMnqm0zut2TZ5MJMzkOmxfquW9x?=
 =?us-ascii?Q?VAItKNBHZD/J3UB26Jve7PTu4Wg24w8vxz8JOEgSDKI6q8X3a9pCyJosVPTP?=
 =?us-ascii?Q?W9ykwbcIUvbdpYNS0xg+fO5smcCumtLTEC9e6OEH3428Hxnd33Eig3e1W7lo?=
 =?us-ascii?Q?gjM7ryUbswwlCXpDiutFXwv3k/Ewh/KggTIOSyNwDFB8ZL1a3+kb/BihQ8lu?=
 =?us-ascii?Q?JOTXgbf2ts6JCG9LrUtN/MPmZLyrLLpTx4/RJb3b/aizdCAzbFzX+JfAdPTl?=
 =?us-ascii?Q?eBbQ9qRj/wTjA94bvotB7ro8CIA8cNxDIJNZvN3n4hdapBoSBx6k1HKX4ZJV?=
 =?us-ascii?Q?k2LWIA86wa1xtUtp33oynyPSpZSV3WJNTMEVsp9KDSkFCMLBNfDD0Hl1P+PU?=
 =?us-ascii?Q?QzOC9i8LXLMZcvn39vAplZ6ItiQ3X3vjy08WCQnchoJ2rSyBRml5y3P5mD0N?=
 =?us-ascii?Q?QrKugai+GLag22g2JckY2i/9AklMbd/14wkflY/Rqv1kKf3a8FymPA83gO0H?=
 =?us-ascii?Q?JOeHNFMkWCrfRfzdrIwUyvorOXqkgM/dErH9vt9z/B+pNLWnaVs2/Mrx5TJS?=
 =?us-ascii?Q?sWGXJ47pQHZ5Zw/SSgOu8mTEGdvibAJ+XACYuo+S8Ye3XJ7y5N+fJF3cVJig?=
 =?us-ascii?Q?UzQ4h4p3Q3HW3prcb1ELcZICaUanHgk4oVCbW18eflUAz18WUjFxmO7p5Xiv?=
 =?us-ascii?Q?s3sOwVNDc7kC9d5IYgkuIAoOaXeXEQ2Oewo1A6bN8sRxKTXhu4nujs4Uq21G?=
 =?us-ascii?Q?hqERjVWefE+PEN2v+RbdP6HiGh6QrBN0pL8h4Uo6W2E3hdILr/FjDLVFE9lE?=
 =?us-ascii?Q?kOn+3TquK8IQT7G9snVI3f92gfa3cFA/PBD3UhNVczJpqSC8lfCZH0JOuubm?=
 =?us-ascii?Q?FQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <50E3414AC32B6D4583429224930FD88A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 29LBSFsqsGOYod2GAkn/H8b7yHcrrB6avWBsV5F5jlkjnnkm2Ow1jQpA/MjBX50W5t60Q4aPtHZ16QRNs0QAF9ieUSQu6RGvuLyMhSo1dKtNmv4YxqtrBJMJSJbszQtgyEGFNAlOsPS/Om0S5dSAr0Z/yX1crn3yOJhOEWQijRC6Pfm2IFd11fV6f6hrHnS5AN5XLR7mKOzn4rcnlRVpOIn1JaapI8GDtrfcWAVAU0qQbl55afArlSLuQy1msM/ix1s4FPPsN1TiJRugsGiMioAL+6oeyI6Htn0cMHDkYnLoQiV7bfKvkif4sXFV8wh3KAEfYwwn0UJCO9X9v26CKcTX0VaFua/qu3eqNKtHgfMoheoOacmEnVfh3JDK791sacRU4D0WHBxhwNhF/1gGaDvGXAUPC0wBc58JEwA6XC7n8VXfvJ+Z65XwZ4bKERg9zsElNwbM9TRdZI+P9qhox0z5u0d1Dqrx9aQJxJXQmzh7h53Lqc9OcIx/ixD+xH8gf0qmIUNyAV9Vv4xKRNbmDy3ozeoOamZ3wqMM48pnZVv058ozFaXWg0BWKfKxXmmunTwX8E/0fRbCHFWAIlTz+jvQPn3KIAawORDy6G67fiHHWAafL8xXKxwfFDjPBtWormfT6w2moRzJGPd13yYVdImED3Y7xR3/I8tWfG2zhiBSbMkpbRyugGCcDsefoJwuhhD5amOTr/jhw/bnbL/dT3gyUweAByuLGusezqMC5tGOfLs9vv+Dc7YgzUCzuL0x7m5F2cGfoinD9OU7Hrg4Cq0OVbwUrOXG/0LaPvo/2BsLa9/M8UzsFgyGOH17rHAOiOOeuroD9hEke+wba4BDhw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a53b8060-c315-46be-0278-08db216a3f37
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 13:20:41.3408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: njW8q8GDRhSy/VSo/adQexf+VKg7fZuVkytCQM8zwkDS/Y0bVXmxOtKYKJruiQNW844oZKwOR1cz4cbt5DAwoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4158
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Mar 10, 2023 at 10:28:39AM +0900, Damien Le Moal wrote:
> When using per-priority statistics for workloads using multiple
> different priority values, the statistics output displays the priority
> class and value (level) for each set of statistics. However, this is
> done using linux priority values coding, that is, assuming that the
> priority level is at most 7 (lower 3-bits). However, this is not always
> the case for all OSes. E.g. dragonfly allows IO priorities up to a
> value of 10.
>=20
> Introduce the OS dependent ioprio_class() and ioprio() macros to extract
> the fields from an ioprio value according to the OS capabilities. A
> generic definition (always returning 0) for these macros in os/os.h is
> added and used for all OSes that do not define these macros.
>=20
> The functions show_ddir_status() and add_ddir_status_json() are modified
> to use these new macros to fix per priority statistics output. The
> modification includes changes to the loops over the clat_prio array to
> reduce indentation levels, making the code a little cleaner.
>=20
> Fixes: 692dec0cfb4b ("stat: report clat stats on a per priority granulari=
ty")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  os/os-dragonfly.h |  2 ++
>  os/os-linux.h     |  3 ++
>  os/os.h           |  2 ++
>  stat.c            | 85 +++++++++++++++++++++++++----------------------
>  4 files changed, 52 insertions(+), 40 deletions(-)
>=20
> diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
> index 5b37a37e19fd..bde39101b536 100644
> --- a/os/os-dragonfly.h
> +++ b/os/os-dragonfly.h
> @@ -175,6 +175,8 @@ static inline int fio_getaffinity(int pid, os_cpu_mas=
k_t *mask)
>  #define ioprio_set(which, who, ioprio_class, ioprio)	\
>  	ioprio_set(which, who, ioprio)
> =20
> +#define ioprio(ioprio)		(ioprio)
> +
>  static inline int blockdev_size(struct fio_file *f, unsigned long long *=
bytes)
>  {
>  	struct partinfo pi;
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 7a78b42d4d10..2f9f7e796dac 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -153,6 +153,9 @@ static inline int ioprio_set(int which, int who, int =
ioprio_class, int ioprio)
>  		       ioprio_value(ioprio_class, ioprio));
>  }
> =20
> +#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
> +#define ioprio(ioprio)		((ioprio) & 7)
> +
>  #ifndef CONFIG_HAVE_GETTID
>  static inline int gettid(void)
>  {
> diff --git a/os/os.h b/os/os.h
> index ebaf8af5e2f3..036fc233fe2e 100644
> --- a/os/os.h
> +++ b/os/os.h
> @@ -116,12 +116,14 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsi=
gned int cpu);
>  #endif
> =20
>  #ifndef FIO_HAVE_IOPRIO_CLASS
> +#define ioprio_class(prio)		0
>  #define ioprio_value_is_class_rt(prio)	(false)
>  #define IOPRIO_MIN_PRIO_CLASS		0
>  #define IOPRIO_MAX_PRIO_CLASS		0
>  #endif
>  #ifndef FIO_HAVE_IOPRIO
>  #define ioprio_value(prioclass, prio)	(0)
> +#define ioprio(ioprio)			0
>  #define ioprio_set(which, who, prioclass, prio)	(0)
>  #define IOPRIO_MIN_PRIO			0
>  #define IOPRIO_MAX_PRIO			0
> diff --git a/stat.c b/stat.c
> index b963973a5824..b60d0a75eec0 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -590,17 +590,18 @@ static void show_ddir_status(struct group_run_stats=
 *rs, struct thread_stat *ts,
>  	/* Only print per prio stats if there are >=3D 2 prios with samples */
>  	if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
>  		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
> -			if (calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
> -				     &max, &mean, &dev)) {
> -				char buf[64];
> +			char buf[64];
> =20
> -				snprintf(buf, sizeof(buf),
> -					 "%s prio %u/%u",
> -					 clat_type,
> -					 ts->clat_prio[ddir][i].ioprio >> 13,
> -					 ts->clat_prio[ddir][i].ioprio & 7);
> -				display_lat(buf, min, max, mean, dev, out);
> -			}
> +			if (!calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
> +				      &max, &mean, &dev))
> +				continue;
> +
> +			snprintf(buf, sizeof(buf),
> +				 "%s prio %u/%u",
> +				 clat_type,
> +				 ioprio_class(ts->clat_prio[ddir][i].ioprio),
> +				 ioprio(ts->clat_prio[ddir][i].ioprio));
> +			display_lat(buf, min, max, mean, dev, out);
>  		}
>  	}
> =20
> @@ -632,20 +633,22 @@ static void show_ddir_status(struct group_run_stats=
 *rs, struct thread_stat *ts,
>  		/* Only print per prio stats if there are >=3D 2 prios with samples */
>  		if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
>  			for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
> -				uint64_t prio_samples =3D ts->clat_prio[ddir][i].clat_stat.samples;
> -
> -				if (prio_samples > 0) {
> -					snprintf(prio_name, sizeof(prio_name),
> -						 "%s prio %u/%u (%.2f%% of IOs)",
> -						 clat_type,
> -						 ts->clat_prio[ddir][i].ioprio >> 13,
> -						 ts->clat_prio[ddir][i].ioprio & 7,
> -						 100. * (double) prio_samples / (double) samples);
> -					show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
> -							      prio_samples, ts->percentile_list,
> -							      ts->percentile_precision,
> -							      prio_name, out);
> -				}
> +				uint64_t prio_samples =3D
> +					ts->clat_prio[ddir][i].clat_stat.samples;
> +
> +				if (!prio_samples)
> +					continue;
> +
> +				snprintf(prio_name, sizeof(prio_name),
> +					 "%s prio %u/%u (%.2f%% of IOs)",
> +					 clat_type,
> +					 ioprio_class(ts->clat_prio[ddir][i].ioprio),
> +					 ioprio(ts->clat_prio[ddir][i].ioprio),
> +					 100. * (double) prio_samples / (double) samples);
> +				show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
> +						prio_samples, ts->percentile_list,
> +						ts->percentile_precision,
> +						prio_name, out);
>  			}
>  		}
>  	}
> @@ -1508,22 +1511,24 @@ static void add_ddir_status_json(struct thread_st=
at *ts,
>  		json_object_add_value_array(dir_object, "prios", array);
> =20
>  		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
> -			if (ts->clat_prio[ddir][i].clat_stat.samples > 0) {
> -				struct json_object *obj =3D json_create_object();
> -				unsigned long long class, level;
> -
> -				class =3D ts->clat_prio[ddir][i].ioprio >> 13;
> -				json_object_add_value_int(obj, "prioclass", class);
> -				level =3D ts->clat_prio[ddir][i].ioprio & 7;
> -				json_object_add_value_int(obj, "prio", level);
> -
> -				tmp_object =3D add_ddir_lat_json(ts,
> -							       ts->clat_percentiles | ts->lat_percentiles,
> -							       &ts->clat_prio[ddir][i].clat_stat,
> -							       ts->clat_prio[ddir][i].io_u_plat);
> -				json_object_add_value_object(obj, obj_name, tmp_object);
> -				json_array_add_value_object(array, obj);
> -			}
> +			struct json_object *obj;
> +
> +			if (!ts->clat_prio[ddir][i].clat_stat.samples)
> +				continue;
> +
> +			obj =3D json_create_object();
> +
> +			json_object_add_value_int(obj, "prioclass",
> +				ioprio_class(ts->clat_prio[ddir][i].ioprio));
> +			json_object_add_value_int(obj, "prio",
> +				ioprio(ts->clat_prio[ddir][i].ioprio));
> +
> +			tmp_object =3D add_ddir_lat_json(ts,
> +					ts->clat_percentiles | ts->lat_percentiles,
> +					&ts->clat_prio[ddir][i].clat_stat,
> +					ts->clat_prio[ddir][i].io_u_plat);
> +			json_object_add_value_object(obj, obj_name, tmp_object);
> +			json_array_add_value_object(array, obj);
>  		}
>  	}
> =20
> --=20
> 2.39.2
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
