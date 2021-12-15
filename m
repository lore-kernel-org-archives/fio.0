Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1564FC433EF
	for <fio@archiver.kernel.org>; Wed, 15 Dec 2021 12:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbhLOM0H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Dec 2021 07:26:07 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33663 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbhLOM0G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Dec 2021 07:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639571166; x=1671107166;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=tLTCqAmfhZVxXJxF1jfUDcw5uVIg/6kjQH6pxlDvGmM=;
  b=NLUa8JR4s3UNFM9YIL1yC0g9T9g+aMGF0qPQ23li3BVr5QjEIk+UT1de
   koMTnx2ZMi8rTOKZNTzhI6pZj6ae/F6QSLcDSzJ2q8MxDMtv93GpEGPMn
   Jl4g9Xa4bCNEGyvBi0ryb70kAhKPUY/5rFSsr0kOergXV7riEvsLjbKrN
   afXSHB4i36kjAOrN7xOVtlrJIpYDdo7R6rK/n0q28PgslHaouue7vMKQq
   aTbxE3GUTt1rRmi0QVbObP5J/4x20wHblDaEm0gd+LFnFb1f4zFsOvHWl
   wEaZ3zBAvlVL3MyNQQLax29jDGZHKjfg0hbeiDAtSt4pjB1weAf0K1wTF
   w==;
X-IronPort-AV: E=Sophos;i="5.88,207,1635177600"; 
   d="scan'208";a="193100603"
Received: from mail-bn1nam07lp2044.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.44])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2021 20:26:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwSU/a8I6NxfMFP+u0BrPGj6HvDarIB2Ptw344RdJGv64syqqCA9HKBkLfZQA1CquGfk8ikf1XILsCaBP/amZv8SiEAvM0YVQeXeFHGvSw5nUVriv00Hrt1DNrrbizfCKcfOMZ3R13uqHpmkuy1/tZxxKEOs2Dt6n26gk7jaB7V2NU8Ftu/nGHFwD8BRpdGhT1P98eeDO/0RK6xqlPx/fs8GqUarD6FQzKPE/t4QfEMQtCh8ElPKn6PoxdHDtOgyerjARtrdCUNO2ypShuFrLm1+eNlo698gbVm1F6Q2cGeqcpBDk/3DU+6q6BqeZbR0AVsoGTs3ZfHtqpcgLjPUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=movMf6zj9Q0pvjzF7ne3ZoX69lqvC3v35SW498CJgdg=;
 b=LTPVdZ+xwxMxcgGL31ppXaWmdlblNTfOilKgqJGvyUzoLT4ydUeKzdJwxq52qJVhwO3ugOum88xKwqKbmsbMY7ze7XF6Vb5mqbiYcugZZJ3OutzsJ5fwit++r5au2y7tD/t5Vkb/Gfmp2mnOkb26B5pk+4/ZvKKbx35XlRq7Z9m2pMka/UpVGc0nBrxZbNUW2N+SjV8yU/ZelX/dx5Olu+n+gvxvKMXdk01LUFQISQVM4EUPCiV0jRewJp6xC4mcGimSSK2rlk+hhfy33mdQLaiOXEwC9xiofvPNrJNBxY6AvPUjpQvaz6gWGEAxXiMe4bdv8CaZhtraDiR3w4Mf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=movMf6zj9Q0pvjzF7ne3ZoX69lqvC3v35SW498CJgdg=;
 b=HA1twORM7uPb/7YbEiXWJ7vl/4SQAurD9CSZr12OYR9y9A/mlGMXV3lS6D7hAPXutuPxWdm5qh5s93sfa91lapsJcYLFnmB5zKxfjjitmVTN4XmHTNel/QFYKxYbcQsXdyyK8UOCrK7QBZyrzbUC/w/7mo3L+PfAv0gVLkaj7To=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Wed, 15 Dec
 2021 12:26:04 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 12:26:04 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] stat: sum sync_stat before reassigning bool first
