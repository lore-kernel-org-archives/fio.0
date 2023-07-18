Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEE7EB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 15:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjGRPqH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjGRPqG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 11:46:06 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE701AC
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 08:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689695162; x=1721231162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lvpv9kVHbxq3x8Y9tEYibQrdEbpywoGt3mNWWXYGYFU=;
  b=C5LFk2etSl3YGLXbBejNiQ+rimK+u2yAxEhVJy0Uo5I+ByM0bXaZ8Bzi
   uIVWK0hdU+LHB/D01KqUDQVrUVBzscCXeDiXUysOD0qRfuV7jh86W/xYv
   7YkEowmE73f5Vme8l3Yjwaty/K+2shf8iOFDNpNwooEZMmFI8acRtBLl/
   VWfSebimmqeaW5eURCEZ4qyHPe7+6in8swBnKarvA3+C5GQWJtbOXej8k
   eAQOf2VO2H/BSrKtm6bjjg1j5o8sSzY/xh7AvLxL5DPD0w+JJTgf7xg/e
   A9cECEIeOyoydmHF89l5x8t93A0ugpVe1BT72+EF8oONdpzLGo267G5Tv
   g==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="350390964"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 23:44:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTCbR/uWCPB5drKXhLxbYugGSMePPRyu1hlgfGK+eOBvPB7C2au9ZtHv9wlcFkgMSJLhd37RFEzhhXWbJOIbLWephv2dyQsFkr8P8wR09l+p5Gjbg8uXoDWckuAX8/fEIZzJ6/uJ2ugP4XqYdS+w9o/gR67nutuENG/c91753BfJ2WOCH0FeNH3uySbOG1QPcEfGEIdB0GD8DMvlONW6ujcu6bM9gA38qVgZMpii61cVaRMTJphUmwJ+LHp6wTtpBCDA1h9aT4NhOZyGkklfs+mFnW1HdUU9cvc7q/Ni7oD5m08rTCoyf6yrEK0LepOIOwMEiEf2abueCpKXICeuyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGIxSN74Miv3D76dVve/ciY6Pt/K+Dpf2c9RNWAM3Wg=;
 b=B0TQK3+qmBOT0DijZT3juZr88b1pJ0ryNw2LlCDMyFxUBIlIxHDDtPF143L7irQ7v/DmubwA0mJ9DVEOCzWTRf6Alqv4eh/9d/Sdv2R6gX7bzYKQPs5W8cyVNGiLB4emRL/IurzaxXObx5pNEPiIuY3whslzKJeTlbcAZkus5QWfoDitBdXcCmsZlf1s6QqwYrXuGfPogtiWUvTLfaTC5ItKQr2IBadBp2YMD3CfJxGdU7xKm/BGoFZmPdQVVU39SlOcWQbh7pL1+wBNfW0vFL6N8C1h+yuyPIJkh1J9i53DlG9jx5x/xF2TM/Et6496AaHAn+BWxppXYke+HRFLpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGIxSN74Miv3D76dVve/ciY6Pt/K+Dpf2c9RNWAM3Wg=;
 b=VJjEuZxJRhasaUEREwZBSAgnNJhxYjVVGx03OPtEgFTlPHW/uZCm1/DGzMURM+HBDlGdCs2Qd+wSYG5DSgm8aNDrIYm9SuwkY/09V5A+g/d9BqIywgVy8fGa0m4kjmW/5t01BPVZLHDqyA1kozS2C73jSZbzOhlebj4qlgCLXqk=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH2PR04MB7125.namprd04.prod.outlook.com (2603:10b6:610:a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 15:44:03 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 15:44:02 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] os-linux: add initial support for IO priority hints
Thread-Topic: [PATCH 1/4] os-linux: add initial support for IO priority hints
Thread-Index: AQHZr43kUxH3GeC0/EyoWrVtd/Y9Zq+/vjkA
Date:   Tue, 18 Jul 2023 15:44:02 +0000
Message-ID: <ZLazPl69DRY2aKwe@x1-carbon>
References: <20230705221302.430678-1-dlemoal@kernel.org>
 <20230705221302.430678-2-dlemoal@kernel.org>
