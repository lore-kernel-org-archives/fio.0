Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E39158D7B
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505677; cv=fail; b=OEBMJ67Qnvmv1tRQpotBUDs7FdH19jjih0Pmc8k76x99zgjWGNSRophinL5gKF56UcYeidMdmf/UuuoyHkCeWwJT8N+ThjldvdrcBwlXmBU8/YFprpgAR+ipA0irbZIZXw8JE0wCqfjVW2Yyg+ExcvGFBHdTe2JY0kTXH3QevU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505677; c=relaxed/simple;
	bh=O093XN2J+JhygRi2WNGsXkalMfNadDXnvusaxjDxN8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BP9IG4oUPaUgP6Ipprk3nKxQKtbiR2k5FD10+q6j/JyECJaPqlclZzj7YRTROQV2Pte+X6OEXlLmBLe5MTsgCAFpACWKsbGJhWAwDyU9orD19wyr4vHPmvL8Glh+4MVvWzuSMrtLhFH4Db1uZY362kYn0lQ8BMoFo5CuYCSFvic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ampZM52u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JgJZRMVu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ampZM52u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JgJZRMVu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMXNw001470;
	Mon, 16 Sep 2024 16:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=fXB1D59P+9+skRwhaftU55/gETOwM7+xFNbUoVKVCW0=; b=
	ampZM52uZ+4gvLIL9NqQXnpVn4+isTwUe0DHrHFmevr1lCSFUY6AEkuLqrB4pzHb
	lyW9ivHOj8DZcuqKh9/LmozLQvzzwr6L85SRVF+3GcRwer/BrjI9LuMZc+1Xxnij
	544ENZFZW9K1jo2WbBZ+jI9I1sfiQoItT/ZIyjIukOnRA15QGuizPlGYApiPwN/8
	24TFPs4d5O/ReUSQ2SEAfm/u//Cni4X2Vapy/Vqw2asKi8mTzsVjUeMuZowlmMgP
	FwanuxXCxyH5/SS0ktOdUW2m7e3ctnynerPGnubjrClErWpddLzt7xS2hrfc7Lp0
	87zmuICFhYolUxY2sXky0A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3scuwtg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GFRfT6034146;
	Mon, 16 Sep 2024 16:54:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nycfpcgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xsJfvOML6yQqI4QAU0774x6oEr4ookYYOVTXyoqjbTAibaok7nw9ii1BId5gzZeH5zoqxvVrmp5a5os2fOn8P4MZCI/bZ7TCs/GSuEBr4gMo44vUlb+xQyOd9ie2ce0n70DGFZOKn//KoGRr5Jb8VERwC28Moau4k2j/YTo3Co7Zm6dPQ8orePd/LIq13viGD13RJbYvoIGb9W6iYE8nIyMj1s4+oBTPnrAV7OfEl4GU06OL2AZp2D3VRpcLckucLhwj/Lf1oMY5qxcj9jwS7CF6fJRT7NI7f+S+yUQgdI1xNyhB59kHoqG/NdD7dmQZ0tyxXVsGh2Raju9axeJ5NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXB1D59P+9+skRwhaftU55/gETOwM7+xFNbUoVKVCW0=;
 b=G5mRd5dbizmkCAv3KJ7LF90lZvfL2ERJ0HybmyZ6OojJynVbB+JRr7v8Z6WhMHQZMZw/dcHoGajdE+INSXUK8ger0qnO5rAs5T9/ZesVRh6a+uFRXYIHzt4bn+eT6SVzoItpMF1gaF9MsyrfHPo6K8dnW0rez2JACXrjRYsN0Kmlxg1w/RNqT7R5odIekfByuuJR9apSHpAuGSPf1Bht6ougAHqmfp09X4hpBKOQGlD3hCfVu7vUW+ncE+27v/kLdBrHVNv0OaekeHg+u29WqSbECAxZBFYxjY7Q6yRCMuz5K9kuMTu98UxthlLeq5aQJWYEXC/6gLgJcrRCXardtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXB1D59P+9+skRwhaftU55/gETOwM7+xFNbUoVKVCW0=;
 b=JgJZRMVuNd7tjLP4vmESynr+9P84j6BWa6msLYB86Stfrfpujtc5ZJ0jkV9gHUjDNq+0bzx+hcVTFbJ46/MSmqtPuucjI0s2+2pHmylCMr4dIAFYR7nWlpAXZagW+LGPSDB9ZyAoRgnf1bkXseuO8EtMo3tcIGs+2xpAF1+7TGg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 4/9] libaio: Support RWF_ATOMIC
