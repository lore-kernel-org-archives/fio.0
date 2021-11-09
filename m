Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59383C4332F
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4254361059
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbhKIAa7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:30:59 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241222AbhKIAa6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417693; x=1667953693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2cgtfAitq8Vc8ogOY3uIJueruBpOz9niqiYmAKdUbbo=;
  b=lEVDH/zUkhK+ZpFRuxI9QN23XmCj6bF4tTfnN1GI+ugtDVyzpE5PsR6R
   pDFi01OPf/VP2Fw56WyhqVFx6FS+7XJQvcFtR1CzaoND/ranVdcBhQZu1
   F5UOsk6i7lkevafFmvc0+OaP/utNBdA6hHxHTmoNAOoFn0CbK/cmvMpZj
   2DAOvez6hBySIorHBoWS0ApK+iqUdam9mAZJMCS9gGgPkxaLoo4gtJCUE
   Ci8gxQbG9vWu8rgPprWiLWaMXGIvpipU2Mfe3F/6BttF7ZplLwv8mn/hX
   FmM7zIsUyPlBa+MOrXGBlNQVN8w8LTlxTcnQqKKMUDFFFfmuOKCF4I2ZY
   A==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068524"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXWWkxKjDDL0Qi2o5FkPWqxkxuP94pmrJnJ1vtK3tAHxYIhloMtvtTpR7LkgHydqMVjzMpRSCtwh46T3gSxrST608qNs0gWKB3SyQfZYAIhbYswU90Kn8hsij7cKLkwmvrjkRxXBDQP5IwAjXl56vdIpZFkXBLzxmd+kE43EnFlplEUWEgP7BLDFjAnC+F+kOl8rNS1ZJOPTDay+iIsk2EDd20zNoWs4gDqBpoJ7tBKYLSlEH3xcqjhxlZTNXTGz74fCq7Sbi1QpJ4vNCq1M+xxnrKs425n3/aTP+axyiEduFZSPX1ZUQoQaJAMMBnFAPJk5qSY4bk0E2Q728XsFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJX76LmEYRgJTZRau8Eb25uJKph3ORrBPrN6a+R/xsg=;
 b=CbCO7zahaueFKHnLXzCh0Z+VvixXDJ0fEEJq4TVMBzkzyDGiAfwT95+DYBejE6S0I+f7s1RD8u1zjCSdZpb5VE54X5gKINT1Uw4HBMo1htZvFO+WRndegoi7UMKDYZazvCu14ajr/WzdFLUj26F9i10mdSaZqrOcht6eFDwpRTjCMCC4cHrB1RVgYabWRy65tU3IAZOGVk/zK8St1jazISn8gCMY94LpRpeHGh4To/iG5Cv5LTb5/qFwcrJ9f4ktoILYDpWXqWJ2QQ8f/SPI3FXRdi9ZxUpJNaCSWbITpJOYuNQXWLqAIJdXgNI5+CHOsunZhD+TKe3G7N9vPfsupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJX76LmEYRgJTZRau8Eb25uJKph3ORrBPrN6a+R/xsg=;
 b=u2Jl2hoWvWNWYwaM8gqcTc1oTTx9U9lkPWx5aabhLKVj8fmWJaVq+///Ljb9HqT+EIjw7NqFL68RDMk3krTNkNaUNeh7Byd8gpHfreXz0VFoDHrTM6BL8/hvRuTxGEqM2s1bOGJHppll9zxor0kKoWOxz7APJtz1GWI32pGtPyQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:12 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/8] cmdprio: move cmdprio function definitions to a new
 cmdprio.c file
Thread-Topic: [PATCH 2/8] cmdprio: move cmdprio function definitions to a new
 cmdprio.c file
