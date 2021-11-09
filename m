Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443E9C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 10:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D84261151
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 10:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241966AbhKIKp4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 05:45:56 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31410 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241763AbhKIKpz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 05:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636454590; x=1667990590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X0mchv16/OvcHkH85vAXfelNQqCpxuIMXwuDVr/yG5E=;
  b=f3Eb8XJxJPmvIoaR0A0c0Mu1KtK0WArrs35r20U8nPybqEvtXRGQA0vQ
   zqo3wdryjB38D15IMB52XOeejHdzZX8t90JkGKHh1Gw3dcFK44xL8vZfe
   9d2EsEpRL1ARBfJ7Mn9x10LlR7LIxGAtXM170v2z03sKDbh5REHNAtk5L
   +Inr/yY7qsmh+Jmtau2Wsy8UbozlQ+vCB971X7TdttEILYOO2hFuyNiX6
   iU4YNulIU72x13SZ9GVPUf3LZfQfFLbBknDsVyaDJ9A1tQNzsvgWBn3Vk
   A9YA68yG3uEisuun9Yw+Fx3dzkyE+nJdsKLM038xNKL8ITRozKnP3qaUe
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,220,1631548800"; 
   d="scan'208";a="186105610"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 18:43:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ga9+CalrCPWSMce1VPPwT182sU9PRRL6p3k/ROS99eTdCod9PjlDHMacqUHhYJ1b+90SfpNssJR/2tzIeGrRT13HMyHgU1dEriHenHxtkiqScxeu2C2QUnG7uFG+SDfzSBo2hR+I/y5DACKxxsYl8Z2zGHE+U5S4R0M9A68G0mMSEcLvKHpW7guMVM+yYN/A00YeHFa7JBD9JV2ztSHHq4zc/VUnX7SN1+Q4Ds8lul5Tb09N0Z2nw3Zy1iI2776KXjzcr8vAQWq0dT/HhswP0NlzfKv3FE9SYXSn+gdFYh4URBk7EJ3lUm+Sr9EWxS4N/hWb74pe1W9D7tde5R5XeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FueSzBatIemoDbU0P8hlj/xQmBl2qBadLR195o7Tlks=;
 b=MW5cVohA29rk4swMJrgbQlPeXAZYyyKnBz+r1MtPv3m29W82yDrj6PNy73TpZKMh3dnsf7XHMGlZ0vGzlzaC4fDhQMJhK/EQwIbvtzPQpKQPiZVisqjxC7JXV6WljjOiJPlyGSV/6AAIXqHZhZsLqz3Rqg+OZE07bpE4g6+tu9uXsZX0UxQvO+B5GpsO3x84gqpXqmJ8lne9nIaOkGfa6ucUwgMWW1Ejsmr2lsyltO9Kp8CGxiVX+7Hz2pYC4Rkn5AjpPLgQa3M/QCXIMKM//aY9LhJ61DoXLHvpA8o/RCTCrDdw80UT8JCYVOLAq9ZyZhO6xAleFP6RnBPTSsfU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FueSzBatIemoDbU0P8hlj/xQmBl2qBadLR195o7Tlks=;
 b=p4tg6z7CIbGnpL/2Df3OQGQPTZflNW/GtdvOrUezFm46JXr2oe2tznJlGK2+dfWYhN2dyTtIbkG2do/bSY5/S3e2nWa3GIVZhB2OPl8zlHdkfJmG+diMZM2e6nhMSDCU5YoI250xsS+ldl3pJuPSSbzMycO9pULrY4AsiegxZQk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 10:43:05 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 10:43:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: [PATCH 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Thread-Topic: [PATCH 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Thread-Index: AQHX1QCvZQ5YXoVsmU6L24MMBmBx/qv6vE+AgABG1IA=
Date:   Tue, 9 Nov 2021 10:43:04 +0000
Message-ID: <YYpQt46J14XQr2pY@x1-carbon>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-7-Niklas.Cassel@wdc.com>
 <c3f0c6f5-8df7-98c2-1728-49d75f0f2839@opensource.wdc.com>
In-Reply-To: <c3f0c6f5-8df7-98c2-1728-49d75f0f2839@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: opensource.wdc.com; dkim=none (message not signed)
 header.d=none;opensource.wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88e21ed2-1f61-4371-093c-08d9a36db60f
x-ms-traffictypediagnostic: PH0PR04MB7605:
x-microsoft-antispam-prvs: <PH0PR04MB7605E5DE17FA1134A56D7729F2929@PH0PR04MB7605.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGiN/8eVC5xxDivd2JCZ2yXz+2fkP6cMIv4xFB7IaEjBWBgu3Sq/RdQC/6tsvRyj53D8VouqppyLdiTTm/P+QfRjGnI41C69yZAPfUTvvYC8wJ9lkikRfMr7RtdKo371wWjuYOxwDYAcQoUE4mCSc8zRHzjTkAYm6zkpsbss4/hR5jOYH45tK2Z3BaWq+JzRshVkmClwDIMXjdk9ZeRcia0cMu6tzzM0FGbJkjHg0bhZ5JQ/YDC+00K5QCVMQ7Y+sSiJgemQ/LhAlQ4vVOU13IHbr8qGsKCE51M20C861Gh5FWLYcn0hH8DiWnzKN+DOXy/MYEi2GV/x0btQdbGXBJ0RkccRPH5KkNwJ6vpDO4epocF9Il7FJbbsF53dbPWoYitUfv3SxLeWz+sMyV3fayu0V5er/ll3fWxq65C/NNIDu8YWvDdLemMEa1t8lN9fcXv4fcSXnC+VTVA8xAXfMzgvMruv+MidtReUm/s2emKuBEFpM4Wa5mIqOuEdvKGi9/DqntikZlk8bO/jjqtZV1E/XqEbAm8FnG4tjZ86a0NGHlydqhyYpG1OJZYHUhsZPhmz+75BUc020aHwFzBCg0fyHmflg73yfrITBHD1bkY6VJMEjyutM7hSaZAsxM57IsSsQUHmbEC4ZDXehD631uD7c8AXM6HG6nVl0L3x64aBqDMlJx5cbcdyz6rqYTMtohnIvndpa0vOMlKFulxvWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(2906002)(6862004)(54906003)(122000001)(26005)(186003)(83380400001)(4326008)(38070700005)(6512007)(53546011)(6506007)(5660300002)(316002)(8936002)(6486002)(82960400001)(33716001)(76116006)(508600001)(38100700002)(91956017)(66476007)(64756008)(71200400001)(66556008)(66446008)(8676002)(9686003)(86362001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ge9NSgyoytBpw1gLwLwchEi6fDV7suAJvv/9GroeEpfO1bAuubv89BuQs1V1?=
 =?us-ascii?Q?iPNQpMzh7QPDOHHjlr0RwAEztEZZsxvoFR3x7US2M7ND+S0V9d3zOea3xnev?=
 =?us-ascii?Q?/M2VOj73s8W3EMA3fnn2QeSznWVyxdk/DbRsxYXZpc1duxsppmYNOs7vgVRh?=
 =?us-ascii?Q?nuFoLqnYU1Vhi59m5ELD2QoVUd8bo0/opiW659f6cBTWu2qoCT9j50/Ds9BV?=
 =?us-ascii?Q?rDt+3TceClc4lG0Lq+c3Kjw6S3EmhGIZrBvoZEkBTOC5xTug/kANO3GS5awR?=
 =?us-ascii?Q?vy4k2o/KRKNjvUGRvJ8xkF3IW4MlBj1SLma3dUiA3/MOkqneOmCEYfjE3Bwj?=
 =?us-ascii?Q?hhotZcpowofhI6GabVH0XYA29hIUgCquG2ZsY9HxMpm2/E2+/Xu+zekbzDLi?=
 =?us-ascii?Q?5REeoBnHTCcVIvc4YZLz4n0t06vmks1B6eSsbxCblYQOt/xAubXaSxu+Rp8e?=
 =?us-ascii?Q?SfELeP8DjyMTubzuXjx47eqXtD9kQifrv8319bCg/eKpNEIqSQHqXChdna49?=
 =?us-ascii?Q?U0tXrLpMWznJxhmfWVB2IADpxHcOFsb0c7CiXzkyXm6Q6kUj4zeTLBlFkWqX?=
 =?us-ascii?Q?A324k3MaSO7uH4SwHA+AHn8Zr6Mne3qPz/LiGW9YLquFNFtb5Au05SKsdjEp?=
 =?us-ascii?Q?I1nnY4LynQCsD0Kvdnd7Sup2JXklBtpYU4bKnPLJBWKrPOqM4FtKdUfbL3Ef?=
 =?us-ascii?Q?P3WnMG+5DjcueFOrwXqiUEQlkF7TVPBVy22zs6fs9MlglvCoIv3wDe4ev7+o?=
 =?us-ascii?Q?S461bC+XrwOFxcN+1I3vR/34Y66gbogMPeyTKAlHyuNfyKPhM8keQN+wRC/c?=
 =?us-ascii?Q?Lpj20cc/URcGcE3iRhfGFVu55VDNC5ETWh0xpnLAcPwtMyl0yki8fjWAEEgO?=
 =?us-ascii?Q?19ZxHWkDnbY/+Wq/LFCjn2r2ocqTYVyjqKkgSsd3/s3gKJJnSmOBY/ZqQPPV?=
 =?us-ascii?Q?+tkcRpoZNjoOc7WWKvhGCi9fsLU3Zvhsu5B5Z62u+vgF7K0plSGHC/6q/2pL?=
 =?us-ascii?Q?a5/1pa28YviBITl59IOZJRg+l2E/pyAFSqzQfRKuTlLMD3U/Qq3YtijCJ7cJ?=
 =?us-ascii?Q?oRacFwimB+difWlUH15kcoQ2L6hUHFFTR2UOAUF0P5AO9acx66DpevTUkEpJ?=
 =?us-ascii?Q?1BW9bkD4meNrcwQqLIAhk8Pp/bu/hl4/4TEPCM7ElPifV1an1MhahD771zZk?=
 =?us-ascii?Q?/qiZOjT9j+3oo8IH5d4tBT0nlZCnU+y0HiQHfPBTTM4DgPqvDSISEGY9D/Kf?=
 =?us-ascii?Q?+sEbDApR6cdHU6SA9HbC75py3PS2QtQdhowXN8X5RxM5AriH0XBgXVGSYCXK?=
 =?us-ascii?Q?cecm7JlIZM/y4KbXSYYy5bd4foyD+mhCiuqIAs6YM4rGoe3wA9pVMwv8VLow?=
 =?us-ascii?Q?rHgmgfeOKDOItU+z1gB6G/Q5Hw6ue5IS1lAiPBFY2dPUfgD6HhXX+XaRp8iJ?=
 =?us-ascii?Q?BJFKtS6vvScoLCcYVbqgET15lU4hx+bcRa+YYnP91X9vLRjFwEcRw37blAyI?=
 =?us-ascii?Q?SGsln0rHroJZcb8Jc5E9GF6IXeoynhblqi03XT3e1Pu/yxXxa/33Ebcxr87+?=
 =?us-ascii?Q?3NFa8hfHJDMVCQhj0sK48T9HGaH+vO2Zy9nl6abi3NVWzGXjkbqeU7ScxPuk?=
 =?us-ascii?Q?k3REo0V9sqpdj75GJq4gbIiAd1+U7BJCexkckuPHolxV?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88E28B829FE1BB4C9EE0AA82208DE905@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e21ed2-1f61-4371-093c-08d9a36db60f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 10:43:04.8627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oa11U5sRrpusSAoCzCdxjOY3pzIH7sR5l6QhQXdP12KuxDSf1w0kMh5s1QF1Ouv45tt7vZiEwZBaTMYWJJObmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Nov 09, 2021 at 03:29:33PM +0900, Damien Le Moal wrote:
> On 2021/11/09 9:28, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >
> > Move common cmdprio_prep() code to cmdprio.c to avoid code duplication.
> >
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  engines/cmdprio.c  | 40 +++++++++++++++++++++++++++++++++++++++-
> >  engines/cmdprio.h  |  3 ++-
> >  engines/io_uring.c | 32 +++++---------------------------
> >  engines/libaio.c   | 26 ++++----------------------
> >  4 files changed, 50 insertions(+), 51 deletions(-)
> >
> > diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> > index 2c764e49..01e0a729 100644
> > --- a/engines/cmdprio.c
> > +++ b/engines/cmdprio.c
> > @@ -67,7 +67,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td,=
 const char *input,
> >  	return ret;
> >  }
> >
> > -int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
> > +static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u=
 *io_u)
> >  {
> >  	enum fio_ddir ddir =3D io_u->ddir;
> >  	unsigned int p =3D cmdprio->percentage[ddir];
> > @@ -89,6 +89,44 @@ int fio_cmdprio_percentage(struct cmdprio *cmdprio, =
struct io_u *io_u)
> >  	return 0;
> >  }
> >
> > +/**
> > + * fio_cmdprio_ioprio_was_updated - Generates a random value. If the r=
andom
> > + * value is within the user specified percentage of I/Os that should u=
se a
> > + * cmdprio priority value (rather than the default priority), then thi=
s
> > + * function updates the io_u with a cmdprio priority value.
> > + */
> > +bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
> > +				    struct cmdprio *cmdprio, struct io_u *io_u)
>=20
> What about simply calling this fio_set_cmdprio() or fio_cmdprio_set_iopri=
o() ?
> That is a lot shorter and the name matches the return true/false dependin=
g on if
> the io_u->ioprio was set (changed) or not.

