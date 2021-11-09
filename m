Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58457C43217
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4292361038
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhKIXlU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:20 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43928 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhKIXlS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501111; x=1668037111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t9QcG7C5bFgTjfgwrePJIIfZFYgCbFlYlM3O/CaCiqY=;
  b=le1kVE5DAMvZz4ynG3EdMtuNQrUOcWPiHP3q70JKuCCCo4qvk6imkG3Q
   pYsXRcHovE3mN6il5b4pUE5Njj4NCdsoYntmFrg+0+82wvwEuVJVrlFFp
   cUYBQiuWaMmZDLTMSyn82grCAPnGHA1Ddx0CJoF4CayLWvExGdGVRuTfQ
   bwciJA94Y7YJ/O80jqo9lWFGvvF1jRZxFREGUjwlf8vgQ665xviuMxFVD
   hntNJuQZh1MWbJT5kA1P9M/d1eSpM/kplRNHXomLYCJVkPkAbERF8Ag2o
   CDUWsEKhv6vy2snSVGVS5dIjCdq1RQuOWWzybXJQAr8/w4f/XpI6SgaIx
   w==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="185172217"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRDj8Xt4LZQLexmwLO7NRND6+pxctk06JlX42ts68aPGXU9FIu9bvnAX52g6Ih+bJHyBH/9t8yDm3dNLJUciKkf5QPBPQqMXZv3BsZDMGcRK9/D6U5dfLnuLC5OLuHH38/lTdU1hdnT++8jf0BqvHfJ8qKPlqIJtpOtcPTu8x/+ywx/sQMoRCAHA6UHKKyWaHbOtOrNZQO+/T+GxgapQGNx5LXGHtJITCkxbNpA+1RqxEAibB9r9Q9uESkHhv8qRK9/gFWWydrixVT7a806CDyYAH9Nt1D8i8S7p66YwPh/aIvyFma/LdagGKQBjXTawUfeqqiv3VAyisSo1raXyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwojeg3m8KEkPetZlj1UDRXw57TP8F0ANKAxzPMhlKU=;
 b=UJZ+Cl70f2OrcvMrvSiy/m+BLQNsTgQ0N+wsIYdmEppM/9ZgD6uC3DfECRulimfOHWh4+npHhLKwrT9AcA710/LhWUJUqCnrXhumceELYjtvDl0iEIm0YvsguyTgojDNjAPyKG+cKBC2lUlsvC++w1J5jjXHxIWx0SPO1CksyqvV4Gx+n7hoaUnIb56sPLJ8TpFmD3AWmZAxjnTwP4uesxrykJSk6zy5MFeH/WMUfkAjBAbNkFvtAPzzScueNVQw1YjlprNAG7uG/5WNbKrVjHUiZIjboxTYsoSN71dN8qsCs38DkHTAlv/zcJGa8TWrpP0sh/YpBJi47Bu7KauFJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwojeg3m8KEkPetZlj1UDRXw57TP8F0ANKAxzPMhlKU=;
 b=VNiLcgFmKm7nZ4r5/NZX9PjeRNMeTCHbPsPWGE2R7mDqK+Onu2TvCZQuxneLu+zf6uPu+6iepN0VVpxt1eWCwkcpA2TDmUKH/x0Eeosls83EfKO+2uU1PPpgdOznXt+nnucRLrI88sqG3bvzxvyNvixOeJUNkmaHt104S/EJVZ0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7736.namprd04.prod.outlook.com (2603:10b6:510:53::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 23:38:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 5/8] libaio,io_uring: rename prio_prep() to include cmdprio
 in the name
Thread-Topic: [PATCH v2 5/8] libaio,io_uring: rename prio_prep() to include
 cmdprio in the name
