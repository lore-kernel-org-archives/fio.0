Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5581CCD6E6E
	for <fio@archiver.kernel.org>; Wed, 11 Oct 2023 13:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjJKNrX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjJKNrW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Oct 2023 09:47:22 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01on2119.outbound.protection.outlook.com [40.107.239.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF3992
        for <fio@vger.kernel.org>; Wed, 11 Oct 2023 06:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqOMRIMc7GlRWKjrzjPZbchNZz6+p9tAHSpvI/He2ejC6vsQXEWbjbHjVgdbr3lEZydFuTTqpUHDhbi9zomLNntyNmKvw/S76dng+miZ0J5057ZdksOuMk0uE7ah54vVoKJqGK6AR7FHFvpcOCuaCWXANfN/Lk3ZzzvssIjxPwh9FO8MngeKDrORmyFPeC04gN5Y+eQcFosF7/GmWn+eY2QX9DhGBGKQEhCCge746bCFm8zFCXGqK1Pbg0xpWs+H96BMyyApMbCasA2JqqwvAW92F+LCQCjU3noXjbJ+2bf3ohK3Qc2SzteZxaksoEDxb73wgxk6+DWOdBlRbDwQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZgBt9iDQFo8Lwjg6NQjOyWqWWTbFM1cuKSXESYvih0=;
 b=MwbTz5ETpGTS4iW/heT67Hr7LHeYtNxvB5ckGSWpaH1B/aDdiZSWyt4+2o9GDd73VjpnLVXRLpuwH/gfhJvmqYN3YpyLaPXznYfzVGZdUwlBI7bNYXaNuAtBAAKa1WVAEOcxwmt6Fk5W16FRtUH/XwXTLynlLV6rMhlE+8kN1vfckYzlP3x9Sl3JHv5p9xt6hFCgzuJk2BXTTqYTgIa0VikiM8e9DPL362fOBtpWudKATWfoJKj5H9tdbL4G+jT4/q7mH4gb+GPuKFJQ8eB0tmNOsPHn6leYiZJzt4dwRQzd0Tt/zFnDKUV6jQYXZHpquoFj2TUBtjUXYgUK/6KT1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marketsdatainfousa.onmicrosoft.com; dmarc=pass action=none
 header.from=marketsdatainfousa.onmicrosoft.com; dkim=pass
 header.d=marketsdatainfousa.onmicrosoft.com; arc=none
Received: from PN0P287MB0603.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:166::10)
 by PN0P287MB0684.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:160::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.43; Wed, 11 Oct
 2023 13:47:17 +0000
