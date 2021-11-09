Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7845C433FE
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9218A61038
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhKIXl1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:27 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26626 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbhKIXlX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501118; x=1668037118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b3DWNJ/9D4emH6tsuuyRz1cgjlt0+203WTq6suOQFCQ=;
  b=eRrMKF8aYuNoc4yaWsCRlqKqCH9Ox5glV3q9H9zzp64JH6TzcnoA6+4V
   QulTbhSlRpP8+lhlP2H8WwC3ruX5JxbCjLKlT7X3auslCva/D1TgPNNcO
   JbvYdO6Jj3MKP6ud2wgTHqkqv8CO3UlRJnTkD35doR2XAN/WBCkc9c4SC
   kkg3so9ht0fYHdk6p2DV4JJXhMZ6dRbvC3eFjBdKobjpXxUlsplX4xA/z
   GPk1CyOvlO/ZMVaChEoVZM7g9gCTHKFYABVITywvI70/+jFAtd/uSWfAc
   Uyd3xwUtO29LQHRkHZ40GCSo24VymSWfP3zQXOxUM0mQxmnNMZHu2Ux9q
   w==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="186161350"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lul56TdCWxEhZCmWBGQsOhW72f4Mdic6Kg4voaCltOctujqPmOTDhjX6UBqyJmjGSuig3y6yhymfTBeDkwYk12plRzuMze6O98zz5bBH9a/OhoJ04AAkW9H0+QwHaYss2leaq+FCQc+XSidHTKUVdm9+v6kHaMfC0JmdnAqAUPVC28Yb+C+x3nbBtxdmp6wFhmW02PU47jolkfYaStEAhBOCJ4jI/A7TaQireNgp2E2G+OjLKxhC+dRpCydcIWCJ3+J8P0JmqV7+rKOq3X0WDc3xQ396Ib2OqeMlt0JhDOYx2pL/Gn7wQB1q76B9XIKCJgF6paA1ggJ9ANw/IHnwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNTJXlYlapbBXTqlTfwFel82DW1q68Y1wnzfzQvwCRY=;
 b=XDGGlm7Soh+3LogqDbmsUTM9CIcZrWI8ivLtmhG5I7K74RYEm08Hu9og7ZqWOazr4eBPKpRHnfAHObg/wbdngwjcxrcWQ/1tMPNrQ1K91ydZ8LfxOc++n8QjyCY2Et30u9x5B0obPGgzOdq0EkfDaQN8B18mrmqHMX8YQNugB7A9sH0tXlO/s6ZK1Bk+dLcLweNxjPgjNIdnVrLy0wjNHnjUuaqiHz+fPdvE2TH83O3q3KBiMQycLtJR7pzEyqTsvBN74+S3SM4I+qpLm1lu/gp8zBZQjrsw5eK4QdaSwaKYJ0KquqC7/3RcyO0aPIjsEGV08q8MRwxda0TsQxzGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNTJXlYlapbBXTqlTfwFel82DW1q68Y1wnzfzQvwCRY=;
 b=t038rSBnX0UYi1L2P1q/UXhz6s64m8ecN5dTuwQb0gKZqAZNnRupQY8+f4d2aYRjOBwqJEf/aTNTHPm73I4oLN8yymTsrnkW6Z1UO42KIiOK+DiUXkcIUuIAMHvI7ZZrrXPuK/DbFErqYSL6ocdV89liyKByfPbOFm24Rnk9Sh0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7511.namprd04.prod.outlook.com (2603:10b6:510:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 23:38:33 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:32 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 8/8] libaio,io_uring: make it possible to cleanup cmdprio
 malloced data
Thread-Topic: [PATCH v2 8/8] libaio,io_uring: make it possible to cleanup
 cmdprio malloced data
