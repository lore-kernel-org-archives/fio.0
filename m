Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB261BD9C7
	for <fio@vger.kernel.org>; Fri, 28 Feb 2025 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740721465; cv=fail; b=oOHqyvGswEnhds2ObGG524ltlzGmUlEEKv7XObrRwYWCHEOxC/s77vNA5hn1di8ajqA5fjghQ540DifKlrrwq6E/BguCDm9iA5ZprGOG/REFPMPweGjzlZPUHRZficRguIP6hlcx4lbXqBG8otsOhaWfoHYilhhAA9ceXgpY7Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740721465; c=relaxed/simple;
	bh=xjTnV0661O0C++umF7mwzX+vY/yNHO2fLqWMDqnCIuk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H9wp8G8o/69XvycMjz+QEaVeX0Nmo/r4fetqyTR/f8bQ2Wa5P2PrVgCyfO0+vuU0cZMJDCWWjEhTpAIevtwzTfiov9y6mbnk0/xG9knig+HXpwLLO9CV1puylQOZ9DFlmRCtyS6sO7ZYZvTLIx55JH2j526q7z6q9oUJ0G67NH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=PpmLg8+L; arc=fail smtp.client-ip=40.107.102.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="PpmLg8+L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N0fAuiCW4fwzDa5tbIuS9NHbWBMxgrBKHB0CzrGIBRuHta7sRBqRC8eiWmPP+fuB4CKu9ThvnZFa8XsMfOyT/BuZmptM8SjCGpltUwH/fDSAaiKKULPd8t5W/EkTl4viQUX8iCcHE40PpVLoKJNpn3NNtoyrpERH6F1EbOPM45TfHB3moEepoqEASAcMiWDu15wJTx8BYGKiQb5Yqbi21O5I1CJzGZ9cf4ztDuimXi2TILcuMx84lYgFvfFkyJTUr3d/uV2wi5eFhuCD5sgZMB6WvARNjawNJSZDYFeC6rH4zw8HLgMD1dq5VnljQrqiq12F9550+Op4XunlAFWlrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjTnV0661O0C++umF7mwzX+vY/yNHO2fLqWMDqnCIuk=;
 b=DR3F5S9ptXAN23DSdrngrvBXzWITJSdqvspQ0qJ3PF4g6Gxj0keVcNHqddyqhuwcfgHQaWZNgUOvmIK2pQntdtukcPUJmDD9hscTitF+TCnqlyhDaAKiOWpetVuSXC6lDTnqrEgQHzo57ijgbX176pm7agq253/+ma9SNTTRn0UAvgK8+SSR3VN8Qh0NKHat1S0U4mfbHcOhhMerZ2Xj838+gTnNcMtiHW7zAxprz2eCFgi7iREs9FuFJ8NS+IWluwFhU6eGipoZG/kJ2S4b+QTKBUTNkUzOwZufDc/SFK+v5njDzZp1m4Wja/a2o0BJ6ifOCzNRtB3XB8g95FP90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjTnV0661O0C++umF7mwzX+vY/yNHO2fLqWMDqnCIuk=;
 b=PpmLg8+LYJd4w2hmOSjHXoZ2q5o0JKP1ZYY1xha7VtrL5MV+oHLQtXG3movt0Eg3Ko3vlkFB61Aur7Ixe0Xg3TrCiOGQ36jBPAvYFr7frSTBoMm9FXG4wLh7Va3B0slSLCkgDHpNXhkzUkJb+kCO2ArikbwceFZUWnqH7fJypHlnAEbPfmVgUxtXotahlxdmtX20vyAfliTMhmcfQvVT8YiiMydm2muDbQdaRK1lJT4X+xJbVpG4I9dvJ9YZ8+p8bL3lmh3l7qnt1/YOfF1l+N9rNU/ETzOaIPa24o6wyzRprFIhK65DeTJxmoL3c0+HJpLpcYtIoZUJbz2UuQLpGw==
