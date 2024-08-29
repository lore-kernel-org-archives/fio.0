Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D8195FF1
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934690; cv=fail; b=J1xWsT7RqZZJICiqXw2puy1gKEojiXR2U24AXdJl4vaLagvY1AMYQCTRla2679junTCVRSMc0FCTE0caXK8Ycf1ljChcYHd8nT0Yc7YbovluZWCuZm7n/FCr5Fs5tKP/2ip+Y4gyG7WILWXE0lK/hOQtjq58wEyT/APtosoavBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934690; c=relaxed/simple;
	bh=MCfL2JsyxPT7aj34L3LzkIaol4NJnrfURmPEmwlKcx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AYCrJQrW0Muw5g6sNrX71IRP851eBfAwnqQ+/jfUOlURG2vPFYtOFCe9BlTyNonj9jdFW5cVxWm0mC5kldkP0wKGNJMwQJjTaLO3Fg+nYXfhbU2ZNQYpBGPCWtT++Ietlv1Mc6NTz3O3s+eJ5X4Z5fz78/uq2UftB1cWwBifvTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BvOXlMlR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L/M37EsV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BvOXlMlR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L/M37EsV"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TC6AU8030195;
	Thu, 29 Aug 2024 12:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=FIhCmvvanwezPK3X6eYc88Y69RCyH293bQzonAvYQRM=; b=
	BvOXlMlRnwLlM4+dxjNwitwe3tFDf1Bz7U61H8b5oDLmqipBPFcNY2Pk7KDlCrAp
	kNNUkwQ5Ve3PnaDr/2OixyRtKg3Ohnwaua8ZnXGn3n3YWZpNkXvL3xHzGm4xW1Hy
	QLmG6+/K7fHzxDvRMjAF22TS+Qk8tt3JrMyLqw7ayQe/pou7d549vBqjXUGykLNg
	QAid4L8rQgxhC8rFOmYZgBBmTmz0+YEHekczWNYZeJHPWixxVrU4VcKkH+Hu8uBR
	Zpka6vGzicOAkMNCYnSMeTrPFqLOr/g6jTWeXZQ4El0MVMirhvv5beTCe8XTQbOj
	IhgWNC8ccoVTDdaZxSY0pQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pup45c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBDdmT010212;
	Thu, 29 Aug 2024 12:31:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894qn9ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9KgbZKmHbNS0MjKlYOi1relmVWUZK7PpKL86SdwwntWf7f8TLTbpRLEFeRA4gXy0qMW1213527tqFvyfxri7QS/DWQxSo1/WsgxrBFhsKxZtIdyz0TNcIO0p8Xub6uUr7Z8q5HQSPl27ULMe6v2cCr1ums7mBBNy5F6Djfgl/sgbqF+IlhPSV2iZaMn/k/eJ7mIRjIIWFHZbgoTgH8PtHAZPQYX5lNnWUC+NFa3hPKKi9hkZUt/4Tuo0cv3UB2Gb+oMgsd9PFaGr5v85NCfhryIu7MiBiZJAQIFpGE2GcCQQF8+scKv/KmqGpmHdi4PP73gpuxWcDd3IEUqyCRvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIhCmvvanwezPK3X6eYc88Y69RCyH293bQzonAvYQRM=;
 b=FsqzGFkBTL7Ki6lfda82moUAWSN2l8KXNqK5qVkbpFwQI+y+i0UK0W3b4qP5FoAzB+1j9NptJOyDcl4NCwnQ0UUYJfMmO81nUNSDNSUsoByJfIUSu9jXZrSWJRSU78tX80sL2/FUt0WLVNOQ4q6BJyroOxcfFcAt91Vs9ahjAhP86SnDNEp5RIP5s0uWazdFMiM6CyWEL0Q/2x/b4o8Q4rCyfEtJPeDHAljjqoHhfVxSAbLsCDLoYuyCD8xOnavOLCbHoLq8svlFW2xoISCffJczyoenV0GhUafIDR94QhDdqDk+HxTAOwZEaizdnOV+fHa92Cu4XpRB4XVs+XuURA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIhCmvvanwezPK3X6eYc88Y69RCyH293bQzonAvYQRM=;
 b=L/M37EsVY1SZQVtuVC2tJ73kEirtU/znhQg26Y5bRQ3AmTlOW/LlFtE44U9CArIKZkkhjSTLIZwIbdKfMr954x+FJn1i6jDqkl9WQLEMFsv/RcmWdrYkCxV7124eTxBwc5mKzl1oX3xNzoQnqMmVd/G26uDqBCcPD07kQ38uMEA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 12:31:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:21 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/7] os: Reintroduce atomic write support
