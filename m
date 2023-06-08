Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D03C7EE25
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 05:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjFHFs4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 01:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbjFHFss (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 01:48:48 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFA22697
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 22:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686203325; x=1717739325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v64x9rEzV1OhRKYDWAPmQQgPbQVRqBzT8FjHA4DcZ9c=;
  b=FxDksYUuRagfMLpKM7g/da5E6Gx7w8gcWQXVko/AgGvTvt4mAo6YBa+E
   h3Fgqfld8BsffWK5Oh0Q4Igu6se9ZTCwZ0OSUUUPjPnvCNi7wffHbclnF
   2OcSKJe34IRG6T9TMR3r6G45dMqOXLztqc9zi78hRK2DCf/Meso0fTDoy
   8yPSDsKDOOn4jnCs0c9cxGKdWxjJj9cZMCw2x7CJ1CgwT02kdtNXDzJw0
   +yf8VBq32c1NzAbCIHbWzqZ4ZMohutSYgDYK3bOnAw7azR2+899JdlHji
   nX065uQiOVkhtEaakAB9GslXSGPjdgghkJJqCfBG7xWzmxZ6j30ybwTH9
   w==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="233092269"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 13:48:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOhYfP3TUWozDoHb7jz+Y00n0u2Au51nf0NfaqUcwsW9FgEDYnexEzTWGC2SWpQi7HdUMgyBxwHV4fVq8zSyusqlH25pd60RJ62LXPlISGNYE1U8EuUK4xbLSkuyzu2Wn2NDen8Ago67IRQLs65j6Ev7Gb3OPxt8ur0oJ5/pmxIYCmwpKW4DtOEP4ILLp/4YvcRcg9rPZ6g2qIG12BnlG52gwjGR62YWey46D+Dmztd9HszprjC5+iO2NRsz8s7hlc037VMlb+frAsHuxQf/K9NfhERBRubHjFMDfazQ0btxJQO38M4A2DoZA1eH8XOhMT4srN5tJ8db1DY83vihAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7S7WRAhxN5ZBhpAqV7iBLjB3A3kfRlyTmORsQLXjb4=;
 b=c6JkQAw2mfXEEPWZOc66rZ9EtdHMDb5Yyn0T+eYqFox8wJs02TWROt+KLM2WhvtpX5wLiH1SCipyceq2BBis9eQVH2iaxA6G4CA10QN7H4TMdKLS/PT+W+1z/KwTQLp22LU5OfS5mw5gkP4TrQQa90Bk+/sHtUTZfExNBBYpBhsEbM2t5lSocnAyw8sAwLB9/P/p3/6HOinjeNUKqi5K+8T1JdnHtA224Q/+S7TjZVzsUHLmChqwFOXyOFFCmahv6Tr7HkzkQJfzm4jMGM09ZrdhiNQILaAjCTMDVDakEvsYCbx7FdUbrKXzfj+/OHq8AnUNwKCuFbnpfCRZjjdzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7S7WRAhxN5ZBhpAqV7iBLjB3A3kfRlyTmORsQLXjb4=;
 b=FokJUSf3W0S/7RyybDlEFkXYH8n/K7kKjznAF5veG1UJVKOLljccCCtqLXo3gGNUVmZptwLnMc17yZUnMW0OYjYPuXviRYmM5cHQooRTfTyZjRO1SdFJqw+0rvMRrgb6f5kAnYW3gF7iNaAThZciu1aHUvxjoaevvXC/mpBPlUU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB7505.namprd04.prod.outlook.com (2603:10b6:303:a1::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.41; Thu, 8 Jun 2023 05:48:41 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%3]) with mapi id 15.20.6455.028; Thu, 8 Jun 2023
 05:48:41 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Topic: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Index: AQHZmRqjh+TR46K7pEqo8aItrb/3l69/Ui6AgAEVXIA=
Date:   Thu, 8 Jun 2023 05:48:41 +0000
Message-ID: <gp4w4ente632nsyp7llblq3hjbnnpfsw2drm4s3vbhfkrrfq5a@ok2icgcyievr>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
 <ZICDCbgaQiZWdMpN@x1-carbon>