Received: from BY3PR08MB7026.namprd08.prod.outlook.com (2603:10b6:a03:36b::18)
 by CH4PR08MB10439.namprd08.prod.outlook.com (2603:10b6:610:244::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 05:44:19 +0000
Received: from BY3PR08MB7026.namprd08.prod.outlook.com
 ([fe80::c003:4a45:deb6:d050]) by BY3PR08MB7026.namprd08.prod.outlook.com
 ([fe80::c003:4a45:deb6:d050%4]) with mapi id 15.20.8489.019; Fri, 28 Feb 2025
 05:44:18 +0000
From: Jay Han <jayhan@micron.com>
To: Karim Manaouil <kmanaouil.dev@gmail.com>, "fio@vger.kernel.org"
	<fio@vger.kernel.org>
Subject: RE: [EXT] A question about fio flows
Thread-Topic: [EXT] A question about fio flows
Thread-Index: AQHbiQrWc/WFJTCfCUuFjVwJEbx1TLNcM3AA
Date: Fri, 28 Feb 2025 05:44:18 +0000
Message-ID:
 <BY3PR08MB70269DC5CFDCCBE9C99B3993B4CC2@BY3PR08MB7026.namprd08.prod.outlook.com>
References: <20250227112905.egy7rsoa3bhw44xk@ed.ac.uk>
In-Reply-To: <20250227112905.egy7rsoa3bhw44xk@ed.ac.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_ActionId=123f33e7-d9e0-4d67-99b1-c96f61a405e3;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_ContentBits=0;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Enabled=true;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Method=Standard;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Name=Confidential;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_SetDate=2025-02-28T05:36:48Z;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR08MB7026:EE_|CH4PR08MB10439:EE_
x-ms-office365-filtering-correlation-id: e011052b-b464-4e0a-7dad-08dd57baf1d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-7?B?S2FRNGw1NEVXUS92SHlqZHowSENwSDh3LzcxM3pheEVXTWlNcGkvZHU3VGVC?=
 =?utf-7?B?V2lhNXAvNTFaUlI5S3RCODJ2QWp1eWNyRFRHQTVSckhVeUNTd0pSOUhIMGd4?=
 =?utf-7?B?bjYxUWxXKy1GaW94T1lNKy1WbjJtejV0cFplbG9iek9BYjVxWistUUlXcTh3?=
 =?utf-7?B?ZGl4UlZrdU5kMGlBdWpNb0ZwMFlqZm14aHRiNGRBQlRrOWkydEwzM2gxZ3R3?=
 =?utf-7?B?NGUyTmd3YXYrLUc2TTNoQ0tXU2VRVkk1WmVQbXlHRXUzMmVYbnBRR0hiTnRZ?=
 =?utf-7?B?RmNDTnptd2hFVWFNOVpRMTR5aTFLU1AwcUJZRE9kQXBPY2wvWnQwZUhoaVdu?=
 =?utf-7?B?eU5yN0I4NlQwY3pWaEx1L3RIa2dRMEljekorLWlzdnFRRVpaZjQzcEc1dyst?=
 =?utf-7?B?R0hMM2d5ZHVqVUFGaE9QcmRSZkZMT09ENzlncW1ISDhRS0lpOXFqT1gvUDlu?=
 =?utf-7?B?RC82QmszdjRhNmFKYlFsNno5Skd6Nk5lQWUxRWJKVzNsZlQydXFQR3hqWWhZ?=
 =?utf-7?B?MGk5ZkhBR1REeCstQWNxQTJlS21vTFhqdDZCT1FBbkhxbEtVbXl0NWo4WEZZ?=
 =?utf-7?B?SFkxWVhwUHloZUNuMkY5SlpNV3BYeFB4YVBaamQ1ZzQwU29Ock15ak1NRkZ4?=
 =?utf-7?B?YkY0NzRlUmhNOU54dVNxMjlHVEc4WUpUdjF5NjkzVzVHbmhDakh4R1dVZUww?=
 =?utf-7?B?RG9VMml6RldFRnZpaWFCN3h4Sk9ZOENudDJTMG5VMGZaTkFoUGd6Zkd3YThJ?=
 =?utf-7?B?Z256Q3NWU1ZTeTVUUm1IUTRNb1FQRzd6Y2Z4TEg5UWhiRVg0cVRXd2JYeE0w?=
 =?utf-7?B?TFRTc21zelNoVmVxb1NZSjRzWkgrLXNVcWN2dGI5VVlVRHluZE9RMUpRb2g=?=
 =?utf-7?B?MystbXV2a3dVQ1V2Wnc2eUlTZ2JLNVowdGJOZ25Wb3NFcHc3U1pJS09ET0JC?=
 =?utf-7?B?b3N3OG9yQzN4WmhKKy1XUjM3Q3dDMjZ2Qi9VOENrV2p4bjlFVnFGMCsteWFz?=
 =?utf-7?B?REtWQ29ZaklYUnE3aXdZbVNDd3p0dFRLYSsteG5WRUlJd0ZZSTNnRENRUk91?=
 =?utf-7?B?aEVFWUJjaU1CZXRvVGVFc3NxNkdmNnIvNkRiOTlSYjE5ZFJBbWVWdkxSVGQx?=
 =?utf-7?B?T0dubk1DVzRTUGNGWlVjUFhobmtwREpSVDV5eDY5SUdFTTZnNEtBcCstKy1t?=
 =?utf-7?B?eWpjM2hkMzVQL1NwWVhLS1owOXVWUmw0NjEvcjRycTh4TkcveEJNak5MWmpx?=
 =?utf-7?B?OWVKV1lTejZYRmlwT2N6dXlia3FKN0VwSkdReTVNR0pjZG0xL3BjS3RlWUth?=
 =?utf-7?B?dEduT1hQeVlJT0NrZUcxcnNmRW1MOFUxSjRGOFRYU1Q5Z1RJcVlpMHF6SVJR?=
 =?utf-7?B?Q0dCa2paeGdHcVdHci9XcVJGYzh2elErLThtVlViVnhSY0hscXBJVlBIZGhQ?=
 =?utf-7?B?bnF3MXZSKy1HNmlQL01jRlJvWTlLVXpHaFBZaXhqb0ltZ3hGaTRLMVZFNU9m?=
 =?utf-7?B?VEx2Q1oxeG1xN0U0OVptMWJhKy13UWU2R2s4VnZUd1EyZDZXVTFHNWRLNU5M?=
 =?utf-7?B?cmhyQ3VOM1NlZHdQYm81ckROVnJIOGpoMEhJNG1kQnprd1lnNHJnbkVRNTJN?=
 =?utf-7?B?ejU3d3dneEFWZnNRVHB1WVorLUFPTDNuR3BnQW5scFFwTGV0ci9xQ0Q0V3Vj?=
 =?utf-7?B?VGIwVHpCeHNPSistNUVUOS9abzNTOVFqSkF5M3R1bDhMSGZsNVB6VFh0Q1M3?=
 =?utf-7?B?dHVXcGRBWGt3cmxxcFNpZ1BNdHhFc3kzWGlCKy03TnRSQmNmQmF5NGFiY1kz?=
 =?utf-7?B?NTJuYjIvYThoeE1QOEQ2ZDR4VDI1cTRncmpvRistQXVnY05PYkFqRHpiVkVJ?=
 =?utf-7?B?L2VLeTIxSSstR09sa2tSTU5WeEZVeW9lQ0tUMHFBb0ZkZVlySDlNWlZBdmJI?=
 =?utf-7?B?Y0FOTTkyb2tZZVEzYmxKSTNFWjRYMWVsRG5PTWNzRThkRGt1TystakdHS1c3?=
 =?utf-7?B?aExCaUFreFRPTXA=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR08MB7026.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?dVdmOWttRmNpOXozbVNQbSstb1Y4amgwKy0xWDB0T1YzNTVheW1YVC9kcEZE?=
 =?utf-7?B?SUc1aTBvVlRkRTdleGhWSTF0eWNCVndySTROUjV6TjlkMG40Q1pIMi8yRzhs?=
 =?utf-7?B?c0ZYYjluTUVwQmthODFKQXBiallFNDYzU1EyR00vOVU0VzBLcmxKZkVmVHhF?=
 =?utf-7?B?eWdQNDBLNVQ0WjF0Y1dldlJScGFxejdoVDE0eHZRUlFLZnJRUG1GVFp3WW5Z?=
 =?utf-7?B?OWlLcUVYTkRhYjNnVmtPV2hqaG9wa1FuVlJycmxERVpUSWd0ZGdyNHdabFps?=
 =?utf-7?B?VlUveWFiUGxsbU1zWlA2eWQ2QThJeistOC9NanhYdE5rYkloODZEajcxTXQ0?=
 =?utf-7?B?WmNadzZ0aklQTXVoS2NEMElHUkZ5Zk5hYWc5RHdlSHNiMXVzb1U1cDVxWEI0?=
 =?utf-7?B?czM2d2dWdHpyeFNPQmVMcUxpRC81a3VNTjJhMFd4cmMxL2VjNHo2YnB0NHV0?=
 =?utf-7?B?U2ZXSVREOVZGY3ZZS1NCM0RzbGhWbm0xTzZzL1R6a2xRSjFtKy1ZMGdXRGto?=
 =?utf-7?B?WEZUZXhDejMwSVRQaistSndIYngwSVhqS0p2bW9KM3RlMzFaOFRNLzNTMVF4?=
 =?utf-7?B?WWRPUG8rLWVWejJPTFRRbDB0RnVPa2l6dTFtcTZyYmo0R1oxWXlOWkxhOVVW?=
 =?utf-7?B?TzZGWUg5b09aNjRtbkl0ZEtGaDVNQ0YrLS9rV0daS0hselpvN0NvZWpNYW1R?=
 =?utf-7?B?d0k4dHhCeEhuTXdsSzJua01sbWNqRlVhQmJGalh1QXVzTENmRHBsaWVLV1J5?=
 =?utf-7?B?QkNtY3pCZmVNQ0VUaEkrLWRkYUUxUkJpNkdMUmhwUTlPaHU0Z2pWTDBoSDNF?=
 =?utf-7?B?dGxLRFVqbER0WWJSVE9GZzZ0eG1JY2FsTkZMMS9nd0R5Ky1CcFAwM2wrLXFD?=
 =?utf-7?B?ZmJnSVZ6UmhrZlE0NVIxUXZzYjE1Sms4ckltRjRaQ2w3cG92aWY0elBTeFpp?=
 =?utf-7?B?TGo2MDJiaFkrLXltRGdGbjlLS1FuUTB2WWNtZVEza1NJM00zTWlqQjdKeHdt?=
 =?utf-7?B?MGlmWVhqT3Jsbk5EWWdDRjFxcDN5SDNrbk5icnpISWd6dHBzUkhIdnlUWERw?=
 =?utf-7?B?VE9sS3k1ZlNldnZYMEhuYjBtVHQvamtxaGJKKy02VCstM1k2U0lxUWh2MXBu?=
 =?utf-7?B?eEZWWDMxV29SS1pLT2hZUi9qWjRQbjRlaFloOWtkUG90R2JkN1hVQzdhUmRp?=
 =?utf-7?B?RklDcHVXS2lVcXc2Z3VDUnBOQjZnRTRJam9KMnRlTndWdExJMldOd0NDKy1Y?=
 =?utf-7?B?WGpEMWtpNHJJczNYbmRGU2Z2QzZTa3l4ckpoSFYyd3RUNmxtN01MT0l0Q3hJ?=
 =?utf-7?B?UUtRalVwdzFiZ3A5czFhbW5kOTRIYkZoUGpqelo3bEZmUHMrLXpRTnhwZS8v?=
 =?utf-7?B?ZWpiQWlIUkxpYWZLNVpiVnpUaEYvd0luVEVMUGYvMjFXR2l5S3BzYUljNElT?=
 =?utf-7?B?R3BpUi9wdUh3S3JYKy1XUFVsT20xcXVnRjVBajl5MTVXbEtLdlArLXJ6bVM=?=
 =?utf-7?B?elArLXUxZkpYMG9JT3lqVWFOeDNXVno2Z3RSU1VhMllwcnFjVllIam5Od2Q4?=
 =?utf-7?B?SUZqL0pJMjU4YmxPWFZvNTZUbGZIUDBmQmV4eGFGcm5XWXJqZmsycWlFR3BH?=
 =?utf-7?B?STVDZXFITkFaWnU5S1JVL1h1d3JlUXloYnQ2Ky0yWkw1UzArLXRMby9mV3Ix?=
 =?utf-7?B?MmVtN3JGZUhmTmloT0tlNVJxL2MzMkY1anh2SlNuUFdsVmhhMG5kWVROcWRZ?=
 =?utf-7?B?SVhEaW5Vb3VBVXloVzYyWHhKMTZBRDFzRkphRkg3QVl2OFdnNUZHcWowakxn?=
 =?utf-7?B?dVJ3OURwNklJRVdia3NWdUxLN1kwOXAzTTNNSExyNVFmUEtLVDJRRW9SY2Ro?=
 =?utf-7?B?QWJ3d0pydnpuTENDZDF0S2g5T1F6WS9HZlh6aU80ZXVOeWdhWW51ZjBFWlEz?=
 =?utf-7?B?akEwTTBlcG15aDBLUEZqRmFjZTRvbkpCTFh1M1lybjRtRjlnaVRQTlVrZzZu?=
 =?utf-7?B?UzJyUkp1UVQ1UmdRbm5YOUZXTDR1VklWcVJPc0x6YWNjQmdMV2cxNGJsc0pL?=
 =?utf-7?B?U241cmlUeHcrLUw5VDBURWgxWUlZTDNLWWNrVG5yNmQrLVZHNWFVb0pUbnNl?=
 =?utf-7?B?TjBBWlRCekNldms5eFQxU2loMlBmdWt3U3B3K0FEMC0=?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR08MB7026.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e011052b-b464-4e0a-7dad-08dd57baf1d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 05:44:18.8508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MoTo0+cGlkEsW18VvDlzySvStaBzkWHdxUZZVhLG4b1Ow24/6lkHMI3MVMuGcooZVk8Sar3jRLfUusXvukZiqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR08MB10439

Micron Confidential

Hi Karim,
You should be fine using the flow setting. I typically use flow for approxi=
mate distributions and rate+AF8-iops for specifying the exact number of I/O=
 operations I want to generate per job.


Micron Confidential
-----Original Message-----
From: Karim Manaouil +ADw-kmanaouil.dev+AEA-gmail.com+AD4-
Sent: Thursday, February 27, 2025 4:29 AM
To: fio+AEA-vger.kernel.org
Cc: kmanaouil.dev+AEA-gmail.com
Subject: +AFs-EXT+AF0- A question about fio flows

CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless you =
recognize the sender and were expecting this message.


Hi all,

I am working on some experiments where I need to have 12 jobs. Each job is =
reading from a different file (job1 -+AD4- file1, job2 -+AD4- file2, etc).

Now, some files should receieve more I/O than others. To implement this bia=
s between files, I opted for flows. Basically, I start from 100 and I assig=
n a percentage to each file. For example, a snippet of my fio job file belo=
w:

+AFs-private-0+AF0-
flow+AD0-37
filename+AD0-/srv/dax/private/private-0
+AFs-private-1+AF0-
flow+AD0-23
filename+AD0-/srv/dax/private/private-1
+AFs-private-2+AF0-
flow+AD0-10
filename+AD0-/srv/dax/private/private-2
+AFs-private-3+AF0-
flow+AD0-9
filename+AD0-/srv/dax/private/private-3
+AFs-private-4+AF0-
flow+AD0-7
filename+AD0-/srv/dax/private/private-4
+AFs-private-5+AF0-
flow+AD0-3
filename+AD0-/srv/dax/private/private-5
+AFs-private-6+AF0-
flow+AD0-3
filename+AD0-/srv/dax/private/private-6

I am not sure if this is properly achieving what I want to achieve.

I have a doubt that having too many files and many flows will reduce schedu=
ling precision or introduce scheduling overhead. I don't know how this feat=
ure is implemented internally, thus my question.

Can you please briefly explain how the feature works. And Do you think this=
 is a sane approach? If not, what better alternative can I use?

--
Best,
Karim
Edinburgh University