In-Reply-To: <20230705221302.430678-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH2PR04MB7125:EE_
x-ms-office365-filtering-correlation-id: c8da6dbf-43bf-4b96-153d-08db87a5cf97
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RmJd3SH57jqAMIPV7hB3d8QI8tsdVYyKnSdulA+GdV5VeG1OzvrRwFTqchT1/mnMmL2egi4paue1+M11DXkEK6MYden57gllMzNSrBmX9DUR24CkirGiv4t4QFc/k1paEfR1vTZLjyngdOXaEdYYV5rzIO4tmhfFTzm7/oDc/OC+8ksCUbzwrK0TsTXp+v5oVX1GAc2GX/PUHX5rIYn9Cvbn9pOZh41FhQ1B28jaeBPxmEOtCmfZ544IqFBlM1RizTbTjCnx7hw+wmErYm6ONf+P3i5zSQ7+EsfXte9LgRNbrvWp2LWPlVujJVcvwBINPxCrtT7xAZ3de2yVifXvGbdOg+gXcjef5E1+wv96SF0fNWS6KZvtMNneQ2DUYC4QgznhHNFowzq07WoAaCJZN43AiupZopO1V7bp8gV6S1N0F1Ts6fShXif4XHRFJoS24oaaH4TQLnh4jiUQJoNmTcfMJqQkDDRsVr+zDxoiEy6M+Sf8mGpYhVrczF5JhxesAGMEq+pFlNGSX15s9M7vO6LuKJb8zixhSGY2bqfg2oEiZUxWkE1HexeRPmjumWIHjq0FvOvFF7ioSXfJAVquu0g7EKom0MfeqffryvGV5nazmpxc1C3OeFfEPVlFalCR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(66556008)(66476007)(66446008)(54906003)(64756008)(86362001)(186003)(66946007)(76116006)(4326008)(6916009)(91956017)(478600001)(41300700001)(316002)(6512007)(9686003)(6486002)(71200400001)(38100700002)(8676002)(8936002)(38070700005)(5660300002)(6506007)(26005)(83380400001)(2906002)(82960400001)(122000001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SE3M1InTNLg0BOY+3ghHhcT/bnbnUGjbmBSDMEYFQ6IE6gv0Hm6mP4y1PKni?=
 =?us-ascii?Q?9hkkeuxg30bCBlF6/SOVx12yQcgdDDZVUORbHNn7HQ4b9WadUVpDNFliPp+O?=
 =?us-ascii?Q?bYg+imsv4Bc2v2Q04sNMdCVdcbdhmk7K71lPyRuTEggwVzTJ1PeOvlkHNAz0?=
 =?us-ascii?Q?vgTSLq+JNpKkFJyL2KN6rwLdv3XGsdsg+x5QgElITRYKMAZP3n+u3PWMo3y8?=
 =?us-ascii?Q?eA35nkoAXZHNP1MeOAoTec4PAhA0HNriUc26HcWwbZN7sGLDfY7Dd2FupzQW?=
 =?us-ascii?Q?iq5d20Ryh5M/kxgesPTe60OxtYt0NJrarC6c2fqXQ39Z/LMVi9G2qrn55+aQ?=
 =?us-ascii?Q?R7adKWrziEuYOc5VSQR5QaOH59rZGzrQ+9sfJEYFd96WehIqVNYoJm07CpWs?=
 =?us-ascii?Q?bTw8/WpH96tsPxMKj9MCJeInbFotg8PPJegXuXPHWgv6xLaB5zjAKzJJI9Yt?=
 =?us-ascii?Q?mAywDtFiMFjpayBarbz1D9iHI0RlbRwx8AJ/N8jxizWdYvslqeDCuqUHpbnT?=
 =?us-ascii?Q?0WhFSEs4XnQe0hhLwe9jaBui7i1+3ojK8io5BQFXWvcDvjR8jSaBWEYTuipP?=
 =?us-ascii?Q?5eo3qxT8PkEqOLctMY3rgqFN78ioiOrenex1ekovS7IhmmcInKCoIFwDM+bF?=
 =?us-ascii?Q?qAjFUDH94cssZqnU+S5g2TYDZTo3NUsFJWm5/rR1Vqagjh1fmosKjj+GOsVG?=
 =?us-ascii?Q?1yPnH/wbWS2esIxWPAk0H7Bdn5JP+IGBuOI2BaxGND5s6EItRSqRCu7zYEum?=
 =?us-ascii?Q?zEam06USThssbNTIQeKNgHChqofNlNNBT4Yw93fYsZz/AjwSM5AdUR6r14Fn?=
 =?us-ascii?Q?lO+fZ6kqoh0OqjnE+9j3i1Ukjt76lXxHM4EwrqijGOc0yE/hXbU+0Rujk6Fs?=
 =?us-ascii?Q?ec504jQPW/DQNAsOj3HwFYmRVnRJBkzWvZ7fxzuRBdbRqmnG6L9klGo0ytvv?=
 =?us-ascii?Q?RkiqG2bDxbLAvEMUREwfnHFnyZuCC8ZR7luKSOMt2OLE042GTRKbcYgMGkY9?=
 =?us-ascii?Q?cuxb/8/m+SEpXpmQqhWTMz+1/WVWP31UAQpwaVVW/EHU8EMLZMZO0feq64az?=
 =?us-ascii?Q?9iYEPmPkqBS50HK+1GSRwUiVeQqAvKwGE9rw2eNPgFlTsTCmrYN53XA/UaY5?=
 =?us-ascii?Q?68T3Z6VXfuN9bWfAAIra6fHsBy4P6W8rntqYFbiXSPz3piO2QqTX+L51K81L?=
 =?us-ascii?Q?thv6JYpCTYk/kScuTxlmzE9LqGTB7kwgi/0tI+c8AWuWx2PDjRqE1pv828pQ?=
 =?us-ascii?Q?vjQb9WMu/1Bc8IFoJDJFqfGBOGIdz2TYVo/fnpJsrF2NhYP68AZ/bp53moba?=
 =?us-ascii?Q?eXHGuWltxr6WnpUkEwA92FuO+1sVde7khlgFziFQhv1rOg61qc7NhyELTR7B?=
 =?us-ascii?Q?zvRQuuheSDhHKPXTSx9MFY+UyxkE8OjNMM5wNhFcI1jMh/kSIcafGJtcraix?=
 =?us-ascii?Q?pbRs2bNY+H8CUXpd+P2Rc4jiylTHrUZM/EIkhZh74S6Moc2cDaYm4OVgymMx?=
 =?us-ascii?Q?ViKw+8B6Q+rDPtGWQ8Oirzd1tdr0XppKW+r9BZ0euLPV0tTRfycxsCLRgA0q?=
 =?us-ascii?Q?VHOcWqZywPTJWQmrBTji3R9VLsTgZayeFrUl6C8ncnSLSVy2vAMTtUd486M9?=
 =?us-ascii?Q?8g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E5302BA3A761E4DBE4C1514BEEAD307@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CjzesA4ke1iyUSf0f9njUL0Q78W64Var0HeRtAGnc720MOn7NRnVkB5l3Q5fYIOIpIo38MBIOSdTcnNuBlg8+I0nY0YBuEVuQrMMQP7drJeU0KYwPf0TzY3pEJs/zNOVxEFjq0rLKvgpom60lwXLRkXiUHpph8I9fioFjr9tbs+qyDcOy48SzFCvRkiJ1YG3iaei1o29x6PPHNO4/lOU6ttZR/YBxYGvHdCLCxU1RT4cgg03mqV+bTyhMa32gKGUrQFaX0t3i7YAnpjR0HxDQmx6I/Zu43PdKhg0yAx4NNQ3HaWqkMRvuBfhzk0GKoITZ4ZVhzzeAux0ChxZob6EYr+spinrbWQC+WJAsJuVkMOWAo6vIYt0P2bVhx94/0PGBlrWDUJBVxrqpT1PbqJrYKqkU3tXayS9NzuwS9Crb+X8kbymNJLEIbU/2zRzgenUOhKCcRRh48me+fIkEgioMAyuzkfh3bq2VWQtwVvXmYVhbvz5PZ7Eg778lT9ZKOi1MovDxi7QFqGWNIMcjsoKejJerhR++ar3uxOxsuQP6U4OYgJIgEfgwOgVoiXGVA9Mb92tUjEPUWKaoJNwh8UV5nfG1473nRge1ew/7B1Px+7NBL/Be0VphiTUZgmZGR2sVOJOQIMfqwnocXwWNQWf8zYdOj48dPLwZJSSJ8GQS6i1Q4D4Ecbox3zb3tOb3mxbn8RsFOKsFH/F8WegChoo8CDPDRaMSq94A0Z1MPLL3+T5sOBYD/4KaVT+rnm08at4XXN6ME9Dw233v72hS83cbwOziMcndr8hKfGdG/iceCkK+YUhLjHP1ZTr908js8+YwxwzJcpgcahz7DhRpeA8VpdwMwfEhCfh33RklqoCshk=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8da6dbf-43bf-4b96-153d-08db87a5cf97
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 15:44:02.5160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pZ8EL2b0RILHlDXq+//ZCPpNtxGPiHTq+6alVNuFkPFe+C8NiiLOWAwcAIaerZOmvVRS4N+puDsl+Vs+AlqOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7125
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jul 06, 2023 at 07:12:59AM +0900, Damien Le Moal wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
> Add initial support for Linux to allow specifying a hint for any
> priority value. With this change, a priority value becomes the
> combination of a priority class, a priority level and a hint.
> The generic os.h ioprio manipulation macros, as well as the
> os-dragonfly.h ioprio manipulation macros  are modified to ignore this
> hint.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  backend.c         |  5 +++--
>  engines/cmdprio.c |  4 ++--
>  options.c         |  2 +-
>  os/os-dragonfly.h |  4 ++--
>  os/os-linux.h     | 17 +++++++++++++----
>  os/os.h           |  4 ++--
>  6 files changed, 23 insertions(+), 13 deletions(-)
>=20
> diff --git a/backend.c b/backend.c
> index d67a4a07..6641441c 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1791,12 +1791,13 @@ static void *thread_main(void *data)
>  	/* ioprio_set() has to be done before td_io_init() */
>  	if (fio_option_is_set(o, ioprio) ||
>  	    fio_option_is_set(o, ioprio_class)) {
> -		ret =3D ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
> +		ret =3D ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class,
> +				 o->ioprio, 0);
>  		if (ret =3D=3D -1) {
>  			td_verror(td, errno, "ioprio_set");
>  			goto err;
>  		}
> -		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio);
> +		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio, 0);
>  		td->ts.ioprio =3D td->ioprio;
>  	}
> =20
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 979a81b6..e6ff1fc2 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -342,7 +342,7 @@ static int fio_cmdprio_gen_perc(struct thread_data *t=
d, struct cmdprio *cmdprio)
>  		prio =3D &cmdprio->perc_entry[ddir];
>  		prio->perc =3D options->percentage[ddir];
>  		prio->prio =3D ioprio_value(options->class[ddir],
> -					  options->level[ddir]);
> +					  options->level[ddir], 0);
>  		assign_clat_prio_index(prio, &values[ddir]);
> =20
>  		ret =3D init_ts_clat_prio(ts, ddir, &values[ddir]);
> @@ -400,7 +400,7 @@ static int fio_cmdprio_parse_and_gen_bssplit(struct t=
hread_data *td,
>  			goto err;
> =20
>  		implicit_cmdprio =3D ioprio_value(options->class[ddir],
> -						options->level[ddir]);
> +						options->level[ddir], 0);
> =20
>  		ret =3D fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
>  						       &parse_res[ddir],
> diff --git a/options.c b/options.c
> index a7c4ef6e..c5343d4b 100644
> --- a/options.c
> +++ b/options.c
> @@ -344,7 +344,7 @@ static int parse_cmdprio_bssplit_entry(struct thread_=
options *o,
>  	case 4: /* bs/perc/class/level case */
>  		class =3D min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
>  		level =3D min(level, (unsigned int) IOPRIO_MAX_PRIO);
> -		entry->prio =3D ioprio_value(class, level);
> +		entry->prio =3D ioprio_value(class, level, 0);
>  		break;
>  	default:
>  		log_err("fio: invalid cmdprio_bssplit format\n");
> diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
> index bde39101..4ce72539 100644
> --- a/os/os-dragonfly.h
> +++ b/os/os-dragonfly.h
> @@ -171,8 +171,8 @@ static inline int fio_getaffinity(int pid, os_cpu_mas=
k_t *mask)
>   * ioprio_set() with 4 arguments, so define fio's ioprio_set() as a macr=
o.
>   * Note that there is no idea of class within ioprio_set(2) unlike Linux=
.
>   */
> -#define ioprio_value(ioprio_class, ioprio)	(ioprio)
> -#define ioprio_set(which, who, ioprio_class, ioprio)	\
> +#define ioprio_value(ioprio_class, ioprio, ioprio_hint)	(ioprio)
> +#define ioprio_set(which, who, ioprio_class, ioprio, ioprio_hint)	\
>  	ioprio_set(which, who, ioprio)
> =20
>  #define ioprio(ioprio)		(ioprio)
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 2f9f7e79..6f241d09 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -125,13 +125,19 @@ enum {
>  #define IOPRIO_BITS		16
>  #define IOPRIO_CLASS_SHIFT	13
> =20
> +#define IOPRIO_HINT_BITS	10
> +#define IOPRIO_HINT_SHIFT	3
> +
>  #define IOPRIO_MIN_PRIO		0	/* highest priority */
>  #define IOPRIO_MAX_PRIO		7	/* lowest priority */
> =20
>  #define IOPRIO_MIN_PRIO_CLASS	0
>  #define IOPRIO_MAX_PRIO_CLASS	3
> =20
> -static inline int ioprio_value(int ioprio_class, int ioprio)
> +#define IOPRIO_MIN_PRIO_HINT	0
> +#define IOPRIO_MAX_PRIO_HINT	((1 << IOPRIO_HINT_BITS) - 1)
> +
> +static inline int ioprio_value(int ioprio_class, int ioprio, int ioprio_=
hint)
>  {
>  	/*
>  	 * If no class is set, assume BE
> @@ -139,7 +145,9 @@ static inline int ioprio_value(int ioprio_class, int =
ioprio)
>          if (!ioprio_class)
>                  ioprio_class =3D IOPRIO_CLASS_BE;
> =20
> -	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
> +	return (ioprio_class << IOPRIO_CLASS_SHIFT) |
> +		(ioprio_hint << IOPRIO_HINT_SHIFT) |
> +		ioprio;
>  }
> =20
>  static inline bool ioprio_value_is_class_rt(unsigned int priority)
> @@ -147,10 +155,11 @@ static inline bool ioprio_value_is_class_rt(unsigne=
d int priority)
>  	return (priority >> IOPRIO_CLASS_SHIFT) =3D=3D IOPRIO_CLASS_RT;
>  }
> =20
> -static inline int ioprio_set(int which, int who, int ioprio_class, int i=
oprio)
> +static inline int ioprio_set(int which, int who, int ioprio_class, int i=
oprio,
> +			     int ioprio_hint)
>  {
>  	return syscall(__NR_ioprio_set, which, who,
> -		       ioprio_value(ioprio_class, ioprio));
> +		       ioprio_value(ioprio_class, ioprio, ioprio_hint));
>  }
> =20
>  #define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
> diff --git a/os/os.h b/os/os.h
> index 036fc233..2217d5f8 100644
> --- a/os/os.h
> +++ b/os/os.h
> @@ -122,9 +122,9 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsign=
ed int cpu);
>  #define IOPRIO_MAX_PRIO_CLASS		0
>  #endif
>  #ifndef FIO_HAVE_IOPRIO
> -#define ioprio_value(prioclass, prio)	(0)
> +#define ioprio_value(prioclass, prio, priohint)	(0)
>  #define ioprio(ioprio)			0
> -#define ioprio_set(which, who, prioclass, prio)	(0)
> +#define ioprio_set(which, who, prioclass, prio, priohint) (0)
>  #define IOPRIO_MIN_PRIO			0
>  #define IOPRIO_MAX_PRIO			0
>  #endif
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
