Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A4308F2A
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 05:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769490359; cv=fail; b=HFHj7xa3DRYNGXlJZhqRWOqdWFaIkodwINu50ANF9pfdr84UhjYcuO5ItVWVBeT971N/brfIGMIPOjUEE6jn6hFnvWjBv8PwnGJy7quBtb25+w1BNjTvtaoWyyMtzLMlSEJlpLd9Vy8xj0GL3uPwBbknu5hN7QMHDXHyne0FeAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769490359; c=relaxed/simple;
	bh=N8NdyGN1mkGEWqBZtXCAIvKd5Hreo80juYqOHzXJWDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Je0VzIVkVt5k50GLdgCTqiqMV43ht/KEUfft+dvSoJeiBhkzXxQEi+P44Y+AuyANC6ileTQdsuEWNqnMPelw38mIe8J9NOXavd+HYszSczCg3KUrQX11YAlO1yX+Dl0Cs3x/NOes32CkahF2W2w7gAKEJHSTyupAgy9d2y62PeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=j+vP+pLu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LcI3969e; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j+vP+pLu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LcI3969e"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769490355; x=1801026355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N8NdyGN1mkGEWqBZtXCAIvKd5Hreo80juYqOHzXJWDU=;
  b=j+vP+pLuEXb3kCVJ3pVZt8m4ToRtnhknzq66B41/vqtT3S9c7OJJ8/90
   09bLvaDHw189tD9ivsycgAZUU/It+RW6EjLRvmKGyluZM6deoJRzX9ieM
   uqehL+CFP2O2EhESGg8tTtEAqPAncZMhfMk2wD8jB+czXpNXfGihRw7cD
   k2ElzC/HVpItojtxtkmhtuo4bimICeh5xT8K015NEPv722TYaWGT6TP9z
   znCo2A90xTTLJoJNoEo+KPwZIll4VVTHkbbNgCNDTZRcdWQdqRTFKZB6Z
   q74yxVQ1zmSNc4Hdk283d6WsNRHum/cwupyOoZ9vUwH5+82807xlOx8bm
   Q==;
X-CSE-ConnectionGUID: FNKBy7kVRLCfuoUtR3NCJA==
X-CSE-MsgGUID: yOIrGXFsTcSeNz1xh5EykA==
X-IronPort-AV: E=Sophos;i="6.21,256,1763395200"; 
   d="scan'208";a="136115348"
