Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB52B17BD3
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505663; cv=fail; b=SFG1/GwHD4gwlP2pFRU8O4/pN3WeTw7SlOhY3WOpi+aIupVHe878H47g641PmYdRCZV7lykrER+DV9z+yzNine3/FNnjt3QtOQorrqxzFO2j6X9NCDRMMFKbY2YSqk66Vu7z3sKcOSIZyCWKG/4J8Ggf4ElnLkBTomNE9dxuiYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505663; c=relaxed/simple;
	bh=QxZUrb2lUmoZW0OxgSVPup3VGp2BicRt+1tdVAkdTFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HQtYOIlvklitlMhJWoaMLm4CToKQEL++NuNiVC2idNywlJgzPjYqFdgIyY3h8sxoPD2EQtKRyD16VwJ306WkM8+IyoFgeueT/dpWr56/iQgWFVrAo509NmHXPTheM696l+6lgsAwl07MMzC55oJkcQAcPncevkvyjDkdjR8kZJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HEJy8hj7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eGba9Fou; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HEJy8hj7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eGba9Fou"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMWpp006532;
	Mon, 16 Sep 2024 16:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=wzhzFPniv0U4OlZpSWiuznelyf5xHGdqidLAwhaHrcU=; b=
	HEJy8hj7wsMpJgOZLV/+moAC/MLSNqdmwGs5SakUe8UsnlU+gq8CqQDFmNDauDO6
	lIZNEOTabaUc0a6VmHODGxNfy4s7ViqSZSrnP77F27EX/q5v1XLpx2QwccyPTzjd
	0ZMLHzlk6DaS8PINAYcVNPIgqCFSfMlAS9dGU+6rABRqpd+U1igmJPx2cQnGmiSf
	MXIsGZCt9yfBITPLMuhICeTmRBcdVF5JVGegZd1/uS4TCgo+wN2xxS9Y7HTmfPM7
	BfurUV+BrPikv6VUOpbquEHMjiDHqigprw95UnU6tkUotimfu6Kw+FVN7WSu+dd0
	CLTyApHBx7JNFE/mWZPm6Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3rwuws6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGOm7o017868;
	Mon, 16 Sep 2024 16:54:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nycvkvjr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZZfAVwP7W8fa+zvYUNpuFwWgBHCSTpGDzbceA48af459354by8m7VXPN/X9MllH3syynzPGDN2X6Dah8FnzgrftR+Q7KGa/UFOnMG+vooG/GgyVJnbvOMEKTIE78haTGDERlpDF/sSAvthSFVMvdnRJGkbcB127jhlJ+nEKd5QQLlRoUJ5i1Z6rktnzQ2jxixnD54S6A1EZx9JExl16oMlu3cUSYJ+/M/AFHCaVcZom0tb1op121Y0dbsShxFKrY8Rrnr9CYmJVWniQYiW6L9y3RmIaExv7lUafCD5XUckQ+k+GG4H/vVKJPGSerwrXLSQ+X41g1RxBfbU7QZwxaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzhzFPniv0U4OlZpSWiuznelyf5xHGdqidLAwhaHrcU=;
 b=r9NY1UGdV9NxOP182EOb7VAUh5W830+740TYbKA94Ao88lAItylPU+z233/hDe1ILv1TE6mltidZYQVBcD5E0MkKjTDeXJMrjLuCS2nNkOm1G8c0V8PdhFRpWD9HEbYHgC+HPWHz/Q02nd3AqszK2rdBmqLZZs2lnAHWmxY9nA0tAv3Glx0YGn2srqzCcfnOoq+d+jkjusTjrI8hxUALR6fJEKMOFvsNmMqzotGcUUE3hFZc7OOsmm0Tj7i3NY/vCwd5olMUYb/+0fn82lkM5MhXxNx2Ew9WMoxyl4hjbRI4OoKHaI0aboZXKpM7dBeig3jOtttgpgFg5px/0DrdFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhzFPniv0U4OlZpSWiuznelyf5xHGdqidLAwhaHrcU=;
 b=eGba9FouKBSQKXXeOWOBRcrUDERH2YJ83vVY1s9o535s2OE8IdYn7Xmd4bxPDX2mZchg/55BlMqCFJUZRacmSwNmNaWCnG50wxD1prkpSJB30XJ0R5b+KbCvZlqY8dLdlbZRGRrnUsW648iENcQgCSXyxItx47x+04gdx+iNyTI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6320.namprd10.prod.outlook.com (2603:10b6:806:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.15; Mon, 16 Sep
 2024 16:54:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/9] os-linux: Define RWF_ATOMIC
