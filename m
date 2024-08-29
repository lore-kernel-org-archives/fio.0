Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040161487F6
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 07:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724915064; cv=fail; b=fQbRIku2yk/HFCoV1n94IjE/8K9sdYLih9Wj3XHnFNlEXd5rIZmOAw8Cy2fovQO4U+vYM6lo3Od+gKrwTWBOpTkL/iOTvTdV71UDzV2Rs34Tg2H3ahL6nYKy6UetdyfL2S5PCIWiQhiR64D2uMr8OYgVxmDXis4V9lBKUmkfD7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724915064; c=relaxed/simple;
	bh=NfkcdstWn1aemEkwzIDYd0Sy09cPPBB0QKQ7Oo6w1ws=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lqQipVFiygg5uAYyMOfn18YTUf/3RJu8mVeku9vcccQP+zhVuUn9iBH0aKMxrlbU/KUJCXjVBQVghGoGkgX7KCxT4TXBo7y1xR9zTcx7F3OoOY1ZcEBNFgx/KwXH9bsv0k0bXd6WOC5JrhdMtafps347Vhbs1gPfK3CDwBLmoBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fMywnFyA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=D3oePA7i; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fMywnFyA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="D3oePA7i"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724915063; x=1756451063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NfkcdstWn1aemEkwzIDYd0Sy09cPPBB0QKQ7Oo6w1ws=;
  b=fMywnFyAQc9HPEIausvYijrDVlGWJXK1xv5V1S4J0daXB2t5rK+ca673
   1vZ9sntxQ/PlGw9JYRQsWRwrpHd5zo4mmcBtEix9hH6PpCE972+KEfrnM
   gbyiA91QmXx2qCJFu54UuMbhnvKbM7A4fSd0FX3x7mO31AAlowUrkSJdk
   xvoVw2SSGsRfk88v5T2yxpAmQ/qno3sw9ORxBdbDEIaMzOPwsKBHsgrCr
   ZjeQ1FLCd32H8q+dnywilERwS1DrI6y0ffIhUdqhxGww8LcwEIEZgXjBu
   g9PDW4bpwhTmf16NurOGHL2QtPI3zzfpJDywwNlAmwol+Azhg3UjVrBrb
   w==;
X-CSE-ConnectionGUID: TA7REscVSdeCGP7vyhn5jA==
X-CSE-MsgGUID: nL0/vftdTMqQ1v2ft4dz4g==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="25815917"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 15:04:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JS4TWlK7Tc7Mu51dnECCKji5HNXZR/wBx22Kc0dmPKIfCYDvS99KospF5mUVKdxh1Bp/NAyW1sEZhlCIhnQ3YNGEo7qeuOEP4L2TnF+47dd5Ta/L+GYyOZL2MAc69J+Ks/+xbJ0wNoc09NUSzGQaCD2RMBKBVIc8JdrcMukWY6YC3RkeVw2kre+D+Nkmc1TMAXMLfbjKf5G6yCQJ66yhHbPvIBV3lzmuO+tPl+cwAgzcdXWW03Kw0XQ0myLIfyNAv4m+PE5ky8eHfG0HL5hoxLtozgMo7pd9BgiWIiX57O2diwkXeSVyTF+evpownynAaWse0iAOy8sWRjubmnttig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfkcdstWn1aemEkwzIDYd0Sy09cPPBB0QKQ7Oo6w1ws=;
 b=es8AL6gpxV44FwfAyP4gCJacqHFFi7doZCO0zIqijwE/Qp/thuymb5Ct/ud1SVrA0ontSXsgwX3unJHf0YPXiMzkulAm9Nnj5/E4UNgQGnT0lLT/7o+1B+/JuMdHut1yb2N5ywPJcuyXYUNgX/Ua5QPK778dGFL//nQk9LQUT3pyfqVvd8sLXQKioamEtqUMprZ9Mir6fsZQpdkZt4qe4J5ctk/W20DnxuwAnPoWuONaPK86VfDGUrHuKFT3RWYWm/CgNllZWoZ5uLaipH3nNjCz57fXMy9rY1wKmtDwzret9wWPZvUIALkE9v9RODEmoUB7TnZYxH9g6pCcsXD3vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfkcdstWn1aemEkwzIDYd0Sy09cPPBB0QKQ7Oo6w1ws=;
 b=D3oePA7i5mWx5pvu6SAnCZh1scMyTzAwQ3+xFedqAMB6wtc7YPNY+/SxBOYJZCTQrj4WSyV0GPNIdslj9rAvZcvkYGikpmhN7JaS7fWnXbvwA4VxP5HoIUhf0qWNaa4TZYgZ9uipmsc00gcPJ0n0LR5vYnyfT0UdV2xh0lWMbPk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6673.namprd04.prod.outlook.com (2603:10b6:a03:22e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 07:04:12 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 07:04:11 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 8/9] t/jobs/t0033: add test for the log file format
