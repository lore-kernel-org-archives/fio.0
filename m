Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF16A1946C4
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934692; cv=fail; b=ogsuYHDRlOATK1KrbT2biRyp2VMCLcMOrAHmsOd6PbG6U8chmwDdDIUDgz04CVrs8+NHR5Ez7HMdoKw/Jjf4gwLHLw3rxeeC7fTnVUOI2dBbwpa4dIj3wCWep87mt2bDk0Ka9GELd/8/NPYSbKia7gynksiQ9d13XdDdOROBDbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934692; c=relaxed/simple;
	bh=nNpM6y9AYOdlWONeVRkEYz+Abed6H9V1E3i1SrMQhtk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XizXaJYat24xSDnIkaQ9b0LSJIm/3Fog/+zoEZ+mYIcgQbyKFjUzKGSenTlyOia2GM/B43aE8cFlUiiApF+adSmy/Zp1uJ9TXF5TpHG6WM+BD79JFqFYTvA6rq5ZoH/67K0SGjl9VsgcK3wxCOa09tRNwwLzoFC0sJ3EOXKQFoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ipwPakgz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ag+bEQ7I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ipwPakgz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ag+bEQ7I"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBvb3F011190;
	Thu, 29 Aug 2024 12:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=8/bU3qm2OTSDYVhD4Orks1ZvBp/cL7AjcLiN5RWxdA4=; b=
	ipwPakgzZQ0THwFxQC0jANCJPv+uSPvm5boU7VuEUl8EPlg6WFrrnx2+i7dKQvf5
	8AYa3WXpELhyiZMlaUY8zvRAaazCDRMhEEcjJexckcvo5BaTDWmQdtIE1kbeULpB
	bk48AmyNPr1UvJzARhCdf+BkHX3w6IbbQF7DEyqHL426fQyskrnrn9ceZYjA2Kq8
	DmAkjfJi/ejAQb3SFnjRKg+CNkR8OxGTPHtlTvG+kPNvW+2DwM0Sr3FcMrwO+bYl
	Zq/fHYXQ6w6CSTEl9LohjYcg/Mb2MtcEafYjP5Z5Wx0b9qUHS12oquh5h4rFUJr7
	TjjIuBndURgsimFruuD75w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pup45cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBvUdk020447;
	Thu, 29 Aug 2024 12:31:26 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418j8qcunc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQJtO4dRxgcqyaqpi750LrQLBzA2osHnaDV/zVUc0SHSoSy0kWGlJc/lrScXvkO5jxWwn3s6m7siPYhlFehjK5x9BBrvt5c4/uGMDp6QjbHGG4R04bE1TusqkvL4ew+V4wLhNkRAj6IrP8i9e8bRQJWErHfdnZ48nWdw+Pen/5sbcL4qtayeonDqIshmlL7rnG3Xl4kcRO3t6r1jQal3mY1nkO3o7v7Xba+6HpR974vBFItglTfejfu7xkF/wJI8JZT4PfP80Fh8k4soGszzEvLnnnuFyl53aHWlEf7BtIrxUDPxrvEkp+7phSfEtKQuBUQVTnppUgcI+y749rYlgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/bU3qm2OTSDYVhD4Orks1ZvBp/cL7AjcLiN5RWxdA4=;
 b=IvkOQ1O8Nt+yfT2+TXuoYHHRCNt5n8ZrtqKi7XnfeZIx+3QFHYwgC9huKBpPyqFobBjWteTikgyHe04Ty0zieX1cqCQ907ehvGxcwV9T1FhZa4RC0nLLP3gLCPJkTx82XSqvNp6CioAwsdf1U+Kz1zeLxajpAp7rm0qSq29fp9MyPwfuqzG/vbAfbItucwrOffI0B9d0TMtzw4MLJ9JLSAJDQCN0eu1iNvc/UWEud5aXCIhEh6OiXoeZkAABla43HIfjHbFeCQha97PZwi4nm3C7FLf9KUtMcGh6/RvTUSiD9klWWDlPPGBc1QkmUB62UmEOZ2N4nv1JzP0xmg9yvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/bU3qm2OTSDYVhD4Orks1ZvBp/cL7AjcLiN5RWxdA4=;
 b=ag+bEQ7IIHY10/aZm1mPOjekPkhiFZY8Axufaly0n8dTZkZ5poIFUnbhn2xOZTpI+Yvl5hflhFCB7768YHZzRLrh7Ko03WAHx7QtQVU6LEvIhI9wSfq/3DKZ+CKYw5NxOGd+SLloBevhXrUQrdPWMr54viCjkqFG9xLRCfh00TA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 12:31:24 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 4/7] verify: Ignore sequence number errors for atomic writes
