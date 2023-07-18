Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC6FEB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 15:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjGRPu3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjGRPu2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 11:50:28 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF9BB
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 08:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689695426; x=1721231426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7NfcXqjmNESwmGdH526xr4DREXx7aVQwlJgY4fSnOCk=;
  b=J1MmHnbl1ifGwJ6s/OGF3d1J3cbTb182TX17oiaJNzndfSac7K9ByQmG
   rGEL4NsDJADNLGpWmQmDJrphf48k8beHWj7BNSOFGwANS8fLYo1oSYNJZ
   RewrQIj3rqqtUmQjqeZfekfBEWxO9LChzjRZx/uve548bbpyTMP2WkuYV
   zAWKcY1OV1/bQ3Oi3z1clBo9VAw6cfmcxrZTkqzxI/6vwH3RPN0cwv7d8
   7vK2qCyjm/abDM0ODFzlB1Xbu3SPerGCXDbqHh7tnXEEJfMpcuY7urwG7
   W3k6LMg2si6mPWajSpTxhhLs4WWSxTJcV+zepLTKKx2TsCghHNcxhrfop
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="238192625"
Received: from mail-dm6nam04lp2042.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.42])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 23:45:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ljbhfl2rUKKASKtIfOVEoECXT7SoL1S/+7O0GRp9yWNlNGqoB9GiOoRYSgV5MhKb5XUOdyVnBBoyMl12Tk6QXhR3oU8NulGRfPriK/vu4pt+06Kgsb5HisW1tC0QeQfzvIyswY0y3EgjyMMlbth/Zu+9eRHy9gVwILmhxCbpWzhEiGl9TcZdTWDFpJu6g3MnXSVB2n8bXOORDPvhcNx8dulVN3enFtcFZUQTifH+/E6xdxjolW+5MVGKdi23kYGg/fqh/zj+JJ4KeD6tyJmy1JDsVkDhIP56zNTSzIG/1iYnJeap9zeVGMk9KkZuDChob1Bt0w57/jrerue9tDCbwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siV6wRNYoxg4yaV3TFRI1mPiS4nogdSXveXnpBcLBoo=;
 b=ZG4npxKP8jqiBvF6W2XcqAQOTdkv8ZSZQXE8O3dBKgFbf3nBcPbDGzsiJ8tQXLwj9tHhgiKWEOV6gbvof5WkvU4T89Mf3LQf5V6MaZdndZgT7JOnhDpOU4Tpg3s25N8ZCU/83wxHVGabTKo8h0ri4UqrrSL9CfFwPjmwR+UMUwfw4PqJIF/Dy3CcaAT8vPYehER0Bcb+KRhuqArCambVCXnC0ljN+z1lEWgD6iVJSvjRHBXjl739lW2brqQlSW/DXxGhTfaJEgLHRLy/MSyf6MHPiVV8L9hna2x8z3EBuFSi3zFtqdhcGJpBF1x4zR8HXvEMTfcXvCDBcVx6htijcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siV6wRNYoxg4yaV3TFRI1mPiS4nogdSXveXnpBcLBoo=;
 b=UKVO+YY/Vmgucfm4rRUFnjfLcvHlPzxgGHIA/bh8ledSTsMPL5dfRADd9GWgkejL9/Ed6c5SIKnzT8GtXrS+O1Ik9nbd8CLgeO1hIFK328htTpFr8JNxiWiiNdBfECDcQ859VDK4cX57SXN3VM/VSJcagaCfhvMUM5HlWkQAWFw=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7505.namprd04.prod.outlook.com (2603:10b6:303:a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 15:45:27 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 15:45:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/4] stats: Add hint information to per priority level
 stats
Thread-Topic: [PATCH 4/4] stats: Add hint information to per priority level
 stats
Thread-Index: AQHZr43vewC9fsQUT0eFUEUNPhbiRa+/vp6A
Date:   Tue, 18 Jul 2023 15:45:26 +0000
Message-ID: <ZLazkxGhtZkCDPZz@x1-carbon>
References: <20230705221302.430678-1-dlemoal@kernel.org>
 <20230705221302.430678-5-dlemoal@kernel.org>
