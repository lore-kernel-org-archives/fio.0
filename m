Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB60EC4332F
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D5060F5B
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhKLJ5e (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:34 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31590 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhKLJ5d (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710883; x=1668246883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9llni1YKfNAQExREJZz8hQCg7WPlXKXH8rLp/unME2E=;
  b=b7hSfL6GpWlXjd4lThJbToH0X76SCgcLHJQdzU6ll4E/G7alp8M0YCKq
   S3DNo4m5wW0Gf+AnOwILvLcZmSbX+v5mbVXmYcvG8zsoW2zm6nfU+Hn8A
   YxiL6EKkRYJNixjhqF7wm0pP1hf7qxin/PZWiK9Cm1vVRFZmFU3rAfvDv
   0RKZ2vpjct+7sZJyJv8d3D9VlPaIbj5J4XnOMT9FHUGYzucR8S+bI4UF6
   +D9btYA8FtmclF7lVwgDGjbEXLp56ade5wb2IORZnNhJ3FOABA9HKFWfV
   m+55hpSeJGxhrSzR2ZuctwnxqskGYLsNEfPoXEDKf1yZM1uz8C0kenL6h
   A==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360582"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6kp7k3kYnexnNxlA7MqiGWpwKuvbmdfl9SgArDuvf0TYRtKhrwywIvYVwhq4pf/ZOcNdCv9gZtKnkxC1+eIqMWyaaifF+mEGlt0XpbAFIyNqaDQjISeG76qW0F2yrmZv9E6U20ZAIkT5S9nJ230nl0JjojAshScsmPUiYb/oWqckzeD7WuwniEGuvv5QPoPke9M6Pp5Rv2lBBmRyCgzpHo9Hy55ICztVSTfg1+XY9MsFH3001ecWDMFXnukfuUGKZii20NnpiGjxFSUkLGmKYg74LkYtAgO6Rumi9yggEegrxfH6J5X69t7GpU3w9N6NYPwUYlRmTZ08rbwRHyw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGsEIqAU3/nQfykyJkRFY5NRmmgrCMhCbD4S/u6Pz3s=;
 b=MkVp+7fTgxKFnwIEzyuk5ot6ZEmEGn5r8QcXuF4CIUyjX6/AtvkIDQOyzVoo4pNsNWOcbtr0JT16p22YMfFcxvrCkgxBfXOYmlvfakZfCxJcXJ7P5CN9kTi02lfrOpueoKjDDlQHPmu9IqCeq7U7L79SovRQGmT7ejAbmysjO5AsQRAxCGoThZe16RNbxXfKMl/IIhDl9SfDMtx+KT/0aqZhs1+t/fLHwxt+3DA30CZdMWkvAO5GG5h1l32siC4L+h8L63C+hAJ0mhE2HouW7BvTYXm5xKHh0t0ohI4jVT4vuwbh5g+rhtYM92WogSepUhPicjE9BHXuwVkwVRUZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGsEIqAU3/nQfykyJkRFY5NRmmgrCMhCbD4S/u6Pz3s=;
 b=vnKB0SiuhVf5y4r93L9c4AYPTdjD70o1J8AUF0KXTb1nEvb2DET7MIy9XhFaw1mr6u9lVSRShHDQ8qhCIHQ1OPqJUVpnS+4qwYnF9/PCx2FJt4gwCsL0O9sorc8Sm/wNoH6VNz33P4UZ90btTGkgm8unc7gfKOqrpFV1nOi5wrM=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:42 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:42 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 5/8] libaio,io_uring: rename prio_prep() to include cmdprio
 in the name
Thread-Topic: [PATCH v3 5/8] libaio,io_uring: rename prio_prep() to include
 cmdprio in the name
Thread-Index: AQHX16tQR4cw0jyxHUKNk6RvpiGDZQ==
Date:   Fri, 12 Nov 2021 09:54:41 +0000
Message-ID: <20211112095428.158300-6-Niklas.Cassel@wdc.com>
References: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 374bc0b0-2a0d-4a90-23da-08d9a5c27300
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB7433895B9CFE017E62137B6FF2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QxHfkNV0l7+LxA+3bnxM2jhcSsxPbZGTadbkAyEabPmHHENTQXAPp4PEQYJHNpxASuCVzetbSvb1roawPpVcPHaTrBf3m1HmGIHLkdVND8xnZK0X6xhoyapGkilXv4rqy0Nvntx1b9lDj0w3R0VaURpiFOh7f165QHB2To2zGvyiZF6TOGI4FbOZ75GtlRKzzYjR8pvLKBtTx8nfyNyEoJAvMaX13A28NbZtjzsrRfamQ9tJL0N0gVehvQPrsvWzudKkKTYeH1A+oebes2x6jwISpmLL3Pc7RZc9JZL3ZkWk6Zkxakb+ySQaUsDpWRXCzCuLhGweGSV9DVreSzPS0qr7T++GTaMMqi0oPqxm4FFmLnlkIr6+tgwSHFI3k+P+Fp9Yuh7na7Pxmm+OBpZwDwYmdbg7yQ/JQ19i3bKR2vJEckQBsfHDIUyHDhqhtgqUMl2WwIZty5HLT3qNjsHb6Nvt2ul74XTjxEhmyteJlIc3pnm06IKDEt4IEnMMtfRUthKGWXPw6CektoDw3GyWRivIHEuLlyUHpvxgylIsh47m3BEFKmP1a5ijQ1HLZaT061WhWd/hdlW41OvDkWKfyDjCM2KADoK7VJ4qaCiGk9HZ1Wgje9T0fOdEKO3PrjJgc6E37kImG+rviE1zVhwho0oMp54Hx9QVipzGAH0xFy7QBsn1d71zMKvgd77zlwxEc/3prpZ8//w0/2YHSAGlJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?MjH2aFnsMgiuKJoQsQ2QEa97eGWewMs8qkTMN4WxtG+AkGy7qWrZkBymIl?=
 =?iso-8859-1?Q?EJk0EoELCGJi1HZ381Vpn2UFa0MH7O7XUUdZEVO7NIL6za8SzWxlBAGdWR?=
 =?iso-8859-1?Q?2jBcEcukaHVMPoEw8uF2Q/8fwFFKuEIoPY9+dDszI7pjm68D2ZUbr0k6dq?=
 =?iso-8859-1?Q?tN485fLizhTXHDDvfrLBMGjIYy/fn0Ypjaz/uSdXshPeLQVqH++yODAfUZ?=
 =?iso-8859-1?Q?I+6rl6zekc5qyY0zboLO64aTn2oReY+pmR5CxvwlGkxAy4RtqqdS7YVzD9?=
 =?iso-8859-1?Q?xuI7C2a1C/lEafPf/zSZMPsFEPiQ0r0UAYOeMFs/A5rAoowhqPwHG6nrxy?=
 =?iso-8859-1?Q?LFyyLFPQEHR3DepYxUZZdyNTiRnG1M8Q8xUcp2yFbzy8+Q/twl9O5DPyaS?=
 =?iso-8859-1?Q?Dl/TLKT83ugczs2DoqcRL28mqLZCUxlN4OfT/hzIHXpOmEJE2HaaHLo6BO?=
 =?iso-8859-1?Q?91jHgdwPMPlyr/Tq0HLzoZAgLmYS63ecOpWuCkCtRI+W/DoHBoLgEj42t2?=
 =?iso-8859-1?Q?2SvYhNQaJydQtA5bUOxix7BsP31PdsUoFcYT3Gv1nq1hQ8awfv0DSgFrPr?=
 =?iso-8859-1?Q?0CgOkHSNFSBpiCWBed9rwTBBlZJUBG2ko9mSvKdOfxxOQY7nywqlXB4B7j?=
 =?iso-8859-1?Q?jtwop+IQ/v8OJniXu2yzoYrFeXy1Nu+yqr5qxEEMA2+cbfGJNWH3roGrX2?=
 =?iso-8859-1?Q?VcScwINHKYvRlEIqm553RH75nmwAIsjnOqeZWqJmwzARPGGHTcP+Mn348L?=
 =?iso-8859-1?Q?jwOskci8Tfo1p0KIAhrZRcPu224rRs6B4xNwWdNFX34Jj2T4DDJ7AVR+sf?=
 =?iso-8859-1?Q?2d0x1SLf6CQFa8+FAkOyDJPh+ycvK4Kl0iwSXwt/RpO7Y3w3m59oNHMP9s?=
 =?iso-8859-1?Q?Xit2ddhHgxOX3qKtwa7/lLdHAV5MnfxFjD0A0+Tcm60C1MEo65LoNE2hMS?=
 =?iso-8859-1?Q?su8Q9bfd+TjeISpzulWPCzbuwAHDaT3jG1Dhs6RM/KZSW3QJX8oruFjpMU?=
 =?iso-8859-1?Q?lItoq76Ckoy9rFNqsedzzXkKqKPVzlXG/bnfA0tX/yT/0gObnTQ1A15zUr?=
 =?iso-8859-1?Q?2UoH5tyd6AYewV/RvpuyaEdRYbVJWFiLC4ti+FlOAzchZyVLxHl10fwdxy?=
 =?iso-8859-1?Q?ntS5CpotcxmoZsVUDqTD7NSETg9LpfwbUKfzJXHvr4GNEJK0K4ntcrGX6G?=
 =?iso-8859-1?Q?+cKMdQAS0fP3RCUKqFE6/bUANTXfPjcmcyRDvJRo73csB2ThauJE4ZBbig?=
 =?iso-8859-1?Q?ymA39iUJjZM6ug3gy18gV0+CMIySQlsdrdF4r3+X454K5nXDzWRRsua/wp?=
 =?iso-8859-1?Q?oqqhfLWVpBaV9biUfz4OwiZGhZtTWXzSX7wuirIgoMaTlOSQ3dsyehPaKI?=
 =?iso-8859-1?Q?3j8HWSTzzpq96BqiyX5jJpwqtI4wFRtqBSq5kRo2KEcsZaw0/xPWrAxmjl?=
 =?iso-8859-1?Q?/q/RivEC/HEg70JgEjIUG6m8ViFWhbwkcZ/jOiPLUE2fFCNoJE8Z3ENrCc?=
 =?iso-8859-1?Q?rtR5F+MlJtALumHpVakSDQ355k5pHoyh1IGU2I6IDMOXFzdHLBIEx9mQbi?=
 =?iso-8859-1?Q?2ZuIP/DG8Iv8WopRTOriMHFA9hi+KVe4ukWY8g4CioYT39HP/9uY+YuHfK?=
 =?iso-8859-1?Q?l02WANZc77IHcXvVmZa24CKjoOlFB7ULUrgvaSvKCFcuY5oql5Fb52kT+e?=
 =?iso-8859-1?Q?9uB0Xx04iHJ1ZpSHgto=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374bc0b0-2a0d-4a90-23da-08d9a5c27300
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:41.9670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JdDrJMKYfuK5xAxA8QKFwuFYou0XBsWoLASVRNDp+54aw/qEcKUiUKYyE6WbtbIFOQF7VkG6NW6mGyA5DncGAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The default priority (which is either 0 or the value set by "prio" and
"prioclass" options, will now be used regardless if prio_prep() is
called or not. This is true for both libaio and io_uring.

The way to think about it is that prio_prep() is only called if
cmdprio_percentage/cmdprio_bssplit is used.

prio_prep() might then override the default priority, if the random
value happens to say that this I/O should use the cmdprio_value,
rather than the default priority.

Rename the prio_prep() functions to highlight that these functions
are now only called if cmdprio is used. (If only option
"prio"/"prioclass" is used, that is handled elsewhere.)

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/io_uring.c | 7 ++++---
 engines/libaio.c   | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 7a2b20ec..0568b8f7 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -346,7 +346,7 @@ static int fio_ioring_prep(struct thread_data *td, stru=
ct io_u *io_u)
 		 * to be inherited.
 		 * td->ioprio will have the value of the "default prio", so set
 		 * this unconditionally. This value might get overridden by
-		 * fio_ioring_prio_prep() if the option cmdprio_percentage or
+		 * fio_ioring_cmdprio_prep() if the option cmdprio_percentage or
 		 * cmdprio_bssplit is used.
 		 */
 		sqe->ioprio =3D td->ioprio;
@@ -456,7 +456,7 @@ static int fio_ioring_getevents(struct thread_data *td,=
 unsigned int min,
 	return r < 0 ? r : events;
 }
=20
-static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u=
)
+static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
 {
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld =3D td->io_ops_data;
@@ -517,7 +517,8 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 		return FIO_Q_BUSY;
=20
 	if (ld->use_cmdprio)
-		fio_ioring_prio_prep(td, io_u);
+		fio_ioring_cmdprio_prep(td, io_u);
+
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
 	atomic_store_release(ring->tail, next_tail);
=20
diff --git a/engines/libaio.c b/engines/libaio.c
index dd655355..9c14dd88 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -205,7 +205,7 @@ static int fio_libaio_prep(struct thread_data *td, stru=
ct io_u *io_u)
 	return 0;
 }
=20
-static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u=
)
+static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
 {
 	struct libaio_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
@@ -369,7 +369,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 	}
=20
 	if (ld->use_cmdprio)
-		fio_libaio_prio_prep(td, io_u);
+		fio_libaio_cmdprio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
 	ld->io_us[ld->head] =3D io_u;
--=20
2.33.1