Date: Mon, 16 Sep 2024 16:53:42 +0000
Message-Id: <20240916165347.2226763-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::41) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 50fcec1f-f6fb-4ab7-c012-08dcd67035aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pKVqn31GFsWB9KX9Ku4p0rEV/7DOWPsk6BnqFIdhis4vWhU0gbHG4S0RnHB7?=
 =?us-ascii?Q?AWO9zcQKo1FNhgAoO0JhaDYTrMNOSo9pF9VgkSFfpvf+XUB1pr4LG1tleRgp?=
 =?us-ascii?Q?YPIwBvJKjmNUVcG3RVS3Z8LIQ+fgiG8PEBM08MqC1DtHngz6DdeIx6KavVYb?=
 =?us-ascii?Q?tKPTRrILgTFnan2wptXy+sJ5U0CC0F7ibSZJIedyLcH59FRFZ2QcUq77vkJj?=
 =?us-ascii?Q?ybxjkC311fOQSlsFSbMQCigoJoDkkV7aG0g8GGmAK+Oj3Bd8kWp+WCTcyoWf?=
 =?us-ascii?Q?WYdx2SsLtqev2ZlVoq4VqlEmsM1MUvnsv08OV6ZDob/Uk1LfCvXoUG4feKlh?=
 =?us-ascii?Q?4wt9P/a6t/pRaX0k1iBu5bGE/Mlu73h+L9Q/zDFRhgdySjPa0Z1lBgeMY0Mo?=
 =?us-ascii?Q?atv0w7ucdqLJKssKPA9C14VfLY9F2G62JUbODaQt+e/JqSijZ/rl4cAWfmwY?=
 =?us-ascii?Q?cnNRRJoq98su9HFQQOMc9qQMtWkqTG1NsXojNsPDJJj+3TZ8wY/uK3NyrJiL?=
 =?us-ascii?Q?JZemgOne5M3bq0kxxhj8OfxeQSdV8pe5/oImEqxtcU6kDDmHADYHwgROC36F?=
 =?us-ascii?Q?VxxSRjtiHsa7DS/2s3BlHUMVkd9QSLBDkA05KBGY0KrvegKTkfmo9Yw82kZY?=
 =?us-ascii?Q?dx1Sjc9dBKnLs4DEGWJ3A5nPq1YkJtWBLUgrNKALCOfqCp6c/QySN0Qo6N8e?=
 =?us-ascii?Q?/xo9xLWk4YFKAJlVCaEMf0dlXsyf6MevwzrWYP/oaU7j2bsIaVFwfd87u9yr?=
 =?us-ascii?Q?USpwGQ8VzK4AXbzs/rBAXmjyY7dr13mLLYLPml5DHLy0x4sDQMzgQ+X+wFsu?=
 =?us-ascii?Q?OtNMN5tSxDYY06q+AVC6L8xbhBSPuuSAZkiINx+K0dQN6kKS0ATFzo6MCqCJ?=
 =?us-ascii?Q?ygL2hMQjqfp/r5oimrN/9/ieSVHBsKlRVYe9qq9eyMQuttKuoZW5OExF3J3E?=
 =?us-ascii?Q?++GIeqISX8DjX7zgJQlxazK7wEkJLQEpXisZqys0j3iftkjHWK24+RyCl8KG?=
 =?us-ascii?Q?3Sy2DEfVeeW9grEyOR4FPavPa9JFQBsv3uOqa1iseDgqaUrJApjmVUxFZ2AG?=
 =?us-ascii?Q?ou9PYCej3qCRXWrozyvmzVhoEtDI/BBxMporSzVYCq4A4kji3A36I5BgAkJd?=
 =?us-ascii?Q?4P6PyKYdZHc35XKQppdkFZclBL1jyoY28IxLMrp9nBG4xgEdUw3tB0tD5s8p?=
 =?us-ascii?Q?kcAIOTuFm1gxu7drInoERFFzhO3qHsRx6RQPrpZdfQoVn8d8VfqRqBLASGTM?=
 =?us-ascii?Q?5Yi5+0ECx4NK+jm2g7FWXB4zi3Rhonp+InYVjyHGxJx6XMSDP1DO/Q7TAOkX?=
 =?us-ascii?Q?NMxGzSM/lzxHzVmQkHJj2aUyfCpfk9/8RdxW1pLpj/mw6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bRAXX/p3C4jjvfx9V6uUjQFe84L3CU+RInV5oXa79V0ypbbJlr4WweN7Lq/R?=
 =?us-ascii?Q?T0r77/RDRwvXA+qOk2p0AcDb+Lwzz2oa+tULri9LE86o2VgKKPIUPmOrZdsz?=
 =?us-ascii?Q?AfsP8Po1wpT34/v9SKsopU2GMWvyAlYXaq4zJrRf/X8trLKa+GGRMFtYrw6+?=
 =?us-ascii?Q?RIyo4y90f+BUf3uJ+MPZwXuyZ0IUaESyxhCynxK4Arj6J56aw35qH2hYQWld?=
 =?us-ascii?Q?4vWO74qWKvupeW9lUgwmmNmSOoASYNTcHt6XW+X9+FC4EOCnKArFisiiIfrw?=
 =?us-ascii?Q?775PDMgK6WMaj1crRjHuQPrnGBLPwbleKKGiWe1bdTJUtAX422JiKqJyM1IZ?=
 =?us-ascii?Q?izjWoO21CzgJMaFUC8jfxog9wsZzaP/XLHbb+6wtjtrnfRvmtjYuQ5z3AMHx?=
 =?us-ascii?Q?tSEn08rW3l8zNTy18z9LQgyOkcJ8q5J+OJtJbixzEI+jxtlZYGalAPrA7h64?=
 =?us-ascii?Q?f1qOuI9qXG3uvna9TTR5hGcovQyUhS0aM1OW7PhLRn3k7GAJViYotxpwROib?=
 =?us-ascii?Q?6OT64g7ZSjePUiBzuWWlsaMEETcOzsPdNdseUUKcQlzk6KxEYTE+fqZiFu+O?=
 =?us-ascii?Q?Johk0FHdQnopk/I4kRyKiIYyyVhAnu+Wa5zgWywKXz6s1F/MV4l/SInfMXcA?=
 =?us-ascii?Q?uOMuFO2rSRn8eoKml15kgXTBBzw9Z5HD6RbNPK9/RR3/0vjD9qk799/KRxJV?=
 =?us-ascii?Q?DA1sxq8m8YKphm3EUrdJlL+a9oMrdcQ132YkFGa0ZrvMPM+iFvMJ8VcTU7Kg?=
 =?us-ascii?Q?0sul4iWHRG1m73M5IJ5gcV9rGPGyvkO/gfRhysN0AK1F4pIZXUSYiuzxtRv8?=
 =?us-ascii?Q?6PCPxGEtRcQKD+grQDZFxxxGE+9Wi5slkT3cscY0YGcwgYv4gnKuIzg+w9ya?=
 =?us-ascii?Q?o/Gem2k87A9fcWx+b5uWa6hmZqBilJXmDSiIpciRNQ+TDi/h24bpah0Dh28L?=
 =?us-ascii?Q?ilgvy1mTveax1/B6GRM3s4GKpF5bfsIf5EnPv7J5dS6hJn7iZXetOfgACnLU?=
 =?us-ascii?Q?NZqciUCP3UCxXMrzpJhgvRKTOS7rFfRqz0J1HmgMBv+UA9s3X3PrVeAMIaMh?=
 =?us-ascii?Q?0/psrYLQthjFGXURTYf/gFY0uJGQXOdoAvwEEUHSMg9kZkVAcax5FxDR117s?=
 =?us-ascii?Q?OI1J78S9P5/Vh5uNm5jyuRFQr8I9rdpaTPcYhfHFkZUfrZLrn8HKFYHy2B4A?=
 =?us-ascii?Q?6fVyu8JIwXZp2YtnXkHCHqHCF+xg3FNVY/ask18B3RBfCDcoCid1QOrFYgrU?=
 =?us-ascii?Q?uqnMtTMmYoZT4HZmy6Z0baZsegnW84YYv3NpMTCurj3/nhXcsFumGfo3DRYk?=
 =?us-ascii?Q?dJKJu6h+g3DODNtodQOtu61XjRcqMfGuVm6RZi3xKLaEN1+PcJSjiXgH3d6f?=
 =?us-ascii?Q?+Mab8AvMg4RO4DiFvzV+cLebU6ABEBFw314QDpsHj1kbF8oWFNAsI8T4rn8t?=
 =?us-ascii?Q?AuEa8omOoov76pivO/CPwao4GTuTAEbsIsqxaqdg10oDPFvBunYgTDRDX+MC?=
 =?us-ascii?Q?0bZWZ9s7AcRbs9x7X+FVzRYQnkOaRRXC1CRdAMkjw8ZNTF1cvpJoOmnS/VCW?=
 =?us-ascii?Q?oljGI2sUA9PqeM5lTNR7iLo1V+XrMgHNVSEn/zkvKSLUDMwN++CEE3bVkhxi?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pz8q/LuWpMX47GkBIBl9LeVZJWfLeavzcxvTkN+YBWBEFqSXCi5L+Xj2XqAF7CGLSFHOCH3KvBkz5YFYDJB78LQ1x3WsCHyrsZBWRYrGNeZTutr+aOcxsyefjC1XFOGcFt8QNCODkvl2O/salTjWDkDWcQaqygeaXoNzztTJ1S+j1H+K5rpriznLP7Gb6THvhGh7WNb0vswZaxp2T17DL5f8GA6mxTg1LKeGtxSweLmOctbzg6dt04gd9OhHjSBYl38gnpsxvAtTaQLLv2GFjvRTgOTkFGd5XzJHUdD860sdkC82LlxE8YPnC+O5Jmo/yRisO/+2w1yVsTQRQBR23zWhnwGCoH02Dj/beYHUz2qa41extDw3tOusNEzQDaB1jEMa/QYfsjjZMh3vRr0ECvvmtKAUZlh9xoiiy273avnrBETY9c7MKV+oG4BopC5c9SRZcB/bDs/0oCJ63BuIpq2Ll2rTdqnnY97xzfdERj9qvoBWORyXBptIBVHOe2shmPpQFNn1xxuP6ianjjtZIxjMa7PxkQ9oA4zvtBkMRbdmQXe9b8DdZaoilcZIWRaSiXdfionf/gHN/PaYHwjv6VNOsdOtwK1GcQolJkuG/B4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fcec1f-f6fb-4ab7-c012-08dcd67035aa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:25.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w19fXYPMftvhXppTgz2cD/A1YfdI2yjT0e0LWI357HxhXekBtixVg8vwX5V8IAfEI7VZmK8qc79lr7qmas3rYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-ORIG-GUID: CvB3zMqAJuqx0wjZ2JZWssgXeiLYBwZ1
X-Proofpoint-GUID: CvB3zMqAJuqx0wjZ2JZWssgXeiLYBwZ1

Set RWF_ATOMIC for writes and oatomic==1.

Guard setting RWF_ATOMIC by FIO_HAVE_RWF_ATOMIC, as only linux supports
RWF_ATOMIC.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 engines/libaio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/engines/libaio.c b/engines/libaio.c
index aaccc7ce..c2d43793 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -110,6 +110,10 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
+#ifdef FIO_HAVE_RWF_ATOMIC
+		if (td->o.oatomic)
+			iocb->aio_rw_flags |= RWF_ATOMIC;
+#endif
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -440,7 +444,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_ATOMICWRITES,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
 	.prep			= fio_libaio_prep,
-- 
2.31.1

