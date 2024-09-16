Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF515ADB3
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505687; cv=fail; b=Ij9udmAFMor/TfOkkIWpMGJdXBTEq/nKH1/f3kAqb2uEKt0gr2yBY+y+j4jgiu2Adk+wJcJiWcVZdF9n5sRW4rmm9zfmSwJJ4x4JOnGPXlI0OOMP0UuiXlrZQZ2NljqQFieNKE1zH6h4XxJ357pNbBpTVxeX5DTE81Oow1kNRP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505687; c=relaxed/simple;
	bh=7eXQ65LCJXlKCXfSqzpzWEwK8WCP+8X1U48kox8w5iQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NZNF2JoHUkn0rq3Qx/orAmH3t90esrE5n363oaZfDe/qeXCMV0r7hgufwdtzG+PT6EOcNfsyGMzWl8dayzG4D8gxbck5dfWHNtRz5ILQdIgPPZ8lwYa8Np0STK498KuuZOuiBeIyGqDJZJ/bjcv0vmk+YSQUcu9IAWQc/usgXek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LDTcL33g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CQv2K81W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LDTcL33g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CQv2K81W"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMYTo030175;
	Mon, 16 Sep 2024 16:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=w66qFYpuWylwoZym5PKCdjb5UFJOGZjaLF1E+GJmO6E=; b=
	LDTcL33gIerYrb3+cqayHu7a60cA+CtQYagN4wPalpxuq6zMxw7rVC3f91upyZKk
	om+DMxNfBL0OacLVIzu2vxLhlVGTC/O/hJpvI6YpSMJdBBChi/inh2yKaHuAYpHr
	xYmTLfIzYTocbQBpW3dwtGWkJAhTAOFWTh4cC+huirVMCr3JOG1TaTprmvBbCJyF
	GMm/LNxOLB4WCtb28WE8oFsGtA1eZZoZyDAlBXsdPyTG4iqQK42eN5h7VXzEch79
	Xhz5zQK43JzYIXDgccQTO1tEHWWvxYjPe9b+i2EW1K5bkwErH+/Ts6r71zK8zKiB
	aN9yiY11FCcU7z2oCbjS9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3bwne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGfshj015002;
	Mon, 16 Sep 2024 16:54:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nyg245mu-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cJuuQGMpkoURpZiGb01qnuqElhwcz62P4ZQSJOg8BpusbrLe5UIL6bor9N19xIPgedinlnDvI8GJBm6tlFvOVRXTPKrMwCdkUkx3lzvF/5WU2+ucHhC4coNAw3UUv70r1ewAIsFhHyS+6ebxPm9jV1rMXv+1w9/9fTuPoP0/V5kJYY/7atskr2hpqwaJSe8Rnf5YnTv7nuCaY8eAeAbss2+BINNBRfrHK8Hd51Fy2SWFX9g+wuj5kmbglqQ99MkBFSXvZFX4JA2mx5qGGE6AVC7fKivRsJdnTwX5Wm8fDdu35ctTzqvA+/26jzjSO+GWDgcdf15N5w9WGc/sifwbmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w66qFYpuWylwoZym5PKCdjb5UFJOGZjaLF1E+GJmO6E=;
 b=g9P5miWrtfzcv48Qvx2IwXv8Mbw0eCdu/tg62a4F1t8THSykQm5MfCcJt/1epk30Q1+OxZw4zvFVl7y2z9rqCNG0he9UdhogO83WrDozVhm0Db6o4d2OpbNjDpTstPWKxomBK2ggcwE3gAezXAnNySygG0IBfEpdnjWL6EOigdrGDcnPZBebWv+k6OJ9ShNF8yjsnxXC5Mg5Ept4IQ4VeVeIwqfiECFsJDgW4E43iOfyibnbBlsiXpNKb43xc7XRg/6U1CDk5Q/CziMvrNGNEAjxcJP/4X0nmRIyEOCNDJPn7GADYQ/9tvu8qV2X+YuxMc8RwwVWRCVJFRUsYsQYNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w66qFYpuWylwoZym5PKCdjb5UFJOGZjaLF1E+GJmO6E=;
 b=CQv2K81W+XaJsp/tGbD6Vq8sCE+HSnNVi5ZMiEQTtCXH9/odFU2doCgcjZ2CWgtDnp2/oHXVOc3TEeA2URg9vCz9u7aKSrmyKVuNPd81EeDuqA32ISkVgqubQbDX6DHjBTs1dxJXKYAQW9jdSuIdIxuTsyKubEnhPC773dUS/xs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 8/9] fio: Support verify_write_sequence
