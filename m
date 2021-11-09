Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A97EC433FE
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355FE61059
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbhKIAbG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:31:06 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50073 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbhKIAbC (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417697; x=1667953697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HOri3JR1r4/QiT6C76RQRuWjYexHdKugm+wJXLTNUbk=;
  b=Tr9l82mf2aLOcmsUoDo1UytrXU9gcxgyjpR12dZCT+l5/cOUl9++Klfb
   SvCbZyTPoGOCqx08LFSrs3fVsOEKDDdaW0addXd4qmrhwD6di79rvF3JB
   1rP/pClcoZ1ojrz4jgosOo3e0nRVERG5p81zm20qKFMV8yTNwQ0tmOB+s
   5L5w9uklaHTQbhJC2Cnej+87dvfj3gRXMk8AV0YvZUH73f8KXKHjffXEq
   Bli7K2OAbaKDovkYSyK4MGcDq+EnXMsEpcpwV2fsS8Jm5dBoopGjWzj+G
   LKzYcVLie+RBH8A+pqwfEJvOYpBK69i4pxBm2A70WhN1nRWPhHGyFOI2p
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068532"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dV9Gnth20pnK4swC7bXSD280/jWe2aGo6vmkHjJRYSvLXAGH0uCdiHxoZlXh4Ffc1KxMqa6SI5vB7kZyZCCljP95TZ/19ikWplQN3YPnrDbhHxUOXS72WT/vJ6HP/nnXBQqPRgdr8j7lpn/XTM/6+bpfyaPGYlH619vAOmljv9qS2DiyU8DVLz88T53eQHKQ6JlrFgLYOsaIQKhJksF63Wrt9vBNyMwOZdO3RMFmLe8tHOErtk4oSYPrzYtNIEobja4vg+qAcsE0NjQCSoeV5epmpToseWarFyQh6T8AAvqOCCPR/Y6PUbqiNIqRTBLQSvqzH4MZWK7KGKO4GJWvjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzCS2qU6rQStoFa4wmX7A9iMKt0YJJuSW5L6Poe1UxQ=;
 b=N1xsaKG9iOeaROGrTe5rvAAV2q+REdPS3Yj76FizZjuuG1AvAtUr9aFITZrMbllkU5GQLbX5Wekcr67frgaZ7yE8jwz5PZWKaaGbJEQRO2tgWl23Jp9kvxmyy2IHmZZ+z9FN4CP6Q5ZB3MjRet28cH2VQO+LoUjVP93h1IJzTkfujk5y2yy783ijgTN2VXDj5f7Dr4ftHe49+bW6hRTkE1po1gTvqdIoCHzXk7vl9EMVB65G/GPucIm1wDQP9xcZV4sCqxz+E+7HWGD+dhcH7d/+vtmrq55X7z5oDV4RIU0v0CnDoxntpVN+7lLYygkiTaDK+49Ypa/3Aoaou5u46A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzCS2qU6rQStoFa4wmX7A9iMKt0YJJuSW5L6Poe1UxQ=;
 b=jHnJjG+N5UDE1C5ZNbETXXfsah3zDJDKo1b9Cf+nye1ocpIFMcEaKsNW0y/lH9OQT/foJC0Kb2Qz6hDxBaSCOEu7EbUtJT4L3rRcnalncQY+lQmxFN5qn1swW0m2hHyyyLdSPV5tULeHhYDX9miH3VU8lSTwSWLZ9kuoJXPFdwI=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:16 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:16 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Topic: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Index: AQHX1QCwimtz2VgxCU+gnzQiTYJoIQ==
Date:   Tue, 9 Nov 2021 00:28:16 +0000
Message-ID: <20211109002655.117274-8-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 63bf2426-b669-4527-ab7e-08d9a317d2a6
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB714496B61B2886B37A7A58EAF2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WkeNnIcuIaOguYSzByDlpuWYQ6sV5FxWpbiRtP21XV0jZuNxpFz/EmUzWM8F+CGz/kQF4Kx7G2hzMAr2L7gOW7mxBjjCpNqrwUKGQYW2OBqTx86m3LxQnxcr1+3HUHtDNIyRxyURgjtMJyyjxtO31hQsowvtqdk9vfb7wraeoqCtLp7BQJXokpAI4C9TDq1jrNqHi8RIphMfX2iO8R7YWHKF3UCZ3YnJ2KbhR6L44Lc7P9zYmFf7pr5FWaTcPv0vVc59u1LdbWfDzBjB6/K71Yn9pldY6qu8CRt2dELzvvI6AcHsktndgYUBGbOiAMvapBWwL4gHO0YDsq2Q4HPpPJpnhHPG7WXyAKK3crtTyPQOueYpQ1CA+eyx2xLoVslmM7HIKmv03gmA0Aaie8kHiezAnI6H6zgrlyQqBIY9UIzu/7omwSHFROY8UIBsHGke21q2bzTWhI/QmJI/RRd0+Q/+Q/75C6xfHAOM1DfuEFYsLvJmLyyi5tMzDO99p15qsQqlzOQCfLHt3CAJkMMyFjOurvW+6n7kGLj2tTKCqBiLM50AueaqgvOOqmL2LiqpFfVRY8TfXYoO6Ok14jLLZtpit85xo4t06X2YfDT1OH0JQl9LscrbwAkL9Ks6lExXyjhR6s5E4zV/2AqpGwGvjcYCiTdGNnvDViBCWrr37xVunaS7AqmmsAlo9uMgyntsGYVt7iU9mKit+1UYZn1lcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?14WzvsHuilFiVKvo3MTnFSWVkfLfVdh88XjJAq6ENS/sekT4B0c4XbfEYD?=
 =?iso-8859-1?Q?1t4OvCRdqLpsqAuMdAG4UMuPjHebBLawZOdvfWZy7bdLAPw6so5MFzT6R8?=
 =?iso-8859-1?Q?K10EYlEJH+BDBx5E8GIa9fpXSTOUygIaEvOr01s3jHdCl1BOZBSbIEQDY8?=
 =?iso-8859-1?Q?EEeG3oitnQnCKCFE5uyaAfVIZ49fRhCwvXM98WvJ40SUlSSyR+4jMh3t28?=
 =?iso-8859-1?Q?AMjVgITSG/w9fw0/yu1ygVPL43wIZv2jOaKqsdVVasW4eGLTjGxEKw3V/c?=
 =?iso-8859-1?Q?DStbJx3Y/93XVxQWaLqhLFFxkpHVQGCOyTsyarRDgwAz1QdrU1FRS8PV7+?=
 =?iso-8859-1?Q?TKTNLrNnJT7ZCFKje+XWpUc7wwlQ9wAfA42TzM9U90ygNyuQhN5hlB8+pH?=
 =?iso-8859-1?Q?PRqrhmty7ZRFGyE1wpK5cB0i6kRBEbFy9GMp4+DBOgVytb3HLtpU0pZ99K?=
 =?iso-8859-1?Q?qUVibfyLSApDqqbwlSUQ8wGfPiOHuszKMqa/4yIUM9GMq5ISBn36MEN1ia?=
 =?iso-8859-1?Q?z8ero0kb6qZ7U4d7DN64t0JSm/6Nh6JanE/d8y8FfKYkBvE0pTaDFufKI6?=
 =?iso-8859-1?Q?2SehnORUmE2rTAnp0XW/id1ny1AXkc6ksYRWPR8RlnDv64Ftav+LYKw+Gr?=
 =?iso-8859-1?Q?gFictZwBH11ck5LTBaPjTopqTFkED9MK2WJ+ZHK2piR7S/tlgCadBwLBHU?=
 =?iso-8859-1?Q?8aKjIZ13vFmbD5nW7y9gPUQ1ftoXSFwvAcKnG7TtcZj9OE3BfSY2hGhbZE?=
 =?iso-8859-1?Q?Fb10SiK025wuxl8FgI6tFZD10xwZEmKf0zYEiQQjt6QlC3rFATcrP6g+qo?=
 =?iso-8859-1?Q?5Vjt2WfNtN+X3+tAYXQDy3Jzz7IoUseo+7SoWEncpTK8d2e4MT0l6Q9ivJ?=
 =?iso-8859-1?Q?SKM5XQTQKRPeaSGQTLAUzFiAmzCiZcKFf0o5pbvawb+3R29LB3VaqSTAHp?=
 =?iso-8859-1?Q?z3EcrXowcGY1AnnfgwB6NAIJFkYbKozBTzkidEilzkeT8wsjPXC5BspUTT?=
 =?iso-8859-1?Q?ym2wAqQiPzph7JmPL3XGSqhcS2tHbHvuvYjtggFcmD8mOSUTJtxg5Zx1nJ?=
 =?iso-8859-1?Q?eyp7ey0ohoKK2p+Y1w76zENRI/qhPuxPgzn2hUY+xktZg6v4rprcitsFz3?=
 =?iso-8859-1?Q?6ADoDAWW0ZxfawKWoC8ZtCAnmyC2Inz8vUH0Ou8spK7XdhfVMcJyVbmlg4?=
 =?iso-8859-1?Q?uRVrzVh69xF8+NZfwVHg5m/g8w9qPXVPznl+8bcw3IIod1KFTezO2y9YwY?=
 =?iso-8859-1?Q?qZdP+2bA80TQk7giMTKIRVcTZ9P92ojAncNKAq6RDCHupGey6Mj4quByQY?=
 =?iso-8859-1?Q?XC0eWUtkYq/VF0VaG5q1WUgMEN/R/s+OSmWFedMpMHVqfXJDKG3pF3pvAe?=
 =?iso-8859-1?Q?NEmNr/M0UmhGRsgU+vmOlZ/J5iJTuWhBuMDOqoJfoSRlvaGlTb3ZpBIJnK?=
 =?iso-8859-1?Q?CTcLKN0q2tj1qCjy7iHU0U0ZbBapSVZpcSZ0id/FNpuADOZlQL3ncnO+0O?=
 =?iso-8859-1?Q?bdrfIMqB4F+9RKPEA8cVlS7yanmK8Re1rykhJQsfpYML13+YQiH4YWmznZ?=
 =?iso-8859-1?Q?LYbBHBl6bPFDhcV7hOQF4ySoB16V8kr23x0zRDYWVqPWB1v6S1Y8PVgbvU?=
 =?iso-8859-1?Q?rK7cweoUNjafeM+Js3HnZ8ytWUuxb1N7O5WQUXNi0KKbRhxqp53S6UZECS?=
 =?iso-8859-1?Q?mxWV5PDL+eTVmjMLDH4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bf2426-b669-4527-ab7e-08d9a317d2a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:16.1298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FIzx2GeHiVBofumv0zaJrRloatkfb6kmZyVFdJI+fQPZd6eC/OaQ6oTa0igS8AwOn6ilO9C0RnMEt0DYdZ1e4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add a new field "mode", in order to know if we are using/running
cmdprio in cmdprio_percentage or cmdprio_bssplit mode.

This makes the logic easier to reason about, and allows us to
remove the "use_cmdprio" variable from the ioengines themselves.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/cmdprio.c  | 45 +++++++++++++++++++++++++--------------------
 engines/cmdprio.h  | 10 ++++++++--
 engines/io_uring.c |  7 +++----
 engines/libaio.c   |  7 +++----
 4 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 01e0a729..cafe21d7 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -70,17 +70,12 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D cmdprio->percentage[ddir];
 	int i;
=20
-	/*
-	 * If cmdprio_percentage option was specified, then use that
-	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
-	 * on the IO size.
-	 */
-	if (p)
-		return p;
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_PERC)
+		return cmdprio->percentage[ddir];
=20
+	assert(cmdprio->mode =3D=3D CMDPRIO_MODE_BSSPLIT);
 	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
 		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
 			return cmdprio->bssplit[ddir][i].perc;