Thread-Topic: [PATCH 8/9] t/jobs/t0033: add test for the log file format
Thread-Index: AQHa+FADypuspJu9ZEW4kqQxdIUN2rI9BHkAgADOMIA=
Date: Thu, 29 Aug 2024 07:04:11 +0000
Message-ID: <nrnxht3jatdcy5w5t6v7x5uqhtip63wsklp5h66u24p7faq36x@hiawgphpgvj6>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-9-shinichiro.kawasaki@wdc.com>
 <ef2f71cb-825d-47d9-8d81-50c296aef165@gmail.com>
In-Reply-To: <ef2f71cb-825d-47d9-8d81-50c296aef165@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6673:EE_
x-ms-office365-filtering-correlation-id: beb83413-4262-47bb-9af0-08dcc7f8c8a2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ab33H+Su/umHyIxBdKYvi/J9cUgGRPOBVgsxpxm2A6hCeVhC6G5Dfve/6bpJ?=
 =?us-ascii?Q?Q/aPWcQgcwZLPESgVns4DxfaVNYBavTPXnXT76mz7eRoN92LYJaCKx42YBC0?=
 =?us-ascii?Q?Nv0Xe6ZH0NDQoSnMwzesmGnbgJinzyHA2ITOvyO/KRsWLeIHQuZYFxBnsOF5?=
 =?us-ascii?Q?EMCJemYPZ4lp0PiSSt9GXyT7n9xsAvnHEPZU3YYwVNhUPeKRJslVxwMMTeF1?=
 =?us-ascii?Q?9pVPuFkDT4N+gwLbmFHGxBatJmC97qqcP4Ut+1gIzyn9dCbshC6PPjcjqIzr?=
 =?us-ascii?Q?HyBDb86GAjt2UgBrU1fVO1c9npvxKV+Wd3F+nPIWGIbfCTtqYRvUfgIAjFIT?=
 =?us-ascii?Q?dfOpT+Wu4E5zv+KXCuLHLj0BNudhaPha/f3snDd6MGioImf7G/IVYD3dxKwP?=
 =?us-ascii?Q?tua+EMoUyHeNZN3cZQYP2IE+QXra7Hkc4QfH2Yfkw7KkPZCxhTBHy1riHgXZ?=
 =?us-ascii?Q?EciGMRirkVc6EX1I7THBdJaN3DD4RThgSYO9Lpl16zClAAkkp+ISj/7CDNrW?=
 =?us-ascii?Q?CMcEwhKrVyLqHdG5Sk+YF89fXzQwQ/dm5jO4I8/98dgz4jr0jYrhrTo+z/O5?=
 =?us-ascii?Q?OjbC61Zcm/Bmr9ywunAFnDjaVdVHzKl5yhssCIeNNEK5rDMyim/+AacWEdV4?=
 =?us-ascii?Q?BTba0VlI6NOHkA+6Q+lYnzeO8T0CpqcdbfgCfwL07/f+hy80qosJCmtcsdmC?=
 =?us-ascii?Q?sYCCisQvW3Xa3YNyiROZ4IMJmPI2MDtZMDoB7/uYWctG7HISRAU63WZAAl3m?=
 =?us-ascii?Q?1b7RO9pr9sM+RquKJFQAMK/khK/6W8NfST9UxgAIfa2uFr3vqKZRg8WowwF6?=
 =?us-ascii?Q?Hs1K7jJB5NTq4y3vBO8NG5pVO2K+bYN5ABGTkB8lidIAq6JQxl5uN1JH431j?=
 =?us-ascii?Q?2M0Bo/QUvsJw0RW2ebsMnSGmVYFcOum83LLsBeUVmmVgqXgZV9kgIYFPPkKo?=
 =?us-ascii?Q?+7+zlm3Mj1mC+PW+4PL5jZb3B8V2Upn03afXIIfBgjnVvGgypOXP7uTv8yPV?=
 =?us-ascii?Q?0lpBmjFH6VlMcAYBys67d82s6q+aDTiXAyo7IO8siGteYNTir8SfpTYLb2un?=
 =?us-ascii?Q?5mrn4Jcuu5V9uNIcqAgInGphZlwR6o7YLNf3lzt+CqIcWKYylXxdPxKLwPlU?=
 =?us-ascii?Q?RL/5e5ZjVsgAjM+d9lktjpHunjR7YO+pxKlrOZ24eAd7ulgfcQKGO7+Nn2zm?=
 =?us-ascii?Q?E/dHMK7xF1SeNTA/vG5K0yXNoeq+azy9yYabMEr/ECbNsBJOOR1bNZyiabB6?=
 =?us-ascii?Q?YULAp9rLQapAw3JQB/o1JKXK1GbX05XD9EgDFb9aLtGWiDOIrGrLiOWBUlti?=
 =?us-ascii?Q?STxetbTPGlKErbaqup5oym4BKhpfRQXiMLlad5JWvmakR4YmkIh/kI6im6Bs?=
 =?us-ascii?Q?cDAP/hA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?puf0cLZaVNgYOQpNnsVgO530OHKyUNOChPeOH11UrR20P1uteuMf7fPmbxjD?=
 =?us-ascii?Q?LkCOXL7vFxSTtxHgGBxUAbx61uuAaK53JopPgNxgO1tD6/9QAvylLbUNJZph?=
 =?us-ascii?Q?07SoPuQiSQdAmxPVKLzuLqu2doGTeLCK84JAJxktN7b3c2w9dcOZEyY89Wlw?=
 =?us-ascii?Q?3OwmZltXEga+O273RFwdyXT2uzA/HoTQmC4I8gntHgt0YMLyoI9ukbe/TU66?=
 =?us-ascii?Q?NLDe8JMB7G0pgmYB495bkkD0Okb373BRt6ukR38WK2aihCs7qeiKTN/o/VIz?=
 =?us-ascii?Q?lSjbb8SEV4CS5q8y9fPLWxGnD4UEbsj6Dt5+eYC7pnB0zHvZaOwbjzpiA/Fu?=
 =?us-ascii?Q?ux6kDA84RXN5fsA4zj9F0DRpAkrJQXJ2pr6ZSInG/S7UnpbIF4LSQCs0XqeQ?=
 =?us-ascii?Q?5+v4OxwTDk9R98d8NWiDnYZWOEjjho3CcUhzx8oKdpJtOShM1thMmAmxvHSS?=
 =?us-ascii?Q?/XbJko96JSQPfk5wyQNJ+M1Ws3DMJN8MzGZ0E+nZQbeZCk9qc5UGlAUPyvMJ?=
 =?us-ascii?Q?2BuG0mLSaskVTsqMjiw4M4Wh4wnmzDJ53kQwdwMvFXQweml9+r5grpJTBuHL?=
 =?us-ascii?Q?yk52tR6RRo7ckJIfSwDtZ9fQ1XlkSWxYOSBSotp7Gfyf74A9qz52khppQLha?=
 =?us-ascii?Q?jS+/JFI75TJm6MScd/HebHJTUl1+w/DJPdjMOfUlp3tXJkvqQp79Wgyv2bTm?=
 =?us-ascii?Q?6xaUNAlzrzvHF/SVJdwozjLcLqyNS7PGhWuagpahh4MRROFDarEVz138D4kb?=
 =?us-ascii?Q?zEftrgzrU8fc7VJaTlB8JHm0iLDgjn0lfA9esY2hunQDRdTJ6DuMF2igvz0B?=
 =?us-ascii?Q?REoqYRM5+rzuFmC6Y6FJc1TYpC1/+iuhOO+iXLoqJKlABN32o6bK1dEcKvzH?=
 =?us-ascii?Q?8VBA6hVqSq0SvnTuVFuClEPYEu1TWnGSW91t927fSqqQyRrtOrpU9KiNOpxb?=
 =?us-ascii?Q?72txIn32uBe7Ru8SM02q5rX7/nFsrpb8QZ1z4pKcFGY5OXEky/rJB4y4n1ZX?=
 =?us-ascii?Q?O1P3yF5fW/jVtwCVYX5jiF3gjY2zjWFUKX2Tt9+rLpChSoT13A9p0M0p/cUi?=
 =?us-ascii?Q?Tv/lcuZ91H0ciX9HT7Hb6/ArWYnYRxIzXtTPPlDC7MumIUz1ryKZxkZf7tmv?=
 =?us-ascii?Q?TOKm9hYKq3uWR0Tsd0h7KJkeJJXWo+cRHI2KIDotL/PvRP0qRIlNYwl54cNL?=
 =?us-ascii?Q?NshV/cbXJRluvMpBqqw6miZ+NyojEPUAKzTBynfs7tstf5hk0e6E9pF9D/5Z?=
 =?us-ascii?Q?Od0JrMEeDgS/D9g1mB1MSfY/K8VkD3rXIrmB7GZ8JWDOmofTJiPGi0u81f9z?=
 =?us-ascii?Q?mx9Pql6lYVrNyGdo1yQpPdoeGdgyEFZoqo1lmA5AZRigHr5fC8rsUQA7qAU1?=
 =?us-ascii?Q?eOXIEfH/GtSe3MBAmciYJtg++2Q8Psq51uLUraw7YW2aCA9tFQ7pc2bNt4XY?=
 =?us-ascii?Q?3dPfsZwiMQowUS58yZ3+d1FJGETlC0VmeOPB9XDZGsyp+9fOVZY09qmCJzL3?=
 =?us-ascii?Q?+skGXkiYUdNw3KYk9OxaLN5Rg7kUXJuVIa9g5dpv0sI4mpfZ54FF7V0bN7Cw?=
 =?us-ascii?Q?t1t0nZ0EOpGFm1FwuyASFTw+7qNBXhdNmMsdRCfgMkJn7gc0sV84ttD4mC0v?=
 =?us-ascii?Q?Se+YYq46MTkv7QewJbvaWIQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3F1609969D18C4DBA23AEADBFC4B062@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8gwTrq81GL8bsoTXpb+Ij5ZCqQtHaY0no9ms8odyf8J49ynQa1tsK9dhy0JsNEvNSerPGmTAODaAr7qHJk0UL50/YgIyyHTiOwT+ZbH4HVvydIBgJ+7qJ7tD+0zv9ofTuhXZNmzxMjvFSqr93IvCum+mb/Vbdx/iUleVAh0tuws278cQG/gmSqeVEYuG3SGp5md8Bnfo1vkAdEzG9w1uq0nbx+Ox/2k2oTQLX6IZLlgPDQ1+QbFVcFWE6pUe0YgUWkrOq9BBbWOPXKb6fQlZy+Dwdom4eXUvZEg973ptDBAr2h9lK2HSikkYbUoAFG7+jyumQVzhowkGgT/AQNL3XZgy/drYegnxHbtaxmCkI1pY3WarSOmPjka1bridOkOmXUCuxgLxAjqHhJbtTT4cESPIfT24OYQru2f3e+mL+HNV6UjusYBpTi9wM0LGOymdlbOV9FRLYm+nJ2YsfWr522lEQ9FCGO3KKpFZayRu/xuehd4fd6p7p4wiCKJlQKr30Q3CihNoa67jrVFcmufd20l1FvJlQHGpADuJ/QzO4hZq+4sGg30p4xmPj1rfWTwDXa5Ugg828DX4h8jgNlxRuT1+eTYaTd8+08QvHNuM4G1P7U0DQvh6ey9/UYqRCr3X
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb83413-4262-47bb-9af0-08dcc7f8c8a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 07:04:11.1058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TW9R5LKZ+k1u/RwPVTdiZgBldK7o5gWila4Z1Q4mE/rcxG51+VjoXeq+n5orBIjfIctQb2pF2nPKDHp9MPV3uMSD17hyr7LBjPZEjnfqwNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6673

On Aug 28, 2024 / 14:46, Vincent Fu wrote:
[...]
> Add [Requirements.linux, Requirements.libaio] here so that the script doe=
s
> not try to run this test on platforms where it is not supported.

Thanks, will do so in v2 for both test cases 0033 and 0034.

>=20
> There were also some test failures where the job was able to run:
>=20
> https://github.com/fiotestbot/fio/actions/runs/10573766613
>=20
> Consider increasing the job duration and making log_avg_msec larger.

I will increase the job duration from 100ms to 2s, and the log_avg_msec fro=
m
20ms to 100ms. I hope this is enough to avoid the failure.=