Thread-Topic: [PATCH] stat: sum sync_stat before reassigning bool first
Thread-Index: AQHX8a7tWaV4TlOP8ESoudwE9dN5cw==
Date:   Wed, 15 Dec 2021 12:26:04 +0000
Message-ID: <20211215122557.95600-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac0b8cd3-d17e-456e-fe95-08d9bfc6103e
x-ms-traffictypediagnostic: PH0PR04MB7383:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7383558280CB74B91FC972E4F2769@PH0PR04MB7383.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ff70yDKaOKExqkP5tQeE/IaBrzHM9MFpZAjOdmEjBHr5rTyTgKgJeN0K2ezHhgmSg78B7xIiQMM09VmOIkvezD7wjOH42jfmHwvNHJSyMqA7mo0EJCCOKCrQCNIJeFdkBxterqAXcG7DBbHVluc+wqLWG06UQ0gY2vajS1ahZk0vNADZQMBew4aPaY1h0rsk2cYSs7XNGpCQb8HX/IJ75W3vMVTjs1JFyKXDTvN7RqDimEgjINvRGV/cLyn4QU/apk0uTUv+zsRFqChNvOt+JFzjkCP9Wa/8AN85aukiBkATJ9xVQYgp2l56/sUfkmPoDD3umvP0hdyhifd7L03FG4gjjslAgN0Z9YyvMT4fQlIST6EJHu4xqp3f7tOWJn2Fk4BbUi5u++Nw6cVDxD4ZAQSdemYmBE4P9LSzNebo1Dz1ZyYIe3pEuomoHxaJRH6wWkRh7ld5z04P0k8EHrvdaDAoFWrX5ZgRneZvyN4wYAyqJ4ww4I/DJcEKFXJ2ZYi9aIJVqwYSuVS9ufZ+3E7e7/9B5F73H85/9UL2MteJ2pOuJGOPK2mSwOO3zLMcFoVkJqX5lUeYcn0NVqV9DQHp4kEXLu35QDAB+NkQd5ELG/m+eUk+H33azfPkof8d7odDShb98Mx5dckafL9pgM/BR/EnidNkNF+1yzAROes1MGndenfBlM55oXHARYBDLnuy1URDcDeb2l8iFawd6cUE2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(66476007)(91956017)(6486002)(26005)(6916009)(186003)(1076003)(6512007)(508600001)(36756003)(86362001)(66446008)(66946007)(83380400001)(122000001)(2616005)(66556008)(82960400001)(6506007)(54906003)(316002)(38070700005)(5660300002)(64756008)(2906002)(38100700002)(4326008)(8676002)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?SjlPiHLEDnTvPqihwTO5fFeVwauU61oeCCW/peUbAu1c5Sf4LUyjoRZiE9?=
 =?iso-8859-1?Q?8cu0o18wrEJLuHf9uGUNo58KrkZ8G4CVFHwNa7tQdGU/2716ZA6Tg0uSGY?=
 =?iso-8859-1?Q?CB5vF3GSg89+IPQJjtf1lICV/Te3RZ5f7qqBRMCMbB+Ge+sRldivvEX3W/?=
 =?iso-8859-1?Q?jzfhhBNY6JOmeuQLqZ524kUFjLC23DBn82EaJG6E6H1xjVFkKy2QodkhUg?=
 =?iso-8859-1?Q?3DomlEOt5zIdoVxWldo8zSKhtAzr4hCSstpJFERjUhjIj42Tvcvl/M3Eeh?=
 =?iso-8859-1?Q?NhAUK+ckhEs5p8RysGdgLqMxx42zkVxhPd35JQM7udAMbJ5PoWOMlhmt4H?=
 =?iso-8859-1?Q?1FFDHQw68OY2nhcJ0MA6lEmaGf1akEXx5u/kTLjAWt477NuWkGWAaBy+u9?=
 =?iso-8859-1?Q?SCOgHwNSRgFPE23vmxMtAyAJMjsbAcC9pmPLqDrZ+IDXWTjk/lFVtgtjZw?=
 =?iso-8859-1?Q?Lq8ybo8FCiJjXCxxD4P9Xd6nSUHZRkHWA3Fx7UF80ovolUUl1tNt2tzdit?=
 =?iso-8859-1?Q?/wLCsWAx2k6I0nD59p5oDSTPTHEQX0tMzCeoAOAJTDRROhE6APBmWmYI9q?=
 =?iso-8859-1?Q?VA0J/mKwmtIoRc/sjdE0XNJEOgSCy4tQsPio72xv9xzU6lYNjgTPOA5e5a?=
 =?iso-8859-1?Q?PaxcZkSbcEN1oKEUysse5wjUk7roZTPNME9srxSfLc0rzQVOKwNwC/qGiC?=
 =?iso-8859-1?Q?P2HLI6igazbC1i80PfPFsKtkYv7mbDUN83rW3Owc5j/DDiQgqGAXEaFuaQ?=
 =?iso-8859-1?Q?OH3yWHgnTzRJr6ILX2lBd/p9eiekalEAVu5kwvY6wBoi3HUGn6fVPTOp1O?=
 =?iso-8859-1?Q?KHIwcM5YKQBWXxB8kdIqLVH5RWr+YkUHcbEAzfFBqNY7lC8d3odynnfZZJ?=
 =?iso-8859-1?Q?KBxYxfwQt3tlnXPzg4SP1FvEwiNL/F7EwBLQBQ4pDmLBLMl2cKACWm8TgF?=
 =?iso-8859-1?Q?xpkvU59HPF+SAG5Q71wrRoCOlvoCXsMk1lbqPdfsoldBpw38wmoFDC2LZy?=
 =?iso-8859-1?Q?Slecx23jtJXRc5VlnDB4PQQQCfl7jio0njctuzAi8a1TxiZWXrs1lFt6S5?=
 =?iso-8859-1?Q?fSR5eWPR3EGddWbzWc77qq97v9BKKoBAVCOhgQub3bAsCZ+y38Kisj1XpT?=
 =?iso-8859-1?Q?76Pc6gl3Pcxql+aGZloC2mdVme/ySW4dhJg//O/89J3hFOQ+EVjVH91e9i?=
 =?iso-8859-1?Q?jVHgR46nnjU9JwtklHfP1wu390DvqrJGIyU4aLPqHdseIK2+Z3sSMCf/EM?=
 =?iso-8859-1?Q?l28KPsv1QsWtImfn8CrHi6Ou5Ey/psPfWfFKE/0DQCwXCHXdCuOT6u+WHZ?=
 =?iso-8859-1?Q?kCojGXW0X+6ezsr9TaNB9aI/c6dIy70I6EDVjmkar2b9ljR5FyJrtzIXzI?=
 =?iso-8859-1?Q?lDWuUaxV+TZ/iXU4ZpqOaEc/X+YDUpRe+0t5Vg/rkITXL7DJgqSDwYBJZU?=
 =?iso-8859-1?Q?/v2G6PCfrwCQgDJjzmUvvxJPXUxC86ShsSmXc1Mp06S79wM4XZ/HKmkRT3?=
 =?iso-8859-1?Q?+SykKYDnVTQYAPmwerWBwuwDHGOb8GWEX3H9x4U5mLsml8FYbL+rt5Xp9T?=
 =?iso-8859-1?Q?AEA/hPlgmCrVqF6PSxodQqkTf/O4vbapBtC+7o+t9t1YuUSDIxKPwmzv23?=
 =?iso-8859-1?Q?G45FTuswNweywQ0qd8e2dQ5osDcYc3t8Tfv2nTveKZALG5Cp7O5f5qbAsd?=
 =?iso-8859-1?Q?A7NuGinfLrZ3HbpGZ9w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0b8cd3-d17e-456e-fe95-08d9bfc6103e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 12:26:04.4857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bc/127cdW5HXNjqwf27ER+s+H9C/A3AVID/wS7anj0n61iqKEdbiBw8BThfC7pd9c0H7wHYtqcAtmadHaux3Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Currently, sum_stat(&dst->sync_stat, &src->sync_stat, first, false)
is called after the summing the stats on a per ddir level.

The for-loop that sums the stats on a per ddir level will reassign
bool first to false when unified_rw_rep is used.

This means that the call to sum_stat() for sync_stat will be called
with first =3D=3D false, even when it is the first sync_stat being summed,
leading to incorrect sync_stat calculations when unified_rw_rep is used.

In order to ensure that sync_stat is not incorrectly affected by the
reassignment of first, move the sync_stat summing before the for-loop.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index 7e84058d..ec44c79e 100644
--- a/stat.c
+++ b/stat.c
@@ -2130,6 +2130,8 @@ void sum_thread_stats(struct thread_stat *dst, struct=
 thread_stat *src,
 {
 	int k, l, m;
=20
+	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
+
 	for (l =3D 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!(dst->unified_rw_rep =3D=3D UNIFIED_MIXED)) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
@@ -2166,7 +2168,6 @@ void sum_thread_stats(struct thread_stat *dst, struct=
 thread_stat *src,
 		}
 	}
=20
-	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
 	dst->usr_time +=3D src->usr_time;
 	dst->sys_time +=3D src->sys_time;
 	dst->ctx +=3D src->ctx;
--=20
2.33.1
