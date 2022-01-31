Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B09C433F5
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351155AbiAaVNU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:20 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15178 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351154AbiAaVNJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663589; x=1675199589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/iSq98tXltOPhl/aeYE4U+gwD70V2FX/+Y2P+HbpAos=;
  b=KTNHilreRFNqVCZwjA8yyEPru7qYP7bf2Up4TjesHaUwAxiLotRYUQZW
   aFSKBr1fNRRt1WdadTOk1+M86aqXHYtAlLw/56WGTRbOZzWBuz50/TFTT
   wbaOFaUVBKppJ/783q6ZHG/1mEb4n0MrUENFCW6UTDZGjXYw6+IOfA1/h
   zgcjc77yzNL/Nwgk1A4S0mI1WdnUNEjXQYQgy1hbdJuZhyeuwY7ZxWJPh
   AfAr7m/cFcyvb480MFHXJw9bwuchK+JLLVA+DrSp9AKz10npyMIUmor8e
   7aFky+C+3PY4G6Y2HzTCZT6EtWGYRlnvPqJwEvnqIDlSnKZwoqRNB+sGI
   w==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720261"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+tMcP+HHtVkEhqU6oQVqt12ikjajLeg7q90NmrziiH3BjIql4YgChLGhL52b6q2Qjlza+NrSnX9qva31fzD7wgtsAp9T8jwKdtkqTSPFgcLd/2DZ1Ja839g3NuJfZ5UkPc4/FOOmIzYfo0asojJdl3wQC9wkuFeu8GVCyYiUAYnFbSdZtB1cSpr+lo7C/ZRNhKMQ9hkpSCrHvf5l+MKQ7VCA+uKrGiVJfJu4/lDHwYaOLNq3WXXxdJKNn2scSEdE+0KKh1E/7nmgc2bu0O/bWkZclXDYHnl+QVQZx5AfaSYBvYYHbSoShcXHcKBGRMDqSJATAby8oKpDMMwV6PCRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ghEheX/dKfbGeooTyO0WVSghguURfk9DvLFjKgN0OI=;
 b=RH/pfGSEsrL+F0neL+dPmHPoB63tO4e4JbD7TbTV1r8HKDtnfSDFXgEXlzV/kXNTrQ8hsFWtofuh40IZ46ZAU1Xp4Ai44Cn2oTxbh9ouzU05st3NS5MX+eEvaovThkcCigf/lMZC1kDAa0O0XOq7EjHGJMYnJQL07nKtf5L8oJ40R1OQ32tTjimAGE/PL6VA+UjoPwOam9aWq7/ETsfqQnM26FDmKnK2wAq24cKepKepR2AiZQpWMfoLH98N+axtM5xbUVpn+3USIaEJblQnE6yD+S+W7WRrrzJ6kap7JNwZix7It3OnHeVLm8doA87WY3F2SvkSEg1orcOdaQcfRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ghEheX/dKfbGeooTyO0WVSghguURfk9DvLFjKgN0OI=;
 b=ySkC3zyNKQpkBG/4Rmxbx9G2kdFJjpBH96TUdqaCRVrliK1964oJ3aDkoM8aQzXTmoDJIjzVkSymQlIIrqnNvlehCa+CeWOnjgVYL+YFctKx6EswxhPRjsWjlhCgYfv2skLyrhsTpGcU32poeDsVc+lajYTojepJ0Nfm8e+8fAw=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:08 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:08 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 12/17] stat: disable per prio stats where not needed
