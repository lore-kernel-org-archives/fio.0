Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B73C433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1F161059
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhKIAa6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:30:58 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241218AbhKIAa5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417692; x=1667953692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z0mOLoYnGF42Uy4+r2olxBt6/L3PHsWEx2EaaQ/XEfs=;
  b=BEvR8R9dkwGnwea4fXDfpCz/6TLVl50ou2/FJ6L/jlREnq7F9bvPhoO2
   fIXllZBF1syqYF+2lpQS0MNuosERAQXOy7jYzNgp/8sj83CNtTD9BFZVM
   jEWW/RgGzx7IfHh1W+lthIxDZO6nkMa5bOWXcbRm8WRp0qqZtEmMcJTgo
   e9T29Whcq5z4lFW+MBGtR0uEIDHnAJh2rDAefTUCYlViyviCMn4YxTwjT
   EMRn2qGvy/wvXmCoWjeZnHoURxg4Y8EL4OKoG+F/xHxhYcG7ohxgcznW5
   iRUpCBjNyXTy3g1J7OuNXLTb95gYG/jz/Lgy0HcqIm50wZ/sbgNm1KQbo
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068523"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0g37xtuNzz6rQlbaf87LTnDoK0Tpj6U6T0BFO/6wykpGSx+SlR9HXFnw/d3B3Amx/qXCpPluwIP2nj88piUqs6B7sDUkvwLNQf8etvWXoaGWbeuIYtH0SCDVAmYLupXi/Rs5WjVu+9y3Pk3N0fjiysZTt7b9BmGal2SdHsCTQrQ2l2+Ew9yuUb+y/rTRhBxxpWNGis+UzNuZMYvKjCIyGaB32oqDt73TAmlxl3h43EpwpBK0SRJVlTVTCMgDwB78xNH+M77ZELfCkJrlLIT2c8Bt17daygOfj3jvfSypfz9GqznoFA9Zgbmnqc2DokMpOrgCuDmlIYv6Ic6tZIoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sDLp7i0M7jzj11o1O76Vg5SP/Utal4haBi1QmSMAhM=;
 b=EcvPWouWk39/SZ0rpM0Mr49+jjmRybXbG5uqYr/GbbnAhJee5EhCwanxRMgQlllSQDBLtnZkXrHrfnaLdqhvFTsuUBf9WIg9TDZh8zLIaLzA/c6xZk2hf718fH0x6ACKjz7+oS/io3vlPtsFb/Pom01kMqJxC6E+Y+firbeDvGsJG4kUogTkNjXEHOq8jxxj3qJJCles92OaIZrD2+NiY/5WuODzIgV5oF6RyGubiQcvWEFRwMqioXibrnQBTvTrPyY0ydRuLz9HvJrF0gbe6FhsO+3pa925YejoUojOU0jLPakuoRCj0a3jdpKpiQGPgGcVuVZno6FJOMkpRXB7sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sDLp7i0M7jzj11o1O76Vg5SP/Utal4haBi1QmSMAhM=;
 b=uk4WjxAvKancf5zZi6Avjnk14gcDigBUPl9nJf/c59mfL1N4E+xZKX2Q7s6aYYwjCkXIsSq+jseu06E3dPihSShwwGkuWLv1MEKJBCFLE0RJUhue+CX3yXHPyXj/x++sP+HJaqmvk0ggu0QrGQ/GRhZNgmApeh29k6O+slUuOdM=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:11 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:11 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 1/8] docs: update cmdprio_percentage documentation
