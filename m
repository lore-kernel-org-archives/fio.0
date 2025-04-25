Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D282F17597
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 03:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745553028; cv=fail; b=mD94cgFGqBQd0B1Wexfg5YcEfVFmbCEgWrCviTR+LftXIAlE3MbBh3dUyG6r00/Mid68o0rI0RHP3XhYmxL8jDVxAJTOB760T92ZFo+/qGpG+e6BafVb7wYtMC/PXKpjTcipxJPoibyynxynBbBqZyJrbJxH9Ci2Ddrl0XJWRkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745553028; c=relaxed/simple;
	bh=PuWW05J93TlC76+hU7GtVYWv6bYBBJ/P3ewG9j2Shj0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jJB3r/czvuIB1cpdGNi+cYF29Z5raZpbdcscBx6aKtKLLKKL1oaWEerBAgya5FveBKC1FKzQYkCDDPkolpS0srtXvlKxl2FZj4Pf6WCKXoeDTb/LaFKoI3i1r6uGcfmhKbeNycdSFSaHQSI+xGW/T8sr0VhdU7MxVpSySJTzy6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pPzl72j8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Amkpt5gK; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pPzl72j8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Amkpt5gK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745553027; x=1777089027;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PuWW05J93TlC76+hU7GtVYWv6bYBBJ/P3ewG9j2Shj0=;
  b=pPzl72j8qrxMSXC6WQyC6F44TPu+rbUqeGeNxMzgTSvuCrMedK0DHcWB
   G3Jlj3cfAulvIagrvjk3FtQROioUoFxDu9qUWzp/Ua1Cr5IZhOt/aUmMv
   4xPWSl7tAElWoi/B8mRqJt50C5WGgQSI1kRop+KtwQis6NpiYsuvEl0V6
   AH8TClN1HLISJ3MQXlBM4q+Gz2X+AP3q4H3liTaKaGfpx8BomINoF6dZP
   uL5hklhRVViA2dRP1inSd+WlAde0vIaRE40VDbaKoXkViD65dt0dZhdoU
   GoIOqhNBP1PhdkXA1jl8+jqmRvmwjj835FitTc5a8rAD5i2mcw5dQOAkA
   g==;
X-CSE-ConnectionGUID: aR7WaUMNSF+IZqDOTAvTVQ==
X-CSE-MsgGUID: 0nU9/0WoQTKC3MkaCxV/rA==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="77747813"
Received: from mail-westusazlp17010001.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([40.93.1.1])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 11:50:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rxc9FvFM/YkIqx0l/Bv3EycF0dCn1e1Kqyd7haKfs4LS7R7ARRS8Tm0CPsQfzUMNXrQeDBc9w0+DyEPfBxvhf9RDjQWvGHg2ClPq7PqnyOd4op7DLX2E4f7ScIhY7cm4gvxwM1blrphw3NEc0m2rE+qoze2+zwOPmJ5NMfdYV3jHYo9hha0j0tm5sVgVSnju5qwiXv0ydtaLtTEjB2YkLynl7fTSHyB88Uj+I5s1084MKhsO8I5Hs2CkbKjK13HF8aqrjFW5UY4wtb+s46Ql+KI3X02iEUtqDIFReTzF2eCg33EUa25anXlrKvT3qgjHKvRifIRkLUHykJ3JOawyAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuWW05J93TlC76+hU7GtVYWv6bYBBJ/P3ewG9j2Shj0=;
 b=Yg2k2vyXBjfLE+0s/VamtDGENKM/6o3C9WtNhd0rmDXbIqE72+a3K14g4+EBc2OXOn9mi3KPnGxNZ4i8c9uHFQ2wvB5ZrMwdfIuCkHcoj1jC3CMdtTzzmIv5HfIZFbyzrTeMf4zrWdBNzuU0ZPxx6gcA2h7lSt/Al9+m0tQDR8gVgZVxKOTwAnQJjl9yD2D9+uH+ENQjyf5caWe/nNVDnSKvq2czlhPw0H72DGxH6QzQjAAIPCL9Zgm4MQf/dujEqiQ1NwmIj+5cLdQX7Q/RhFoLsQGYeDB5UEbsSmoSyQ5tHjZfoAgP3xUIkLDpYAJwwQjoXqlHiBBNfZuU0S1HXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuWW05J93TlC76+hU7GtVYWv6bYBBJ/P3ewG9j2Shj0=;
 b=Amkpt5gKbKvUWI/KB6tgdq2qll2A2G/eTmBOq2IlvjGZd36fUJtbG6qmiVwELc+vBYKTuFI2qLMg1tuG7tbovLaa8iLdEHjwtNcMJ2mjfGOJDS+5rfuplqHSsNJRRe6+5HxinPRy7OMk1DYFEDR/oTKseg9hPzvLRl8wXuhgbzc=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB7662.namprd04.prod.outlook.com (2603:10b6:a03:325::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 03:50:18 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 03:50:18 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 5/8] zbd: add the recover_zbd_write_error option
