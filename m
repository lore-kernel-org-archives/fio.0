Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01D6C4332F
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353753AbiBCT2g (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:36 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34997 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353754AbiBCT2f (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916513; x=1675452513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5r9d1auWGOpUR4/UUioCl+z1yCbm8fLfqEPwGS7Ac5A=;
  b=UI4BQinXaeMAzpEBCs3Q45AMN0pPNaD4/uWO7MfIBb6WRQdSrqcJ7Fmn
   ZsT55ZrChAhUN5dY6/7mm4FAG0UuolOwmBbQZ5ck7ZTM/kua5CU1AQ60z
   quC9Fr2hg4v1o7Cl91pG7BrrkmaehSUYrWCSiZbuMncL8OB9W67m4iNYA
   V4vGiYPAlcNRps1EUv4tXds9BAGAdAfpDYTiDRfZ4ptQJnBCd8LcTwd5H
   JHWc5Lu5T0ULPsuDSZqozC+mDqPAeE01jWjG0otTYfHQ1m0470T3QHXtn
   fmlm6KKR9pI/KHWRrnV3KQX++1rgGzwwFwN6jryomIX6FGq+55z6rFTpM
   A==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107553"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m570dOe2bBv+w7ARiWOsNNWdGiz9rc4dzOMj0kXXM7l4/8m2oZr+vBe0cVgG4UnBIG8r4ue2glqD0d7jP5PzUsPiVF1u5wfnxBrZbvbH5uSVu+BABiiL6zWRHcuuWUjSHAnIbUTn1Hgw7bvfbISyFKg1c6eb3QIAUWzYf1ZSCX3k2LBf3CTra0Jgu5rci+2uWlqQ+Y4tBgkbJNowfli9L7RtaKgYg3Qc3LI8yI3SiExr9uxQ2wqNPVPvNvkSwvumEQzizNxZC3lDWTqmc/hbdvTIimv2KLWr3LBvs525ueeHYFlJdPnDmNQxTth3+0gHmc3xSKUikXolTX7wGOQMpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWQrrvgnl4x0RZIeR0O3EQ7xoTWSj0dnNv/iAveAAxQ=;
 b=lLVkTIhGoiIJVqhJQya0gk3V89rqkyyChi8i7BRmotGQ/n7WWOmyJucw5iJ28Sdwv0NvRxr6t2n49BU2u4ZsOFSJlduiiwnUhOlPxagduhOMFqtbcoOisXqCcILMWLTeCMqpghjXCqqA0sVTIQsDJfVYPviYhfGbgi1ywL2uKxh/uko2mDKZsV/uq+peM4QO3n0ejW7WVP7dqOMCDSiD5UgVS1okoZqMkKLBWeh+Y9zwJS83gMHQSs8Mi5Mm3dD7KKyUN5d7jssF6kPuKS4GV8Tvn7ENJD9J3vLoEzn1MVKPuyN/HkJexJ2g9MpN8JDuDpyHlE47xaHve2ijg8HrWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWQrrvgnl4x0RZIeR0O3EQ7xoTWSj0dnNv/iAveAAxQ=;
 b=jPFnz8rJax2BZxcqj+sJfIuCpq+9/LRKLaDuyTukOBhP14FHC8U/d1MwD8Aa9eqwVyh8nJiKQgNiFAjyFZbRqUlYSXa0RdFFcOUTfXvr9Rsi2UPt834o25AmTM00SqgI3cwcjuVej1OKUObnCL3tzTsnjBszzXthkUXgBMEan6E=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5423.namprd04.prod.outlook.com (2603:10b6:805:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 19:28:33 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:33 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 13/18] stat: disable per prio stats where not needed
Thread-Topic: [PATCH v2 13/18] stat: disable per prio stats where not needed
Thread-Index: AQHYGTQ5cjdkKjaYIkeH2iaaJ/ezIg==
Date:   Thu, 3 Feb 2022 19:28:30 +0000
Message-ID: <20220203192814.18552-14-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aaddb92a-f43b-4d3e-2146-08d9e74b5dc9
x-ms-traffictypediagnostic: SN6PR04MB5423:EE_
x-microsoft-antispam-prvs: <SN6PR04MB54233D8D487C2F2E655AD4ADF2289@SN6PR04MB5423.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ebd+H5XJSGDJ5dUCfSVRqNcRFBoXVsVV/geFXTlUT9l71xTo8SIVL+vdojnA1Zi1ayiXust7sVaFrqm6reTOFbLdSv8vidW3ms0bX9bA2eTtNKq0ETwZXqWo2EBHqDvpFmmzcED4bCmoqtGID261dMG5upCnt6bUMQeW6OYT1CPmk3M0OBVuPtDewwskSoEvHbt5epUYc1/wZ0HzS6Lczf0CqpQwpjQBy8NGBU5wLzRueFfnY9KLWYNI4zp9CfClc7mYkTz7jrecojQw3xAr6iA8KL60rig6ZpR37K/k/61CXeCrsfsLeL0eLHFxo+5dNlTxAfAqurz4Aosbw569MnLK8J3E3a5AeVVZm7TjmBP/VmPzu+F6k6fr/g0XsRT6xXASiy9O4B+kgxXVXtjEW+8yvOp/nM6fADRyw4aIb7rfJEjFInB5jMyANPiLvVAJpstLQIHuVorbsdcVIFXCdMs2nxjGNnyK01GZXIxZnpACer04XQLMzLLVn2211H4rZY+FNx2TL1Cs4cpM8tB9VQtNitoxbe5ykPMaS6vHJapslotCaxneVSLlh7YURRRBFNrfyQvue1HXblfJUJ+oIay2XjM51Ze/07Kps9XUBob2d5BA19xz6j37hI8s4tDXHPupiNpIrdiOgLP3LMrJ3JV6gsFE3RyqSOGz7oy+rl2lgvPoRAGIllC4eDH4UAuXVzYx0DvMN8tP537FHayCZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(86362001)(66946007)(91956017)(5660300002)(64756008)(6486002)(71200400001)(6506007)(8936002)(66446008)(6512007)(508600001)(122000001)(4326008)(66476007)(66556008)(2906002)(38100700002)(316002)(2616005)(6916009)(186003)(83380400001)(26005)(82960400001)(36756003)(1076003)(8676002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?5k23KoTpJFQdLxHun+1Y3VfEBq6uTYt0wgwu3z1euQR1jlxZYBK+P6ktSG?=
 =?iso-8859-1?Q?wtkJjs1RM6fXOGph28on/fCnhLNuGb/nHLvnt2Cn5WGsXhj1cdw1Le67kh?=
 =?iso-8859-1?Q?tj45L6W1OFx4904Xl846bNxICftNgNtvLLHZVnmIXqOEGbWo6OvceuUG73?=
 =?iso-8859-1?Q?pc8ALK4iAzLYpOLQBshFzKHSTqpCeThzJjjH4lvketIr1ypICso++IX7fA?=
 =?iso-8859-1?Q?akXadmpGxULhLmYvGMXmV/WBM4Rd3j4VMm3cSY15P8DdQMZiUlFu2QBOxu?=
 =?iso-8859-1?Q?f3Da1ejgwjGvAGuL3CsJthA1kR81MYQ5amjM3k9+SaJ+GJ8ELL8tj3abSh?=
 =?iso-8859-1?Q?dEVn1tKC1gju2kNnSArOvwzP2a30WBAMJvTfTbZfISIzx3lXwX/i4nTaDk?=
 =?iso-8859-1?Q?CPNYAVM5IyvTpWQJoMaipMszsIjZxwZqIMK5TJBX3KTPOrb17XFWs6+0z/?=
 =?iso-8859-1?Q?A4yraZ3DQUYR0d3grsuyBaxSvPDwRt8HEpsO0Iu1zYZcWGBJmlHV2aRTpf?=
 =?iso-8859-1?Q?ylyxi7D0lowgz9GNa/JtTfd7HjRnD6lcTBlzQJ0IwVGbcQLHLeHhYo87Ti?=
 =?iso-8859-1?Q?izM7MwYyKtvOGawE2IohP2j4aVFGTnSWJX3Vm5P0wtggKdsEsxf52zgC3O?=
 =?iso-8859-1?Q?kHlPHQ0s5lI+8Walwe3ETDa4S2t+GEm05JSudocbbEXOWYWIyN07q/FZCa?=
 =?iso-8859-1?Q?uOKis0BuWdSTzY2TWJ+GtI126uxjBnXSeQUsZUQCDXXUzGePj40xcME+AU?=
 =?iso-8859-1?Q?ycVfL/qQ72h3KHj8FM1uHAW/qPKGNkBh5ZtgPjgL+LnTmi5338PjdRzqOc?=
 =?iso-8859-1?Q?pL79ySEpk3clNjbi0VUHc64SIq6VnijhHW+5oHwgi4nR2GKNNSiLIiVhH6?=
 =?iso-8859-1?Q?K1GntgNDZ8JAx5q044KPMWxeRejcc0snpnaXN+XcouZ2pnBE7PqZoA53qA?=
 =?iso-8859-1?Q?3ULT7jN1oPJOTwdvnVkzpevb3lGTTsyPtQQ+TnRAlt4d3V8OHw0/lGOMU3?=
 =?iso-8859-1?Q?qMXMIxey69h+7lmFGqaLawGT2NDUGKJwbKFWK3D2syYL2MX3EOsi45Qa9q?=
 =?iso-8859-1?Q?1bOfUs5T5Ic8Cmy6doV0m/zceveSFRdFJ6qTEDW2X7l22RBchgIf0CJdwP?=
 =?iso-8859-1?Q?DOQhPIlHeuYqsk7S5Ja7DQt6gPWYkkEImZoO5oY1p7j2ytTdfMJN59Z8s4?=
 =?iso-8859-1?Q?P1BUA25Rb5U5QVCiWe6+eUkyu1iL83Vq40kSgp2/sZmja8bN+8JRA98gX9?=
 =?iso-8859-1?Q?JYgWCzQnhAYMh5ojJjVRNTIzpr2J/EQ1xy0UETswo4QFN8JvTKlQbbTFBn?=
 =?iso-8859-1?Q?gw8+SGibwL94kaUW3QOdbG5Kx8t+qqRNejbPZCY3AwHXPCzU5m0YlFDdcD?=
 =?iso-8859-1?Q?9rwR6IVsAOITn4VGCbAyOe7wTpZzIT4vuJJiLALQawdcPncl3DSM9KzIbe?=
 =?iso-8859-1?Q?Qkl03+8s/IJDCe7E7ZOALGGgDWYX02/CTcmpDGqCWK1ecP6uUYWGYYCuhS?=
 =?iso-8859-1?Q?D8Sjq2YjFGF4itx9rePmQhHhjAdTd6BH7ckLnCBITFkUwxtsCr1T0tkNlm?=
 =?iso-8859-1?Q?5DPBJ2aGNwZlcL0lAXEzLERvUfV5zmKb0t2PxuPpu9GVEJD6GxyRZldUN9?=
 =?iso-8859-1?Q?qocxnjGQEadVZyJKG6fRSng5LAEhWwcCRV3IEiR3N4J5gv2FsLjC3omRWY?=
 =?iso-8859-1?Q?6yt0xz+/XaIkg8dCMWVy/3nEiCEvKRBsVXRT/a3K?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaddb92a-f43b-4d3e-2146-08d9e74b5dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:30.4141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ftW9mbuyD6TASZgi9/dNewHIQlWFx6L75ncyhbmLZ95BumTnlrlDiAzb3ZEXxWCY5bFmirSOQgdF/1fk4cb2zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5423
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
don't want per priority stats to be generated, should this member be set
to 1.

Server version is intentionally not incremented, as it will be incremented
in a later patch in the series. No need to bump it multiple times for the
same patch series.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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
index 9ec09345..35f3ba34 100644
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
index baaa29f2..f783aed8 100644
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
index 188c57f3..6c86fa22 100644
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
