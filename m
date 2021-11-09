Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A63C433FE
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B737A6109D
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241225AbhKIAa7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:30:59 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241223AbhKIAa7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417694; x=1667953694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ofQBpROS6QntrQmQ0MMDvTuemBN1Sm6oYheqmkgih0=;
  b=rWyfD85e82WwUJvXRUVCKIaFEgroEL1Dl7BYtQh6du6cxO+4dBLgEw9D
   4wRbO5UJAEySWfModq2nxTR/6eM9q8xzs0yybBxk3elAEECS9IT5mMuP6
   qvwj9oUt7F9LhGrWSK4NGQpcE/7m4O7RK/uizknS6uSq5LioZglcOGfML
   7YHPMVkZGvRT4szA1muoDZvSHl3bK8S6bLJECNMCk5N3cPvlh4x9TxZM4
   1DB6opeEhAn4g5c3mGc/tt6qaDrHl8+iVZMhc0dNQP6V5Va81i4gRvf5b
   VjUdYN3AiYuAX8PMrjSiyAQYtE+me52ibNLKhvDGRUHXWjzrq/E/4w5dU
   g==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068527"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zla9NmIdrStDUAdy+nskOzxG7c6ByalYa3ASyN/3VnEseM9njrqwDvT5mY3PL2x9m1gFjAeqdFfajHru3Ur6vJ8Mfg1apWVfO6Fvpp4pAuzrUS6hHAZlKpqv3RYqLDPtg/nBIOACO2mfkjOlOKyi0Rsv6FUdCY6UUsjYM2F0EVZx/jKhtzo6sxOKtpJ2GLbUfqJyeKRjHrnIOIA9nczD8AHuoX/eUBYlFhzN678BKU3yJgz7Zb76XIxRHgbva5libqZsz663rkG9JjYHJkRsRQ7ApjIFwrCDCXnmgddzQ8ncT5Dyqwrxe8lTh7nnfRCHCH0kHla5wPuKP++RQ3GovQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFiaUlaRKYfF/WXudDrM7Cln6qyJCWDnkVWugnQOfqE=;
 b=miuPAkEAJ5IEQDMgEyKj0jtTbhdUcoZplyeMo4zn9RzDYTfo3oDnkVSUQN/Vn+xIeIqPk3b8asEgROV6EKM5uSiTs3yqlG09rtJYozjl6ZceTwpwNdSdDj3lUiZe8QIAt6ceP65PNXlicMDN8kF/Q9851FqhkoAbwp9Cm2IHK858fbVy7dPAHneGxxpK7v+IU2zsBelogH3COLsVVNnuOaDeR0zMeADtFXruk1xDg0E+FlAG2Cn32PbbJqRyNmb/66sgn9CTGbtEKBi/IAGT8o1OEtwHjOQeoKZ7Iluw4RowIUV8g6VejYvCNvNDussVnuEUtPzT43/aRbTKrRODaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFiaUlaRKYfF/WXudDrM7Cln6qyJCWDnkVWugnQOfqE=;
 b=Uk8mMXcGqFt9nfgHVpvDqYJeOqDaI4afry+oXDmejiaF+XKI3LTb71RcevKmKYedskdfqdY0zocZnSogKXkUJHNI0RfZheHoqedVxmmjMK6It7s97m1IohJ8ptIzo8BSmtMZ/hEwsIih3jyDwXVmocV+k/QEo8pe7g9yNQL5hU4=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:13 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:13 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 3/8] cmdprio: do not allocate memory for unused data direction
Thread-Topic: [PATCH 3/8] cmdprio: do not allocate memory for unused data
 direction
