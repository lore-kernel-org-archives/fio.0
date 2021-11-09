Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE16FC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C6061059
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbhKIAbF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:31:05 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241226AbhKIAbB (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:31:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417696; x=1667953696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LTRokZFSRB/n7HC3g7tc+h/mH6NoaAis4U8i2Rd9AbE=;
  b=V6pszz6ky2rmzLOWiefYHcVe8Z4gY22qPMKsXcdBAyKcx7MajfV4uLCm
   1yobpetv8h9yWsL1Qu5MTBucGywKqIkkKJ9enLfxafXUiLZc1oVEJYr6I
   L4cO6F61bvoOGx4KVsReqcew/a2SaD/9qnzkCM9Gt6vx9BWCQEvj0o9FM
   CndE/TODxSYZzKIoUkV88dyvu9UzQiD4kwbD/z6T7eyKmhmhlx8vTEtWj
   kfdbm4JzkNZEiGgTLl9quj1KKl2+7SJigElWZGxP0TGO1LdVzwQuBQKNG
   6RzCxUYF7IMvYMX95JiMOGn5tOEw6XHojSTYeSSrLDu+lI7K8or4xx047
   A==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068531"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gll1xPFzOVTq/leudbL7kwSVkoMAOTBAmIHzMiDDcPOYNqH5325F7R4PbcniGvEPHEHEr/jKhqncPWiivGBtOuRMHBz5sgvAq47USoakCSTs01PUZiz4FYDu/zsktEeX8XkfYyjVej8vq/OzJLRIqZCWzJ71ruHpmzCLyGS8hJ+6UPs+87WBKc7FRGnn2eJE2R7C+E2SBEFQkC3cCiqYobGDT1xL3fFwmsj26DxS/FHgyU6kAgOitsh/QqDAO6ZfwW5hDx7jrSSaCzVwOZTTEjz12YOAPVh4zZNA0fUscH+GIUP6Iw+liObpHMoc+KTgRw2SbgsjVdCMqIZ1oydYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEsC9lL/uhWmC0glBTuDgAIR1WHOC1E0D2MwCsJyplc=;
 b=gjARma+EAm5WHW2CpUksbrQNQGGJ0nlhoMKAnGFhMpW0umnCBYivrxL0GrH4Sv5A9mbRVnSW7MPCKCht9iWcQF32X8C+/YWFWsjetsNwy23aVYmJrBmDukrPXWHAUX4HQ7iOuuwRLv1IbvrgXcypDfVb4SVQbIcR1qqjOZ/JGKuvA/w4mTKVL1V9Ov+8W9+eQffX3z5hoIid9i3huQGYrh7TxZyuiMlxgu9u1ujw4lfauPuOHDpr2Q6aYkDVIywvpaIn6aMl+jVLSxB9NDAlrCjQ9E2ViCUuSp6YhSkvcW6uNrF1RTBy1m7/SQJRWivL7SH0vBppxxbQjh75nGjCrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEsC9lL/uhWmC0glBTuDgAIR1WHOC1E0D2MwCsJyplc=;
 b=VxebBLPwmLBQzUE/UoRY77SNbk2R+AnwaYev13bwqiDL9xlGfzGuZUq4NCJUF1qMYxLcdFpRE2RbdIl53+DvMKEFWBPWmNJRyomre3y+U0lNbj1uhmjnl1475Ia7ye7C8k6PupHt4bucJoZ9SgJq0aJfKFhNiClzO7OKBi2indU=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:15 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:15 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Thread-Topic: [PATCH 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Thread-Index: AQHX1QCvZQ5YXoVsmU6L24MMBmBx/g==
Date:   Tue, 9 Nov 2021 00:28:15 +0000
Message-ID: <20211109002655.117274-7-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 2c02cdc8-bf47-43e5-ce49-08d9a317d22e
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB714422A6D14CCDC4EDFE7B0AF2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Jb598BpxXz3WhhR+eE82hlY0u7PFHJgw1DXC9bK49SLfXyCOwbuDgAQry2RywY/MSF35CnFOYkD88ausD5Eu5NwUTuvdEpVL4fFODOiutLVxSS7U9nNLNyiHIhEmx7V4n8j5c9ASweDArEFAFYUTMZhpbCEGfpLt7T0zCkVLGzE23xrf0kuBba4ikGEyNEyZwI5EMFRs44NrgoK4HxoXGAyX/5bQFP3laOE8TceDZMfG4cm/0ADPiw2V/ubyVWiKvr++jShZZrphTGcYc/BfRWjY8V7hhmNgX2I202RuxVvuhf31YQoGWkZI2ARozhNGCBWtqtT3CHIpPHXe8XOXNuP0RfM9FjZpUIdZypb+b80ZdXFqD+joUxSCseDIxzyLo+Sgv/leBG9ZAzmL8Rd/E+Ba78sRPLbgUJ6YomTLMdfiUzt9bz8cszZJcKGnPp3BXRljh3qLtcvo7kT3QhEOjkRVG8q+pKCjA9NzDo3eaBsYACEWAPRbJHuszeho/2Q89uSYGs9ehNoaG87wZRzQDG5fxT3D3wpHx81nq5L1Nwwe58p5eBRaLbOUEaln5A/knoi1kEyy65JckDPhQu5G1y8C1F1D7lYQQT7Hi6xSet6crS7ZSj/DghKBZoDFdmXD9UmiqlhewT/6iRbCHCGhLLROIqE3dCZsEwlQS2LezrHC7WRdwUxhG49sadEMiu7Fp6UeG8axGDdLstKXe5fsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/pViRQTogYFfGJPOgI3mc1cOWejXba/OwGK/eG+bmTuzRR1C6AHp73uEDu?=
 =?iso-8859-1?Q?JbJXhFZnLkF4ob6iKjm/7CI2NBjsX/fmj2l5EZ0s74LXLKmYXJrmw/C1mc?=
 =?iso-8859-1?Q?aGfneiRkIgsht28vqQP6UpGrawWf9sPrB+zU18SyVqzmYtSSRWKDvna9c6?=
 =?iso-8859-1?Q?9mL84p4kXJFpQXdE+Av5bvRKgH91i9x14i2poUaxKTduEb5zJ7aCfAXyU2?=
 =?iso-8859-1?Q?wEnOYy5juXJjQzwvF0lVLe90rPh+WOrUgzNwmWhWC2eCyPIEpmWZURYNCg?=
 =?iso-8859-1?Q?CfajgsSDmL1zky8Z6i6oriGdeEl43OUE7SnKEkkXTXexhkXOrElp/xIKW7?=
 =?iso-8859-1?Q?rH1lyj3cdqs6Sd0KKUZjv2BJTcJWD9c67dCDuNprXGSwOiFq49J8WGGqa7?=
 =?iso-8859-1?Q?mcv1dQxWnE5r22DGbqVDHoYyaiG+CKBOvkCNjKQfdZyyBKuwekiXZQdy85?=
 =?iso-8859-1?Q?DNhpLqnvUS44zIjBF8k4XF8CE2KqLqTQ8l9MugPEKUXopC7ujR+XEXLpVc?=
 =?iso-8859-1?Q?SYymG2cksIZzFkmzTt2YafR6brrygsrZ/b1PR5rGL3Q6BaPHDqSK5oM5Ee?=
 =?iso-8859-1?Q?/qVd4VIetx8rpBR563lAQbLqHv47iERORBbJM2Dx231W79skYHfPsThqbx?=
 =?iso-8859-1?Q?Fo9+c+F1Xx4ko2FClBx/WTEyI9rdhaAyCrlRCzPYjtvMuVwuyDeA52LsAc?=
 =?iso-8859-1?Q?OB2IOVut899tZvUt002c9BH1bLfY/jW65xF5c1neivwAUjWZeUBFPlxJDr?=
 =?iso-8859-1?Q?hxhycEUXecXzBlpJ0t5Y+aTqzahnCeUuhAminqWi7lfYd3WukrbJwE3M+i?=
 =?iso-8859-1?Q?P9kZ5dmIGc7Ipk2hAMo0dBNENvxuXtx2YiQJqkfM8cRCm7D1jozYgseIND?=
 =?iso-8859-1?Q?EWpmeXqyInRC4uNIkGbSN3sk0mvEwy0fS2sgItEXNFkojzRxC2g5ES7osw?=
 =?iso-8859-1?Q?2ZIqaZYfVUvO1Vwu1iadS8d4BItUf6pjMBRqf5NM0hSUrZNmBq9bCkGMUk?=
 =?iso-8859-1?Q?POne8sa01X8tSXJnghe++wahw4JrY1v/XNhaZ7xbLVf1hVWCTjUobkowqn?=
 =?iso-8859-1?Q?M0tx4HSSig3kIqSKXhKLTyTLnX4tk/yLwvLNZGNr7sQcF9zs+KFZSDDvgG?=
 =?iso-8859-1?Q?/0m5HcpSZedjTKvKcU97OgcARJZ1YZRx7m8G7QbnZufoRTOP+8cjrtmfRK?=
 =?iso-8859-1?Q?40DaVrPCCYH896iPaHs5JsMrjaZycRzBaW8dbB7vupMwDSIoF0riDBwtDa?=
 =?iso-8859-1?Q?7lNdQyidayFOt1CSIU/inMQbY4ceTefvJ2ZlFE6Nhkmm4uQkylUKzDp4m8?=
 =?iso-8859-1?Q?MwyorMtZnx/FP/20o6muXEYW+BBo2d6Jdri1f07c/ggY/eFgf0c0Asv2SV?=
 =?iso-8859-1?Q?Bva1426bLZbmibneaoeeCtGH5dWpSvn7g8F5RrkzADQCx6tctP6iOlpB99?=
 =?iso-8859-1?Q?b8c2rbg2yp49qmGLmeJsWoCRJdrdtcranUy/l3e4+KaCSrBbcnxscpvv40?=
 =?iso-8859-1?Q?rIJIVNpPDwfoxFuGqpZicL1xnh79CR6zRXzMtMlXs6QM89gBpL9VD5LDvR?=
 =?iso-8859-1?Q?yjZvv+w8aBSBakLIRJ1QLGvmEjg43oz7CnAnBGGbqX9SXqWvAIDsGye1E5?=
 =?iso-8859-1?Q?dLUXz2+GSpHzC3xZgqBa1o1lWlyf+5QnggJlcstBF3bAXScbNQFfhC8gFK?=
 =?iso-8859-1?Q?AS59BWQi4o+JkhQNKb0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c02cdc8-bf47-43e5-ce49-08d9a317d22e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:15.3552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AHpCxzh4PfXpucpvQ18DAonuyNNARMgRZCRYYl8t56l438E4SldpsHvWNCdFMZjW1StDQcIlyJ+KFKbx+cqCCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Move common cmdprio_prep() code to cmdprio.c to avoid code duplication.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/cmdprio.c  | 40 +++++++++++++++++++++++++++++++++++++++-
 engines/cmdprio.h  |  3 ++-
 engines/io_uring.c | 32 +++++---------------------------
 engines/libaio.c   | 26 ++++----------------------
 4 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 2c764e49..01e0a729 100644
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
@@ -89,6 +89,44 @@ int fio_cmdprio_percentage(struct cmdprio *cmdprio, stru=
ct io_u *io_u)
 	return 0;
 }
=20
+/**
+ * fio_cmdprio_ioprio_was_updated - Generates a random value. If the rando=
m
+ * value is within the user specified percentage of I/Os that should use a
+ * cmdprio priority value (rather than the default priority), then this
+ * function updates the io_u with a cmdprio priority value.
+ */
+bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
+				    struct cmdprio *cmdprio, struct io_u *io_u)
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
+	} else if (td->ioprio && td->ioprio < cmdprio_value) {
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
index d3265741..c05679e4 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -22,7 +22,8 @@ struct cmdprio {
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
 			      struct cmdprio *cmdprio);
=20
-int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
+bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
+				    struct cmdprio *cmdprio, struct io_u *io_u);
=20
 int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
 		     bool *has_cmdprio);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index de1e6cc9..46f4bc2a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -458,35 +458,13 @@ static int fio_ioring_getevents(struct thread_data *t=
d, unsigned int min,
=20
 static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
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
+	bool ioprio_updated =3D fio_cmdprio_ioprio_was_updated(td, cmdprio, io_u)=
;
+
+	if (ioprio_updated)
+		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
 }
=20
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
diff --git a/engines/libaio.c b/engines/libaio.c
index 9c14dd88..f0d3df7a 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -209,29 +209,11 @@ static void fio_libaio_cmdprio_prep(struct thread_dat=
a *td, struct io_u *io_u)
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
+	bool ioprio_updated =3D fio_cmdprio_ioprio_was_updated(td, cmdprio, io_u)=
;
+
+	if (ioprio_updated) {
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