Thread-Index: AQHX1cLortpq1gwBVka2j54oyTgcNw==
Date:   Tue, 9 Nov 2021 23:38:32 +0000
Message-ID: <20211109233804.164786-9-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 7ea9ff2a-50f6-474d-66f9-08d9a3da0adb
x-ms-traffictypediagnostic: PH0PR04MB7511:
x-microsoft-antispam-prvs: <PH0PR04MB75114A26E97C337EAC18A8C2F2929@PH0PR04MB7511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNDONxuzgTPMJFL34EkzjM1Ho6FlXNt4T7oVHAJUZHpFySieetxzEfgz+HzFfvWfoCuite1iuk8e34/yqBQi+koaiuEJd4DUAvlrXC5Mjm0nSQQHTBLWCbcMvIZp7oK3oXrpOhV9ZqHXX+uenN25bPubzp/pR57fqlW3yYoaYF7A77ZtM7nMgrgDcPBpEDgzinI0hUk/K45qo1Gh7GEJD0BHzSzwuYKUEIF43aZU1SYRPNFBm5afozIxshxioLPfBUC+pYThI4QNEAtNkaXFNehGtNL5m2xNkTFhxIIflm5xFruqN8bVsgA6W/ZtEyg7stPCBWp4MW4jb4JVNVOaL9J8WbAZ0vXKzulU0M/vvrz7rlihGxyXtc0YuA/eavSqYXhc1jBgVcoCQ2VWTuWyYkTEMafRLpf42NCtwQA1O2n4gOas4OC3r1Ydev4HPitVktdfQOpVCM6NL4JIBwiH8llv5Df4NZT6oiFVpgjgKo+P//Gk71a8qflPw1rU7frPLeLLsKOF2HkmdQ4UCxBZ50vmHXL7/dl32SyUmhWSeoOAt+0unMIaeJQiDahWtd0XdrmPEX0Hko00vBn5U1S9kuqaw0A2zNCfJyHvz0e7KO4eHsX6V2ftdQvhp6SAo6Hs4XPJzh5reCgrq8ZDhJ+XMSCoUDYronu+ojCHO45Mo5IlXM188gmkSneUcloxv4M1IfeijSzuX2iritpZ5Kfp9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8936002)(122000001)(4326008)(38100700002)(36756003)(71200400001)(2616005)(66476007)(8676002)(6512007)(6916009)(5660300002)(86362001)(54906003)(316002)(82960400001)(64756008)(66556008)(91956017)(66446008)(6486002)(83380400001)(26005)(38070700005)(508600001)(66946007)(30864003)(76116006)(6506007)(186003)(2906002)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?T9ksVThwQcCI90kFQAODU6T3Irx+nHzSD/PZLtFODW5QjBcOmwtrqb/nyC?=
 =?iso-8859-1?Q?FVCjzJnzTW01W43B0jy7L9XMvbW+NTYn7KqllxJNzq9u8P/SkmL4mNaIGj?=
 =?iso-8859-1?Q?/CFJozMgAZO3Uj7QD+QFt7OThVUzMvFsWS7xZ20dSmEaWnq0IXWrR7pKpG?=
 =?iso-8859-1?Q?7KkeoFH9q/AYcBW54XpbaKkm6xFmuUDxJO5DGfhImWBl/VSstocl9aebIt?=
 =?iso-8859-1?Q?NkFiTuMuYsrMJJK6ou8/RMR0JKgmBKSOigTD74g8jnhDGgFSrDf6pr1lMK?=
 =?iso-8859-1?Q?6vvrqKebJ85067zyVeVU3nXhsmWGvP5kNW6enAgvt+XPjpr/bviiEvqA2V?=
 =?iso-8859-1?Q?NXZdX+KcFqSm8DaNuqfbUye5R6E0f4/RbWIWkF0VGZ6NmMOpNtx/tijWBU?=
 =?iso-8859-1?Q?9ERYuXTndCQx3MfsdRwgWxzR47o5ezG6wbhgyt4fAqmA/N/BqtriJh+5jc?=
 =?iso-8859-1?Q?4ysLNOHFROdZWQcrFsj9G8Qaafzs9rYQ5FMcUR1HsGtAMms95coxfmTwex?=
 =?iso-8859-1?Q?mH5Z+c7FuaMvHTSEUJ/EqsT/yXe/nQ/T+m98xX8/HFwmdZmmqpisasTw34?=
 =?iso-8859-1?Q?UgHGE+SFlcLqrzA1rf3EQuhzsRnm5DDsd1s1fbGKv+2ClpAuxv6d83Socg?=
 =?iso-8859-1?Q?rb3RmOH+qfQ6LUKjw6cvrJvK2/GJKWiSbqKYGq/8Bzr+TM/m1sJub6QL4L?=
 =?iso-8859-1?Q?O1T74rZDFmm/QTxQnbXFkjc/wnLZYHU4UoxeYfv+2HXvF8a/GTiOQnQXdc?=
 =?iso-8859-1?Q?wPMVOWPmYr+mpMwSqyeqv45O07+kp3QxMGm8kiePglxN+ao2vPQd5s4txf?=
 =?iso-8859-1?Q?EC3qlimzIdMCsHsO/vYamAmfgSMo9OfxaoHelJ3VUKYIRFCLQcGMgjVyUa?=
 =?iso-8859-1?Q?Zpg5szQ+v52X0BOvzZopPXCXouWzdRsiqNFoyRwQfoCpGMQ3JW//uPnDoi?=
 =?iso-8859-1?Q?+WKP4lCRdehEfipU3b8z+MKus1MSm0PeTTvbCzrLYeuJTNXq6ckyTYEg6c?=
 =?iso-8859-1?Q?UzkkIy9xhA2zdhIB/C8ku5Bya7DyCHSoJkvZ48HfZmx2QoaCvs8JV4CwrU?=
 =?iso-8859-1?Q?jnDx4kgsvPZ7k8fdjQBfSCl0K9C9h2YoKmsRRhwdKpsvafen6ABxpFga7+?=
 =?iso-8859-1?Q?QrofZ9mOBcL4UBgoecOR0t4ZZ7fc85qq7kmkToSkVEmwEPNWMTNBeGclft?=
 =?iso-8859-1?Q?eD66tJJfrGF1KHM0F5ab9xkTuaZgkf1uTyjry07ELl2CTDp7pmmRkYTkxV?=
 =?iso-8859-1?Q?7ETFw/BlAIArzGU/VufTH3dEVWXauQ6O8zx03VSU0ysHHeNXiPgC4Uwere?=
 =?iso-8859-1?Q?MnY3P88KyMsiHhFSnPW0Te0Iixig1gDqeJhTPPYhW0LjOIMGJh0V9nnQKg?=
 =?iso-8859-1?Q?xDs2ir+sny3hJCfPd+w8WoT6R0WembmnW4XZHWN0lcyMu3paZGBjiuccAI?=
 =?iso-8859-1?Q?SYLGFjh86NG/7xEXOSY/zyD2uzdgz0kka1zbQwuBh5Nz+YESoVryf9ieTW?=
 =?iso-8859-1?Q?4NupNl/dWDGxVbPEQgM4osflvlr6HacJt5ogQmec+CCeJCNtFElIAuDO2K?=
 =?iso-8859-1?Q?4Q1S1IgYctiN5Rym4/Dyvh9AlregOtJPzjrBptARfC/Y2X4+GtKP9XU0a2?=
 =?iso-8859-1?Q?9dMkU8VGz2hm0TXnRwg6fS75qSVazuFmyLTmbIZNOvnwBLb7AWRAEOdHnK?=
 =?iso-8859-1?Q?CnqZWTpqMeWk6e6n0lc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea9ff2a-50f6-474d-66f9-08d9a3da0adb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:32.8023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxYEWO+ZvsdPJCSYN+eGGcNXAvWtX1fTfevVJ5XVWp7tG9CPX2XDhUplNaTBbe+pWdrlkPj3oQuEsrzIXxNbFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7511
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The way that fio currently handles engine options:
options_free() will only every call free() on an option that has type
FIO_OPT_STR_STORE. This means that any option that has a pointer in
either td->o or td->eo, which is not of type FIO_OPT_STR_STORE will
leak memory. This is true even for numjobs =3D=3D 1.

