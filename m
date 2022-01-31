Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC60EC433F5
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351164AbiAaVNK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:10 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15174 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351050AbiAaVNI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663588; x=1675199588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XmKfo9/lQFBL1GvwFNocBnB1hnqDFeX4NNRZ3gbLNS0=;
  b=FCfmizQH8zlwXyB0eGrOIDDILtC/dQD/5fapetiRes4UTyqbuaAunuTg
   +uyrVN+Z1Qu2hx6FHXaqkiskBgpx09/BMkiwFXAWDYaFcPW9lQu5PC5h6
   O0M1JZz5RnwjHUzYL7Dkhd15d1sS4cJTXFpfBqpda52vBN+5ByjpaZv/c
   Zdk2/5EunL3lbInqj3GBQvnW9GuyQn8F/qAFow0MmQqnDh5hljZ4ZFRmt
   M0eWdwsVW3qKf0NIBDHYQs9Bgmjp3+McCE3/kwjpurVx0L0r6CH1iZQ2J
   d37OXBPzsrYqlKNxGwgtZ4rrwo/5kCGc0kM0bgZweFiBBKvRcx+BA2G2A
   w==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720256"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1e+vLx9i3PtGm4wLJlvW882elvmvehzaHOXfLigmA/4y8aTdJ94d8BbBPX+2ONNEnLdygLTf9JB2SGZJsWz4FbO/rbQHY96zMWvknU/1AGplIE6qEK7CYI6oLtAIVTgzXYsoArpON7yrJK40eYXMkoj6EPMlZpsiJLiE9kj744oT4JyDjOgt2GschRbgaipiwmDEIP9vfcvhPaRR6Xp5oiO3I7Ue7sfl6+PU9RTZ/vEfsdyIl9NcUKzfKACxDPlj3CnamKQbvFDjkwl0YVcjO7rKHNUn44LC4/zs2Bt6jXAwqdwR9QQQowL0iKvS/k+lQeqfwFOPrkeGlfxNL/Vwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kV+GM74XCJwq2NmXrmIp5wD6qrhAbt90cDDYYgdIA8A=;
 b=Br9gN8Mln+95LJLuKjXYEWbWTpUCC3lka67UBSLoO8NSPh0w/fmTrVlbhARXmCbJMqUnHxXLFa5oOXx4sEkJAIlRowuNsMMwixnKmAulEUoewYfbQMIjSjvM3OIsf3a2cYmMQLHTzKoBDqMua+NP7x/lh/ADfTaDAYtCAdMI4Zz2GELvsFkKEOiBYdxzeMEJ/l8rSVit2jKu7fTyexECugWONsB5ldwZ6lqCndsgYy68cl8Oxp4YQeKml+fpJ0W1dqzs6QXgKk/KRg/0/y3cmcLdS/s7AcubOLBh74SlEmRHyjSAV9bnVD8Hed2UWC1w5WOeEoQAJ/cH6dEbOfOiOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kV+GM74XCJwq2NmXrmIp5wD6qrhAbt90cDDYYgdIA8A=;
 b=tdc26KPDlsC7JE1vRvUAPNGL0AnoMARPcwPc3q8LPwNHv2Ja8UtXo04VWfamDpoqe0k3rybv7NJwgBSSd3A1Kg4Fu2EdgdDAHML9Y5jVISH6i1fUNYTJxqrxL41Szn2lfr5vQqjnmbNpUbrFv76LXcLRiGa44kQa/Z+dg36DkMY=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:05 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 07/17] cmdprio: add support for a new cmdprio_bssplit entry
 format
Thread-Topic: [PATCH 07/17] cmdprio: add support for a new cmdprio_bssplit
 entry format
