Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5329518DF61
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934696; cv=fail; b=qtaOp83ePPBC/rPkSEophdumLTBE2RRsIRVDvF9h9WrzzM4wREly5+8y6elb7XNyExSTvgiK/rSIpr48QfctqQy1/h3GQz+s1g+UrrObU+CnTYoSnqyCi5z6Ct73YC8Kv299J0vnlAhnG3He2d9hHHI0huiu5GjX7CwmCuOpcoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934696; c=relaxed/simple;
	bh=O093XN2J+JhygRi2WNGsXkalMfNadDXnvusaxjDxN8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SaTfnrW+ByrtAa5d3/DjgakN0BVkk2TF1bYyVEd1nxFWQ3kN8ov8nuQ+71DRPMULxr/fSj/za0DViy0+otNLyJrugHWXdWktNNA/Lf8FCnLoBFXujdQOM9zH2hI15ASQBKhE49GOWKy0GPCNtVBA1Tr1CqtdHZ5Y6XM4Az+/nqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FzeD1xMl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J0J8OjAp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FzeD1xMl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J0J8OjAp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBvb3H011190;
	Thu, 29 Aug 2024 12:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=fXB1D59P+9+skRwhaftU55/gETOwM7+xFNbUoVKVCW0=; b=
	FzeD1xMlmZDnneofOHNRLE1COeRmCd7hkBCfU+yhGxhBG1UQ/GtWwPWUhrvk6ze6
	6u3VWttwk85G/07v+LBc1WzWkKTAvSyLSjE8lcl2AEfbJkqA1uJiWl8v6DdWxBgS
	zlxxBd4wa6eobzB3+Og/JM0sQIth50ImEXrvC4ebuDHtKNzrvoNmwTrSPZy9Tx8g
	YdpJr44Hj4axQn7PEupBCjrUy36pmYDOBylvFULMMekb5MBShpmtAE9qTaT21zwL
	9oMjkizu8O1Hzhiz456YZ4b9GUC0C3H+3CJmnpmuNHZUwDUG87Z8JJT29hLBeVwt
	RIvPY2SI6jRcqZLlnU9f/Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pup45cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBreuQ017427;
	Thu, 29 Aug 2024 12:31:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 418a5v29k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KgN3Z9msIciqipAKyLL80RGTVpRzg7un8ObDMIE9xRsgkkmhyWgVK1OT3WQaptKp11oSkKTo8nUHmC1HVebYoFJWmrnf1X2mvIm4YW/mDbV2fsSWz73STKD4Al4Zcdqa5Rtyc8FbGOpTkVYxtnrZfvR95YX3Cx8i33kSd/fTPK2roY6y928Yeig08h1GvaxJ+4Hqkf+jjU9w+XhOW1IlekMf8Ica/cC1Thcco/S1S5EkhnC6nJT7J6XCywXURKv0gaNu6JeRNbs4BkgTJi3Gb1oRo+S4nxUsuUYAU9tID/8jLLxwTqI331GY1a3BmpZRnIC+E/mqsq18ByudCIYKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXB1D59P+9+skRwhaftU55/gETOwM7+xFNbUoVKVCW0=;
 b=J8GqfiL+XfoaOK4lDXD6nPhueilza44U4UifrdD/58g1y7RAqsJmZVgopPE/wzBAOnZBNnif+5gz0TtxPpkwn1V/4epXnEo6dSW7TPTHxL4kwxDiyaDk92zEjmoAj9j2f9zRRS8tRSVuvMX6IWW+ahlfJQyDYpSyXMh6Igd6NtGKHIoPG2h0Ro6LFyeiyfSeCl3C6iHLeEBk3NcE/5mZpJ3OSv7bSPE7lJFZEbmkN4WWXD6muuUKgSaILMQK/O3i3t4Dqd3j++EFsT1VxCP6/nS0hBYNp4EZN6vtQmTyHRWM0/P8W07wJ3gnuuJ4FHw7PpokKkCIvNWos+VeJ7sYCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXB1D59P+9+skRwhaftU55/gETOwM7+xFNbUoVKVCW0=;
 b=J0J8OjApjhe4U5bDBUYUHqhazRqG4Te8VmpsKd6hliBSebMJFSotW0GVShxyyD56xLH1wvHHbRD5b3zMNbewVsei2yywq424HK31pyN9U8PVVI/Y3G/gqc4cCs2Qsep66lzxiH29yXVjU6LWUB93rOY/2VPRDSLoVHtnX/yRbKk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 12:31:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 6/7] libaio: Support RWF_ATOMIC
