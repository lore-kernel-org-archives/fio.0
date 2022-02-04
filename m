Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2328C433F5
	for <fio@archiver.kernel.org>; Fri,  4 Feb 2022 00:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356189AbiBDARy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 19:17:54 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2960 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245100AbiBDARx (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 19:17:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643933874; x=1675469874;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ChtZVHpYAoVYAJhascG8C7orZmNWdhpOMLward9HLsQ=;
  b=CC0C9ZJrsBEm66Noo1PeImd1hknLHgMOgr1J0pE1+/8KUUkIg1hznPTf
   9mTSJxZNsdzrChpGao4VV8Fpd9L8oJ1OfUmZmWuwMB2t00pxTupoohKP0
   Wil1TuXTP1c/YRDa0Bhhs4P//0M15lLCIf29xSMewGBELyQWTlkcgtLL8
   qcZ9yX3kyfyDsLPRMcrRstafDECstTQeT53uB3SxIKQsu6ZZltChyW+lp
   jMXZAYNA6ZRxV9Z3pj/pBmsYzFCd8f2WX8BZxOE+1/yPn1sxFxmEPUnEZ
   vB88H7S+v9ai8Nh5qur74ERwqGHChMaVNtyUvMpyoPyYI/okUQWDKR+2C
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193109664"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 08:17:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi0XAATX7+I5Wp41KM0GJKdtkaOjBoEWo8ujBrzrhJrCbbHtACo2Fq0oc0sx2oJQQyuKXpSK8J4WNYZyBAHJZzdsEEv4S6OSAtKUjPf/n048QZrhr2aXksDyIfpNPnmbrrRi2o70Htr24ZM28eyLLZOvrQxmMDx9YCW5W8ZIPoDo2LTpRhwgQZtBGVFA8lFvWlptyf+3kiKTFF/nDHzFByyCVBRWuKb4we5DsS4VYr/scjHUiroAwEtJz4dSv3ayrlAr3exRKjdGpRYW50NceLD6AcUrs89hPyd4ECNdqiEHRmwESD/TlzGUeUDMddKyZRBQPzGYTgu9IEqXX1O8xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmDIcCd3ZvrjlwwZsNQWU+ehswIX1nYmTjQVzdoJ0aQ=;
 b=mViPemKmyoOqb3AACIvtpLbqaVtZ63jz0uUx1Ttr5Rpi+FbLYIF/bvFz+51f/NGB7KZAFdZE3BUjelgoLjBYD9pCkkU6p62s1tOKaym1sCaUc7Onzc6L6wbETOu3eJntP5KZqbZ8OMGAH6xia1CXF2YRF8j0ZUuaxQD6AoOwB//Ghw/VKzflOWhyLE9jUK1+456j6DZUE2PIf1OUs9ay5yxRwGAqRdO4nn4GpdJf0sEh6+wbXGtHnZ/ghDAc9a4LBJBClO9CcyL1K8/U857VeJmKQf9sBwzh1thc4pc2evimgG6Vgv1nypeM/asqL1DM/LwB+mJ0loS1y/alG3En7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmDIcCd3ZvrjlwwZsNQWU+ehswIX1nYmTjQVzdoJ0aQ=;
 b=cfXkUuQ8keJ57SQUWiJlZoaMT+U6erpOctkgw0urpB8YAAaZR/Ugki7+5r8NeP63R5cpn9vIy9X3n4/nyIDQSe8rYYHh0ZUjEkxHxTGhTyhUfRAdx7eoPoqJGNYs/PtGW4KxSCEanQ1iwSNuS3Mo0HHJwFI1Lz8qAmwToWLPQvg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by DM6PR04MB3867.namprd04.prod.outlook.com (2603:10b6:5:ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 4 Feb
 2022 00:17:50 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Fri, 4 Feb 2022
 00:17:50 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] stat: make free_clat_prio_stats() safe against NULL
Thread-Topic: [PATCH] stat: make free_clat_prio_stats() safe against NULL
Thread-Index: AQHYGVykYVaRpJA/okKJSz9jTIUaKA==
Date:   Fri, 4 Feb 2022 00:17:49 +0000
Message-ID: <20220204001741.34419-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c8b02df-ebb9-4c40-39bd-08d9e773c74c
x-ms-traffictypediagnostic: DM6PR04MB3867:EE_
x-microsoft-antispam-prvs: <DM6PR04MB3867C0E342C4055F939CE86FF2299@DM6PR04MB3867.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+P5HsmVCeaqra2CJn6IKpSvBOatRfYN5D8IX+CDbDa3EtayPFn5bYQwdKJ3HqfISIm675ZoCfRDDapFfH9NVr7rXGUujSh/CNvntQmKulciO3YPwQgHenGOgjqZ1gtVvH8JT6G+gqwID3OsGFpB/v09YdrNrx+EUoVrY9x/OHk4BcUIjrmCsLD20bkD1BiZezdvVjm5G09jJASyFhpoEoniGivufiu9FbUgkEn/ScB5/CM5YNp+CwHpdjY82L0S56hP1WnhsTAF1PcxOlwxCzEl6MUTLaFQZMeRHcW9N3Rj/b3ZIh+Fe81NtOL3LKZoh61BFUEhr/3lKzdVaQPrk+cRNFFlP9YAxaG+bCXb3LaHx8aGgW/shBdrOV/6Sj+/aKvu8WY3xATB5GnKRZxWe31+41/lFJKIi6/R0CbQz85vP2JZeA8PTOMAzm3aGjS1N/n8m5jFMSEY6qfRT5hWgd4gK/jO7vo7b1Itm6ZmYELxMtYSuWumqIwKti9TQU1rN5VYmAvp62w9sMOu5O5ZE3COJ6kHG/OjkQW8wBzBpFa1vwEWbfeV1vCR4mCF9JETLTpeF+m7pg8mkM5+KmXQtwEVYnHypTGoaLlwimgxCkVYB+V7q5Vhe7PXezsdMgXH2TEgBJNv5IWTBizVCiXC2yVJKmvofdb6fTJpyh6sa2VwIJ4RhTBZlqlScP8FkRWH9o9chpmBUALhzLqyyfjjiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66446008)(66556008)(54906003)(6916009)(2616005)(6512007)(64756008)(8936002)(66476007)(8676002)(4326008)(86362001)(76116006)(38070700005)(6486002)(91956017)(508600001)(316002)(71200400001)(122000001)(38100700002)(5660300002)(186003)(6506007)(36756003)(2906002)(1076003)(83380400001)(26005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?pSscYR6Vv9Jy4ZjtuRnrKbULMHzXMQ9X0nxbuWje+vQfBt7ywJ3QSSfJoM?=
 =?iso-8859-1?Q?MnQjX1aa8N9RbSlaLttsjXUl7hJGioE3KDmx8OOtMu5zcNco/v51137Mly?=
 =?iso-8859-1?Q?Y785j/JwGAcZKNcDC9FnMw7DvwdQhsQcwEx1kAfs5oo/aqMwCdZRCpsDr8?=
 =?iso-8859-1?Q?sAYR+5xdtQs9FLVy4HkiOno2okUk2KTKCYa0YfAJyybIDiPNnMSxvjPnEG?=
 =?iso-8859-1?Q?Ut+SAHiu4/dzU0SL2geTNbdkTUccpTK0NC4I/4VLyr9m4co0JqesRwf2CE?=
 =?iso-8859-1?Q?k9C9WHkBMgjvsVCmeZEyvYYbEsCeoCNPbVtgwS+KM/A9cgGGGfJk5OhI9y?=
 =?iso-8859-1?Q?46dkcma+ueFwQj1EMR14EUoOO6HKmgVkqdIKpwdBRop7WqYwycpcTFzpRz?=
 =?iso-8859-1?Q?nY2ourk6U0rQYI73IEUXqpArVs4OdDE0ITAmkjC1lwmLk9xor8hLZDI7kn?=
 =?iso-8859-1?Q?Gze1Ny6mUFEQNL6S7+tttTAmTdGewk6TnzpabjgwqN50oN3xlwuouCxAtu?=
 =?iso-8859-1?Q?PpylfgAizcZUDU2Hwh8/nDmoCeVIEErfVS9yZVDVJ/T+EbQreRg5rOuvr/?=
 =?iso-8859-1?Q?TfO9Lzik0bbkT5Z7PIZHQCIXPKlKC/U8GGAf3Xta3Uih0VLiyjdRqkp5Vf?=
 =?iso-8859-1?Q?wpLp/LAojAYsrmTJRNYMR2P9+5vrKdEt5hCGV5NgLzab52oiqk+BMu0Mq+?=
 =?iso-8859-1?Q?spJO/79inzsCpPAoNocIev5BmihZUF518cpDxPXGOwuUFUsy2GKbhNbg1K?=
 =?iso-8859-1?Q?brVTsLgPWrxOps9eox8LQCObZLVb2XmUrOqp0Q1KcF4cTsIfchQ+7c9ZOV?=
 =?iso-8859-1?Q?TGJiTtiptfoQolTtTRxbynHj8vmARRDAOG/2K4o7213/IhUhj2Q4n92cqd?=
 =?iso-8859-1?Q?sqN/E+HicaXSOJLQVYJ20alnTY6iLCyWO1wjDKe3ulvvTakDtDNFEEckW8?=
 =?iso-8859-1?Q?OpnvzDAKaSrUQXP6TlHz8yfNpptx4c8bABwqESYklRv/SuoiYogdhktTdO?=
 =?iso-8859-1?Q?Dvx7tY+L4EHmTMQqrzZErVw29rdwI9buGGtl9aGINHhC1QC6F6PnT6WaX7?=
 =?iso-8859-1?Q?kap2Kqfz+QJI33d9lSUsQBB1dCA7b8exqKmuPcz8qV3pQxSCkZprxhcYCC?=
 =?iso-8859-1?Q?sQcFBpfnND9/dJdY1BBTX/I81bkPT3koNTDLYh4znUINq+DY3ZY6+I2mDX?=
 =?iso-8859-1?Q?Ss4C7O5a0AlX8uP5DdBOyYX67WUQKXz9EXfB8ZOO31adi451wd9jdE0TmG?=
 =?iso-8859-1?Q?N5ZdYmx7aOXgoeiUHj3EqtC4Zn8DDZvXkdJ3uktfbhp21stIyV9CB0wNKJ?=
 =?iso-8859-1?Q?dBGbfv7xoPHJci/WPvHMcwC4APf1glrFmQ3rkeSBk8iKtgYM2I7nVdqMq7?=
 =?iso-8859-1?Q?+loKGMX0ZMGhEs6drXZe5xrokj6xmb2s9+vy9KK48JI6gR5qjSa492rBoQ?=
 =?iso-8859-1?Q?7X0EviRqWjQlC0fo6AW8Y0uWmtQOeYI9G9PnmjSzEwYIfTWmi4jG0qcBTw?=
 =?iso-8859-1?Q?p5f+TIiQMB6p9bCR0sesZvplAUdI2w57YXzmYRWplZkMzvlKGTkobLVb6y?=
 =?iso-8859-1?Q?LnnYmWwVGmUZZdqWRX0nVA78NqGDGxTPxTj/Hdzxe/YpEB3QAVmZ8WEv+A?=
 =?iso-8859-1?Q?ozgFOocr5gL9UYdV5TOYwHkhvupNZIm8Sg+jMTJp8xuZ1P3f4We7M10Q9P?=
 =?iso-8859-1?Q?me+Jd+hoeN4hCo0pa0EU52RpWez/c+1cHImhoWeF?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8b02df-ebb9-4c40-39bd-08d9e773c74c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 00:17:49.9302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R2lRnuWHTsTwRmVtI3oVuPYGch5r5C0BMYV7Q9t5RiZGq3YwPdaXCa1W1N58tKq5e5tH+4YY7ayWu86jznMGXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3867
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The sfree() in free_clat_prio_stats() itself handles NULL, so the function
already handles a struct thread_stat without any per priority stats.
(Per priority stats are disabled on threads/thread_stats that we know will
never be able to contain more than a single priority.)

However, if malloc() in e.g. gen_mixed_ddir_stats_from_ts() or
__show_run_stats() failed to allocate memory, free_clat_prio_stats() will
be supplied a NULL pointer.

Fix free_clat_prio_stats() to handle a NULL pointer gracefully.

Fixes: 4ad856497c0b ("stat: add a new function to allocate a clat_prio_stat=
 array")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/stat.c b/stat.c
index 0876222a..1764eebc 100644
--- a/stat.c
+++ b/stat.c
@@ -2041,6 +2041,9 @@ void free_clat_prio_stats(struct thread_stat *ts)
 {
 	enum fio_ddir ddir;
=20
+	if (!ts)
+		return;
+
 	for (ddir =3D 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		sfree(ts->clat_prio[ddir]);
 		ts->clat_prio[ddir] =3D NULL;
--=20
2.34.1
