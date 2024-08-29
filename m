Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28569EAD5
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 05:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724910291; cv=fail; b=QnwLVADdHmXgNoTH5GSwBN8826uH0w1bRxpbL2b8D2mGYI878KeLe9/xdtkeI8mGihvwEWNoBdu2qctI2R4I/X/R+rRjbAGN99DgCK6Qa/fKCxyD64zsnn29SFulf8qlaUzm7qCfjtKsJAvmCs5Uq6G+kpux+PwBYDvwbWESzTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724910291; c=relaxed/simple;
	bh=N6f+wQ1DFDw2Vtu/o7tbA1txcLS40eZ0Pvhof/3lm00=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lxZemmc/eCQfZThFm8/wmPOQl8cGuNynDNRyCoaiNX6tbkrJ5AW1HT0Bs+2oWhhidtuL6C/AjnxbW8V/BjCKpvB1nq3fjA9KRIMjAgmXWRnFGa7f4CUe2Y6jQ2rcprWp5sAS0RiL3w3o18gj4HbzgfR7lm/Oc25Qv6/il2ZVdH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Eke7zkJS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zSiWlT4K; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Eke7zkJS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zSiWlT4K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724910289; x=1756446289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N6f+wQ1DFDw2Vtu/o7tbA1txcLS40eZ0Pvhof/3lm00=;
  b=Eke7zkJSVBBuUEWh0DGztuDRRY0La9fP6jFrUm33+O1HhcrfmyJLLQcP
   1NwWGQKdGSjdaNtIGlnOabH606qA4QxsTmDT3lpgqebXF6U8eykpysp4J
   xnx11LJkinpSx5ONQqLN42g9dHWDBIjCpcZZDpECNW3yuY+QkXXPelj+m
   s/6FDEUeejHFfvui230aOcm2CeC+XjV/r0JkeFNdwRBoFYVgQCfZzEA4I
   OLQW5annx4jTmQTYZyih9tbYsawMMVUJTfcmjnr7qQiRHboCZqL+b/6rC
   +EAGASAhkn12r3RRWZtFoRwY1rckLSnBYn8VNiFJ5Cw+c3Yzd35zJu6s+
   A==;
X-CSE-ConnectionGUID: iS8VXe2MS+2VkQVw4dPpJQ==
X-CSE-MsgGUID: O1n9tub/SpS6Tqo6ljNgIg==
X-IronPort-AV: E=Sophos;i="6.10,184,1719849600"; 
   d="scan'208";a="24841363"
Received: from mail-bn1nam02lp2043.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.43])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 13:44:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2/Q0kCjnV96g/MVQd71N3fuX/69HWHpRUcNfkZYh4clWu7IG7WdS+ramwodIMB6D9xZTANBD+K88aMbg7UYuYVrCvae7BVFgsH1SVVdhQvL8AppRjp9clrfJbujowY6Zg1fJiIok0mNIEQ6YVnyLRMC1kyFhv8GHSAak9aJvt9dsa3Ac7mXAbjrZIMAhOmWCVhK/ZDe6qWYGx7R6DEXxmOXBELS891rnd7O/kL3yd3VnablUOoSCdY32HdvFcXv9Rb/Dl8kZtNWeMoYhAmIFl607L/gpGrsXFEuyl3j/olCjX15j3ucf0NA+d/D4FPCGVf+/RjCYqCm8lkRtZ22Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bu5oHWt6x8+wtq5+0oXVAjbugDzGQenjIWbbR2SDpKQ=;
 b=oPcsazpXc1S3XwcSUarSob/q0/kEDljxd+sHfIQ/DePwGOkriTyTx87gp6N3u1XqmxJLqcCMO0jLN/eVCDbJ06wIerfXEg2dqkt7ZaVOx5P6QEq0Cek/cUrtxxrF/JASPPX2oH9jb7eFyXVPKJNdaYLQR5KqibmLrXJcZUzcjW6Ic+DMG5pXLpUxVIPQkCU039qFUkX7fccYffeN2peLRDjKNnAW8QmuZsnAAGE6VeeC8gJj+iZRKKZnOth5ptAPK98rZx9i03UhjkDbknkCKcLYcWiPGsHQV9LNnyE03tL8fTgG4L0OB5XOFAo3ZrkR+8h0pRrq0WuEIAj5Qn5liQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu5oHWt6x8+wtq5+0oXVAjbugDzGQenjIWbbR2SDpKQ=;
 b=zSiWlT4K9t/WxmnKOnIl0xh2l/8uSV/9GuSdM9/ofE4d2U4ou284iQjns23Zy2qHm4f5f4YTQC7ZpytgIsp52Kb3g3lFO1+uVbCoarp98FRM7S7mQjQOZ9w4csbygSakdr9L1n8SkhJhysw2PO0fhXcx+ifTKoH90Q79RTrtYj4=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA1PR04MB8918.namprd04.prod.outlook.com (2603:10b6:806:375::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 05:44:39 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 05:44:39 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Nick Neumann <nick@pcpartpicker.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 3/9] iolog: refactor flush_samples()