Thread-Index: AQHX1QCtVXcb2eOCh0mDCoepTgcI4w==
Date:   Tue, 9 Nov 2021 00:28:12 +0000
Message-ID: <20211109002655.117274-3-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: fdd56cb6-3b46-49a3-3a0c-08d9a317d071
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB7144BB9964C4723E2E103F8CF2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jctVq1O8ah6OZC82UidcW+51mlFS5X9Tl2OIelo2rO3S3gDPREPM37LOJoaWciU3ujjJZwbWoNSFV16jKlInt3R0R0XetaM+lhEFlhfqJqEY5+e+dHYP3R3WdWAau6d+EAzvdNOZSSqDe9qbgFBO4lMrYkNjzsqgKINiyvC+Mm8s9yBZeavN6wnj797snax8nX5womiJStCMTpo+76Z1P8oXr9/kxrRfaCjfKh9qeK/+NCmO7Fuq+/b2hVQfvxycFk2Y54mvOH79Kv5rj7p98SKQmG7qNNJIhtoV2F9oIYvL4wlLJEc9Ypgbq9PlbXvZgiGNz+xeRpsrXl27vEkch5K+2cTNd9B2ZErmiRee8fTZYyFQ4z14UMvTOgkKB1nR76RLh+VG0rCmmxmAa22OwZf4dSpoYRRL6/nKQiutXJ/nO2Q6ufVl3IlvQV6dNKcCji3nQ5UaECHsrMPCJdElWqAL+6HL/pgy/6QVvbPWlnkS1hsbViTsSceYHqHbTRjHGlKbXjW2WkUGNfsWDuw7Ze258ibq659AStaXl3cFMWfISj6u+eUctusvAmRleaFhm3wEQjomFQ9IqHBKY+a7IF73qmoGqc30fUnqzzEqfhp4/j3sY5cxEccYeeUcGlmiJU2KCKwGnH79QkXlAhNnNcocrl9OhLeFDSsCZvk/c4cHMUUw5UX5rDSRDRXT1pdimJ6ByDci/sMn30tPD1SvZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sXX4btuJVpG5uw+9ozY9VF79na/uFYMqQCK8WTLUbOkF9ZJcSCOQ3kEECm?=
 =?iso-8859-1?Q?l87+9uylnz6nS8A9y1EnwJd6HyqTnjRXcaXrjjziGNoEM/AMvl3ehonVGl?=
 =?iso-8859-1?Q?VbdH97heeCr/Qz4HfWeWkUBMgM0hHLMxbwzoDDyamwIITIowBEc3ujr6fG?=
 =?iso-8859-1?Q?zW+amgyKqA/PYueffy/w70BKAhLYtuGDzy13A1IYCYd3PyVIDbjsq2oghl?=
 =?iso-8859-1?Q?QPsHObip7hzy6/dxRKqwF7rnG0jDCj/qPya6hWfqvccq+UvUquEafdtkja?=
 =?iso-8859-1?Q?W+ERvHr7qfRh8HYAHkn64nbOYiUtPgO7QABdp8GdAOYw1lB+iGkLvt+ibR?=
 =?iso-8859-1?Q?TEuba42kXHMAsfsWvFfJdmndIfHzwJSMpAgkAnMo1VtWSvG7sFJUSt2XOr?=
 =?iso-8859-1?Q?93sJiyvhsybvK/PH92oYuYfe+d4xI7XRTvKChMJWUKx3iXsCZIcRqMznyV?=
 =?iso-8859-1?Q?8dWv/8nhSLa6MZXXf70nj9Db+hlCxyzAhVyKGGdUtATDV3oO/J0Yq9tf5f?=
 =?iso-8859-1?Q?hXzrh9J4knHv9mYj3LTW9IDyYkaZqWgnrXn5zSQg0EmZfkI+fd1UUzYULr?=
 =?iso-8859-1?Q?NJP1jSIARrF9NUeYefLr8KDuLfDSQGPRk19ctXfpwmvs43ZmmrNCBT3kPI?=
 =?iso-8859-1?Q?xtbjCZ+M+CnB5Lm4AnNfnN5h47/kwG39MTLeGPBdi1ObihriHgbxjg/Y9w?=
 =?iso-8859-1?Q?mvJ8D5oYsefYyF/aHKtc/t7JiYjh9eocf8CDddJwLHvS9TaAvdyKj0BJSl?=
 =?iso-8859-1?Q?6+O15aPojGnARLmYkCwXyxenB/1PnuA3HKhHGu3bBdv4kwImNDbCA5g0RD?=
 =?iso-8859-1?Q?tE3tror65O56qhYpDRhYvkp6EJ9rz5Wc1V4RmXD8ZVpZ/DdVkmFUDSC0Wy?=
 =?iso-8859-1?Q?MN8eNw1gBjQeHo8tqWVCBhtpTHOVJzRe2PvfqRCSlndFpFizyJf27geocT?=
 =?iso-8859-1?Q?7LbzJS/OIgwmSOGgrkQ+QjxHh1PDCiICSIAWebSCBMrvn5Bl2kXp0th/uh?=
 =?iso-8859-1?Q?/1uQVDA/DSvu/SH5QdSkR/nFEIHlyF6tMddejMSYTX2dXf5bEKBRxyY8ny?=
 =?iso-8859-1?Q?Z+b4SAAkjnNs2HbSMLFkeVE3c3NupHWJacggHaILBrzo/mRgPH+diBljFu?=
 =?iso-8859-1?Q?ZIj8MeZe3k5dqVpYhURDMquUT+6eVqcRe8t71+EwnurYVEG/iMCqJVtbsL?=
 =?iso-8859-1?Q?arnzjHxb1RqOfcUx3txtJVctjsUiLTQ/j2UyU5KbRL27bL3uGnbP2D9tVd?=
 =?iso-8859-1?Q?6z2S68UeyLCi7MqXGSMy8O/3zHmNKJsUgCaudYmVfm95uFucuRjRptykVa?=
 =?iso-8859-1?Q?rhDEFHCycbbYdTPkZ1VklMemT/tv5OTm94FYULVvINXZmVquwETkQ/SAO1?=
 =?iso-8859-1?Q?ctqM2U5qz+gx7db99tleugyTSICwmoCf34YKxzpgzomo9+n7kQ4n7Vv0qk?=
 =?iso-8859-1?Q?4woxajRPzki9kuJT6Il3n+8wRg+rLQZWNUeKncJjM3iSkRTob/UtkUWHT3?=
 =?iso-8859-1?Q?4DXx0rf5COiGSMykrVQGWuNgVhpGIXxe11M5gv3GvYqQj3qT/d2Le3mT2u?=
 =?iso-8859-1?Q?cgJMawZQcmzl6mwy8071TTRB4OTu5IT7lEv6snB+bWXhlDekeRjtuF9B/M?=
 =?iso-8859-1?Q?PZ6BuGiH1vRcq7fin/GnjFz2QoPeCOB1pOAY/Nl/fFcCKW3yIEmoG16o1l?=
 =?iso-8859-1?Q?82RpQKPSru5B8nLc0uc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd56cb6-3b46-49a3-3a0c-08d9a317d071
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:12.4400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g/zEGjqt8xPznvlVsiXvOUnBZfwKNUT9/8KGrh2jIWsL60G+kPztpen9ZerImVAm88gnIAJk6wrfL/2T1NLxdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Move cmdprio function definitions from the cmdprio.h header file to a new
cmdprio.c file, such that we can add new static functions to cmdprio.c.

