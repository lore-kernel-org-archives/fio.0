Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751BFC433F5
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349428AbhKYNZo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:25:44 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32791 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355351AbhKYNXo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846433; x=1669382433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rm0fg3Q44gLjdjFDXuDxdq1jc/6zjjn3h7Q5FwUNwAI=;
  b=VaoDVMfdqnRo516qwloePxJWjzH7S5FwCFeJ6ziIIS5WTuL8CTCdVmpz
   xMhfoMRL8UA+3p+thKdQofH0ZgSFUEJtmSKmI+sKeTR/Oid/4iliQ0PYF
   nCGprlnjTwGr4yzMcf8ECmd4jZtHDQmei1qrP81yAk14QH/1QZoB1o5f5
   29h99e9pQtpavn25ZQHv38RgtfHuTzj+frIIWc2Q9uLplmWY+nRBNZBVT
   OcI4Na35lltWHKnfguegN0Jh1HkawRcty0pf6oJRZxsvq4bkFZKwEhD4i
   hg97+ALdnTbvMMCzSYnvrWwtcRVWKOJrHFcPJBr71C9kohci0wBYRHfC0
   g==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="298461772"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYlxwmzjAIVem1+Htl9jkmMLZ6maIHqi9l/fvWnjuZDc1JRNxoMeACMda4lP5LHCe4iIKKjscZbjqJQiKhRLXnjEzP47GHlpixJdk1EYu7MdsKIyFZ/G7zfwQsDmgMBr5cfcfUeTAE27Z5YvW6VxjNSNws6xkJuWxr0bNeDGec+chhBi0c/Sic+vaNcav0Wq2JsBSo9EbHXN3O4ulDhEG2grtQl4u01v4OrT/026TWCkkeq9Npaa/MvhDj1LDA7pjm5qUVaLGQOC3Bfi5SvT6gtZMImdlNaT2a7jLiQ8yJ2J+WUHOVuqL51BTnYcSWfSovHd9US+2jFiRaMgI0queg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LyWvVGYr06AYOVXXH447R4419KdZ1OtVSuE4hcdLSRg=;
 b=fEb3rAbV9XppsSkP4QLxzMA1sp/VHjB6SGfSpIFLPM5lx1UeRgodvUms6fuT/L9v4XrSM3axae5C2H3NzBit1zTesdNkn2y+xF3fB8B3UQ/t4CIfr0a3zaCBXnNmR1q5OQ7C+gsf3cW9SV28dv5OOLpaEYNkjffGks9rvZm6lkakDU9DnDPseo2edr9Jhu0tZjf5psAAVDZ5Uz0VAaIDvQDMNP54VV2Sh0y2tSWGN+JwMKTDHE074SxS7VvvF0S45L6UTFpES8dy4ks+zX+SKE6KlMoh/QejlWBIk4WvuDQnOQx5mVstMkw7jerjowAAGXRovWsClkE5cIdC5+ZFXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyWvVGYr06AYOVXXH447R4419KdZ1OtVSuE4hcdLSRg=;
 b=Za1KNTmA9HnwSVnayE87zh3YV6R2R9XzNgbrF/qWmccrax8cMTChRQUfJWvwyoqwQe0XQROI+AX3eOxDCTbIAG8DC5o9HjHZb79NRh4BM9/zvsCvO0LYlm4nUCH0oem4goY3YtDMtWSYEv/3LrgW+1JYR5F+xHAy8r0kH1SgLVw=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7591.namprd04.prod.outlook.com (2603:10b6:510:4d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 13:20:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 13:20:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 1/6] docs: document quirky implementation of per priority
 stats reporting
Thread-Topic: [PATCH v3 1/6] docs: document quirky implementation of per
 priority stats reporting