In-Reply-To: <20230705221302.430678-5-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7505:EE_
x-ms-office365-filtering-correlation-id: 97903960-4ee4-463c-8331-08db87a601de
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +CTSrLsThTEjLu3E/Po7EO0V1EqZVCXWzSItQMJ0GjB20R+2eqEfEv4r+RGa080NMw5yasOF8OnxDL0ucDXgWXEtNNp+eMmc2Blyn2uXeRig97tW+d8mzZ4Z6AT7dPLFUj80kmdXZ27qvN+oQaHDcw9HQVj5qyIet/uIXi4gd0l8VHXPASiQ48BdaNJgvNlvE3aiw40vf+msuCmksUzvgV0pKXz4sdER9YNvZA8Ej60oPgsyaCF80Zh4QjF4GMOVE967hDnIrmucSyCtfn4l4l9qcsgspIvPCdswXR7GQmCpCoyk5ZCmP7UkFTUSTlanOc5vs97ZH3XHjWPDCAv8qdqbq12HfEudrtpxN+VLXDAgEjKZsYsipJfLbzBTvNNYRAYLUyrqEhHaLyrOWZhcc/LXSCgxBXHShoXJ8vyvxU/EAR3GDQVLOvTz/qssLCtaDE8fIRB6v24oftKw/1i2d/aapo9UyWR9jdckp3hPZW/TvtO1HcQd0wJJgmpcm9zXl4sF+9/gnfRDGHnmZfTYupxwohvz7GiWsyvM6X6ults8004H+930oodiOwOq71rIdb88fTDtj1cmbG47rMRXgOg+0L6zU111O5H/9Qtea6ovTg+EVo2Mm4DKlxt3bd81
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199021)(8676002)(82960400001)(41300700001)(86362001)(5660300002)(8936002)(38100700002)(6916009)(4326008)(316002)(83380400001)(9686003)(76116006)(122000001)(66476007)(66446008)(64756008)(66556008)(66946007)(91956017)(2906002)(38070700005)(33716001)(54906003)(478600001)(6486002)(6512007)(186003)(26005)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cESJYzq/eMaBf5VlHgBK939YzqNFEDAV3v6xfX7SilfbyGBKEUlrDus9tP12?=
 =?us-ascii?Q?V6qGe04KRKAvVCN81VD0nJe1pJHe/5n7bkxY75rywOZsk5pOQBjJxEwwpaYU?=
 =?us-ascii?Q?XJNhbDfBsP8KqjgvB5ADHVXzGKASl4jm5cmYi3nsbr9jGTdai3pn2P6yWvuR?=
 =?us-ascii?Q?5wVJPhtriEpbzh4wEainKGZtMKTIWvU9vXlBWpIsYtRuzBHHHImdxx85hixd?=
 =?us-ascii?Q?eSegw5LN0caJGgFYmt6pm0pVUuCoU6SMHkz5b7APKP4Yc/8iFcYD0JCvNWMX?=
 =?us-ascii?Q?ZD3ltSdtr9xzrFYg3OaCkFaVuQ+xtuNhM7riHmwyl10gKidLLx86LAwrz/26?=
 =?us-ascii?Q?mAKugXUPk0hD9if4RlH26TPDab3G9GTx502A1RDUtvu7+1xoQdPibtLPG5By?=
 =?us-ascii?Q?mD+EBltZZoIZuKsvh2OjbVBhfu5hF1OiGY6AUOPrVbJ8wGgjI6jnvDS0oRaF?=
 =?us-ascii?Q?0fR3bX3/jWdrQd4dqXxHFRADOrDaWcNPw4Mqh/FO/RAnqEFRXb90kGkK8J01?=
 =?us-ascii?Q?6y9GQfyHeOxxqdJhyfPHn2gI37XHmoqwLXtRqZcKdcJ8H9yemTcZWM8cANaC?=
 =?us-ascii?Q?KICcidBkg+e/LJP+MXJAm9BYRKpbEosjG1Fr3J/ce6N3vf+YeyWN06mPV6tE?=
 =?us-ascii?Q?pd0rWawLgS0/yURz4t9QvFoC7pmy0P/UaaNy5InbZh7QjmL46bnaza8tDMA1?=
 =?us-ascii?Q?/CFlsKRn1vK2cmUQDn2pK62WVrsXvK/yyIn2STTx9fg6plrgKGvsIzxLceHS?=
 =?us-ascii?Q?NjnC0zmfkwkl3qQZs750MeWBkcZOconqlCvkrb6BQfH7pRm/0AYntI2HvAOV?=
 =?us-ascii?Q?0eIAYx/uSfjtkm1ZkAEmMYFvT9Sgz0tEKMWMfex0dKlBasLXl9ZkfLUgAzGI?=
 =?us-ascii?Q?7/Ih0h4AAMmqmTPZSYU4Gjo23LhT0a0gdboJAxvlT1Ks73+QcA9FgKNwqz1u?=
 =?us-ascii?Q?/xutdY6ZR6leocp4jTLK4/i+Qf4Du+dTk1qzC5CCJGfz4y8qYJEsrfDLjDdm?=
 =?us-ascii?Q?3B9mkkjn4yPbKcNc+ewHmvdMyxcXdo4AsGq7s+u9MAmYG4hM9xa5NkPlUt6n?=
 =?us-ascii?Q?j8XBzFXAU9XAm/ZkDpcJAWyA/i48HbrzjAE6vj/RWFQaA5fuJqdUsEqdkUY6?=
 =?us-ascii?Q?JvEwk5lYz0FJq5oC/c6atl2CHEfVLI1ZUkVIaaEk2L46ufnrwZHncXtB2tNj?=
 =?us-ascii?Q?6ecY+0wrhILsc5RYgzdl9UT3y5HqBb89MizcTj9dwDduWTg7f2KnDXJIK2gl?=
 =?us-ascii?Q?FWBSrdaj0X+9xhHctyGrtuK1F1JgAIgB434ppzG2sHrqswr2ywJrgnJ2ZGdA?=
 =?us-ascii?Q?cNarKEQ14juTk8p2tV5rOkyQhAtY/In2Dbdqrx7sI5Kmt5zhuiPFvgmerKgo?=
 =?us-ascii?Q?rJVtXWCs7xKfSUWEAkyBHy2EMZNmECQTjg8wQ/E9BaOcM2bUpKosZZw4qthR?=
 =?us-ascii?Q?vUTfP33x1uR5YF0spFJSZFyvF4TX7HKcIcjKrsrzu0XbrQbM9MPOyv7/NDEF?=
 =?us-ascii?Q?5VSA44NFQF1PDZUMTfkhugJgWkV8K2WZ3GJBrd1cgcEVZqQdutQhXHThqGP2?=
 =?us-ascii?Q?G5HFKPb3kcMZEgPb3oXxYC3sY5/RWptT0W+ZyQ8/M+aUzgCfR2ng9JsaMkRO?=
 =?us-ascii?Q?jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D48001113F6434F8DB13265E3BDFA80@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XSj6c1dFkbpAe6YV+078X/Ija37uRk6TSwlRf+H55eWJPtZMxIARE64T7ejZYrG2jaa6QUjAOttvIUnpWQGPw+4cjrtbSvDkMtP30WHVwRyb/RtQLybLdALrgcHtNaQUBGMm4zHJn0U2ccwEOgpUa2px9YnMpRXLPHxXVfVIGrakgFqMNic9DCraNOXFZ7r/Jm0XrTA5yCs6JuB2kiWcOvaxrDf1LLstALHPYVo3VciaDXIDmG9IVT4Buots9opkwOhqmP5wKeBnDiFviQL/ZJzqk8B3KA9FTTp/feNBUJ7YTpX0ZTVqXzXFg82QK6tgwddtQpREwNpk7nYmt8qRczR9b7YKoP/f0byNVc40UOzJJ3D8cXRfqiznPTS1xTEoIQC5vorBsn8opmuQ3KahYYA5xqy27RdvFEqXWYotGnLxenhdTkZe3ei8kxllo00srhDdrOFz2yBOP2Vp0QzDnh1OwGjwuFzKF54tOlrXi00TWbFxLd5LNY19XWOdOO2knHtRW/3eNruub9LN9uBil55o57Xzdf1QbfPnkhbShURBTlDY6ltVPOb4K3Jn99jrP+mkKfMX2qNQOTlx6jJamOXwLKhmGpRYrGp49Bo2SIIYZLS4xmX5HYSJTb5SY3g8GS13alcQKLjuh/PMVA8tfxELsfKFHkZfGzidAe6qEal+pUdCx5rXsukAhElwvBCzRvaupjMC5TNB6PdSMQAWu+26EXiG3NNyzP0sCyFGyuUCSph/EdEgmyzyXf7wwPhAkTeCVZ3tvDa4lgQ8Ple+nlQvmPRx8Fj4jRQ0qRVXkmflaz+ghYSkdo1RW4CX6Zu9iEjYV8JT9LBvCo2NUXVQjk/10gbqXOsi2q/YlSjFm5w=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97903960-4ee4-463c-8331-08db87a601de
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 15:45:26.8705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FLLSbXAiQyPEQL6gU+qW3oTzYhm7NSWj3NrZ2IuTiaIxNJEe1EXgLVZbYImo2EYt4ilDzl+X8V0AwgX4zjPvDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7505
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jul 06, 2023 at 07:13:02AM +0900, Damien Le Moal wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
> Introduce the OS dependent ioprio_hint() macro to extract an IO
> priority hint from an ioprio value. This macro defaults to always
> returning 0 for OSes that do not support IO priority hints.
>=20
> The json and standard output stats are modified to display the hint
> value together with the priority class and level.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  os/os-linux.h |  4 ++++
>  os/os.h       |  3 +++
>  stat.c        | 10 +++++++---
>  3 files changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 6f241d09..b9c07891 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -150,6 +150,10 @@ static inline int ioprio_value(int ioprio_class, int=
 ioprio, int ioprio_hint)