@@ -99,10 +94,20 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_data =
*td,
 				    struct cmdprio *cmdprio, struct io_u *io_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int p;
 	unsigned int cmdprio_value =3D
 		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE) {
+		/*
+		 * An I/O engine should never call this function if cmdprio
+		 * is not is use.
+		 */
+		assert(0);
+		return false;
+	}
+
+	p =3D fio_cmdprio_percentage(cmdprio, io_u);
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->ioprio =3D cmdprio_value;
 		if (!td->ioprio || cmdprio_value < td->ioprio) {
@@ -127,8 +132,7 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_data =
*td,
 	return false;
 }
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
-		     bool *has_cmdprio)
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
 {
 	struct thread_options *to =3D &td->o;
 	bool has_cmdprio_percentage =3D false;
@@ -140,16 +144,12 @@ int fio_cmdprio_init(struct thread_data *td, struct c=
mdprio *cmdprio,
 	 * is not set, default to RT priority class.
 	 */
 	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+		if (!cmdprio->class[i])
+			cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+		if (cmdprio->percentage[i])
 			has_cmdprio_percentage =3D true;
-		}
-		if (cmdprio->bssplit_nr[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+		if (cmdprio->bssplit_nr[i])
 			has_cmdprio_bssplit =3D true;
-		}
 	}
=20
 	/*
@@ -162,7 +162,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cm=
dprio *cmdprio,
 		return 1;
 	}
=20
-	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
+	if (has_cmdprio_bssplit)
+		cmdprio->mode =3D CMDPRIO_MODE_BSSPLIT;
+	else if (has_cmdprio_percentage)
+		cmdprio->mode =3D CMDPRIO_MODE_PERC;
+	else
+		cmdprio->mode =3D CMDPRIO_MODE_NONE;
=20
 	return 0;
 }
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index c05679e4..7d14b3a6 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -11,12 +11,19 @@
 /* read and writes only, no trim */
 #define CMDPRIO_RWDIR_CNT 2
=20
+enum {
+	CMDPRIO_MODE_NONE,
+	CMDPRIO_MODE_PERC,
+	CMDPRIO_MODE_BSSPLIT,
+};
+
 struct cmdprio {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
 	unsigned int level[CMDPRIO_RWDIR_CNT];
 	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
 	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
+	unsigned int mode;
 };
=20
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
@@ -25,7 +32,6 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, con=
st char *input,
 bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
 				    struct cmdprio *cmdprio, struct io_u *io_u);
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
-		     bool *has_cmdprio);
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
=20
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 46f4bc2a..f82fa1fd 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -68,8 +68,6 @@ struct ioring_data {
 	int prepped;
=20
 	struct ioring_mmap mmap[3];
-
-	bool use_cmdprio;
 };
=20
 struct ioring_options {
@@ -472,6 +470,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 {
 	struct ioring_data *ld =3D td->io_ops_data;
 	struct io_sq_ring *ring =3D &ld->sq_ring;
+	struct ioring_options *o =3D td->eo;
 	unsigned tail, next_tail;
=20
 	fio_ro_check(td, io_u);
@@ -494,7 +493,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 	if (next_tail =3D=3D atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
=20
-	if (ld->use_cmdprio)
+	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
=20
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
@@ -831,7 +830,7 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
diff --git a/engines/libaio.c b/engines/libaio.c
index f0d3df7a..b33461f4 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -51,8 +51,6 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
-
-	bool use_cmdprio;
 };
=20
 struct libaio_options {
@@ -320,6 +318,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld =3D td->io_ops_data;
+	struct libaio_options *o =3D td->eo;
=20
 	fio_ro_check(td, io_u);
=20
@@ -350,7 +349,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 		return FIO_Q_COMPLETED;
 	}
=20
-	if (ld->use_cmdprio)
+	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_libaio_cmdprio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
@@ -507,7 +506,7 @@ static int fio_libaio_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
--=20
2.33.1
