Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ACF189F31
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724919227; cv=fail; b=jNU8OselYDc/ghgIVUxd/cvR1DWsKfoLBc97kl6f/Cfq2TZaR3E9YpckdoAngllxrpGduEfWPjEwMX8avi0B4UPqI1YLwhuRAsAdEGQXu7eFNUt/AvI2Hqk36ou5bO45WKCK6/Fuw8jWPwB8xm80bKH2q4/yR4JSxBgKcXn0CHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724919227; c=relaxed/simple;
	bh=fsk5Do8baR/K04w+Ljg/ZR4CXbpePhzqiGLpdGf1dmY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nDw60VnV/mAq97CLR7D6Xta+iDQ95G6uiI0QdH0cIJ1ZvjLlU54VmVv+rEt6SkCBpUB0pG6ogoStjlxC9ZVRg0S/sFejCjh8jNXjzbyNbM/Xd5t2L4pBdVjJS7bvdSgSBtEcEPKImFwDZS+34V1B8u8gqmjhRvYbRT28EnJtuGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=g6gpqxeQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=U+/efjdf; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g6gpqxeQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="U+/efjdf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724919225; x=1756455225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fsk5Do8baR/K04w+Ljg/ZR4CXbpePhzqiGLpdGf1dmY=;
  b=g6gpqxeQgpbSQ++eiZXxNYH1ppVtexKLilxQLpggu/uTn2E0xhhZmxob
   E9M13m/ta2xRw1CqO0ZEXlPR0/fHpPq9459lnmIgVDUKy76rju2uqMZ3k
   7wQBl0c/lo8jc+Tjw+K9rpdAjf14UjY6WKw2WrmLtVyJa/H0L/1bZq4al
   evXrJDXaCqeyOKYUGyB2Nc1RaeufzYZo5UgHVnz0UMrp69VDHuPnot9y7
   HBOZlM1RfCGpsl4DtsIqL/aABC4hvZd+EckBNTbhkVIM1jIybsShrIdez
   B0DKO5O+ySP8QNkYTxDZ9tI52W/2cviNbvRlv8CdSX6346Tj62QMVCgha
   A==;
