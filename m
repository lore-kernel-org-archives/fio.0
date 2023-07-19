Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AA5EB64DC
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 03:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjGSDNT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 23:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjGSDNR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 23:13:17 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1DC1BDB
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 20:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689736396; x=1721272396;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HOjQNJVWWMYjHvPC3qeV0rRli9VdRdKEPljY9xNCxlQ=;
  b=cdj3P8Ne+Ph0rTtdtkcPTmDDsZipa1+lvHJ9HSoUqE5mKIFeuNJBvz7C
   9bJsMkTVsopYBM3k+gA+x4coGWLi2R2AjNYdExihIjhXCK/API5cCOUO4
   b4EZmqVsU74md0XnJ6CY7fQVebR78LFOBxgPe5sN9WLtLGOwfDn2ovOAm
   ryqmJ7lOTF/s3TIZeO3BQLK6uSqPZsYG0KDqjEDelNO/A4a2CwtjKDymQ
   erXx/gFnzaF3pvJ4kw0CAe2HuhymgXGunhgsAuVgh3+5sPpnx27Id6BiD
   uoWacmO4KLMJ3+D0QzQoPSfb3lyFDIzgfjNjx4TDfgN5XXJcjTxGdh5FK
   A==;
X-IronPort-AV: E=Sophos;i="6.01,215,1684771200"; 
   d="scan'208";a="238248754"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 11:13:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPPHX8sVMqyXzxn62t6tNnMarOIoopTm35y7M8lhHS3spEeaPGNrGKcdZCEMgu+ohHz1oYyx4VQkOz9qiM4DGIGegGiy3BBEj8r+OvOabK14nXUjilgiECkTFOFRAE1q30Jr2ZE7w+RJIqFTiY26vlL9kg/04Rjxs3zhnj0lXrHVGAZmV/a6JAnC5NdVjczPNJVtvqUCNOvVw3Cr043tnX6/os/AMxmaR8lh9u5cqut9CVEHN+NEeoSY47Jl7uQfYIViTJuevD5bQgAHG0p92Cqn86JUN2zeCjK/Mwu/IjKq8zMYsobHfbQQ1JSmx0Mji5uSCwFtbWAZ/TYM0kBMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5eLXptxFRFa0+aqzzGGtMzw/R/jAq8lpHJyOF+kEco=;
 b=lxK4kmorxdt+bRkXH+MsbWDwyuKcvuEDoivYlDc2TNbQbxgAv+pPLtwBhVKYi8Hzc6WRb/OsEs7TQjDpW10pd98AFys1OtMIOrgJFil1e+kvZ+spylDd2InVqpIVXCjaF3clbbQ1+gd74gk0/CX804vTLx1d8V4u4gteAX4HW2zLPgA5MF2Sto69M2sG8YEn+rFvOOBJAxp1/V/UYsVXU5zRn3dUsrdQVxKutu6+xVO7vMLhTWRcmfJw8pRoGQ84d9Q5F5OCEKqnecLcgmZMlnglKnRt2fkAbg7y9nxVRm4smNOFQTBs2mkNwA6U98FCazO8YWrxetlkPgoIkntOMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5eLXptxFRFa0+aqzzGGtMzw/R/jAq8lpHJyOF+kEco=;
 b=O1p0rUfc7g3Hse0kqQ7PwGIN/B3f5hPAVXNbT3r0OIZ5WpsUg1nFjFx8ahr78/ujff4o/bbv055cZZPkHYtqmPEagiT4LzCpKid5NJc2lKew8aE33xGLuVcdJpbuR5qs8LLGnzTlrDZ+AdqjP3/wAhdse+pp6Kp/NXSE4He8WW8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Wed, 19 Jul
 2023 03:13:14 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9%7]) with mapi id 15.20.6609.022; Wed, 19 Jul 2023
 03:13:13 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 03/13] zbd: print max_active_zones limit error message