Date: Thu, 29 Aug 2024 12:31:03 +0000
Message-Id: <20240829123107.520005-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fcf8fe1-658f-4278-1290-08dcc8267c9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uYSA1kX8tLbefFRlAx2MAR6Ljc3oYMWq64SIouLnZWAx0/BkfRRU4okIHaOl?=
 =?us-ascii?Q?Zg7BwmgZA1OOqJxRqJe5KNzpEuzlw5qXymQ0rgEypMRe0arUL2rAj6MQTQCP?=
 =?us-ascii?Q?NW/EGvcDpq4Td+62pPrJuKagG3Fvk3zs09Fvi6UIoH1HVsMDQXyUlYJNYHj6?=
 =?us-ascii?Q?O/y+a5TB/2zrihLqbBERRlhcH0wmvpVTN51uJzsfipH3ldoYGfu5QqRiQEMT?=
 =?us-ascii?Q?AjskD/l4vt1VRH6ie+4kuqjJ6tRT5zBmmgC55eF7vx0q84YEcoD4SCY6JFtD?=
 =?us-ascii?Q?rPGbFjsnj7g8o7UUF7FwFcePcgYeN7qdjdlbkqrcQtrNxhekcdCM7acOx4aU?=
 =?us-ascii?Q?SbHNVMPSLIaCnL99dWPhHDXf4otUZF+C6LkjVC0N/FoxTEO9dno0LwIyXpWZ?=
 =?us-ascii?Q?xnBUVSjqJrwt/9xRtLMum22qekDEOxsJP66It8oILyTZKhYwnjl5w32VBg2R?=
 =?us-ascii?Q?IETo35Hm0aV2k1JVd9ENm0uoa7t0825VQyNo7U4yQTd0QRCbqCuuqw9pzYWI?=
 =?us-ascii?Q?EYMEdgrcz1GdGVN2E/hzkGnGfw4mGfsLRMBZ6A5zhy1qO3tRduF/U4O1sTst?=
 =?us-ascii?Q?e1QFv4bZa5R/0IwLtyDghjc7SuTKglN98pSH/ilN10ghmtzeopFRx/Vd1ezR?=
 =?us-ascii?Q?ZRFbYVlEBVtF1OTsflaIDuCbNn7aj7/LtuFZH6Z4xxa1eIQ6NhOi2P+Cp1ZY?=
 =?us-ascii?Q?F1PbSkio+l58trlx6mMEFDiAH73CCn6VTpB3+S+pikRw4+YU1ud9L1l7LkCe?=
 =?us-ascii?Q?UixoBZgIRVFNS/s1clDxs+DMp+3Qeh4pIF5oRkXSNjABQPPzoHvVylOvnlc7?=
 =?us-ascii?Q?abSqlE+JG6EyEls1Lwecedx3/giQ9koTD2FdT3NZ1Ryww3iFhp06t8wfrFOO?=
 =?us-ascii?Q?CcxHSUOVO0lNf1w7IfJcvlFMn6LaVW6cHQ1U2HXsGfpj+nXF32WILKE7PFev?=
 =?us-ascii?Q?SgVUYrlD2fN0Saxd4CQMwGWzr7Acam2/37BKk9ImwGCbRS/yVAjvAuLase2C?=
 =?us-ascii?Q?rIC3J9j1uUHyTcnddZ7KPJu5hZHFsjZUCvgtvWmhQ25A99njSZ+pd+U+pPqC?=
 =?us-ascii?Q?4T/1Au9CTii2+1hAMstrHEtCkoxKIIlvV2RaKQdyO2MZyaDIEUVaz4MsV/Im?=
 =?us-ascii?Q?ldR+wfM8nK/nqD/SXO7j0eFusQHTyol2bUVy76TdLHiGJ+bLsNTaNLeHnijY?=
 =?us-ascii?Q?8u67UiPN2gHapD6AdRbXQWizM5CW8zBVCYs6LJazHUaG3D+zIfxbzqHW8GZW?=
 =?us-ascii?Q?h7FVY9ZyPiiZNDD7l+PftUnvcYGTbY7mxDyNgxGVzb60HjismtFF+U7TtU7K?=
 =?us-ascii?Q?Qc4DuVVrL5BmGR5QFcBIjPxAUDGWiegrGP6VHft247SdUA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JCuPGilShbWWh+4rucOzrwfQ3K43eabNNuJ9izYlQr++RxMOcs2rr9nTUsNk?=
 =?us-ascii?Q?6AIoaPv/pigA5IzcfVoccM9Nf4ae29OIyXr5fPWRrX5TNDsAO68o+wJze3x1?=
 =?us-ascii?Q?jY7Uozo/Fms3txNzutqOXKk/oirc+mR8EASSJgN0rhmvS3QlXuTqJ+mtQhip?=
 =?us-ascii?Q?UtCkaqGw2SM16YYEc+lMbAPyxcY1ZoqWpYtuKPzkps/rfkbkMC9OQpWD5Fuz?=
 =?us-ascii?Q?TJppfa1deMs/2GSsKHDA8XQ/rMIdKHgbpw9p1CIkQE3fdc57vIwli/X33HE8?=
 =?us-ascii?Q?IR3wItPZPcQ1QRwaPNKv32U3dFdnb7FGJtX7i9AmHg02SMg4HnCcELyvGbF1?=
 =?us-ascii?Q?AMs8F1mCqCD3X/oZqTB8O8V0jKXGfa3Qj/PLvzHM2FyOIboZ/gd62zp3ZPfs?=
 =?us-ascii?Q?mldh+eq+FslK0176TEwbiwryjOAFmUjJCtIKugCm3Re9v/N2T7SSRl9smYWc?=
 =?us-ascii?Q?7kTJfwrtlNRMUyKepDTG07JJmkUwykivOM8vVflZLXP9D9eebTWUmD5oz/uB?=
 =?us-ascii?Q?+ywjI9ufxtwtIk7dpKadGLoqBfTpuAjHvJNWdsXrNWjpFMPnFigROW/KHh3s?=
 =?us-ascii?Q?RBZq6WxTqxrLRq+MD9yYyzF6grVQ+ekffjFEfRuiuuD/dcl7YbrTfug6ydW0?=
 =?us-ascii?Q?pJ8rxQp18CyEj8P1RMFKwlC9C9rt6eIXO+tIyYAiFU0Hsl4kDqPuW8C1wHBA?=
 =?us-ascii?Q?0f5MsY9X3hM75bhOh+hjTW2N5nJ+UX16K0yZKpTdQEud3nETXw6eiCntn1VZ?=
 =?us-ascii?Q?f4GVaNrT+WQG2hfkUZNk2fY8eDgT+/R/aL6CHV0gw0xhBjtnfbhNv/ubqTlc?=
 =?us-ascii?Q?/+vGf1GWGiXyxU5nmf6Xmxb/aYWj/i4xV18Pu1VD+VwyBZ53tiCDKlkgtkzu?=
 =?us-ascii?Q?RzO7a1azwY9T8FbqN+rhOFwH4VevYTXuldOg0KWZx0c/y4sJP+xxMLtoks+h?=
 =?us-ascii?Q?vQrMoZ9uAk0QvJsYxP8YAnOTPZb9YGOl5E/XDRIg0zSEEGkVBdq8W+tpSaE8?=
 =?us-ascii?Q?zyBshgmsmRP93zZHREJKbULQQwsZeBfXYqcT6Rw3T5ePmBQiTleEzvKj0W5o?=
 =?us-ascii?Q?fZIHubRVYdfgBlKHPq7Fw05EHwweJ6hIosIESk7hQw8EhBzNlJSw8SomU2kx?=
 =?us-ascii?Q?skJ5F0ue0M9rJ2mImDQSxr5btJydgdhf91swhnhfIYqFF/X9AIWwRfoTDR6o?=
 =?us-ascii?Q?VhJjDIbsqzg7SNwQLKAJKyZDnTFfi841QQXVKYDhXqwjbaqs7c0PkXINBJ3L?=
 =?us-ascii?Q?EA4Ha1vWIOWHcYCss1or0y24DlhFAkG4outSS1s7RepYfrUkJt0x1r+SXIzD?=
 =?us-ascii?Q?pRR2wDCD8dxDr5KzRIxpVyVeBYJs2eCkI2lrZu+J81dnMkezIt/bTfhSzdBW?=
 =?us-ascii?Q?yn47DGAjWaU0zrUTSK84hy2psYj/4KFPOyTXwe/SwDJr8dcbPpffYLRXzbvs?=
 =?us-ascii?Q?x/acfeWP+WNmlcBFL5AObCkMy0talqDdgssmlmmBaIUKSNYxScDBuBmKh9jx?=
 =?us-ascii?Q?w5sgsB3q3D6pRiVhd5QS+A1e7R43ldxHGvIdB+Q74gwGNmfHO91M0eF8aI1S?=
 =?us-ascii?Q?AGhVjz1mooH8fQYRbkMx5b80Xf/+hrViHDPBdF+6xqNH8c6ccmnFG/CDY4DJ?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CP+DmZiyudLZacvrRFMVnWUxQc/4gxQrooE1UpZ6np3QCzjd17iBk+XqcdQUGRBvNVbeQu1GLRDp4htfgvSa9LJrSc1LfHs64rEI/sFWuPzEv5WqcZUfIrPDcI3jiKqMjJMNaWHvYA41vtTPEmJCrJ68eNTI8DGog70U4GJy5NyLE0rIY5vtqnv/BhzIV3uc93l9nNX34YuOJuT7ZCT8ZZ3MfSqvOS30SVOV8yXIwTrBHSqqJ4exj8HC4FBovBaQxV6/VNzuY8RreXP8i9M7sH1m7o0YMeRS0b/1HgD+RfLDMwW7CAguj+Os39dTE2mH0Uyrh1QxLwga5B+56IqNw0HLHO+s1Y4QBJeEp4YNbomr5OdZSQ7oKfCEQDT0y6TZBlGWM0ypmtJD8WV1OMLRj5KWR30Vq3rCwZkzTkqcvQX6NX5bpBc6cn0lJU8tHAsU21TErCh59dBUGKBsmLmj6lv0w6w62adGrt6op1eN3vqge/gW7rSiy/u2A9/ZleDLvb2dcnCUghg+953pvgb9ZdyGG6vXsBAh3WVboLvkfbxhmDA81a+3VGUmx/uYR3QcnjF5H/jfdxgjd6kgf9c3sJuXd16j7cfeCNAXSOLIgWE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fcf8fe1-658f-4278-1290-08dcc8267c9f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:21.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vizm5aOVlrYXNbq3878MuQXjMaJaP/H+cWwgHx58lijEgXxRso1Maxb6F8E+3yMQrgSQ3MqkhrJFdiPh9PiNVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: gQl9LZRM4AsV4zdZteTaiv47hDpG5dEg
