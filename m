Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE31D1739
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725636162; cv=fail; b=d9mVUvcbqalUuzijIJcFHtM8cDJHwUte0UMhYo39IyRovpACdWSxeWfvvQpu47YkXtsgVihphI1GPvK57xZRsSr2g870plLWXpdqVqXBDOLtGbTFqne56lJCKy141lfsDig4sb9A1p1UxDOWKt/8gmo0Ctx4jYhGxhC1Dp4Uz4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725636162; c=relaxed/simple;
	bh=hePVYnLt7tfT2yhzsOYqfenD6GfcaU5i9sR8dzOaNVc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JoNHs1twBONnXITQ31Lolz2IIiesFvb/MHQDDLNLfN2+cDCEaP3GPOl3v4T7dUJl9UhXJrHHuTPMaSxHJPzmfyaye4Iu33ojwOHqSINAsyO8eHw0qoyzbYpt8aur0veGmQVnolopui7bHhS5KrUYNmsgxmW2Fv9bOon+cdFplhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UtBpq94q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DTWUc9Lf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UtBpq94q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DTWUc9Lf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486DWSLx000796;
	Fri, 6 Sep 2024 15:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ipkjOWeymSVRQ2+WLSLkP61z346odDyG+F5Yx5TXeWY=; b=
	UtBpq94qpfCoqms1Aylc4yNJPMvuLbpGIPr23dYPT7/9CKJufKyKmzT1O1ILDXEj
	t/tQofNsOx/WsPaTu8zq1OAhulNL0HOP6JnND+gjSDI1HgwZ6Tfb24Q6/YH1KDlg
	NqJVrXa0eMURbstt5J5/oQg23nfYNi75GueGbY7/7Lw2UENXbbT6VMsjeNd5hFNq
	P6q+NppnZldqmxzWF+2IblPHED6ch3153sQ9H8ZU21TBGtPgqUYhmOFf5B3kLBMY
	kIDI/0M9qEbtCLv5a4ukibMKPo9AGjizbkaA6l9zv4NniYSSBM0DYV41bkWjeUWp
	QR13sVbPpr/rXuXygtvX8Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwk9u85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Sep 2024 15:22:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486Dh0Rj003350;
	Fri, 6 Sep 2024 15:22:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhybd4hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Sep 2024 15:22:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XrqLyIOMdrU3gWk++ktJLpebKyN5xZVj4IVVSpkT9mbTmChWHzSpL8BCxgihA6blsTYILpxw65wVUQenMrQZg9fx62MsGy4Tj9rwBlzHyjP5q7AoWFDE1JD7B6XtDzcWXMK+gGRzdf6dQQOmVVrSroETJUFNgQgrQpSEkDjkuJl23QtxvwwMmlte6tmMVBdIls0inh4nvMCDJxv4ST8G7NdtWTIHnU+1KJq9dAUkMkG/msbI1vtHXTRX6kzCRnZvIwFVzorcPQ+Ns9aFprBw7qr7laDGp5Hgfopy8JMFAzD0wcWKMgR/p81Z2XYj8nCpCdVSdjsurFcB781ABgvJPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipkjOWeymSVRQ2+WLSLkP61z346odDyG+F5Yx5TXeWY=;
 b=TOw7cUuDFx0+MsezAztywp2psvaLPLzPr13EUbzyY9SjiPS7aeZOP4bXo7m+zX5N6l8baAAg57FP/7bAWu+de/xENl9IJP38y03oJYWnhPZr9JseXRjnkL4/ijyGEzTNNctyIeOy7MfBAKGS6nDNapwFMW/ZEIWmn4T6LpmLrpG9GxtFDJaC0JqnLXf0JY0+OYcBW5H3TzGIfzL2jo+r99xVQkRouN4KHJHyTdQLB79UX5imwBFJnVF0VqlWis2v2NDUqkL9r13X2rHldO/IwOESR+9W4bV2xOt/8qBdEBQwxcyuK0lqTccZbaTB6xKj8svX5lpjG20sTUIxhtZ5fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipkjOWeymSVRQ2+WLSLkP61z346odDyG+F5Yx5TXeWY=;
 b=DTWUc9Lfwu0VmH3E9QGtGL4El179YFG4zrAVy+7AHt2RiU8F8l9dqAMg3xU19qQEWrHKxfdY5Eph5PenX8jp8P/jU6NgM4/njaLQfr6RgMW9FY/k1rrq3CiRweYVAwhtVza/ChEY49B32twQJFq3XCoM6QEB8ThFX0iSIE9bit0=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH3PR10MB7808.namprd10.prod.outlook.com (2603:10b6:610:1ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 15:22:28 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Fri, 6 Sep 2024
 15:22:28 +0000
Message-ID: <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
Date: Fri, 6 Sep 2024 16:22:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fio@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
        djwong@kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
        Daniel Gomez <da.gomez@samsung.com>,
        Dan Helmick <dan.helmick@samsung.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <Ztl72OINsWHeq4pz@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Ztl72OINsWHeq4pz@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0030.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::18) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|CH3PR10MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d38f81-3be1-4c31-f8c9-08dcce87b820
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmFsanh4RlBmazRoQlRmckVrSUxDV0F6L0hlOElRZnRlR01OR0JGNHJLSlJW?=
 =?utf-8?B?bDl0NWExNU96TWFEMFpEWXdJMVN3SWF4Y2RCQ2FXdngranFlTFRPQnhVOUJa?=
 =?utf-8?B?QU1lbHVZdmRVcHEyeTdZQnVsaXVGa21WR3FHV3NFSTdMZmJheUcySUtaZTNo?=
 =?utf-8?B?VjVQMnM2dXM0Z1N6amIrclRoVWhUUUxpN0NNQkpyRk5ZWXhCMDR0VGpONzcz?=
 =?utf-8?B?alFjcGVQditoYUFIR0k0VjdDUFNHdDRxU01pakdPUXNWN2MyZDNlalBKbW9v?=
 =?utf-8?B?TEE3VnJHVmVQTHdRQWV4NlU5NElLanZ1cmRiVHlWRUlJT3BUamlDellnaHA3?=
 =?utf-8?B?WFgrZmN4YXZyN1h2dHR3WVdrZU03VGxMVHpyS1d0N1Z5WnN1QW5wV0JDYnJG?=
 =?utf-8?B?dTVaTlM0QzAwZXp1VnZMdFkzbXFIWGhtQUplU1ZneUZFUUFpZWxLVkhzdGtv?=
 =?utf-8?B?alErdE1tTEFaTVdFU3d4Qm5kRFRaWlNWQVdoL2ptaTZ1c3RNK3Q1bnFCdmpN?=
 =?utf-8?B?YmdjWDN0Y3JWSVZrUFJHN1NHRzl6cmVSQUtLcTIycEZQWVc2UWVTTnFScFVZ?=
 =?utf-8?B?Q1BsKy9EM0htdFNma2Rvd1FGeHdGNWtlY2IyeUVYakcyTWwveDBqYlVOUjE1?=
 =?utf-8?B?VDBLVTRCR25wZFJETWtwV25jSFVjbmFZUUpvMk1iNVV3akpaRmtpTkxxalpP?=
 =?utf-8?B?SFg3dXA4RzVIb1dyeklzc2ROdWdQenp4RlJPZmJpbVFXSGszVGEyOXRDWFFy?=
 =?utf-8?B?dVJZQnJ3QW12NHlhNEFRWGkxS0t1OTRkVkkyVXV5bGlaNDlheFBzKzVjVEdN?=
 =?utf-8?B?VThDZEw0eE1UaXVGak41V2owRjZDY2RONG5ZZzdGTWQyTUQ0MUlHVmJpWU9W?=
 =?utf-8?B?UVpyZkJwc2RIOXZ0a2hBbkI4WDREQnF0UElzTVkreWVDZmtTc2kyeVZOaUdQ?=
 =?utf-8?B?NVZab2xOY3FiSnFReEhCODNzQWo4MFlkNkRwNkVBTWRab2ppQVFXc0JjOGx6?=
 =?utf-8?B?SG9GZTZDL2JGQWh5M1BQUjV0QkdxTXFIOHBuYW9PdlZuV0Q2UWJTNW1QanVi?=
 =?utf-8?B?cGRZY2syZzRNMDdHV0FXbzNsL0k2dkFvMjAyeXAzazdtMXloMFk5ZzlYZVh0?=
 =?utf-8?B?VFVNTGV3THpSbmpIaTBQMDhnYit0Zm52VzBEOEpBZG9TSTV4bDk4bEhzQUNh?=
 =?utf-8?B?SERJS3pQNC9GZDFweDg0K3lqSjVtTWRkcGtqRlo5QURHcE11Qlc3UVRjdHYz?=
 =?utf-8?B?dXhualVrNUE4ckpOMzd3cHBySWptUWg1NC96Ty93amdIdjlhT2RYbmFad2dn?=
 =?utf-8?B?eENhSGlHOUNDZFVuTWVtK0FwYzdOdU1xOVNnSUd0RmtpL3A2U0h5TmFiRFJa?=
 =?utf-8?B?QlUxbk9mSFZqbmtlM21XaWhVQytpeEFkbzJzWm0xUzNveG4rRVB2dFByblhY?=
 =?utf-8?B?MkNWNW9oSTFlK05Bclc0bkE5WjdNWTBtbGgwVTFHK3A1YlpSazRvM0tyQkdF?=
 =?utf-8?B?dmkzaDBUMkZNelNvT1pjbWllU1dBcUZ2RlovSFRFamgrZXdWRWJaSThscDBK?=
 =?utf-8?B?Ykp3dXZXY21jQ2pwRDdySElLajdsNjFkVzJGOFB1elNMSHduV21yQ2NESTdF?=
 =?utf-8?B?UkE5bll5THRDK0l5T1hEZXR2R0pkVEZoYi9xWVlXNDR1ZUtjTkF3Um82Uk9s?=
 =?utf-8?B?dnhURzU2MmtSSjB0TGwyYm1vUUdzMEk1K3RJSWpzcXZXOU0yWkVvLzg3bzJC?=
 =?utf-8?B?UzJPamgwZ0N3YXltelY2M2M3Ly8wYWZrUjBlUmo3YytMNzZjbEFnTVJYb2dU?=
 =?utf-8?B?N3lvUkQxUVdPcUdFZElHQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGpld25kVmEvNWhMaDgxcC93Nmtkb3k4Y3dGN28yWk5NM1laUm53UHBaMm04?=
 =?utf-8?B?NmhaRXBqZ3pHRFpjYUpDSmR1NzBGZHE4Mm5EQzJ6bkNkb29PTjdhOXRzNjFr?=
 =?utf-8?B?MTFRWUdpZkhGcVJpSFpvMU9iZUNnZzJYKzRzWGpwc3lZeEU5eGxGbUZ4UjZp?=
 =?utf-8?B?OVk4UndMSGpIVTBXbHY5Z3FIcXdmWEVzTVF5bXdFVS9Hd1U2djV4dzl3LzY2?=
 =?utf-8?B?ZWFVVExJdlc1elMvQTNnTWV6UGw4QWNGaHpweDlDTVlqK1QreC81QnFtU25W?=
 =?utf-8?B?RlJ3VXRBWHo0L1VvYXpqL0V2L2JYbmRLS0dmTmR5QmJLMUFIdlkrQVRWdWoy?=
 =?utf-8?B?QUJiUkNIdGVKSStBNGFXVnkwbGRUejIxN0xrN1NzOE00b3VpWTFUQXI5TXB1?=
 =?utf-8?B?Q0d2NWFHM2M1OWtSNngyOWpWVEd2MmhPc0V5blhhR3BwSVpVT1VPWlFXM0dK?=
 =?utf-8?B?ZWxURmF1N0Y1T2R0eWNXTmxCSGxwRnBQUTZuNGc1d1FPMFVhNEwxMzRFTTVk?=
 =?utf-8?B?TS9FZnJVM21vWm00K3ZFVzRNWlpTQnhtTUFNTmMrQjBnRS9VT2M4dWVxYlBh?=
 =?utf-8?B?b3VQNmpvaGhJb29PZjc1SlJMd2d1K3ZPcFVxdEZ6c1pHUGtpeXpzVVdxa3k4?=
 =?utf-8?B?Uzh3eUJCZ1VvaU92QmVYZmw5VVk4VzB6OHNlaG9ZQkN5bXp4RXZTM2lhbzQx?=
 =?utf-8?B?VGxmbkhtRnl2cHVna00zWENFMS9CeE9JOWFDVlJUKzNKS1pIY2dtbmNuVHNv?=
 =?utf-8?B?S2VqN2Z1cnJCME5rRzd4cTd1ZmtHejVQbnFJYXg4VmVQR2x4OEp4NHRSRGN4?=
 =?utf-8?B?Y082aEpwQi9zTXhNKzJuL2d4Tlpqdk9TY092V242T01NQllGWHB6Q3JPZGt2?=
 =?utf-8?B?UWlKU1ArYzFGeTRJbEpQVzJTcVkzU3NFV081clpqMEV4KzNuVTF1QkJCdkUz?=
 =?utf-8?B?RGdUdFo5TTU3WGREbTdPZU85dUR4eC83OExKQm5MTTl4Vmt2b0xKMVRza3l6?=
 =?utf-8?B?RjdseWVhWWVER2RNNlViNVgxNGhMWUZReHNyTXFYMXFkekFFT01TQXNxeHdq?=
 =?utf-8?B?ckNmSjZtWDM4dGhMSmxwRktNSmROTHlRdkUwR2ErSzBlb0o3M3RIeGpVVTB2?=
 =?utf-8?B?eWh5RkFmcEJlY2tmUHRzVDI4TENBRDhiQjYvWm5qaUNMbzBueUZmN2hkdzBF?=
 =?utf-8?B?RDMzeEVUUExHNUxHNFhjNDZpZ0J0Q0hEM1JwUDZITmsyTlVWZnB1cUVRUXRC?=
 =?utf-8?B?LzhVWDh1UkNDM0pmL0t0WGZ4OStXRDFoU2NxUjRPejl3ZjhiTGFyaFozMmM4?=
 =?utf-8?B?aVlmWEdEQnVFUytFaUIyMEZiYzZjTW0yeHl1eFYzQXRqV09SVUMzVXlpTGlq?=
 =?utf-8?B?K2R2emxPNXp3bi96NURva0swdCt3YjBUOW9mQVF5NU16dlRiTGVwVkhXNFo1?=
 =?utf-8?B?UktsNi9vZ3Y2eFNyTGQ5RDZRb3VWcEIrSUNaZUtUYmVucWJIYWxkbVp6Y3lw?=
 =?utf-8?B?eUM2dE5rUElwbFhrTS8vUlgzbG1rMmd3eTNTd1RZTkdPRFgybTk2WGxCNEpm?=
 =?utf-8?B?cEpCYnlpeUhya1hwTGluNzhFUENIZXZDU01oQnFwSTFiSk9YaGdNQ1RRVExE?=
 =?utf-8?B?ZTREK2ppNUxyek92ays1Ym5PSzAxQ25RYjRheXh6UGcyazZIZVZ4UThoQ0E2?=
 =?utf-8?B?YWgxTnNaS2Z6eXZDZEZtMjZpOHJDeS8ydWpKZDNQbmM4UkV1STZiL3lGT3Rm?=
 =?utf-8?B?ZEJ1cERrZXhMSnkxczc3U0lsTEc0Y1QzSzFTb1pVdEhZdWV6OEF2S2lWOURv?=
 =?utf-8?B?MUV2Wm9vVEFsT29zTk92M3I2ejZlZTRsVm5Md2hPL2FYUzk5bFYyeHEwS0Rh?=
 =?utf-8?B?aVFJWExMcXZ3SllEY0U4a2ZjRjFmWDZzS0lGSGdyVWRheGs2cGQreEh3U2px?=
 =?utf-8?B?UmlCUjBzek1xVmh4cE01Sk12OTJTY2Iwemd3OVFiUWk2N1k4Rzd3RVFOL0lh?=
 =?utf-8?B?eHpXWGEvMHVuaEJyeHVHa0dYamE4aW1zckZnRjBYVWYxYU9aYXFveTFJOVpE?=
 =?utf-8?B?a21meXpWOW03Zkp2OFg3a0QvWHpYRGE1T0ZyM0djbm9xM2NWU2srTm9KV09t?=
 =?utf-8?Q?YMtl1N6om6BhQt99h+J86NAAE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z3kcFP59pUyO2HEIDBUqxMtzpx26hKyy1b0JNL7sPkCCeTXV84aWQmlFUdw4/1ZGLiLOQcSTuy/Dz9eyFNlPhF9+N/Fu+gZVpnlYSN89xHjvrlJq68LLCf/7ywQHY7MBjFfPWkutkognkixbSqtH+GX7u+pZ0wtcV+dQwgrD4ON+jwI7AFPY4Nr2R5rNV2GRdNAknoNcbO8AHxzlLJaNq97cI5gVLA/DMdH/w6hzO2K2fzlP6Yz351wKUUn4NbSPmY7tWUjlkwx+GIDYXWQq8+cMv0C3XPkgby9oBtCn4xAt4RtqKYtmjXWPzt6bn6SA3KyDk8L8OpbMynzIt9VGAe8fXenEgb+HK6crV0j7gP0vEuhcf0gbEW0N8723bwOlyIbPC87Gq8Zf9oPqmeb/2C7h3KHKjwLH5OXPxsSpxhHwIMY0VOLYINTWcqbb+Xu5sRAwDifFjd9fw3l0+N0eSzSymvD1ckU8MP3GneSBKEQGGkW2TMTHakx1PiT6EzZAx3Dg0+KwjBkQyVkDnaoza9I2vZ0BQe+imFqpM9ZE1mqSWMSjmTOQoRTp4DpRBd47FHKu/VdzAYLg5ynWJ9z+nXHEg5iSZWnBZ8M5BqBuTH4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d38f81-3be1-4c31-f8c9-08dcce87b820
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:22:28.6971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhidpD1Bs9yIgDjcFGR9OKtUlks4Pb67afNZ+Kig8BcTbycj5hLBN9qFH7V0j4jKJMpRPMnyEB9VJTewIcZLGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_03,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=830
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060113
X-Proofpoint-GUID: CSsihisg9A3XTJbqm6Bzoq3tmO8HwASn
X-Proofpoint-ORIG-GUID: CSsihisg9A3XTJbqm6Bzoq3tmO8HwASn

