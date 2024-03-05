Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104684CB4E
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 08:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709628056; cv=fail; b=uw8rcz/LmlZXhInq1jZ4NSWajJ+tRdr8nyssdEjkgPTCslDiaVyr33GfDH9KLVYCYzJ/IBjGeBFA/1PCXN7MjEy1X37V6cue+b/JHS7faEpdVCyAQ97+aqeZzNfoCfseoCiwk0byFaPwhygJ9g586YOV6SCw2We5REoP69Mhc80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709628056; c=relaxed/simple;
	bh=AsNjuISY9UL3CO5NJSXBsgr0IWwvqH2dbozaR4cgeb4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GGCQvNj3qpxASJnelBTb7y7HxfqW8eJ7uY6eyLOg1+8PYQ4v8YFyT6NKfbxQAe6HmgKCvxnTeFbrIJMNpLJEgUaHa/8gihX88HrUMvjBv8tB+9a7+fniEhWApWX5ISXHp+ZNwxGhC0E08exq8RVGlMwdbYWhFY0dNPucjtD0tHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mOQbgDMc; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wC8Khp3e; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mOQbgDMc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wC8Khp3e"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709628053; x=1741164053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AsNjuISY9UL3CO5NJSXBsgr0IWwvqH2dbozaR4cgeb4=;
  b=mOQbgDMcAKvDKYz0DcHpAV7jShrYQavGko3g0lwSCOPhYqgYps7j4ikp
   CaPzAYQqzJOTIK5ppeJJEPvqS9meuaFq6Tl4frloJJlxyR0Hd6wH1JtMS
   L0u+f6KYZBIyL37x+EpabSUWjLW93T+H2hujKfhCK/iub7Qbeb1wJRaHz
   5vvvlg9yt+1usxfC+q/WgxLUCByTlm+Aq81k4qk4ZwP2G3/UsFW+Mbnty
   T+sPl+qeIKMwbg9cEdxBZs1/pv96JSwykkZfSgKV+w53LBvXjPdGcWrme
   oJTha5teRH9QB4EPuwXQso4jxF4IyIqo7n71cojdamU54xkcOnem+Widb
   w==;
X-CSE-ConnectionGUID: ReZYgd1lQ0mojS/byFD0Jg==
X-CSE-MsgGUID: NARa1SRGR3qQpTZr5BLixA==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="11422905"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 16:40:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g46TKFGDzXq0DabW23JpFhDK5BUx53ihswuyPSaJ+b9Pmw5FBf5BUDlP4ukn4A4LO7u5epw3YgRg1jkWrGVeYvpszXB7NuJHKvgRxOR5C0duYMq6PLgm7zDA0FH2zr5ZMBkBBsxudrjPHeyyqyf0VSfBGDFOvxf1Fdnhr2S/qjoP5n6hErjo8WWbVJwBd5HrUGRv7gEnrGZYg9RWXH0K+N1/UvsxFJMW9cnAXc835TfBZR79zuiiM+U3Bs3kW6G2L6MB/qrCrJDYHt5jBcAcLRLzBDwfod3xIL8EI9r0+U8Yekm0m4yPzkxBhxqrD1W+nmPDznxSgbPpkzxF68luxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsNjuISY9UL3CO5NJSXBsgr0IWwvqH2dbozaR4cgeb4=;
 b=V3wo7fUQGlR5bg2TCeOxjudFHIWq4FuM700vxxh9Es/lDD4w3+9A9FiQ9JDSbjKiCppwMC3HrnusX+XjzGMl9qKUJSsyCX3RsNb9E6ZteRPHkRN07OAv56r5kftwiCGBBpjHJpzvEP6sMdXFIUdzvpXpvZKndTgMaV4pa9RcFNqMLZDJTLpD4lq2LX0m1NdDql82niO/GbVmX3vHgG0u3rllPzvxm7wnTEfYA8I+GmZgPC+vwHD5KPGbd7OMx5lVbTx0y2sRGyZTntGieRYLwHlsAJ+wD8N2DndgFR3rmTeXFUo9a70eC5TV+tTghTcDe9joLgDnPUhVvjeyzM/zmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsNjuISY9UL3CO5NJSXBsgr0IWwvqH2dbozaR4cgeb4=;
 b=wC8Khp3ejRCZRMQCRdtTxI+8cVdpu+LwtGKFPiiDTIE3gAWnZWbZEKyF09ZVCZEC6oygsDtfCRZq+evYDkyWLz/eUlOSi1vmHA/Cumws5PLdFo7Q/eNkAVfArSonWAXTgE94ZpUlTpTUXyeXHzD+hLl29STtGPbm3pXwJ5vrolU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH8PR04MB8616.namprd04.prod.outlook.com (2603:10b6:510:25c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 08:40:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 08:40:46 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>, Vincent Fu
	<vincent.fu@samsung.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH v2 6/6] Doc: Make note of using bsrange with ':'