Thread-Topic: [PATCH 12/17] stat: disable per prio stats where not needed
Thread-Index: AQHYFudYrzFjpdE4ZEiFTaSjyHMqxg==
Date:   Mon, 31 Jan 2022 21:13:07 +0000
Message-ID: <20220131211249.106820-13-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 73012fa7-2298-43fb-b0e7-08d9e4fe7ab3
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576F4B28BD3EDBC6973DFA9F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: di9N30vUfbHTrTFMC3ugc4NdiRlt5e87lOIChXFJ0ZI37rfzR2z9lSgZBuxt5Aqb1E1ch4S4xHZlDBpcg8iANc66w/xytlXZFf08AjsmPdjblJbz5jhUxc2uJ/9ALhnX1arJ+gVTQauS/TvYl9OnoR3i/pHcFMM2Y9u3/P3xbReKRDOUZzSUvl1AjKnUsKBELtfPz5KF0SVo2y9etoIcorAiyeCuo6ypHXw8FpdU0zwuM5LxDMsVX/5Ct3flA1jf4K+5mSMzWEynholpvSf0DCM1LaJP1MQstzAn7Q6G6a8JnN7ueOU4uM1SxlVTOV/he2Q/kecf0ATG6tQT2UULCCUQCy4De9uq7n7Ks+49xQP6eJ86W/Ls7zCL0gHXEQcoXf/tHo4kTXWq+ZyqSOJ0U0fEvDAUDCugAnGkLuvb02FW88MEYjryKqmHkMwaGJ9NLFM13YzcVZ7WK+IUY0WcvBIHWCGLvGE1MizYx3geAELyAmXuVc+0UXPHDye4kU38eJIIrOCOUbdQYAYb4oySUioad6hq//Y1QCENd+87ylp7xUHqdEOfA5IDdhMeN9bQ12ukASoopKZh1K5gjeTPUeas9jEBO9C0GIbGffbWNWXplqqjsKJk6HHqNRt2OkPvDbVnVbub4xdy+F15ePO9Q0TX9BxHOpj+G6x6vLP2d2Zac8F53FpWncOKQpSiEkuUiLNc2OuZAkN6orYdXyF+iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?yEpr33g5wtR+fWBSe1U2ju1j3ZBLXINjvtB9VbRU2Ja7NBpC0iGdfLZn2+?=
 =?iso-8859-1?Q?fGh//3aylQlP2nbO/GMM74qp2df1UAYkgNXVN/cWQbWMFg70RV6HsuhcNm?=
 =?iso-8859-1?Q?UTn4yiebuZ4cVLfWS+cqBijKosAGGMy6fX1b4VruI/yGRovwF+CRKRuJ8i?=
 =?iso-8859-1?Q?Mz8Jdz7PEHaK8A3BhgpmUl93mbI7mwee61fsX0Fw6e3fxDEayS/nVgHl3z?=
 =?iso-8859-1?Q?OHZy2Xr3GvembYrHj4VrTaGOaJS0NePT80LF48QNCmT8LrdgBxEIM5sK1x?=
 =?iso-8859-1?Q?aM0380ELdmz1sK8wsZddvB1Im+unqt1x5108RN4WrHQN0fcr14acB8fZLk?=
 =?iso-8859-1?Q?ozVT+T0wP4QKu9G60F75DIOPJ8yG4pp2s23YLjqjrceGEWoQVIWS9XVCeT?=
 =?iso-8859-1?Q?yMK5g7vqVYxag3n2vamiWDX7dawoZwjSQi/k1868FnF30uvPG62AKbONqm?=
 =?iso-8859-1?Q?rjrIkvWSboJ3PbQDk3gWS++3/AQEQILGAg6cCWlSc7sEC1C33rKR4UHPXH?=
 =?iso-8859-1?Q?0ysilQv2FQq8apI01/Pv5qHkHvFbMkI+VrDoq/zr7olzjIvKdSnxJWfXz7?=
 =?iso-8859-1?Q?t+WSM4ELbnSUVaCPu01xhxGgtMlcaGf6g4fbYjvmRKkfjVwkRsy7IIJS/L?=
 =?iso-8859-1?Q?J2WD1UoWlo1pkd9ff8hrshMFUAcD62dwGH2CsHsBDwPXOQ0dMZFhP9rJqW?=
 =?iso-8859-1?Q?Pwv6rwVhpGUZ1Nn1FzlmuxY2HIkXQJqkC3dkJOX5/NQDpreeSM5xYN7koj?=
 =?iso-8859-1?Q?0Rd749dKd6y+Zmk5B231Z1vdVRGK0oqrWolBMdOtdVGWWbGAcWRyc3h/Cr?=
 =?iso-8859-1?Q?l9qs7zNFlFwH508KpkTzd0kBDQ5RSxHpOHOmjoU1h3MxiMHn+mqhglPOOy?=
 =?iso-8859-1?Q?d0po5MU3cm+x6bXvefaVgvf+FZGCPFA24BWhbkrEGNihuuLMh36vWJDj3M?=
 =?iso-8859-1?Q?/VKwamGxrAnqSzdO5vM+yh2a+Z2sG69RQ5V9ig7XdLhlvb6N1tWh/4mEQe?=
 =?iso-8859-1?Q?IWVZ6VDEUS9zS601WlILaa6LIaQZ9r1HbmYA0jfYYqfnYNpN/AXy5D4K4Y?=
 =?iso-8859-1?Q?VOMqN7HgNh0Ql22b7DJHHEuCaDHaLxChsWMeyWUGB4Z3bh/s2Fz/IagiWY?=
 =?iso-8859-1?Q?iQ6RqduvgtWvaAKMe9cIXZaRDSkvi45zIaXhQtGCUMiQlGAVD8zo9efznK?=
 =?iso-8859-1?Q?bR8GrXat0cWLVJCsHo1G8Ad39p4uKtaZtQfarFRO6x4los70dtSzvuv1RI?=
 =?iso-8859-1?Q?0VDM8WgxxcpTC8SlN0MDPH7RjF4iwUVHB8sx7MUEfJuA6n6Je07ZCR1YbN?=
 =?iso-8859-1?Q?m0shBrkFo3iE2yy0xbn0evVyGKmf5Dm0KdDiJ+IugYVdgcgxxmBB+VaXa3?=
 =?iso-8859-1?Q?sQNds5O7/FgtCbWaR0Gt4P5fUAnpx/YxFIOZn7930/bml1BlY3UbOQK3g5?=
 =?iso-8859-1?Q?SR9rDaTJ8RDQrTjf1iisu0mN0j2lQCMluqShEdG6xS32Ye7S8WwlSFUJRw?=
 =?iso-8859-1?Q?l1+zGy/CXxqDGS9fja/Qd1niTdJZEhe6PpIJrc3OIDeq5VU7X5Q/XKY6hm?=
 =?iso-8859-1?Q?rRbcoG9pKCJRGHUQALNNP4zXGmL1rTsL4sNmqYb3/nFDJ6pLYziWLnu9/v?=
 =?iso-8859-1?Q?mG4DCm0qIyHMiRhPP/I94tbGxGqbKi7+daJ/TFndkUPogjDR0HdmDXob4C?=
 =?iso-8859-1?Q?jR5ipfLuOlwJJdufW9FYP+etdVtXxc125RzKoOdl?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73012fa7-2298-43fb-b0e7-08d9e4fe7ab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:07.9653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VruKOcJjqOlgiV1XUBZkyqKdX6On/VY2UOYlMCOXdsU9++pxWDSvNqcvI0+v1lNgUSmq1UuxslVlMBX9nIDNew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

