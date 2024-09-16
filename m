Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B310A18
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505663; cv=fail; b=Tso27cBvUzM+DUKyXBSZImFNsYGEXh+H2D21SksFM62C/jyezl9oeU+aU84mawgAFsXz/3y60BiykzTChN5DeJJpE9QKcmJSU3SLk57xPKs+vwjYcYiO3/Do+oAPKewehxn2lSaTYKKGPRFW9q3xarmD5mxBs860E94hkVumITI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505663; c=relaxed/simple;
	bh=QWifC+WYY42MgTX4oy2ZqET4rRapJa7MiCSvPKXt7Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=EIrw7OlgfaQ9HjxDhEruR3P3Dqk+pkOGMn80gr3A3iDQ+x9ANJ+Sz+ay/LhK42M4PZBtnZLv99VlNQ3Zh+duT+LmphG7jBzqjnTyTUgegfOGfYzXYydEN3xUpfengTB4e+Tdd2JztrQcm2eS85TGAteZ4TDdtcg1XXBEIDnGXIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BgOh7ckb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KvRWWZ7q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BgOh7ckb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KvRWWZ7q"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMVj3009562;
	Mon, 16 Sep 2024 16:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=ggZ0Xo3Fyp7EsP
	4gAWhNoZqRTdzZWUv9KZ0+9RL+cSo=; b=BgOh7ckbNE7rAYL/TGsAt61tby1dPt
	+D+E1mYSOsgWzb5TcDoGGyhfuLnkW7dWt1GyxKQxHrIxfDNOAMAvJVk+2sjj98lo
	XHix+Mczg7HZVrspC/lerbD1aIHz9wfrO/6QDBeFIja8o7FELMPuT8w7hPEJyRG7
	lPworTjcE0Cdzd59fck2rPMvxZGaCjCwv4WGzFN3qvP10+lntkWuB2+6YewT5m9T
	wJTK9doQql4+Q0FS9FExClK856JPEGVhNGYrY/8acxTK8DsetYbbyeh2SWeIiRBU
	hnf6nBo7XcHEc/rDB4JO09RUVrs615yJO0k8MH34ZTnoP8F2D0LsHHpA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3nfkxe9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGOm7n017868;
	Mon, 16 Sep 2024 16:54:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nycvkvjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nFcMaiiiti/ikQnoddFN6uQdJ9jOf73gkAsbzWM5/H0eDZxJP15JzPCjEaabnq4Ib1AGt+l6ufGhx++RAPwG6HKDvxshFu8nKOr14s3bhRMtO4Bb3t8hvQstbUTyYn5BdpaHqEPMgmXf5V9m0mTbDbUy9T7LWhc5WVoTr5HfrK8rckJotqrtQFoXyg9HvAJSI3K29WG8kMR/Rih21PntBa7YjMEtGNCC6jlWSrGFccK8zqn7EQDFwL4ud3YMSFK7aeT3Xn9QcJhD5Vx2vdt4F4RFnkkwUNVwdJvFV6u0ndFBRsDk71r6IGmVdG2WNqrfHKPNI0Eho4/MMcslsHi2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggZ0Xo3Fyp7EsP4gAWhNoZqRTdzZWUv9KZ0+9RL+cSo=;
 b=RQObrzMX4LwWjBa8CuObFuIBIX6GKd6KjpOUfz8EU7+P1Hp1Vj4JK9x4/RBPldJ9CmsM185pSGwiW4YdcYl9RYVlR+bQ6+VmNJVN+M9FCEXV2GSEHS+oZ3RrRUSpp6kQVMehe+ohLNjsTFC8kVPOwIA6YCPcVvhg4uHiF2JWQ6T8NZ6MuzEgOTU70lZpY3ZMbZX9y5DVygKLFEL+NbY4B+Z86EiDNkw4mAr5WSWjniRypn2VNUxMsWapNL2oxxhwOSo4eszcRj9qXQi5AJPO11H9uHdgsRib9oInPQ941E1TbuodlmghrFBi2f5wca767oy5hwiW+FRvlzfoJ/awzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggZ0Xo3Fyp7EsP4gAWhNoZqRTdzZWUv9KZ0+9RL+cSo=;
 b=KvRWWZ7qqVrWG7PeR/HiQ8iG6B8FFXXE4UvWNC7KcwxO7/S6MXo0bGRqyR8576wXkfT/KOWBlF9XFYJZyyc68he/2oV400qaiTXee8B8bPFgWZoz+pkg8NwGx/hTvEZGYqiz3brbafTxY5IeS/g1tXhIq/riSGw7DS52QJzKcRs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6320.namprd10.prod.outlook.com (2603:10b6:806:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.15; Mon, 16 Sep
 2024 16:54:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:11 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/9] fio: atomic write support