When running with numjobs > 1, fio_options_mem_dupe() will memcpy
td->eo into the new td. Since off1 of the pointers in the first td
has already been set, the pointers in the new td will point to the
same data. (Regardless, options_free() will never try to free the
memory, for neither td.) Neither can we manually free the memory in
cleanup(), since the other td will still point to the same memory,
so this would lead to a double free.

These memory leaks are reported by e.g. valgrind.

The most obvious way to solve this is to put dynamically allocated
memory in {ioring,libaio}_data instead of {ioring,libaio}_options.

This solves the problem since {ioring,libaio}_data is dynamically
allocated by each td during the ioengine init callback, and is freed
when the ioengine cleanup callback for that td is called.

The downside of this is that the parsing has to be done in
fio_cmdprio_init() instead of in the option .cb callback, since the
.cb callback is called before {ioring,libaio}_data is available.

This patch keeps the static cmdprio options in
{ioring,libaio}_options, but moves the dynamically allocated memory
needed by cmdprio to {ioring,libaio}_data.

No cmdprio related memory leaks are reported after this patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/cmdprio.c  | 106 ++++++++++++++++++++++++++++++++++-----------
 engines/cmdprio.h  |  15 ++++---
 engines/io_uring.c |  41 +++++++-----------
 engines/libaio.c   |  43 ++++++++----------
 4 files changed, 124 insertions(+), 81 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 174bed7c..7ff39d93 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -46,22 +46,15 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 			      struct cmdprio *cmdprio)
 {
 	char *str, *p;
-	int i, ret =3D 0;
+	int ret =3D 0;
=20
 	p =3D str =3D strdup(input);
=20
 	strip_blank_front(&str);
 	strip_blank_end(str);
=20
-	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
-
-	if (parse_dryrun()) {
-		for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-			free(cmdprio->bssplit[i]);
-			cmdprio->bssplit[i] =3D NULL;
-			cmdprio->bssplit_nr[i] =3D 0;
-		}
-	}
+	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
+			      false);
=20
 	free(p);
 	return ret;