Thread-Index: AQHX4f844pwjpDwn1kK5/JIzCjClSw==
Date:   Thu, 25 Nov 2021 13:20:30 +0000
Message-ID: <20211125132020.109955-2-Niklas.Cassel@wdc.com>
References: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 886e010c-a4e1-4541-5377-08d9b0165a98
x-ms-traffictypediagnostic: PH0PR04MB7591:
x-microsoft-antispam-prvs: <PH0PR04MB75918D56428E3E59355DE530F2629@PH0PR04MB7591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sg7VEgmwR2WqmowH/7JWPXd7babdcTd7Nb0FYxwKaKRC8NavZ3iQxuU8VTmRuEgPS7/McUHJIBrO49z9/U5bl/uNYYTcp3dTdTe/Y3+E0AoHLMuZtrdpK6BV+GmITRqi/QPpr93il1Vr85qnjgnE2OK27RbMg5BXg9wl8u0uhumhL4DjGgCZhKGdFg985UWIcRmYM135LdZ60hkMt7BbklUH0zMJhUuJze5XtTv04IOnSp0HQKQjme8wCMW5ItJQC0aSMK2SBB8A/YyTo9AS6eRTho1ixkkBMalKjmF7N3pgwpSYKQCQozVmSI0n04iWFVw5W77wITK88/AjRrxzwnOlwWxDpHcc0oR/gPaL76AvBKTg7R0K4U1Nlkc0HQ5S8Be7vHGLx0DYw+oOBZDo3wEYPG9hen4LLoGD1U11A6rsYLPoyBAPH6PvhZY1Lur/AHOVpZJvcReMELEBgFnZwg2dswWi3OP+hLcotY5PnHjQkizdxjJxI8IW19miZ1ZvevFQuVfYyHzMui4Z2dtuvgpEnFms/JvjlrTPJVlRlyXE6qYUmNweQyxItX7dsN0hjnMYsVaVstkHmqe869ooWvFoGE+C/sXfN5VWEpTK9kqvvqsRoDEvmsAU4F6SfgPrA/cBmb4QO2gAvpPCSFYT++i35ULm1vVWs3WtmUNd4l47vqmjD3JbqoavXXotSwSSxFfmJsuszqAeMf2UkMPEww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66476007)(66556008)(64756008)(6486002)(6512007)(2906002)(38100700002)(8676002)(122000001)(38070700005)(5660300002)(186003)(8936002)(76116006)(6506007)(71200400001)(508600001)(54906003)(91956017)(83380400001)(6916009)(4326008)(1076003)(26005)(36756003)(2616005)(66946007)(316002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3gv7KfqUV9b35n+Rq74HunkDy5SKqa51omT++AWu7JflFpnvaG91Nk3Vh0?=
 =?iso-8859-1?Q?mpFb/mzyEhnwruppCP6aKn3AFCGGlogyUB1b/n+ZU5Rl92Bl8qQWCiKttq?=
 =?iso-8859-1?Q?c9Q9gjEo036kffGfZbnwKKJ0XBOl8FDFwmxG6d0g2oWdIIygEWS9l0Gv8i?=
 =?iso-8859-1?Q?1Q32n7mz4DdQq4W9K+4TSma1qvtCF78wCRp6UhrWWsJS9638wurEoT4DWz?=
 =?iso-8859-1?Q?RZzHs8hBLSmTsS0C2FXV+BUKZ8EiPh4+nnNxmHzXKLTfFRlX1BqDTPaZr+?=
 =?iso-8859-1?Q?6LlSOgSc8/fffPEk0J5v9soUWBhDRUZcY8LYcJICt4aJ5M6LX/yP56Y1z7?=
 =?iso-8859-1?Q?XhIMwEbJzUmFgwzWhOMhliwHh3MJ8PsglpJ0CdO9cqOMnz6HjxRRH6rkT+?=
 =?iso-8859-1?Q?nxSkArWBdUUlj+AHXamN789HbRcaAddxNyuqr3h8IstseywjS7cIR+0fqv?=
 =?iso-8859-1?Q?zfqBRy640eJkmAusAwGnzY1SA3HhMUoMm+4H8vCeeBKq0nyIYAHIAYWhfW?=
 =?iso-8859-1?Q?i/gfk0/FkGaclHyR50TpvPTm/kJByhnap5ePC0B7mY+F1lsjqZtoj2vFyZ?=
 =?iso-8859-1?Q?10/bgERRrolKQiQiWmARGMNExVWkchxwV+MRvPKYv6YuHrRA3l6k5T58+E?=
 =?iso-8859-1?Q?gqfJj2doNQzd84F0L8Z7JIBtbIWludDNk1MaYqLxoVxIchBIx4k00ivPWA?=
 =?iso-8859-1?Q?tFodNwOZPCAZjK6SUDLX7ouzhvstM4khxntIYOoQQF2WGTyFDztDUr3dBU?=
 =?iso-8859-1?Q?4jWWpl7hu5+0UdNtMmBNAO2z/WvFtuiPgE0Bgxjnz54WKHg7DDo1Hudzs8?=
 =?iso-8859-1?Q?V+9AK0IuQobEWsdBzWqMaDoYGgEgSSqsehyT25Ogw42snanYD0Sjzl9vrv?=
 =?iso-8859-1?Q?CvKBwLzzVv4w+pZxnd9Wf48j/vQfsW4BFfxNK9+5X2lVWRjdM2oaTMSbHn?=
 =?iso-8859-1?Q?geuR2vYF3woaG/bLuGdRfohhBpan/7NNjgalhFowHl5/XpfMKA7aHr/V5H?=
 =?iso-8859-1?Q?VPXHX/6+Qek8lTbdjDhfVRzYpCBctsn2sAKJW+Fj6qMbZIbZQiqfo/eQlr?=
 =?iso-8859-1?Q?MNZjh0B2lUOVC+PIgdr6LVui1LC9bnhuONI78Ye8mNZNGsBx0MzVoDsOsk?=
 =?iso-8859-1?Q?JNkAnlAXnjIESRjkWKdqnChNN2d86MQeTLkD9xp1BO+33b9H4rBSEmoUtM?=
 =?iso-8859-1?Q?NszkcTA/wBGJZ4z4HWcZLMbftRwGgx5YfacHxvtEC8Ldq5CsI/UDuKf5dx?=
 =?iso-8859-1?Q?+efK/3TNXqO53bd/eBQVPWtvTJal4W2LRWxQ52jp1hAkYzCaWhZJGFTMeY?=
 =?iso-8859-1?Q?BqZbOYSx+NH0v8PkrZqqlzDulyfVf01fkr0tS3BHxliuPzEn18LLZh6kB9?=
 =?iso-8859-1?Q?iD/yHiP5O2csajR2l/TmFH77JVp2d7GsRxmt7fri6ustKRddVgplwsVZGl?=
 =?iso-8859-1?Q?R3UF2oGuc7BCKVtAlCk9Ez0GMBucLw99jngNzUb9U+rZyJiODrzap5+ntZ?=
 =?iso-8859-1?Q?fdxqvpULrY9cfgSl/6TH4EsGcrp2Z/iNPTuPt0ZhKbFWpjv4ssKDqZ3BYw?=
 =?iso-8859-1?Q?0MSnTMN1aZetD2mHvpy0q5sk+ghffB+CWjhvMcQuxW8nPF3XWtI67uBmao?=
 =?iso-8859-1?Q?ECozOPfX390ISB/1rbg8GTrfmY5ZCCZwRUkHNwxNtwi64HxXILs2aenCMv?=
 =?iso-8859-1?Q?KdZ69Jl1P1cpDR7uMAc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886e010c-a4e1-4541-5377-08d9b0165a98
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:30.3774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: baEYv6JpR8va5Cd+uXX3tg0C4kmCqZ7MnqzQWR5vKeGDIU5lnGQux677r4jT9FGe10Ph96CnFhZzioioGLVvHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7591
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 56440e63ac17 ("fio: report percentiles for slat, clat, lat") changed
many things. One of the changes, from the commit message:
"- for the new cmdprio_percentage latencies, if lat_percentiles=3D1,
*total* latency percentiles will be tracked. Otherwise, *completion*
latency percentiles will be tracked."

In other words, the commit changed the per prio stats from always tracking
(and reporting) clat latency, to instead either track (and report) clat or
lat latency.

Considering that a certain latency type reports two things:
1) min/max/avg latency for the the specific latency type
2) latency percentiles for the specific latency type

