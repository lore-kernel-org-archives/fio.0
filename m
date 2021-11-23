Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0472C433FE
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbhKWOaj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:39 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbhKWOai (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677650; x=1669213650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fzes69SeeR0i3VAqg+YjXS1snBxyHmTiZ2ENq9S/JFE=;
  b=BrCDUbQdWiZbPm0UWZCxvYn6CLKTPIra+JxOq5Zm2qVOn/7oOo7Io3ZW
   RiA3oP1KnwAtQWUNmu5Z/QxfO2ftsn/D4iQv/V+uBpVsdVOkq+s83D1TP
   R0PsUjnHY/rNle9pfzr1QmSyincEjgM4YQ15uhfxxGh26X16WgjMxJmay
   YtdnIHPEDiqshlqFj3UF7O+up0oHo84D0EvikRxna5UtTQM+Xe9wNg8yp
   IApqA5lAu1lLe4EUZpM4LfT8LLoi1WwTad2Ln5umDujTyM8LsDHT+q6m5
   gRPyQSQjpaSQGOw0R00ePdoXgbozZ+UQ5OxkDOHIuP/3MC4KpkBnp76ak
   g==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250426"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfEuDiMl7OtqPwc3Xvw7WpsI+/PzrBXTt7D8NaufWdOED3MV1rORKpQ70Kx/OApT/3DYtfBtCZmv63x7Fy9CE130KaI4nIq9FZDy5ilnvrOF1F7OeJ1dPrDbYtgNm3kioB3t+jJOECoiBYLLyx8lixtC1E2TyrNRIqavDjrCkr/HpDLdJFnLqbUXqBPo7LviFnajwtVhY5RWmy7QXh2Xb54pJuGfzr6Dyw74uQGiYdv3f4nauwFrJo71QHE0YMJSiSXZQYRCuXAvPE3eD6M+idbzTIaLXaVdqTKtJe2CVef24CTGPycX1Vbee43i/q2y4y62Og81uAiGSwjZwFbnHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVRB79jIfiIinmDHH9eGvzAd6BKGTZ+5AHEqFX0LQ3o=;
 b=izDimzxNqJ6wq+2elJufY70yyp2+HWcWxlYW1QbcyJRUqvTKnVEk5R8beXoBTP1d9nhy9TbQ9AuffjbebjoWjInO/IstoPqnQVA7zBYJyWmfoAlzAsUzGokwdnoJaWSN5wb5OCLIPGYE7ryP8DYa1fkuRaRJ2oJ8x2MlDWoOeozsDleno/jekcx2n5pyDgUPxRe5jEDGrFcYNiYGQosxm00dRegoQDH47XKcRTk7oZrT0cE/ke18iXKswc/gyCXZ1IEuo3FJKAFCKQK2VkBOoUZdKeSH+bfQpFMhDr0Xyca6jvHNCZtLorckd22lhPHYfZnozh4YYPWTlVSNZlDVog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVRB79jIfiIinmDHH9eGvzAd6BKGTZ+5AHEqFX0LQ3o=;
 b=YvNSsGUgXeVv1zscLdJTXeeignoVZ3ga51dH/ApPPPNbXjSLBjISXNCG9tq1FoNz/eI4RT7L5ZSx3cGY4Uh8aBnguqTjAleN7uLzLibU4hdyiNRe1WP1Fhbkm/0Gs5E9w2XGTmZNkdf/81PezHxBqG31x2cOWc28FRHOA5c/p6k=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:29 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:29 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 6/6] stat: make add lat percentile functions inline