Thread-Topic: [PATCH 5/8] zbd: add the recover_zbd_write_error option
Thread-Index: AQHbsrpSPdsUMQDCqUyMj12cP66gCbOy62eAgADZdgA=
Date: Fri, 25 Apr 2025 03:50:18 +0000
Message-ID: <ehghsx7jedrrnutj53nyfnqeivva3cxoufvd6qp3aeus6b4sqb@jkfrnfdhjewf>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
 <20250421123828.82712-6-shinichiro.kawasaki@wdc.com>
 <9b128c9e-fe73-46f9-8e83-ae552f6c2531@gmail.com>
In-Reply-To: <9b128c9e-fe73-46f9-8e83-ae552f6c2531@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB7662:EE_
x-ms-office365-filtering-correlation-id: 68b4aaed-504b-4656-d0a0-08dd83ac4bf7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700018|27256017;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?eXByw53rTBo6vX7SCBzrWkcP0ADayMcs7IXEm53IewKbfeiSUDNArSFm189d?=
 =?us-ascii?Q?2f3W6MgVHwLl1b2xiPBN8Qm6RFywB9wj4572MKknuS7Tgh2+3IqMDofHu/H7?=
 =?us-ascii?Q?KRNcD4rv1EgmpGoDM8jvA7QLGkVIO+U5s7wih+HStG+suZQ9Hpl0SmCICm9Y?=
 =?us-ascii?Q?MsXQml3OGjNDfBljv2dU2M5E3aNKQjDZq75oCQGqnr2iA1ijtdYkBJicgnnp?=
 =?us-ascii?Q?jRZerTtuEZ63iYaAuJsqcWXYF4c5+a8+3O/XgOSS/55rDWqSO1YkoJXfAL4m?=
 =?us-ascii?Q?QMi0xevZIPpufjFNzcvZgHvI5RMNuaj+dyL+i4j1gv6OtVpAyKUhtC3Mgvf+?=
 =?us-ascii?Q?RjwT5S5pp8UA46QHrN+PsACHKqytvXKZgj7D7FqS6zh8p45DsuTzfjWVBFTq?=
 =?us-ascii?Q?e4g6wB6jqjZrDVWe2dJswPbaoBZArnj7KZkdxH25DPCkhpvouN5pOOilyuBS?=
 =?us-ascii?Q?pEYf3lTkVxjp4TIuJmU5oze+6AYOEYd/Q0sRP+tYHUuX8RO/J3Iyq2iidqs9?=
 =?us-ascii?Q?h/FR5ln4QB7GYvoml6S/dUqy9AfIH9RUVHulSIOwJPHddwWBySCye0lsO+Ti?=
 =?us-ascii?Q?vTubao7TCak4n4T2w84Pvx2GS+GGh/f2owa404vqu47xeC7d2GmzaCWiH3vi?=
 =?us-ascii?Q?MkfAXlMJSjyjhqFDurOvvz0B2qMVJRgcmqvskBgmkJOfQflU5bY6MYWagaWc?=
 =?us-ascii?Q?pQ2ao0zeT7Mfy81UASubKEEu/M5EAd14Exkoa4BLmutONIVLBmwpGbr97KKg?=
 =?us-ascii?Q?8JqqsMiybkm0odeNrf98elgFzGoDuQlyv5XHKgBJQvo3dbLO2Hxa3aE88XYR?=
 =?us-ascii?Q?0dA2tei32/6pIM5u9O4MGNsCaweVo15TAtrt26ZzDgNUkvQ4Uw1bP08ozU4w?=
 =?us-ascii?Q?We2WE22HvuH1EYQlDoLv9ykbpyHHQuWkH4PjCNwbH6fL4TGUF0x6wyDgYThM?=
 =?us-ascii?Q?rvMI6P27D7Qn4CjwR4I9qu1WAEcffdx7OC/T/LD1FM5/uUO8NhGEmwgn4JPX?=
 =?us-ascii?Q?1M1FlA1Lwfxn7pUrTGJH+kqrN9A41KWj6N5ZepHh+rUenCrvC4cYWW9Ba1Hs?=
 =?us-ascii?Q?7k8boqKRwu2QaMC5HOlB/OmnXJp/eill3cKnm/naoUmqyu+/H8pO3EV0ZMAM?=
 =?us-ascii?Q?BN0It98numDmXHlRVjQZ3zdRYQl5yipiyCQjSa1MgDRcNtyoiCCmFfi3ATPz?=
 =?us-ascii?Q?O6U++Aa0ipUcOq70g0VEVhdrHAcYPoO85oM0e9vV9dXQMsZ1PNQ5pIi95fq1?=
 =?us-ascii?Q?bTQKDEIaSKDIMpXw5cVM9MX7ij8B7c4gxTnUqY1mSxrtEGbmOqMrG579AU9u?=
 =?us-ascii?Q?o47RIVRTF/fpSRzuFDFDwkjmjKUJPIqUdhtCPHHY1gUYBd+OoI0aWc/HOIaT?=
 =?us-ascii?Q?GFY3DM1nptyh2j6WO0nk+f/5bkraXpb2PRwJohvdwp9nqB8qw1e3+B6AP+wz?=
 =?us-ascii?Q?9cD6HgV6J0BJB0vZq0p+PXjZo4iPllMLAd4uqKu9ZP7jlRWT1UyqzPJA5qQx?=
 =?us-ascii?Q?7JsNAC/0NRORBQ7q0w3zkBKcCcteaMt8Gdua?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018)(27256017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nVQZ4CTLEQFbj3V1/YCFgFUfb2+hLBNyfY6ZLUroOygsPTWSrnLFAui+YRuC?=
 =?us-ascii?Q?Iu2Fzfy3d5AY9B232G3zZGCNe8QXGQa2mH35DTasbgWeV2YoqW2nLsVv3ey+?=
 =?us-ascii?Q?BAPTVE2NSjx3KJi9ADrp5fjEHBl4b7e7nPUxBZzaN9UvyZCLfPcoxzixhEml?=
 =?us-ascii?Q?J3+ueHXCm7rISM7SDUW3QQm7iFXO/G5hQcDQZU0STp+wRFDspg9wPC2RQO5P?=
 =?us-ascii?Q?qZJDJQnLSEvvQl4ADawHhQrjbdQSJa2iYtBDXotNjgH3Y3Ullb/yaGE2IkjA?=
 =?us-ascii?Q?fUlhB6e6PW1DIEDsOgJjqbAELnYmu1EqnLOjVHloPk9PR7nkibQJpLTwryhV?=
 =?us-ascii?Q?VDResh9p7CWuAf1kQgg0hZeirXp4npgF96fvUKhLAu++wWd8iu5X5GALLLCW?=
 =?us-ascii?Q?0J2MazzHtHI0r2d1J4yTNlYy0EUkDDY7/wdC4+SzQ2tTAAQRZ85+DKb7SMXf?=
 =?us-ascii?Q?i46V+Ei82mI0D2TsvjNUKQYUWs6LxjlikeI9wabVKLhf5KxIILgsgMW1re9j?=
 =?us-ascii?Q?LaqhD8VaSlIMLMwg3tdl4o83zciFEH685S48L0sV5xAr04Y9pQ8VUkvAt+Z4?=
 =?us-ascii?Q?l6fhscIAjFNXxuuUq2jYeZGlAu7dOGRDo6XzP/b63hgGWKdq6wMn2HwMN5rY?=
 =?us-ascii?Q?mDqPgAr++oV9sJhP8lWfEThNNoPr1hdB463NsWESLFGEjJu4qRx7+JfRDZSb?=
 =?us-ascii?Q?EDZatz5dckV5X4VgL3bvuixhjJd5yssuKMWz1YRrrKD8+V05T6l8TaOYUaJK?=
 =?us-ascii?Q?L2d9MCtTEJuPHF8LxgjFeis0id/YqnPcwAAhhhESEf//lUhUNmc1CRq6JhhZ?=
 =?us-ascii?Q?XnvOSgzSwkknk0VZ0wkHX8ufa7EEvgu7nw0qCfkGKtSSZciodEp37tGf1owp?=
 =?us-ascii?Q?Z9MT+aGhZhlUg+49jb6A9BkRpx0pzPmgo4smFL2+AnRxMGbwROfB535Nb5yQ?=
 =?us-ascii?Q?xDkCOepYMxt8AFNvSezUxKGWg/MXiHTJzSOFx0cBwEFAWJn50cywFKIE7hk8?=
 =?us-ascii?Q?H7ctr32IwEnmQgmxtWCfvcefode2fXws7nk/2/VnE0P0+aqwi9iIyfp/MB8T?=
 =?us-ascii?Q?CiW7Xzy968SH0aSOA8MNiPNe/eNAPd6hvlknTP/5JefWhUWzLFU9LHi+036m?=
 =?us-ascii?Q?5KMfRrqtNKf7Qvtqz0gFnrNainQKQXIV3i96v2I711bE8Whb7yd89mcFRxjQ?=
 =?us-ascii?Q?4AYCufUYySdUmkld0qyo5ElNZY8iMIyS72r4EFMynSawNCWqatBTeQHLG0br?=
 =?us-ascii?Q?vn1RpZ2RiJHlQcx5xHRvrL70kjeJS2CGV4EeiubJc2k+ph2TZeWOx29cWUaT?=
 =?us-ascii?Q?QF1bIP1Z+PdpvC/jRCOezEVhsji3KSJm54zJ9FBn+i9mOKZ3fv64F8TjwSTX?=
 =?us-ascii?Q?wSdKLh/N9XteSzQDTeErvi8tpacAXCBWWaKEoOeSNk458o0FqUmsBpN+Xnz3?=
 =?us-ascii?Q?ugm4EguB3HU+fK/fL+hYMSFwlec3G4+XKLTi+ezC1p2OMhxRgG8NJRRzS6Gf?=
 =?us-ascii?Q?z1LuaW6hDpklmEviRJCFjx5hKTGLXXdh8nJIwp1ITdvctaWFEeRcRV8D4ojA?=
 =?us-ascii?Q?PrDsyc84DIPWiMF125m9FDrcVl3u+GHIirBHaZR1bPGjII8rzS+13T49zoO9?=
 =?us-ascii?Q?MePCAgH19G+jYdVAGfV5hfw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4993377113D4B5488325F5DCAAD96B14@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+73hNEVIjcM6OnQRx+2ntgtYQKSCMqhI+0nj3gHKhwbnweOPlGHAtO8z533y3rCKkiLxtp4SnUEZoSdXOcINXmX93sqHHDE6CVQtGHPdYVL+vmexIw1Wg2ymvvMt+7urZAS7Qv2uv5rMmbys16B7kt3QTu9/Uand3oNia6Ma7VVoC8rXA8V8XoMVIxZjSsPLJQZKgfurP5ZZAv74fXycfsZ9tmbDvik1yZCExrTO46Z+7ZGOrAdsyJ5xV2N5x2sjPWlFQALcL2blVxQXgK5Rr/gjYMEVAKQSpWTajTxwt1PPiw+kXm8jKuQv8ADuGTpbPBUAE9UmmqQ71+/xAJ8biZAKMwLQeRnCCl5s4FDpamATGvBEfG1ip44CUyr4ytPA8kqDhgc0z6QXLCIVo767ShgoTO83hg5pQSCpXbKGFKpWMYusK7AYk1u2uqDga2XgLdo2LIF5oJuKLgF21SZKE3Kie4Yo8wWpcuBYULQxpk8EaLL2R7DRK2rqLUtFjautpZ3+Wh0/EJ7L7rQLxffNzhgAMDdNQqxgS0Ikcf0QTvXazVQ/u83mQlF2QoZR5LrBIMlESwgfhU/w7YxHuz0+un7rkaug0c0nYzStMs+FIOWIcTCsiOnGxXeGXnCIDm64
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b4aaed-504b-4656-d0a0-08dd83ac4bf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 03:50:18.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aVnCEK1c9vm9EXuyLyQXlgdw4I/c+Xk6SvCOiJQvQnii/wjO3KVJ6uaP4j3rE3rRn9dJo9kN2WS5WYPMmiNibpunaCIGuEvyXryx+4Fn+Qw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7662

On Apr 24, 2025 / 10:51, Vincent Fu wrote:
...
> Changes are needed in cconv.c to enable this new option to work in
> client/server mode.

Thank you for catching this. Will add the required changes in v2.=
