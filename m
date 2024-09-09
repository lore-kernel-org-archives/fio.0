Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F1B13B2B0
	for <fio@vger.kernel.org>; Mon,  9 Sep 2024 20:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725913217; cv=fail; b=rgZqiva5+ZIwmAJneBkRFpIEqfvtzZTwzb7D6XnE/MiI7x/M+x/yN6eZ/uSTw6LsGRmlCR5nDf7UWjdFO7HsKEQZu1m53hjX7FFcUi43r45+kNg3Cv9um6XjWWveLose5pI8DM0qExGt7z2I5FprPHUiZ5AiVdXDXlkZyTKVNLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725913217; c=relaxed/simple;
	bh=DR4lec/S3dlFPsxIHxC9vmEUhljkhYBE9lA18jj8rzc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mhN6t1I+dMwQVPnWXH8Olw6UDuP2pU0x1W5whPbU3n8nyU9UvsAwnOIJCIdn7/z/+tUvVRhwfXZRRj6Kdab3S5IjFkk2C5jrDoyTkBOPBsbkJ96ac9EWCdqvY0Xbli2L0tGtOpHRtgzNxKgWMJGAh0lYjnsiD8zXFlyzlZoQgRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=etzwvt5T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vrHqWUPJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="etzwvt5T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vrHqWUPJ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 489HBUlv024347;
	Mon, 9 Sep 2024 20:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=1AjLDmZ7rXr+AG032r2BL5IUYkmd/uE/XSczbmXbYBI=; b=
	etzwvt5T4+ffmviPjJJsi9/zHCtHSpX7cTk7rqmsII8JXIqbLIqLbq8isk7Lb+nu
	G/QBn0Q9bnpoMC8plJUUfyNTyF95oSKgiTsqUtxC+Th2T90oFOMEc+3pIV9S3e9M
	sgnd/SrYn10+eX5+Gqgl7Gtc2+252KiE2NP4QRkrFUBI2xftOQHcLzXQKeSLh55e
	foUW8CnSh9ZBgdjiRxOmKz/y6xef17APGUlXo6bsuRcOOlyjY9IXDfnRUIoV5Eem
	fbtOtK7q8GLuevJ4YP3w40aHfqXdv+JN/FwCxp4qekLRnG8hQkZjKAZD9+OyMSAI
	jgUK10PgYEIWQ+eAnkdVJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctbxhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Sep 2024 20:20:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 489IRT9F032386;
	Mon, 9 Sep 2024 20:20:08 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9dxpjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Sep 2024 20:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjGfoWNAr40WNJ24lB13aOxscrK/gYYKv6Ut3mxaLTOSyhkG5eQhbKchHcUFjMvQfx7yIe28vjUghIY6T0I3ijtbLiXO/FlRGZ5MCBHXCxZypuy/dgJlIV6+lQxNmySIOkrg/EzFiyTWSUMZ0s4TJbEYTQIzVKA1Gqe3pkvS9OJ4p6ueVDqjBKuQJaoluIlvMl1KYKZmJeReE0gbcQlUPvjZH6FAs1Ed9hUGpfBOxJe1TYB707d8rfp6snmP7E5l/WP5eGEcdc0iKOAkceS3GlZPDAY6xrNgue6xEO+N1iCRJ8g0lgs0kSgm5N3Z5OYgZfKFzSkdadiMLNn2nhe7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AjLDmZ7rXr+AG032r2BL5IUYkmd/uE/XSczbmXbYBI=;
 b=cpKvxfERTXRCJzbZ7j7ZzTSfIC9SLt8NECBHqpwh4o5UMWX4YanJIRJ4ThJIoNgAN3oPGCmSDqvWH5lyiZph5FjA5Nqn24ca14cTZiFIh3D8uVFwBcsYfMPIj2IZTN94MdyZPzRmyZXPeTykDsj3AdDSrPHsewpdomhzVALyuLEbb4TDZnyb5E7GpIFNcA9fo+mdtDPkIZAsavBE/fL1Fdm2Tv4aGPcoQnFvLgizytc4aoi8F2XRB28Daa1Q9WgZNelqLUgCIDDmouG9Fpczox5nkBDtnk4v4AL6CB1HYTSeGlwWDFBZRAYBvTYHLDK6mixEdg5TibTVB0GNrrHINg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AjLDmZ7rXr+AG032r2BL5IUYkmd/uE/XSczbmXbYBI=;
 b=vrHqWUPJT0C3YofwLpnWgEug+bGuu9lygr1V0agyN/xNYKWyGrDt3cdtM/lSPTy/iHwphDZXi2+z2Hy6sLO//xOmSXF2gpKD6MD3jmr4figMq41j1Cukgpw2Ui64YhkcBw8rGAkf9pBgTKxwXO5Xm/f+ekMhyediXWbCMAMq544=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6319.namprd10.prod.outlook.com (2603:10b6:806:252::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 9 Sep
 2024 20:20:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7962.008; Mon, 9 Sep 2024
 20:20:05 +0000
