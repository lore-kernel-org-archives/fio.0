Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9253815920B
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505686; cv=fail; b=NweYWUszEmw/jbxDA5+j/CXZ+qw1FqUVSF62C1WPlovXVnPenl6NZZ4ZQYix5zkxvblNOo4Py8k/HXO47f8j3Yu82skc48UT6dmVeuo9YkBuz4g7i13TBbQu+LDPi6gouY5Fk6Xor1Yst4c6YJUoFWGVtbaWw2q1CXqNI7ztSfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505686; c=relaxed/simple;
	bh=bAAdLedu+ZgGsT+x1OxFs/U3vu7USqRigaf6EskDMlo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JS22r3ok9JyeL8bcZZgoUz9Ry+kblafXiMFTkQGPN14krNYaY7H6tBSax+R3SNzWK95zIeaPk+bJPtZc1x4+smJUb7dLZBqsoOF32BIXFBwXMlLFtptUbQYfHRufN2BA60bH+cre7wSu/K4fA3Ot916Qaz7D4I2V7lIb1ffNB+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z0cd3P1E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c5zx6ywc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z0cd3P1E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c5zx6ywc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMZKV001101;
	Mon, 16 Sep 2024 16:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=UMGro1cGudho2I9GkB7quAdNoN+/wxMs2h2GKhuWBO0=; b=
	Z0cd3P1EXrD5CB+p7DbrO6BCJPCpWNXoNViqyeHRjNtbYDFtsNgHfkTCYR58G1Fx
	7I4lRhvxCATGmYco/DZ+b9YmIQLnodRuCHs9ZtinY/4OMMIj1oTCFWyRbqMPA3MN
	JDhYdtHp1Gs/4v68yqBPCqsVDj4HH1te837bCxiLqMDeUGC/tFSYO0iwObWhnS74
	LVKARk7g5tx7ZKRubTZkIC9CFgFvxfSZyskig2pZyotLOPuh3mjgeBDR831DXfUH
	xOnaAlxMyu2j9jwjq/ia93P3W8ENP8vjepxOqPeHDJ4ZWId+SU+tBV/TkCXoDIdj
	aE1bxHyJgMzh6vCqaw3Pbw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfkx5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGfshg015002;
	Mon, 16 Sep 2024 16:54:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nyg245mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8tnYNDfGZTBii2SRbpjqsx8NfnX7ijUQuUFUwyoEGm2dkuIHOLnxra0gxvemVrQ0iEE+v/GH98u+wScMd3URg35+7FzSXpUchmsdcMqmejmtzTcxH7dyar7+EC7mSjkclQ9rYhKV1+PtIenwpPeRPTyoVwA9Wf99toy7R1HweUFFYdtcn8Y3rb/SZQh9sZ05e4hzfx963OOi39oNlH2ZK6w6V+sTxlf1dPfI1tsboKQnGxEqtqvLVjrMzBEz1xkeTCi5fw7QAgqsyFRfu1n2e5SF6kJB+aDcLzlh77924u31J9G3/Lnm8wMotU71Bw3wu0hmHY3RmK2a0zn0pjkIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMGro1cGudho2I9GkB7quAdNoN+/wxMs2h2GKhuWBO0=;
 b=uF6E+4DzDSBq3EALdDcqNnEiXW6gVxkIFxoGL+1c5U10JSIR5mfLKU66tJ2LLaZbNuJrtQ20ExfUJ88jL0MRhpsUWujCPAmyYdA2/AEvbRE2KDtRHQjk33cMpvM+VuqQOGygv1FynNpJ+BVHewpwUoM/i/vj7FoU5OT6SnzbhkZ0LYIcoJSirIDjeGYAShTjOtSY8jPiZruQJKMLILzcSxFEiwyL+e8XeO33zOk39TrszKNt9gHabDb+qYFLPcn4nWiw6QvOh2U4CKq88dQxdC8QXH8t8MTDc3Cseq6Mu1IZbOG3ubwTAjdmK6xHH3RU5gxspO5pKpZjAGMJQ+xYPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMGro1cGudho2I9GkB7quAdNoN+/wxMs2h2GKhuWBO0=;
 b=c5zx6ywcBm7uSV6R/woXp+WjrA+td+zVjbX2Yh8sDqbu5RxCYQlA7sLNNzLUn0XesyQtPk6h7CVMgnCG+QmwiqK/+2tZRzycUsKiBxR8WlJCMhsJNanXSVG6HIsUMHoexw+JUOS4uXBU1nkR5OtW1qSFyL9HrMMXoPCvzumyUJI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 6/9] tools/fiograph: Update for atomic support
