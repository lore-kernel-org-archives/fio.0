Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D5E1E5B71
	for <fio@vger.kernel.org>; Wed, 19 Feb 2025 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739972341; cv=fail; b=bJNQnLTVzF1Bp5A2prRh3K1FmheA4bmiwHVr6oSo5/KAWAt188ZcKJ96cJIdCt8OTWAg81pg5pQuEkbH7ab5xKc99JDlw/VfLl571T5fp9dfgFv+jBHjwsKnrjJECbZEK/2jIVF/TdZ/gj/MqA0NxZ3pV52YMdeFMhzK3cLZN+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739972341; c=relaxed/simple;
	bh=hoQ7pr8W2pD9SIPFpoRUYxCR3XHjHSG453QQjJCckq8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=O0Yy8AiUZuRwJDlhznjKQOCiASWNMX75N2jKggGr2wH4eZEIlY1t7w7uYhlQGbYE5kL8rRjFO1mobf8xDIq09/AImr4HSlFbaf1HlvCrzPiFgb/lvNDSi2qE+lN4JwBeaCV2NDbnOaAH39tgcCkarNE/w5tZb5OVQKImWWO0gEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=o6UY+G3w; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=o/xdnCAK; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="o6UY+G3w";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="o/xdnCAK"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JAY1Hr024043
	for <fio@vger.kernel.org>; Wed, 19 Feb 2025 05:38:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=proofpoint20171006; bh=ho
	Q7pr8W2pD9SIPFpoRUYxCR3XHjHSG453QQjJCckq8=; b=o6UY+G3wzQhb55hOQS
	JxVI/OiGwr/1WqmRsi79mvebE0/5KnLFtQhv/Xy6naog+hSQmS0DVMbDXGtIdLqr
	20RuBBuDw4b9EhNQIfcQVmuRXf/AXjUD73OvmMcHwcll+LrcwFvVceLup+Evbbb0
	4ysRDqaCDmQEu3I7RPIduN7LST5tb8z6HupW8OD3mVnKQ8lwBmlrQBXntAzY7ZgY
	Zz+TeLqWSlP5228xtDkixg+nBOAAcaBvLyft1pmtzv6NU72uDWSqsg4GB0BQ1V7d
	HbtY8VVC7r25ceREjG0aXod+OFTSLglpn8aue8vUUf4UIBGaAvLuVmAAPhGVkt17
	cO5w==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 44w4b61tf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 19 Feb 2025 05:38:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdTBcNWxS4Hvtj8DE2x+77pr6m97S6t7fUWwqhn9HFkDu29puu3s/FOGenPbszAHbLuxivPTBPxWav6tKvDtQ671a6+hVzUg8BJHZOv3mU41SiY1L4z7mDrCFBh/HMa9CsGxWj88tXhKwtbnQNSc36UDbDB7qLZgBLTbbslxk4M0I1YMGxgPsPqXH+AifmwQDMwirjSPVYC+HXYriRxqzthdvbK1o9m1nsyLb7dRxxwz1UKGXW2+4V6AAx9EMNj1WeWMfT0tmOJd8VMH2MbLDI4e9af3whG8FrKfF/z2gYB2sOIvRoNXDgKRwJdhQTNwspFyn2KzlhiR3TiHsAi+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoQ7pr8W2pD9SIPFpoRUYxCR3XHjHSG453QQjJCckq8=;
 b=IuSQOcGsdZ/9YAAOE73V8JqtyYi0rPFFsh8MNVAzqxhHi+H1aXIavQqNjByyeWvD5UKwpWdhrjAWjQdV4/MLrnvaXpdZcPCLiqtfzljY2GbIqoy7y9zXpu2kQDdoh0e0RVbLMmHpkdcabmpylNam/kMD3lE3x3GkRj1gz8wzHEICdz+JD+kImCcgcCvjLcTCgJ1Y/XQUZqDU85YuQoTVy/el6Xd/9xnvnKIgYQgvOFesZLV2K5kBXs56cjBYD3x6pHhAoQ/qmb7/BdvjWfcvmGNMPF5UjC4hitVsVObuX/ICxKXX2gQi3xQoOQgP/1eFVctqB7sLi6M/zkQJbYcWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoQ7pr8W2pD9SIPFpoRUYxCR3XHjHSG453QQjJCckq8=;
 b=o/xdnCAKJJIU5NqfOQ3XMyVUq80x5zFCFv5QzOagGf1NlixmYghK54tZx6UsVvnzjNWOVOQSuIsmDoD+cmiNhBVXNfTrfWmgYFcPofg3jMeZZ8lzsupIcMUeBrLVd7q9DQ3ykSjC6xUGaQjt/UK2olaIKFmJ/H+gjcOaINklTP0JJPzcJWPcI7Y+ztXz9aZsRwKiVMfqTDrZ8HvZsdxlsXDNEiMp98Sa/DRyrYONx7RG+SMP5FS6GGybIjVshdIKC+nx0vtMeot3x24+/JM9UnjfB3AVl96HO3hpYrCJbRq2ZcE13kXoZOPh2HwC8D+pNHGMZXGBUKkh46SjiOMHoQ==
