Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7F18FC81
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 10:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962647; cv=fail; b=R8t00ROWlcg6zdk0DsnwM6ZbJeOM8U/IKZfuyuviGL18BHp2C9ZOT9nRthU0d3qPLdUjITYUAlwvUZ6OEBs1LBs+3rOkgXQMKiRqczimfhpeXCipDMVtxvDqX7J6NOTKAXHmQvFHcBMM0/XtEj6V6E3BP2TuXkkzE7i+X2pK8ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962647; c=relaxed/simple;
	bh=oFkMjvgUHcZQYlkw5jLfdHX8h1NrkvY3NaRS1e/Ny00=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tvi0JRbl1D0h1p+X74VMPMoynXfK4IYvBOpHhr/CWkSvNA9U7JXW5EuE0PPR8MINRv6FPyXV46311XX3/9M/HTGHaySujrRu7U2YJ4wYPBBliCLm6Jppns05H77PfAy7T99A+7BOdY0LPqFnZcyIhxToD/fClvZgdrhk2mJPrvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DMgsxokN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ADsWrsgT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DMgsxokN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ADsWrsgT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A9QVcV022346;
	Tue, 10 Sep 2024 10:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=YIQSvKHMuOIKHbUJPqwnbMY/eNuGfBsS0MdzZtWbcUE=; b=
	DMgsxokNIOsAcOwNisrTZIERFpRTLXNOf4Kwtpc6Y4+tARhf5YJROF8VnYDmuXiw
	WRMA6aQVfSi8P2A2lNVbFks2lz5OuzD5wgXqrI+qdNH/NMcheteumIAXGwUQQunu
	X2RBmiM1pgWVAPbCensMe+gQdKOzpZZFhrq5/gT8GSfnhlgXrxoG/FhAYP06buZz
	zpIDRNldGOQOfOuhanr4D+f62+ZS48YkuIfwm2Qfcw78Cxlm0/u/K3M06XgBkSim
	oRWj9RiJ33mTNHUWZLiZZfsSCaHeA9filVfjHfyPfKHmMhbRlOiCNNQnJ3rS6sdm
	H93HvJF00KuTmjl0kfQA2w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctd43y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:03:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48A8BOVn033116;
	Tue, 10 Sep 2024 10:03:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9em3uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:03:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIS5ZiAgcBBbulKrgTQ7lQ/1y4Xk78lida0O7ZdYnu0CvGfhYFg40X0iUDhJrAU5kj8/o4XptAuc4hRrBmiP6f1oDD84rKA0+iKKoMlBLd8Qh1uL6GOUTZap03UkS91qCNlml6bcFTiyKUJUYio2FN8dNfy2FR+v1oiWfnQnKgqAQ1mA/TDbpg3h/NAAXgPDFan9LoKnjdlOEZ6iS7yJTbQN6WhsAQ6TAu9Zv4BfBy2RrkzMNu8Twi1ScWGR/1+DIbLMm7gmUXxTbaxtJZpuTjLVsKbqc5ozUHwXly8mOX2WvBlykvjLObXFDpi/n/yhWCB62BKRd2FYAgGbJngyNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIQSvKHMuOIKHbUJPqwnbMY/eNuGfBsS0MdzZtWbcUE=;
 b=gZF07/akD74BZeYP9NA6oqx09eOMSPAHAItIJp/6P8pERIqzEFT85aUYTa9ktZq25Fqlwwe3FuLxnjfO63BoPwo2WVUjf7KggaK+x3QFFOBCg4hMJTVXTghT1kKsmMQsvTOQZtAyrNJnNSHThOy5jdS6mntfd1dEbgNYa02YzeSQU213po5ouoGQg6youeVzjbnuXlpapbi1m7zCdxpyYj/J4PMYK38rWzvd2SO9gjk7ofP1dKu9d06gLaT6p08HNeXFeg/oO8w0btNMPcicGrxVKxes2hGirxJ8tEUjfk2tdopcfBh1WzXmEcfUFhWXgvIvMM0Bd1Kov1S6GbJiJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIQSvKHMuOIKHbUJPqwnbMY/eNuGfBsS0MdzZtWbcUE=;
 b=ADsWrsgTpaqhEfaelUZABKe1N2iTzdOH1LVX1vIi8NOY3RyBT+Su+GT+OdHAH0MCWvTrrAezPRcrCJ19IiohO6csQfy51qZtWiWyMyZcuFT9MenE7cdbrwmZio6jTxG64sHmAK3+ddHx1BmEThyOBqndvNE+ak5gWxj0l+dYfYs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 10 Sep
 2024 10:03:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 10:03:52 +0000
