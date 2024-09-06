Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F683182B3
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 02:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725590010; cv=fail; b=s0qiCLmjpTEMoNpPy1lkWJgFoXm7Im4uc6B6ppxn68Cg/WdJLlmXkZshefc/hk4du17uEz59LYykD+Mpvx5utgnSTwPfqXitzxD+ZhDCbZCGp6ddUdsDMIb5Lg6QzGnFmX6rOWW5TW3dri3KdVnYatLQdEfWGW3F67oOLwYPtNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725590010; c=relaxed/simple;
	bh=r6rXEh6HHXdKeJV8ER1JMUbMffqLC7Jayy+b7QWlS2w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HUK9LNvP9ZMXy6tuOa0CiLtdb0qCjaovZejeu3P9WbMe+By3YYQtUnjR9/BuROQy2Fi+adCd9a2e4Qznq84Qo5Rv4hoL8MSj986QUn6aweRB0uHawmga/d5rLMoAjFKpSI/iP4sdDlzo60Vm+hvljr6yhxNiyynIL9UzoG3RcZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZBMg620c; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mX2Zimne; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZBMg620c";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mX2Zimne"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725590009; x=1757126009;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r6rXEh6HHXdKeJV8ER1JMUbMffqLC7Jayy+b7QWlS2w=;
  b=ZBMg620cdJWMuh+vfHMFipczPfnr5FJ550wHOqT+zLLhk1M9/QuSSIwV
   BehENEV1Te0dufYiJEIX//P4CwrHS40or/5+axSg6JXE1vCfIef6UX+MY
   AwJROXI0B+Ny8Yztog5dS6xdXLTFOfBB7+KUTFsRJuf/UzbONobV9rysS
   cnJ/M8sI1esAaU5br+bz7L723BRo85GvduZpjtHG7mh0QOGWYWtA9Jb/3
   cfjPalihhTYRAbXHtqdQzCdWfRd5xI/3DzWJJuEU9EgRcUgY6Zb0s8gub
   Rp3Clv2upO7uIk12ROZrF9geHLfoQgtDIMY+iO2IPqbVYdlP+a+Kulr+F
   A==;
X-CSE-ConnectionGUID: xtaZ/zzbTx648BKY5UMihw==
X-CSE-MsgGUID: +gFVlIqyQDeukzWvEXmr0w==
X-IronPort-AV: E=Sophos;i="6.10,206,1719849600"; 
   d="scan'208";a="26054453"