Thread-Topic: [PATCH v2 6/6] Doc: Make note of using bsrange with ':'
Thread-Index: AQHabgRH3eV/VXt1mUG2BYwOrTulVLEn+I8AgADc70A=
Date: Tue, 5 Mar 2024 08:40:46 +0000
Message-ID:
 <DM6PR04MB65751169BA7F9A9F999314D5FC222@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240304071851.982-1-avri.altman@wdc.com>
 <20240304071851.982-7-avri.altman@wdc.com>
 <307ea21d-464e-49d1-a03c-34c04dbe0c4f@gmail.com>
In-Reply-To: <307ea21d-464e-49d1-a03c-34c04dbe0c4f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH8PR04MB8616:EE_
x-ms-office365-filtering-correlation-id: 3420e299-d080-4b22-1f45-08dc3ceff405
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 WJYIMDczUxlRq5EuLlw5Dau0fr7WPw/YCIeuVK0PLb3+/V5gtAsrcynnZlq7b1tNv0iaMz99hRQIlNYPPn1SvEx6XxA67jpGoEijo9/d7/H1zX/y1gmpFFhUZhbZ1/XIY9iO1UvnNjD6WmYWCvt1boZrEpMremXlKf5qjhmNhnae5VD7t/NFLM+x52Dq82fNKRzcRROIu65l7hqpnw4e/tjxV/5h73dPo7YcM+t0pIquiiy7ZutPJyvu6cvPeDSwq3Y4tOiUGnhISHJ0u2hZ9JMozJypY3RHbPDVkVeyDK4U/nWCN1Wp1jYVQwtGsSQHvx8LXwUHShlavS9BxHbxe0sk+0auNUf4g3oxp7F4t8YnWD7wSisGpRlYn8xoW3UqK3r3efRXgWbEKa1EW9EHb8CmRF1RkQtsgcxrIIo/jmXgLJcFtqlFxGxIADCFWLXoBJgWDofgtTtn03BY7wTb6C4E1BuS6x1p+gvFuBrzgqCL0tkZhVzza3HAfbeV8Mfy1OuuOH2uyWRmjOzbPxLKZ8yUMZZI7yKof+y6TNXp57RQsZhp/jBvjR03Xmjagj+X9VBH8Pa37dPt+nwi6RIPAfyLUn72SlkiNc/VU54D16YFiQxxgsw1YoQIFdcrerPij1TvrP2mvH3SpQRmkrOw/wyJxzHXpp4OjggZGdPdU+06PMYMAhFSoI9GRwUdCYy1t4QiiftpgGBwUvQaeo67TA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2RqNWxUOEdDZTd6NFN1dlAzZ2F3eGNEQ2JNdHNMcnAwQVlQNGk5QlFNaWdN?=
 =?utf-8?B?OHI4cTJrS0owYTk2amNiWEgrVDhDOHdkOWFUNDJnUml3SFMzZGd4OTliL0FN?=
 =?utf-8?B?cGVBTlVDeWcyaTc0ME9hb21OZEZRaitlVUFwMkt3ZnpuQzZSMkdJSzg4dVMz?=
 =?utf-8?B?SEc1SFZWaW9qUU4vVEJGUkRpdFp6WHRvelRjOUFXMTRwb2xBYXBuZlZadGhm?=
 =?utf-8?B?RnAwcnExdVlRM3hQeTd5VjFBNDlaK0NkNXl0R3dVcTVsTlArVElGUUFSbXdT?=
 =?utf-8?B?TVBWUzJzUm1CdkZzL28rSUVjcEJjS1Zwc3RPODR3OTcyQ2wzcCtQT2l1U29E?=
 =?utf-8?B?NzdzdEMvc1JwMzVLdytlY3dpandkbEJmWkltNURJR3RCUE12Ny9qeXVJYjBu?=
 =?utf-8?B?eERQWXZDZHVBL0k2aVd2d05iSE53ZlpYMHJnRXRSdUlPb3RtRS9LbEpMaVF5?=
 =?utf-8?B?NmltcmRsdFpJMExCVU5MbjhISjF1Q3F0a1FJTGJpV2Nub1d4MWtnTUhLajNV?=
 =?utf-8?B?WXNTcjI3SU9QRmNBSjFGMDVEelNYUDcwTnR3aG1KWFl3ZG9TOUwyQXcrQ1lB?=
 =?utf-8?B?Nm1CR1lxWnI2Tm15Yk1pRVFMdHpFaFg0byt0ZlRBWXlTVVRxK0w1TEQwSHUv?=
 =?utf-8?B?RUZUakJhRVJGYktvZFZ2TGJyemtteVowaXFKeVVQaGxQbzArNjFWdlZDWlZF?=
 =?utf-8?B?cDB1QThDVzIxa3VMZHdTUm5tRWM0cDJicHp6bmEzNVd0WHdaU3lGZFp2L01o?=
 =?utf-8?B?Mnc5N0NkN3BGWnFvYW94ZDVaYWxvUFVTZTJXK3FhVzFENlh2ZUExUms1bExw?=
 =?utf-8?B?LzBXZGZwUFBVeFZQZG8rVHNvcTFTMml0VFZLRkd2KzErWXVxQ1ZDbTlBYW1S?=
 =?utf-8?B?cytTU3F4MUlCSytNL0Q1MEdnSTFWSUZic1g0M1JiTHZVS1FMNzhqUTd0Skw3?=
 =?utf-8?B?NjF1OTBvSk9NMVpqQUFmdjhzaHBJelJVRHFwait0MHdCRVFJSnJKRE5QeXpw?=
 =?utf-8?B?R2d5d3hYanVyUkxBVWVrQ0lTbTdwNm9obW83T3dyeE82NWRoV3EyenhMRGU2?=
 =?utf-8?B?RmYzRnFrT2p0U05IMjhOUktBZ0JzLzMrYzhkbUhHVEVaYWRCUGFTN1lKVE9s?=
 =?utf-8?B?TXoyMVlKbjA5RjJlaE81VGdYcVcxL1ZmaU1NK2E0aHVRRFVxQmhxUUxCQTBZ?=
 =?utf-8?B?WVgrSWNXTjhjNjArT2NLdGZaYXhKcW9MSnhWa2lLa3JRM1RSMXZzOE1BS0Vo?=
 =?utf-8?B?UjFNWGNlNEVIZ3dKZUVsck5EeXc1MWJFdlc3d3VNdS9CcTRzVTFiK3FlN2Fy?=
 =?utf-8?B?YXUrbzdGMDMxR2xxQXlIbWJHVWl3UmlhQnpMeDh1NXQwMjZiT3k3YnFUVWwy?=
 =?utf-8?B?aEtTd0JjdlVoc00zYVBrRmhkM25hYW80bWxoYW5LSHlzc3BBTThaUlBacElF?=
 =?utf-8?B?eWJQeDZRUXZvY1hBRHI1cU1pd3Z2bmhKU3hXWnBoUjl2UVJOeXYrZEo3bVZa?=
 =?utf-8?B?eitlS05RK0dEbXdSZmtrcGRYU3JFdkZ0dUNHQWJkUmpMZjl5dDJFZDB1NjlB?=
 =?utf-8?B?ek1VU0czeFdBUFBxV25hM0NHbGRKWkNaRkZVWjFSc0Qxb2lFV0NhRGVXV0Ev?=
 =?utf-8?B?SEZEYWZMbUIxQVRDM1FaYnU5SEdSSTZwbEoxaEI3ZGFIZnE2YXFiZ29Gb1Jk?=
 =?utf-8?B?Q1Z2ZnBxNS82Q09GRm1GdWVreUIrQzFjakp5V3l4OHBLSXcxb0kwS0FrYm9w?=
 =?utf-8?B?bDZ6UDJvQUVQSFJoVU50b1Z1K0R6TStuZU45QjhhdnVwaGdGOG1HU055OXNJ?=
 =?utf-8?B?MmZxY0RzaDZiUVlwSkpoK0V5TkxnZkNERXdtcnNDVWpZaHRCWER5VHVvelVY?=
 =?utf-8?B?WjhYM05iaURkMXhPUURnTVhyWWRlUjlzLzAzN0tXR1FYM0JOSjBQV0Nqd1J3?=
 =?utf-8?B?dDlFaUpKOWVWNG9HT3ZFcmM4MitYclpLSjVsY0hiVkNWWUdLc1F5WFRVYlhL?=
 =?utf-8?B?aE5VMmdUQ091bmc4WG9FWlFOQTdlR2I2c211TENHdDZlQ3c1VnRkMzRPSmo2?=
 =?utf-8?B?bkMrQysyaGdXeFFBWENMS1RwRk1oc1AzcW1xWk93YUlSRmJXZ0xiUCtoMkFj?=
 =?utf-8?Q?nIiGAkhFKppLdDkavW/JjPA6n?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ctma2NHpk6LCmPgWJcmyZUt/mDkEE5KLf4fZwnPU/n+kVQV0Z7lG/jryyc1vcsXVWcQnV4+vQf0oNJ3gz8J4aGXj9DYO1PVZf0NjepZslxaB3CohYfAGf0rdtJC01nXkpxb0ijHuM//SDSnh4w3tSf0YmdDJ3ZGbe7VXxOnPbSbz4vbaUdiv9xYA0C3XesmxF/T9a+VPCDtZ9mTz/uULkrZ4j3EzrmVN0sn/s/lRM6xjPRmXHK+81koiz+NlDXpZxX7J8WI8ILItpU09HmK4jjdewvPPg3t/62Ay54aoe0o+s/Z7gMk2kz9Nsu4UTo0aolOonn5CanHJe2I7VWAOOQEQDIj+otvRC+lESVtkSa6WOkaKiYi0OfD1zryhUIJ7hM411utUvL7kidAQX/RH1y4lnucjIdxlWUn46QEzlV9vmSp4MUGCInaOINFtFN0b8yN4YUbQuxCWuPUddYstzFx7+1Ofa0+WFQA0Na0Y41djLFsNU25sB3eH9jQoWzl+8I3/xlrYvJjcBNWFVwczKriUj4rSOSE0h2PSCqYo+Y3ZA5io1J/A0fNycWfsVDx3XZGSHep1sdgRzpMHIb6mWWRSkTygQ4ydQW/S+GyjD/kluCorJGEaRiujshpUgHvP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3420e299-d080-4b22-1f45-08dc3ceff405
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 08:40:46.8500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +UGGptx09sUVGxWpVIz/hA1quh5RgKFhp8dFyorDKbbbDaGXyDaVOUI6feBPHO5o8zXg8KMrm4xeIgShqODkyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8616