Thread-Index: AQHYFudWeCuPrwtj5Um0hkUX0CZjwA==
Date:   Mon, 31 Jan 2022 21:13:05 +0000
Message-ID: <20220131211249.106820-8-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3463ddf3-1907-4f4a-324b-08d9e4fe78f7
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB757611CA175D1549F9011A95F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fCGgsMrRVAySnhxfna+ZgokaoZ8oYThVXTGc1EkmS7yI0PuAE4Ywnu6ZOjs9QtiWWAYaHRgb27+jm8Q8Rc+BhzT0AbHEuuVeRSx+H/UQSr9GGMfUbTM3JSeYnybml60G9NfKSIB2+Oa9KFKGX9oEUHgh/JzKUyZ2PEt/do0NMyDp2rMs0RbwWiCv4xljfh6B020P8+3u/c3xcseH3UfdgWI0GTNWkJ3u6aipn4JVBY/pjxD6B8OEM951Tu7yUZ0ulnVPogwSFwFA5dKXLp0rOeeIyujscH81OH4ZW8/pf3rWgr7JFmOomTgi52J5598J8vrQ406RbHroyWwpAqDhgnTaAPBtOPKOHN+dizUTEr6COC5QNkU/R61jlrEH7+pjYE0arEDyQaj7Q1J7Pr6jj5G5hawUoKz4wvvusOW0wYsuY9fWqA5l97fI2bdPv1N50s+YIaGIkXEy9gFyGlZtJcRyGwl0vF5WqoxwKMOmUeOrlFLMIz0BSKAkoQ6OnR5g1FOYTiK6LmUbVIWdxzb3NtcZvhIuW1E7iYoaSjhS+2HTERE0M/bkyMtvNTWW4ZGf33JQk5uuGRdWk8h2Qdkv2ZaNFCtEaiayRjXgs9kKn0PoTnPboSKGQiK9E6SnVXmyQEXvMbK2b3c9j+F5a2kSUXWsW5+Yl2MJa//q2y0vfIEgny7ZyaB0sej8b3m+8hVMV86RK2YC/NzvkUax61yfXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(30864003)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(579004)(559001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FlNP89f1ZSPfPs1nz1kgVFCK7zsApkZPNBR4yGnM0rM6kaswofAfHT59jO?=
 =?iso-8859-1?Q?TYUZWDg3xfvctSwKDvYZDd0jvXfFXQbl/upHVzajGw3+p+lGRV/86VLNZM?=
 =?iso-8859-1?Q?3to6pqLukRhaQ5Rj6G8ouIkCmWh1ZlTLSQtF6Zabwp+pEXRhMujj17zmn3?=
 =?iso-8859-1?Q?f6hif1msGHKIlctFBlTt7AtE8LC6T7lCbfB0pq9uRSwoqQg7gjj5xt76K+?=
 =?iso-8859-1?Q?q7qQHpxfkIrdDm4U1cdxrAieMh4Qv6u+ZvPBrVKMrBynPyJ8dSgoq13sNK?=
 =?iso-8859-1?Q?Q+ejB+5UJMFE0EZt9xa7IMpXAf4AhG5BLSHjeZnUan8M77GQ6clH8o2X7h?=
 =?iso-8859-1?Q?7/0H8rjQzGF+dwsctWUNWCG9eGBUIQXTqLvV3QxfZ+J73louZzedoB7dSl?=
 =?iso-8859-1?Q?6vpVDOIwZQz/OlEllxsKObyy0p867SyvdS0zuFayOGpaNsjfARYew7vQlC?=
 =?iso-8859-1?Q?RytS4A+ASQbQpVap3g/mjavfU5RgcQuOSunCygWCbwQWt3DIUo+QpGWfdz?=
 =?iso-8859-1?Q?4GutvUIDkLgKwTf2USZAj3sfg8e3Y+XQuJXlBnjiDxbK0aIP7g7a0tnW0F?=
 =?iso-8859-1?Q?JEVsyF95O+n+Q8zzHb+ONeuVDN25CmEPcOSPj+ene2WY8+WSupavDW6F53?=
 =?iso-8859-1?Q?HSqi5QKPjDHTd19zS1NnuUfyK+0YD//SXSLgDri6uiRhZyHYNY+rYmRwpd?=
 =?iso-8859-1?Q?vUvnfEwFs+TNQH7UxQvxXWGqcWlLOOXwVQ3JH6SSWcdUJTrTIBhX8saVEV?=
 =?iso-8859-1?Q?vxntrXHn9NzhubWa0JT9HeV6MX3S1qg/eS+JmD53eibjoK9djHr7yYHEFt?=
 =?iso-8859-1?Q?+U/V61ofV3+O+h0XP6kVPRZM9XxH8BlMBH1/bYrtHAsVsN+jvJi1dyaTxm?=
 =?iso-8859-1?Q?4XsZzZGKtLB+RaE1ndX5QhZFBjgiazFbZx0xOy6/YqCyNBKQOQ2ZfDA610?=
 =?iso-8859-1?Q?PghwnWkRZgCQbIly1/pY5bbeIYcjcZliSjcsxSAzan3vTMFdU3bns+W9CY?=
 =?iso-8859-1?Q?AB5kcWhXtNoH27GyfofzYRY9EypUFbVycTzJpsg988LwfNx9J83DyzguiP?=
 =?iso-8859-1?Q?xXY0nsIFjNNJQFwVNdqnKzXHfYaoJnSQgoAioXwyIL31L71jQWX3/p7pH0?=
 =?iso-8859-1?Q?KU8oH7IDszrxmhM63gSpKmSPdCa9GURlnGEFYPKZ2J+Sx/F9h/nwiG9YzJ?=
 =?iso-8859-1?Q?FKpe3aewF+Auq3LZHeFOrhaJ+LVXH1/pm3l4DtdThVqLhXUqzaVD8z7h8g?=
 =?iso-8859-1?Q?S4bbpkotlBeCqSg+hx9n/xq+7w8K9HvTbyzYCZkBnrYtzZTpuosjkg4nVd?=
 =?iso-8859-1?Q?OriQkx6S/j6tJosbfrQHSVchDE8zZ9UKpnSGjGfjzMdaL6lpWvRvS2znJz?=
 =?iso-8859-1?Q?iCtKPjQvklbfrNAnmpwQHDK9FaYbCPhg+e3fRXZnzPCFLTzqTvT1k+TmGK?=
 =?iso-8859-1?Q?xVijDpdt3KbfidY7JzODv0JWO0mgpl8Oyd1EvB/T8ouxN5Y78Ji3TD7E2z?=
 =?iso-8859-1?Q?+dyjPcbIBxNECKDI9uW3u78FUtrf8hodMFfBnwh0kyLDgmH+/zw5AUgWn/?=
 =?iso-8859-1?Q?/yHQwNPpYtt6c+TvNiSYKgZEM4cheJfcD1lbcINpLznKN6oe7Q5ol0VU9w?=
 =?iso-8859-1?Q?zyyLTFwX+P7lUF2WrghI+c2eOrFp0Hy2Dyy7O0dDVaG2KFAF0GcAbG43y9?=
 =?iso-8859-1?Q?XN0jj3yXp2BmEtuRiSquQPHWoMqNN1+UIHTCOSkT?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3463ddf3-1907-4f4a-324b-08d9e4fe78f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:05.0522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YAd70EJ7amKo3d5/xbDFMzIYmjBPqWGU34h92XPVcnmmeLew6mWOrzYz+FgUB3RW7YNK+A0SIOHUS4gxig8qnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add support for a new cmdprio_bssplit format, while keeping support for the
