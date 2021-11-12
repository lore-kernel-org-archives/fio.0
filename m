Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A89CC433F5
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AFA60F51
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhKLJ5d (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:33 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31590 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbhKLJ5d (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710882; x=1668246882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C1vQsPN5OEWUAxfhUS3ghPYHQwlVd2kMGavh8f+mr2c=;
  b=bgN1w+B6gxBph+rLx0zQZOZecczQppRhG4y21YH3S437M4nCOtudXi4Y
   Zbtabn/Q4Fy+t9i2TJWXPnhqf7NapGZWCDo93MIELN2MGi/RN4H8D5s4n
   FWoLIzve4R3sgMP1BYNAxsEQsQBlmZNR9+JCM0Kesed5+mlYvnVUKGrDu
   469T/lq2SUQcfysl6yI/OBGLyYNKVcdrseatxrdmSkBo19T6/OAJfl7He
   HluZcYdZaafV2fTkPtrdhapJdvq8Gu1Ai75lbI9xIXIiSqXUcOlU7i3PQ
   Pe++tG+LEuW+VMi1n8feuT0lg/KW4NO/uxzTSqC16IZt0XMycxyxgMnAt
   g==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360581"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOKtoCg0djq1tm/inNxAaTqpW5l4n/wl/flf8FE21tjabbkIt9w1h7gEmRTCFFEN9IgLs4QiOGwCCRkAx57fIL+NbcteV6L2J0VOzugf69ttN/EjBvwnjC3NgB4dHbsO61kBu0kGNGyJjdVuLobTg6pLY0/qm6VkJQlgJn+0LO1PwyOyOrcF/bKofMHMqNeFBQ2MCP+NfiD4ZKFKTsXNNsxpsdD8wRGZrtDR9DT9gadvyt9BVSUUTAxg0yWMIA9WER3IXYRi5CBuKLTbej1pOAk1or4cxsySl5KmRjb1BmjtrgMOgq3EflJr1yUq8yje8VzIqdgQYeuXndsDnHOMYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mD6T7W1YbEZWqEIauk2vRQcEM018+qBxTSrxMIzCHGw=;
 b=nsM3x8VhZoYoU+vynAY1a4MguxHFDx775Kd/itwkI7FRX8+hHhSo2ijIqSYLsg/0PyB9zvOMDL4zqIk07bLhDmuKGH1Dj+baGD5zAYnsFzOK9XmTra2n5lyytRzM1Z3/OkoJNBExKQWYmA4eJ0pS8hOPQ3QVe7Ai9qa03kWPKPIy5H8XZdeO8cZWKZXO8qInJRCNyQBEzGt8cucc9462LYAyqTJvkW4Dw5R/88k22RHLYiMeyDjm0J7kOIUO39zuqZtaBwGXndPSzx56Xo867K2aEtq6HM4WNnY/9Nk5Ac1Z88BZHs0+/qqPH83Paxy7s3KnY9fNdRIlEfJAWoZG6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mD6T7W1YbEZWqEIauk2vRQcEM018+qBxTSrxMIzCHGw=;
 b=ooapPZHQaYe+6CXyRVw6dm3SWh+8IFNXEWI+6jXtmojfMf4+iKStnEtHmsOLbM3otBfUWpHYTJ8L4pYqC95U65dk8g69T6f8p8iFoE4Rjh8uOhB8H22WIT09y8XNMJvsjmINUYQpWNf7+e3DTYX9ubfYILpmQ8QV5nJl3BMVxLQ=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:41 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:41 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Thread-Topic: [PATCH v3 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Thread-Index: AQHX16tQAurX+BcHXku51qhXAWRozw==
Date:   Fri, 12 Nov 2021 09:54:41 +0000
Message-ID: <20211112095428.158300-5-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: ca6ea63f-7a60-4c5b-e5db-08d9a5c27299
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB7433ABB238434333E53E6B91F2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XwmjD7Qno2q4wt9AQCL/YAs3pzsa8CYQZq19aiu56/+r2bSR8TObu1OGPC4vTq9+wowSObnUT+zfKxiLTA9+s2UUavX5v/fA/cvsn80iiv367xWOJm3fEN7pVnaI+ekZbBB2lBW5tgjrGe+PH7b4++fNT93+mvfuYf5VcUKfA90BGxjrnr9qQMkYWFEQYwCGOKqxfxPQqUjl/5gFJFcvYOiw47Kj89LWFh6ObPeJ/6Ycp0xfGtO23PG0DCHzZal7tFxttBpvzK8PZ7cxsCaOtUhWcztNgoHNi9AkP6YFzG/CTovd/dssveThKrH9wPigwq1knqkmNmYshQON/pSUWQ7wf81aRPbACDrykTYcWUlExSmFIvWn4A2AHSyqC0AKWZsY9/WBQzM4/8LMvchSjhUlVPDg4vr9Q0NjZr5O6qtHGxyfeUSYV+lJ+Voiwz4oaLBJQ6LRm+y+MQmVR0hTxeD3dgFYSouif5+Oo22IHqyRmYTLmDJB7IKhJ2BA/bmAxYnHnzSea/8NTEYKqnvQo/+84y8WVYiVnkqKkvUu5qiTP+A6FGXiHkkiT7UEGSMz7Rgf7/l2fqXPP3IBjT1HJ7lcB6JUMt0FiMOyWd1FzKulSAC0XM5pp0lPmLz3As4G7O+v3hJTtj6YeMVMW/cu+4lmlSJnDCqH3XF2SFfieQK4Ikqogsdi4BfHTGNxpb42arsmFjWETn7oJ1n6EtZUxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uoihQHiQNWOZT4r8hhF4W1IuHbYxE3jD4tzYWtCUKQx50EBcRpi1wk3wOW?=
 =?iso-8859-1?Q?hc5FAHmnQeE0q4ge7D1VeTBDh7uZqsqM0gymxIR4Le7Vlo6AoIFbEJMOLI?=
 =?iso-8859-1?Q?tayLBrQx7m47Dw7rRzJBaAyk0YToe/NqyA1gFDnfD/v/lqsngkiWqxu6X4?=
 =?iso-8859-1?Q?cG1YqG4w8gWpDs7R6Cl8uO3tg5U1ACkUbLhNSsOh+F12DFso6OBgp6uFBT?=
 =?iso-8859-1?Q?e2+VDFS+1i5K28QAGWxP3Gbj5qF0DP2yVwMTiDhco1bCEh3dFLK2GBytqe?=
 =?iso-8859-1?Q?SkDAbWtIq5HI6HE4T44/542Mkxq+KziTsGk3hO5EUaeHM9ZUJgCPIovhvk?=
 =?iso-8859-1?Q?Rb1Yx/FTp4lJtqUc5dils9HSFdkhoDijnhsbpq8qlnwiWmlErmtr8s2MWN?=
 =?iso-8859-1?Q?WUPmC1QmDJcpRasMrNSoiBSWIMQ6CgWCbI7Eh9hEFy41StILy2y0WYD1v8?=
 =?iso-8859-1?Q?NnK3jtSHTfklelsLy44sL18MJgk5JELtrCrqsd7zQw4atA+Rnq2CVPEbpj?=
 =?iso-8859-1?Q?pBvxdaqhFkl3pYBzFXHfue74gW8C6zJHuzzt1nLnUywuKDcY6ojRijzzF3?=
 =?iso-8859-1?Q?5DUXm972ha++TbFr+W2Yi/tvRHXJxWWAmlhBuydU6zLavyy3ZZgQzIlA7G?=
 =?iso-8859-1?Q?NDSl/MI81uPbPFUoAu+7gkeWVnhTF01bqLGetI2wHszGkIEHoy6MeXLJcB?=
 =?iso-8859-1?Q?PISvirS2HvZu8i4r2hM4aDJbg+LCiPgNPsdn/4cOvDTH3CR0eK394YhlZ2?=
 =?iso-8859-1?Q?xkzg34C9Nv3FbJUP9fj7UANopQfZoVlfFtmnydJEyAyX5s9T3xQpy6ZmXJ?=
 =?iso-8859-1?Q?O7vw5hvG9z0AGu2G3jAuQKmHLfviU70GhcJ1Vin1HVEPQZ1UsoBHQB+jhI?=
 =?iso-8859-1?Q?2Kansetr2v3C9intYnwng46gwL8SMwK2B1MGj1O9Bnrb070gQJdYlxTQjn?=
 =?iso-8859-1?Q?CyFgkMLYecPtTblCt1BkfInKehhIFX+bu2XqH1yYrU+dju3v05kutHZRzj?=
 =?iso-8859-1?Q?mVLEJ7GNO+eyBvslbUYDPBiOCndsE3WJpAsnna1KIRfZltR4mTBbYElVhP?=
 =?iso-8859-1?Q?6HMFju+J2BsAdKRA2Rm5sHXMazLzhiPllzl1ivB2BO6XkTqFwX+pxYR6Hb?=
 =?iso-8859-1?Q?Vv/+m2LC2mVIjUWUQIFXv3iUGbN6eYkJBhAAoDeF+WhrrhiA2MPCLAGwaC?=
 =?iso-8859-1?Q?8GE6Cd1EWt1DFZ/N4xX/wRqg0O737BOezEquqZjSKEofvU43O3PTBRSzOQ?=
 =?iso-8859-1?Q?uHnV6+7pFYqCR9LpmV3J57pOWAmOgmvj0xYOnzy5vc/X2HNAQHQDl4aVYu?=
 =?iso-8859-1?Q?aQxPBH84ER4miuF6gGiAV7PM8Q7ZxlDiSPp4QrV0sqMz/C5ATjNiWIUnzS?=
 =?iso-8859-1?Q?6+WuhflnEi1DFvwGAsuZM+3TznNAtGG7tdHpAqhcyNkstDsq6uDN4EWhHp?=
 =?iso-8859-1?Q?76sNsbMn4Z+6RQJkpOpBHVWCIKqC6dF2msRomPvKnuKFuJjC7ZrqBRl2E4?=
 =?iso-8859-1?Q?ua2Y17erXRI9CG3uu+Nn2A0ixkMPT9fQ+Pb2fPaxOkItqnEaqiy7pKyzVT?=
 =?iso-8859-1?Q?gSDVrhmoupfwtXGyAtVYH/bd/XJCqrz4lpP8fXtUX6b0Qh62k7E/aoW+or?=
 =?iso-8859-1?Q?kNe9OQO2acUJ5ITqxX4VOnhKhRtswrjzIflvF7mNaP4aOAC/MhyF7AC2LL?=
 =?iso-8859-1?Q?4XeHlS2FR8RhGr0FY00=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6ea63f-7a60-4c5b-e5db-08d9a5c27299
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:41.3875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Vp3M/ReDcIZrOyc4oIvObXmll5MaU79kJoSuhp0C2xvMLRkOAJ0g75m9sjTeFHa7peTy3pRaQscmaGpE4eijw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The default priority (which is either 0 or the value set by "prio" and
"prioclass" options) is now saved in td->ioprio.

The simplest thing is therefore to unconditionally set the async IO
priority to td->ioprio in fio_ioring_prep(), and let fio_ioring_prio_prep()
only handle the case where cmdprio_percentage/cmdprio_bssplit is enabled.

Therefore, fio_ioring_prio_prep() doesn't need to care if prio/prioclass
was enabled or not, we can simply think that fio_ioring_prio_prep()
might "override" the default priority, whatever the default priority may
be.

Doing it this way also has the advantage that the prio_prep() function
in io_uring will now look identical to the prio_prep() function in
libaio.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/io_uring.c | 51 ++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 27a4a678..7a2b20ec 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -338,6 +338,18 @@ static int fio_ioring_prep(struct thread_data *td, str=
uct io_u *io_u)
 			sqe->rw_flags |=3D RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |=3D RWF_NOWAIT;
+
+		/*
+		 * Since io_uring can have a submission context (sqthread_poll)
+		 * that is different from the process context, we cannot rely on
+		 * the IO priority set by ioprio_set() (option prio/prioclass)
+		 * to be inherited.
+		 * td->ioprio will have the value of the "default prio", so set
+		 * this unconditionally. This value might get overridden by
+		 * fio_ioring_prio_prep() if the option cmdprio_percentage or
+		 * cmdprio_bssplit is used.
+		 */
+		sqe->ioprio =3D td->ioprio;
 		sqe->off =3D io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio =3D 0;
@@ -456,29 +468,25 @@ static void fio_ioring_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio =3D cmdprio_value;
 		sqe->ioprio =3D cmdprio_value;
 		if (!td->ioprio || cmdprio_value < td->ioprio) {
 			/*
 			 * The async IO priority is higher (has a lower value)
-			 * than the priority set by "prio" and "prioclass"
-			 * options.
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
-	} else {
-		sqe->ioprio =3D td->ioprio;
-		if (cmdprio_value && td->ioprio && td->ioprio < cmdprio_value) {
-			/*
-			 * The IO will be executed with the priority set by
-			 * "prio" and "prioclass" options, and this priority
-			 * is higher (has a lower value) than the async IO
-			 * priority.
+			 * than the default priority (which is either 0 or the
+			 * value set by "prio" and "prioclass" options).
 			 */
 			io_u->flags |=3D IO_U_F_HIGH_PRIO;
 		}
+	} else if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default priority (which is
+		 * either 0 or the value set by "prio" and "prioclass options),
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
+		io_u->flags |=3D IO_U_F_HIGH_PRIO;
 	}
-
-	io_u->ioprio =3D sqe->ioprio;
 }
=20
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
@@ -820,7 +828,6 @@ static int fio_ioring_init(struct thread_data *td)
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	bool has_cmdprio =3D false;
 	int ret;
=20
 	/* sqthread submission requires registered files */
@@ -845,22 +852,12 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &has_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
=20
-	/*
-	 * Since io_uring can have a submission context (sqthread_poll) that is
-	 * different from the process context, we cannot rely on the the IO
-	 * priority set by ioprio_set() (option prio/prioclass) to be inherited.
-	 * Therefore, we set the sqe->ioprio field when prio/prioclass is used.
-	 */
-	ld->use_cmdprio =3D has_cmdprio ||
-		fio_option_is_set(&td->o, ioprio_class) ||
-		fio_option_is_set(&td->o, ioprio);
-
 	return 0;
 }
=20
--=20
2.33.1
