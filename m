Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4D21862
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934683; cv=fail; b=DQp52PzP6jHBURMWQrwurexr2jNSC3qLqrwzqlLoRrgn2OdsiF5sYExyy7rjH75e1WgrB74JM6m56Yn3DzReCr+YppuFrnoq1/K1s1ZxX7bErpzMY3WMe0AY7qftYz8KGca+d7yj484tPD93mcKkLoKaETKSAuT9DlHN3RAAziE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934683; c=relaxed/simple;
	bh=oaLpTYfL1PoX8y/3cg2ObdAOa3rhXS7ve1MBGvoZq+s=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=QdxXpBS69nGbQYlS9bRkHtoeDRsQMynbq0Wy17y7dZ5eHZYKa5Jcaw4RUObJwLm60cfrWlP5NE+/Y+yAZxvzT2+tbZO69j3YzXrLCVhJZ/moievq7nBcjqSStOEp+vmLBPeMcEc3IGjBuOCldZKjIiDt0pvQd/UwBBOm/EfnORE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hne/6Upv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E3QK92r7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hne/6Upv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E3QK92r7"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TB5KQW001437;
	Thu, 29 Aug 2024 12:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=/+JvxL8ROb2UJX
	UqsYkBHwqV/Yqa4SEe3XXFGYtpGP4=; b=Hne/6UpvaK5/6u3k+Pec1XWJbeLlgr
	4i5/djn0lbBFjVfPF1sKFUgTXtkZ79yJuHm1QY5hw7fcfk79VAxQx17/PHYrLkBU
	OwNFJYk2cYYqN5ERvFBTJxYUQQzV248uXeG7/z2afNa4BczYNLWPNUkCXUm5pJex
	T+9WojGDUzZ9tZDGYj9ag0BCWMz108R9N+DHwfs34VftAUDCj9Zbpp/n9GwyFvcj
	ma1nAT03I9ETc/Z0kQWzMUMUc6q7i8f5XqNsqhdKWVSMYK64OtPWv1ik4Dzucb4R
	pLVYYXwcKz/kVVoJt7rD6dsLIkgTw8Jus+4wx5lQl/J4BRNI+bPGibuw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419purc2dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TC33En036491;
	Thu, 29 Aug 2024 12:31:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4189jn5j2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EAprCFG38xDV2fPVwiHXuXqClUmQArIj6n5rXVqEskLcnJAN/+o7TQWwLGZwmr4UaNgnAlvVtd5M9JHaEFm1/SMTkGFasrJdHYXXI83hWKIuZCf3q5tdYbt2NvDpRyA3gu5WxG7R2vaAYHBU8BIRqdK/rpUzQ+LciwmJ7ojUU1+l2b1ab6kxzyJI6kq/+7fcKduhXmRlP9UoMEJUtF5mkU2xW2G1WVjXmclQ32bsO4uXonBd6eErJ4JnM6Nm60OyDL+1y+a5OJxA0GpcMEhHc4abWwoR6gIVW9vsBGaZB0v3kcINLV0UckMAwZc3uq4YD5zcjaqCU98zVEKsEhGXKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+JvxL8ROb2UJXUqsYkBHwqV/Yqa4SEe3XXFGYtpGP4=;
 b=pd4SNlVzAc9t8oe0HXAiqDxDRz/Gyk26EFVrPtmr++24pCjaBq6BAr4MLKeK4ersx4yqPEGmIYOsV6aoNN5rAffXuDkPgoqVeLvoX7UVp9oi1J7KMGtIW1ydcmgEvHqPKNhXLX5mNqKwDQ0mWAi6liR6BI7gENqRXz4YQ81RfVN6dmrgKpTVgM12lYbbo0o6hL3w2V3evyG2zy63KefD48cdwrvR5SH/8Nx9kjdIBuFt6XdJ2hZEtxb3e7PySgjsFNEU3sHjep8lnEDEJz98y8Ns0nfZwVhN5VRt17zbOJI9v8W6kFD75Yu9VXciqlFbuG1Oi9vOjiQta3Q3Gf4PYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+JvxL8ROb2UJXUqsYkBHwqV/Yqa4SEe3XXFGYtpGP4=;
 b=E3QK92r7graYmiXM9ltsoB6bFTjYBiiFvZfKnLso9KUCxJhYMpl+EHU+84sfmwmIxR9tuCfHwgL93HHwWb9xN7fUzrUhnG5OVYvKCieYzHDwgSc3rKNYk6A/pxcOOHrsFff9n+d3gMXplF3qDaZ31dQsrls40mptEULgKs35FAQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 12:31:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/7] fio: atomic write support
