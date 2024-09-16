Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7BE15921D
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505665; cv=fail; b=GnoKbUpsasClhDs0Sf37nS2g8CVnWkLuxm7WoaLfLX6L89ybHb7PlJNYIiEJ8pVcKC987pbCVb3y2BSN3Ex7+3mC8HLlU6IdAR1pL5rSu0GxySkmK65cp6VGbjV/QBLrJySqi3Ax7cOwmCfKYtRs6IFwkuxQvTwmjH26dPskkjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505665; c=relaxed/simple;
	bh=TxNDoFUSP+aPF1FdjiEJEBzV4lRjQmE0NjRAiw/moIA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MUr4Ks6f4KV7a7PmJI7Zcrjbh3ralT4JQs2i6dDy0UFLUUWSENRnhM+VezJPSt11UYRHGcdqThpoHlTsTG4hD0928gGCGbhzFSxqUqxX3sXvyljlGMTcPVD/ETpH7mIq3U7LMcoeYlzP5a4gvt6zgcu+IVUbgFzx/3SwEsF7kk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O7kaOVAv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Scq0r4Nn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O7kaOVAv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Scq0r4Nn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMYcS022226;
	Mon, 16 Sep 2024 16:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=PL+q5Sr1p+YXl8dClyrc4P2DWrB3MntKSW3gtCtTVto=; b=
	O7kaOVAvAMS0KyNsRXLJ9soN0dfGJjrVOz/DB7SCdAL0G/F/ahFhPeg9VoWV3mEt
	PVwyNWcazZasVjSbzta3G2br9Upvv7Dip66eRiuQ+xeVxXXbMJTFsrhHb3w1R3pV
	9q6qjBn0IIi27uDgHMr9cjcMadTNg3zDkQyOpqxYZ/X6GqcGdRXp2pQUo8mSSN8V
	sBjmU2H5jZ/LsT0JS1p4AGPQrOuVHAcd+ufpYV7HkPvm6JFOII0W2q5sR4SMLUyD
	vRziiP0a4KZY/NqE9atBZYv6XC7FfHsHo2dfZDEpalMINUKXpOqTDZI18pfbfGwc
	pdEipsGak7QCP08rxKflFw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3pdkv50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGVA3s008353;
	Mon, 16 Sep 2024 16:54:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nyfav637-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b9kP5aKUjQcSncPel67EEcvN7Q5e3Qlt6iOILvJvhAg8ST7XpPBGrkvJMjP4efRw77mj9kpwWARLRRdQWRipNLh9JfvE9MOlg2+Scn43nWy2czaGVcKIeocwycD3abpvROEOHG9IGfZgp0+V6YIizV5wFl3+DF9kUedoLpq/kKSdP98EVBZRBKs8bVgnabcoU6WR3bI4l1K492SNbCMzlNrbaeNsJzAp7u2/heYT6ymk4nP09DkNq1bdSM4eoB3drz6elhcoS/86+cRs5UekLElGniGRrwc5fhJS7ryRi1DzUNAgngp7or3ZcJ6lgFIooMMwohaDjPL849pkvVTjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PL+q5Sr1p+YXl8dClyrc4P2DWrB3MntKSW3gtCtTVto=;
 b=H+x1Y6lcCy5yTjTFBL818mhWzShtj/AE1l8xO1cr2Gkqo//blqbBb3euCxsEXB9sthgiikeAAoIA/YetTXum4fSgpqkcF5rfYuOeCCNWYdPgUOSLivRnw1JfiOblDyoPAsx/q8WM7fbA9q4AGpV6pCLpQ7voFaHvj2IX625eRoDvscTBP3wN6sgv41H3f4PnzARZQLtcdYGBWkIc1T5R1jgiFeZr3gQ9PDa4rxO1pcxJfce1pMrfsqvxF6C2x6lEuVBXSAoxHw+NJbFKSqv4BbMmLN0v26qagcNYlsXqW70YX/2g9EUP6etM0MegKynH0c2dulaDO/dpPCSVu7O9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PL+q5Sr1p+YXl8dClyrc4P2DWrB3MntKSW3gtCtTVto=;
 b=Scq0r4NnN5RNfo+jNpEWwHYi5SU2ODaIfrBhRo1aqls483YYFRp1qNB/zdEluyGZNxPXBywer2xUr+tPV69dTdZxxaYykXcv55d9Sh/s+8SdkQ4wTHMWxrhmizu6gTnqNKjJHQueAgKJno0KNV15KVnFH15Iwu2AP4UDM2h3WAU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/9] os: Reintroduce atomic write support