@@ -70,11 +63,12 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
+	struct cmdprio_options *options =3D cmdprio->options;
 	int i;
=20
 	switch (cmdprio->mode) {
 	case CMDPRIO_MODE_PERC:
-		return cmdprio->percentage[ddir];
+		return options->percentage[ddir];
 	case CMDPRIO_MODE_BSSPLIT:
 		for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
 			if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
@@ -98,9 +92,10 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, stru=
ct cmdprio *cmdprio,
 			    struct io_u *io_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
+	struct cmdprio_options *options =3D cmdprio->options;
 	unsigned int p;
 	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+		ioprio_value(options->class[ddir], options->level[ddir]);
=20
 	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE) {
 		/*
@@ -137,30 +132,85 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, s=
truct cmdprio *cmdprio,
 	return false;
 }
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
+static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
+					     struct cmdprio *cmdprio)
 {
-	struct thread_options *to =3D &td->o;
-	bool has_cmdprio_percentage =3D false;
-	bool has_cmdprio_bssplit =3D false;
+	struct cmdprio_options *options =3D cmdprio->options;
+	int ret;
+
+	ret =3D fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	fio_cmdprio_cleanup(cmdprio);
+
+	return ret;
+}
+
+static int fio_cmdprio_gen_data_structs(struct thread_data *td,
+					struct cmdprio *cmdprio)
+{
+	struct cmdprio_options *options =3D cmdprio->options;
+	int ret =3D 1;
 	int i;
=20
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_BSSPLIT)
+		ret =3D fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
+	else if (cmdprio->mode =3D=3D CMDPRIO_MODE_PERC)
+		ret =3D 0;
+
 	/*
 	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
 	 * is not set, default to RT priority class.
 	 */
 	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_percentage =3D true;
-		}
-		if (cmdprio->bssplit_nr[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_bssplit =3D true;
+		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
+			if (!options->class[i])
+				options->class[i] =3D IOPRIO_CLASS_RT;
 		}
 	}
=20
+	return ret;
+}
+
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
+{
+	int ddir;
+
+	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		free(cmdprio->bssplit[ddir]);
+		cmdprio->bssplit[ddir] =3D NULL;
+		cmdprio->bssplit_nr[ddir] =3D 0;
+	}
+
+	/*
+	 * options points to a cmdprio_options struct that is part of td->eo.
+	 * td->eo itself will be freed by free_ioengine().
+	 */
+	cmdprio->options =3D NULL;
+}
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options)
+{
+	struct thread_options *to =3D &td->o;
+	bool has_cmdprio_percentage =3D false;
+	bool has_cmdprio_bssplit =3D false;
+	int i;
+
+	cmdprio->options =3D options;
+
+	if (options->bssplit_str && strlen(options->bssplit_str))
+		has_cmdprio_bssplit =3D true;
+
+	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
+		if (options->percentage[i])
+			has_cmdprio_percentage =3D true;
+	}
+
 	/*
 	 * Check for option conflicts
 	 */
@@ -178,5 +228,9 @@ int fio_cmdprio_init(struct thread_data *td, struct cmd=
prio *cmdprio)
 	else
 		cmdprio->mode =3D CMDPRIO_MODE_NONE;
