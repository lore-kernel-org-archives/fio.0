Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D933CC433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BD7611AF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhKIXlS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43927 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhKIXlR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501110; x=1668037110;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=5T22S5bzoGWkix60MN+IEWKrvfcQCPbzDqmO46tf7bQ=;
  b=UihPb+su0j9wFcsE/vUXzrCHSC8VszlJI/JU90ztaUwrGaQvianB2QvT
   XM3bms3/lQt7BCW0hND3Mual+1gH2Wz3kOzMWGX8CivHo46OQw+3U9ozG
   ER/4fSmb764Xu7/VahBLuYDowiZL5Fjm4TQxKuf574psu7nTJ3pwKbnyh
   j0SgWtyCAVsOKtgkRRTQqXMIIbhbtqjAltDZ6sy240nDwy/raSkoDAUgb
   GEoPn6xw4/Azxervqg4hrp4SvKd1Xp618bKpmOswtn2KSkisobBgKVPeS
   h9d6rtbITggKTn0LBwO/s0+ZZjia2wG7TWJl+DKaP4aMB2GV20i3j12Iy
   g==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="185172211"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X65Abq6gmvU2zjKpxc+thSHzM0Szj8lVxZIzImnULiycah3b+XlfB+FzdLxOhKR2PAEDU4CAQ6hz3Vw2qI5rZ0Z6e1kbFHylj5nmpAosFGObu9uDVhS8j07yF0H/TPO0I9gzoK8ody58L4hCdwEdL2TE2N9QWM3MIJOV1o4OAEMIw7k8msUsQc0vxct2c4zJKIkvn6/duKJZmkWqYMGBEuPUTeF88TFODhnNEnXCKOuEOG41w7I+rJvs1sOpF1VhkbDPEiGQElyJBzw6blnof7DpNS5rKYcoHjhhA7zkskqgv25UdUxGlctzv8jQ5QA5rcJG7A8UOFxX8KslgbuKOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2RNS7ZWFTgW8MKlhR4e3uBCZsCfAcK8G0jyhutCR/s=;
 b=k0UOTatN5QLMP14JHRFDRYIrDK/wby/x3eIofMyvE5fAwv/6B4fvKBBz/1GFhQJ9JbJm4oztmnSe6QYysYJip0KRxOyNkBS5+zuvpO4q2OdLWBBdUFO4zo7E2Zjp+zSbwZrKL2N3/5ljKLG4m/G3inGLdEJCrAUBgqWVdH7Wd7JTho6G1qS6jikw2Rl+UvgTKEWTIpr1nDtC+95pe9ID4wa1sUlQ5IRQzf9D/u+yT4MhTkoMy1Y5R5UNyQ6HT8MAvHhVLjpqb4owADWkSb82UZ+yU8yFgGasePE91erYLVF3B7YSD08GKOuzjVCYsk4Muy3ZRIlRvCcoURp2Ily3oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2RNS7ZWFTgW8MKlhR4e3uBCZsCfAcK8G0jyhutCR/s=;
 b=fvBVY/B/pGdDx2HZW3yzofn5+EVEJqTHmXt9uSkKkvejgy5veXgnBDZ/2l/ViA9ee18eahr2Mk1Hrgv/3fnhrumZx0WqzBDeocvuiPt6FPMhX3fgThOsjTq2Dh8LL/XyDdIfl4JSUUl8yZS7brnZJieacqTT4bTkT0D072uy6wE=
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
Subject: [PATCH v2 0/8] cmdprio cleanup series
Thread-Topic: [PATCH v2 0/8] cmdprio cleanup series
Thread-Index: AQHX1cLknhYE6u7NDkW2PyoIVHN3Yg==
Date:   Tue, 9 Nov 2021 23:38:25 +0000
Message-ID: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9109f03-45d7-4136-55c2-08d9a3da06b5
x-ms-traffictypediagnostic: PH0PR04MB7736:
x-microsoft-antispam-prvs: <PH0PR04MB77367E2904FCFA30CB71E1F5F2929@PH0PR04MB7736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LhhL6K577xUQ6noVEhTOxjKX97hZnc7Ajz/+SoWVIJV3IIm12GaqmVjCSQXsMCR2jXfyDvPagR0MJuEMKDYfwom16kx5Ygr93ePoMfxNzn9YaaIpR+WP2EqnXUUID+I5q49ZHoH9KKnb/ZVDo0LXg2g6l7RAcxwSE2g4+HyqWlzWa+IPHCwBLcmw44YHgAi4jGBWhHV8KnLvIbIRiOYGDseWg7IFGWTbE2IUu6h7z99bWHFTrNY6Q1gtvSeTs4kmtbH6zEURXW/WztdhdBM3wcb6DDrD1w20BlY+t8O3YXratocNBDan1gRKPsnBXSiX0VxYn1j7bkb7TKyVyBJDW/wstqLU3T00e7BD5xZHRxA3ISvu6M2SdWngIs5nGEH+f/dCbfTTatwJmSoKQ9jhgQ8mOCnq0Orqdi8FBFvCjUo4O/DUtWJh+YVSDr9C/EY7DcFpU0NlOPaQvf2h9ADTSctZc22EX5sKZaOVBhv6vlpldZq7wZBc7rJIrTkLJCAWIFDnjI1/PN4ilSYSs95gdRPMahPI8UzTNtCXwrmKhV2w7LhozslAr3+ErBeQfT1EOn7Gs/47WITHzaunmILMGC9aYwg3waEmSxdFQq10h2E+vCEKLeZa39szuwlqnpJU8Xyzzcqob33dq5K5oJJ1I90oCXvRPxr2ggWgw/8/AjZtLlZFmnG4wNoCTz4oLAF7sGNLxmnPHzmx/zXMFlgjEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(508600001)(8936002)(1076003)(6916009)(316002)(83380400001)(4326008)(36756003)(8676002)(6486002)(6512007)(66556008)(5660300002)(82960400001)(38100700002)(38070700005)(122000001)(66946007)(6506007)(66446008)(71200400001)(66476007)(2906002)(91956017)(76116006)(64756008)(26005)(186003)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FcmIx1rdX+EW1zxtuAgtAJNKk4o/GZqfxixG+x2Lquo0+AIf3DeQyLY3mz?=
 =?iso-8859-1?Q?GWlmT0yBTBU8/R0l1CnSAQt7X1XaK7R5Yc6em4LU74ic/eepoLlARIy2+z?=
 =?iso-8859-1?Q?g8bGQ9EQVD+9I61FuhPGjHoomjxV0CceDt1u5yCmW3yrRYoHdaU/4/pTwo?=
 =?iso-8859-1?Q?CTxfsQztg4O1HbBzZYwknFp8MSz/laqTLRJIMa14DzaKRA4zS1f5UI2c61?=
 =?iso-8859-1?Q?ES397wXjRiKmrk9UKFGLer53XmCqO/c3smUbSIlUmDXt8YYUZ0IfYyw9Vz?=
 =?iso-8859-1?Q?Wr6bMlnEZXecYfKn99yu6YKgsVC2KF9uDW5RVGUHlqJdPDBDBB2xvHuBzU?=
 =?iso-8859-1?Q?JSCS5Ks+T1P2IEVT2CrX5dn5FoBdbfQAJRxpgGxIt+/Ah0L3s++2l8aM8F?=
 =?iso-8859-1?Q?MtQO2PWKXAgRoD+AjFSnPNw19fdo8jsZ85a9i4z5NvcfKuoQHgrJ+29UUO?=
 =?iso-8859-1?Q?oMuemBwBo0kwBHsU02n1YoZW417RUxn9epYC5ef1bDq5wGUgI+GIcSMhkj?=
 =?iso-8859-1?Q?5ZIMHCGq5tAwOLyMI9cBhPNAVIIPj3Kx+adlzqeQwGkLrRmH0jtfkcnwif?=
 =?iso-8859-1?Q?328PEnCmSAHndjXTIU/Ob5pii/hIT4LJSPeA4WOSsIzoh+9xJh1IC5hTEK?=
 =?iso-8859-1?Q?8lT6wY8V36PoK/48MFCIn4VN/u/nrMC29AGAuRRMXs4U+pdRR7bu1jIPbB?=
 =?iso-8859-1?Q?xB/t4oQQJygVg/tJC2deWAosVwlUaQSWECgIQJg9Z0DIIIPDfhiYouMxWx?=
 =?iso-8859-1?Q?+T4cgw1B9CtkTQ4E01NhGfV3ExMsXqBNsQa0IUSDfGPV772BBNcTTAfZva?=
 =?iso-8859-1?Q?Fx0DYRNArFVKuKut90Fs7t90mW29iuG7syappx20I5zBJoI3Ijq/OqB6gg?=
 =?iso-8859-1?Q?gtUE6IxU8doIsgvhXxz5+Pgj7pnyFQoroli9sz28PEUZFHEX5cJhvojkEH?=
 =?iso-8859-1?Q?W789XT8cuMGvQ8pZyosAHwFZKHAf54oyrwZ5fzfeNMZQmb7t3aXK3pJisb?=
 =?iso-8859-1?Q?9bNa7Y7y0bwN0D6g9PVu76e4my7VLeqmnVAO6ZY308SjosqAXoT1pQR68N?=
 =?iso-8859-1?Q?y7puTTVfst4VQ217UNcIRM6cIF4V9o/ZmsVYVnlgsmStLSbvKY1WU70zMf?=
 =?iso-8859-1?Q?dyTxvMA/Vpw1nKnDDSo44I0YXwV6OnZeAnBFOyMfbz0aL+V9p08SiSduTy?=
 =?iso-8859-1?Q?dO8XEvpkTHyYL1LS4zBc1/GAFt1J1zU88QqU/jar9PYLnblp9Ylt46dShN?=
 =?iso-8859-1?Q?94SF6qb0kixDegaP+U7kL7iJ7yNTTEYvlNcgPJPD3UcShj+7v8nl0BbUvi?=
 =?iso-8859-1?Q?knBDGmjgd0cFRU1+c+lxRHdMcfKVpyRDhA3i58/FreLkSNOzgubr4pXRn1?=
 =?iso-8859-1?Q?5lrH1J88k7RH3lilLhvqUYbn8NVtH8iQjqtiZ9MedSrddjfxBGFlZ0ESo/?=
 =?iso-8859-1?Q?ycIbeEGB8RrikbQ/m5lII8shiIUpU0HKV26/Z6e7FAMVRUQ8Xy5z5MgZla?=
 =?iso-8859-1?Q?vztukGTSrHSPmjjn17SolU27pGeiPQgxqjRY2000dDrpfEFaAQnCHGVLUZ?=
 =?iso-8859-1?Q?t168AgI6TU9GijwK/apv5BWFbudARy87dfMhLwOM1fVT2J1bSFi0pbntgH?=
 =?iso-8859-1?Q?MdZzFiABcOgAhn8dJcbA+pKqJWkDySioPHktZFSVHW47sTfVYa3KoDxskq?=
 =?iso-8859-1?Q?Y8YI1FrvRT7nIhfAYcyHQERNTP51fNPI0dbc1TCr?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9109f03-45d7-4136-55c2-08d9a3da06b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:25.8818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gE2PxkHan8YFXT6CXFxBbMdNODyZVqNRDe2NlIwozYRl1/0znWDRvHa+iOICM4RvVQG+Borhv7jMA7W8AB+Tpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7736
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello Jens,