Received: from mail-eastusazon11011068.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2026 13:05:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moSE84UQNZhKcluNDiESvPwqXbfoXgec5qcybSqgYbP0/V/XSf4hsE3ShBz9HwY23IzBCB8l7IOSI1a/4BP4Ey2Pceqpn6Q7CvzepZtCY+nHziSWjpkQrH7gCkX5ShTlr2ce5f127LP7YsZxfLjr99aTLxrVW9VRPm53pO/2efS9uQIS9UDPRONx2qjZ75r0P5158iY+mQkczpaulze2VWA5u9MBdOrxbVONYhn94n5HLry2U3NkEjzN42LpdJQLT6J4lpNw7Hb96MqAXblPfzBhvfU4/H+LAPQ82moJHyC3ko4mWQuBPs7bJxcjshoPaJ44Qicd+RLJJ4UEZ0ZpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5yKrJZ/US3ocRccol0pMDnTC//exnGaCPPgrvxyRWA=;
 b=BshLofRA2/ZTwvTMn1rZKdjFvyQG2Epka/0cgp2yyM5Notm9U6oCtG3S1BVpThDFE4gPZUXCkejpN8rMSnqRFhDnuZsApK+oz3UWl1fU26x7T1qIaaPZ3j2EfM64KIYuLC87vaC1Zmov0f+hKORcwOxYPewJnBBLp/7hCPHSUbu9tvrNRKkPD6ot10QA+lmNN2lSYyBt9hW1q0AKdHxEL/2K8g1t5nU91TII7RTEDgwkPjj16+GQAPBvuLfam6/bYlqShG4hjt7RElMHRwrf95NKN5+xnTeAUKJfgAY7DV5efzunibSi9d+kieGUdZ8RtZroBTznkfbkHO9dX2+ygw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5yKrJZ/US3ocRccol0pMDnTC//exnGaCPPgrvxyRWA=;
 b=LcI3969eDgNbOugHBbi/u8culpuFymPL5TQqQXtClfe9BIvPfhjAP8QVUlG8g7tgiwPi/Aom47mqHtNbTaX/4VTuacGeURUzoww9s4NKmBWYXd5fMyTtSxuspG+cxblwrCDue39XOJ72D/0+D8WOihAnhGR+oq128gWsV7hVfu0=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DS1PR04MB9582.namprd04.prod.outlook.com (2603:10b6:8:21c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.6; Tue, 27 Jan
 2026 05:05:54 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9564.001; Tue, 27 Jan 2026
 05:05:53 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is
 specified
Thread-Topic: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is
 specified
Thread-Index: AQHcgRC3+kzZbvpbx0mgbeTQG6UQjbVlWXcAgAA5nwA=
Date: Tue, 27 Jan 2026 05:05:53 +0000
Message-ID: <aXgleDJ44YFYDQeF@shinmob>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
 <20260109023603.2848421-3-shinichiro.kawasaki@wdc.com>
 <CAOp=CXnX9zorei7vwO54OvxBeFEjsKzgKXZaLqDOmu24-X9bbw@mail.gmail.com>
In-Reply-To:
 <CAOp=CXnX9zorei7vwO54OvxBeFEjsKzgKXZaLqDOmu24-X9bbw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DS1PR04MB9582:EE_
x-ms-office365-filtering-correlation-id: 8ba5b2d9-1194-40e2-5cad-08de5d61bf56
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0YGWA3JLIQJ7lnKDso5WmrocHAWRIXkp+yMACctlgSn/AtD2DcwjXtFCNQZ0?=
 =?us-ascii?Q?UEpcVmouh6Hm5LqaI1TyDIzrOTIm6sChyNpGtb82wCv9vM6OZ+rFRQ5J+HaE?=
 =?us-ascii?Q?k3YLXcv2QwkG13JkrZFKReaRj1QeAkGNsk4bHhuopjHrZRkptGThqgGz5YKX?=
 =?us-ascii?Q?Q/dMw8eaA1OY0KfLE72YHEjLBXK10GEol1mWTQaLGy2GsZtAbw0ihAZWk3Ae?=
 =?us-ascii?Q?B8FM5X9o+X4j1lijB9z44wSH5fIptJBDMiu6lVlQrZv41/FmNaAGTjDhlK1+?=
 =?us-ascii?Q?zik6M1v84t5Ipkjm6AfwT6XEgdCfMvSGn4OLG5BALS/WkgpNWGN7yFyWDsBx?=
 =?us-ascii?Q?P0qalk2qdZdVDvYT3Nr+oPtd298XIQofdbf7WqHW/jOB8oMtvd9NojPVxaFW?=
 =?us-ascii?Q?96lyU9GBt6x0wW6nsRb8l8kyJA1Mb9TdZ6PxvmcuJxeBeRfiMugmROhMC5i4?=
 =?us-ascii?Q?Q0k/KNiM7B8loPUYQcBsvhZCmrmrLkbGN+oePTS5MrfZXfqc1dal06FGPPka?=
 =?us-ascii?Q?iBkLDpw9HyIK7/vzNyOYQNLVsx+dw018DT5+V6eDwhrVKOBdD0UFkFVJuALA?=
 =?us-ascii?Q?LvNAuSazxNNriwCy1Cq7rfcdWtTL28yaz9sUz4SR23ZtqWy4YnEv5KA+bUyE?=
 =?us-ascii?Q?cfvUrV9AMS2Eeb+YWZ6LkjwmG7i3JnpyNAro+5C6Y8uUJSphyVhWbn+cf97o?=
 =?us-ascii?Q?pCYJAZ2GlgE45DKD6n5vcSSvHM5csS+0mQR9FFKXinxS6IEnp/ShVeTRptd5?=
 =?us-ascii?Q?6DVeA09/8brc7625tEiF5Zex+BsJQUjFXOFuRzoH0N668st05LK8YehGkEkE?=
 =?us-ascii?Q?JzebNLwiYouC0KQxaEMzcDQdMhP4bDGOfyUZ7F06MU0YNxFl5/1r0/KrTGID?=
 =?us-ascii?Q?bDzSCmzp9s3I3LJcGQpgtCcSkXYsn9M9UhORQjn9Kl9pkTYF25LMC7HspzST?=
 =?us-ascii?Q?1X4xgfdnR1QHJu6tHX1cJIobE3APb5KLwgOU1cUlmqSFJFyZcRAO86acedO6?=
 =?us-ascii?Q?/zutEY/dey4vLc89WOSzFTXeCVWZGiWwpwB+Vo/Q26DMGry/i+dMtDRg+3R7?=
 =?us-ascii?Q?Gt9HRvEn2nfA3LMceumVscsRwDtpYlRvGmQyTq9sJs3tZ0s7fHtIN7jA3U3H?=
 =?us-ascii?Q?uF3EASCXcENnNOXtUrpA3KRjMgXQNpa3ddjO6jXo0xioodFsXvUBG5+JlwbY?=
 =?us-ascii?Q?M4X4Nvm69NSK6f+MWbILThQJ3VrbjFEVYaHKjr46OmX84dIePjLx9hDguVNs?=
 =?us-ascii?Q?jZnzEmE9h7PUJ3yU0aC6LrtYiGF77KdIgIAr43v6CvZaU0FPZWRO7+hxPTlI?=
 =?us-ascii?Q?15S600hcuNszPWMGpNm1Fs6zIpxPfYAzcup4XrjespalOsflsHm0Mlz4zMcp?=
 =?us-ascii?Q?YaZkANv1vnXz6ZTpMO5pyJQRCs1JlBWqA/WzHMZCr/bbzU+uIi154d903ZZS?=
 =?us-ascii?Q?YRrI2prhdE6N6SjCcZvWf6xfSldEeDvOaUIRTKyV9xcxmu3Yrp1N2eBsnsc0?=
 =?us-ascii?Q?twqwgQcerz/AdP3bq0cHAH8hNxvKKVztyPy55hzrapRneI34hg0/hHo0XDnH?=
 =?us-ascii?Q?ESaZPVBgPP7ljc/VA/M7tWPl6EthpaTzKoyRCYzytJD030J3E+mOy51EVZND?=
 =?us-ascii?Q?AaEtMZHgWpsbYZbwfdO8xT0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?94/JTG3Cl36PgbzrAAsjZhLMf5prpv1MQ7UDlcdeo/44Yl7PaE7C1R6nGxCe?=
 =?us-ascii?Q?PVoS3nleT50ETpF6+G1FGeqLo6XOk58aVRPJK47ssMwG7BSyGpGSsL0qesZP?=
 =?us-ascii?Q?yfsJzlmExXWQmI17rED2a8GVeD07XfgBGG8ZiR5YiEVlYNgD/Bz66Hk3yY4V?=
 =?us-ascii?Q?4Ow/0zBcEBYFuHtphznslnihAGvfPBQGfVhRQFywuwzYZVTh8DB7qPazds36?=
 =?us-ascii?Q?HUNKHU9HwCx/tEUmqG4jt+fEGIFWxQQzkup8q2J+fQSrCQqeQIFVy0wyuUWH?=
 =?us-ascii?Q?r880kWRj/C7kURcy0ho7dE/dbjujmC9oa3uCvoJELUEyTJfHL+YZAmcHvRvi?=
 =?us-ascii?Q?VCw6mehs0s71O3p0HiiFqqa8N5KntcjPZxK5EiSpsmoxa+q4KP/VoVct6Ezc?=
 =?us-ascii?Q?S02FzMQ2rcocezdzbl12OYVPGCLByXuldhEsHPb0mlxjgcrHZ1gC0Bmybd61?=
 =?us-ascii?Q?T2kcjAk6jvy1p7JQz7H9ESgWM+lyNT6Bd41IMkXe81HxrEAPu4sQzttfDc9Q?=
 =?us-ascii?Q?IJMmpth++lo2ASwKCSfjpdDWwyd6mnQO+YERwURhQx0VN0mIJ0t8vLs38+OR?=
 =?us-ascii?Q?TkFIW/6o07FRw/NkoDALnkG3OMTOFTFKyuNeTugH+BawlaF51LbgW4gCrVVN?=
 =?us-ascii?Q?jb4KHEEckk7hT0hsumg6fuJYmnPu8kI5v8wSMKRo3f3bpP0qCQabSdkJiMQx?=
 =?us-ascii?Q?2GRJOppRWeawY5SNKYRf/7vFdfO8ZcOENzPwvZ7YwfVzBKxquZS3LWDuacxW?=
 =?us-ascii?Q?zFKXOwJMlT3D16IDwGqIaxZg6zcoBhg3UyukzP+AgMqDff4Sy73BHRfP2WKh?=
 =?us-ascii?Q?0F4A8X0lU0L1L6bLvpExDMsQaHqd4a5s11paTOoWlZsT2Dm7m/Kc9zgSoPiR?=
 =?us-ascii?Q?r+FjWwsZPtJafUrdAmC8MtMFqSjglPzRICLm5BYOehBHDe1PuQAwz4yoZMjF?=
 =?us-ascii?Q?0Bjf/+xq/WJYEEOkGwfTPDf/DE9GetsP+So9KrjoEpxeHqAAeUwQ2lnku8It?=
 =?us-ascii?Q?jggXcq8JRq8S0MySi31GpO8WQyt0JH0WsAOWFCFJXcS4pbfjiqWYyWcKriTw?=
 =?us-ascii?Q?XDzjyvQrPQ91wC33edGbT5com3Fh3itTGBup2bdY/k+Mb0FRzpYoHnMIIB77?=
 =?us-ascii?Q?DcWr4yLkpc+dAf3hfRszrMZWxGAE1bdgh4JXRXRQIHVicFi5kalA7pAAPGMK?=
 =?us-ascii?Q?Me5GENDV7KnmywuMM/m0k2w/CC3o61NbmZdjtXh3amqcUye6RAG7DNmyb1PU?=
 =?us-ascii?Q?x/+9PHN8wus4ijxoP4ZywjB3oclcYIHCcMPp+0oXchfpmvrXRrijWisFPoA6?=
 =?us-ascii?Q?Le6FafTEfILRm8iEIWA8+FzaBy1dSu5cLrJLbP3BXojLzQdVJ2UNoFqy+M2w?=
 =?us-ascii?Q?NAR4T1a6sWwqIdpwjzauDubiae6W+UJ8PE6FZnLLUetGQNbKpXbOPfkwO+5w?=
 =?us-ascii?Q?d88djQ9jCwh2XJGH3fMDfK1y9N9aHygMX3O6MYbCKj4s8gVgxzZhgbZqHdDm?=
 =?us-ascii?Q?BU2jIY173vEm1GGGUVHw365aGkhT4OSKCXlxIpyJNcIooSkMIlTlS309pN/r?=
 =?us-ascii?Q?fkf1EU1/jPs3OEonGXTO50VvE8waeOLU3tkjYynEU48iXSTzRH3rb1YMCoSg?=
 =?us-ascii?Q?HfefHRVAZRGKXBbJb5AM6yJrxvg0FvNoIz4Wy5cLkA6jrjak5QGwgiTvCGZ3?=
 =?us-ascii?Q?SPOAyXe73tYOe8xLDMzOHootM/0ekJn3KQmBXgP8S/A26UmyXS54+upnBxsR?=
 =?us-ascii?Q?Qw3XXONlrQ6sGvVkHDafHhIZwZrpCCs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4CF064AEF18E249A9827658F34DC7EB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2bWXARz9OJriQVFqhgcnR6cWar7kTL3cbij3QuuLknGCTdQp91pWc7jbj2SSRcr0uImarVALgB5Yt1Oi/r+noSJ6cX22H916MioLv8EjTGDt9w8fTp0GGiCUUHJWysTh62VEgmdAqPEgLFBVgYYF9A+a5Ecp0cbYO1omjnGxLz0J6FWTKqZWhITONKAXExslqaZv5rfksqaTG3kreOXZ2+1lSnsrGqa+5A8Z4WXPhwiWnpPq6PX3+76/ZXOSdsrDbpC/uxVpdZjPuEdhlGhCAI2tZ2mlSFQ75VrFJsDBTWJQaM6xj4qq7KNLYa5marMBOIfL1k2dPuz1nsCFMaNmyo6L2hpkPY8x/DVBHtH4v7pcr2LhxPbiTwLvw6B6Dy67f3XxBoSbs3bmWXBSlqfIe/6GiUUCFoHyYmFVjKFVsg9PC3Xo3boPjJdJpZ33EqIuaUj+/6I5Yg3ExbzNXoe4PQkw2TKgqKr9uDkKqEF4rfD1g879R3FQpLsJ6gH0sXnfCYtazMYWsKZnJa76NTPKnFF3mYOgoJYCEoKC/ypQ/AqRqByVr9Ayq920WVvib8qRs3t5StQ5rw0/yxKsOHuxgWW3pMC1Rercis5y3LNlZpU1b/uFeFnGlIlmqQv3X78o
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba5b2d9-1194-40e2-5cad-08de5d61bf56
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 05:05:53.6008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f+Rzeu3XUHeFN55gApAVNFNSJA6J7qDdNTNo5M4Zja5BIXZ9546431r8o0K4uiyN2GUq11tOokaJCbzrh3bptca7yPfitd056wcPIgKXO6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9582

Vincent, thanks for the comments.

On Jan 26, 2026 / 20:39, Vincent Fu wrote:
[...]
> As you know, we try to avoid breaking existing job files. This change
> breaks 3 test cases.

To be precise, only 1 of the 3 test cases in t/zbd was broken due to the
norandommap=3D1 restriction (test case 14). The other two were broken due t=
o the
change from zone finish operation to simple writes. (Still your point is va=
lid
for the single test case.)

> Fixing a genuine bug or clarifying previously undefined behavior can
> justify this sort of breaking change.
>=20
> It seems heavy handed to suddenly prohibit running a test on a zoned
> block device with a random map. Can you provide a stronger
> justification for this change?

There are two justifications to prohibit random map:

1) Random map is not accurate for zoned block devices since zoned block dev=
ices
   have the restriction that the writes shall be done at write pointer
   positions. The random map feature manages write offsets, but the offsets=
 are
   modified to the write pointer positions before issuing the write io_u. S=