Message-ID: <7255db3d-abb5-4371-9cb1-e12cf41f979c@oracle.com>
Date: Tue, 10 Sep 2024 11:03:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        david@fromorbit.com
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
 <1185aac7-de61-4071-83fe-802b52e458e2@oracle.com>
 <f689c9ea-b677-4521-8363-1c4f2f3c81f0@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f689c9ea-b677-4521-8363-1c4f2f3c81f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P250CA0028.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5738:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d8a937-a128-4d04-460f-08dcd17fdf94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QS9TRUU1RDZNV2dqL1E5bld2TVF3WFNUSTJUUEhaWm8zZ2RNQytScmZUSmYx?=
 =?utf-8?B?UkZWRDFLL1E2TVZWRWdEcERoMFV3Y1lqOFQzZXptTWxwdzdvdkRxbFlFZ1JT?=
 =?utf-8?B?cUVtZnJRWVJRdjdsZ1pKSDZmSnhUV2w0Wmc2clJYbEV1R2Z4anJEQzFPNlJj?=
 =?utf-8?B?anZBS2lDT0xEcncveEQ5YmYwdXpoRHhQSEgwVm1OOEdzOHJMZHdDYXBvdlBP?=
 =?utf-8?B?c0hUZWpYZjdYcWRzRkdUcVlvS3RsWGhudmlXbnArZDJNWmx0WTFzUXoyN0I3?=
 =?utf-8?B?aXhCZ1M0eGg5ejZoUUhtZzJpV2hFRzIrZGI5TFhnL3BETDdpekUrbFpQek5H?=
 =?utf-8?B?LzNybDNYQWduU0FSa21vME9vb0pqb3dFV1ErYVo4YSt1NGtDSHYwU3J6KzNN?=
 =?utf-8?B?K1dyVFRHbWJ1WFZUcmptRGRWZ3p4ZFJUcUdOUjVTOW5KNmNZbDRVSk5KMy9E?=
 =?utf-8?B?ZWJtYWNtVjI0amllMTd0ZnhYTnFvUmlyT2FPbjZEa0ZCVEZmNWRMeEszQlND?=
 =?utf-8?B?dnRHRGNpaDNMNVdibnNNYXdjRFhRVERBcWtyYy9aK2hiZ3M5OWRvaHlUUytG?=
 =?utf-8?B?U1lFbU1qYTVtR1ZCUExZdFBNSWdzZ3ZGaCt2TS9wZFhJL1UzSG5TYUw3SkZO?=
 =?utf-8?B?UnExQ0k3UjdnQm5VRE91UDJGR1FNR0xmT0JwVU5ic2NrVTBXc3JFeFFyZk9n?=
 =?utf-8?B?bG5FcEZVMTJ0Q1FVUDFvdUdCQTlOaG4zYUhIMW1EYnI2V2ExajdzdWYyUnVq?=
 =?utf-8?B?T0c2T2V1UDZHZmRzZXpxMzFvdDlralhsNWUrcGZpdlVVWmdDYmxaZ2NaV3Jt?=
 =?utf-8?B?R2lkUGpyTENURTh3ODAybjVWZzZpNUQ2cUZ5TnBaQVRWbE9SVzN6MG1mbEZG?=
 =?utf-8?B?WEdrMXNUMDB0T05sTEhnTmV0NEd6VEJ3S0hGVUQ3aU1Bd0pqVHZqc1hGZlJi?=
 =?utf-8?B?ZnJBcWN5U3JmaENJdUMwc3ZKS20rNVJjR0s1OTJXRTk1WEpIZEpSV2FYK3Y0?=
 =?utf-8?B?Rm1ZUmdBcG1aZkNwU2lZTGh0cThZS1pKa3pWN2gzenZYRXkrN0VpUk1lMWZy?=
 =?utf-8?B?RDYybDJIdERIWDFEQ3NJakEyMGpNN2p6em1UM3h0dUhFRExxalh1VWx2cjdR?=
 =?utf-8?B?ZFVIUDZuWGRrYzRYSTdhVkdHWGdIMk1nS2pzUDltOG95eW5nY3liaDZZaHkx?=
 =?utf-8?B?R2thMVNMVUp3dXJQNWdDTGV3Umt0V2N5RVVtOVg3a2szclRocXFQTFltbHdC?=
 =?utf-8?B?bEpyMXhSZS9GTTRQTWlhMG5oR1hmbXJsaEdGRUQxSWlZemNEd3hFeVBiR2RE?=
 =?utf-8?B?aHd2ZzNZdGNNdFRWYW5sYm8zL3pIRHJjWklqUXFVWWxrb3o2Mk9aMzdraE1M?=
 =?utf-8?B?Z3pKaUV5eHEzL251K0FoRzdpRi9hYW5YSTdDd20wb1lNbGlmNEZvaUNIR2tZ?=
 =?utf-8?B?NU1lZS8zUzk2azNldWJnTTNuSDdWejZxaFc4c1lRUExqdVRwSjF4MG5hKzdO?=
 =?utf-8?B?SGRaNTJzYXdjbmN5YW5VOU9mMnMxcEgzRHpJU3FLWUd1YVRlYjdBdUpPUnBL?=
 =?utf-8?B?VWhMKytkL2E3L0FBR21nL3d5enQ1L3lNamZqKzE2R0E2L3JmSFZGV2hRQjJl?=
 =?utf-8?B?Z3VXcm83b0hIbmIxOU9sbmRkY1lZOWJwZ0Zjem9Md3V2aFNhS245dTVZTUEw?=
 =?utf-8?B?T3FZbUJXZlRTazZ2UzZndXNVZkFtR2NWWXEvUHZFb2VLZ0dsU1ZtRjJlRGZy?=
 =?utf-8?B?TDV4Z2NqWEpTdyt0VGdqa1F5UTJnbWpBRStndnVGSmhLRVZlYSs2dmV1ZC9t?=
 =?utf-8?B?NlQzS2I4b1JwbDNSZEJKUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckZmZEg4K2l3VWVlblo4TFlJN2o5K3FvZXJxTDNLOFNpL3lQZUU5VFFwY0ZK?=
 =?utf-8?B?Rm8rRjNISXpNd0ZRZDNESW9nWnZ6RTF1ZUgwQTVWejE2TmUrTSszdzNRditX?=
 =?utf-8?B?NHFrcEp0Z21wVlp5UncycGdLOThrb01TVmtmdC9iRFkxZFRVZCtXQjZhQmc4?=
 =?utf-8?B?OTZHbGVRMVdVWVdkZXRaT1ZNakJRLzRZRUQwRlAwSVdONE0xRXFibXN6c093?=
 =?utf-8?B?YWtUS0NsQW1vY0RxbDlmbnI2aWR4Z3N6WGxOalpqTnp5Q1VUTWFISk1rTVdt?=
 =?utf-8?B?TndvZTV5YUJpK3FiaHlTU2F4TmRPQmN3ek5jYWRUcTZsSzV5YjRqbnVuVi9D?=
 =?utf-8?B?MG96Z3Rpc1lmNEc2NU1xT01FY01jZnFnTkhhV1pBMWloT2UzMWtCR2ZJYk5t?=
 =?utf-8?B?Y0FpWmZxWnJ3dTJuQUJsdTE0L3VaZGMvOHNiWVFqT25LazdsUFJpcXNnaDZq?=
 =?utf-8?B?citJZmFpbE13aEhUMi9aSVkyQTA0eURYYW1VdlUyUjlIY2Zjc2h6S3B0bzg4?=
 =?utf-8?B?ZENPNExPcWlUMy9KaEZjejBCb0xmdWxnV05xdGNMU0N2NGxUczBWWUkwak9h?=
 =?utf-8?B?SWcwR2MxTUgzQ25YMW1sYjBGVkdXdnFnenZFZno3SXpERTl0UXI3WnQweVRP?=
 =?utf-8?B?UFlBMW9DQ1dBSDljZVYzcVZDYVVCVHZvcG9rMHVwR1IrQlRXck9pdWQxVEpU?=
 =?utf-8?B?TzdIMFVnSFY0RmRnSVg2d0FSUVR5cmRvc1U3V3VkVGI2aHNRajAvWjNZWkRJ?=
 =?utf-8?B?UDhlemRKY1hGT3kvVjFOZWpSWjdWYVFXYzBQd3BwTGFKM2YzSlE2R2NSZ0w4?=
 =?utf-8?B?R280ZEJJS2E3RFY5bzFRSnpPanhoZVErOVFKK09aYWVlVnI4WUw3bW5DMy8v?=
 =?utf-8?B?MzVHZnUzWEdDYkp5R0daYTViSzJ5N1ZiTlQrTmYxaUo5OWZkV2xFTjhLMGY3?=
 =?utf-8?B?Y1d5dXc4TGRMUDNaY2IyR2Y2MFJOQUo2K1MwbUlNRDJDQU5BV015aEhCTjRj?=
 =?utf-8?B?SjVCOWFrVldGT21oR0Y5VEF6NGFFU0RlVUprTmI1TTVzdEM4QUN4M0RTZSs5?=
 =?utf-8?B?WmxNcGdyVUZTLzlLcTBYUFVtQ3BEY0RSS0tOQTljSXI0R3VCZzF4S1JLQmhC?=
 =?utf-8?B?QkZrTzZrTERub2JteStpL3BZTXVzQUlsK29jVG5SK21jV2dtVGp5Tjk5b2p6?=
 =?utf-8?B?SFA5anhML1FSdVpGQ001VjJVZFhYTXllZ2hLYk12a0x3b2lMZUpYL1pzWFEx?=
 =?utf-8?B?eTRTaVQxTjJtZTAwaURUeTREejVFbEF3WUFzNHhpZWY3Z0VLWTJaaXN0L2Nj?=
 =?utf-8?B?d0FFVWZTRjdYZzA2T0lnbTFGSXZWeVgrQmwyelV3d1RBT25LTHdqVHVrUE1y?=
 =?utf-8?B?cDJJcG9vYmZiWnJSa3lXNm1Fa09DdFFXNFZhVVRQeWxaQzg0ai96eXphM1By?=
 =?utf-8?B?Q04yd0x5YjZaNjE5QjJsdm00U1Jybm5jdjlRRlJVUGdaZ0owa3hQWTE0Vk05?=
 =?utf-8?B?QTdYN1Qzbi9YY08vckdmUlBFOHZnbmRlcXFYdXU0K1hSRDl0azRnRzZ6ck81?=
 =?utf-8?B?Y1hoMzc2TnlQS2V4MUNyZEhaOE9Eb2ljZ25ScHNGUlltNGJxZFRwSks5UDM2?=
 =?utf-8?B?MjNmYjJzNGlJVXdmb2tCam83RnNCTStNNHpOeXFwMzhPVGZQYjNSZWpqeCsz?=
 =?utf-8?B?NkVadVpwQzFuMkUwemY4K3dEZGZQWWQxV0hMLzBvU0VBY3hva3VPa0lRSTFQ?=
 =?utf-8?B?SnBDM2tMVjRSa29WRDd5WEQyUWdoOEdhZk9LbnpnV25qZEVHeUZzSTh1RTJu?=
 =?utf-8?B?QTRCZlRwOXJuMFNrUUtxODl5TUJQUndpcnE3R2xTODdicHJmZDZoSFBKNnd2?=
 =?utf-8?B?QTF0eWkxSGQyNzBMTnZsRW5WcUVhTWFpWHZRaXNYTVB0b1ZpTnVzb204ckVU?=
 =?utf-8?B?VEQrNzZLMGpDbjBpNXNnaDJ0VnpHOHlxSVVXQmtieTZqVjBSL25TZm5iM05m?=
 =?utf-8?B?VUxTYm5LVFFUMm5WdDdTbzJnQXRHT05iODY3ejRxbXY4M1o2MkwzWnpYaXB1?=
 =?utf-8?B?S05BdzM5SzRKejJwMVN2RStubUlrODYzeUo0ZFZZRmdUWlJlVG9EQXJlL25p?=
 =?utf-8?Q?HSOqOsqv/sx94Bhhvl185MT9s?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FNxV31Ej35YRa0ccLWWmG7+6R+S1c7Z/UPrePuF+aZPiiu1kxIuPixBR0Ptd6/RGeuhaYMQRKadMKE8cdUa7/jLtvoGj2p/3MyBr4G8SruREmjthuhHPMShqBEMxql3z18Q7RpW29TX3QEOnr0alirSEaB/iHLx+QamtqMvuMgsVdgZVBgxWa7JxooLd7UvMyZf+xr3HdByB2OaMhfeULB3mjmvoeltSnI9TEqB2/BRSwZ3twW0mYP0eic0axF5SSTt/0NyrE61l0mifmRHIEO5DBqat42ITfItDBnsb6f1Vn1h/7roeeWVwDGJEmxZqUPBXznuHTYpfu2AuQER//YqQdV0yKPIl2X4YA2UEgQ35jVcX+HCc54vcETJ0l9GRJTPQHLVXd/jEft6vhfs76LFQdBnbio3hFXAIBeGwpDcsYEsrZ8VDXyBWUU3oPctPpaRAGu8xVkNLdbdV3hywWVpGrjlYd3hQxmIqLYOrZ0ijENhrdJySqx+Mhiz4OunIenBqBZ+On/FG8+qdc6rC+KQENZGl5e4gNoAjT6y6PgMZ9QE7sDq/oqXStkCLBSRmrzACcifjOM1SBMFw0tRP07p4B4Ldx+dYMq7iQiQZiIs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d8a937-a128-4d04-460f-08dcd17fdf94
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 10:03:52.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6EKR9QWXhC+M9xqQEHiI1i2UM0tjD2IK0YYDvRaZ9FYAPe4nSgGagGXE8M5j5nx5z+0ozYu23iPiAzff8DFGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5738
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=743 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100076
X-Proofpoint-GUID: S23qq6f08gD1ofv5nW_VA1vm2zeuY6l5
X-Proofpoint-ORIG-GUID: S23qq6f08gD1ofv5nW_VA1vm2zeuY6l5