Date: Mon, 16 Sep 2024 16:53:44 +0000
Message-Id: <20240916165347.2226763-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0379.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 70ca9589-ba84-452f-e208-08dcd6703b83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hue/Bpo2TnMRzzfQGfPG5nGw/Em5GYKjJj3NFMEhy4QdmNOTgGhHORS2z8oZ?=
 =?us-ascii?Q?dGIOo4RIMASrUF+gG0a0OlNjVpdpLr9MvP3arwnbquLoSdoNb870b4M+/3Kp?=
 =?us-ascii?Q?vX+V1NoMpt0woQLtCMfUPDfLR7GOZNErCNImYX/0F46yVxFgmHXXL3MGDvC8?=
 =?us-ascii?Q?SXBTi37QOp3YhE3atyKZUTJsr+HZQAJ7Xe++9fjbOXOZk5k9V4w1n2vYyCHa?=
 =?us-ascii?Q?xFe8TEEmmUw/VB3O5DkAbmdcref+ldLDO/Vw1gBN7dFrz222s6ziWzpP/rPe?=
 =?us-ascii?Q?/VN8odRdtTGWrAJfr3mrev/X8elobfvoJIo0TQLJa2qos8JNMXIuYKEoJq4h?=
 =?us-ascii?Q?mrzxJCBzU3dZsNsK2pyYzi2Nm5+N8xyWrzs7mXnTmp5agNMBCyGiPLyKs6fX?=
 =?us-ascii?Q?q/SHH85f1nwMRHyYZq2NxKo3Uap30d9NgR4W1K+w6Rf3Ydh/TyKyXltk8EF4?=
 =?us-ascii?Q?FkHEw2WE0tazMhX+712xq/+B74ITlYNIQHSOPxJ5Bi8ztdcuaU/RrrgpDMkH?=
 =?us-ascii?Q?OumjdpirNhEsiQzAX1hTrv4u2YsM4U91HJHrr0aVNBWjIpJajM/P9rrb/dQ+?=
 =?us-ascii?Q?Vb/waV6kqTRf/GCeJ4u7CMlYHdBAj/x5jRVbd/8piMrYXMBxQ6TFLm1VmWHp?=
 =?us-ascii?Q?sGwkYe0AcfkF1gMbHI4BvOXR/iun0O3/Pw2VeW7Mo4aDDx44Ia8vYXtV6sfE?=
 =?us-ascii?Q?KekQVwHxRpD4lRRet2T3kJ6NmYCNg6iv1KfzuVErxGSGUX5UrVL2/m6y/SSj?=
 =?us-ascii?Q?KbrwKYZTtGBxoyb6R7oH9RnOelm4Vtq39kBTUsESs/eIHpb67Oti1orsJBkw?=
 =?us-ascii?Q?GlbVv4FcEiLFRAjlZ0cbHGKtt2E118q9xxXb8JBk3Z2gMS2DlWlhFV0gvWpr?=
 =?us-ascii?Q?OdoQiQy+GN8HTayrkCiHP5z6UiPF4s/Cn3kTcQY13hSzwBRAo0ClGRV3K2Qm?=
 =?us-ascii?Q?qKpA8dHlrgqIpdqyCOPmNn1Scl/nmUFsfjGvFjLQZ7s+ZIHWofaoSf7UprrY?=
 =?us-ascii?Q?VXq206mlH3S++ZKiX22KhTfFqtn/LuL5mvoHAKS/cRn707ayakiWPe5brWWR?=
 =?us-ascii?Q?kkHcwzEyV/J1cJ7ag3jvU60C/UhB1fWtSCkVN7k62QFDTbl8/9cTHrB8RQxW?=
 =?us-ascii?Q?glhnaChZglXqQSxvG3Elh8paeGoACFxRt7btPR41OvGJ5Rvj5QQ1N10Pback?=
 =?us-ascii?Q?dWgK8V1V4fs3UlX+b2mq6a7vgaZ/IpCa5d7lBQm6+dkk5zvUHz/EqH6QJOsY?=
 =?us-ascii?Q?a8keSRgFlDb1IUr9DK55oC1iQFhI6gSvdcW2Ii7V9mrOgMo9QExT190HxT3e?=
 =?us-ascii?Q?OZBe7gwaGAJZ+CW3FbxDwIo7eYW2WzUDsIo983Y9mmJhLQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LCaeyRHaPDSl4Z91IzSl7joLg+3nvsw48fbBZGBe6DJ32ZLyNWQNsS9jmcQW?=
 =?us-ascii?Q?0n34tz4+r/8SIBwb7v/z4l+rRxDQmuSDU8RqSUqphvUVA+a6ZF0/1bIybTvG?=
 =?us-ascii?Q?djuNOljEeyl0KJwi/uzNjROZ45nDp4iyORLOj8R2bXAemkLId45ddJf2vlLZ?=
 =?us-ascii?Q?KeqVYaeb8rnCTDdwf+x9sfoea7mARxJ+7HVZOa9kxOxbx2wUsn/Gx9lXwtwY?=
 =?us-ascii?Q?Wlmn1vNDMwxKmYT/LRpC9vBcVp/SvE9Gm/TW7ga5UTQSNRhUOvHTwzvQm9tK?=
 =?us-ascii?Q?n/lhUWFhSiFOlKslG5VH49rEsMZGt0F/lg9mnHnsyxla8y1a3ETZ40i1Hqgy?=
 =?us-ascii?Q?z9Ha0wCPtaeOo1tq5RnojTE9sMOzVH9uAfLJ0ni6VuNGcdTQ22/hYARbTI7v?=
 =?us-ascii?Q?zOd6oDy9SHi7KeKgbuNJWtBovO5bl8uP0fmN0NnTU15IwL3Aj18Q2lBivjyR?=
 =?us-ascii?Q?XNYtv3XQAMYt1kOoVJElLGIlfnT9cVHNVcopuLSRC9uebB6xJ8smW9hXXBqL?=
 =?us-ascii?Q?V5j5Kz5C6EKULXqzRaS5kVUXwpB+FGGuOUePIaixVAhIS+K9Pr51n7spazZm?=
 =?us-ascii?Q?ffTNnru7060i/3hYrWJi8sVBmymAq0HJEJ/i49zMz6ggY8YMCQ8+V6APMp0u?=
 =?us-ascii?Q?1mfRNXvkfo4ZwIHR0oJcgFByTLGJPyY3hGlm79pQO0KkX0dvTHHh40C9RQ3x?=
 =?us-ascii?Q?L0k8FLi1oRFC5VJy+Xy9+/JsXAp/AFCuE6WVxe7eC+WS3wvNMWs+0KtGfQ3/?=
 =?us-ascii?Q?WqTsUhDGFOYn6QJNqv1xvwCTXIfWQ4b0Pi49sCweO88xJQxDPCY20dviJawx?=
 =?us-ascii?Q?kz4lMrFey05/l7hqpyrijhE4wFZDrddyprkCCpVqw30f2TuPh1M62inEKzP+?=
 =?us-ascii?Q?YpSjP/RaHVxaB/uHoBMLom7L+kdLIyX8JSIuWwYffgW23l5yL7Jfewsh66Ot?=
 =?us-ascii?Q?KKBbu9UeXW+VQHeQWkICLAaQQa17qPwwY06XSpQPWEBnD5V51Rc2fS7Ua0ky?=
 =?us-ascii?Q?eByigG8dTDbv1puRhS1RAs8od6dn1yEGTD6Yg8ubrcj2jFBCED9m7BTIyzpH?=
 =?us-ascii?Q?1gLONojs4o6y2vhervktvBxAbH2MAwfAFn0q4Ygc1XEEGqY2E3iYrSMD+B6m?=
 =?us-ascii?Q?o9NS86KMI/+vJUhGl3p0Psu+EPNRrKKv9Cg0QQaQC9kFUnqTdRNBd4OEM7Ei?=
 =?us-ascii?Q?KRDR3MPbwVTGMeQfsT6vpw0sJdYcsSG+mXd4WReBu8y3Cu6WVVPN09JLiI/g?=
 =?us-ascii?Q?iuH2dnerAb2QFgCpiLzXsJ9rAOY+XP1c2qM+JNwUy4kedt5UfNBlyBMOQ1tq?=
 =?us-ascii?Q?P6fM6Wa7w/X2DCnp+DFyKrLBknbX6gl314I2mtRMZsDHRxyN2N4n+x+LvY9g?=
 =?us-ascii?Q?CTKHr23bs1jS2Pdo4D9RBe9SJmUHkgGDz16+Q4g3rdbkuRtY95z5KHMXMEey?=
 =?us-ascii?Q?wzDVkUnyJC+oWSjK73fojjpxjt85PipkpvmCzkq7CVuEdoVzyE+LDgFEVpDt?=
 =?us-ascii?Q?sN9/OEPMFfaMu4eDpg1tgZgg71OnUo9gomzY1buXT2JrZlWAkfvEXbG6sMtX?=
 =?us-ascii?Q?CxVZY7MISUptmfa9OHA4YE7S+4U006qYZ+v7qqBMdpogyw9nunYmF1dZ9dB5?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PlC2rT+YHfv95n/lb8rB9Jjqi7Jo6IHF/B/ds1h3+AwSLAJ6T0RsGN8VQRXDCp9b/K9slk2h2V7hdKIB+ctMw8gFbgVw/asAc63Xmj2pnZH0P1dPoyGKKfhLp9FS22PSjDvNxyAgks4G9iowt7In3BJw3cr4KLsBAxv9PJdyYdovfqr/Rz1QOTsZw/RFS9yyJeGjaE1/2DdN6etujDHavYyE1h9E8r3GvquKMzf6teuJhdFBclO1FF0K+LTssIk0vyMHolnDF5mE9L096W0vpeS0gVKhv/Hff1vnAWPGccufHfshf64yT6YHCRNaRm5A7hHhVyppJDxa2qXQl0sTNTpkg300JCjTHx4DZr42cfec1m5cKwUOfrUnojqdf01aGV7wI70fNfMX0xG8VCcXxDnXYK3W6K+9+UGMRlWAzgS8NAzTsBWoYXLkorSbMxq7t6wwcFzW/+7ebfWa+m50qyN2ReeAKSETDsPZzl3v7xeRF/6KK0elEcGXT63hGap6FxUa8ymwHbvJuoxA6y7wB1GpfZZoIPqATY5qchmn0lk0dqCI0hh7mVOFCYjqkDHpdpxUXQyDLywju8dkBsp+hWUqd9LbY8MQtuMdzF1gLQg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ca9589-ba84-452f-e208-08dcd6703b83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:30.6025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qoCs1xSAkGMPAozYsTMVVFwDeUL2CjMx182TzBLFPD2K4KcCLWIAzJrkBp1lU0uwBjl8u7CVDnNUIS+N7dsX3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409160112