Date: Mon, 16 Sep 2024 16:53:38 +0000
Message-Id: <20240916165347.2226763-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:408:e6::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: ca2dce31-17cb-4532-27ed-08dcd6702f76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?92q0QxMUZ+P3ZC4wzXUz9kZjPhBLj4ZYSNEiRAzsbVlVpsQdaNvmI7gqN+Yu?=
 =?us-ascii?Q?i6juVxZkZYx/PA29Uf5EA74+/qVMJzIBMlS+325GRmEpqu+ncp5OlnflFzGv?=
 =?us-ascii?Q?m9VBXF+/IAhQ02yChtTkHSfWXkT004VrnQZuycAoJafa5DSqbvkY/QDCJuEH?=
 =?us-ascii?Q?dRrWh2FZUFa105g8faM4JAgDwwUAiX/KoDu2OKVgu9iBZwJVoL3yhOKAO50E?=
 =?us-ascii?Q?20UrMj0EKzmspVYdX95oPppIHJUxNw5nsG02Z9MrCeBceQtqTCjjE5eUvkly?=
 =?us-ascii?Q?nokCx2ysLoxqk6oHAjOp9ljAnfEihRx9qvfvcjQoBVlKhqEkY20FoTcWqwhH?=
 =?us-ascii?Q?R9UtHnVmAQotwPfkC2HI0pXxhL8FTM6dJv4UoGPVxID3djqoHzoaoA20aTbF?=
 =?us-ascii?Q?DT3KF8B4AtBmwiQta0vUycIuR5MQiirhbf1WTghwaqkudBIM9+PWBElY6etR?=
 =?us-ascii?Q?s2u9IlgJckti1T5pw86FLSQR6aLlJOxUyODdslSQBLePNHfHFTXih5TE/1QX?=
 =?us-ascii?Q?vYmnYRC5GE6cVKrVYVUHbLsWHXxG5FAydtSVfeD1lvm2XK4JQ/o2LvPNCjEV?=
 =?us-ascii?Q?Xn9URpieLgDfbj3ZqdJAOPXe5cHbEnnv4x/6bbllaaU4LJiUAdm2xu7UNBDN?=
 =?us-ascii?Q?as961yioyNlBqLLs+jqOhEEnkN9/gPJa1JOnOSfWWNRyYMmKnkO5lVjZm9t9?=
 =?us-ascii?Q?znsV+V2RjJRjGHoGORG2dta19dWO8o4oB2EQwomnI1U95KMqgzy8QiLaWgZP?=
 =?us-ascii?Q?Byt1v4HK5sSrZP/cVSas1s69p+cdQ5dnZmEtmHiF8S6gMTqTbyrn0Y/DVOZu?=
 =?us-ascii?Q?otluiqQBbO8tgdWB+yYpjS5098/WZ3ulksRuk4ehhxkbSfbqLTx6WorMQk4T?=
 =?us-ascii?Q?TNpiNa1dgQzvc7kAarl17bUqTKquJxahVnz4d1MzZX6hMg3hgotJMu/fqjPc?=
 =?us-ascii?Q?IVcNgYV/XcVS05wNrH+vSxk/URq/P0OZLkHn3ukAmZEifo2Q+ZIEEbUordDF?=
 =?us-ascii?Q?y79rmTsLqpwwRUI9w2lE0m/irPGPtYvoWNe+Bk8qh0obR3k1mzVvxxt1A5Rs?=
 =?us-ascii?Q?P26LlMVNreehhIiAxpbU+NW6zoHaL3beHxcoIdounb63Jm9TtOe28V1hGhGX?=
 =?us-ascii?Q?AwqZlqMUGYZ8hq2u+G1sb8v2E0F7COtp6yBIa92O8zI4yXSAmVysur4CzV3t?=
 =?us-ascii?Q?dHGLhhRRcMesUmKgg1Zb9Cg1QzkgbXyi6L2A/UlcuV4rVI2lLHgd9Af51m89?=
 =?us-ascii?Q?ypoIX5DlZ+4WE67p5fjizOwOy76rsIHByTD6bpWRmsE9PYvw4Bp6MGdIFpAm?=
 =?us-ascii?Q?1y/4ycGoeyeh15yR2lHfscS4r4mlqJF0h3Huh7o8LZkS762NoXiKFO9Hujsx?=
 =?us-ascii?Q?wESGGwc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ccaIbaGh1ndQfowyaj509ZpnOhZp5jofEFA5awNvAVg6m2xnEjwnT8XzluwE?=
 =?us-ascii?Q?1qa1QcMx/ivGuvyvNV/HAZFJvGDyEz1zUmT4CWE8pxEDe/zDH8TOKL6sry2Y?=
 =?us-ascii?Q?uY1+2U8dnXasLBI33C0oKtwjosJS5xc5101m/if0dvBgXhIW6oEZr/izg5tX?=
 =?us-ascii?Q?ogjhuadKJXjT3WP7tZMQFaCISq4aI/vlk0SMHpG4o7tTRihOfg7gPFBXc3LI?=
 =?us-ascii?Q?3OVfK4c5FyAC5skSCKxwZC84XHS39UVQy3crLllwZ1Jitw2c77Poqbh/jFFx?=
 =?us-ascii?Q?2r8DNBZf7FqFvpjpZQ/MHvLPsDCPfrb8bU/lfeA2bK4ECgD97mo3iI37LQJr?=
 =?us-ascii?Q?P/PF6MWue0G/Z/5tu1zC6MykYWNA1AcgcbK1RXssqiPG8Fha/r8wbvmmmxGX?=
 =?us-ascii?Q?/amR7Pr78rkLzFcoQ5q6zd3nunjZAJmgUc5j/2ecMtTipoLv2TMnQAXHBIuJ?=
 =?us-ascii?Q?NQcIYFDxQNXgv/VegIJdOEvPO6RwMAp5xiBvIRv/DJFx2F0tpu7G651/MqWA?=
 =?us-ascii?Q?SmTZcQrz0t2uc5ncFTP2cSpX2S6zORu2yWQa/91lUPSJ1XxjHZWbaWEzAhbi?=
 =?us-ascii?Q?oclf5zHLEaudn2wSns3FBojlQ7yXhs19SKJoMgi+hIzu5E3OdCOgjut/oU/C?=
 =?us-ascii?Q?xOMJ4HJkQqkrdjnl7s/c/NaalHdnRwNM0Tf8RSI/zupnC7bMEXlN8opF97ZV?=
 =?us-ascii?Q?eTj9Fu3E2gbkgrRNSbNYGICq1z4EBb2Q/beciyKYOEr2aq9m3T6NmPUbSwbn?=
 =?us-ascii?Q?F+W60bL1ljJ735nBZYML8jrW3f0cLT0vA32BK/GgngEAsvf34I0m0YmEdA67?=
 =?us-ascii?Q?+vYe+37NTWREvXjfb2AubVl/kyyM5kGKH7KNGkbvRxjwLPt47YtVHDwic4ty?=
 =?us-ascii?Q?CzZAXPgp6tkApyD5fjssC5SfU2K1luz9DbM+ZOr/oHGKG5CA8ljdVc2685yt?=
 =?us-ascii?Q?5HJU5YrHeSaw+cAxp65Uh0mtm6r/wTpJlmz5t9PeznHhgU8r9yU02HwX8Ows?=
 =?us-ascii?Q?t+ia6b/cy9ZqGByc0NENv7b+VkhbYttaX5T//D6hN9xXrry0APFpk9dVhWQ3?=
 =?us-ascii?Q?o/JLsaLqaERT6+U/L7ajs+nZIKcxrhqDUiBw7Q6SnXHJM7waWmKlHU1BOeQC?=
 =?us-ascii?Q?fNoG1s2kEtI+V07G8OZ4PmehqMYsSLrTl7aLv+ydBbjIcOh5dIBpt73TtgZF?=
 =?us-ascii?Q?3dPOsm4v90SvKxmIBXp+jjqrnGZi/R6Nk9MLpjHtmyhgLRXS+ZU8AosJyLpU?=
 =?us-ascii?Q?53lWoDi6dcxZb6rTHX6S6GB4QoBxzwUZKNG5Kdaehn3jO6n2e+oO5j/qdbkE?=
 =?us-ascii?Q?dXqr+wfVIg8uK3r7K9YrgpK6phWfodsXms3uVDV4AXCao2Xew17gp+Kzje1G?=
 =?us-ascii?Q?v569Gl/1yYpgbg3f5teTmM8pDcBA0FJIwqJ/HdCFOAv37j3SV4coVil/5OlB?=
 =?us-ascii?Q?DrVjG9bbjCchWo/gP602l4Z9JXk36xoiaThDADGSH+Eokvw3uSCidTtCr6mw?=
 =?us-ascii?Q?qldKYP/1JuM87vbRdkRTTmG5whrOntfIa5fnKDZlQG/EvAVCm4nO6ck8WYTf?=
 =?us-ascii?Q?YGrRcwhsa37yKyLO/llo9ap2+RDGUlSSumnDx+JyQARKLhJShPs4rkQpvZG2?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mWTEJpIkeVt2XyNVYzhVC9/5or0uh+Q+Lobw/uvl0WawuSE0wXQFRSMBOYntivb7uvJ1ctDmnLOTMFcoISrFyboAt9qhB++3pv6UA7lotcvxsdhv36nItk9pxYG+D5DIahJd4vEpnsSKHlnWm50sZHvU6g8zXY5RBtR+vV9SoE8mXk/twQvl4aODZWcpZd+FhhiQVv5GnUD3EHJVF0HdOcw+JaE1Tbue0G5iTRLVRDc3UejXHdA8Ihd1aVnkAUCoUHCAl65QrYJhD1OXaxAd0GRmqK/yXQ3z3SBQnHtbmrMh6gAHw54VAsVDUSq3rNDQWute8+ojrijx2EUF1f2dPcc1rHIdG+SRU681X+VmGLmC/+ipDmuGNr3cDDK60iPlZmExwvE397yMKzOEnHCq6Ov68AuqvHBEnfmdAnFCP5YGKIObnkLmzVGjmWs+NX4FbzofNZ8R+xs+hpFmX8m9Q83wx1LytyzDt5DxntcHpKoFyg8bQ75g2Tivw1rR24Vp8cg09+TIM7laV7fPzy8eAwZ/o/no4xoSMYVRGlkyARmTurvyd93GjyLdr0PZ2V9cN7iQjU1aN0BSbWM2OAToTustPcgDp7SSvvHufVr+IpA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2dce31-17cb-4532-27ed-08dcd6702f76
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:11.0020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9s3KU1quATwv/djC57AqXpVbXufo/AS+ey1ma73h0StU064BOmpWaerMH4Bd05zuSFOT39j7U4KdPmWmFH7jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6320
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=944 adultscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-GUID: nbhFPOyz5-geGwZp3qWosl_o1fMbVHYV
X-Proofpoint-ORIG-GUID: nbhFPOyz5-geGwZp3qWosl_o1fMbVHYV