Date: Thu, 29 Aug 2024 12:31:00 +0000
Message-Id: <20240829123107.520005-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::41) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 58150193-35ad-40f8-387b-08dcc826784a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H9/UjdccdD5vcFC0UzHimlEatGLLuWfMwWetu5V6RSMakDxzA/vRFLp++Ck0?=
 =?us-ascii?Q?9+hAexMr87eIftMryM9WBvlqx6lfvRHohQoEvLX5JDqOR0K52GEOloceiaV+?=
 =?us-ascii?Q?gn00v+wf+/8PzM8ly1AcMNS/1xcniP+4iyA93WmkKbqAP18yaiTiCAA2oJUc?=
 =?us-ascii?Q?jaX1pXxALYa2oeAn4gbpJBQPGoPydhlPpJ2bfEkxMhRsJSU3JxqJOWwNNSCx?=
 =?us-ascii?Q?1RLexiM3FMgm8H9QhjsbBTEVoyf48P2t0CXkeKEdFwSQJ1k256MC9/uiVZrM?=
 =?us-ascii?Q?LYvAEYaZcuS29okXsnswEZIaCo/ONUuJEVZqlt9XCLVKiXVaeBrkRfnZVY3g?=
 =?us-ascii?Q?+UbSHP9OgjY3KZ3xorwzioVG+32evtWZ7yWIGfkiD2P0SpZF0VDu4f8iDe/g?=
 =?us-ascii?Q?BzFdkoV8U2I6YwBJsqhyMBs4lpAGICVvy8DIwChLjsT5EoDS7PR7FFwGActZ?=
 =?us-ascii?Q?fUWhDM+CqlGsQhaWRxFcCSEOjfEjdx9O8Vygqazl/FwVs3iNh2TdrtRWsZJq?=
 =?us-ascii?Q?jeIGBXsvmCmL2/zn45HUZ7kqrGhsiYHyjYERrCMe/KbSxCcdoaKTegn4DBZm?=
 =?us-ascii?Q?yBgzYRr6uZRcPQxbVYf87h63hQDE14BrNHSmTDXtGuLRVpcQRS15gWB/f7cD?=
 =?us-ascii?Q?VnF9Z9btshdCYD2WltHCw76v2SmumOiwjNsaNZLbzNv4+uluODPUWzHyk9sl?=
 =?us-ascii?Q?zFDguMOT618Di7rHEP8f28+QzuyW550YlmlPbSlskgU50rtudAsKMXgraoAT?=
 =?us-ascii?Q?2GU/irHlYvhKUBqbCfgn34IgO+tC5/y0J48gfCO2yhT1ZYsCCLgeD/hWL0zV?=
 =?us-ascii?Q?nNJy8HseOkl/GZGyNtlYTLwz0ul/lRBeaCnaFY0UAM7/nHu1Yf20SPj1ytWc?=
 =?us-ascii?Q?24ROs8EEVAxJejkY9w0bo4Ao23XU2E6e8IFbU64/DpPW/RhQbAd3gbrfVXz/?=
 =?us-ascii?Q?++SmVAvQzzggO1QdjT3IvKGT6rxKq50j/YQY5+SMchx+5jjwOwHhQMKCkDp7?=
 =?us-ascii?Q?DZEM5+C0S95T7Rv1583fXDIXr1CNbUOgu/o0jM35318JaLe+RovHSqg4WAJi?=
 =?us-ascii?Q?RvAKw25fRt/oOsbCXso0tFkJ0fN6qqi++C+yOnaoIGBUfPHrEohLurNzZzvC?=
 =?us-ascii?Q?6YJDdpPA9xxjoahFHgpJTpR8yuLBNCvG6JZouhUnvSx3jhrXnhDVMhSrKs+1?=
 =?us-ascii?Q?7miTA58/QW+Fhk4Y0wxi1ZfGEA7z6M9S7eE3JA70fjsWpK1UFKzf5BqRxd78?=
 =?us-ascii?Q?KJEdB3vKl3rse+vEmLM2bGc5b/uha/bm8A03KXgmlij5Nj45s1NmwY8uMnPL?=
 =?us-ascii?Q?To5VFEKO1p4MmE/EG/W5Q3bEXu5RLfsPcyxtplMETX1h5wljH+HUkkSjZpJE?=
 =?us-ascii?Q?gwVr/rU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ef6iia8CvlDARMebrL/w/wvFfSqAeAXrX6HTMMuv1L55HAG7znd1znUraon?=
 =?us-ascii?Q?CEOGufJaoLOgIDIrN+AEmPDSfDx7ivTTlw2OCzf7/PI+gP3vom/pyU09dGGe?=
 =?us-ascii?Q?OJAg/9c90eoQnYvlxtke3piwFhogLbm/9wwYWFXU6JLj7Lr47f3pTaq+u+oV?=
 =?us-ascii?Q?2e6V1JJjbvhAwNvRY4Yls70DHbdlfMhv9ZI6AIgTyGmKkrTo1bft+RWMH9V2?=
 =?us-ascii?Q?Zic0U01n+RRa20L/EvpMb/ttTL1UxAVTV3+uRCW4MVoKOtUA543Du3W5Dcsg?=
 =?us-ascii?Q?Kd4RdyaLGtHbCduUqSOc30e+Qf1VW28TfJRWxV6FYsDiR2B2UgMqxxP9D2fU?=
 =?us-ascii?Q?BkzwusdXk2uhWBbNR4i2tKurosVsaQI/zcpP1MzVvniJjAkOXRzdY3/5gDFX?=
 =?us-ascii?Q?UU8kXbVEFyY9hAlhaF/UhY/rpsJbvdzJ5W3xEQbEHXD8u98uxaLQYFq4xrN4?=
 =?us-ascii?Q?P76QgJtjjvBrFoS8I7mFlbMwQRJ4vHc0DQYBgQXQbZCwACIlcr+MV3Oo7gMc?=
 =?us-ascii?Q?YWhUQyYmiMAu1hxnHUPDDmxcY6rFx7HqGaSgmNSAbLmWG7zlVnBfeAPrHWt2?=
 =?us-ascii?Q?4LRPTgysZ6jLFSV/Z/Oj1FEBzIyNxEDKFMy14mmyR89nWP8lwelEFxcJvdx+?=
 =?us-ascii?Q?QqO1+zOrm1uhdkfGlZmi/XbApJJp/b0DivKmFd11elHWzTCNfj31hHvQaVNp?=
 =?us-ascii?Q?bXB/EmHffAQUL4fTl9sakVLJ2B2gVhS2PFzUoabLEUZRMoy8z9q+ZiCEpzSf?=
 =?us-ascii?Q?sU3E6nET36U7G4CxSbxHAGs81Eh/WJxH8E3vyPjR4eoseuAkKMJfe3IWX0oq?=
 =?us-ascii?Q?X+x/Lq+dvIehXtdOFOIg/+hOpq57AsNdiNa6ggfdZykCPlB6X3BLGj1L8C4k?=
 =?us-ascii?Q?KZamci7JCtgqZX9Ur4HyAJJLS2tAynb2LpVlOGVBiufu3iFAWMgWxTqnPtl0?=
 =?us-ascii?Q?cOaFnZ5VcRHfSAh7dGC5mNH8rZjvO6zqvY9vIf6zAJZOCFlVaZGgIQLSCeTW?=
 =?us-ascii?Q?IXhM7PBsrd7XNvmKIqTTlN3+51Ya+RY2uImgT3PTP2xiM0WHMChlfIlXZ1Zz?=
 =?us-ascii?Q?qnEAhtqByr1/pCG+MFVvK2OcucPv73k6wgwitsAjN/6ex3yQenkAn5BOHxmC?=
 =?us-ascii?Q?XXPjq0DywBlvlxWwxrKT8Wp8LTjafITVsLy58wD4UJ7rFS5l2nWUuZ6hFXS0?=
 =?us-ascii?Q?6HnaB3G1+teb+zuiIVhv8VzTB0J2Dk6AST/l+aE84bkmYwjFYxh3GNbP47QM?=
 =?us-ascii?Q?OeArE4cju5x3pY9ENlsoyCOMWrkiZZ9Ywkl7p10p0EJzissq+ccPM/z7+W1X?=
 =?us-ascii?Q?YdFNTGV88BH413dGXbNM7ehi3/VDsvjSgM/IVTNSL/Mjyjbw6ydAPzwvXUJF?=
 =?us-ascii?Q?Wk2L/SXCcpax3cUlBJkVgYROMFMqwgbOeQzp92ENamZ2/1l4/sKVahIzWzLz?=
 =?us-ascii?Q?c20hkor7te8cjxTk5m3ygHKlYTAm3Qm9Zfj/9LN1OMrYVJpmDh87B5KhZB6Z?=
 =?us-ascii?Q?WKfFhctL42syklQW6GTLLMJFmAwMkqTLGsDxYbSnzsFzoDMglp6ZGxQP/Kgx?=
 =?us-ascii?Q?62mdPc2p/2902LEVL+Z0mi42HNwJTwCGvc9c5Kwki0FUf5otlj1ZoVodvXaG?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rMolAshfBwRLbpRM9QGVJiwXCO6h0qscd3BWie9/e66l2da/+1Pivs1TnPWGRADDXikACg9IiE6XOmti2z+tBGCW8tMnhjLsKEGTYgdCjaBZDVb9oy5TM4dE7hX+ZVrDaFDfax+eWpbPgCuh03Vl3aVlzgzuB8/VPdXSeaXb1BKRLojaT+da2B9J3thjB6/jSrD0kDAXUVtIc6TGHA/3LCtTj/BAVedX1z/3sspT8axRPv5VYhxWY7k/aylvkJPmfxxJcpdmd6ISu43h/YNzDmo0gFUeqOxuAdD0X2hqUT1d58SVPza1xdnWC5QRJekt9IAK/y1RWCmunOPfvJza/8QQiVKfLLdmb3/GHlguX+0/tXo9F3jW/qq3Q8hJ7Ob0z6d/Acmduf/UKak2N3ACgfO93zs+GUTX8B/uB5A36qrPT0B8O1ENRHGxSNPGrw02bSYc+Z91T6O/dwykF9UgcRM7BH/MPa4E+ABSNXcgxU/538M3b+mcXpDlPZt3Q0E2gSBWCsi1Uz0SRJcw061l8pFswOn0u1lIck/qj3AcMHtQXI/iqz/DNv2mDwXV3jXyXQFILqXoLGSalrpVXDMXzZ1hh5n1GqUPj69uN30Zin0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58150193-35ad-40f8-387b-08dcc826784a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:13.3287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Vm2DzYSWIzMJCuVsG+wrGVjP/FLMtF6YJkEts3OPKypbFzkOzYJHY4DZVlV3zrbmTBO0sF+z9WirkMFe3ikdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: MXVkQc1i0XL18jbEeLIAf2kevSahH93C
