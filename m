Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613ACC636CD
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBGG3U (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBGG3T (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:29:19 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4911CF69
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751357; x=1707287357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HgXCr9hOQVUjNlyMvGWnHz4tv5YDz/9kAQMMTfuVzcM=;
  b=hxTC0mf+AN7M2Ng1INhqaqfJhUmfjBX1hZK9SjVJ46F2tbwQTTARNM6g
   Qv5c3CJHxNduBTySbk4TqSU0E+e93Hx2Ze6EIQRFvtCb/+jG3KLFh+e82
   57Se15yhdk9NuC+iYltxRkOIZwmgdt2vxj7BqSwoCiKDpJrAuar7arwCd
   p3c6yf/YXAGhoCqHcq+1x+bsrBZ60aeY04j55QZbbSoCYXFgIuVCmTm7k
   Yex+ocU0EeS3ivqiFYXrFxBT43gnqBN0dDdAVgBxDadmcJKNwxlvZNbw+
   8vmtNMCF0Mi5qrJqntecHlmgHpNImGidJr3Zk1MoDFbrB9Ro6kd6GL8L0
   w==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="227654093"
Received: from mail-dm3nam02lp2048.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.48])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:29:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1TfqcvDBcVeJTrgCpJhInpP9sFsIGAOmjhtsFZToKYMx8x5LEq6iaS9nEa1cSGSO/NbjBC8ZxkN+LbFrbHtBXRRal808afgJhtgSqlb3pdRBwpiNfG7vb1jnhcsVadFEMr52/k1EcihLSdl5RY/DbbRhmK2AL6tgW5CT8FL2GRq48VpAEP/YLOKeXNzhcMxgf/otz/9SJFOX65MhLaL6qy8Wnc9JrilyKI3Idtg9J8KxpAJHUzU7ARGllnKsPa4TooFyB9gTTG2dp2gOwXygoKObdHWVY3XXzOC6U3p4B8Ie2a2z85I5izxSH0M/MVl3OPxNqzWBFBRgzsUReOktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7HmB/0RY/63g4iJK0GRAHa7MQJKJ9VggPO9Fz2NO08=;
 b=MEfHUsqUo/3OwZUS7KXB8ecHsqqOyWZ+n4Q+yhNjw514570DT7CzIFFr6QaiLm3h7alLZ+dTTBj+1rbGcBIzsbtzrNWJk59tgXRBsjigNLZzo0EYUZffvj8VnstD+OIsBz48GFBHLEXJKES6FPlHQWr86hECPL6P7AKeA+KhGLmqwUm3V9ppYFopL/w31tfTM6faS3bUsbDTZlwkdztINbMLCWOhKTg+FSF3/7ToICoCZl2H3zxIWmatRz+Qtjv+06iDm5DWL09qWygsrIh29xmPNMd6jGjT1pT+rRk0MGP5n1eCbkZojnHSIV3UCzrziXpsAgRzrYLHWfNANV5vvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7HmB/0RY/63g4iJK0GRAHa7MQJKJ9VggPO9Fz2NO08=;
 b=fJoCzsj/CilICQZQeBEsg20P44sw72EyxK6wNEA4jfyw4nXhbNluMZqC7fqY70DOGmboFHahBdYKA8YIzGJmLgYHUK/q3AghPN0Eo+TKUVHafab/ip7TLT2Hu2XteqmIKHvgOYG57JJTLADlXK+Lyu2szaFx9qV2aUosnFD0gxU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8257.namprd04.prod.outlook.com (2603:10b6:a03:3e4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Tue, 7 Feb 2023 06:29:14 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa%5]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 06:29:14 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Thread-Topic: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Thread-Index: AQHZNFKa4Xxew8Afj0yRICK6lH7M+a62xBAAgAD8jwCAC1G4gA==
Date:   Tue, 7 Feb 2023 06:29:14 +0000
Message-ID: <20230207062913.ifblc26vpso46xii@shindev>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
 <Y9edEqAqMyiqm4tJ@x1-carbon> <20230131013752.24ayrybrt27w2u4w@shindev>