X-CSE-ConnectionGUID: VCILy9LgQJaLJ8u1I4DuMQ==
X-CSE-MsgGUID: mrwYwpHUQQCz46T3uiUVGQ==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="25457756"
Received: from mail-eastus2azlp17010003.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.3])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:13:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5c4pBTfkuSnWb1AnemAtRdwkbgwI7p9fe6keVlFIP9nZpAWttIJO4Tkw/rMVHEoF1sqjRqTW10/oyiN1kDjdAiuAghJo5UzOtpp36PEXRF/X9IrNHVxEn+QVxW7PqZs6wyL3rbeb2h7BxL4acnh2D3z5ZCdCqjV8Dt5ynaYU+BCxlLmpTH1WvKz9IB4DuM7zhLyaQhI/bnCHZkXVbUDYk4oDfEPcFoDxPCuFhKoDZNDPXoVsZ5bg+4/8s6o6KTfsw010jnBXPwKUNNMAAxir3IwJo+HxPHVk2416JotHG/y/NlaNy8MsteEuQ0xWjWNAENhjnu9Cq6YQ9udMqzKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/VdejfnwO8wdmxrXcBgs/j82knlxbZ7rYiVpnTCQnM=;
 b=Rf3Ue9ldY+mwBJRQbAkVRQibuz9DzYZvp+cfPvTEX7MR2yfHg24KZXnx9QbyqRw74h0BdKQitVIwO19b0Ox7h5QqHVKKArXGFGldTwARcT9KVeWgaWQAn1r8hQ7WUD00lYaCJudtY/blNiVDBJLvFNAq71efos2rfgVXC1paEgJspl4Ucwf/ToMXbIGCE5VNuq98i2O0cz2oFfweeGzQeivDLdSfAqSh49hezVxvhDbaKdhzzAwkYasp25UZSg7z1Ok3irf41426sJkNgXEkdoCau4228JaB9aHKg5oSB5vy4hHH+27wEdiTvFaTaPn+Hm7SijafABJv7O/WtsK6oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/VdejfnwO8wdmxrXcBgs/j82knlxbZ7rYiVpnTCQnM=;
 b=U+/efjdfyjW2uC+aTWgIq3r+Kv/X5oxsToWSAKJei3HWKrpSkUkgqnr+M3qbidUHCbQH+sZ0Fcw9fYhHptqj5jG35l09PEIuFewZ8uu6ZDOHT5OTMKaN7nv/5c9dbZYRFToKuKPRnBlkpP2aPh851nCQQpzN1fXugk+gTgO+feA=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN8PR04MB6434.namprd04.prod.outlook.com (2603:10b6:408:d6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.28; Thu, 29 Aug 2024 08:13:41 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 08:13:41 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
CC: Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 5/9] introduce the log_issue_time option
Thread-Topic: [PATCH 5/9] introduce the log_issue_time option
Thread-Index: AQHa+E//k/wYq8WDPk+oSjlVo43uOrI95hUA
Date: Thu, 29 Aug 2024 08:13:41 +0000
Message-ID: <brjwzp2oarruuwtrjm32jx5xdctl2tlbnlwkoggiks5uojot7v@sttovf6bjsb3>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN8PR04MB6434:EE_
x-ms-office365-filtering-correlation-id: 72d15550-2129-4de1-a8d4-08dcc8027e1d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?41kTZtwKR4b8Zqw6mfzIPtUoIjL6hy8NJawSWc6MiCyg3VGXyjcWQ1PcZnSb?=
 =?us-ascii?Q?fRY5PeAPD68spcniKp8Z9s4wYK2R7G83xuopsoX4LxhJtQHsVXTdJHIp6S1k?=
 =?us-ascii?Q?O6ZOOMpLwBwdTmtdMbX44TOnTkan1XkFHOa93HttO23C96BYPd5ARHnanUNe?=
 =?us-ascii?Q?aJPF7ZKl+92Xt4xMV6Y6GrpesTdOyzf0mwYVUk+JNYF18+KiPM8DnV8cpdez?=
 =?us-ascii?Q?tml4DmrOn84yVRGZI2vraUbanaQVnQ/3/iBXrqgTWe6kRiP8qahPoKE+NeUL?=
 =?us-ascii?Q?6bMq/OoMAGfxWp/9IZzgNU6sz4LEVS6YOIwbm+FGrQ0Puq9H2KzvZAnIxnpl?=
 =?us-ascii?Q?yXnhf7ayxEyqqhJdpPh3MURwL9hsjHCT6w8Ef2CVMJRdFLMZyPkq5NHkj54h?=
 =?us-ascii?Q?ofHx7B6l5tiKLKUsrW1XQg2A4KxUyrBJL5UTa00yx9sPTVQ+TIxkn+/3AcK+?=
 =?us-ascii?Q?WyhSSUp90ZKcA0+QvQ/WUVmSJejXIXCLL6f4CFUX+oR9j79+Jo4b4Yvz0hPn?=
 =?us-ascii?Q?u3senRdfvmCv/Z9V8hIFTYXpuWqjKZ8+PzXUPfqR1vMBLun/8abxM/dYROMV?=
 =?us-ascii?Q?z01q5bpGxgFeQQ/EGAtEBh8DCj9aofLD6zeEHkhCy70UYnXev92ok9cjVJG5?=
 =?us-ascii?Q?QEUa7anwLPjkeH9pleFIj0izNUnlboEVcZTGf3Ux09WuT3IhPaC8xgX6sl0v?=
 =?us-ascii?Q?JWnm52QuSCjWgj5JCeumaIZY2im0BgPYWdwJE/QP3q9Fx6IZNOv1pP4bD4Nh?=
 =?us-ascii?Q?IfibEdJiaTsQ7MwsEre+IXZHyhdC4NCQYoqxFH1KruNch3wLqRRjNpXFdBx6?=
 =?us-ascii?Q?JNvvny2J+61+K/kNfZXs6+N4gBqChWtY8DWgmC5Am42ydrzdLw3kzyDgYgmd?=
 =?us-ascii?Q?sPu7TC2MLlVg7tPOrF5N1tPQEgqjs7uCqOmBL/1W58NcVy7FfWY+VNi7lExP?=
 =?us-ascii?Q?ALXUVSp89keeRtjnGBz8zIyuaB8km+9IAHab73z9RXoKwtJmA0vDvhlf6cnK?=
 =?us-ascii?Q?lrvB9+NC8lSBk4Vj7y2d1DBXrnDrPPpiZ9k4va8KNk6FEHdrORMbUc+NHIeq?=
 =?us-ascii?Q?llguE2QjBZ8MHkwUu2/lO0pZHaCpowdZnZhzzyggn6tsd/EvPAnoopCYizzl?=
 =?us-ascii?Q?87ijuqmnaIWv+fTdnDTegoOAnH8MWelnSKpEhbpd0nSRBisBMcMwS1Ylx9Fi?=
 =?us-ascii?Q?vze9NpqOH0Dvixe3YYFn2vC74vwdMWap9sYb/Dn0Vn7c5sn3jzBIjLVZQQGn?=
 =?us-ascii?Q?rKBxFYk0DFoG3aYCwQNAhH65WYTo+orNw/0yxQ+IRvjhcrg4QK4LMjOe+9cw?=
 =?us-ascii?Q?9z5HDPJT2BmFk8PWJAwVAIUKCCTTP/BZvr3amityFzrhg7O0Hi5Xa4V5Ih95?=
 =?us-ascii?Q?PrdHe7yTx/QsY55DAfoen+jjhhNAa2Emm2AIzqT8C3RM/NxKmw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yHZZF85FAl+vCN1i6kJiiVuTMfXPPWczNjMmkPUmkVFoYn6aj1HwhgM9m8zo?=
 =?us-ascii?Q?Pcjlz8l7X+5OMpTiTzGLCel5Nqkefy6krNObB9x6/MGsh5tHQbcr8Wes5ANY?=
 =?us-ascii?Q?4D7fMQTrDWxgVn6GKs72BwC84/z69r6hZKGvs3mO22T0k/hyLo4KmPdTqLW6?=
 =?us-ascii?Q?EHuj603sF0bk00dE/fkgLpdaZ5XoH5wffVy4yrPRtkWYu5SeUQQ2ddiapQcF?=
 =?us-ascii?Q?5CVPw8wlDwhEOYrnUhgqDxNl0couK4n8eIhfVlnzEouEC2ctuKWGQ0xzaSxo?=
 =?us-ascii?Q?Qh+A5F1vDdyuq8d0R20zUBX+Mvk1ff25nc7lNr0ujG31oHr4h0hFe9YNHsk3?=
 =?us-ascii?Q?0xN9+6DwsObmIsCMQhlXG1GoyOfBXg3xVKCma5E1JbV7XdooVU4kGqqYhSwo?=
 =?us-ascii?Q?my9YXREdnLk1hsNIjfR+FkcfChjJnzYzYSr2HiTuOniHMSBuD2e4/iY8R79l?=
 =?us-ascii?Q?MIThzIitLbpHQDLNcvHJ+y6ZEjUaYXEIneTNQBRzaXLSU5kR/hb9PRuog1xm?=
 =?us-ascii?Q?Za9uwCMXnXNrH2X12KzIGf19Rx+Y9Tlxk7qS0bFU/qBIxPYxC9jrQOOQ19EG?=
 =?us-ascii?Q?+FOpcGefCoztpg/wpCpLTX7L4DQJwsGqk31rEoX/SxmE7yD5cxFXvxWi3ERL?=
 =?us-ascii?Q?J4pEJ0B2BWTeWRV4tpFlJFy2zKhk6CXag8aUc04xtRG5HR9kID/TpORQo/qT?=
 =?us-ascii?Q?ag1CWltTRukmvJpIbUcYTcG7DzVS27WIS+iv5xStYje4W1KPa9FsuqHW6XVC?=
 =?us-ascii?Q?aQBcqufccZm3+ABnbjJgfjux/oYtLdOzIVG2R3Un+IGptjpEKSJC++PXpeZG?=
 =?us-ascii?Q?ooQmBdx13gPA2q2ZteUk5a5NJ+tHNwB632Xi4qVh0sve9fkcmw7U9Iowvf9f?=
 =?us-ascii?Q?ban4J5vPIND7k0KuOfu88a17cS90L1Ombs40CLpmkysKbnr1sFAHYIEQR/m4?=
 =?us-ascii?Q?O3xpUrv14FEoM05O1Kh0bmMYVJHQzBMD/K4tgzTqAYA2Xs/xdsMES77p1UFB?=
 =?us-ascii?Q?ZRlqABbo4U1Bc8C0Dg43sYXFw9pAkJnC72XAuSgImOYXTqrAkIlzhrXNBKon?=
 =?us-ascii?Q?5EGGndKqfUlc9g8XY3zECrLugLCyv7MVopNYQ4HTQf44f0Gy/Fqe9TpEvZ+R?=
 =?us-ascii?Q?gYzbiETaW3jlpb18l7Lfmp3Qbr0LhM0ZnVCj5A+xzqCJIUQNPLqVzNG/4kuN?=
 =?us-ascii?Q?dO5Nwuf0JaRkeYHICvKLMd5Wu0bzHysmkl7Ymr4wi8cHYJZOTz7GriC5Hsio?=
 =?us-ascii?Q?EWVd7r1+1TnpEdGvxwCdqNwZClbUWwvF1hzKsuVIkNeGD/LB93HIzL7GMlG9?=
 =?us-ascii?Q?dYspcQr8DX+6QF/xGS6agMFqHhXeOPEJbZTYMwSWajd+20HhnkeoyxNY3vKV?=
 =?us-ascii?Q?6IsWQWaNr5flZhSMTJx62KmF1SK24yEtZ1ocE184Uu7a9T5C67PqI6O3FzE5?=
 =?us-ascii?Q?Bx6mQXONBZ60XBs7PxanaCXUM+eVJtoYjVqgJviWdIOdSmr/uE5SBYvnOHQ0?=
 =?us-ascii?Q?bIMAcdorO4tidg5gq+fuxLfiCiMOr7pQH3Vq/X5/s3wBBiOfE0yMCYARSO37?=
 =?us-ascii?Q?FOsTX4EkWtKn9F/mSshD5SIk8P+svAbIEMY56+STPC8TaBDEA5DB0x+0hWQQ?=
 =?us-ascii?Q?cWcnc3cGgTKgLwsMX7vI0xo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <220EC8B86BE77C488EEEABD40FF97780@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1WuCSyhp3Jgr4L+nYBFgWSbbPgTTgbxYnWpmsA9YpRG7Tdk9cmpP8CSJ9tcgAeaXJjTqRWOrN/YX5Ag+G702TACD99UJaZ8kLV2DYY6VPLDqsUpuuPNqCz+svlmMZxiR7wyYZbvhJX/GTi0xAwL/CAcM7W+Iuxs7DTz51cBmh8Y36vZUQ9EKhoxbcqI9K8IRJ4aYCoZDpIBcupOu5kLe04qONcGdAgoJDftMEwBcn5CLadcoAbEMFgAUAVfCN8T8ADyW3lB0qsS+6UxJR0uwhCYmK9DB4MMNzNlaMI4FdtqQq8rsdH7xxe+Wj/oFdUGoXkYHabwMQvmhcji8rUUYCPtwO5cgI4a1nMSzEZXEyjpPCScmxiPM7rDMWDdekW4scjrIgHmPLiSTEllGAP9g2b2cK3fPYmI09lzygbOlrF7+Q7BIJ7mW9aKneZVEKdOvK4H83sQj8d7yQ7tezCZJq3kpZA3jkHrSNaCL3+C7nlPA15ccSyTyA8sllghZwBRcbh3dEiLmGnzS7VPAQakHm3s9+eklcKTEWLxXFVspJuIxhGfsEnDRXWuJ++j4J/q/Kd9UCnXQKx6gLcQinLuOTUAyz/MauRCegPYXPIEHM38B/exEUND69J2PJp5Jtu5H
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d15550-2129-4de1-a8d4-08dcc8027e1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 08:13:41.0589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bcF/16mY8Ve/lAS76GtzidmGMl0MnjyVVNevb8RWXFCJ70SYiKQcns2SqBRGgnUFZDb3MVv6QiM+iFT8NpfX570I7sf+zQnuaeCjKStZIAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6434