Yes, that sounds like a slightly better name.


> > @@ -458,35 +458,13 @@ static int fio_ioring_getevents(struct thread_dat=
a *td, unsigned int min,
> >
> >  static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_=
u *io_u)
> >  {
> > -	struct ioring_options *o =3D td->eo;
> >  	struct ioring_data *ld =3D td->io_ops_data;
> > -	struct io_uring_sqe *sqe =3D &ld->sqes[io_u->index];
> > +	struct ioring_options *o =3D td->eo;
> >  	struct cmdprio *cmdprio =3D &o->cmdprio;
> > -	enum fio_ddir ddir =3D io_u->ddir;
> > -	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
> > -	unsigned int cmdprio_value =3D
> > -		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> > -
> > -	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> > -		io_u->ioprio =3D cmdprio_value;
> > -		sqe->ioprio =3D cmdprio_value;
> > -		if (!td->ioprio || cmdprio_value < td->ioprio) {
> > -			/*
> > -			 * The async IO priority is higher (has a lower value)
> > -			 * than the default priority (which is either 0 or the
> > -			 * value set by "prio" and "prioclass" options).
> > -			 */
> > -			io_u->flags |=3D IO_U_F_HIGH_PRIO;
> > -		}
> > -	} else if (td->ioprio && td->ioprio < cmdprio_value) {
> > -		/*
> > -		 * The IO will be executed with the default priority (which is
> > -		 * either 0 or the value set by "prio" and "prioclass options),
> > -		 * and this priority is higher (has a lower value) than the
> > -		 * async IO priority.
> > -		 */
> > -		io_u->flags |=3D IO_U_F_HIGH_PRIO;
> > -	}
> > +	bool ioprio_updated =3D fio_cmdprio_ioprio_was_updated(td, cmdprio, i=
o_u);
> > +
> > +	if (ioprio_updated)
> > +		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
>=20
> I do not see why ioprio_updated is needed. Also, since the sqes initializ=
ation
> also needs to be done with the defualt priority, can't this be moved outs=
ide of
> this function to be common with the default prio case ?

