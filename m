Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C788EB64DD
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 17:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjGKRDs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 13:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGKRDr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 13:03:47 -0400
Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01on2109.outbound.protection.outlook.com [40.107.222.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DAD95
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 10:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEiSc4rtM8sdIZ7kis1NSzsXRyLGeEv/5pff0I8doUbvE+yV8U9jIkFrVJixeo4xsHjCmzC8HFP3NKKt49fSYB6j9y63p12NEamWzWlQR5vmQhpgvtbuc2vDVBi+zowsZIjP8eGZoHOyO2gH1sDGZxwsYQRUCHaIekQXShOswsUWTnWOznYKfh7hUIJDjJtHZ9rnKvWp014UxzRqa4rjB2Q5RzZcYPGm1/0AscTsTbnU+DrHHNslh299Y1SWuxju/hQC0CCr6rRK77f/GhND9KRAIC17cjvRY+Vfu2og2AqFtXdAXG+gX24MHI6xmESWe/gCyvMlNqnxfAFS4Tw+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McXHD8/QYCxGnOI79jAlDptzgVAFWX9IZaW8jcI4jJU=;
 b=mezqby+cBaXJ1+WZNGdDZaiMngOpyxUOTdDG30CtYI4+Qvj/B5tcV7tPccvhSIXh1yew7llnB2aYmLpv8fnOo8UkDLDYc41gWieh/VR0InTKr3ciyM715m5tpJv2Qxh03W+aXHO3ND81JND1CCQOFox1uluUMDerPqpiEBsabJG1g1Ha/lMULAXvQVgpNo/DSZlxUnFYCtgMQcdd86jzcWJ/6yBpd2t4iDXhpgmFiHPhbc4Z1ZgSDt6e8YNGntk8UC1eT2xXXSjtoYZQeKyamvdVqtdNnHwHMdLxEb50MY+bO4fK909ZG6q2oaNfRlxQiZzawF+cVcSzBOGlYuN2mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marketsdatainfousa.onmicrosoft.com; dmarc=pass action=none
 header.from=marketsdatainfousa.onmicrosoft.com; dkim=pass
 header.d=marketsdatainfousa.onmicrosoft.com; arc=none
Received: from MA0PR01MB9577.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:c2::14)
 by MA1PR01MB4211.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 17:03:42 +0000
Received: from MA0PR01MB9577.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::e5c8:f6b5:4e7d:4592]) by MA0PR01MB9577.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::e5c8:f6b5:4e7d:4592%6]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 17:03:42 +0000
From:   Claire Davis <Claire.Davis@marketsdatainfousa.onmicrosoft.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: vger IT Services decision makers
Thread-Topic: vger IT Services decision makers
Thread-Index: AQHZtBmldW/LbJsvBEeHl+h6VY48BQ==
Date:   Tue, 11 Jul 2023 17:03:42 +0000
Message-ID: <8e370165-d2ca-fae0-d042-69295e7636ae@marketsdatainfousa.onmicrosoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none
 header.from=marketsdatainfousa.onmicrosoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0PR01MB9577:EE_|MA1PR01MB4211:EE_
