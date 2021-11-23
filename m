Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285EEC433FE
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbhKWOag (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:36 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhKWOaf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677647; x=1669213647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FLDsH21wdLr02WPvODtLPWfUAUiWd5eq04ck8DAhUVk=;
  b=AJmNebYXRZwIBSK+/cYnmCG8T+gT2dgyaTI5zSbTL0mKDUkOINGocZeD
   5F3Vzh1fiQrED+3wKY6AOktYHdmZi1ZqdCxA3XIQVgIzo12eiV5vWubQG
   6TfSegAED2vA75cGoc+hcO9Ki4bJ16+FEh8KAyQror0VCtA4YNcX56BNb
   siI2wB52XlND9NTJTGnt2HYNMRYeWQwW1n/mRZZRN9afd8qFtSoPn1aUA
   I+u84+Nx7rnAPYkJqpqJsf5z1a619m/HuC0+uggoNDWRzBEH4BHSvNF7V
   9WmxXK0Cmhv4phAvWS/OAdP+6q4C16qyBXZUFkR8Uc+epXu3K4Q3MJNg+
   g==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250419"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiJejfx4pQZjGblhiFeXCduNcQ9B243j6ScKzPRegcbZ69pKSBaDL4VCXfN9Kgxw4QMXGK33kuZGRZIUhTdIqSW+1YeFuxX7VIHivuKKAAKUuMwaP+sX5hlSI3IwHmw96U1bxqaA8unrcpRfp3/BiEQ3+/z42MYv3BJB74Kwf2OHaTvTdnnTgkJIX1rjokVFOGXHLguuKop4WRnwpH6Tu5STtKzxZ5Fl5Ztgf62Ip2MFkRJ88wK6Lw3XCpS6zWNDnBJGgcDopP9MWoQma/hz0LkofOsUj37CrY1hdKUxgTKOae3fuhF0WXONlUcacZkyLErAFl2glClR7aifCVnNzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXUveoSJqleutHkO/xDLHA8H8lfVF3COHv7VrCtifEg=;
 b=gB1qMe6WPsDyCoEkdPzkG6niItVZHgEd5HNSg4ilylETdG0wWaAQXGJz7jaQzhskDenw0OFEzaOUPlGR/c5yDWPtxZkVrwpi9dpLR8rr8ofVzBuR4ztvWZZ8j+BDh2yJDXLz5UbqNQC3mdf5WgtZs7zZy3Bk8i6nINDeRHe4p6Y+sDT19L57WEZT/FMN2+20N87aJWAtyxfuCQ4EipV7Ii/5ti2p03PFDWqbHMuE2CY2jKMa6AnkzVlHEdI+yv2uIK7jGNB/J0uX83X45I1R3RuagqBBAdUb/uH2r9Y94WrM+z5nC3egYMLA4GUXXo9qYZ20SQBm3+x4H+aBUZOXqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXUveoSJqleutHkO/xDLHA8H8lfVF3COHv7VrCtifEg=;
 b=lL887ng3FahF3Ss6TLOe+aRcDXthhfwZZ3/INGRIJtZLs0X7vkJ2f5G+4oRILLsOmE4KhN5L/T0QjrVwvXbOv7qJGaBvADSpQ3HqL3mHVRU/eUN0NFaufL9adQH3Xx7d/66HpAuFfWOI+woAuTLA+RyUUXdjhXBmF2ZnORs5cOc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:25 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:25 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 1/6] docs: document quirky implementation of per priority
 stats reporting
Thread-Topic: [PATCH v2 1/6] docs: document quirky implementation of per
 priority stats reporting
