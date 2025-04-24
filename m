Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CFA2701B8
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 06:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475249; cv=fail; b=PqAQ7mGWn1VvVkOtOUiWyNvcn9iEfifxyGGn3lBjS1mIxDGCV5bephh797/ja6lPDcMOHdtkTfti/i0nXE9DtFwWXJVvLgvM3L2snMRBrQjl110xMYwrhIgCPitrC67TStI4Eppv4dji7c5XCWLZRYjCZaXXCkyvgkMkyEUMlnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475249; c=relaxed/simple;
	bh=p7Ynzc+21gzo76+tTIDC5ObQtbrHq8XAy6FMRfVsZgE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QhHoaTXMXuCDSGOclcEcpw2X7HFA1HbxOA0xr/1aKn0sl/BEB1s0TRmuffU9pQ/jSLisxvJDMKywG6wi6Lni7hgkA1rdBzhHdm3bJYNrL1+jqlmdRjWL70v0E42992K1OuA97ERyhImPoS21hsi2NulzaUbpcxOcYDl7gVKIH7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JIZXfKKm; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=sFZUazXC; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JIZXfKKm";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sFZUazXC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745475247; x=1777011247;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p7Ynzc+21gzo76+tTIDC5ObQtbrHq8XAy6FMRfVsZgE=;
  b=JIZXfKKmNwV0tYC6k0e4RtnKKkakIANoS9qboA8xYPDkHe28zQ+7Mxxd
   ioIXAnMQyaMeEnP72hZLwJMYgUUNx39Gu5u0jdUSfRhfDrMGLS5VdGpD8
   cHTKqtfxCgMgp0NGXd30EcSJ5VtNe8Jo9Ej2eSickMhrmsIQSihm5mjVL
   flZj/cMCI1JHm0OHmbvXVrYK4clGRC723/1jvxHd8lvj08/HHXUZQU1Ri
   LL6FAVaKkk8GGTN0NelrUe8TmnU1iEXe1kHuJ3OCSJtFfHCFINaJJTosz
   83B9A08qWeIParfKYgiYlFHUS/u2fiIG3UGYD8aSBlZ59nJ3eKaUEoG9G
   A==;
X-CSE-ConnectionGUID: p/fSPS82RwKbfjy5kl7D5Q==
X-CSE-MsgGUID: jmL7BuIPRSufnYBTHGUz6Q==
X-IronPort-AV: E=Sophos;i="6.15,235,1739808000"; 
   d="scan'208";a="76343433"