=20
-	return 0;
+	/* Nothing left to do if cmdprio is not used */
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE)
+		return 0;
+
+	return fio_cmdprio_gen_data_structs(td, cmdprio);
 }
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 7e4fcf6c..0c7bd6cf 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -17,21 +17,26 @@ enum {
 	CMDPRIO_MODE_BSSPLIT,
 };
=20
-struct cmdprio {
+struct cmdprio_options {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
 	unsigned int level[CMDPRIO_RWDIR_CNT];
+	char *bssplit_str;
+};
+
+struct cmdprio {
+	struct cmdprio_options *options;
 	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
 	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
 	unsigned int mode;
 };
=20
-int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
-			      struct cmdprio *cmdprio);
-
 bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
 			    struct io_u *io_u);
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio);
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options);
=20
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 979d07d4..b2308b94 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -68,12 +68,14 @@ struct ioring_data {
 	int prepped;
=20
 	struct ioring_mmap mmap[3];
+
+	struct cmdprio cmdprio;
 };
=20
 struct ioring_options {
 	struct thread_data *td;
 	unsigned int hipri;
-	struct cmdprio cmdprio;
+	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -104,15 +106,6 @@ static int fio_ioring_sqpoll_cb(void *data, unsigned l=
ong long *val)
 	return 0;
 }
=20
-static int str_cmdprio_bssplit_cb(void *data, const char *input)
-{
-	struct ioring_options *o =3D data;
-	struct thread_data *td =3D o->td;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
-
-	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
-}
-
 static struct fio_option options[] =3D {
 	{
 		.name	=3D "hipri",
@@ -129,9 +122,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "high priority percentage",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct ioring_options,
-				   cmdprio.percentage[DDIR_READ]),
+				   cmdprio_options.percentage[DDIR_READ]),
 		.off2	=3D offsetof(struct ioring_options,
-				   cmdprio.percentage[DDIR_WRITE]),
+				   cmdprio_options.percentage[DDIR_WRITE]),
 		.minval	=3D 0,
 		.maxval	=3D 100,
 		.help	=3D "Send high priority I/O this percentage of the time",
