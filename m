Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2977EC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 13:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12ED061178
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 13:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbhKINcX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 08:32:23 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11653 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbhKINcX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 08:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636464577; x=1668000577;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bBk25uGrc8roHr0VfrOL9psMLPp+vHg3nKqY0SCTV0U=;
  b=RPLzlTb5P5krMmmwh4YQUMjJr25OZGBxEZmJWjo9dVh1GJoX8DJffc5n
   /bejGbHm7s+9iteHfMqvYWLys3s7ya8+xEzd5VmTVR716aRBGYsM2SUWm
   nREBWtT3MX1suKh9+PnSY7OcBJ42WBgcDbgdOXdmpAVUohI8TgncItYK6
   3bHEYHDUZRftcWLJP8xqn2KWYLMYUEQUOLGkILP3ibyg5jWQPf2O/Z/tu
   id6THgHcHsHo5vzMgUfs9cEhU7GlFCeeiIf9A5LvW+wygN1FCaMVo9HGz
   7eLg9ee3dHvJfDeX8SLRFHVPy4eGP88bt4sn2/bdqxT9oY0GJMe7K6Wxh
   w==;
X-IronPort-AV: E=Sophos;i="5.87,220,1631548800"; 
   d="scan'208";a="184130372"
Received: from mail-bn8nam08lp2042.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.42])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 21:29:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkBnDGP53JNtkiS3BnLEpo4odC0CAEKUHktVuW7WiaFaRqVf45ageJv9qcPthGQwf4BXJThLnpQCQC85SPoIeTlMr4PCi5wl1+xnCRJ+DpJWxmuTMbwtzWtNP2sVGXpMcxJZ1QPaCPJjCeLfDUBxghUgurYw39uFmbrSNbW+iDUU5y66EIxBEBbwXEcCa/y39zRGVz7vpkwA8dqsAUTpDcE6DolJ00pe/56rWMgR0BLcfO1/P619eBcxZzGtHb6aeUz/uxgXn3CWr01Ru0LheHTt6SsEUmdJbWoNKbo/ZcUPrsCvjv6sJnBaQyRqyDT0W2CEUy1S34kFREJvcsJ9pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/oXi8wCmhlJx6QFmbR56Oi/xCB3KShAoz9g0vkZT4A=;
 b=ctpWawpZUQvVWG1akX1912EdNJU9E9JpfoJ0wnfZCzLsuTQXhTnp3YKP/QuZ7/w3plcpQkVlPDi76zRSNHXtogtmGrS3+oBBqm5UcNJi+q7GCONBevLukv8FBMbP0kbisnSEeGrrePvFLHbrszrVcOsadt7n1gEkMSOIyBukOb833nTL+4WuathXxy04dd9DxJkpRdf7Ey+95imcEUUTuAuIWb4IoTtSe2/KqhUUQY4li4hPd2781e1riV38lqnFwTjH5/RHqzUtj4U+iVUrc6av4ehRgbcx1KUghYa2p9/W8IQFWjjnncefhm5t7pAVoo7QjDJ/J7rH4X0baeyn/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/oXi8wCmhlJx6QFmbR56Oi/xCB3KShAoz9g0vkZT4A=;
 b=M0Ju2hI1sCSI/GAKJ73zcf9aB2zTVn5COY+g3RcfMVmQYPVDB/meTR8HZdJmEAEz1tfXj1Mz3c/BtJdOcm4OYYtemKi5bSz6meOGAoqhz4+U9QojwYKMyjHIGYWbCth1KuxV76egX8N+S+WDxXEm+/kRkCSah185zrOLZyYGl9Y=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7317.namprd04.prod.outlook.com (2603:10b6:510:1e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 13:29:35 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 13:29:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Topic: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Index: AQHX1QCwimtz2VgxCU+gnzQiTYJoIav6vtYAgABy0QA=
Date:   Tue, 9 Nov 2021 13:29:34 +0000
Message-ID: <YYp3vESWV74In8Eo@x1-carbon>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-8-Niklas.Cassel@wdc.com>
 <e9dc1315-540e-f69f-6814-f8c95a2c077e@opensource.wdc.com>
In-Reply-To: <e9dc1315-540e-f69f-6814-f8c95a2c077e@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: opensource.wdc.com; dkim=none (message not signed)
 header.d=none;opensource.wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9470bcd8-3ba4-4928-905c-08d9a384f87b
x-ms-traffictypediagnostic: PH0PR04MB7317:
x-microsoft-antispam-prvs: <PH0PR04MB73171E9DA2D04EF1990C8EBFF2929@PH0PR04MB7317.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmOS3/q1zsvEqRDK5ro5UuoqFufn1FbN0+hpFnL2wapIsMw5+/sxg/ZDB53/5nkl5BqiyPEtsHWmePmV1Sv6f5InKu9SN8IqbBrEUE9h8ztAYxDlevEc18tYftIMf1i0ZQwftpOg8Bke8FS1lwrjdU0bn2Bf/0WexGsGADgZzoCardH2+oI1xGnXuoFr1kUL3YT8pI8HG0GdWYpszQjEWUb7AMcqMtS+la2LX9PgDFL3onQSnADFUmIlzJzlKQ2FxSy98u6pAgMwhYxrDF2zy7vCa1VEbSEJ8SVi3fQ/A3b9zW1asTgYv3ubeO54amR845HISxTGbSkheYbBYJ1/W8oazPzXAjbiUFW+6WL8V3qULwHv8fm28BYeWmXITwlXG1FlFQcv91fte400sjrQPK4UJ6TxInb8TbVG4NTjO2MM4kuML20IV4VjFQnMFlm1nmMCxugQp9ACdZYt4jHolNdHhRpxsQmh4QSZgdXNZb6YXTg7bWrx74hvLyvq3/CStSF6n4aMJ5+qwaNAaUKq2WbivIzhNQ03T9JMwUrWPg5+f4zdeAV5U5P3W+kRKgoCsDmpB6dgNTIytPyw2F6HoaFKV4+g7RdQwJFA/2D26zVh5eM+oWAKrYCtsjQ6j6sEUJzClTTzOnKifx1Q72EiGshAW42EStgt5iLaKlDPvDpUI9hbpJDhBaDRyOtkW5cDR5leJoNoSWHXrdVetPQbZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(316002)(6486002)(4326008)(64756008)(9686003)(6512007)(66556008)(26005)(66446008)(122000001)(6862004)(2906002)(66946007)(83380400001)(71200400001)(66476007)(76116006)(91956017)(8936002)(508600001)(33716001)(6506007)(86362001)(5660300002)(38070700005)(8676002)(53546011)(38100700002)(82960400001)(186003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OuXPdVFE9pW13wXo1PG1v/GxCR3+9KOdvoFxuVdAgQjiRwG8Ix7yOzl6DouB?=
 =?us-ascii?Q?lh/QqdSFsGXWf9bqmty30khJo74KHFMeEuvHRooqr9af5o0x0FWWQ8u1m+jF?=
 =?us-ascii?Q?9A42KDiaQtvYw7YhYcpLEYt/KrOgzPB0YXvWh2ILUhHu4m2r0OWeQTltPlf6?=
 =?us-ascii?Q?dgU0SI1Unt/TCaoWnbva1oUGRh5vrVyRb2VBA7o9woNUJyzXhJtPqPozz59r?=
 =?us-ascii?Q?h0fpv9IqRaMQEgxFwt/BdxHv3YeS88tJWUVJWS9mnTuYOqopE+60FnFQjmA3?=
 =?us-ascii?Q?932vZ6sOjmo3iDp+hOTqKz9cI2mLFla34NRrf6TB78W1OPu4/JskZYWb8tsj?=
 =?us-ascii?Q?UsCc6AoGB/Jy+R2kzcRrvWFFBf8xXbh9E1HYU1gASsjbS7fl5lghz9iPvwpv?=
 =?us-ascii?Q?9FFpQblUA0JBtO4AI/E9DAhtbg3mlRdl1HEGpvm3mOoTnnv3btXA/oB7VyLW?=
 =?us-ascii?Q?0+voeoELGnbTUgnYVkFDQF7eIMi8Kep/xBDWo/D7vpiDSyNzjStGHK1vy/Cz?=
 =?us-ascii?Q?PCYphJyGAdoiVxVZTHGzoL6oI11BELVB7v6rJiUuSWOEHTXFIKbO5to7Hxvc?=
 =?us-ascii?Q?TtE+Wjm/7TlOBkFdBZj5h0ZH0+Wssftf+rW0Rho/THiyG0XIZI8BXlXEQMgM?=
 =?us-ascii?Q?6ywLY5XD/TQwe9C1m4xwzJssSIwsNhCJm+yIMVSKIuwyl97IW7P0zqYh8NW9?=
 =?us-ascii?Q?KrzSAKRdvDHMiC6d1IQrj3XpfraVKtpMopseTwFCmfDY5SSiIo3KWtfLnRvv?=
 =?us-ascii?Q?q+gv8GZ8VD5xdBcrYPcPhMNjNRHlSlQwKeKrBD4wGxcUd/FlplNWachHoTiE?=
 =?us-ascii?Q?9/gC4jSRhkPe3fjIpbl64Mst3mGREht2d5wHJkyTixFOaLouuc5UDuHXtM/P?=
 =?us-ascii?Q?3IHGuwkzVCa5VyN7K7k5wlUWsyyPuxb05V75RcgBMrR9Jk7qRsHwHV7XOOMO?=
 =?us-ascii?Q?85nvcEznUc3Kx1xZWQin2QwHklf7iKuAohDjgBklbS5bkPNju7S6fdUk4ORc?=
 =?us-ascii?Q?UMaloW3u/8IaoN4yyPWXkMQ6qZ/SwFhMuFIh3sibFkkvT2o2EDPENrJ6iInO?=
 =?us-ascii?Q?I5uC7V8XEfWMbeDbJnyhHM5EARHqIYOVyCfpW9h3O3ewmCo6pOoOGhM37i6K?=
 =?us-ascii?Q?VlqRGRPkQ0rU7eQeoTKpS+Vz63BfXgzaYVGUKtp6q0rYHbK+67u1UVaYxVmW?=
 =?us-ascii?Q?dTuvnbz3RrTZsO4fXVH7/Ek16RUdvfpUx5I32PnG01eTiRKWXdgjpwb4Vovo?=
 =?us-ascii?Q?AsE56ct25sdljhkFx9mw1QRmhw0q+s79Pp3ep14H52hPWo8sXMnYQbOVc3uU?=
 =?us-ascii?Q?IsPkl/mH4wt7Mb/Nxn5B6MYQnUyR11RyD8fGlwq484niCMnTXTayHVFfObhn?=
 =?us-ascii?Q?Oz4oZ2JrgMQZ/tDdfcCU+vMJNGIQ/2fjpKaA6+6nCcokKdNAF9eDCxISfucf?=
 =?us-ascii?Q?oTg3/Xpx++3XqQ0v+v6qB2nMvJ/+bR9JoD9cIM2iVPfs8Khqb3EOoAD151Pa?=
 =?us-ascii?Q?VEqPze/XLJfoW0hIaRgOeJiY7k/jYZux77AvoVmRoeCcsq/RD576UzaYdIQV?=
 =?us-ascii?Q?ntJOUozTEfnlH1hKsXmaSpJjwfUaQQAChY8XrRZVi1HTNRqqfIvSdS0+Gldm?=
 =?us-ascii?Q?xNlzOfCZ0KpewgkVwW2Y4wdaY1pUDO/ulJ4i1IPVJotw?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E9238FBD2106BB468ADDC5E2071AAE1F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9470bcd8-3ba4-4928-905c-08d9a384f87b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 13:29:34.7223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJOoCW/5/9fTEf2VfeNAeshREq9zUH802DzOL615UADUUHRDUakm/ap3QLhqo9Sp5xA23UEXtTUuVtuHTeiRqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7317
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Nov 09, 2021 at 03:38:36PM +0900, Damien Le Moal wrote:
> On 2021/11/09 9:28, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >
> > Add a new field "mode", in order to know if we are using/running
> > cmdprio in cmdprio_percentage or cmdprio_bssplit mode.
>=20
> ...if we are determining IO priorities according to cmdprio_percentage or=
 to
> cmdprio_bssplit.
>=20
> (I think that is clearer)

Will update.


>=20
> >
> > This makes the logic easier to reason about, and allows us to
> > remove the "use_cmdprio" variable from the ioengines themselves.
> >
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  engines/cmdprio.c  | 45 +++++++++++++++++++++++++--------------------
> >  engines/cmdprio.h  | 10 ++++++++--
> >  engines/io_uring.c |  7 +++----
> >  engines/libaio.c   |  7 +++----
> >  4 files changed, 39 insertions(+), 30 deletions(-)
> >
> > diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> > index 01e0a729..cafe21d7 100644
> > --- a/engines/cmdprio.c
> > +++ b/engines/cmdprio.c
> > @@ -70,17 +70,12 @@ int fio_cmdprio_bssplit_parse(struct thread_data *t=
d, const char *input,
> >  static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u=
 *io_u)
> >  {
> >  	enum fio_ddir ddir =3D io_u->ddir;
> > -	unsigned int p =3D cmdprio->percentage[ddir];
> >  	int i;
> >
> > -	/*
> > -	 * If cmdprio_percentage option was specified, then use that
> > -	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
> > -	 * on the IO size.
> > -	 */
>=20
> Personally, I would keep the comment. It makes it very clear, in human na=
tural
> langage, what the relation between cmdprio_percentage and cmdprio_bssplit=
 is.
> That is, cmdprio_percentage has precedence.

No, cmdprio_percentage does not have precedence.
Since cmdprio_percentage and cmdprio_bssplit is mutually exclusive,
what we should use simply depends on the mode.

I will update it to a switch, like you suggest below to make things
more clear.


>=20
> > -	if (p)
> > -		return p;
> > +	if (cmdprio->mode =3D=3D CMDPRIO_MODE_PERC)
> > +		return cmdprio->percentage[ddir];
> >
> > +	assert(cmdprio->mode =3D=3D CMDPRIO_MODE_BSSPLIT);
>=20
> Is this really necessary ? What about using switch()/case with a default =
that
> has the assert for debugging ? This way, the assert will not be uselessly=
 tested
> whenever cmdprio_bssplit is used.

Will do.


>=20
> >  	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
> >  		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
> >  			return cmdprio->bssplit[ddir][i].perc;
> > @@ -99,10 +94,20 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_d=
ata *td,
> >  				    struct cmdprio *cmdprio, struct io_u *io_u)
> >  {
> >  	enum fio_ddir ddir =3D io_u->ddir;
> > -	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
> > +	unsigned int p;
> >  	unsigned int cmdprio_value =3D
> >  		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> >
> > +	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE) {
> > +		/*
> > +		 * An I/O engine should never call this function if cmdprio
> > +		 * is not is use.
> > +		 */
> > +		assert(0);
> > +		return false;
> > +	}
> > +
> > +	p =3D fio_cmdprio_percentage(cmdprio, io_u);
> >  	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> >  		io_u->ioprio =3D cmdprio_value;
> >  		if (!td->ioprio || cmdprio_value < td->ioprio) {
> > @@ -127,8 +132,7 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_d=
ata *td,
> >  	return false;
> >  }
> >
> > -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> > -		     bool *has_cmdprio)
> > +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
> >  {
> >  	struct thread_options *to =3D &td->o;
> >  	bool has_cmdprio_percentage =3D false;
> > @@ -140,16 +144,12 @@ int fio_cmdprio_init(struct thread_data *td, stru=
ct cmdprio *cmdprio,
> >  	 * is not set, default to RT priority class.
> >  	 */
> >  	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
> > -		if (cmdprio->percentage[i]) {
> > -			if (!cmdprio->class[i])
> > -				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
>=20
> Why do you change this ? If cmdprio->percentage[i] is 0, you do not want =
to set
> the calss to RT. Or is it that cmdprio->percentage[i] cannot be 0 ? (I di=
d not
> check the range of the option).

option cmdprio_percentage has minval 0.
option cmdprio_class has minval 1, however it can still be 0 if the user
omitted the option and only used option cmdprio to specify a priority level=
.

I was thinking that cmdprio_value is only used when the percentage !=3D 0,
which is the case in my cmdprio branch that allows you to have different
cmdprio class + levels, but you are right, in this specific patch
fio_cmdprio_ioprio_was_updated()/fio_cmdprio_set_ioprio() still uses
cmdprio->class to determine if IO_U_F_HIGH_PRIO flag should be set,
even when fio_cmdprio_percentage() returned zero..

The question is, if percentage =3D=3D 0, for e.g. writes,
but the user specified cmdprio=3D3
(which sets cmdprio->level[] for both DDIR read and write),
should we set the HIGH_PRIO / LOW_PRIO flag?

I think the best way is to simply not set any of the flags,
If cmdprio percentage is 0 for a certain ddir, then everything
will be sent with the default prio.

So I will keep the unconditional reassignment of cmdprio->class[]
here, since it shouldn't matter. If the percentage is 0 for a ddir,
the value should never be used anyway.

Will add a if (!p) return false;

after the p =3D fio_cmdprio_percentage(cmdprio, io_u);
assignment that this patch does instead.


Kind regards,
Niklas

>=20
> > +		if (!cmdprio->class[i])
> > +			cmdprio->class[i] =3D IOPRIO_CLASS_RT;
> > +		if (cmdprio->percentage[i])
> >  			has_cmdprio_percentage =3D true;
> > -		}
> > -		if (cmdprio->bssplit_nr[i]) {
> > -			if (!cmdprio->class[i])
> > -				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
> > +		if (cmdprio->bssplit_nr[i])
> >  			has_cmdprio_bssplit =3D true;
> > -		}
> >  	}
> >
> >  	/*
> > @@ -162,7 +162,12 @@ int fio_cmdprio_init(struct thread_data *td, struc=
t cmdprio *cmdprio,
> >  		return 1;
> >  	}
> >
> > -	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
> > +	if (has_cmdprio_bssplit)
> > +		cmdprio->mode =3D CMDPRIO_MODE_BSSPLIT;
> > +	else if (has_cmdprio_percentage)
> > +		cmdprio->mode =3D CMDPRIO_MODE_PERC;
> > +	else
> > +		cmdprio->mode =3D CMDPRIO_MODE_NONE;
> >
> >  	return 0;
> >  }
> > diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> > index c05679e4..7d14b3a6 100644
> > --- a/engines/cmdprio.h
> > +++ b/engines/cmdprio.h
> > @@ -11,12 +11,19 @@
> >  /* read and writes only, no trim */
> >  #define CMDPRIO_RWDIR_CNT 2
> >
> > +enum {
> > +	CMDPRIO_MODE_NONE,
> > +	CMDPRIO_MODE_PERC,
> > +	CMDPRIO_MODE_BSSPLIT,
> > +};
> > +
> >  struct cmdprio {
> >  	unsigned int percentage[CMDPRIO_RWDIR_CNT];
> >  	unsigned int class[CMDPRIO_RWDIR_CNT];
> >  	unsigned int level[CMDPRIO_RWDIR_CNT];
> >  	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
> >  	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
> > +	unsigned int mode;
> >  };
> >
> >  int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *inpu=
t,
> > @@ -25,7 +32,6 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td,=
 const char *input,
> >  bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
> >  				    struct cmdprio *cmdprio, struct io_u *io_u);
> >
> > -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> > -		     bool *has_cmdprio);
> > +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
> >
> >  #endif
> > diff --git a/engines/io_uring.c b/engines/io_uring.c
> > index 46f4bc2a..f82fa1fd 100644
> > --- a/engines/io_uring.c
> > +++ b/engines/io_uring.c
> > @@ -68,8 +68,6 @@ struct ioring_data {
> >  	int prepped;
> >
> >  	struct ioring_mmap mmap[3];
> > -
> > -	bool use_cmdprio;
> >  };
> >
> >  struct ioring_options {
> > @@ -472,6 +470,7 @@ static enum fio_q_status fio_ioring_queue(struct th=
read_data *td,
> >  {
> >  	struct ioring_data *ld =3D td->io_ops_data;
> >  	struct io_sq_ring *ring =3D &ld->sq_ring;
> > +	struct ioring_options *o =3D td->eo;
> >  	unsigned tail, next_tail;
> >
> >  	fio_ro_check(td, io_u);
> > @@ -494,7 +493,7 @@ static enum fio_q_status fio_ioring_queue(struct th=
read_data *td,
> >  	if (next_tail =3D=3D atomic_load_acquire(ring->head))
> >  		return FIO_Q_BUSY;
> >
> > -	if (ld->use_cmdprio)
> > +	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
> >  		fio_ioring_cmdprio_prep(td, io_u);
> >
> >  	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
> > @@ -831,7 +830,7 @@ static int fio_ioring_init(struct thread_data *td)
> >
> >  	td->io_ops_data =3D ld;
> >
> > -	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
> > +	ret =3D fio_cmdprio_init(td, cmdprio);
> >  	if (ret) {
> >  		td_verror(td, EINVAL, "fio_ioring_init");
> >  		return 1;
> > diff --git a/engines/libaio.c b/engines/libaio.c
> > index f0d3df7a..b33461f4 100644
> > --- a/engines/libaio.c
> > +++ b/engines/libaio.c
> > @@ -51,8 +51,6 @@ struct libaio_data {
> >  	unsigned int queued;
> >  	unsigned int head;
> >  	unsigned int tail;
> > -
> > -	bool use_cmdprio;
> >  };
> >
> >  struct libaio_options {
> > @@ -320,6 +318,7 @@ static enum fio_q_status fio_libaio_queue(struct th=
read_data *td,
> >  					  struct io_u *io_u)
> >  {
> >  	struct libaio_data *ld =3D td->io_ops_data;
> > +	struct libaio_options *o =3D td->eo;
> >
> >  	fio_ro_check(td, io_u);
> >
> > @@ -350,7 +349,7 @@ static enum fio_q_status fio_libaio_queue(struct th=
read_data *td,
> >  		return FIO_Q_COMPLETED;
> >  	}
> >
> > -	if (ld->use_cmdprio)
> > +	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
> >  		fio_libaio_cmdprio_prep(td, io_u);
> >
> >  	ld->iocbs[ld->head] =3D &io_u->iocb;
> > @@ -507,7 +506,7 @@ static int fio_libaio_init(struct thread_data *td)
> >
> >  	td->io_ops_data =3D ld;
> >
> > -	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
> > +	ret =3D fio_cmdprio_init(td, cmdprio);
> >  	if (ret) {
> >  		td_verror(td, EINVAL, "fio_libaio_init");
> >  		return 1;
> >
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research=