Thread-Topic: [PATCH v2 6/6] stat: make add lat percentile functions inline
Thread-Index: AQHX4HY+DlpUAfSoOUuxkU2IfMbk3w==
Date:   Tue, 23 Nov 2021 14:27:29 +0000
Message-ID: <20211123142708.48867-7-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: ebb64b4c-4230-42a7-6ee0-08d9ae8d6113
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB75897C3DDBB383A4F6969330F2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:46;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i7OBRPc7vWrZeUylM9h+ZPt3pCDvbepLGAKKspdbfQT/iDSq1w1vIiqjecFJ7eWl91tvIwIQnrBnZ0pjMaI7AWTiHLefKERXIec/caBLyaNlQfOPrm9h/B4l7E4VpzF61XJrIMk61mFzXFgXA2XUWuzYZbLbrTXlpose4AM3lxgU8ysnErFPuwA9xerchMNzRJgyAm1RO3eEIGk8ZWTdfAyBdodiw7r3zEEFuNMyR93PAOXZUcoSDD/+AjLMhSCzZvWUbrT5qkSyf5jr3sTRPrxkTUrESbTH1/0gSBwZAM8RdY1XpvdYC18MOZcUrqh9xwPdukIrSsKrOql8YXRsC7ZU0ZhrqWXkjH/FhWzzxb0XwRsDxnIdlorVVjeTiOHfodgpI3NsmCTffgr9da/ZhOdEZjgs0gr4yDznGzZHsylXwW3E3IparC2613ySeDfg+VWuX9ZFEo4A0hZlilSpd/Sm1eql95i/EaVtzjzAfk5ZZ99Z/XKINjDvqHoNz3M+tfGmfHl6d1dIofskhqb1z8brnaF3dNshRQs2OPbmlYmagH+7iZEcrinxYAuvRCjkhneM47HWsKAK0FREkQogqRElSBs9mmeq5kYn+C+WYZQOL+37xVk+Ah8BhmmBP31yrAW3Eofhcd6eIUIVl34PaED9+2EkY56q+wi5JC8azY5d15bB5WxyHGOTn5wDI9XRdOPzv/LMgh+FgqekcxpPkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(83380400001)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?TNPfcQCyWdUSYrtEhsW4oHtXiXM60JoxKRODosCFaUn1hGPgSVPLzbeiew?=
 =?iso-8859-1?Q?6WUZXE6op8Vm5TBQ0RZd5ogD1Dd2mUdlc4Mp23BifIi7jk/dGXiD+GDN0G?=
 =?iso-8859-1?Q?je9OFOgOGqtq8o9zNf0ZspL5XBBNEXAbA3JQtaQKdA4n7VGkn6QGMwNMJe?=
 =?iso-8859-1?Q?2suxHGZtn//8uyYG9oZme7ToKKIkCsdxRuGGWrPX5+CL912SUFrC6I+NFV?=
 =?iso-8859-1?Q?0drrL04aOfRbQCM1iPCiebsDvaoy2/BnaxOE6htIm4Hkwlki3PIwFJiH2d?=
 =?iso-8859-1?Q?BJlprV4rDylhI4LYagKJ2xOQkV2VBFpfAabJRa8Y9KNKQutZncfQKjwtTa?=
 =?iso-8859-1?Q?7Eykqp4B29jYwjVDwXLgtgk6khHCaGNosPnYUO4cOJVavcfu22n72nLBYa?=
 =?iso-8859-1?Q?Vl5Rzb3tBFwJOlIZfqbCG14k+1lP+zz8tMA1Kij61EG6BdXvhW++fUfM8G?=
 =?iso-8859-1?Q?cgJme+hikqbsShPwa8BIDMbPMDBrL5QcPAAUlxhKWeQKU7KVearbjzd7K0?=
 =?iso-8859-1?Q?gOOll75+063bo4ogMsbNqHgbLzvVhMDJy+lFoLsLFbZ0E6ecuU3POP1VtS?=
 =?iso-8859-1?Q?FWhngceVYjj5yw7oeRToch0zduMnTlTyOKV0bcJPJdh4MOrlOY3d5oHhPb?=
 =?iso-8859-1?Q?V2QhqPzpiXzh5O1ibNWwg4NIcthhoELGSWJ7jDeuqyi9lWJfwmqAEyH5U1?=
 =?iso-8859-1?Q?cJGbBbYlXFAwFOzqpUDh4WeuHBWnmYG4+iEgx7yuIJfcFEYlGiiaMGSuxH?=
 =?iso-8859-1?Q?4IUseVsXQJHpPjqsjvHJcvj6zCYY8neNnvN/u5qNx1By1MuqbbvFynTVoW?=
 =?iso-8859-1?Q?sVd1IF4G1y2Irb1EfSAWMtM/UZhHDrGeffnwAABn41rmZ0tlbkqN+bm1Sk?=
 =?iso-8859-1?Q?D6yFMyVejQDh3i5vNrRhWlFAkWYVPGeSUAjr/NKn+/G7mcLvkNZnvV9G7Y?=
 =?iso-8859-1?Q?9L7wKrkOi2q8bbJbLISMKrdmics6gcvOkkV18t8r7OOt3OioiQlsT9P1Td?=
 =?iso-8859-1?Q?YcByKtKAyUjgqDQOiHFj4WYpVk0QSSCcNZIeGoSbbKZuQpMilkSUNa0wzd?=
 =?iso-8859-1?Q?gsMt3SHofRezW2JY3PV4PRH6Q/mJQnQYa2s4ZkbZbq+deEB7vnqzvobTKE?=
 =?iso-8859-1?Q?bw8/VOrQHredQc/TgdIqsc/bPmXdrRoQ5bDSQFGsMvrZkekNNDTzsvcwyX?=
 =?iso-8859-1?Q?rhSgtBxEJMoc0RTYGRNEn8iKOhC+BOBXAEtv0YwZJk7fEW2EQT778NOz6V?=
 =?iso-8859-1?Q?3CfkC+BEyLfj12+EZ+lJH6iSW37lzJgglBj01lGezl84sww3nGRRvUo29k?=
 =?iso-8859-1?Q?8FnKZfR1MltJEfEdxnPeoh37kwg8fksu6z04DV4X0qKRCW4jHAu8crJOKA?=
 =?iso-8859-1?Q?oxhZm/JgSLxySdw/qbcWOvQD6C0v6LURr9F8a3vwZrp3CmJ0EPw6Gkofbm?=
 =?iso-8859-1?Q?d7LGbbm10TIkRPoZKh92kDW67+wHv+zQCuWNTjejBtfMM/WFk9HILnF0HA?=
 =?iso-8859-1?Q?BvUcUfF8mWLNBd/nTgVxukR1Jhcv1dy+HAX+t3JMBYbvca0Rrt4YgpMbDl?=
 =?iso-8859-1?Q?ew2fkDRzNSe55AuEQFBIf6XVP3Taqg+SP4p90BaYtXzm1fglODKiFrJtAi?=
 =?iso-8859-1?Q?cJ3AQjY1cmb38aU7ZNaUhWrzJtCcJEQ2/z9vIXLEXc8529SdBrUCpZXFeN?=
 =?iso-8859-1?Q?quRa6VRLMTK6ddY8j+Q=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb64b4c-4230-42a7-6ee0-08d9ae8d6113
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:29.0497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: va/3g1hSLXYMMqKJdwi4n4AAB8SOycFT66IPDgufyh6zC4SjDEybhDBXgdjfsQd1fs2XsEUQP9NHLKRYteGIkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Now when add_lat_percentile_prio_sample() has been simplified,
make both add lat percentile functions inline, just like add_stat_sample().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/stat.c b/stat.c
index 678fe953..48c70072 100644
--- a/stat.c
+++ b/stat.c
@@ -3052,9 +3052,10 @@ void add_sync_clat_sample(struct thread_stat *ts, un=
signed long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
=20
-static void add_lat_percentile_sample(struct thread_stat *ts,
-				      unsigned long long nsec,
-				      enum fio_ddir ddir, enum fio_lat lat)
+static inline void add_lat_percentile_sample(struct thread_stat *ts,
+					     unsigned long long nsec,
+					     enum fio_ddir ddir,
+					     enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
@@ -3062,10 +3063,10 @@ static void add_lat_percentile_sample(struct thread=
_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
=20
-static void add_lat_percentile_prio_sample(struct thread_stat *ts,
-					   unsigned long long nsec,
-					   enum fio_ddir ddir,
-					   bool high_prio)
+static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
+						  unsigned long long nsec,
+						  enum fio_ddir ddir,
+						  bool high_prio)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
--=20
2.33.1