Date: Mon, 16 Sep 2024 16:53:39 +0000
Message-Id: <20240916165347.2226763-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0733.namprd03.prod.outlook.com
 (2603:10b6:408:110::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b05064-6060-424f-bbf7-08dcd67030c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8p/zQaEixSySirxvA2coSb1p2UaJqYzlvoJBT3j8W07N0kuEXx/0i6l8snYw?=
 =?us-ascii?Q?2RJCSXhy6adsSA3Q9HjNUm6nkLjwFqdSD4q9Mo+8Ds7rBWIv7ARYfTPV3FxU?=
 =?us-ascii?Q?7nikOsm/izdlK+UR6khKlfXGHBSrjVUqH2gIc4odDx9fW8EU0QsyfXV9550n?=
 =?us-ascii?Q?RdW2g3bCfjQYi8v03KpRARB3YAXFeUgpcykOMqW+T35fF23qy56mWFSMMUcV?=
 =?us-ascii?Q?xqS199MdJbS2phCjlJvyZJnklofIQpNtN1ue8c4SyUERlzv45JVzTJXLTAVz?=
 =?us-ascii?Q?Ye/Z0GNaWMA1uPqXx+mITXC7wWsEIsxo7APrc65YGJjvTmqke+y37rV24WXE?=
 =?us-ascii?Q?vl3caYf9E13OK6tL3xtlTAiNdw0Ix3ruExoXc5Ld540rEpLuqGx8b883vK8Q?=
 =?us-ascii?Q?tmftMhVQeVS8G0seOLvD7sW10gb01Gzg7tHB6hJpbRyk6+AXQxgCaRQnrKwh?=
 =?us-ascii?Q?w7OXsPoG0jxZdERyN1UOcV9cHUTf9H07LQs8Z8jV5sC39vcS8i6nNknkNcP9?=
 =?us-ascii?Q?WBzO3/cHFJL9Et2OfMbsPqvOqKU/dZAOTIyAvgYlHQ0+BGNrgFvHL13fEy4T?=
 =?us-ascii?Q?0NturaQuSpg/Ll3LsJHCYBTo8F7d3SfeRPo+gEKbddit8AlAFSKpEDUy/B9O?=
 =?us-ascii?Q?MTqyIIZ9VEe0cyNiGmLqYrsiMQQulaYYGdUo/nojWy3uV4I1+NI2l9aS4TyO?=
 =?us-ascii?Q?OecO4Ou+A+HZEK2Y9CzjiBCjEpZp1oEiZK75b0qNFE3icilcfWTxnLxYzmRu?=
 =?us-ascii?Q?zDCnnwfg5G/3pNUx2oTZRyLhSqNNKZ87kLe146eZVO9CSAwqt8cN/Tz/89Iq?=
 =?us-ascii?Q?sfOkLnmqIXHm3UlSf2hsqQBCP+T6Wb4J+sypml4gzGqL2xZ71+4MS2b5qFZr?=
 =?us-ascii?Q?UFIdOMpm4aRQZox5Mf4eA0YjUHnMJ3Jy5P9dYF3WJFYRQ4IJFkMRRUihslJN?=
 =?us-ascii?Q?DoFbn4oxoG7sXRpZyH6b0DyuHEDiNIznX50gLdtual+cIjpQpm1bYp9oLVKj?=
 =?us-ascii?Q?/LHZu6ZDFKv2N8fOgWs0pTdNf/brFizalrN9s2WxDD+uEv80YvHLO2O6teHb?=
 =?us-ascii?Q?Bc79dmJSlnOm0E589HppsvnPJuI4cBUZto9ScfWsyeFxdSn1+9cUJjaTeO8x?=
 =?us-ascii?Q?wgwuGWfktPncxCkYRpCnN+HulZDfsaqpKGhY60w8SKPXyTcDvoyMF6jEB4NR?=
 =?us-ascii?Q?kGMwFjjtnvb6y3LY3EBzNwrrle3dOkBNekY862tMVx/vl/XAg2bYNNFCD2Df?=
 =?us-ascii?Q?U8S2U2meU1gqFBx1nFl2S8ctou4J/cyN8r2TVyeg7hcczhsyMxPuPvJ8g3PK?=
 =?us-ascii?Q?7GFvED4YBHYqcODwdSTSGJGc/QZ/y+gUY+sGKVW00W4UAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tD935vnTndyhOMmtB8sscBT9O2bxTCK8wwCbzYlWZk5lCzH1VWHBV/wYx7JS?=
 =?us-ascii?Q?AxzNy+b/67Plvzn5X2fvfzRqQAseOH7caeak6EZ2JwCikP5nCqcImX9LAaBS?=
 =?us-ascii?Q?fK6KxF3SQXicJSNWgy3RQHMFbf03GQlxCw5fd6pSBZXR5JrpXUrHZPAQnkHz?=
 =?us-ascii?Q?GJff0Zji0DlNkHZmyT6PqfQkg3LaxXM1RUqhMTJVusr84MGUX69CZ4dv8oTW?=
 =?us-ascii?Q?iLb0rIspTD/THOKe46xpSWoVNxEDn+YwR4crWnCIjk+lXMmHsRC4fTF+4otg?=
 =?us-ascii?Q?u6WTQ43lcX+4miKaQz9NwUUUu3UvGeF28ySKLvd51ybFws7cz9L7shKl0ULq?=
 =?us-ascii?Q?GttNO+Tc8KZz8+79y81VCVeFz6p4wCScpZHnt4jYpweRJ6xVYb5I/tTK1tY2?=
 =?us-ascii?Q?h0qvOBK+EEsCkCh5mSmA5ow1f3PfLELixxDdYFbE7D5vWz3umxsNWdBxsGK1?=
 =?us-ascii?Q?rZFioAOCF8IwxUtwkczqkR2JaNGmtcTOWajnl1UOtg2w262m3tI4+OQ0iulH?=
 =?us-ascii?Q?8odfw5/aDZLptrwA4E6xdoeQvSdnjfxQdbL0V/5KSL0qR7+NDKW08X2c5lDK?=
 =?us-ascii?Q?9Zf4+6Cb4LFC0Ib3pOA2OjwkmEzDB92dX8MK0ZZfDXNf6eQwKO++AzvmTnoy?=
 =?us-ascii?Q?boXS9uZPE4Otg6qBi9R9OKJDFOSWr/1rnx+nYJ1x0D9SlTkuNVbB/Bm8mFKH?=
 =?us-ascii?Q?dRgO4vxu8Guc3kWWRBFEro/XdfCUH/DDBYd8us5YQZsDZ3SOjfAaWJjnTVvt?=
 =?us-ascii?Q?sJUZzHrYhXGdpVnVYQXGlGpBiUCVhUvMKhRGnjnBOD/1lW5G6xt8jpTkQsxc?=
 =?us-ascii?Q?8bA4pFQ/pgzx9AK9+7824fQZAhErR5ylnkrYbPscS2VmAs6iXVv3FudZnwyX?=
 =?us-ascii?Q?9JgxftYi7rLspvqZvNEpoYTqzAEOvHAWtoXm+bExNWus5IZnpHPeWCkZjrBC?=
 =?us-ascii?Q?bF/YQo7ce4QvJWl5t4MsIJl+ythB9X/pHfSwdBzVy9pXyZvIRCrYreq1ozvx?=
 =?us-ascii?Q?KBu2QUoMbg0JcMLloXZSt6EMc+ZciP1oM03Xlh/5X/0IYMCHuMsNoAPY5lzU?=
 =?us-ascii?Q?+iwEF4jpZOI82IIq7+0FWgxQBZ+Z+Z1jl475pNCV8BRIxeBFpYOhANFhCkpK?=
 =?us-ascii?Q?WQo1ZrYEnYR/8icnezMmrSQC1PpQie4mtXaGQgL269OA7CaZZ9UdVaLrFRJc?=
 =?us-ascii?Q?4jyr7MOpnMiqGeHhmvKdRPRaj/ckmBqoYw9BD823QpsIpuZ6bO6sSaBV8MJ8?=
 =?us-ascii?Q?JGzIt+r5n9HU1LVUowYH6FNgOAZeYwLAHlhkLzn5+sTkygHSvZ1rsyizVCGX?=
 =?us-ascii?Q?WaHxVwJMcg+Ru1x1jd7pyrP27/aqEKRhR8xKaWbe6Os4oTYw0MuFMQbY9/m3?=
 =?us-ascii?Q?EuaY/x5YJ5ONixSJOW+mrqxIOnFCNoANATqI2ykFAVPfQbvtk7oPF0dIdEuZ?=
 =?us-ascii?Q?K6AqFEe0XWEHAE0ebgo/rnk1k2H/0/rY4O/pN3dkc55bWLIbQtWZFd5xS6Z0?=
 =?us-ascii?Q?83CU1MW2K8v29D7nbrkx3Ca93N/xqRBFHJuxJS74heziIzY+7VMDfM8RhdDA?=
 =?us-ascii?Q?7ePUMGRdTaEFZna9IaVJRHJ/51Hc4uifOR1ck9aZLLPnQkCaa6gwSFpn7Om6?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VmBjoeO0ms5uFQ6n5byE+k5n6GiBset9Zox6ftAL9XDNh+ZCvZRvTvZvArWDO02pBNHqLlxjyacZjQkWfyD4UgsVe+zI7bmMs+H8kgMAFfkvjZUsBPVTDmZU7SPUXvJDcOlVyfqSaWxsp5+TFxw9jTMe7/WlpLfvu2KfpCfa95lcjSN5kub4Iwxp5I4Efb43jraxbjqS+eclV4Fqm9A88KBPrLE3AEVjB/YDT/lhayu40VSLdE9kqKNrlFdNUwrqHDP/665OcsiwhmotV3vgpDZXARvaEbqutWz/DsJNSfPDvGsp/xTEbM5ahnjpRN5Ay//3/09uQFtprtSVJeBWveqZnuNsj4OzCdcUgU4kU0XJyj/s8u+8v3GeHjxz8xaME1SHvFSVtRvdSNMPAjy0AnLAaH681ZpjoubtThUAK04d/FAy4nejVBTFJLi2kK2uNySBKGs0jeipRnnk+YwHy73C0PZ1K9q67qgZVMuAgRX5s5hFdoBZrqIVatUqIsTl3qiDyFz7R6NsFsexe2G5AXDASks/GxRDMk6KJ3/PRI4zZWkXGVswQ/hSyCMb/4m4GrsW30Vq9cDIYgnjsck+zm5j1Qtsz70GhhnQDnapRJE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b05064-6060-424f-bbf7-08dcd67030c7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:12.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3s3cRgqBFJ9TatjtCMKKemM80VnBLq89LKlN7of+ic3kAfANC7L3Vh3fFWzOvs6Xdks/7WN17dpc7N/lYbj8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6320
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-GUID: UnEcdZCKzFH8YNF3lRLXlbGgnljx0vnn
X-Proofpoint-ORIG-GUID: UnEcdZCKzFH8YNF3lRLXlbGgnljx0vnn

Add a definition of RWF_ATOMIC when not available from uapi headers.

RWF_ATOMIC is going to be part of Linux v6.11

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 os/os-linux.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/os/os-linux.h b/os/os-linux.h
index 4d150311..010a8291 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -328,6 +328,10 @@ static inline int fio_set_sched_idle(void)
 #define RWF_NOWAIT	0x00000008
 #endif
 
+#ifndef RWF_ATOMIC
+#define RWF_ATOMIC	0x00000040
+#endif
+
 #ifndef RWF_WRITE_LIFE_SHIFT
 #define RWF_WRITE_LIFE_SHIFT		4
 #define RWF_WRITE_LIFE_SHORT		(1 << RWF_WRITE_LIFE_SHIFT)
-- 
2.31.1