In-Reply-To: <20230131013752.24ayrybrt27w2u4w@shindev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB8257:EE_
x-ms-office365-filtering-correlation-id: 40fbe68e-7d02-47f0-f0a7-08db08d4a1ea
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ehs+PWusWPpfgFCJ9HjFFVBIq2Ygrvgbq639a7f2X5NyWsZqSPlYUz4wmpW4jqlqq8RCFiW4znlz1BbktTvlduQCylSVbrQv28v016UHsTRrspD+kyMeksK/zttQNTl50baP08Vy47DyJPVVVgfDVYOsUlC1DbdWIFnjRpQgqdd8verm49A7dszpkdIszkeMPmJWfGlV3diWub4+UBoPqGAl8w1swMC3C1D6vvs81meulAwucI9fs9qnkNifRHTcXbH5a9gjevXt4WSnAD4bd0tWYEOWV3j5M36kVX5pCDTsynlA1QCUi2uRiY6o+w5oiMgTFMqJUIz/3OBRlinXlXFjPzMzF4AfAcR0kKqK0dfKbkG/p5Red7CGHH+e+WGFsbnpWq8XIxZX6K/6SR2ssgIHyqpDk9+DMeN5ycxSrFj3iXWEI8odxEiCfGvRk9hMflstjcUuyHsIuoxtJHneL5WBngGr1EIz14UTDk23BZie3pRzW4tDraD8/CeMxwAYbgiIf+9TeM15+z39v7dKhYqRlMenFRNalrK+OJI4DnCKHYsa1v9xyGs+Z4TAg6A6AqVa7yfhkOV8FvEO8LU4ILcDruYEWZRBqgLa/vZF16Dl/wMll1y/6J1fb2fu9CCHXa9wxUZt7UCuOq6D8syG5HiLj9y3O9uPuIn6YEmvcEwgmqe76ngqRIS7qoipNUYMqo7wPr/ur6F2g0EvLCiCYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199018)(122000001)(38070700005)(38100700002)(86362001)(82960400001)(26005)(9686003)(83380400001)(186003)(6512007)(33716001)(6506007)(6636002)(1076003)(6486002)(8676002)(71200400001)(76116006)(54906003)(316002)(41300700001)(66946007)(8936002)(4326008)(91956017)(6862004)(478600001)(66476007)(66446008)(64756008)(44832011)(66556008)(5660300002)(2906002)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pdwSGpuR7I8is+5diMGfLSvRJFS0a53bLfi0Y9w9MPQkTNbkc3YvDJ6Z352G?=
 =?us-ascii?Q?1pd0MBDcR8OvqwXtYiaF9PaPA6tzPTBQSCoJsOQfQ+jiXYnoV4LRTZWfzgn8?=
 =?us-ascii?Q?CGviuNIBaq6uF4nY+IOWLiJCPVp1YC/0LE/EOTnRq7t6ty1Le+Ib0QKV4Ub1?=
 =?us-ascii?Q?o4JZj6tCxJghABucDtIaw/S2+H/uFOl6HJZUvjTvBUXt5uIhie6FsrUE/poZ?=
 =?us-ascii?Q?mb12cRFbyr2S+RRR0FN+09HQAqyIS2THOkUqLNd/RhJFw/FNc3BTFwaTCLmq?=
 =?us-ascii?Q?TdR04kX8IKn2rgYcWrvB36aHByZt/6HhTHb9lKvoq3y+K/sfxXuK+6mWkuH3?=
 =?us-ascii?Q?IHCKQQRRCwxt9T5aHwAZnDeMg/R3MjBuEiiUlEXpxvFN1ouF4bqP4IReErqs?=
 =?us-ascii?Q?+bXF/NyuZY8CDANi1Fk+v90DtV6banEU67VX+pAxYURTm/1X6da3FIoUViYw?=
 =?us-ascii?Q?gZo6g8hy9t7nU+GJ/zcIsYr+20RVXp35jV33jQSqvrPc+zmY83FxV2EhP6ME?=
 =?us-ascii?Q?LPMBfreyj/kEwJYp60JQLGuG/CZ9A1vVz7DgwaL+y3CGU1CwtKhJioFsJmnL?=
 =?us-ascii?Q?GdwoqUEnQZt1MbD+a8Q0rysBW65mP2sSy6ssxEBMynFvnr20lCzNa9dRSfDr?=
 =?us-ascii?Q?9GQu6DeEnmhS9iL3dYODCccVw5HfJTp4QsMysoW9QqNqhAXlk0YBm4KVxXpm?=
 =?us-ascii?Q?ctZKx/PFniedtPswmAXZ/tv1uo4NyTCASZZm1JHXMD/sK5DsjF4JrM54qpm5?=
 =?us-ascii?Q?An5MCHusJEkS3k117rpmkiCCRT0ZYmTlch/gUp/cHyBbkRgmzbQtH1NgN9O+?=
 =?us-ascii?Q?Ay57S3yjBjSMFthopaawpqKS14lYIq+Cb0xkrDvK1ZOM6WmXMQxeeG3rx1vQ?=
 =?us-ascii?Q?0QmS23Jtc8rXaF8Npawnp7EFfSJWg+XpNNQ4NOuPP8W7Gl6x66n8bPr0vwy/?=
 =?us-ascii?Q?ofVkDhhV5hN/XXT7bRYLhOCZ67aJeKOBmklOHYV9o0wkGcTh6CIBsdwKgHYN?=
 =?us-ascii?Q?LesJcLKX0xBMop8UOgUSo/xJv6ORYOMO3V3HhgepStOuZEYBq7U9XeW4aTYq?=
 =?us-ascii?Q?p2Lco1nVfF8a8LjFTUQ17/xo3GQmS7nEBJPagZIUf5391ll0Kug+5npCIE9h?=
 =?us-ascii?Q?5pfn21RLqtZFhUDzvL+IJzGPfuB5HhDKveqzgZeJDh94YMXW8EPaynp4WC3s?=
 =?us-ascii?Q?UAEgdttP6PtJmMi1MRlVCSvNOHUMGQYIZaZoNQdJe9Om2mkElkCImG7W6dI/?=
 =?us-ascii?Q?BT2E5sJeqbX5iK18Yqv7/sTcHktC83gEdVThZOlm465ChxdpEsvDqlfter6e?=
 =?us-ascii?Q?4ClXgic8vmPunQq4WzShi9f7u/S0E4wqRmRDSXuI7LEkDElQ6F/TcnExIdx7?=
 =?us-ascii?Q?hDtFfr6OwnHGfiFC0N9SdOTUitzDDXgHoxlVaTmXSLjgT4IozcGCJcCr1VzR?=
 =?us-ascii?Q?u2KLpsWYukKkOK42gvcbGGWNHRUMLehtJLV/gfTExNC7Haw81DoKhTfHuETK?=
 =?us-ascii?Q?0oLaRHd5+nEoRDFRfpjtFgGo+9uIsiuVTDHEiIHNMF/qvfL9EvJsxJgYsRWd?=
 =?us-ascii?Q?Zn2B7VBhy/IASPDQbCvoPqwW0SHEUoNxqNXWBb+yGKo3rwS6+pIY4ekjcYKH?=
 =?us-ascii?Q?PFRIizL+XcIruhBKMoSNVCI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FAE9525263407B4CB9DF0AC6764009BE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bd6t9dAaKHC5qRmCCStO0HXvGZYhLS4/X4HXj0Z+KzDInJ0hdP8sOqQ259LSKeWYEpSTzCpa/hTrhGLHQHW2KXjZ0N+y5VfC6CK6/Ly80Ke4xomtKFsjQqPHCdHoN/UnXp/yZxaCZXbdRBW+fQA/JvgmZw6IZzY9K0gyUowl0UdE0ghu/PlJ7XtVFty5mpeV2gHSmCP06ZMyV1AoLjF5lF9d+90VpPY6YrZ5xXSLsD1EvHkXycIpl3LPNwBR8TV6m7p3NVSRQRIxfUmgfHoQKACf6kh/Q81Li4sUcm6bdk8853PKk2EJLxluMtM+GNlXvDzhnMUNOLvB6PGa6o49SIxrrv8V/GhIDvEeOJ3CCyh1MfJMTYUWRl/RUgNLktNxc5ZBq0o7W5fI6PaIPyFKOx7TKwDrfvGj6++JnrBc7MQOEwHxHr64eomRwNxkfF1v7qt2x1D8VlLMtfinOlUicZto3cDMNQ68VV0fmSBWokAkiDImNfjEz5eoIwdl/I3OLIXCKyhcCqltoTInawXxYJzZaAFOqTVkrEaJB7kQF2ICWUkCCvuQTvA8mwJ8MpNLEngXDq16OmGiJ5QZ5tM+tH5PakpsR0wjAipdpHMt9nM7f5h6gqJSBspx/NQuOyKfbZ8sxWgrR3bSODuonj0LQ3OTluWc43yI0uO3N50/dACWwZ/LmmI2XbAtAhTluNstygsQ+KbU7lVITtnoLjyX1YCMdFZkWcObqFTOHwUoMut0HN3LIplBVs6vI4amnmQxC4HZABp3vsk+GPLyV/sHLSJ1QfaHs1yASsIi2brY4emh3o+y25oxuDDjA662M1Jf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40fbe68e-7d02-47f0-f0a7-08db08d4a1ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 06:29:14.5038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxQHMDG2PaKOesjx3LZ5YEahdybPMVi0QAFBtPqnuhEMbUhSO1cS8LucHyhAZr+IcVlSW0f/AVu9gvMQ6/Z3WbFeJsHkCmxoN5Kl249UHuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8257
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jan 31, 2023 / 01:37, Shinichiro Kawasaki wrote:
> On Jan 30, 2023 / 10:33, Niklas Cassel wrote:

