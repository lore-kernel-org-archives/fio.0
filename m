Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE3BC433F5
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 10:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiD0K5B (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 06:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiD0K46 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 06:56:58 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0B03AA87D
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 03:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651055586; x=1682591586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bWxRCHS3K3mNdTfB7jqdkf66VLxa0XCC5FdJIfLCtwA=;
  b=myKDvIq+8H9G80PckFz4O2YB/OAWMVjiMblfbqUf8bvi51057Cx6wTUQ
   7eQ+SbfjXNYzE6Z/FTNNVKc0HxEuLprHa2BnXrzL7q8j8hsChMgV0wZZt
   oxozEaniDkaHKqzJ9jt1pO/WCdtPfAeSwIHXM5sG0QNpZNmjkVe2AXrDN
   yHvEYAoiPXv2FLa9v4LOWi8J7GkwtRQPbapM8mkQW4qP3BK+RtypDMcCx
   F2sYjamJL9zn/PpU9numvyWmy3zO9978w8PVTqiL7cOPlqWdiEJmU/PIr
   kCmfWd3xBXRe/2T/RGPGWpUaPem3HefCm6p/jW+hh0VjtkW4+URXZvvXP
   A==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; 
   d="scan'208";a="199835518"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 17:35:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRSecxHE9BzP++8PQo8Oi/lytWj20jJqNc3s4o6yOK77TSjUfGA9WGLoDV23X9Y5LoLIzVDc/Wbbr6u/6BJrfGDqkd9lg86fcwoJMxh6TdpOJXuJujhMPQBw9mKmSZCsAoVtftFjh1MK34LsP7QCK2/8U7qOTXwmEV8wa3QGI0qy120VhKHeTxWfSDoSp+/+ZLF+VwZwtRPBzK74TryqpArEhX8XnE4HAbDIXwUs5pFkxNJaDr98vmHrtbRiumyDFBUyo886BjfvUesSX5v1rts+T63xLd8FhqpRkjnpp2sHB68v+KbR9Hjs3FMGfm7Mk5kUSu4n9CqU4S+FQ487Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3kJxkgCbALlbxhlz3GaBi9VXX48P89iUZ+2QtxP7xM=;
 b=M+cLs+KBqStN1y8tuxx531IX63I85ii1JKXOTmLEyMIYJTai81PvPAvskCJO+5P0f4VsNjA2AnvGWTckH8i4QGsU4tudZAbJYq8R0AzZU++uWkNOXCovubTQMTQj0B3QjQrR29ror6jJju5QJHyibDl2sl7cfnecKv86m/VTBvsWvqXuxYEOScn8DjmBQ1qK5AWibuDAWjJ4tLR6t54iCHN87tmr2oUwJbBQYxBbfvNcIGmBQzsb6J3/E7RjV7U2zrbAbXa0BGnZEDyz+FfLnH1RkMrF4autTJiJvhPslF+k2HmjqEucksx+ZSEo/ow9HLAzs4pQT6mNmio36p9TUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3kJxkgCbALlbxhlz3GaBi9VXX48P89iUZ+2QtxP7xM=;
 b=clt24071GuPgrSmzK3/pq2qXVGuepoJ3TDBSE6v97Xgvz4dpcOOaEyyIugtjD6pkIaGSYNEEGS5CVhQx4qYhND3Rko6FqKL29tzU7ljXc9tIr9Hbx1/XSuiP46A0MhHIyllNtw7uPojotbN2RmXYdKX4JBPLY1dAvgo4Om/BnkA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BN6PR04MB0165.namprd04.prod.outlook.com (2603:10b6:404:14::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 09:35:02 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3cff:7ee8:c1b5:b4e7]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3cff:7ee8:c1b5:b4e7%5]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 09:35:02 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: Re: [PATCH v2 3/6] stat: Handle `ENOMEM` case in `__show_run_stats()`
Thread-Topic: [PATCH v2 3/6] stat: Handle `ENOMEM` case in
 `__show_run_stats()`
