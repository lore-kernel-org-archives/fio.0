Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07266197A65
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934698; cv=fail; b=Tl8pdCJWLprKoAEDoJapx5LUwQ6iRfwhg5q+ydoXM2giUqBunwaDW/+cQKRGBeKl37V5QMSygzWoqgKgNhy3JEM7X0Br5Py4EVx5BtNU6cXU15psam3dSP/1jxlmYfh+DQaDZsdltKM8a/vwRxODuRLAB14vYdH9vrJ9OsVXhqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934698; c=relaxed/simple;
	bh=cqKh2urq79m8Y1uP3eMVfxCyOuJG0wG3YklTQYRizNc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BKwBczcOTh6fmli7NsWPkjiqnefExf0fhFnE9Pv/auS+JXzUdZ/5EQfcosANRjUxnNErXgcQnZLrABhTIwTwveLA4gI7eQrGFsDXJcGNSUgD4Sxmxpe8ase2GvIrvf7OdL0MmQ0HpwIxejk6ZXeSyvda9bem6Cvx3UAA8Z8b+Hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ar5f4YI7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z6bJ1R7Y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ar5f4YI7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z6bJ1R7Y"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBNawU011235;
	Thu, 29 Aug 2024 12:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=yK+F07sW/lYNr5MX92wiUH73dbYWXCTAIoziC2W1B20=; b=
	Ar5f4YI7DotZU8adDRtzIZvEBhEiY7oFhS1m2pFerW5QOvfIlIOW0nrBRuW74qBB
	TSz5TjY3zmdnKznY3sk4AWeZFg/GHzMihmjKVneApY9lVIVR1iRuQkJMuy4gjfNq
	TowCUwkNmz972tywGSy4axtju3PyLoRpGoERYoxo1NtCji7p5ZPnibQHpJOEH0gO
	s8qcRHBYoDUFZ6nwixdnniz1t/pGAU0SiXlUT+/Geyr7MH1KtPOrqjCukc1Rd4yq
	xmzdhcgk6kZEoZC4TMrUct5XXXun3q6YKpAuZaekE7KATLQ6xUlU4zvb3BRVhzhs
	ZbmgitbfjNF9Sft1L3e9bA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41ar2pr3yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TAhwxJ031806;
	Thu, 29 Aug 2024 12:31:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418a0wn1y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPRqbV6SVGOk1HWpzDmQzUNqh/LkX/aKxqUqePJFLU+i8MSkbga85yUlOCwDTfiFqHczZ7ETnbm4hV2DDjte8S9xUf0Imdgatj4/ANINzU/oxzakFGQ5fymLXzypc8HlQ0pZ8N7Uq2tMItwaEecF7ChwirwzbBbZsJiQVtyoaOzAPkYGQn3QQDvVt6qxWbAJDxj+bUANW8RXseJLgWYoIFmDhdIWwCexoFz/Laa+dWQWwjUAatZwA7AGBsJEHLt8JMzCAUnGHqpkzi4GsDdsBsq44i+PDZSXuKYZPpEugAT7RVJ+b2eQuZv+cj+7MOC1oiQ8NAba/PeL2nTzYslrzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yK+F07sW/lYNr5MX92wiUH73dbYWXCTAIoziC2W1B20=;
 b=bP95mTyIcU+Z6kZcJgoruBnTDfmZTq515c4obP4638d2aaylVWBjBR1vJ8BRjSJNDWg/9bX9uN9z1dcTaGAhwsm/Bq1vg43nZERkUSQjRUxVddar0CfnHWIO0Yr3pBGqYaCcf1fv0Txx8nhQXRRD3XM3wA7ibG2+YFQ5N2cWz+Qkz7WRk4njwxyn6vbQuHzidiA8GzgwQx2Ce7NrhBB0kxJkbAYZztsLHvgjMCmfOjq0xjxXF/ZFx8QHDFoux/K0r/I5PDtDeEN92jxJeW2cyBhUG82uHzIls6wLWX4D3ujHTsggZYDGaVc/I4Y2EK/2bstasu025FhODY+xbPqCyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yK+F07sW/lYNr5MX92wiUH73dbYWXCTAIoziC2W1B20=;
 b=Z6bJ1R7Y0RGmVAGyI5wOmb4/A6TBzLoseeOZ6RmlYShAGQUdaGjZgtQ1R/oGXnXBub2nAcI0A3LekUT/2ar58B2Bj2r+dokI1p10yDudyvZQAbzMKujdJI101Z05MsD21CYtcAb95adG+53NgYEq/InDGD6ArZkMOQlZh127TDo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 12:31:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 7/7] io_uring: Support RWF_ATOMIC