Date: Thu, 29 Aug 2024 12:31:06 +0000
Message-Id: <20240829123107.520005-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ddcfbc6-90a3-41e0-6c71-08dcc82681bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n8PSPwNQtkl6Ex1Iroe6ClQNiKhYroKHZ6I7/lsXFQr1ZJU2NJQukGj7F2ch?=
 =?us-ascii?Q?NLDJn89bjNJOWEvYheVkGMUvBKV1cT5wbqEV6D+jXtG5aUTZw5VOBEd8p4Gq?=
 =?us-ascii?Q?JbwjJV3k5s3/EkWG6mMHmPyt+6z9eza4kRuhN3icg+1cnGIu1CPaDx3fF/UU?=
 =?us-ascii?Q?1CYGscoh753nC6cfQ2ZyfEdt2c+IqFBWtbUutXVohzioYDdRVHesRq7yMiPS?=
 =?us-ascii?Q?f4Fvc5wkXVG6yL28fn5xs8rsDVVgSD9Dy97H92bKrUlDdVjLNxWtldE+atbF?=
 =?us-ascii?Q?uyEUoeqLzShGSBxNvPR3TSiksGgsfbSFKJYNn74lx0LpnJ7V1u4oFeUH42a2?=
 =?us-ascii?Q?pkVycVGym+ZqRNvb7hcWsknuDRg/dhmDcynUhKrWXa+IDTW6s6YN6ZBZugW3?=
 =?us-ascii?Q?4FplegLlaiq4Zo8ozG5gji1qOKr4ZmeXhbGwEZDJFfljpGDmsukPX8mH9Skx?=
 =?us-ascii?Q?U5dVfoxno3V06TWW4ing19sMyUx6SJJlD/mTMxTITpbZKAj//1n6Dwa4Te0t?=
 =?us-ascii?Q?mi+GWLXab+8tPgJb3jlhRzDCqQKGsDBWCTfPm2LIfTj74HVMhmub40eI0bCi?=
 =?us-ascii?Q?1cbDSDAEVhYBY2OyYftax2pmvOxSHiRjzQpUEDEXsPFUFbmsf4XoZj6C5WV/?=
 =?us-ascii?Q?r63qf+XE7lcqMoNq4Ctj5H45aGpI15hvlGzaYtRGnxPumLFj1VDmTwWZLd+x?=
 =?us-ascii?Q?OYl9TgdcBvizantJmghHRMUEjqYP4si2aYG4ZBesE1m+CNhoCU5ji8/zL9b6?=
 =?us-ascii?Q?uZMTOvTDCzH6eS333PEgbFOHpvfknq+cjW8zfxchlzOtoK3xICxwKyvytyW7?=
 =?us-ascii?Q?4a227sNDbf+dFahI0aO7JrJWOdVmc7lnz7kpKmkjNgGZE8gpCmQXyQYycfXU?=
 =?us-ascii?Q?mov2hGgBu8TSFXd9rA/Le82itlUmvQfL6tT8jeZoZyuvUTL2BkjbuWpbBWGT?=
 =?us-ascii?Q?Tlz7wefaP+6AkDZEjphYdIhOvJB7CPDnH2qj6gANt2k1DleSr5BcWNol9aMk?=
 =?us-ascii?Q?VrEXNhzFdwMhTe/ANU/1/LUEYWWhJk/W/K8G6YVy8LvuiVCK5a5X8ROPjEIm?=
 =?us-ascii?Q?EYdzFBPPjWYt4ZKDNHtS5F3lwuP3/sYnX6zlutISG5KQ9uYaPIP7/+ObFO2b?=
 =?us-ascii?Q?ys2dgxUBf4we1f6Fcym/HueZQm/Ih5Ol9berB50FxYEvAuLxNCelEDB9D/Xm?=
 =?us-ascii?Q?maAJny8rPXcsMUkejPc4KmWSxj8GIEWbC2LaghtMWxm6AKPBG9ITv7O8/sW8?=
 =?us-ascii?Q?KfQsVM2Tn8qbxM/sjBBbkBwGdF7zyFPfv8YoC2vK2m66DrJ7yr4OxSzEX4W+?=
 =?us-ascii?Q?oWwKPMq0v1m4N+RgYmF+euUdrZqN7K1rewWGeqhNtdyCJA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zgj0B0Bg0nJYibdEA1O7aKCYigiOORtunCR8sV6rjQ3+wpQ3F0PBhXmcznHQ?=
 =?us-ascii?Q?y+ypl96tEO+2kXz4XUp9A4MU4oI8DPpjCyKKoQSIV3iAIMxZkulSza+7iBz9?=
 =?us-ascii?Q?Z56doeG35n2ZH9hJiDujlVjiNGIq36RZGdolyUvgBokOsTUwpL5n/1EUm7f9?=
 =?us-ascii?Q?eF9W41C6heNGdYtXqurntvNEl2VFvM7YdL85wBJLbcbuEyc4V5pdj7OfgDLa?=
 =?us-ascii?Q?FDR1JNAncF/XX59WMcX8En4EUm52XE5cvlX/eyE9EdS8jrtyv+b4GovNoC1A?=
 =?us-ascii?Q?Pl6AaTPoDIW0aDK+ntKFagysMe06x7orou6oxkiho6CAy/H7RX7UMr7ny6yZ?=
 =?us-ascii?Q?gWCgLcfrgFjFzPNeKdggmxthAppmN6P/F5AoEkS72UdshYZpyAfq4vlfkhp4?=
 =?us-ascii?Q?C1xGMps3dmbA/x6SeOP3UueMIK3WPAB6n18btBiP3eTeNx+phTNl2L2f7bW+?=
 =?us-ascii?Q?uRn+w697ncnZM3Hsm9jEwvvV+1t1M/tdpUcXH3iFYzL3+5U76PoweN+CrfaN?=
 =?us-ascii?Q?Q9DTp4vPKDCg1USyDsC/wi9pdwY8XSJn+H8AWcu9GDHCaEtqcpKMDLLYccot?=
 =?us-ascii?Q?2YcxGZMWrPawEXeDNDJyi8sP/XTHpEQvGqLVYvxqEXVJfIebMXvanL7hn2PP?=
 =?us-ascii?Q?kjM0SvDCIg84GYU++/YTMBZISOwF2T6uFtdt51lytv59zVzpdnQSjr8bO4Am?=
 =?us-ascii?Q?ye2Zu+0GNWrtexXzqRzph+DKF12rG4BSRtTl4ffTcM+cZOgDNMAdLzS42SBC?=
 =?us-ascii?Q?0bXR/tQemfsPYeNVgjfHycy4yDNc54Dl3R2i+T85r+u3OYjZ1qS5RUBwl2co?=
 =?us-ascii?Q?Vr6TC2uL2IT3lFH5HXwZXRPHI/gmYX+FvOi22n+JGHEH4nPYGdgI6lvbOimC?=
 =?us-ascii?Q?nG0NGoI/M0IrTMO65S/MCflhE1bGwhZS2s8o5q0q+I+EadoQG/LyrPb/87sx?=
 =?us-ascii?Q?ikiRRiEBw9GZmVUYX7KCE2it9qW9NQxWdajDwXc/8zHuMefolaIzmN8YpoA0?=
 =?us-ascii?Q?emW7mPU+PwlA+N4luqrCwk5UOajkeZExRRAG9LE7dfVZjSKf9ZsHxXJHgIbH?=
 =?us-ascii?Q?fAPy2dvx0mJcUD6R4O4Mfl0J+BdGcSbly3sQ8PQKxvi4MPPE5yzUUdj0Nw7c?=
 =?us-ascii?Q?uHJrids+iIS9lHoL2hS2WcHzYec8CYlonOgGWSjppcm+vjwBLLRqrcuVpcdn?=
 =?us-ascii?Q?vexlrlH5izwUJXPguS4EYmW9LUgFncOkdBLgOq4S3mxiNSE1kacrVBItEda4?=
 =?us-ascii?Q?DF46mf24Zf/NemdGZJs4LEBvS3zt6IiXzHeC28HqHcrJU48yZg+ka/4taN6H?=
 =?us-ascii?Q?NL5zLsHsOiXP07JtnOkJEWGqRL/DILFJrK0I6EiIYrM40NQa6doFeIzdQ77F?=
 =?us-ascii?Q?CDpjEZj7hrCdTprdNT6/PmLIRbiYAQgMR5NbJKQT/pdIWSJYQwEyrcf7iQHg?=
 =?us-ascii?Q?QYkasN3P5Ov8SzOlWWMhKrwm3DbrXbWI3sEsWzuO7oxnS1S1vKdO4/AG9z6s?=
 =?us-ascii?Q?/dK9zD2fsCWJb2gFN2byVMXD3Uyjw2jlYVAd5yC0JtUdBoOg5/GMYNrRdOIF?=
 =?us-ascii?Q?Dh53EUmZlnZF+Jp271IG7XAufsXQ7C4YbjBZ25Su8bwa9yso0Css3wbeVs/i?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cwqPAbXyo4sfq/k6WPHMvZOJlD3dccoOagDUC40FVGLNNDZ2oQLn5QuetjNG4f+0cMGihuCr7x30m1YV8kXAlhgzeS1b8Y2wKqyDakCGlELA/ib7uxS6EIwhjfS6EwZa8VHW10GXrqtxn801aDuAuGlpHIMNwCtPZcdwyD+fSPDIIldVLDDiUDtXvh6l8jIgHL+cfT5GeXIzj+q3Qie/8yZLPzssuk3fgf2gb9eWAhOkvg+CwlpoGNP7CzOLZS9l96K/f0lG//tQJhocnPZpxH+JHnVT56Vg72/cIpZ5CyQN94FWvXmoqYDijajvs4Jpeu6PV6rqTGZy8J4apoOzdWbrtcIM6ayzifGhlDXTylp2GDHiE6yUHpG9uBbOximQlI9639T0Jw987ac8ADO5lW/2ijTeNInLt3Rx0iq3Ymis/HEff8tyHVShC4DY+vQjGpvfrEyoHcKv/XPSVlVwCT1zr5Hek0axvrneEyJwrqeEJVbEpyNwIXquiLk7WePY0pTPmQOE6xXyanMj1rzEL+jvSb6hudVARR7vyW7eGtK+45WtwEOAKJmT5fXWkiK2SrmA2TBSurY2PAjcAt9WViYVI/bbQ7SJ5sKGmD0MT7k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddcfbc6-90a3-41e0-6c71-08dcc82681bd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:29.1519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMMywE8NeKE9OJz2X4smkZh7FtMYUe8772NtUpvaBz3lgTdHg/F5Vg9ZzRjSbEOeFAr8oCdDt36XPcSVgG8Ijg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: 4XiUmNf-enrOMZNmyVz5Kol1m_flILj-
X-Proofpoint-GUID: 4XiUmNf-enrOMZNmyVz5Kol1m_flILj-

Set RWF_ATOMIC for writes and oatomic==1.

Guard setting RWF_ATOMIC by FIO_HAVE_RWF_ATOMIC, as only linux supports
RWF_ATOMIC.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 engines/libaio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/engines/libaio.c b/engines/libaio.c
index aaccc7ce..c2d43793 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -110,6 +110,10 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
+#ifdef FIO_HAVE_RWF_ATOMIC
+		if (td->o.oatomic)
+			iocb->aio_rw_flags |= RWF_ATOMIC;
+#endif
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -440,7 +444,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_ATOMICWRITES,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
 	.prep			= fio_libaio_prep,
-- 
2.31.1