In-Reply-To: <ZICDCbgaQiZWdMpN@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB7505:EE_
x-ms-office365-filtering-correlation-id: b19474ea-9857-41a0-f1c0-08db67e403a7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Vlwae8a0D34mK3OeV6YJgMIGeZubmXupEBrAzM+xH715Mc5+Bc2zromGyG3tWEjPvNfw4UlQdXUN2+wuKrnSilAHusqlj9yWk15DRK4FRA6eRAIDCs2TWemo4+jZtznML/yqjqUDVizDfaW2WkD7c68eN6AzX+SXtfImjeIZWLp4Igf92SnEU+NbbUTBogg0JPwtyJNcURSprtgWYHac3m0ntNQdYKsdgYhPkbngPL/1qk1h0supPhgUugfn8ZVYPX3ToUWPKQFQOHyqgO7jeB0Nvq7J0Ylj0KBm6RRYW6m3dqVhC8f74/h/O65lrzocZMNAnFs29yxz582d+GdvfFEutKf14HRiXJ/qg76m+kurLpZJ6Iph4hCjkzts5VFom3fq9rDG2iEfyQFZU+tsNBy7PGXJL+5kykrJXYKtc1KPPBcWQGs0e83X0YBOK9LXUY/5H0mvoSXkEnrm2Hu0zJ4IZmEbqKdcE1ZeqHo2/C3/8xVxx5A6mcQVA9m+UXnR87T1WSG4Z7F4q73aAfL8nT39bFC11YoIBG+l0Ru7+VzRnNPIlipYUhjEtkcU31bCDEm769hkunTDCHLOK6CCAIl47zlXaA0HEgXZvvopwCwpBio4ADbZxbH6n8o1QZ1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(38070700005)(2906002)(86362001)(33716001)(44832011)(15650500001)(5660300002)(83380400001)(71200400001)(6486002)(186003)(9686003)(6512007)(6506007)(26005)(478600001)(122000001)(82960400001)(54906003)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(6636002)(4326008)(316002)(38100700002)(41300700001)(91956017)(6862004)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZDIx4Ky6EvJzJzxjDIra/y+Y26mqkcz/buBF/ZxyaZB0rQLdw22rnm0a0uFN?=
 =?us-ascii?Q?khwDojuY2BBkU1vTy/v9EWcOc0Cjtb/NxwXXKrKGAWBu6X2PfnILdQc5+Ndd?=
 =?us-ascii?Q?+AjIHpQQnso44WyKukCQPAJI/aMGCg8ApUMCG6dT3K0gNLKKO1ASlxRGWyo/?=
 =?us-ascii?Q?3YxtC/+ht+/UZwPdkqAgD6q86i4mGeMwUmXDOIzUlrU1crsr/f7se/NmE8za?=
 =?us-ascii?Q?MSnVfeHkrszSmUSbcRA7q6vzJW814hKCRDoUSsagpKbuxfsff5SUGJj0ml//?=
 =?us-ascii?Q?lUHIcc5ti7F4eAn7kFZhUjJbLhLf6zeH3q9peTi3qBx2L0c+opEBtqisWiRA?=
 =?us-ascii?Q?jpLNzQfKDvlMOfen4IjqCDdRvOqO/jyElZ+seofcovjKTPWVCU8X77a34Awr?=
 =?us-ascii?Q?Ea4iLBqoL9+CiW4Lh6VxHXE6Q+TfsIMKhGZ1ta2/hRHORCHUinSTt20mpvLE?=
 =?us-ascii?Q?yA7atBHSig98GWsbZU4Kj+P+n/fhUNWuS2dWdxQcHdfqgo/2ifNb7gfCn9Yc?=
 =?us-ascii?Q?O000SKYmilsreXwiJ6qP8UlXI737segjZukYMdOIEABuaTxwSmPEKckZAj16?=
 =?us-ascii?Q?HtB58E50wHR3iiOF5ImJi41HJL0y5/VPeSQe23OYem8mXhpoCrcHVXT7ulq2?=
 =?us-ascii?Q?edndEYb50NQCSRT7UpjigVM8VdOT4gvILDLIEiB8oUekMzM0zVXK8+DCGJ/J?=
 =?us-ascii?Q?tCDQeMnxQJcIzlg+hepK+OywuZ+zOHz91eNXxavNQb6AH1zpjsF4IOWp9uJ0?=
 =?us-ascii?Q?fCz+ywdBwxGO+0YSMr7iHSYYhVrp3BE9vcvkoEMepwXFDGb/QOqOBMGz2iuR?=
 =?us-ascii?Q?8VS7s8JZdQZPS9YbNOztFZ9+zq0l7BiFprYE26h6YsWnN1oB22o7esP7hE/K?=
 =?us-ascii?Q?gUk28aLsqwIcYsS29zdYYrI+zIpLwjWu9IeKdOMG2GeXyEnePQht0CGIz7oq?=
 =?us-ascii?Q?HecNtQCH7m39ZwlXSovswy818tqVMxpXLq/uo+my1OdNePztL/JiOzO7YKQL?=
 =?us-ascii?Q?XbLW7mqB62C97rABez67Sg4a2YbY6PjYe5FTt5qaOJ2TJkAla2bPIyj/gfHU?=
 =?us-ascii?Q?tfTRBhDb1UwbD5hC5t35sb7MmAZUQ7C6BE3hpnZr+GETmvZWCqYkHulmZ1Yf?=
 =?us-ascii?Q?JCIvRIOmMwZ2b2g7AkptKzz5LBZZll2joMuiWS6uA3j0y/8KnOJ/kjXPQs9D?=
 =?us-ascii?Q?UoGsciWwSlPlkfN6yG7T9tQkobbNWSBp6YlLo0hvbWcaw5lXpbEo8MQ35nbn?=
 =?us-ascii?Q?mCoaOptcFpTod4y2SPeLdkGXka7t2eeM839l68MHsuJrULzfVQ/hdyMTF+bG?=
 =?us-ascii?Q?ZY+omEmVsdw+DO95RKp3vwZpPyn4yKAmp1lp+Ijy/yP5gGJQw3SX0eXdGewp?=
 =?us-ascii?Q?I39LPIr29bOQn4hesfo7t0WIbik9Y7MITfegiMfjOZ4Dr4XkXHlIc0VzH+bb?=
 =?us-ascii?Q?Hi9pVLkudbMMSdkOt84ppEems+dLyDUxZAl4pmYDCj8BN/o2kjBFT4G4pIcP?=
 =?us-ascii?Q?2tHaGDwaTPweSAbVvhaeKn0GzBghVcY9fVTfz1u407M62YYfQMWaH0tm4Zv8?=
 =?us-ascii?Q?4Eabc43EQKpy7jbXQczeoDZVi+utCMaiyRe+U2x4TMbkVLuaJ4WqLScK8DRv?=
 =?us-ascii?Q?yS4exoh0kUVS86OOyztET/A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40ED5988BDA1B4489060D210375F4ADA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nifycF/2g2RM0lWqByoTb3xUT5BA8V9yKa4vdKZ4KvYtvGkmp1sQlGWYc2mU0Dh76i9gaJYWtgeV5lE49f/RC54eTrdd9zzOKIbfFksRcOF9M79ZaiA0FPM4HwJPKAUZtawPDxoqTwfGeDhXihPyDol8W60oSkhqZRv1GHa1RE98+3Glan7VauvPb07xwxQ/ywZHWKteEc3KQv0io5IMbxKolskN/sUqRlbdt6FGqrFrlhtpZHU7Zlxs+MTRQENv3mb1cqoYfD1QdbZp4fUuQObF9Oxcrr6ubJyMoJmyATJkJYqnWXPSGJj4RZDPly4GbxxPs4YiXyu+ksarwaxMBQvQKP0vBkHVMrAE7H5NOucM/w4DVhPZbBqacck/dFsui0b4K0qiyv86UFVx1SoBaTRURazQij5BSVqZgGrtmVrVP5q/pGT66qbrVVF644pUEvJkOWrFcl9DQOURVwK7qAjlDa9QJ0n6n8UEZAWgiNm6S0tpZHqQ+pLqg44KzxcIcJ+Q9vPPJHWwWHKvs+Bez2cbwFAXlgYu9JYG5zvCo3IFPQrpwvjNU2VNeiQ6Q3obbB3h0HoOvxtC5suyc0Va9dqJglNCHr0aFp2rUFkCMZ8zlAslpA9Pt4ARnNRwKkDh7kFFHAbZ4VEpfYI4vmYzdebYyPgtLRh9VofHmq+L3gskuOSaEzQ5oWdkeTNKSoXqPyEu0ZXoKT88YbCtzRxN78wmUX/FQxzDdTiKGqXmlL9KZmyKWRbEb36tz16F2ygm7HwKJtupaLowMQxMKmzdbZryzQT/O4vc1WJb9DtabiRBsewdEk2v8HqORPDvNPSdPgq+B+Ks6ypLW+0Rn9WHVcIwHA0v7c+CEpI4cwKu3k0=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19474ea-9857-41a0-f1c0-08db67e403a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 05:48:41.4249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmG1p+NpoVEweP9mnlXv8EmUsJY4fZ7QVYBPpTNY67YhEHuVmQG1y+in2aJTbtyZxbO9MzgUI6eQMgwQZSMwuAwY0QwlI+4oAhvF00kt5QQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7505
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jun 07, 2023 / 13:15, Niklas Cassel wrote:
> On Wed, Jun 07, 2023 at 05:32:27PM +0900, Shin'ichiro Kawasaki wrote:
> > The commit e3be810bf0fd ("zbd: Support zone reset by trim") supported
> > trim for zonemode=3Dzbd by introducing the function zbd_do_io_u_trim(),
> > which calls zbd_reset_zone(). However, it did not call
> > zbd_write_zone_put() to the trim target zone, then trim operation
> > resulted in wrong accounting of write zones.
> >=20
> > To fix the issue, call zbd_write_zone_put() from zbd_reset_zone(). To
> > cover the case to reset zones without a zbd_write_zone_put() call,
> > prepare another function __zbd_reset_zone(). While at it, simplify
> > zbd_reset_zones() by calling the modified zbd_reset_zone().
> >=20
> > Of note is that the constifier of the argument td of do_io_u_trim() is
> > removed since zbd_write_zone_put() requires changes in that argument.
> >=20
> > Fixes: e3be810bf0fd ("zbd: Support zone reset by trim")
> > Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  engines/io_uring.c |  2 +-
> >  io_u.c             |  2 +-
> >  io_u.h             |  2 +-
> >  zbd.c              | 40 ++++++++++++++++++++++++++++++++--------
> >  zbd.h              |  2 +-
> >  5 files changed, 36 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/engines/io_uring.c b/engines/io_uring.c
> > index ff64fc9f..73e4a27a 100644
> > --- a/engines/io_uring.c
> > +++ b/engines/io_uring.c
> > @@ -561,7 +561,7 @@ static inline void fio_ioring_cmdprio_prep(struct t=
hread_data *td,
> >  		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
> >  }
> > =20
> > -static int fio_ioring_cmd_io_u_trim(const struct thread_data *td,
> > +static int fio_ioring_cmd_io_u_trim(struct thread_data *td,
> >  				    struct io_u *io_u)
> >  {
> >  	struct fio_file *f =3D io_u->file;
> > diff --git a/io_u.c b/io_u.c
> > index 6f5fc94d..faf512e5 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -2379,7 +2379,7 @@ int do_io_u_sync(const struct thread_data *td, st=
ruct io_u *io_u)
> >  	return ret;
> >  }
> > =20
> > -int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
> > +int do_io_u_trim(struct thread_data *td, struct io_u *io_u)
> >  {
> >  #ifndef FIO_HAVE_TRIM
> >  	io_u->error =3D EINVAL;
> > diff --git a/io_u.h b/io_u.h
> > index 55b4d083..b432a540 100644
> > --- a/io_u.h
> > +++ b/io_u.h
> > @@ -162,7 +162,7 @@ void io_u_mark_submit(struct thread_data *, unsigne=
d int);
> >  bool queue_full(const struct thread_data *);
> > =20
> >  int do_io_u_sync(const struct thread_data *, struct io_u *);
> > -int do_io_u_trim(const struct thread_data *, struct io_u *);
> > +int do_io_u_trim(struct thread_data *, struct io_u *);
> > =20
> >  #ifdef FIO_INC_DEBUG
> >  static inline void dprint_io_u(struct io_u *io_u, const char *p)
> > diff --git a/zbd.c b/zbd.c
> > index 36b68d62..7eef49c6 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -254,7 +254,7 @@ static int zbd_reset_wp(struct thread_data *td, str=
uct fio_file *f,
> >  }
> > =20
> >  /**
> > - * zbd_reset_zone - reset the write pointer of a single zone
> > + * __zbd_reset_zone - reset the write pointer of a single zone
> >   * @td: FIO thread data.
> >   * @f: FIO file associated with the disk for which to reset a write po=
inter.
> >   * @z: Zone to reset.
> > @@ -263,8 +263,8 @@ static int zbd_reset_wp(struct thread_data *td, str=
uct fio_file *f,
> >   *
> >   * The caller must hold z->mutex.
> >   */
> > -static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> > -			  struct fio_zone_info *z)
> > +static int __zbd_reset_zone(struct thread_data *td, struct fio_file *f=
,
> > +			    struct fio_zone_info *z)
> >  {
> >  	uint64_t offset =3D z->start;
> >  	uint64_t length =3D (z+1)->start - offset;
> > @@ -339,6 +339,33 @@ static void zbd_write_zone_put(struct thread_data =
*td, const struct fio_file *f,
> >  	z->write =3D 0;
> >  }
> > =20
> > +/**
> > + * zbd_reset_zone - reset the write pointer of a single zone and remov=
e the zone
> > + *                  from the array of write zones.
> > + * @td: FIO thread data.
> > + * @f: FIO file associated with the disk for which to reset a write po=
inter.
> > + * @z: Zone to reset.
> > + *
> > + * Returns 0 upon success and a negative error code upon failure.
>=20
> Please add an empty line before the "The caller must hold z->mutex" line,
> such that we are consistent with other functions, e.g. __zbd_reset_zone()=
.

Thanks, will add in v2.

>=20
> > + * The caller must hold z->mutex.
> > + */
> > +static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> > +			  struct fio_zone_info *z)
> > +{
> > +	int ret;
> > +
> > +	ret =3D __zbd_reset_zone(td, f, z);
> > +	if (ret)
> > +		goto done;
> > +
> > +	pthread_mutex_lock(&f->zbd_info->mutex);
> > +	zbd_write_zone_put(td, f, z);
> > +	pthread_mutex_unlock(&f->zbd_info->mutex);
> > +
> > +done:
> > +	return ret;
> > +}
> > +
> >  /**
> >   * zbd_finish_zone - finish the specified zone
> >   * @td: FIO thread data.
> > @@ -404,9 +431,6 @@ static int zbd_reset_zones(struct thread_data *td, =
struct fio_file *f,
> >  			continue;
> > =20
> >  		zone_lock(td, f, z);
> > -		pthread_mutex_lock(&f->zbd_info->mutex);
> > -		zbd_write_zone_put(td, f, z);
> > -		pthread_mutex_unlock(&f->zbd_info->mutex);
> > =20
> >  		if (z->wp !=3D z->start) {
> >  			dprint(FD_ZBD, "%s: resetting zone %u\n",
> > @@ -2048,7 +2072,7 @@ retry:
> >  			 */
> >  			io_u_quiesce(td);
> >  			zb->reset_zone =3D 0;
> > -			if (zbd_reset_zone(td, f, zb) < 0)
> > +			if (__zbd_reset_zone(td, f, zb) < 0)
>=20
> Since you remove the zbd_write_zone_put() call, which I think is good,
> I think that you should continue to call zbd_reset_zone() here.

The two hunks above are difficult for review. The 1st hunk which removes th=
e
zbd_write_zone_put() is a change for zbd_reset_zones(). zbd_reset_zones() n=
o
longer needs to call zbd_write_zone_put(), since zbd_reset_zone() (no s) ca=
lls
zbd_write_zone_put().

The 2nd hunk is a change in zbd_adjust_block(). The zone reset here is done
just before the write command issue to the zone, so zbd_write_zone_put() sh=
ould
not be called. Then zbd_reset_zone() should be replaced with __zbd_reset_zo=
ne().

>=20
> >  				goto eof;
> > =20
> >  			if (zb->capacity < min_bs) {
> > @@ -2167,7 +2191,7 @@ char *zbd_write_status(const struct thread_stat *=
ts)
> >   * Return io_u_completed when reset zone succeeds. Return 0 when the t=
arget zone
> >   * does not have write pointer. On error, return negative errno.
> >   */
> > -int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
> > +int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
> >  {
> >  	struct fio_file *f =3D io_u->file;
> >  	struct fio_zone_info *z;
> > diff --git a/zbd.h b/zbd.h
> > index 25a3e0f1..f0ac9876 100644
> > --- a/zbd.h
> > +++ b/zbd.h
> > @@ -100,7 +100,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *t=
d, struct io_u *io_u,
> >  			      enum fio_ddir ddir);
> >  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u =
*io_u);
> >  char *zbd_write_status(const struct thread_stat *ts);
> > -int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u);
> > +int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
> > =20
> >  static inline void zbd_close_file(struct fio_file *f)
> >  {
> > --=20
> > 2.40.1
> > =