>  		ioprio;
>  }
> =20
> +#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
> +#define ioprio_hint(ioprio)	(((ioprio) >> IOPRIO_HINT_SHIFT) & 0x3ff)
> +#define ioprio(ioprio)		((ioprio) & 7)

1)
ioprio_class() and ioprio() are already defined in os/os-linux.h,
so if you add these again, we will have duplicates in os/os-linux.h.
You probably only want to add ioprio_hint(), after the existing defines.


2)
Perhaps you can also change:
#define ioprio(ioprio)          ((ioprio) & 7)
to
#define ioprio(ioprio)          ((ioprio) & IOPRIO_MAX_PRIO)

and
#define ioprio_hint(ioprio)  (((ioprio) >> IOPRIO_HINT_SHIFT) & 0x3ff)
to
#define ioprio_hint(ioprio)  (((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_MAX_=
PRIO_HINT)

so we avoid magic numbers.


> +
>  static inline bool ioprio_value_is_class_rt(unsigned int priority)
>  {
>  	return (priority >> IOPRIO_CLASS_SHIFT) =3D=3D IOPRIO_CLASS_RT;
> diff --git a/os/os.h b/os/os.h
> index 2217d5f8..0f182324 100644
> --- a/os/os.h
> +++ b/os/os.h
> @@ -120,6 +120,9 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsign=
ed int cpu);
>  #define ioprio_value_is_class_rt(prio)	(false)
>  #define IOPRIO_MIN_PRIO_CLASS		0
>  #define IOPRIO_MAX_PRIO_CLASS		0
> +#define ioprio_hint(prio)		0

