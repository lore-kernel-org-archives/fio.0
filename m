Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5DFC433EF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7785660FBF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhKLJ5h (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:37 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33518 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhKLJ5g (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710885; x=1668246885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y6FFB9Y7BdN/rf6t65Zdk08q2Cjy3MLCoy6ZW1Wd+6Q=;
  b=ogPpK3F/AspF/mO+uGKVEfcW8oZ8aZrm70ACTtDIC8qrZ2EEGRptyjAV
   Hd67B9Kg4OR/1y0oxfCXWwNdftX72ZsLZK0vGJI1c3SfFfSTDmF7f6oS9
   19f1ttW+5XJkgwUp9aYbtoVeODMZDIso41CthGtKTobJuTI2mNAvU07Ya
   nLrgR1qoUgz9D5NoNlewPd9ONPPvLSKPBPvat5O8AtdYUJQddcl55niFN
   f6sQHoFIalDa74oafSvXqjJUw87l/gkuaacYbNqO7wz9m/Yvz4FsXSnym
   yodWOB2/rm1ZF5gDvQd4kJTaTjXkGqAo5Ht3UUT2Jrdrq+P9RHSHWUgWn
   w==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="185430180"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPgD6HnUCBdHC/HmEwi4Tn2zApy1tXTIzLzsbNS8zrmGkDYM6Zhb1bUyahAgWhoV3LNI3fN962bOnoAWu6xwODuIHE3tKy02X2y9HsPTgAyE6qdmk5aP57G1lxgoEkKvuXIMyWcXSYQvEx1e4mvGnfOnAHePjKw1WhDJUtDRGHWAtn2cNF9L3S0NWxPbE7tCF8H4DQpRRHNCP71/BvN9R9vH8ySWQFFICI7lDoAWdiOvKFnedLaE8rON4qhRWywsExck4dW8T19emP/kzX5j1KZTb00XY7yQVYg7H/iaPX7vf7SyYm08clh4Vn4iG4uuVIt011J5aZ4CO/ks62taGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbvaj+CLWwqifFe7Qg6DKOWrr9wMkSAsJQKZva0+IDQ=;
 b=Xj47aM4iwJ4V4ab303gexpd3KJsxMs1GWWWOoK9EIUKgXOEW+o+zobBQVDjCBPeRfYanHHb58kQHEz/k0IUeA6ioIbdG861J73q08kkktyN8L3vOb5xGXCnYbbc4Jwg8djsoqjm+OcLLegILj37Yu4sW0qxftEfcd5w6LkUQrnyDMbfN65SAJ5Crv+GeD99n619XrBUUEdSX0DgWqjvIo1enSHx1l3MD0+DItDY33yNDHAKnH+uhMT+qpAW/wVf0B11K91vqkcxvTk+G903R9ts57Y6fYnFuBaitx7lsT5nwKfZtkuy8ETVDAM9Mf6DHnNoVri3vK1c2royJsdYnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbvaj+CLWwqifFe7Qg6DKOWrr9wMkSAsJQKZva0+IDQ=;
 b=NjZW8hxN1r/ksl1D7gR7Ts4RUMFmjHVd2awe33APlmoah/BgzeCj+2KJuwbZL6ic9SNlJtzzyQVb12bjGJQO/z1M1YKRvLhqQDK6QeMvQ3fmcljLkmhmOlUuXPnxpBKRPr1IyEd65DyJm/62OauhqFvAWemE7fteZccWqoVHs4g=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:40 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 3/8] cmdprio: do not allocate memory for unused data
 direction
Thread-Topic: [PATCH v3 3/8] cmdprio: do not allocate memory for unused data
 direction
Thread-Index: AQHX16tPAq9noZmNlEew64OcD35DWw==
Date:   Fri, 12 Nov 2021 09:54:40 +0000
Message-ID: <20211112095428.158300-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 198b8d64-7026-4b48-cfab-08d9a5c2724b
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB743349D0DDCEA647BADE2D7EF2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F0Oa11bzgf1tHxsEvXUHeaziUn6EDzltNNFnrLWpbiTA2Yf0C1UTU5WWsSmdDrEdhUl9hVC+pZAOOlrmiUa2Rl54HpDUFuDrXMuRTyX68yANzptexfYLz059xTiCIgsax9yUblgkLrtpvY4JrKf5Z6FUg1OF3gxy4Kx5JySc9w3woPJWFcLLSTpdiIlcPRq7kxXO3SdmT2nXfpLlz290+H3zpPViowXP4B8IZF2mLGvtcam9gFq3Rygbr27cYfyT4gtezxINENfibD6xXMVSlzfcOEIuzUSo/nSaTxciDyWb35RW6ISvn/XZSsIxeJ29EFTqbC3V4TbLi6HUfq2NuId9anEMkWxZwRI7m8kB1HeigiURCiQ4jMa0KVzfgD0a7QOXJDjBvMJSV5j2QaxNesrwLk2+RRJ95IR596rV1HtC43NUlhwgOoNgw+xpQJ4+A9V65e9ZCQ8xMbKYYdlLf9csC1AskfoLVvfyP0ohyS5WUz35el+nWRqE48fHtDvc8UhCxG8zTUVcULecQsA6A4CfBsNc+7kgZNIPnAxs8VA86NE4F7WTHyLOILid8eexjX8YS9BevyZOWxP7gRsyH/17LY/N1Q5/VU4u1R289jQ3V89j97qSPNK0FAs7GojeyetkZi5AvreXf1kq5pdzlYIm9LmXyFZGww3++SaKa9Rw4H5l7ElOR5Tdm56pOKvaUFHp/DxK1jbdsz9T3eSWaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?cI8ItZsspmM/0oVktmVn8i4cZHtmUMhlCIbR/I2Cdw5xlkxXY9rU519TXd?=
 =?iso-8859-1?Q?t2QjPUn6j6kH79pUN9iuiOnilqXO9FvLxDUpd1mAI5a2YzS3OaFTaXgIIm?=
 =?iso-8859-1?Q?cQyCirXJCLkoWfup/5RSe4zxP3QK7BYlpKLVlQtEPwhfYUKVEV7971iRbn?=
 =?iso-8859-1?Q?MgPLIxUR1onNp4YMmn/S8yaAzLiUGnU6ALbGBOBiHzAIOvgw2dA7M34zXU?=
 =?iso-8859-1?Q?QZ3XdUBxeSVwtUODD2sqgYpxLxnj1lFSkHUSKBN5lQejKBHSXHH6P/AfQ2?=
 =?iso-8859-1?Q?6n60xKK9iZtVZTiQw9AJMaE2MG0OkwqdlHRkFfllbFeu9kZG1KjZvPFOWM?=
 =?iso-8859-1?Q?N3xbfc4QWVotV9rbIsLtj3jI/uRdZEik7WhTc4oitBBV/hzhwukP7rvSjy?=
 =?iso-8859-1?Q?hKyQJqIM1Uq8tuHfwqsyi7r2970rQOfA4pBj7pbByyoo2XcfpT2OVyCGmO?=
 =?iso-8859-1?Q?8gQzr4RvaCPZpk4MyCXJ7vTrnQcyQt3lTuhTs5jpC9+faJx7850TKnl5AX?=
 =?iso-8859-1?Q?qDIxPVzFy9B8rlEFDuZOKw8b2EZI+/Xut3P1VgXLVdOuHKdis9CMr7W7bs?=
 =?iso-8859-1?Q?/Q9ohpW4CllcmInxlTpoDNSqDffoEAwutNazCcZmSL3hj8kbI/gG/+r4AS?=
 =?iso-8859-1?Q?IQBsxk23uA5Mjtowi3LtSwpt8kGYUbAzGL6hIALGjBToneZj1apLCxNttS?=
 =?iso-8859-1?Q?eTKCL6uhzLwerw/yyvyjiSuSPAUgCLylMoGq0pErbRoH3Gotd1ZEKB/OqU?=
 =?iso-8859-1?Q?LcdjukrrIE+EITgcJ1c5y2uNdmDpz8RiZ053W0Pe7UOrPo0dxQ8DpsGrck?=
 =?iso-8859-1?Q?KEukOvG0meKTFj9q3nes3cS62RUTw78ZhexxXwYVtKl9Z4CpdRqTe7YvUC?=
 =?iso-8859-1?Q?mspKlxxMLvbB30wO6MxFgsTcRAZ6FFbRZtvvZhnkk/iGkGKR3kw9tji6PL?=
 =?iso-8859-1?Q?ipYHCyEH48DZmuU0vCCsVyr/fbXp+533j4dpwRsKlLx3d0HxcvxaTv5GHj?=
 =?iso-8859-1?Q?4B9kRz3AwlLUcdl46UqeXuVGuBXEKAZko04PIzd1wREpfuo3Yq16otOCde?=
 =?iso-8859-1?Q?Qkx/Fuj5+xJDI4GxYkIyAtPJOg7t1OKKK0ooCmLqzB0xOCbIzanwDHEFOu?=
 =?iso-8859-1?Q?KxIyhb+fXLP3amjGW1e3qj/VXf2hYHjCClL/LdWgdPqSoiCFkvpJfwlR58?=
 =?iso-8859-1?Q?T/G2Gqp2udCu0tPzpMy+ZUEw141pUfPqWiypi4yZMA3am15bP/qzZsRiTn?=
 =?iso-8859-1?Q?3kCXyB0ViRqGL1pQy9pSjFCP1sIuRi8SBH3qok/qIBCm1ESikFPsB6vIam?=
 =?iso-8859-1?Q?cOXHjgW+NoaNfZo0BxlKTYz8CZpOwmX07tcgjVroFIrijmrQZLuXOvz+F4?=
 =?iso-8859-1?Q?LUa9/LGLKo3e66JNpkPqRH8UjPMqu+ffPJLGAzFu29pvB8sqSVvWj9Vfi9?=
 =?iso-8859-1?Q?3Y1X6oDkQPQDezcLE9NedS2/5jmHruvw1Q8OsEAafKiZ5MoJurbw3O+sSK?=
 =?iso-8859-1?Q?IaRtiRgUvXf5PxKcYZna/Jkt/NWPxXXjmJoJLUzugWx54CQvCgv2vPyuqj?=
 =?iso-8859-1?Q?DY7ZvM8l/+J3EDqwL1GFNxgdlDuIr0g1jKRYcOlV3GakOPevIrg7jkQsjF?=
 =?iso-8859-1?Q?7P3iXMJ1G/8Ds4zi1w6p9JS03YDQYw1lIgF9pRaXxj4xjYlb/W7VmAL+oB?=
 =?iso-8859-1?Q?f/KZRammc/j/EG9J9pE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198b8d64-7026-4b48-cfab-08d9a5c2724b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:40.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06QVyf5ITRrF0bW0mp373PgqihIB4l2f20WHPtkNYEVkZMDIqt/NVg5ieK4MntEM7GOQ+wFzwquh43qn9zeaNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

All cmdprio options only support data directions read and write.
However, each cmdprio option allocates memory for ddir trim as well,
even though nothing is ever written to this memory.

Change this so that we don't allocate memory for something which is
never used.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/cmdprio.c |  4 ++--
 engines/cmdprio.h | 13 ++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index f5b7342f..2c764e49 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -56,7 +56,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, con=
st char *input,
 	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
=20
 	if (parse_dryrun()) {
-		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
 			free(cmdprio->bssplit[i]);
 			cmdprio->bssplit[i] =3D NULL;
 			cmdprio->bssplit_nr[i] =3D 0;
@@ -101,7 +101,7 @@ int fio_cmdprio_init(struct thread_data *td, struct cmd=
prio *cmdprio,
 	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
 	 * is not set, default to RT priority class.
 	 */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
 		if (cmdprio->percentage[i]) {
 			if (!cmdprio->class[i])
 				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 33a8f5b9..d3265741 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -8,12 +8,15 @@
=20
 #include "../fio.h"
=20
+/* read and writes only, no trim */
+#define CMDPRIO_RWDIR_CNT 2
+
 struct cmdprio {
-	unsigned int percentage[DDIR_RWDIR_CNT];
-	unsigned int class[DDIR_RWDIR_CNT];
-	unsigned int level[DDIR_RWDIR_CNT];
-	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
-	struct bssplit *bssplit[DDIR_RWDIR_CNT];
+	unsigned int percentage[CMDPRIO_RWDIR_CNT];
+	unsigned int class[CMDPRIO_RWDIR_CNT];
+	unsigned int level[CMDPRIO_RWDIR_CNT];
+	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
+	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
 };
=20
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
--=20
2.33.1