Date: Thu, 29 Aug 2024 12:31:04 +0000
Message-Id: <20240829123107.520005-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: cd4866bd-3ced-4252-bcea-08dcc8267e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NtbnJSgOJ2xvhKJtB09gQKUSp6sQRuFkgXklF67UTo0z59TVacDRPfwtdFbM?=
 =?us-ascii?Q?5yab+z9J46d6Ex5lG6V33t+hF55rwsNfXT/gOtwR/0h5/dk5s4QJ/4eC805K?=
 =?us-ascii?Q?k8ctYXL0RoOK/pTHD1j6vLFLb18kgTwk8A2lL9WPken3cvZnHHGzORYFuLj3?=
 =?us-ascii?Q?oTVSS3aK0b+HByM29RytjcOTXQhmxr10xqvBSDacqxCf/IasUEyRwXRIOKvo?=
 =?us-ascii?Q?iMSa3HcX8RAb+6p7LoMNS6FziG2S/tePX7ymrlI1KpxqUN3hEE2SZT8KkW6M?=
 =?us-ascii?Q?AVNc8Cnx/8ulaGav/jfwQPUmKUnD+yebPeXYs2QguBh4gh91rULby3pk2CLF?=
 =?us-ascii?Q?+ikBkfJMdJ1QqG3Gc0nEdiIRq4/ggbJKvBOA5L1qnYpM6v12acVnG1+mVilN?=
 =?us-ascii?Q?siXt2VWl25G8RRqaCd8h0qupHaaWl92rShxQTQH3wI1PY1K5dCP2W+V3Re3t?=
 =?us-ascii?Q?d7FHq2cffGIC9YLaHJFFdZjI3OCjfFZW46K40FdwvtWPLc3zYjjUlsRxbkYW?=
 =?us-ascii?Q?l/Y20IRG9Iaou608f8k+vGcmuFpChEg2e14lwzIoKnPBk1yS8G1Kzc1gBJRI?=
 =?us-ascii?Q?lZPwpVduEirrk6QxxDB1FOMx5z6szygRVMrpVfb2qH2UqpTBuUBut9rN5R7i?=
 =?us-ascii?Q?4zJ8eo1AEntz3x1vzjmzqd/P3pd6+fIZismFe7aTK7BWiiCtQ3uwVQMAgDd0?=
 =?us-ascii?Q?/Bvj41EJxgU+h38qL7m+9YMM8idyO6WjmUnnuhlWGcsxZX5rGhW8vdm7Aec4?=
 =?us-ascii?Q?JialzckSfHpo+0CfVU+zlnaxmtCELXxMQIAeiaNVbe4uhs42aHTCEgHXR/ps?=
 =?us-ascii?Q?+dIYsA8ZPfe+dVTNX6RzuLKXbNdkQ01Ql4+dcYWwamBPY79ZBo2Xqu3xriNA?=
 =?us-ascii?Q?t5P2VCd7RVdaPgepe5J6ANbz8zvM04l1e6nrLsK2JkxCkHofhD+Zd/tBFW2J?=
 =?us-ascii?Q?f/JOsAEJTaMTSR1aGggmP3QRgdaerYavT++Ra9FFba9VsRwfKOzi2malJ0vM?=
 =?us-ascii?Q?tHkj7HpeZvaUgh6S2O4UQWhFPfPo30aQeHGhTgcr4MxKhj1t7cImcxlpn31M?=
 =?us-ascii?Q?Cd+/sqXJ6HQFACPFeLwY6MCnRvCKG1JSx1hg76bVVKCGe88LCMcvJp+vNoky?=
 =?us-ascii?Q?AIg10FQWJSpYD2tTZ1Xveg84c3GysDfBuGbrp/bK72edzV0WNaaOI6Bn2+6h?=
 =?us-ascii?Q?eqktHONWEUj2HGjSnxMPt/WpxCRlIkGuFyug1YhBsJEHqJej37AyaMRUJmIJ?=
 =?us-ascii?Q?WOZ7MvEinM6nwN7RNiW0n6TAEMH1wXivDWILQHc1Z2sOOIn/eeIzI+fQLaVs?=
 =?us-ascii?Q?sl1forI+WQkTYk38+IfgQP2hDBvU8DXDqb7/9DTB1rngjg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ye2Bo7WduB0J38uppRZp/rjJJQsWruHWjpwr4JE/YIKj3EvRmebH/VGROF7d?=
 =?us-ascii?Q?VBkT4nTW2ke4v60ldgN+wmsYr5rr0EAKKum+3yFt4EkYyntW4XVZkatQMKhA?=
 =?us-ascii?Q?2nuZbIuKtFVJkd6QSSqFr4RpRhFq9I+dfYBKxPgKvRMzAujj0csRik4Zd68+?=
 =?us-ascii?Q?j60paxfvhtN1yNBM850o9ZKVyr8weLqQXVXcUdhMc3Sy5BrolLeyoCfKmyYT?=
 =?us-ascii?Q?0awCoV/BR8s6nM9sR97ZJ8XldSu1vTpMTWYJghbKQRw7hrcdbzz7TG/meAXD?=
 =?us-ascii?Q?kAMSf6buVkdr25cwElZ7HnDWH6aYDrhWwwKsuycnueHit/pZOHufdgT4H3X/?=
 =?us-ascii?Q?Mzfn+QjyRaM0tK7VY3cCPapVPsqnfv6lnZQR1YUrYjdp26J5+CIdzbg51ETk?=
 =?us-ascii?Q?FFDITCHwKNPMFS1N7MysNqrcpxPz2+AJObXw2X6ilU1tayAO36dUh6gitlVf?=
 =?us-ascii?Q?jwetRi52qur223Hvrj524Mz2od+Id/IzryhzC8SA3jADJ8esEav0HTBdfRA+?=
 =?us-ascii?Q?+vs9TCmK8oX+aLgEyegcWPTGDow8QhZnvTqbcwXby0/lKNeXp7DVqvJIc/wM?=
 =?us-ascii?Q?+hQKXi4JA69JrRwJGN+2pekiSrEmdoJoLXhPIBGp60s2G7VeSRzHPZVLx7gm?=
 =?us-ascii?Q?q1bzpd8Y2caPWECI35EXVgDgVspdsIuVA1gOnCum1MWgzEDhijRp2KQ2+eS6?=
 =?us-ascii?Q?/HQgfyRlcC2RdFWeSaS4HcqzuPz0nVP6TO+DbVK3NvBUNQLWJlYXdA3NWlz4?=
 =?us-ascii?Q?RphAy5aXJYcBTnYPiIUQKI5j9OeD+pU3wtR0OUqstEn1LyZ/dcI+J7fPeJFg?=
 =?us-ascii?Q?nGPAV/eSy98VdJRpNx/DUV4FuXV8JTMj3xTQOz49Q2gQbzK2HE3AC0geHfc1?=
 =?us-ascii?Q?NynnuVzg10xC5/F98lR0TOfk2UVXwAUUgtMEI4LZGvYjxJ0MSD7hiEiOx7w7?=
 =?us-ascii?Q?KwQNOn+0UczOCZB4IbAEAHXhsy6VlXomuDsIEMcO2YSZ/1rGUczPxUrxVSdP?=
 =?us-ascii?Q?wSgsNTpV6qyAr2FYhHs+5d9NYefwwEQMZiuaI2stxMxxG5qCmQjheHdRWJSg?=
 =?us-ascii?Q?vQs0PNFfpCCT0ZGptVZunEcQJzflBK5fwu2kk7q1IlbPVgqXGnRw1G+gu7s/?=
 =?us-ascii?Q?QwRIV3W1kBIo5qCUJabnRd9b6Qs0NgY26xNXGsrV2iPg1kX2ZKJ5xZGkWFhC?=
 =?us-ascii?Q?01BdPAC4l+5t10dUAec6xkhBFT3yzXWV0NSXQnaVkKtzlXpiyWf+13bUrReA?=
 =?us-ascii?Q?BX9ZWTaW1hW3H77ErEYAo8ffD4u8bX3SnKKCXCuXW3zJPPleEY3TAldhE9tW?=
 =?us-ascii?Q?DsXUZFtd5UxE0NegHXDk9yk/iBVWVFzrhYiUmHJ78fyu6ZWTZ0KhLvDSkc6Z?=
 =?us-ascii?Q?k9YI+/jyHA/LCss5iePhoG/N7MWMmUFApzwBRRojD63eUwI9iI8/ArZHcqWL?=
 =?us-ascii?Q?4fgq5LxGl76CD544pYEsKriOvjyXxvm/FAMSdY2eDX9Lb3ZFqqoE+R/h7d84?=
 =?us-ascii?Q?aMxH9RMR1HlIciqpNrOey/0DVrDnw+5lVRgVsfMLUWacrG2rHzoY1sA4ucP2?=
 =?us-ascii?Q?iLlWI3ITmK1WDIbjmA6t030xULIskp31zDq4rPXxvx2Ykib51LZ7g5zqqbZ7?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P9hQhihaKNNYz+wR/KjGcAhkvjwT5kfA2PGDNXaNPI9Ol74+fMN7DNGI+02w1aaSdCEOJ548KBVg2KwMYepc05fbAIIRffpj8TSXXkoTioH8l5C+Re40D2XVWdzgDadBTsMSyGZ0xGcio3az9pgAU93+Mel0e4JilOASIh8qj4ken8ybLte6hh2YKQMUe7uTfZZ792RiLYwTMPnsAmOJA6h5X6065f9sOUmnRlH7gQ/gjNIl5AVHlYIviCZuDFgtGW1cDRzExtYAfTvyOliah9dAre4vY7+kn84atYynnwmaM7FzE7Rcf1gPV8MLatfzmyhunKq+vk/G7kU6AvN2cMhH2a1ZFu5t41IbT7mUUkYLAgeU3IsofSiXtedDLMIcmanZSU/uSGl+Hng25Fv4pKvpIxpgUsL/y/buHG7OQHdtKm9vKzT+ZIGize1GLkvE0HLhXbEIeAA4+AxWczrtF9B0sfgmMpELz/5i1dgCDQfTOsV3asoR0xPcUJy9MJ44asDLTXRPLBvv/L94PDhQDb6CalD1HxUqL4ZxvQfN40ubgs4VxJhxi4RUcjIKNI2ZhYasgIDtYP+Jpfs0vEL9emME2t7IRNXMfdGLrc4BP4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4866bd-3ced-4252-bcea-08dcc8267e06
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:24.4467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnY/KiYcJZny/uiZei0h2n47kLOJBr//WSy0XWyVNL9TDxAlgDzv+R01pl1nGw0unLoWAjTSgR8y39d3F+I9Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: xkN8KsI5nR0rKh6JVSxwLJrsiOo2VR-B
X-Proofpoint-GUID: xkN8KsI5nR0rKh6JVSxwLJrsiOo2VR-B