Message-ID: <2c77d05d-e1aa-4a26-80e0-4ce6f2b50524@oracle.com>
Date: Mon, 9 Sep 2024 21:20:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
        Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, martin.petersen@oracle.com, djwong@kernel.org,
        Pankaj Raghav <p.raghav@samsung.com>,
        Daniel Gomez <da.gomez@samsung.com>,
        Dan Helmick <dan.helmick@samsung.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <Ztl72OINsWHeq4pz@bombadil.infradead.org>
 <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
 <ZtuQVTC4MwdzRDsy@bombadil.infradead.org>
 <76e0cf08-e0ac-4443-b107-86e7d2e4c23d@oracle.com>
 <8e15be46-75af-4d3e-ac75-8c38ec179b0c@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <8e15be46-75af-4d3e-ac75-8c38ec179b0c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0128.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e27f8e6-dc38-4d73-53d1-08dcd10cca66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vy9aeUpwbjc3MDh2QnJnREtjN2JoazFTQkRkLzZoSGlOY0NWaGFMM0xOVTB0?=
 =?utf-8?B?VG85aTlNT1IyYUtoK2x2S2xJc1pDTlI0ejduNi9sMFZsa0RtUzVocW5RODBE?=
 =?utf-8?B?eWdiZGplY0NVOXVVUjJqOWcwSGRzeUlxS3N2ZkZCTHZpc1hjK3pwV1M3RnV0?=
 =?utf-8?B?bk5ubzFkeUh0UHlvWmg1SnZLZ29UaExORXM2b1kvNTMxQ3BTN2RCSEtoUlBi?=
 =?utf-8?B?NXk0RHBHVndhU2h0cVZKL2FUcjhUVkVIaU5VcEpEL1JDVktyZkhmaGZ5Y2pK?=
 =?utf-8?B?M3gzT3ExY0NsWHloRElWM1lFc05VaWVtbmtZWWpsSGtORlg0RzFzSmpDV3B2?=
 =?utf-8?B?eDBJeWFHeVhFZVUvNG1yTk5GVE1rSjVEaHNMam00SWJKVE9UU0pxWWtTM0th?=
 =?utf-8?B?S0ZDejNNWU56b0VuYm10TUVQVGpvT2RXbjRPNUdkdjZwdHQ0dVJ3NXpHbUxD?=
 =?utf-8?B?eGZOUGNvam9qTVg3VmNlTDJnTEc2UVJueVZpb2lpdkNlbXVNYVNpUTR1cnNl?=
 =?utf-8?B?d0x6MHlNTTcwejA5dEVPek5LVkRXWHEveDVXYStMNEFZMWdUVE5qeW41K0tS?=
 =?utf-8?B?OHdzUlpBL0dJK2ZoRE9JNTlVbnBaVmJlaStwNkxMMWg3QVhGRklrVmVDZGQy?=
 =?utf-8?B?Zkdxc2p5UmNHanByNFI3TjNJdVpwd2dXcEdOcGJtSFRicmtubk4vN3crdUFL?=
 =?utf-8?B?WWJVKzM1NmN0ZUIxV0ZpMElmMEExc3pkZXVWYlhCTHVObG5EQVR5WFBZZTE3?=
 =?utf-8?B?Qmp4ODlQY3pYWmV0cHlXTjVPM1B6NzlIdm5zSTVLSVlDUWhvdk0wZUc3WE1X?=
 =?utf-8?B?NGhwWFpES0J5ZHVIZUJkZHE3ZEg4MUtsT3JZN0VkNGxuZFZ1UEFySU44Tzd4?=
 =?utf-8?B?T011VVlXMU5ZRE8vYVArSUt3T25mZlBRL2ROaGdPV1phOEh4TVlxOWZlVXdZ?=
 =?utf-8?B?SXYyRVlYRGdTUDV6cEZEWFRpOHM4UUxDYzg0TThYMzNiV3pyZS93RHlxMXlH?=
 =?utf-8?B?d0RvVVROTlJNUStWNWQ3bUlkc2lDZVRQVlpLYWNLdWIyL1E4Wk9QS3N3Mktz?=
 =?utf-8?B?Z2lqUERnL3llTTVJUjQ1ZTUzbzV4UWdmTG5XdTVWaVl1WFV6YnRuRzBYRnhq?=
 =?utf-8?B?YUpSOEFqTTcya002R3hLK2haSXFFUUdSaDlLYzRwTElqbkU0MFFJQjJNcVZB?=
 =?utf-8?B?QjVnTVBDazdjUVczQUxkeCtYYjNmOC9RcjkvR3BlekorRVhYZ2NJR05zOTdz?=
 =?utf-8?B?b3o2Y0xnOVpOL1J0UlFOVk56a2VGQjJBQjBMc1hGeUNLeXZaWGFCalVXZlFR?=
 =?utf-8?B?cjN4K0VDQUd4cGdXVVVYMk9ndDZmaERpMVVtRTBNNU5qekFsZjhSKzlmVEg2?=
 =?utf-8?B?anpCRHNMTEJTU1JjNU1GWVpJZFk1QWR0SGNhQis1eEdOWWE0SlJXYVljVkRV?=
 =?utf-8?B?MVVPd2FRbmZsOHBlQXZYUkkyc1BoOXhpUkJrWkNxU2E0SnluR0M3T3RYSXlj?=
 =?utf-8?B?aWExcEltQTZWazFHYVkxR252UmM4OWFOWnJ1VlNuQWI2c1drTU14WkZMcTR1?=
 =?utf-8?B?RXIwY0oxbUZsa2JhRTZqejRKWVNEUmM3VXR1U3NwR3JzM3R4RVYrbVVuZ3BP?=
 =?utf-8?B?OFIybVVyd0lYRXpkNFVGVWdVYmZqc3ZWZ3NiVFAraHlhdU1iakVmMEZUZTRz?=
 =?utf-8?B?U3kvbHdnOVJoSDZWcjRIS1Z3djlHOXVXYjlKUy9yNHF3N2pNSWZvT29SM25C?=
 =?utf-8?B?NUVBRVNWM2ZnVUI3VTJMQ3JhNy8wckp6R1VwWHo5ZjlrNG5BR3FVRThVUHd0?=
 =?utf-8?B?M2taVEhZSnIyRGliekprdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlhVUEhrVjM5dFlHVUdhbnduRXFOR3ZTaTFxb3V3VVJYbHgzODl4SU1jZHo0?=
 =?utf-8?B?by8rdUZ0VDFNL3dZTlpXekZubjNiMHN3Zld5bGNLRGFyeVpVQmxIWDZXSHBD?=
 =?utf-8?B?STBORkJIVUhWYkNyZFo0aW8xYmJiM2gxcDVhSFBNeUJDM25XaEVqd3RsM0x0?=
 =?utf-8?B?KytOT0E1ck1Uc3hJUE5UVkZZcGxyUHhvSmFxT0hnamJFcjlGNG5mY05yV3N1?=
 =?utf-8?B?SEROUzk5NDBuejRDUnprZkRObGx0b3pUVFlQN1d2OE0wLzQ5Y3YwS2pISytG?=
 =?utf-8?B?WEY0MFQvVUVJTDVVNGlGaUJkV25MTUhNVkdZdkJPblF5Z2gyeGdmN3Q0eFpE?=
 =?utf-8?B?M0Y1NW9KMWhNMnQycHdSZHpmSFYxUUpqbFBiVlVvWWhBNk1xcHZESStBVWxO?=
 =?utf-8?B?N3lOQXVWdzRCOUpyK3lONFF1Nk1TZk8rMXRhUjdNYklsN2pTa1JlNnZWZWFa?=
 =?utf-8?B?YW1xdUdpSTdLWTUvVWtUL3pkTStLWkVPK3hieVVOZDhSOUVQSEhoclQyR2J4?=
 =?utf-8?B?TnFhQjlyV0hlMHJ2QzlWM2RWaThnenJYU2JMemxTbG1TcWRPWVVBRFlGS2V4?=
 =?utf-8?B?YVVZSWM0WGVjdEZMNlhZNjh6a1NLT2EvR0lVN1FTdm91YkZ1bWtCWFZqUnNj?=
 =?utf-8?B?Z1FONmhReHBrN1VNRmIreHNBcGZ0bTVnNFFXZTB0dk1GM2Q5TGxIYVhhS1JJ?=
 =?utf-8?B?UWtWZ2ozcnJiancrYU81bVZZZDNGRDZoMmtTeVJFUUpOd25hcVpmbExsZ2lN?=
 =?utf-8?B?cWFjQW82NEhjaE9lbjNpNW1rY040QnBOczJpZUo3NTh5R1AxMnptcGVZenVy?=
 =?utf-8?B?Vm1NQi85b3RSeHFxMFRuaEV6VXNaNUFpN2NBVXBjTDBWRndwVWVEQ2gxdTBo?=
 =?utf-8?B?cVNzTFlNcDQ1dUFpNGxBSFUxZ2FPSmxRWmJnYm5hMjl3R01rZDdqc29scTBE?=
 =?utf-8?B?ZEU4cUpiK1BnVnp1MnBUcmp6MlFpK0VLd2Q3UlZRem9ncGdnYzRSV0JuOHJE?=
 =?utf-8?B?dGhBZTgxdGMvSnNMM3FEV3RNM1hRM3hkZ2tJaEVRbVNzNWVwenpZSDF0Uksz?=
 =?utf-8?B?TWpQc0M5czV1akxVL1BrVDRiM2dFMnN1Q3VLczUwMzFXVEFKRkJXbFBWVloz?=
 =?utf-8?B?Nmo0WWlrMEU5bWlRalZWY3pZOWkvb0xjbXpUTUhqMitUZy9mRTE1VjR5MUtR?=
 =?utf-8?B?SFNzcVJhc3VieVhQNC9ZWG4xenBSTmxYMm5pdTc0ZWNZOVpSbFlWakdUOGJM?=
 =?utf-8?B?R21xc2RsNW1yNjVnTVpHK3ZUajlHbG1rYkpOVDlRUlIwRFFPWURVRFVHMnNw?=
 =?utf-8?B?OU56QTlwb2lxZVdSdlhUYzhUVkhsaGFxU0ZVNy9lQW1SbGl5UmorVTJUYXo0?=
 =?utf-8?B?QXFETXduWVFHcWZpYmJCcHFXMGNHanMxOXBNcG1rMFRiSDRHTmp1cWJXdWJS?=
 =?utf-8?B?QnlXOXJ0OGxRa0dpN0RCbXA0azVxazVUcGtSNjRSYU4vNTc0QXVtb3c1WEpW?=
 =?utf-8?B?UjhOSmRuMkhVQ1N4QzZTTnNLT1c0aG5ab0NENi9Cbm85SUh2OE5pNzdJOElq?=
 =?utf-8?B?TE8vdWJ4T2NNRzI5RzdDWGRMYmkrS1pUeE5KdVFKdVpkbVh1TDNBdDZmSllk?=
 =?utf-8?B?S2hOUHg2SUVvMlRZV1NlN29XSzNLYkFXZ2hNVkZUMG4wWVRJdlBVVExDS2VW?=
 =?utf-8?B?RENIaVN5QXA3d2UwU2lnMDZReU5UWkorYzdXNWdhTFJiQ29zMlR5VENVd090?=
 =?utf-8?B?Vm5Qa0YwNUFXQkFHNnlLSnBrdXN2NW5GRzdBL1U3VnJQZ29tcXY5a0J0SGho?=
 =?utf-8?B?ejNUam5XVjVKRDBWVHZLSmZ2cDBQSWZPUlozcjBENFhxZ0ZwVkN4NlhlRDA5?=
 =?utf-8?B?TlFwdlNMUVhMOW4zZ0RIajBuVXZrcG9YalhaM3ovRlhrYk4ra0JtS09jY3JN?=
 =?utf-8?B?eHVFSDV0MUYvMnFUaC9BK1l3WE0xdWhuN09lSWQ2WHg0QzNzWE9rUjN3cmly?=
 =?utf-8?B?TGJaRy9JTkx0eXk2RUxMSCtTYUFvckhhc0dKeEpLYU5mU20welRteTZvTG1i?=
 =?utf-8?B?TzFsaENyMDJrSm9wVHNxWGdaUmpiazMvZjlleVE1RHhpUjh5Z3gyNHg3YWRl?=
 =?utf-8?Q?k+vCkassE2M0MralyeNUuyY6f?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	owM6pxkLN3cz+4hsHSP+4VXBy6mNgOyO91xPOwdQTpAD4FSt8ukZCuX7exkkOU/zUbVS4xCLh67QOC/rUyO/6r3gdutkM98jz+ZsINRYLuepMVNophHWAKKyqgG+SA2xmICMdlrUgcpU7R24p6wmb3CWGTNFKnHImLRDUGCOrFFTJoaPW4CBEN+xaKyzUp9XmYSbPkMQGn7qAyUSEJZTb5VuQd+ecPkPkIthEP1Cwy5YY9deo35wzo+CCtDdmLAY8YcG5WhuQdfAZJJEY4vQXezEUh49sPWjH81ITIwIr6WaZPswcKe1aSKF8t5Ymkr1jjt5wq51rvUCvdJPZSpMJOUv5gGLYO6sypoPSzJQoOJoXpYn9PkkoA8ORvFqH1xHGKrTFsJyUKYe0XRcfHTOgjptjHHJtDikkEextR8QkXlsRfH5oHRWgbGx5mw7KxbbfXljUClAQNfeKm9eLwYm8LVRuYSCV9YuO9L5PA1BYj45XlN/5nL8PTGIHw6LyiZE/JZMFoiiEtsIuGXPI13Y9mSt1PGKMJHb8LqZG2lXUsxToiXQpO0yY8RmXXrsoZ4iStvMsXTqACqqBlFNUlTQGnn8cUvvKhaGTAd4cvn7Ins=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e27f8e6-dc38-4d73-53d1-08dcd10cca66
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 20:20:04.7860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8cFGv5854HH+7lcmRBq6D0v6X5GsOlnDj0tu+7Jt12lMbfyDL9RmAEPHo7Rc30Ld1peBK3nt+v6Slqvsv1JFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-09_10,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409090160
X-Proofpoint-GUID: SBhFVTHPkWPGv6XjfW4gvstE7WVl6p0e
X-Proofpoint-ORIG-GUID: SBhFVTHPkWPGv6XjfW4gvstE7WVl6p0e

On 09/09/2024 20:48, Jens Axboe wrote:
> On 9/9/24 2:12 AM, John Garry wrote:
>> On 07/09/2024 00:29, Luis Chamberlain wrote:
>>> On Fri, Sep 06, 2024 at 04:22:24PM +0100, John Garry wrote:
>>>> However, if we have multiple jobs, they may overwrite blocks from other jobs
>>>> - fio warns us about that. As such, in verify mode, the read sequence number
>>>> may not match was we were expecting with multiple jobs running.
>>> Is that a generic bug in fio?
>>
>> I wouldn't say so. That is just how the verify mode works.
> 
> It is, and it's quite possible to craft a job that won't verify (even
> though fio warns you about it, as you said). If you have separate IO
> threads stomping on each others writes, it won't verify. That's mostly a
> "doctor it hurts when I..." situation.
> 
> FWIW, Luis, your email gets marked as spam. I think you need to check
> settings. I only see John's replies.
> 
Good, so it's not just me (not receiving them properly).