X-Proofpoint-GUID: GxifIL9QlD5lON63xulslwvTKakTY2iy
X-Proofpoint-ORIG-GUID: GxifIL9QlD5lON63xulslwvTKakTY2iy

Add atomic support for the specific engines which support this option.

This just means that "atomic" will show up as a special iongeine config
option (if fio 'atomic' option is specified).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 tools/fiograph/fiograph.conf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 122f2baf..75712180 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,13 +51,13 @@ specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_ke
 specific_options=ime_psync  ime_psyncv
 
 [ioengine_io_uring]
-specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async atomic
 
 [ioengine_io_uring_cmd]
 specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async  cmd_type  md_per_io_size  pi_act  pi_chk  apptag  apptag_mask
 
 [ioengine_libaio]
-specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait
+specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait atomic
 
 [ioengine_libblkio]
 specific_options=libblkio_driver  libblkio_path  libblkio_pre_connect_props  libblkio_num_entries  libblkio_queue_size  libblkio_pre_start_props  hipri  libblkio_vectored  libblkio_write_zeroes_on_trim  libblkio_wait_mode  libblkio_force_enable_completion_eventfd
@@ -99,7 +99,7 @@ specific_options=hostname  bindname  port  verb
 specific_options=hipri  readfua  writefua  sg_write_mode  stream_id
 
 [ioengine_pvsync2]
-specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync
+specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync atomic
 
 [ioengine_xnvme]
 specific_options=hipri  sqthread_poll  xnvme_be  xnvme_async  xnvme_sync  xnvme_admin  xnvme_dev_nsid  xnvme_iovec
-- 
2.31.1

