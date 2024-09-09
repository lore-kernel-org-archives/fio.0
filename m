Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1381BD008
	for <fio@vger.kernel.org>; Mon,  9 Sep 2024 08:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725869565; cv=fail; b=YswmdmP+a6UhKFnIIiCWu6haWLymAGQPp0G9UeFUmNUMQ3kT7vIitBM8NfgEi34hUwQAZVV4/wO2w8KEda44ZBpei4g1YoCGBzBU/8xmg3LWDSfDkQkKz5yRyy/IsRjKE/KVrGx1Zr7EzxfiXqbFL/tv051s/ofsNMifI385mnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725869565; c=relaxed/simple;
	bh=iOygyXD6nLCpF5tXLxFR66cMk3X8VNLfs39GFj9E9O4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RMSVKc68l3oWT8tRtHJqrYAoyT/4Wr3OT48MbiP2nUnqRxdqtFY31wTMRM2O1vPTrbSkqdd+lbHrcpw6YIQeRIQFLKMxyVePoHy/CHIRUDvuJ3OLg9KwpcqvVKisUpQMwEQkaun2gHHXX8qLWSOCzrrdCSfoFMxVYefB8knTbww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mYhQwauD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OJ/IexcQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mYhQwauD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OJ/IexcQ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4891tpD9023056;
	Mon, 9 Sep 2024 08:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=PP+jkVDrSPXsTLKtYobvJWUBiAS4WiSEtfKqHoFP+/4=; b=
	mYhQwauDahfZSV2MkO5+ak2ShTYWjMUc4XB1j8CIOR/WtZOfNRL44VjF6fu5wpuB
	G0p/3Th415j4UOEPVYHebP91ikTAfRI6WY2RzloNtPJAkQhkYQaGhfT39+xYXqeD
	VUtSOlBFqlWh3QLNegWyjNaaOOL3cr7n8wFkqSJS2WQsExIuVCBFnL4sMwYxKnLM
	ge1RZHLyKJSrajOYQU+Jk5nrreJG6UpGhJfCBNULPI2GKqBt3NmgzVzEEUJvsaL3
	SD5Rd7fdNeVesNHGhO+wRXabZ85/XjYO+XIIDfqsXdClOSaFBu1m1BXgsnyOv8ur
	IoY+yqVOXBKW3i0abFfN/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9j7q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Sep 2024 08:12:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4897fAwq007168;
	Mon, 9 Sep 2024 08:12:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd96vv8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Sep 2024 08:12:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qOr4NFdJ+e3/DXOBT6bhOdI5zY0xBbhehrpq3p4FXSFSJaUqdJ1+OjMykigIkxSOAmUlHd5G8ByM/ZuqEZAQBBwFdkDtSyusaGSxBbEzRvNHF2pQArX2ODExsWXE3OV9SdpoUwUbW1S4xrGw9t0zP190arWH2j4Cu2+wLOjBtRqzxsNay9TXDLaRJvLJP3LDUIgUIiPCg1uPR3/T2Mp7shccJSHzb3Mt8cuUm2tV2FPFgB44GegpF+Hq1ia+bwE8NXQW5JMvMYd+7qSq9elPko+8gtuwhQB1B/WpMRUadyPILkjDaZKj9oTdJhEWJBLUhlFmLyB6miCVSfoTqFdv1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PP+jkVDrSPXsTLKtYobvJWUBiAS4WiSEtfKqHoFP+/4=;
 b=t2KMJ/17o3/H71j4bgpU7oudP/Gi7m64EBWZ1GoZlly43UVtFCLPh6uqlltr4QFn7lR5kzZ/7VXR1a3SwBqW4yKiAWYlQ3Lsn42QKlH5d7LwDMRJ7C8xEk1s9ZSL6/uIyaikfhRSGzijsG+9Bi5M12rhMopofl74Uk9r8jZf/NAPo0uBVQWTHw7wOi+3hYKLwjK8LWUG/zMw9imUJZhutDTSY4yxLIddPBzNY4NfYLs8kiUIzjzyPsyFjhJJdl5FZOXAGINiypxB/PbOEf3q/FDjtUU+uetMKz0Xxl67pJJXiLIM4QZMLWtB5UA7o+YPu2kVti6s5dwq4EcuF7woOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PP+jkVDrSPXsTLKtYobvJWUBiAS4WiSEtfKqHoFP+/4=;
 b=OJ/IexcQJaxhprCiTHutcvc7ai0dfP1EWoFpWvutfQMu6q+5WhStP1PxtZOGiCp63QeEm0nnCfuW4JYMUDpTMroBCawbkVp3Qqp73YmiNPl0lGvjKTe8Dg4mFkvUzWrSQUDE5vTXgED9FdsAW+fCYdm/dmazPgJ18AB9nGCPVfo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4463.namprd10.prod.outlook.com (2603:10b6:a03:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Mon, 9 Sep
 2024 08:12:24 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7962.008; Mon, 9 Sep 2024
 08:12:24 +0000
Message-ID: <76e0cf08-e0ac-4443-b107-86e7d2e4c23d@oracle.com>
Date: Mon, 9 Sep 2024 09:12:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: Luis Chamberlain <mcgrof@kernel.org>, Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
        djwong@kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
        Daniel Gomez <da.gomez@samsung.com>,
        Dan Helmick <dan.helmick@samsung.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <Ztl72OINsWHeq4pz@bombadil.infradead.org>
 <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
 <ZtuQVTC4MwdzRDsy@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZtuQVTC4MwdzRDsy@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0038.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa56c51-7036-4c13-fd36-08dcd0a722e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXNLSmhQWFBESkNKaWh6Z1Z0c0lUZkNlWEhWcXRQTVBXRGpZQ0NTZkdtNUM3?=
 =?utf-8?B?aGlyMDM2aWE5NWY2cE1DT2hDbER2bjFqeXpLeDBRa2h0TlhCRE94emZPQ0th?=
 =?utf-8?B?WlMwbWt0RnBhNy9DRkFtOEt3TEpqU3NLYnpNT0RQT3dLVFptTGpDMjRtREZw?=
 =?utf-8?B?bHpETWorcWVFdnFROW04YUYxak5aMVVudVJqRCtqK0E1cTNpYTU1dEFmekxp?=
 =?utf-8?B?WlEzTzU1QXVYR1cwVlZtZ1lNOXdJVFVwT1Z3WWVTMlFzTzl6WnI5ek5GL2xW?=
 =?utf-8?B?dUVMT0toQ2JVMEovTXdwOGF1NE5JNTZIQXI2VEU5N2QyK0UvMTF6bXVhbnBx?=
 =?utf-8?B?RTh3T25UOXNYQ2laVjI1R3c3YlBxSjhoOUVJdUgrK0RRRHMzZHUrQmZsdVRS?=
 =?utf-8?B?UU1Uc0NkVGtKWmhVeFRyRFp4alhiNlI1S1B3NFlYc0l3RHdIS3ptU3dtVHp3?=
 =?utf-8?B?ci84ZDlmemVIVEh2cGx5ci9iZHlVY1N0M0phUTJrcFNoOVBjVzgxR2ZLOXBt?=
 =?utf-8?B?YjN4ZFNsTXhPT3BwSXZ2UGFWc1FRaGg2Y2lYWk8vY2tGMHpPSjdCbzgxSGcx?=
 =?utf-8?B?MlBWNzhCWXNSYWlRRk1EdG1oYWVTbk9iUVAzS3lsOGVFNmVXNlFwVVJZZ2hV?=
 =?utf-8?B?NkR2MENKanFRcVo0Z3VtaXRTRkxyMWRPRkdOZ0tkNUl0dW1CY0oySzBwRWU5?=
 =?utf-8?B?eGs3L3JaV0FlQlBWaWRQWVljYjQ4elA1clV2WUpDdld4RmdRTzBETWx3ZUNS?=
 =?utf-8?B?N1pvT3pDUjczMjNZbTcxb3l3NjRaVDM0NC95Mkp4eXVPTzdORTdaWXFwcmJ4?=
 =?utf-8?B?eGpiUmpEN2NleWJUVHhkZm9Pd1ZEZk93dzFVam84SWcxSlNnRzUyejlWalFC?=
 =?utf-8?B?UzRLRVg5VVBrWVdTd2s4dlpWdGQ4czVkbGF6YkUvcW8yWVp5aU1hTWVpRkhI?=
 =?utf-8?B?eW4yWWFDTXZOSWMyRWpKcUdCTyt6cmhLNUxGZUJlS0RMOGdqM3BDaEw2dGxX?=
 =?utf-8?B?STVrZkl4d2J1ZU15QjJ5T1V4bjRKMk0yWThSd2svb0dIVngwd0JHWC9UcHl4?=
 =?utf-8?B?TitROWw5N0poVXlZNUZzSlZDSTNjY3ZMajg1MjEvZUNEWGZQTmJLL2xGYk9C?=
 =?utf-8?B?YmZEWSs1dlpWczh4M01rUFZGSldUNlo4SmxzVDBqQko3ZmdmNm13NkFnUnN5?=
 =?utf-8?B?UWxvNUpnd0VLc0QyU1V2cFZjMzM1YjlENTl5Wm94OTRsOFdNUUpxYU5rOGZE?=
 =?utf-8?B?VFhWeWUwdnhwYmppenByb01wdW9qZUVjMjlRd2RVWkJ0TytuVit3SWlGN1ZM?=
 =?utf-8?B?Lys4UmNjVXI2N2V6VzFrOEZITU9JUUdob1Y4Z2FoMGEvS0dhYUwzSnZEWDFM?=
 =?utf-8?B?M1pYUnJSeFdLb0NyVE4vam1SeERuMHNwUVJBcDRld1RXcEwvQnpZZTM2TTZj?=
 =?utf-8?B?KzUwbloxNUlIRFdEU0JSRXU5VHFjemc0bXFwdnlPRE15OXN6QU16T1VLWUJS?=
 =?utf-8?B?TGhJOU9rVVFZczhtMVY5LzRkcklFOElqVzVaczMvK1RITXliSFJoaWNlVGNP?=
 =?utf-8?B?ZndlRUxscHZvOXhGcUxmSTdIenV4LzNCSTRFOXQ4TzV3MXVjT2pYM0JnakJK?=
 =?utf-8?B?M1haV3VxckV0MDBDenJWMVZ6Q3VuakNwcTZLeVFZL1NTLzdIbGlUL29mT1dh?=
 =?utf-8?B?dDFXTVd1Uk0rbDFGc0NMamNpbHJ5VFlKUXg5WjlhUmRlRUVDQ1NVTExza2ZU?=
 =?utf-8?B?VVhGRVBHV2UzN2l1c0dzUjM4c3YrRStDY0V5MnJrcVo4U2x6QzBYeC9zbHc5?=
 =?utf-8?B?cytSYWJQT3BXQ3BXYlBWZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVlmWkM0aFk5OU9KUnZHeFF1WkMrMDYrL0JTL0VRMEorci9ramVORXArc0Uy?=
 =?utf-8?B?cHhnSGtFUEI4N01wdkEzd3poZGR6MVhLV0pGcGl6c3NlUkhQcmVpUVdvR2hq?=
 =?utf-8?B?a0REWmNad2lOUHdvUmRUWFhiK2ZoOERtV05mUGcyaWlIeDdlSkxBamwvM011?=
 =?utf-8?B?bTN6WXB4T29hUnFYU2VHYXloanFpSGFJR3BYaW5EdU1XaGdEN3VGcGlzUnRO?=
 =?utf-8?B?Qm9ScVd3cG1SS25OUW9jYmpkSHhwM2kwY3JYQ2ZXMXFCU2tnblloaTdjdlNT?=
 =?utf-8?B?QXcydDVxQjRjeGJ5TnJFRGRLbnNIUFRFdzIveGFCZkxTaEQwaHFwYXg5eUcr?=
 =?utf-8?B?QU9WTWg3bjg0TWdnMUQ4YUVNSG51bkRVaHl5UVNScmlEL1U2UGVKZjc3UUJZ?=
 =?utf-8?B?L1lWek92MzVTTjhCQXpISVdnM0t2cEJqUFhGNEFjQk53VHEvZU4yc2E3eld2?=
 =?utf-8?B?dUt3b0lVR1RTV2JIek9GVmNPZFNJbDBKczFWc0FMTk9yakVVYllJT0JlSG9L?=
 =?utf-8?B?WHlNQzlGMklxM2NFWTZUSzNrM0tTN0xCbjNJRlpQcC9lanljZkcxaGNuM1Nm?=
 =?utf-8?B?Wi9RS2hUQzhpNEZqaDM2eVBRdWw1bWo2NkdwVHBqTHRFRVFnQ05xOXMvbzdU?=
 =?utf-8?B?NmFsLzZxSXBmVEhjck5WQVZMTk40dVlDbFhyT1loWitBWkNwRG9oTEpVTHpa?=
 =?utf-8?B?MjhRWmMyUDR6YUxrWmY2R0I4MlU0cGxqNEZsVHpGcmE3K2dDaVFWcXFqRHdt?=
 =?utf-8?B?ZVZXMGo4VGdUQi83ZkExU1R6K3BUZU5nbWlSWWJTcmZZcGVBZjVFaW5ja0lt?=
 =?utf-8?B?cnorMGQ3bXlVTVh3cUJ3dXBqc1JDWmlvUm5uLzh2Z1VUWTM1ZVVuemY0TG9u?=
 =?utf-8?B?ZnJ4UmdWL2NXamd3bVBjOG54VWdXcjJ5SFFXckZMTExocUJOdndiTUhUOERN?=
 =?utf-8?B?WVpLNjVMYVFtYU51bXB2SFVNZnhVWUh3eWZZUFpxbWYwb3NNMWRRcE52Vkpq?=
 =?utf-8?B?SmxNdkI0TDVhRXpIRUo5L2NVc3ZQN05iQUQ3Mk15NmYxWFFjeHFqbEQ4bDhI?=
 =?utf-8?B?VHBhQjdhejlBU2VhNTYrVWtLOFNGL200ZmZ4QnNkMmswdmdzSk9XejdYNGli?=
 =?utf-8?B?a3hZWVNmL1hiY3RoMW9WelJyQ2NDMmFRUVR2SU02alVvWmhHNjAwM1RRTDNX?=
 =?utf-8?B?RXRqeUZFYk0zZUNPNytPN0xQK1QrZUxzQVFlbnFLSEs0eGR0NWVOK25sOERZ?=
 =?utf-8?B?STkvejRGUzFXcU5uOE44UFF5L1BIRDRKTVFqNGJBTzJBdHZzR2kybFd2NzJ2?=
 =?utf-8?B?ZGRJUHVlQ1RQb0hrZThSeit4ZkJDaVBCRzYxQzFPQ2hqVjh2WG1BbG9wcmVP?=
 =?utf-8?B?RGZmTjd6UGtaMVJYeGxRNzhROUQ1cWpMdngxdUNlSEg0bUpEQ1JsVmNPTjY5?=
 =?utf-8?B?QlRsRjJyR1cvWDZPYTJkMG50enhHODVlb1lCTldFNUNFS1h2NmkxUDZHOW94?=
 =?utf-8?B?M3dJRlhIb1FFTk04MVhlcG5qa05PTXlnbkNtQ25FOU03STA2dUVGdXlhK3ho?=
 =?utf-8?B?OFE2eXhnQjgrcFZmajkyOXg0Z01rU2NWNXJHaHVMK1d6VDdQM0lRSTBmK2J5?=
 =?utf-8?B?TlMweGExM2VjWUpnZmJpKzVYVFhhZDllVTZWN2RlMm1zTXhXSDJkRTBaV1ND?=
 =?utf-8?B?Q3BvRnVZVnZoZGpiL2pabmNRN3REWVM5bXg4eVljUjdSWWZrN3hTNlJHVDVY?=
 =?utf-8?B?VS9zT0djY1VOZmJSNlhPWDBKWG9pZXFJa2pWVjdxeHNpOEgvVEdrUVptTnIw?=
 =?utf-8?B?T2RPemF1RGluSzQ3dlUzWkR4SkxZT05rN1BuUllpUG03YmlUV2g4VFU4VWxO?=
 =?utf-8?B?TFI4dWswbjlEY2gzWDE4ZGNTZDVPSVhjU2g1cEtpUEpjTUFOTnFkaXprRzk2?=
 =?utf-8?B?akREaXZqUk05c3JLRXpOalRXUUxyWVh0ZGxxeUFHS2tTSkVrM2k5bE9IMit0?=
 =?utf-8?B?djBqWjIyQnFBWERDY21XVlA1OStHOXp1OXZHN2NVU3Z6YXZUYUFPVkd0TGZH?=
 =?utf-8?B?RVZnazdqdi93MGV6cmFuN1pKUVpZTGhObTA5Nm82MlJxZENwOCt5TEdFQmc1?=
 =?utf-8?Q?MfuRUoR/DzZIc9v1v+sIAXPh9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iRQ3/6fmw2l1fOFhZw2s9SOPGRFtNF15+yLCJXeVt/7kvRel9J/JDDtLVYWYBuu4YGQZusXkgcrtSekSv6M4wM5q7z7lcTq2CEW2gQS8ktqHsEFTuP3Ur1PHvR7CqmLFW2lkWSnZ8QvZVN707qJ3RH9F18P3oZI/S2tpkT/CHaO5U/qHlkuTCoj95brXshCExPnfYb4bJ/g4JWc5KlPQCT5oFbnc5EQLauxWLef4+ZPE0d3P5x90sIiz7ubUO6IF/dJg0MOAM/wX8UgLmxp3wGpOZir/iL/SK1jLk6WAKkY+4/BvAonmBbMTfhij605WvbUH4LKIoyy8Ysd9KYOgJCGY6BfcfSwIxLcIFm18uWtwO4ts95O5rRbc29duFdK57VRP+J3e+6wLdxhcJhZhWAjNeHj49SDZWzYoS0iW3gAIBKdoVQ2cYkdhvDPKnEbnJLxLUQQWjccYzxsp9Fkv97iRkO/IzQOdQ5smQMEnLVrRevlN/PrrTfeRzLsDchSjPh3owiqcUHANMgf6gojx9KIgZiNlA9fFpY7ZSvZmlDuvkW2Zao9akn4tzejmYlaPIW+5BMWtyaJzCbr2OJv+DGJ12oXuIUSHPpluKjV8qcc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa56c51-7036-4c13-fd36-08dcd0a722e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 08:12:24.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltjMkyrJCISlxyKYWd55FgTtkJnt20jwy7Q7wiDiCpqox9bj5ocaB5m9pvdjlqYSAjOmHXTpzqOYjd+6gJvyfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4463
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-09_01,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=989 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409090062
X-Proofpoint-ORIG-GUID: X6vObWAz4TvHrj6Ke_CEJbLVWl69WUIB
X-Proofpoint-GUID: X6vObWAz4TvHrj6Ke_CEJbLVWl69WUIB

On 07/09/2024 00:29, Luis Chamberlain wrote:
> On Fri, Sep 06, 2024 at 04:22:24PM +0100, John Garry wrote:
>> However, if we have multiple jobs, they may overwrite blocks from other jobs
>> - fio warns us about that. As such, in verify mode, the read sequence number
>> may not match was we were expecting with multiple jobs running.
> Is that a generic bug in fio?

I wouldn't say so. That is just how the verify mode works.

Fundamentally verify mode is to verify that we read back the contents of 
the file as expected after each iteration. If some other job comes along 
and overwrites that data, then that cannot be helped.

However maybe I should just create a new verify mode for atomic writes, 
so it is clear what the verify operation constraints are.

Thanks,
John
