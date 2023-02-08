Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04B6C636CC
	for <fio@archiver.kernel.org>; Wed,  8 Feb 2023 08:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjBHIbK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 03:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjBHIbJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 03:31:09 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD44F457D0
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 00:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675845067; x=1707381067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E1HDtkCdc9Z4vSPWo1xFtyRKAHFOnfqpig+eHsrWpyc=;
  b=avaDEqM2G0yXdaZb6iHgGRVDARbB+0j7HvGZzQLkOzu7HlQCq5mRP9de
   L48YfawRXDn1TQ573gtX94s6Xlhn5bJch+PvAAGgmiwhavEDZp+XrgTH0
   HLpRNb4bz45BW+0PzYMp2Oa/RQrEZaBHSHjNFucAltbWH1djbs4T8EnAL
   8H75OgIr7FZwdHcr1wgrR6T9spsBZ6IAoC1wc1Jnf4Yf325+k2voeOjaL
   9OxI06SGktT5MpAHQBA99bLo6KX8GSII+W7Lt7TXF2SUGFBowV2rBejnb
   UsPbEIWHCli9ZTb4GPiP+taXghak0r3HBWzjlK6lMq3Z1uQj/ettzUCHA
   A==;
X-IronPort-AV: E=Sophos;i="5.97,280,1669046400"; 
   d="scan'208";a="327092205"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2023 16:31:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeUfopIsbQJKIhaLQd5qN/+9cbjaHD3cxgCV2YVvZzGogUt61LTqG/b9jlcJulGJY+tY34FLnqCx9SfETy6gpkMlo61Ip5QnkJalTokdA+UlczDuBQ/ulZIfriFhQlScQwOTL365GGNSHE1UF2xD2YU0RgFrBmUdjxSZeY/kHbKh5R4ajlC/UjKOeZ6d4oARmMVsc4a3p9Hoq8Za6aPI63jENFTN6Mnis0yAKPfarF0VZR5JzkPNqcWoj+RPsYErd4olsd0S5fItC4ZKQGPUOmddW+bh+DHCFIqqeStQXMtbIaqbW9u1XA1f9fPFXrE7MpsCt+JTxPNDGLEtPpsKhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZOOURgqBmhLt7N09Ag2xueZxI5kyNM/qYKwTX92Dho=;
 b=nkfp+LACuFGer0XBqPysvsxkYDYU0mIKfApHRpxkw0HrccVEp9lH8vQsrGM7su5lgrwVNQnxd/LIt0nbTHKOFzSeSJ8EA1rdGuk25JBd2H6y/rA9bRjpogsxEk0GZXDmyYgU5M30dGkUQKevZqq0A6R9fjxB+gSUZGQkaYa9+o8UfRaHINTvmIwNTMQ9yEImWTSkHCBxkMzruCqV7Wg4nIuE9vIF2FeMgnxCwaEmbrtcqESFmRwF3ZImCDBefcN769A8EYVQRK050P4ok0FuF/yRGwRJjidYs0+yTsBgT52jF+zCs6N/7ZbmNe9eXbWfx8ibpTP3xLgT3R5yL0muIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZOOURgqBmhLt7N09Ag2xueZxI5kyNM/qYKwTX92Dho=;
 b=lLEN4JpMZM3wVR7T7mgi5kl03ZWsc22tvA339HVRxgQYbpxoAeb4Amu61rIs/0w+GTdC+vY/Wi/ovc/VgM4pwgyrd4LHb+KfIR/EBpEtckNWiC03TMPGxoikXjZozVrUSP+WUkUhKeE4RDRFe4CBOSYsLdvUvJdyRY6i6+hhf9A=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BN6PR04MB0786.namprd04.prod.outlook.com (2603:10b6:404:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 08:31:03 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 08:30:56 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at
 file set up
Thread-Topic: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at
 file set up
Thread-Index: AQHZOr636sPQv1gG3EyY5zCqskmisK7DhUMAgAD6ngCAADnyAA==
Date:   Wed, 8 Feb 2023 08:30:56 +0000
Message-ID: <Y+Ndvgyi4homNk8u@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-8-shinichiro.kawasaki@wdc.com>
 <Y+Ja5jyZq/snxRpI@x1-carbon> <20230208050329.zwk5xeero6vzezje@shindev>
In-Reply-To: <20230208050329.zwk5xeero6vzezje@shindev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BN6PR04MB0786:EE_
x-ms-office365-filtering-correlation-id: 88f6787a-e301-4b20-31f8-08db09aecc96
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cfa7KADh9sUSjkBy6eAGHDU12mTrmY82QkbLOtBFQSJt3ra/YLDvXTAlnGxvr5iP3hWtnfF7tsNwvu6KZeK7umr3Tg4jX1siLOdfBosYtw/Qq36qma804lbgvx79vXyOgO0L031q5/1TFSYUSWy9XBmLD7sz6WyCoZhBXyLzowjDKSOQDo1+TiHuYYM9fYm57YDuAIhFVbdQKHCpT3WT1elVb3eeEofT6FxYvRLJ3BXoP2evPj/oRio/YVBR2dAmbTV2XNpS0n/sF/Y7bRHJRS1Epr0GFfVEqmsA/+LJZnTAr8nihluxjfL0R1bcQPicbo+gmqSisKLcU9UGBfgVFMtWSV3/fcS83x2jE5MtLACjyehAkAqnFWJmfd73uBe7oq1rZ7T3Z7NXc93j6vZTrjpJCW9M9ehyY9iKy8cHu33dBUuWaCfwszmAudEkEzt/OSKY4880SZKUafmE0nJOxITV1lQi57m0tCX3nNuMeyUjmDwD2DIzA83xBkng0qY8xbTyhlmM3SPKP496A7fomysfegz8ar1OLciwhrp9zRgglgXhKHAjVwsA/yzDpguIiSNr4t+jweZsdhFuT/3ijI8p3HtAieZYmH4HaR7T2jLTjDmTRc7/EjuEqegC5Fg3MDP280dUB4dHf+nG1vgb0WXU5yOYF8xv1O+ek+hagFFRnV/XXnLViCsEEHiqn/wvYnFZaLTNvkETSFor62O7utqiStE0qbumtoDriu/HtuI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(83380400001)(54906003)(6636002)(2906002)(38070700005)(316002)(76116006)(15650500001)(91956017)(478600001)(122000001)(6486002)(71200400001)(38100700002)(82960400001)(8676002)(66946007)(66556008)(4326008)(64756008)(33716001)(41300700001)(6506007)(8936002)(6862004)(5660300002)(86362001)(186003)(6512007)(66446008)(9686003)(26005)(66476007)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JUzHxft7TkvfN+HRGT0AM+hPUVM8dWqC+nu1B5TTzga+bhFnv6WG5zddVeEI?=
 =?us-ascii?Q?9FOvrOcZ2HDZNCUTtV2bGHaqUakSYotc9V7zX/XRW+E3gjtIarwpg+LkfKcO?=
 =?us-ascii?Q?NIh4GEnTq+GqwyLWcADFs2V9RI18rixXVhwFv/prUwYMBYT7S6szjxIWJ/Yk?=
 =?us-ascii?Q?dPK/ACl6bgobimits/blCK5c/iY6RTdRlwwgPFe35ZaeUP0d6T+US9vJBfqJ?=
 =?us-ascii?Q?ELNthNc7uyfkM9IP1DIrx4Yv+h1u7jhnWVdwhUZUjgpbO7pVFh7cgWGwg/a5?=
 =?us-ascii?Q?vdqDDQbbB10kkhub+WiSSFXLE1MRQdmgqFN+aqJ0xzzYpM0VPdXBEKf5rJ48?=
 =?us-ascii?Q?YbfY2TwBwuxQ5+W9I4lGF0qczOfdjL9NCUO8DY+ml8qc65wMctE/jK1M0hQV?=
 =?us-ascii?Q?SSQKIC9JZMHz3GHvhxT7xDIJzb0eICHEoalL5Xo3RsrhqxIYp5tW4+LR5dcd?=
 =?us-ascii?Q?X5zETqJpqLuwsmxLwCjfnKpyxeyf68bndF0pBPNJgdnXH7xjNGBuXYt496mF?=
 =?us-ascii?Q?4IODzvP02HHMY0a4yQcewt0O91oDAgNfvirvOfal5rItR5r85LXMCWGghWcA?=
 =?us-ascii?Q?ksOrKfVCw9uaSLhEhT7QY7abppgc8pzIjHc1Xdy/bpVHoTu/6JK0YBUYf3Fp?=
 =?us-ascii?Q?jffIrsWQBObbfr+weZoE3FV9ADLqIzyVzttn3HB0tjpBN36OGcmlb/Q+hOQm?=
 =?us-ascii?Q?pzU/rc/NKZLhI+sD6TALpNJ4Y15j8dBGP/ifKri6K3UYB2oh+XMVC7C4/1/J?=
 =?us-ascii?Q?LWCDGRGg6KxZC2NgAEKwTDra76kvQi0sSFGJaBHIL+kIhN5VjoJgagqqmA8Q?=
 =?us-ascii?Q?2mt1LV+Y9Y4ykjz7HWGO9mgVh53GKqHXXseZxhQdlU/6m7X5hMsbU0ZNdrT7?=
 =?us-ascii?Q?XjxFq/GVn3CO8aobyyjZUiCm1KW0rujYSOkObvCoNUd/8GOlgTxutWaiEMpe?=
 =?us-ascii?Q?ptUNSWvoo7hdUHYzXaKHGXIV0SAe9ed6t/o4b4MlOuZ1Bklkve074yUBlhg8?=
 =?us-ascii?Q?7+RWhaq2l2jTKU+mSxR0wE+CfIogTVTte3mWxKogUmvvsKZUEeMCIoTrxA26?=
 =?us-ascii?Q?8bkVkS/b4dwo6IOY5w7izwtrVwpmULC7yruMhtM/l3pph/TQi9xa1E2+Lx1y?=
 =?us-ascii?Q?PrH+UokaBwymc3juJVtQPVN7ES3CdQKAw+SjeGUuVQRKPdCaah1ctKI0Hnie?=
 =?us-ascii?Q?ThwAnYeXMx6/zlmMS4WdBQiA8dkBQyncQpwgQVRuEPZBP1PmnILFjyZdznJF?=
 =?us-ascii?Q?nSG5DkYkBlzrGDyQpTbt0vDsxTC+f8PfjDqgq6lgGxSu2gFr56K6ClsLZxc2?=
 =?us-ascii?Q?6J1KBmR03dXdITNgRQU9mbC3V7Xee8Bf+Ih6gZncva4ANrmivsBGLsP5cwMV?=
 =?us-ascii?Q?eJElzcYJXpBbsmTRY0tY3BU/9TGFuHxcdMXWUHaoiSf0L9D5TxI34hqi6ffw?=
 =?us-ascii?Q?rNcXSpcDqyEi8lGA8C/QZKoCXmJGxQk+8io+gpSpciU49zzv8iZoas3Fvi5g?=
 =?us-ascii?Q?/CRSUUC/NgPuehzaZz9vdj/Ya1JYdvJ5t3bABM1RIxUmBSmmqPEic0/2FEVp?=
 =?us-ascii?Q?mQeEoVDuu9DggCJwb66kCzKA+JwkGUH79hEkOaKhyp8eSFTn9ot0ORokb0fr?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32C653512CC92648A07D8F58CD34A627@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: K2OlbTi/0sxu7WnERg3nNacQc4eEGadUD61Ps24ryt/69mlrsOH0wxXyf2E0NJHR+5Cu2MpeV/l5/UH+Uylsqf9JdRwTy1pQ7xcMZyhCkRps9YspwnNhnNx/p6ELQKWX4ypZK9qRf9K0XGSZ2L4QzobMa/riutqF/FVyVkJeiRSIuFx+1vUyX6kb73pcCbeYXORXP+xc/HOx+lRwxQytj0sx974v7Q85mWTKidlQpn0PrPARSiTajfwkcBCZ7YLzD6vBEVrH9o7q4QapJot4HblJI94GIuOuI6mFBlvaTXCcmeQPXBtbwV/nDbGMhqPesLVBycA0WWLrIXC2KyYewOkt3zBHOCoVS5P/08rADS+xBsGIYxZF6A1iXbMLGiW2Im7/1ngBGmQV4CzaGB49JmWgCGmK7AQemLBDj471LsBJYnm1O3/IjDdU03kvcFYPuxtj+IhyWEqzpT5dxcTxoccrXtoaBCywqpryqwyYklAF6+tyTbFn/OzdxwKgb34K+MA7jknoL3SmJU9sxgmKNMEhQMYzsQsXoODfVRIlwIIXXn/p4LmkPGvCKsM4SjXkAfRPWfs/0+ABWlV+XMViD2w8mqKCTKv+YLgbUIcaFMoSU2Lt8FtGz6VcfKs6+RGfGxPaQ731+bfn/BdggAFFD1pr/RbYuB12++EHXSMsHbVB6k8mCk3N9jME0VtBXBSwGOeIInXyN63PHicqKt0z+9UC4Np88pkUKNn6XcuKwOcJ7jUOjHJ2THe8edlWBYuLzpALPOR/zpGUqYttjUK+eYMEEUIQAaIuoCjNw/xmQhDeO7Vnr1uR6dRV5+/5dj57
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f6787a-e301-4b20-31f8-08db09aecc96
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 08:30:56.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KqoGZj1MhQcus9Dock4J+kUxYksWYRaTrovMC3ZhrzJqNygI1blWPrAQSvSCAHLW0BczZBXb/HnYaCL9SqWy7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0786
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Feb 08, 2023 at 05:03:30AM +0000, Shinichiro Kawasaki wrote:
> On Feb 07, 2023 / 14:06, Niklas Cassel wrote:
> > On Tue, Feb 07, 2023 at 03:37:38PM +0900, Shin'ichiro Kawasaki wrote:
> > > The valid data bytes accounting field is initialized at file reset,
> > > after each job started. Each job locks zones to check write pointer
> > > positions of its write target zones. This can cause zone lock content=
ion
> > > with write by other jobs.
> > >
> > > To avoid the zone lock contention, move the initialization from file
> > > reset to file set up before job start. It allows to access the write
> > > pointers and the accounting field without locks. Remove the lock and
> > > unlock codes which are no longer required. Ensure the locks are not
> > > required by checking run-state in the struct thread_data.
> > >
> > > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > ---

(snip)

> > > @@ -1252,10 +1251,6 @@ void zbd_file_reset(struct thread_data *td, st=
ruct fio_file *f)
> > >
> > >	zb =3D zbd_get_zone(f, f->min_zone);
> > >	ze =3D zbd_get_zone(f, f->max_zone);
> > > -	vdb =3D zbd_set_vdb(td, f);
>
> The zbd_set_vbd() call in zbd_file_reset() is removed here. Then the chec=
k is
> done only at zbd_setup_files() as you expect.

Sorry, I missed that you also removed the only other place that called this
function.

zbd_setup_files() calls functions that are named e.g.:
	if (!zbd_verify_sizes())
		return 1;

	if (!zbd_verify_bs())
		return 1;

Perhaps consider renaming this function to something like
zbd_verify_and_set_vbd(), since this function is now only
called from zbd_setup_files().


Regardless if you rename or not:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
