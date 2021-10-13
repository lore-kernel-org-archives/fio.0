Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2188AC433EF
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 034C560EBB
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhJMI3b (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:29:31 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59891 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbhJMI33 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 04:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634113646; x=1665649646;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ym3ilj65XKSFFbC1JC9rN4z1L61mawRdTSrvUKSzax0=;
  b=U1TbqJoL6z8yoV5vh+QeJrWRS+LbHi+Jghp04/SMqPlYN0hg0Ux0WbN8
   B7qLlwd1R5IwgJP6SC0sLDs/s19JLyOgnMpDGYKUzOxMZJbgSE03Pq7ha
   yv3PlAyHowaYQBxCNCMsReZNwZOAtmLYl34566s3nqpOgHcw7By5wAGhq
   TI2bZsRE1PqJLZXcr7YJlAGro2GoeSzHyDNRbjXJaoHEgMC8JoxGaabea
   +SLdlElBXFia5mmgomo+mT+C8wcRvsklPVIVWmRkUn1wzto2FwAK+V5hI
   ZTkRnJxYtPZGdQWt1p1cuLwc/iCQIoT++0PJFwGkamNPFAqYmkND7LPq1
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="181730582"
Received: from mail-dm3nam07lp2040.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.40])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 16:27:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zjg73FpFz1k2d+uimLlNCd1Sy8T4uSY/Nc/1YHiQCOrvmB4/3Z9goU+vskY3INkD6sJYCAd+JQLVvIIhWM5EOO7sWgXVswaz6WCv7VGSf2bzaP1mmUmNXbVDJRy//c9oxczblfr4F7fYG/rtnlHe4lN5+aYdvGGnqrTE3NaGtjlFNjC5jbGaE1X+Bj6pC0IPLd9RiEfzdXNBwrH7KVlkaOLcic69GHeL+CX/lcxGXwB0ZwxiQuW3YbQ2XNCiDXoRYTLgnbMyn1BaVtVRn6WLSkos9NFv0QL6tXHp1duogTIQb185/VIGzn2pINB/Z1Rmiw1K78cFtEZNLtqMytw04g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ym3ilj65XKSFFbC1JC9rN4z1L61mawRdTSrvUKSzax0=;
 b=fbK0EXLeUfR7/P8rDHG1ayy4iatl1IiEJ7tZaMY982ayrx70PAX/HN/SGoJvmjYEMREsgLlEqF+EMhgT2bfpzlqxn0HNeLIYBdiYQGRGUTiWycKVQt6izaonOdzq8jaEP+0kgIIY07FGinduaXQvypB37LxNUcSYrgh5kKzQv5dLTSNYltn6Fdcg3q8oumDbvbT8Q5XQKr/2gshVld8tZG3feZtKA03WMmRbViE/2ohVNu4tWYakNlFOojxjpbXBv1sWpBkrY1uqcuJi1lw60R9D6XWcxNhBYqwb1kzXoCDrW1YH1a43oq7GWwlS/EDGjToHW9ETo+W9F31m5oWfNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ym3ilj65XKSFFbC1JC9rN4z1L61mawRdTSrvUKSzax0=;
 b=O7/8C+lByrKg7eep2qA9L/PX0JZrz98vtfB7fIq7FI18ICGQpvI/gLJELDz3ib+aIVhR9VHMn8rxdO0weGBXg4fjVC00IX8MBXrkMCake9FNbRxXmp7BI+DXjLMERrRz9//0rI+IUlzJS6XPSRRe1UofHvnR+1CnuOhBRfGyXzk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7143.namprd04.prod.outlook.com (2603:10b6:510:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 08:27:19 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:27:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 1/5] zbd: Remove cast to unsigned long long for printf