In verify mode, we check a header sequence number and CRC.

For a job with multiple writers, we may overwrite blocks and this can cause
verification errors.

The verification feature can be useful to prove that atomic writes won't
cause fractured writes from multiple writers. However, atomic writes can't
solve the problem of verification sequence number being incorrect for
multiple fio writers.

For verify mode and atomic writes, ignore sequnce number issues and tell
the user about this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 init.c   | 14 +++++++++++---
 verify.c |  2 +-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/init.c b/init.c
index 84798b3a..60f240f8 100644
--- a/init.c
+++ b/init.c
@@ -810,9 +810,17 @@ static int fixup_options(struct thread_data *td)
 		       strstr(o->filename_format, "$jobname") &&
 		       strstr(o->filename_format, "$jobnum") &&
 		       strstr(o->filename_format, "$filenum")))) {
-			log_info("fio: multiple writers may overwrite blocks "
-				"that belong to other jobs. This can cause "
-				"verification failures.\n");
+		       if (td->o.oatomic) {
+				log_info("fio: multiple writers may overwrite "
+				"blocks that belong to other jobs. Since in "
+				"atomic writes mode, this should mean no "
+				"verification failures, as errors in "
+				"sequence number will be ignored.\n");
+		       } else {
+				log_info("fio: multiple writers may overwrite "
+				"blocks that belong to other jobs. This can "
+				"cause verification failures.\n");
+			}
 			ret |= warnings_fatal;
 		}
 
diff --git a/verify.c b/verify.c
index b2fede24..7ebfd3dd 100644
--- a/verify.c
+++ b/verify.c
@@ -854,7 +854,7 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
 	    !td->o.time_based)
 		if (!td->o.verify_only)
-			if (hdr->numberio != io_u->numberio) {
+			if (hdr->numberio != io_u->numberio && !td->o.oatomic) {
 				log_err("verify: bad header numberio %"PRIu16
 					", wanted %"PRIu16,
 					hdr->numberio, io_u->numberio);
-- 
2.31.1

