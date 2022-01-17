Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D21AC433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 09:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbiAQJvg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 04:51:36 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:62557 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiAQJvg (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 04:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642413097; x=1673949097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dVTxcvrZu8FGF7QqKAwKdzsDrUqMZN2yRAcXB+Xgj8Q=;
  b=kWKEGFyKGLrvfNRqDj4L2tqBZm0zxEEodZkZV83SFpF9RSTG4pnWM90w
   UyHb6/xcIWMT2+Zt+VSf59usjpOV2MHml5COkeM0XAe2zwyDW7gHWDYja
   eeRKWQfE1VQuPqfLjp5A1njMRhhdFju6IgUuhMvtXuHH2ZCMnvq0Cruez
   whd/MUljr/jM7Uow13Ccb1KodyM0NZMdRo/YwKD0O2mzG9i6u+UrAV1wr
   7gUWtylCEUODX7bqZ1Qm5OjaXYbrqi1MMqtnhjgJD8aYiM8HNzq7v5oDS
   3c8Yt5zhtLhM9eVquTNf9Ga5Iip+rH1y6n54EHOCFkW90aFS6gNtGovK1
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="191651322"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 17:51:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmJWNIsv8QYi38Awbyi2CFh6DbkGvDrZYlXsgbhSBDyetxbsjWyCkSFkVcGc7D3gJrvP/66ZJZitYqyZLJj/96NxMbJKbRkk+uKIH0NHwvIlLdX+q0lRx8Ei1kHPybNqfFOJO8MWTtRN0Tu33zdHyj3ALnPxO0N9i+CNSUR4zv0EzBK0xtyKuDpC+A7ChhFCZ0nRK7gRUTw5BJstaJg3d3IJsg5klrjodkBIvQTP1uB+87cAa3Ubaixr7pvIFSVNiQjGCrSk9rt5Mg2g/Pw5Ozp0+/XWE589ZJaG9CyNWIfDbnTIq0lKCYYFmF8yI+ccN8fuPppu/5lm7GDJ8of+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CT1ZVLesnJLKmt+1VFKiJz6H7U6N7ecSrCFw5ABySAo=;
 b=RqXOUaOzDPCBwvi1vWOta1+LoFwiaWVPu0pGA/6cfuXRSloCq5wlRvb407Yu/sVagwP3s7Lu1SAU5neA5OFtM7r2jVwu2UHn4fdfRrX+k74Te3M9W0PiqS5D+I78PtWae0PrLrh3B7+qs6LYvV0nm50Ob98k2rFN8PHRG4dJbDX+4aAZGQK+F4raGJJsJdqjx2jQOy6KbeSk/ZwHgDfW1nfgj7l+3rWM7CTzSp/hWGWiKSvbm/rZr7zD76SFfffuRhUMCXnRZdH4CRYJg13p2sQjB4RS2RPuOFLWk2pQmodm1FWhF9QE8arvVAa2qWCkHFYWnLPh7qv93dZ2II2+aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CT1ZVLesnJLKmt+1VFKiJz6H7U6N7ecSrCFw5ABySAo=;
 b=xJRtg9Z8r8pOK7JoWMqxd3xeRvDc7CHHZqQ9w6/EZvO/cCWEz8VOdQIglzyBvD89kSVqPyFvEuhkI6QimAYtyYjP7KauTr71DQxTtWAsyVpE5m0YTp56hHdIaxTx0OWz2slClHpklofhalXA0QSTFSdF+kIPUT7QFiPy0Hgjg6s=
Received: from SJ0PR04MB7165.namprd04.prod.outlook.com (2603:10b6:a03:2a3::21)
 by MN2PR04MB6333.namprd04.prod.outlook.com (2603:10b6:208:1a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 09:51:34 +0000
Received: from SJ0PR04MB7165.namprd04.prod.outlook.com
 ([fe80::878:3eda:afd:cecb]) by SJ0PR04MB7165.namprd04.prod.outlook.com
 ([fe80::878:3eda:afd:cecb%5]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 09:51:33 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] init: do not create lat logs when not needed
Thread-Topic: [PATCH] init: do not create lat logs when not needed
Thread-Index: AQHYC0eNlKPS80rONkOKqxhWa2Lf+Kxm+Q0A
Date:   Mon, 17 Jan 2022 09:51:33 +0000
Message-ID: <YeU8JHc1ZsgZE2Yq@x1-carbon>
References: <20220117021127.9259-1-damien.lemoal@wdc.com>
In-Reply-To: <20220117021127.9259-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52b71172-63da-4ec2-b28e-08d9d99ef219
x-ms-traffictypediagnostic: MN2PR04MB6333:EE_
x-microsoft-antispam-prvs: <MN2PR04MB633384D13DE07E3F4F193C6EF2579@MN2PR04MB6333.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TXdA6gh3xdRnP6WhJoqtQOFlVUFPcId6fyIFAyEaqoamRYEFwrlv8zGdCrvi7gp3YDHlBjz19czWiYLnv92OAbCGZ8yXc5sRgFBtLV4y3krFBwXxsD/wFEl5nL5Ns8BlOLHl4RgfxfhFU+sTGH7uvNGSD1jwdTVhQdz4mMMe4zDWQ/9xx52E7G3cIAgRwwn3ZIVoKK6p7Qjth2kTSq070vtMPQa1yCEOA0Q2g+B8GAdzJZelfPPrD1n0S0JntSC4o73gMRXizNeeu5YMPwYx/WGBF9hreEX8QfPClJU0ADqaKz0iIejyVoZkO0Zkom2KLx6B8Jf6bMTVrD2zxnktK5VrzzreX6sOUaghecPu0Z5jHmvsDMU+n0XKvHVhOqhzpNY794kRpWAtO/sWmeSMCK/5dTUmIa0MYLoMLRTdlTknFdW/Z9u+cEmhrM4lP201nYAqdip6aoi4S340A17uZbINP1DKj5cZe9wRfKtQy4ljlCvv3uZXWL18CNETDuG7Fpp1BFWrSt3ePAeyYyPHBHZgG06WWUoPgZ7yWh6kRY4T0XsNg8e9ow28RtLxHvFyqJury+R/K0jnIY3AsRiA1mE8Wx9gmLHcjEKuUT7KFkKMWtct++/D3BsOM/NN0ixJw2PhxeIVL6BlqdmQG3/Mm5WS/Lzie0iKHdbdr61l8hyhKJb+1R+Xn4mtDDiSAXbBg8qm3j/DyDf3ksw4VLHe9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7165.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(82960400001)(26005)(4326008)(8936002)(54906003)(186003)(66476007)(71200400001)(38070700005)(66946007)(38100700002)(33716001)(66556008)(64756008)(66446008)(86362001)(6486002)(83380400001)(2906002)(6636002)(508600001)(122000001)(9686003)(6512007)(316002)(6862004)(8676002)(5660300002)(76116006)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uEZZRQwsfn3IcY6tSa52gpKxv1tuLCZh+uG0xaGI7Wz1FoE3PVCJkxh9P/6C?=
 =?us-ascii?Q?cOCGP0yA8tWFbLJSrcsPO+46E4gXjjgjSxvRLz/5EredKuhO7iLj0zczncRJ?=
 =?us-ascii?Q?ur8tOvifiza9R4j/8A3cMCaeetn1NbFyCIRKqHrrdrENvnar2/QRImghhzjz?=
 =?us-ascii?Q?mn0JT2AE6AHw/9PNul1Rj0YlxwTTiiRA5sYMcZyCGyAV4n92nbQ0E6Ja6W/0?=
 =?us-ascii?Q?AnthKnM9400imbdY7hEeXIKRmwYAI9phCNsczB2mQDPasAfp+NTVR5G58vir?=
 =?us-ascii?Q?eUPlsH2tXsr6Toak/BSbW3xQGY89vxBwLlSw4NIR8SH6WdZbyAGNgE3KLJRu?=
 =?us-ascii?Q?gJRDeqXL93kOKEMIO90GF/GlYhZxIM9I4ARoe/Vope4YlGT2EisZEwi1w39I?=
 =?us-ascii?Q?9CsdwmPv5gG2Lc+ukgvF6dE8JTFUa9NwNcXLpiWMIJMIsExL/fgKjhjJfx9C?=
 =?us-ascii?Q?EdbeYKs187jE9djrwI3pw4r3ODNzogPdjK506T0Fy61bGblvCsEJTF8ULcLd?=
 =?us-ascii?Q?I8Er5rUDOAEomTEvN4xAdFd3AKdlEEy6GLF5iYiaNhE4zJL9AzDQt+iVan0e?=
 =?us-ascii?Q?RcXTmzUtdM/0xYM7JGaruKhoiZEB5tOcG35uUGquFI1Hobpc1cC9K8DTBesw?=
 =?us-ascii?Q?Jd8bb6X58FCMy3GUT/NZihxyO6SUj1+9CMEeDavMngrP6QL/z9CcTBj8ubG8?=
 =?us-ascii?Q?ML9SvvfOov702LnAg873c0GSSW82syD2ydcJeUkKSjvM0Cyj5beHmvUu2Tcs?=
 =?us-ascii?Q?SP4CJ+01mUTE5YIt8fut1Wfu95grFEr9XOkVEAQF9leBNdm2yb58KIRUlOyL?=
 =?us-ascii?Q?sLehX4cRjqxMIl3vcEtMczWpSyCIZtzmqzO4DFHpzfygxRM+2MOzJk2JGjf2?=
 =?us-ascii?Q?3BYvjh26UalJXyOCwC52UuVGBZp+8MqmlaaCpGLjqUXB9n96DFB2J+DD0BBw?=
 =?us-ascii?Q?ef7zvhRikyTJAZRUTLHm5AKdb325AVOvAOuQo2JGu8yKKkFcOSr8R+Tzs8Hm?=
 =?us-ascii?Q?arFCwYcO8QTpyxPiE+Kwrfqok35WyCGfQ2hJ9LY+dDNmUv7+epCqH959lfyV?=
 =?us-ascii?Q?UzWCn76by0bMu4jLTPO/d8PtxXVCNMJvaIUvWTcQTb9yhqxzAp81m6mc9iBq?=
 =?us-ascii?Q?FGwLkMyy03WQt08Hv/cAc/KIgi1feYTXrXcTPx55lMm8AAMmxWVw5rpHCcZ6?=
 =?us-ascii?Q?sOeMLVZzXhQKDrYi0x83A/uGY7WzlbsSptSSRTSkazXOfz6kIxUqIyF/4boA?=
 =?us-ascii?Q?k7MTURIF7M7DQFoEhIAxMTrIdCciYQuFBSnvPaEhhU1JFWU9jMIwb6VuRkEX?=
 =?us-ascii?Q?MrmkAuEpPTXd0/o9JoTmTLB22DIf9oRyiIlveXlqTTUEofKYLOBj1a5AazgZ?=
 =?us-ascii?Q?HS7gdYGp0LRkf5XKdYautJc7yMw2Rdx66joezOHNgPuftiNh9X7bUDoYQ575?=
 =?us-ascii?Q?pi/fKuk8PJ+zhYm4OmUI9t1qlM3R+MuhYmpaGgWyrjbz70CBHWichRl5kzzV?=
 =?us-ascii?Q?iILm45spO60SUdYE5PD+uDDJxpjF9xi5USFdozb6ot3tMlaRGPEY32GMIRWJ?=
 =?us-ascii?Q?hvVn8t1I1dkTpJj8k64rOB4MJLJsZ955lXZxeu+psQEVZTwYpdFCzPr4cqJJ?=
 =?us-ascii?Q?FkjKvjy8/4Lpt3RbTSwCK2k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12C6CBE8DB09B1499CCA88F930B4D78B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7165.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b71172-63da-4ec2-b28e-08d9d99ef219
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 09:51:33.8060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D8Yk86AnX3NRWMhlhAspzwudCRioH4R+hzTrHDasZf0XtRcuzEcoPAreIXUvooajjY1OBWK5U8d2WlQIh0R9Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6333
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Jan 17, 2022 at 11:11:27AM +0900, Damien Le Moal wrote:
> When any of the options disable_lat, disable_slat and disable_clat are
> used, there is no need to create the lat log associated with the
> disabled latency. In addition, when write_lat_log is also specified,
> this change avoids the creation of empty latency log files.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  init.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>=20
> diff --git a/init.c b/init.c
> index 5f069d9a..07daaa84 100644
> --- a/init.c
> +++ b/init.c
> @@ -1586,17 +1586,23 @@ static int add_job(struct thread_data *td, const =
char *jobname, int job_add_num,
>  		else
>  			suf =3D "log";
> =20
> -		gen_log_name(logname, sizeof(logname), "lat", pre,
> -				td->thread_number, suf, o->per_job_logs);
> -		setup_log(&td->lat_log, &p, logname);
> +		if (!o->disable_lat) {
> +			gen_log_name(logname, sizeof(logname), "lat", pre,
> +				     td->thread_number, suf, o->per_job_logs);
> +			setup_log(&td->lat_log, &p, logname);
> +		}
> =20
> -		gen_log_name(logname, sizeof(logname), "slat", pre,
> -				td->thread_number, suf, o->per_job_logs);
> -		setup_log(&td->slat_log, &p, logname);
> +		if (!o->disable_slat) {
> +			gen_log_name(logname, sizeof(logname), "slat", pre,
> +				     td->thread_number, suf, o->per_job_logs);
> +			setup_log(&td->slat_log, &p, logname);
> +		}
> =20
> -		gen_log_name(logname, sizeof(logname), "clat", pre,
> -				td->thread_number, suf, o->per_job_logs);
> -		setup_log(&td->clat_log, &p, logname);
> +		if (!o->disable_clat) {
> +			gen_log_name(logname, sizeof(logname), "clat", pre,
> +				     td->thread_number, suf, o->per_job_logs);
> +			setup_log(&td->clat_log, &p, logname);
> +		}
> =20
>  	}
> =20
> --=20
> 2.34.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