Date: Thu, 29 Aug 2024 12:31:07 +0000
Message-Id: <20240829123107.520005-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 355e542f-c0b5-4f69-a214-08dcc82682db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AdmdzTqpjcsrUSJa0TWsOV5Mhi8kPbPA1ExbDphhWC7n+gHF5POSh1wtzDNg?=
 =?us-ascii?Q?+L1ZTOQep9rKMdBXMMGid4I5rY0YlOXt1lSULeTtAqraBYHvaOkHTD3s0+BV?=
 =?us-ascii?Q?X29spucIbkGxapcwclTL3FOZxZPazX4wnnFKiLvFF7ih9udCif/m6iYH7ijq?=
 =?us-ascii?Q?iCcVdR8s1T583ErcQm7GNzc3JxRzGwW8piy+SF3p8scGpQMzvexVMb5lnzdm?=
 =?us-ascii?Q?JD4O+pgb6VIUd9J6sAjU/RLv9ADLiZl7C5akL6tn+TzSpJRb5lLh9gYE9mH2?=
 =?us-ascii?Q?jsiaDpFTFwOjzg+/xvufVj3dAVx6TCEx6BDQCJzmzDUw3+HBxXtQbc4QvYVM?=
 =?us-ascii?Q?smzGMC1fjP/O1GVzrHlpEVhayV8tz5kpG3qc9JOrIIlWpgeB6dxp0l5lKNVP?=
 =?us-ascii?Q?2o40GTqL+g7XnydTVycjhw3QmHTKJgECauEuj3wTZo2bCnuH2Ak4ZtuxrZEH?=
 =?us-ascii?Q?YKA83P0Z1uN3m0IPtBdNRIMTXvFkoEuFOMM/9NWkHLzFjvrR6HMpDG4DwUtv?=
 =?us-ascii?Q?8gqwOEeD1Sb6740VikMqDchlWbIFRsrOZAPvFr5j+g7LtaWSw8Zkx775EPeu?=
 =?us-ascii?Q?rMoP8fgAOiNMPRuIBy6trVq1ESAXnqgostiSUbAFg7P/6jXzmv9RPq4KJPos?=
 =?us-ascii?Q?SUQrrlWZZ4vEeCr18pitHDaX5hYv/HD2P4YLl38B+L8e4V8vz3PoQmXAuLku?=
 =?us-ascii?Q?vm8PIyFAPTJS8xB+NiicVozzNPX/EJMbNPWC99jmQQg4P+Fw4CGNEmNpvCuH?=
 =?us-ascii?Q?y4wPNwDpk5qJqUe/VxUPW/1b7r6CYhaLY9ALWrOzozOKb6CesQvvoG/rCaz6?=
 =?us-ascii?Q?zI5SH2Oe87MR9umaVhfuNni6SiiqZ05IZIBa0122bZ0BGTdYEdfKTaDgWEkR?=
 =?us-ascii?Q?KsBuLHePpECUu2VeUseq+IPa+xz2sngZaGWlgnce6sqgqSVKR97K0Sx17BUI?=
 =?us-ascii?Q?4QUlWKo9xGtPGq7PEvKuIBcbNruIftd96iNabj2U61Dukrrj53KcxCNHa3em?=
 =?us-ascii?Q?lytae+OJ+fjggGNEIVupUmatIyiHBIxwnpGYjJSpBdsmrpeKBazrSniln4yF?=
 =?us-ascii?Q?QjHPU3CCxTia3vXBgxxgDNL7g5KDlVsqVCChg9hwxWlSYWi/RcR9eVe77FqJ?=
 =?us-ascii?Q?3cOO502NGNsX29yujwdO8yZ8GTKQF4Tlkvmo7FntIdcqzrHEbiHSVykOw3se?=
 =?us-ascii?Q?pKfhBTGwyeNlZ81TWEahA+3ZTIdXUNSsvr/PuoD37NCJTpiY7sbgz3d9GEh4?=
 =?us-ascii?Q?Fgb1hZgQF3ozt8+FPhERB9ycap/KS+VcXmRQxKJaG4pJdI5paZprhLyJkuCj?=
 =?us-ascii?Q?5n3WVIz/Bwwwvhdy5GJg2NI+Tl5ju5E2nBkpnDaHBcT9Fw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dyzyUCb3q5nsLU1T+l4rjD1+BSOwhxupomNhiJECMdeKpEI6ey5LbLI2RjBw?=
 =?us-ascii?Q?ULZLgxnTScpJaXnJyMhcQNiWGdgcpMgWI8V6eh6OZC2UOK1f5q4jRLQKmRIy?=
 =?us-ascii?Q?pE1dZgujUrjeFPZ6yGzJtWHq3GLDgJjtlSQUHAbvz6MDgiiAUfe7vnzZOs4U?=
 =?us-ascii?Q?otNTDFR0xhgidPhSHQLPVNzjQJY0U1oovEzkshTawuDVm+RgEHY3hkQtOYZk?=
 =?us-ascii?Q?KjfQDTViO9SsSfOcres2Iyq7qCMVLUQrFrygDU8t+rlgCece1VVk82iZkeXO?=
 =?us-ascii?Q?n4wVLa69aPVj2gJ5yxTEIGbS54CKCD0pap58kTAOSJ8AcaJYh/VXX8wqA3UF?=
 =?us-ascii?Q?alDNPyObRM7posIzdewWHHIFhHJJIMv/Fzsbn/2HIp+5h2qnQCnHQI/XZwM6?=
 =?us-ascii?Q?1/1O9MLuX3uWxRx6CnKcXqnm7jg0AJMjgj7TqZOz3W+SO1PCTxkGN1loIqBI?=
 =?us-ascii?Q?4UZ3puAnqI5+3/gVNtXYs/RG2yCNAKAG+S63ergbXYErs9bTsSRiY+ghtTSs?=
 =?us-ascii?Q?1tonOPCR7wniUdmq4Miogv2b3ooWRobe98g1cZtjycF/TaVUiuGW1EXa13b+?=
 =?us-ascii?Q?s5zJ+a2qg2DVrzVqAdFL8wfYdVY6EBWU/pR26lDxPW4R1XeSHfSQ5Uf5zdfB?=
 =?us-ascii?Q?zl8I4ehLA6d3rDlKdOku7TYLttiyYgcniOi/MRMw7O0wJoqeS1zH7pZRm0/S?=
 =?us-ascii?Q?XZHa4bvCYQLZLG+t1ImGqmYxgq0cDRDo0uZo9uL+cua5UExA2/LTqCVT/1Go?=
 =?us-ascii?Q?3zRm0CfcwMP2YPyW9frhl0WomUePW7Qx8JY5at/N/kPfHO921fMFa3G3UwOe?=
 =?us-ascii?Q?ZCVTHmxc+ZesgDveFilhu7XUSN6T9nfwjoYLRG4WqEr/3rIPOJCSfuSs6IoL?=
 =?us-ascii?Q?xk/V4B1G4Au9xA3oK97HVvyq6ykkGLnFmc6cO+h1GQ+ABgSa6qA/TBgk3/i9?=
 =?us-ascii?Q?g8XoKerYx+/HVrD8ZW4kkdShXjB4EA5jCqwAdEF/yre7z62KrZeyxyqDMRuW?=
 =?us-ascii?Q?K/SsyLq3XJbPnrNDVc+HTNQRwfe6du3eRuaGWLLkotsWQcLuG6HffHpmM1XD?=
 =?us-ascii?Q?2EMhGnWbf9H3taOkDwnOAvtFj4KbVT1Xc7+JG/MUV/FTI6NE3X6dMCOcEnwn?=
 =?us-ascii?Q?j0EZEomtM7D9XkTS9nvvycmmhc5Q60XxLnnCYws0VDnKPjbRphYCtQAMZ903?=
 =?us-ascii?Q?/3x6LkCFX/iA3qU0gAhRABxkJEyKkf4zqkp2mF5zLbgz+l5sqXBv6Dv5u7kC?=
 =?us-ascii?Q?exoClecJH2H1ipqvFHtxBZZUlbvGFBh44Wkf+GHQu+hpWTuFnNF7i2uqwO+S?=
 =?us-ascii?Q?Ph0+pv9h25WIaOsncazy7iz8DU9VFGpETIW8jr4++fMfuH4Z02qt87z1M1vq?=
 =?us-ascii?Q?NLxpYFUieJ16pTaKANP5yNmx/yhq885zQ/iGwquUQlF9HWQ0P8PX/SEdshtH?=
 =?us-ascii?Q?x/Dma13l5KzZurhL5f/WfsnD4F1lr3XhBw+52BHNNhAgs/YdZieQ+Dkp31o4?=
 =?us-ascii?Q?8hfoxLHbXg0Yw7/Q1qU4n02TDKcvS4u0FC1mr97C2tpCDI9PuU5FtzGNBTIk?=
 =?us-ascii?Q?TXvnR/sx73Yd4O/PRJwUCh3tKxeSvesnKO54EknrYOCW4Qddg3qdeoxwytvl?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MUkovN9B/LiWcWRir8laFy7wL4U/1FriwJR9hiabkZuBNgSwClJASlxNFOTZJN+DqMcqQNrz5ClF6l7hZn570INcK/ebWoy+mxhQUWre0AP+y67McQiilZhr8EvBrrDogE2qnmkJs1eOJ62CtaKSTxKefAbAUfboze22tCKQ/F0WDV+qrB9Up6hSMdkQzVKwIFZDn5O28731GLqbgAXRsYBKksXmffxqmMUfqB3QHZwqCk+zoYrX8+Qz6pWPi1B9lCHRn7Hk1aZjuZfkHuFnOaOqXnYk/yPiFclPmz+2A5zsi31gAzQLwAR+UL8aMMguqw1STuYBQecZpaPUokeSzvwx+BuH3Az+1KZyNxEeHfm3OP4UnckS1a7v6BEkbU7+If6ha0jK/D8WVsG5KoPDX6ONsaA3uuDRPzY7XYrvSdmakdbz+bWCVQW6GmCM2+bu3xAw8Aiw96lOg/fDS2+Ybn0iZMiywiGDGORjd/r+xGL0RTbzEvsRGEhQshbHX+Nn6n/KDu/jxA0NYU8NTPQihPQe0KKG9M9qwCYjy5Ao9Atu4ff5fhms1SAl6caqfo5xtmNywj5HV8a7dKRT5nOhgJBBO1Q4aTy5Yf24aC9TQYw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355e542f-c0b5-4f69-a214-08dcc82682db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:31.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0C+DWRJnTE1eWwstjbG6GNnJexpyFOPrYhliGyo5m7KqWC2zuM9k0O326kgPyrZeha3bml+jTDg9kaIXW1Qcfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-GUID: Uq2_XkqmfemoFu7VKfQ4xgADVcqCsdo4
X-Proofpoint-ORIG-GUID: Uq2_XkqmfemoFu7VKfQ4xgADVcqCsdo4

Set RWF_ATOMIC for writes and oatomic==1.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 engines/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index bfbdc3b4..79217631 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -399,6 +399,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->rw_flags |= RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
+		if (td->o.oatomic && io_u->ddir == DDIR_WRITE)
+			sqe->rw_flags |= RWF_ATOMIC;
 
 		/*
 		 * Since io_uring can have a submission context (sqthread_poll)
@@ -1591,7 +1593,8 @@ static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_ATOMICWRITES,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
-- 
2.31.1