Thread-Index: AQHX1QCuHLhrCbCciEyIUINeBadClQ==
Date:   Tue, 9 Nov 2021 00:28:13 +0000
Message-ID: <20211109002655.117274-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: c4a3f7ed-6c88-42dd-315f-08d9a317d0ed
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB7144858CA5BCFA7634E3E413F2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VqIwvcFqmBQW+cwok655wR5KRmZzJGCwpdN2NM74MzjW+2kSLJ9VsVDeyIZXWzFGBZ4ieN5zUfHEJOQ6/O1xwELESrjnb7OnhL0fIBJUsTUmQcYzTlr3o2H9zfIfb/t+PKGK7uL7pprzLKluM2mu/1VccTIO8CJzlmFnVN7ch1vE6cLwcY/+J4KLGxs7srAQxQnI/baWPOIGiKYFDQU4JiEztZ8ozf4/ZlzhJbMpVlT7lwqEAabzVGQ7YQFkduseMXIwJjBPbwVknrM1PzUr5hPc1npI1m2AMd0prW7wpihywYGX5slTGfNfAGDvBqCo1vdAVNyD1XcfvpLo8XHPUJnNJgnlBo+U4GBj+03b6G5+O+L0IuwG5AtJgouC6PRnFajdHh9LOlknBetjyASset/P2GwKdBB6mLe6Diq4CHyfYeF+MzXwLHBR290ARvMjDZJFTiM+9oeA7CYbvruwg7V22m68pU97KowOCtQC/kHpP5bREEvkpQVdQ3OyvG81dhFYAiTEwyhUfOAJukxnAdKWVx0bIfynJLjWHkLX8xNz863JUZEfJdtStT99qmAqUTQsSkOkqWGm784cphaq6zG8T7IB++mvk/maUeUKVKNVPYqyDN7oWYgVQVz+PY+gAWFI8sff0y2l1p5jvKC73fxZQIHxywU4RJXbVir355vGbcPO/E+VJBeZhGl7MfLVHdhyjYrlRiyLwdNWdjORWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?GxmW+ou7sVL/HZAsDwtPLkuF3ob1HseRpnRMwv1kYVnP5P1DIKjjQE8Oh0?=
 =?iso-8859-1?Q?aoInNqe6TnJFdHgxi4bsKtcfUatFf7d4vM4CU/LPwbBOPiN919R/Z/u3Zg?=
 =?iso-8859-1?Q?IdueIAx8g8Jw5CDQtU3cOWsyiDW0KVuN2DzQOyYboZa8ZsQ+oGVdY9MIsl?=
 =?iso-8859-1?Q?nESXoE3O1pyP5J6jFQiCSi6BZkktYUWDrKUETxj9iqVletoaKk0haCxyj8?=
 =?iso-8859-1?Q?L7ir2ScEA/wxOxesGysmgTQWD4z9fZzTMozHMKlpOE8JOt0ne/m2XX+7sG?=
 =?iso-8859-1?Q?8mws0yWVbR8q9KbizIWA4ifgb7O1CsGQb87qm1M4nTCa2MUqYj0ZyYTQlC?=
 =?iso-8859-1?Q?52gBD8cCI6q1wun2sEZjvZJ0sAyw8h1l6OydNfB6denlNpKy+lb4aJ39ss?=
 =?iso-8859-1?Q?78X6rl6Qhd+q+WmcWrq6/alYxhFKcIBd5OC/XizkKCKqmrCAH3qAxCens7?=
 =?iso-8859-1?Q?pIppoPQ6XoMwZp3BIH4GW4687oa+h14Aos9vCY11m8slqWpSRKGDcrHHB5?=
 =?iso-8859-1?Q?sLemdj3Joyew4neFzuBbY+LicNGg0nFsUsUp+/5j0xwZISbfXNBoMf9JSR?=
 =?iso-8859-1?Q?6FkXN5LQGk/UKbawFbN1kvSq/2XEEE8Bi6DTundYzA07OFUdys0EctkFKy?=
 =?iso-8859-1?Q?83tJVKF92nHxoqzbDQoDGGDZaBZXp3Z4R6ZKOC2wGPOz0nA85MBIu+g961?=
 =?iso-8859-1?Q?kHYnEBljhUi8GbwTuBxWm3tszqECt0Sl1divR5hYefQGsMgHlKdaekIM7o?=
 =?iso-8859-1?Q?nDNctdFkhDya6L0F3nVr+TqeDFHg5ETtKJQecLDLCr7XKqJLfxPxiG9iKu?=
 =?iso-8859-1?Q?4Gx4/xvwu/n580hV4ucBfQHCYeHuSMEOC9HPp+YxNJHcaNMudBy4G7A7Ak?=
 =?iso-8859-1?Q?q+sjT+v+6MPbefSmRyRlCXtMrd0djv3pVFiHpOx4sG79JlK6ZK8M8mdOfQ?=
 =?iso-8859-1?Q?G+slgrEu4fgYAUoDQVVEHWAdKIEq4/GXIoR+atUl+5/WX8UZquoUBaLqde?=
 =?iso-8859-1?Q?awaFRtDkoAWVLKFwQISSWgsa6haCcHlpFK64E0rxxypJK3CBXgPTU+FBlq?=
 =?iso-8859-1?Q?Xqc4r3nF+Ecd3tthariPGIVd9MxgmzVlYQYHNDDQvgWT+w2qRiLtZ1/vim?=
 =?iso-8859-1?Q?VWn5aWIFewOsmiDBM9PMvwO/zAnTG2mEuxmcfWTGl6l6GNSrkcAklTKUXl?=
 =?iso-8859-1?Q?Jh0fkghe+TqXBSxLjJQSWIY8xb14+w3Nj5joaWi2Yx7rKCZxxvbWJXRQpJ?=
 =?iso-8859-1?Q?kQfINAFRkdfF6RymC+Y/I/rwFbmQsUln1uW2Nqj5EfIIB4i1SsqX/6fcNb?=
 =?iso-8859-1?Q?PaEEvqHJ7w8tAXszaPZaJdzo0DCACUDfNplvL7Xfutk0lCxPCl/MPOTDqs?=
 =?iso-8859-1?Q?XooSgGN3eOc8D/NEhfwUhmMgj9qa/UotiKAv5GG4ei4f3JGIJJjYYdG0Mj?=
 =?iso-8859-1?Q?5Tj6RRX5qt01HFmu0gcjU0OKroUqiO36xwVULhI1dGt5dOM5WB1aHuhoF1?=
 =?iso-8859-1?Q?TuECt9H1QjLeMFckS7R8/uTY/1Xxxa2oTnwGjimHA9t/kv8MVJC51NPSIa?=
 =?iso-8859-1?Q?QUJBer06VPdZHF15SMESi8gMKQW6wXg4eiDe2+9pd1hqvT2PKLMefa2lxI?=
 =?iso-8859-1?Q?CFUHWsU2LSKT4jOOeEniAlkvXL03pK0w77z3UVnhXKHCkUn+jQ40YxJ9di?=
 =?iso-8859-1?Q?vQxf1K2V/+DZBvek5gg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a3f7ed-6c88-42dd-315f-08d9a317d0ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:13.2993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pt2Ozw/xAwgixazc/41YzxdcYMUvQ1798yeGPTpdHz752Pd932RILG4arTT8mUwKLAwoGyha1FHEOuiNssqpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
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