A follow up patch will add new cmdprio functions which do not need to be
directly accessible by ioengines.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Makefile          |   6 +++
 engines/cmdprio.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++
 engines/cmdprio.h | 127 ++------------------------------------------
 3 files changed, 141 insertions(+), 122 deletions(-)
 create mode 100644 engines/cmdprio.c

diff --git a/Makefile b/Makefile
index 4ae5a371..e9028dce 100644
--- a/Makefile
+++ b/Makefile
@@ -98,6 +98,7 @@ else ifdef CONFIG_32BIT
 endif
 ifdef CONFIG_LIBAIO
   libaio_SRCS =3D engines/libaio.c
+  cmdprio_SRCS =3D engines/cmdprio.c
   libaio_LIBS =3D -laio
   ENGINES +=3D libaio
 endif
@@ -225,6 +226,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE +=3D diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
+  cmdprio_SRCS =3D engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE +=3D oslib/linux-blkzoned.c
 endif
@@ -281,6 +283,10 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   FIO_CFLAGS +=3D -DPSAPI_VERSION=3D1 -Ios/windows/posix/include -Wno-form=
at
 endif
=20
+ifdef cmdprio_SRCS
+  SOURCE +=3D $(cmdprio_SRCS)
+endif
+
 ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS :=3D $(ENGINES)
 define engine_template =3D
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
new file mode 100644
index 00000000..f5b7342f
--- /dev/null
+++ b/engines/cmdprio.c
@@ -0,0 +1,130 @@
+/*
+ * IO priority handling helper functions common to the libaio and io_uring
+ * engines.
+ */
+
+#include "cmdprio.h"
+
+static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
+				    enum fio_ddir ddir, char *str, bool data)
+{
+	struct cmdprio *cmdprio =3D cb_arg;
+	struct split split;
+	unsigned int i;
+
+	if (ddir =3D=3D DDIR_TRIM)
+		return 0;
+
+	memset(&split, 0, sizeof(split));
+
+	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
+		return 1;
+	if (!split.nr)
+		return 0;
+
+	cmdprio->bssplit_nr[ddir] =3D split.nr;
+	cmdprio->bssplit[ddir] =3D malloc(split.nr * sizeof(struct bssplit));
+	if (!cmdprio->bssplit[ddir])
+		return 1;
+
+	for (i =3D 0; i < split.nr; i++) {
+		cmdprio->bssplit[ddir][i].bs =3D split.val1[i];
+		if (split.val2[i] =3D=3D -1U) {
+			cmdprio->bssplit[ddir][i].perc =3D 0;
+		} else {
+			if (split.val2[i] > 100)
+				cmdprio->bssplit[ddir][i].perc =3D 100;
+			else
+				cmdprio->bssplit[ddir][i].perc =3D split.val2[i];
+		}
+	}
+
+	return 0;
+}
+
+int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+			      struct cmdprio *cmdprio)
+{
+	char *str, *p;
+	int i, ret =3D 0;
+
+	p =3D str =3D strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
+
+	if (parse_dryrun()) {
+		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+			free(cmdprio->bssplit[i]);
+			cmdprio->bssplit[i] =3D NULL;
+			cmdprio->bssplit_nr[i] =3D 0;
+		}
+	}
+
+	free(p);
+	return ret;
+}
+
+int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
+{
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D cmdprio->percentage[ddir];
+	int i;
+
+	/*
+	 * If cmdprio_percentage option was specified, then use that
+	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
+	 * on the IO size.
+	 */
+	if (p)
+		return p;
+
+	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
+		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
+			return cmdprio->bssplit[ddir][i].perc;
+	}
+
+	return 0;
+}
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     bool *has_cmdprio)
+{
+	struct thread_options *to =3D &td->o;
+	bool has_cmdprio_percentage =3D false;
+	bool has_cmdprio_bssplit =3D false;
+	int i;
+
+	/*
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
+	 */
+	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		if (cmdprio->percentage[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+			has_cmdprio_percentage =3D true;
+		}
+		if (cmdprio->bssplit_nr[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+			has_cmdprio_bssplit =3D true;
+		}
+	}
+
+	/*
+	 * Check for option conflicts
+	 */
+	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
+		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
+			"are mutually exclusive\n",
+			to->name);
+		return 1;
+	}
+
+	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
+
+	return 0;
+}
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 0edc4365..33a8f5b9 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -16,129 +16,12 @@ struct cmdprio {
 	struct bssplit *bssplit[DDIR_RWDIR_CNT];
 };
