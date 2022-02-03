Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1014C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353761AbiBCT1H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:27:07 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34890 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353757AbiBCT1H (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:27:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916426; x=1675452426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9bzFTArkBNv/nNKhfUZ58iEqWZBofPgU6/IBjEUgqsU=;
  b=EYfSLTbRCXL/QrnKkUdKcBibBMh3mu8t/TTt2anZNL3LSYkpgGEL34su
   YZhWXfmNKXIt1hdfcUdrsQ/Ir5kPzA/hV3El2kDcOMIQ0XUHFohedwHNg
   NUXwCkHlMdZbFVAVHOVRGaN749zdgqKpZdV89wB35LEBao3dHKycRqouW
   p3xrw0Miw32nHe6kZndhcHVuKtCEmrPHIyYg0zC7iYRZ6/CYgT4qSOlX8
   pkwEJ84Xf0LHDCsVSv4HZTA4aKI/QBaoMRza2mYNb8Dre3AIM0t7VkGQD
   oVzj/FDeOHzuKMvC8Ce6tpXZxGAfNDZ/1mN0Rz4sA7gYr/tWhqIPLzOe6
   w==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107439"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:27:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfUXJTZYi0/FW6360RqUjypqWqoCvbNDANuF+X8ymlOLgoEwf/+qh3PNyO1C74fBZbCdYRFH9SWzHa92k6UUyiCIFzv3Zx3PkVyfZrX/F0rFMHRpfPg5fqNliHFHtKaZZ1lnbKiGy9cSHXpZxMQd9bMwBNGCW+N7ypgbOApQnU6q/HoOZORCVhDoGyO+hMHc4LO3gl026aq53jDcQz/nb1DbFp6TBJhJYwmu8w8cj6FUMydRN5QfFSQnfK3kpAb/QTVzHvMEGyg9plAzuda1C0FaotmpaODAWzim0juFG+o1hQZDrN2WZChpwlp6KW41w9t+AFi071dPv7pEQ/XANg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joGr9RZRYcjFgs3o+dwWvysTs236x7QS8WdH6jgd+Xg=;
 b=Z46euZC8NfDMVvSQIHT/dc8itatQzeV3VuhipLVf8rVHAIpcKsjzpn4pD0R1+EjLNnK3pB+sQsluZbQFaIju7JYmG6OZoNSdWebaXZxnvIk6H0+yuU8RMlWJq7+LJypQU68dQ/wgxdDX7BQUVj1SDylV6vJnKRD3e9SbJC7hbNnvM+Bfn8PHwLg8lD7Q8gGjuIw/NgRJxj+BNEYcuhcR/5t/iggXeMD9cKJ59Z7YjQmNdZ2xiEEB2NXpCrLCE1aoTPCqGVa8Ryy5+P3KKAG/GTx/xRRDP/lrPX4UQcsSTKrvZECJ0XAFP1SjaXfURUD/rrfGRLeCsEl4Y6d/+290WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joGr9RZRYcjFgs3o+dwWvysTs236x7QS8WdH6jgd+Xg=;
 b=My8f3vnVLsLG9oz9g+CbMQjPwJKuj1MvyrTJ9Kck4yWCj4hFaizdraxmvNP+JcSqyHw/p+mSq3zAFzjqWMxaPw+Ai2Z+x4pxhVNgXRDmQlSoA4C+0fKyrvD8DCjWeDUJ4eKzu59Q4sHdHtFF44FgKdY7aXR9CIpXYzc8VkPZwfU=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:27:04 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:27:04 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: [PATCH 06/17] options: add a parsing function for an additional
 cmdprio_bssplit format
Thread-Topic: [PATCH 06/17] options: add a parsing function for an additional
 cmdprio_bssplit format
Thread-Index: AQHYFudV6Hc1sj36sUmglt3EEACJmKyBBjkAgAE0A4A=
Date:   Thu, 3 Feb 2022 19:27:03 +0000
Message-ID: <Yfwsh88/vdcpYd2p@x1-carbon>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-7-Niklas.Cassel@wdc.com>
 <eb127b06-7800-aa0a-8a86-869c28a14a37@opensource.wdc.com>
In-Reply-To: <eb127b06-7800-aa0a-8a86-869c28a14a37@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 931cd0c1-e050-4ca9-709c-08d9e74b28a8
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4632118B4C1EE5FDDAC588D1F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yoDOm6f6O2wCLlOX3LGTEMV3pSepmgo61aQQw3Maj/iAkI3Kx9In5SeFG/Gr9BjBcxiNc/TYoXzznLSeTut5620E2xFqQcVTRUPhJPnhn8v0vGEEZRBwmnzwdqFnGoLxjlapUmuaG71+/bAKU792CEG1iYh7xM7e/kB+XHc3SZikoNZ8kQzr26ybbAcH8P5pkZAV7f+R0n4uAL/n7FSCxqKaQ2Da6bhj4nQiXcU3Tyuwi6pe/H8zy456jZu2j9mWZFZKh2S9nXz7FqWHPasKYfqXVBbKgZYnLh+bxZv6UgT6KYYGouPEpmM0CBwEB8mXVTASpNm4xqaWH8/mqZ5uU57Uud+xNt6kqV5TQTs4rP6ucHvSLMfHYSv1HHjQa3CpKwrDIg+tiZZEW82SJNEoDiXr5/necUrLT4XQMEU23L5forAiFbFWbeB7hbDQaeGAmAj1Y9BUeoXGcNqqyN3QbBPAmkK+PmqbC0HpVGaWxhczZxwp07mKZMs48sn3u+kqbZLPBaq36hGfHgXdKf5FIOA3/33h0uifAF+8JIQKZp9tus4ZPtTRDKE/5KM8X89Jq532EF2QPZS0DK4sDaMoa0uDNfi+GWnsV4WvSjOZJd/25Qm+wPX/jDserJBurh23pefXPgzwuVRDUDSYob2b+fwhzemxFoC8+GSANozIuYYKJBBTw8vkCL6bGsn+4tZTDFK33xKG+Pyspvg8H08TlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(54906003)(2906002)(83380400001)(76116006)(91956017)(71200400001)(6862004)(6506007)(66556008)(186003)(9686003)(508600001)(4326008)(86362001)(66446008)(5660300002)(8936002)(6486002)(53546011)(66476007)(38100700002)(38070700005)(66946007)(122000001)(33716001)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7G445Z4XWIaQLmoO0bZqz0PAl34twJsEbVNVZ4NO1PdesNYGKGUfUAbejXUO?=
 =?us-ascii?Q?e+EFtipLYCvX8hTXQkLgQ4l5kAcDwNqJWh5xYvWe7KN+LRk9LYktfhfwqd2/?=
 =?us-ascii?Q?y8d/j5qPtjvKVSLHk8AgG4xIUkLyhVVkGs2LutD04DDwOpQrx/vzX8q40T7Z?=
 =?us-ascii?Q?7ytPNdaDI989AiyR241AF76KfB5Viwwf1cvDV+C2qH5zTlEzHhoMmFhJa2eO?=
 =?us-ascii?Q?Ox03SZIoXLG6x0LwMDbsrXK6w6X4PXuoEryYxhgAbNDOox+h1NgKEyhLutky?=
 =?us-ascii?Q?A4MlI1TqVich3fEpTsQ+jjU5benGGUSKBplhSIBrChR75wLTthj8pKrTQFyA?=
 =?us-ascii?Q?TB10kKJm/GyiWwHYfz9DPLzHq7sNEkYQgK06rctmNJ2w6uw/AMpyVeXEyWmb?=
 =?us-ascii?Q?Vn31llBUujh28+TzbYCpvgamT5JCVUVC8utCRHBbQIC+LB3SWBTN0vEdbJc/?=
 =?us-ascii?Q?ajbaAftMfitgT8YYyDFcogvnmt8qi+XoK0mK2+6+KfgZS4ZfRU+YvHgzVdQI?=
 =?us-ascii?Q?El76LEioGWQ4WBT2zFEoBMItJUIhTW1k0Vlkpgp6WN2CjqerGLwM4QEsPQXn?=
 =?us-ascii?Q?cB2DdrUjALVThJeNL/XUKOiCJ8i4fNvW8sDfYiJ84ss3WR5tGA2qyl4ZZAty?=
 =?us-ascii?Q?J/7lfc8anIB64n1mZ2/CdpuNRJZCBreMB08ydRVXmurGWeS+1xEKo5F4FOWx?=
 =?us-ascii?Q?0tCBFgBCkPouxD834ck5Zh18BHPP2u6r47LRccP8QGB7btHl1dyV6vt16le+?=
 =?us-ascii?Q?dpYuywIz44MCW78etdi/Rc2gcuedbl7fKO8yyCXhcBSykKbdWACTZQlwDa7c?=
 =?us-ascii?Q?6Cr5hF98ZtgnDcuTmFZJHobLAXQOLcJYH1vSgsp++CWFeAwzc34OjB818jDJ?=
 =?us-ascii?Q?dEZ5nvG9coATNlMSokSTkbVaHls1kxR0vx4TJ+W/G7QxHsnydb6XnWYp5OU0?=
 =?us-ascii?Q?Gnj5xrvzLdBKXiyTQA9SoezKV/qrQfPaYm4R6PIoXHBezGKR13PWr6N3Aot3?=
 =?us-ascii?Q?JS/dBP/bH3Yi1SOsGQkDm1aACCPg5Wet04Pwlc998Ly9g6fneRBFa/GBY6bC?=
 =?us-ascii?Q?CKpPvDdexfLjb/GUmI7S0Flhwnp4qbTBpqsKDskeyiWrYTlXiGYZdz3KRIDy?=
 =?us-ascii?Q?ITJDOyiELsHUlgT6rjcb5wcmNTS9U7oDF3/ZAI0tbnnDPcc4dFFzoRBNf4eK?=
 =?us-ascii?Q?MkXiWWlMwzCKYqJGNuy15qOOVraSh+FhtqgfJDSfwlWaX1KuD4whBYuqHJqB?=
 =?us-ascii?Q?dYtBIFTtL3EfexaW5hYm2lSc4OH1D6T5EXkUFzSt3R9s0IGKvyNnWheDoLDh?=
 =?us-ascii?Q?KTgHaA4Bj9w4SohtFrRZb9/sFsydRN8tXSNoh3Ma5ZRIK4glnR1ukF7XHomj?=
 =?us-ascii?Q?1wgRcL4FYJRrrjwj2Che84JvyslXTQVyamDT5ssvC15IJS7ansnb2laMXvXV?=
 =?us-ascii?Q?6aGbJuC7bnuzfPhXvESm4kb0maVVFUb9UwXzpu+RxLVvXU7wq6F4+awzZuC2?=
 =?us-ascii?Q?YR150dOx+pmeVpR1arbx0FhS5F9FVZ2dbvCedX5VXVO11EqUgEdwKP76cIb1?=
 =?us-ascii?Q?YT2CZtx+Ic28/FCvzWI+EplyN3Izt7zV+T78n/RNd8aic44zx+jBR1vqmZKg?=
 =?us-ascii?Q?yWsUtTcK0bp/AlLNFzfk7eY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D42AF6B6C856848AA74A68E2B67E902@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931cd0c1-e050-4ca9-709c-08d9e74b28a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:27:03.8764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9rO6Ip9yiYPXi+xQHgvFZ2OSgk3DadAdbuqf/y1aeWXzytTr/xRZCYFUS+L5pGsBNZIDrUwzm+755lhfIfovg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 03, 2022 at 10:04:38AM +0900, Damien Le Moal wrote:
> On 2/1/22 06:13, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > The cmdprio_bssplit ioengine option for io_uring/libaio is currently pa=
rsed
> > using split_parse_ddir(). While this function works fine for parsing th=
e
> > existing cmdprio_bssplit entry format, it forces every cmdprio_bssplit
> > entry to use the priority defined by cmdprio and cmdprio_class. This me=
ans
> > that there will only ever be at most two different priority values used=
 in
> > the job.
> >=20
> > To enable us to use more than two different priority values, add a new
> > parsing function, split_parse_prio_ddir(), that will support parsing th=
e
> > existing cmdprio_bssplit entry format (blocksize/percentage), and a new
> > cmdprio_bssplit entry format (blocksize/percentage/prioclass/priolevel)=
.
> >=20
> > Since IO engines can be compiled as plugins, having the parse function =
in
> > options.c avoids potential problems with ioengines having different
> > versions of the same parsing function.
> >=20
> > A follow up patch will change to the new parsing function.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  options.c        | 126 +++++++++++++++++++++++++++++++++++++++++++++++
> >  thread_options.h |  10 ++++
> >  2 files changed, 136 insertions(+)
> >=20
> > diff --git a/options.c b/options.c
> > index 102bcf56..4f2ce0d0 100644
> > --- a/options.c
> > +++ b/options.c
> > @@ -278,6 +278,132 @@ static int str_bssplit_cb(void *data, const char =
*input)
> >  	return ret;
> >  }
> > =20
> > +static int parse_cmdprio_bssplit_entry(struct thread_options *o,
> > +				       struct split_prio *entry, char *str)
> > +{
> > +	int matches =3D 0;
> > +	char *bs_str =3D NULL;
> > +	long long bs_val;
> > +	unsigned int perc =3D 0, class, level;
> > +
> > +	/*
> > +	 * valid entry formats:
> > +	 * bs/ - %s/ - set perc to 0, prio to -1.
> > +	 * bs/perc - %s/%u - set prio to -1.
> > +	 * bs/perc/class/level - %s/%u/%u/%u
> > +	 */
> > +	matches =3D sscanf(str, "%m[^/]/%u/%u/%u", &bs_str, &perc, &class, &l=
evel);
> > +	if (matches < 1) {
> > +		log_err("fio: invalid cmdprio_bssplit format\n");
> > +		return 1;
> > +	}
> > +
> > +	if (str_to_decimal(bs_str, &bs_val, 1, o, 0, 0)) {
> > +		log_err("fio: split conversion failed\n");
> > +		free(bs_str);
> > +		return 1;
> > +	}
> > +	free(bs_str);
> > +
> > +	entry->bs =3D bs_val;
> > +	entry->perc =3D min(perc, 100u);
> > +	entry->prio =3D -1;
> > +	switch (matches) {
> > +	case 1: /* bs/ case */
> > +	case 2: /* bs/perc case */
> > +		break;
> > +	case 4: /* bs/perc/class/level case */
> > +#ifdef FIO_HAVE_IOPRIO_CLASS
> > +		class =3D min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
> > +#endif
> > +#ifdef FIO_HAVE_IOPRIO
> > +		level =3D min(level, (unsigned int) IOPRIO_MAX_PRIO);
> > +#endif
> > +		entry->prio =3D ioprio_value(class, level);
>

Hello Damien,

First off, thank you for the review.

> For the !FIO_HAVE_IOPRIO_CLASS and/or !FIO_HAVE_IOPRIO cases, class and
> level will be used as-is... I wonder if they should be set to 0 ?
> Or may be more simply, in os/os.h, conditionally define
> IOPRIO_MAX_PRIO_CLASS to 0 if FIO_HAVE_IOPRIO_CLASS is false. Same for
> IOPRIO_MAX_PRIO. That will avoid the #ifdef here.

Sure, that sounds like a nice cleanup.

I will add it as a new patch in the series.


Kind regards,
Niklas=
