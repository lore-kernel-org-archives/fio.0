Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F94C636CC
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjBGOGo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBGOGk (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:40 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB85B772
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778789; x=1707314789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OyWrNyvS+Awp2968sPtJdPhioFj8GOhzdIlCBgdg030=;
  b=Vgf26Ovisx066vFbi/3Kwb0BVN8pJ/u1+9O3f0SHIQfOGa6qy0h7ClHu
   duCpCR96QVhqrGSUFfMr+Fek2iOifmVNm7cGBFxnzrYTMyYE9Y9PLpAD/
   U/wIDAV9dY/xJ1uqEsl/oEzm+djzGT5olLT86d1GjDLW6f0pr1pLMmAnB
   IT9DqiBDrYVemRhFm3Gp5/CWdtoyYyTr5bfYUGKPKBPWOouaCcmOOi75a
   6R81Y722CSLq2oqtMZO6mJuVS5++OWsbLTjJ5Oemf/+ULIGis3kkrllj9
   AsQoBGEt/i3Mg16/oZzGXeUGfEPQh0uX454SHkwKLKeW3rGMsCLJwdAY9
   w==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="334679138"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:06:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlwIPFL1xs8+6CyE4uRRT6LGf/UK9l0/DBohoquaf3q0rP2h+xt4Xte3SeHsvkuyRqxkuHYJGzrrLgVilyBAoRX7gZMYhbSuMCBvQVvBvDlCiCGBhoWka/26HJZrBJ+o3pAFGzvZdqaxFJN7Ce2pdbTKu8bcSL71Mqo0ISEOXn7dkk8J6QbeamKMWBM8c+/CFvgCa7XfWh9VaSyl2/2Tn2x6LzEB6cEkEoMVnVQoZr8PufggCCSUNToXqImVfXhvuUPE4AqxBaWvqlnMmTROgHd4pxeuRY5SGigQzuZaqOVs3MgEvXV29t4Tnhs5k17eoa9znmcDjhGfIIlWTZ68Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9qvrfOTX4v+zwEpHLC+qRFy2/02vs7iy/aQvwEu8Ic=;
 b=SvRI1ax9KrfarwZUe4l+ly+RXEHl8OouE0Oh5KN/cIvIKIWlT8HUPUG0h0Yaom2jx0DfAL6RpS8khPVthyf9kQbGoPODbCskI61KHYXIC2UMy1lcDT4FUEUkpnmC7JozevEvxIRJvHeIm48xNEyDqk8hD96wDh64Fe6dzmTh1xQZmSv365qViFjFXtVYuTaCj2Ik2mzGvi3orKH0hn1Fhh6ybd12HKbl/ZxQcW9L1znZfBFlJSnvYkRSTq5nl5mbzZbOer0jdpdYg2DMuECsTDiZ7POtfKQps4Irr4Idqd1pbKCkq0kBWZGAgJ60H5XpUnxGFqd8Oz98VneHRSsmkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9qvrfOTX4v+zwEpHLC+qRFy2/02vs7iy/aQvwEu8Ic=;
 b=LuSKEdMso9/VI91Wm7GD4g2ixDG825Naw0KPHitlIxU3h2VJcLwQS/0Cn8zzpGZu0bdqfg7h2VmdhCEUk4PB4rv27qq/but2jYboCsg0asP/T3z8t7/P42fkACFL9Z3Gp+iYNVvRLDOvlZgKYvrJLgHqojuhXzUnetNeMihuHgg=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7042.namprd04.prod.outlook.com (2603:10b6:a03:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:06:24 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:06:24 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 6/8] zbd: check write ranges for zone_reset_threshold
 option
Thread-Topic: [PATCH v2 6/8] zbd: check write ranges for zone_reset_threshold
 option
Thread-Index: AQHZOr64JdOBO0G3PEaIlsE8OnvORa7DhTqA
Date:   Tue, 7 Feb 2023 14:06:24 +0000
Message-ID: <Y+Ja38Vlb49Owx0r@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-7-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7042:EE_
x-ms-office365-filtering-correlation-id: c0975bcb-fcc1-4ee8-5b70-08db09147f76
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /IGF0+s9F6bBU0fmHJEwvY8VEcvoE02xwFU58F4ylOo3rA19xC5bI9qyOVJyyTUO6JnRWFHxJw7KDNC/fyZ7f7o/8+cP1vaKKdWHpEfvKwfAKqOHgmpE36f0xQrJX8EpFbmxNPdmuTKmIaLJJR3IzF6H2Ys4uklOob8iCav5t1YXipOrPVLYXLzd0w4nXIzLKO474Rcj5zoHGEh0lZ/xPBtU8vWGBvwlVX73ZdrZoz/A8nIgMusLj64OsUJNqNOy9bFeFrbWDWswqmXGjuHdSkUhKCG9xc9Sb/MMfMow1FFeKWDYbLjBsq4RVQKdS3xPXyDuS79jedC1sruYYmRtvt02aYelDlvgPu5z0S+Q1Qt0S4WWGfreFCuvlsxt6i8uB8HiX9yZGBI1nCQc0z79kq32iEmeE7D/lfoWtap0SarXCzfdUINPyoBFiZaRwwH/+EKmZFKuhxPWDaEAcoC4teAdZSrwxC1YCPuSg71TMp3WmIdGzLmETG8zdKqaHt31yz8xZRppaOF+UFxpJ63P+DXDC7rUBDh0Xjt4w9K8wZrL5RumT176dAiiZXYHiNO94Jk1HujwShP4ZcMoVbeRxo1gESHhw7qIKot+NM8OMZRsVnnVHHVCBHir34p/l8R+Y4A9RP00/JTNHGjaK/GZcMJVy+Ki6SPllrbOedV+YDsIOp5pRdRT75a3jV3g/AMf7xBzHuFq/DnPI610DMd74qQEsugJEOXgqEiGywC/n9c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(38070700005)(86362001)(122000001)(66946007)(54906003)(316002)(66556008)(66446008)(91956017)(8676002)(76116006)(38100700002)(64756008)(6486002)(4326008)(478600001)(66476007)(5660300002)(6636002)(2906002)(6862004)(33716001)(8936002)(41300700001)(26005)(6506007)(186003)(9686003)(6512007)(71200400001)(83380400001)(82960400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SflrpISK87y+J9dPRUfbbf8N1ZjHrkDLXHqO1z7IkGlBJpLE/7cN3Wm7n/m8?=
 =?us-ascii?Q?kbL9tSfwk6WuzWBlxirYWR82lwki1WXL4jB2gQ8g04d7tUta2N+Kf/qZlP2j?=
 =?us-ascii?Q?sbmkShAGZexMr7zakutUijUROuQDSi0j50FQ24vKg+e5eLXY0pFdowmkK61c?=
 =?us-ascii?Q?okrLUq4GedfT0f871hcMFl20hTdfkHy6q7uGf7Q+qvAwxJwipAMfVYI3dWxg?=
 =?us-ascii?Q?Qmd+O/aSyu20YE8DRzmSXYTd4z/UV5ExYd3LAYQy2G2ZO7U77eFTej3JDPgX?=
 =?us-ascii?Q?yULZawq0+cYQDGbUZeBmm+RCgdEfKVP+LMGRrxCunviHYBIPqKxzX/4S1L/J?=
 =?us-ascii?Q?7nosXI5InJzuZFG2D2nzsQNI+D1zkCFIZvcyG8JjqV+7a7G2aTZRCdeEMt6v?=
 =?us-ascii?Q?Qk3qQSt3opFM8DyqP+gLUizdH2h2nR5FExOL1kU6XjJDTR6TuLKqzgtvSDss?=
 =?us-ascii?Q?BWmqpd7wfEu7nhobgaVvhLZHO1+Ag3T5EMqQDtqtPjErojimzTp3+yXpyPTR?=
 =?us-ascii?Q?NfoeKmMd3vuqrtkr68oPw+eI0FkDHq+OY9n7SFH6zi2Gn65ppzmUY/JnqJ35?=
 =?us-ascii?Q?1kuYlPvtGQ4DX84rST6lffuHwiI2xa30WWcyvCgdzyNhjBZ8i3EKL/lpXd4h?=
 =?us-ascii?Q?9dU9ZDdH+mUfiBSFvNaTnTVIeSAOZOeAG1Pv11LykucKdTu5792BCrmmjoar?=
 =?us-ascii?Q?U+Mm2cgco+5CQjMXTX2zzWXMBCCW5IfrgoPKNATKpTMYuFsXY+uIjxq29TaD?=
 =?us-ascii?Q?nf4HitRFac/fmM41BU5JCxFG6VbyBIPzT6D3/UwEVSw++dmMBGgvykE85FHY?=
 =?us-ascii?Q?ZHQo1oEnXf8aQ0xyL+2sX4hTlB8kiF6PDyRvR77Xxc/1/5SCBTCOxNewxU6D?=
 =?us-ascii?Q?VekaXKcc93+HtA0U1np8ioTqX+2/iCOTYaMt+qE6P2GaTT91wZb1+b32WqYr?=
 =?us-ascii?Q?hjYqe0S9yiqqfUzV7UJfpB7jr/ROzbjBGa1j2nD2ShVmgonhWubAntC+YJPB?=
 =?us-ascii?Q?o01ltzAD1yeUswH5pz3d6ppLJhXV2x11bY0e+SsHInGXn00/BSV23vX8qumX?=
 =?us-ascii?Q?ryDYzs0XooFs7gZ0sW8FK1df26tkf3ziQlRMGjKmMXyXmDcmtQXDpMrcRB+A?=
 =?us-ascii?Q?Db6yI11Ep3FQ/kKFmjYMfcPVF7ne0CpITvqGoMcc3JN/9aVZdAd4ot5GR365?=
 =?us-ascii?Q?rD44w3KmU8vOukR6FwyLGLRnhHVeFhEmZR0CBtlWf04t+1utE6il4TF1FaHq?=
 =?us-ascii?Q?yU6HoQg94SWIE7R3W/GC+KUxQSLpLx9WDaFbao91PB0toDm3q5EdWkdDdAlo?=
 =?us-ascii?Q?lHOTngZKJURPX96/VqfdVC3DH/4Gins66Pvn/CGiIo+z9JqrxCPaenz9XJA3?=
 =?us-ascii?Q?FRLOEyNMXaiNZGGudqRYYmzpzhCXS31mrjhDDDSOo3ncl6eaPA3YQXAnP/fj?=
 =?us-ascii?Q?LhNrehJyJxMmbwT5sowXUhc0/z4HiR8B9sISdML5TQx/cWzEZC5pNPZDn1b9?=
 =?us-ascii?Q?SeBKs0EdStaSb61VqIYI9Z2v0y9avNnb92g3lPdcFnafols+80opVtSXgWrg?=
 =?us-ascii?Q?YfLjSyAqdrxNlWcbwm3VabMJmBMppiCWpc/IhXZxV5o1S2zYzxCTPZN69q9L?=
 =?us-ascii?Q?lA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E6287048DD37A4593184AA71F89EC28@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OPwvAq4qIa6xiGnKFtentkv3ADfYTcyF72dGWQy+LrHaoaGC3M66JlACa3OmCsemRLvF+fp5gqasxm9UqscE1+UrQg+zk9Okd7wIP8epuKqhquibMBzrwbrWJpn19n7hLEHWDPWFgzL8L4dSeHVQiKhP/JMgCVrKH2ELiC5tCyrHjIPL+mpVJF4CvHOotg8b7P2PF3B8u8mX6aY6NH6vhZvCKM8ZQ4q8wtHyvutiC38r0qN04MbOnWHHdFmkdGtyVvPOsYbY4baj6N6I61tsSmdVeigYoXOJwKLYWZQzw+Hk5biDH5ebBfHIvUAo8lHejHh4drc42h0kCm1RCkY1roQ8pyiQCVhk9yOc75dTHytuLZjtrIun0cbSinqVdqpMFTjuPeS3fqCOWuJ9wX3RPo/juJ0DeDfhG0LVTg9Wl7Q99bC/sCHk5EsiNzVnEfstsUEbnBAhmcNz5vXxKg8+STMftz8VlRZoI3j6GqP9uGwTsoHTsJJxJytaB/7i8p2B1CqvgqGV/2geQwY8zjURD9SOxtFWUdcbFP/szcJ0YRhue2pwZt4R8ZwA7zTae3Al7hSLTfk4K36jC+yxXhZ5EkZw447riUAU8qsj7cxs+smQ6grWr0YV9z2QlO1J6VMgx6ni6uYENIY+IOGZ4J3p4LvMY8oQQdFATRB2Afc5kx3MRZ8wKfONZsEHlzWuphOd6nxd20BbQh1Fz7HU4igFwe+QisVO0Zq7KEJQsBRFeUu3Pc5EXAAgXn0JhRoOU0DKJ1MZxTDPrsZ7vw/EzQpwh6uBUqTd5seIhvRQRbyrE7mUxdM8jbrIcYMCQAUk8d9o
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0975bcb-fcc1-4ee8-5b70-08db09147f76
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:06:24.4891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7oo2CeH3n/h2JMiCvDPQPH30dgf5DKzzMrJkmrNapUhSLEmSqIoXW1UkPEnhFVasRRt2J9t0mcF8AJNwlwQ1Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:37PM +0900, Shin'ichiro Kawasaki wrote:
> The valid data bytes accounting is used for zone_reset_threshold option.
> This accounting usage has two issues. The first issue is unexpected
> zone reset due to different IO ranges. The valid data bytes accounting
> is done for all IO ranges per device, and shared by all jobs. On the
> other hand, the zone_reset_threshold option is defined as the ratio to
> each job's IO range. When a job refers to the accounting value, it
> includes writes to IO ranges out of the job's IO range. Then zone reset
> is triggered earlier than expected.
>=20
> The second issue is accounting value initialization. The initialization
> of the accounting field is repeated for each job, then the value
> initialized by the first job is overwritten by other jobs. This works as
> expected for single job or multiple jobs with same write range. However,
> when multiple jobs have different write ranges, the overwritten value is
> wrong except for the last job.
>=20
> To ensure that the accounting works as expected for the option, check
> that write ranges of all jobs are same. If jobs have different write
> ranges, report it as an error. Initialize the accounting field only once
> for the first job. All jobs have same write range, then one time
> initialization is enough. Update man page to clarify this limitation of
> the option.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  HOWTO.rst |  3 ++-
>  fio.1     |  3 ++-
>  zbd.c     | 22 +++++++++++++++++++---
>  zbd.h     |  4 ++++
>  4 files changed, 27 insertions(+), 5 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index d08f8a18..c71c3949 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1088,7 +1088,8 @@ Target file/device
>  	A number between zero and one that indicates the ratio of written bytes
>  	to the total size of the zones with write pointers in the IO range. Whe=
n
>  	current ratio is above this ratio, zones are reset periodically as
> -	:option:`zone_reset_frequency` specifies.
> +	:option:`zone_reset_frequency` specifies. If there are multiple jobs wh=
en
> +	using this option, the IO range for all write jobs shall be the same.

nit: perhaps replace "shall be the same" with "has to be the same"

> =20
>  .. option:: zone_reset_frequency=3Dfloat
> =20
> diff --git a/fio.1 b/fio.1
> index 54d2c403..80cd23b5 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -857,7 +857,8 @@ value to be larger than the device reported limit. De=
fault: false.
>  A number between zero and one that indicates the ratio of written bytes =
to the
>  total size of the zones with write pointers in the IO range. When curren=
t ratio
>  is above this ratio, zones are reset periodically as \fBzone_reset_frequ=
ency\fR
> -specifies.
> +specifies. If there are multiple jobs when using this option, the IO ran=
ge for
> +all write jobs shall be the same.
>  .TP
>  .BI zone_reset_frequency \fR=3D\fPfloat
>  A number between zero and one that indicates how often a zone reset shou=
ld be
> diff --git a/zbd.c b/zbd.c
> index 6783acf9..ca6816b9 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1201,10 +1201,26 @@ static uint64_t zbd_set_vdb(struct thread_data *t=
d, const struct fio_file *f)
>  {
>  	struct fio_zone_info *zb, *ze, *z;
>  	uint64_t wp_vdb =3D 0;
> +	struct zoned_block_device_info *zbdi =3D f->zbd_info;
> =20
>  	if (!accounting_vdb(td, f))
>  		return 0;
> =20
> +	if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
> +		if (zbdi->wp_write_min_zone !=3D f->min_zone ||
> +		    zbdi->wp_write_max_zone !=3D f->max_zone) {
> +			td_verror(td, EINVAL,
> +				  "multi-jobs with different write ranges are "
> +				  "not supported with zone_reset_threshold");
> +			log_err("multi-jobs with different write ranges are "
> +				"not supported with zone_reset_threshold\n");
> +		}
> +		return 0;
> +	}

This check looks a bit weird.
What if the first job specifies a f->file_offset and an f->io_size that is
within the same zone? Then f->min_zone and f->max_zone will have the same v=
alue.

Which should cause wp_write_min_zone and wp_write_max_zone to have the same
value.

The check will thus not be performed for the second job, after wp_write_min=
_zone
and wp_write_min_zone have been initialized.


> +
> +	zbdi->wp_write_min_zone =3D f->min_zone;
> +	zbdi->wp_write_max_zone =3D f->max_zone;
> +
>  	zb =3D zbd_get_zone(f, f->min_zone);
>  	ze =3D zbd_get_zone(f, f->max_zone);
>  	for (z =3D zb; z < ze; z++) {
> @@ -1214,9 +1230,9 @@ static uint64_t zbd_set_vdb(struct thread_data *td,=
 const struct fio_file *f)
>  		}
>  	}
> =20
> -	pthread_mutex_lock(&f->zbd_info->mutex);
> -	f->zbd_info->wp_valid_data_bytes =3D wp_vdb;
> -	pthread_mutex_unlock(&f->zbd_info->mutex);
> +	pthread_mutex_lock(&zbdi->mutex);
> +	zbdi->wp_valid_data_bytes =3D wp_vdb;
> +	pthread_mutex_unlock(&zbdi->mutex);
> =20
>  	for (z =3D zb; z < ze; z++)
>  		if (z->has_wp)
> diff --git a/zbd.h b/zbd.h
> index 20b2fe17..d4f81325 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -55,6 +55,8 @@ struct fio_zone_info {
>   *		num_open_zones).
>   * @zone_size: size of a single zone in bytes.
>   * @wp_valid_data_bytes: total size of data in zones with write pointers
> + * @wp_write_min_zone: Minimum zone index of all job's write ranges. Inc=
lusive.
> + * @wp_write_max_zone: Maximum zone index of all job's write ranges. Exc=
lusive.
>   * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2=
 or 0
>   *		if the zone size is not a power of 2.
>   * @nr_zones: number of zones
> @@ -75,6 +77,8 @@ struct zoned_block_device_info {
>  	pthread_mutex_t		mutex;
>  	uint64_t		zone_size;
>  	uint64_t		wp_valid_data_bytes;
> +	uint32_t		wp_write_min_zone;
> +	uint32_t		wp_write_max_zone;
>  	uint32_t		zone_size_log2;
>  	uint32_t		nr_zones;
>  	uint32_t		refcount;
> --=20
> 2.38.1
> =