[...]

> >=20
> > I understand that you change the way that the accounting works, but
> > I don't think that we should just totally change the definition of an
> > existing option just because we think it should have been defined in
> > another way.
> >=20
> > Can't you:
> > -Change the accounting
> > -Clarify the definition of the option, but keep it like it is,
> >  regardless if it causes zone lock contention or not.
>=20
> In case we would keep the current definition (accounting per job), still =
we can
> avoid the wrong accounting and the zone lock contention by checking write=
 range
> overlap. If the option is specified together with multiple jobs with over=
lapping
> write ranges, fio can error out so that users can know that the option do=
es not
> work as expected. However, I am reluctant to take this approach since its=
 use
> cases are limited (no write range overlap) and it adds 8 bytes to the str=
uct
> fio_file only for the option.
>=20
> > -Implement a new option that might be more optimal, and does not
> >  cause zone lock contention?
>=20
> This sounds good to me. The new option name can be zone_reset_threshold_p=
er_dev.
>=20
> > -Potentially deprecate or remove the old zone_reset_threshold option.
>=20
> Yes, if we introduce the new option, I prefer to remove the old option.

After further consideration, it does not look good to change the
zone_reset_threshold option to the new one. I will post v2 series which kee=
ps
the definition of the option as it is, and resolves the issues with a diffe=
rent
approach.

--=20
Shin'ichiro Kawasaki=
