Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6811A3BB1
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725986343; cv=fail; b=kLkPOh5kYhXYvqvw4Z0MQndS6OeEQnmjknrnrbcAsZkyTLhMwCt9/JP84bbNH2JmLAZ4CzOjJKzAvJ2o+czHqbsHMiPo8opB+Prp4IMjFcJk5+aLCkV8+hvf+yQmAQrx+tugTI8AkDTreU2DKlIxL1AExIXV1S1cF/tMAKH3VeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725986343; c=relaxed/simple;
	bh=kyc/MLsKWmUEfjBkO7HaHP1tbqAX+kQuHz2MHLaObOo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BSMOaEQcr9YsogSZOwodU/4qUcfHbhZPQriaA2Qwh1tsXTMtwlWO6R3aeccHadFwhgGVPQH9dwAS3lJKa3LBFURalq3omXLcfKuaXWcHLmXjICg1dQAq3WQoX3T31Q9NY/lZM9TnwkT3r+aWzylFRwAENUVEYd91rdokKiyJ3cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oqpZlItM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IJeyw/2f; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oqpZlItM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IJeyw/2f"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AFtYUO026275;
	Tue, 10 Sep 2024 16:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=pIrY8VLXAAFygjQj3dQwsv0dWFGCN1PmEIfuNGrJ39M=; b=
	oqpZlItMkWyD1OWbR1VMieUubn5FtH+hAqaQfQRhPFI7UGElHGKCSTuOqUm2oGaP
	6i+F+3qm/z9A4FWohgjqAAxbB6zF6J+lKa18vRG5uh1h5LHE3MOPbnOth1sKFWa0
	r0q8Fd7P4mgCUHS9gKdhGMkr7g080cbSXHjUw91tKE8E1VRoa0UAK57lx1cA3rA3
	2zZD/mamlmciBDzRHvfyfQibYS9G3hyR+mmt5V4yL0L2k1rQjhXHqv+QixoIgveN
	x7E3FJWohR/LweGOhHZ6HkT+kjC2V84NoO9WL8hLD/4MkHymOJ1hcL2DB68weOb0
	ValCKxV1pojOAtY95a2Q9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrb65de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 16:38:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AFPxNq004179;
	Tue, 10 Sep 2024 16:38:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd98u45a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 16:38:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGpG8LCHf3VVgKRkkHV0FGyU75TBosKPd4AADeo6gDcYr+eE4DNgsRigKNrW4Wvhwt8COwfkvaLs6w10uivNljc4DpwuSO2glJ03+otgAHX89R3iJIftQvQI89RSzdT5HVP7R6hxyWUpoJdwfRYvlouFtgddFkNwl62Vy5EmeKMqkjOYtNBaNYhGbglo4Z9uFtbjutjE3w5kJhbF6OPFUSdhqBehf2Mx44wHmsAd2XGA0XZL6RY9fr/cxJErQ6V5Yp6etqcA3hZySF39j4/X8nm9RCfcfxglb4mYeRM3XBmCoO1HRhNjjVTx9RpX5Xh5UNvZ8179UNQNo1Y1lUZx5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIrY8VLXAAFygjQj3dQwsv0dWFGCN1PmEIfuNGrJ39M=;
 b=s+kMS2BNJ2vcMnhwHLHmCju2nO9uMjtm4/cW2oIo0DjHXgeWuTrzGpT7gnK//FYrZ6RUOZplBg7n39h0L13L6FUjS475woeSL5uSPoJ2CJqHrpbN4DhC9bgoYHfepoluSvr1Pj/olhPJZSZDxeReI1pQSVP0aHa42jiRMAOMGIWWMtOSHOR/JCfS0tOc5ugHscy4s/yrjZ3uc+ox+VqtCZE4fTD+AuqZ5fM2fq/dhWXwoZnSv3w7W9Y6RrDtLGA6PhcJNBLRZ6hUD+mbCxVFb3RCzy3PVmX89afwXG5t7hH385+fDkZdF23eK2Z7v1KByhmME+cROj/tkkY62QFBkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIrY8VLXAAFygjQj3dQwsv0dWFGCN1PmEIfuNGrJ39M=;
 b=IJeyw/2fKtQ4uN3e+qpy9JsxeNSB8eQmyo7b+NLdScX3jVaHQv8/3W914bEVJB9diTQejMyZ4a3m7Bc275Pm9TBW9Sld/o3abSAejoBagDJqpaq5KspJxlE7kthXGYZulq9OhoSf/jdPKjilqcmIVbmUngbR8/9mOqLwa26twjQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6675.namprd10.prod.outlook.com (2603:10b6:510:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.14; Tue, 10 Sep
 2024 16:38:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 16:38:51 +0000
Message-ID: <df880559-4408-4bc7-811b-353699c467cd@oracle.com>
Date: Tue, 10 Sep 2024 17:38:47 +0100
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <80443d11-538a-46cc-ae81-c2f945d68ee1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0574.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 0160bac2-ee01-470b-bafe-08dcd1b70d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTQzYW84cnhCYXc3d2l6YVVkbWRMeC9nTWxSVkxSY1B1bm01WkZKSDF6SUpl?=
 =?utf-8?B?NENUMC9GOC8xNyt5R1Z1dC9sV1ZZeko1Y044Ny80RE85c2wxVGg1NG9VeUVq?=
 =?utf-8?B?YzMzTHpld0xUeHR1Z1hVWk10cWw3Wkdncm5IWmtMN3lCdldlU1B6azZZaE4z?=
 =?utf-8?B?WFRYcTl3RnM1MXpuanVMVDNzampNMDVTU3hGbEcrNE5KeGFMT3BNL0VGYUhZ?=
 =?utf-8?B?K0VRaFdOV2NPaWR3b2hRUTdUdVQxcW4wcnFlVVVnTFVRZUVXZyt4NXFETjdH?=
 =?utf-8?B?a2tadWZyNHFaZlNUMllWRzZNdU9JQ2YyQ3NkOVEwT1NqT3AwZmJveVBuUnJZ?=
 =?utf-8?B?N1hqNEd0dWc0bFY0aWZrSlcwZU5ERmg1c3V6U3hZb2hLM3d4TjFraS8wUUM3?=
 =?utf-8?B?cWRhUW1Wd3JpNGwyQjFWanFnVjFkbWM2MDNrbXdJcTdTSkIrM2NLampiYjZr?=
 =?utf-8?B?YkFLNnJwWlBiblZzSjJZRUl1c09vREhXbjJMNkhvemRiQXBGSzkyc1VKMDYy?=
 =?utf-8?B?SXNJOTNkY1hWSWtMeGk0VkNWdlQyUmJ2VUppYW1DUGUzWUprdHZGbiswQnpN?=
 =?utf-8?B?NnRrQmY3YTZhTXE4azZhOGV0UHpCZFI5QzhlNWZSM3diMlJZMzBsNHJLQnBB?=
 =?utf-8?B?ZFZ5QU12U25GZWxLeEc4VGxXc0l6cE1zdU5oUUpBWVZFR3V0bWRpWEorTkRF?=
 =?utf-8?B?bUNUZC85Rkx2NEdFV1JJN2QzcHNRdlRZb1UvTFBFbXVBeVdPSEYxTnFTL2JT?=
 =?utf-8?B?YjNzcE1rZGhjWDIvRUxaZGFUeng3eFhOTmtlOEEvd1A4M2RkMzVXa2tma05n?=
 =?utf-8?B?MGJxbXdQY1pjeFBKZy9ENmROZ2pvSllESkUxT2JwSHFmVFYySGpuTUVQMmhI?=
 =?utf-8?B?L0p4dFBBMkhTMnZVcHhCaXJ0TTJDeHNsb01sVDJvbmJyRzJoRW54SHpxeG5W?=
 =?utf-8?B?UTNKbVh6RGQxMVZLN2FYTWNhWmlaYy9wcWZrZkNpNGMzOGcrdXlPQVZQU1hR?=
 =?utf-8?B?d2R6TkpLNUFrYmx6WDMyUDlGVmpWTFloOUU4c1E2UEJaYWJ3b0dvQ1VjWGRq?=
 =?utf-8?B?OEoza2wraktCUjN6Y3UzT1I3eXJDWUFraGlJY001cEMzQ2xLQzlHNVVydjFj?=
 =?utf-8?B?VnNySmxXbjBQclh6aGhGYkJXc3R4b01ia1VHVDdKdDNDVUNWT05DWG94ZzFG?=
 =?utf-8?B?eU9DaC9wZFRZQnhUcy84OUk2NlZjK24rUm4zTmQ2S0tQRWlSeGt2Tm5LQ2F3?=
 =?utf-8?B?cFVMSTA2RkMvZE9WaVNLWWpsNUM4RU80djY3VG5NSnp2QjJqM0ZQUko3aDZJ?=
 =?utf-8?B?YzJVdkIrZEExN3JtZ01NVHoyNVdSR1FsMkNieVhieUpxSTVsMkE2SGlQeVRu?=
 =?utf-8?B?bXdzVC9VcE9HVS92WjROVVNFOVE4cWlMZ05yN05lOStxOXR0U3RJMHBVclN0?=
 =?utf-8?B?Qkc3MmV0UG83VGlpQ2o0dmI0czd3QTFVRktYUHArZWFjYkZVZWpkMkhmZEpH?=
 =?utf-8?B?Wm5haGl1ajhJWUkwdjNiSjJnRThoZm5UMDRWVk96UnExYjhZVFRYV0JkRDN2?=
 =?utf-8?B?TlVlTmU4VTFVbkdZR0QvaVNoaHVBYWRpaWVrWG5NREZqT3NYY3hpR25wRDg3?=
 =?utf-8?B?Vm1NS21mV0J3T2RESmRqWWlhRTJDaVg5cjRid3ZkSkpVTUxsNnJTRksra3B6?=
 =?utf-8?B?N2FyR1gvMXdtK2VKV0hONHIwQ3Qyd3FIQTVSQjdQV0dab01DM2ZsYlI4NHZE?=
 =?utf-8?B?U1BLYXZKV3BteDNBaWFCcUpqa3NnTWliQmFVR1V1T0Q0REF6L0FURXd4MTdP?=
 =?utf-8?B?WWU5ZDZjck1IempPUXRIZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OE9weUNkazAzRk5SVHJUOUhjR1dQODNoWlR3TVFXYWFGVURvcUFPcXlIZVd5?=
 =?utf-8?B?Uk9uNzcrWGh6Wm5sQ2UvMFpLTDR4SlkraG50amlPNElRSU4rTk5ZeEI5a3Rr?=
 =?utf-8?B?TVBjaTk4MHNrSFJKbk1mZHlkS2ZxbVVQMjBGTDZ3RjlRZmd0Q2p0Qk5RWFJ4?=
 =?utf-8?B?MHNYSzJsZWYzRUxZbitZakw2U3BlV2RCdWhERTkvQk5hOFRIYVk2T0RVQm9n?=
 =?utf-8?B?RDl3WnlQRWJuWnhlbjBlMyt1K055T09GWVBla0EzTFp0UFF1UktVcC9GanRq?=
 =?utf-8?B?N0p6L0FQN2ROeVFMazFxYnlUUzRidzcrSXZsdzdJaW9KN28zQUY2OHB0QWxS?=
 =?utf-8?B?bWhXd2FEZ0tNT296YVVrUzE4THA4L0RCSXNMUmFZclJ3d0RWYmQ4MmNMb2Mv?=
 =?utf-8?B?clFPMDl6SGNMVDZGU1MzZWhnUTRYODJRSUpHc1duNjVOZ1VRU3ErWkpoUDRh?=
 =?utf-8?B?NThTUE50dUdkVDJIeTdlTmtaZFl4VzBTV2ZnWXZTVjRqd3ByQ3BVOFNvTE5E?=
 =?utf-8?B?c1JqMVRuSDQwdDg3VWpkT0dhbitUN3hjOEV6ekJYYW5WSHU3YmJteFhOa1RK?=
 =?utf-8?B?a2FFNHVwS0MxRUdZQjI2WTRCanA3YlJRLzNNTllJOUNYTWtCZGVnenh4OHh1?=
 =?utf-8?B?Y25uZTNhTjZBSy85dEJURm1FQk5oWnYxOXUrWjVZRVRveWxlRXNJQkNnVUp5?=
 =?utf-8?B?dm8wMjh2ZzA0cS9NRlcxS1c0bk5FTlVvK2tTL3doZEYvSGh0OXVSQU1qZGt6?=
 =?utf-8?B?VjIrdHpsQzl6WDdQcDlhU2UzVmJ0eiswRVBnSHhFYWIzOWY4YkVVeWgvVldw?=
 =?utf-8?B?VWpNbStKQ2hYNDVtNkJWanBRYlhWWjhybU4rSGw4SnRObi93SFNsRFFPZmUz?=
 =?utf-8?B?Z0ZKVzhPcXg3VmdFRHovSTJvcnJWZ3lFZVBta283cTVWRFBHTnNpMUcyMUZB?=
 =?utf-8?B?Zk1SS0FGcUpYQ1VST2QwSVI5QkpKU0wxYkx1MVZ0ZHprUFRWeS9UR3ZERUJP?=
 =?utf-8?B?ekk3eXF4NmdrQUxQNTluRForUXBINUJLQ20yT0dxZHZtUzNtME9NaVZrK2c5?=
 =?utf-8?B?OXNVSEw4NTJiZ0pHNVd2dmtXQUt6c1Q4Znh1cks1eFhDTTNqNlM5bTRCUWc5?=
 =?utf-8?B?SGRodURwazlmTTlWb09BRWhKSTNFTjNQak5ESnU1cmkxcWhJRGxyUnFxZUZB?=
 =?utf-8?B?Slo4ZWswZFFUSko3dGNaM3dhR0JuT3lqYUpGRWpqSzNWdGppakhiOWRybkRJ?=
 =?utf-8?B?aEZZcFQ2RXBScHRjb3EzVCtzalBNUXl4OTZ3Q2ZXN3lDaWxzTnhyZ21JYjhy?=
 =?utf-8?B?bE1UbVFWNWYyaGlkTWhqTDRSK3VHSzk2RU02ZTRYNFJYaU1aeUtIMGxCYU5k?=
 =?utf-8?B?MHVmdjA0bUs5RFAwNCt4SXErWG5mejNhZStXV1QrMWtPQkpjOXFnRi9hVDRR?=
 =?utf-8?B?Q251WEc2OEhtdEVyRVJtUCtsUTV2dEU3YUIyS2t6d2RCVDNmaTdhNjk1WUpW?=
 =?utf-8?B?cXpuWitZcHNaNnQrRUc1M25Zek9CR3Z6Nm9tbHBqajN0UnJxZlppTmQxTFJM?=
 =?utf-8?B?b0VRMkhNL1dPZFNEb0ZmdlBRUE5IRzJGdnJqSWFicGxlSDVrcnhvTUprUzM1?=
 =?utf-8?B?MmxOMExhdG1xbUFzM0VZQnZON25CN1Z6ZjJNTGNxdkYyRXZZUFZJRHY2SlM5?=
 =?utf-8?B?Z1crQ3BMdWVMQ3pLeUhBYVBUL1pVTFFuSEVXdUk3WTVlRGJoSXNIVjJJSVQx?=
 =?utf-8?B?YnNlbEhITWJQZnRJRnk0ZUhHUXpZRUx4Vzl3YzY4a2pIWldkc1M4bEJZZHRl?=
 =?utf-8?B?Z1ErU0pzUURjMEMvRlVOK3B3WU1FZldYRHNZOEMvZmlFQklpWHJnZW1mNkdo?=
 =?utf-8?B?UDlDTWlSWDJJS3Q4djJ1eUV4a2cwWVptZ0ZwYjZEL0ZRSUptRjhNVGJ0aDlW?=
 =?utf-8?B?cisxVk8rMzhLRzdtZW9nREdXdmFDMVZQUFBvR0pacU9zak9rQTRSanVrdHZC?=
 =?utf-8?B?Rm1URW13ZTVNb3FhQ0NMK1krWmpCRnlJQmV4azEvKzU1cFZFK3BQZ1VKL09t?=
 =?utf-8?B?OW9va3NveFZuT1UzZ2JUbzdQM3BheUx3c0JxRHhaUFlYTHFrcEkzUDhlRzEr?=
 =?utf-8?Q?GiPyBjVqT7tlNHhoiseGHoMHx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r10ugBh5sv1bY+X8ZKFWtuzpTnnKnVmECD+v4N4ehR/2R4FJVxWbIBMXiTOKdE01YEkql7U74meRsRcZEdJ8EibuCeQ++4Xa3jmAKLPTZU5POFvTm/GuYFkZA1zP43LlM582LbNx7TFD54hhWtFu18bNevlRCQsyTAR5bq30Z9xZ8mrB61NHqsEJ7EL4/2j0BafC9OMIBgZ6pYdR3BJVtvS9UpRzbJeS3I5R8Lj7sumhtofUDLiTowQ27uZL4q+wLHL2Nz5kfjL1bh4+p1rQKt7x4pT5D78RESDrP9jTD3SH4QbWH38MwTrIxRJxFaxnRY3PeIxMNix5kLj4F/0KlgriHYEMTkmDwxNNXhJgIdtFGIYA6jlyW3yCy6l6czsZxYC6D+ZcM+tbfSwByeSyXc8T9ekTm7QKzaNyrt7s3SteVxFhVqO7d00hGiqUexPgeYQwEfvy0OmH0g38EfxxmJdIOu0R2rv+RTyAWzgQuAnWHDd/hfY0S9fq9Dik+1igO2B7/oAsPawoyFFgdAg6sLk1z+IoW45bv5rOiUs9U5b+1u/2miA1C7IhzP2S6SNQ6lYPYEqLQrM44g+dzl6qlpn3Sp1KSn6aWIFj7o7JSVA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0160bac2-ee01-470b-bafe-08dcd1b70d4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 16:38:51.4294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nTPOefS4LzcajO+F2i7zqSTrItk5UWNJUc0x2f33ol9NYGjAw+0hY7CYdvA2s+9d/YUThFwvHCJPp4FwWq07g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_05,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=912 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100124
X-Proofpoint-ORIG-GUID: mzVm52Ywak0zXDczMmgLMEiFxoIfSkiX
X-Proofpoint-GUID: mzVm52Ywak0zXDczMmgLMEiFxoIfSkiX

On 10/09/2024 16:56, Jens Axboe wrote:
>>> t drop that patch.
> (side note - please wrap your email lines, I always re-wrap when
> replying)

ok

> 
>> Some background is that main selling point of atomic writes is that we
>> guarantee writes to storage will not be torn for a power failure or
>> kernel crash.
>>
>> Another aspect of atomic writes is that they handle racing writes and
>> reads, such that a read racing with a write will see all the data from
>> the write or none. Well, SCSI and NVMe guarantee this if using
>> RWF_ATOMIC, but it is not formally stated as a feature of RWF_ATOMIC.
>>
>> It can be argued that having racing reads and writes is an application
>> bug. Furthermore, as I understand, even if posix guarantees that
>> regular writes are "atomic", it is not the case generally.
>>
>> So one part of the relevance of atomic writes to fio verify is that we
>> can verify that atomic writes "safely" handle racing read and writes.
>> For this, the CRC checks would be successful if we have many jobs;
>> however header sequence numbers are not. Hence patch 4/7.
>>
>> I had also been using the verify feature to test atomic writes for
>> power failures. In this case, I run a single verify job with
>> --rw=write, power fail, and use verify in read mode to prove no
>> invalid data in the file, like:
>>
>> fio --filename=mnt/file --direct=1 --rw=read --bs=8k --iodepth=100 --na
>> me=iops --numjobs=1 --loops=1 --verify=crc64 --ioengine=libaio
>> --verify_fatal=1 --group_reporting  --exitall_on_error
>>
>> This power fail test is what I am mostly interested in.
>>
>> So my point is that the patch to ignore invalid headers could be
>> dropped, but let me know your thoughts.
> Gotcha, that makes sense. For atomic writes, it's totally fine to have
> overlapping writers if the write size is in the atomic units, but we can
> of course expect sequences to be out of order depending on which one
> makes it to stable storage. But you have no checks for whether or not
> the write size is within the atomic range?

I don't currently. If an atomic write size is out-of-range, the kernel 
will reject it with -EINVAL. However -EINVAL can be returned for a 
multitude of issues, so not much help. So I could add a statx call to 
get the limits and then error the fio config (if bs is out-of-range).

> 
> I think dropping patch 4 and adding a verify option to specifically
> ignore the sequence would make sense, leaving the control in the hands
> of the user. 

I already saw verify modes "no header" and "header only", so I was 
reluctant to add a potentially conflicting new separate option to ignore 
the header sequence. However, I can look to add a new verify option to 
ignore the header sequence and ensure it respects those mentioned verify 
modes.

> And then bonus points for adding an example job file (with
> comments) in your series that shows how to use atomic writes (and uses
> that option) would be useful.

ok, I'm happy to do that.

Thanks,
John