Received: from PN0P287MB0603.INDP287.PROD.OUTLOOK.COM
 ([fe80::d4af:3cbb:2a99:b08]) by PN0P287MB0603.INDP287.PROD.OUTLOOK.COM
 ([fe80::d4af:3cbb:2a99:b08%3]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 13:47:17 +0000
From:   Claire Davis <Claire.Davis@marketsdatainfousa.onmicrosoft.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: vger Marketing for management consultants
Thread-Topic: vger Marketing for management consultants
Thread-Index: AQHZ/Elz3xw5/biK7E2ukcTtF02rQw==
Date:   Wed, 11 Oct 2023 13:47:17 +0000
Message-ID: <2f2e2e44-0bb7-e875-498d-7e12e7a2964e@marketsdatainfousa.onmicrosoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none
 header.from=marketsdatainfousa.onmicrosoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PN0P287MB0603:EE_|PN0P287MB0684:EE_
x-ms-office365-filtering-correlation-id: 620fa991-01d7-4069-5d18-08dbca60959c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GwgeIfkw7pxdK2b5j+c7wcigcfCgVmCq/n4GlCUOpJ66a/neMiH3Pyo96jppwiTB0GEFb7RQGQKA0K3Lh1YVTZoA7gFVz3bA2uBeHq/NYW54e1p8e43NhucyH00saWVosBsRns6wY4aqY15T4qZ5eqnAPsC3JWauyXPtADadv2OsU+4CZplxOvLxethjpfT51z05IrRjEbVW/ZF+429HKvaayWe+wQs33IXbE+dtdavvT2XCthkah72Xle0mNBrcU5HqwqFNJtwYiCJGpR31HxSbtBVnRpn/GK5JiJlrbXdSmq7TxGBNbOFVRAgnEYljKgkMfjWrvhRYOCq1br9JL4ILI6L4n9ldOloBFEgCNeTiuCsvwxCs9wIBe2bztXjffF5CqX/cpHCSqxIFfrPlJZ82DOHlO6hVvfIssWPpiNnUz6pofGX6O7yYvdU7pvMkURQmaR5/GQ/h0X0qBZUKJiKYINaskPQ/iaB6k+4oQDgb/JGpMozUhaIckmqrbLRZI4V3qw361HX4cp2YFjCZZcRkwD+UcyjZSU7h/r7Ing4QBuVt+yNAyqk30H1mclBh7kaRVKw6Dv59Vcs55PZCWeldYSHKrPivh9FZCChuQaxM9nV5o/zfzcy3+4ksqI3uaEa0aIXtP3hW6USdtCQHQ37C9p9KH5OmTQR8WV0+2j4U6utZ5KXthgpnkNEAHdJ/MuLu027okq8b1IS6GupMqkeL6iN9pzHwJyXs83dBMjSyZhQcjW5n1Get/4L1LZ74
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PN0P287MB0603.INDP287.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(366004)(136003)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(66899024)(5660300002)(83380400001)(38100700002)(38070700005)(122000001)(86362001)(31696002)(2906002)(71200400001)(6486002)(2616005)(31686004)(53546011)(41300700001)(478600001)(6512007)(6506007)(66446008)(66476007)(66556008)(64756008)(76116006)(66946007)(91956017)(6916009)(316002)(8936002)(8676002)(13220200019)(437434003)(581174003)(6396002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUtKdFp0RnAzZjN1Q3ZrN2JwQmlEdmxEbGNjZE5mUzJGTFJ2cXBIRmhJMlJw?=
 =?utf-8?B?akp0KzhmS2YwL0pNeUlzSXA0Z2lJdVZiTmtCSGJtZVk1eWx3S05sM3pPKzlv?=
 =?utf-8?B?M2ZMMUhuRDdnbys4ei9nSGIzMzk2SmtQbWU5TEROV3lUeEJIbVlESmtyNXMw?=
 =?utf-8?B?NWgvVXRMaTU2NWM5VE9CYWRnZXlsU3J5bHUyQWZYak9ZUGF3NjFlN2RpQllB?=
 =?utf-8?B?VDBkSXRZRHloQXhEclpuQ1RtQm1QM2tFcHE0eTNEUjZMWkM3WFFPSWhMYnYw?=
 =?utf-8?B?Y1JUa1laS3RWMmIwRUZzWHZoaDVZaUVqV0UxWWdySWpNR0VmMkEvaDdqV3dX?=
 =?utf-8?B?SFQvL3llY0JBZ1NYOGkwSGs2QlZyWm1OL1l2NS9HVzVoNmxqMm1zaDdwaDZG?=
 =?utf-8?B?RUppY1F6UnA2a2NEYnNlSU04WUtwdkZiMWFQRUhwandGOGJHa3huU1hsM3Zx?=
 =?utf-8?B?MUZlckJxM3RldXhIb0pYa3VRZmxMZmJ2YmRhemtVeXljelk2K29nWndoOUha?=
 =?utf-8?B?Q3FTL1IvaVZJL2JwbE5rZGZIa2F1VFFjZHdhRXZudGYxTzdTL3l3bkZnMkhT?=
 =?utf-8?B?WFNSbkVpUHRkRUpETzlqMHYrN0RFQS9FQzMvSk5hMHNWZjdIckNLK0N4TDVu?=
 =?utf-8?B?TFNQclcvV3VFUG9WNjQrRnN1M1FSYkpXVk5aMGt6b2tidnduaUpmdHhkbWp6?=
 =?utf-8?B?b1UvcGZFNDA5WjB4WmdwQTVmTVkxLzVSTWQzeGZCWUNBZXFIZlQ0dVowWGk1?=
 =?utf-8?B?QTdIOEVoSzRuOHUwU3g5TkdZaEpmRWw1dkN0TGx4dUtUNG9FQi9DeVlZQ05F?=
 =?utf-8?B?MVM3bGE4c25penFjWVNvUVp6VlBLSjZoWndUaWNlMlM4ZmRYRHRPQjRxQjZw?=
 =?utf-8?B?QXRHMEJZNmxPb0haZjJOQWdGcTRCcmdBVWRzdG1kN0Jpb2hJRXRyR2tTYURK?=
 =?utf-8?B?Z1kyandVWEpWWGh2LzJqcUs0QmJkQlpTWmt2bGN4VURLcjV3OUtLTi9pQitE?=
 =?utf-8?B?TEFDUkk3UytOcTdNbnE0WUJ5T2tuZWpWazNuWEFzSEtDekludnlubm9KRUQ3?=
 =?utf-8?B?VzFzKzZZcy9abERwSDFBS2NtcWZ6SmtpOG1Hc0EzK3hXYXVMTytkQ3dJV0Zr?=
 =?utf-8?B?b2FjS0xkVmNYQTBmV25Lbmx0Vi9VdW5La2V6NmdEaEsvQ1lINHlFN2VMKy9T?=
 =?utf-8?B?WFBUeUVUcGZpSGdrbjdHTWRpTzFHNVVLMEN2dW51bVlQQzlwTkdkZjh5R1h3?=
 =?utf-8?B?OUJRYWQ3am1NeGhBTjROSFpQTExiVzZOV2tPRVU0UW10ZksvYUVjQ0hUOVJu?=
 =?utf-8?B?U2tnREZ4a1pGTGpUczFQQ1RKdUxGU0p0YzQvbWMzSisrVy9yaUh6dC9RTUwr?=
 =?utf-8?B?clNvNStMdy95K0J6L1cwUmduVW10eDgvclRaSXlMdVJYQnBQMnhYU2ZhNEQ4?=
 =?utf-8?B?UVpWTFR5dzlReEdQV2J3ZVB6Z1BsTkhtZU5EVStSOUFvWlNONVE3OGdWem1o?=
 =?utf-8?B?RU1WTm1POTZrYnV2YmlVa0p4ajA3V05rR2o3b04xM2lRZ0VVS2t6eW5jTldq?=
 =?utf-8?B?UXJwT0RIc2NHSWVhWVd0d1hRTGdCTlZKUWNFUXJCZ25XMlNMQzFsakQrN3Va?=
 =?utf-8?B?WkxGajFyVWcza1RadWF6K29RVE1TaUlyVjlSUFNWSTRHQkRGM1dZYkFpZHZv?=
 =?utf-8?B?OHR2TVJQTUNnaDVSSXZmbjRxQTU3cjAzMjJBTGRhc0xUZmh5MHZlaWNIdTFk?=
 =?utf-8?B?KzloTmhTc1FNWHVvTmJkMFpuekRhTGJWTXJ3dzYvVWNkcVl0TWdIOGtvUW9s?=
 =?utf-8?B?TDA1cnhhcm0yRWdwcG1TaG9JeVF5YjBTNUVjTituQUszOExXNGJVNTArVDRB?=
 =?utf-8?B?RHg4UG1ualZIdEh5bGlUT29paWVmYnIyUkVvNTAxQkxLNFdHei91ZmFQZS9i?=
 =?utf-8?B?WEhiamplY3NIaW00RDRSNWFpV3NBRVNlYTJzeWowazRpY1E4R2JQSXFEdEZi?=
 =?utf-8?B?ZTNISXVJZ0owUlBrS0FmSW15U1o1aFNBUjBEUGlNdnBTRXJSZllFTnhmVzRP?=
 =?utf-8?B?MDFDVGN6R3pISXA3Wk94TDFUWFluVy9uTS9BOFFER3QzYW8xbVFKbE1LWDEv?=
 =?utf-8?B?WE9hYUlUMXR3dXViL3BQZDU2SFp6RGpZYThFbGUwWnhzUDhoUTZVTHc3MHYw?=
 =?utf-8?B?Sk95WmdERE1MNUVneTVrV2lJd0hOZXo3clJ0WnF0SE1EaGxEZXV5aEhvMDJ4?=
 =?utf-8?B?YjhBL21yaE5vcDNUYWlIcDdubHVxdVZFamc0cGttYWxON3lkQ0V4RnpPRFd6?=
 =?utf-8?Q?WnePJJnpAWKVidCpUP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <125156F0AEA23D4DA02F7EEC26D7C8BD@INDP287.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marketsdatainfousa.onmicrosoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PN0P287MB0603.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 620fa991-01d7-4069-5d18-08dbca60959c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2023 13:47:17.8178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 62dfda68-9244-4547-9a56-5a49125b28f2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d3ZXZzKXnUFbhc0bUMULHV4BtENw2TLAokyCjxju/A+H6RvZh6TZlGkPMxGFzU95NEWhv64E/IAvs2QcuVezUH/IjZWB/2UF3x4TGo+BLG3xPFawIg8hZMjBc49OqoYveoeCzDIxsueuO3jK6TrPnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0P287MB0684
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGksDQoNCldlIHRydXN0IHlvdSd2ZSBoYWQgYSBtb21lbnQgdG8gY29uc2lkZXIgdGhlIHBvc3Np
YmlsaXRpZXMgb2YgdXNpbmcgb3VyIA0KdmVyaWZpZWQgRGF0YWJhc2UgdG8gYW1wbGlmeSBhbmQg
ZHJpdmUgbWFya2V0aW5nIGdyb3d0aCBmb3IgTWFuYWdlbWVudCANCkNvbnN1bHRpbmcgQ29tcGFu
aWVzLg0KDQpXaXRoIENvbnRpbnVvdXMgaW5ub3ZhdGlvbiwgYW5kIHBlcnNvbmFsaXplZCBzdXBw
b3J0LCB3ZSdyZSByZWFkeSB0byBiZSANCnlvdXIgcGFydG5lciBpbiBhY2hpZXZpbmcgY29uc3Vs
dGluZyBleGNlbGxlbmNlLiBXaGVuIHlvdSdyZSByZWFkeSB0byANCmVsZXZhdGUgeW91ciBjb25z
dWx0YW5jeSwgd2UncmUgaGVyZSB0byBtYWtlIGl0IGhhcHBlbi4NCg0KV2UgaGVscCBjb21wYW5p
ZXMgZ3JvdyBzYWxlcyByZXZlbnVlIHdpdGggb3VyIGhpZ2hseSB0YXJnZXRlZCBlbWFpbCBsaXN0
cy4NCg0KUGxlYXNlIGxldCB1cyBrbm93IHlvdXIgdGFyZ2V0IGluZHVzdHJpZXMgYW5kIGpvYiB0
aXRsZXMgc28gd2UgY2FuIHNlbmQgDQp5b3UgdGhlIG51bWJlcnMgb2YgY29udGFjdHMuDQoNClJl
Z2FyZHMsDQpDbGFpcmUNCg0KQ2xhaXJlIERhdmlzfCBNYXJrZXRpbmcgQ29uc3VsdGFudA0KDQpP
biAyNy0wMi0yMDIzIDExOjQzLCBDbGFpcmUgRGF2aXMgd3JvdGU6DQoNCkhpLA0KDQpXb3VsZCB5
b3UgYmUgaW50ZXJlc3RlZCBpbiBhY3F1aXJpbmcgYW4gdXBkYXRlZCBlbWFpbC9jb250YWN0IGRh
dGFiYXNlIA0KZm9yIHlvdXIgbWFya2V0aW5nIGFuZCBzYWxlcyBjYW1wYWlnbnM/DQoNCiDCoMKg
wqDCoMKgwqDCoMKgIE93bmVyLCBDRU8sIFByZXNpZGVudCwgRm91bmRlcg0KIMKgwqDCoMKgwqDC
oMKgwqAgVlAgb2YgT3BlcmF0aW9ucywgT3BlcmF0aW9ucyBEaXJlY3Rvcg0KIMKgwqDCoMKgwqDC
oMKgwqAgVlAgb2YgTWFya2V0aW5nLCBEaXJlY3RvciBvZiBNYXJrZXRpbmcNCiDCoMKgwqDCoMKg
wqDCoMKgIFNhbGVzIERpcmVjdG9yLCBWUCBvZiBJVA0KIMKgwqDCoMKgwqDCoMKgwqAgSFIgRGly
ZWN0b3IsIFZQIFJpc2sNCg0KV2UgY2FuIHN1cHBseSBjb250YWN0cyBvZiB2YXJpb3VzIGpvYiBy
b2xlcyBmcm9tIHNldmVyYWwgaGllcmFyY2hpZXMgLSANCmZvciBleDogQyBTdWl0LCBWUHMsIERp
cmVjdG9ycywgTWFuYWdlcnMsIGFuZCBzdGFmZuKApg0KDQpJbmR1c3RyaWVzOg0KSW5mb3JtYXRp
b24gVGVjaG5vbG9neSB8RmluYW5jZSB8QWR2ZXJ0aXNpbmcgJiBNYXJrZXRpbmcgfENvbnN0cnVj
dGlvbiANCmFuZCBSZWFsIGVzdGF0ZSB8Q2hhcml0eSBhbmQgTkdP4oCZcyB8RWR1Y2F0aW9uIHxQ
dWJsaXNoaW5nIHxSZXRhaWwgfCANCkNvbnN1bWVyIHwgTWFudWZhY3R1cmluZyB8R292ZXJubWVu
dCAmIHB1YmxpYyBhZ2VuY2llcyB8RWxlY3Ryb25pY3MgYW5kDQpUZWxlY29tbXVuaWNhdGlvbnMg
fEluZHVzdHJ5IGFzc29jaWF0aW9ucyB8SGVhbHRoY2FyZSB8IEhvc3BpdGFsaXR5IA0KfExlZ2Fs
IFNlcnZpY2VzIHxGb29kICYgQmV2ZXJhZ2VzIHxNZWRpYSAmIEVudGVydGFpbm1lbnQgfEVuZXJn
eSBhbmQgDQpjaGVtaWNhbHMgfEFlcm9zcGFjZSBhbmQgRGVmZW5zZSB8VHJhbnNwb3J0YXRpb24g
YW5kIExvZ2lzdGljcyBFVEMuDQoNCldlIHdvdWxkIGJlIGhhcHB5IHRvIGN1c3RvbWl6ZSB5b3Vy
IGxpc3QgYWNjb3JkaW5nbHkgZm9yIGFueSBvdGhlciANCnJlcXVpcmVtZW50cyB0aGF0IHlvdSBo
YXZlLg0KDQpBcHByZWNpYXRlIHlvdXIgcmVzcG9uc2UuDQoNClJlZ2FyZHMsDQoNCkNsYWlyZQ0K
DQpDbGFpcmUgRGF2aXN8IE1hcmtldGluZyBDb25zdWx0YW50DQoNClJlcGx5IG9ubHkgb3B0LW91
dCBpbiB0aGUgc3ViamVjdCBsaW5lIHRvIHJlbW92ZSBmcm9tIHRoZSBtYWlsaW5nIGxpc3QuDQo=