x-ms-office365-filtering-correlation-id: f17f0dac-2d85-406c-3896-08db8230c7c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /etmOX9b51CTZUb0dmGpFkvdgd5cxdpn8hNGxdCg0u1xWzB8bkRCGp9Dot3et0xnnplggy0t78lbeAps6RAzzQrB3FZmU07RDZHxcgNPZ/DHaIbM06gzdWrekFMSow5uV7huDZJpLFGFZqDtra+24aOXoGieHL9U6DY53nC3cAFwd7qfFwGzEg5ykpoGcooksDAMZJQbBiJT10EMykvVZqvLUepVD0LrXoIupw32KscKE5NzVND91O0MAvCXBEczbfT/lvRzNyxoSnT3Q/qusf9OnIASFjTKepO2ruMtKlc1YH8xlOn7ydwFC4SYMHCJFlq8SCqoFRKfxWP47OyJlEnFjCEkDfSL+tJxf0nk+IM/ceob1Ods8xuHi1xP8CaQMbGPEw8qpElLmkFTUU465ZoExKD8KDtOyShioIVzZOoAQAZExWkDICbd0NJlUipsv24kJ+5oT3s5qEYPqSVNZX2XYIMuVKw0L9AD1ms9WrduAioQ1zJMjblFNu1SAUWWN1R6Z/vSsU71Y/oGw4w3le9Kc3ZgMPXGhZccgoqoteMbUisq2OiDvS6xBiLWp2w5dr626TbQrnrL+ImGblKzcxFnBHFHpFpj2g2KLXm8H7XisTOzOoz9VqSY2APg0qsnad0ALJy9ZsjhGfUDA2QRMZOCZscVKFtH7W57GGwa5Kk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MA0PR01MB9577.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(376002)(136003)(396003)(366004)(346002)(451199021)(316002)(41300700001)(8676002)(8936002)(6512007)(31686004)(478600001)(6486002)(64756008)(66476007)(66556008)(66446008)(6916009)(76116006)(66946007)(83380400001)(6506007)(71200400001)(122000001)(38100700002)(31696002)(38070700005)(86362001)(66899021)(2906002)(2616005)(5660300002)(186003)(6396002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1NxMnp3cjlCMTBjOHhWQUxUNk8va29kOUY2dmYyWjhBSCsreXFQQmpOb28z?=
 =?utf-8?B?ajJHeG9va3ZJSjVSTmxyc2dyUC9PN0cwT1k4VU0vWktFbGhuVElUL3RTZ0N0?=
 =?utf-8?B?OUNPbUU4TFI3L2tZNHlyWVRpRk5GbXBLcGhTeXloL2FBTmxzWDhEME1RQ1Ft?=
 =?utf-8?B?OEdBaHJXUVZiekdIRmJRdklHMVN4dUcwNjFtTFY0d3dyeDlOdVZRMlgvMk4y?=
 =?utf-8?B?S0w3KzFCKzFOV1NBR1pzZm52NXlCNy9hU0s5ZThIbXZLQjY5U1QvSno2UEZr?=
 =?utf-8?B?Z0t2SG9tQ3YrcU55YVJhMkJLbFd5MmxqZmNSUmt3ZVVVMHFhdDNzZXZBdm9y?=
 =?utf-8?B?U2RrTUZWcUNKS1VFOFRpcWNwTnpPQmlDOHhGSitlWEp2dFVXVGxLRmtsWkd4?=
 =?utf-8?B?cVJrdW5EWndXY0NCQzZpd3BXMFhzaExlUnhLc2ZIY1ViMEUwdWdZZDhOcHp1?=
 =?utf-8?B?REluM1NOcnYwMmc2ZUdlaUI3TUVGV0FuNGoxZDUycWJQcWpVZWZObEczMXR4?=
 =?utf-8?B?Ykh0R0hSanNUSmRQTG92d1VISytLQ2E5enNWUHZMMjFaV3dBdWZ6eXNIUjBa?=
 =?utf-8?B?SFhCZU1INWdSb1RUK0JlN3RmRy9lZVB1VlI1YkhoR2lrR2wrc2pGek0zTXVz?=
 =?utf-8?B?cjZkUkRGZ3JiK0xCRjBuNDNUYnpaVW81YzdQRmU4V0FpVWI3MjhLZlFqWDNX?=
 =?utf-8?B?b21MNUxtTElrUEVkS3VNclNDWGJibzFCcmVPRDRWWjIzUWNKSWRGUzlrSlZj?=
 =?utf-8?B?RDZib1BTSVpodmp2M21zdXlhOVBvUFFtNU5EVGpHUy9aSlRaRFlLS2l3ano0?=
 =?utf-8?B?dzl1dldsRjdzbUpYRlh2a3N2VkUxYWtIZy9WOXFKNGVFM1RkKzJ1cStDL2N6?=
 =?utf-8?B?cEthNC9wUWlwdExVNnpzeEhrdzBBZFQrUDVwY1pkLzVwNUgxbVZKN3JvT2Rr?=
 =?utf-8?B?eHg2cnB1eGs2cmREek5ZQW0zdmltNmFLSW1QN3phQUQwTCt2Y2huUEk2M0Vs?=
 =?utf-8?B?aUVQWTNFSFN3VVVycWpRR0d5c1JmMktmcW5nbHd5WmZaVE9iTno5aWR2RlZX?=
 =?utf-8?B?b0hUbCtUMi9kVGJzaC9SOStKN2cxQ0lUSVpOWjJBK2s0NVNUcnNwbmQxNnNS?=
 =?utf-8?B?VDlXaDkyZHlTZ0tyNk5JOEpZWjZKTTR1OXR1V0pjSEJVOFpicVkyc1ZwZUZN?=
 =?utf-8?B?d0ZSalJDaEg1TUlxck9wcVEwQkNSNTdDODlpYUxYZmJvRDJScWl6RmlpTmV0?=
 =?utf-8?B?WExIZ3Y3NTRXQkRuZ1lkY2QyVXR0VmlaWWMwWVVFVnFkYTFaZFlyUUxWVnpu?=
 =?utf-8?B?elZSTlJvbCtZUXFTWE9ndEl5ZEJ2M0NSZlVLbVVuK1g1WWVMbHk1OHN0NFdj?=
 =?utf-8?B?ZUlmeVo2U0ZpVGtCbnI1NlF4V3phaWdUWG14ZG5KRkJQL2NYSzF2VTRxdHZv?=
 =?utf-8?B?WUVXbmM4enphNnpjNUlaUXlCZnBUU3dMY2x2d3JZbjZtRmFLTnE3V05iR2hC?=
 =?utf-8?B?eWROTDQ3dDhWTHZFNVFXdDFBZk1mWitDRkVXSzVJUlB3KzZuU1dNYWNKTTBt?=
 =?utf-8?B?SDB4dEw4bnVZbVhsZ2taQmNwOExKMlI5SmxGUTlwQ1pQQXA5c1lsMHlwNmVL?=
 =?utf-8?B?V2hlZ0ZlTWtOTTk2eXNDTENuUCs5STJXbFljU0czNFcxbU9EM1NBQ2FRYkxD?=
 =?utf-8?B?L1ViRUZMNSsxUWZ2M2E1RGYwS0RQZmF1S2Rpc0tnZGFDeWFzZlNhYUtWQnda?=
 =?utf-8?B?SnNvYTB2Vm52anFWNnhQSmVWeGJTbGduNy90dldBSmxYczdFTkVtUEhCOTR6?=
 =?utf-8?B?UVBnT09adDB1VXplNHlUNG5tTFJJZHZyV0d0bEhtTlc2UWxaNXV6QzBvT2lC?=
 =?utf-8?B?Y1p6alFlUENHQnVZV2tCMGpLWUM2d2hiMHlrVlUvemp2N1d4blpOTmR5OVRH?=
 =?utf-8?B?Y0xsbno1Z0FrQTdYOWdrSXlTeFluc1VwM1FTQlpXcWlmYmlPbG9iUndGa0Zy?=
 =?utf-8?B?UUZpaHp6V3dqQ1BEdlU4NnNKQ3pPZEw4dUZPN2x5WTBNdnB0WTZuV1JMTlZC?=
 =?utf-8?B?R0NVVkpJNDEvTHJCS1QrSFNqazB2SVNBZC9UY2wyUVNaa3g4YkRNUXEzYjRK?=
 =?utf-8?B?bFFxcjZqa2ZPV2N6K21LWGxuMnBZbUpIdjQvL1d4ZGlIQlNyVmNVMWVQYVNM?=
 =?utf-8?B?ZDVWOXVDYTkzQm1IVnpWYlZRVlFDSVlXdUZzSlN2Yk1ieUJDUlB3a1lWTms1?=
 =?utf-8?B?RWxsVCsrVlV4NjI0UWRkaTdlQ25UL1JFaVl4VHV1eHFGOEo2TE9BK0M0YjF2?=
 =?utf-8?Q?IVurCx2AlY3g8Y+qD5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61AB317C9B61984BB9CF24A460130730@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marketsdatainfousa.onmicrosoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0PR01MB9577.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f17f0dac-2d85-406c-3896-08db8230c7c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 17:03:42.4439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 62dfda68-9244-4547-9a56-5a49125b28f2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZqIB2LdJLUCB9Cq+mGEBCZNrkQL6xo+p8tDAny1AYFAePH6ZAMvMDgAzltOzz8IVbAIASTXW8gEajZ2bvPzcHUguGzIH8C9S1C/VWFS5MZcW1D7L5MMc2+8QaGSWBofiOCKEzuGGj6DxkbByNNyiZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR01MB4211
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGksDQoNCldlIGhhZCBzZW50IHlvdSBhbiBlbWFpbCByZWdhcmRpbmcgYSBjdXN0b21pemVkIGxp
c3Qgb2YgSVQsIElTIGFuZCANCnRlY2hub2xvZ3kgY29udGFjdHMuIFlvdSBtYXkgaGF2ZSBtaXNz
ZWQgdGhlIGVtYWlsIGFzIHdlIGRpZCBub3QgcmVjZWl2ZSANCmEgcmVzcG9uc2UgZnJvbSB5b3Vy
IGVuZC4gQmVsb3cgcGxlYXNlIGZpbmQgbXkgbGFzdCBlbWFpbC4NCg0KUGxlYXNlIGxldCBtZSBr
bm93IHlvdXIgdGFyZ2V0IGluZHVzdHJpZXMgYW5kIGpvYiB0aXRsZXMgc28gd2UgY2FuIA0KcHJv
Y2VzcyB0aGUgbnVtYmVycy4NCg0KUmVnYXJkcywNCkNsYWlyZQ0KDQpPbiBUdWUsIDMwLTA1LTIw
MjMgMTE6NDMgQU0sICJDbGFpcmUgRGF2aXMiIHdyb3RlOg0KDQpIaSwNCg0KV291bGQgeW91IGJl
IGludGVyZXN0ZWQgaW4gcmVhY2hpbmcgb3V0IHRvIHRvcCBsZXZlbCBJVCBhbmQgTmV0d29ya2lu
ZyANCmRlY2lzaW9ucyBtYWtlcnPCoCB0byBwcm9tb3RlL3NlbGwgeW91ciBwcm9kdWN0cyBhbmQg
c2VydmljZXM/DQoNCiDCoMKgwqAgQ1ZEIFRlY2hub2xvZ3kgb2ZmaWNlcg0KIMKgwqDCoCBDSU8s
IFZQIG9mIElULCBEaXJlY3RvciBvZiBJVA0KIMKgwqDCoCBEYXRhIENlbnRlciBNYW5hZ2VyDQog
wqDCoMKgIENPTywgTmV0d29ya2luZyBNYW5hZ2Vycw0KIMKgwqDCoCBTb2Z0d2FyZSBFbmdpbmVl
cg0KIMKgwqDCoCBPd25lcnMsIENFTywgUHJlc2lkZW50cyBldGMNCg0KV2Ugd291bGQgYmUgaGFw
cHkgdG8gY3VzdG9taXplIHlvdXIgbGlzdCBhY2NvcmRpbmdseSBmb3IgYW55IG90aGVyIA0KcmVx
dWlyZW1lbnRzIHRoYXQgeW91IGhhdmUuDQoNCkluZHVzdHJpZXM6DQpJbmZvcm1hdGlvbiBUZWNo
bm9sb2d5IHxGaW5hbmNlIHxBZHZlcnRpc2luZyAmIE1hcmtldGluZyB8Q29uc3RydWN0aW9uIA0K
YW5kIFJlYWwgZXN0YXRlIHxDaGFyaXR5IGFuZCBOR0/igJlzIHxFZHVjYXRpb24gfFB1Ymxpc2hp
bmcgfFJldGFpbCB8IA0KQ29uc3VtZXIgfCBNYW51ZmFjdHVyaW5nIHxHb3Zlcm5tZW50ICYgcHVi
bGljIGFnZW5jaWVzIHxFbGVjdHJvbmljcyBhbmQgDQpUZWxlY29tbXVuaWNhdGlvbnMgfEluZHVz
dHJ5IGFzc29jaWF0aW9ucyB8SGVhbHRoY2FyZSB8IEhvc3BpdGFsaXR5IA0KfExlZ2FsIFNlcnZp
Y2VzIHxGb29kICYgQmV2ZXJhZ2VzIHxNZWRpYSAmIEVudGVydGFpbm1lbnQgfEVuZXJneSBhbmQg
DQpjaGVtaWNhbHMgfEFlcm9zcGFjZSBhbmQgRGVmZW5zZSB8VHJhbnNwb3J0YXRpb24gYW5kIExv
Z2lzdGljcyBFVEMuDQoNCkFwcHJlY2lhdGUgeW91ciByZXNwb25zZS4NCg0KUmVnYXJkcywNCkNs
YWlyZQ0KDQpDbGFpcmUgRGF2aXMgfCBNYXJrZXRpbmcgQ29uc3VsdGFudA0KDQpSZXBseSBvbmx5
IG9wdC1vdXQgaW4gdGhlIHN1YmplY3QgbGluZSB0byByZW1vdmUgZnJvbSB0aGUgbWFpbGluZyBs
aXN0Lg0KDQo=
