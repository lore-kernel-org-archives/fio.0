Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA81EB64DA
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 09:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjGTJai (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Jul 2023 05:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjGTJaS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2023 05:30:18 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E05E5271
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689844736; x=1721380736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pXiy4FJjVrR/f9JWKO1IXJUOazkNWcYzv3rUQs01xpM=;
  b=ab4MsaNMoOlm+Xg9Lt46qYFRyYrgI21EBZlJjhxnueopgDz0qtR2ZaFz
   K5RjUebqTvyCbqAiUrS+O3zwXjTVXhhMotrtG5YRMUb0DCQJrRRszEKvw
   AKph+b1+GfQzBtHUTk7pnvk3oCVCg7LBktBHBEDzQa1ZNmg3fFbexwcK/
   4HQduGAYktn1qlSRIW6DOnMD50sjJQNDaJ321dAzD8JYTX6JQIF5j84sU
   B2ykaIFvhyg9O5+ihkbymnCeFQ44qVYdlPc47zJUmJFc56k31vVTU6fry
   14dO7IbSwQjh0rmPMzOIwx1p/Sv+N8pdwxii++eU+8tyA9DIm2X09MXHm
   A==;
X-IronPort-AV: E=Sophos;i="6.01,218,1684771200"; 
   d="scan'208";a="243235511"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2023 17:18:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaLPC8dbCyD1sX/DdZPmFtxric0lU+4Grx6rCZVg4frQvabMdNiEpbmkiGWhkwO1moOqJT96Cq0WBgW8SvoIVSNMGemqiZ6wMxT2hLaVEq6xLLaKVphhMNwdX1SQqNfgqA00TpH7VdQ9xH1z7532erufUUiJgF4CIzhVTowMwu/G1d7x3OkQhtTsBDkvCyAIvfi5pzGQ1475BOGh5X0P2MRPy33dULze9vzKJylbUfj16nkSE468I9ooFZV1kzLOwmEqVOk0NlyY6ITJdyXZ2jmv6oUFI4hYSEDXJFefGPen7S8NaZOJR+I02v015BV0yJFUHiE6D/TG4ctlOZTApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPWaNHGTrbZ61+NVr8JZWS9hj9vo6WY43ki9GKYQQUU=;
 b=dPGnm0ibAJpHR8ZytWb7U6FCSC+AW4yeU6DF3CIqobbmxNKUvHGsVRLjO6IrE8n7/E96IlIoJLHc1R0ZuC5xiwqLQQV2CY1lSxyk/AgBdsb+EiWTqfOqOXh9siZLgefjDCbn6fV9mnyJcymahGAET4LGn5o4I0deLmciJKaYv44UukNsO9MnSUySQBYAXgF44AAPno5LXvoEDCj7phhkNF8N4n/b9CKfezykFGKrLQNg0BWvXtQRdzO1Q5OzyziIWtVa8hfsLpHzNxmSOHTNmXuFfOY+Zsol+AEeEgvf2Om1F42K6MPZC8uYYGHKlb4k8wx2JmUA9UxgeS1YyfXJZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPWaNHGTrbZ61+NVr8JZWS9hj9vo6WY43ki9GKYQQUU=;
 b=JcNeOyUrtfa6GgcksWSu0xIQzjSTmLopI8d7KLq9TRke02veu37l3UWkB1hpig5RRF+mbmTQVSf2SQaPtfaEpMEjQ2DuQJ4MhErMldoT9SIVs8VnKFnCYtL1pJoNpkupOpMEThJbZhQntuKNJ7bWY4Z3AtiUi5tLJf1dSL+0qXY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH2PR04MB6918.namprd04.prod.outlook.com (2603:10b6:610:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 09:18:53 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 09:18:52 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 1/5] os-linux: Cleanup IO priority class and value
 macros
Thread-Topic: [PATCH v2 1/5] os-linux: Cleanup IO priority class and value
 macros
Thread-Index: AQHZuqnlw9cov41fakC49oFeic10rK/CYRGA
Date:   Thu, 20 Jul 2023 09:18:52 +0000
Message-ID: <ZLj7+y84XQKz1CRw@x1-carbon>
References: <20230720013114.28158-1-dlemoal@kernel.org>
 <20230720013114.28158-2-dlemoal@kernel.org>
In-Reply-To: <20230720013114.28158-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH2PR04MB6918:EE_
x-ms-office365-filtering-correlation-id: 53f2d877-c3bc-4269-bc51-08db890255fc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c5z7nr471EaUgkoFdZ3cW773kiWBVNL9MNIcJJUQv4JA0+aVhKyh9/KZITOmZne85Wng3W/BlJVC2X2KXYq52kviyfXKM/ry0EPhXLEj3GIOsNPJbQrWHeA57LSKW7W2ywxC4LGTFD6zTWvYIAE4KEmrBU3I2FmGs301M9lAATSHfM1oISCYGUiOzC8/yrSJPfPWYdUbk0m1pqEfVklWvQ290uH6kHduRr7wVcaIRTD2hvB474sZBJ1J4bdf2ciC0JvAPn/DCAOTkfPybX4oiyKCqMEiUBD6lwebMibnphLI5PkWu6/gcaUBXCQQc9HdsxC6ptnyHiFobjn94esvu3ah3XZzxqpXmeXaXJlZyO7DSULMjhkoqulmdtX7qVmZ3kCtZJP5Um5joxA9YU+dwxqOQiODRbVEcH9iFwyzfxVXUMKPMMdG50uEh5RWcVG/4T/jsekSNlvCqiqjjBENQzo1Jxj2QJJoO64Z4fl1ljSsjDSR9h1smGUJdqVlNT0g8iRB+xpF6LO6IJSErHTxiYBEeVLbquEmcCp9oRC5GT1uWYNJLPth2ci9kik78cK5z0eV0Xlw8yzqOS0ryPd8FKPOwG3RNyqCZBqC0G/A7mvSqDp4IhyW6d9FmhNjbu8iIeZ2CuBxS/whGnQ8y0UrLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199021)(86362001)(478600001)(83380400001)(186003)(38100700002)(41300700001)(26005)(71200400001)(54906003)(6916009)(8676002)(8936002)(316002)(2906002)(4326008)(122000001)(64756008)(6512007)(66556008)(9686003)(66946007)(33716001)(66446008)(66476007)(6486002)(38070700005)(6506007)(76116006)(91956017)(82960400001)(5660300002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kt0cHZOqtmLNx/JbZWshrSo0ko5aipuZlrtU03MeEFmtwVej4PLfs6aN27jj?=
 =?us-ascii?Q?ElsoMajTxLCpJGbIPqdL2op6lOqujTwV6/vyCQ6bUp89pKN5A5Wf7gsDmHHR?=
 =?us-ascii?Q?FGVNPOtXKjuwmoCGJUyFRvBG3Y6iK5TBHUl8HkhnDk+7O+8Z++pO84JLXo6I?=
 =?us-ascii?Q?lvuLVWb9d22IY4ww/htxFs7dHvg0PexyTHF9vrYPagiEOG3hf3fjUpAXe+wv?=
 =?us-ascii?Q?ru3vUPF88rq6mvS4Dg9GOA/oPq+FoPsS+vU/sAIClDfWi6P+3wNZHHXT8Afd?=
 =?us-ascii?Q?qCCDgtjBM89yWo8PqstmAhW3ueCfcBNKFplb69krYjH4kcEpoqifs2IV4tT0?=
 =?us-ascii?Q?2tDb4sw5AJtKDP/SY+2fXaYnWHNPhq5n6wPNEJX3bc00PjbA4mlKI67/oYnV?=
 =?us-ascii?Q?83f4Nc67ZrKvI46xlTbZFnjm/efIW1YNmwEytREK0n8wFQhKqvViXEMSUBo6?=
 =?us-ascii?Q?AiU/FNP7p2/ygDcSB6s8KZAHMsotWe9iH9PPRX2wAHExlVpTMmUPNEv+vPRY?=
 =?us-ascii?Q?dPbOAB8uzmSJ0Iq7XYjgn2Tuc12wH1cvkva/5NxC5IvZIgg77VIE2TuDBVzu?=
 =?us-ascii?Q?svQ5KsLiL8yt7Ud6vlVCotYwEooGqe4Xb/Kly2tY/vZCi3J16DWuk+QcHlOP?=
 =?us-ascii?Q?S7No74tTkBt2LprO7jHb/Q9eAaorIYWwXNzp6HABy+LU2FD9eYzy8f6n4Ddq?=
 =?us-ascii?Q?BHHsse3Mm+XVszpnKWUqtAPP5K/7OwowmdRoMwKyic0bfqnfL0amhq1cpZfj?=
 =?us-ascii?Q?Ynw9Wo5ln5AC+gCcf6zZQ1aTii4xNPO8UTDdhSZ6S/loJ7K9a6FC0horXW6a?=
 =?us-ascii?Q?GC84XjqH+aZL/7VMJcwo9RYEi5aTTWbiyGiw1DVSCBS2QKopd4w4DdCVLCHy?=
 =?us-ascii?Q?SQY3CaYrZIPoSqVuTLoISBTnfjCXYmy35wFjZw4m0vFr6iLa7TPCSlAPOwGK?=
 =?us-ascii?Q?riKEZVkDTNwJtG1l59aZmCCJTokHelgpOTaJ+ORsgWW9ymU2gB59tDv2iSd1?=
 =?us-ascii?Q?qQRCch2MDI3ayfeQZUCtUaBxaKjl5cig8sWNbQup8TZLylPUEYhemln3q10n?=
 =?us-ascii?Q?Br1pH1RUl/8+jFeRanZTI+3Nzr41RPBQVFzai6bndyIsixxARxNYA7QiOr7x?=
 =?us-ascii?Q?lVdE217pKOAbdjix1DedajjOtE7C/c9H/nqkkzmW6eThZaoZGo2VKBL9pj5G?=
 =?us-ascii?Q?xPTk1T1OdWI+fPld7CngJ+9uXug0a9CdsXqPMAWeCL0hXk6I8P1nPrn1lI6G?=
 =?us-ascii?Q?6dvlbk8x1O3JpZDLbvgHyn8d4MEalCjmTz4OLOxZcuqFHe8OHjqzHNmuXfy4?=
 =?us-ascii?Q?mPtiktdTWntfYNKyrvChu+VJm0eTVpzPAy2xk3NrMviSmWV1I5+iDYQJ2x5D?=
 =?us-ascii?Q?Icgk7QT1njfKGhirb5C+2w4oXCCEPPdNvRbH+8E0RMo3xrBsR50oGaXmckfD?=
 =?us-ascii?Q?8CbY63692dONCL13D2I8FfSBqcIzo5b9PaP5kfA9eQDXTa+IdVMUPLyZlUCe?=
 =?us-ascii?Q?ufGSWmtIgW0NC5r1GfF9tViu03bqJ5MXZC/c1OBTJl2lW4ZYRYuQEFFI+aoR?=
 =?us-ascii?Q?jBcVyrPMc9GtnoUbv0TkAxBatPyhJMFQ0iwdx5KOYfvyeIiragO7V8OZrv6q?=
 =?us-ascii?Q?tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <37A698F1B3F94F499E65BF69E7CCEB69@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eWqJlh4mR2EViRXK1jwD8/1WHtbelTpJeHptXTRcP6XeDHxjfSHffjun6jDtxJL7CpYb6lePx9Z6V49SaqUClqRF83b8hqzdi+akbGVZpoGgdpXP6ebBGoWsQDI/uwmo/d1KyO2yyW6/k4QPAvcuWMRE8ddvegHwUZ9fovJBjrSHkayxMEsrFn26Lrx9ojdESLGjqIIlSmcrnE4gWPOPTxEbAr9RAQWQp6OaWRWCsVRloatFm7cZGIjkI8UxHHrb8JUG5HquDe4gSpVeIdT11z+nbRZX9IM3UCB3qzYu/1lva/IZEZOKYJZYhVOM6oSOc0WC1DwLE0oZGARQcckfaAuEcJ95wPRUK8YC9mLmIi8P6cHYEHxyh8QCo/tR7u29w+UE+BPS1tzpcqh7h2ScjxRk6JPYIq+rIYFBnGQve0g0uEbw+gwbdy05ci2KgxuagiIvq8zJVzYno+ZZpv98A7g23FO4zI3UK2dVhHJvTwn7JT2SndhuJe7gZSd4gqPCwIEK45HBb00+ANPfFZwzvWG4PlnsmgNkoU5fAJQeFjTtIVSAYQdVVJNYmuuUfy5eXjbTVeIhWX/TQrHGIM5/gTKxYDb4qLt8GFgtqS0oPeECZd+lfPSNt5hQKrmr+6q8SF7l6mnlZqkdCin4XKnvArD31Qf04jSik/MFyhVCJBiPKi7HGTRzZ88SbN6neYtzu3qmzGg1YHdjjq4VtPnBB2ZTDG0XeUtPLlXA9xQSiPlG4/h8hfPaIlyup+GF89X+ELc+66/3zRT1m+djivc6w57emCViX55sRslQiRj/OODvbfRc1vQlPe6yRzhSqwKL1W/baOKhpeCnu1ca97bbtz9jAd1/xksrSguA5kLXX84=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f2d877-c3bc-4269-bc51-08db890255fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2023 09:18:52.8106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fGf1CkF0C9KIgcN7gVcbgh+6yvthgSPlBwJ5bRdc011aZyHam3NpwleJYjt+Vh+7N08siaT3hIhzKYUIynNpqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6918
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jul 20, 2023 at 10:31:10AM +0900, Damien Le Moal wrote:
> In os/os-linux.h, define the ioprio() macro using the already defined
> IOPRIO_MAX_PRIO macro instead of hard coding the maximum priority value
> again. Also move the definitions of the ioprio_class() and ioprio()
> macros before the ioprio_value() function and use ioprio_class() inside
> ioprio_value_is_class_rt() instead of re-coding the iopriority class
> extraction again in that function.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  os/os-linux.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 2f9f7e79..72727ac3 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -131,6 +131,9 @@ enum {
>  #define IOPRIO_MIN_PRIO_CLASS	0
>  #define IOPRIO_MAX_PRIO_CLASS	3
> =20
> +#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
> +#define ioprio(ioprio)		((ioprio) & IOPRIO_MAX_PRIO)
> +
>  static inline int ioprio_value(int ioprio_class, int ioprio)
>  {
>  	/*
> @@ -144,7 +147,7 @@ static inline int ioprio_value(int ioprio_class, int =
ioprio)
> =20
>  static inline bool ioprio_value_is_class_rt(unsigned int priority)
>  {
> -	return (priority >> IOPRIO_CLASS_SHIFT) =3D=3D IOPRIO_CLASS_RT;
> +	return ioprio_class(priority) =3D=3D IOPRIO_CLASS_RT;
>  }
> =20
>  static inline int ioprio_set(int which, int who, int ioprio_class, int i=
oprio)
> @@ -153,9 +156,6 @@ static inline int ioprio_set(int which, int who, int =
ioprio_class, int ioprio)
>  		       ioprio_value(ioprio_class, ioprio));
>  }
> =20
> -#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
> -#define ioprio(ioprio)		((ioprio) & 7)
> -
>  #ifndef CONFIG_HAVE_GETTID
>  static inline int gettid(void)
>  {
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
