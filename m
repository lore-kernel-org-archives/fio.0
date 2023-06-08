Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C618CC7EE25
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 08:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbjFHIKR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 04:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjFHIKN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 04:10:13 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA4198B
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 01:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686211812; x=1717747812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5rjbzEIfDzfkvJ9MEwMgVHgYv1GVTsFVeD3qmEq3Byg=;
  b=PAfZpct0BnnU2DU4RXNpHDpE2D05CxRDHq2o2q2XH3LFmVjLJTj+ypiZ
   rvqlJ//n3vLVM4J5J5iDJsV0HwSca8t3h+qjYnpwYRDtouUj2caObvI0q
   2mFvySmd8Y/jaG0o6jCk671As+Uci+oFLXSIcvs0anViGp26MFJkUbqcM
   nts1BIPKAKcHpP2x5Xad8uYaXAXW18p69RR8dmUSJJpofYYnXjJ/jKZKl
   Xeyu6P0ZGaqpWxDjfwZRwMNjPQTEin82L5KO1LUhkoW3dPgKnyGZjQLiK
   OoXTYSTl6dSkUFbPigxSsEgxGZtYQEtiIl6hHOpv2UK/z7V1n0B8KrIJ8
   g==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="233012743"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 16:10:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSzXlyedLEW1SfXvsHnjqHZ6gxA6TgIrBfV32Egi+dN3HEtlMCQ6THrbJayySJtyHG4o8ZmE6hA8KowSCYwb/IfFCVtjwGblD3VAxTbfcxg9/rKsCYmy8C9P3p4i3o0hx/Ko8zPy6jdc3HVbK0Us7WzLeVMix8/o4l/jpanIlfLO+KuR4E2rbl8xlSZrioVjKflU9ApjstIf/UJIC/4XVqG/acryyOdO2mD4Sxr8oSz4/zNCNQqqdL2n4ysOC1VfIrnVs/6t4+J7X1zTS6Wc6pXz/2pnlKnh6yryI4opmstippIDTkYImohOjMilZqxOlo1xffLzHBAzFu8EyFxK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvNW9Ughags2kKZSp3E4y/GnxB0wME5XMFgEN1jznjM=;
 b=d93NgHy5y4K7dup/aL0eVdmG0YYpOJS92+K89jOrv/lHDhzwPQbxTgJoRzRlMAC6Kf+8JkGTp8PaRylazw3AbHSAfunSvuAQ4M2ynZJ4U//qGnV5VWot7yu6h9zRqbqXbUlcuFThWJfc52z3qt/xP2bSqEYQgzQIP3icUXpdGK6/xw3atl6X0dvUaQl+gYmbZj9OfJ1zbNohYmEEV5Rfa/kEhswZ6ZvJ7JfK/OIqdLenhu0WsDmGlW2w2cEDsQjb4RpM6Vk2E4cdIGJ8+AjohvwTkdlHWPX3hiupDeem5/Xc6arPWXoDol/2rR70wdERpYr43Lh6Iyy3qxp/7Mj2jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvNW9Ughags2kKZSp3E4y/GnxB0wME5XMFgEN1jznjM=;
 b=s8sPTjeojhbMPMQnFGQ4UTMofWal2x3z8+2OY8lR6ZrwSe8sXBBRaNgHRARmwD5sNrlgd56a2iIL6c0et7ccZQdb6hedT/pH+/qgJZLCWQUhJTgKZitSIvn5deLZiWCp18sfeg7M+Cy4saW+ip0fOae5r7cnqicrvsvtXwfKEbU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB6314.namprd04.prod.outlook.com (2603:10b6:5:1ef::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 08:10:08 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.039; Thu, 8 Jun 2023
 08:10:08 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Topic: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Index: AQHZmRqjagW66pJkBUCQGUt1g3SDNa9/UimAgAEVY4CAACd7gA==
Date:   Thu, 8 Jun 2023 08:10:08 +0000
Message-ID: <ZIGM1waG1/wgawP+@x1-carbon>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
 <ZICDCbgaQiZWdMpN@x1-carbon>
 <gp4w4ente632nsyp7llblq3hjbnnpfsw2drm4s3vbhfkrrfq5a@ok2icgcyievr>
In-Reply-To: <gp4w4ente632nsyp7llblq3hjbnnpfsw2drm4s3vbhfkrrfq5a@ok2icgcyievr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB6314:EE_
x-ms-office365-filtering-correlation-id: d14f8df9-346f-4435-3811-08db67f7c618
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /uXEghgmQoHZd8YFZ2I1gCIU7s8uu1ZpZdezEr4Fo8zdMbAYggG6ineFe5RUy/yas1gv/0diKvp6aFSNoJfz9S5ba1VlZoHbPYjhvbZJ/3G+B7P8VPqHV79vfThWbOPp1eCUQJP7Hnfb582r7DGbQ+sF5E67fr0o9UnIqWWT/ueqfyKDQhQWUlGpDtcyQA62zI32G8uKOmRj1+qgUaAJrPEbMl9SlYw/QhG3j98DJJtqePSJ62e49uwr7AbSGS3xFgERL59El4Zf1JwQTwU4B5UxlnSYYXQ8iviTl3j3CmprY+Nab0n3quNGpivhje9y9eWFHU8ETQ6VgDvGQUTyfoabsPn8t8VEQra5OBID6V6CmwN3SWTBrvZ+UoK/V34CjyzcvKf1TTnA+VUSR778bp1gaE42uAiKrvtaSfasHrJnv+eyMhmthI4mFMOBP9hBtMW7WtSwsvqPVG5RtMwnsg9UIPi0ZjE0zuiG11J9WMoR5WWZ/b2snGKlY9ses8sba2ZZkJoDBRCOTECOg7pIGuNCyiXU62318Fs1pDh6Ur/PCueJKPz8Oqciubrim7UGdYTadSZ3us3XxIX78U/tB18tBlilORHOzMTy6hRE5/6vM/gXBHxA+by9AMd7/CWC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(6486002)(478600001)(71200400001)(83380400001)(38100700002)(86362001)(38070700005)(122000001)(82960400001)(186003)(6506007)(9686003)(6512007)(26005)(33716001)(8676002)(5660300002)(8936002)(6862004)(41300700001)(2906002)(54906003)(66946007)(316002)(66476007)(76116006)(64756008)(66446008)(6636002)(4326008)(66556008)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mfwEU9lDvQYKyMfYAyaQMdimplqNJabJm13WH8534sGSmSrr7REj5Iv7cz7O?=
 =?us-ascii?Q?DvrKtytoSwCjDRNRYhCaQlPPVDKfa80QFJLlU780l/o4CGleB8dDQqzGxxj3?=
 =?us-ascii?Q?DRrBN2zsdYF9Am5ULxRPdqS8d1rfy8VuJ4VDB0OVfLfhZSdLS0P247Lyxvn6?=
 =?us-ascii?Q?qjFsMk1K/gUk0HoxKGkTmlHB2oeFmYGWkFfLFG0AGp/maAgsqbpzh0GSetO4?=
 =?us-ascii?Q?Gbb8HncjSdkSCnx3eoBIwiRTeSkZoxdCI7h/dSkay0vT8ZREgZ7n99GdR6KQ?=
 =?us-ascii?Q?En1uMA3QkBEFRXLRSpTfHBUhkCPbr+VwD4oMyRIPfGdquoYKm5xDK3hDw641?=
 =?us-ascii?Q?JUdVXn6nhE/vaCSGffdQJB9X4vuHRzT37v80PeYUCEeP66c1iUh1OMNDpHqg?=
 =?us-ascii?Q?SXp3eOiBB05SIqMKI6dmb8Tb3UGgrP0FR2hMef23BnEY3kiCM3P3sWSysx6E?=
 =?us-ascii?Q?1Z92F4QfyPpnRX1d4Z42zGVndML7ddFxkuu8JAaI/smSKHDOnDGYcFXBCwU0?=
 =?us-ascii?Q?zy3RbBwdxM3CNjF9QqTlv6kZq/s2lu7Yk3MkADNyUxwrHj6pPCyqoaXxa2YH?=
 =?us-ascii?Q?0Fd3ZYog6128/7Brg7hMW8SYEuqo8SWWcmR3by43WS1rXNpMLmf2DgtlXGyw?=
 =?us-ascii?Q?MJS2zBm8vmsA98mFUOU52Q95pVkWxyVD/9A4RlLKBwlzNszxiOqkKNbRxMaM?=
 =?us-ascii?Q?5A2lceAD1t1Ng4tR0s6+lh9SYBqr3GbtLS4VyHNpbOT+jezOwfjvWOpJKq98?=
 =?us-ascii?Q?wWPImfjlsPgqI5I2zsUBRwR2uz1vyv81mgoxveJ7J0pyP2MOtX8ExLpPnn84?=
 =?us-ascii?Q?x7fUKPbuJMnR2xK7524HNrH25rcjHttr9MmCY4zpCX2Lqm+21u0AvTp3xz/M?=
 =?us-ascii?Q?UyKgG2XK/y0L5G56IeJW9mRwjUvCo3vfgeJwltEjibq0p60F0VDBGvuf+KE8?=
 =?us-ascii?Q?n71ObuxSNZffdTylAi/biRG7oo982krE2/RMS8RWKZ+jZ7xkqbCUDJbe1LBU?=
 =?us-ascii?Q?GiEPfVrKtENYCj0ipdtLEI/jUIx/rwpGM0gIHs02LqcUlNG6iZ47+NsRWNkW?=
 =?us-ascii?Q?hIi6bMM23Kbu3hEvGJsoBzbBAzbKmDKcS2epu8dFSu+OqRVt80TCM18DKg8a?=
 =?us-ascii?Q?UBmNdKbu+TWw07O/rSZjGoDZhzz5q05Z/qjH9P2uLiofteikvyNIHI953rSE?=
 =?us-ascii?Q?nXrMfsygaB5yqHb7dtsqiv7OCNLuuqHKqgsgF7+rccmTZbrTqwGHxEUF4Rf6?=
 =?us-ascii?Q?CBJfIX3hy2xPbdZPbmdl+/3cb+NGThMlXH307s0G1jDT/0iJGKvb8iYlTic7?=
 =?us-ascii?Q?Gk4ghPYZEuy3L69/WUSDv0CbzUMqGcoNTKDzpU+D7chfsp3VpV8K4nxN5HxF?=
 =?us-ascii?Q?NL5yaKurCTr1d921caeCPrn4asMpESvrjeJb+EBNLLlxoecHqhuCKtzwZym6?=
 =?us-ascii?Q?FuuvKo79QnjGC7jyjpPvQCNQZis6V5JrxKXvON1ppJK8Hd2vJei/v87gR/Pb?=
 =?us-ascii?Q?0w60VPDKV69sgutPjiFIDygtz7y8xYYhx5qfJgKKlfPE20uJRr4vAyy9L63g?=
 =?us-ascii?Q?Pr92t3FhF2ZMD/EERcxHoTMpt7Q9RWhX/8yFkOVWTeR1kY2Gu6ArLQ5Yahec?=
 =?us-ascii?Q?Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C4851BDA6F8A24F84290A03F3162C1A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5ESLziEt64qUKzA75xS2VcRarHF+fDXm1eHYtkToB00qcEBrLhCU5GxWrOPxuuPA15yJE+VAHyPnIgmikIFeEDeV8s1514Tqb4Zk6ztcQrLd8Zd8Yj0xxk2krNVTXZxJH6tLm7Mi8QBitXqHpV7zD3SHcztUV3JF2Cpj0z3HFeQJcXALPxtxvaDx54pkSmn9E68tV3Jodpx8gT94dS+019EXZbhGsktLKIXKJBphfGBHycyGhK7o9JAbA3fV/gWbiZU/Ut9wwOuNEKBOU4HVdyfgsG16sgEBlDWqXvywnT+9sQLPFqpf94dj4V19l67BlHxxigDkyeP8TzZolZlikbJiHQzfh08QEPULD3l/2lDLBolycRA3UE1zr8h13c8KYtVqxbyni5Co/aXJxET/9gQP1DU7PN9bHgUBKMyK/efCAC1OeIVp9jTI/FkQVuwpgkPH/3e/keUndmKtPWJycS6Nmea4DcYDkLaZ9wuhRsCjpN+tSZ3ApSpbukDOBkg3uRWcFVkApupfTiHQ9/oOElnjKXDEhMCzh8ziZ9hKtSw/KiY+gC7gZMYuN5liP0SEYoMMjyQeBkoyWdDzc0CxBbGIdviazuRUxnZ9jXPli8wBVMUxiN52hQhv+ktMuEN2JYPgaRnstCxP3ItxTTV4jwc3yRQLVvH44pxx4aPBwI43pgC7z4UrzebdU84hM+9kUE/9C57LAWV8GS1/1uQGgf1dK7WLJjAeB5DYZ/clzEAAg0fIQyGwBbeqbAohqi+sSoup+EpBH5DmsE9/vj4NuAkvCCIKxFuFwQLxgb8xyHL3P82QpjpqJvkWIF0VvQgoalDThSeDN0IIJffWqbE02fDKYRfGH6/hoihx2/H5DbQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14f8df9-346f-4435-3811-08db67f7c618
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 08:10:08.0763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m6glIwtTDrrEgi70Y3eEWyjQjuQu1Y5muxZgio7KgFl0wGOYuT1V1opVyIZUqOiouBwJxpkNekqS6W14o5Q+ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6314
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jun 08, 2023 at 05:48:41AM +0000, Shinichiro Kawasaki wrote:
> On Jun 07, 2023 / 13:15, Niklas Cassel wrote:
> > On Wed, Jun 07, 2023 at 05:32:27PM +0900, Shin'ichiro Kawasaki wrote:

(snip)

> > > @@ -404,9 +431,6 @@ static int zbd_reset_zones(struct thread_data *td=
, struct fio_file *f,
> > >  			continue;
> > > =20
> > >  		zone_lock(td, f, z);
> > > -		pthread_mutex_lock(&f->zbd_info->mutex);
> > > -		zbd_write_zone_put(td, f, z);
> > > -		pthread_mutex_unlock(&f->zbd_info->mutex);
> > > =20
> > >  		if (z->wp !=3D z->start) {
> > >  			dprint(FD_ZBD, "%s: resetting zone %u\n",
> > > @@ -2048,7 +2072,7 @@ retry:
> > >  			 */
> > >  			io_u_quiesce(td);
> > >  			zb->reset_zone =3D 0;
> > > -			if (zbd_reset_zone(td, f, zb) < 0)
> > > +			if (__zbd_reset_zone(td, f, zb) < 0)
> >=20
> > Since you remove the zbd_write_zone_put() call, which I think is good,
> > I think that you should continue to call zbd_reset_zone() here.
>=20
> The two hunks above are difficult for review. The 1st hunk which removes =
the
> zbd_write_zone_put() is a change for zbd_reset_zones(). zbd_reset_zones()=
 no
> longer needs to call zbd_write_zone_put(), since zbd_reset_zone() (no s) =
calls
> zbd_write_zone_put().
>=20
> The 2nd hunk is a change in zbd_adjust_block(). The zone reset here is do=
ne
> just before the write command issue to the zone, so zbd_write_zone_put() =
should
> not be called. Then zbd_reset_zone() should be replaced with __zbd_reset_=
zone().

You are absolutely correct!

I confused the hunk at:
@@ retry:

For being for zbd_reset_zones(), but it really is for zbd_adjust_block().
(And zbd_reset_zones() still calls zbd_reset_zone() as it should.)

I really hate the patch format for using labels instead the actual function
name... Especially since you can have the same label in different functions=
.

Sorry for the noise.


Kind regards,
Niklas=