Here is a cleanup series that improves the cmdprio_percentage and
cmdprio_bssplit options in libaio and io_uring ioengines.

I'm currently working on adding support for multiple priority class +
priority level combinations, however that series is not quite ready yet.

Getting this cleanup series merged would make it easier to get multiple
priority class + priority level combinations added.
(Because AFAICT we wouldn't need any further changes to engines/io_uring.c
or engines/libaio.c after this. Most changes will be to cmdprio.c and
stat.c.)


Changes since v1:
-Incorporated review comments by Damien.


Kind regards,
Niklas

Niklas Cassel (8):
  docs: update cmdprio_percentage documentation
  cmdprio: move cmdprio function definitions to a new cmdprio.c file
  cmdprio: do not allocate memory for unused data direction
  io_uring: set async IO priority to td->ioprio in fio_ioring_prep()
  libaio,io_uring: rename prio_prep() to include cmdprio in the name
  libaio,io_uring: move common cmdprio_prep() code to cmdprio
  cmdprio: add mode to make the logic easier to reason about
  libaio,io_uring: make it possible to cleanup cmdprio malloced data

 HOWTO              |   5 +-
 Makefile           |   6 ++
 engines/cmdprio.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
 engines/cmdprio.h  | 150 +++++-----------------------
 engines/io_uring.c | 100 +++++++------------
 engines/libaio.c   |  72 +++++---------
 fio.1              |   3 +-
 7 files changed, 325 insertions(+), 247 deletions(-)
 create mode 100644 engines/cmdprio.c

--=20
2.33.1