If disable_clat/disable_lat is used, neither 1) nor 2) will be reported.
If clat_percentiles/lat_percentiles is false, 2) will not be reported.

Therefore it is unintuitive that setting lat_percentiles=3D1, an option
usually used to enable/disable percentile reporting, also affects which
type of latency that will be tracked (and reported) for per prio stats.

The fact that the variables are named e.g. clat_prio_stat, regardless of
the type of latency being tracked does not help.

Anyway, let's document the way that the current implementation works,
so that a user can know how per priority stats are handled, without having
to read the source, since the commit that introduced this behavior forgot
to update the documentation.

Fixes: 56440e63ac17 ("fio: report percentiles for slat, clat, lat")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 HOWTO | 6 +++++-
 fio.1 | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index a3b3acfe..8c9e4135 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2169,7 +2169,11 @@ with the caveat that when used on the command line, =
they must come after the
     Default: 0. A single value applies to reads and writes. Comma-separate=
d
     values may be specified for reads and writes. For this option to be
     effective, NCQ priority must be supported and enabled, and `direct=3D1=
'
-    option must be used. fio must also be run as the root user.
+    option must be used. fio must also be run as the root user. Unlike
+    slat/clat/lat stats, which can be tracked and reported independently, =
per
+    priority stats only track and report a single type of latency. By defa=
ult,
+    completion latency (clat) will be reported, if :option:`lat_percentile=
s` is
+    set, total latency (lat) will be reported.
=20
 .. option:: cmdprio_class=3Dint[,int] : [io_uring] [libaio]
=20
diff --git a/fio.1 b/fio.1
index a6469541..a3ebb67d 100644
--- a/fio.1
+++ b/fio.1
@@ -1967,7 +1967,10 @@ Set the percentage of I/O that will be issued with t=
he highest priority.
 Default: 0. A single value applies to reads and writes. Comma-separated
 values may be specified for reads and writes. For this option to be effect=
ive,
 NCQ priority must be supported and enabled, and `direct=3D1' option must b=
e
-used. fio must also be run as the root user.
+used. fio must also be run as the root user. Unlike slat/clat/lat stats, w=
hich
+can be tracked and reported independently, per priority stats only track a=
nd
+report a single type of latency. By default, completion latency (clat) wil=
l be
+reported, if \fBlat_percentiles\fR is set, total latency (lat) will be rep=
orted.
 .TP
 .BI (io_uring,libaio)cmdprio_class \fR=3D\fPint[,int]
 Set the I/O priority class to use for I/Os that must be issued with a
--=20
2.33.1