=20
-static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
-				    enum fio_ddir ddir, char *str, bool data)
-{
-	struct cmdprio *cmdprio =3D cb_arg;
-	struct split split;
-	unsigned int i;
+int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+			      struct cmdprio *cmdprio);
=20
-	if (ddir =3D=3D DDIR_TRIM)
-		return 0;
+int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
=20
-	memset(&split, 0, sizeof(split));
-
-	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
-		return 1;
-	if (!split.nr)
-		return 0;
-
-	cmdprio->bssplit_nr[ddir] =3D split.nr;
-	cmdprio->bssplit[ddir] =3D malloc(split.nr * sizeof(struct bssplit));
-	if (!cmdprio->bssplit[ddir])
-		return 1;
-
-	for (i =3D 0; i < split.nr; i++) {
-		cmdprio->bssplit[ddir][i].bs =3D split.val1[i];
-		if (split.val2[i] =3D=3D -1U) {
-			cmdprio->bssplit[ddir][i].perc =3D 0;
-		} else {
-			if (split.val2[i] > 100)
-				cmdprio->bssplit[ddir][i].perc =3D 100;
-			else
-				cmdprio->bssplit[ddir][i].perc =3D split.val2[i];
-		}
-	}
-
-	return 0;
-}
-
-static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *i=
nput,
-				     struct cmdprio *cmdprio)
-{
-	char *str, *p;
-	int i, ret =3D 0;
-
-	p =3D str =3D strdup(input);
-
-	strip_blank_front(&str);
-	strip_blank_end(str);
-
-	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
-
-	if (parse_dryrun()) {
-		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-			free(cmdprio->bssplit[i]);
-			cmdprio->bssplit[i] =3D NULL;
-			cmdprio->bssplit_nr[i] =3D 0;
-		}
-	}
-
-	free(p);
-	return ret;
-}
-
-static inline int fio_cmdprio_percentage(struct cmdprio *cmdprio,
-					 struct io_u *io_u)
-{
-	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D cmdprio->percentage[ddir];
-	int i;
-
-	/*
-	 * If cmdprio_percentage option was specified, then use that
-	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
-	 * on the IO size.
-	 */
-	if (p)
-		return p;
-
-	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
-		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
-			return cmdprio->bssplit[ddir][i].perc;
-	}
-
-	return 0;
-}
-
-static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdpri=
o,
-			    bool *has_cmdprio)
-{
-	struct thread_options *to =3D &td->o;
-	bool has_cmdprio_percentage =3D false;
-	bool has_cmdprio_bssplit =3D false;
-	int i;
-
-	/*
-	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
-	 * is not set, default to RT priority class.
-	 */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_percentage =3D true;
-		}
-		if (cmdprio->bssplit_nr[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_bssplit =3D true;
-		}
-	}
-
-	/*
-	 * Check for option conflicts
-	 */
-	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
-		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
-			"are mutually exclusive\n",
-			to->name);
-		return 1;
-	}
-
-	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
-
-	return 0;
-}
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     bool *has_cmdprio);
=20
 #endif
--=20
2.33.1