Received: from mail-westus2azlp17010003.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([40.93.10.3])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2025 14:13:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gdkaf8N05gaso1WmEsKIc4gQQNUC+J2ABcpfSzqoR55VoDWKb80ZUIyAAefbm2ggk6BzXXEzumZBSJrBUYytqSjcC47jUoKkKIL0va6jEkGTz6bbZikGyF1IeeJ2K8x0NiVl/bko1QLbqtTocu+NPj9znTva/vU94OlCbR1ikqmsTMmkHFqUJo6KGYpfo+ZMlTrxbK0yCwoU7Kmlm4ATnScWoTJuPMZUvn9us9YloqGiORPm9LOwx7Z6xr/coRSpNbW0yI3BxYEx/XmYzedDivvM6KSEzBGiH0ZjSwsP+iSGkovxU4xbUiAs7x36mRX5O8GnrCyp6Tu1yWG4Oc4vPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7Ynzc+21gzo76+tTIDC5ObQtbrHq8XAy6FMRfVsZgE=;
 b=Z3QFqp8hhgvg8gJ4rCCCQWj4F9bE5UUzuwkY1b6dKLfDyFZHket0h+ks19bLUQwNOlSI/bE98hvQ7yBBD8tyK3+0c9FizIMhfwWLy50d7p8zV7qgqn7v+dUVKebocLvDTKL3vg2k/HTLeqTZlwffCpfhvZWeYwDZjQkdAMh+4a23wrgRw9ZS8KChF1ABPqVoE+e1cF3rYule7mjq7fb/MjVZMhfFZ8Ej1LXs8TimVl9QXuWAo12On7OyX0n6soAe1513ANQFOpPJOkfFjHBbkO2sxRUPdRczBAueL49UN7gOpQ+c74RqIKn0LyZM+tO/uR15aeW7keE0MhxdwQZgIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7Ynzc+21gzo76+tTIDC5ObQtbrHq8XAy6FMRfVsZgE=;
 b=sFZUazXC/AyLmPm256QRTSZSDXshX8upwUFTaRs0WMxpQkdI5YrUqdPmGXcs9+pDiT4opsaet7bbN6IQpkDrrxtoJLSxsTFyR4Z14bZejLh4Niq1joRg9Fyt8sSdsvVtgY32bI3EAO8ODU0X1vsF+Vh8bIusN3NRSPg16SC4mz4=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH7PR04MB8923.namprd04.prod.outlook.com (2603:10b6:510:2f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Thu, 24 Apr
 2025 06:13:56 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 06:13:55 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Sean Anderson <seanga2@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [BUG] active zones exceeded error with max_open_zones
Thread-Topic: [BUG] active zones exceeded error with max_open_zones
Thread-Index: AQHbtHLH77+zun67Ik6XWhsgb7UqFLOyVzeA
Date: Thu, 24 Apr 2025 06:13:55 +0000
Message-ID: <ptncklg56axp5463pdaadt5a3xxepeu4vnnl3qqtg3k2elpsmj@lcl7boaxswn5>
References: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
In-Reply-To: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH7PR04MB8923:EE_
x-ms-office365-filtering-correlation-id: 858cfb9a-6648-49cf-ef09-08dd82f731ba
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?KF98oVUByTJcz2mqRAXyN9aIzl3V8UpbKslPk4mYg1wKLeQOjUYHxqJqNKHg?=
 =?us-ascii?Q?M0+16/49rCJZPM+LHLPSo071GzCwnl7qcavlBJGIgSoWveClpTPTTE7s+NgH?=
 =?us-ascii?Q?sZXZwv3+id0hTrpfLfjlviTW8WxRF3uU3opI1kSIewvO7C3tEvy3MlS4TRhP?=
 =?us-ascii?Q?rWWW33YK6gPaHsWraJL5NPS/bXZdJQe1Cn3XtajupWQigjkrPWWw7/ttS1mO?=
 =?us-ascii?Q?lMFodHK58EdGh+0W2WU4RGoHjLVSGmieNwu4uk/wEwIlaezxdOq9ne5a9De4?=
 =?us-ascii?Q?yGBsA+jrNdTISwpG3q5agqA22s/hajospvfnKvwWYvbFWUPP6lOgm6gpTpcO?=
 =?us-ascii?Q?C2eXKacOt1r5befOAghEKm/FhcjCzOPKJlch1dkm7ljxQlMmwKoEHIHhfyAT?=
 =?us-ascii?Q?cANzpVXMT7u7TCuwql7MhdhD4Vp9sG/uEngmv5R23xlyLPLp15xpGkt+moo+?=
 =?us-ascii?Q?5ad/CQ6Wm/HgVMIH42/766GCcb8fY47QtLts0gmxEWmACc2VJzNSmJPz3hB3?=
 =?us-ascii?Q?VtbYKwFu2BZ8Ybz+9hP45MvdrFa8obPtDMLGt5t8i7Y8ZK5lt1uYQQaQFrAv?=
 =?us-ascii?Q?6u/6fLXkKRvGqaTtJPskfWZ7A5gOuip0CrUpxnO1ByvkkQcoF/Tz9mTy/cNP?=
 =?us-ascii?Q?0dfRePYEc4RsidJhTDhC7zmdQgkUBRcQf0ScrBNMW2h6KH6DdQH+AaVvGGl4?=
 =?us-ascii?Q?tYj70I2/Gil9w5SHozqql7wTwzV0g3vL2O/9rMlS0PhUdOU6SX6sv0w1HTdO?=
 =?us-ascii?Q?hIc5MMkal+9g065mN/7vAvOPlfrKNhgDv3WgIlIpWBIZsfWRwzF87MAt2QxM?=
 =?us-ascii?Q?H5TwmYcsSDv8cu9NVp/aL5vhx1DpkLDaboBdMQMlDXB9ErNybedAEWlnL9SV?=
 =?us-ascii?Q?L8E1DOjAGtzHgxThenb0iK85nP3wELUfHNAMaZX4SldbciNhGd45EtawY5U+?=
 =?us-ascii?Q?Z3++KioX923fAn+i/+oQYcS/WRjliRPyEmxu5JGB0hyw7/g4RP9ji8zJkoba?=
 =?us-ascii?Q?vwQXNkwtTyKSCzhrrYpYI9Onqu6nXRycN5iMU9doW1OCPntFi0MQNF/hDOKC?=
 =?us-ascii?Q?3Yh/o/wfH+VT6mvlBhZuVmyiqrr+y4kQmrmp3trziIFk1cRtokTt8nXZz3V3?=
 =?us-ascii?Q?j2+CcnuoIGkx3ydQl7DheV5h3b+Q1R1Je6PWZeOA8z1iBZlMB3mVIEoTj60t?=
 =?us-ascii?Q?dUia5SzqF0eU9TaR5LBo2FJAHXZxm7Le+usPVwuuePYjPkY1KU2J7UhbcloP?=
 =?us-ascii?Q?MYHq/PZeRB4aCXfF6ZHJUUalGtYpep3uf9jEkL4hUlsW/NjEgi+vFbmCk5QG?=
 =?us-ascii?Q?suOxw31tceOzZ3YY/G+cVJEawTzyTsENdKDPZL88AAwW8WUlmnqNRerxpYhh?=
 =?us-ascii?Q?XkUhP4sIuesSeQ96jcVkZ6BBgl7ArQV6Ow7Zqz4J2ueyArBO/hukt5TH929d?=
 =?us-ascii?Q?cQSlr/RCf9o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zwcytu3LMF1fksfrhecYPGhVSBlv+zKcLC4XtoL6vxJ+giI05iDhxi0gMTqZ?=
 =?us-ascii?Q?xVWrgzPN4ckcmfUkdMhtDiGemQ9T3xkj95BRgppAN2PvRSGNNrTtnvkoA9O/?=
 =?us-ascii?Q?tvYb9MpenABrBKoTf+AO119pE34eHVL7aSKkoTB83vx/ZmZ0rtah3q5e3fvo?=
 =?us-ascii?Q?1P/y/KBsRv5QzMrF9X7rzkYfY+5a+Tn0r1CZPNvvX20yh3nHo2xEmhYV7OqR?=
 =?us-ascii?Q?qrNJnXoBfb5tcscfXlPpZGWN1EMfma9pFPz5r5lMOMtW2Hrl4Y6PMP3AavIW?=
 =?us-ascii?Q?dpiyOOOd3K1BbQRWkEMYuqhnOAuntRA3Bn4sDpMj6/fYlyfYRTR1jOLzngyO?=
 =?us-ascii?Q?NJ+Dk5+bZZm3frfxH3RJPk322pz3H4jH0rMHWsXVqeAVbYJrcJhZ5SJd0+2K?=
 =?us-ascii?Q?wxEr4iB0PbkNZeOCrCVxPa+3nju+87E/hVqB/ELthgcEhcOzFmWcwPBoIoGO?=
 =?us-ascii?Q?t72FBUm1muK/vYg+JN9rmRfuVhCIVq+ehCNMA7vgjXOMMmUtFstBwPCkaUCT?=
 =?us-ascii?Q?IEt2w7HKyILkAxytHIfm5uFSn8FIcewJkH/pTEN53Ng7OhtY2zXITvEM18xf?=
 =?us-ascii?Q?yk0FES9f/+yqkKR2pKSSbnXuHBxQqITa122CVmtzmXozltAAIdT4YzxMqvEa?=
 =?us-ascii?Q?HdWA8bPytiAfR8eci2T+OkDAS0wYb/YsrZtMxrMebZVKcdKKyG2RmRrrJ+2r?=
 =?us-ascii?Q?EK50+4PsVGfCNkXrGW5RWnQR8UvFdASKiQY6WRnylWYZBwb1Q6D2sAwAHEkn?=
 =?us-ascii?Q?pvjfmN2lxAjgx1Fsy1Dw7KhnukdUXK/l5zV3ePEjH8yxZgi7xU50n2AyA0xC?=
 =?us-ascii?Q?HmCY399RF/l6DLd3ZS3qHJFgcheQNcyKnezfTRfgS4kOAIz6F0DcOgD82pem?=
 =?us-ascii?Q?xRoUt+Y8e6g47JQqoSi2qZLAavDIgORvST+/K10TP+t2C4jVCk8lSaktjGs9?=
 =?us-ascii?Q?htPBE9FkzvnSbrOzgM/M/UsshLC08gwR84ACN99VY8EX0jxjL2BErS+ljLK3?=
 =?us-ascii?Q?C5uRXh24XBQWTpEEyfDxdMYr9PXkwcw2OGhTeyr+Y280/tVeyzzNfJgFK5tA?=
 =?us-ascii?Q?TqQ+aUe9yDTNI9OqTYVyteh0BIrt0+I7XQere/Hqg+F42Nmmy9pUhj03ftj4?=
 =?us-ascii?Q?4Le7l3QjQXJTa3RckEW78WkJz8gvIHd8ruQGCm9NRp0IdDiBtFOaRIn11d8S?=
 =?us-ascii?Q?nLjc2FM9nJT57SF0d1e51A8BP44cU8kTS5bnyuGYDIjZqyjw//26rs+Db9Am?=
 =?us-ascii?Q?zYGtLk6lOD3ls4Fq/NS0FfHCSZd9TnM4MKy8TKfEwKryPKc/Sqn5capuj8Na?=
 =?us-ascii?Q?i7dbYFxGUOx8KeK1H9eXF5tsSNODQT2Ll08Dp6W+v/EEREW0mNJDAVHScDDK?=
 =?us-ascii?Q?iVAif6y8hokWTyfCbe4A8/09PBYDH2nh4VxFlMimaFaTwIxm7/CKY7UNCHiY?=
 =?us-ascii?Q?To5Ex3tSQIiQrLgj5k4ueSuNo3US+QKV9DRTLPvi9WskFUgMY4J+zYySFXOE?=
 =?us-ascii?Q?uOOoBvtGCZTBAnDcMFul7bpq/2dnIlV1+YFakNBu/kegYz/r7U9D5VMPeCmK?=
 =?us-ascii?Q?dGUOT9dS4Q2UArf0Rr2E7HarLVxdYFOxVVcuEBseaZZ+yh4FQn4ih9hRf5Ur?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75DE800D7FF9DD4AB339062FE127CD6C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zz/kOhzDjohmd7OnnhtQMFAPYkphoaaomzxrMPavZVP4DyV9U6YZVwhPQaHPHvG14rUcXWe0Gfesh96ctQph06ZIsf/EUIm0nMbOzztUVZbfP/+t897zO7c9gR1A4UlaRTv4nbhWnTYtFGVs1OrQawrTWs/c+YTYFDuggTU4pfP+/IXu3sXwfcTDOwbD2+u4e1uGRUmUZr3cVrUw5ylBUGXQ7Mn2efWf4/7kn+291vETeH7NSEWOEIsA8MzJ0o1siyGwczHHcVSTfqYyVFcr9vaRbgLUJPbKwphlm4fbZKpg3+d2TORbWl9N/e7XWbrI+9oPfZGB25UZZku/aRcv4Me/+ehOyBSH5zsTtzRsT2ISZJc68H6PdN64aK+scfINk9KvFGJdJb1Kwd1WrrLR3/VpHp02NXqFiVeW87+eIWM5b3YmUAcW7FN66eGe9zMTMdu9Yz4iNSmhBO3lmLoYsvKSP8kpVNW7RVg43W5E9Wj6SuciwcsdOx53Xq36xycEeVFdgJnns+cGXab8bOgnz52oX3qqtNGG3f3Gpfn072uGIQJvdiAKFRLQRtfsllpGDjQXJ6jfOIiL15xrvgHPyT6t9UhzIdcR7u3ghqIcbP+WKRt4HjqAKP5nHPL3VVAR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 858cfb9a-6648-49cf-ef09-08dd82f731ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 06:13:55.9104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xsoTXcc32eLHXY8tWsPAuAdUF8MdC2sRa2iZKdNWckXbTiT7ONymGdAI8wKKDHUHy4UPeJ7KwKng+LABhkiDvaEW+fhzf4AvKY6xxV0wGNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8923

On Apr 23, 2025 / 13:11, Sean Anderson wrote:
> Hi,
>=20
> I'm getting an "active zones exceeded" error when running fio with
> --rw=3Drandwrite mode:
>=20
> # fio --bs=3D4k --rw=3Drandwrite --norandommap --fsync=3D1 --number_ios=
=3D16384 --name=3Dflushes --direct=3D1 --zonemode=3Dzbd --max_open_zones=3D=
1978 --filename=3D/dev/my_zone_dev
> flushes: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dpsync, iodepth=3D1

Hi,

The block size is 4k. And according to the blkzone report, it looks like th=
e gap
between the zone size and zone capacity is 512b. So, I guess the fio can no=
t
fill the gap by 4k writes. It looks likely this unalignment between the gap=
 and
the block size left unwritten small remainders in many zones, then many zon=
es
are kept open and the device exceeded the max active zone limit. Based on t=
his
guess, I suggest to try with 512 byte block size to align it with the gap.

> fio-3.39

Recently, I contributed a fix which handles the case many small remainders =
are
left by random write workload to zoned block devices [1]. The fix was upstr=
eamed
after the fio version 3.39. I also suggest to try out the latest fio code w=
ith
4k blocksize.

[1] https://github.com/axboe/fio/commit/e2e29bf6f8300186d267fa46a7b266d14d1=
74575=
