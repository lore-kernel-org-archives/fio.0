Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D689EB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 15:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjGRPt2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjGRPt1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 11:49:27 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C4A9
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 08:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689695366; x=1721231366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BS73hcLuAgCQAYjvKPA+MsHZIbfqwQL+UWVFZH0O8Ag=;
  b=gmrgI7xnhBv9kiwlGI8Fcg9ZvG4NRpEXluZR9V5Qf+w55NE/Jrw5miR5
   TFdE4kdNG4nZ2jCF86sNT6zjep1X/R4dwQ/0eIDzDYmZfZ6ejmgPJXGhm
   ucBqZkfAz6sLdoZChjcG8lbU+NKsT/MIoHGjV7M3KKVBCR5KvE+wJXmO2
   ximvzpxyuaDgc+7OlNs5/M3I30dCHRWquRovDqWMBtHeO3I+bfK28DZW0
   xKa11aBJs6iECa7OGysHCMleuPtBA8ts4FidkQMWQlUY+ckzd5Syf03mj
   A6ayo9r7Jr2zeHhdYzPmJVv0CsJXP86PgIQLHK3OGTrEb2lZKBl+aX7Mr
   g==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="238782326"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 23:44:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jzqj5FiU92dFd5Wbw80IznFyAovL9KtV0m+w9s0NkquXOiZCHOTT9CTgUJGU0D47o7cOFnEufN3vLnl9Ca13+tKyKOjKEZPjBokTFOGHC5ov337NFE581w6uR3j81qL4812VLjlcnBdt2hTCsWxY0gwWR3dGF7KlbHgJr2LqFWjpVmp/uCPZnFMK8GoQCTFfSfInNuMJJV5Gjr8czsamYEfjTR1qmFT/8Ss4rY1HAkSPoygqrQRWq4itPvsx5X1UberEwolWKlfnsw1+rNb+ip+NyAV2JU5vh3uu50iBDynLE2PzSkcRonc33IHheBLUcsLFM38b4jnJrwb2AtJVgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ji939JcOO61+AaUYGjkzoGBWXHB6ugNoFPWDVxvniC4=;
 b=REVpStgPP3dLNjevlTfWMWJsFmFDrfKJRXTd/VFRGjvOG2A3v6emnMdrYzY3a7SV2kxBQZ6xHKDRszcVD+UILWUv4yimPY48TlNyYQjekKhxoJe4KhzG3mP+ZUA0ndy9/+DXPZVnHqd9wT1npo1/gk3RLw8TlwRnawi9GpbaId+JnV3JzNDNtTYDJa5rAa86Hpmslwy2amCMn9BLWIkVKO/6m8sDexCivKUukKfjuo8NWRUmB/ObalP1An4G6sTp1+1LaRS51DzLSWikdkL5e7r9CwhJu/XNv217J4xiEVj6kr4hp6UGXEpPT9B5OhTVM6Uvlt/YgdB1jdbyz/foMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ji939JcOO61+AaUYGjkzoGBWXHB6ugNoFPWDVxvniC4=;
 b=agxG1QFTJ5VHHYQJTuqFJ8FXsDeQxLdacAuSBBv+evNeh+7Okhp+HPEVzX1RmDemqrkk9GeYp6ybgdSpnunxeA1ynv0QAe/vsL/7PW1t183+C00XLPT3jnHDzUwrf7wOk0JNWK3Jqzh9R0mWGoVOxCFPp5XOcQl/gC4wrHLxODc=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH2PR04MB7125.namprd04.prod.outlook.com (2603:10b6:610:a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 15:44:56 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 15:44:56 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] options: add priohint option
Thread-Topic: [PATCH 2/4] options: add priohint option
Thread-Index: AQHZr43llv444ficRk+b8nXd3uA3Ga+/vniA
Date:   Tue, 18 Jul 2023 15:44:56 +0000
Message-ID: <ZLazc49iA5LXU3bi@x1-carbon>
References: <20230705221302.430678-1-dlemoal@kernel.org>
 <20230705221302.430678-3-dlemoal@kernel.org>