On Aug 27, 2024 / 16:08, Shin'ichiro Kawasaki wrote:
[...]
> --- a/init.c
> +++ b/init.c
> @@ -1621,12 +1621,18 @@ static int add_job(struct thread_data *td, const =
char *jobname, int job_add_num,
>  			.log_type =3D IO_LOG_TYPE_LAT,
>  			.log_offset =3D o->log_offset,
>  			.log_prio =3D o->log_prio,
> +			.log_issue_time =3D o->log_issue_time,
>  			.log_gz =3D o->log_gz,
>  			.log_gz_store =3D o->log_gz_store,
>  		};
>  		const char *pre =3D make_log_name(o->lat_log_file, o->name);
>  		const char *suf;
> =20
> +		if (o->log_issue_time && !o->log_offset) {
> +			log_err("fio: log_issue_time option requires log_write_lat_log and lo=
g_offset options\n");

While I prepare v2, I found a typo here: s/log_write_lat_log/write_lat_log/

> +			goto err;
> +		}
> +
>  		if (p.log_gz_store)
>  			suf =3D "log.fz";
>  		else
> @@ -1650,6 +1656,9 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
>  			setup_log(&td->clat_log, &p, logname);
>  		}
> =20
> +	} else if (o->log_issue_time) {
> +		log_err("fio: log_issue_time option requires log_write_lat_log and log=
_offset options\n");

Same here. Will fix them.=