Thread-Index: AQHYWhisE74GBihu2EmBCvpzN9hBwK0Df/CA
Date:   Wed, 27 Apr 2022 09:35:01 +0000
Message-ID: <YmkORZJIxvBOxHJN@x1-carbon>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
 <20220427091125.114146-4-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220427091125.114146-4-ammarfaizi2@gnuweeb.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7983f5c2-87a1-424d-e692-08da2831341f
x-ms-traffictypediagnostic: BN6PR04MB0165:EE_
x-microsoft-antispam-prvs: <BN6PR04MB01657C28EA6081A7C16DC99EF2FA9@BN6PR04MB0165.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2bPCyy3LQwBnE3pfrMn1r9sPMBw/WRFZobvWp6wbFMCvI6djj4F4/7p1W+MvmzhaGyKTki0nOcNEB0uf6H27I9n1fibv53Vu8hNTUgVhUoVOVizl6zl7xq80hyjvEiGDDgwmT5kLmAdYr0A6Q3dCW3u56fsCOEum1zKKo74F4cWXZKzkOPcMAX1fch5McVq7+GRF4KWQg+KfNcj4yQ8yvoIREPTljq4e1lQ0Vori16TMjSaaMnGwCtnms+Josltwh7gr8Nh0Tc7Sz8Ao2xvWQHMiHgZvlB8vXBkssxbbAkbk85dW2W2LdPV2jJKILulZ9YmVfC+dclvbVLoLcVLMlXZosTt52Pg+hDZa5LboZh78Sl8A3yn14wfNbzYENFgUWilqQZmxilSN8//a8HXPIQrJPjK+xUkBswgiqttgZu5Z1gYujC4EhRvM+T/7RWA4LviPYo2k03IXOtjUxYRUtYRY5BY17y7DQlUgG+zxMo+drXQpyorXcledUKXnRHKk0VzOXOmrrsBSJsHhJlNZDMd3mObXhH951CCp8r2y3tH4bK/VU0mVJt6ZE2ht2AF7Eb+F8KIhpqVdK6MeJLqFF6uux5u18nkpaz54VQZ10Gb8cxJpXW3pcFnALWaNymA8sa+VFmSebIOIBq1Vy0qXBvlOebhoIP56bSupqTNBMY4ZhTsD3y0ri20BtTWx0c+oBddv1IK/aAv5iK232WX75vSmsn8VUSDh7cDDZQ+b0k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6486002)(6506007)(8936002)(9686003)(5660300002)(33716001)(83380400001)(122000001)(186003)(71200400001)(86362001)(26005)(82960400001)(38070700005)(38100700002)(6512007)(8676002)(91956017)(66556008)(508600001)(4326008)(66446008)(64756008)(76116006)(66946007)(2906002)(66476007)(6916009)(316002)(54906003)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cLZJn9xQC+x5xq0fmei40+pbU9tTxi/19Qlw+TLZrmrl3bMN3WyXPoKBFmsW?=
 =?us-ascii?Q?NEjZ0SUHJ+0Tku1gTVHiQxTx63pPge+zf0MA/0tUilL/AzQQ21Q5DXLRQ8VN?=
 =?us-ascii?Q?+SRvpvODc/9FpKCqcQuIYTW1L4NimN2EAMlXXJQ+1qEwW65ywNHLV7Xv2+Fw?=
 =?us-ascii?Q?DoELRvj65o+WeWB+Oug4rdJxXNX0LuLM1bQD+3z7UUmv0SJUvomf4cjhwU0z?=
 =?us-ascii?Q?MSG+RpPAKQEUYtEB18TwlgtQkM5rQF1r3kALGTGwV07/tNmHGG6Y6qkxYUHY?=
 =?us-ascii?Q?H7uDqJpzUNIqWfjk37+4+oMGQOMeOUO4ZCmis5KpQrk9plJ6D8f45IdrydrW?=
 =?us-ascii?Q?FqsUmsP2kTgErFXeCgF7pdoJvxlh82/jzrIhnZxtFQ1l/BxxEiopOow2ZcJD?=
 =?us-ascii?Q?J6kEreLXkI08KdPCrg+GVl5OwkK7NoSa35hx7RXVIQt+IsMN4k7p332bqn5y?=
 =?us-ascii?Q?cjXzxrN0nSjT85gAPEsUCCtf/cPFaZLRjvqWY2I0b3hl+3hQmmbfJ+b0LjtN?=
 =?us-ascii?Q?wOlrjFnY46hAAHYd8DgUTARFpmNEn/MOxQv4LH6z7xBEI23pGuQLH8m0GvYV?=
 =?us-ascii?Q?kf+pHc97E0ekVLtk/5oq8zyFbzJ9Ik7tctaI9mtcc5h7rc3KBMow6nrxrpdn?=
 =?us-ascii?Q?uZpxp6lc64Y2IhQNeiRFZWgbz687YWcQIhrk0lLUtoZxPGaanYp++1sWAOmD?=
 =?us-ascii?Q?O3ainNlf0PRxOoNBQN6yJfiaRwtOl+0fiefUDgDeN65WMODalEqpOBXJH8Ak?=
 =?us-ascii?Q?9dMdl5A+f4R+IUoK9c7Hy7nE8xz5nF5f6kdSfVGYVIicIxbP/hDypJ7niUT2?=
 =?us-ascii?Q?hxNfdsfdFhLViW+JSeAYfT9yOiMqCtJdFRH/AwbkdCmFfHb8A2lOhgRZYEj/?=
 =?us-ascii?Q?xX6bJ5BQgd44P8IHjeAkgxfsd/gagpR6VAHsIOqPUdhdeoUCf3yagbFxKube?=
 =?us-ascii?Q?i+xfE/eJnDuHzqyF0DZbDBqqUOEC2EQguC+6dHL/fMoYF0K+uVn7x0u0gsGD?=
 =?us-ascii?Q?bkCX8fPsAiXBNANNXqwH77N7VAqEcWxPwlagGeS44oXTXB8rh14lYwrbr4Ro?=
 =?us-ascii?Q?EO10aI3q9oVghlCtNoCNnq98veis0c4Q71BCDx0E6MXxXgp3RD/Kj8iriEJk?=
 =?us-ascii?Q?qhYgcnBydc9E8twajLve16SbaXoAcEILzw6hl9/Mp87rmPU60b53laiRNMio?=
 =?us-ascii?Q?TPOMn1c8A7Od9EJ+4eXjBcTM6BC60HpdbUMTWirmW522xvMLK8vUMCF2+je7?=
 =?us-ascii?Q?b5xEaoGAz80JS3wOsdscTglQxneb9/k0Sw4UOvSYdSepRnWAK4k9V50UkCaD?=
 =?us-ascii?Q?DI9IwkyJ5dj2borLlzSVYj9mpYQPXTeELKvzyi9XFTmIODuhFIYiiKTKlLAT?=
 =?us-ascii?Q?oPWre3KUjdKT5xp8go3OCZHtAC5iCyz67/wFgqTvZpTPkygDwKw6KUN50RIf?=
 =?us-ascii?Q?KiRmviLhT/wekWgeEftZjkaIU6qZ+PMWrvYzqzSDm47mIE6Li6N9FSYgGkQU?=
 =?us-ascii?Q?3vr+G7RvsMzlld2kNWMdTnSMnV7BwvdaTNhW2KcJmQM2eEEcQIIjI2QwyllM?=
 =?us-ascii?Q?ljibyas8tTKkdAlvdN6+Y9VfVPxA8e5ESvhR/x2LblGJLBMf9jKiVCJsR2kq?=
 =?us-ascii?Q?xak0X9BIO/R4zxI6PucUAhb+ye9TeLu6RC/dQHEoEbI8H4nbVa8afdrKsXlB?=
 =?us-ascii?Q?ZGrtnvBytJ0zOSQGh0H3nFYJeeJhE7if1VgGBl6E0154snTjysZiBoR8+hKg?=
 =?us-ascii?Q?P3wDCLzaBunoXRzUKdXM28OiwHLzGdA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2EA675142E97B46A5A5DD046509F43B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7983f5c2-87a1-424d-e692-08da2831341f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 09:35:01.9049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oxgYJL8w78pugrRrH/PwrgkQitwQa/eOL0gMLhUU3vvyuGjzVRTReyH2Ph459kmOsQ6IZSQbzNk2z6j1i5peGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0165
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Apr 27, 2022 at 04:11:22PM +0700, Ammar Faizi wrote:
> This handles memory allocation failure and several improvements.
>=20
> 1) Change `malloc(n * size)` to `calloc(n, size)`. This is to avoid
>    multiplication on `malloc()` because it doesn't do overflow check.
>    Also, `calloc()` zeroes the allocated memory, so we can omit the
>    zeroing elements of the array inside the loop.
>=20
> 2) Make sure we are calling `free()` properly if we fail. Use goto to
>    do this.
>=20
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  stat.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
>=20
> diff --git a/stat.c b/stat.c
> index 949af5ed..cc9be02e 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -2429,7 +2429,11 @@ void __show_run_stats(void)
>  	struct buf_output output[FIO_OUTPUT_NR];
>  	struct flist_head **opt_lists;
> =20
> -	runstats =3D malloc(sizeof(struct group_run_stats) * (groupid + 1));
> +	runstats =3D calloc(groupid + 1, sizeof(*runstats));