X-Proofpoint-GUID: MXVkQc1i0XL18jbEeLIAf2kevSahH93C

This series re-introduces atomic write support.

Some time ago support was added for O_ATOMIC in fio, but O_ATOMIC support
never made it into the linux kernel, so fio support was dropped. However
some plumbing was left behind; specifically, we can still pass command
line arg --atomic=1, which sets thread option oatomic, but that is just
ignored.

Linux v6.11-rc added initial atomic write support through RWF_ATOMIC flag.
See latest man pages for details of RWF_ATOMIC:
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/

This series uses the "atomic" command line option to set RWF_ATOMIC
on a per IO.

Support is added for libaio, pvsync2, and io_uring ioengines.

Since RWF_ATOMIC is only relevant to those ioengines mentioned, trying to
set --atomic=1 for other ioengines now errors.

The verify feature can be useful to prove atomic writes. However, atomic
writes only ensure a proper CRC, but not sequence number. So sequence
numbers are ignored in verify mode for atomic writes.

This series is marked as an RFC because:
- If ok to use pre-existing plumbing, I am not sure whether setting
  --atomic=1 for unsupported ioengines should error
- Whether verify mode should ignore sequence number always or we should
  add a new option for that.

John Garry (7):
  os-linux: Renumber RWF_UNCACHED
  os-linux: Define RWF_ATOMIC
  os: Reintroduce atomic write support
  verify: Ignore sequence number errors for atomic writes
  pvsync2: Support RWF_ATOMIC
  libaio: Support RWF_ATOMIC
  io_uring: Support RWF_ATOMIC

 engines/io_uring.c |  5 ++++-
 engines/libaio.c   |  7 ++++++-
 engines/sync.c     |  9 ++++++---
 init.c             | 20 +++++++++++++++++---
 ioengines.h        |  2 ++
 options.c          |  2 ++
 os/os-linux.h      |  7 ++++++-
 verify.c           |  2 +-
 8 files changed, 44 insertions(+), 10 deletions(-)

-- 
2.31.1