In-Reply-To: <20230705221302.430678-3-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH2PR04MB7125:EE_
x-ms-office365-filtering-correlation-id: 16ac5b2e-a41b-47f6-cb97-08db87a5ef9d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UKEZJ3Wthr6G2rZ0VVrgGbURxqVTcmtKVBhIHr/tktJ/MpF6Um+GgI0VgHhiQv6b3FCtQM/XyvddCf1cLMdu3X9RQn/HZvl8oAvJkeI8BVWTubXVDja8MjZ/qN0+4tUh/kARQfuKWFsAfccHm2cKaZ1XiT5ejM94OvRcjfmGvRasw7fwc85N45PgdOdMC9zNy+7wk78WchxD32+gVgrbu3Qj9BLugt9pyT4/nxZFfq6wznvrO590AlydAmvcYVyjM+hNU9lK619IxI+8kUR/AnYZG+DzRTZXCpKuHsO5pBFxpogr9IkdJUfg1guLyrTai9vdYMgihnZW9jhDA1yASlGjwAyszJvHGzfx2iMB/11KF1JDzo0SWt1JrjtuexIlRUy+1YRnMBQOrk3NS2LWVWikpv0QQzRRfIBzBDrFjqKJDGW2Zn+RjtIo6H+An3ZKLu8iQPm6Xpu61/6IGQ2mLy8G4ZHj5N6bdg4IMN+/JN1388J2+XUbm5XtO+G7qhNwHdpxsDRCSdIJtXh2/7jPjMTzH0h2v57N8GhCC3qNtcRyQpVOC4wt3izVGkWbZUE4TRs01hN20s8+bi1kF+5UVC55byM7AP5iJuxoSGA0b/0NNfXMTWFs1TVe/fGqo/0m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(66556008)(66476007)(66446008)(54906003)(64756008)(86362001)(186003)(66946007)(76116006)(4326008)(6916009)(91956017)(478600001)(41300700001)(316002)(6512007)(9686003)(6486002)(71200400001)(38100700002)(8676002)(8936002)(38070700005)(5660300002)(6506007)(26005)(83380400001)(2906002)(82960400001)(122000001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2RKqiAn8Wf8h0Rmd1+4hhEvvsT5+N8czCebdi8SUWuuPsHDWpgNoVkUaHcuE?=
 =?us-ascii?Q?VJTJLp5Uoae/cJTnht14FaETzrGOxj1C0MPh5aZPmEQ1GadoM3E8LYXbznGU?=
 =?us-ascii?Q?zcjTQ2E9AHayybnuB6zuYzq7Q5RC1leS4MFutWYVtXAPgEfoFRwY8nnovLiR?=
 =?us-ascii?Q?bspTvIw08hxzbfsU0tdz57kwHMlsTj4dzNuOwEwq0UNJootIWBHQQ392BGMp?=
 =?us-ascii?Q?6BZP9SWmF3hJFUIQ5VvDgeg+ccutAQS3nZLirPN5m9XFlFDAlgh8y++t/K1V?=
 =?us-ascii?Q?OHr7BGQt5TFex1KHQ5Lcigihv6oATm3N7SqoJH/iJheCCh196IQE8hncslDe?=
 =?us-ascii?Q?BFe8yQM0ELc54OF9hNoGVh4zlcJNgDmgC3Z+L+Dk8lz6DfipqtXpWK0awlla?=
 =?us-ascii?Q?YA8ZGC3KCx5qA7N54/5BigJizKDRezuvfsryjZ1QJkdta51fgxpKwCpcDN1D?=
 =?us-ascii?Q?91X6vb2KhY7jVgeu290TEbVNYj6GzoKut9b35A43VqaKUxu64CpcCtknuNm5?=
 =?us-ascii?Q?j6YicN71n9aAPnq/YMrr4mQ3C/iVFkjjr5AKsMnJUhLwvpSl3N6mkDYS09Fe?=
 =?us-ascii?Q?UiFQGiKH1oCDNQA67EVaEQFPJlYC7x8yFDuAISw8OQmADnPtTQBsKdXVkpMW?=
 =?us-ascii?Q?5p9sKQ4x02Br5SB2MFw8YUxIQNy0+uQ7ZmwDQo4mYq1zrw+J/QpoaeAOn05n?=
 =?us-ascii?Q?RCkXQ1nnypFHvHUskSIuKxsSg1yxKsKbM0Nmq3yEmyMVXh0a5IxkzYAJ85P6?=
 =?us-ascii?Q?fcE+sruk/0MRKurvRIfnPSq3ef8ocLEznsNYUpOyB2oh6hhXg64Xir3S9JLd?=
 =?us-ascii?Q?+XYjR2U81j/Fimz0eWPTVktBiZqMB3xetMI5NfcjXXBfTZJqCPW0lmmUMpST?=
 =?us-ascii?Q?6V2rk5pZFr3ZK1nLXbLVOz9dOjW9Ef16wBnWDxAurJrhlGnKmLbcQyryY7wD?=
 =?us-ascii?Q?UU4xI+OWBkYmEiVNvPIawuTzXs3l/BO2KfsgNyIb8JODgpPrCFgDuHHRkwdX?=
 =?us-ascii?Q?hxOtNKOuX9vpksNZELyU/lPPkb/amCxkoDGCVEGZY7qXemFG3oXb3JapVXL9?=
 =?us-ascii?Q?4LPXqYrm58Hx5WMMLV5dki9pdB0/5FUKTtPqJ5nrDrVKNcit8rJ/YuswJkQ6?=
 =?us-ascii?Q?SFIt/RyMVaCRE+GoXh8Zq9cNPX5030rBM0KC7kdvJh8q2k3iMpy0zxFuIyyR?=
 =?us-ascii?Q?0XH8AKNPHNy7xWxMWtaBNoqJlcw6LJuBBxJJS7Cb584GBHOImEUd7EMX/KEO?=
 =?us-ascii?Q?plgYWncuo3UxApghX9Jy6jInPeVCjj24NtabI9lUjnN6jdt7WoEflhbQD0aO?=
 =?us-ascii?Q?OjQEZiZU4kJ/JlcwSdyJt89I6+juWmBAFhwTjY/vlIRMsaUY0U3g1UpeSgSY?=
 =?us-ascii?Q?NyHYM/F/EG5fyNPbMiGNsDzGn9M1V/sGlhqnz6a6zLmFLatbRFmcUR+kiNTV?=
 =?us-ascii?Q?SHO5nZ+yglXBxfKkPxE8JF5dTIuStUHgjGvA1DeONScbQ4SMBgJyw0vMgL4x?=
 =?us-ascii?Q?KpVRNWnZkqBnKQz/Xlk4RuCT/OtAPAatxnlZgF83Vdi8fPZn11HY2oCMU6rd?=
 =?us-ascii?Q?OaKaeDBwqGF76hXDjSNtEdZFYsOunNh3SCIzIeIUtM6miux9tW9AxTYYpxPK?=
 =?us-ascii?Q?iA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5BCC44FA9AC7B41B17DDC58D0DB4AF1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VO1lWkjoy8RHPEGu+BqzfSZN8sCkVq+Q+p7X2xzcvniknyph6MmyBuu0g1IWkQILsDuSbwvaI0g6sj7FbfMfY3FgUteVfQ/ibjmQuAhrqM4RfPxbtAKCWQO+qdRitbX5arvli8zNKFFqrFWO5lj3hsCtpLfFpPlmZ16zhkRj4R9TYqgF1mdjZHJ7v+95QhS1n/TGw6YOkFw4Kg2XkaQU9v9J9sQIJMJw3wb038Rqu/O6JJIsgQrrQ1+sobbawa7aGRJE7t6jVEUzotf24EiuASlonM7wW2rG0gqACef1nUIxS/VnHWbjmAw7c8oqdbl75G1yEaetdeVqEiRItdfWk2WOlRCPEz4x1Bfeo8Rt01S4OWsdcyCa8TSe4GPVaxvX7Sp3qBeixv4mtJZ+lAY9nSnkS38fRuFaON9kRVZAbj26Q4OQHb9SSW+Qx+8vmL953nQZiMOBCwR/ICdKRuzfeQeRyBDcNs8ck3lVfQgNWo6n/Ng3h+laLZWXLqHBWZSTd+2VgTGQvsqMcX8YItkuHwRhskOrgXTrb91mnrKAqXJwg+I6XG9A2AHtETjGLP5HMO9g7f68Z4RmdmuuiNc1lyM0GmVxS3BVKnPQPwL5hOG1D9kXOBA0eqEUFqaWyZerhrjpIuRrmqO0QwZUaCWmEAcptW9UnrKHW7S7R0YmPES2UbeGuDc+7p615/vPghe2Zvb2mqTLLHeArPQqWDdWK3eeGR99dMYJo2d6TbZIJGLiS+2JbJeCvwCOGFaOWcMN+jvzsGIimD/AQn8FSiHuVDMUWkBEJJUhTC5ggQQPNgXoU17nGiMWfkU2CParOJx2c+kSP3cSMO0rgxZU5Pmk+8k38x/PMBk3k85Tc9Qumfk=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ac5b2e-a41b-47f6-cb97-08db87a5ef9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 15:44:56.2275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zsCPhjyKHl3LhSIto3lNLWlRiYrDbvzWV+L/ZIYD0TcucIrCUqeupqBZxogv2vTUNZ3mUwBcPzO2YI/684iVpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7125
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jul 06, 2023 at 07:13:00AM +0900, Damien Le Moal wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
> Introduce the new option priohint to allow a user to specify an I/O
> priority hint applying to all IOs issued by a job.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  HOWTO.rst        |  6 ++++++
>  backend.c        |  8 +++++---
>  cconv.c          |  2 ++
>  fio.1            |  4 ++++
>  options.c        | 18 ++++++++++++++++++
>  thread_options.h |  3 ++-
>  6 files changed, 37 insertions(+), 4 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 2e1e55c2..359d606b 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -3409,6 +3409,12 @@ Threads, processes and job synchronization
>  	priority setting, see I/O engine specific :option:`cmdprio_percentage`
>  	and :option:`cmdprio_class` options.
> =20
> +.. option:: priohint=3Dint
> +
> +	Set the I/O priority hint. See man :manpage:`ionice(1)`. For per-comman=
d
> +	priority setting, see the I/O engine specific :option:`cmdprio_hint`
> +	option.
> +
>  .. option:: cpus_allowed=3Dstr
> =20
>  	Controls the same options as :option:`cpumask`, but accepts a textual
> diff --git a/backend.c b/backend.c
> index 6641441c..8e7bb70d 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1790,14 +1790,16 @@ static void *thread_main(void *data)
> =20
>  	/* ioprio_set() has to be done before td_io_init() */
>  	if (fio_option_is_set(o, ioprio) ||
> -	    fio_option_is_set(o, ioprio_class)) {
> +	    fio_option_is_set(o, ioprio_class) ||
> +	    fio_option_is_set(o, ioprio_hint)) {
>  		ret =3D ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class,
> -				 o->ioprio, 0);
> +				 o->ioprio, o->ioprio_hint);
>  		if (ret =3D=3D -1) {
>  			td_verror(td, errno, "ioprio_set");
>  			goto err;
>  		}
> -		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio, 0);
> +		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio,
> +					  o->ioprio_hint);
>  		td->ts.ioprio =3D td->ioprio;
>  	}
> =20
> diff --git a/cconv.c b/cconv.c
> index 9095d519..9ad8d6bb 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -281,6 +281,7 @@ int convert_thread_options_to_cpu(struct thread_optio=
ns *o,
>  	o->nice =3D le32_to_cpu(top->nice);
>  	o->ioprio =3D le32_to_cpu(top->ioprio);
>  	o->ioprio_class =3D le32_to_cpu(top->ioprio_class);
> +	o->ioprio_hint =3D le32_to_cpu(top->ioprio_hint);
>  	o->file_service_type =3D le32_to_cpu(top->file_service_type);
>  	o->group_reporting =3D le32_to_cpu(top->group_reporting);
>  	o->stats =3D le32_to_cpu(top->stats);
> @@ -495,6 +496,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,
>  	top->nice =3D cpu_to_le32(o->nice);
>  	top->ioprio =3D cpu_to_le32(o->ioprio);
>  	top->ioprio_class =3D cpu_to_le32(o->ioprio_class);
> +	top->ioprio_hint =3D cpu_to_le32(o->ioprio_hint);

1)
When updating cconv.c I think you also need to bump FIO_SERVER_VER.