Date: Mon, 16 Sep 2024 16:53:46 +0000
Message-Id: <20240916165347.2226763-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:217::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 469a559e-5eb0-422f-d5ae-08dcd6703e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dg214AIos7o+WicdWpHgH8wLgUq6mNNsXjQz58S2N3O8WBqtBnbWh0wpxWGV?=
 =?us-ascii?Q?PfvR8kBT/oQ/kALKFEYFhnNyWMYfJizy+t5rCpl5vvM+SWiZmpIl28JzryET?=
 =?us-ascii?Q?z/IxptG2yJeWxg4LlZZ7/kpiXq2abBrIP6B+Y8SZloIfJPK+V/IWjBtf/h3S?=
 =?us-ascii?Q?0Ds2v875lVBnCHV30G2ZtuTp9wDztGK53WOMzNypMf+pfVWlwNh9BWcwtij+?=
 =?us-ascii?Q?hrLv6qNLuOSnPJYFNd7FFUbRCJLBzrGZ8Koc2RHJ4fi/vSsJQZXdniDPspvR?=
 =?us-ascii?Q?CtLGNANdUWEujeWfUbXi9AcRQLsmWxppR15IHMcxd/IjTZj7STm+qH3aipp7?=
 =?us-ascii?Q?0JSC9CfKbsck+q51h2JRTp8ULicg0G9RWy8CVYc1mnoFun+mt6/vizQ61R9a?=
 =?us-ascii?Q?0G8/KqOM104QMoJ+CJ51GLj1Jmzno8dDQGZPQDijO/heOndYZ57Esamjuq/m?=
 =?us-ascii?Q?S3a+MRv0TfNVO5yDx1o2ZoCZLl67dfuD6SM+NQ5pZGfDtgvm+7SmMteAhHO7?=
 =?us-ascii?Q?P2ddjT7JKrXQyH5AGdWBu8cyglBC1/haiEpY/k/l4dBoQmzyAkmAZ7eej7ka?=
 =?us-ascii?Q?NQa2juGE5I83skajUFcICiyeNw2eFeFV8XqJVtz4THKcKAT4LHV+v3BOgtbJ?=
 =?us-ascii?Q?w2hsU3HH2PrrUNAri5Jeyy/ST7NdnUn/Keqi93iVQo6aZC21CwGmMVcr+PUM?=
 =?us-ascii?Q?AXXvlXVNFL73zqQt6Ghq/zfa0+NNsRHSRfb2wbGTwbJaS1Dwz39P2fjAxa9Z?=
 =?us-ascii?Q?D9VxW2yGTuw2PAf8bFSxjcBAND5l3izWSUt6MkhlXx13zRmn73WINYU6bv19?=
 =?us-ascii?Q?8umm858FC5qJXFZMRepUS5KIIYPladSi7LHg37Fkw3sBnDr/UyftMOtDXsEy?=
 =?us-ascii?Q?HRH1Be/yNQveF+BUk3wxwMoj7N/YMH55fbkj5tNK4MpThR4pLgmxpCSgy3M6?=
 =?us-ascii?Q?FJTxOm/WcOSArog+17636+rw+VVXtZevjycumyErMCaieYzmZRdfE0IYEbDH?=
 =?us-ascii?Q?F9sCK9fYkuTALjcPAM/VchKJEuEZ1i7wiPJFVonTYh+VOR+P+8fYFb4iqGBd?=
 =?us-ascii?Q?ZQbRwEdpVOXukjRIvTB6iFCyFEm0kwgKuKzpJ664CsMzRkbEXwkRYwj+EoNR?=
 =?us-ascii?Q?Jpt0pRV/UC6nZ18oGqz8Ggky1GlYA97kUu+UmyD1wpL07lGf4o9XghOR0d45?=
 =?us-ascii?Q?0eFNMnnvx484akkH7lKPaVda9mAK+7jnGFgeyR0iTeVKpBywHpz6ckCkHOPn?=
 =?us-ascii?Q?QscoTQEs3ZJqGfoDATi3xYx9zyFu80ZCknxGnEtq+s2wN/IyXwQ8TnOfU5fM?=
 =?us-ascii?Q?qw4HrTOF9aCeuo3me11aZT/ZVQAaDeqMI1wu+MXGM0XLKA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cynivi5hUeUDTXT9WEaULCQUgw63Hp3kW3/ShF4ttYQO+UcaDv2bx67sFFyk?=
 =?us-ascii?Q?DT1Exk5MwNZtPTODNCSWKD2eYh3IZFUl5xp/BQXxoTPtSeQdIzvcrLmPxQUW?=
 =?us-ascii?Q?vLJ+OpW9tCD2vV+HZwnSV+ISCK+8ImLfxpSEpLDvRgTYn5yLLjq2gfz1Kri/?=
 =?us-ascii?Q?eDftcr9YlntA/1zT3ZTkWjDdViic5xwXCgUiJpgOrNeo/yobQkLuAhf+IJ7B?=
 =?us-ascii?Q?x32xhjhUf3qxKUly+k3JNMRmWrpc7WH7hRXOtXv25caiRlcgscEjMMw+xOmr?=
 =?us-ascii?Q?6H37mhvIFzU3lhARr/aIDXKfBnrarjQmLcYhjAf9jGPj2sX7KmAcZu6BRXoi?=
 =?us-ascii?Q?9exdbKjSZ+0xwwfNhKdhpAUuyiq4j7/BLldBHXZAGoTPjfIva0yLCU1qns6b?=
 =?us-ascii?Q?j9P0IkVRVLahP3AD7JL7kUDAm8sC243RdHW3nsTbMDNtRTomThRQzywzzMGF?=
 =?us-ascii?Q?ttwEn/QnlJojlcw9vDb3uWxqxuCd1fDuT7Bqu9UZfDD25gFSl9u0rRcKOXvd?=
 =?us-ascii?Q?BOQ4wvgmi+ZdgJALw5t/Z5BzPVMqqTkJ6ksr3q5enTXIjNXGnVZ45hAHe7Zc?=
 =?us-ascii?Q?M9DmQhE6WmpJPB8EEbhgPXLW9X2o7U5pmMGsfW25jUi/2ALZO4ic0go0YEg5?=
 =?us-ascii?Q?EGjPhfevHsNGTCgbsYulRHHo+qjZXl57ppfaPUhVB3uVtyO4nuF92JR2BCNF?=
 =?us-ascii?Q?cWwuzMoTZ4dxDFJW1i/307PvsldtG/kC4EtDs6+FtwVsfPPmoqwvogp/cgtF?=
 =?us-ascii?Q?zuDDDpvtLX4eVlZFpDz6q7KGFZNCa1Q0y54WBXQ5PDz7LBHlwNpbZMagikJF?=
 =?us-ascii?Q?L2f1XJv5edJE0pRAQpWt/rNpqC+c3MZ4Eiv+FJhl/y7BXY0+40OyL4k+vofs?=
 =?us-ascii?Q?Y3k3rHmiSLl/DNbVLVjooUvTdCA7Anhc9WIm9v4JlQj7wVil6GdRdGS3dElV?=
 =?us-ascii?Q?2m7XGLpbAY0Z71qtsi1gFSkDcPR3AK32AhdvQnS1Me0ZCBzmvSG5Bs8dwyTC?=
 =?us-ascii?Q?0gUsPw8+ZGqgqjttGeEbhQv+2jXCXojdLDCqa++ETKbxFWE+Dyh/j9HIZqNo?=
 =?us-ascii?Q?hTFQxGpYNotYbzd55uQPOcC0o6L4eLJuXTgLIDAUB9GoIYBxnDSbPpr+UwIo?=
 =?us-ascii?Q?BoXgSiTIMGnvkVN529mU6XY8lT/rH4RWOWd7PUTfoxEXNH5ymAViFnMS5bvN?=
 =?us-ascii?Q?vbbMhPz5TgA/+1udOWyc9M5HnImR+r57Pq1Czsyx6Mezimjpi0FMRKzyaFOI?=
 =?us-ascii?Q?pfHpOGmDWrzC0+0EHimO0IynLpQaFJWIGgkBLTrNudOxuDgI7k2Ja8lLyZKB?=
 =?us-ascii?Q?fOgCUZ2si5osG8RJ3ds/T120r+yE9ZTtIs7mR0vhrd9Q7+3JA7vNLEfeCDvT?=
 =?us-ascii?Q?iBBklrDfH5mzihn3I+0xitDgSzMCw+MMroKxCQEtphIoNkjRs/DIZ+JrsqH1?=
 =?us-ascii?Q?EZoeKxP7J0Tk7cFokMaFcWQ64VvCvAYywuEvR63kNpZu5LSDzhnJYLVdXJX1?=
 =?us-ascii?Q?TBgJJZ7rUeEU0EHO4Xo1PjRv8PNqMpZdPKAB0dHEUjXXcBq/X/e1vYzi9Uzh?=
 =?us-ascii?Q?mC33u9rvxkJJN3wtdMmOastC3RjRkNP7qya8cEf4jkLba9jNtMBYFH84Q7O1?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eULJFBZmEdyaiZuv7mYBpMnI0hk2aIx61Ntk3/09ir74UV7cR64PtjgbE0wFPcimdRB7m7p+NQMQRoeVYfR2uQMfu3ybueqW+cJsGzSkfQjGmzr2P62nGzUytc8iZllCBdhxG6RPAlLiivKXw3MEERpHu8Au3fJwI2fshV8rVEZd3QCitKt5bzBbp1ClVKw1A0em4mCfQEgVBl3XxQrYNVT3yNYpoYzohwLA8s0QD6LESgBRQ4NePCTQRWMB/JXRY04QwAuEJqnN6FHLm3DZOvaJ7cDu3QszlByWOH9Y0JOD5/Ezo9oNKdjCfBHYV6NzV+Z+xBiyYCXZ9zJSh+gQnElAIafzvNsLXR0ZSaxagpMFMfJKbdZJ1ZUbeGp7S8xn9kdUSniXIPuUc+evNAg0rDpIdGrsH3gclCrmW3Biq68Np2t+4PWdVoPsAJRaufa7XyzpMCxpKfVkKZkmPZI0CvoLtxkBd+ff/EJvVNJn1wcmqvOODTfAl1w+AGRgnHZkyOR97GTt/sJMqT1NFAVtZE/X6oejh6i/3qm1qorxLfH3ROtJYvYoODwmFjBfHgyCWNP6JU0jUh5ll0LLT47fVg9K7E1JyLCWB/RtChYH3yw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469a559e-5eb0-422f-d5ae-08dcd6703e67
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:35.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xitEKPz1qJBq9OFludFR/blGN9WNLvZ8Wy+d+rJXyQiRVXyCAKaYbPcq+7WpSANWcxRQvqANGgzvVRHgHC1/OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409160112
X-Proofpoint-GUID: zHcKmObY_mhOejS-LQeo4ME00DwLwhSV
X-Proofpoint-ORIG-GUID: zHcKmObY_mhOejS-LQeo4ME00DwLwhSV