Date: Mon, 16 Sep 2024 16:53:40 +0000
Message-Id: <20240916165347.2226763-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0075.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 3605d144-4d3a-4772-6ca4-08dcd670326d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Unotbuq9AZy+b9EsB7kPeDPJ1V+v0zjLiNv2+HGjJ9p/9NrrTWQbh0nYz/u?=
 =?us-ascii?Q?QlSZ/C1tlwTSTIxRrjkVgbZbO3iXhP8O380/br2PWd4EfkkflRdq1cyFQ9Qu?=
 =?us-ascii?Q?wRor2mqMFySAZTV43tPqBSLyeIfqsa+mKYUR8y2Q/SXJ09hKJ+DQzt2O6aR5?=
 =?us-ascii?Q?SHljvbZki3rcHB/Ktn9jb9j9/Tt6TL7pL1lbGng98O4csbCdgmjJ3JHBoJjj?=
 =?us-ascii?Q?gROOk1w5h46lxKTgfvfyRYpiAgExqVi6Tf54giHFwgSMXPtH3I3QRgq4cUy3?=
 =?us-ascii?Q?wEwFRWC3EOPgzwby0HZxOC9sKHO+QrW7m7DiEzllFVOAzaIekDFJ9TchahdC?=
 =?us-ascii?Q?kZlKXtcFoE8NR3c8XsPSPi6kLtTNu8TFEaC7ZbX4cnreKVQF45e1xb14GER3?=
 =?us-ascii?Q?mOozNP5CcGWuOrtp3XzT37A3mVjDGyGq8X770/jz90O9lbFRFYR/hOpngMHM?=
 =?us-ascii?Q?0AVEvB5RtIcLPUVHtKIJogQ2imYpg2Dg05ylBqXJy8TanKj7zQ0sM0U8tXBa?=
 =?us-ascii?Q?RkWPtbcI+uXoTY7QYlWI4szJqQFFiRFmPAt34BMDZfVKBoMigXX07HNQjnaR?=
 =?us-ascii?Q?5EV1GQ4EGc86Xljrextg8mZ9IMCSBzz08EqwjjeUEuEtS9jMp4brknV+rFHf?=
 =?us-ascii?Q?XMh+VyOPObpVu1zm3h8EvCVeukKiD3bDx4d4MF51F+MEpkXHdLx1Kc6iabSi?=
 =?us-ascii?Q?lTILzV1t6X26hqp9GlLdp8FpyRsAJyDlVZJO4g0wQZpb9g+mbhLBhGnwO1zf?=
 =?us-ascii?Q?XSGuFreODUgSB2j/rm+q4nIPNa0qicShJ9kyWKGnZofUrAZBCAtRvBHeEtv3?=
 =?us-ascii?Q?6zagZmM34RpT09hyDtV5XFAQkKs1A75CADn3Q3Y8Txx4W5ucz5kFBOF0t2aC?=
 =?us-ascii?Q?LqoPmsgwwsQdIM4YEvIoBjfPE0e5Qs9DeSXpoXrEVVp5fzNgPCjZgSDPg6Oj?=
 =?us-ascii?Q?izy6WjxxkNKx+YldfAudCOc1a/r5OBJnYpeXuPB2beIqOpw01fvUCyoIBAHN?=
 =?us-ascii?Q?g9mjGW1xC7USqfPSF1Hhfbg4ctw5Tl3lpbCQpB6jG/1M+U8NWpZqNWKiwvta?=
 =?us-ascii?Q?0LfI1kopLV1fGiF6m21k0ZcHkkg+qnqhnWxS8UYLR/vdm4SG5CmX+iRu+FZm?=
 =?us-ascii?Q?qQT3kTV/xKatpzH0JqtBtedfuI8/nlVmdJ7foU3/Gmzic/goCWPfD8sZA13/?=
 =?us-ascii?Q?0iP2xwC645FBKXdyp9IASpnQ9a5Y536N3UaTJfdNsJHX+5t8e7jPrLu8a+cC?=
 =?us-ascii?Q?r3zM9UdFn+c2BbVd9ShMqODBX1iBDASes4OROeqwCdZ79FPvelUr1lWPGWBc?=
 =?us-ascii?Q?ne94xTIEjNdyaBZcIrNQBCT1vBtpYI2YbPXSRz9c2D+9pg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+MZ5blFnr4m09xNMPfDKYmft8bMk1PICY4CYAmvNu4h8vdFnoolxVUbP+ugm?=
 =?us-ascii?Q?GA7J0FyP/+mX/TFKlPG8DB7H9aP1qHX2FqMD/CLi+t0EPtrE7NfSUdhCu5l5?=
 =?us-ascii?Q?0wZwtu45sHyLCVhCn+7ILCWa+qtsG/ylBZdKu1Z9DboaWiNKAbZpv3rqmAZr?=
 =?us-ascii?Q?fvtXYmVA4lCXLmgRuOoBae6pT7s+KfF/XCW/AreRlo4CtWno8SCWHS+e8Bpk?=
 =?us-ascii?Q?GaI6jews6SftpbgYzVbVth08de4biAIEDfWLYnvrTQ78f4CJ3J6gYy5cuUhq?=
 =?us-ascii?Q?Fe+am1f3iFuLfq2YBn3LrZUIz/SSFdtNlZYLMjLRF1d5epfiNVPV9mspaVmO?=
 =?us-ascii?Q?sUlfIbRlECZbvGM5nSo0vYASrGrXs+OiG0iQdTxNUY75eQ4AFVbviWiwP3XI?=
 =?us-ascii?Q?obZ1e2vdaImTTFy+5ZdLfzqrm8C6rFs+HuyCmAPayChPi/0lPu5wl8tQx9EX?=
 =?us-ascii?Q?xoNQIn33PjlhtOzI19/QflDqmcH1Ahz9Z+pazNlK/Yspan5stIGEcyIYMVvc?=
 =?us-ascii?Q?1zvxbSy5+7mJ+4EnpENBjtw0OCgL0bQQ5N2FmcUlh7yk55xrSHb/yhQCaeb5?=
 =?us-ascii?Q?jPz650Kb8B2kfARjqcZJqgmjfsdvAcndXvSFtG2dF1aCyoG6dBtcgRvTI7DV?=
 =?us-ascii?Q?fxrB+QdUttt1UxDSp4sZHAolQlFhcKa2+K+Wt1MLDOthbIfjyKoXbwAHZ+Zu?=
 =?us-ascii?Q?/fWu7dB0nd87+IyGkSn5ZE/5fbRazHc4ilj5Nxw1oaY6zQ6xHnFB0slh60eE?=
 =?us-ascii?Q?kq2PTFPFsnEZz5U1BgQQHFXIfyFza7pckGPfQFNp9DCk3yZyNjPxg+VrTf9L?=
 =?us-ascii?Q?YBbFDa7Zt/xeUXTcwo0aEsRqTqt2urj7VGCzPctfIHKTYDURegJ4UdCdtZ3V?=
 =?us-ascii?Q?S12BIQgI17VqTGWwZEGHehQi2LqYb66Rfz0cfb1e/zQUKOw9mUzoddypYdhI?=
 =?us-ascii?Q?m47epg0xfvrMK0AbcLGkYMCKxuiMmkYE4jbL53ikd/ESZX1/Q3tm78LNiPVc?=
 =?us-ascii?Q?NOJocqtdNxjr68fBFW54Aj3sJUKO6iNfPpp50GJOZs0vPztuNlDWoceczD7b?=
 =?us-ascii?Q?aS8xiHatGouKxvG81NtdEOBCvrfF2mAjhxpUbqMn0MsQnsGj9cFhEmHEyOYr?=
 =?us-ascii?Q?1ZNHENGY0TnkQ5evtEGPl6gLa6pZh0srO+5M0b2IVLgVhNJO7joE+ur7RQ6A?=
 =?us-ascii?Q?ki8Y8tqRGx68ofDhGp7dD9NNYlrCBu5GFh8ygvb9OwyjYWHOiBi9o9iHDQQp?=
 =?us-ascii?Q?MAMEKOHRc8RpdqADTBrd0eWljNmRyE/seXItxrZBYaJYUwR/JqFk64VZywJg?=
 =?us-ascii?Q?2Vv5M5yBn7R0IetGBC0KSkn8S0ph/x20VNw9/NOzzMBt7AzcYcRkbHDkZE4E?=
 =?us-ascii?Q?QDPeVvviSZNsUrhUq4DAPUQtTJyEn4+iKC5gRrW551jA+ldbPPmmtLQK+xj5?=
 =?us-ascii?Q?SLG/4MNWF0jCVDp1Uz9pPEsHJMIk3ls2re0Uz34JUm+JwsqZLNNCvoNie5gA?=
 =?us-ascii?Q?vQayCTDTDnQ7yF9mtzfb5+7HaSlYPHU1mrfFgIrrD+GfyMqgcDxUvrSgXG4/?=
 =?us-ascii?Q?O2K0dyPCiu+65pRJ2MPu93VNlk5cZ9gW6BlIyHwNuzEq9pg0EGGF2W71P4bf?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mUguoKRE5jLsmHnk0frh+T+8z1cJ3BmX22YBq1wxNVLoaqUUn349I/fnx6QdDux+pwivGkCIrl60z+GXuxSjrOD/3Zjg/IGhl+OMTJx82HSjHdB9tG+usUhtq+431WT5oCVEmApP6WtyBGHHIXe+tkZM30sfVnfUW2mWLSsFxy5qeNAzf87lQ/OXQsG9xbWNYgH5ipGk+ER6UV3Zhk3GyPUeDosXDRdLCGsTuNjck74i3mAe5Q8H0+bb6+AwyNFIYzHxAkpycXUdv2DWC9DL3rgg+0zF/tCJ8xHXT/VEl//Om12Vfzp5naf1WsE4OaEtzgYjMjMGrhykNhVkZKrjEAfY+dpwO9RMNRdvy2LGt5OjwJQxlIOSzXdHZWV7OuFNp4jNRXtQJLar1nxDSBijlcUKvl2VLGY+TVvoLt+f8etJnOiohKt80YiadkjhFCmxCyyoF+763TN85aQwcZzQ+m8nmIdKPR729AWHIfzsKAPMXTtutmfsjW5QCNb0yjMvx9pnasMlGxuwsf3awmtNIshecmvV8a8N13rNeT5NAun4x4GWI2UyzSa3xVZRKLc+ebTIjEThYpYpoEbh2hJpls0Bwi8KNLKslrZyUrqt/44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3605d144-4d3a-4772-6ca4-08dcd670326d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:15.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6bzHaTt22KfVVL6qGIJQoPhkFzj1RQinbmF3KEK3i10rOJ7nhw5KcLSkAwN6CTF5aIfPFxvOLapNqr6Q6lOjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-GUID: losrCdf2wr4DIEmgX-3GsYINgwlI2pOM
