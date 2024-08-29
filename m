Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20162191478
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934687; cv=fail; b=UXL6CDLl1L2evgvgPG2OlTJPhg544RbRp4UqPDKUR13ARhf24UB5lyTK79uAMR2c22jbhje71Kg+I4WbVwGp3xfV67xB0Hf8KTrtvPsSe0UejJmJE6L0BUmd08K512uE+UUfth6vRb7pdf/5pw3cjtv5Td4Xs4yBSaJ7hqhSc5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934687; c=relaxed/simple;
	bh=twBjErm7CkQlIWn7N23W9gmoUlUZSQnn/Ez8Fdl/D20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SUYs+P/+OQCZjP68aabQDsdB6whPueRbHYmcfCgAIoMoZE4VcROPL+Ovtd1kF8zuJd4CPKMsmVW+YZ303weaf05k5PF+ibAuow7Y1Gue+lF7ppQx7Z60kTj89vGyCkZ8S8EXtphJ0zFOh9Vvg3PplWl1oRmCaRoHMhBNQ3gQR3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gfQASiRl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qUVSjz4c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gfQASiRl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qUVSjz4c"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBhSDP022830;
	Thu, 29 Aug 2024 12:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=v3hiasKHr+oxzJmS/feVEf95x9SuCiyNjFoHPfWJWus=; b=
	gfQASiRlnQANR/cHcN4rfnffKOMaNzB2lLbrKSq+hi+ABLNq7wuCpK8/OI2e61Py
	KbNeFh/+7FTtEUDvmvRazJYqbpx8yK56p7cgkvC8gVBW5/ojkeRrD4+jEiYKzIEI
	yHfbE7syQbznXRKsrS2D2/d/IEQ4JbjFvQAyo8KP21iQkb+/JDFSs6JLqVZdFUW4
	wRMAcscg40qaz7esZ0aooeXbJm1NIdZUVvgrCSAmoEPDTmt8EQ0npVwEjIPe38Io
	vxAO+vKA4nxpMp7Iy8QcnhtgOG9vE7hNySlv13kcRcrJJdSpmlQmP4HIpiwwCWoZ
	porj6c3bTydP0SeF4RN6eQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41arbt02qa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TAcjB8031752;
	Thu, 29 Aug 2024 12:31:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418a0wn1qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMBBq2Onv2BqJKJ79iqUAkoKvJFrhfAZNjaBYfEjys0NGgytJuQ3F50b66CAkCrLNFT1gjjMFfAwKZRpQZNbwh6C+mgFu1U2d1gjlSEMG6P/kjn87dDaXr88tYwkggBaBx7m6LfFsmAUFRoVVGjDSJSmdYjrsBfrpMcSVKaDGP0nLmXW2ZDLUGyGbHMtHYym2IjubrWIZP7tOZ/m3rA9W4TXZOywAU0O+4/NGpUQ7Dku3SotvglbjMcCJxLUdaN4mnv4Gf7E2HXTlsIrn9E58rN1GxamSs0cHisxVFrVP6acdTI0+VL9g5kKaA6KawDvrMcwxmerULC/Or6O2IOFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3hiasKHr+oxzJmS/feVEf95x9SuCiyNjFoHPfWJWus=;
 b=UMN++LbvmQBxE0OqbaQSvo8wfh9X2VWQ5YLWG0bsXIXKOZnlhUtGVhI7zm5G5NrMJ1OYtpXRY/O3dWTMvyAk7VwHTRV3HCeLhpc2sr5nqpA9DIZBIl+c8ycbb5e5oD2Nv1vpTUx1+tDhYYqsDztBWh0Wd5S1k5wphqnZlwrtzPPldbpG4hz5uAbce5uNNMDtk/ZnuuVFxKFOzxmh1VG+D+eB0Me6oPIc4DZQt7agFrx/A5KOc5+sBa8VAqrv1onpquHhclQOdWz/7xAagX1jb5nYzN82zFJz3voNhWx2qs+trEKu9i+KbqyrBv+4kEe2s+1dJpxkcOMrpKCeuqomxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3hiasKHr+oxzJmS/feVEf95x9SuCiyNjFoHPfWJWus=;
 b=qUVSjz4cSzwtZ4y+XnR7X+wLZJLmbPksUk1a6dXzv7/4R/3FvJ5u4WcoQmP3pQ1ZXr60joOnsSM0fcs7NCWe3WzkAxHSnYoF+Snwy65HEOo3ic20tMgYjTZVjEjVrlRPXMAvn59UCq20ZVX/ncWJ7Feysqz0gZ9IspjS2ss+EXk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 12:31:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/7] os-linux: Renumber RWF_UNCACHED
