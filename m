Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20081922FA
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934689; cv=fail; b=JU0vVlQO4L2NppmuQ7rEd/aDK3GYTLeUUQu8wIsjlY9rqDV5J3Xxi55w6l6CarFl2AilHFRmjDsyW7ckrVOVVHYsJipCeQYDpfOijXrcJ/S1EW7lRMmFTnl92YTWpf9PexMfwv04eY1g032kJOrbE1BLvUw2Z9WpV0IIbWSW5pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934689; c=relaxed/simple;
	bh=BN814p4rBtUfehhlBLoC1QeLRa5A6ZlCx0JBhvnEJz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mU2L+xbKygIKmIddAw0i4tCu/Yczzu7SOEaqM+Zh+htbGDYdntsQBtHXDE7irN7CHxIud88v3OLIe2nXc5OFGuAW2uzvxA1zwcXG4jEG42whEbuOwVOGa9HIN1lPxXUvmPb0SieD6OOU1/I0WBFBKRpI3DtQstAfSPNaw5lyKvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QQOLVKW9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bp7LuSY5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QQOLVKW9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bp7LuSY5"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TB5KQX001437;
	Thu, 29 Aug 2024 12:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=77WPZn4xWz24PcH8p55Vu6a+pafvIESSqHfMi/OoclU=; b=
	QQOLVKW9kQRxpLtcatKVB0Jhi7+kIGaWHqdBsVliszF3xRHYh8MN+FhYZ0Gu7EbE
	3fz5DwSf/aEsRz5qSLveoO+sW4VB3EWGex9xxo1Kd8dpZtdGya5N6YPuD1oobNQE
	K/pNwwLe+N1Ywze8GE/F5VqetcB2dqfkmj3CdkDddWj09OhpKah6WKT2mmyKis+/
	LEgeuhnpHkUxOO7xTCXGfejyc13JD0omvZ68+gjVolZqdd9WYcJCzcFxSNzNamre
	vOY7d2QTvNHyisA3npGA934BuycGadP2CpyG6GfpZBEF6hHK9QktKtheFU5LvwOQ
	mZRlQfY6jMttdDvCLk/qAg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419purc2dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TAcjB9031752;
	Thu, 29 Aug 2024 12:31:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418a0wn1qq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oMIWmawvb44U2xcy/3/eVjw0n+kz5ooZdkXtjv5Xy/opWEOh9Bf5JV+uyn+mSIHXFBzqNsKzufiImvX4mXGEqIZkChAZ8DgLd6ZiAMzTDlIG1Hn4nGvkh8lVQJx9WsJoxFLKvwbmKvaWIe1mBYboQpeOAIDQV9iX8sqZ8orM8Tgz5VbO/XvAXGkc9aYH4no5y4HvtAtPP0JsmCgcVuJoQqF6mcaCgZxlbVULu+stMHHjXaOSNlmU9lIMfaC4LZEXR7TWkw32WbsXUMLR8UxLczg07wCzwVsXxZn1ev6BWm2xDYOTyyg8PqWMRH2U+UVbgWxgV6La0lrl6OkYTSYm2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77WPZn4xWz24PcH8p55Vu6a+pafvIESSqHfMi/OoclU=;
 b=UJXHGU6o/sy2MlKSLWQ+HQsxzhar5Ey4y8Ztv7ys18IeNUnneOmyyeBirGeTyszyUTD8I0eAd6vPjYPKcRVtCx3BcmDDCEX5FkD4tmoeAPfc6++Y+XnBYQK5V9bhD4T7302QpgbZYF2UBL45dkid/3lC7+WlBaqhFc1sWWA9xzsEWYk0h+GhcpG4u0LUQyjVlHs2Brc5cKmG8GxtYN2hxe+NWMOTJkt5aDBjDIe9spiByT7qxAQYN2St34vs5B8GZohmIIPsfWwmnN1dpwB9vgDau9OK5kSTW4B+LvrqOmydVfKFRKPN3HxwFAkUX+ea7vJVuZqlWOqlnSjc4GCySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77WPZn4xWz24PcH8p55Vu6a+pafvIESSqHfMi/OoclU=;
 b=bp7LuSY5qjBoTGTIMoFr3klEXd3AaFTacMMJRgJnNILi9SbR+XehD3bazAIa3yCeM1HbTHUgdvFnkyynmqxk9exGVzw6sgchJ1Gj5W9rzndyx05yUXMJtwc8snFChw9GNXKMn2x8GVbuHAeYlcM/HPuQLAqOJxJKu+3Qa5GViwM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 12:31:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/7] os-linux: Define RWF_ATOMIC
