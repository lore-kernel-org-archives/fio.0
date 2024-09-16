Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB60158DB9
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505678; cv=fail; b=pflqmoGOjGJPgkUCyflBi9a7u9GQvUjXowNcNvVuGHVlMbkXxzlxjy+ZW+alNMmUUqZXI418HkBUTwypFYB3d3JuC7LV9pGe2mvbVoCDoeNgB6Bbsi+99be0y3zxneSL0TnEFmDW72PV0+REQv1BelGTkqkXKyHQpy5p3qb5sJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505678; c=relaxed/simple;
	bh=WzYjgNWvZtk0Mhx+HKaHQZ0E7VcAnybSfWggiHzQDvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RYoCwX305J7Lf/9nMbg4NrstLA21VPmK/NiUPNY0Pu1ySSWnKt/TluZmaWY6fQ1ny3DWQ+tGtvw9UrEW+Bfg2HUiIVwqlxb4KMJInT3u3qbO4TmEiivEbKj/NYe7tce8uxtUeP/GoY67F/dYYcSEkOd5iM5fFExO9JGN3ijB19g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T1XfewcG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T04S/Fba; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T1XfewcG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T04S/Fba"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMYQ3030157;
	Mon, 16 Sep 2024 16:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=EoCg18GLXTHLRbdErcHlmHjTw6Cbr70aRcTetbv8BQM=; b=
	T1XfewcGG1z2blLtRbhYBxRZxQn0QGjTx7c3QkZBjFLsdR/iS3rgzIQM8mYrfuhk
	sroAloKZHjsHcFBFkl+DlLtrD5hM2irtO/jEnQ27/4oCCOE5agmEgY/9pJDRSDhb
	06QOtUmTEY5ywd30HEPJbHBhAaBY6u/AgZVFc+RyzLQX8az3I1rY2DRjHzzqH2e7
	cMKiQvPlZDVuGC2lGBG7B24Oefrj9A31zgi8X+wCsNKhxaWowduhPVPOfN/aPIca
	Ra/Dw1m5atPYTkORyxsqnhjoJV8j7lQzjbzT7vWwSKysd09Xeo4n5zVKYdoJ7wJW
	a+LpfaSgZoPV3ruaJ2d1fQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3bwn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GFRfT7034146;
	Mon, 16 Sep 2024 16:54:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nycfpcgw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jo1wRhqd79l1dhN/+DHaFOnwtpt8ZsPagZ4ZXf1b2HGubmU5vUyrQTZ5z/uAshMFYeqRV35ZjzqPE2ycj/H3Yvz7Xd6O237m/tcvAMQYexxaoQ46VV3qK4SEx3bc4YurgctbaToT7KHwNk7wgpCLC9C/8LaOlEOu6rWmegocPAm60d0/4W3kRtG9iZFOBgt/Ft42Qe/oWOlz5eXIiUY4FfuS5++wPJ/MVpRSAsZKwX0OLcAr18OAhXHAWbIhby+t+Mpauw5tAZ6AbLz+ZV63NzepGgkVsuP4DeP377bXZpoob6tEqSc+oBg9QyjmswmKGcg/kFfdxPhqHJWkoa/ZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoCg18GLXTHLRbdErcHlmHjTw6Cbr70aRcTetbv8BQM=;
 b=PkNhiTic0y+crN1Ie9Texj4OVOSDhJsD7ZhCnQ8cIe1e9dJJPdxtkdyi7qI2mRxubuCfPv/ChY2n+Il38+cknPI7/s5IFYHRg833lvQK7ZJO4Kvi2b6FwWu6iAweN5szre/At7WDVq0k0OmWCTTptvDMlkfYmDiWmqPOnlQ7JacWKvPnP75cZwFf0M222O5pTnl79iCn2FH1mpyBdkOmrLreR/UnnIXSgq/x4jW4mXQrc/ZkzokW94IwqMaZ/VKq3qe7cZEKq9d5v5cjKLmrdKyMx5wXECL3C7Srm2y/4diixAp9dy6s5YerZpnn7RRHjR9R7NzbgAnXcIvO+irGQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoCg18GLXTHLRbdErcHlmHjTw6Cbr70aRcTetbv8BQM=;
 b=T04S/FbaT5KcEH20O8PxJl6T1LXu7lSkwnhOGB+0Uo3Dq8ao/DJYncCcL05ov/D/BA5jTa+C4N9TGVRGM9GjW2V0H6tTYKrq22ZrdOYumrT6YlgJ/LEXtO95mvFHWM+lkcZGcCaCTfCxSVRcbjTegxEOX0uy4cmRDR5gRWFO1qc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 5/9] io_uring: Support RWF_ATOMIC