On 10/09/2024 02:01, Jens Axboe wrote:

+ Dave, who might be interested in this

>> I was preparing a v2 the same as this, but do you think that I should
>> just add a new verify option for atomic writes to ignore the header?
>> Or is just saying "you have selected atomic=1, so I'll just ignore the
>> header for you" ok?
> I'm still not following why atomic writes make this any different. They
> should not. If you have multiple writers writing the same blocks, yeah
> you will get verification errors. This is true for any kind of write, be
> it buffered, dio, or atomic. So unless I'm missing something here, I'd
> just drop that patch.

Some background is that main selling point of atomic writes is that we 
guarantee writes to storage will not be torn for a power failure or 
kernel crash.

Another aspect of atomic writes is that they handle racing writes and 
reads, such that a read racing with a write will see all the data from 
the write or none. Well, SCSI and NVMe guarantee this if using 
RWF_ATOMIC, but it is not formally stated as a feature of RWF_ATOMIC.

It can be argued that having racing reads and writes is an application 
bug. Furthermore, as I understand, even if posix guarantees that regular 
writes are "atomic", it is not the case generally.

So one part of the relevance of atomic writes to fio verify is that we 
can verify that atomic writes "safely" handle racing read and writes. 
For this, the CRC checks would be successful if we have many jobs; 
however header sequence numbers are not. Hence patch 4/7.

I had also been using the verify feature to test atomic writes for power 
failures. In this case, I run a single verify job with --rw=write, power 
fail, and use verify in read mode to prove no invalid data in the file, 
like:

fio --filename=mnt/file --direct=1 --rw=read --bs=8k --iodepth=100 --na
me=iops --numjobs=1 --loops=1 --verify=crc64 --ioengine=libaio
--verify_fatal=1 --group_reporting  --exitall_on_error

This power fail test is what I am mostly interested in.

So my point is that the patch to ignore invalid headers could be 
dropped, but let me know your thoughts.

Thanks,
John