Add an option to disable verifying the write sequence number. By default,
it is enabled. However disable for verify_only mode.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 HOWTO.rst        | 11 +++++++++++
 fio.1            |  8 ++++++++
 init.c           |  3 +++
 options.c        | 11 +++++++++++
 thread_options.h |  1 +
 verify.c         |  7 ++++---
 6 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index c6c9b306..4f071484 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4002,6 +4002,17 @@ Verification
         instead resets the file after the write phase and then replays I/Os for
         the verification phase.
 
+.. option:: verify_write_sequence=bool
+
+        Verify the header write sequence number. In a scenario with multiple jobs,
+        verification of the write sequence number may fail. Disabling this option
+        will mean that write sequence number checking is skipped. Doing that can be
+        useful for testing atomic writes, as it means that checksum verification can
+        still be attempted. For when :option:`atomic` is enabled, checksum
+        verification is expected to succeed (while write sequence checking can still
+        fail).
+        Defaults to true.
+
 .. option:: trim_percentage=int
 
 	Number of verify blocks to discard/trim.
diff --git a/fio.1 b/fio.1
index 6e5bed9d..0fd0fb25 100644
--- a/fio.1
+++ b/fio.1
@@ -3726,6 +3726,14 @@ Enable experimental verification. Standard verify records I/O metadata for
 later use during the verification phase. Experimental verify instead resets the
 file after the write phase and then replays I/Os for the verification phase.
 .TP