Date: Mon, 16 Sep 2024 16:53:43 +0000
Message-Id: <20240916165347.2226763-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fe7877f-acb0-4fb6-b001-08dcd67039be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zU2s4SNRPN/wXZQXd2d62IQpcDdqRiq7wjIl4bSmJjMWHXnjNSZqv5jCNipK?=
 =?us-ascii?Q?4nrMxJU3fpN8jCLlCEQIPFXhuiPoqrZ7mAuDTTbqvcm2lwjqrI727Mo30SQA?=
 =?us-ascii?Q?Cnvt+VelJRq1v7uKmFakXdAk/k9WVbcz/YdquSkNLcwrUIZSnKA0/iBdhkka?=
 =?us-ascii?Q?IZIPc1nBujdHEanHXFradhaL1Lymvhk4PmOL3fmb3VYJaGUmhXVU0bkjfqIl?=
 =?us-ascii?Q?AFmvYjzYXgmhSYB4qUMGvyKFTGQLTsghIyZGY4aEu4xRmAGwkO2I9Hh/WpLO?=
 =?us-ascii?Q?/B1nDqTRf9/q828/lyFxlHnHyBEt8RPZKcTIfAZlaCeNpN1ximghLNtu9DLN?=
 =?us-ascii?Q?ey/9IbDpMQ0Yx2o6PEpXBS/RJkRWvaT5NUR0Zf4XnqNcPFG7y48V21W8YOrv?=
 =?us-ascii?Q?/tD+LE/zLwFEakQ0wJi9ukBRnwHdPv9EObmIaw7oaC+KNZXYhE26fjqzuR+v?=
 =?us-ascii?Q?WG7yEKFgxjsTVe6OKKyhOWsKxaSiSGsT4CAScrkWtzOfKdnln+FExGVPnblU?=
 =?us-ascii?Q?pRCCV3ThiNsy44GQXt6NXp2Vz13QepBAtg2UJqp26HDKhZbspLalZPVR66Gk?=
 =?us-ascii?Q?Fdgyru+vvSlnQ4as2zhA2iwDmCGLUGiiRblKfNWkPqgrRsPqNJPHeq9DRgwn?=
 =?us-ascii?Q?qdn2htpbneURzRtqNfuF3uK5STI9eSpRJaz3KWicoEje7fCUWyroZEoYpKvZ?=
 =?us-ascii?Q?71MKWJf2QqeioTVe8OQDuri7eiH/RYdxc7Iliw0+JPwhrLUry+2uOyaRWN97?=
 =?us-ascii?Q?mNAMVtSRFg/yfMqLWLMWIqdDAdbRlrmdvsSG+u+jhx8m205RFXfTgqAjqfsh?=
 =?us-ascii?Q?RtWejfNWzwSjbJpkCaNvWRnI+c7+VCuJtRSEYWMO3QVeWl6hYHi2sGlj0OjI?=
 =?us-ascii?Q?hvqzRJBAJ58YCLC3j7gws3fshbgNeohbIrmbW8gm1tkrXcV3NcP1eKu0TNAm?=
 =?us-ascii?Q?m80cFZnn7jvoR7R62z6E9PopOXJgOsQqduErww3S9wBq9g6dH+fUkRTX9lA2?=
 =?us-ascii?Q?Tb9VQURq8xN6blwOTdQNXt4l58t2gfK6ux9XLzuZ+6g/qxzPsVsbwzQ/vvIH?=
 =?us-ascii?Q?N7XeTKq7/M3YdSgM+fvLzuRJciQ2P84cZtPD3REvPRPy1pusH5ICKxQmr6SP?=
 =?us-ascii?Q?o5mkG+fcPXHt27fVltxf6wDvKfM1F6+D8yo/qa2T7BgUSr3lveNfvnAtUykw?=
 =?us-ascii?Q?fTQyW6edYmK2kAo5Ovwcsu6a9qJzE7rzznKBw3KGADIq2fXHmfo0S/k6TDrF?=
 =?us-ascii?Q?KMJrHM9NgPlHTy4KtK99B0Rfy9sMq+eMaJqHTob1MOMsYaXwTf1+bUabx2a4?=
 =?us-ascii?Q?CNFv/Me2rRc6LD5C0WUH4omtzSX31ycfoTP1BPEpG/TIGw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PiSb/j86WCJ5Gz1ZUKVn7m+KskmmurIwMfgpGlIHIGp+V1Ox/aec6/7LS5sI?=
 =?us-ascii?Q?X8zU/AEUnXwCVErx9b4wnDppINxT2Okxdkh6TJ5xV4dOJMtrT+t8qsGxBhFA?=
 =?us-ascii?Q?qS4QksxkIMjy3GU31aXdvA8kXXU+Kk9hHDpKXMuyIHT1QzzYCX7fR4uBOO0R?=
 =?us-ascii?Q?nVaY/eZe/XuShgwBRDx83kHyKOhoarrtXkU+IuSuRwEQUHtGAdqRD5yQWM5P?=
 =?us-ascii?Q?RPdzWmFgI0dJdBle2HCPge49xXRCG9YKVh3RBYuhvBNeIlyRGzFmQqo/Hy8S?=
 =?us-ascii?Q?9YyPQG2Hl46dMH2M9T96qfh5OB5rkS2h30c1vg6Xp1gs+flwCEX6wP8kjkry?=
 =?us-ascii?Q?Ur3GdTG8qRHM3EEbzLM/4TaE5GMlvxR42bFfPvapPZgDDoGLL9W3YZtnUZb0?=
 =?us-ascii?Q?uEV05ViBNXrVQLOf8+PdtjXuITT/tnwwBdwy1u4eLrH+RJByTBXi893Tulw3?=
 =?us-ascii?Q?EwUeBwPoHAflQBPgiq6fGQxHjCiXNpWVFE13nwAPH4J6xjsCPJFQhAOm5HGl?=
 =?us-ascii?Q?O2+blnMT08FGwfh9C9REai3+VE1Kwlv2u23C8CHESGOXSame1+8C9UFUnso5?=
 =?us-ascii?Q?W/iNUSntu9D1SERrfY1whP8mRuC5CrwDw1MUSvXZ5P3QfsnkiUpQ7vuToZD5?=
 =?us-ascii?Q?64fso13wp9q4uTsYPkH3iRJ/uKUL0opLZ1oCSLpqkcjZlOCwtVRchyo8ILn0?=
 =?us-ascii?Q?U+7U+D/h19PVlFzkRJoylUYAuuh0FIADjQD8BRliTspHrPMSiOeyzo38boOv?=
 =?us-ascii?Q?d5BbDs+rfuL1IJIQsX1ajDLU1TLH+8URJxgz74owuigMYd53FuzoBXH5Fx3o?=
 =?us-ascii?Q?D/aY5onBN59hDPbd67ukuMXzOtCUMOCgtiFyasr+aF4UEMXiSXZFcc6JeguN?=
 =?us-ascii?Q?E3aUk0djQs2Apn/HPqHCojmNH2RY7qyZc9n/2mcGlOL0wUxGhcpPlbPMkgR6?=
 =?us-ascii?Q?so18KiaHbCVsqBH+NXFSomHvibcGWD2IWGAkrL8+nJiotuGX/xflMv4P8Uvl?=
 =?us-ascii?Q?zggP6tksMRZjuGH0ramvmsclN3+3KVCiO8QCcaM+3pQGC8PW980YXAZjxUGl?=
 =?us-ascii?Q?K234GolcUMZUnQjz1vri5e3TyFUTIz5Dayn2s64WEtQQwf41icmM+u0OXa4t?=
 =?us-ascii?Q?2XFyF+gPmTYExV/Y7CNZ8KLri2FHxooBju/a4KqR732wTmGnIta9vFxsG7Pv?=
 =?us-ascii?Q?jt1hvcyfDnpYyCL48fBZTEoLIaBNns44TtkC7BKaysGC1ml3dSfUF3RjxZ50?=
 =?us-ascii?Q?V48AWfoM6VvEiMeDqddeCkR6lrPSPdBaztmzljR+/BpOmSE0/lxv50t9phCp?=
 =?us-ascii?Q?tV2GHZTsc9yPDEXTrUeiKimjskyMA7FeFeR12uBLraWYABMDYofallok4n3+?=
 =?us-ascii?Q?/f2f89p0MrR6bBCTOl7HQZIvrRIQaPdFbtxtqvN3dasWWBXfX7dv2oHw4Rqx?=
 =?us-ascii?Q?fBD9EgKO8A5BHCm7knEdRBAil45yUZ0jGAUBcce97owEzxLVoaxkNCV3aRco?=
 =?us-ascii?Q?tlFpj5AbKwFKwg+N5oUv2b7CV7i266kMZLu+pU1fKfPbHrjCF86PTNjIPSab?=
 =?us-ascii?Q?ryAPqqDeivNoQhQ1PJSIeRt1mc9ZLm/ukSnhO9u+rpobTAHINWvVUYf40mbr?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U30H7RqCb3jfBKbjwIorttICtzZYuaAfECBWDDKmuGB0kPuQrzfDipCRyflB5WbUaK6aEJ9j1J3rRkLfBwm20MhbvI606Rt1215ThjoliG/1vlY1IKGVbxEJ8GjztOGR7bmFJmKIhDM/XR8NLmtcYtvvS2dojRq4v76ZF4mkoFZ76ebtJlvnQOdoLHX1bKCYUayCI+uIqd5Jxm1F3aB1q7iCgiEbn7sYmzq2QlcivY7S+yeQw3/c8KGD6WDR/LBkWK56DTHRuWXBLXHaMVjiWMG9HOXbOscITSeOYlhWJfUv/aJGh0qg188HWvq3McG7hP5RE/L5vWZq/K+bHk5eDYirD4y77/ECS6tyjz/DnDFrhruv5Y9EbF1b+z8TVLfknAldR9AfIT4PDYRoMTOc3sZM6s98Iui/+e27ctOu+AHgY2iigyUpDIc7csdwz8XFzIcE1f6b9zx/9YwcspaSn2c7mFFYJmvcCK8OKu6iV/X5PH5H6OwyMaxJdsBHfzjnjFy9XKUCej5wmeVNevqaIE5eF1t/yYsOBb/9sGBXMeen90v+31KT9D94+tzzInMPa3PpRNzXZCm4s2CG06ktZ5+qGOj5rz4pRCYLnCOjJhY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe7877f-acb0-4fb6-b001-08dcd67039be
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:28.4787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfC7w7p3itVKm6NsPwGmemvLgSj5AHjHEmiu04/kAASuQSHk6W/hX5ifuhn9+PHTaZF7ObDEwolAF1eVDLI2nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-GUID: Lor-BEdJZ_vVNA2ZL0JDX2AR27P0K9fz
X-Proofpoint-ORIG-GUID: Lor-BEdJZ_vVNA2ZL0JDX2AR27P0K9fz

Set RWF_ATOMIC for writes and oatomic==1.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 engines/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1d4a6118..96a042a8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -392,6 +392,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->rw_flags = 0;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
+		if (td->o.oatomic && io_u->ddir == DDIR_WRITE)
+			sqe->rw_flags |= RWF_ATOMIC;
 
 		/*
 		 * Since io_uring can have a submission context (sqthread_poll)
@@ -1582,7 +1584,8 @@ static struct ioengine_ops ioengine_uring = {
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