old format, by migrating to the split_parse_prio_ddir() parsing function.

In this new format, a priority class and priority level is defined inside
each entry itself. In comparison with the old format, the new format does
not restrict all entries to share the same priority class and priority
level.

Therefore, this new format is very useful if you need to submit I/Os with
multiple IO priority class + IO priority level combinations, e.g. when
testing or verifying an IO scheduler.

cmdprio will allocate a clat_prio_stat array that holds all unique
priorities (including the default priority). Finally, it will set the
clat_prio pointer in the struct thread_stat (td->ts.clat_prio) to the
newly allocated array.

We also add a clat_prio_stat index to io_u.h, that will inform which array
element (which priority value) this specific I/O was submitted with.
The clat_prio_stat index will be used by the stat.c code, to avoid a costly
search operation to find the correct array element to use, for each and
every add_sample().

Note that while this patch will send down the correct I/O pattern to the
drive (potentially using multiple different priorities), it will not
display the cmdprio_{bssplit,percentage} stats correctly until a later
commit in the series (which changes stat.c to report clat stats on a per
priority granularity). This was done to ease reviewing.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO             |  26 ++-
 backend.c         |   3 +
 engines/cmdprio.c | 440 ++++++++++++++++++++++++++++++++++++++--------
 engines/cmdprio.h |  22 ++-
 fio.1             |  32 +++-
 io_u.c            |   1 +
 io_u.h            |   1 +
 7 files changed, 440 insertions(+), 85 deletions(-)

diff --git a/HOWTO b/HOWTO
index c72ec8cd..cb794b0d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2212,10 +2212,28 @@ with the caveat that when used on the command line,=
 they must come after the
 	depending on the block size of the IO. This option is useful only
 	when used together with the :option:`bssplit` option, that is,
 	multiple different block sizes are used for reads and writes.
-	The format for this option is the same as the format of the
-	:option:`bssplit` option, with the exception that values for
-	trim IOs are ignored. This option is mutually exclusive with the
-	:option:`cmdprio_percentage` option.
+
+	The first accepted format for this option is the same as the format of
+	the :option:`bssplit` option:
+
+		cmdprio_bssplit=3Dblocksize/percentage:blocksize/percentage
+
+	In this case, each entry will use the priority class and priority
+	level defined by the options :option:`cmdprio_class` and
+	:option:`cmdprio` respectively.
+
+	The second accepted format for this option is:
+
+		cmdprio_bssplit=3Dblocksize/percentage/class/level:blocksize/percentage/=
class/level
+
+	In this case, the priority class and priority level is defined inside
+	each entry. In comparison with the first accepted format, the second
+	accepted format does not restrict all entries to have the same priority
+	class and priority level.
+
+	For both formats, only the read and write data directions are supported,
+	values for trim IOs are ignored. This option is mutually exclusive with
+	the :option:`cmdprio_percentage` option.
=20
 .. option:: fixedbufs : [io_uring]
