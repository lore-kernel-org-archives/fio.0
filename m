Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5008C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B7BC61038
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhKIXlZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26626 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhKIXlV (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501116; x=1668037116;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nD1VKB3GS9cR2UF1YbPgzCKOYROaCNYmKCrzX5a+NQA=;
  b=A4dL84poKpDp8VPtWQ2fGKFBPW1NiKxCkdlsbEM3L6Kyl8B4hphuX/pI
   CHpkYmZcn8LpVAVN7msL0Vpz7wa74AzcidfCYpsHfmF3yjeYACzb4W3kL
   4iTw+cCzboH7UkAflW/+pqfrh9o2MTHQdha593ChXAAS8DcUS/saevcHG
   yNAHujpmKhz9qR+1DrFWDk7+cJeElFNRB5XecisMOjLPIPK8qew8NgiJc
   KgS6Lvy1rMRN4AhZTx/QJJwDGRXbKUqQuydrb/nBLSlP4fpUKP9VfYDbO
   YUytQS7gTHyej9L3NOE2ZkRyNqe5X/iQg2ituEK+kdeepmNFBYVOscheb
   A==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="186161346"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvzATmTXtTliLPUQTDRr8pJB6o0a8R56066jpVFLJmH80I6cF+jjw933tasA3I5oCspNzIoMw+m8JurU1JyYPDR//RWE/fpjqTkz1RQrmlayhbIuuxORy4jw0V0oJXs+mFfSQG43/iQSYfouEZv+LGz20kPZjKxaNH5EiNfEAOoCWs5E6dk29ewRWfvzRJLI3it39yXOHBc9WRtoj0V4e0fUm5LOAtt6VLXeUDNQSU/qdBvQlOy3V1/i7dnmhx5Xsw57AlybcER0aPHo4P0WI1knXrWvjgc+T2xxSRLV+tgYd8OhZghjnO0rd7/ik7R8xq4UnGcm4BCRS0tUWm4ezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRmYkBpvmOwiUGNhzRaZWzLtMUMKJNmzc3YQmLeZAVg=;
 b=EDQ0HR3XpIIFxvsre6ZmvESFK9IBVxbKuk3ChJcfs62FAOtgkG6VDYrGRJSbpPorzONNrj0eINJUCrb1ZUcI5D/YftxOQa4607xh47jP37aHJGBBUjgpVRIbIZchOVz38iXdqjm1kImcSBk7rLg6wHU5Y7XCuxWFVF17hYvW53RC44IhJTAYcCZYQrPsj4YqAlPloxU17vuVIZ8m8t3mWgsLZNeJb0ZiiKE0M0fSag04S6kONEELA3P/s0swiIhlGeGEE4P4Wn1TJLNfva6p38O4tGdaLEVitFBWn5vzHA8/sRJvPwJLybSxrPxUrp4Wn9253DMo+N4fGXsjR8Ev8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRmYkBpvmOwiUGNhzRaZWzLtMUMKJNmzc3YQmLeZAVg=;
 b=gufnn07FwOZJRRuQP7YwSPqlyFws1eKGFeeXkKIoz2bxUG4FzHCTIivPC6DFrkmU1fIdKxluVey8bgwub6m2MR1TVwvjcM81PjIpCuSCDbr4TU8OyCcIqdvf6//Oyko3aNR6NK0p1iw7HblqU7t2ml/xZ4JxZvuib7q3XT/jbY0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7511.namprd04.prod.outlook.com (2603:10b6:510:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 23:38:31 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Thread-Topic: [PATCH v2 6/8] libaio,io_uring: move common cmdprio_prep() code
 to cmdprio
Thread-Index: AQHX1cLnHGnYTFY8Lk2u1qK8OnJZkg==
Date:   Tue, 9 Nov 2021 23:38:31 +0000
Message-ID: <20211109233804.164786-7-Niklas.Cassel@wdc.com>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce3d0f34-068b-4f9f-3b9f-08d9a3da09fc
x-ms-traffictypediagnostic: PH0PR04MB7511:
x-microsoft-antispam-prvs: <PH0PR04MB751148B1E9D093C101A89557F2929@PH0PR04MB7511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E396JiUyF4xqhr6rfEc6u/C80apwWYg9T0Trkce4Y2mrBUmTdel+wkQuQEAtJMPxygJcRmj0IW9dHNm2yvP0fo3RoA9Wx0qmayN0mAbHZklD0y/JuuKuqBTsCEM0L1/vaEbBgnSo4yk3LT/U7+v7YTeCvC/NCYwuqyZ5moqMnj7W2LKXabB/+9GMCg4MiDNQnrZjV8g4V015ENuqebIzvKTr1lD6kyVZi5pOo0w/G4wwUnyjE/pnkmWO5278n9lqB+knmsKPIZnaciwcWDqae+QW/9cq0QP97x6e3AQ/wI4w17B4U9dcCQvK/B9+3WAncPt4j4xZ180fCD5G+NQ4XUINMhz/KI9FHDrnVhKJD5PkhHKpowa8c1vQ1RHAhdoHek6d9cbZx/hZ9ksVq8VVaQY9e506OU3Cffo0KWrEk786MJMme4+t0fiAnlmuPcZFcbC15FRShcX/2pcg7zkeFDDme4UrrYo0s0T7we7jwVrKk5Jimu2WRY0cXEowqIleXv9ydHhfY7EheMiLUHWgsXrVmEuFKEMZkPVca5T/MRuUL89SEJWkfEMKNN/uRX64Wq5c0X2NM56W90Jg2yqW8U65OwzZOcpNUxV44sYvFKQbHTzu25zHZ09syktMdW3ZtqmdzY6RSw0oy/U7SfZ3g1UKsYI/4mLf4jDg/1/nPrUWTShzJqmrtwG8niWQdt/0LsZ5Nbbx/ikxq7/5NIRsUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8936002)(122000001)(4326008)(38100700002)(36756003)(71200400001)(2616005)(66476007)(8676002)(6512007)(6916009)(5660300002)(86362001)(54906003)(316002)(82960400001)(64756008)(66556008)(91956017)(66446008)(6486002)(83380400001)(26005)(38070700005)(508600001)(66946007)(76116006)(6506007)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?JwKq34EZJVV0zbkgraX16UtdLhxppB+gLXwXUYeWv7sm0M2hEIxBcDp+YK?=
 =?iso-8859-1?Q?sDjEyQgeLgeuGVkQeEOaTuU4KMkjWQ6F6aqYrH6pAxsiZ/TPUqnivgSZ3s?=
 =?iso-8859-1?Q?J7mr55rLo+MEIzZq9HeNyz5rhRyTNRq5eXOcEWlbsNBwJIL1gmY3SZeha2?=
 =?iso-8859-1?Q?fw7S/zEaKV16f3FeNdp7uQJwj4bG0r0tfbrhIVT5QUlFNST53AEQs/f7yA?=
 =?iso-8859-1?Q?GUXdlStrwYxghzG67y5s70YZ8xZejg+8Q2Q9Sh4D3/zNngNRZAFGiw55/U?=
 =?iso-8859-1?Q?dfDoF04qhP+lvwb3iMWkci0NCodt/Wggo8cKqEyd0eEZQ82gH19YWSmPJ0?=
 =?iso-8859-1?Q?unCDcZxX2Sm4lOedpD+Uf9d19nLkfgxHBRmMDo4NuF4csVC445ZrSDmhhT?=
 =?iso-8859-1?Q?0XFtfjyfwpTqp2diKeDUH+MoR79N67QU9VL0usG4pOTOjZNvuzSPbWA/5B?=
 =?iso-8859-1?Q?o1tGyD7tJK17yd5ii+gYU4DACxtOPr6b0GrKCjlyA1+/sE9RHNt9EVR5RT?=
 =?iso-8859-1?Q?EdBNP85sEf7sjFwMSLnqG63oxG4RWNeO726Tu9lX9tXg4NQYZkxJ9bJgNP?=
 =?iso-8859-1?Q?4GWbP/l0zXgz4lqF0VVDOGprRR4jxgsx4W5Ez+SefjB8D6Jh/oBi4Kvy+s?=
 =?iso-8859-1?Q?x/r8wOBFV8Od377sslCG5AYxL8c2PICfBqMbARNtnBpPAfHf0H7ketTjqV?=
 =?iso-8859-1?Q?fFIBZDEp3PCqYXUzEJCNM1kJYxzn3CLiY8FYVZdvqRlBwB9DnDC+CmdzXv?=
 =?iso-8859-1?Q?aRIjjqEeftMLg2gz3+KrZzcQuio3cIr+f2Av4X33wa3MG2npVR9gX52dYB?=
 =?iso-8859-1?Q?ovbgXuLbXVgIPK0Nms5WlbAL4z7To65ZGHGNzQv/SRt7WYeqHQAVklHAmJ?=
 =?iso-8859-1?Q?1Ggk94dUpbWxHQlGz59rzLyLtkFNkaSb879xgp2JEMF4RXMy7hJ2Dig6NI?=
 =?iso-8859-1?Q?nu4NwFhA+chZcpblaQv90jiMg6e5jMRdmaRKoyxLWPCkipP19XLrhLPebM?=
 =?iso-8859-1?Q?HVjg2XV4ReBUDMbksUmiYPIKh+dyTQdpIwkhvxvAbCA+2i0jmBx9+aftwE?=
 =?iso-8859-1?Q?zxrunPdMRUcwVAkBDJ+u+PKY1v8h+705uJSAUWAhV97BUCKMvtmB49bg+9?=
 =?iso-8859-1?Q?3NB2d3YBHfULIAq5Qhnn+E92hm1dPxp7TLZ9trXfuKfYPAsb50hwEDFRaa?=
 =?iso-8859-1?Q?Uh62sheF+c+ZLZpRFWAowdhwnjPq6bcZwklHhdZ8lsbnIYLcZvJBU/Mppk?=
 =?iso-8859-1?Q?yKaAb5bqEy1BZUOK1qObUo6t/QZNR31qqVFSMJpweC00gtG8PZx1uHjTlB?=
 =?iso-8859-1?Q?Td6OOpd4BCbRGQpRgqBuQm6KEYGAur8Tae+7qOCU0qZo423sg5KeWq+GUQ?=
 =?iso-8859-1?Q?AccuSmyAy6pedkWxpbxGNJTm83qXBOnNzyA1BKeOAozNoJHHieGkBaB10A?=
 =?iso-8859-1?Q?5tjy+DNrpwIuZjDW37wJFrFg7YwVQB7qr2H0HOI8QEX8eFCYst31uLlik5?=
 =?iso-8859-1?Q?KeGcGcluPpPgIju8t0zS6/HBjdz+uoEbbDYHsfMJk9+9ENz3imZ2ybejdw?=
 =?iso-8859-1?Q?eBBWSoAxyoFEUTNMU86ZfqokrITV1dqUjb4+DQuUxbct7IluiqttADKIQH?=
 =?iso-8859-1?Q?tEFFKjXwQU/ZW8uelxRFZWrEnMcJN8mwdP1NFul4w+H0djde2nHGIqG7uz?=
 =?iso-8859-1?Q?vdSzlsvEeusYRv74MTk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce3d0f34-068b-4f9f-3b9f-08d9a3da09fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:31.3407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wB34QIGs8mmFxLeQJqSVDGfdap2FsQQbiNvu7PKPyia0DdJmLt7Ff4dGSMcZ/Fw6rICKuPR6IV79qBf71PJJDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7511
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Move common cmdprio_prep() code to cmdprio.c to avoid code duplication.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/cmdprio.c  | 41 ++++++++++++++++++++++++++++++++++++++++-
 engines/cmdprio.h  |  3 ++-
 engines/io_uring.c | 34 ++++++----------------------------
 engines/libaio.c   | 28 +++++-----------------------
 4 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 2c764e49..9cad76b5 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -67,7 +67,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, con=