Thread-Index: AQHX1cLmzCEiEBq7TUCk64ljuVrL9g==
Date:   Tue, 9 Nov 2021 23:38:30 +0000
Message-ID: <20211109233804.164786-6-Niklas.Cassel@wdc.com>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca7e522c-7b59-4040-af95-08d9a3da0989
x-ms-traffictypediagnostic: PH0PR04MB7736:
x-microsoft-antispam-prvs: <PH0PR04MB77366A221C0B0059257FB3C3F2929@PH0PR04MB7736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k4nyPvXmvKXGTHFiE0xS3/nyPzoqchY4LMM6jmxLuKfW2yU09my6zNGeEiDutPgYdQ4sx+mhjkTj7pfmTnV34TghtrX8xQ39+BDkqRbqm6gwMmOTpMEdPRMxn6Jdp5D5wYQ9JnMgNymnGccSpCroJSgxUuPewvpkJiWIzu2+yhTEoX7eeEcrsjf868OKgpoBqB+Jc57g24PQeDV+DP4TxFkxzYbJRErI1QX91LEZMFfb2TwwQStqpSGp9IzvTEU9FZ5PZ7z8IzC6sqc1BB3ukUo0nqEOMIZAXWmKscIzcxodXtEi20hJG048RIVxZIadhv2moJjYOigvyXXTIsm0gQmSmEWFU8PSDthXvb0Lcb3DPXYep3Bu1D52iqCrm42IqbQMwaGpb6e+tpxVZtViduMajfpiifuH4mEcMoIX4sRLcITtvima0VGZh1tbyMsYYurQKaDKi3pHV4P+NnGblv5tBZThpM2Klw2BnI2QlmK9WPreh2Gemw80F7YMJCzNMKCCynF/4m4mBVTWmKE9aW7roob/lCDKKX7R2SSMeCjFq7sB50kxZTXe7184CTyKgoTdQXu1guZWNTEpX2Oihjqr9uTJY7l9h8axiGDJdFY0ngsr35t9dykb7UQFxrsquuis6zIszfhCNfkJJMHF408O1qB1BeJYYvHzxfWRvF/hOHCte8AgDUb6B3UwaAMtHxjdDz7CS/6DOyZeLk56mA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(508600001)(8936002)(1076003)(6916009)(316002)(83380400001)(4326008)(36756003)(8676002)(6486002)(6512007)(66556008)(5660300002)(82960400001)(38100700002)(38070700005)(122000001)(66946007)(6506007)(66446008)(71200400001)(66476007)(2906002)(91956017)(76116006)(64756008)(26005)(186003)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rVORQ4Tb7GeXSxvZKUjwnL+JJI3Van1f/eMe4XPTPWi+bSh+9J98mb0kSs?=
 =?iso-8859-1?Q?9UbHime85KS3k7sIbul1VCFO0JCxUpuDNOZ1R72XJL4eSxHomzfFd8h/RU?=
 =?iso-8859-1?Q?8CNYpIi3DpEl0FVg70qWpJhHR6KVn9QsFDAhiaNRGkDT6zvIbyS6VY+LMt?=
 =?iso-8859-1?Q?HuFhtku/lAc+1dND3DY8idAUBVOoSKF4xDEC+w3V5XmR+IgazUpmFsL+QU?=
 =?iso-8859-1?Q?mvR4APLXk6awTSYrly8yHoCm1OKUnjEziTeCs3hlz0fOTqVPmNK7Wg//lR?=
 =?iso-8859-1?Q?dlmzugDQgOivLNIE6aWvS8fMnN36Lwm84MbvfVsvNk5tTBNbP4doPOwdoW?=
 =?iso-8859-1?Q?CBb0D+JHtXVFAl8pSg65LhL179IrzQL8xr5c6UXL+sJCG3rwaTISzeQkRx?=
 =?iso-8859-1?Q?Q2BEPuXbnaJkH/xeBiARzufzdabn2ugXPdv3Z8VDVbMEy4PTfPCi3tRVH8?=
 =?iso-8859-1?Q?2IsgWID9XHPqlGuQtuDwqjPbjx6DjWXbqr9tRr6YLB0MeYqBbiyF6vf5/b?=
 =?iso-8859-1?Q?q2m1gBooh4mGF72pC6vnCiMozuhuoGpCfPn0Bqi4tWpQCNB04LZXLN8bGD?=
 =?iso-8859-1?Q?6pU3ghkVLnUhYyGpVyX2Ra7W/775jMraOtILYCp6C46dHaFceZwqWnboTB?=
 =?iso-8859-1?Q?NkPmBiKySZkhSbIMyv4puHltPSt6/Ot1EvRtL3cXQErMB41aOLU5ganbkR?=
 =?iso-8859-1?Q?3Kn5sW+Yp7CrZXtUqYqDL6qVeLGcMw5HAWiVk9dMsPdoR/CSeCtpRzbEWi?=
 =?iso-8859-1?Q?4iKqOfTj/C8WR5g3Zl324QzCo/cg3prhAobj8z/80bz7qf4GAyi+WITe89?=
 =?iso-8859-1?Q?sBA451CyYQmiH/SrvAEBCHJN/Pb9bgQp0KhPnpmGncV8CqXq4PMcUYtCsr?=
 =?iso-8859-1?Q?pmSdmUXpNTwGkHq9g3wuo9eqiP7jV4lqoYeKQmn9tP5tcM8RZBzZ/54aSO?=
 =?iso-8859-1?Q?BWzbGeERaFmqniKr12v/CZYERG/EHUxfPqM/h4eCp0nNL0inCRs7wqeNUz?=
 =?iso-8859-1?Q?WhmFCxDEf58u7cTGGHnL5eJTWnQ3phRzHjQAb8Kizmio7Yd5beyujtpB9T?=
 =?iso-8859-1?Q?o9vuby5AzG60Xd96qdTyA/l38sEgAJ7M30eS4Blq1jr0v2vcVrmz90SMaS?=
 =?iso-8859-1?Q?UvlkGKjCBJNY4qf9ufRcFDGLvAUGXC7uv4J/dL2y84oLB2rUs/V9flIYXZ?=
 =?iso-8859-1?Q?oUtiVwCp2WqDMQv1p8C1EgxCda+ZeQ4tWPO2+U8MeYTacgFtvbOWPIiat7?=
 =?iso-8859-1?Q?/rAq784IRx0ZD3ErOy9ga7vHSAalUkcnu5bBzSXWrecnoqKketYr/JlKRa?=
 =?iso-8859-1?Q?fS913Xs73DrqzHaIasz1biKwODV4nJTIINS9hzB6duju8/K8s4Bqj/O6cV?=
 =?iso-8859-1?Q?kmGz4tDYWmVOa9KwLKd1v7eRB+RDw2OWjqGOiWD5l0beL4MDZu/TtTq8JW?=
 =?iso-8859-1?Q?RJihCVvyeGF3wHod5SkB0d1+MtVBLcTWF7cbOqqxLoom4fyLfE4QNmFh0L?=
 =?iso-8859-1?Q?Pb234qn9Qm0jRiM0IZLCn2uF5Xc4C7uM+rpATHxm3KzrPOCZWAGzQbhkyC?=
 =?iso-8859-1?Q?4JyGsQGV0MvQpMU49hf9sGeUwegD3BMgEckqzPBgjuCBPMlj5xSPgjiGLx?=
 =?iso-8859-1?Q?Go7aZE8DC1bkE/ONGWgaEGgQD2Ys7nV7rEryy05oLjHK7vmPDWuXUilFBc?=
 =?iso-8859-1?Q?IE0LXmyrGv6ETiycw+k=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7e522c-7b59-4040-af95-08d9a3da0989
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:30.6438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssOyp8EMj6Tz04ZnTxTysFH3BpuH1C08L7gJta+it3qOfoQQA70f6xqQJuu3rB2ukDdFKlUh/05NkaIV51dUQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7736
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
index 0e66398a..6f90e0a7 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -346,7 +346,7 @@ static int fio_ioring_prep(struct thread_data *td, stru=
ct io_u *io_u)
 		 * to be inherited.
 		 * td->ioprio will have the value of the "default prio", so set
 		 * this unconditionally. This value might get overriden by
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