=20
diff --git a/backend.c b/backend.c
index abaaeeb8..933d8414 100644
--- a/backend.c
+++ b/backend.c
@@ -2613,6 +2613,9 @@ int fio_backend(struct sk_out *sk_out)
 	}
=20
 	for_each_td(td, i) {
+		struct thread_stat *ts =3D &td->ts;
+
+		free_clat_prio_stats(ts);
 		steadystate_free(td);
 		fio_options_free(td);
 		fio_dump_options_free(td);
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 92b752ae..fd78d401 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -5,45 +5,201 @@
=20
 #include "cmdprio.h"
=20
-static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
-				    enum fio_ddir ddir, char *str, bool data)
+/*
+ * Temporary array used during parsing. Will be freed after the correspond=
ing
+ * struct bsprio_desc has been generated and saved in cmdprio->bsprio_desc=
.
+ */
+struct cmdprio_parse_result {
+	struct split_prio *entries;
+	int nr_entries;
+};
+
+/*
+ * Temporary array used during init. Will be freed after the corresponding
+ * struct clat_prio_stat array has been saved in td->ts.clat_prio and the
+ * matching clat_prio_indexes have been saved in each struct cmdprio_prio.
+ */
+struct cmdprio_values {
+	unsigned int *prios;
+	int nr_prios;
+};
+
+static int find_clat_prio_index(unsigned int *all_prios, int nr_prios,
+				int32_t prio)
 {
-	struct cmdprio *cmdprio =3D cb_arg;
-	struct split split;
-	unsigned int i;
+	int i;
=20
-	if (ddir =3D=3D DDIR_TRIM)
-		return 0;
+	for (i =3D 0; i < nr_prios; i++) {
+		if (all_prios[i] =3D=3D prio)
+			return i;
+	}
=20
-	memset(&split, 0, sizeof(split));
+	return -1;
+}
=20
-	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
+/**
+ * assign_clat_prio_index - In order to avoid stat.c the need to loop thro=
ugh
+ * all possible priorities each time add_clat_sample() / add_lat_sample() =
is
+ * called, save which index to use in each cmdprio_prio. This will later b=
e
+ * propagated to the io_u, if the specific io_u was determined to use a cm=
dprio
+ * priority value.
+ */
+static void assign_clat_prio_index(struct cmdprio_prio *prio,
+				   struct cmdprio_values *values)
+{
+	int clat_prio_index =3D find_clat_prio_index(values->prios,
+						   values->nr_prios,
+						   prio->prio);
+	if (clat_prio_index =3D=3D -1) {
+		clat_prio_index =3D values->nr_prios;
+		values->prios[clat_prio_index] =3D prio->prio;
+		values->nr_prios++;
+	}
+	prio->clat_prio_index =3D clat_prio_index;
+}
+
+/**
+ * init_cmdprio_values - Allocate a temporary array that can hold all uniq=
ue
+ * priorities (per ddir), so that we can assign_clat_prio_index() for each
+ * cmdprio_prio during setup. This temporary array is freed after setup.
+ */
+static int init_cmdprio_values(struct cmdprio_values *values,
+			       int max_unique_prios, struct thread_stat *ts)
+{
+	values->prios =3D calloc(max_unique_prios + 1,
+			       sizeof(*values->prios));
+	if (!values->prios)
 		return 1;
-	if (!split.nr)
-		return 0;
=20
-	cmdprio->bssplit_nr[ddir] =3D split.nr;
-	cmdprio->bssplit[ddir] =3D malloc(split.nr * sizeof(struct bssplit));
-	if (!cmdprio->bssplit[ddir])
+	/* td->ioprio/ts->ioprio is always stored at index 0. */
+	values->prios[0] =3D ts->ioprio;
+	values->nr_prios++;
+
+	return 0;
+}
+
+/**
+ * init_ts_clat_prio - Allocates and fills a clat_prio_stat array which ho=
lds
+ * all unique priorities (per ddir).
+ */
+static int init_ts_clat_prio(struct thread_stat *ts, enum fio_ddir ddir,
+			     struct cmdprio_values *values)
+{
+	int i;
+
+	if (alloc_clat_prio_stat_ddir(ts, ddir, values->nr_prios))
+		return 1;
+
+	for (i =3D 0; i < values->nr_prios; i++)
+		ts->clat_prio[ddir][i].ioprio =3D values->prios[i];
+
+	return 0;
+}
+
+static int fio_cmdprio_fill_bsprio(struct cmdprio_bsprio *bsprio,
+				   struct split_prio *entries,
+				   struct cmdprio_values *values,
+				   int implicit_cmdprio, int start, int end)
+{
+	struct cmdprio_prio *prio;
+	int i =3D end - start + 1;
+
+	bsprio->prios =3D calloc(i, sizeof(*bsprio->prios));
+	if (!bsprio->prios)
 		return 1;
=20
-	for (i =3D 0; i < split.nr; i++) {
-		cmdprio->bssplit[ddir][i].bs =3D split.val1[i];
-		if (split.val2[i] =3D=3D -1U) {
-			cmdprio->bssplit[ddir][i].perc =3D 0;
-		} else {
-			if (split.val2[i] > 100)
-				cmdprio->bssplit[ddir][i].perc =3D 100;
-			else
-				cmdprio->bssplit[ddir][i].perc =3D split.val2[i];
+	bsprio->bs =3D entries[start].bs;
+	bsprio->nr_prios =3D 0;
+	for (i =3D start; i <=3D end; i++) {
+		prio =3D &bsprio->prios[bsprio->nr_prios];
+		prio->perc =3D entries[i].perc;
+		if (entries[i].prio =3D=3D -1)
+			prio->prio =3D implicit_cmdprio;
+		else
+			prio->prio =3D entries[i].prio;
+		assign_clat_prio_index(prio, values);
+		bsprio->tot_perc +=3D entries[i].perc;
+		if (bsprio->tot_perc > 100) {
+			log_err("fio: cmdprio_bssplit total percentage "
+				"for bs: %"PRIu64" exceeds 100\n",
+				bsprio->bs);
+			free(bsprio->prios);
+			return 1;
 		}
+		bsprio->nr_prios++;
+	}
+
+	return 0;
+}
+
+static int
+fio_cmdprio_generate_bsprio_desc(struct cmdprio_bsprio_desc *bsprio_desc,
+				 struct cmdprio_parse_result *parse_res,
+				 struct cmdprio_values *values,
+				 int implicit_cmdprio)
+{
+	struct split_prio *entries =3D parse_res->entries;
+	int nr_entries =3D parse_res->nr_entries;
+	struct cmdprio_bsprio *bsprio;
+	int i, start, count =3D 0;
+
+	/*
+	 * The parsed result is sorted by blocksize, so count only the number
+	 * of different blocksizes, to know how many cmdprio_bsprio we need.
+	 */
+	for (i =3D 0; i < nr_entries; i++) {
+		while (i + 1 < nr_entries && entries[i].bs =3D=3D entries[i + 1].bs)
+			i++;
+		count++;
 	}
=20
+	bsprio_desc->bsprios =3D calloc(count, sizeof(*bsprio_desc->bsprios));
+	if (!bsprio_desc->bsprios)
+		return 1;
+
+	start =3D 0;
+	bsprio_desc->nr_bsprios =3D 0;
+	for (i =3D 0; i < nr_entries; i++) {
+		while (i + 1 < nr_entries && entries[i].bs =3D=3D entries[i + 1].bs)
+			i++;
+		bsprio =3D &bsprio_desc->bsprios[bsprio_desc->nr_bsprios];
+		/*
+		 * All parsed entries with the same blocksize get saved in the
+		 * same cmdprio_bsprio, to expedite the search in the hot path.
+		 */
+		if (fio_cmdprio_fill_bsprio(bsprio, entries, values,
+					    implicit_cmdprio, start, i))
+			/*
+			 * We do not free bsprio_desc->bsprios here. The calling
+			 * function should call fio_cmdprio_cleanup() on error.
+			 */
+			return 1;
+
+		start =3D i + 1;
+		bsprio_desc->nr_bsprios++;
+	}
+
+	return 0;
+}
+
+static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
+				    enum fio_ddir ddir, char *str, bool data)
+{
+	struct cmdprio_parse_result *parse_res_arr =3D cb_arg;
+	struct cmdprio_parse_result *parse_res =3D &parse_res_arr[ddir];
+
+	if (ddir =3D=3D DDIR_TRIM)
+		return 0;
+
+	if (split_parse_prio_ddir(to, &parse_res->entries,
+				  &parse_res->nr_entries, str))
+		return 1;
+
 	return 0;
 }
=20
-int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
-			      struct cmdprio *cmdprio)
+static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *i=
nput,
+				     struct cmdprio_parse_result *parse_res)
 {
 	char *str, *p;
 	int ret =3D 0;
@@ -53,26 +209,39 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, =
const char *input,
 	strip_blank_front(&str);
 	strip_blank_end(str);
=20
-	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
+	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, parse_res,
 			      false);
