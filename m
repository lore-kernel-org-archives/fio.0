Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB930C4332F
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5F6C611CA
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhKIXlS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43923 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKIXlR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501110; x=1668037110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2Gfl6nO9Q2rJGKHUmMKi9cdGp7zetOv5vgojmCef6lc=;
  b=mYuIGblkpOUpiuufhKid/8E8pHJV9ZRsdjdfMdCZ4xZEd2PT2Hv+yYzU
   ypmVF3teiM7b4qPTVGWknVwsU1CCpb8x0QJJQfKzmYfD4MrTVpzvkUFlL
   L3uJCxAhGCoPFPlthaEp1rWqb4a2YIfaFyrudUvJbeuaYk1KUYgmlqvtP
   dk8Wb6w7CoswmGTaJUhaQfEz6w9qBd81orncmufcxSiK6O3mUHNzVMmnA
   oAfKu7V07Lnp6UdRAzf5ijNZbC2u77B7x4uuHZSbrtmH3Lg7A1wumkH7y
   DhXZA+QwPCyrNSosu6V2NNBXTqNXU16H8x+iOz1ZV+e4derLY3KIZDgJb
   A==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="185172213"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Joiyj0wcYvI9XlJfkSkew8pMi6jogvl5aMXQIS4M+L1xT0M5NIRkEeKb4APkuJo4R2MFbb1prtg+B7qBiKQJWDjRX1ZAo+W1WGVutg1/qGge7DQajgLrDQtICs4VosCbbVgnjGDhQJVcZw561LpOeZ+yR2Xt2pBlnldyI1fJafWXvjREXlms9DP+SoCcDZe3oU1QTcwfUda9Y2EIoVAhIEl5ZksVCh77fhzu4Ak199wSUIIdGxqTgXGnrhO0ISJQXGa7jQWv1hnOmqZPpIHqovVKIDsjZiI6XcpmP9Z16suMryW9nRErYCUiMM+wv7Tu8ZQ+jFHruvFDjdkj96BZKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PyUR7mpZYTUPFfJv1NVhi65fuFzYcjo4RuR9DHZqPo=;
 b=XyxM43pubtLV/cB1rOmpQaMTxVCFtFo0rDDBXpPmyO7zO1LrjIRiTiQm5v+gYnyrWJsN7QSxd6Ctz8vllQXXKphTuCAQzT/1vw3+qCk1Khk7u0hzarPwWuc4uQqynn2lIcHHq3z5xfXlj6y/QPhTTDJOzcvGWLdeyZw4gGbAa+B01FIHm1iI7tGd3Ptzdo1v8ytQCBNsXrmXUmFENFnCC6GHzTpiCIOJLi1GkGBIhQAYEINxCjwVT0KVaCBy1CSIemDcGo8WpJYA62SPDsYy1UGTO90AOgWIVZYYUsgVsRM/vlI64shUSTiySCPif0eXD1iv2WUKFz1wJoTgEvaetw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PyUR7mpZYTUPFfJv1NVhi65fuFzYcjo4RuR9DHZqPo=;
 b=KphsnqlN7LQAAfjr9srMcv1wP7jysCLPB5zN+Ofqqwp9RjdznnsIdxP/JCALfmuvzbEeuO022dIb6e22PhftjkPAxxNucAGAIwkmz7RsCvy0NS3k+mYBfMGelb+qb5Smhuf1ydQtG2Mbzf3zqHcQd4XkHX913TEcq4KJ4sa5ooU=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7736.namprd04.prod.outlook.com (2603:10b6:510:53::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 23:38:28 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 2/8] cmdprio: move cmdprio function definitions to a new
 cmdprio.c file
Thread-Topic: [PATCH v2 2/8] cmdprio: move cmdprio function definitions to a
 new cmdprio.c file