IA0KPiBPbiAzLzQvMjQgMDI6MTgsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IFdoaWNoIGlzIGFs
c28gYSBzdXBwb3J0ZWQgZm9ybSBvZiBkZWxpbWl0ZXIuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gPiAtLS0NCj4gPiAgIEhPV1RP
LnJzdCB8IDIgKy0NCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0hPV1RPLnJzdCBiL0hPV1RPLnJzdA0KPiA+
IGluZGV4IGM0MDRkNzI0Li4yMzg2ZDgwNiAxMDA2NDQNCj4gPiAtLS0gYS9IT1dUTy5yc3QNCj4g
PiArKysgYi9IT1dUTy5yc3QNCj4gPiBAQCAtMTYzMSw3ICsxNjMxLDcgQEAgQmxvY2sgc2l6ZQ0K
PiA+ICAgICAgIENvbW1hLXNlcGFyYXRlZCByYW5nZXMgbWF5IGJlIHNwZWNpZmllZCBmb3IgcmVh
ZHMsIHdyaXRlcywgYW5kIHRyaW1zIGFzDQo+ID4gICAgICAgZGVzY3JpYmVkIGluIDpvcHRpb246
YGJsb2Nrc2l6ZWAuDQo+ID4NCj4gPiAtICAgICBFeGFtcGxlOiBgYGJzcmFuZ2U9MWstNGssMmst
OGtgYC4NCj4gPiArICAgICBFeGFtcGxlOiBgYGJzcmFuZ2U9MWstNGssMmstOGtgYCBhbHNvIHRo
ZSAnOicgZGVsaW1pdGVyDQo+IGBgYnNyYW5nZT0xazo0aywyazo4a2BgLg0KPiA+DQo+ID4gICAu
LiBvcHRpb246OiBic3NwbGl0PXN0clssc3RyXVssc3RyXQ0KPiA+DQo+IA0KPiBQbGVhc2UgbWFr
ZSB0aGUgc2FtZSBjaGFuZ2UgaW4gZmlvLjENCldpbGwgYWRkLg0KDQpUaGFua3MsDQpBdnJpDQo=