This series re-introduces atomic write support.

Some time ago support was added for O_ATOMIC in fio, but O_ATOMIC support
never made it into the linux kernel, so fio support was dropped. However
some plumbing was left behind; specifically, we can still pass command
line arg --atomic=1, which sets thread option oatomic, but that is just
ignored.

Linux v6.11-rc added initial atomic write support through RWF_ATOMIC flag.
See latest man pages for details of RWF_ATOMIC:
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/

This series uses the "atomic" command line option to set RWF_ATOMIC
on a per IO.

Support is added for libaio, pvsync2, and io_uring ioengines.

Since RWF_ATOMIC is only relevant to those ioengines mentioned, trying to
set --atomic=1 for other ioengines now errors.

The verify feature can be useful to prove atomic writes. However, atomic
writes only ensure a proper CRC, but not sequence number. So a new option
to ignore sequence numbers is added.

Compile tested only for Linux (ok?)

Differences to RFC:
- Drop patch to ignore verify sequence number
- Add support for new option verify_sequence_number
- Add atomic writes fio file example
- Update documentation for atomic option

Alan Adamson (1):
  pvsync2: Support RWF_ATOMIC

John Garry (8):
  os-linux: Define RWF_ATOMIC
  os: Reintroduce atomic write support
  libaio: Support RWF_ATOMIC
  io_uring: Support RWF_ATOMIC
  tools/fiograph: Update for atomic support
  doc: Document atomic command
  fio: Support verify_write_sequence
  examples: Add example for atomic write verify

 HOWTO.rst                    | 25 +++++++++++++++++++++++++
 engines/io_uring.c           |  5 ++++-
 engines/libaio.c             |  7 ++++++-
 engines/sync.c               |  9 ++++++---
 examples/atomic-verify.fio   | 36 ++++++++++++++++++++++++++++++++++++
 fio.1                        | 21 +++++++++++++++++++++
 init.c                       | 14 ++++++++++++++
 ioengines.h                  |  2 ++
 options.c                    | 13 +++++++++++++
 os/os-linux.h                |  5 +++++
 thread_options.h             |  1 +
 tools/fiograph/fiograph.conf |  6 +++---
 verify.c                     |  7 ++++---
 13 files changed, 140 insertions(+), 11 deletions(-)
 create mode 100644 examples/atomic-verify.fio

-- 
2.31.1

