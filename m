Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A063BC433EF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8928A60F5B
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhKLJ5b (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:31 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31590 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhKLJ5b (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710880; x=1668246880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QPzMp7aZSsAUyUdsaiA9AWDpWnhAmxTjz8co6SANPXI=;
  b=OJ1XroxiIq0LTiF+XkiTz0z7ESYmdeleP8ZZiulUhZp95yVCmX4SMAxf
   D9oc86/UncXjRuskFX+6L+Yp7hRVA8kEkf3r2nGcmMRBWgdFj/78Basnm
   DXv/cIH0cS6JGubGmGZ+5dKj99a8bmmbfT5woqwZ+ZqaiagmQPuVsu9mT
   xXnC6YRLiU8xZzr6bYMt+PJoaP6dRTEd3X/zsozDpXrtH9XgMNokmzbKR
   cWEWlDAihmtjCYDaQDC0rmttEljqEExqn/so4jKpxIcBkrZhVscmIQJRt
   qZPaNelNoSZ/KDMciV4TaPM+JtKpIBOLSn3KGyETvuigIFryRlm0MFsE9
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360572"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2i3Io4RVQkCYRo+sNXFYBQTMFVelo3NQ/vdq6er9WANnuhDM2Pf1en9G6Fx9dN74Ikwa06U3ZDTDc8ibCoTT0SkI+Eql8B8DmSF+Wv7TOYHdB2faogZzPoFO/Hs7OLFqhksaxOvavN4ZJKHrgWb3g3tbtLT6fkgV/CKAorrdy8713WIw3oAvu4lgTa+9p+gIg+EwdBqXIYDxWruSqOF9G9OqvpRT3L4t7RAw3iSAZk1sJs1QMt9M3ayUaMQ/Gzjw4X94YpePP0q4TWkcqwpVBUQZRzQ1wl80GNjr/thg1HeuuelX57nZwSEFHtamjt0ZDfMGuGU8Kk8j0HhfRToSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xw/mIarXHh8rQgmjxyQVtKYWrGPgt9A6VQsGKCh1yzM=;
 b=Lk877sasT9cqAX/EvEYAD0hYbtVZ1byzS21RGCpqjQxd3C6MBzZbrpkRbueCeiFGx7i5AIfbwMn0bCV9rEEyq2tJ00T6TRrwreZn7CmZdojLigRlz8I94V3fhtNxo2IKhvRwEWkDzduPYkz7hVR1ADebGLhPn8YgO1telnU1RJbWxV1Uk/fstFLNP7tWM4zHDjezFZcA7Ozy7bznertJUtcDloXxKJV4UxlwDdWOghG+lskv9Fxv+gECZBQQRCaK/b1Rubut/h8Jm0HJFjgCEiTWOZ5Nsa0Y4qBt7uZQgNG8B5Y+BY4/IpvidH5DUcPhKeJGLNMDJLVASMcBqzEf9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xw/mIarXHh8rQgmjxyQVtKYWrGPgt9A6VQsGKCh1yzM=;
 b=emeW3tkxX3bwyq7TbPNq1lrz/HdFAPjWt+VWHn9aohoXSZPf4dk0mGpFWoUDcw1aHw/Pfd98B0qZ1wG+yf58dCbkpGtGRrYqRDQERV6NHfgyFU2Euu0emnNUjod5rIyq7WpDs0qtVvZsLtoBSd/yzureeBF9DQnsKOtNeQTJfAk=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:39 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:39 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 1/8] docs: update cmdprio_percentage documentation
Thread-Topic: [PATCH v3 1/8] docs: update cmdprio_percentage documentation
Thread-Index: AQHX16tOAYWiOdpZfUa3TXvjqnEtaQ==
Date:   Fri, 12 Nov 2021 09:54:39 +0000
Message-ID: <20211112095428.158300-2-Niklas.Cassel@wdc.com>
References: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd2a99f8-1292-4af4-087d-08d9a5c2716c
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB74337467D9E09C084D566475F2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iYsyAV3pc0jJq8tfhIRMjaEK3Cm50JSzzkzf+ala4zpNeRMN0yRj2IbPdb9vX73hDOh1JqSX6eaKWnod+EpQ82rUFFjyzff852KiMPPbLpBvGN9iIU4YuWf5okDLSCQtzBTNeRsREYvWK2ehvuFoRmgF98HueA5Q9lyhU6/FO0Nthokj49TYE8TL9OYsBxL3FPnbh+/V6AKsvAuqqwS3Et2qf5gHLG57GkDWXb2GwSJeMzXjU4c/DliPvuRqSRiIzkk+83RnoHUThQSoaGVRp/ZO7svP6Os/t5SZA/r4HhBFsQsBV2E/CbUBf9RX7jjFC4cF1387vOnh6PSj6wiMrq8UmplwDPxvdd0wA6VwWIoDXhydPj5BisoXgJheuqAO7qzFlMWHB4zBQhc6z8jdpUS1g1qlMyti+nmeoYUff1n+Nv+uBYLnd5xiVaCO0X8gZc9U5TM6nCh1ZINA69x8FXnGkLNH91l5au0MpgHDYiF+JhY8G7wZpi/ko1zzBC/YrVhSMUI0/ImKDigUqNUfjhHcxIXMWhBrMPm4A4GYhrhIvYO1huR2B1zQFfdOhDyWq/6e0fvEpKKdmApnz/gAOomBePtELm2jK95b4+1uGkDpA4VCSVN7WrDk2Y7agXVrVmSZhr9Z8Kc7a6RtMrJjcfuze5DHh1U4rMlOZTDou4oBhz1A40UnrwREXuQmX8G3XNsv7puWMQt+RhzvH2cYUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(15650500001)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?oFb5TuojI5XLg9cOlfoyBg+0GtFZFhyVApI3Ep/1AvTjhHIrVJ8GGrwUfO?=
 =?iso-8859-1?Q?8R435XnLmk6mH03uBhw3iRBboblq30vnpBtWF+2DU77yup4hync5EQTOiY?=
 =?iso-8859-1?Q?yo6N4sody/fPI5jJHd2sRHfq1SgvVNv3rjSmKu27UxRkMnARsJYbPXg2qL?=
 =?iso-8859-1?Q?DFlIIGhhMlxz342BNjbAFvKkDd3hiOrPjhtaXf0pweJBePrjavLteMcbFK?=
 =?iso-8859-1?Q?dkcTbFP31VVMXEpeQIIuwIMO9Sk0I/2QPRbfS7j0NDzpSDeXwPU1Y1OXSs?=
 =?iso-8859-1?Q?dgEj7UZkD0sbMjgOHnTG6YaGPIz59/3HW5YT4UbcOiCJFWV26uw66LXUw2?=
 =?iso-8859-1?Q?sXzzXOFcxHXdmmjYU7zw3nTXvErYBX91krsKF2zLTHcfnd7ebV4x8KDTXM?=
 =?iso-8859-1?Q?zG1boTTT4OEg3wMknhD3KUELKKLSLUV8m5NTUYNMsAnxEHvEvYwg2Jl6+A?=
 =?iso-8859-1?Q?E+cNH5SvCMiRy2QfFZvfUJPrr2FRgrlCuWX7VpWJjTt5mHLfd5PMk2U/C7?=
 =?iso-8859-1?Q?JB5r22Ylta049rOvQ77cxC/0k6GS571aouGscqjnvq0GEsoCS6IzViDus2?=
 =?iso-8859-1?Q?yQbSbtVIfef8W2LM/E/lW2ywB2zLnEqdfIJusr7pTopfT1h9oRhvv67sRC?=
 =?iso-8859-1?Q?8LMTXx2KIIzhzHcLGWcEKQ3LYuA1ABLswTrHP1PeYliSCEEYq4VbtDGpL+?=
 =?iso-8859-1?Q?5Ga5lFSCn9TdOgCxezcgQTx5FdCZ04uGY6777vGhbTH45GzKjV2mBvFJTS?=
 =?iso-8859-1?Q?B/M8DEn4BcyQt41+bfCt00dTph16icqO1SKgZl4ujuE7Ix/XDsgAxB7TL1?=
 =?iso-8859-1?Q?Irowr9DN9/80eJABxj5ANYWI+E0O9c8y9TTTolEdFuNSUHXb3/fJr1GkM0?=
 =?iso-8859-1?Q?0tmXqz0MrgEOWfqTqF/2w3kdx1b3qeghB+RqJGuDo0K8m11iXoITsn3eJw?=
 =?iso-8859-1?Q?qGU+xjj3Q/BbxYIv4WX8ll7XZnuQBMMGnlr5L1/W2tHmoMT07aJwVqRjlN?=
 =?iso-8859-1?Q?Z5I9d0fhX6PLyZklPMbykI6iPkvD6bTq69Ub1VsLbc/Y8v0zKzRy1O+vwt?=
 =?iso-8859-1?Q?4kAoetDsjP4C7bB+om7O059yHRpVp45Ox6l2lRYEPAMEQLJdPrv3wHYytG?=
 =?iso-8859-1?Q?VnZaFawfbXqV7Ioxikowe3u0Co/zi5tq8IDW9ndan27tyXMnJZkPNc7Zg/?=
 =?iso-8859-1?Q?jt1O1x6R1D5rQzHBKAh5FtPOUdO6Wv6GvfGadLA6nJIbwVlllAIMJNwoA+?=
 =?iso-8859-1?Q?/s9XLBOzTsFPnI27JnUH5PQCyYvGfP5MksLLookOSHmndVJr7PXbTqK9Er?=
 =?iso-8859-1?Q?j9XT71k7AuuvAL3XJHGfne9lnN2K9u43q42F9i8HQe1cVuJqikDo52dsK1?=
 =?iso-8859-1?Q?mqWL/aB8WsbNcDGDedvvv9KTYIhvGRwWSx4Ogx52TZct9cmXiSoDTOojwd?=
 =?iso-8859-1?Q?W1j5IPxDc4blKbD58CBao8oP6kkzU2tostVewF4iNZc9G+GStVXhtV20H3?=
 =?iso-8859-1?Q?ENYtDJA80hP4wtzHO6hdeAumKorNY5qJq4NiI1zn12QW7q/PWLwpZiBiuq?=
 =?iso-8859-1?Q?aNjZ1ibGp8szAeZQPxsUPaXwhZQWUQOYq8fBYqxXZ2wmKKiaX2lKrTLdI+?=
 =?iso-8859-1?Q?olZzhRHqLzFVd/t54pmrDf+mxkG4dQSkX8O5AOJVVMwtHObXFzdsfiBZAg?=
 =?iso-8859-1?Q?1D957rGpP9RGE+OQeic=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2a99f8-1292-4af4-087d-08d9a5c2716c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:39.3246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAfDTSpIkNkZzWjNsc2HTWXwiZv0U4osTPfRVGyz3uR8C5Tg7EbCg6cGyryzYh1YBZX0EteMtWltk0aY5b7DPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
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