st char *input,
 	return ret;
 }
=20
-int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
+static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
 	unsigned int p =3D cmdprio->percentage[ddir];
@@ -89,6 +89,45 @@ int fio_cmdprio_percentage(struct cmdprio *cmdprio, stru=
ct io_u *io_u)
 	return 0;
 }
=20
+/**
+ * fio_cmdprio_set_ioprio - Generates a random value. If the random value =
is
+ * within the user specified percentage of I/Os that should use a cmdprio
+ * priority value (rather than the default priority), then this function
+ * updates the io_u with a cmdprio priority value.
+ */
+bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
+			    struct io_u *io_u)
+{
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int cmdprio_value =3D
+		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio =3D cmdprio_value;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the default priority (which is either 0 or the
+			 * value set by "prio" and "prioclass" options).
+			 */
+			io_u->flags |=3D IO_U_F_HIGH_PRIO;
+		}
+		return true;
+	}
+	if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default priority (which is
+		 * either 0 or the value set by "prio" and "prioclass options),
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
+		io_u->flags |=3D IO_U_F_HIGH_PRIO;
+	}
+
+	return false;
+}
+
 int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
 		     bool *has_cmdprio)
 {
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index d3265741..732b087e 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -22,7 +22,8 @@ struct cmdprio {
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
 			      struct cmdprio *cmdprio);
=20
-int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
+bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
+			    struct io_u *io_u);
=20
 int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
 		     bool *has_cmdprio);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6f90e0a7..230f08a5 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -456,37 +456,15 @@ static int fio_ioring_getevents(struct thread_data *t=
d, unsigned int min,
 	return r < 0 ? r : events;
 }