=20
 	free(p);
 	return ret;
 }
=20
-static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
+/**
+ * fio_cmdprio_percentage - Returns the percentage of I/Os that should
+ * use a cmdprio priority value (rather than the default context priority)=
.
+ *
+ * For CMDPRIO_MODE_BSSPLIT, if the percentage is non-zero, we will also
+ * return the matching bsprio, to avoid the same linear search elsewhere.
+ * For CMDPRIO_MODE_PERC, we will never return a bsprio.
+ */
+static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u,
+				  struct cmdprio_bsprio **bsprio)
 {
+	struct cmdprio_bsprio *bsprio_entry;
 	enum fio_ddir ddir =3D io_u->ddir;
-	struct cmdprio_options *options =3D cmdprio->options;
 	int i;
=20
 	switch (cmdprio->mode) {
 	case CMDPRIO_MODE_PERC:
-		return options->percentage[ddir];
+		*bsprio =3D NULL;
+		return cmdprio->perc_entry[ddir].perc;
 	case CMDPRIO_MODE_BSSPLIT:
-		for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
-			if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
-				return cmdprio->bssplit[ddir][i].perc;
+		for (i =3D 0; i < cmdprio->bsprio_desc[ddir].nr_bsprios; i++) {
+			bsprio_entry =3D &cmdprio->bsprio_desc[ddir].bsprios[i];
+			if (bsprio_entry->bs =3D=3D io_u->buflen) {
+				*bsprio =3D bsprio_entry;
+				return bsprio_entry->tot_perc;
+			}
 		}
 		break;
 	default:
@@ -83,6 +252,11 @@ static int fio_cmdprio_percentage(struct cmdprio *cmdpr=
io, struct io_u *io_u)
 		assert(0);
 	}
=20
+	/*
+	 * This is totally fine, the given blocksize simply does not
+	 * have any (non-zero) cmdprio_bssplit entries defined.
+	 */
+	*bsprio =3D NULL;
 	return 0;
 }