Thread-Index: AQHX1cLlYVgVleez2EujOPjenbwfcg==
Date:   Tue, 9 Nov 2021 23:38:28 +0000
Message-ID: <20211109233804.164786-3-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 03bcc3a3-bb36-4091-d5ea-08d9a3da0860
x-ms-traffictypediagnostic: PH0PR04MB7736:
x-microsoft-antispam-prvs: <PH0PR04MB77364E2E6ADBC50D1D782D59F2929@PH0PR04MB7736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6scOFxM4QHUAnJniilpTXW51tnyqPaKrTjVGBzW0KT/lHRi9nqJyQDxQonvsgCw4m24nBBHuzh8QI6s4ueflzMINIiKLrJ2yyWTWtNoyjD9ZMv/9geWhMBdpiVmMQnkzR6+SQDH55CUw97KC6So8zQ27hhtulrLoLgpvZcxL3//bxt8bhUTbwsOtyFbClUMyzG8TouKbj7+5TwH7nKPiLe/eNbwUQXRNyK6vmjJBrDlT7atJpbM6PT6ac7GUvXz5bd5ctvsHzjuBuqXcI0GtFg0iL2o9XE3ydHVtKg+KPIuEgr3qp+U9lqFn2bYknMTiAYQyGM0KCyRvP+EIlfsCUYjcop1ExYD1IwqvSH0vb0PTcX6b/gAUYAmwf3KrhWMwZKQMVUEeclYiQY8cDr6Hc5uX9uTvzkBvt9ITxbElrs0z7SHR1016TAlSHrmJBudxWAnIMnV42Fm7hCYBwknZRyzdecKpLZHi+nBgpFD8y7H+xI5rfppV7e8PVzYgc3pS3TTQy9pE/Sl2A2aneki9Bg6GUHN32aPojTbOvSSfN/qAaIZVFn/VtXECQCFbHBc8LSLFP3VkMXQOegHhNnCpngT9biS2O+Q/bzyq5KepWJtdMVfXuyZmi/LfhFVFdHaW/27L2HDv3W81iKvsnAZ9ZfqXgtZyCb9yP5AIW+usEUTQa38OnjDQmkRfB0zEDneu9SIo69IVxD1BLT60Aq26Hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(508600001)(8936002)(1076003)(6916009)(316002)(83380400001)(4326008)(36756003)(8676002)(6486002)(6512007)(66556008)(5660300002)(82960400001)(38100700002)(38070700005)(122000001)(66946007)(6506007)(66446008)(71200400001)(66476007)(2906002)(91956017)(76116006)(64756008)(26005)(186003)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?68fuFR37G2EkduY2Swdi5bcCPQcwgdxaKJTQW5UTZC9BgOfaHJAq/Xib8L?=
 =?iso-8859-1?Q?RySmLFsdHcPjxBJxBZoeR/Rvtrncha0nL4b+/RRh2hVGGIS/WHHN1pxDMA?=
 =?iso-8859-1?Q?2ILeQRQLDoYWG2EdCDECujjtBrCy81cEn9Vx+2CEooxcWDhHWnqxB8ne/X?=
 =?iso-8859-1?Q?+4wypuM75qmyGgDbXfJ/JhM2zEpuPxl6Xfh+MWCf4pgwJwNClcbfsvkg8W?=
 =?iso-8859-1?Q?OxWBtm9vtc53vKlvCZwJ8+Wd0nHl92mFUubIwp+rEVGph3RUPyZ7bso04v?=
 =?iso-8859-1?Q?poi4o4nWildgxHxL7j2E2G5d4Dq6cUEM8ZdBxTr/N/TJKiybZQ6vfu3tcM?=
 =?iso-8859-1?Q?tcSdczzzpSnZT2RN2q7woTyLW4t7HBKds2D+xqlocrzCiXkZMHEXf8QiQH?=
 =?iso-8859-1?Q?OFJVzkmFQEESx3iXQUMV1HXNkqnS3EUkl7LXeyD31xjk+QVDglNrgXU/zg?=
 =?iso-8859-1?Q?g/vcpjh32qXA4hlcxVqicrFF24Y9tP2lN6G8yvZBf9tSiHaTFg/X+ka1KE?=
 =?iso-8859-1?Q?gTOSU/c0ieQ8F+dd9PdOQYVj6j73PDX5eyCSz9Us8ACstZt9LTp+Qc2pmw?=
 =?iso-8859-1?Q?dGwm5Uwb3swYOiL96l9VgnVtth//vy4DijdQzckXFeO/XM0p20BUevARFY?=
 =?iso-8859-1?Q?fjGMzxJpsB98iE9FKYznbT4HYfkN0nFvJfvLM7cWLsg3tbTOzaKD6I30lf?=
 =?iso-8859-1?Q?zImZGU484PU1dAL2KX9SaPfBKoCXddUV5W5Y0vB9va0mpZ3/ESKWCOGzMB?=
 =?iso-8859-1?Q?bvXtegjb60u8BL0he/VNvJnIz6kmdtmFB5bQzp8JbxAdVW6KQjKinAq5AU?=
 =?iso-8859-1?Q?USTOr2uTDlXrpm6gnNT32b99gzV7XRrNooKpz6VWA2MVKaYL7tsAn0CFzN?=
 =?iso-8859-1?Q?HxnzQ0MVK1MFUeONnMkPN2KSNxlmYfPyblp1xXQSC57Hkk1pK3ArtRBwTJ?=
 =?iso-8859-1?Q?xRdEjgKcwyQkivlO6xF/DHXPa9rYsQ5OtrOECZ0vwSBb8/RVx88GxsUxra?=
 =?iso-8859-1?Q?ulQJfnNPF7wUUJpi/qVG/9PeH+KAhx23FbpS2PRrrcWFB2F7VdFlL+y7ng?=
 =?iso-8859-1?Q?NYsBPhYBc480yEcd41T4+5wxKXFJq4qnTmrorLBYZyK1m6dtIDiPlQI3K2?=
 =?iso-8859-1?Q?rVy6zooO7KIt3zA9cRwGSBkvdpmLJ5GFIVgu1uBdzwN5DNBynf+GLMQqkV?=
 =?iso-8859-1?Q?a+iPuqeAnYJSHpYJskMJqScTm6UbUkmGMAPlFKZwxSdCiF76XAqa9VJnDp?=
 =?iso-8859-1?Q?lJYtt5yrYR42WWkqfQGajO/dYFsBVWtQsRoQFmg4pWibQZF1QNXujluyDA?=
 =?iso-8859-1?Q?X7cRcI6xldWrAN0WkfllFPHHtYqIbg8vx5PelJztqsG0atqCuW7Nwt4Jnn?=
 =?iso-8859-1?Q?w+rVamRngFTPtb9g1iiW6YCaSQJJrUdOItZX7xVdH1eLj3XXdRt6O9snon?=
 =?iso-8859-1?Q?QC9b4Z/v2SEb73BzF1yZR/hIhIQ2ShZ6Gxw0k9laABCZl/5PbKkrnpmCr3?=
 =?iso-8859-1?Q?LGy0wAXv2l8EuHQc6XlsS7poky2m4qBXuZwdpWN7Bjh4W8PntiRST3fMal?=
 =?iso-8859-1?Q?HS7RN5xQwWEdB5jjqwFp7cGq3aS+2gwCD1evJWz9Qasns3ULpJIxPf+9TP?=
 =?iso-8859-1?Q?weI574d8j+Kg5XKM/N2n7lH6n5mtjJiHu4Q/1DPEjAXCmRwwRMrM8GszFa?=
 =?iso-8859-1?Q?YAUaUTWOQvvZlO9NUBI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bcc3a3-bb36-4091-d5ea-08d9a3da0860
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:28.6784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yZdDP7guLBZKGjJaYOYtUWTtg1jlMrAiqH0bgg/evRTs9D5hJnWDJKMVE6tOIbz4EdceVwcKljin6ydPM0Nmiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7736
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Move cmdprio function definitions from the cmdprio.h header file to a new
cmdprio.c file, such that we can add new static functions to cmdprio.c.

A follow up patch will add new cmdprio functions which do not need to be
directly accessible by ioengines.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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
