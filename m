Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazolkn19011035.outbound.protection.outlook.com [52.103.43.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402E22FCC12
	for <fio@vger.kernel.org>; Mon, 10 Nov 2025 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762780474; cv=fail; b=c7n+x+6DqSDZe/5xVWX3xnjbukMqhY40R5S+AQv89c7IcGwkA4SBBW3WnWRpfWPK5vo8y5+GLN6rNlrN4USKSCKL8frEkIYt1FOU6xFUqc83xi6iXGLUUIs/ZPiqItiMVpgdR+8bXsqcv7XWucylG8GYi6QyuvLTKOZbUs1wV3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762780474; c=relaxed/simple;
	bh=5w29s3A6jgj+guyVTjeYlOSNPPBOTGL8YchanDProog=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LUL5swAJbtXaUf0DfmJsKEVXzp/JhdYuPCeuniRVrVScmVPo541gBQhjk/o1+9NLNfRucHr1m9cLr7LZYGA/ahGJEf8wtuFSX7sjpINX1/UX0vIa4wKYLzJL5JWulpNU5wa1n3RzuXr7fRV4w6kNeL7HUjVpmSzLItArEjA/AEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ixYSTIik; arc=fail smtp.client-ip=52.103.43.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ixYSTIik"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=neOgBdnxELQOz1LDc5XV9O7F+p28osDV36pRIjwBQMUsKw6Hw5ExewbEyQEn0RP8sm2QffY8JsKl+aNfMZ/G7F9ACRoPEjuDXMgm9f9dToPTnCtiZ8ffUm3Zuv9o4AL7/0qg0a15l+kHxcvgQC4kx9cE2HuRrEme0kl5uZTJAPwX9jpqXlMUTRmtDgwdP61+uhgxkMO4zSFQCp1CXc4Dk2Hax6An2FpZTtBFwQDVd7bKdr8BXENVPXcuiVDuM2iAUTypp53E5T1Z8YRDdG2t3V4SUGtT4vkZ+XIB2of+sqOf/w7FzSK2oY8xB7isQtn0UuslYeztevQhz/zrwfK4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5w29s3A6jgj+guyVTjeYlOSNPPBOTGL8YchanDProog=;
 b=iXeIVd+1VmqF6ke9EftRPKM4frVaNuVF4SRC73i0zfXJQ4ZoKzC9a1jsMA81fbwtHNp5g+oiVaCK1TPbYu7HmoZ5el+v7gcu3LTIDjWXURkJvUCtIW9YuoyK2A3lyEEJgXwBTVhXP3J+M5L2U/QPvn6rR1tuwIsaXCVrcniOE1gsevIW5QPYLQSoT3wEFuC8SwpyT2vfEyADR/DR9tYbRoxDMQ+nbPNyPODjE0k8jAc0/1ZxYn6kkVi5IFqN4hnriz6dKteJjm3ODasm/g/KBPKQHeobDWqvasxVYYD9SKV1mntaheu+VfCimxrGDsaeti0s4m0oPW5QBMejZ1ghEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w29s3A6jgj+guyVTjeYlOSNPPBOTGL8YchanDProog=;
 b=ixYSTIikqe1OdSSR2QMqeamA4yNhKXY9xP+q7KoPJrotH3bLBkaphkChC3WOgyRpxEbemqHdZu/12rdtd0ramJmhMS0FvjI2iy6btZS2xTGrKMj4NH0fs8rsVQppw16Q/zCj4E9wWm797++ZfMqDMxGRlII5ZFvJilEQeWqjx6YRRLhQ9a8OzHFo9/WGF63X6ZAwYms3jBqur3ip790nyKhGKpKd3s7lEqJDdHoExBvDzZT0zzShBIr0tgXK5couw9eU6Z6HeE2Lr0e3AJhQVZgrLWNM9hjBqeCVwko2FyFx9KHeaqus5SlMM6M1zs7yxGUQRn49OZ1wPefXHc36sA==
Received: from TYWPR01MB11940.jpnprd01.prod.outlook.com (2603:1096:400:3fd::8)
 by TY7PR01MB17152.jpnprd01.prod.outlook.com (2603:1096:405:364::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Mon, 10 Nov
 2025 13:14:29 +0000
Received: from TYWPR01MB11940.jpnprd01.prod.outlook.com
 ([fe80::719b:c633:fa29:e549]) by TYWPR01MB11940.jpnprd01.prod.outlook.com
 ([fe80::719b:c633:fa29:e549%6]) with mapi id 15.20.9320.013; Mon, 10 Nov 2025
 13:14:29 +0000
From: =?utf-8?B?5pa5IOmHjOaYjg==?= <limingfang97@outlook.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Can `latency_target` limit rate when iodepth=1 && io is very fast
Thread-Topic: Can `latency_target` limit rate when iodepth=1 && io is very
 fast
Thread-Index: AQHcUkPyOYxJlRmFYUmOa8OUHMjzcA==
Date: Mon, 10 Nov 2025 13:14:29 +0000
Message-ID: <969D2681-E796-4E46-8A8B-862B5B70DA41@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB11940:EE_|TY7PR01MB17152:EE_
x-ms-office365-filtering-correlation-id: d9664609-e836-4b9f-07f6-08de205b14c1
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|461199028|31061999003|8060799015|8062599012|15080799012|19110799012|440099028|3412199025|40105399003|3430499032|102099032;
x-microsoft-antispam-message-info:
 =?utf-8?B?dDhCdlJVR2VhTHd3bUtWb1dQKzNmeVhLWE5xaFVzQTBEQUFxRVRLVk90TzNl?=
 =?utf-8?B?OHQxRCtkUlFhK0ZzamFJZ2JwUGhIL2tZV1I2c3ZBeW0xMGt4SER1NU9ZREJm?=
 =?utf-8?B?eEdpOG1tSXlFUEFldDd3L3dyUE9kVFlPNDlmOW54ZUFubXp3QmFROXZoVVJH?=
 =?utf-8?B?TXRUMHg3emtVUkxYd1ByWFlhUFFyZ1NkMnJ2OTk0L2xrNHk1bllvcDhJb0JQ?=
 =?utf-8?B?SG5HZTZURitQNmpFK0dWTk4wVjY4bm1RbUlVUllZeCtXbEluTng4Vkl5RGhw?=
 =?utf-8?B?RDFJTXVFWExqZkhIYmEwUjd5UytQZ241WHAvMG1JSVJXSHAranVXdEtRSVd3?=
 =?utf-8?B?WHhSaE1melAyV0NndXhBVmsvNkV3elE4YklEV1J1OHJod3dwbEt5eG0vcm4w?=
 =?utf-8?B?RFI2NEIyTzVtWlJKRHZJZGFtTWM2UjdybXVFM2ZEYmNpd1V3WkpmMEx2VTF5?=
 =?utf-8?B?Y1B2WERuTEIrUFRrQUtZbHVwZzhWUHZ4c2o2T2FOR0ZNVk5SWGUzNnNIRXpJ?=
 =?utf-8?B?S3lCWGRYSTBaanZvKzdZaUZWbnpHdStNOTM3WE94WnArUUNWZjN3N3RXRUd6?=
 =?utf-8?B?VjBCR2k4a2Z1Z0owN1c0K1VPRllqdjg3QzBURE9qRUNneTdpcWIvdkhaZGZY?=
 =?utf-8?B?Sk5ac1dHNnB1eiszQTlJMjNtSkQ1UmN0d2swLzdtanVBek1RMkg4RWpMOS9B?=
 =?utf-8?B?ODM2MkZuOWRGL3YzWkR3eVEwaE91SCt0SVRLS21sajI0Z0Y2bFhla3lGc0Na?=
 =?utf-8?B?cXJEeWtWWDcxWHA1UENULzJOaTZ1TWNtS2hkZDQ5WHFKdEMrY2UxUWZEdkNG?=
 =?utf-8?B?bDhiKzdFbDZROTU2SVdmd2FIblRUVWk1UjU2MVNyMHpTMUZPaldya2NtdEJo?=
 =?utf-8?B?REJhOU5NV21hMWtaM0NOVlpMMkw3dE1EVm9oMk51N1I4dFJZZUwyT2tKMVE3?=
 =?utf-8?B?QVhteTFaRHVTZ0dna2c5ZFpXMmZwNEcvVjJnNVJlV29ldm1nUlo2dnV3alp6?=
 =?utf-8?B?cUIrdEswQmJvM2J6c3NFMkg1Tm5kTXY3TzFBN0ZBQlU4YlpPcjJqbjJxUyt0?=
 =?utf-8?B?a3hKTjRmKzZWOUxLckNSMWVpZEJWNXVrdElQK2ZiMjZFdUVlRGJtYm9zV09h?=
 =?utf-8?B?WXkyT1JTY0ppeXpDNlBLeWt5bGxjVlgxNkk1SFFEYnpxSFhwN0pCN1hHcmdE?=
 =?utf-8?B?V2lBSWhmWUxnMG5UUndaUXFualUrZGpJS09mZk9JenYwMlg2b1lKaUNFUktX?=
 =?utf-8?B?M29wcHVhZ3dnNGZRMEx3SG96SFp0UkFVcUZMclUraFk2ZkVuWnJpTU5BNkpu?=
 =?utf-8?B?eStpb0ZnbEJQS0lCM3NXZmFKdFFHSnd0SEY5MFRHQzA2ZUphVDQvMUZ0WmdU?=
 =?utf-8?B?eGRiV1BUVmxndHh5a1RsUU1iMHBiWnd4MWR5ajM3amJZbWdZVHpERitUTjE0?=
 =?utf-8?B?WElqeEpLMXlMNzFaTnpEditMeGJLNWlCMDNqd2orZy96UjVtQjdpa201Z2FZ?=
 =?utf-8?B?Ukt0S08xMjZCU1B4WXVlQkNpOXdxNXR0TXV4a092S3VnVDJhbTZyK2lFRnRF?=
 =?utf-8?Q?Hca0s3ytMQ1C9fl4wIu47pZ7hHyKnaErQN476+rmInQBxo?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TllORWpXWTY0eGtRQnByZkVNdGRPLzVHdzh5N0VSbHpPUUp2QW1GMXQ0VGdL?=
 =?utf-8?B?NmxEZWlocG9XYjA1NFZEdTZRVFFLVFVlb3VMbHBKa0VvTVlLbUc1S1VscFBC?=
 =?utf-8?B?SSs2SnlNdDhNY2h2bUFPMHdGRnIzQlNLSkUxY3I0dmpjRWZOOFVQMnFudGxp?=
 =?utf-8?B?SmMycUZRT1lJRUdIY3lOVTIrQTBPN1V5UFV2OUFBa2ZNK1pOTHhFOENHbGtI?=
 =?utf-8?B?N1BZQ0svVlljS0w3dnJYaktCaXB4S0pNaTN4eUFVNytDcFBQUDBpMjBQeitX?=
 =?utf-8?B?WE1wL3VCYWJLV2lTdnkrUlF6Qzl6V0lObDhNdEFNak5kNXpZUVJSU1M2T3Zk?=
 =?utf-8?B?YWF6VkNaYWFqeG12cVFlQ29ESDBjSEFOakhBOFFvTFMySVpMUmRnK1ByaEdp?=
 =?utf-8?B?eHRjZ2p1UGdzVG04QjUyWUJ2NjNVZnAyeUxHWjR3YVU1SVlGTUVRNlR1alpI?=
 =?utf-8?B?S3BPSDBwZXg4ZW82WXpGUXFsWWd6cHZjaXU0OXZYbURyQTdjQ1F6VzdzYlpq?=
 =?utf-8?B?M3A0L1dOc2RYdUk1WnhiNzFZeWFieUNQemNoQWJ5N0FRSzJ4ZWVtK2MxdnRF?=
 =?utf-8?B?MXVGTkx3eVg2Wmp1Nkt2RGlTUVNtTXRTL2lzZ2IrMDc2a2ZlRVFvNzVtc3FC?=
 =?utf-8?B?TFpkMEs2RnIvZkdRQndNbHh2M1M1ZnUxS2FQY3JPYXllWXRvSmY0UkFNdFNS?=
 =?utf-8?B?aFlFc25PMWR1OW9KVFRtK3J3cTZicjIwWUUvd1pZaVdxS0tUSHZiQ2pMbW5L?=
 =?utf-8?B?OW55ZkFlVUFFazFidytaaVlraTdtWkM2aG9CS2JaY3g5VHdlVE4wYWdYalo0?=
 =?utf-8?B?c0Q3VURiWWVJaUF2dDlIcWJ3VkwvMDR0eFVtNVJsRUp1aEZzTGsxanVVM3Q4?=
 =?utf-8?B?NldmMU9oYmorUlJNVDlUM3p3MFUwRXVuZDFHLzVVL3VhNnkxanp4UkI1bEJK?=
 =?utf-8?B?dmpMcUVGbHVjUHpTL2I1L0pwcVRSczlqa0tFWFlIeENSeXR6Q1MyQnlJM2NQ?=
 =?utf-8?B?MGU4NTBFL2VrWjNMa3RTNXBIOXQ0cXVCMnBaUXVJSjdYeXBNMTdDamF3TTJF?=
 =?utf-8?B?T1lKR2JCVFZSOEJ4SWdKdndLVXRCNVRuZmpWQ2ovNWU0ekpmRTgrdGhmbmJF?=
 =?utf-8?B?dFhnQnQxanVscFBDanRBYUdGUlpPZ1JEYkxLMGxjUWljcDB0eXpCeFR6cjRX?=
 =?utf-8?B?OGZFb0VGM2RDek5CS3dMU2hlNmdsQzdTMnp6QWJqUFdvMTk4bmx1elhWMHd6?=
 =?utf-8?B?VkFCYVlYMDE3cE1WWEFxSVhUd3QrZXN5aVNscmdVUG1YaG4zcEdaMmNXRTd1?=
 =?utf-8?B?VWd1emtqNXk2NzJraTNMVTZQK0tFZmxtSUNtYnZxa1haSHlTUU5mNXNuLzQy?=
 =?utf-8?B?cVh3ZXA0VVNUNkRZZ3VlU1FhZTVKNnFBTTBTWkdGckZJYXZsZWR6aStOcWkr?=
 =?utf-8?B?MkZzTTdvYnpyL0lvTWR4bnFTbFNRM05zc0ZpaWtTdTdTV21IUHptUEJGWXND?=
 =?utf-8?B?Q01oc25SaUZFQ0ZMczh2T2MwbVNNNmUvNWphdXZZZXNCamxvVWh2aEltWGlE?=
 =?utf-8?B?cklTNjJNd1hNMHpONGZtbkkyN1ZRZ25zL2E2ZHJUTWRWLytyZHBLRnFwaVdo?=
 =?utf-8?B?Wk1BekFRMG5wUUZFVFo5UlV2eDg0NVJzK2V5eXEwRXM4NG9mbmdDdzZCSzd4?=
 =?utf-8?Q?j9FXwQI3SUxyO2BVV82w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4261DEBF84BCE949A09427CA4DD53E7A@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB11940.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d9664609-e836-4b9f-07f6-08de205b14c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 13:14:29.5205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY7PR01MB17152

QmFja2dyb3VuZDogaSB1c2UgbGliYWlvIGVuZ2luZSBhbmQgaW9zaXplPTY0aywgd3JpdGluZyBp
cyB2ZXJ5IGZhc3QsKGUuZy4sIHBjdDk5IOKJiCA1MDB1cyBhbmQgYnc9MTAwMG0pDQpRdWVzdGlv
bjogaWYgaSBzZXQgYGlvZGVwdGg9MWAgYW5kIGBsYXRlbmN5X3RhcmdldD0xMDB1c2AgYW5kIGBs
YXRlbmN5X3BlcmNlbnRpbGU9OTlgLCBpIGZvdW5kIGZpbyB3b27igJl0IGxpbWl0IGlvIHRvIG1l
ZXQgbXkgbGF0ZW5jeSByZXF1aXJlbWVudCwgaW4gdGhlIGZpbmFsIHJlcG9ydCwgaSBzdGlsbCBn
b3QgbGF0X3BjdDk5IOKJiCA1MDB1cyBhbmQgYnc9MTAwMG0uIElzIHRoZXJlIGFueSBvcHRpb24g
aSBjYW4gdXNlIHRvIGxpbWl0IHRoZSBwY3Q5OSBsYXRlbmN5IDwgMTAwdXM=