Thread-Topic: [PATCH 1/5] zbd: Remove cast to unsigned long long for printf
Thread-Index: AQHXv/jZKx37ZIKz6Uei4Q3zCRm5sKvQmEkA
Date:   Wed, 13 Oct 2021 08:27:11 +0000
Message-ID: <YWaYXjMLrTf7b2bc@x1-carbon>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
 <20211013060903.166543-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20211013060903.166543-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 699bedbc-415c-4142-547c-08d98e23415a
x-ms-traffictypediagnostic: PH0PR04MB7143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7143B6ED5640BCD87E8CE7E8F2B79@PH0PR04MB7143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ig/rNGI5xLsLnOn6L3dmJvtrq5BansU3QHqGlcTO7CYOYOafroTyKRsuAwQXPzOKfTB4WE3r0AWFBARLV7RjcSSeKUfrdd6Oxw4diFnqtaypvFsI5k3yeUhsxhHBTMeSihtXfhwiEtT8+svRZAqOaKo5VNGg2aMg/WJ91+S7jUwx/iZ8JWutn0+ybrR/kau8pTbZ/sdRHCmxQCfUjVwjAKc42Az96hZLhrSLTr/G+AHeUMUh8PC/EXzKgPyAyaNPTKpVB1+Gq4vFeretPNlDb0vvnrtAmsfu5ynQaZMOHbglalNkgJ3d0bLJ7ir6c5xK7YZ5k5qaxHLOnIf1Sw7qXBH2jeTVaZA3Pc7tTIc5lIHSsysdxOsIYXf1M4GZG17A+1yOuOcR6vg1HALLEBQW24BpAZI5IJLWYrTQNz4e2+V9f2VrrleIhRhDI3LDpbVsRNxJWtj0OoAoZ+Eo5D6OwDLFfvy6rYJozyH0yiUBtQNbJTKe79htS1fk6xw1KMLuZUph6Zzq+odexCdUicMBehylGOtAB7r1oYp8YQY8YNkIXQvCQH9tEQAJt8h86b2caYMuOMzGNLrgIo/993MCVsvNDX71uP8UutSbYVh0V2pavR9muKF6eR3ZHl2LigIrkM0PaEarFBEMJPSTbHVC/ioT4aKiymrFkMzBiyGEqnF+8RgKK4ha1a4ub2gCes8qbURwXbQ8iKAJd5N2jCvPrQuXM9u3a8ohPZp92CrNMQI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66556008)(71200400001)(66476007)(66946007)(38070700005)(91956017)(64756008)(76116006)(508600001)(6512007)(9686003)(54906003)(82960400001)(66446008)(316002)(26005)(8676002)(5660300002)(6506007)(83380400001)(8936002)(6486002)(186003)(33716001)(38100700002)(86362001)(4326008)(4744005)(6862004)(2906002)(122000001)(6636002)(223183001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GNtxJhLu4u2JpQwmMqZlNiMrvlwa8KWm823dV5RSCxAzq+FXMMuubMr+QUs4?=
 =?us-ascii?Q?v8cVc3JgoN2hBU3AZM2evkkwtZl4Nbgae5Ea6/lkFyBiZzZd+fKWFyXdq5Hl?=
 =?us-ascii?Q?yBLg4g6uN6XV6uEGSigN1Vs7FANWGy/+La4/x6oW0lm7He0z7fLZNnSWMSuc?=
 =?us-ascii?Q?glwh81YLE0rsrRPzbRY/yYuT3RGlyYG8SNVXqzcZa0HsGp0+TUMGal4cKRfJ?=
 =?us-ascii?Q?1tqg54MwdBqZXfphyuAx+lmOvKCwXd0dYlAjam3XALDZrNG4UAfyh5Z4GqGD?=
 =?us-ascii?Q?8uOA40el6fuMU+RFgDH2aFejgKzxDmC3vn8N09MvSSLRG0+oV8wRkRhSNEyM?=
 =?us-ascii?Q?bhYhICJ6+2qE5Fg7nqOTd9atByIrlTUuwmRX2X0W7vvSnwLowHC1tGz1FG2i?=
 =?us-ascii?Q?l9hJ23OZBBtdSHc994gVfqzUFo1hBblyBoufqZhf040KYNvhP8Zmw50y6UXn?=
 =?us-ascii?Q?wZ/G6fqM3w6CnKG2gB/EW6pFr05Y7vP97kODCTRcviwEH1xJw8b9swHchdVp?=
 =?us-ascii?Q?j6eQf0Qlj7YKY25S/UfP67ryZSEGSSd8CKndIBjOtriS5lvC4HFkrYKini2L?=
 =?us-ascii?Q?ByGhDNQ/TNWofgdL8HmqOuOdEemwz6tEEeC9D1Y9oxuc5awz7qdPVhUiPUEf?=
 =?us-ascii?Q?0p9SSDN4NoVZtNeR6sdm7QIO3fUrZKxvszYPqsHqo8nWb4lco2ouvj2k97iR?=
 =?us-ascii?Q?HFpzZj640VByMYi3nJ+KQZSVt/8vrUHVoDsRhF4TnVeyzyOY4ldxVRq2SrnL?=
 =?us-ascii?Q?eT9Rj/x+vVukJxDMHYxjZdJzPB55gGb2S5G6Mn03IBIlaSN0rcRrP44oZxSt?=
 =?us-ascii?Q?JDOv60IRW9sKQtDc66cZQR9++h1sLJooGztuJ8WHAM9Q0h/iOrP5yLAQpX24?=
 =?us-ascii?Q?vQo6GuS512KPgfQPdTRVfDI4pPyAq3G6YoJ03Z+NZimxiLyjQnZrxFMkXK2l?=
 =?us-ascii?Q?RJwU+xOSHr37WxH4xcQRQQbFjrd0N/JySOmfv7ZMn9oVin1Mh3NonR9BHJvq?=
 =?us-ascii?Q?UP3+8yOBIz3V63qjjmXw8sGP712PfVJj3rAOByzq9R/lrcPQk3Carcl8z8ge?=
 =?us-ascii?Q?kaWrLRfPxHD8omx0u7Vq4PhWxRArAe0nBYCY4TyXgfxeTTlbsk4Q8+tG5Ba9?=
 =?us-ascii?Q?loTfYL1Pha6wW1RrePidgObmfSkUAe1HrNOV7iTDz6a8a95k6zviLrRsRdAo?=
 =?us-ascii?Q?lqnZLebhoE2AScQuCBT3FKB9rk6dE8lnl+maA1DSnrSrwPOj2p17uGaGCc3d?=
 =?us-ascii?Q?J3wJJjaMg1aMHxGJhpLj6gMtgXy9Bj4fg0GKOzfH8aUY0Y5aEAx0PkSZAdsz?=
 =?us-ascii?Q?wn/MtUGZ65WtMC/rBC6ngr03p/ul+iYkke1Zs1JZAjLLrw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <823C447688637245BD2C4DC262B47ECF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 699bedbc-415c-4142-547c-08d98e23415a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:27:11.9511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZ7GNR9r03zmptoPhkIOiKmp00Y42Mno1YyyGuc8XiMNauzDFv3tI1ijBhQ04HGLdVY6bDMl8CnG/LYl+ahPgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7143
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Oct 13, 2021 at 03:08:59PM +0900, Shin'ichiro Kawasaki wrote:
> Many of the variables in zbd.c have type uint64_t. They are casted to
> unsigned long long and printed with printf %llu format to handle
> uint64_t types difference among architectures. This requires many
> lengthy casts to unsigned long long.
>=20
> To simplify the code, remove the casts to unsigned long long. Some of
> the casts are simply unnecessary. To remove other casts, replace the
> printf format %llu with PRIu64 so that uint64_t type difference among
> architectures is handled accordingly.
>=20
> Fio build pass of this change was confirmed with 32bit ARM cross
> compiler and 64bit x86 compiler.
>=20
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