Thread-Topic: [PATCH 3/9] iolog: refactor flush_samples()
Thread-Index: AQHa+FAC3n2dA1vSjEiCKTWras4qjbI85eMAgADWjwA=
Date: Thu, 29 Aug 2024 05:44:39 +0000
Message-ID: <3fyoa5ncnwgcai737ipmnhp5pkikchsjfxgcvaz2qdgxefmjdz@rfdy7fb6plgq>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-4-shinichiro.kawasaki@wdc.com>
 <CADqNVTqp0KDySU7+5vHmAnfBXorkMZnYVrQAcKGMsSFBZfU7nw@mail.gmail.com>
In-Reply-To:
 <CADqNVTqp0KDySU7+5vHmAnfBXorkMZnYVrQAcKGMsSFBZfU7nw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SA1PR04MB8918:EE_
x-ms-office365-filtering-correlation-id: ca19f75a-d2a8-4cc1-cd49-08dcc7edac66
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?gDuGZB1wdyTgKOXLplAHk6rMZnT8M7jcg/SPtvOrtymcSjRdF3cxHAKOqCe5?=
 =?us-ascii?Q?0aZ7RWWz4nMbP4k1TNh5flpycZwiRHkjm6L4n3pLjDiSIJ4a1vYa9di0De7A?=
 =?us-ascii?Q?VdmdgVu3nTUq+jgBPeq6H+H6R+jKAoRy2MdmQHRLYA6nKuUHYYJ3yRH714NU?=
 =?us-ascii?Q?qUKyqe9nqayJgGx/yhDicgiYuFcKWcHd4aUFZR6pT04cvO6eQo1YjkJYI0k4?=
 =?us-ascii?Q?ndYMYmnjaTB/hnma6bjYYEuozKBp4+LCn0wT1mxe3UjWEzoKxbJNrLaEgJvB?=
 =?us-ascii?Q?tfZVHYkIc99d0UoZdDE9zj46dp64k8q+Et+pK14wdEbZzryXhVpcEbln7Jkj?=
 =?us-ascii?Q?fN/r1K86kmsUSbZ73cWvm4V7/cNF8MvFC6qPPMvNvbC6rA35zNTxPJ4D30Ie?=
 =?us-ascii?Q?8qvevCAx1mFGJc3dL7AgqNcji7tk7IOoOawdCKVZwXuKzanCwEHyq0mdrlFM?=
 =?us-ascii?Q?t6SsKmVjuctodeU+BMqD+TcmmCD89hM5jKa1xsJ1RJu+GwO8HUqy9isXMeH0?=
 =?us-ascii?Q?lmjczlNPUytgcpuhqaLFbpGoy7ErDT92mEvNhOq38nAT+hRkyjtxabuaCHQJ?=
 =?us-ascii?Q?QwBD0VCOdcPY5rdxsdnAbr3HFct5oScBsFeTXPB4vQNqQuW+2Fgp6G7HDPU/?=
 =?us-ascii?Q?iHGaDWdqiaNu4/QIhv+hnmdT20evSxQH5WYZS4q+1J2+njJCEJtKlg0oScC1?=
 =?us-ascii?Q?X1hL0a7+fq3laQVQun3N/gUoeM/L0rXEfb6sfBVmdDeKY41UDcYGoYeumL4U?=
 =?us-ascii?Q?BCwOtKADgG2sYQMqa+GYZwqU7jxY9CfYkNylN5Zy7KOKo3TID3o4YmOJxGQH?=
 =?us-ascii?Q?vANU1tqXKGwGUYMbGIOVqMHZGiCncIlo1YN4WijX6YuwtQBBaanmMkMQtLwf?=
 =?us-ascii?Q?zVT9XRE/BHzu8BLs+bGVK0hYKzNXdGqz7u943lgM194KDA79YAiFBFjQIrrI?=
 =?us-ascii?Q?BnM+LiTMlOmoGi8gnhs1U2JOhTY8UOTm+sCAkLOld8FQNA7udSpazzybKDUP?=
 =?us-ascii?Q?em4oMQaVJAlNi+4ZEgfhvzcWEjWhhQueA+RdOmlQFxGt0+S8Wv4f2bAigN/E?=
 =?us-ascii?Q?o7xKFaDvWzLbuNI4Ynw0Q4TwDyt9sccx6NL4JenzxtoFC3KRQ5xrP+KzqzCq?=
 =?us-ascii?Q?lZ+4dQ+jjV9wIg1SrUG3KheGtXQ/XupDl8itP523TCLRbWBEY1xM8Rr6N79j?=
 =?us-ascii?Q?kaFYMk2qfwC/SSYzuhsUtF7CFu6DLRtIUYikLORCx4VDJwyhTl2tLiqEN6ZX?=
 =?us-ascii?Q?p1ntI2+WcfoCYTV/Rlfa+FsgKYZeESLvCrpnKOoLEFflDkE/mZThqQavoGnH?=
 =?us-ascii?Q?yBd8DfobBrLwncqK6nAN9coiX4DUFdSPk4AewHPxWe6sGvy4V2M0cAFYiLRk?=
 =?us-ascii?Q?jVStH1PuoiUYOM0ua5lVOmxz8gZwuIJRKENp7umMKN3Gq708pQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UF4Ye6mC8NWK3B/YMotvLCILXaztwy/hTps5RmhNmN0LPd/51HyYZIf59ULP?=
 =?us-ascii?Q?3tm0+UdpOOh/mn7pYddD5IjJ3pncZls5mnWpGc0gGhhHzb/0+BEV68KfcF19?=
 =?us-ascii?Q?TLGOiiLjFpHedaOLVi7bMUn2i7g/VRg87o3tBSJQEdvIsVjeIdoJZrMQnMAw?=
 =?us-ascii?Q?Y9g+Dg7nP1yZO6YcIl0KdGgl5czn4CTJgwjAgj+BgoIBlLXSub34mOmvjHNH?=
 =?us-ascii?Q?F7SsAkauyW5MU97dbKX9tS+svysPc3J++pv2DXcG6A4s9EIpBFqeIZ1jJdrY?=
 =?us-ascii?Q?tGUsJHgizoXulX4ciZab08DUiPf4Rk6CQSkSI/a3hnrNx1YNmKlwey8CtuYM?=
 =?us-ascii?Q?AhzWtLF1/tBsSPiiOD/DWGUbhoZ6hto5xOeEBHi0EpqZ0o67D09+aUYgPzdV?=
 =?us-ascii?Q?QL/ipjDfRKTkje8afmh+HwTxKNBaJem/XzXy4YvDCizKbvEaLSTWACLftdgm?=
 =?us-ascii?Q?3ro+brriUXyaDVDnQnNixcNIPRco4inlaJYkIjhZkLNIR3qtvPcTIOSmhqli?=
 =?us-ascii?Q?MbkVPrWyjKRLy6+U9pwyffwZDrykWbiKwkNQ0KbjPXFFFZ6GucUh5CWldrCi?=
 =?us-ascii?Q?HZ7Q8lldQMDEB5TtMFbfjOD1OZZCSTTDjsQnFo9Kouijf4AhgjTd8wp8lqUu?=
 =?us-ascii?Q?hlRBLsYUm9r+b4j7FRiCbaphbGHdWwKs/y3B45URP6nkUBt9tzsc+ZFW9wUl?=
 =?us-ascii?Q?q73zTYpjsDfe3GzADDePncFIOPPHVch40snfuUWElKkTzW4T5i/3nWBo2Zlx?=
 =?us-ascii?Q?gNtPb1+iHJhQfA/qOfYX0ehBvC6VeOJnAxkZi5XO69fofnSJPT7ubjp24Ask?=
 =?us-ascii?Q?QQzOJ/90x33iskGUhk5OpIWXx0YVh+OqGk8RXPWWrmVWF/78CCwGhpcIxPpC?=
 =?us-ascii?Q?l5w8dlsXTp90KXfJeryxdmQyT0YkzMJXr/ctuS2antRwC4LJ+7xnNvO6e1qQ?=
 =?us-ascii?Q?Abypcpt1GqBedNeOSoLw/zkcqPKA+hDFcbldB/yFkAygB6+kUgRExDXNrL9C?=
 =?us-ascii?Q?qdCU2m1QGkO6NLnMad+A6oKFuvO48MaiJdB+Xn0LCLaOHzIeyBu5LZp916p+?=
 =?us-ascii?Q?+g+Gfe4VilSoS2U4gkugRtHAfw96n6xGGEHeTMZbO+Kd0ll2id4ukoqvP5P9?=
 =?us-ascii?Q?fZi6P4gV7SVsd4nRGDkU8eCBr1cNZgEsZZPWWKdlDp9YBL3F1RoR4NKEJVoz?=
 =?us-ascii?Q?Es2xCa0uo34AV7OZOJKSbgt6D1eusEHmRiK8xa2qydc157M0Zzl8D4cQmOeL?=
 =?us-ascii?Q?AoPNq//2nOO2nAdh9Uteqs/4Q0j8KpVHxrruD6MaxADCTCgXn53s5J0v5Ugw?=
 =?us-ascii?Q?3zf7Z4HrsKRCBCm2IHg0DqjyZp/z+ft0GXmBf06XykOCRxoutNI5xbHbY+fT?=
 =?us-ascii?Q?NifIjFnxnINtLDSdJGw1K5SUJem8701ltiE/kSUIkvuqtNWJKSldaREB9LOc?=
 =?us-ascii?Q?1DuVZSO9hlh+b1K2tkmUX1wijXo/I6xK3hAOCKaCbi+fMwtpMbfVItVyI+3k?=
 =?us-ascii?Q?rhVhAZ3AV0fpXj9/kM7A0Z242GGW3+Int2b+A7kdwPycuD5I9r6aBJitfNIr?=
 =?us-ascii?Q?wRtVL5Udw11ZzlT0xRq6vJ377dZUjShhVjIPtguGbM+8skagsQ9QO6Wdein/?=
 =?us-ascii?Q?Zph2TKuITHFPhFptN0vGtHA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A80B20A2A03E874CB1B6CEA504353DE1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wwOqTZDHYPGPWT3w7k76m6m7Lspt2x8zIXhnq/UXRUidkmHuZSmeazpovZ3PMsb/NA8osp7x3VLt8aww2SV0Qu3txWez9tGCd6h48RQkFtjCkjFwH5oDOvis8Ae6CX/BtZgL8hAPb3LYQ8l6yWYJPK8SxNPXFAtpWBbQGs5JT8rj0ybFeJyTyjQKUzUwf9vZlg/sD/2KV4qI72TRQinrU/9oO/AP4I0NNoXnOUW2bGJ6AtS0ui0tska+jdiiOlDTgN9f64j4LxadS50COM2BZzCnY/QT+jUbfzg9yiS+Z3AgxqVkPeASdeV8IPixcx33w6nMdSbcP0OQhonOEZJkHjAQpKMLAgJjd9cTUGGHoD+mV5FLvO8rn5C1VvOXgUUssJvXIyipwQQGRsYXk7EHpUabCdiPILTJ7qDx1pgq+LMy1J/iepmGOEbbBK+CtyNl1gLNzXR0Gqygi8ClX6ei126cMQvWFG0Ch/dEZOnrYHzSRRadzBl9xkGCERuSpOY3JEBjjQ1Xb7jDG0DiBlqRxqDi9QzKplgKeSQJYFtWbxhKQe9Cs1fY5LaRfZnM4l3W9UFWuBWC6PUybBDQE4o3L6yWxh8aqp15myAAnXKYgaiDZOgGKN0SsvpX4OGKhTnn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca19f75a-d2a8-4cc1-cd49-08dcc7edac66
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 05:44:39.3042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J2Xzz3UjEs4zr8ZhTh9nNdMPl9xH23TeAZ8g9uSvPWv3ibnmaKsrEf4Gq0q94VpljZz9LrTfB9s3KhlexCSskx9R+jJfViw03lJIfjSE3yA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8918

On Aug 28, 2024 / 11:56, Nick Neumann wrote:
> One quick observation though I'm guessing you probably have already
> checked it. It would be good to be sure the performance after this
> refactor for outputting the log files is similar or bettter, due to
> how long it can take to output per-I/O log files.

Good question. To understand the performance, I used gperf and compared
runtime of flush_samples() with and without the series.

I built the fio with these commands,

$ LDFLAGS=3D-pg ./configure --extra-cflags=3D"-pg -O0"
$ make -j$(nproc)

Then ran fio and gperf as follows:

$ ./fio --name=3Dw --filename=3D/dev/zero --rw=3Dread --bs=3D4k --size=3D12=
8M --time_based --runtime=3D1m --write_lat_log=3Dlat --log_offset=3D1 --thr=
ead=3D1
$ gprof -p ./fio ./gmon.out | grep flush_samples
  4.96      3.73     0.63       59     0.01     0.02  flush_samples

The second number "3.73 "is the cumulative runtime of flush_samples(). It w=
as
3.73 seconds with the series, and 3.50 seconds without the series. This
indicates that around 1% overhead is added to the I/O log file output. Fio =
users
will need to wait a little bit longer to get the I/O log files after the
fio job completion. I hope this overhead is acceptable.