In order to avoid allocating a clat_prio_stat array for threadstats that we
know will never be able to contain more than a single priority, introduce a
new member disable_prio_stat in struct thread_stat.

The naming prefix is disable, since we want the default value to be 0
(enabled). This is because in default case, we do want sum_thread_stats()
to generate a per prio stat array. Only in the case where we know that we
don't want per stats to be generated, should this member be set to 1.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 client.c      |  1 +
 rate-submit.c |  9 +++++++++
 server.c      |  1 +
 stat.c        | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 stat.h        |  1 +
 5 files changed, 66 insertions(+)

diff --git a/client.c b/client.c
index e51138ee..e5f6cfa7 100644
--- a/client.c
+++ b/client.c
@@ -954,6 +954,7 @@ static void convert_ts(struct thread_stat *dst, struct =
thread_stat *src)
 	dst->members		=3D le32_to_cpu(src->members);
 	dst->unified_rw_rep	=3D le32_to_cpu(src->unified_rw_rep);
 	dst->ioprio		=3D le32_to_cpu(src->ioprio);
+	dst->disable_prio_stat	=3D le32_to_cpu(src->disable_prio_stat);
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
diff --git a/rate-submit.c b/rate-submit.c
index 752c30a5..e3a71168 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -195,6 +195,15 @@ static void io_workqueue_exit_worker_fn(struct submit_=
worker *sw,
 	struct thread_data *td =3D sw->priv;
=20
 	(*sum_cnt)++;
+
+	/*
+	 * io_workqueue_update_acct_fn() doesn't support per prio stats, and
+	 * even if it did, offload can't be used with all async IO engines.
+	 * If group reporting is set in the parent td, the group result
+	 * generated by __show_run_stats() can still contain multiple prios
+	 * from different offloaded jobs.
+	 */
+	sw->wq->td->ts.disable_prio_stat =3D 1;
 	sum_thread_stats(&sw->wq->td->ts, &td->ts);
=20
 	fio_options_free(td);
diff --git a/server.c b/server.c
index 4ddf682b..d82c7e5b 100644
--- a/server.c
+++ b/server.c
@@ -1486,6 +1486,7 @@ void fio_server_send_ts(struct thread_stat *ts, struc=
t group_run_stats *rs)
 	p.ts.members		=3D cpu_to_le32(ts->members);
 	p.ts.unified_rw_rep	=3D cpu_to_le32(ts->unified_rw_rep);
 	p.ts.ioprio		=3D cpu_to_le32(ts->ioprio);
+	p.ts.disable_prio_stat	=3D cpu_to_le32(ts->disable_prio_stat);
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
diff --git a/stat.c b/stat.c
index 7f134d35..3345c7c4 100644
--- a/stat.c
+++ b/stat.c
@@ -2171,6 +2171,58 @@ void init_thread_stat(struct thread_stat *ts)
 	ts->groupid =3D -1;
 }
