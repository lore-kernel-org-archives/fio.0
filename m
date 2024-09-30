Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02olkn2109.outbound.protection.outlook.com [40.92.50.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197E040862
	for <fio@vger.kernel.org>; Mon, 30 Sep 2024 08:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.50.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727683559; cv=fail; b=l9sLlPwmugFRL4BODT/lna3Z7nFC+A4tZO6UiY6/Sn1UJjgeLBYsmzGe+JE/HWgIvRAdcIIhYD+8ZFlvpv7wLmLSfTew9a0+q/aRHDfUBDUlLtnpCB8NIgzLBaCG4+ZSp0ZrwXL5bifckbgoHXSd4fDybfbjqkkq7pTlMUfMt1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727683559; c=relaxed/simple;
	bh=BLX0CKfyZxK3uHyUiMPCn8ckT16JzJkkg9vTW6sM474=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=YDmfMNvRZmha4wt9zlY85Guc43Pa49i7ZsqwMt8GH6W8l2aXGXd1cPE7cKsvRtu8LS6O1lPNkOdhPo2nNSGWVglSPdLelObPTL0JDaMt2u/oTElr9Ecuo7hZU0mRdfPd0tMN7lS3Zm56aXC75/fKBR2wUBiiwx12hEX0czWmn2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=gAYxmD8s; arc=fail smtp.client-ip=40.92.50.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="gAYxmD8s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ch4BAQMIy6YAY8RDkr7ElbT5f/ZVv9MwUzDb0rGdzaz94XkeBS4YPwSQGT2k88zGU0frvPy6zZTcYaDN2UuoBqfKwooO3LqircK//LGpZolTBWyE/6o4ke0/hciLdeb9usxS2mD67DqftHmYIodKm6AjyOs9LIpf59dKSOZGqqNB/85XSXtCVpW6YszXqjBxsIzLsCPMwP9DZOxtCfHz/b1N0o0QtNeK54W0Og8upzIlJ0M7HH+Ng54HniS9FjHrgNlXLC9hHngfZIOW3Z3AFdgHPP0kfNAvCpsuEOLxtmGG0lKsqPSx90beWQkWNWCF9BHWTr3oOGigggqcmqvJqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xa9mgTZywp/wmPM8DUan9nLsMcyvCiEYlxYQ3SyaVJM=;
 b=dmPrprVZwI1BzV3SV316haydPHXrj+Ld/JwMwipBnoazYaIiK9k3eovcPkfvH/tVxPn8GlFlG/3A/C9SOGtBpsDxWVye2wjcJ4JJv52Mc7nSOywcz+zLcAxYcPKnCA8Ab1N7cL0OGG3v9Ok6Cl0XPdPm5cU6UMj83l75hHeiAysuOrG8hgbbXM6ov0yKAOXOTCzYmfQ7Go3SSJh2fmaaaeL75oqZVXOicBpkO3YEqU//qv7gAOOXi5EibhuCSPwmVW5YUXL2d8jLGBDawimSnUMG4nh5y9Obw5rbFjLSFBw55QdNpe8qLSYEB+pfEdR6s1lovNuh2SvdhR/0RlhP3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xa9mgTZywp/wmPM8DUan9nLsMcyvCiEYlxYQ3SyaVJM=;
 b=gAYxmD8sjfHb/2iG0H8+weWQTsOAt0tDImR52XcNuNYzQCFPxmFaWlZCO6c2m5dsmvHpOESWa7OEhX8b7OphC+MWqqUGV0hYpSsd7eNYxr2CxZboIBcIc3KCbazOj/AG+64+q7OppPFpVY0E8RvUx8CNm7ZPaOkg2qayKRsL2Pmcr+BD+D8UHG9rBLUnhnVAOrFxsCqP4VeS7Qiyttux4grK/E5R7DRsX1zSaaBytrrbCOOhhtGsK7PM0fjzpc1aXWeF9uIuQs0oPstVA6L7q4k4XLD+cdsNYbAuTjtvMwxNYjZEgigM3pQtcoCU1laOfXkuJcLKP4IWffw9x2QBUQ==
Received: from GV1P195MB2055.EURP195.PROD.OUTLOOK.COM (2603:10a6:150:a1::5) by
 GV2P195MB2015.EURP195.PROD.OUTLOOK.COM (2603:10a6:150:76::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.24; Mon, 30 Sep 2024 08:05:55 +0000
Received: from GV1P195MB2055.EURP195.PROD.OUTLOOK.COM
 ([fe80::d7e4:bae0:94b0:378f]) by GV1P195MB2055.EURP195.PROD.OUTLOOK.COM
 ([fe80::d7e4:bae0:94b0:378f%2]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 08:05:55 +0000
Message-ID:
 <GV1P195MB205577C20DA7B1A65782397AEE762@GV1P195MB2055.EURP195.PROD.OUTLOOK.COM>
Date: Mon, 30 Sep 2024 10:05:54 +0200
User-Agent: Mozilla Thunderbird
To: fio@vger.kernel.org
Content-Language: en-US
From: Jigao Luo <jigao.luo@outlook.com>
Subject: [General question] on iodepth Combined with numjobs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0234.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::18) To GV1P195MB2055.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:150:a1::5)
X-Microsoft-Original-Message-ID:
 <3c864fe3-7aa7-4d73-8fb0-71e9c04e9062@outlook.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P195MB2055:EE_|GV2P195MB2015:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f94acad-1f07-4bf9-74f2-08dce126b57e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799006|19110799003|8060799006|6090799003|5072599009|461199028|7092599003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	vQ4cPbYfE/C/G3ejtCov8Ed/4Fe97W4ilBhIhP1bRB4Y0S6zBrI5i0pJAJY6edl7RBz28UH2vbk/2CxJQRRRIUuX+9XJRMvpHylqaFGjhIkWA5d2UIM4DIQtMvvLKmCfU69xeCq1nRx/trRIwqGmuX/qprBiUAGbUJ0rsUQ09UoQpAxIeGblBYk25RUOS0trfRc7yiHBj2xXICfdBt6i6JKwyRCcags4N+I0l8It5c2sFZjp3rTRiygSDF7gHpobRAZqCjTtY/oLRrN8yYEbSKeD5sI41lUaQ/6SMo3wQr0wss6VLjcS+GF75uFLDBCa/MokzDZKoP51843tf411FG1SYc1P8EpmEGu7dMmO0pdi1DV4NH44Dd1Cs5n2wP3LPPRAOxvuguxnKJfgrFG6AZZKt9v6O5mgJ0DZzqw9hgKg9WAEgqSKgkuk+TcbY6/mDw8XHQ3bxx5kHU6rPYTHkalVoJFtl47I0t8j6/+BO1Sqkclyh/1UaMP8pO3xoRwcBSrARTJnaToQfQJu1U+tvaBfMjYfJb33jUeFacHRKXiaAE7rprLzYPU53ETlTxw3/7fuov6xzJFxMdf13ljXtiy0gJBjdvhyILhVEvyB7L57b9JaWWE0UU+LJ+ffWpAXM8GaTwv/xL/jNMc3mch678VObS5MPFtM/bXZC+V/k1FE2Qj8PB5KKEjm4wznMogAgJ7lWt4KUzxZDM2Q1+MOtHgUXjx2KPAPcBDs1fJuCo5WV6QEg9FBEf0qpBrjmmT5pmgTLcyd3OOgqEBy71C/8w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlNVQmNxc3VWSTl0all3S1o2UEFYNmJxVGpHeUNqTjBjMW01eU5sNHltTnU0?=
 =?utf-8?B?b011R3RwdlhuOE9mL3dWWXRISGFuc2VtZ25IT3RFN3paM0FFbDQ2WUNDblhW?=
 =?utf-8?B?MTJTTXhoZU12cXVxWGpMQkZLNVJyR0ozSGhKSU9ZaUp4VXkzakdERmxDeXNG?=
 =?utf-8?B?azJFNWlKZlpMYkcrVXFSVGVQMlhvZThoZGVTcERMbWhGL1g0SXUwdDk3OG11?=
 =?utf-8?B?RWtkMG1mQ3UxQjg5WDUrbWlncTBiSnFmSTQyYnluZ1VXaTh2RjA3ZzRFVTRZ?=
 =?utf-8?B?dHNDOUJrQW1renR5aXk1RzN3UFZGY2lHV2E5WHhFdDJHcjExS1pmUXhnYXNL?=
 =?utf-8?B?OGpxMGZsYXVvZlFhVUhKOUtZMEExUExzdnI4MkllL3EwQUxLRVFvVlhXZVFK?=
 =?utf-8?B?Y09aS1FjSzE2RWtYZUQxSzhGRjRiRXNlWlQ1dTZibU45KzMxN091RmRFMFNL?=
 =?utf-8?B?WXNZR1NNQTRpZ3N0ZTlIaUk4SWYwTTByL2JQMkpuYVhmbW05SlNQcGRtaUJU?=
 =?utf-8?B?Szh0amRXZjUvR0J5QkdrLzdsWlZoNnRtMkFWTnFuQkZWRVFWb1JiZEhFYXVi?=
 =?utf-8?B?alFRQlRJNEdmeEdtTG5ha29jalA4YjRCZWVXbXcvZmFWOGFMaFZyeTdScFk4?=
 =?utf-8?B?dzFqU3FQVGY4MEdQUUQzZndMQi9MWTU2Mnd6OHVrZWpRZjdhQ0ZMcWE0SHJY?=
 =?utf-8?B?b1M3SjRiK0xLT21yTVB4dXRGZGlYcXF3alVHZDVoVnhuVHNZWGg4NHhMMXZG?=
 =?utf-8?B?dmIyR1VWSHB5VGtwTEQ0L1VWdFF6bEtzOEt0R1M5NFdkY3dZb3U3REpiTVp4?=
 =?utf-8?B?ZWl0Z1k3d1phbSswTXJVUURMNCsvWjhQWmJtN0kxbFhTQUVHTGVFYnUrSFlP?=
 =?utf-8?B?Z3FuTXRGNE5QQm1HbXUwNEZWeGZBSDR1RFY2b0s5RDNEa2xocFZQWHRhSE13?=
 =?utf-8?B?aS9MMmFuRk11S2ZiQzJjTUpHUUl3U0FNVjlWY0s5eG41Mld4RElqZ1BFWThR?=
 =?utf-8?B?YU05dS9IeEZJUkJFQkxQSnFrZXpYclJYWTVrMkhXcUN5bXZmMmNvL2Z1ZG91?=
 =?utf-8?B?THRqWFRyWHJZWE4vV0oxY2N3UGdYTlRmM3hOWWpONGt2S3pBSlJTVHlZOUNP?=
 =?utf-8?B?LzdhNitpWE5idkVaQkhRa1lyNUUwa2NaRm1SM294NlY4ZkFuSjAxY2tmWXdD?=
 =?utf-8?B?M0JXT1ZnYUVLcVJ3SG1CU2sxdm9rdWx0allxYndFbTJWRGovN2tlYVVtYVJr?=
 =?utf-8?B?OVBNNFMvcU04Q2FLaGVBSXkveFJreUhzUkxpOHg1OG8rS0ROUE1aWi9GYkhs?=
 =?utf-8?B?Uys5cnhURVBIVkNEc3NaaW8wSzc3VlZyUXF0ZHJBYU9PSSs3ZXg1UkhpbEd4?=
 =?utf-8?B?K3gxbElFb0s0eVhjcENmMnloc3FReXE1RUh4ZHE3VVRUeU94MXJhT3NENmFL?=
 =?utf-8?B?Z3JvWnQ2L0xXYjljcXJocXdDR1hIUzd5L0V1bW9mNDkrWlJUbkpCQkhxSGp2?=
 =?utf-8?B?VTQ0NjNWVGtiMmE3ZGhFdVlOZG1oV2hHWjRPV3E4eUc4TnFSYi9WdzBXK3Ix?=
 =?utf-8?B?L2RPNjF5cWh1eVBjcVFLRzNJa0dnVE5YTEo3bTFQbzRwSDlxTDBsVks1NnZa?=
 =?utf-8?B?YklnYUhPVEU3SDVoTVV3SDIrWUZhbVJBWFpkb0VFOWdhRGQySy8zekFicTVa?=
 =?utf-8?B?RUZieVpFcEw0dk1pTTQwWWNxV2pNSlhOaDNDRzQrTk43cXB6Y3RUMm0wVUh4?=
 =?utf-8?Q?3Z1+79MOKlNL8ws6O0=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f94acad-1f07-4bf9-74f2-08dce126b57e
X-MS-Exchange-CrossTenant-AuthSource: GV1P195MB2055.EURP195.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 08:05:55.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2P195MB2015

Hi everyone,

I have a quick question to confirm the behavior of *iodepth* when 
combined with *numjobs* in FIO. Based on the FIO script below, is the 
iodepth set to 256 for the device /dev/nvme0n1?
 From my understanding, iodepth value is set to 128 for each numjobs, 
and since there are 2 numjobs for this device, the total depth would be 
128 * 2 = 256 for /dev/nvme0n1. Is this interpretation correct?

Thanks


[global]
ioengine=io_uring
thread=1
direct=1
percentile_list=50:90:99:99.5:99.9:99.99:99.999
group_reporting=1
norandommap=1
rw=randread
bs=4k
time_based=1
runtime=20

[filename0]
filename=Nvme0n1
iodepth=128
numjobs=2
cpus_allowed=18,19
numa_mem_policy=prefer:1

