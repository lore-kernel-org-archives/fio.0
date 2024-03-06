Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6465E206
	for <fio@vger.kernel.org>; Wed,  6 Mar 2024 09:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709718259; cv=fail; b=ETp+V7VnyEJsFkDqHKjpB9jsApGUGQLQsrO2QDy5jg9ieucO/2TOFfBRehXllnv2PpGGP51npzPBql9n7pCNqVumdE33x7viq5nepXxxVBzADqFKqgvegAkX4s8lhnzAunPSsVNSlGNHgQo6NFQm7Euy/GTLHKjeM0frLZxenQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709718259; c=relaxed/simple;
	bh=7TTtwyhGZVoPzF+BMnlz+QjCEnTukNvBDUtRYR3RN6I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mroOyNVhP5hVcTWwV+PKuSoYvoN54omA9zfeCRJb8S9rjMWUCYU+11CU+iE38BOcmo1XCY4Yi4yAj2HFR8nuqrWjSSSImqk64abFuu4CLUoa3/gTRNnfdNhc+2xgXqTgxZNogZbauNbTo+zbNQVEL0EX3ORXZ9tJyVfKmpBkm+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B/VmnZ2F; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B/VmnZ2F"
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4268bGbo004571
	for <fio@vger.kernel.org>; Wed, 6 Mar 2024 09:44:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7TTtwyhGZVoPzF+BMnlz+QjCEnTukNvBDUtRYR3RN6I=;
 b=B/VmnZ2FybylJg/kj51sui4tzO4W8bpqgHRXlr51bLng9ERx7vnM1AXIVTKD7zd8jk+S
 9ZHcmfwxhj/A9TxhJaYbXDJMch5iX6mYVmQeLfJLdDtKStaIuinqfgo3xb3yeKDt2Wcn
 /8zJXInMVEK30jR/Kgt8b53sNLNVZQJqflEZfyR5T1Cm16nQKqMNDz5N8f7h48yB4CIU
 a9oJhr5x9vSF0z2hLqXfF/o8Qc2zfRGYOn0bVFmyaxcH3+OOZ0I128rAIafpxYAylMpM
 snC1e/v277F09tpuvPdfCDoNjpcA5hP4/08bIHKKGmZIun2FVv9qSUNwB3MHOEMtDsJ4 Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wpn4tsxcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 06 Mar 2024 09:44:16 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4269ZOHM026317
	for <fio@vger.kernel.org>; Wed, 6 Mar 2024 09:44:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wpn4tsxcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Mar 2024 09:44:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jH7e1sMhkYyUpAiTXu+xmGJ9bdHhec4natFKMnzjLOI5l2O0hvurgIybynLBjGyIpXeTLjpV3DPOXT679dS41KbyOBJrvza7iKBlUHcyZSWnLH8MGqx13KGSnjjRuzcFQ4lGKWr6TuiEh3OSPULXGYCbixNg44N0pgtn241NIky3zq/FeoL3uoFx/JOug7CMK4pV3TtL179Q2jnlBl8Pj1tFW5ehxNn8dy1HRCfZ9D9yHQhKEtFCkqKC3rNADoIihxdINbGgy26+AI9YsN5DeOmQUV56uvZtYYRLVz3ACosgBBiftaIcudkzBIFoFCUTRpmDfhQRezyEUI+2JC1wDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHHPalYseuZ6TJpi2LscmcHrtsm+mEExkT1mkOS9MZc=;
 b=LAzAvjwa/5d3BuTGdJlm2jDmdl9a7pIaGVjTdVxmdrQ0Fj3Ek2suQZBCKFARU67kj1Dsnf4peNA6qty//SOL3tm0TanBb62nWgncR+ga03RMX+jZZqJ75ALcJVEE+aQiyVpU176mZWfq8JZ7aT1bbIPUqf6Sjy3Y8Sj20VxuywFFh/d1WDQzmDUEZg8oQe2iq+E/4228byZxrh2tVESn77k6ZM+YLLroSVAtqaMY9PJznm7584rD+pYNGQ0I/zkE8mSSucYVhJmtuQMspYmWXx4VAryUhJr0gyzgFUmUYBWZXFpiJwl8RgT9SR6ItQemd7lD6f1RLuKqBdwI0T+J+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=de.ibm.com; dmarc=pass action=none header.from=de.ibm.com;
 dkim=pass header.d=de.ibm.com; arc=none