X-Proofpoint-GUID: gQl9LZRM4AsV4zdZteTaiv47hDpG5dEg

Previously O_ATOMIC support was added in commit d01612f3ae25 ("Add support
for O_ATOMIC"). But support was removed in commit a25ba6c64fe1 ("Get rid of
O_ATOMIC"), as support was never added in the Linux kernel.

Linux kernel 6.11 will add support for RWF_ATOMIC, which can be supported
for various ioengines. See latest man pages for details.

The plumbing was left in place for thread option oatomic, so that will be
reused.

Add a flag to say whether an engine supports atomic writes, and reject
when oatomic is set for an engine which does not support atomic writes.

This is a change in behaviour, as since commit a25ba6c64fe1 ("Get rid of
O_ATOMIC"), this oatomic has been ignored. However, it is better to tell
the user that their ioengine of choice does not support atomic writes.

Today RWF_ATOMIC is only supported for direct-IO. In future it may be
supported for buffered IO. As such, do not auto-set odirect=1 when
oatomic==1.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 init.c        | 6 ++++++
 ioengines.h   | 2 ++
 options.c     | 2 ++
 os/os-linux.h | 1 +
 4 files changed, 11 insertions(+)

diff --git a/init.c b/init.c
index ff3e9a90..84798b3a 100644
--- a/init.c
+++ b/init.c
@@ -855,6 +855,12 @@ static int fixup_options(struct thread_data *td)
 							o->max_bs[DDIR_WRITE]);
 	}
 