Date: Thu, 29 Aug 2024 12:31:02 +0000
Message-Id: <20240829123107.520005-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f347b0a-799d-4b22-dac5-08dcc8267b3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wVcCJc2y2dh8vlZ0EGEs2dgDOHQS/t4YaeMP+nbk3ZdOZE5vH8WGiEzuNWux?=
 =?us-ascii?Q?8ij8qE9r16HucE7wcyOqYn0jDLCWRmhSiEQ2uQX3JyyNSJ6p/i9/1sEZZPZY?=
 =?us-ascii?Q?WrwVHzbt9dYW/VN8pHgPKTSGGlaoYgeU9bMpD7wP5ipvmltXh0Uz3GUfPub9?=
 =?us-ascii?Q?CB2ThXiFd1b/SSKCqKY8lfsROUfp0TVgXZiMpeD+5+hyO9/GecRiqS0Lgsww?=
 =?us-ascii?Q?kXc5rmEOMq4gosKvfW1JaSEnL40UrfzN4pz+iGFuUUGlBBLHxgciJ++39DZ8?=
 =?us-ascii?Q?y8ZXe/xjL6NXkgXjeov3duomI/1i1rVMbSBQfDv/RoGnUmIKs2utUDGXAmbe?=
 =?us-ascii?Q?F+7pT5fKb9y8vOcG6wX1UVla3o3a+4yThukVsi8L8UWJcuVR15gUdlTdmEAC?=
 =?us-ascii?Q?b77hEKfnW0FIGRXuM8pU/Yp57OeR6P2EBhTLJqogOCKaqkR0icc0fnlMElZ6?=
 =?us-ascii?Q?EoICewElBJ5hKVLKzjP65dbZ3ADz5C6p873KTQoEzk1hQyAnkuvIEu8KGqWC?=
 =?us-ascii?Q?q9/P0KqxXiu0ApD+bSPBxBpfRQvlbzX3fWs2zNvaPs1KKrNS56AUW9BKpnC0?=
 =?us-ascii?Q?U7Y3zs1lN654k9cLg61j5g363rDa+BKcf56dELE1miYgG1uSQ3XRjyEo0PS2?=
 =?us-ascii?Q?TORH+ME6MXoYi1YalcfRLrOt7Ra+7M4Yn6cVbgwdKthVRSFCWDBepjA7HyvW?=
 =?us-ascii?Q?wmx1fyC1va2AHSuCu7HuflExiqZbwYqVzzJKexcq7syS+3mPlJg1AObctAHG?=
 =?us-ascii?Q?fOs4ivHr5yOfyo6dtpv62msHy9ubHMQSjhVXIk+7I8LxQasOBNxi4EttDI/y?=
 =?us-ascii?Q?CJMl9mUBgkAo44WmeA/BkMSonjVjqqkzcs/E4FJIYcEgY8Heia8+G/wZgeFZ?=
 =?us-ascii?Q?3IVv7csLrRb3rwidn+jdtuOleR6F7V6WQm9zWPCHMLZSLH6LfN1j/vdSqTHI?=
 =?us-ascii?Q?HmvvWg+Q+xoxQx18NiqKyZwyDuDY6yMBP0dJVPTnooYP6adKIOu/J+w2TsMu?=
 =?us-ascii?Q?Xr7BZf5qhtgcjK2ppQP3Sx2clpi14N+rXT+94UBTaVGI8lBNrbmIIe7q/X1g?=
 =?us-ascii?Q?po2E0wwxBxJuru4mfJBbfECse4os1bqhc80RK88aPOxmXnJyd/GbcOJDI3lM?=
 =?us-ascii?Q?vBqq/hckdbspN+XUyUCSRdG+230fMpQqb1vSdQPhN8rFr9uVMLioszm8ES/k?=
 =?us-ascii?Q?Vm4A8nGlDD7rsZpLAs0HT0HaGlXdQy5za7sehtvUAfyA6qP1Hpaw8RwzhyJs?=
 =?us-ascii?Q?0EhsFihakc8+tXlpTiui0y8zwJTrIySQaK7/Xqv9/7pJEaNICVL47ieaRubU?=
 =?us-ascii?Q?Z9wbEnUy5sg7DeqiLtCh3Osr/5YxqlZw9bCKZNfHT0oK2Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ch5u0/GQCSmSbFtdbSzunMlfhrZNTQRClwuype0L3I9lfTgnTeRPp3w0FLfY?=
 =?us-ascii?Q?FuxyzTXT9m5nQ5XTf9kRrDLNeHgboJOB4hZMqd6JrfqKXmhtWV1M/aKFLD/L?=
 =?us-ascii?Q?RGIPLWMYPxhdu5lqK43JyXm/OCiorq70u+qlsSjAbQkVzYso3FM2MMgcauUC?=
 =?us-ascii?Q?nk3RZ/yBeNp3jNjEZLe4V05FB899GvLwWfaHCKKNgRuJU9MUJY1/QZeKRDXK?=
 =?us-ascii?Q?DA3Lo4MTkLtWOCERjap/mxTkujmNRg6ADgZy8Vq7uXkKI89ceJ6NbTyM+8c4?=
 =?us-ascii?Q?BLr0YGnuE5O7xFR2g8mIf9LGxiONDvz5edVJgC+PQHiVP1af026U52bLdvi8?=
 =?us-ascii?Q?BGoGuu8B2D3R6ymNG6wO+GGZ2UqZGEd0YRFQNxXqZIGPVHemQgK54TAgeSku?=
 =?us-ascii?Q?QjxLTYdML53ZKMVEIb4KA9xY1djpA8wiVbGuHnKgVxDZPYoNOyM31NF/NuP+?=
 =?us-ascii?Q?mMG+lqEvIy/zI5A+8eIB8wO4KleK46om1G+cVNGB4eY6iQUw3LAoYbK5Bm8W?=
 =?us-ascii?Q?ErM7ilvQ3+f5p0lKbjD2Bx09iFUOwD8T84+ftu388VmmRrm1FX0FhcXz2zK/?=
 =?us-ascii?Q?joVee9FXYJxrZAGfE/pEFbY7rkDug8RO/JV06Mc3rl/IrNzzQ0qXam+Crs6i?=
 =?us-ascii?Q?Z8StrzloofHPhZ9/SOgeVhP2cBf8HclvmTpTU/s+1M6dyNxtbZYGpD1lZvHD?=
 =?us-ascii?Q?LrYQ+8/pOI/z/VHe2RFrzJn8QqRbHbDUhPPGl+O9vcdBymeMXM8Cw9++Rlwa?=
 =?us-ascii?Q?0liJ73TWCkvlO/Qwj/z+8CAuxIQ7CYZU7ZBhwbHq+LDIesaolif1+7gGQars?=
 =?us-ascii?Q?mRq4WU9FhJlT77jyhv+Wpu+35f0/M5Dml0oshT058B/z8jJMWowkZNJjquK2?=
 =?us-ascii?Q?12RQoc+D78iLJfAzrNRsqGJOfGR1GV64kW/HJXiHp2tRMF6AGsJg3YdXydEK?=
 =?us-ascii?Q?LnZlsAA0Xc0MFt4DrmSFWCPQHnqkpi363qnHLNEkDWZO4w6PmWFIL3QKz+D2?=
 =?us-ascii?Q?fKS+TPWsa2ep24rbmlzeeujTMr56LymC0Fo8Xpj1k5Z8SgFkMuvcSeX1VqN7?=
 =?us-ascii?Q?JJHCLKi4dfS8wLos7zLiFxAMtgrlT1Mof2tDYlUTHgFWw3ri78zzh+PNLEf+?=
 =?us-ascii?Q?HF9cW90iACbdLhVSK/64Q1ba5q8Oxp2xQI40qXJuL+qp4YnqT8ASf5nBgL1G?=
 =?us-ascii?Q?UM7wY/T18RTJON2LdGwEljS0JjJpkfY3ejvNOvLgTinEuUywAsxK9XMiFdrB?=
 =?us-ascii?Q?RALgFNKGZ/fPnOmt5oXJXGHeO7ftmZ3gN1GqU7CW2c5cnWt7l4+DlcmOCPHA?=
 =?us-ascii?Q?cXJFIEEDOJYMsfE+wpalXJar9fe3g45ULNrU54dvRQIsWiNzS59dX4S7jfYy?=
 =?us-ascii?Q?Yi7Mgja2x88riQSePK/31jjs0vIc/ZKk8kO/1+ermueyGJSDbPoM/pmXPN1L?=
 =?us-ascii?Q?dNBZ7IKQbziQWz6JPyJjUJ7ILgDVDw7n53Nbk/NfDPOvM6j4wIU3/qPV46YN?=
 =?us-ascii?Q?YnrjNMZgnY4R0tRypv6VUycNm4+FBm9FGFlqIwYX9fsA66t/vl3k4zEW39AA?=
 =?us-ascii?Q?5er0E0P/CI8+zXlLwWxaecX0+0MQd4pg7tr0aXV8teaqSPhA1X5vJBKUyUPR?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t2VgHe+chqmtvor5EGpeV6hlinRMea/zy529rvNfH8ydg0pVcfIzwKClzSAtjg3cOTtEHYqIjCZO7kjVRqa0v8tL4lN7G3MlW+sR2OxKK668d/TXGLgXJYM+G1ykvRviLYy5bilkH8mKeLNnGkLuwSPNj3kbIvUpF1yA+9nbQuw/co/I0tNOVz7dMvwZILvNgr5hQtCXLTRomxHCtM0RH6d8qMom84PY1kC4RTmk1FwwoN9C1Hh81uh0w/IXVNHRHkgkjvkzieavhx/eB0628AWK8D+48CP3vVXYgI29POtE9z0F3+dWKPL3r/1/NpUAz43B71Ho9alOAz193hta6F+R+U4/d2pISv/CnPaRt7ox1cUNug22gGCxaLI5pPWYhSuvHsb3C0hMMSkI8ZJnk4r0eHUiR1UmgLo/QmOGUPxeP9oya4O+wqJjWM6HmYWvNXEF3MyZj4dowMSsHH4cVWYDah0SsUaLeeyIl8o8e3+qWvi6JMD8ggFWUw+CFOQTPVt+QF4R8wpYRFDAMtIfY0RW04fcvwRTgTj6mK0YksGctYdFOEjXyN19VbAHirBX15vw94X3S9l1Sa1vOZfKqXBlM4gypt5tEJ9xxT9fCpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f347b0a-799d-4b22-dac5-08dcc8267b3e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:18.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4GLGVNxCISHZIYyJAw+SaE/kg2lqBUT9qdCSaemF3xjpKnYkwmclWK5r2C1QnAuyeFEO4aBJ8OWkkGL+vraVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: EnuUm0gwiuzRSrc_YRcG-w4JUW4EtOIc
X-Proofpoint-GUID: EnuUm0gwiuzRSrc_YRcG-w4JUW4EtOIc

Add a definition of RWF_ATOMIC when not available from uapi headers.

RWF_ATOMIC is going to be part of Linux v6.11

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 os/os-linux.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/os/os-linux.h b/os/os-linux.h
index bdd725f6..5b2d1714 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -328,6 +328,10 @@ static inline int fio_set_sched_idle(void)
 #define RWF_NOWAIT	0x00000008
 #endif
 
+#ifndef RWF_ATOMIC
+#define RWF_ATOMIC	0x00000040
+#endif
+
 #ifndef RWF_UNCACHED
 #define RWF_UNCACHED	0x00000080
 #endif
-- 
2.31.1