X-Proofpoint-ORIG-GUID: losrCdf2wr4DIEmgX-3GsYINgwlI2pOM

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
 init.c        | 11 +++++++++++
 ioengines.h   |  2 ++
 options.c     |  2 ++
 os/os-linux.h |  1 +
 4 files changed, 16 insertions(+)

diff --git a/init.c b/init.c
index 414535cc..bad8b75b 100644
--- a/init.c
+++ b/init.c
@@ -855,6 +855,17 @@ static int fixup_options(struct thread_data *td)
 							o->max_bs[DDIR_WRITE]);
 	}
 
+	if (td->o.oatomic) {
+		if (!td_ioengine_flagged(td, FIO_ATOMICWRITES)) {
+			log_err("fio: engine does not support atomic writes\n");
+			td->o.oatomic = 0;
+			ret |= 1;
+		}
+
+		if (!td_write(td))
+			td->o.oatomic = 0;
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
index 5a6b0a06..95567de6 100644
--- a/options.c
+++ b/options.c
@@ -2926,6 +2926,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#ifdef FIO_HAVE_RWF_ATOMIC
 	{
 		.name	= "atomic",
 		.lname	= "Atomic I/O",
@@ -2936,6 +2937,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#endif
 	{
 		.name	= "buffered",
 		.lname	= "Buffered I/O",
diff --git a/os/os-linux.h b/os/os-linux.h
index 010a8291..ead8295c 100644
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