Received: from mail-centralusazlp17010005.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.5])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2024 10:33:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5yyg2my8HFAR5HIT+ZapqdvttgtbwE6dc62Z6SUX/1TClqOWYTz3k94qkDeFhiSnkutDtVs6V2aItJefUHRgiOGn59u57j/Q/G9VkXgfGHORY0YFfBbWSjXOlmU5bKVJpAkWcxlm05sfxCMvmEmBEL7A57R59oGldObOevADmTQxXnAcPGOTdhg2Bnp6qFZcvy2VoCNZ2uv9V0uQHvHq5eGoo2NjOtHV1m0gGlYI7540ZyUUOFukM/i5M6TI94MF7SUrlvDaU1JAf6zo6ERtSuzmZJetdTp5cUJTTUuqimw1CaRt/ugIXGo+J4qz5LOKzDma+Ok1LKmhv0VyOWAXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wk3t0zRPw+ouyIfVj6xugRHm5AH+/WqShrlmNqB+zq4=;
 b=prE314soqeyg4g03YEnhQF3lAw5Ttw00EAeo5My9eBb1oR8lvRAQpLVXkMBkTwM/7zvWFHymGCqtAZDvcZZS8rOorMgKd56i2zKXKpNTz42+jIAjxk3v61CTekiCYB8zdBTxDS3XifgKQYtCheghfPFQrfiFFGoUoaS+/FeA/Djvt1pQ9I+xvVWVtfKFZuScaHXt+GyVnIAKGisE71IqRd9vPb+JNkJ/MIyhA0eNf0z5R7CDJnkWKDNs870UyUeyw3cV13WFjPNQiA/9X4gu5jerjVrqByTRpMsQjA5ADmLdIVNQGfZzlL9iRX94bFEYjxaE363F7Aw/bsdH32werg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wk3t0zRPw+ouyIfVj6xugRHm5AH+/WqShrlmNqB+zq4=;
 b=mX2ZimneFH1cjIgaWgM+y3ex7c+nj+NZjmU0vDhzwWqJ+PsFme8uRCMqWFEsPe1iLUInI903jtJJKetiboKTYLDMvydga2aLW+YbUK3z/uCys3GmSxQq9sTFbRpQJcrZGSwPxTdmufoqCWM2qump+8lLFsReXTRA2/bftR74RSY=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6772.namprd04.prod.outlook.com (2603:10b6:a03:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 02:33:17 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 02:33:17 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: latency logging with file operation IO engines
Thread-Topic: latency logging with file operation IO engines
Thread-Index: AQHa/8UEK+tGglPaVUmH0dYvUoamPrJKCraA
Date: Fri, 6 Sep 2024 02:33:16 +0000
Message-ID: <qwx2mda5xk4lrf54u4e5ukurcrn7mlpnyfsrgjfygsgrdmjhqj@6uuevmbwj6kx>
References: <0e2c84c9-f9e4-4073-a075-016393ca7bde@gmail.com>
In-Reply-To: <0e2c84c9-f9e4-4073-a075-016393ca7bde@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6772:EE_
x-ms-office365-filtering-correlation-id: 51720152-918f-4aba-923d-08dcce1c43bf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0kbx0Gwj916HFrJA6yKvBX1fqTSkgRRWJ5ihiBSvprjlc+K1QS3L1BxeX1b7?=
 =?us-ascii?Q?2+niu1tNYzd7EvuOESKFAddpQS4Rro1rjq9c1jjAqQKGeV+SBWvG6uHW+W49?=
 =?us-ascii?Q?AfhGb32HwcWd7aR3D6yVQd3Ml5yDDO1O9SZ4hROrab/TWhvzDU/dK+7DTVeU?=
 =?us-ascii?Q?D6D4fh6CTsdaTiC+0YfYt8IL82+7H89q6cXrGzcoXaP0idGas/axdue2qfPu?=
 =?us-ascii?Q?JGVd4Wks7DJA+Dbi+Kywux74vxiinVFPp727KQMWXnEAGLDRiZx6sec9hWTd?=
 =?us-ascii?Q?DU2L0rRqraejOQL3Zok21jJUURIL9KpQmkK0U1JMboDfwuWTRo8IiFRGiT7O?=
 =?us-ascii?Q?EmGPrEAYDKKHQYWM41B9VhbU9Ao9y/MRHphRQpRBpliuPx4LRW2Dmg7fKgtK?=
 =?us-ascii?Q?yHvrbB+yYcm7gVo9t4zgkiRUwQw14IgCie8Gqrn4eR5WQvf171XAXD7//Kkw?=
 =?us-ascii?Q?lbuJJWAkO52n9QGFuL+8zP9nyvc8XYQS2IqATIPn7FrJCqSqy9hWzZ92HdVB?=
 =?us-ascii?Q?oMaaiqExq9XwBIX3BavHz7LObVAL/HD0j38+FCcNrll9WQRkbJfPvW/H7gKq?=
 =?us-ascii?Q?eNT46lPCdCRJLMb4mCqFlC793d7/pGzwNcvI3G2Yb0qBd8xM8hEC8dml0MPZ?=
 =?us-ascii?Q?GW+e99kvuwO5SJ61GV1up9p1rAW9LbjVrxhf8c13NKNMGGMJQJ6qYMm6EHJc?=
 =?us-ascii?Q?eSnmfwq6L13QUKMh2+6y9BXcraBGRX1SylyFZLdjGAQTkFaAXQyltMb/xANC?=
 =?us-ascii?Q?l7E+Baxfo+iLk5w795cAtBfBCXOl4ciEVY8oCI/qR7Fj30bBc8pdXEXyzc6B?=
 =?us-ascii?Q?tO915/7ORZq9yTp9j1NL8kl6jVv3Pq/XvqmkcNfVbDxZgByBiZYJBpURgSBO?=
 =?us-ascii?Q?IbuVddaoX/XtyWdXZ2g4OYLNHWH3Lp+iKBj9Ihxvbt3mtnrFMW2oPxjefj9G?=
 =?us-ascii?Q?b/3BZqcO9L0yOCRBNuRlAwcCQQvkWaM5cN+ZV2sAKhfIZ9hH8pXnr+xDBc5U?=
 =?us-ascii?Q?8k4ljX62qmEvpMjW3fOVVMNjet3e2rciuTSBtpgbTHdeGeRInDB5JQtvPUp5?=
 =?us-ascii?Q?jKNQf6OqzHWiX1SSOjR4fdAIdAIxDY2alElkQ6s4DbelX3JMjwzhGPIVMjyi?=
 =?us-ascii?Q?YxW/Y/sKXIYGKxU3srm+Bge0JgRZSMs4d4BeltT3REfMW8Xd2doCvxyBz+4y?=
 =?us-ascii?Q?D7wjo72dPINXYVH0Jx1BhS4Xg9dSFM5AwgP+as9HoBI7IVqRvp95U4d4sbDU?=
 =?us-ascii?Q?cO4G9Gh1KiBeB2omMdimy2iSd8c6ZRS+wDev2R/EHK7+TbpuyEh3As/uMv5o?=
 =?us-ascii?Q?4/4h8uGFkGdiapdfXsSJwtqjxI/2GspjhQhx8yN/z4aM3nBYy4c88Zy6HGJj?=
 =?us-ascii?Q?7sgUJsgoKTl9kgfRuZDI37zGN2Xlp2Jw1LZ8cd7z6ab34ax+Yw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YSKJMKDAdUgg8ZrhZQ55yYLqgFwUT9feUkqAjw6MJDIWG1+6Ixj75bZlus3d?=
 =?us-ascii?Q?7tON2evB4BQevGumlKb2QXuYEJA1U0jyD2zqNqas30I1Wwrt+IObl6g4nT60?=
 =?us-ascii?Q?EEk5+ZJNZauQaj6MIbVE6HL6wB23aeANsEXkdyDaSlonTFwXvEFefjA0JTZ5?=
 =?us-ascii?Q?otYnpQT5Fsb6gpqVazPrOq9euFx51inybsUVXfrHCZNbTKoqgPP9XIZzyC3d?=
 =?us-ascii?Q?h16fRt/e/6z3aZtKHeK7Cav2bXVw1c+0drI6vmiJ+LrrWkoBhjLusIe8c19g?=
 =?us-ascii?Q?NvqQb4G0eNjX+9NUJcqYhJAQ3SzE7AEElNBeBO+rA2YDYy+zNGjDSHM0Fdu8?=
 =?us-ascii?Q?jn9FVIzaZ4NbPoDPoOB+IXUE1YINekcrUZq5JfIQV2ayHDfAQi8mpgUZOP6r?=
 =?us-ascii?Q?kLTCuEs6VV7Tak+ixp1j4J157x+o14pkOTXr1Q3nRLdmFtKLrmUk3wgw41Ru?=
 =?us-ascii?Q?r5aR5EK7VR+AhdwcQRZa1MSiu8sCL+/jaNpRmjSC/zETYQtrWaEo40NscbxA?=
 =?us-ascii?Q?m1idDhICNF64qQmwP1jhnvXPzp0sVO5LDuxegK3ufB93fXOLTJvV1iVd0dpJ?=
 =?us-ascii?Q?TejC0P1Zi8KzKWTcGeUlEbB5wXFCCi6L/tlDnsGqfHwmGFAAWKjlcEPqzsr/?=
 =?us-ascii?Q?91eFbjZrJZoGeVbCAcbQ6ALAE0MTHSBP4LdpAYkLfRqnZY2JX4Tk/ugl9Bs8?=
 =?us-ascii?Q?LbqNYUmV7x4Oh7zg0wZYp4ZnQMzg7B4vG7qKP/CNKfDntR6apz5oiISvDo78?=
 =?us-ascii?Q?dAEdtrpAzlLkaiGzfaSr7xkqcv5Vgtd4tC8qfma3bU6rS2RAzuZl9wM8VeVF?=
 =?us-ascii?Q?wUOnNrjlLAmkf2u0yBojLYmuQ1YpArzqeRigOXfawkfOIFp+Z2JsBLtgCU9D?=
 =?us-ascii?Q?zIidvRyPE0lK6hRyqZBUvvqfC++lWDb1yoCorOxg2IFgBKQErCQjS63TeFCV?=
 =?us-ascii?Q?1pxQzlp/sxibLvaVWTrX7ie9/nt3NDKyLclkm/+SF277C4gYd7oVSwt11VaM?=
 =?us-ascii?Q?7HBzyPdNWFCX8rx5rZvdguYvkO6N3J5smFRGxC1/XCgpo+S1AS4//7I9oMtO?=
 =?us-ascii?Q?Im3w2VoU2G8NEsZAsem58UjIFo7atxIpadlnYRtaE4ae8006+SiaibHxPdb/?=
 =?us-ascii?Q?M+VFkB5yfMFQidNtk3QYnENqS9itSl8H2EjvJQVv+FEHqdlNfTbNQd6XHU0R?=
 =?us-ascii?Q?BQ0IfRiyUTlKIKtvNzHqYSiHmLYhaDGYvZmLbegmtZJN76Mc0x29i8m8M5Ln?=
 =?us-ascii?Q?HF6fogcAEhfm4haeWoTPLLSm7EwH/bKm5UjQsFAp9wIqWPVeSGHu4SvzsKF1?=
 =?us-ascii?Q?qAvqOlXzyMThemBbjKU5z8cQ/16HJiviNCZzMTu0bndAC/I//a1lfZ0FtIVS?=
 =?us-ascii?Q?Vi3gxTZ1tDvfK7KC2VPS0gLFWGvd403SVzVPgIHH5BQxJQsoh+3jHs14N6n0?=
 =?us-ascii?Q?mMRRRngzITcl1RBhJSeWNSyvc1CLJ7YyCLs7D7JXmZ3lH5FYAmNf52ESsW0L?=
 =?us-ascii?Q?IUuGzTCdY0VnthcZzhJn58shZdeo+IZCZEkMQEDcAIUrsrgszOeWchstmd/4?=
 =?us-ascii?Q?AiTyQ4kKVqGLO4SKDraU4K92z9H6+saK8RJ6268G3WSpRtn+ET46IHtyga5i?=
 =?us-ascii?Q?3dlj7i/tfdpOhZVo66LuQb8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B353AFD28987B64EB38E0C8A0A0A0765@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gucFfIaXHXOimgtH7LTf5hWnmMGhPQLDTivhPZjlX7Zb5nUfvl1JHMqlKMpISKNhcwgCjzERodGrzTIkz96SWmJEUBuNCmN/SNT8knaoxLDaQW2eoGx0mpQqDz8flpcbarCYohLHtmJMcyPGmYtZScOSqbmEBtsKNkql6uYwlUJM6S/ue4KZOXs/JgN0vN4ZwxpM9iqFV2rQ7n+nwyvM+05PzpsBtDNQ4SJF7cVoFdo+Eh7U6OCj/OXRgOJmDYkCO41Hz0HDT0jjyJY7uW2caHMzO/61oLcmhc8Rd/CNWw2T/swW85nqsHoKoOA2dcXnb0/yBzibVzqGDgU8b/VXYXj85y7ztlca0TMdyYzmJOFri9aFNp2QcsMbKA/72xrUE+vn3CBKi0xSy1slW7W/PTenZcR0lJd+3u0nkS5WOsKAIBq7YIvyIYIvLzF1J8HbtfsY8XPHOZsz/HzIslyx9Z0bYsIWbXyaqz0A+ivTa+iuYeXCv3CP7miehZrkCwMgMm7/vdQbYqH6fpgOQMvlQ/d+e8wlUc7h6YdS9smGG0PxJTOAR1spaVTusljA2N8hK/2K7VjZ0EaU6DOpR6tmK5sqjYpDvt6HwX/h+2C2wU/RbhLGicxwNHShAgNZfL0n
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51720152-918f-4aba-923d-08dcce1c43bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 02:33:17.0172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQKIpUToMLz9Ef4M66luiB9TDGo1deOz7PY3GlUbf6Gi9KV0r9dMb48gU41p3JI6FalgOLCHBsECGyLIfGLzrL3W7NHhcL+Mv+qlMDe1kB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6772

On Sep 05, 2024 / 14:53, Vincent Fu wrote:
> Hello Shin'ichiro,
>=20
> Coverity reported the issue below with the "stat: reduce arguments of
> add_log_sample()" commit.

Hello Vincent, thank you for finding out the failure. I looked in the detai=
l,
and found my commit 14d3134a5fc0 ("introduce the log_issue_time option")
triggered the failure.

>=20
> ** CID 509196:  Null pointer dereferences  (FORWARD_NULL)
>=20
> _________________________________________________________________________=
_______________________________
> *** CID 509196:  Null pointer dereferences  (FORWARD_NULL)
> /stat.c: 3342 in add_clat_sample()
> 3336     	 */
> 3337     	if (!ts->lat_percentiles)
> 3338     		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
> 3339     				     nsec);
> 3340
> 3341     	if (td->clat_log) {
> >>>     CID 509196:  Null pointer dereferences  (FORWARD_NULL)
> >>>     Passing null pointer "&io_u->issue_time" to "ntime_since", which
> dereferences it.
> 3342     		struct log_sample sample =3D { sample_val(nsec), ddir, bs,
> 3343     			offset, ioprio,
> 3344     			ntime_since(&td->epoch, &io_u->issue_time) };
> 3345
> 3346     		add_log_sample(td, td->clat_log, &sample);
> 3347     	}
>=20
> It appears that with the refactoring it is no longer possible to carry ou=
t
> latency logging with the file operation ioengines since their calls set i=
o_u
> to NULL. Would you be able to devise a way to restore this?

Sorry for the trouble. Will post fix patches soon.=
