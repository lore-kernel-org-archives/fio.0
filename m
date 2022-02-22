Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED75C433F5
	for <fio@archiver.kernel.org>; Tue, 22 Feb 2022 14:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiBVOeh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiBVOeg (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Feb 2022 09:34:36 -0500
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2129.outbound.protection.outlook.com [40.107.23.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103BC5DE6E
        for <fio@vger.kernel.org>; Tue, 22 Feb 2022 06:34:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kr/mAZZyefz1/yCp+o2gaK2qJTevwo7OSTtOgeSlIZtvjFJ+ZgZQpldveW1sL+fP4EnWghhtIsnETrksKJa7SxttS5LqyZb3QWhKwh+Gt0qtJlm8BdCnJiUNn0BNPCt8j7UPtzBTOtwNJ3IKiVfds+JOZWsJMFveSCT27yEjaWucFWiAzxxV6L5u1zhvQz1ZXIlW4KECCqhc7/verRw4vPE9RGmAEZ6dBc0vOF4wBNJThFcR6iAd8oC/uGwadM8f3xSz884vqAA5u/ZX3VtXNqXGy2P3RlcnDLSqb+kyi0K7+zRWM65sbtjr7fYN2lBhU4pw6Z8K+hJTXaOR4cpJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSYgtLSDYp6aZVggM2dviURmJAf8mftz9B8tETawKIE=;
 b=F4Pu4h52V2+lFqByDE3ZR17r2L9p4iz4Oul7oTxWUrJRa7SlNK0CWIzAFxpx/UdcZEMYC7iGbmvOLjo8X4Nmq3G91KbfQ/yqTYMkB6fwbp2r7wDp5rnDSfs/bSIgzPyJtHaMYUmSw8bbqSxJmz7wZIV1n83iZ+MZy+O43U92XoaY0ZiywQG66WsbLgW+yPeCG+pyVqwPOQnezRXjTbbeFQ1kn2OT4Vkh0qGedeHma8CB8PqRnWV9sASGMdSL7bQ+Va5t49Ejh+1EZsQ5SzEFY+O1kC18D6cfDLXWps08/mPhYKNUQ7f9TAjS+VBnmjmKkejRozXgY/2YZrAiNofD1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSYgtLSDYp6aZVggM2dviURmJAf8mftz9B8tETawKIE=;
 b=LTNZq4xrr/lci0Ek98iqaainbKT6OlZMzVy0WNvfQgUwHIKEM15BcEgg+P+fh/stZZVz164qvhYDWte8MP2YK+eMfv2NpUNPg0sa5xWVKdZpB78xEHMUqtJO5XivOas8wPaTCS8he0hHNE2+Iw3fxTeeocZ3xCQOpfY3HZAcGx8=
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by GVAP278MB0972.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 14:34:08 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 14:34:08 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: Using FIO on systems with <=512MB RAM
Thread-Topic: Using FIO on systems with <=512MB RAM
Thread-Index: AQHYJzEERcXvP3wQB0KCk0vhofz1/qyeqsMAgADv0wCAAAmHAA==
Date:   Tue, 22 Feb 2022 14:34:08 +0000
Message-ID: <eab55f5985c7b812ef911f157f472d5576c21953.camel@toradex.com>
References: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
         <a93f0c6f-2b1e-c046-2cbd-654894cddcd8@opensource.wdc.com>
         <7c8c801bba09694a19695a551191cd970f5c6a97.camel@toradex.com>
In-Reply-To: <7c8c801bba09694a19695a551191cd970f5c6a97.camel@toradex.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e75d4b6d-5bd6-451d-ab35-08d9f61062e2
x-ms-traffictypediagnostic: GVAP278MB0972:EE_
x-microsoft-antispam-prvs: <GVAP278MB0972B7B917BD4EE1A5D8E090F43B9@GVAP278MB0972.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kZ2J47Q3AmskoEfrnKg43FmBTtaTQZBUIsKXkjp13731aDDsURypJ5jNlmJxgTUHnf8qKIHL8cEBtOlVDHEJcyFtBX+W5RHS+F2J+cTY2ZBIT2V4whXUSdIf6W96X27gHAt61e0xK7eZhXBnfvKml4V3GXOmR16YWjpqlg5/9vjaVjVaLJdmZivYs6WuRqa3ALEWTFK265SM+X1MXi45WWkefAullM5U5TZvQ5R4AFAw19rfPdxJJ26Qj6Hxaq19g6d/uvD9PDIfOYHjD70WxdOTKLJ/RtJ0etvMLpu1boanz7FXlqOVjIfYmHB4HaDBCgi1aID9MCG1lEEOhJhv54Ics6NhTIlcNJVUY2W6le/7GdHLjL7KL4ztzcVOHnaYaPOinnyPeJ9Jir6k8aYfzCXQdj4/G4+ALq9zmHPy8TG9NNLjymN+gVqNICDdtSvSNfzs9YNTnYL6ElM9/rIr4h83cR4VXAI+qPr7UKJNZcuKKMzUrlZrjvDdnGd0YYLomMJNeDrG2Oh80ls9xcs/aOdo/Em3dqMJgL8wONbGJ5lZ8IC2UNz31Stcy1ncBjAO47OF1sY0w8IdUHIgjTnLFHyuF2uOI4YhCW6uqXDSMOil1A9JO0HPrkyrjRd1o9UOwimikjkW63RIB2g9C8iFtiBQDrwy4lNMOFLew96AT6xfOva/XiJQAYLspcb2+mX6bQkm8ldF0Ajky4FTnHhbxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(71200400001)(2616005)(6506007)(498600001)(38070700005)(6486002)(6512007)(53546011)(2906002)(38100700002)(107886003)(64756008)(186003)(8676002)(66946007)(4326008)(5660300002)(110136005)(26005)(44832011)(122000001)(86362001)(8936002)(76116006)(66556008)(66446008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wkc5Nlk4STdHMUF4SE9WVjRPQUFscGRDWnJsSFd0b3d2VXI5RTF6YisxY2py?=
 =?utf-8?B?VHVsOWN6WVRGdnVzS1A1Z2RtY3ZJRkxPR0tQS2VuNmhDZEhlZVY2ZEVPNjNC?=
 =?utf-8?B?YjVDaVJVTVNMRVJYcFo3Sm1YYVAzb2JVZXNkQUltUzFNQTRieHMySk5mT05U?=
 =?utf-8?B?QUNnTkk0NkhrL2pndzh4d2REN2tiMDUraVY0czRJR1NNcGM3VnUyMFNlcCtQ?=
 =?utf-8?B?T2tMbHowNlJYaHY4eXozUU9ZSTcxV1Vjb041MUxYRTY4VDdDaU9vTXRxbmJ3?=
 =?utf-8?B?SEtvWlJUZGNrdTZUN1RxVk5wd2lhUld6ZmRldHJ0QkE1dGpwbGZTeW9vNWZy?=
 =?utf-8?B?eDZoK0w4NFR6Q3V6RGhUZ1pNcGljNU9IWVRmemNudTdnaWt1bnZmSXJWTWg1?=
 =?utf-8?B?WXlCbWVBMVlJc1h0UEdEQnlDeVJDaTZndUFDRkFzK1dmd3RyQ0dCT1RPdkhB?=
 =?utf-8?B?N2wrYzViaDhZc1UxYnFINEdvYXZ5ZFd6Z3IzYm1LWWJQOC9UcnJoYkZqU2Jk?=
 =?utf-8?B?UUFVTlJ1R3M1UGUvcWJMVXJjSGVOay9TN0RIclJvTVpWTmsyV0llb012M0JC?=
 =?utf-8?B?Q2sxODhVeWYxSWNhN1JqVldiMUoxSEpjNUJYL24veDdPN3lMOHJBbisvckVR?=
 =?utf-8?B?RHlPRUJzMlF3bU5EK1ZKM0Mza3I4QlN3MlNOYjZwR0h3MWJ4UHFKVDdSYVZq?=
 =?utf-8?B?cFlBWTBDSkphR0xHdnFpL0RpWHUvNG1PNTIrOHBxM1RPYVRRWllib01ZYlpk?=
 =?utf-8?B?NGNIczA1V1BlbTk5R0hVbDNabjQ3SE4reXBSTHRESWdXYXpWUUh1Sm9VdEp1?=
 =?utf-8?B?Sy81bGg4cTgzSi9UdUpDZ3ppdzFlOGlzalVXRjZjRTNqdHlXVmRnKzlsMmNF?=
 =?utf-8?B?WGRtK2VvN3NRVU1JL1U1Y2JCaXFxaDJGbllIbnVkc2hOalo4ZUZRZDJVNURS?=
 =?utf-8?B?Q2dncGZHQmJGeWo2OXVNeG00NzhWVHh3MUFIbUpBQzh6S09qN0dQWFRCSm04?=
 =?utf-8?B?RnYvRjYvMnk2OW04QnY3dGo5UzdNVy9lZzVNT0RmZlExdmFkSU1ueTVGendW?=
 =?utf-8?B?SFhSOW5PR1hyK2tNWEhHNDZzRUVldDQ1T2NKcHB3QkkwNnZkeUQ0THBMZlNF?=
 =?utf-8?B?eEVraVN2SW92SHVFQkFBUkMwcUovenBsMGZPd0VzSDczUnZEdi8zdUZZeXdj?=
 =?utf-8?B?bDFlaG93eWJPSGIycmNSTEhGU01NdUNmVzI2MjE4VTVQSzQ4QW5ONU94TlVT?=
 =?utf-8?B?SEU5VldKWnlqa3hPUXFXVGdibEZnQy9SbmxzRFBBa1pDRDdLU1ZJbjFzdEpj?=
 =?utf-8?B?eXNSeTV3dlJMSkhYc3c0ZG1MeWhpRHBmdzQxbGl0MjVvM3NQS0M5QWIrMHRa?=
 =?utf-8?B?aFhWakVyLzBaajhPOXl0S1hWejNBVW1vbkNGMFF2dG5XMnR4ZW1jTUFhTVhk?=
 =?utf-8?B?N3FpSVNYUjJWNnFiL1QwRVhORjhSNHVrTHJwS3N3Q3F0Y1djdituSXdZUWpk?=
 =?utf-8?B?QnBKb0M2WHBYR2NRTkFRZEF6U0JBZ3Q5WThJWlJsc1BScTBpY0hncHJyNk02?=
 =?utf-8?B?WVI0US80OVh4K09mZ2NYa3VxQkdWNU9ZU1VhZTd5MC9pa0VSbDNtS3ExVGFw?=
 =?utf-8?B?a0NmWmY0c0ZOTWZsbGczeEMwTmRyZjFrTnlRUVp4YVFRTkVOdmsrUmxWQmxP?=
 =?utf-8?B?MWQ4d3ZjUEFPOEVDS2kzM1Z4TTA3dURQMmQwcitnbkxJdG1QV2lRZHRkUno2?=
 =?utf-8?B?Lzc2VEJURDFUTC9BR1ZxcFppcjkwRERBSUFBRDRQQ3lUS25yVHBWWlptZGQr?=
 =?utf-8?B?ME9xUExBZnZVQ3VFUUdMVk5BRHF1ZHgwM09XR1pUbkJDa0tJWVhlY0lZNHJi?=
 =?utf-8?B?aHVKZ0hYQVI2b251SEFOSkptQjc3RmNiRFZ6aklsRkMwdXpDcStHUEM0RGow?=
 =?utf-8?B?cWJFZkdOVFZYSm1BajdvUitQVjZEd1RsV3c5L1h6SCt0aSsrZUpNWTZVRHp4?=
 =?utf-8?B?cHpMSjhtRjVCL01WbkxNTWkwN1dUU0VBalNNcDRiL3pBam5mRVRZak9VNmpE?=
 =?utf-8?B?L2gvZXFQbmtHdDJuZUMxQlFCUk5mVTBVQnNrd1ZLOVRXK3ptTWhic05YMnJD?=
 =?utf-8?B?RnJTbm1VZWdmN2pwVHRjbHF1ZzZzR1BRYmNLQmd4Tm9sTlEzcXc5c0lwYXhs?=
 =?utf-8?B?cFFTQ1Jua3NVemI1aFRuV1B1UTlQQXRkQ1N3dTBYM2xtWW1MKytHdVpJc3hY?=
 =?utf-8?Q?UQEGodtEsFTsMeXD+FhSUMjBBYH6xdgKUUS9f8TvfE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0371EAB2B484CE4FBB216CFA957A2B27@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e75d4b6d-5bd6-451d-ab35-08d9f61062e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 14:34:08.7631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9K4zShX4m/IwncJHPA7ZHSzipAyiywBnkLstE6x/DtOOFUdfeYFbFFusqWWTEZtMFoKbHqoTyi7TSiouQxaTYMHvXyFwym96yPkDsmKosA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0972
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gVHVlLCAyMDIyLTAyLTIyIGF0IDE1OjAwICswMTAwLCBQaGlsaXBwZSBTY2hlbmtlciB3cm90
ZToNCj4gT24gVHVlLCAyMDIyLTAyLTIyIGF0IDA4OjQxICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3
cm90ZToNCj4gPiBPbiAyLzIxLzIyIDIzOjQwLCBQaGlsaXBwZSBTY2hlbmtlciB3cm90ZToNCj4g
PiA+IEhlbGxvDQo+ID4gPiANCj4gPiA+IFdlIHVzZSBGSU8gdG8gY2hlY2sgdGhlIGVNTUMgc3Rv
cmFnZSBvbiBvdXIgZW1iZWRkZWQgYm9hcmRzLiBUaGlzDQo+ID4gPiB3b3Jrcw0KPiA+ID4gZ3Jl
YXQgZm9yIG91ciBtb2R1bGVzIHRoYXQgaGF2ZSA+PSAxR0IgUkFNIGJ1dCBvbiBhbGwgbG93ZXIt
bWVtb3J5DQo+ID4gPiBvbmVzDQo+ID4gPiAoPD0gNTEyTUIpIHRoZSBPT00ga2lsbGVyIGFsd2F5
cyBraWxscyBGSU8uDQo+ID4gPiANCj4gPiA+IEkgY2FuIGhvb2sgdXAgYSBzd2FwIHdoaWNoIGhl
bHBzIGJ1dCBpcyBqdXN0IHBhaW5mdWxseSBzbG93Lg0KPiA+IA0KPiA+IFdlbGwgeWVzLCB5b3Vy
IHN5c3RlbSB3aWxsIGJlIHRyYXNoaW5nLi4uDQo+ID4gDQo+ID4gPiANCj4gPiA+IEkgcGxheWVk
IHdpdGggdGhlIHNldHRpbmdzIG1lbSwgYnMsIGlvZGVwdGggYW5kIHNpemUgYnV0IGNhbm5vdA0K
PiA+ID4gYWNoaWV2ZQ0KPiA+ID4gYSBjb25maWd1cmF0aW9uIHRoYXQgd29ya3Mgb24gbG93LW1l
bW9yeSBlbWJlZGRlZCBzeXN0ZW1zLg0KPiA+ID4gDQo+ID4gPiBDYW4gYW55b25lIGd1aWRlIG1l
IGhvdyBJIGNhbiBtYWtlIHRoaXMgd29yaz8NCj4gPiANCj4gPiBTZWUgaWYgcGxheWluZyB3aXRo
IG9wdGlvbiAiLS1hbGxvYy1zaXplPSIgaGVscHMuIFlvdSBjYW4gYWxzbw0KPiA+IHJlZHVjZQ0K
PiA+IHRoZSBtYXhpbXVtIG51bWJlciBvZiBqb2JzIHdpdGggIi0tbWF4LWpvYnM9Ii4gQWxzbyB0
cnkgdXNpbmcNCj4gPiB0aHJlYWRzDQo+ID4gaW5zdGVhZCBvZiAoZGVmYXVsdCkgcHJvY2Vzc2Vz
IGZvciBqb2JzICgtLXRocmVhZCBvcHRpb24pLiBBbmQgb2YNCj4gPiBjb3Vyc2UNCj4gPiBtYWtl
IHN1cmUgdGhhdCB0aGUgdG90YWwgYW1vdW50IG9mIElPIGJ1ZmZlcnMgeW91IG5lZWQgKG51bSBq
b2JzICoNCj4gPiBpbw0KPiA+IGRlcHRoIHBlciBqb2IgKiBicykgaXMgbm90IHRvbyBsYXJnZSBm
b3IgeW91ciBSQU0gc2l6ZS4NCj4gDQo+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgaGVs
cCBvbiB0aGlzIHRvcGljLiBJIHRyaWVkIHRob3NlDQo+IHBhcmFtZXRlcnMgYmFjayBhbmQgZm9y
dGgsIGhvd2V2ZXIgaXQgc2VlbXMgdG8gYWx3YXlzIHJlc2VydmUgfjQwME1CDQo+IG9uDQo+IHRo
ZSBiaWdnZXN0IGNodW5rIChjaGVja2VkIGluIC9wcm9jLzxwaWQtb2YtZmlvPi9zbWFwcykuDQo+
IA0KPiBkZWNyZWFzaW5nIHRoZSBtYXggYWxsb3dlZCBzaGFyZWQgbWVtb3J5IGluIC9wcm9jL3N5
cy9rZXJuZWwvc2htbWF4IHRvDQo+IH42NE0gZG9lcyBzb2x2ZSBvdXIgaXNzdWUgYW5kIGZpbyB3
b3JrcyBhbHNvIG9uIDI1Nk1CIHJhbS4NCj4gDQo+IEhvd2V2ZXIgdGhpcyBsZWFkcyB0byB0aGUg
cXVlc3Rpb24gaWYgdGhpcyBpcyBub3QgYSBidWc/IEkgbWVhbiBpdA0KPiBzZWVtcw0KPiB0byBy
ZXNlcnZlIHRoaXMgbWVtb3J5IGRlc3BpdGUgaXQncyBub3QgbmVlZGluZyBpdD8NCj4gV2hhdCBs
ZWFkcyBtZSB0byB0aGlzIGFzc3VtcHRpb24gaXMgdGhhdCBJIGNhbiBhbHNvIHNldCBtZW09bWFs
bG9jDQo+IGluc3RlYWQgb2YgbWVtPXNobSBhbmQgSSBnZXQgc3RpbGwgdGhlIHNhbWUgZXJyb3Iu
DQo+IA0KPiBXZSB1c2UgZmlvIDMuMTcgaXMgdGhpcyBtYXliZSBzb2x2ZWQgaW4gbmV3ZXIgdmVy
c2lvbnM/DQoNCkkgYnVpbHQgZmlvIDMuMjkgaW4gdGhlIG1lYW50aW1lIGFuZCB0cmllZCBpdCB3
aXRoIHRoYXQgYW5kIG9oIHdvbmRlciBJDQpoYXZlIGFic29sdXRlbHkgbm8gaXNzdWVzLCBzbyBp
dCBzZWVtcyBJIGhpdCBhbiBvbGQgYnVnLg0KDQpTb3JyeSBmb3IgdGhlIG5vaXNlIGFuZCB0aGFu
a3MgYWdhaW4gRGFtaWVuIGZvciB5b3VyIGtpbmQgaGVscCENCg0KUGhpbGlwcGUNCg0KPiANCj4g
QmVzdCBSZWdhcmRzLA0KPiBQaGlsaXBwZQ0KPiANCj4gPiANCj4gPiA+IA0KPiA+ID4gQmVzdCBS
ZWdhcmRzLA0KPiA+ID4gUGhpbGlwcGUNCj4gPiA+IA0KPiA+IA0KPiA+IA0KPiANCg0K
