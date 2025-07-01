Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2033.outbound.protection.outlook.com [40.92.19.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3E27604B
	for <fio@vger.kernel.org>; Tue,  1 Jul 2025 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.19.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751382699; cv=fail; b=UN/GnoCn5QHiOtws60YJdgFYG/vxHeJrjvEXrZPvMxzN/6X7iGv6OwYWj9r+VuXmfuFXDnbZquuJbQ0digjpzTePb9YCdm7aQbbGWGxfAGexHfoU3U/vEbG4qRNfhaldBEXfrKvTUz1xVbldG3Hw8m7CSSK3QsKyOmXjUq7D2O4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751382699; c=relaxed/simple;
	bh=+KBSluCnIRRV6ebHHlxBjUaWSZ+fX+lBjl9goy3AHZI=;
	h=From:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eWXBgLfqnBZ1dzrjAItVyMJrBarb/kqCEXaiGCKPuLFWrtncxSTruLIlK7DP0CGeNOAVEEUofdiigqvofh896B0uiOHvm9RlBsJtnyneHRP4At19EzUPUoXSIX6SpqSygbYAytdaZNwCCd2ME7bTUsSXOYALzM0ch9ISHji9670=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=QBlE2Fgm; arc=fail smtp.client-ip=40.92.19.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="QBlE2Fgm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+LnNacOySEqJGs0gyn+7Hsxz+8V30ypBQtIPJ/XrvFV82Ml2P231i9KCkfOwYnPlyi3O+3s+GWSlhbRhbk6GhiXh9XlfGWpGOu/3WSRMUSurHLm/P9xnUWW63PUbM0myaky+rqjT5BJQG2GDdv1VWGWcflGR8XIraYVbF+a2kxMijheoCJtfDuP7uI3KWb+dDOA52iw3TIsoqO4nlWCMSr/bWNKhy9SsuLZU75GadGY7UHuAik95sutUVabRpus+yszueqL1iITGXhvtXY45l6uZxFbIGcsqS/CcYCNmqBICTv5duQ6UfawZaR/4Uth9H+bmrd1Q+RQgjNqxLW6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KBSluCnIRRV6ebHHlxBjUaWSZ+fX+lBjl9goy3AHZI=;
 b=d3DsnWMrdklcP0w8WoCfLXyqea5LtrxbyLatuLZzOrcv6nsjBnHqtNO3KxoN2d6CRCnFI/EWYUS7GA7H8cpK0L+ekIvWTKgHShtLlsYzWA/o4vN0Iq69y49D05wAnukberpBEOvByeg8yZaBTc2lDKerZkghx8koB870TqZQ8TNUQlOT9ccrpkT+4SoJa65/ndkL30nIy+S2iw2qwGbHm611tR0hLUVfEznbQ8ammx2cdy1AxPmd0NmA8+bW0BQ6RGx4xHhdhQ8YkIo/Lr2XSyknYeqqJnHr72k+Ni1gpEU8j9dvaSZM2e9C4/yR7lkJ0BBbrA470foyKm38lZIEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KBSluCnIRRV6ebHHlxBjUaWSZ+fX+lBjl9goy3AHZI=;
 b=QBlE2Fgmkc5l3H6r8Zy0mFv/DAuMmRF+2dis+f/XhHrBRlk65jc7O00cwTJ1MbMDpYjrQLDGFJFWb0Ds2l83NBN9B/VnUlzLvETOtQ6FWN2RovgJpkv0udotqcHkeQFc4Z6U3XNkH1w85VfHR5kktdXNrW7DCcpl+AyE4y72cdhO9LpztzRrInJpIacBpJJynkayUXhrnh0KE4zLDbZxPENTWewI3EUCqLiYXykBdLEJKBw5dR9Bdj/LfcVDvyvEH0OHqSY+7HvJSUHFsoa6HwrioAzUTMMvGmEdfv8p69PCaY97UQo/zic8zSWjGwz6WgG2HiWj0yF5vM9FnN+xbA==
Received: from PH7PR14MB7419.namprd14.prod.outlook.com (2603:10b6:510:1b2::7)
 by PH7PR14MB5715.namprd14.prod.outlook.com (2603:10b6:510:211::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.31; Tue, 1 Jul
 2025 15:11:34 +0000
Received: from PH7PR14MB7419.namprd14.prod.outlook.com
 ([fe80::c687:6296:79f7:696f]) by PH7PR14MB7419.namprd14.prod.outlook.com
 ([fe80::c687:6296:79f7:696f%6]) with mapi id 15.20.8857.026; Tue, 1 Jul 2025
 15:11:33 +0000
From: Adam Horshack <horshack@live.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>
Subject: Re: blog post on fio's verify feature
Thread-Topic: blog post on fio's verify feature
Thread-Index: AQHb6fcT6g3R2vD7M0Oqn7gi5r7oabQdYO1l
Date: Tue, 1 Jul 2025 15:11:33 +0000
Message-ID:
 <PH7PR14MB74191EB7ED456E1719B80B75A441A@PH7PR14MB7419.namprd14.prod.outlook.com>
References: <e17fc881-c699-4d72-8824-0eceb69a7d3a@gmail.com>
In-Reply-To: <e17fc881-c699-4d72-8824-0eceb69a7d3a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR14MB7419:EE_|PH7PR14MB5715:EE_
x-ms-office365-filtering-correlation-id: 76214fe0-94ea-4d3c-8865-08ddb8b190c0
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799009|7092599006|8060799009|8062599006|19110799006|21061999006|461199028|102099032|39105399003|40105399003|440099028|3412199025|51005399003;
x-microsoft-antispam-message-info:
 =?utf-8?B?emNDTmRQUURieWRRZytBZ0I2Wnd1NEtrWWhLQlFyR0NCYTBObVdkcU8yUjc3?=
 =?utf-8?B?VjZGTmt5UFlQWldZVElabm5sNE9PRnVSZ21ycEdxQ2UxVXN5bmF2MHNPaDFi?=
 =?utf-8?B?MmtmeUY2dTk4b3Q0Nm9mZEVBalRYTDROUlRPc2V2OHRDTFZFZHljNjdLaUVQ?=
 =?utf-8?B?R3NEU3Nlbm5UV0xEUG5kMG9RTnZ6eEExWkEyeW5YRUFmc0xGZUlXRzYyN2hm?=
 =?utf-8?B?ejR6Sk03MmFnQk80RmJHUDZZTXBZdUkwRmdDRTE3T0gvS09iWHVxeTlOaHdu?=
 =?utf-8?B?dHdzMlkwOEdLRWt0UkFCYjQyemV6eEJ2d0ZNcERJS1RSTFR5OWZzRkpidld5?=
 =?utf-8?B?aXVmU25jYmZ0cnc5ZDBNc3RzNWZkUEJZMjhxVlpxL0VYUUQrMDJ5YW1kMm1h?=
 =?utf-8?B?WU1iRXE1OW00TFRiYjJ4WFErdHF4Y1F3aG8xS0Z0NDRscFZvdXN6dUFGL2Rm?=
 =?utf-8?B?VUdDRk5MelZubTVZRVFOeE5KNnRDUno1eWFQWTZaSUQzRjlFNnhLS3VQY3pp?=
 =?utf-8?B?TlBSMjdBd21ESmswUXZ4SUZGNnFzN3EvSE1CSUgzM3drcDhDNEdkMXQyT09h?=
 =?utf-8?B?UVJId1lqN09ZWFJ1UXcvV0E3eDdiaTZxMm1pRGc0aWpzSlMraUJGdzU4WjRK?=
 =?utf-8?B?SHBzWDhueTJuSXFhck4rTU13Y3JpUkhmaDJHdXVCaHdPdG9lWGx4Nzl6NG0x?=
 =?utf-8?B?QklEQ3RoL2t5QVd0bDg2TG1yOXFXblZVdzRWa0FReGk2dkZ2dnpSNDhSZCtV?=
 =?utf-8?B?VHFuMGFIYy8xK0lSNUxHUzRta1dYMzV3ak1hODM5cWdjY3lVNENVSmwyVFJT?=
 =?utf-8?B?Smg2VUxPUndEeUI0MHFzQklLbXA1S2t2ZDU4ajBHYS9hV0w5RVFjUG1Bdkdq?=
 =?utf-8?B?RTc2ZHF5UGhwRldFTEtXYlFvWnlsRG9XM2VBMnhDbHdUdXh2THdmNnlqSmd0?=
 =?utf-8?B?N1JESzZ4b0FhWDhTNEprRTR2VEd0ZFZsamFNc0pyamtMWFo1ZmtBWE44OGta?=
 =?utf-8?B?TnNGeFR6cnNJdmN5V1hRWXFhM1djWG1WVElhVzEzK05Bb3pET25qSEdJS1dS?=
 =?utf-8?B?Q0hiY3dCcmFpTCtnZGUxYVpJYmpoMExPV0dwa1dPV3ZYMWhUbXNPc01wUEhI?=
 =?utf-8?B?azRjeTNjY2t4UFJ3bDJzQ3E0TGxsNENuNVlNWGhqVG9YdHh3N1pnMWo0S0x3?=
 =?utf-8?B?WktiNjc3a0xzczFMV2Z0ZVYvTlpLQ3U1a25XM1k3SEVoTGpQeWYvaFppcnRP?=
 =?utf-8?B?Mi9kN0FEZzhmeGthd2VuU2x0a3NvcEEwN293SlRXU1RyVlNQM3FaUWJhL3Q3?=
 =?utf-8?B?TTlodC9sQzlVUUtJTWN0eWZ6Zk05cG84RDVzL0loVkNlaVNVbjhQYURrZGMx?=
 =?utf-8?B?cDNXK3ZxaFNaUWV5a0plaWN4SnF4SldKMkVzWFoyZnRwVG5Rb08wdTdYdEw4?=
 =?utf-8?B?cENkVWJrVHNmcUt1VEdqM00zUGtINXdFd2RqdmlZV2VuSkwzRVpGZmZvSzB2?=
 =?utf-8?B?LytiTlZlV0p6YnFSbE53RHd4ZlRkam9wUnV6WHlXc3ZiNnV5UTRSbDZ0dVFH?=
 =?utf-8?B?TGFVejBqN2ZLRGt4OVl1dXlLOFA3R3oya1g1ZFJsSFJkdUxoRi85NC8rdnU4?=
 =?utf-8?Q?Xaq3KF0+nSbOIEUBydRRy29ECscpK1ij9IJkMEaKqf7k=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L1JtYzRhdG5RMC90R1ZsMHJENVdoY3kvMFlDcEd4Tm9wQW95V3Jjam5OV2JC?=
 =?utf-8?B?L3luTkpzYW9ReFdEVlJjR1BwdC9rUVRFSUpCV3BicTFTd1dQUVRrMXhrcjVR?=
 =?utf-8?B?T0JZcHVxaUYyakk2d0xzZkRVWFAzeWVZc2VTUEg5S0syWjR6dis3UWQ0MFRq?=
 =?utf-8?B?MHdtWm1XSm94NGdtQWZiS0lGcHFwWUxlbEY5OWlITHBhdG56Q0VBUU1sY3M2?=
 =?utf-8?B?dm9tMnZqZWZrZlIzRkZMNnptMVdnSWdPbDg5QmFXTGt5R0I5VVplS3VtRWtJ?=
 =?utf-8?B?ejI0bUV2aWJPaEN0VzFKNHI5b3dObWc0NEhudVpWUThtNHprYjF0Y08zM2dn?=
 =?utf-8?B?YjdhRytKdjQ1dDFQVCtHUE1YNVlvd0w5dnVQNEhzK3pVSXVERXgyNXdDdVo2?=
 =?utf-8?B?TWtIOTFrdFNGY0RsS2UxbE0va3dCLysvQXdNK3JUQW9SSTJzNGhLQkhZTDZh?=
 =?utf-8?B?SXFsV0xTZzdkZlRaSktnOFlSa21OQ0JtR1hEVUNiNHRzRmJnMzlNTjVudnhi?=
 =?utf-8?B?clN6cmM1Tk82ZHQ3YmFFNkhCaXRmcG9tOWRjOUdaaUVIaU54ZVM0clBHZVZ1?=
 =?utf-8?B?WXZyRXl2Nkd1Uk9PMS92SnFQWHpyM3lKczFUMERHWWRxSllZSjdUZDZUS1VO?=
 =?utf-8?B?YVg1WUQwRnRhdGVodG01UTNIdGNyM2owcE1rVUJtNWcyMDYyeUY4NENza1hy?=
 =?utf-8?B?WVF4RHBwaDNrS3Q5cEc3aWlxRVhxbDlYd0MzeHYxdHZzY3RMVExqQzFLM251?=
 =?utf-8?B?MTllRFJHWis4SzMxWDhKcWJ0UjZ2L1ZuSVcrakxzNURYak1uZTI3R20xSkRz?=
 =?utf-8?B?QkdJUUJ3ZWZvY1ZVOFVoWGU3aFJDaUJqdExlY0dka1VVZ05qdEdkak0zc0R3?=
 =?utf-8?B?bWN3ZkdraGtvL0ZGVDNJN3lQaGowZUw0TlpkZElwak05SGc2UGdLMXV1REov?=
 =?utf-8?B?c0lKbnA2RUtFeEh5RTlhNmJWNEkyNk05WGY1NnRMUGNIK2lFaVozbVFsQ3Bp?=
 =?utf-8?B?b2NuVit0SzJDbXpwa2hxNUNIL2hYUmxCaTJaempLQXlRQW4zZGk1bUYzb1pi?=
 =?utf-8?B?enZRWWxZbzVUSHpEWE4vM0lQVE5DMnorYkRaTmowT2VhUkFQSzltVFY4V1h3?=
 =?utf-8?B?RTdRM1lBcXRPbm1xeWd2MHNZYytTRXo5eEsvay9zYlJmTmJkNnVhZnZmdVR6?=
 =?utf-8?B?blVHQmwzREtneUU2MG5yOUpZbmwyOTlnMWtEc3BHWWlFcFdFYjlYYnN4VURF?=
 =?utf-8?B?bGN0R25PT2VjWUxqWmo5bFFZYnlNWnFMdEY0RmRlQitsZEZySExSTDF0bXNI?=
 =?utf-8?B?WEw4enlEM2pzT0FDbHJERVdmWDhoODZMM1BiOVZQS1d2UjVsRXd2RVlUbG1t?=
 =?utf-8?B?dzdxb1o5aEZyK3lPVit6ZFhTdGVxRFlqZ3Q0aU8zUnhWVTVKSUZla1UyNTc3?=
 =?utf-8?B?aG45SUFZdWdpYnF6a1BRcVNlWFpOSEtSVHU5SE5Cb2Z3SEljeEl1YjVPaENP?=
 =?utf-8?B?TzNscFdvcDlTeWpJbHlnK0tOQmlMeXd6UzlUTmJldGFkOXIyc0V5YjBsQWxI?=
 =?utf-8?B?UXIrZnNKOXpzamVYNlkyL3hoVlNWM1pTbDYyUk1iQmd3bCtsRVFKMUllTWRp?=
 =?utf-8?Q?x0Oy970dOrgrpuu2kuJD5xiDDJvbqFaLKvxO2NA1p8I8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-8534-20-msonline-outlook-5fc7e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR14MB7419.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 76214fe0-94ea-4d3c-8865-08ddb8b190c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 15:11:33.3264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR14MB5715

RXhjZWxsZW50IHdvcmsgb24gdGhlIHZlcmlmeSBibG9nIHBvc3QgVmluY2VudCENCg0KUmVnYXJk
cywNCg0KQWRhbQ0KDQo+IE9uIEp1biAzMCwgMjAyNSwgYXQgMzo0MuKAr1BNLCBWaW5jZW50IEZ1
IDx2aW5jZW50ZnVAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IFZpbmNlbnQNCg==