=20
@@ -100,52 +274,162 @@ static int fio_cmdprio_percentage(struct cmdprio *cm=
dprio, struct io_u *io_u)
 bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
 			    struct io_u *io_u)
 {
-	enum fio_ddir ddir =3D io_u->ddir;
-	struct cmdprio_options *options =3D cmdprio->options;
-	unsigned int p;
-	unsigned int cmdprio_value =3D
-		ioprio_value(options->class[ddir], options->level[ddir]);
-
-	p =3D fio_cmdprio_percentage(cmdprio, io_u);
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio =3D cmdprio_value;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default priority (which is either 0 or the
-			 * value set by "prio" and "prioclass" options).
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
+	struct cmdprio_bsprio *bsprio;
+	unsigned int p, rand;
+	uint32_t perc =3D 0;
+	int i;
+
+	p =3D fio_cmdprio_percentage(cmdprio, io_u, &bsprio);
+	if (!p)
+		return false;
+
+	rand =3D rand_between(&td->prio_state, 0, 99);
+	if (rand >=3D p)
+		return false;
+
+	switch (cmdprio->mode) {
+	case CMDPRIO_MODE_PERC:
+		io_u->ioprio =3D cmdprio->perc_entry[io_u->ddir].prio;
+		io_u->clat_prio_index =3D
+			cmdprio->perc_entry[io_u->ddir].clat_prio_index;
 		return true;
+	case CMDPRIO_MODE_BSSPLIT:
+		assert(bsprio);
+		for (i =3D 0; i < bsprio->nr_prios; i++) {
+			struct cmdprio_prio *prio =3D &bsprio->prios[i];
+
+			perc +=3D prio->perc;
+			if (rand < perc) {
+				io_u->ioprio =3D prio->prio;
+				io_u->clat_prio_index =3D prio->clat_prio_index;
+				return true;
+			}
+		}
+		break;
+	default:
+		assert(0);
 	}
=20
-	if (td->ioprio && td->ioprio < cmdprio_value) {
+	/* When rand < p (total perc), we should always find a cmdprio_prio. */
+	assert(0);
+	return false;
+}
+
+static int fio_cmdprio_gen_perc(struct thread_data *td, struct cmdprio *cm=
dprio)
+{
+	struct cmdprio_options *options =3D cmdprio->options;
+	struct cmdprio_prio *prio;
+	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] =3D {0};
+	struct thread_stat *ts =3D &td->ts;
+	enum fio_ddir ddir;
+	int ret;
+
+	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
 		/*
-		 * The IO will be executed with the default priority (which is
-		 * either 0 or the value set by "prio" and "prioclass options),
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
+		 * Do not allocate a clat_prio array nor set the cmdprio struct
+		 * if zero percent of the I/Os (for the ddir) should use a
+		 * cmdprio priority value, or when the ddir is not enabled.
 		 */
-		io_u->flags |=3D IO_U_F_HIGH_PRIO;
+		if (!options->percentage[ddir] ||
+		    (ddir =3D=3D DDIR_READ && !td_read(td)) ||
+		    (ddir =3D=3D DDIR_WRITE && !td_write(td)))
+			continue;
+
+		ret =3D init_cmdprio_values(&values[ddir], 1, ts);
+		if (ret)
+			goto err;
+
+		prio =3D &cmdprio->perc_entry[ddir];
+		prio->perc =3D options->percentage[ddir];
+		prio->prio =3D ioprio_value(options->class[ddir],
+					  options->level[ddir]);
+		assign_clat_prio_index(prio, &values[ddir]);
+
+		ret =3D init_ts_clat_prio(ts, ddir, &values[ddir]);
+		if (ret)
+			goto err;
+
+		free(values[ddir].prios);
+		values[ddir].prios =3D NULL;
+		values[ddir].nr_prios =3D 0;
 	}