Date: Thu, 29 Aug 2024 12:31:01 +0000
Message-Id: <20240829123107.520005-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: e21e682b-e9db-4b9d-a8c4-08dcc8267a01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TAQFHBx+YD680m1QAOMYCKzRoxjXnRUBIvP8mSHv/S9RsiLIWSuanPtfS4zk?=
 =?us-ascii?Q?mWP/Ti0fmgAhHvwBphyLuoc2xqja7nOMyRuZmuSbQO7SSaNYmrvtQ/TIosOg?=
 =?us-ascii?Q?TG04+4fis+UmvkKwv05xja4Nyr74DgYNXUprKs+hjnDonNwhgO0vGxazjhQh?=
 =?us-ascii?Q?oWJoaOexvfe3jlKCkRvvp85T8T2au0ZykbrrY53ZGX4vKfPUeNWfpMj+tUuE?=
 =?us-ascii?Q?gsjCdOv0kyJRl87Fzi+dB19PBRpzg/Gh6KRCbZV1GcXAHflo8BesxQx7OL7F?=
 =?us-ascii?Q?v7I+oY5YLaT6su94w0Hu0NUXgae5VD7HX7rwFfHFvx8eb0yTk+3I26ExfRTR?=
 =?us-ascii?Q?XdBcvlYX6kAlrGe0P+fgEaEVPb8B1n7v+6lINFvhbtrr7TD5x4+9TkgDjW85?=
 =?us-ascii?Q?0GLyhK13xd25Evi8nLJwJcAVkqI+qq2DudzxHMZYz7j7LkajNmpK5/32vqRJ?=
 =?us-ascii?Q?81iH9ryY7H3SbE+7rc5Srvt/e30T2XNg740WkxfSrFW/kmcV/o7j2daLOW4C?=
 =?us-ascii?Q?jNiTXwqMgvy1nZYFzeaZxu+m+23PJIQEvwa52ONzBtamxOQ8BgZlPJNwn2Hx?=
 =?us-ascii?Q?mG73FgJa1UOe2NG92qITXLmYxHOUZ/Tu1QH/aqeDhbqWRDmwdtJ8k9wCHoxa?=
 =?us-ascii?Q?4BuPtPmLlHXw6dFBrcAscWq7AfnOKWao5MsGKGIuHjcTYV/ojlJCg5NHIhSR?=
 =?us-ascii?Q?nsHVBmCHFNdVdvPyWCdrBSAS3elbcN5bKgm0G72rj++X4lhH/5S/zcD5Y+4n?=
 =?us-ascii?Q?Y1Ig0aS1BDRel3e9JHrUNvL35BIqWlyoFh1FUOGJHl9VgEotDZfo1kIJcBHo?=
 =?us-ascii?Q?u3SYJWTGLzt6wipJq8q9vsBYvTHyYuDxRtZFPbWvfLejwGS6FosfMxJKJPOC?=
 =?us-ascii?Q?cZMySdmnSyKlbXium4mfMGycLc5NrVeg75eLAosP9HInJmuIIBmFzNFNjK2k?=
 =?us-ascii?Q?S+7QqrvcjQBlX5Rc5tmxboZ3hjUXfFfa71XTPzn7I4W2Oz76sjxMjAJw3gSO?=
 =?us-ascii?Q?1/I1hUhOGvVCh50zjCAFVrQkTVMp/JVPqLXWjcy+6X0RZDuatwNusGRk6t1e?=
 =?us-ascii?Q?Q3OAkkxmv8BjbEL8CwwlJE5YSUgbK5lEFvOVDlmCp4eA4Upez8PhzbsWqZ+1?=
 =?us-ascii?Q?0t+ZIwEj9p3YlAtFSZLIFhI8qflG96JitPUntLtkV5yQWSSIVKPMUrgzFioT?=
 =?us-ascii?Q?G7UKKfQuuxfJ5wDnTpNv2xluaE0rU+QlqxnXlVazJFpLLxiUgTSu95/pCHFQ?=
 =?us-ascii?Q?Dy+4FTK3RBy94baA/8CGIDjCXfaEva94cfrIcvwVIxgPbPPwRQFdC5Pmwhlm?=
 =?us-ascii?Q?R3cgMQywy1GlwKcyRvbptD2h6fTKWsJe4qE22+0Jr5FV9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oLcpFgUdeuPe0kzuOvizeMFJ2BQzsuj2HMeeKamT84dYy2bGpo+8MAcCd8H9?=
 =?us-ascii?Q?bdjMhRtxgZDwLgRq5LFb1ijr4LbzJRn+i4x0wZAEenOzj5f6dxTdfvKj/XdG?=
 =?us-ascii?Q?svbT5ercNDKtm/JXeHiJMrUngE/6DkXTYvLxfrsGpzQjrz8uQn+PJwP3Bn7s?=
 =?us-ascii?Q?w4nSZ1RgVN9PNUWdVD9ZLGHZ7fd+Ci8uYWInY8tTk0XIHOBKu9PvjDjRdIUx?=
 =?us-ascii?Q?srvilAE7/A9NIQih8KeCi4E3u+/ekFqQCvvl7rGsjKLbG5ELBepRaUDWD7lx?=
 =?us-ascii?Q?DWh4Imy9L6HETuT0NdrbGnUN+8yPsx0Bfmsrm/6onluE6BzRZ0HD749AKPnC?=
 =?us-ascii?Q?YFn6GJZyxxFYkkdubc/kVk4oO6SK+JxAVDEc6lKB227CoHR+AwNS7hl7QFcZ?=
 =?us-ascii?Q?3wLWR+f5Fw52hFIwnp8/D9KKn8Wo4fsUkIr5V0Vxmfhw+dDtp0NSEf7RDVn8?=
 =?us-ascii?Q?j1obGkAsEZ8L2YeR6/JUPcDClxwuAaVcXLusCI42/WmLKD+PhTjisnzliyqk?=
 =?us-ascii?Q?Fsdc2u6wv2FTrIwDntYDvhtnGLIhndg5m7ydqye7Xqfk5ch6YwaM06M6gFcE?=
 =?us-ascii?Q?0mH8srRfDZMBV6g4AO2k8GQUC3JHruuWA7YY+QUw+vFUSw8qdHIKnj9db3EA?=
 =?us-ascii?Q?iRSmoDHWW3/EdMU8GwrxFscUp4rEbJk7AESUK6AWrcQ4/S+MQJfmIESI+iM3?=
 =?us-ascii?Q?8L+oFkRIPqg0rDzvL8eAUcvVgEmQYG3kyHEFVai+wwonSLfd6Y6m/q0Idnrf?=
 =?us-ascii?Q?gUgmtJECNKpOpjoM+OxnKHS17XGYhrnz6fEduJCB2z5wraputD0E4ccZk8Zn?=
 =?us-ascii?Q?j6Ya3IueN3ChV3wk1IVypYxo64fQi/ChFf4ND8uZI+H2EK8LtLHEC/9eO7Lr?=
 =?us-ascii?Q?ylwQYvTlQb47Jn3xDlYqhfSDriedmydoVcqm2rEjIs6WfqdiaU//1/39Cjws?=
 =?us-ascii?Q?CZKiEapeAqEy88+jq9TdWXzdp5BIMBcaPxU7QxcFh4VP14EOZUqcafyqRCYW?=
 =?us-ascii?Q?zBVZMKOkDvrE153CIObLcGxf6rTyOaaqY8q8Od7CG2d4TtL4HoBN6vo2YBl7?=
 =?us-ascii?Q?WmfUi7LOKZcTGj1Pv0eWaZf6gwaaMSU5+Ulu/1glwLoF8/osYOQpjez+UR97?=
 =?us-ascii?Q?S6LrmGW/cczmW1XkezrDuQjhIflR3ZOiOm2qy5eog9DJiD/7vflhvazlfiVg?=
 =?us-ascii?Q?AviZFOtGuw+ful47LrBWP099FXbMfGiD5FzDnRtvzB/YUrB4dsdK1GvG0PXg?=
 =?us-ascii?Q?qFAngsAlCiu943TafTQiLKj9Wmr4QrNM/GDvHvT6cb/wt5M56+p+qMXY8cVP?=
 =?us-ascii?Q?II947itPwmSP7Ify+Rst4GvcTVLuVr3Lyd2aQmUjGXUWnv8zTnvODm+qK8jX?=
 =?us-ascii?Q?m2d4Zr5tyqjxNoVdU/uYyZJ2PBeipRB3NqYFxatzDQKwYJmpPk0M8BlG4FWU?=
 =?us-ascii?Q?qxz26oQPJ5z1C8anJQ/q1PsKr7Z6lAUD7Hi3wcfA4nrPnCdHQghE7NDcmRM5?=
 =?us-ascii?Q?qNJOUpdn1SQOU+nd/b/khMj5ULT3FQ3klhXEdMf5FeKii4RDbzgrDLGGOotk?=
 =?us-ascii?Q?dTGHie1essMiamEAV3U6L3nTIg8gfZzZrl+y4MWUn+9Ci29oG9NIVSIZIYVp?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	55U6j57op/ajzWbmOVvDyGHuVUXx+ZC+Ds68ZrRi+XWw3H/ssGAlJ7YD210YvvfsXeRiOtRxX3hLV7aC1DdUTtw/Os3sw5/ryn+NP+0t+qMqLzi4pxg9ozQIa3Nf1JHzjj22n0Wa2d5DbDVMcdirCBgHpPN05IHBmZKMpawarvLBDE0qyCB87RZl5F2tjL6gUB2owbvqINL/q59dTy7mN2+ggrGmyRq5df2empL8/Hl8DMUBw1ABG8q3Boa9CdPZdkiLQ7l/+BiibgpYyXq37Why9ZGxKk0Pr5lGoP0OH3nC9XOk/DmN3PX6LCU6ANx03lO+4iwemCjVM3qfz19mtJy/LHur0lln53vWV+cMnhQE5nqOmKrNhdcezRusLwhtdzlCbRMobm800hQLtSNRxcQ5GCz38HuE2BQmhy3cqmjiPusfcXQRPQdRPhSL9Nu6MHPxzM9LY5fpSYdlhKtnBMNG91JZUOJ79e4eF08CJuA+rKljr/DWtJ94Iwx5XAYNWNfhHo161d8/sHT+r+3TALpfdAUBoqHKJk3ICEZh7jVuGzxtcBlbOnt+YVM9BDc8utMhmDWXkM1EJtxvIQviKYWDMjzrsrPSP/1PnAW4Bu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21e682b-e9db-4b9d-a8c4-08dcc8267a01
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:16.1845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1B2lTztUmCxN/RiwBW/lpzfZY1RAvzgd65vPVoNYPfnQfeSOPYQTV8lNmoeqHPt9eV+Q1eEpxOZBkRqTQn8YWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: cU3T3pAMPU8oSEKz2ziWNg1yiCO3jVXn
X-Proofpoint-GUID: cU3T3pAMPU8oSEKz2ziWNg1yiCO3jVXn

This now conflicts with RWF_ATOMIC.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 os/os-linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index c5cd6515..bdd725f6 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -329,7 +329,7 @@ static inline int fio_set_sched_idle(void)
 #endif
 
 #ifndef RWF_UNCACHED
-#define RWF_UNCACHED	0x00000040
+#define RWF_UNCACHED	0x00000080
 #endif
 
 #ifndef RWF_WRITE_LIFE_SHIFT
-- 
2.31.1

