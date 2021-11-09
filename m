Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0B1C433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 153CD611AF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhKIXlR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:17 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43923 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhKIXlQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501109; x=1668037109;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QPzMp7aZSsAUyUdsaiA9AWDpWnhAmxTjz8co6SANPXI=;
  b=dHAksyRik7shoZ3NRa4ZFftEDJL1lfRUcna0Sx5L1QZJpk0ABETP/DNB
   sBu9KVfjaInKpsMvefF0sJQcxx64VypFMhGv8VklAlH5SagvDBPL/VSd0
   1JDuJYtuhxiZB63EtfNaOWGho6T+otNuohk/cddSB96ruF8dWwszmaZ71
   yF+9exfn2uAeqlqZ9kwNIOYORWzs6hoDTbUQEEFyc/RQda9D7GIs6kZRF
   F7ExjhUJ5vWktx/qj6x3KendIApNmtQPWIumD3Zrn9OUQWus47nPaNBZn
   a3e2r6SOCTCZ1a5BKtynrDrpjVErF1uUUI0fPURtaAJNkK60hAYsG3bOZ
   w==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="185172210"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUXpDe2MZ/oTuu2ml0eWyFBYGs5WCSWOPCYUoEvHdtllCpAfrV8vU+icgtABWshCVSgCNFzm6TfCbvbyfwQKX7P39Ti1ILi8JVufb3zVjA40GZRKvSb4SJKG3XKpsx//RqlTFWJlmDlsx3Uk/yLxA27c311itas9s3YOxgRaQgjPtAzZKX8+qebZRni2Dj//4tobwTth/w24akFptVHli7ZeaY3ICM+eMsVuj/pQhtbWWTDIeJXoITSoOn65YFMXTCG+ReEVIWMVkJO9OPCfCOKs/Wk0CoSfn+VyjEYN3ys1m1baH5SpkPq8UXAEtwdpXX7YD1XRfwimFcvHTbnBHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xw/mIarXHh8rQgmjxyQVtKYWrGPgt9A6VQsGKCh1yzM=;
 b=AUi4p0jS19SJkjX3EnJfbBf3WCMnaFuzyx8kak0Fr2+umu1tvm8+mlVoNbvYqqUfi8nHtmsCUNsb9uLK8UGf1/QuTf1qsG+5nIQCZjs1a49Yc/M30fAfb3CuHJhkeiI7H/KD+7fd/8vW67yzFdxMj93/3N8izTCvZ9we4FbWqLLSm3x/u0eQD2GhoahehGCB9XeNaU3MrJk13h6H4OqHai/RzdC5O1tLbhzJvnykIfTzGrgIop1JWhixjghhvvaj1PcsykoO68lczOKLKFG0gEnkcvwsC6HZo4cfT5AXCcwKW2LdbQdaNo79IDw+jj7Pz2DL9nGhgDjcY5M7Mk93bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xw/mIarXHh8rQgmjxyQVtKYWrGPgt9A6VQsGKCh1yzM=;
 b=ArRo6y/h9xCyx1N46H15z3bahhD34ii/ba4FAqUMnzCNhN3a1XibIviIuqQNS4I6wuOJ+G619/xob6c93RPFA7/PAe389dodsGajqhse8a+1W+4W2snCT5VOMt/riz3ahIj+MtrDdryST3kcUMnSFGvgt1I9PoybOZtCNzBR6SI=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7736.namprd04.prod.outlook.com (2603:10b6:510:53::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 23:38:26 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 1/8] docs: update cmdprio_percentage documentation
