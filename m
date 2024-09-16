Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496F10A18
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505685; cv=fail; b=n+ASvZfyoxPM8F1oBG09VO1gtQfyTQp/zB74w26dTItoFcRXrc2m3s41iT5x7UxEhBoNpMLkTnVUZc9rBOEXw2/T6A3Jz3dIgdzmCJdRkOCbfWnXLaTaw9sXlp0qQ1T7lpEwtj1gw/KgpxgEOo9bQ2i0JVim6/ENKfWC4wM4tjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505685; c=relaxed/simple;
	bh=Lb558uxjQCOuYIMcqq/P7ljq5qJZdks5m9ayXYWnRTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bkbOnw9/xLiE7OhnzEgvYWqUTKo0yJG1s+TM1yD/gRBlDg9malGV7A2xnkQGQ3+ux7BGw217bpqEJHT5H5p3eSb99y+1zH93aehERn7rnvVcVi3M+xz8/N8JdKhZk9q59FS7hQMy/orooGUKog78Mfiobx1tyOPyMjzuwzEomuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=conxfK8b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iGlDoiEb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="conxfK8b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iGlDoiEb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMXpi001444;
	Mon, 16 Sep 2024 16:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=GoIllbNzQfUWK+fd/K/W1SmK5vus4uYI/irXBjqYIT0=; b=
	conxfK8bBouTti/K2bDjddYR2x5uJ1xzOQsLBx0CbTi/Rp+tdkCL1XxSPbMDim5B
	9/zpU0N2d+09mTfZYOjLOnrzzsQ7gudlWskdoNAO6kpoCPpDeXeCgXXgCJZOXcEv
	5Ms33kZHn4mP9DU5EffFwb95r/S0BiWQcv3GnrNEbXjQpWFelmQ8n204Q+G6oJSv
	5SzRIO6vYZbyMsHY76g4t56IFE+xRLPQrqcJrsN0qMbPhbV5+vTRnKr32xHpZ3pb
	ZgXSt91T9bGhnsAEoOLerJZjFyjTrRmvyGRN3v2OcxNzbt1H41kOB5R/ncFhkSin
	uv5GuMkwk8YdTL6W7eRCyw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3scuwtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGfshh015002;
	Mon, 16 Sep 2024 16:54:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nyg245mu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/AINXtMPVR6+rNdqcOJjWo1zMTSYrKcfhlAk/HwKOvqQEs8ePBnFWgvtM4Rp8GoHIml62FXl+3L45ibPsJaGYF/3J0ejzIjw7ZvQn9JMyqLXKK25JFcyJZYqhk6zxvp3aOvNprVMeqWMpnwhvUG9oZOwMEpZCxrk9VfGJpxXzo3jPR30XxHcgeQJuO1+EBlbX1a9Sm9V/1uTQGC2XpAQaWcoogOouEj3Ft2uv8oo3EMdc/bMlDy34JVxmlFKxU8AqMTObckNxWlQFp4FIHX8OC9RcuqzXFxwSMX0h2sArFKWuI4QcbSEF4ScL7r2HZk9VfUw2eZAyvlNOWB6Ginuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoIllbNzQfUWK+fd/K/W1SmK5vus4uYI/irXBjqYIT0=;
 b=KLSm9ZxIQnuevtLryvfq5qrTC2FJzF+eZdvI69b9CxlZqXodluHS7znAbe4MCz7hkTJQ0p+ew/jWl8rk+mR2tl7VlJCog9barRN9hc3dH7oUIpck025+mLcN3sznjnrMurKkoXfy9NRKNSBCsqfobrTVvKW/pxebQx4ytUDHpwVg4feNCAWL4kIYfSHrmzn1EvUjzWnROxHvLGsLO0FOb2Fs9zvnaGLAzdWB5L7cC4WfRFTmIJikAoAMJyiM1udv4Tjh1SkmcizGgMCzgSz3yvWtR1TH9GRdDCjGuvaZESn47zLOAOj1f/qNRDadpdWjVIIVUoabdy2GyxcT/8FWXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoIllbNzQfUWK+fd/K/W1SmK5vus4uYI/irXBjqYIT0=;
 b=iGlDoiEby56ZSAh0So5FXkrdmNpcT6Frr4zt1QsUq4v8gUCYOtgGlIQdfJpBOeMOshb8Te2221APM5tfHE5sSTqoxGcIncRMIDJbVoBttic1ibd3b7BxCwzskmR2N2gkpsrRxnrFyjZvHilmiLYY7m5l7I4LSHBkdOngul+lbKM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 7/9] doc: Document atomic command