> +#define IOPRIO_MIN_PRIO_HINT		0
> +#define IOPRIO_MAX_PRIO_HINT		0

3)
The MIN_ and MAX_ define should probably go to patch 1/4,
which added the same for os/os-linux.h.


>  #endif
>  #ifndef FIO_HAVE_IOPRIO
>  #define ioprio_value(prioclass, prio, priohint)	(0)
> diff --git a/stat.c b/stat.c
> index 015b8e28..4f943602 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -597,10 +597,11 @@ static void show_ddir_status(struct group_run_stats=
 *rs, struct thread_stat *ts,
>  				continue;
> =20
>  			snprintf(buf, sizeof(buf),
> -				 "%s prio %u/%u",
> +				 "%s prio %u/%u/%u",
>  				 clat_type,
>  				 ioprio_class(ts->clat_prio[ddir][i].ioprio),
> -				 ioprio(ts->clat_prio[ddir][i].ioprio));
> +				 ioprio(ts->clat_prio[ddir][i].ioprio),
> +				 ioprio_hint(ts->clat_prio[ddir][i].ioprio));
>  			display_lat(buf, min, max, mean, dev, out);
>  		}
>  	}
> @@ -640,10 +641,11 @@ static void show_ddir_status(struct group_run_stats=
 *rs, struct thread_stat *ts,
>  					continue;
> =20
>  				snprintf(prio_name, sizeof(prio_name),
> -					 "%s prio %u/%u (%.2f%% of IOs)",
> +					 "%s prio %u/%u/%u (%.2f%% of IOs)",
>  					 clat_type,
>  					 ioprio_class(ts->clat_prio[ddir][i].ioprio),
>  					 ioprio(ts->clat_prio[ddir][i].ioprio),
> +					 ioprio_hint(ts->clat_prio[ddir][i].ioprio),
>  					 100. * (double) prio_samples / (double) samples);
>  				show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
>  						prio_samples, ts->percentile_list,
> @@ -1522,6 +1524,8 @@ static void add_ddir_status_json(struct thread_stat=
 *ts,
>  				ioprio_class(ts->clat_prio[ddir][i].ioprio));
>  			json_object_add_value_int(obj, "prio",
>  				ioprio(ts->clat_prio[ddir][i].ioprio));
> +			json_object_add_value_int(obj, "priohint",
> +				ioprio_hint(ts->clat_prio[ddir][i].ioprio));
> =20
>  			tmp_object =3D add_ddir_lat_json(ts,
>  					ts->clat_percentiles | ts->lat_percentiles,
> --=20
> 2.41.0
>=20

With the three nits fixed:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
