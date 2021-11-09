Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9CCC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE6E6109D
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbhKIAbA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:31:00 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241223AbhKIAbA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417695; x=1667953695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J9exW2huoXwRUgVbzjzcnUI041uYLbjZQCWJW9CO5Ls=;
  b=bddzNbC7oy5/oeqH1k3Tvf8jfoXEbJgc/DF/mMmqum9aUL8EstWHBw9v
   L8DwaQnztmyTSFowTxcLJP8f+cPnDGFUKEIEA4O6/76lJQcC3XAm37sAZ
   8RT81Bft2E6zBmjiIx0R0YtQ/E3Ii4NuLskopv8HpHm1T3sd4QpuBbQ1P
   zrSnQ+MoWQXLM1Bhyb683fAcdOqMXMmFgvu+RUdIEUZplBGlGbDJfx+0j
   xaEQt8j5Gj0l3sOwWPaQLX6/xYZyVJkwZLbFH4tU0+KkcEKggJs76Ktm0
   FNGGy22ie+gP8iQomdiuTo7NJJqTygsj3VQGsE77MmzcTZmx9xHurzVBW
   A==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068528"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMBfCl30A9L/DPAmJMAd6ViVyoJhsuLJ/b60aosn8Do+VaiOOarM4645Lt9RliV9nr8dzqyfCFpGCZ6quF04ZWyEy8VrbNV9y9S68XgifTILSzgBK4fvs24w9g/n/PHXkKxAQ2gYM7+tn0Q5FkdDooIZFrUEK2RyammRJ0SarFuZlG9gPE7Ay4bwnY5Wj1xdJ765sp0kkAGxJbBO7WG9AhM/hgLfXfjc4SV+0eW3tMYTgkSKm4gd16c28hc6J+dtVcHnhssEPr6MvsNq2EiqMishRI0909Wmo/TYZR8npGolU8UQUANxDhJtC2DS50GhIiz9VKmobq6u1UfaI7rbng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPhsJJZ6C3T9xpbFANelKBB9x7LRNTKCb+o0BSAVCjU=;
 b=jnGi4XQZkpwyHNKoGQrK/4EK+8VqURPA6mOSvFznFVhLtRXeemhDLGI7Pzbjv17Fj30IJ0vqiqaWcoGoSUGsqLnrDtAF25nwQhRND0yGxJRtUxD0ZtcbDttDWlpd4nOhxHZv1s8xkRlLD/3q7uJS0NXLT5TAxSytRxr25iEK+pCp6P0s6ddsugnIpiXQGg9+VEXonTh7LledpfjUBCumGcmf5NIQwevdN+0wsDWlUTADnNgfBw9zVZMLuhjvFq3ZomfrfFp46zSjHl1vF2eHpXJnF06nCa5KlKUs/eByIk3SGy9LSCEwfsdIdB2luIA1kq8+0cYAIy0rj+eTJtCLNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPhsJJZ6C3T9xpbFANelKBB9x7LRNTKCb+o0BSAVCjU=;
 b=oLGxGk9byN5oGSVfuFeWUU288VUjFmocPtgPl3+RKTlDmau/68gE3aN8hHSZN8yDeX9NRq7n7b3gj/Bk2dw36aBBTHJ99x+uI8E5SAy3uIgZmooONVWqTit519s1AuXpx5I3Md0huxg/4Q6U9IPPyxzBrFD6NL7PmC8L9ZAVaT8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:14 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:14 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Thread-Topic: [PATCH 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Thread-Index: AQHX1QCuzFhPFV9J40+WKebwXByrrw==
Date:   Tue, 9 Nov 2021 00:28:14 +0000
Message-ID: <20211109002655.117274-5-Niklas.Cassel@wdc.com>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2364c5dc-c304-44f0-0b9d-08d9a317d16c
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB7144D0EFD8550117A05F59FCF2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /uYmk/5tciffmwMn5MN3mJKgVjYuXvhmbxgZo1rW43kHjtWA88UwTRgzLhurH9nO3M5ukvCPk21Jze7lsC5UB84k0fZJjpUNT6x+fycfmIIXHgzSVze/tp63SJ0DsxAxp+1TIwHXZjf6Tqr6hq2hMAY+1fAPS6g4TXnV0Pz7wmw0GtWZJh4FUF6aM2EqDja6x+JqPjLS5IMHWCNUaDpXqyNDNTiqPJUnCkkECZR/JRi98drRuxnB1qPkn+0GH5quCFR0B+ivS776CtrfRAF6IQVGyvGxYH7mNGzbnKUTTwADkznhxg3L6d3ib6/2Ks7OmA7/Nk1/OvxzDptJ80+aKxkew2jGjVObyafadH7Rppi3ZScRV74f+JvGF9XdqDxxDKesO5W9y0V8ouFzDjx6mVPLMW0CP8DyPRFRsG8d0qo1KIPT5/+iOdTF5TpECawFpPLK2rCg/MYzxdI6V04pJFlYQwRZl5oVlyMi1AgghstCwWi3xotWDmvReWqrt+aMu4u7Dx3iPwkNw79kNq/l0i0c/oKSoeeZmRmz1mGlyVdHrJP6jIW8BnR52uIWD2LME3UywV3Tn8553emc9kSGzpOX2rm1hp+JKlFNGMB2OxNjL57zvF4l/nFZHZQbelfjtbMe28bcs8D2ZprZ7McnqAJSyDbGF7BGmjaUlKHsez2p6Fr6XTFFBmQC2RbNa0wJhsZkcjqjuIQswBZU0Tp/Vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PPcOdK3plwYzBSEosttAiQyY0QsjWM7sEaZl3+lduZUGP2WaayMC6fm4dN?=
 =?iso-8859-1?Q?TM26ROeb7UAjWlqNcsV+lzKMKJkwTH1KmcXIFGIKqmtKia9FEvB3Qpc9ye?=
 =?iso-8859-1?Q?MLmhYSbAg49pHXwEJ1cLmlIT+qPqxs5cpAw+KY2MRhISU2LVQuvcbefjEB?=
 =?iso-8859-1?Q?ROoNDsi0yEVGfTWrLQeuQoUTIoCu1CKasDaO/qBiYGcHUXRl+2CqnArqFr?=
 =?iso-8859-1?Q?4OcsEH3ZsQVE+L/Edk5wFW3IVQjhixauJpMYyUnwqxKyEKwqzOXxjPP1Yt?=
 =?iso-8859-1?Q?qRWY3VsKK5857tREkC7dPngJZKiUQrT/4LoVxrUWGJ3txGaY6M3sOUNNbe?=
 =?iso-8859-1?Q?5sdN7FJ2cjEnwVcPv+9R5HFqpeMsOOoCiEQJAN0lasCRcmllnNzolVfIQr?=
 =?iso-8859-1?Q?Xo25uBFzuYJ6rylSoAYLSYrrqrdVppluP+26h9KU8kEN/YwDTtmADniT5W?=
 =?iso-8859-1?Q?IUl+CY3YyYkFRbiz22HmVmWtTyQk7yRAXnoCvzzt5AUnripH4mFkUTf4DB?=
 =?iso-8859-1?Q?ErzkorJL0qaBEUF/g4UGy/3UH6dmPSNi14xRBvH7kZQdFLIkKKTvhrgO+m?=
 =?iso-8859-1?Q?8+9EDFdRSQX7rLf+SPk4KvaPQp+8tUrGc8F5Nw9ka/H5UWHEXjcAX9y8P7?=
 =?iso-8859-1?Q?paiGHQWLOJV3k9SQk9NuwH07b7mTSBDIafGcBPn14T8qnjWhFEATRkhJIB?=
 =?iso-8859-1?Q?XN/vkQti7qJEUY67X6rBygHTRTsQMRefsT6wyL9mZoEgrLlylxXeHDQz1l?=
 =?iso-8859-1?Q?kYUeg8MPtgHPxEtZ3P4esFjcJQoGc1+yZA8m89eD3sR3FTDgp2ICpknIe4?=
 =?iso-8859-1?Q?nfKCoPQwj1+FYPY698WQx+e6CCYSUNbLdd+/nefvQt7Q01HLcvcAsJQ6eB?=
 =?iso-8859-1?Q?nPf5Cj6dyOG4q0FkzCI1NASg4NR2BjpnSj5F5bYrTPUtCX/9LmaL7STLcP?=
 =?iso-8859-1?Q?+1PF+cPaX4lQCNmLRBJi+13YNiq1Av9mLyPc/AsF+CI5+l1m/8689Yr7aG?=
 =?iso-8859-1?Q?UzRxTlrbQuBdOdwWIW/448bgDOCU99D32IbwZCFiR+Bz4Te38C07bTNZPA?=
 =?iso-8859-1?Q?sR7RKIC8eEc6CTUFI3so5Lut4ueXv9BG8oTN1fjUqoP95BqLOfmKrurBHH?=
 =?iso-8859-1?Q?HsKdroK47jy2KLUmlKnzdN9sOtdnWZsOSqrd7wT5dRQUZdoPytsvF/ZNBy?=
 =?iso-8859-1?Q?Y+jr9C4uGgE+FcajCM5BbRvNtFY4V9X1NZH4pX3IHOfef8H3kul7FMEa5H?=
 =?iso-8859-1?Q?GVYTiFbutKvyJgYSilBYWNeBNCRZmuk8GnSaeHcSF8mst6QV7ynVDeFqhn?=
 =?iso-8859-1?Q?4VPDYPUpKarTzK2Tn76vvfXkAJrcinvmO1Vlak2GVEChNw5uR6lJ7IDQ+g?=
 =?iso-8859-1?Q?8dqCpHkmKzjSfLMyec+iBOOyMADFY3yhJ3ynn4XXumBNIQxl8wXNrQPCb8?=
 =?iso-8859-1?Q?4oFuPyfRua8SLdBbc0AqFLAEPo03eTuOYIcUKUNt/7YhjrS2oJbsgEkre9?=
 =?iso-8859-1?Q?yUP2GNm/ddKkK+Y1eQAFszJTTqS8PBpPeLlA7/9cc+aDC25m0eoR+CbYK1?=
 =?iso-8859-1?Q?xySgnPnXJJPVAW2r4OuR2yFT8j+1zlNchSXn3/DNGuP1+N4vTKM4D/+kCY?=
 =?iso-8859-1?Q?YtWRnyip6hP3IvmkMsV3PVmzUwN3UXxLSKEZpl7e2gOOefcpNH7bOrK+6j?=
 =?iso-8859-1?Q?DaCUTwB58xe+F8Tl7x4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2364c5dc-c304-44f0-0b9d-08d9a317d16c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:14.0798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S84ARTDrbBzMLvAbK57P1XJ1o30dykV7bYQnnZ5jQw+Ee4dJBLU9seQ3G37yKknhJltgFVYoqvtKqPnrtCH2DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The default priority (which is either 0 or the value set by "prio" and
"prioclass" options) is now saved in td->ioprio.

The simplest thing is therefore to unconditionally set the async IO
priority to td->ioprio fio_ioring_prep(), and let fio_ioring_prio_prep()
only handle the case where cmdprio_percentage/cmdprio_bssplit is enabled.

Therefore, fio_ioring_prio_prep() doesn't need to care if prio/prioclass
was enabled or not, we can simply think that fio_ioring_prio_prep()
might "override" the default priority, whatever the default priority may
be.

Doing it this way also has the advantage that the prio_prep() function
in io_uring will now look identical to the prio_prep() function in
libaio.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c | 51 ++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 27a4a678..8f3d6c39 100644
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
+		 * the the IO priority set by ioprio_set()
+		 * (option prio/prioclass) to be inherited.
+		 * td->ioprio will have the value of the "default prio", so set
+		 * this unconditionally. This value might get overriden by
+		 * fio_ioring_prio_prep() if cmdprio_percentage/cmdprio_bssplit
+		 * is enabled.
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
