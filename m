Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D11A01C6
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 17:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988661; cv=fail; b=jeewpeWvBAW8BJubeXkEhixgCVZVZW3/F6AerUDM6XtsUTXAud+piqYu4H7dFhmwT0wMOqxE46KVuPNVNNfJ5+TLUCdvnH+mm0R21i5GU3keQSiQJXL+eBx5QEX97Rh5Y5G/bNhuOyvod7D8vREMIVNthmvxVJT3Le6brNP/LPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988661; c=relaxed/simple;
	bh=DUpkgVTrgIy+sEHoT22lNaWMj0/jb9fkvl8yum9Ptdk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ehOhUYw6SBd0HyWyg2dJI7bTu6ckEDtvENyTAx4esGWvOpNkfTHkOUMU5vgvEyC9GHa2mEET0Stb407efeyRWmTWlAqqyYwLM9w9XOoHevK0bbzoAOuGJAoBKgy08CGPGn2aDPOT+b1gR5SiWEMSLsDzxxBRCPKPmgKay3s8s8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SG/zHPjL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uX5d0utI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SG/zHPjL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uX5d0utI"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AFtV7j031456;
	Tue, 10 Sep 2024 17:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=DUpkgVTrgIy+sEHoT22lNaWMj0/jb9fkvl8yum9Ptdk=; b=
	SG/zHPjLpsdiaWoGM2IFtSRrjP32sUoNy/6gUPuATv+HHXvxsFlagDiHk+94OzRr
	e5rOb/afDtha4YvYkWeKSEs7fN2C3UVt+wxF4SYs6wQweQfu9SlHqeuXVKAoavBp
	LDPmiexLXWdFSG1v76zpegcrC3nFQV5AM13E84iYmR1ZDOpwPauCIrQiQ5bNGE1E
	KSIHFYSAEgsfqkxQu+7yjzrvxfzXsakRnMkb4ljrdeYFlV24P7aFjJPETl9jQrSo
	/XmgVc/G7C1XiGSrASb2WQ+KO0GPbDNCQVGgHegD005lj2MYHr9uAYuDnugZL+9V
	GWd7QLGu38YpeHE1+EA+aQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2p6m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 17:17:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AGbwjh040860;
	Tue, 10 Sep 2024 17:17:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9ab5gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 17:17:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GUaCxoQrEBEblSn1mAQ2sczeR2gU/d68X/IWsLpvU81avYDDDyCJhF5+1uUXhFafW+LL6FWvc1nFgGVWEmbDWhAWeLxhyhHhv7K+HYtByuZaIjLRhE2vYRVsohoMCFocAaUxMZfO5Na3Sx4l5j/vODMzYayH0L75saVf4FfDV7T+ZGdrrFdgjup0T1xrq/tfmt+tZsjNmh8fjdOYPlI3XCixVoztKBInx0N/9w5b+I/biimTWEEo1mqCkaOwMBS9eIIoxz1vrzkHLIyPT2RjDzrwSAH0mKPJev1nDVQzZ3/RmHH4zka6VPqjRKa6E+p4TATJrmv1zm1VwKtood2XeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUpkgVTrgIy+sEHoT22lNaWMj0/jb9fkvl8yum9Ptdk=;
 b=sCcJrm43gIQGvkV2fMl7ZYrJ65K7/cQH7RyC3pUrj8XsNerz5lTTVbtrzKU2zCbIp8Q1Xg44yflA1Xehk7vrE7hQfl4jXFblMLw2FNPFVWDI7neLYg6tjWypiT1SDLkWR4CLsuAeAonnrNnJp4ahKZGDnuM2gyXFZ7VMC14HG03xfTerRc4YDReA6cJrkNrao8zP1dh6VwKOd4AbOQmX2kqBCbRyhxMnLn3TDC7uRN8sp6003sG2l/c3/S/UOWA/rIE0lAEuTGMCQN44PumYzSMcCklnj1maZ/P1ffgMxX0UmDtlJRkj6p5Osr5QGXl5Yap9YFODwGYwP2uJVDlHew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUpkgVTrgIy+sEHoT22lNaWMj0/jb9fkvl8yum9Ptdk=;
 b=uX5d0utIFV82cZE9eCmGbt7wseboVWkO0UFSWvRsc8KxyX46tU6OpmMATLu/Y2VvRim1jP0olPM3BVRfmXu+RQ055W4h7+vKeqNLAYWa2qIbaVgaY+VD0ZWCJXgp6N/kbdaehZ4ymopwufVZIUhmibmK0CiiEjiQpq9pKLHndCs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW6PR10MB7615.namprd10.prod.outlook.com (2603:10b6:303:23f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.10; Tue, 10 Sep
 2024 17:17:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 17:17:29 +0000
Message-ID: <0863e51c-28c7-439a-b262-29aae7618957@oracle.com>
Date: Tue, 10 Sep 2024 18:17:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        david@fromorbit.com
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
 <1185aac7-de61-4071-83fe-802b52e458e2@oracle.com>
 <f689c9ea-b677-4521-8363-1c4f2f3c81f0@kernel.dk>
 <7255db3d-abb5-4371-9cb1-e12cf41f979c@oracle.com>
 <80443d11-538a-46cc-ae81-c2f945d68ee1@kernel.dk>
 <df880559-4408-4bc7-811b-353699c467cd@oracle.com>
 <3660f96b-ab31-40f9-9cfe-ebf5e84b0a4c@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <3660f96b-ab31-40f9-9cfe-ebf5e84b0a4c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0265.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW6PR10MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: c84ed4a1-f1b1-4feb-58d9-08dcd1bc72d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UU1rbDhqSmxFL3dBQ3JnZTBCajB3UHJ5RVpwY0Z5bS9lL05nTzR2ZUdpaW9u?=
 =?utf-8?B?MWFYVitHLzhzOVNwOTYrVUNKdmRDNjlXaEhXWmp5ek1KalFZcW14YTJHT1NN?=
 =?utf-8?B?cTJnN0hTdnMrTmptWTFmbVlMRWlraVpQa25FbXErcWxWRVZVcjZPN3ZVTFlU?=
 =?utf-8?B?R2crTmZES1NBS3I2NkpleUtiVktGOXJNMWJuZ0hSTnVaU2NrZVlmTzc4NitP?=
 =?utf-8?B?NmZpMHR5NXBtSWNZQ1BqVWtNd3BPUHhTK2pNelZYcXVxbU5ZNUxZdjFOU2tx?=
 =?utf-8?B?dDRlNzBFY01nU2pKQjd6L0tQajRnRG9JOGlYakhlZUI1bmN5NVdEZk1Qb0dJ?=
 =?utf-8?B?dnhGV1NXNFVCUVVQR0hmTnVHSEo4Zkt5MVY1MWRKQ3AzTzlIS0d4SE5OVS9k?=
 =?utf-8?B?elZJME5uVDZUZEtvYmExajFSQWVTcEFCWEV5cWN2OUxTZDUxMW9lNkVLeCt2?=
 =?utf-8?B?eDZ2QWE1SGQ2UDdiZVc5a2ZEUjRhOHNXaERkT1F5NFljZjlyTkZIeitYdEsv?=
 =?utf-8?B?bktKdTdXTE1Gc1VteVJsUTB3QVJFbk1VaGhoUUpNakdaZ2t3QmNvWThySWFy?=
 =?utf-8?B?eWcrejVjMXc3OTMxMDdXK0grclJ5aTkwUTdnL3FOcGk2UUl2L1pVRkNWSFFQ?=
 =?utf-8?B?OXl4cUc2Q0ZBRkFNSUxDVkZrY2wydmNTWmQzWEk3Mi91Nkt4ZXJyblo5VVFZ?=
 =?utf-8?B?b1VpMjhqbi9TZ1dUcGZha1oyZ1k2MTNpRkxFTHNiSGczdFJCSFdNOVI2bHlv?=
 =?utf-8?B?aFloRHJWL3RqZjNjVmtSb3hmdVI3WXRmS0NESmxlVmNiYnVRdFE5ZHJIOUFi?=
 =?utf-8?B?bWgxLzM4VmQyTnlFKzg0bEFCRUUyaTNEUkRudWQ5dE1JbHhYZVlNeUFiYXdT?=
 =?utf-8?B?VFVvMzBqZGI0MzlmNGRBR0dqdWpEcXpCUDFjYXdjeGF3RzVqS3YxcGttY3lP?=
 =?utf-8?B?V3U3cisyRVRZdENZSVJlZ3ltYitRbUZuRVVEOVVOWmV5TWx6Vk0raldZVWY2?=
 =?utf-8?B?NVMxbE1IRmlqT3N3YjNwZWtUMWRVT2pWSDBVazB3dytKcll1VXZKNG9xWFhI?=
 =?utf-8?B?UUJwTGVLOFh0dVFnTDVhVXNhL0ovUlRkUzhzbE5OVUZoZkV3UEpNQjRjR2Vr?=
 =?utf-8?B?b2FLOWU0OGh0QkJsd1NIZHNkS2wxU1N6QitTbWtmOGdKTlVZU29OQS9QQVFh?=
 =?utf-8?B?R09HaUkvUWE1NkxKRGhrVC8xMEJsVURld3R3MkFlTitiM2NqY2N6dWRGbnJa?=
 =?utf-8?B?enBlNDVFQ1F0c0FYNVB1OXVnVnlxOU81VC9FLyt0aW5mVmJsVUk0VzllVDhR?=
 =?utf-8?B?cnNXVW9NeTFhN3h3ME5Rd0NNT3pNQ2I1RGtMK2VSODdKQXFCZFMzaTd2RkZI?=
 =?utf-8?B?VkRoYXUvbytoOGJsK0FvVDIzbjN2RUNZTzNEWjBMdTBaTlBsNkY2ejgxYTBY?=
 =?utf-8?B?MThEV2paazF5S3lIUlZGRkdaTXc3Mmw1SU5aYjlJS0lqR0g5SDFsajRrQ0po?=
 =?utf-8?B?RzJSZXRhOHdOaklYNFQ0R1lCOStsVE1WY2VKNnNHZ0NhVjdiMnZyQ3ExcEpp?=
 =?utf-8?B?Q2t3V1Yvb1ZVc09nS3VyZ0NicDFhNXhndlhKYy9OY3oyY2tEQjBRT0Vna01E?=
 =?utf-8?B?eEt1eGtXWFBSRWdDc2xaa2swTHJ0eFo4TW9pR0pWa1FOeW5TRDI0eVJlbDZv?=
 =?utf-8?B?c1Jtd1I3N3Vvb0NCRURnUmgrL2p0UjR4cW1TQkt2RVp5azF6UnV1dG9ibm9u?=
 =?utf-8?B?emZaZjVkblRVNXpRZktJZVFIWS9ZT3pGRkFZdW9HUk9mUlkzS2VLZjdsOGpn?=
 =?utf-8?B?dWRYNFIza0FDOFFSSTZlZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1UxRHZ5TjBDcjlGRmhQcE0xNXUrMGdWRUtUMGlWcWFPcThjTzNLQ280Rzk1?=
 =?utf-8?B?cGFKRzZEeGx4NWdPWVMzN3hEQmxDeFNVQWRLRDd4bVdvR3hxcUkzRXI3RVc1?=
 =?utf-8?B?VUgrWHlmcGJSL2RjSi9VM2xzVG94d2M0MnFya1lZZkpaMjg0N3ozSDdHVGdP?=
 =?utf-8?B?UVRSZ3QzdCtuSzVxQWx1WHhvRnRGbkphaVYrekdvbHlnWThVK1RIV1NUeEdT?=
 =?utf-8?B?dWhkZGFyTnpZajkyV1haUlF2SUJPOXZvbWZQVGRYakNQTjZ5MG1WeEgvaGcx?=
 =?utf-8?B?SjF2d3NYeEM4bEl3ZTlpWVZOamVraG9oSmtWL01kLysyNlNEOEtzaFhnUVhl?=
 =?utf-8?B?cFBUQzZuREJjalRKVUwrTFltcFIyMW9VOGMxRWpnN01JOFI4ak5iclRhU2Rv?=
 =?utf-8?B?OXBXcDY4ZlFhdXg2MmdJV24zdVRCdDJUVGN0bEw1VGE4eE9DZksrVTM0aEMz?=
 =?utf-8?B?MnpWYUJxbHVJQTVDdzNJcXR4Z2JPbEh6Q25VOFZiaXpTY29EVDVXY1VqVzYv?=
 =?utf-8?B?U1p0b3RVNENEYnp0TjlIVzlWNTVPQnQrK3V2QzdnRWs2MzJmMEFNeVpyOTZj?=
 =?utf-8?B?bFROOXppMWJKdDdBazRzU3VLZmd6RWNWdEsrTWlBSmVvdVpXcmsyWldwY1VC?=
 =?utf-8?B?TnRyOXZ1SzRqbkVrQVdsbVdFL3pzcnN5UFNYaytPcVRrSjlPNTlvSVZSMHJZ?=
 =?utf-8?B?QTFFZWZmaE1wZVVjOXhES0dOZ243MHZ4S0pyZ2JIODFZVi9XQzB1Nzl5Q3A0?=
 =?utf-8?B?c1p4RDB6a2hvZW1qK0NsSDluRDBPaGJyQ1pBTjdyaHlISE1sVThiTjVTSkx6?=
 =?utf-8?B?akE4ZjQydTUzUjB0SGJzZU05RE5CNTIweE84V3dScHJwMGhTeFBmbW9SbGZT?=
 =?utf-8?B?RjhpTG1QdGxUMGd1ZVBGbEJXd2o4ZjFzbmFaQmZUQkFDRzFvbm9rMU5ENTBu?=
 =?utf-8?B?ZDlPQ1BHSlIvalJaM3ZwOWErTHJ2R29SSkx3cW4vOWJTTW4xN3k5LzFXSFlQ?=
 =?utf-8?B?MEtBNjR4VGhNcEcvOE52SjFtQk1aR3QzT3pBSElybWoyMVlKQ2FDYjVZUHpY?=
 =?utf-8?B?QXI3UmV6WWJaU1c4a2h4WHlISmtzZElLM2JGelhISWRidlMyZFNHL3QwaGRs?=
 =?utf-8?B?MFdPaW02R0NUQ042UHBtQ1Z0R3JRSzRVMERnZjlzeGZwUzRZc1JzUUF6UlB5?=
 =?utf-8?B?OVR2cVMweEVSN0d5ejF0bWtnSHg3QjArTDVVYlhXOXFmMG1zYngxcTh0WCtr?=
 =?utf-8?B?cDNFVzQwNVZiNXY5YlBEWjkybGpzeVJXakM5blhROUhiKy9tM2lLckNNRXNX?=
 =?utf-8?B?Q1BzVDNOSHRpdGZUdmNjR0FCWXNuNXN3S0VFVlRSUmcyV25tZTN6ejhRUUxy?=
 =?utf-8?B?c2x6OHFYM1Z0N0cyWmhjUGtnZHZ1eWpyVkVtOVc4ZnNEa3ZWYkx6RnpPMGxm?=
 =?utf-8?B?SUwvcWdmQ0ZNUG5XWFBUNzAyWkw4cDVmbVhldnN0MjlYQVFtVkFESmNJdlJl?=
 =?utf-8?B?d2laZllHcU5Gc1ExcjBLcnVRY040dEM2aTJEMlFEU3ZaOWc5anFrcDczRHFu?=
 =?utf-8?B?RGVRVURpNUtVcGVSK0h2WXhkbXdycVFhVVVZci9NWTJnOFZVV3EzRXl2bVlB?=
 =?utf-8?B?aTJhd0FPR1NZdm1SRm5FU3pGdnorbXkzM3p4czkzYTNubmhzalFFS3pZYnJX?=
 =?utf-8?B?SUIrUUh1UmhpKy9jNXlwbytkeVQ2VjBnSHpsOHpOeGFCaTd1emxtZmNqY3NZ?=
 =?utf-8?B?UTUrU1RSYXZEUGRFdWgxZFlXVlpMaTlxVDZCMXFGeXpXVUl1VldndW91Sk1i?=
 =?utf-8?B?TWhYdWNldTJBa3lOK2dDYko5eWh2c1hQVGlOTTBqd1pQZEdvbWxzNWFPZld3?=
 =?utf-8?B?YnFiYm9uMDFBUnJLRGxPcEcxUFFVaGJGZ1BlVjY0R3V3bDMyTmZ4aElKRjRM?=
 =?utf-8?B?QndKUlA0Z3V2anlyU1BPRlFYRUVaZXhRRmJQTUsxNTFwYkI5RVVFenFQZmM5?=
 =?utf-8?B?YVQ5ZlM4bWh5OHBveFgvclB6bU01Q2dlUnVyZnF2cWRsU2tMUDhvNEJ2LzMx?=
 =?utf-8?B?VVlENTRGb2lmamtucHhLOGM1ZWhIWVRXNEYwbTg2eGNuRkk4L2hjUk9Xd3ps?=
 =?utf-8?Q?LFoWY6fJMVRaZ5KVHefdGESsK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	36ZRBvHklL21OOdKOp9V9fNySvXhCSzpjkjkZjSdFydSnGZQm/QaoLtYRfLCghMdDhUwn+F/TRHVLjTHI560HApBHt9BwPxRq20Ikhw+muo0svoc7WzGUeZGnI8SHA+3bz3sv/Y6KtMIOuZVmB+wdQ286qvUuO1gV7eL7nFhtxZWtVRY8U/uqE1ZDJFJYIKLPAawIZcJ9aZSaZlle54cKXOtwpKsnM/qAIscDHtpfEGQhDLuQcMwwBofgWvTn+tdTKu2Gqaktm9mt0TvDQWQkxAwdtB+Pa+KjzpwpG4UuhkY+7Fh8xWN3a7JiiBZTu3aBXwrQ/ds+RQd8K4/cr1NqsEGpwrD/IEslAzJuRBWlwWH/zhdF1MfwYGeMHm6s6SNU4nxEMDzxcxsYUXj4ixhdv3HYsZqeDu56ssv+So0/+mfmBISu8yvFgM8Ohln5N/L0WKxcJcbqk7lMdknl98Y7nNmKOWWFDiXfiWCPtQ69OXj1Dox9QQC1i8nmdRwgDCXFS1YnE5Eg1FZYlncWfXJMnhN7G11ovC6cBwpo2sBlW5b1FSY6GLj+jA2QfqRw4KdCRoOQdS8h1jVkmb4fcQTg1srXw07Ctm2yoyp5cxMZes=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c84ed4a1-f1b1-4feb-58d9-08dcd1bc72d2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 17:17:29.2858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJ+8KJV5EOvVMiWRJ/Wbw6smxLRggpfWtDXpxaQHOG535NRVs7AG7AeQsjy0k+6VLEfjLUFNskt3gszwnu7VCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_06,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=908 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100128
X-Proofpoint-GUID: XyqQaFEV4HV_GStLAvLLGhCc2itHxciz
X-Proofpoint-ORIG-GUID: XyqQaFEV4HV_GStLAvLLGhCc2itHxciz

On 10/09/2024 17:56, Jens Axboe wrote:
>> ok
> This one too 🙂

I won't write much..

but happy to make suggested changes.

Thanks,
John