Received: from PH7PR02MB8979.namprd02.prod.outlook.com (2603:10b6:510:1f9::6)
 by DS0PR02MB9322.namprd02.prod.outlook.com (2603:10b6:8:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 13:38:40 +0000
Received: from PH7PR02MB8979.namprd02.prod.outlook.com
 ([fe80::3d22:5e5a:3107:1a64]) by PH7PR02MB8979.namprd02.prod.outlook.com
 ([fe80::3d22:5e5a:3107:1a64%6]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 13:38:40 +0000
From: Rob Scheepens <rob.scheepens@nutanix.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: How to specify GID index for RDMA?
Thread-Topic: How to specify GID index for RDMA?
Thread-Index: AQHbgtOVEwUjguQKEU6rAeOW8b01QQ==
Date: Wed, 19 Feb 2025 13:38:40 +0000
Message-ID: <FEE79ABF-C0A9-48D5-8ADA-41336854284C@nutanix.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Microsoft-MacOutlook/16.93.25011917
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR02MB8979:EE_|DS0PR02MB9322:EE_
x-ms-office365-filtering-correlation-id: 91bcbb22-21fe-4391-b30f-08dd50eab859
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z3U0NlRLUmorTDk5OFVoRW13aGFxWFEwc3BENjdNWEd1V0x6cFkwMldaQ09z?=
 =?utf-8?B?T1RNenppVzVuYVJYNTNXRWFGNE4xRkhyT2Fac3R0dUZCU250UlNRMW9rL2t5?=
 =?utf-8?B?UjkzMjcxVG5DeEZVY2ZWbXpvNlFxRy9kR2k5b3VlSnErbGhVNlUrMFZaUGRQ?=
 =?utf-8?B?YUlxMWdpRjRiQmdHZU1zNS85YXUvY29SRlNLY3EwQUxvR0h4QURJMnRkeHlD?=
 =?utf-8?B?ZkM3QnpiaURXNUhDR1lTWjhxS1VKcjAxeUIzQ0tIdVhnNUduY3lsWU15eHRz?=
 =?utf-8?B?b1hERGZHSUMzRXMwQVA2MjVCTU04TVVUSU9hRUxMRHR4MmFnNW5yY21GU2Rq?=
 =?utf-8?B?VU5naWdteUh0NzMzMHZwYVFzd1BFdnFMbVlGVGd2czBsWU9kUjdoa3RLb3RU?=
 =?utf-8?B?YlY4R3d4bWhGYlFlUExiazFCeitUaVg5NFgxSGtyRWlGdmFzTStnenBMVFJ4?=
 =?utf-8?B?QkhoRW1QWlBwaHRRc3liRmRqd0RjWEN6Q0lnN1AvSGhMUDFBdkxpdnBpZHdr?=
 =?utf-8?B?d0M1Uzlpdzg5VXpFMDErL2ZDQnErWnZua0NneFJEZ1BCakJqcDBaY0k2blBN?=
 =?utf-8?B?bTJoSnZQdDNUQndKeFVwQkpZVEhZN3NlVm5XSStxZWUyR0JIeTFDamZtMDN5?=
 =?utf-8?B?MGx6d3BGL2pxcVRyd1A0Y0ZMcU95eDgzOTk0bUdHSXpwRzhPYkFuSVY0M2Uv?=
 =?utf-8?B?cktwVDh6WkplR2ZCdFIxL1BYWk9zLzUwVkpzK0o3dTFZMkRzMHNYSFFGMkM5?=
 =?utf-8?B?V3FIV0h6RWZGQkExdVJYalFZOHdsSUpjczZYU1Q3amFZdG4rYzh6cWNsb3lo?=
 =?utf-8?B?NFQ3L1pGSDlaN2c0OG1SZmxrMlc3czBsajNZM3FvZXM1bnpuNUpPREFjNG1D?=
 =?utf-8?B?MjNOMzh1SGJDVjZ3bXBSd0wyMno2REFXRDZOVElVVENFRSs1NW04cEF5ODM4?=
 =?utf-8?B?SUhpQ0p5cG8zM25YSWpLd0FQTGkxK1I1UFpoTDMvY0hmZnRCdlB2bTNNZmto?=
 =?utf-8?B?WEkwN3hBR2FPOVQvSWpQVHY2aU9FUUV5NkNhdTVpNGJPbzVQbEl5eERsRVVO?=
 =?utf-8?B?NCtwWFlBaFZWcFF6R1BSSGlkdC9tQzk3cFRIc2ZpQ2p6YUlkVi9wK3JEZkJ3?=
 =?utf-8?B?UkdNQkFWUG10SGZBZytoa1d5UlFjcnFCQ0FLREpWVXRhSStTb2k0dXVIRXVk?=
 =?utf-8?B?ZTBQa3BETENmZXBxUm1iQnErcjA1aHhrUTFSWkdWRERUeWdKUnJLQ2d5YTIw?=
 =?utf-8?B?dy9JY1laRDd2Z2NzUTR5NWg1dDFwUXVDZ3lKSFlFNlJVUkFFSW5QdE1LSDNp?=
 =?utf-8?B?b3FEZ0VXZW9CQVlVZEFSK2hrVnUxU3o4akczY2cwcFQ4WlVQc2lDQ1VQamxR?=
 =?utf-8?B?Qmh4MFBHSDh5R0d5ZDZ3WDlYcEx1N2lPUWY2U2Y5MklDZ0pLUkppenZ4cEJi?=
 =?utf-8?B?WFlZZncwMmJPZzA2Q3A4Wkp6Z3ZmRU1JY1hhRGpKWmtaVG00Mmwxblk3dzJ1?=
 =?utf-8?B?VzMzSC9FL1FaS0FJL2NCU2hJUnhGcFNxMkRWVzNBOU0wZE1kWnVwOE5RSU1i?=
 =?utf-8?B?V3Z6TWFodmxQNDF4T0VVVlpEMlIyRkozNkhQVWs0TjZRMmNtSmJBcWFZOS9n?=
 =?utf-8?B?anhVWklVSk44SUlNZUVkZnRNRC85KzJPclNlcFcrejk4dTdXWVFMTjFXR1NX?=
 =?utf-8?B?WkY3d1AwMnJnNW10NGU5T1NUblBPaUlSbkpWOWpNek1PUyt4Snh5ZDBBeTEy?=
 =?utf-8?B?N1VGZmJOVXUwRkVZRzhHQ1dFUmNHd0dlZ1pTSjdVeWkzTTY2a1JkM0NZQWU0?=
 =?utf-8?B?NFpHYXE5blB2RVBzQnJuV1FWbUdwek9xV2w0ck5WUnhwdXFjVTdaRlpFMVc0?=
 =?utf-8?B?S3BtQlluYWZJRzg1ZXVUTEJPS0xXTUR4dEN2Ym12eHZCdjQvbFEvU3pjOHVQ?=
 =?utf-8?Q?QLFljA7w/WwbrZl8u8s5LJshK0NtZxfL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB8979.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d1B1akQ0S0Z2dm1wU0lHOGlCS0N3OG5KdTVPbFpINVV2dmhVbzA2dko1RGZl?=
 =?utf-8?B?N2dRMk9tSXhUa0VsdlpPb09zN3Bwa2d0WWVlbUc3dmdYNzZoekVBMVhkay9m?=
 =?utf-8?B?Rko3R08wTGptaUhpWG1nK05QcVEwcjNNTE1VUUliZU1IWmF6NExpY1BhZ2pF?=
 =?utf-8?B?ZmRaeU5lZ2wvZmdCVkdWY3pERzdnOFFwSFN1QVQxVW5Rb1dXYW5yU2UzbVkx?=
 =?utf-8?B?TjVPc3hZcjY3OGNkUHN5QUFnZWV4SmRtdkVYM3pRbmRQeGk0MklsNE9UZExT?=
 =?utf-8?B?QTkxOVVIMGNtNVErZjQyMmV6QzR5a1FkTUNsL1U1ZHlIWDdvbHVjNkJaTDFW?=
 =?utf-8?B?K3dSR1dsK2Z4R3Q1dklaOVh3QytsZEZpZkJXalpWR0lwM1BOSkVBZzVvNTlu?=
 =?utf-8?B?TjBpL0JHR2YwVjVoeUZ3c1A0cVpXRnNwVFR6UnlSREpjakxmaFplY0FQY09P?=
 =?utf-8?B?WktPWFYwZmwxZ2tyTmJZL1AwQ2QyeFBlWi9PdlBhRnZOaUdaejZ1VkN6R21D?=
 =?utf-8?B?UmY2YVdyWExJQWpNaVRLL2FQQVNCL21ZZTZSek1JUjhBZTNJTms3RUZGVGVp?=
 =?utf-8?B?Q3FwYmhnTFFCV2RKSldpVVhMK2NSampTSDdoeHJQNUJVR202R3ErUW9Ic29S?=
 =?utf-8?B?NTNIK3loMWFRdElBZ1RxeFl0ZExvYUpTcWl4aDB2bVpJaExUQjBYd3A3T1RS?=
 =?utf-8?B?YzJpUnoxOStrYzBxcU1QYkw3WnFVclA3M1BnMDJOelEyVFFJWVR1M1lhaXkw?=
 =?utf-8?B?dk9XNzZ0Tld0SlJidld1U1V5NmJGaWlrN09GVkxoWkxCbnRZUDBtT2ZENkk5?=
 =?utf-8?B?blZsTllSUlQ3eXJ5Uk1VbFAyRXlpc0FTUXZTcHAxQjJQSjBhMmlqMUJHcmJo?=
 =?utf-8?B?NDMzOHB6TmxOS0ZjK3Z2eVFoRFhWVi9qMkRFL1krTkordGl3eWlWT0c3cTl6?=
 =?utf-8?B?WmpxaFRISHdDREVrZG9pQm9wMjVaZzkvYWRPSEtuUm1QeEV0WVB4SGUxRjJj?=
 =?utf-8?B?RWd3QnJwL3FpZ09OY0YvMjk4UTVVMm1iSnlMMW1lUlg2VldPUW9ITlFrQ3Vo?=
 =?utf-8?B?SGhFRGpzQlhRVVhYR1BrOTZIaHUzTDlIY3ExMjIvWDNRZ0pNOE1IZzZvSkhr?=
 =?utf-8?B?QmNEZ2wvTzBXOU9NNm9OMUdqV3RqSEg2ZWE0UEhNb05mdFNmMnAwK0ZSMm9h?=
 =?utf-8?B?L0txSGpGcWRxb1VOV0IzUmNtTDQrTTZGVHJKSlJuanhrbi93bWFZNHRpQkRI?=
 =?utf-8?B?K0ppbnVTUzRDYkRqaUJYSUhBOXF5TzIxTDBJTS83NWlYUnM2eTE1NElUVzRG?=
 =?utf-8?B?WWdZNHU0NEVldTQweDRYeHA0TXAyNUtjZ2NWcVM1TCs2MHpJSTVGR2E1NjJy?=
 =?utf-8?B?YmpESWJlRUtCM2dOSUo1elVMeFEyTVZ3d1R3eDR5bWtHSHl6Wi80ZThNNk1Q?=
 =?utf-8?B?aTZFdE8vK0JubnlzMGNPMStPakdiY0I2TWRyaUVHQ1hjeHUvRHNLV2lMa2tJ?=
 =?utf-8?B?N3dra2ZlYnNnNG80Y0tybm85ZWEyZ3l3TDU0eU5UZDRjNnJZVUh1b3FYVVVx?=
 =?utf-8?B?b0NlSTFWa3UxN1huSjYvVzRhY2U4cm1lcEF3MTdYNFV1d3Z6NTlXbmNuMHlp?=
 =?utf-8?B?WXdqUTMxVEhpYVp6Tkg3ZkRwUXE3NzNVTUpHOElLZWNiOWFObXJ6MzhNVWQ2?=
 =?utf-8?B?UUx4Um9QVWIrVFMyanNQcTYvWkZVUzVrbjlXQi9CNmEwQS9tMGtRQ3QyWmp0?=
 =?utf-8?B?a21EWklQcWJxOE50ZklqbXIwekhhbUhUL21ScWNZcTFrakwwU0FHQmxPOXVI?=
 =?utf-8?B?Z3lQSVNKa0NObEpDamFScW03TCtJV2NsbXNWNm10ZWx6bDNFRWJUZkhQYnJI?=
 =?utf-8?B?M2Fpam9lUGh3ZjhNcGgxMTlEK1BuOGFxeEpTc1JHcUJZeWFOL1JkMEFXaktP?=
 =?utf-8?B?c0toanpGOGZzWE41TnVTRllackYrY1RacXBneEkvbDV5d1kva3dGa2UvOStR?=
 =?utf-8?B?c2QrMFpHU3pjSzBlbnBlWUNjcFJzN3cvUHUvRVZrc0dTNFpQQXRGbTVHM2sr?=
 =?utf-8?B?TmlRUzIvUEhqYXBQSFVBT1l6Wk5BdUhmdWFLOCtVZllpcWZyT25WL1RlMVV3?=
 =?utf-8?B?bU42QWR3U2tZakNUNi82Mk05M0pNZnV0eThnckloMzRnRVNuSVpkdzkzK1Vx?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F8CD179AE58144896F77883FB60994F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB8979.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91bcbb22-21fe-4391-b30f-08dd50eab859
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 13:38:40.1524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ua3n6A4gvu+o/mSKbkZdUCxyx4CDjaJ/5LcYerxcVNCOCCk+BWg30keuwH2C8tPOIaWeD/DiQ5W911a3OvQiOw82BmD5vtnpH/Zk5+DtGzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9322
X-Proofpoint-ORIG-GUID: fGcBv3CiAB_AQvFl75HuclNA8ys8yleU
X-Authority-Analysis: v=2.4 cv=cdUormDM c=1 sm=1 tr=0 ts=67b5def0 cx=c_pps a=WCFCujto17ieNoiWBJjljg==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=0034W8JfsZAA:10
 a=0kUYKlekyDsA:10 a=7ND6-clYcT6P7u58XR0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: fGcBv3CiAB_AQvFl75HuclNA8ys8yleU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_06,2025-02-19_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

SGVsbG8gQWxsLA0KIA0KSeKAmXZlIGJlZW4gdHJ5aW5nIHRvIGdldCBhbiBmaW8gd29ya2xvYWQg
b3ZlciBSRE1BIHdvcmtpbmcsIHdoZXJlIGEgbGltaXRhdGlvbiBpcyB0aGF0IHRoZXJlIGlzIG9u
bHkgaXB2NiBhdmFpbGFibGUgZm9yIG5vdywgYW5kIHRoYXQgSSBoYXZlIHRvIHNwZWNpZnkgR0lE
IGluZGV4IDIgaW4gb3JkZXIgdG8gYmUgYWJsZSB0byB1c2UgaXB2NC4gRm9yIGV4YW1wbGUsIHdo
ZW4gdXNpbmcgaWJfd3JpdGVfYncsIGl0IGxvb2tzIGxpa2UgdGhpczoNCiANCnNvZnRuaWNAa3R1
LXZtMTp+JCBpYl93cml0ZV9idyAteCAyIDEwLjAuMC40IC0tcG9ydCAxODUxNQ0KLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogICAgICAgICAgICAgICAgICAgIFJETUFfV3JpdGUgQlcg
VGVzdA0KRHVhbC1wb3J0ICAgICAgIDogT0ZGICAgICAgICAgICBEZXZpY2UgICAgICAgICA6IHJv
Y2VQMzA4MzJwMHMwDQpOdW1iZXIgb2YgcXBzICAgOiAxICAgICAgICAgICAgIFRyYW5zcG9ydCB0
eXBlIDogSUINCkNvbm5lY3Rpb24gdHlwZSA6IFJDICAgICAgICAgICAgVXNpbmcgU1JRICAgICAg
OiBPRkYNClBDSWUgcmVsYXggb3JkZXI6IE9ODQppYnZfd3IqIEFQSSAgICAgOiBPRkYNClRYIGRl
cHRoICAgICAgICA6IDEyOA0KQ1EgTW9kZXJhdGlvbiAgIDogMQ0KTXR1ICAgICAgICAgICAgIDog
MTAyNFtCXQ0KTGluayB0eXBlICAgICAgIDogRXRoZXJuZXQNCkdJRCBpbmRleCAgICAgICA6IDIN
Ck1heCBpbmxpbmUgZGF0YSA6IDBbQl0NCnJkbWFfY20gUVBzIDogT0ZGDQpEYXRhIGV4LiBtZXRo
b2QgOiBFdGhlcm5ldA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpsb2NhbCBhZGRy
ZXNzOiBMSUQgMDAwMCBRUE4gMHgwMDI0IFBTTiAweGQ0ZTEwNyBSS2V5IDB4MDBjZDAwIFZBZGRy
IDB4MDA3MjQwZmRmZDIwMDANCkdJRDogMzg6MDM6MTY6MTc2OjA1OjY3OjAwOjYwOjAwOjAwOjAw
OjAxOjAwOjExNDoyMDQ6OTANCnJlbW90ZSBhZGRyZXNzOiBMSUQgMDAwMCBRUE4gMHgwMDI0IFBT
TiAweGIzZTc3MCBSS2V5IDB4MDBjZDAwIFZBZGRyIDB4MDA3YmI4ZDNjNTEwMDANCkdJRDogMzg6
MDM6MTY6MTc2OjA1OjY3OjAwOjU4OjAwOjAwOjAwOjAxOjAwOjU5OjE4OjIyNA0KLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQojYnl0ZXMgICAgICNpdGVyYXRpb25zICAgIEJXIHBlYWtb
TWlCL3NlY10gICAgQlcgYXZlcmFnZVtNaUIvc2VjXSAgIE1zZ1JhdGVbTXBwc10NCkNvbmZsaWN0
aW5nIENQVSBmcmVxdWVuY3kgdmFsdWVzIGRldGVjdGVkOiAyMzAwLjAwMDAwMCAhPSAzNTk5Ljky
OTAwMC4gQ1BVIEZyZXF1ZW5jeSBpcyBub3QgbWF4Lg0KNjU1MzYgICAgICA1MDAwICAgICAgICAg
ICAgIDEwODI4LjYzICAgICAgICAgICAgMTA4MjguNTUgICAgICAgICAgICAgIDAuMTczMjU3DQot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiANCkhlcmUsIC14IHNwZWNpZmllcyB0aGUg
R0lEIGluZGV4Lg0KIA0KTm93LCB3aGVuIHVzaW5nIGZpbywgSSBjb3VsZG7igJl0IGZpbmQgYSBz
aW1pbGFyIG9wdGlvbiBpbiB0aGUgZG9jdW1lbnRhdGlvbi4gVGhlIGpvYiBmaWxlcyBJIHVzZWQg
YXJlOg0KIA0KU2VydmVyOg0KW2dsb2JhbF0NCmlvZW5naW5lPXJkbWENCnBvcnQ9MTg1MTUNCmJz
PTFtDQpzaXplPTEwMGcNCiANCltyZWNlaXZlcl0NCnJ3PXJlYWQNCmlvZGVwdGg9MTYNCiANClRo
aXMgYXBwZWFycyB0byB3b3JrOg0KIA0KcmVjZWl2ZXI6IChnPTApOiBydz1yZWFkLCBicz0oUikg
MTAyNEtpQi0xMDI0S2lCLCAoVykgMTAyNEtpQi0xMDI0S2lCLCAoVCkgMTAyNEtpQi0xMDI0S2lC
LCBpb2VuZ2luZT1yZG1hLCBpb2RlcHRoPTE2DQpmaW8tMy4yOA0KU3RhcnRpbmcgMSBwcm9jZXNz
DQpmaW86IHdhaXRpbmcgZm9yIGNvbm5lY3Rpb24NCiANCk9uIHRoZSBjbGllbnQ6DQoNCltnbG9i
YWxdDQppb2VuZ2luZT1yZG1hDQpob3N0bmFtZT0xMC4wLjAuNQ0KcG9ydD0xODUxNQ0KdmVyYj13
cml0ZQ0KYnM9MW0NCnNpemU9MTAwZw0KIA0KW3NlbmRlcl0NCnJ3PXdyaXRlDQppb2RlcHRoPTEN
CmlvZGVwdGhfYmF0Y2hfY29tcGxldGU9MQ0KIA0KVGhpcyBldmVudHVhbGx5IHNob3dzOg0KIA0K
c29mdG5pY0BrdHUtdm0yOn4kIGZpbyBmaW9fcmRtYV9jbGllbnQuam9iDQpzZW5kZXI6IChnPTAp
OiBydz13cml0ZSwgYnM9KFIpIDEwMjRLaUItMTAyNEtpQiwgKFcpIDEwMjRLaUItMTAyNEtpQiwg
KFQpIDEwMjRLaUItMTAyNEtpQiwgaW9lbmdpbmU9cmRtYSwgaW9kZXB0aD0xDQpmaW8tMy4yOA0K
U3RhcnRpbmcgMSBwcm9jZXNzDQpKb2JzOiAxIChmPTApOiBbVygxKV1bLS4tJV1bZXRhIDAwbTow
MHNdDQogDQpBZnRlciBhIHdoaWxlLCBJIGdldDoNCiANCmZpbzogZXZlbnQgaXMgUkRNQV9DTV9F
VkVOVF9VTlJFQUNIQUJMRSBpbnN0ZWFkIG9mIFJETUFfQ01fRVZFTlRfRVNUQUJMSVNIRUQNCmZp
bzogd2FpdCBmb3IgUkRNQV9DTV9FVkVOVF9FU1RBQkxJU0hFRA0KIA0KR2l2ZW4gdGhlIGxpbWl0
YXRpb25zIG1lbnRpb25lZCBhYm92ZSwgaXMgaXQgcG9zc2libGUgdG8gZ2V0IFJETUEgd29ya2lu
ZyBpbiB0aGlzIHNjZW5hcmlvPw0KIA0KUm9iDQoNCg==