+	if (td->o.oatomic && !td_ioengine_flagged(td, FIO_ATOMICWRITES)) {
+		log_err("fio: engine does not support atomic writes\n");
+		td->o.oatomic = 0;
+		ret |= 1;
+	}
+
 	if (o->pre_read) {
 		if (o->invalidate_cache)
 			o->invalidate_cache = 0;
diff --git a/ioengines.h b/ioengines.h
index b9834fec..1531cd89 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -96,6 +96,7 @@ enum {
 	__FIO_RO_NEEDS_RW_OPEN,		/* open files in rw mode even if we have a read job; only
 					   affects ioengines using generic_open_file */
 	__FIO_MULTI_RANGE_TRIM,		/* ioengine supports trim with more than one range */
+	__FIO_ATOMICWRITES,		/* ioengine supports atomic writes */
 	__FIO_IOENGINE_F_LAST,		/* not a real bit; used to count number of bits */
 };
 
@@ -120,6 +121,7 @@ enum fio_ioengine_flags {
 	FIO_SKIPPABLE_IOMEM_ALLOC	= 1 << __FIO_SKIPPABLE_IOMEM_ALLOC,
 	FIO_RO_NEEDS_RW_OPEN		= 1 << __FIO_RO_NEEDS_RW_OPEN,
 	FIO_MULTI_RANGE_TRIM		= 1 << __FIO_MULTI_RANGE_TRIM,
+	FIO_ATOMICWRITES		= 1 << __FIO_ATOMICWRITES,
 };
 
 /*
diff --git a/options.c b/options.c
index ab650bb7..3f9e7894 100644
--- a/options.c
+++ b/options.c
@@ -2936,6 +2936,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#ifdef FIO_HAVE_RWF_ATOMIC
 	{
 		.name	= "atomic",
 		.lname	= "Atomic I/O",
@@ -2946,6 +2947,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#endif
 	{
 		.name	= "buffered",
 		.lname	= "Buffered I/O",
diff --git a/os/os-linux.h b/os/os-linux.h
index 5b2d1714..a8c7953d 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -62,6 +62,7 @@
 #define FIO_HAVE_BYTEORDER_FUNCS
 #define FIO_HAVE_PWRITEV2
 #define FIO_HAVE_SHM_ATTACH_REMOVED
+#define FIO_HAVE_RWF_ATOMIC
 
 #ifdef MAP_HUGETLB
 #define FIO_HAVE_MMAP_HUGE
-- 
2.31.1

