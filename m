Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4E32AF0A
	for <fio@vger.kernel.org>; Tue, 13 May 2025 03:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747106210; cv=fail; b=DWb9Ow9OKQsP6vc/1UUq6uK5Djc9zxO93kwoRV/dzJzMOIXp3tWgPjKdFxAEltmKjdw8e5Q0DQuhhLBX9eDsT+FhXVNB9XZsb58svspwmVAW029hMmnHZD0r+eNNRPqvJJSxzOK+V0vtxXd9wHB9G4KRJRGz+ErbZHQm82yGRbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747106210; c=relaxed/simple;
	bh=KY9SgpVAbnvxDon2D3MLmICUeu01/N9/CxjCPKyfZQ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=INCOjOETn6VGs860UIZ/NnsPA06+tbMnLmABkRMFGQp2m5kjtk0w/CnerwOeCOHXu6rV4kSIFB6QsZt1atktBGCBBL++LeILH8U0EKKtV8/hhhzOrMUAeiJYbf4XDccQu0oZU9vYyJBXZRjGueOYG+odOqhXJoDMjIEn5YDXZTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=T/uxAGrX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=woCAkp+a; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T/uxAGrX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="woCAkp+a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1747106208; x=1778642208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KY9SgpVAbnvxDon2D3MLmICUeu01/N9/CxjCPKyfZQ0=;
  b=T/uxAGrX/RHoMpIU60jDpM1Bnm0T4l5UyBrtP8iXIwrzncFDIrjrCB6y
   JeRYQhSBtKkGfsIfQbNijAZwdO8rz7BUuN2beRkZHwdIavQNjwgeCS+R2
   ecTXFsH/ToCYsnRl2uVS9B3BN8I3OmKW/0k8smie7joeK9MT+LhsxBGBG
   FVRYTCVF8c6vkJQqRvRGwHs3JXgTETTDTNsgcpqKeuuC1FIlZVL1GYiPC
   5rWNHkoGIWGOrVWQwSzq/bhoaoYo47WiwzfPsQ2MbISuPKVPuqrd+kywT
   J9V6cF/1RXhYw5Dt1vrYARLsycwVea97ytRC9cW+KhBFeTzpPFcABw9bb
   w==;
X-CSE-ConnectionGUID: t/gBEME1RzaSixdR50BorQ==
X-CSE-MsgGUID: guRHHCeEQ1+qZ2HPxMuhAg==
X-IronPort-AV: E=Sophos;i="6.15,284,1739808000"; 
   d="scan'208";a="85343189"
Received: from mail-westcentralusazlp17010001.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.1])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2025 11:16:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lVnvu2SK9Hjo5Kn7q24JsqmrXnq3Up6+XNjgZZ4Xp3Op1Ak5azWSE1h8ri8cvflU5ZC032cUqjnKSD/vWXAZ6AbYkSxUP20Emdo911NlSUL6EysEoFgOXTllmczv9GNEvCTAuHDk+8xvhWigqAEIPPNkz4hvHl6ElBO8LB2LyvSM/ZqbHtCn00VSzqAXbhW6iQGci9WhN9KpNpTA5GjANgvOFdX85PWR/ED0n6lu+MNADmOlICqQPmWTHLJOHKza/gujHDrgLGjUvo8SbV2X5p4d89ROVGXy2lClAcWImfS7z/L62QYLqCesX9IVIhUDl8G4Kw4DmaLWBbFCLz5GMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNi2YJyTWhjIMM9AWNqcKrZiXI2ZSXuGrHu+7oHTi20=;
 b=Lpy3WtNoiDZ0L8bKZTxxaMA9LPOGEJy9g5kXuPuiUdpWxYTK/R8mWj+utd+uJGlS2rExN2gtalOTNTpu9+aygF8Vqwb+uvrwJihqEGGqe6GGxhkuACLqu+3FhoujQj3qhSCkpaXRoHPcJctEoqzbCChQK2KXkYhKt4488IrxckJy+wMgHKLAGa7TiM3cSvNCH0R0tZ/daw57qeifJTxEf1AzZIXm8Fa07IW5kecDEQmlEo4n14l6KCIeaGV71WFI2as7NWnMyGpNEBNq5L64GiJPWE/efqzEnCVoaHggrbzu/d7i/5udsrYjm0g7XGz+6M0d4N7rR8omc+mWUX7VGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNi2YJyTWhjIMM9AWNqcKrZiXI2ZSXuGrHu+7oHTi20=;
 b=woCAkp+aKs4jOAayxt7bdRy79mvhWO6sNDjOm7QDg3okS4YbBxK06L0NtYDhu91wktRHTWnlD6LVySoha5NQ39D01hloI/z47JyN25IzrsYXX+H09ua6fw73zrLMBX9NtHyzsiIdWCsQ1wlSkB4ngseQRlk2BRc887Hubnep65Y=