Date: Mon, 16 Sep 2024 16:53:45 +0000
Message-Id: <20240916165347.2226763-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0378.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 208f752f-45d8-4b79-7e01-08dcd6703d0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KhKkYZ0QoWpp1uqW5o+RM9Jg/3o69uPhv9eG6zhn7KkxiwlB0fy5bnBcpTWD?=
 =?us-ascii?Q?10xStT/+zoJIEvRajgYLorD2WKxK6yRokjrZxxWpTNtV+Z1WytvNITwB+EXq?=
 =?us-ascii?Q?E3cV2AXsKg0f9Ycu6C8T8qobf7byugW2emHqwbGctOK+tonJ2PX9O+m8kn/b?=
 =?us-ascii?Q?MYCXN5ExPNZHvSs2BEwHWcR2shrCBDzjGSJPfgL9C6uvTrerC/EdsXzs3po4?=
 =?us-ascii?Q?5bN1SzbyWh3ewSV6ibFOU6JNw1n1zuVP72CbWZ7ebDFyvn1X87iPtImDP9Yu?=
 =?us-ascii?Q?howzn6FcrqJtF4wcXQMTP4KBEtO2h/XhIgJb5r5Ume93SfMb7vr1IT6ezZew?=
 =?us-ascii?Q?knfn1K2jSfdj9NXzDgp/h+ommeyfxKpfTWRV5IFscvlvFjBJMoAqdUf2UCYm?=
 =?us-ascii?Q?kFzuMM7dtIf02ICPSHSh4N3t0Z5N3Z6FZ3CvWcFUrRrB9PYVj8TzvskioUVk?=
 =?us-ascii?Q?AR4orp3tud0dssKL7Xo46GyiU5DbdWxSTFFQOHcsvG6Rbweh46b2oKLW562A?=
 =?us-ascii?Q?ToDN/ICUJwa1QnOCxg+l6q4oaRtVXY1ZRh8CgdfBoUdvOOtxRJXg1gO34lPc?=
 =?us-ascii?Q?Xhoh4WxpNW8ILpsbEuqz6dHsVL3Ppx1zxkwgPEsVAr7+u364NlnB8sCOoMW2?=
 =?us-ascii?Q?o77x+vnnEZ52C+GmD1Y8TwKsWiHjKn6g9xIk4RR/SS52lBcIg7N+Ti+tPg8P?=
 =?us-ascii?Q?WiTir0UpXXmzwWP/h6/kN+qJCnq1VT87FZomuJs7sdyvXSiiicOIfGGWHi5B?=
 =?us-ascii?Q?43fh1j27sw9Y5VxsVU2gY1T8Uvn96w2t529Xd6ZDBk//Ygh1/pWaKiPuH8V7?=
 =?us-ascii?Q?s9szaO8ZtlptlujxIH/cugGdKEAQM5vHxPma48WlouMqZ9DXjGZMF/OHTau8?=
 =?us-ascii?Q?nXa4Y43Qc1BsSSFyaINXpzYYstoxuEJD7kTFZaZCegbb3KrLj0tahR1DfGxI?=
 =?us-ascii?Q?iC3j+/czG2IOS2qJ01MH0D/oYqAF10lLwbk8UAFhTn7g5CmUNIL7FFIu4ZU1?=
 =?us-ascii?Q?kP1GVDOmSHmSB+5pQCIB10XL+KFS8ahbz2G0zvJjDOVBT0fTQyo43ikNg4bf?=
 =?us-ascii?Q?qDYifJMPqU2OWP0iJDp1u2rq7KFXcHPmqpDfb15pxGoidpuxWByuKe6YDzp7?=
 =?us-ascii?Q?Hhh+XiTldWQZ9/n2dQmmCud+XDQfsVgpqVEw//A7J6Vp1BrzQtMaiDkVN2ib?=
 =?us-ascii?Q?Decn7zh+amVYpTzRNfJ6dxzuQlL7YoxWYQ17v0p0HiH2y1PSF/iGrVJQbhlT?=
 =?us-ascii?Q?a0NTmIdpzIit3Z49/P9ZJ03D/tOJqWsLhk2pp5uz6GqC0gmTtX/9Gi7+Wxwd?=
 =?us-ascii?Q?6jV4g1JPkdbhB/L9QH6mCsu12qo3N+ve8axQdFRi1GyyvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XCJGTW7gSYlNyoRFmqJMRktMb8MkHUr493pCXV5hGfnat2/eDtKOq/IYzsFB?=
 =?us-ascii?Q?l1DADrw++q9qRz+tSPvowzjgee+2Tqe/842xw4Ff9+b5159bcvHVp6BxCubE?=
 =?us-ascii?Q?VMVppj7Gnw8EoBmEZohhE3k/Iy8OcarpSbFAn/Mc/IJ6TpVyeo4ZdDsezCTW?=
 =?us-ascii?Q?+fPxcj2waa6de9B5KbvVmvMcR2X9+zzV8clMP5MY0h43Zq2S/1mwkTaFGjl1?=
 =?us-ascii?Q?qLB2oCpdyNSzaovTCY3crw/YiQGYcMmPjQnMY6WUPZyMyS8b0roxD8eMHb8T?=
 =?us-ascii?Q?AwH9ZqG6H2KdIN2D/O913f89/uiwsV7/tzIJ/vKD3xMboeuN5j54Tv+xcJqr?=
 =?us-ascii?Q?agDlHgZSORoPjWri7t2gOkRIyxA1E/GmlyrrBzSaGIAFi8D/36NsyhfP2lL/?=
 =?us-ascii?Q?BjZLwjR3tSGguMMrimxRJVwbxgOvVYi7JP7/9DeT86idIvzH15uq5AXF/2ue?=
 =?us-ascii?Q?7lsPPQXp3F24k2OGPJqRvY+XiGIHUeA8Q+zC+Wfb1U3abZtU/j6r6f2mfXwL?=
 =?us-ascii?Q?+uKhArsMApzootbj/DvdAxlR9mojsO5wxsabSktsYugKykVCVe5Jl8QPSDJB?=
 =?us-ascii?Q?GfxJd0zHQtWIU2ODYiB2EowRXpvIcWqTQuRh+Dicvigj0leZRyUk/XO25YVz?=
 =?us-ascii?Q?9P5jtRL+4TTCqnUkdlS+z46fn3mjMqtH0UOl9YpA+kJ2AAvCrKydA7B1t5NJ?=
 =?us-ascii?Q?r6I1NgFzNmGFstrxFmMEo8H2+7j3ZJhy0QoPXgBgnhOActvaHYpoZrgrzVDL?=
 =?us-ascii?Q?gcXxX1VkFiyJMsjWQ8ubDR8tfBTg0QJgfOzz7akP6qg7om5/wID3p18uZoeS?=
 =?us-ascii?Q?q2BF7XJ7LBAj74Ujk7gdnlRoPQrCygW2p9y7cqr5v1TbY7qdbPZ9NJvqk21g?=
 =?us-ascii?Q?fu6PBGVlQgVnKyxBk/uqPjIcgadV8e8ozJot+iCMS2KzHb/5WPUCGKYXwnym?=
 =?us-ascii?Q?ExA3duQMJPccjlH8yI8vqpRC/LxEH/J4rtNn0xpPZeCKNUvYS5aKEAZLwf6G?=
 =?us-ascii?Q?PGuKxXaIEw5tbNnIgfag/dgvJeUPJbplNhunHrR/5wJ3OMmFJdpDmozqLBXJ?=
 =?us-ascii?Q?Z2TeCIzpJn6wqf26t7rsrHAeTmrNzVutIuJFq55sxnWYWWcDprjLBwN+rGx8?=
 =?us-ascii?Q?Fe1vYSMBokjklU7sv6YgbV7MP5Of+fPaI1amTzTnoMcIfzd/jHKblhQdaDmW?=
 =?us-ascii?Q?DTz6NJl0/XABRy4sF6fXbZ9xnxkZSizR+1bnRnBhAU8VlwUp7Bdf8S5IoF4V?=
 =?us-ascii?Q?2XMEjEId0LOBYi/jJddPOip3UPofF5wfn9ZtiQhWYZcIwAn9Bml3hqrwMbJL?=
 =?us-ascii?Q?2/12xt8c42isq15B5/zcWCdJRg0bosSGKueJ94rzI7wZSeDay5FFm5I10Im6?=
 =?us-ascii?Q?t6S9orDpt0Nv5C0LuflWSbfyQKyIx1/KxRa6N5I7kiGJpUwBLRvd5/23TYyX?=
 =?us-ascii?Q?kq69U7SVuJ/El8iMT/T/qDcl68z9NIWzJElJqGkka0+6bkIdad8nDAX1CfHv?=
 =?us-ascii?Q?1wQXHQqzGuhhmXsAyzNwObtVL/yBWmS30FSsSVz7XIEG78mfjApKhmeEUugu?=
 =?us-ascii?Q?B6NAd5S8nSnHuTidDphs8oSJAm7WX/17DN3wDtu4IeySLadNSgD65bE+J0uo?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hMvjCENrQkxZ9kfsR6q8P8yb8DEIZlItgsMh9A9wZSG2cDa90Wy94tzKyDnGG8cmSttzoBE7npBef6qFzhyGIL5vok2IPcni54Qr97TPrn2ElfBEvXu2MTMvitT9OFW2tuotkKDtW8wWKhyELvDOSpFVM+CNdGapp49qcCDaFsXuIeGcULSupVGRJkZzSxIukQLTOXIJPqSswQPt6syiDoXX7CQ4B5gdqITF78dt6m/kA/O5CZUgje8X/7MCzQ/b5zUaK7yhjbFkLpih4TMgPBeFGX03LYT1L4KsLFEn42rXR/LGzZpwvj0zd1qFI3tV0rzO/k7hNdat193+GinZmXXWObUHdnBUBtoAL92ye8Z6UpvtdBF1CCr1Vcl1zjuSa7jjygu39bcTZBFogQbJS+HP4XbZ0WOKyqP2wN6xfacno6nJRS+bNoJz+O7z3q2aS6bZNVR5gbtaCuU0K+pf1EsxPOdO5S+TkPEtqi0pJTcSJM3eJztogBrsqrjTJGaLoItjiBySUocu83WB/2/UbaE64sNkNiW/pTZ/QIpe3ophsJEPt4XlDOwxeFWs2UEKn4AhqP7n0oOmdUuC8zeMpePp8DD1nytZIsrbdtXrLXY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208f752f-45d8-4b79-7e01-08dcd6703d0c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:33.0520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4rK0+mC3p/T0TZtOMZSTili4aFWaDHzzprHhC5TCvXtJwiNI2Em3NwyeolEX2/ZqQFm/PkjGikTfUoJLQIt8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409160112