>  	top->file_service_type =3D cpu_to_le32(o->file_service_type);
>  	top->group_reporting =3D cpu_to_le32(o->group_reporting);
>  	top->stats =3D cpu_to_le32(o->stats);
> diff --git a/fio.1 b/fio.1
> index 73b7e8c9..6dbdb293 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -3116,6 +3116,10 @@ Set the I/O priority class. See man \fBionice\fR\|=
(1). For per-command
>  priority setting, see the I/O engine specific `cmdprio_percentage` and
>  `cmdprio_class` options.
>  .TP
> +.BI priohint \fR=3D\fPint
> +Set the I/O priority hint. See man \fBionice\fR\|(1). For per-command
> +priority setting, see the I/O engine specific `cmdprio_hint` option.

2)
Nit: 'cmdprio_hint' is introduced in a later patch series, so it feels
a bit premature to mention it in this patch series.


> +.TP
>  .BI cpus_allowed \fR=3D\fPstr
>  Controls the same options as \fBcpumask\fR, but accepts a textual
>  specification of the permitted CPUs instead and CPUs are indexed from 0.=
 So
> diff --git a/options.c b/options.c
> index c5343d4b..c1246297 100644
> --- a/options.c
> +++ b/options.c
> @@ -3786,6 +3786,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
>  		.category =3D FIO_OPT_C_GENERAL,
>  		.group	=3D FIO_OPT_G_CRED,
>  	},
> +	{
> +		.name	=3D "priohint",
> +		.lname	=3D "I/O nice priority hint",
> +		.type	=3D FIO_OPT_INT,
> +		.off1	=3D offsetof(struct thread_options, ioprio_hint),
> +		.help	=3D "Set job IO priority hint",
> +		.minval	=3D IOPRIO_MIN_PRIO_HINT,
> +		.maxval	=3D IOPRIO_MAX_PRIO_HINT,
> +		.interval =3D 1,
> +		.category =3D FIO_OPT_C_GENERAL,
> +		.group	=3D FIO_OPT_G_CRED,
> +	},
>  #else
>  	{
>  		.name	=3D "prioclass",
> @@ -3793,6 +3805,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
>  		.type	=3D FIO_OPT_UNSUPPORTED,
>  		.help	=3D "Your platform does not support IO priority classes",
>  	},
> +	{
> +		.name	=3D "priohint",
> +		.lname	=3D "I/O nice priority hint",
> +		.type	=3D FIO_OPT_UNSUPPORTED,
> +		.help	=3D "Your platform does not support IO priority hints",
> +	},
>  #endif
>  	{
>  		.name	=3D "thinktime",
> diff --git a/thread_options.h b/thread_options.h
> index a24ebee6..4fb72651 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -248,6 +248,7 @@ struct thread_options {
>  	unsigned int nice;
>  	unsigned int ioprio;
>  	unsigned int ioprio_class;
> +	unsigned int ioprio_hint;
>  	unsigned int file_service_type;
>  	unsigned int group_reporting;
>  	unsigned int stats;
> @@ -567,6 +568,7 @@ struct thread_options_pack {
>  	uint32_t nice;
>  	uint32_t ioprio;
>  	uint32_t ioprio_class;
> +	uint32_t ioprio_hint;
>  	uint32_t file_service_type;
>  	uint32_t group_reporting;
>  	uint32_t stats;
> @@ -600,7 +602,6 @@ struct thread_options_pack {
>  	uint32_t lat_percentiles;
>  	uint32_t slat_percentiles;
>  	uint32_t percentile_precision;
> -	uint32_t pad5;
>  	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
> =20
>  	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
> --=20
> 2.41.0
>=20

With the two nits fixed:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