+.BI verify_write_sequence \fR=\fPbool
+Verify the header write sequence number. In a scenario with multiple jobs,
+verification of the write sequence number may fail. Disabling this option
+will mean that write sequence number checking is skipped. Doing that can be
+useful for testing atomic writes, as it means that checksum verification can
+still be attempted. For when \fBatomic\fR is enabled, checksum verification
+is expected to succeed (while write sequence checking can still fail).
+.TP
 .BI trim_percentage \fR=\fPint
 Number of verify blocks to discard/trim.
 .TP
diff --git a/init.c b/init.c
index bad8b75b..96a03d98 100644
--- a/init.c
+++ b/init.c
@@ -853,6 +853,9 @@ static int fixup_options(struct thread_data *td)
 		    (o->max_bs[DDIR_WRITE] % o->verify_interval))
 			o->verify_interval = gcd(o->min_bs[DDIR_WRITE],
 							o->max_bs[DDIR_WRITE]);
+
+		if (td->o.verify_only)
+			o->verify_write_sequence = 0;
 	}
 
 	if (td->o.oatomic) {
diff --git a/options.c b/options.c
index 95567de6..c35878f7 100644
--- a/options.c
+++ b/options.c
@@ -3397,6 +3397,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_write_sequence",
+		.lname	= "Verify write sequence number",
+		.off1	= offsetof(struct thread_options, verify_write_sequence),
+		.type	= FIO_OPT_BOOL,
+		.def	= "1",
+		.help	= "Verify header write sequence number",
+		.parent	= "verify",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
 #ifdef FIO_HAVE_TRIM
 	{
 		.name	= "trim_percentage",
diff --git a/thread_options.h b/thread_options.h
index ee1e5b31..d0e0a4ae 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -156,6 +156,7 @@ struct thread_options {
 	unsigned int experimental_verify;
 	unsigned int verify_state;
 	unsigned int verify_state_save;
+	unsigned int verify_write_sequence;
 	unsigned int use_thread;
 	unsigned int unlink;
 	unsigned int unlink_each_loop;
diff --git a/verify.c b/verify.c
index b2fede24..f3d228ba 100644
--- a/verify.c
+++ b/verify.c
@@ -848,12 +848,13 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	/*
 	 * For read-only workloads, the program cannot be certain of the
 	 * last numberio written to a block. Checking of numberio will be
-	 * done only for workloads that write data.  For verify_only,
-	 * numberio check is skipped.
+	 * done only for workloads that write data.  For verify_only or
+	 * any mode de-selecting verify_write_sequence, numberio check is
+	 * skipped.
 	 */
 	if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
 	    !td->o.time_based)
-		if (!td->o.verify_only)
+		if (td->o.verify_write_sequence)
 			if (hdr->numberio != io_u->numberio) {
 				log_err("verify: bad header numberio %"PRIu16
 					", wanted %"PRIu16,
-- 
2.31.1