=20
-	return false;
+	return 0;
+
+err:
+	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++)
+		free(values[ddir].prios);
+	free_clat_prio_stats(ts);
+
+	return ret;
 }
=20
 static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
 					     struct cmdprio *cmdprio)
 {
 	struct cmdprio_options *options =3D cmdprio->options;
-	int ret;
-
-	ret =3D fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
+	struct cmdprio_parse_result parse_res[CMDPRIO_RWDIR_CNT] =3D {0};
+	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] =3D {0};
+	struct thread_stat *ts =3D &td->ts;
+	int ret, implicit_cmdprio;
+	enum fio_ddir ddir;
+
+	ret =3D fio_cmdprio_bssplit_parse(td, options->bssplit_str,
+					&parse_res[0]);
 	if (ret)
 		goto err;
=20
+	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		/*
+		 * Do not allocate a clat_prio array nor set the cmdprio structs
+		 * if there are no non-zero entries (for the ddir), or when the
+		 * ddir is not enabled.
+		 */
+		if (!parse_res[ddir].nr_entries ||
+		    (ddir =3D=3D DDIR_READ && !td_read(td)) ||
+		    (ddir =3D=3D DDIR_WRITE && !td_write(td))) {
+			free(parse_res[ddir].entries);
+			parse_res[ddir].entries =3D NULL;
+			parse_res[ddir].nr_entries =3D 0;
+			continue;
+		}
+
+		ret =3D init_cmdprio_values(&values[ddir],
+					  parse_res[ddir].nr_entries, ts);
+		if (ret)
+			goto err;
+
+		implicit_cmdprio =3D ioprio_value(options->class[ddir],
+						options->level[ddir]);
+
+		ret =3D fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
+						       &parse_res[ddir],
+						       &values[ddir],
+						       implicit_cmdprio);
+		if (ret)
+			goto err;
+
+		free(parse_res[ddir].entries);
+		parse_res[ddir].entries =3D NULL;
+		parse_res[ddir].nr_entries =3D 0;
+
+		ret =3D init_ts_clat_prio(ts, ddir, &values[ddir]);
+		if (ret)
+			goto err;
+
+		free(values[ddir].prios);
+		values[ddir].prios =3D NULL;
+		values[ddir].nr_prios =3D 0;
+	}
+
 	return 0;
=20
 err:
+	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		free(parse_res[ddir].entries);
+		free(values[ddir].prios);
+	}
+	free_clat_prio_stats(ts);
 	fio_cmdprio_cleanup(cmdprio);
=20
 	return ret;
@@ -157,40 +441,46 @@ static int fio_cmdprio_parse_and_gen(struct thread_da=
ta *td,
 	struct cmdprio_options *options =3D cmdprio->options;
 	int i, ret;
=20
+	/*
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
+	 */
+	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
+		/*
+		 * A cmdprio value is only used when fio_cmdprio_percentage()
+		 * returns non-zero, so it is safe to set a class even for a
+		 * DDIR that will never use it.
+		 */
+		if (!options->class[i])
+			options->class[i] =3D IOPRIO_CLASS_RT;
+	}
+
 	switch (cmdprio->mode) {
 	case CMDPRIO_MODE_BSSPLIT:
 		ret =3D fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
 		break;
 	case CMDPRIO_MODE_PERC:
-		ret =3D 0;
+		ret =3D fio_cmdprio_gen_perc(td, cmdprio);
 		break;
 	default:
 		assert(0);
 		return 1;
 	}
