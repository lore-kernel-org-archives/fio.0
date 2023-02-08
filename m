Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623CBC05027
	for <fio@archiver.kernel.org>; Wed,  8 Feb 2023 05:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjBHFDi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 00:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBHFDg (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 00:03:36 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957DB206A6
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 21:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675832613; x=1707368613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VefezvbY7djtaGG/1bfbSGGRi5gwGiD+XhR+ooQaTUI=;
  b=jKF09/JNK1jySlK2iVvy8Kay354GRrK5zxf+DzpG+PX31q7v+/GCs5o6
   KlNhtcNy5XILWm85qnaacyuAF1oagP/KBn7+pXytomigEMllzNY+EbqMZ
   fMCwM2AN8YeSB8Cay9odKR/Z+dl8qjCEyACd5DKaHX8HA6m1jh+2guFYn
   FyqzlKGJ/OPWfuAnT5pa/2aIogCwg2nMMFUGj/Hi5cGiTiz90jw1xQY7y
   vinm0DhgBPEuVPPzYZ7vhIJoIaewt458a3F3lUBw1J9XKjPXpxMPYVrAV
   22Ovfe1ARDVlZFlbssqXyEDa1rt6dj8BtY4Z8byGsbro4zOZTJdir2WSp
   A==;
X-IronPort-AV: E=Sophos;i="5.97,280,1669046400"; 
   d="scan'208";a="222814946"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2023 13:03:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THAPAppUUzIYQgopS1FzOw/GDlsFpRurfqmC+7K/DeKTMcq8BTiaDb1MqZY5eF/jzCb1I2CDo0OvgYEBHrijIJ7PYJKzB2yDGHu3DdB0J2jFQ/2zGWwVU8xxKWYWWQUz2IOMP7Y7P+AaZppdqlQ37BSATJV9pAn1S6nuVLcnPKbAeCASOVIrZOJhTveKAzN1iaWjWb51n3GszKovNVCWbnx/4OnxnLUnz7NFmRpAwnefJhSopg+l9CqpxY0Jcwl0/ULU1lB9YhyVx6/oEC+Ub9m8zZNQBOmz23/K65TlAaZvzCfMJ2MX8eS/J4Gl5fyFuxraRvDifg3x8Je+HQi/YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrOh9h28kfon4SVljQTJgGcwBcgZtlxyPMXnwFxPRnI=;
 b=UN/OtbJYPsSUTEDQ4X4FSFLHcQ4B+6H6jE0vmZX7d3M+YpOym00owyf7FV4MzuQ6qU5MR75AAijnV+lXbCS88Feqjoq1LdVgCHDcSfPzj5Au83rieZFlQ+aUdHc+EumxPj+p3XCjlpCFAB07W9tSxLwd1FOnUreRYTe/UXqxYoT+39cnLfCLaTbZHCQmxur48bVi/rR9t4qzt4luHdDpZtJq9elhM9NX3rrNyF2BplJvNT2omQfJAJsk8Q3Jo5m9RgEUFehIDZM50wImcClU+1m1siWUXyKyCJEz718kA70RDOubeIRJRu4UkTFiWlbgPlvbtblFRonW/j2eJj9bQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrOh9h28kfon4SVljQTJgGcwBcgZtlxyPMXnwFxPRnI=;
 b=sJOVNYC0HD+0JwK/51U0jVEmmEY2iBuN8FhSen7jS1LnWazOuQsnAGOltP4ruNJkzh+TNuB25pvD8D3w5wawBC9TuHdxDuBKUZhkWlEWEfUcapFbIsnvGMcqjmsdm2eqX+nGPiQnPFT4lGQNqfm+GLfNtojPJGBATCxyVRMhd6s=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH0PR04MB8033.namprd04.prod.outlook.com (2603:10b6:610:fe::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.36; Wed, 8 Feb 2023 05:03:30 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa%5]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 05:03:30 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at
 file set up
Thread-Topic: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at
 file set up
Thread-Index: AQHZOr63tk/TymyavEa/jTJuNP2+rK7DhUUAgAD6m4A=
Date:   Wed, 8 Feb 2023 05:03:30 +0000
Message-ID: <20230208050329.zwk5xeero6vzezje@shindev>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-8-shinichiro.kawasaki@wdc.com>
 <Y+Ja5jyZq/snxRpI@x1-carbon>
In-Reply-To: <Y+Ja5jyZq/snxRpI@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH0PR04MB8033:EE_
x-ms-office365-filtering-correlation-id: 5ba7aa35-4503-4c23-74ab-08db0991d1fb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j39UPrl8DfvPp1VfZPWC06U8iGEMpogV/KklXq8pIBOyhnsOOKofP59LQ5Twj1eW8tpHj2CMy6xgsL6aP8Ri6ZipiwyMrB+58x4egzIz3aUMKsxuLYR1phgpL+238mhr8oM7LM9DSGxuLUWgndDL64QtJjAPrB3WHC5hAbX8JGuS3f6nk43W1SgPzq7nD8WmHcmVZC3KYfifDV8GW4zdDs8RVDB+BbJTgVr86jj05+qy2wcCAfPUE9hU9hTkRr4q3daXNPmQ73OZB2T+pZt9ll6Ju5NLtHT7G6PNgITV2X+3o8GypLwN5biqzxzebyG7gXWgQrb5bc5AU4eWpawog7tVqujCLoGGNx6mSF3vY/wqmNvYVVd3RB82uy1rvjsX3GGdD+ZP2CCN0vE+BGgRgjGcHPqS7iViUO/46W8o3IFja/UMCXq4/BQZMZMuKeoT5viO9IW21mjdndONWVFB+MMMTuXfx02o+zLWiBWlu0872xcfRozqBOxQ9SVJBycEfb7p5LxLOj4E+Oz40/lUyM4y/5nECPuw3cN12r/vy9rLbOmRY2TzyQnAagpoGBgHCSPo/PoQCdDnBi4+HtzK3lfLN1EMommIle3uZ+oMexORrweTR1hh/fCLdhC6OHkitcxuwAtY2kRfJgRCFI4VUeF617g8evXokqDN3PmAY0Vd7EAXF7XZE4hswhHJ0v3oN1uaaWgB/N7kGhNf7la2Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199018)(41300700001)(82960400001)(6506007)(1076003)(186003)(26005)(38100700002)(6636002)(54906003)(316002)(6512007)(38070700005)(9686003)(6486002)(478600001)(86362001)(71200400001)(4326008)(91956017)(64756008)(66446008)(66476007)(66556008)(76116006)(8676002)(66946007)(33716001)(6862004)(8936002)(5660300002)(44832011)(122000001)(2906002)(83380400001)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ixiMLBgF/SL8LpX0qv3CGEK+qyDUnelG22Jz+JTIzM9S3mae8++6Y5JZdJl1?=
 =?us-ascii?Q?zwt4E+w1gfI2hNAnUYWz/xM3rbBylMuHZj9mVPPiTr4FELaDZxdmjuxBeqRw?=
 =?us-ascii?Q?wiWna7/w1WT0uG6ypSnWgjom30rO/OH8A/fnlQF1FIFXS1ZL7gooyu+IRX7I?=
 =?us-ascii?Q?4qDUmsEcI/PM2Ts0NFgIjsD+WuAPc18lWm3ohXMfnX7Nd/FQeUhPbDTe44yZ?=
 =?us-ascii?Q?/JGTLhtywF+1MqY28MTJJrYGUHPLbE7NNw3DJiSEwb15MCko2VIXInKG49hS?=
 =?us-ascii?Q?i6zznYK4KH0Ypf6ycO/lAOi4dlh/2U30ArnMng9tJZfHVWvU+1p0wohOmO7b?=
 =?us-ascii?Q?hNjIxr0BpskBa5DcaGdxcMqbVr0j72VLtpAO3JKeQCLi2Q3EU6DdsB/aH13R?=
 =?us-ascii?Q?FlCfBEdNnAAS1hb7DnuKRUkqqYwE/xahgyDfXVDUlQd0KDOJzLbUHWq18o9G?=
 =?us-ascii?Q?v1Ad3FtYr7r5MUJR+obG+CQtfBp0+EHQeMSGxOpTojBTAkyv/LaBBSAjtxob?=
 =?us-ascii?Q?IvztL0t9uY/E0xJYI2llpWEgiIHpEEfXQzJ/EGYGQRtDi4tmkJ+qJu0xD75z?=
 =?us-ascii?Q?ZZwJPmLD1ID8Wwk/SHSM1b5GQsSwYjoDkA5W0/KZPyD93WoDCXFIJZoGMN2Z?=
 =?us-ascii?Q?8j1w0AF+JrD1e7whQ4Rhwqsa/MvmmNtHKS42MBtmhHQoQLtrE04hxPZ+IcDj?=
 =?us-ascii?Q?LSGn5vZ/g6tXS87D3OhiS3wmN/NGfZl9PtVzBdVdXs+ueBY8+FW7sEN1U8Tg?=
 =?us-ascii?Q?whJomfEZBvk1EnYoQSH4Gk7mDO7v+pi9m/z4DjZhENSxr21G9coKt9R8+Uz5?=
 =?us-ascii?Q?FEdedE6eV5Okk69ADrYqQICi8DDD3cS1e8BRwt9jz/9F0totY/NnfQpgPKHn?=
 =?us-ascii?Q?hp5V9ORTMlbxkW5BDX71sJyAzbEL+nfgX4wOLn7Dt/sxG+H3nUHKSKXmBvWs?=
 =?us-ascii?Q?o5QtVoEWzMWeWO8xAcRZEN8Mq2jed+OBRAMMFVq/VwH1Lj0+/0D7Ch08n5TV?=
 =?us-ascii?Q?918IU0p4xueXBQg1sJKszA/ZJ8dlgZoummIrbDq3BhmLOZ/EevQwSnXoxbJf?=
 =?us-ascii?Q?8sdII1/lJ9wZYvaAjiZyAUWQmg5OSEamMbBafvb6JC1B+FXLJ3f9cZhLPOuV?=
 =?us-ascii?Q?Qo6rhyZdOwO+MJLfFgnLkNZo86UpURZvSGnmHRQE2CsiTjObrUSzGOsTxWnx?=
 =?us-ascii?Q?nwPnzVtYrfpTnmeiR/hv/i5+gKnf6RKy3rDoecDfztb/uH/+rD6vjgsKOtD0?=
 =?us-ascii?Q?dyDNcaZ8fEzX5JLKHtDBFMqIHkKsXuIRR9Srxontxi6/FHkYGlYZB5nyB+Pv?=
 =?us-ascii?Q?+OjglmsNlb5wQM4zBh7CzwlspRcUwTHWHIxIVMsHwZQ59xx6A+LttqvzZC2/?=
 =?us-ascii?Q?9IIKzQQU59d5uBca99gyv6NKSUjh2isExn6TCunyQMXRx0HhpcmH2kZASGEg?=
 =?us-ascii?Q?DvznWVd8IhqXmWT227bbdze2HGMFZ0eIGPrdxbfeAio5BA55Qm8EvtZidg+y?=
 =?us-ascii?Q?q0/+wSYr00GrrpVuqhNn4xQsZ2kxb8CcpH0vIchRUzlALlo/aaaTC6PRjpEz?=
 =?us-ascii?Q?BWzjD9GwEW3QzGdN0L4GTFvGCS5WUgDGjEHdH278ABx2JuQSEgFt9L2Bu07l?=
 =?us-ascii?Q?qZbPrbhaPr2pzUKtPUZtHL0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD422EEB7188CB4C93CCCA0DB37A8B44@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2O4uZyKePXJcitVU6s9KLXGeD4ew8Vel20w20ub88Ick02UCwxxJTEN0PZWhkpm/cJSXe6NlAJek6nHm+CXG0tAS0hafxX7ER2gVRtIWqvB0nzKXebkdU08bMbeTjvlV6cq2O5nKt5FhFaFjKkILyONS3+t/HhhKUgTSJl702OH/Uw1HWXTZG9H3dXkpCRlrqZ4I82Fc5uN6/y80bOQ5gVUA+3CJPSOvtZalaoqapQdtVLCdjgTcFWclioTAQuqRTILVsifl1p4Vg2CpHbCi3L8V49yuyYY3b0kxExYlhfLy9UlU/wYK8NFWSvzbUo94heOWEx2nSBtyNGCxbweO4PRYB8OVO3cr9VXqYsPCjEZ+eXLgJxaVMWHgTJwozB3tWVapoF6rXwHqgR+hgnvdNCBZifpqAW+kjy0HsMsQPiEzzFCUB8tIWmY8dVzBQydB5lwHm1t+MEj8+8nHSCXQSwMLcJ0AdP8pWcjRdkIU9JTd91oRO/YuEc8dhyp56RtjoxxOwnshbmqaE1HVoFD/nmz22CaP6JW2YpM81oGuI9wty6dtv3/jAlJG64Ja5qTDI9ABcv6/HhuIIDs2tBuAQqNkBsh9b/Vl1INhPg8RDQf1kkrFpPTm3HIL1V2X/TjhuOV/zDQyZe/YO4H052Nw3Loe8BoEA7LkTD/xV2Oh48x1IxmF/hg2C8UWAypt9Vwmsmp85FAXkXneCIFrbcNrIEMTRAkwrSXJgt3KKxeSZgHBq1nb6WjV6D1Re0VeX9VcpEQJ7CiA59N5yOF7rjDuPRdsGIgdFOocNeRCzEWn6v21uBGSh+dL3SW4dVIYITFI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba7aa35-4503-4c23-74ab-08db0991d1fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 05:03:30.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +c+SP6TmK70eKDKxkR7uNZy3WcCd+LjnMxiBoNF/UB5vmWVzJlwDeRkEUNayA86oHGDtqeVnOhrl5m7k/nHvzjRTMCb1VsK/WvuuniiWh80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8033
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Feb 07, 2023 / 14:06, Niklas Cassel wrote:
> On Tue, Feb 07, 2023 at 03:37:38PM +0900, Shin'ichiro Kawasaki wrote:
> > The valid data bytes accounting field is initialized at file reset,
> > after each job started. Each job locks zones to check write pointer
> > positions of its write target zones. This can cause zone lock contentio=
n
> > with write by other jobs.
> >=20
> > To avoid the zone lock contention, move the initialization from file
> > reset to file set up before job start. It allows to access the write
> > pointers and the accounting field without locks. Remove the lock and
> > unlock codes which are no longer required. Ensure the locks are not
> > required by checking run-state in the struct thread_data.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  zbd.c | 93 ++++++++++++++++++++++++++++-------------------------------
> >  1 file changed, 44 insertions(+), 49 deletions(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index ca6816b9..a464d6df 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1074,6 +1074,44 @@ void zbd_recalc_options_with_zone_granularity(st=
ruct thread_data *td)
> >  	}
> >  }
> > =20
> > +static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_f=
ile *f)
> > +{
> > +	struct fio_zone_info *zb, *ze, *z;
> > +	uint64_t wp_vdb =3D 0;
> > +	struct zoned_block_device_info *zbdi =3D f->zbd_info;
> > +
> > +	assert(td->runstate < TD_RUNNING);
> > +	assert(zbdi);
> > +
> > +	if (!accounting_vdb(td, f))
> > +		return 0;
>=20
> zbd_set_vdb() is also called from zbd_file_reset().

Not really, please find my comment below.

>=20
> The code from here:
>=20
> > +	if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
> > +		if (zbdi->wp_write_min_zone !=3D f->min_zone ||
> > +		    zbdi->wp_write_max_zone !=3D f->max_zone) {
> > +			td_verror(td, EINVAL,
> > +				  "multi-jobs with different write ranges are "
> > +				  "not supported with zone_reset_threshold");
> > +			log_err("multi-jobs with different write ranges are "
> > +				"not supported with zone_reset_threshold\n");
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	zbdi->wp_write_min_zone =3D f->min_zone;
> > +	zbdi->wp_write_max_zone =3D f->max_zone;
>=20
> Up until here. (Basically the code added in patch 6/8.)
> Should probably only be called by zbd_setup_files().
>=20
> Or do we need to perform the verification for every single file reset?
>=20
> > +
> > +	zb =3D zbd_get_zone(f, f->min_zone);
> > +	ze =3D zbd_get_zone(f, f->max_zone);
> > +	for (z =3D zb; z < ze; z++)
> > +		if (z->has_wp)
> > +			wp_vdb +=3D z->wp - z->start;
> > +
> > +	zbdi->wp_valid_data_bytes =3D wp_vdb;
> > +
> > +	return wp_vdb;
> > +}
> > +
> >  int zbd_setup_files(struct thread_data *td)
> >  {
> >  	struct fio_file *f;
> > @@ -1099,6 +1137,7 @@ int zbd_setup_files(struct thread_data *td)
> >  		struct zoned_block_device_info *zbd =3D f->zbd_info;
> >  		struct fio_zone_info *z;
> >  		int zi;
> > +		uint64_t vdb;
> > =20
> >  		assert(zbd);
> > =20
> > @@ -1106,6 +1145,11 @@ int zbd_setup_files(struct thread_data *td)
> >  		f->max_zone =3D
> >  			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
> > =20
> > +		vdb =3D zbd_set_vdb(td, f);
> > +
> > +		dprint(FD_ZBD, "%s(%s): valid data bytes =3D %" PRIu64 "\n",
> > +		       __func__, f->file_name, vdb);
> > +
> >  		/*
> >  		 * When all zones in the I/O range are conventional, io_size
> >  		 * can be smaller than zone size, making min_zone the same
> > @@ -1197,54 +1241,9 @@ static bool zbd_dec_and_reset_write_cnt(const st=
ruct thread_data *td,
> >  	return write_cnt =3D=3D 0;
> >  }
> > =20
> > -static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_f=
ile *f)
> > -{
> > -	struct fio_zone_info *zb, *ze, *z;
> > -	uint64_t wp_vdb =3D 0;
> > -	struct zoned_block_device_info *zbdi =3D f->zbd_info;
> > -
> > -	if (!accounting_vdb(td, f))
> > -		return 0;
> > -
> > -	if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
> > -		if (zbdi->wp_write_min_zone !=3D f->min_zone ||
> > -		    zbdi->wp_write_max_zone !=3D f->max_zone) {
> > -			td_verror(td, EINVAL,
> > -				  "multi-jobs with different write ranges are "
> > -				  "not supported with zone_reset_threshold");
> > -			log_err("multi-jobs with different write ranges are "
> > -				"not supported with zone_reset_threshold\n");
> > -		}
> > -		return 0;
> > -	}
> > -
> > -	zbdi->wp_write_min_zone =3D f->min_zone;
> > -	zbdi->wp_write_max_zone =3D f->max_zone;
> > -
> > -	zb =3D zbd_get_zone(f, f->min_zone);
> > -	ze =3D zbd_get_zone(f, f->max_zone);
> > -	for (z =3D zb; z < ze; z++) {
> > -		if (z->has_wp) {
> > -			zone_lock(td, f, z);
> > -			wp_vdb +=3D z->wp - z->start;
> > -		}
> > -	}
> > -
> > -	pthread_mutex_lock(&zbdi->mutex);
> > -	zbdi->wp_valid_data_bytes =3D wp_vdb;
> > -	pthread_mutex_unlock(&zbdi->mutex);
> > -
> > -	for (z =3D zb; z < ze; z++)
> > -		if (z->has_wp)
> > -			zone_unlock(z);
> > -
> > -	return wp_vdb;
> > -}
> > -
> >  void zbd_file_reset(struct thread_data *td, struct fio_file *f)
> >  {
> >  	struct fio_zone_info *zb, *ze;
> > -	uint64_t vdb;
> >  	bool verify_data_left =3D false;
> > =20
> >  	if (!f->zbd_info || !td_write(td))
> > @@ -1252,10 +1251,6 @@ void zbd_file_reset(struct thread_data *td, stru=
ct fio_file *f)
> > =20
> >  	zb =3D zbd_get_zone(f, f->min_zone);
> >  	ze =3D zbd_get_zone(f, f->max_zone);
> > -	vdb =3D zbd_set_vdb(td, f);

The zbd_set_vbd() call in zbd_file_reset() is removed here. Then the check =
is
done only at zbd_setup_files() as you expect.

> > -
> > -	dprint(FD_ZBD, "%s(%s): valid data bytes =3D %" PRIu64 "\n",
> > -	       __func__, f->file_name, vdb);
> > =20
> >  	/*
> >  	 * If data verification is enabled reset the affected zones before
> > --=20
> > 2.38.1
> >=20

--=20
Shin'ichiro Kawasaki=