Received: from SA0PR15MB4014.namprd15.prod.outlook.com (2603:10b6:806:8e::21)
 by SJ0PR15MB4188.namprd15.prod.outlook.com (2603:10b6:a03:2e1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Wed, 6 Mar
 2024 09:44:14 +0000
Received: from SA0PR15MB4014.namprd15.prod.outlook.com
 ([fe80::2ef6:65ec:6fe6:f2ba]) by SA0PR15MB4014.namprd15.prod.outlook.com
 ([fe80::2ef6:65ec:6fe6:f2ba%5]) with mapi id 15.20.7362.024; Wed, 6 Mar 2024
 09:44:13 +0000
From: Thomas Weber <thomas.weber@de.ibm.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "vincentfu@gmail.com"
	<vincentfu@gmail.com>
Subject: Re: fio version change gives different throughput results
Thread-Topic: fio version change gives different throughput results
Thread-Index: AQHab6rY8dHvS7iUtE+4R+pyS0CkJQ==
Date: Wed, 6 Mar 2024 09:44:13 +0000
Message-ID: <064bbd4dc5db416092090ce568ef8759744f46f0.camel@de.ibm.com>
References: <3309778342f6bfdefe0b7a1de1fcddab10902c37.camel@de.ibm.com>
	 <706651ae-3f53-4cc6-aa06-43a49f8e2078@gmail.com>
In-Reply-To: <706651ae-3f53-4cc6-aa06-43a49f8e2078@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB4014:EE_|SJ0PR15MB4188:EE_
x-ms-office365-filtering-correlation-id: 674ab809-c576-449e-c036-08dc3dc1fb94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 vmPsyyddMCrSBVTGDsxYW4v4ABeeTmQjXn6SpQblKaR7ZWNJhTeSsMF8f5NQ8YPAa5qMZmqkIeN7g+PUT5Q6eZkwFfTsKHo9gUYt81Qa3OpCqNy/nbRWgnWh742YmKJ/H18nz0sF38OXEERAQw7MGv3YNWhnJyI6M4A7LmKqYRiL9DIL14cXRSTt5OlJ76HN5L30YdwdUwAz032ItUyldlCZ/h2Irh+iMCgAXUtCePrL+KIULTyMRfKiuH7JcURw7ZPsVOsvGRfcFWDFwYwI8WAG0tfWZLRePjSUOHdBzzFRwAdtrZRyIJqUxY7rcgDfeTczTi9CckRn5G5s583+f+WnHs0WddVI+VZnyK3YlO/sy0lZFipb0um6hV/0jIT0QEnMs7Q5kY/b9tSsqrhMQXTBcRFiPBvRhFVVj11IxtTCS9xHeF7EgxjLx6b2iDa18U680N2ItU9nC2PZYs0ipa8kpPbZdjQtYebZRioJW+lRAvbCOF4TEMrc0QmV9CgHVocCjxfsn1PlS4yVa3IRoEck9g2vD11I/gi0/kuRrq+420e0E3npSnub/0BfWI23417zohpJfewUo4lawhc0zwF72WEnlCju+jOKtbaZu/JmrnJheoPdxqZMPer/ieFMOKtrn8KidQIdgVQc6/ouU1iGsTaiGoI0IbsXwII2MqY=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB4014.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?WHNmMnpvdEVNa2lwVG9tTVNxTXBzSDRielpxRlFmYU8rMlQyZjlaTkgvMk5X?=
 =?utf-8?B?SHVXQ05Tajg0UXlyaU9oeDg1S3pYZTV2WTFIRkNMVW50R0ZjLzhsMFhWbWNI?=
 =?utf-8?B?OG8zaFIwTXNiMTdhdFdEZGFqWG4vSDdMbHR6NW5RV2d3QlEvY1RmQURFUlE2?=
 =?utf-8?B?dDBYT3RWb0FRVjJXS3E5QU02cnEvZjVrUVRidHlScXNIMGdFQmxMODFiT0lT?=
 =?utf-8?B?M1RtcThINDhzRmtnS1dzbEtERWxSZkFEZ1AvT1RvbmJJOE82b0tNVlVvaVZz?=
 =?utf-8?B?RVRici9JVDJoaGxQQlFGR2hWVml0OUpCakh2S1BEeDhWZ0c1UlVLei81WWZT?=
 =?utf-8?B?Nk1JOUtnUE5YM1dhNExTWGJmdGcrTytlNHNEMXF6STkwTjF1ZTZTdVhwWEEy?=
 =?utf-8?B?WW9jWHdYZXlpck9hNlhVUklSUkU5NVg2bjhFSWw4bElJZFBFRjFXSktKSmky?=
 =?utf-8?B?Y3Yxb05DLzQ2OFU4UkNhNG1wNDUyQ0ovbXFZNDFNKzgrOHc1K05RUWw2Skwr?=
 =?utf-8?B?UEpBOE55SE5UVFZXWmNnMUo4dVNCaWlOVHFNcmlOcHcwYzlZR2lRV3ZGaDlB?=
 =?utf-8?B?dkUvYnFGVVo0MDF0Rm5vUmVPaFpKc1NvZVVNZm9nY1FMTk1CTUI3a29LSHFX?=
 =?utf-8?B?VFZ3OUxOWnlCOHNncHhFTFRlbXF2QVBWMk5qMFNTUjJiZmhlak9JNUZmdkMr?=
 =?utf-8?B?M1FXaFN1Ni93K0s0UlJVN1NWS3hmMmp4QWxwa0pKU1pRMGJ5U3dlNWpvMzZj?=
 =?utf-8?B?WjJpYyt1SkRjdnFVWW5RN0VYNVc0UXFhbDlJZ1FYZkNpZGNmVnhnTUhuOEEx?=
 =?utf-8?B?VEVwblZJbWhqcEh2b1VXY203K2dEZW1qZTc4SERnQkw2ZDNQUVFPeHNaNlpx?=
 =?utf-8?B?cHk1SVd6bkdnWEVFNy9iRXVzQjh4amhSQTdTQ1ZvNHhYU0s0Wm5qUDFJVG9m?=
 =?utf-8?B?QWFkVWgwTzN1Q1lWSXlhd2piVzRKN1B2Vy9GZG82dDdvbDNWcU03cnZNaW5E?=
 =?utf-8?B?aStadTB1MWJ2Y2RlQ1lpNHJkUmhsbXFPZkdzZytyVWJBSys4ZDE3a25vYitP?=
 =?utf-8?B?YWxrc2VnZGtXZUpxLzZYaEdQQmJrMWlVejZJREZrcVFSd1RFdVdORTM3Sk43?=
 =?utf-8?B?SytPWldUU0xzMGhlREtEaDg1akFUWTUwZEF2aVdjQkIvY3JZY1haTGd2bE5k?=
 =?utf-8?B?MUhzNnUrUEc4ejRpVmhkbGR2UGRSVS9YY1djb1ZiRHNUL200elVsbHZHdEJj?=
 =?utf-8?B?NVpRSmRGNTZRM3NwK1ZBSTZ3ZXFZZ3VoeWY0NFM0d3dBNVRhQjk3aTUyWUhi?=
 =?utf-8?B?dis0NWlUTncvaFlyemVCRFZlNXg4K29NVEd3NlUyS3NZQ0QrYnpPNk9lSDNr?=
 =?utf-8?B?eU9BV0JPS2V3Tk1ORzdqVGNkSXkwSFI2L25oaHozd0JQM0J0cmwyb1lTa1k2?=
 =?utf-8?B?ZTZvYmYyNEhXSlRVWm8rZFBzYUo4ckJxS1pEK1ptYjZZSmgxb1ZZbHMrOU9v?=
 =?utf-8?B?UGdkNStPNVErZ3FWcUNxdGlrNlZ3WDlDVmFoUDNRaVBWVEZqc1llQ3IxeFow?=
 =?utf-8?B?ck44SUd2ZDEyRUQ1b0hsSzZDZDZ4RnpqOU9MN0NIR2ZJQlMrcEc5SS9yWFNX?=
 =?utf-8?B?V3d0Y3h5RmYzOXpZNHVKYTQyZXh5eXZuWHBqVHZUL2VjTGhFQnFNenZma2NJ?=
 =?utf-8?B?N3pjM3lHR2E3WG81cjVRWmdENVdjdEZLQXpXT09tSjVwR080b2tETGFtWWJR?=
 =?utf-8?B?dlc2ZmZCK2tTb3h2TGRvVGU2dmlYUWhuSjF0VmNyVXpPeVNlYldRNFYwcC9y?=
 =?utf-8?B?ckZuR1REazVxR2tnV3NYMVBaU3NnQXJGekw3Z3QyRGtmQTRhQTFnOFNLSGl0?=
 =?utf-8?B?MkZUQjM3NEcweUpuNEEvWTN6SVJzSE5VOHd4V2RnUnRGVHZqcWJyVEVLblRC?=
 =?utf-8?B?KzJOSzVGSHd6Z0ZMYUNNTGxvcUhJd1JTdllGT1hTbGwvU1JmZjY5T25qRzlq?=
 =?utf-8?B?ZzR1cGdtN3EzajZoRWdzUjlXSTdvdnh2cmNoaUdXOXpvQjF5RDdnc1BRRitL?=
 =?utf-8?B?WWNUdXh1VVNkc053dWgybmphQTdZQ3hhQTlRVlRsdGpid05NUHRZRmdaYUJ3?=
 =?utf-8?B?NXVVZUdXdWV1Uk5zcm42ZVVVOVoyOUtjcU4zYWhQdFU4cm9HTG9qZ3NvTlFM?=
 =?utf-8?B?NmRidE9lSHhnUHU2ZnVJdnBydHhSSVFNRW1HMFBjQ1Q0YU9YamhXVnpQVDk4?=
 =?utf-8?B?U1IwQzR2V3BuRmlJWXIzcENDTkdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07A87ADDE43FE14EACD5B035ED151D2A@namprd15.prod.outlook.com>
X-OriginatorOrg: de.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB4014.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 674ab809-c576-449e-c036-08dc3dc1fb94
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2024 09:44:13.7978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rhlqqAgDsRqujH8WgsSXW/Kkyfm9Zc1SZe7TaVi34WH0cZGwL44Rv9j+p3lGS1GJlx3FuzuR841w/70TaIgzWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4188
X-Proofpoint-GUID: 014x71hWseAS8CHGrxHkdUd4WsMhoI9z
X-Proofpoint-ORIG-GUID: ooGDxHZEv6YzxGwCpw0-gyxAuiXYHtnf
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-06_04,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2403060076

T24gVHVlLCAyMDI0LTAzLTA1IGF0IDEyOjExIC0wNTAwLCBWaW5jZW50IEZ1IHdyb3RlOg0KPiBP
biAzLzUvMjQgMDg6NTMsIFRob21hcyBXZWJlciB3cm90ZToNCj4gPiBIaSBhbGwsDQo+ID4gDQo+
ID4gSSBub3RpY2VkIGEgY2hhbmdlIGluIHRoZSByZXBvcnRlZCB0aHJvdWdocHV0IHdoZW4gc3dp
dGNoaW5nIGZyb20NCj4gPiBmaW8gdmVyc2lvbiAzLjE3IHRvIDMuMzYuDQo+ID4gDQo+ID4gSSBu
YXJyb3dlZCBpdCBkb3duIHRvIGZpby0zLjI2IHdoaWNoIHNlZW0gdG8gaW50cm9kdWNlIHRoZQ0K
PiA+IHRocm91Z2hwdXQgY2hhbmdlLg0KPiA+IA0KPiA+IFRoZSBleGVtcGxhcnkgZmlvIHdvcmts
b2FkIGF0dGFjaGVkIGdpdmVzIG1lIGRpZmZlcmVudCByZXN1bHRzDQo+ID4gc2luY2UgdGhlbi4N
Cj4gPiANCj4gPiBXYXMgdGhhdCBjaGFuZ2UgaW50ZW5kZWQ/DQo+ID4gDQo+ID4gVGhhbmtzIFRo
b21hcw0KPiA+IA0KPiA+IGZpby0zLjI1Og0KPiA+IFJ1biBzdGF0dXMgZ3JvdXAgMCAoYWxsIGpv
YnMpOg0KPiA+ICAgICBSRUFEOiBidz0zNjU4TWlCL3MgKDM4MzVNQi9zKSwgMzY1OE1pQi9zLTM2
NThNaUIvcyAoMzgzNU1CL3MtDQo+ID4gMzgzNU1CL3MpLCBpbz00MjlHaUIgKDQ2MEdCKSwgcnVu
PTEyMDAwMS0xMjAwMDFtc2VjDQo+ID4gICAgV1JJVEU6IGJ3PTI0MzhNaUIvcyAoMjU1N01CL3Mp
LCAyNDM4TWlCL3MtMjQzOE1pQi9zICgyNTU3TUIvcy0NCj4gPiAyNTU3TUIvcyksIGlvPTI4Nkdp
QiAoMzA3R0IpLCBydW49MTIwMDAxLTEyMDAwMW1zZWMNCj4gPiANCj4gPiBmaW8tMy4yNjoNCj4g
PiBSdW4gc3RhdHVzIGdyb3VwIDAgKGFsbCBqb2JzKToNCj4gPiAgICAgUkVBRDogYnc9NDc0TWlC
L3MgKDQ5N01CL3MpLCA0NzRNaUIvcy00NzRNaUIvcyAoNDk3TUIvcy0NCj4gPiA0OTdNQi9zKSwg
aW89NTUuNUdpQiAoNTkuNkdCKSwgcnVuPTEyMDAwMS0xMjAwMDFtc2VjDQo+ID4gICAgV1JJVEU6
IGJ3PTMxN01pQi9zICgzMzJNQi9zKSwgMzE3TWlCL3MtMzE3TWlCL3MgKDMzMk1CL3MtDQo+ID4g
MzMyTUIvcyksIGlvPTM3LjFHaUIgKDM5LjlHQiksIHJ1bj0xMjAwMDEtMTIwMDAxbXNlYw0KPiA+
IA0KPiA+IA0KPiA+IEZJT19GUkVFUEFSTTE9ZGVzY3JpcHRpb249bmEgRklPX0ZSRUVQQVJNMj1k
ZXNjcmlwdGlvbj1uYQ0KPiA+IEZJT19GUkVFUEFSTTM9ZGVzY3JpcHRpb249bmEgRklPX0ZSRUVQ
QVJNND1ydW50aW1lPTEyMA0KPiA+IEZJT19GUkVFUEFSTTU9dGltZV9iYXNlZCBGSU9fVEFSR0VU
U1BFQz1kaXJlY3Rvcnk9Li9mc3N0cmVzc19kYXRhDQo+ID4gRklPX05VTUpPQj0xIEZJT19CUz02
NGsgRklPX1NJWkU9MWcgRklPX0RJUkVDVD0wIEZJT19JT0VOR0lORT1zeW5jDQo+ID4gRklPX0lP
REVQVEg9MSBmaW8gLi9mcy1zdHJlc3MyLmZpb2pvYiAtLW91dHB1dC1mb3JtYXQ9bm9ybWFsLHRl
cnNlDQo+ID4gLS10ZXJzZS12ZXJzaW9uPTMgLS13YXJuaW5ncy1mYXRhbCAtLWV0YT1uZXZlcg0K
PiA+IA0KPiA+IGZzLXN0cmVzczIuZmlvam9iIGZpbGU6DQo+ID4gW2dsb2JhbF0NCj4gPiBpb2Vu
Z2luZT0ke0ZJT19JT0VOR0lORX0NCj4gPiBpb2RlcHRoPSR7RklPX0lPREVQVEh9DQo+ID4gc2l6
ZT0ke0ZJT19TSVpFfQ0KPiA+IGRpcmVjdD0ke0ZJT19ESVJFQ1R9DQo+ID4gbnVtam9icz0ke0ZJ
T19OVU1KT0J9DQo+ID4gJHtGSU9fVEFSR0VUU1BFQ30NCj4gPiANCj4gPiAjIGZyZWUgcGFyYW1l
dGVycyB0aGF0IGNhbiBiZSBvdmVyd3JpdHRlbiBpbmNsdWRpbmcgdGhlIHZhcj0NCj4gPiBzcGVj
aWZpZXINCj4gPiAke0ZJT19GUkVFUEFSTTF9DQo+ID4gJHtGSU9fRlJFRVBBUk0yfQ0KPiA+ICR7
RklPX0ZSRUVQQVJNM30NCj4gPiAke0ZJT19GUkVFUEFSTTR9DQo+ID4gJHtGSU9fRlJFRVBBUk01
fQ0KPiA+IA0KPiA+ICMgZW52aXJvbm1lbnQgc2V0dXANCj4gPiBub3JhbmRvbW1hcA0KPiA+IGFs
bHJhbmRyZXBlYXQ9MQ0KPiA+IHN0YXJ0ZGVsYXk9NTBtcy0ycw0KPiA+IHJhbXBfdGltZT01cw0K
PiA+IA0KPiA+IFtzbWFsbHN0dWZmLXNlcS1zbG93XQ0KPiA+IHJ3PXJ3DQo+ID4gbnJmaWxlcz0x
MDAwDQo+ID4gb3BlbmZpbGVzPTI1DQo+ID4gZmlsZXNpemU9MWstMW0NCj4gPiBic3NwbGl0PTRr
LzIwOjEyOGsvODANCj4gPiByd21peHJlYWQ9NjANCj4gPiANCj4gDQo+IFRoZXJlIHdhcyBhIGJ1
ZyBmaXggaW4gZmlvLTMuMjYgd2hpY2ggc2VlbXMgcmVsZXZhbnQgdG8geW91cg0KPiBjb25maWd1
cmF0aW9uOg0KPiANCj4gDQpodHRwczovL2dpdGh1Yi5jb20vYXhib2UvZmlvL2NvbW1pdC80ZWYx
NTYyYTAxMzUxM2ZkMGEwMDQ4Y2NhNDA0OGYyOGQzMDhhOTBmDQo+ICANCj4gDQo+IGNvbW1pdCA0
ZWYxNTYyYTAxMzUxM2ZkMGEwMDQ4Y2NhNDA0OGYyOGQzMDhhOTBmDQo+IEF1dGhvcjogQWRhbSBL
dXBjenlrIDwNCj4gYWt1cGN6eWtAcmVkaGF0LmNvbQ0KPiA+DQo+IERhdGU6ICAgTW9uIERlYyAy
OCAxNDo1NToxNyAyMDIwICswMTAwDQo+IA0KPiAgICAgIGlvX3U6IEZpeCBiYWQgaW50ZXJhY3Rp
b24gd2l0aCAtLW9wZW5maWxlcyBhbmQgbm9uLXNlcXVlbnRpYWwNCj4gZmlsZSANCj4gc2VsZWN0
aW9uIHBvbGljeQ0KPiANCj4gICAgICBQcm9ibGVtIGhhcHBlbnMgd2hlbiAtLW9wZW5maWxlcyBp
cyBzZXQgYW5kIGZpbGVfc2VydmljZV90eXBlDQo+ICE9IA0KPiBGSU9fRlNFUlZJQ0VfU0VRLg0K
PiAgICAgIEluIGZ1bmN0aW9uIF9fZ2V0X25leHRfZmlsZSwgd2UgZGVjcmVtZW50IGZpbGVfc2Vy
dmljZV9sZWZ0IGFuZA0KPiBpZiANCj4gMCwgd2Ugc2VsZWN0DQo+ICAgICAgbmV4dCBmaWxlIHRv
IG9wZXJhdGUgb24uDQo+ICAgICAgSG93ZXZlciwgZ2V0X25leHRfZmlsZV9yYW5kIGNhbiByZXR1
cm4gLUVCVVNZIGlmIHRvbyBtYW55IGZpbGVzDQo+IGFyZSANCj4gYWxyZWFkeSBvcGVuZWQsDQo+
ICAgICAgYW5kIF9fZ2V0X25leHRfZmlsZSBleGl0cyB3aXRoIGVycm9yLg0KPiANCj4gICAgICBJ
biBuZXh0IGludm9jYXRpb24gb2YgX19nZXRfbmV4dF9maWxlLCB3ZSBkZWNyZW1lbnQgDQo+IGZp
bGVfc2VydmljZV9sZWZ0IGFnYWluIChmcm9tIDApLA0KPiAgICAgIHdyYXBwaW5nIGFyb3VuZCB0
byAyXjMyLTEsIGVmZmVjdGl2ZWx5IGxvY2tpbmcgX19nZXRfbmV4dF9maWxlDQo+IHRvIA0KPiBh
bHdheXMgc2VsZWN0IHRoZSBzYW1lLg0KPiANCj4gICAgICBBbGdvcml0aG0gdG8gb2JzZXJ2ZSBi
YWQgYmVoYXZpb3I6DQo+ICAgICAgZmlvIC0tcmFuZHNlZWQ9MSAtLWlvZW5naW5lPWxpYmFpbyAt
LXJ3PXJhbmR3cml0ZSAtLW5yZmlsZXM9MjU2IA0KPiAtLWJzPTRrIC0tc2l6ZT0yNTZtIFwNCj4g
ICAgICAtLWxvb3BzPTUwIC0tYWxsb3dfZmlsZV9jcmVhdGU9MSAtLXdyaXRlX2lvbG9nPWxvZy50
eHQgDQo+IC0tZmlsZV9zZXJ2aWNlX3R5cGU9bm9ybWFsOjIwIFwNCj4gICAgICAtLWZpbGVuYW1l
X2Zvcm1hdD1vYmplY3QuXCRmaWxlbnVtIC0tbmFtZT14IC0tb3BlbmZpbGVzPTEwMA0KPiANCj4g
ICAgICBjYXQgbG9nLnR4dCB8Z3JlcCB3cml0ZSB8Y3V0IC1mIDEgLWQgIiAiIHxzb3J0IHx1bmlx
IC1jIHwgc29ydA0KPiAtbiB8IA0KPiBzZWQgInMvWy5dLyAvIiBcDQo+ICAgICAgfCB3aGlsZSBy
ZWFkIGEgYiBjOyBkbyBlY2hvICRjICRiICRhOyBkb25lIHxzb3J0IC1uDQo+ICAgICAgLi4uLg0K
PiAgICAgIDcwIG9iamVjdCAxNw0KPiAgICAgIDcxIG9iamVjdCAxOQ0KPiAgICAgIDcyIG9iamVj
dCAyMg0KPiAgICAgIDczIG9iamVjdCA2NTI5Ng0KPiAgICAgIDc0IG9iamVjdCA2NTI1NQ0KPiAg
ICAgIDc1IG9iamVjdCAzMw0KPiAgICAgIDc2IG9iamVjdCAyNw0KPiAgICAgIDc3IG9iamVjdCAy
NQ0KPiAgICAgIDc4IG9iamVjdCA2NTI0Mw0KPiAgICAgIDc5IG9iamVjdCAzNg0KPiAgICAgIDgw
IG9iamVjdCA0OQ0KPiAgICAgIDgxIG9iamVjdCA0Nw0KPiAgICAgIC4uLi4NCj4gDQo+ICAgICAg
U2lnbmVkLW9mZi1ieTogQWRhbSBLdXBjenlrIDwNCj4gYWt1cGN6eWtAcmVkaGF0LmNvbQ0KPiA+
DQo+IA0KDQpUaGFuayB5b3UuIEkgbm90aWNlZCB0aGF0IGZpeCBhcyB3ZWxsIGluIHRoZSBmaW8g
Y2hhbmdlbG9nLg0KRnJvbSB0aGUgZGVzY3JpcHRpb24gaXQgc2VlbXMgdG8gYWZmZWN0IG9ubHkg
bm9uLXNlcXVlbnRpYWwgSU8uDQpIb3dldmVyIEkgc2F3IGh1Z2UgdGhyb3VnaHB1dCBkZWdyYWRh
dGlvbnMgZm9yIGJvdGggcnc9cncgYW5kDQpydz1yYW5kcncuDQoNCkRvIHlvdSB0aGluayB0aGlz
IGlzIHJlbGF0ZWQgdG8gdGhhdCBidWcgZml4IHRvbz8NCg0KW3NtYWxsc3R1ZmYtc2VxLXNsb3dd
DQpydz1ydw0KbnJmaWxlcz0xMDAwDQpvcGVuZmlsZXM9MjUNCmZpbGVzaXplPTFrLTFtDQpic3Nw
bGl0PTRrLzIwOjEyOGsvODANCnJ3bWl4cmVhZD02MA0KDQpbc21hbGxzdHVmZi1yYW5kLXNsb3dd
DQpydz1yYW5kcncNCm5yZmlsZXM9MTAwMA0Kb3BlbmZpbGVzPTI1DQpmaWxlc2l6ZT0xay0xbQ0K
YnNzcGxpdD00ay81MDo4ay8yNTo2NGsvMjUNCnJ3bWl4cmVhZD03NQ0KDQo=
