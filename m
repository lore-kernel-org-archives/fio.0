Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660E61E7C35
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730839574; cv=fail; b=OSRdTa9NPtMdPCUj+oobLalLql7pd94mEuRn5ohmK5C87Flrz12rhILLF5Q/CI8LErC7pLtsnUPCpFC05AhjiAaSNu5zwbhq7NQdtcXW+sE0rZb6folYYjP0xBTQaX2///61/u8wojWxsAXy4yTDt1t44pyXpzzHF/OhxhsLvxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730839574; c=relaxed/simple;
	bh=oB8dgqrT01s4Jo1RmvS6hqG7ka+LiAma8fMrA4fIMfc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aWekeK7UA7hg/Mkq4FzfMca2Z/c/zk6k1dAsGkH3I7QzKhlLxg/TbLjY82NPlYH3qD7BcJCmf1FbsrnUVSEmrq49h7oYZe388hV6alJ26UHRJRAU667idTFaiXt9lCowDs9zbIMcJukEg3nepnk5P3GbppZrmlkqHszAm4X5t3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=FBaizWlr; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="FBaizWlr"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5FGQSR009259;
	Tue, 5 Nov 2024 15:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=smtpout1; bh=o
	B8dgqrT01s4Jo1RmvS6hqG7ka+LiAma8fMrA4fIMfc=; b=FBaizWlrRz9Qv3CQt
	HAaxUJsIuZhTQ4T/xqFLXyFtLu0rPVrWlhJgLayJ+phGoUFMbptsfBBuWn/u2mUu
	Lttm3EbdmKaxHZCOswSJH82L+JGb3TAAv2aAgrrq7fHal0KBq6X90bnkGBZSHpiO
	uCPOs7KKueLPA1Pho0oOEey3s88xtevAQK1p86DI+ptcCuzeyKw/TCoIYhm0M2gn
	B+26Obv3uEctY4y5W9J/zrI/uiKU7fN3H5didoq3fAK9ikYBl86tl6QR/hZU2GJw
	9QfFSvTrSMJEFItFJW4nWRJGxM9eqi/vHcmR5JVcPtkXvT6eXw/3BBOJEVYcLRGz
	3E9ww==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 42qnv21psj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 15:46:01 -0500 (EST)
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5KPf9k002440;
	Tue, 5 Nov 2024 15:46:01 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 42qtcx079h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 15:46:00 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDcY4hqeWQsxq3X25PkDKN/NpcqCZKFF6p3DuUA/tzC4GUaeZhP5CEg01rVFk36BizIhngFHGJwkVqwg3VMBQUkxKSEQNQwFfvHYNev+rui4me3l6Bc4U3VrI4vUh73H6m0fFoJ2rsfC/R1Oy5RjNw6MNRPL1J1LoRxQ2qBDMRRht5nwslBRX4nikaq4mumtpLz5H80ef9gotcAa2P7EKsmh4PGPiTMGVLvS5IKEGTrKOY01YWvbDhm0HhWLo0m8+UltdcimRC/sTX4y1EhN99w61y3NiQGPDXtXqFUF/ZyghBrEE5mWkYDVnl6aJDGO1djeA18XQ3tOnCSKxQcSnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oB8dgqrT01s4Jo1RmvS6hqG7ka+LiAma8fMrA4fIMfc=;
 b=tJ887FIRrd837FwCEicqdJVmJGyCVZjgHkvyoF3IW1oSW+Rwp75zxuuo1yHY9l8OHjmT94taFBxwW8p0NHNTxQolVoY4bwaSkLFg8Jwf122hv1FvpQ4Dsh5Ozc4v7TmojxTwZyPNlY9+OAC+AVh9Atb4mQwhCA6DC3r80Je6wueuRcsznPK5vpQD3S7o2sARwwBEY6c3XC3wwdUu0I1LNkO/80CxRmW9v2TMWO2eLqcyfnH5YGuDmBJA544u62A78x0OG/XW7OKlCp+UQvfBgLOqwGIfX9abmpVxlvv9Gb+XMlW8NaCvOojPXs0TWyYZ3pTisrQKizLkXcAth58z7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from IA1PR19MB6449.namprd19.prod.outlook.com (2603:10b6:208:38b::5)
 by MN0PR19MB5899.namprd19.prod.outlook.com (2603:10b6:208:37e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 20:45:56 +0000
Received: from IA1PR19MB6449.namprd19.prod.outlook.com
 ([fe80::d674:451:f201:f944]) by IA1PR19MB6449.namprd19.prod.outlook.com
 ([fe80::d674:451:f201:f944%5]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 20:45:56 +0000
From: "Terekhov, Mikhail" <Mikhail.Terekhov@dell.com>
To: Vincent Fu <vincentfu@gmail.com>, Adam Horshack <horshack@live.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: blog post on fio write zeroes performance
Thread-Topic: blog post on fio write zeroes performance
Thread-Index: AQHbL7qu7KlOmTQy9E+qjjx4pjJeUbKpG+wAgAAJioCAAAFmwA==
Date: Tue, 5 Nov 2024 20:45:56 +0000
Message-ID:
 <IA1PR19MB6449DFD774C96F404487D5E4E5522@IA1PR19MB6449.namprd19.prod.outlook.com>
References: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
 <PH7PR14MB74195A055EE5BF97F7054A32A4522@PH7PR14MB7419.namprd14.prod.outlook.com>
 <422c7d4a-5b9b-48d5-adf7-355947d18014@gmail.com>
In-Reply-To: <422c7d4a-5b9b-48d5-adf7-355947d18014@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=3fb43a49-0e80-4e9b-bdeb-de2e0a5d56f1;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2024-11-05T20:41:59Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR19MB6449:EE_|MN0PR19MB5899:EE_
x-ms-office365-filtering-correlation-id: d764f7d5-e460-46c9-4cbf-08dcfddad8f5
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-7?B?WHZEcFVnVDhYSlhwVTNUVm5NTXZZQW4wWXVjcEdma2lqbkNYeXNSdDhYeDUv?=
 =?utf-7?B?dG03SWVFKy1uM2l5TWlWWSstZkhhMHRPNDFwRTljb2Y0ZjU0c0lLajR0ZDAx?=
 =?utf-7?B?dWFHMkZyL0pzOUlWbHZ4VlByT0pMajk1blhVVXRjZGFYTjVwUHdocjY5MFR4?=
 =?utf-7?B?azNURFMxL0Roczd5WFZuOGJ3eDMzY1BvaHB3eS8rLWcxcGVGcW9oKy1zdXpv?=
 =?utf-7?B?ZjN4ZkFXV01IMjNYdlpvaUNqcWMzMVp2dkNKWkhkTS8xKy1FNTlTSkhGTEUy?=
 =?utf-7?B?ZVRFWWwzRjBQS0YxYTU3dzFtM0svMlNySm5KMTZWeVhjb2hnRy9vdEFuQTg0?=
 =?utf-7?B?VjBUckI2MzBnNU1lWVptZk9raG5tOUV5MkRpdi8zajZzNFBrZUhWNTdPaHBj?=
 =?utf-7?B?VHFxUmRmUzlWOHMyaTA5VHNkaFVWZjVNeFBWb1RNMlM4Z0VhZVZSbHM3YnMx?=
 =?utf-7?B?Ky1HcjhUU1M2bkRMdlVRR2hqUE1wWjNWbklTeistb3RTSEFCZUhLL21uc0ZX?=
 =?utf-7?B?UjkxTDNSTVg3NmhmQ2lQL1NZdistbXorLXFVSWF5RGN4MENFelRxWGVnd254?=
 =?utf-7?B?QXB4aGFIUEhFQWtodnpnand1dGJVcllSLzdZWHhVNVg1U3JtRjhtVkgvYXZG?=
 =?utf-7?B?ZnN1NDM0SFRJZDQxcGhqNjhCUFphcUdsQzg0ZHkzWDd2b0sxVXg3RjZka0Fu?=
 =?utf-7?B?M3V1MzlEcmd4akgwSG9XSWpGQ1pFNnpnWkEwMGZXTzFNcUZ3cUoxWWdsTEls?=
 =?utf-7?B?NmUrLXQrLUk0MzZDZGVyZGliZkxCQXlONXE0RkIzekFsOFFNOE1DdlpxY0pn?=
 =?utf-7?B?SHhGOFBTMGdMVU55ODJsRHI1bm55Yk53VjQwakI4YnlQQjdFcU1KOVhQYUdB?=
 =?utf-7?B?YXFTNzY1emdrQ3ByQ2RjejZndHZJb1RDOUpMSDJzKy1QVEhUTlhQVXM2MW1z?=
 =?utf-7?B?b1RvTlpRWW1JRk42c0ZaZ2hIMm9oelNWUjZhbnA0S3JQUHRwSm9qWUExUFhX?=
 =?utf-7?B?SjBFaXZZbVM2SURZRU9zdEN3NCstZjhMRDgyckZxYXB0UkQvNmE1MDM5UWwz?=
 =?utf-7?B?bkVDLzh5dVdlanN5aFNsVG5Tb3I2QlpyV2VYU2ZtWVM3TVJhdkt4MVVNc0E1?=
 =?utf-7?B?RXdhbGNrODl3a1d1M0JtY3lNYTZ4UldIWE1tS2szMkJoS2JlWmVtZXVEMGNP?=
 =?utf-7?B?cXpLMmcyS05ZanBCZHNCZHpwMHFiQ1FxN1I3NnlMZEgvNHl5Ky0xajJaOCst?=
 =?utf-7?B?aXBIeWxkN1VkTWcwSmxSZFV3b0NIalBCZWsvM3U0ZFdmOG9WaVJSWldhMzkx?=
 =?utf-7?B?OU81R3lWYVdkcFUyQ05nZHl5Q1pRdU9zekkwZDdZL1g3cGtqbE1ObXlSdlN2?=
 =?utf-7?B?NWJLRENoZnFFR1BJdHd4R0Y3Q2RNelpQQkp4am0wbENNc1dtQzVUNkMydkRP?=
 =?utf-7?B?cUNEYWs5SkttTVNGZ2pHQ1NUMmVsUm5UNkU0NHpzaTFFcTNkKy01QUxLdmEw?=
 =?utf-7?B?VFE5aTRRT3BaVEwzMjhrOXUrLVA2WE5DVzUvZGdSSlFmaDUyVzhKKy0xMmVC?=
 =?utf-7?B?bGR4aVppTlo0TmhraDgzSW5TcGphNlY4cU5hckIxdlhvOWg1QjVCRCstUHVy?=
 =?utf-7?B?bkxTb2tzRmFTd2xBcmxJT0hMQlBGNjdPbnJlT1hFcTMybVN5TThwdzFTbWNy?=
 =?utf-7?B?d09rdUFHdHNHbnJhZzlsNnRhUUU5b09Pb01mcVpBdTJ2RDVRbTk0MWhjbVpO?=
 =?utf-7?B?QS9oSm5tVWEvKy1aUVMrLS9qWVU3VkhYUkN0VVFJY2lWKy0yZ1k2Y0YzZERS?=
 =?utf-7?B?MGJhaWJ4NEZHUGxXNkNnOUhKeUVockluQistbUFub3I2RkNVTW1QKy04dW1N?=
 =?utf-7?B?QVpWQ0xMSXp3bWFQQTRhbytBRDAt?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR19MB6449.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?bjJ5ZmtkTDZsSjNmeEk2NmNuZERJS3lXUHhMZk5QNjFFanE3MnhIOExPTUZX?=
 =?utf-7?B?Sk9ibXI3R0Y4d0xvQXdBZVUxUCstNlV5YW16dXZCemFJaDhUR25XVWJaZWNa?=
 =?utf-7?B?MDVHdi91SktqeGZnMGxwdVRPTnJHKy1tMXhQSXJDeGc4Z2NMemJ6V3VVTE42?=
 =?utf-7?B?MDFpOW5uRSstck4vOCstKy11MlpjQnF1RGxnVVRwcVpjS2VCNUtpeWZvWFQ=?=
 =?utf-7?B?Ky0ybmcrLTlVOXYzYjlJd0k3TkcvV3B0NGNIdVFKQTUxUm9ON0pvY1ZQQmpr?=
 =?utf-7?B?UXI4VWNUSk1Dak9ucW1GOGFHdnhjNWpuN3VZeEdiY3ZFemZpMkxWbUNsZEhk?=
 =?utf-7?B?aHJDSWs5aFJpb3FPblhnOE1tY01jaS9HcHZJYVR2ZmQxTDZOYTRxREw2S0F6?=
 =?utf-7?B?R3B2QzFJTlMrLTc4b3d2cFBiSnhZSm5QOXBMYlBhYW1yVEFrZGowY0FvaGFx?=
 =?utf-7?B?bkcyekVrRGlkKy00RGNTVnp3RXBYNmNrUW5odFBtRHluUDdjR3lKS3FURjM0?=
 =?utf-7?B?TS9hQkNoV1F6RW1VQURrSXd1dXBLZjE2VktraWg3UDdXQ004bVI2clh6V29l?=
 =?utf-7?B?VVErLTF2NWR5bGhvREJYOEJxdE5WRkc4Z21GQmhqV2xZcHdzT0drTnNSdG03?=
 =?utf-7?B?VW9NcGRZbWc2eFZjS24rLW14UVZEWGhTcHprbDE5VFRrYzQyUU5ROG1GcGJ3?=
 =?utf-7?B?MFQ5OUF4S3RLR3daTzEva1lIVnN4UDdaTElGcHRZZGhkbmMzUWJma2J2d0tp?=
 =?utf-7?B?TmM0akJWMGVEWk9qSTBuem9uR25ibGMrLTFlWVhkcGFTcmd6Y2c0T3E2RSst?=
 =?utf-7?B?OHZrZGpsRWNXdW9Hbng5bTBMUmh4QXdWeDhpVmZxVU9tdGVkeDRTZ2xHMktL?=
 =?utf-7?B?Ky1QalNHc1BwKy0yaExpSEZNKy1yVzgya2NJcW1yOEtuOXc5d2dXcUJwUUNK?=
 =?utf-7?B?M1JuaFpTZmxCenFReTJTSFJHZGlsUXBFWDdmYzlJUUduSUhXTW54cmNmVUVt?=
 =?utf-7?B?MWN4RHZpUzlseGkzWEhybm5PZTVQU1RLcFJBaEVCblRma3BldjRiR0tFRk1J?=
 =?utf-7?B?a2RKWnRJZER5N05DQkpzSDFBa29DVkNwWWorLUJNSmczelpyakk5VkRSSjlK?=
 =?utf-7?B?SUZhcFdqdHBIZFR5b3J5SWc1a1lHc1JPeklZTVZ0T24yTUJuYUEyY0syMTF5?=
 =?utf-7?B?Mkk0cVJuVFFoTEdaUXBSZnByOVNnM1R2WTlqNk9BQWM1SE5BU0dIa2paclVL?=
 =?utf-7?B?Ylo3V0ZmKy1NOEJEc0xSZUF2OC9jb1BmNnNFKy15MDZId0J1UFdkSEpRUDN1?=
 =?utf-7?B?Y3drWlk3YjdLQlIrLU9LRE9wQW5MWGxNTEtoMUwvM0xacDRUdVRRWlhlbnk5?=
 =?utf-7?B?S2c0dSstN2JDMmZrc1lsdnlQTk9HRk55TWl3ME5ROGI5NTdpNHFwQk9ValBr?=
 =?utf-7?B?YVMzS3hOTzRqb29rRE4wdC80emN1VkpWQjh1SWw2cXhsNDg2Ky1KVmhXekEy?=
 =?utf-7?B?cFlGeTkvTjR5bXluR2N3dFJsTUorLWtYVHp1R3BBRUJyRDhsdkp3bFQwcSst?=
 =?utf-7?B?dU54UndxUC9XZGM4d2xaWm85MUV6ZU8vSTJoUHo3VG1OYk5Tc1VqSVJIZXE2?=
 =?utf-7?B?Ky01cDF2bDBMVEZtNW5rb1RzbWo0SjNlRFNadnE1UXdwWUdsNnRoVkhnb3JZ?=
 =?utf-7?B?QjFLVlhwUnBoQkdrUFh5S0k1Y2NubnpqcnVaKy1vMHRXTUNSTFNZekp2dG9x?=
 =?utf-7?B?VjBRM2Q0OVZKMkVNZFNEZWZLY2ZLc1RycE9QQUhXc3N6aVJpbG8wQXpXcXE5?=
 =?utf-7?B?WkgzcVUxdmZlYmx2ZkVYNGg2VExaU24vVWVyRWx3NEEzTzQ2dkZ0eGNuaDg1?=
 =?utf-7?B?OFRzVzAwR09qM3FQZWhiUUZWUkY0dVJ6S2xvdm9sQ0hZa3hWcTQ0VVVyTEpw?=
 =?utf-7?B?MzlJTWRIZzZlajVLVE9GL2RwY00wNjFVT1p4WVVqMzRZbDFrY3R0aGkzMGhX?=
 =?utf-7?B?UE9xcG1KOVpMdWNMTUxJaGQwZ1RMVFZhRjNFZXRYL3NBZjJWUzlxVXYvdlNi?=
 =?utf-7?B?VXNZMFNJU05tZmlBM050dkw0M0ZmQm9BNElHZzE2NFkyR2UxUXlveUp0VUMy?=
 =?utf-7?B?eDhZQldZREV2TWVOc0cwdWhaSHBYWVZPZEJiQkVFSDN1Vk44ZlZ2ekExT1BN?=
 =?utf-7?B?TzlDOGVpOE9QMGNXZWxnVjNkN2x4Ty9aTmViVVErQUQwQVBRLQ==?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR19MB6449.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d764f7d5-e460-46c9-4cbf-08dcfddad8f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 20:45:56.3901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cWbkoGSYOT0H6Q646rmh4gQGuK0XirYGWUdTJzrSVi9ITlLeA0BGYsm5HoVcAr73s4egL3oTANAj9TI2prPdXs6Pk2nqOhlDyZqXs1XXvoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-27_02,2024-09-26_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 mlxlogscore=536 bulkscore=0 clxscore=1011
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411050160
X-Proofpoint-ORIG-GUID: 2LcgiMcrwVSAwjtonwA3oI61wjCDd5kM
X-Proofpoint-GUID: 2LcgiMcrwVSAwjtonwA3oI61wjCDd5kM
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=495
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411050160


Internal Use - Confidential
+AD4- From: Vincent Fu +ADw-vincentfu+AEA-gmail.com+AD4-
+AD4- Sent: Tuesday, November 5, 2024 3:37 PM
+AD4- To: Adam Horshack +ADw-horshack+AEA-live.com+AD4AOw- fio+AEA-vger.ker=
nel.org
+AD4- Subject: Re: blog post on fio write zeroes performance
+AD4-
+AD4-
+AD4- When we added write zeroes support for the io+AF8-uring+AF8-cmd ioeng=
ine it was not on
+AD4- our mind that the default behavior for fio is to scramble buffers. Ba=
sically these
+AD4- patches just changed the opcode from a regular write to write zeroes.
+AD4-
+AD4- You do have a good point that perhaps fio should be smart enough to a=
void
+AD4- touching the buffers when doing write zeroes.
+AD4-
+AD4- Thanks for the feedback+ACE-
+AD4-
+AD4- Vincent

Does it mean that in the regular case (not write zeroes) fio spends signifi=
cant time scrambling buffers and IO performance is lower than it could be?

Regards,
Mikhail