Received: from SJ2PR04MB8536.namprd04.prod.outlook.com (2603:10b6:a03:4f9::11)
 by LV3PR04MB9122.namprd04.prod.outlook.com (2603:10b6:408:27d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 03:16:43 +0000
Received: from SJ2PR04MB8536.namprd04.prod.outlook.com
 ([fe80::8820:e830:536b:b29a]) by SJ2PR04MB8536.namprd04.prod.outlook.com
 ([fe80::8820:e830:536b:b29a%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 03:16:42 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Vincent Fu
	<vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] fio_sem, diskutil: introduce fio_shared_sem and use it
 for diskutil lock
Thread-Topic: [PATCH] fio_sem, diskutil: introduce fio_shared_sem and use it
 for diskutil lock
Thread-Index: AQHbwt1wvcF+lavq0UmxJiVSV05O57PO+mYAgADqrwA=
Date: Tue, 13 May 2025 03:16:42 +0000
Message-ID: <d3fhqfmwtvhptpukazupnrhmialrekujjokuhoi7bdoxvzr5gk@yvnmyknsooxj>
References: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
 <70f490f8-4590-4446-a72f-b75213868134@kernel.dk>
In-Reply-To: <70f490f8-4590-4446-a72f-b75213868134@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR04MB8536:EE_|LV3PR04MB9122:EE_
x-ms-office365-filtering-correlation-id: d1279d46-ec5b-4b95-5011-08dd91cc95ac
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?DXsTIAX+8z6ZcRGW5+H1yIpn/zoVQQO4sOhvcT61wlQoC7O4OL8YwM/yurWY?=
 =?us-ascii?Q?SMmapHfaetuL4BdFdto32a0jdUQKz58qBwHjvstpt2IQzmdllY2rFDRG6NwE?=
 =?us-ascii?Q?+laJMN7XOBc5QcpTU9w8hqG56HHeGvDH1+8ouGPnmD9j2v3Bu6Hyypn06kc9?=
 =?us-ascii?Q?cptRwdTLmtt4gW5i7OF7EASJZhrnXsEowQ2PEAXbl85x3wC3tnsc5XExvHul?=
 =?us-ascii?Q?5tY4kF+aZrD+Q/nEZvgpUAc14S9lSHb+6qkYZOiSEhJiZw17NwnH9l6ohKFF?=
 =?us-ascii?Q?PGwi7N3Zt1f8Z7xF7PYLpIKajT6jQB/U6O8sKcGnhELMRaN7KHLj5P7Fq1Vp?=
 =?us-ascii?Q?fZcpatJvWR/X++GCR8Gc7gfCovAs2e+zSzv2PZgd3hf4e7k8BMAvsEjkPwRL?=
 =?us-ascii?Q?3kFgVvWf1JMA6G8wsPq4ckBCh1mwZ8e4w1Zb39EeB9ZakIB7/kQNGxhhPBkA?=
 =?us-ascii?Q?wbHFLVfF9ZhubsqXpkVNrFBHztXG7IDYY00U4u1D1t94vrGS2TkWvAQIYz7T?=
 =?us-ascii?Q?hhPePmrOOpWT/DqrHnKJBfBPy8BkcbVudsSqKy2+iz2BMxJKE7gJN4oWXyN3?=
 =?us-ascii?Q?MSYskVQ1zPJ/AKoUzrKEvT5h5zGY4V9hinPfrxDHZEINH7zu8cmYm6SUY2wx?=
 =?us-ascii?Q?IEMWkMnBDLgOsd+MT259dsMGllLkOpY0rfjcBcWMqbmHxziDEA5GzUL3wUoG?=
 =?us-ascii?Q?FDBP+zas/8+Nf7IFqqafM18T3FNX1Toea66M50ORII+XJ5ohGwQY2TEK56w0?=
 =?us-ascii?Q?DWEvlO+TlE7IeHyFzpWc38vqHKwbnPJuhibI12EgUT4QOQhQ1/jPJUd3qNRi?=
 =?us-ascii?Q?vrDK0bmEvSDXXVCWucVB3J6Xv33bNM7C822YZsJJmatpatNTSjc/LnCMjTDR?=
 =?us-ascii?Q?roBrlbqN9Yf/mXr0TaoloqXL+FoOw18aIHZaAH8ptdON/q16bYtlyQqdp9ox?=
 =?us-ascii?Q?kFUSo51erFjvgrUTgeWaETWmvqmhRtZeLUX+6ZVkgRzkNXY1koGwnSEBXldv?=
 =?us-ascii?Q?R4skMHBTN5hWmi/VDqJVtuit39Xgtf6+kcGAidm7PpbEhE1g2CPqc6zdb+Ux?=
 =?us-ascii?Q?pT1BW/EqQ1vE3u51czO0MgzTVvfROZdkaBw9ig7dix8kR7tIt1SxEhLKbHDD?=
 =?us-ascii?Q?fkfI91bmhjcPwq+1T/ruABdcIayxpVKHLrSSoveK5h4GnrU86L4Sq75PfCpS?=
 =?us-ascii?Q?bTRiCzfmWBY5sXkNrlUH/+gmcAMbm34d5S4chnA/geUoKqTnV1H+0wAqfACQ?=
 =?us-ascii?Q?ThKYpkd3nlwCH15SoQLFq63LQ3SZ595f5g1y/JU9Eyxxb7w8xuhKrkJQg8yt?=
 =?us-ascii?Q?ODUqy3+asE8KxXY+s08nJYFchLKMRSkIDnVWV4XqThUZIWLHc5GisogI+B1X?=
 =?us-ascii?Q?CYzoKv9ECr6vO4nmv8CS9eHONo22HlNkmpgtgxyb71WKun7wgyQ//rAFaT6R?=
 =?us-ascii?Q?AQoh9Xo6GpEOAV9v+L0k42DSxeg1uh970opxWXhIbZa1XUQwbP5asw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8536.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/qIMOOyUHbaBbpS5TAwmUG6sWcVYgV6Gpnom9OcPvCeAd6swKHJYM3bcu6gV?=
 =?us-ascii?Q?6FG6fWSn6aAnDecA3K3v0HkoRNDd49rThiYqHwRwSeGNQpH3z9UKOJsDNVYh?=
 =?us-ascii?Q?1I81OHnj1CIR/07iaxyb2WFhX6qtYwdLiPBzdwwbC0PXl8jmGhl+mayPtzhj?=
 =?us-ascii?Q?BWNneVIRLOSzYZJm3TmR3CQsh10y3nykBtft+3BpXuzFRImUsBmUjld+rvOP?=
 =?us-ascii?Q?8ynFsN3ORRGukt/RAqFHEj2UbSH1QyO9GgPisb8dZDF3WOd0fky9mJcqpjm+?=
 =?us-ascii?Q?o7FH2tZrzm+QJsvNCBTpvmCpfbqq17L3uUznmDTlfLlOFzjJokiYNQkopsqG?=
 =?us-ascii?Q?OA46BH2l0lsSQl+DiGi2eRr22LBMEEK3rGk3AQh4eMUlisPxeikcCf8+t1ad?=
 =?us-ascii?Q?7i0yYlboUNt/3Ix2wlQEYrnS/hsXF8q5ahX8KmAS8lRV8E3FOQ5xHv8jlmip?=
 =?us-ascii?Q?dF3FvINmdyDoupx0cBUWdbdvRiKc06d8uqQVaXGwN6RvxB6UEcI9DoE2efN/?=
 =?us-ascii?Q?YI1H9sYmx0Gh0pjHydt7v+r9hIOAe0DUe9JZuBjdgI3cJuSndvVb/sPbMLfn?=
 =?us-ascii?Q?XJZ7lZBaqaAKHRjN8x7dts1Cr6+q2bBa7cJ2R1BoGytSWCWWA4roJaYaUwV5?=
 =?us-ascii?Q?vi80ZBAPvCTwqYsQcYWMwDjsqpjydken154EcJZzkrwiKJtexolRTGj74225?=
 =?us-ascii?Q?0OVEGaZhsHPTAOlYef8jaynjFEtxRlVU7feBRFZxDq2sOC7/eb440eUXCQV7?=
 =?us-ascii?Q?14JpfWBUO1iFjbugz/1HSWHJTTRq8rLPDiPIdQknqoUZDomTsJK9/PqtkR1y?=
 =?us-ascii?Q?6Azg/oP3oPQavJ8UMngmaiVlrO0wMR6uVmj1chVnWKWyOR+7b0/Yq+2alrzx?=
 =?us-ascii?Q?Px/NShuir09b5lTzWyLYoYJwEMl9+ExJcjX+KLMXm+bNT4ASz+/W3ScBXnCi?=
 =?us-ascii?Q?NQM4dMWO4h5vfdFW/djH1IhzQ1lxoANW7rt6YnYF5LZNtWUExJ2VprfiSWig?=
 =?us-ascii?Q?eAW5bhwfT6JPVa1lOzkMqmIXr5BiqKCaqplxrrLTwty60p2UNCV35TGyeW2+?=
 =?us-ascii?Q?p06i/s1TNp7kgWoaJ4wGqCvdfV7ZXkxriIYF6ppMfp7DdjeRE7MgMvFYXwNf?=
 =?us-ascii?Q?Fmnkj5VoLatua9WNoJNr2EdD8c4LCSj36bQOHvteIHfs5NCPxWTPB9L9hC5o?=
 =?us-ascii?Q?5fJbZu34EJ6gLIv2OwPF5f6dhA6WElXbNwu4DZZtRw5T/NI4qG69yOmrmWkO?=
 =?us-ascii?Q?/l4bqhsUlchpmw6irQieDPTW/i5y4uv8ZRNv+Ko1ZGPygOgZ0/xcitO14553?=
 =?us-ascii?Q?Vh/9XpdfDR1WGqY5fEMGbqF/ypgrMP98ZAYu9fhpyHt5dzFKCnpZG/18feUc?=
 =?us-ascii?Q?bDc6o5Xp9FcWprq03WTh8oPv0cq1h2slJEgDpFs0aTlzfFMZ0XWTfullfOTz?=
 =?us-ascii?Q?B7QDw3u0v5zA3NFLvy7CIy00kW+ffBJ1Qucr1OaDrgZTmcnRUXsXBv1+S3l0?=
 =?us-ascii?Q?DmwGllG4cUm/e6ayDnng4SqL+4J0hYhDx3h54KouFN0G2vxq8lBz46VoPHOx?=
 =?us-ascii?Q?Y2/mKaU3PXpqPISTLQvdHJEKuj0gVre5ps8N7vr9E4+hsKtFTuHcGvgPOdox?=
 =?us-ascii?Q?Y0oDpIrS3vYZSKsZLv5wPhk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11AD6CB6E2360041B3401937AE9CE2C6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iQ8OR+iyDBaLqLcDSJ6nd6Ga822GYcA4hSBMjXEe4bYsgP/t64AUNMkQXimtncfI6eOjLsBG975sYlxJvGVjYagAUSaAoM5gyac6xfj0aXgBT4Jwo2g2AJCJ4KxPlySahQnaotyYWkmLEl1y7emv4mW07GqdsSGw/BP19p5z/efxsUG4Z6paPcySCoVgrUoaB3G6n6IbHRaxsaX6ugyJuFlu25c7Amp59cNPg7nORrVY8nWaOXu1dAXodHnuVIFl/906c5R8HsBtO5R7qBzfM9LoYvYCpESntpJlQ8qOcSBeObTBoebI4ooKseepsF0oA2wTukDn0O4ltUA10FGxgvIZq45io/yEJ1YCQhm/8fivXhSKeQMqY6PK0FTnKn5jNsSbp7jBT4xBdvxTfFli8IqDW+l59xKBSt2GyoecRdUqS2I+pDMKnp84az06M8j3sOKQ0pIbpIiDC1YCKwpzcyuRoe3PdHecGX4tz98RvUs7jJ8NrOhIksr6rYjRqajFQDG9mHwkKyw/91maSMt5nyk/kjgyoK6bJhYwWuEUCjDtFgg6uhfXR+yD+Nztt8HY6EgxDlxEHAUqeulEf8LeW9z2WJvmqI85fIn5wNe6yjuiW8ruVIUNeuZa1+aGDqfe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR04MB8536.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1279d46-ec5b-4b95-5011-08dd91cc95ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 03:16:42.6331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C+XdOnfc3zZKCJzoMO0Uxp+CNkfBu/bYJn5ChYUzFli0kaDFMlaTI0HzdsP5qCIJ0UaLC+FXON2qwuafHrQ3wY5e5jdCT8r69crwsaEWTdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9122

On May 12, 2025 / 07:16, Jens Axboe wrote:
> On 5/11/25 7:30 PM, Shin'ichiro Kawasaki wrote:
...
> > +struct fio_sem *fio_shared_sem_init(int value)
> > +{
> > +	struct fio_sem *sem =3D NULL;
>=20
> Pointless initialization, you overwrite it right after.
>=20
> > +	sem =3D smalloc(sizeof(struct fio_sem));
> > +	if (!sem) {
> > +		perror("fio: smalloc for semaphore failed");
> > +		return NULL;
> > +	}
>=20
> smalloc() doesn't set errno, and logs an error separately.

Thanks. I will reflect the comments and send out v2 soon.=