@@ -143,9 +136,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority class",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct ioring_options,
-				   cmdprio.class[DDIR_READ]),
+				   cmdprio_options.class[DDIR_READ]),
 		.off2	=3D offsetof(struct ioring_options,
-				   cmdprio.class[DDIR_WRITE]),
+				   cmdprio_options.class[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority class",
 		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
 		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
@@ -158,9 +151,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority level",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct ioring_options,
-				   cmdprio.level[DDIR_READ]),
+				   cmdprio_options.level[DDIR_READ]),
 		.off2	=3D offsetof(struct ioring_options,
-				   cmdprio.level[DDIR_WRITE]),
+				   cmdprio_options.level[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority level",
 		.minval	=3D IOPRIO_MIN_PRIO,
 		.maxval	=3D IOPRIO_MAX_PRIO,
@@ -171,9 +164,9 @@ static struct fio_option options[] =3D {
 	{
 		.name   =3D "cmdprio_bssplit",
 		.lname  =3D "Priority percentage block size split",
-		.type   =3D FIO_OPT_STR_ULL,
-		.cb     =3D str_cmdprio_bssplit_cb,
-		.off1   =3D offsetof(struct ioring_options, cmdprio.bssplit),
+		.type   =3D FIO_OPT_STR_STORE,
+		.off1   =3D offsetof(struct ioring_options,
+				   cmdprio_options.bssplit_str),
 		.help   =3D "Set priority percentages for different block sizes",
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_IOURING,
@@ -458,8 +451,7 @@ static inline void fio_ioring_cmdprio_prep(struct threa=
d_data *td,
 					   struct io_u *io_u)
 {
 	struct ioring_data *ld =3D td->io_ops_data;
-	struct ioring_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
+	struct cmdprio *cmdprio =3D &ld->cmdprio;
=20
 	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
 		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
@@ -470,7 +462,6 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 {
 	struct ioring_data *ld =3D td->io_ops_data;
 	struct io_sq_ring *ring =3D &ld->sq_ring;
-	struct ioring_options *o =3D td->eo;
 	unsigned tail, next_tail;
=20
 	fio_ro_check(td, io_u);
@@ -493,7 +484,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 	if (next_tail =3D=3D atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
=20
-	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
+	if (ld->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
=20
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
@@ -599,6 +590,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		if (!(td->flags & TD_F_CHILD))
 			fio_ioring_unmap(ld);
=20
+		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
 		free(ld->iovecs);
 		free(ld->fds);
@@ -805,7 +797,6 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
 	int ret;
=20
 	/* sqthread submission requires registered files */
@@ -830,7 +821,7 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio);
+	ret =3D fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
diff --git a/engines/libaio.c b/engines/libaio.c
index 53fe7428..9c278d06 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -51,24 +51,17 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
+
+	struct cmdprio cmdprio;
 };
=20
 struct libaio_options {
 	struct thread_data *td;
 	unsigned int userspace_reap;
-	struct cmdprio cmdprio;
+	struct cmdprio_options cmdprio_options;
 	unsigned int nowait;
 };
=20
-static int str_cmdprio_bssplit_cb(void *data, const char *input)
-{
-	struct libaio_options *o =3D data;
-	struct thread_data *td =3D o->td;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
-
-	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
-}
-
 static struct fio_option options[] =3D {
 	{
 		.name	=3D "userspace_reap",
@@ -85,9 +78,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "high priority percentage",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct libaio_options,
-				   cmdprio.percentage[DDIR_READ]),
+				   cmdprio_options.percentage[DDIR_READ]),
 		.off2	=3D offsetof(struct libaio_options,
-				   cmdprio.percentage[DDIR_WRITE]),
+				   cmdprio_options.percentage[DDIR_WRITE]),
 		.minval	=3D 0,
 		.maxval	=3D 100,
 		.help	=3D "Send high priority I/O this percentage of the time",
@@ -99,9 +92,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority class",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct libaio_options,
-				   cmdprio.class[DDIR_READ]),
+				   cmdprio_options.class[DDIR_READ]),
 		.off2	=3D offsetof(struct libaio_options,
-				   cmdprio.class[DDIR_WRITE]),
+				   cmdprio_options.class[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority class",
 		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
 		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
@@ -114,9 +107,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority level",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct libaio_options,
-				   cmdprio.level[DDIR_READ]),
+				   cmdprio_options.level[DDIR_READ]),
 		.off2	=3D offsetof(struct libaio_options,
-				   cmdprio.level[DDIR_WRITE]),
+				   cmdprio_options.level[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority level",
 		.minval	=3D IOPRIO_MIN_PRIO,
 		.maxval	=3D IOPRIO_MAX_PRIO,
@@ -127,9 +120,9 @@ static struct fio_option options[] =3D {
 	{
 		.name   =3D "cmdprio_bssplit",
 		.lname  =3D "Priority percentage block size split",
-		.type   =3D FIO_OPT_STR_ULL,
-		.cb     =3D str_cmdprio_bssplit_cb,
-		.off1   =3D offsetof(struct libaio_options, cmdprio.bssplit),
+		.type   =3D FIO_OPT_STR_STORE,
+		.off1   =3D offsetof(struct libaio_options,
+				   cmdprio_options.bssplit_str),
 		.help   =3D "Set priority percentages for different block sizes",
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_LIBAIO,
@@ -206,8 +199,8 @@ static int fio_libaio_prep(struct thread_data *td, stru=
ct io_u *io_u)
 static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
 					   struct io_u *io_u)
 {
-	struct libaio_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
+	struct libaio_data *ld =3D td->io_ops_data;
+	struct cmdprio *cmdprio =3D &ld->cmdprio;
=20
 	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
 		io_u->iocb.aio_reqprio =3D io_u->ioprio;
@@ -318,7 +311,6 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld =3D td->io_ops_data;
-	struct libaio_options *o =3D td->eo;
=20
 	fio_ro_check(td, io_u);
=20
@@ -349,7 +341,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 		return FIO_Q_COMPLETED;
 	}
=20
-	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
+	if (ld->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_libaio_cmdprio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
@@ -468,6 +460,8 @@ static void fio_libaio_cleanup(struct thread_data *td)
 		 */
 		if (!(td->flags & TD_F_CHILD))
 			io_destroy(ld->aio_ctx);
+
+		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
@@ -493,7 +487,6 @@ static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_data *ld;
 	struct libaio_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
 	int ret;
=20
 	ld =3D calloc(1, sizeof(*ld));
@@ -506,7 +499,7 @@ static int fio_libaio_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio);
+	ret =3D fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
--=20
2.33.1