=20
-	/*
-	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
-	 * is not set, default to RT priority class.
-	 */
-	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
-			if (!options->class[i])
-				options->class[i] =3D IOPRIO_CLASS_RT;
-		}
-	}
-
 	return ret;
 }
=20
 void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
 {
-	int ddir;
+	enum fio_ddir ddir;
+	int i;
=20
 	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
-		free(cmdprio->bssplit[ddir]);
-		cmdprio->bssplit[ddir] =3D NULL;
-		cmdprio->bssplit_nr[ddir] =3D 0;
+		for (i =3D 0; i < cmdprio->bsprio_desc[ddir].nr_bsprios; i++)
+			free(cmdprio->bsprio_desc[ddir].bsprios[i].prios);
+		free(cmdprio->bsprio_desc[ddir].bsprios);
+		cmdprio->bsprio_desc[ddir].bsprios =3D NULL;
+		cmdprio->bsprio_desc[ddir].nr_bsprios =3D 0;
 	}
=20
 	/*
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 0c7bd6cf..755da8d0 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -17,6 +17,24 @@ enum {
 	CMDPRIO_MODE_BSSPLIT,
 };
=20
+struct cmdprio_prio {
+	int32_t prio;
+	uint32_t perc;
+	uint16_t clat_prio_index;
+};
+
+struct cmdprio_bsprio {
+	uint64_t bs;
+	uint32_t tot_perc;
+	unsigned int nr_prios;
+	struct cmdprio_prio *prios;
+};
+
+struct cmdprio_bsprio_desc {
+	struct cmdprio_bsprio *bsprios;
+	unsigned int nr_bsprios;
+};
+
 struct cmdprio_options {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
@@ -26,8 +44,8 @@ struct cmdprio_options {
=20
 struct cmdprio {
 	struct cmdprio_options *options;
-	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
-	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
+	struct cmdprio_prio perc_entry[CMDPRIO_RWDIR_CNT];
+	struct cmdprio_bsprio_desc bsprio_desc[CMDPRIO_RWDIR_CNT];
 	unsigned int mode;
 };
=20
diff --git a/fio.1 b/fio.1
index b87d2309..3c26a48d 100644
--- a/fio.1
+++ b/fio.1
@@ -1995,10 +1995,34 @@ To get a finer control over I/O priority, this opti=
on allows specifying
 the percentage of IOs that must have a priority set depending on the block
 size of the IO. This option is useful only when used together with the opt=
ion
 \fBbssplit\fR, that is, multiple different block sizes are used for reads =
and
-writes. The format for this option is the same as the format of the
-\fBbssplit\fR option, with the exception that values for trim IOs are
-ignored. This option is mutually exclusive with the \fBcmdprio_percentage\=
fR
-option.
+writes.
+.RS
+.P
+The first accepted format for this option is the same as the format of the
+\fBbssplit\fR option:
+.RS
+.P
+cmdprio_bssplit=3Dblocksize/percentage:blocksize/percentage
+.RE
+.P
+In this case, each entry will use the priority class and priority level de=
fined
+by the options \fBcmdprio_class\fR and \fBcmdprio\fR respectively.
+.P
+The second accepted format for this option is:
+.RS
+.P
+cmdprio_bssplit=3Dblocksize/percentage/class/level:blocksize/percentage/cl=
ass/level
+.RE
+.P
+In this case, the priority class and priority level is defined inside each
+entry. In comparison with the first accepted format, the second accepted f=
ormat
+does not restrict all entries to have the same priority class and priority
+level.
+.P
+For both formats, only the read and write data directions are supported, v=
alues
+for trim IOs are ignored. This option is mutually exclusive with the
+\fBcmdprio_percentage\fR option.
+.RE
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO cal=
l, and
diff --git a/io_u.c b/io_u.c
index 3c72d63d..656b4610 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1803,6 +1803,7 @@ struct io_u *get_io_u(struct thread_data *td)
 	 * Remember the issuing context priority. The IO engine may change this.
 	 */
 	io_u->ioprio =3D td->ioprio;
+	io_u->clat_prio_index =3D 0;
 out:
 	assert(io_u->file);
 	if (!td_io_prep(td, io_u)) {
diff --git a/io_u.h b/io_u.h
index bdbac525..d88d5f2c 100644
--- a/io_u.h
+++ b/io_u.h
@@ -50,6 +50,7 @@ struct io_u {
 	 * IO priority.
 	 */
 	unsigned short ioprio;
+	unsigned short clat_prio_index;
=20
 	/*
 	 * Allocated/set buffer and length
--=20
2.34.1