I'm quite sure that the compiler will optimize this and generate the same c=
ode,
but sure, I will remove the boolean.

Regarding moving it, I assume that the original author (of cmdprio_percenta=
ge)
who put the prio_prep() call in _queue() rather than _prep() had a good rea=
son
to do so. E.g. the _prio_prep() call is after the busy check.

The most important thing to me is that the call to fio_ioring_cmdprio_prep(=
) is
done in the same callback function for libaio and io_uring. So I don't want=
 it
to be in _prep() for io_uring and to be in _queue() for libaio. Also lookin=
g at
libaio, it doesn't like I can add it to _prep() in a nice way, I would need=
 to
add it to if (io_u->ddir =3D=3D DDIR_READ) and if (io_u->ddir =3D=3D DDIR_W=
RITE), this
alone make me want to keep the fio_ioring_cmdprio_prep() call in _queue().

So, all in all, I'd rather keep the call to _prio_prep() in _queue() for bo=
th
ioengines for now.


>=20
> >  }
> >
> >  static enum fio_q_status fio_ioring_queue(struct thread_data *td,
> > diff --git a/engines/libaio.c b/engines/libaio.c
> > index 9c14dd88..f0d3df7a 100644
> > --- a/engines/libaio.c
> > +++ b/engines/libaio.c
> > @@ -209,29 +209,11 @@ static void fio_libaio_cmdprio_prep(struct thread=
_data *td, struct io_u *io_u)
> >  {
> >  	struct libaio_options *o =3D td->eo;
> >  	struct cmdprio *cmdprio =3D &o->cmdprio;
> > -	enum fio_ddir ddir =3D io_u->ddir;
> > -	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
> > -	unsigned int cmdprio_value =3D
> > -		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> > -
> > -	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> > -		io_u->ioprio =3D cmdprio_value;
> > -		io_u->iocb.aio_reqprio =3D cmdprio_value;
> > +	bool ioprio_updated =3D fio_cmdprio_ioprio_was_updated(td, cmdprio, i=
o_u);
> > +
> > +	if (ioprio_updated) {
>=20
> With fio_cmdprio_ioprio_was_updated() renamed as proposed above, I think =
you can
> get rid of the local boolean and simply do:
>=20
> 	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
> 		io_u->iocb.aio_reqprio =3D io_u->ioprio;
> 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
> 	}

Yes, I will rename it, and like you suggested for io_uring, I will remove t=
he
bool ioprio_updated.


>=20
> And I wonder if the fio_libaio_cmdprio_prep() helper is really useful giv=
en that
> it is reduced to the above tiny code. Same for io_uring.

Since I'd rather keep the call in _queue() for both libaio and io_uring,
I guess we could either keep the function as static inline, or do something
like the following in _queue() (this is how it would look after patch 8/8):


@@ -341,8 +341,11 @@ static enum fio_q_status fio_libaio_queue(struct threa=
d_data *td,
                return FIO_Q_COMPLETED;
        }
=20
-       if (ld->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
-               fio_libaio_cmdprio_prep(td, io_u);
+       if (ld->cmdprio.mode !=3D CMDPRIO_MODE_NONE &&
+           fio_cmdprio_set_ioprio(td, &ld->cmdprio, io_u)) {
+               io_u->iocb.aio_reqprio =3D io_u->ioprio;
+               io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
+       }


Personally, I don't think that the ++ looks better than the --,
so I would prefer to keep the function, but make it static inline.


Kind regards,
Niklas=