=20
-static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
+static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
+					   struct io_u *io_u)
 {
-	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld =3D td->io_ops_data;
-	struct io_uring_sqe *sqe =3D &ld->sqes[io_u->index];
+	struct ioring_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
-	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio =3D cmdprio_value;
-		sqe->ioprio =3D cmdprio_value;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default priority (which is either 0 or the
-			 * value set by "prio" and "prioclass" options).
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
-	} else if (td->ioprio && td->ioprio < cmdprio_value) {
-		/*
-		 * The IO will be executed with the default priority (which is
-		 * either 0 or the value set by "prio" and "prioclass options),
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
-		 */
-		io_u->flags |=3D IO_U_F_HIGH_PRIO;
-	}
+
+	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
+		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
 }
=20
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
diff --git a/engines/libaio.c b/engines/libaio.c
index 9c14dd88..dc6ad08e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -205,33 +205,15 @@ static int fio_libaio_prep(struct thread_data *td, st=
ruct io_u *io_u)
 	return 0;
 }
=20
-static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
+static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
+					   struct io_u *io_u)
 {
 	struct libaio_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
-	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio =3D cmdprio_value;
-		io_u->iocb.aio_reqprio =3D cmdprio_value;
+
+	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
+		io_u->iocb.aio_reqprio =3D io_u->ioprio;
 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default context priority.
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
-	} else if (td->ioprio && td->ioprio < cmdprio_value) {
-		/*
-		 * The IO will be executed with the default context priority,
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
-		 */
-		io_u->flags |=3D IO_U_F_HIGH_PRIO;
 	}
 }
=20
--=20
2.33.1