Thread-Topic: [PATCH 1/8] docs: update cmdprio_percentage documentation
Thread-Index: AQHX1QCtusJfI+7JlEqD0eOkifPxBA==
Date:   Tue, 9 Nov 2021 00:28:11 +0000
Message-ID: <20211109002655.117274-2-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 95ab3c5a-3ea2-40b7-51b6-08d9a317cfd2
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB71446AA783799B015F6774A1F2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pc3YvDGPr21wxeVv6IVxCD8OZCC5JrhKOK6Y1FRgmrlTytmg6CMbnexM6eocPgyKLh1CuMEFQHRn9Rlp9o7hSxShx2wXSwnurCpd1ddmKAuDudJggBelgKhDa6nfiU5YjjhG+4Ht7n1SW1Bo0fsP3F4AKBRNkOUSA/dexwL/xUOkUcW1EHyuh0wUWVt2OLGlHjYvxizcFoubIvkTO3fjHaXsZ5pXQugm+9Jxkspu7USwzqfOE+S4BXAGPRaQHmqySekoQJPmkV5H5tcsKpBI6GylIpNuYccSrULii/Et0qLXL9osq4UKzRXy4PApsB+wKHVLsahZIbhkIEQN7tD/wR5lI9CXcOOC5I+0iLumrTFcWBEkwRCEOI9moHYUDOFQLwxP/s2VulMT8xUUIQdYMz4Vk+Zg3X0p7Oato2sgqRRI98pzpas22kAyjT+8qoOkBgFWplQeFo7u+mZ9WOYGvDoa+GQwn3OJcTYNG1sfZ8cglyJLd1pdjE6jOMw+IUqBgDQHw4hQuCjHpNOeDylY19LIBZWOt3beSGvLLuegDVcL5/mIxRhbTgSGTB82/V0mvRppp6EjVpaxiQ2eG5oXWZHyOLWGoGpAb3j/gdEFaJJxFGlKM1VSKnqYH7Oh7kg9jGvp/VRG4UA+VwkD0Dj8ZDCzHdzei7Q2cUN8hoCAEUZo0M0RCCFINTUeY3r6WlyBTaRcqXYVL5Ne+yEqsugWJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(15650500001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?VncbFcKFIMzgSe//k1mVN83PL574cxrFiKlFni/EJQ9MDBB0aS8XZUyQHI?=
 =?iso-8859-1?Q?8ZHdBAocNJ/PPnYSkuDKBSSmrbuRLUNgQCvgL42ypJ+H1NJdZa3yvCwUv+?=
 =?iso-8859-1?Q?y7y9PK2JQEnpX+LGrLI1Dy/uTA6LQd6mAUPrOwMSmgLvAR5VSTwocQoLkF?=
 =?iso-8859-1?Q?d8ufXgJnrOnctD2A1YlJw0uTTIF7TlZ/Zr5/hLaK4FDCh/z99QO0okrnKQ?=
 =?iso-8859-1?Q?JL00m8yxVqfPyUEuoO3Qof1yy7zQiyTSXyqFKeq63VNMwwmK0tcU1guSmF?=
 =?iso-8859-1?Q?XmmWpBchMMtG/TFFEL1w/g7cNNDHtcRxx1XDfsUEeKbPfeNpEpihg9ozJQ?=
 =?iso-8859-1?Q?gEPIzDE0OmLyKx3O6KZIZBLhfUU0sdC+PGV6r9tlc3Pkps4uNfz3pZDL64?=
 =?iso-8859-1?Q?wBKuEcEx47P6eZy4CXYAbrWCJ6H289ulnQfZ2+vgTzcs7/Ft8WUeuNd4lX?=
 =?iso-8859-1?Q?p1aJxjdRCS1L7PX9cDNGmuCRU4A/i+D7048xngcB0oLR+FqdZ/xINqSzeP?=
 =?iso-8859-1?Q?HQ8syRBP5lNXyEX8LpZ9ERN0DBce8bnBDacx27Gd8kmmPLQsQ/usgrF8AW?=
 =?iso-8859-1?Q?rBVskhaOf1xbq6qbdKUj6KBfP11mqubXc8hFrEzUkpclEe+nZLzD4H1s8k?=
 =?iso-8859-1?Q?HnoTTnZ6SNSrXqefZm3v7xaVkMu1s25bU1I7ci/Mbxh5blDl7cpP8hqySt?=
 =?iso-8859-1?Q?1RUUGjHw0cyAeXDKpRlXG1yB4ipgYT7ELtlYNTObf4I2uN5dPmEP4cPJn4?=
 =?iso-8859-1?Q?iz4Lfz/nUYJXoAat6Jk94G3oOitg+OZfTJ9AjIrGQK6IHMLTrrkdMWbiLD?=
 =?iso-8859-1?Q?M288tvygp9NR3Bs9vi1kP3hOy95aRDf87/VUndpSZ0uR2kBO0CghYGkSlZ?=
 =?iso-8859-1?Q?7ESkZ9Ex9HyPMzxggrxAJtqki7vQdgZ6yHTlwNvrKLKOQ6CKgovqK9OOLP?=
 =?iso-8859-1?Q?NET2uCU/vCTV2YF33zBU31nY8sy6drf1I9rROGh8BHtcTg/0c2qhVhLM4y?=
 =?iso-8859-1?Q?zakLXvxorgYLIERetF+CROOXoSN/fSD4JDW9U/jCPKCtcY0iQIVQrmSaGO?=
 =?iso-8859-1?Q?1Cgi6NDU2B8FybPx9RIZSnUfdVQ3wjSi5IADq/GVPEH4X/82kzSmdFoZtR?=
 =?iso-8859-1?Q?nmZWn9V1NqImxWqYXRLB68Ud1kWY7wctqqcO2V5YY1FRvi9qhFWOmFMg17?=
 =?iso-8859-1?Q?H2MyKqXBMCe4xEzaa16yqxM1ChyI3fl0mLXCRzOPZnf+5/69ED4S52L+RF?=
 =?iso-8859-1?Q?Gn8SPLT/Zn7a4ylhfEcXYW0UP9WJ/v73LBHFms2VyEA+0ipae27s6gVI8Q?=
 =?iso-8859-1?Q?AtRNLPw/Iq88SAnDgho+ftOS+7FAdPderPyXOmcEybN4Zc7w+PmWGPo+PL?=
 =?iso-8859-1?Q?6+/fh9UcK2Y4WRVWTaOSk5ecUL3ViSjiplWByY0k9YCpId1zP3rFkhPoMT?=
 =?iso-8859-1?Q?DRjANrpzJZojl34TOJwFkkcBVGsuVU1Nh136NpgbTPOnyX0ca888snbjdn?=
 =?iso-8859-1?Q?4S4HPDSxZV8BSXsIIvqY1Ll40FHzqeEa6+5MBwI4DV1b0sHpv5B6mIDh19?=
 =?iso-8859-1?Q?9c3KpY/NsF84B+acxG4b5MFL0nSSjJSWrcV0y5FES1xhjVYXhYLOF9TSou?=
 =?iso-8859-1?Q?r5ov1gndptZ4OL8hW+kSpecmPG+lTGkHcERMHEO5gFDncvq78l+JVWKzk2?=
 =?iso-8859-1?Q?31Ru8FhgX1Dyiai2k6w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ab3c5a-3ea2-40b7-51b6-08d9a317cfd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:11.3946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUZq97KDXB2kAENayWw+NGs9Jl92ec//8EMHwuEwF1FI1nJbEIHGGlyGsGcDfg/0EPj3wevPQn+AQ5ZQ8o93sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
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