Thread-Topic: [PATCH v2 1/8] docs: update cmdprio_percentage documentation
Thread-Index: AQHX1cLkiaIonc/aBEqaM4rsj9E3MQ==
Date:   Tue, 9 Nov 2021 23:38:26 +0000
Message-ID: <20211109233804.164786-2-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 4f98e805-49a8-4e8b-2333-08d9a3da0738
x-ms-traffictypediagnostic: PH0PR04MB7736:
x-microsoft-antispam-prvs: <PH0PR04MB773626837DBAE04961C3DE3DF2929@PH0PR04MB7736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDWKQjitPNiii67Fh+nquheO8zfQy3kEdUY6/8XPPvsy2msN+bYmwhuXeNnzvpU5I4r49j+YrnoY/C7W82DlC/Xnq2/RkDWn7esNfDg6CD/9IISFu8NEpGmQzbGYdc3K3Y+mUUZsyCnrOex8PL8stCcNAe2bKYsR4Z8wx7vnZJ5inRwcxQiSsjbb6A7ErEVjG+iz8pY9gS2GZ46TDrvxxJwVlwrvMn6c9lI6gdZr5us7cCQA0kyy55RzZnoYjA+qR8lyK/j7unX5CQl2cPW87ajPlIlKHlMN45jProrcErEOAmQ/mbWMoMEkJTMOkIUI6qcq0knSnYtEr0tdwQXY4RUs+QZFd0jTrdq1u7M0GNEEkWXWFDozU97TWZBbxjtHESCqQQN2b/oC8axsq+2EFWbG0zHvjB04sGpZfoMkePcwSHTJ+WBAIDBTkGMtdgUo/Xxu7r4u4LeIfUofDbB4QTDtkjEAtBaCYpPgSjXj0Qc7DmSACv4MtWkWwZsV/XdqPDqel0Equ73OKh5FlTaJKBjxweb0uATIAsNR3Bxbys62zZlbvKN9E9bytVG3jPVto/4EfCqnfIttLSOezCNLDK4zbrg052f1AEvmMspgxC/vnKJgvmRv+IZ64mWbpKFIdBiSw4yuG7/8ZXXN6o76BNU/DBs00Eu0tQRkf2vBMpgCqGkvKK922mTuq2PvOZ0goCr3iXLpAT+RnSqoYgVxCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(508600001)(8936002)(15650500001)(1076003)(6916009)(316002)(83380400001)(4326008)(36756003)(8676002)(6486002)(6512007)(66556008)(5660300002)(82960400001)(38100700002)(38070700005)(122000001)(66946007)(6506007)(66446008)(71200400001)(66476007)(2906002)(91956017)(76116006)(64756008)(26005)(186003)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EaGrIlahoHSKmGTNEOhUPSFsbUqKY1BHbLirVyvx81/+EmpL1Qc40CX4Kd?=
 =?iso-8859-1?Q?jtWvXhRxLBeejX2texEUB10zKlPTwIyHQJiIQ3SUSWjY0O1PawMaN3LeTl?=
 =?iso-8859-1?Q?d234CQDTLbSi5R1tfKx/g4RhVPVpYyMuRc6tNrUBpGDTz4hUtkiqnCCCyE?=
 =?iso-8859-1?Q?iuaJqEog7Yr8IIlXx7wPNdm3oJnwy6U9DVrC5fASXgOMi7LuIxsX/HBdAO?=
 =?iso-8859-1?Q?BgU0gOj8YVZV1wRDZ6t3mt9+qUORJ9xeQ4a3mSZ4m6gwZWX4S5Qwuzw1Iw?=
 =?iso-8859-1?Q?9RO9jkERAFg+H4Tnc3/Io4eMnJBTr+pnJ6aqGQSe4uhXR8B+NvaEXkza0R?=
 =?iso-8859-1?Q?nxEnPtXgVKbdrfik1/dH+a/YHmrd06db8DIz/uOuffSwej4l3ZRelOzcQB?=
 =?iso-8859-1?Q?/xVCHvEZF6NjTTEtGrycSX3MfuvBqPbOK/Md2T+aGprLpXQV+2FtvT0o9y?=
 =?iso-8859-1?Q?cBxpACLmhsLGQLDuLcElmBMpOeEkd8HYSskDjXfxlie2tIHSS8Ius8gZPu?=
 =?iso-8859-1?Q?ZZmurQNAjyYNakokeeolPFcP0r7Lxge5NYf7S5GzwiQ3FfKFOr90AM2+R7?=
 =?iso-8859-1?Q?XZXTpn8mSlTAKqWu2xtFhj6vzWKd8wfupleXY2MopSlsifWANLICI8xn6Y?=
 =?iso-8859-1?Q?1Uo1l+1srK1wG+4jw7V/6iLA+W+t+bBAnKr2FbivOTMvV/0htaB2rvBHbw?=
 =?iso-8859-1?Q?QmgDKLQ550Jb0gwX/RcXagtXzJOT4Zee/jWuJi1hY7tb+vvxaOv2B4eDOy?=
 =?iso-8859-1?Q?G9Tqv0OQjO3glnAWCjCvo5MiPs2uzV6KIPClPaIbxxIRmVOhlV0TkSUCBF?=
 =?iso-8859-1?Q?1/YYI5L3P1Jka4IqyYIMFSTo8KkuWR4nzMLTjs68iSm/6YxPOPcmHtzsa5?=
 =?iso-8859-1?Q?cb7PXPsbh9OycMx8Ft07soMVBvPzZ7utDDNUGe6+B6fUwTf9KB7CH5WKhp?=
 =?iso-8859-1?Q?dMcCn9m8WJfoBL8npMwnxWGY8qIskgDMWpdnT6HaB493ytUgDkPvX2xW/j?=
 =?iso-8859-1?Q?rKDAZe76Rzg4dUVNiJfHKPQqqeUlPVkA97m0uhPIIs3XxPuwKdRi5Mpv7X?=
 =?iso-8859-1?Q?l+95kdwCYlNSV8d3tPngEwNuOB/lJqipCwcIzq93HlH1dSh2h3iIGZ5L5J?=
 =?iso-8859-1?Q?a6f37L4Te8YAS78ULldYxBolkKrCa6AAPF4EwRj4mllMnIC5A+sedll1sP?=
 =?iso-8859-1?Q?cEjoudgL0qDODVIU7zGDInOsk0Hf7/reI3woCM2kBmIj5YM7IWFBLhyRAe?=
 =?iso-8859-1?Q?+AnOBnd86ruK5zwH6guN3+SluGsqW6zrtGynM3qGjUAvrwHFO0z+AwSSXn?=
 =?iso-8859-1?Q?CikuBGrH7Hx8D3Ho1VcnuEXLUjudKWVPu9bH/ui2jdeLhpjK8ChcNqc1bN?=
 =?iso-8859-1?Q?suZZDqOfmcF334dKY47UDaBPOUkquHWhH8vdDK0stZO9tX3gLG8lF6/rTQ?=
 =?iso-8859-1?Q?2JLHqpV3uO4ZRLqAY0KYNoZfDUI12eaJGDbQyuVekkXnDeozyJ4jhpzr6Q?=
 =?iso-8859-1?Q?y9Znrl3hgG9Jm3Km++fvK8+Xm+ADxsCur9f/4/sCnP/wLFE4LJYulQnwDl?=
 =?iso-8859-1?Q?lpNVMlfQlmBDKZl7aFFd81NTtZJ8rfZ838X17tBEmMvXjPLBFu8Tn5Ew07?=
 =?iso-8859-1?Q?8bACm8zklF6CoWxih06//MfKB9TecXnmVmBDy3XJavKxtkRReZ0boiYL4c?=
 =?iso-8859-1?Q?pIGd/hHFKCMBMtbfzS/Zn3XcFVOPLiO9yh8h9O5x?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f98e805-49a8-4e8b-2333-08d9a3da0738
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:26.7280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BwEzPzuywXhjkwDzamYcI41EbDYP0xBodDule5Yj6+u9QDSTrezfbK0Ym4zUl9NvspowJbKDoktzwXfuZ8WvYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7736
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 1437d6357429 ("libaio,io_uring: relax cmdprio_percentage
constraints") relaxed the cmdprio_percentage constraints such that
cmdprio_percentage and prioclass/prio could be used together.

However, it forgot to remove the mention of this constraint from
the docs. Update the docs to reflect the new behavior.

Fixes: 1437d6357429 ("libaio,io_uring: relax cmdprio_percentage constraints=
")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 HOWTO | 5 ++---
 fio.1 | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/HOWTO b/HOWTO
index 297a0485..196bca6c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2167,9 +2167,8 @@ with the caveat that when used on the command line, t=
hey must come after the
=20
     Set the percentage of I/O that will be issued with the highest priorit=
y.
     Default: 0. A single value applies to reads and writes. Comma-separate=
d
-    values may be specified for reads and writes. This option cannot be us=
ed
-    with the :option:`prio` or :option:`prioclass` options. For this optio=
n
-    to be effective, NCQ priority must be supported and enabled, and `dire=
ct=3D1'
+    values may be specified for reads and writes. For this option to be
+    effective, NCQ priority must be supported and enabled, and `direct=3D1=
'
     option must be used. fio must also be run as the root user.
=20
 .. option:: cmdprio_class=3Dint[,int] : [io_uring] [libaio]
diff --git a/fio.1 b/fio.1
index 78988c9e..e3c3feae 100644
--- a/fio.1
+++ b/fio.1
@@ -1965,8 +1965,7 @@ with the caveat that when used on the command line, t=
hey must come after the
 .BI (io_uring,libaio)cmdprio_percentage \fR=3D\fPint[,int]
 Set the percentage of I/O that will be issued with the highest priority.
 Default: 0. A single value applies to reads and writes. Comma-separated
-values may be specified for reads and writes. This option cannot be used
-with the `prio` or `prioclass` options. For this option to be effective,
+values may be specified for reads and writes. For this option to be effect=
ive,
 NCQ priority must be supported and enabled, and `direct=3D1' option must b=
e
 used. fio must also be run as the root user.
 .TP
--=20
2.33.1