Hello Ammar,

here you allocate runstats with calloc.

> +	if (!runstats) {
> +		log_err("fio: failed to allocate runstats\n");
> +		return;
> +	}
> =20
>  	for (i =3D 0; i < groupid + 1; i++)
>  		init_group_run_stat(&runstats[i]);

Here you call init_group_run_stat() on each runstats,
which calls memset(). Seems a bit excessive to clear
the memory to zero twice.

If you intend to modify init_group_run_stat(), be careful,
as it is also called by client.c


Kind regards,
Niklas


> @@ -2454,14 +2458,21 @@ void __show_run_stats(void)
>  		nr_ts++;
>  	}
> =20
> -	threadstats =3D malloc(nr_ts * sizeof(struct thread_stat));
> -	opt_lists =3D malloc(nr_ts * sizeof(struct flist_head *));
> +	threadstats =3D calloc(nr_ts, sizeof(*threadstats));
> +	if (!threadstats) {
> +		log_err("fio: failed to allocate threadstats\n");
> +		goto out_free_runstats;
> +	}
> =20
> -	for (i =3D 0; i < nr_ts; i++) {
> -		init_thread_stat(&threadstats[i]);
> -		opt_lists[i] =3D NULL;
> +	opt_lists =3D calloc(nr_ts, sizeof(*opt_lists));
> +	if (!opt_lists) {
> +		log_err("fio: failed to allocate opt_lists\n");
> +		goto out_free_threadstats;
>  	}
> =20
> +	for (i =3D 0; i < nr_ts; i++)
> +		init_thread_stat(&threadstats[i]);
> +
>  	init_per_prio_stats(threadstats, nr_ts);
> =20
>  	j =3D 0;
> @@ -2709,15 +2720,18 @@ void __show_run_stats(void)
>  	fio_idle_prof_cleanup();
> =20
>  	log_info_flush();
> -	free(runstats);
> =20
>  	/* free arrays allocated by sum_thread_stats(), if any */
>  	for (i =3D 0; i < nr_ts; i++) {
>  		ts =3D &threadstats[i];
>  		free_clat_prio_stats(ts);
>  	}
> -	free(threadstats);
> +
>  	free(opt_lists);
> +out_free_threadstats:
> +	free(threadstats);
> +out_free_runstats:
> +	free(runstats);
>  }
> =20
>  int __show_running_run_stats(void)
> --=20
> Ammar Faizi
> =
