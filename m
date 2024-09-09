Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D4618A6A8
	for <fio@vger.kernel.org>; Mon,  9 Sep 2024 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725913706; cv=fail; b=Ej435Y+nDVb90Tz5IwN4BuV7gfaRjeB+b8hXUU5hSo1srwC4wgYQkcfNTMS4OfL9zEf6tKEyVxJX4X0idIjmGZebVHASFY7DXtWsHj2SGyu9+ySbdeIqzSU0+TGx7v0oSCkRtWil5xMHk6u1zbePq9hj1dL4cOo/Qt/Gf0/ukGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725913706; c=relaxed/simple;
	bh=NCY2RysYQSY1mVSHtgViXCLoLNyCX5RhfhgGQl+gIFU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rwSpr4feE1Lef5IO6mQEnYF1FTEnTgp5/SjWSc3Ej/I4T3+XbjecbI400PJV7SL1Ui75jc9aUcXa0btoqbo1OWIX+cf9jSd41S84r4poJD1ByGSgYRZhyGfGP8QeozCP6lzKVJ1mZ0kgXVQLbxMQod6vXvcGBq6fAJb7aR8KSKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FPoFaoy2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sOGzzLPk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FPoFaoy2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sOGzzLPk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 489HBWTN030303;
	Mon, 9 Sep 2024 20:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=T8ekxO1Mf2VqsD8kIuUkx4O0DEDRyZWwfxgrsK1Sfcw=; b=
	FPoFaoy2UtfjxTANK755Yoby30mku4eSPqVtqhx1RubvG88A8zmNZDWej2XpJCJw
	HFsPVJ788t5LaEf9Ue7miuUogN7lXf2Ep2Q7H58fnP/XEo9vNBq5uyMRVo7DMU30
	YIjpbDX/PdKSjc/w9UtAo9E6BBKFPPFqu7Kk6e5zZxDTLNeh/K3DKOZ+fP2hMfcp
	Xs4Up/MRnpQrvuP/YjtpPbQEvoFTvWCB3UgB+lL+VfZPS8py23l0tYlsoJIKgzaG
	ZM1xhYPA2MNJC+tKD5SD/PXoa6woLMOghlOxWFoFYphTc5BAD3GmMFhsgfpauH3C
	CG7FFglarBl62GzXpJTJqg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrb40fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Sep 2024 20:28:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 489JA8g6040909;
	Mon, 9 Sep 2024 20:28:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd992nre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Sep 2024 20:28:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrwfT+4DFQhSDZ5ZEHtfIkMkvyO1DVf8zUVuFGxtKmRmZVvdhv00PNPJzkMbnRqXbUw3/odje17mLdzPj3xiPvnusl0zhqxJI9303ny9BsZDJS4VJ9btBHbd9sarCZja0snak9nbGJek2zKJV9EXb5xNCCJQu7vwCy3rN9nXRvqRk6wIKd9plxMQJ5ZrLTFe6U24P+7vKk258mTPVOy+4hAlYiQTvOgmpypSz9l/rLBssXUYNFI3RjP/emcSTEHqMcS8jjPwZp3cuLyUz+R2BlmF+8QTgM/cfplT17oHhmSIGI/ZPBg3ShyoAAV9YviFiCzjWqJsxcerPbRSobxH7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8ekxO1Mf2VqsD8kIuUkx4O0DEDRyZWwfxgrsK1Sfcw=;
 b=ja03RMq6rtsrkM7CJR/o02fCSuJ+y4JuCk7lJiH/TGpHqNcwKcmGidgmmq0ieIuhOHkKM67zk1KDXsPZjQXmHibm/s/DIrzCUmy1eIX24C4ntj11nct/BF7LQorEPZ9pUjD/App7wTOyISgjNYR2VR/qbUQZFaNvQHcrpR2xu/qKSqktSqcFJUvg8R+7HvDnQoHTuCM1MBo4UhQ3a3pMfXDK81gmabs3CbaVdHg/e2ll0g/CfqhWRfyeYEFaGDbULsiJxvrKo4kKdGmoj1alPXspb42mjHtjlgrIxxyCVmNK3l0JVfSxRjPYN1fxo4/5aEY7i23kmNVDiruolu2MIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8ekxO1Mf2VqsD8kIuUkx4O0DEDRyZWwfxgrsK1Sfcw=;
 b=sOGzzLPkyrdu4qJ47/+SG+6coqh53KwDr2nUQIeOZXQEp5Z8QRm1mop33uAseIHH23TExgf7Ef8f8vJcF/r3kGJ1FqwKDG9ZSuU0POJZg1tGT89FwZz4wQiGG8ZiijfsFPooaj9eobJQEPmEHZU/8qGkyt2E0tIB6ycRUYGVDXs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6273.namprd10.prod.outlook.com (2603:10b6:510:213::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Mon, 9 Sep
 2024 20:28:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7962.008; Mon, 9 Sep 2024
 20:28:17 +0000
Message-ID: <1185aac7-de61-4071-83fe-802b52e458e2@oracle.com>
Date: Mon, 9 Sep 2024 21:28:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0547.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6273:EE_
X-MS-Office365-Filtering-Correlation-Id: c5612296-5b37-4d47-2f78-08dcd10df056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjBZMHRDZThIM0FiUk5OdDZYenh5cDQ5YXpXS210WllRVEhLdmw1dUNGaXZO?=
 =?utf-8?B?UThkVlBQalFPa2RVa0lxT2tYNHdQTVBBOXVLUEpRMksyenU3TVN1bjkzaWpX?=
 =?utf-8?B?MWZ1ZmdaTm9GZEorUXphSEo3OW5LSlJWNkdzbDlwYWYvbXErUVhzU2s4YkRW?=
 =?utf-8?B?dFZwZ3RDaXU1Z3Zxd2dTSTZlYTdCZitQM3VBakVxazlCd2tkQTJQSnZ1RmZi?=
 =?utf-8?B?R2o3NmgxV3FHK2ttMHc3NEx1WldYWUNmZm4rRGJhaktBY3U2RTNKYkxvOW42?=
 =?utf-8?B?Qlc4S2JNUkFobUp0UkFJMG5OcVdYcGQ2RnpxcWtwSmxBUjNtQTMrSmdvamF2?=
 =?utf-8?B?K2xvUUJSSVdZMnhZd2RudkNSWnFMUHBqeUNuUDRRTDZGOGFFQzF1ZWV6L21y?=
 =?utf-8?B?RUFwdDNJemJ4UlhBNGNwY3VBNHZxUVRBa29WYWE0eW5hQW4zMnAvWDdnZkRk?=
 =?utf-8?B?Z0tWVlBFT0MxUHZoMGFkNmU2Z2h6OWRyTHFIeUd4RWxBY2hETGxFRnJjTWV3?=
 =?utf-8?B?cU40YXJpckhEQW1TcDlDdklSUmtlNUI1cFY1QU5mWGZrZDU3NnI1cHVTNE9t?=
 =?utf-8?B?ak5iTjg3VmNlS2dROXRCK3U0K1ZKb2RLQzE5RGFEbTZ2ejNwNEpzRSsrVnFS?=
 =?utf-8?B?OFlETGo3aHBrUG4xck0xSmNjYkZrc1gvTGsxOVIyM3BQc1NiYWk4aFE4OFRK?=
 =?utf-8?B?Y3hTaWRmWTdxUE5iRWtTVjhuSDVpeUVybFFZM3Q0dkVuV1JzSzVsdHJMNzd1?=
 =?utf-8?B?dTc0cmliTDhFZHI2SjBxbU5oa3hRa0tKVFRYRVZIQWVBN3A0NERETWJZa3Y2?=
 =?utf-8?B?UUdFN3U1UFk1S3dva0hKSThZajdnZmtuSTQ2a1VSMTdkbFBlM0l2SlJzMDE3?=
 =?utf-8?B?aThYcnBpNmo1OFRkS09vWTFlSVIzM0g3a0ZSazJUN0hpNDhpdjNSQjZUQkRr?=
 =?utf-8?B?Uyt2K2kzYkxTemV3NVJVa05GWUhKT21PcHRSaVQzeDZEVXBwMkQrZWRucXRo?=
 =?utf-8?B?N1Bwd1VWbThhUVNHZXRSRm81ZkFSUTI1NFRtWUxPbTV1RGd1dkdlYW1OU2Vq?=
 =?utf-8?B?RE51SFluRzN4cFJlVU5jRXVDWTM0aDJrQUNLb1BjQ0VsZVgxWFNGanBtZzJt?=
 =?utf-8?B?VEk2RGY3QitxT0ZCMENMdUNueGE2aDRtVWNabUZnRTRmTGhRdEU0TlRkOVdz?=
 =?utf-8?B?MkZkejlnTXIvVzNqK1gyZUpiNExZQW1Tck0rVDBLaHhKSkNnTW5ZN3NoYkpP?=
 =?utf-8?B?OFNPaDR0NUdiWnBvTE51YkZmbzA3VEZIV2IwMGVJMzd2d3BSQzVxTElwMnov?=
 =?utf-8?B?M1RqK2xQaEVVT1IySTh1d2ZOWjJxTXc2TGxpb0ZjamNkNFhrVCtGbEQrbmly?=
 =?utf-8?B?K2lWalpIcVltNkFsTTlIRXNlZWtkUzkvdzMrV2NMUXI5VlFCdXY5aHJpVmtW?=
 =?utf-8?B?cTN6L1d3ejlVc1NZejl0WWFUQVBnVy80WkRpbGdraUJmWnlOb2pnUmNRTVU5?=
 =?utf-8?B?M0U1c0w4ZHVoemNPdTluV1NsTno2M01OazJqdWlXZUFOMlNhNVBod2VEYlhk?=
 =?utf-8?B?TVBJNFdhSHYxWXA4bGhwZ0llbVBFc1RUdXR0czJZdWZUT1BjaVQyU1h5eGV5?=
 =?utf-8?B?eGVDa2xhendzajZpcU1hTHE2Q1d2UVREUmlQQ2hFbzdnM09pNWF5emVoZ3Q4?=
 =?utf-8?B?eUE0VDYwOE84UFpQelp2OTFHWmtmQVBVTDVQOThROFBldEYxTkxEdXZKTU9X?=
 =?utf-8?B?azZVQzdWdEc1NVB6TDlYWFJGWkM1bys2VW16c1d4VXBlUWlYdThYSklHNmNn?=
 =?utf-8?B?VjRCWU95a3R6U2ZmbmV3UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emU4SFhadlFxb1VNbUtnbWswV1dhWkI5LzEvRTBXbk1jVkl4ZHNLQnFYdnE0?=
 =?utf-8?B?eHJXLzZSeDhFKzl0bTdxdW10eVFUMzZUalMvcUEwdDM2UXMzKzVNbXFHY3R5?=
 =?utf-8?B?NnpOeWlIdkR0VHdYZThzdHhNajNxTStGRHZyclZMLzBmazBLelJkSS9SMEJT?=
 =?utf-8?B?WWQyNWJTdWJlaG5HSmQzQWFibmYzR1JoOXlsaUNZZXQ0c2dxR2JGZWErcWph?=
 =?utf-8?B?ZUlISkp0NEljSHMrU2JEZlB6d3pyOTFuRXRnUUtTd290NFBrekRRcTJPQnBE?=
 =?utf-8?B?NFppbllya3pZcExFSllobGc2dVloYXFiZGxrZnRhTit1MFdaZGJzaGRBQnRK?=
 =?utf-8?B?cVMyajJ2SGxrRDhyaUxwSVplR3pYWVlkUlU1a1NlamwzeEdvV0NnKzQwR1pp?=
 =?utf-8?B?TkpOQnhHb2MvZGpnWXU5SU9DaHp1SFRIWUhRN1RVZ3dOQ1JnakxvTEZQZnZs?=
 =?utf-8?B?dEVZSzYwWXFrcTJQWlMzREJMNERrZ0c1RDFxM1krb0FLZ0ZqNS8yeGZscnZi?=
 =?utf-8?B?NlBqcDZwQU44LzE3RThwcWFjejZmZEsxYzNwYStoSGNOWmpVQ3g1OFZwdzZ5?=
 =?utf-8?B?bkF0cDNPZlNxUS92VE90TEF3Z0N3RGtHQXA2WXRWZmxyT1NHbmRoeThGdXpr?=
 =?utf-8?B?d29Oa1dIQWpJeWU3a2JmUVRhL09BK2NLbk5SNGhRczRVTUpIc2tXak0vN1V5?=
 =?utf-8?B?MU8wb0ZiQVJBYWdHeW44UkZ3bE5LRkF1Z0VkWmpPZ0ZVN3NkUDVMNUhGSU9r?=
 =?utf-8?B?Q3dCaXZWSDlEczJ1V2ExNVZwTGcwTzlMRzlPdUtLZzg4RG5LQUcyeFdaek0x?=
 =?utf-8?B?V1MzNWNXMHRDWTZrdXNiU2JpMG56d3RSTDJsWis0U2llcXFUYStPWWNtNXkz?=
 =?utf-8?B?VVlLZTliUlE5OThjakhsZ3ptbVpEWkR2MHpzajF2N25rYzdvVGt3YXdDZzVQ?=
 =?utf-8?B?Z1dpbWN6cmNTSkc0WlNTNEZtZ3FVZVZGTlFiMjN6dXIrTkxGNXBJUGtucWZ2?=
 =?utf-8?B?Uk9TMGJWL0FpTU02QjNpTTJKcHdXNlhiVUN3OXZwa2lOYnI3KzY1M2NISncy?=
 =?utf-8?B?dXJ5Y0NGM1pEZnN6b200OXdLd1FibkZCUzEya2djRkxSa2hQQjVydVk3TXV1?=
 =?utf-8?B?TWJVYzNwcE5rVCtsN3cwdU4rNlYwUmVqL2pRYlJGNEpJSEVVeU02WnFaalF2?=
 =?utf-8?B?dGJ3bDgvUEY1TndsNW54eDF0dE84TFpuRU5DNFVNQU1JZTJxanA0Q0d4cnFM?=
 =?utf-8?B?d0NlVU56T1BYaDhGOXA4RDVuTTM0dVI0dEg1cW5sMmt6a3JNZUVFVjlJSXJH?=
 =?utf-8?B?OTZwYU1rWnpRUkRqc0lMKytpaFFSYWNuMGVuam5DeDJTcHZIRjRmS3FVVzlM?=
 =?utf-8?B?YUczZ2VsTy90NFFJRjZLd1pGRVl3MDVLWXVaRkl1N001RmJKUjM1S1dkZmc2?=
 =?utf-8?B?OUJwUFZ2d0c3WGNUelMzVk5wUktKU2lKamhzQmZ0Q29xODlDbm9JdUVRMmZR?=
 =?utf-8?B?bkozS0pZSEVDaHZxODZkNWdxdUhjT2JzRWZhMDlhaHRqc3l1SDU5aFFjYnF0?=
 =?utf-8?B?UUFWeXFXUnZMSThMQUQzKzBqZjNBWWN5a0dlU2s2YU00Q0lnL0NxUHl3ekQx?=
 =?utf-8?B?V0pNSlFmVkt6dXZPVXRyOHZQRC9CeUptTjZ3TjcyVW1peG1hb3hJOG8zYUtE?=
 =?utf-8?B?YmhQZnpLUzh5RmJGeGQrd01FRVJ5NUdjLy9hSTZmVGZzK0UyWTlaNlZkdVVz?=
 =?utf-8?B?N29lK043dEM1NU44L2plSExmSlFnUWxFd3MrUFlVczJKUStvTGVvTGJQT1Va?=
 =?utf-8?B?ODlmbm9XWUUrc1R0VGhROERpVGN6cEVtSkoyVnVUMVVhOFltYUFVWkVwdUIw?=
 =?utf-8?B?OGtVaGF5aDRiQW1BWjY3SFE0eXpxVFE3ZFV4Y2dtNTQyeElCZysyUTQ1R241?=
 =?utf-8?B?WDdrU0tiWjdKSnhMZmJqRmpZMCtxajZnRGFkKzY5YS94MFZBUWVzTmlIbDRq?=
 =?utf-8?B?S29yTUd1aXhGOFVvWmVkalphcnZXZExtRURXTDk1TWp3WTFDM0JDdkw1SS9s?=
 =?utf-8?B?c28yRkpHdHcxYzRVaXNtbm1KVFErYktwNFVBdWFqUFA3ZkZjRkZlWC9RdENh?=
 =?utf-8?Q?ZAB7oLI1r4l56yRvPBYWh+rRD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uhl67sK9QsPMgd5TVK3Yw2h1pIOAKzwzHjHI98cenVCJ3EgWk7jfmfynYxmQVv0gh2aRHH1vDtKBnXFccq+ngVZl+wk3UJD80Q+ODpBsn0UTZMZAIXY5SQtyUIKyV1RxXFxAQcQqlKkfBj7WYDE80U5fE3XfNhIjHp1WsXaV/82OpP08BbzkXxeaA/GRAl5ETgiKZ1MIoh71+0UX1A1VuxCOYBaJk0dC/TbRqe7k8g1dPeZl++/5XdS8egNvQDuLTc65o9BJnbzS7AMh7JMMZW0tEqYRGdQ7KqWuY0nR48Rr84Oevd1ypknKzJFQrFi/MZNyCHvL/ZvkUHvGcS6wFMs7oqYMoPOJYbTkgNo3/GCVIqTafqTZlsOHEdc1X4+YSQnnWWVCt6l11PrWwgKAUKGyjBW4OIRup06s8/2yXqdAX6+rfeFGtBUoTvDk1P1oKutBw/0rkzq9T1PTrYDxT0D7eLeljh0pGdi0LQGmbaqo4rDOlnrKrtKM+pYWAS1/MmbEe4ULHBhZtTg1vvX+c8liKJ34Nvfuiz7QPoqu+FWl7lsSucM6L8j+Ap1S8s7NqtglOaUA5KUI1Odxz8kx84WeRd6gtXxbkMkogjEq+5s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5612296-5b37-4d47-2f78-08dcd10df056
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 20:28:17.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nP23CfYDFy32d0u6I5CigH0U8CVA51+1HgK6L14GKzFY2FhodZpEvmlmp7AgybhZFmm28khULkvd99uzf1o8oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6273
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-09_10,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409090161
X-Proofpoint-ORIG-GUID: 12vUDOm6nmPuBwKSyYtplyowHjJ02ttF
X-Proofpoint-GUID: 12vUDOm6nmPuBwKSyYtplyowHjJ02ttF

On 09/09/2024 20:53, Jens Axboe wrote:
> John,
> 
> Maybe it wasn't clear, but I committed that change I mentioned in my
> initial reply basically right after.

Thanks for doing that.

> If you could send a v2 on top of
> the current tree, that'd be great.

I was preparing a v2 the same as this, but do you think that I should 
just add a new verify option for atomic writes to ignore the header? Or 
is just saying "you have selected atomic=1, so I'll just ignore the 
header for you" ok?

Cheers,
John