=20
+static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts=
)
+{
+	struct thread_data *td;
+	struct thread_stat *ts;
+	int i, j, last_ts, idx;
+	enum fio_ddir ddir;
+
+	j =3D 0;
+	last_ts =3D -1;
+	idx =3D 0;
+
+	/*
+	 * Loop through all tds, if a td requires per prio stats, temporarily
+	 * store a 1 in ts->disable_prio_stat, and then do an additional
+	 * loop at the end where we invert the ts->disable_prio_stat values.
+	 */
+	for_each_td(td, i) {
+		if (!td->o.stats)
+			continue;
+		if (idx &&
+		    (!td->o.group_reporting ||
+		     (td->o.group_reporting && last_ts !=3D td->groupid))) {
+			idx =3D 0;
+			j++;
+		}
+
+		last_ts =3D td->groupid;
+		ts =3D &threadstats[j];
+
+		/* idx =3D=3D 0 means first td in group, or td is not in a group. */
+		if (idx =3D=3D 0)
+			ts->ioprio =3D td->ioprio;
+		else if (td->ioprio !=3D ts->ioprio)
+			ts->disable_prio_stat =3D 1;
+
+		for (ddir =3D 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+			if (td->ts.clat_prio[ddir]) {
+				ts->disable_prio_stat =3D 1;
+				break;
+			}
+		}
+
+		idx++;
+	}
+
+	/* Loop through all dst threadstats and fixup the values. */
+	for (i =3D 0; i < nr_ts; i++) {
+		ts =3D &threadstats[i];
+		ts->disable_prio_stat =3D !ts->disable_prio_stat;
+	}
+}
+
 void __show_run_stats(void)
 {
 	struct group_run_stats *runstats, *rs;
@@ -2217,6 +2269,8 @@ void __show_run_stats(void)
 		opt_lists[i] =3D NULL;
 	}
=20
+	init_per_prio_stats(threadstats, nr_ts);
+
 	j =3D 0;
 	last_ts =3D -1;
 	idx =3D 0;
diff --git a/stat.h b/stat.h
index 1e720ad8..4b1d4cb8 100644
--- a/stat.h
+++ b/stat.h
@@ -174,6 +174,7 @@ struct thread_stat {
 	char description[FIO_JOBDESC_SIZE];
 	uint32_t members;
 	uint32_t unified_rw_rep;
+	uint32_t disable_prio_stat;
=20
 	/*
 	 * bandwidth and latency stats
--=20
2.34.1