On 05/09/2024 10:37, Luis Chamberlain wrote:


Sorry for the slow response. For some reason I did not receive this 
mail. I just downloaded from lore now.

> On Thu, Aug 29, 2024 at 12:31:00PM +0000, John Garry wrote:
>> The verify feature can be useful to prove atomic writes. However, atomic
>> writes only ensure a proper CRC, but not sequence number. So sequence
>> numbers are ignored in verify mode for atomic writes.

How fio verify mode works is that we write datablocks to the file with a 
CRC and sequence number per block. When verifying, we check the expected 
sequence number and embedded CRC per block - if not as expected, we 
error. This should not happen for a single job.

However, if we have multiple jobs, they may overwrite blocks from other 
jobs - fio warns us about that. As such, in verify mode, the read 
sequence number may not match was we were expecting with multiple jobs 
running. In normal non-atomic write verify mode, the CRC may also be 
incorrect, as we may see partially written blocks.

However, in atomic write verify mode, the CRC should be good with 
multiple jobs, as we won't see a partial write. The data may not 
actually be what we wrote - hence the possible incorrect sequence number 
- but the CRC itself should be ok.

> 
> Why not? Note that NVMe TP4098 MAM support (not public yet I think so
> I'm not going into details) 

This is not related to MAM, and really an fio feature.

> is outside of scope as the current
> RWF_ATOMIC requirements specifically require natural alignment and for
> the writes to be between  stx_atomic_write_unit_min (LBA format) and
> stx_atomic_write_unit_max (AWUPF) -- why are we not getting sequence
> numbers right? Is that a SCSI issue?

This is related to how fio verify mode works, and not related to SCSI or 
NVMe.

cheers,
John