till
   random map has the effect to balance the write amounts across zones, but=
 it
   does not work to ensure each sectors has no overlapped writes.

2) This change to ensure norandomap=3D1 is required to do writes to zone en=
ds
   that have remainders smaller than min_bs. Before this change, fio handle=
d
   such remainders by zone finish operations, but it turned out that simple
   writes for the remainders are much faster than zone finish operations. T=
his
   indicates that users will not use zone finish, and will use writes in th=
eir
   systems to fill the remainders. Based on this understanding, the current
   implementation with zone finish can not show the performance that users
   expect (This is the reason I started working on this series). The major =
use
   case of fio is performance measurement, so in that sense, I would say th=
e
   current implementation has a performance measurement bug. I thought that=
 the
   norandommap=3D1 restriction can be allowed to fix this bug.

>=20
> Perhaps you could instead emit a warning when a random job is run with
> a random map and then condition the relevant changes in later patches
> on the absence of a random map.

Actually, I thought about other options as follows to seek for a better
solution:

1) Leave the current remainder handling with zone finish operation, and add=
 the
   new handling with simple writes. Choose one of the two handlings by a ne=
w
   option, and ensure norandommap=3D1 only for the handling with simple wri=
tes.
    -> This can keep the current behavior with norandommap=3D1 workloads, b=
ut it
       comes with the zone finish operation that shows bad performance. I
       thought this leaves complexity for users and in the code.

2) Do not set norandommap=3D1 always, and set it only when it is required. =
To be
   precise, set norandommap=3D1 when,
     - bs is not aligned to zone size, or,
     - initial write pointer positions of a zone is not aligned to bs
    -> I guess this can be implemented, and can leave the behavior with
       norandaommpa=3D0 for some workloads. However, still the norandommap=
=3D1
       override is required when the conditions are not met. I thought this
       complexity could confuse users (Users may need to move write pointer=
s
       to run their workloads with norandammap=3D0).

3) Modify axmap and randmap handling to support block size smaller than min=
_bs.
    -> This will be a fundamental change in fio and axmap designs: min_bs i=
s
       referred to in many places. I don't think this approach is feasible.

I think this patch is the better than the other solutions above, but I'm op=
en to
other options. Let me know your thoughts on them. I guess your opinion is
similar as the option 2) above.