X-Proofpoint-ORIG-GUID: v8K8uM-DNzhflRqaVTAfrH4N7TyZgENm
X-Proofpoint-GUID: v8K8uM-DNzhflRqaVTAfrH4N7TyZgENm

Now that the atomic command is formally supported, document it.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 HOWTO.rst | 14 ++++++++++++++
 fio.1     | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index a363206d..c6c9b306 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2501,6 +2501,20 @@ with the caveat that when used on the command line, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't required,
 	file blocks are fully allocated and the disk request could be issued immediately.
 
+.. option:: atomic=bool : [pvsync2] [libaio] [io_uring]
+
+	This option means that writes are issued with torn-write protection, meaning
+	that for a power fail or kernel crash, all or none of the data from the write
+	will be stored, but never a mix of old and new data. Torn-write protection is
+	also known as atomic writes.
+
+	This option sets the RWF_ATOMIC flag (supported from the 6.11 Linux kernel) on
+	a per-IO basis.
+
+	Writes with RWF_ATOMIC set will be rejected by the kernel when the file does
+	not support torn-write protection. To learn a file's torn-write limits, issue
+	statx with STATX_WRITE_ATOMIC.
+
 .. option:: fdp=bool : [io_uring_cmd] [xnvme]
 
 	Enable Flexible Data Placement mode for write commands.
diff --git a/fio.1 b/fio.1
index a4ab07ed..6e5bed9d 100644
--- a/fio.1
+++ b/fio.1
@@ -2266,6 +2266,19 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't required,
 file blocks are fully allocated and the disk request could be issued immediately.
 .TP
+.BI (pvsync2,libaio,io_uring)atomic \fR=\fPbool
+This option means that writes are issued with torn-write protection, meaning
+that for a power fail or kernel crash, all or none of the data from the write
+will be stored, but never a mix of old and new data. Torn-write protection is
+also known as atomic writes.
+
+This option sets the RWF_ATOMIC flag (supported from the 6.11 Linux kernel) on
+a per-IO basis.
+
+Writes with RWF_ATOMIC set will be rejected by the kernel when the file does
+not support torn-write protection. To learn a file's torn-write limits, issue
+statx with STATX_WRITE_ATOMIC.
+.TP
 .BI (io_uring_cmd,xnvme)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
-- 
2.31.1