Thread-Topic: [PATCH 03/13] zbd: print max_active_zones limit error message
Thread-Index: Adm57vRemZ7SQVyp30axrNyJPvxDIQ==
Date:   Wed, 19 Jul 2023 03:13:13 +0000
Message-ID: <hxrt4z5642kfg6fnc3auktrmseqns6f2bqzlawxrlspnbnwpxq@3g67hcft54cw>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-4-shinichiro.kawasaki@wdc.com>
 <ZLaZ19LwRUNOSYOm@x1-carbon>
In-Reply-To: <ZLaZ19LwRUNOSYOm@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB8377:EE_
x-ms-office365-filtering-correlation-id: 48ad56f8-1b21-4473-a9a2-08db880616e3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QKlInwugFPLoPQYfUgsdjzAGQKNM0UjQvW0HY6ilOwGQ9Yb97IoaHzUgj6R23tpahxEwGhRVFwbd2E+M3k4J51bk94yiD5TZ9U46y8oJXHcJe0v5Uel06FQY6dSrAXm/kJoAr7g4NLvgmab681t58YVmsVSw2LRrjbLwJ7pPZUrhKC6+r/XJcwCw10NxmgHJ/o5XMr/Oz2ffddYuzV5PiATOJQ24Io/8t3afmyQBW4IWcwd9G45vmfwjWxFVxmHiDhUrikBnWFeuOuvJO8opzF1SIN2UtMphGbFSoHa7E83AgMsN5ZIeIh0GgFQMm6t3PoyMbFsDOXauWVgbyJsgg30wjICq1x/02JUK1h+UnQMMmYR1s3fC7l14ujsL4i09+TySqTjxBlr1rbSV5ZHtGDTKQ8VtXuR9t/Y9w+xgLJgTMlUAzaprVhX9GsM9uZQZ30Iu+B035sImSiT06dgmWBm+ZB9WH2DGSvU1IbEykO7bTa1lvJa6LjSKjtoS3bB9MNBD0oNGHzmz4Jv2DIRVTiiVckEBLmCa+hF/SkliOaBoPZpzIowv5pkGdnbQQZnD0HVC2moug86KYxSywppUdcpwVJWxsoHajTh1BGrbgfHX1glZM9rFTAYzs/M6YPyS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199021)(33716001)(86362001)(2906002)(8936002)(8676002)(4326008)(83380400001)(38070700005)(44832011)(6862004)(6636002)(316002)(41300700001)(15650500001)(5660300002)(122000001)(38100700002)(66476007)(66446008)(91956017)(66556008)(76116006)(54906003)(64756008)(66946007)(186003)(6506007)(26005)(6512007)(9686003)(82960400001)(478600001)(71200400001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9UWE9LcfXDj1jPXk7IfgOdDnTJtnHzKmbXBGv+c7nHfTZvRKiSpkLV5doNHU?=
 =?us-ascii?Q?cVIDAzRrEqltbPl2E1SHUVt7cpI5dFlIQceXKneQXcUUWgxwE/5qfzr6bzQG?=
 =?us-ascii?Q?wwh3Fr2t3v4JBLBqVrdQ+dPFo2FbWG64pBjff2BXDPUrDC6fllKYCzrqgjvR?=
 =?us-ascii?Q?6CsAr9Wf0/IW6yI65AU+J6uGpCjzyLgvTWoQHG7I72TBe1o39Z7/IUJrKOFp?=
 =?us-ascii?Q?N+i+D+YL6N4FUnPwXcDk8QHSVOs8DRkDglSFekT3WcmyrbBGqkkncfyz0PTT?=
 =?us-ascii?Q?qU1rKrrQM+8Mcz4GbO5Znw/1Trk04qCXe0/m2WaX3f5MgGQx+QU+XA0p9yFf?=
 =?us-ascii?Q?cb14jhibN3T0ZDiEziyGugzrP8ZvbhTJXEFyAdyWuucJ+YndsmCLxfbLQHY0?=
 =?us-ascii?Q?cUlzSLM6RwYac2A3UT1pFUGH1r+cWVdOEaU3BLSXWUvKG+OMoxC1xfeArwtN?=
 =?us-ascii?Q?ESWqECY+NT6zsRgm6krTA0hgXl2F1OjxllYlfn6GBSGKTjhOFkUw8ArirIVf?=
 =?us-ascii?Q?/8m/q7rJTztK5z8TuOId5JGsw13LcZQrJQ7qdcuyxeeZgBNykoUNU3pwqzQm?=
 =?us-ascii?Q?o5/F7xF7tNZenTt2MlIDjAWHZ3gJr0irE7NjFb69RW9PwdaEfjl160ID673d?=
 =?us-ascii?Q?vnu3fOE5S9QkcqSxZEm5l4WQ0tEuqxtYl9MbN1UjitruWDcSqTaMw0G+Phmo?=
 =?us-ascii?Q?K9QJzuFOa1UZ0YA3Wrliz1OfSoX/CssGvuidRg/DmZjWlxUnwhvZe12/Kh+7?=
 =?us-ascii?Q?BKlTeOem6UG9Ajy8DVj+gvWGkmLthu6dsEburNwvA0ZBAXBv/B8B71zOYzWR?=
 =?us-ascii?Q?23ck4rMnPZGdYcXRGhNexwLhKNQ3jRpmYgwz61gZfVW1NkXSKR6ZTbylN1/m?=
 =?us-ascii?Q?raMf+sPVyrDaSRdWjBWEU2LlVEGdntlHPT25ibecn9jTeBDIsGl1M9olTEjR?=
 =?us-ascii?Q?x4yWphwWgrmDW+803tNxR/TePThusof01I8wA2nqC0QzYGjYza+9/RWc+jIB?=
 =?us-ascii?Q?h4i0Nxc7XyegFyaJ7Hv5dxCZFwaKi1IO1BoMUjhB9AU0hZsMb1VBuuj+opcS?=
 =?us-ascii?Q?9Rjxt07JPIqsPSd8VTXrw3zGB9vDu6ESgYl5eX3rSrrmtzhFLJozzkJ4Dc/I?=
 =?us-ascii?Q?loWCgsQrIt4gja+iTmexcNtc+Ururci5eGrEnci5hI0MRiwCJTGmq/x5bcxg?=
 =?us-ascii?Q?Yz/OK9lfl0fl6k5WinrkJ5ctME97dyfJpv/y5dZFAPlBzP53ebUCF670ST67?=
 =?us-ascii?Q?HUGUMLl+BpgH02oEiVB7D8FB4lC1yATiHpDrejodc0i6ZV8tJrh/yRAWsqjA?=
 =?us-ascii?Q?7CKKZLmFagQvk9DVhWKLjLqjE5jw6lThPNOpthw+ZIJza8NwUr9W0lMnyB9p?=
 =?us-ascii?Q?93/RdqNpfD3FSCGQUN56/2cYUML0Tf38qla0oxcj0pum6MnmRfNsPZtGk83f?=
 =?us-ascii?Q?sPZcWU6tszp8sRSumpmwkTyKgQU+jdTJQxefhD5qzN6Ip/YqpWKSsfapT1U+?=
 =?us-ascii?Q?umHw5qhVzF24CijcDLhCw4zZo5CAfedOho3lP2UAaj3p8WczXL4u/IibsvfW?=
 =?us-ascii?Q?R4SmGIngjEWks7UDmkh+o47g+ITk39H9Y3fNY0xh2lOgIzfkQW0KgLfHcQnp?=
 =?us-ascii?Q?D4bmGbngeK5v+7jLIz11p+k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B0BDD2ED9CF8F747AD4159BD6A0E3F27@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fBAMqUuB2FGqslDmizB17AvnP2nS7e31aryS7/FG+TIfduzgzlmmaPSE7H56cVWXE547QbM+46Weh6SKy5PD76j3QZIIApFOExxkPOqFLgykWnDe3Q6gwfSyg0XLgsQNv+YVeBM/BcVwArMP2xtkXJ/OEXTXQMPjXv01qcr/v+ohuxN6Yr/wz4NE4/ah2w4olMv3f5nl1BtFUefkl+FqXK3zlntPd+BV26RJUd3+gzykXtkSIYR8QO+/2b6pXZHO8PZqJraPFwP8hkUNS6bGci+/etkUN+7w3DDLrbpBzQL7mbCq1eUAk9FTK3jiudDsfNsyWL7bdQ1lQqQIghmEW1mu8A8XzSkFaGeA2mnG5X9eNJlD2jP5AXMeneeqP0LzMEEadc106LpN84TTE23AXhYx7vS9Z4OuEIJdZxaf4+9Blp2GxweHhRTLyQXd9/GFiEp0sQRdBVcKkLDPKI1vd4eGYUbV7nGsd8aUq0Gr/YdIcqytg5tooRYCP81D0nTui2uN9IVvmbo3Xa4ap+fCjLnutjEHy0zBrXrcL2uBU8jb+d1YheuBlz8eATxVzQXDUiP1vtL4d6r6ilw/zkblAYPuRjm5rkJCtSV2+cknw8K2IDjST6lL9+vROG9S68y0Z0WGRLReaX3kV5RbP/xPHNbRBpB3UZF1oCjQ94GwO0cjNt5rxbw/GnFMPUjhpzWa6vZVMJZ1VzLlXTwl9HOTzXSHskqF397M7UamOv2/tNnPOX0hXAkJZjA2ooFakWyrA1kAuC33nUGLU/XkskpX7WrOapWwAw4MQencFlhNitSXWH1zdVcD4Yxbs8yRoeHZVLq6oADYJbxD4WZA2Dl8Lb8GdVvfrOGGOfAAEAqCt7s=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ad56f8-1b21-4473-a9a2-08db880616e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 03:13:13.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WKTc+BTX5rUTbiN2hEz6tj57TUlk8lInaQ5V0PYcENIYHAwkHsJ1Ct4umLQMMz3jWmjrsB3LiZteAsqrq6kW72y1Y04DwWZOxDdWUb58hOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jul 18, 2023 / 13:55, Niklas Cassel wrote:
> On Fri, Jul 07, 2023 at 12:14:55PM +0900, Shin'ichiro Kawasaki wrote:
> > When zoned block devices have max_active_zones limit and when write
> > operations exceed that limit, Linux block sub-system reports EOVERFLOW.
> > However, the strerror() string for EOVERFLOW does not mention about
> > max_active_zones then it confuses users.
> >=20
> > To avoid the confusion, print additional error message to indicate the
> > max_active_zones limit. For this purpose, add a hook function
> > zbd_log_err() and call it from __io_u_log_error().
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  io_u.c |  2 ++
> >  zbd.c  | 12 ++++++++++++
> >  zbd.h  |  1 +
> >  3 files changed, 15 insertions(+)
> >=20
> > diff --git a/io_u.c b/io_u.c
> > index 27b6c92a..07e5bac5 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -1879,6 +1879,8 @@ static void __io_u_log_error(struct thread_data *=
td, struct io_u *io_u)
> >  		io_ddir_name(io_u->ddir),
> >  		io_u->offset, io_u->xfer_buflen);
> > =20
> > +	zbd_log_err(td, io_u);
> > +
> >  	if (td->io_ops->errdetails) {
> >  		char *err =3D td->io_ops->errdetails(io_u);
> > =20
> > diff --git a/zbd.c b/zbd.c
> > index 3069ad1d..047489db 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -2222,3 +2222,15 @@ int zbd_do_io_u_trim(struct thread_data *td, str=
uct io_u *io_u)
> > =20
> >  	return io_u_completed;
> >  }
> > +
> > +void zbd_log_err(const struct thread_data *td, const struct io_u *io_u=
)
> > +{
> > +	const struct fio_file *f =3D io_u->file;
> > +
> > +	if (td->o.zone_mode !=3D ZONE_MODE_ZBD)
> > +		return;
> > +
> > +	if (io_u->error =3D=3D EOVERFLOW && f->zbd_info->max_active_zones)
>=20
> Can't this simply be:
> if (io_u->error =3D=3D EOVERFLOW)
>=20
> Since I assume that each BLK_STS_* in the block layer has to map to a uni=
que
> error code, so if we get a EOVERFLOW, it has to be because of a
> BLK_STS_ZONE_ACTIVE_RESOURCE?

Right, the check with f->zbd_info->max_active_zones would be too much. I wi=
ll
drop that part in v2.=