Thread-Index: AQHX4HY8PiTNmT7Yn06q9Ji6WFqI1w==
Date:   Tue, 23 Nov 2021 14:27:25 +0000
Message-ID: <20211123142708.48867-2-Niklas.Cassel@wdc.com>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2217ff7a-59dc-44c9-ef34-08d9ae8d5f18
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB7589EC2E0259F4F801DA6F63F2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3LCaeAl+euog1KA0P002R/E1mwqkweIAn73BEOAOY3xpfrT2JtBz/V+lYkJB+kPJiHTXFclQI4/pYbnO3CMhPO11BETvdAGxald1Gc2U94wWmPETX8EcBBpJ0pPOrk8CuGJ28cR6ukHB3fTyiVNaMDlQcnrd/Iby0P0M7OmupgA7XctarO1Qaf7sAtgu2ityiF3DtN7tIjpV6HE17Iq4Xpd/O5HSTK20rZGiCrdGqGhkj630Kqh//P+oMoqgruuTMlyD5Ep29Z6a0bfALRz8hZ5EK2goO2pjeCagMQBOSSYa9t9y87/bFP5XyhixqTwwpq6nnXf74EyJwjsR+ajTZOvrDnOwHaXVHV001SlYc3fepLnMYOkrlXxPFuBlVjXxc/i8TxokQqFW0438zvpQUcqgGkr800WoXG2i+Lxy+FQlkTDEdbugPEDJs+1IJIPRk33N/c+JKzBpRHJdq2XRS5SJZzn/dqSpvMAYu0Ue0PMo+PLtPFemWDRi+uZ9tzd7fpV55DaVUsYuhJbEBIY8/LBwjxlQJ/7TTK/k6uu14FvZxkB1kbzd8qiy4SBR24Xp8nIhdl4zD7vrJrkchI+q/QGpAztbIpg+ud8VzuUVdZEP9SOTm1GZapHdvX4ngJBDlxVKCR/UPg7c1XqSO/AoLg9QwpbT+9+mCSH8emvzYdMZI+xgbbUAafim8576GhsAwRNQu3iCqJC4bkJUJIu4MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(83380400001)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DBPrWIWuL23wsH+fxKJ8Lveyk4sg8hIg5j3a3x0JHdBHM75vqe/TOVeg2T?=
 =?iso-8859-1?Q?/FKybaDls84Mi0FncweTCmXTbVbG1HhUMoVQNw1P9L/fq/uZuVJv+YQzVJ?=
 =?iso-8859-1?Q?a878n1GX5K0tdR243l/twKwPtRJt/JuGLs+IWQV9eUx7mVGTEeUdQa1hMm?=
 =?iso-8859-1?Q?vJJg4D7oYzAkowz3r/GQ6RcstG3quONQWCuHGp3TszUvLT66zXShZS0bg1?=
 =?iso-8859-1?Q?prdyxDxlz5qfn1LifdLoWLHBMR5LHbL8lswxDFVzvung1n9PnLcWb+KBih?=
 =?iso-8859-1?Q?6Q+PSa2/NaqsFlMOPMQTGVZRhCB8vJYYD8a7cHescBisJwFMbvuFYkHYue?=
 =?iso-8859-1?Q?rC8bonVwEkePzFEug3bB5r464WwkN8+QYwR6ZzRHZeZn0st2dT/rtNN4CO?=
 =?iso-8859-1?Q?mK7ekoFYspSkC9ezVW87VBMMKOa4W3ZmlGSRVa63IlVt38Y0ItyTlhcTr9?=
 =?iso-8859-1?Q?FCcJ6jTxBJpNuh3L5pEgdCfGdFrUPjfK7PUS2tx5BclIDvpxCaeVVfSGFm?=
 =?iso-8859-1?Q?OY/ROSRm8+WU96xdrEzJxVj7qYHMiYaev+QjXo1xRiDq3n8zLcVGoGKJ1j?=
 =?iso-8859-1?Q?nefazJvM3/5weY7EqcdjRyJXLKt0x+7hEdAxxp0sDRV5IXoiSViq3QjqRS?=
 =?iso-8859-1?Q?FhDbcJZjQ73/BKweArTHDGIllVO2aNIeXoYsUXQnRMS1Rom/X570u+NIlS?=
 =?iso-8859-1?Q?hnWJBGKWuJphC13Jf9ohtwmg/epazi9d+adE6mx7DmYPyY1QCk2oQG9Tgh?=
 =?iso-8859-1?Q?CUWv7y4NmnblR0EpmOlWkWcKodivorMxtQzji5PrEgmRmZ+gahaT3j7KzJ?=
 =?iso-8859-1?Q?3d9sYFMKBQDaH4E59GwXkzSmGlXGzdBPnBYY94xygoqtN0HEzrJZaJ6SRr?=
 =?iso-8859-1?Q?5mkt8Kd5+uGGVPdvqkn/Mm0+91LdjmuIpDmdH9ezJDvWJ2EbTEtRsLNpH8?=
 =?iso-8859-1?Q?yBGzIjXiJz2h52GD4uY6QUqebhCtU0Hiz8/HuPvMPPFpqxzqOlsCQmzfXp?=
 =?iso-8859-1?Q?AEQlpo5MBoYsD/ph/S3Skh/1wwNJNCNCFP+74ZtnSJjjAbV3BcVw7oQsaI?=
 =?iso-8859-1?Q?92PkXBlz5j8T3Nd6X0FT9uFpHltBuh4QVsyCwybzmHbYTkaV4Bvp6vkXLt?=
 =?iso-8859-1?Q?pcC/dYN1QJCGDlApyAAm+3oMsduHwRGbaHbzZgI2gdqHoo4FmqtM8g7DFR?=
 =?iso-8859-1?Q?CCvVngYxGio7o5EVmPLBefVRY5cdi40/pmDpvVFL8QtlXvELeE3qXe5+vx?=
 =?iso-8859-1?Q?2y2Oop8B9vL2UW5RDIBelUQoZbI3I9Ni+u8i2++yx37VRRGYppxdwvUHvJ?=
 =?iso-8859-1?Q?x1skgL5WPKDp9VylUMlTzJ0OE9XnjZs7qWBhosEEWEhyXwD0R4aSqtZjAk?=
 =?iso-8859-1?Q?aOyHTk3rprdefhke7T+MTluznUyW0sHPrr7xZBAlbIqOmd3/EJmM+y0Bwo?=
 =?iso-8859-1?Q?gzNPQXfhEQXGDOmnmxKkKK4q6YSDCYHiPkwWt/YhebudtDgm01Hnso0PiJ?=
 =?iso-8859-1?Q?1eNh+XzG6gukvzkWflK9h1v81YB9LG2tz3vpaTL/wuSoRA4cklFY4ETHZH?=
 =?iso-8859-1?Q?tdtoNZQlFAAGotJbK/W8WbrwUR/WqJ63v4Fe1hGYe5bEWElRCr0F3mUnk0?=
 =?iso-8859-1?Q?TLIkVL6xDGg2n73/K5RPWwTzHR3RdrZWKtiCRfZnoJemxY85vI5GXEwF5A?=
 =?iso-8859-1?Q?lfTCeZT+PHsxxTl4ivs=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2217ff7a-59dc-44c9-ef34-08d9ae8d5f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:25.7502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2gwd2UzkPoggkDaaGXkKt6EO4QkFpruGOGVo7y9mPB+ZF/xYHetmMF/vX69r1rE6ELX+scgFwPWTCicHd25kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
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
