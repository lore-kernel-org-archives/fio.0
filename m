Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA001EB64DA
	for <fio@archiver.kernel.org>; Mon, 26 Jun 2023 08:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjFZIjZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjFZIjY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Jun 2023 04:39:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2098.outbound.protection.outlook.com [40.92.19.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FEDE5B
        for <fio@vger.kernel.org>; Mon, 26 Jun 2023 01:39:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMpEoUSXdQG39ZirgNzrbvfX3aSmw44SLq6ccE4m60CbtI/TjzRuhfRhbBvBAhhwq2+Plt9XQQXsyzkhs3QeZMQet+K4IaSWclynYOCRG3SDs+5m38yNG/TBkN4oX0R3/K0ucw1VjnTEUmzJ6watgh99eejidRu9eb/smdP6bBBSMWqSX95lauhDLTTgn1Cf7fCoVunjmGyGrvwzpvmbm7DWthPRQhVz7YO2tZjkNFlRLDhPUst26I+iQwibzURlQIySXKKx/qQ1A3xJNf17Ii8rXfK1lboYbV84QyWcp3A1Qop7E3oOR6a57wY3tpPaxCf7xBYcZlsp/K2lvyV5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRbsxYXfrQpuhPQJuez1uWf5Nw5MEdRWokSZiOZI0hE=;
 b=QG/qHJtWdgRMzQyazR6Kc1+PlVRp/aEkiDC8XPIhZBVDN5MgNfSwaqrLUvTujbLSiROmGa+a4DU2++5IZ1fXIEXPAoeJC7Mb9EOTWs7S3JhBYkDQcTPiyBJnaMMBqlk1ZvM7jp0q3thlRwOryiw+SFbgTFjM6+p+vPeePdFlXKxhpUz4c+r64tJgwZCRBqpIjp5YoNS9YqjZRpTQb1ss1IUjvqgnp0TVZszB4QzlUc6COnEcW/7ZjRM2R8y39Pz4a8j6iF+n1Qrbi8k6HLj+7O4C/t7fulcQYUCNmhW7DB3WFLc4pCJjXCv8tCjuB2i6swlvqu27XXCsZanLXyn0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRbsxYXfrQpuhPQJuez1uWf5Nw5MEdRWokSZiOZI0hE=;
 b=uYVp6dgipmnLelI3reXheqjTmYDjAnkgHHSZ1UCKxoDedIL845+rkmAXBJcnHmJhSm5eXMjIvgvjPNF87AcqwinFRsEy92MfeEHlTmVxT7/XnMrLO0S8CjUKpgV41bg1X6M7A+exxZd+v9CWBYRqe8tKHbAOI/tYhnWA1qs+VrjUuoasy7fCoNVwbI5EPBZGYi1AE+Vj3UcU+jn13ykzWt29HI5YCMc6Bdk39cdfOYAz1hA9awVZtZmj9XDycXkQIXu2+bgp4DxsL3t1vVb91v7cOXP2HG76v5JklqgCTyYXuUr0if/P5G+QL1CmWmXzuapzZGEqqZOKfT5924QbdA==
Received: from IA0PR17MB6275.namprd17.prod.outlook.com (2603:10b6:208:43b::7)
 by CH2PR17MB3783.namprd17.prod.outlook.com (2603:10b6:610:88::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 08:39:19 +0000
Received: from IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::bb49:31da:ddf9:1b64]) by IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::bb49:31da:ddf9:1b64%6]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 08:39:19 +0000
From:   Adam Horshack <horshack@live.com>
To:     richard clark <richard.xnu.clark@gmail.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: Question about the internals of the file IO latency
Thread-Topic: Question about the internals of the file IO latency
Thread-Index: AQHZp7AcpPTFPQG9vUSi7aR96J17HK+cxAWe
Date:   Mon, 26 Jun 2023 08:39:19 +0000
Message-ID: <IA0PR17MB6275DCF5B223588AB129A697A426A@IA0PR17MB6275.namprd17.prod.outlook.com>
References: <CAJNi4rNuudfMQEQqGN4SbLB72CwpyoAZ05EkmdLAKAY9d2f7vg@mail.gmail.com>
In-Reply-To: <CAJNi4rNuudfMQEQqGN4SbLB72CwpyoAZ05EkmdLAKAY9d2f7vg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Ujq9J5lXGrQgTrzHS0rCrBRfTiKJkR7F]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR17MB6275:EE_|CH2PR17MB3783:EE_
x-ms-office365-filtering-correlation-id: ce2c64ef-2b6b-41b5-504d-08db7620d578
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vt5b8qK4zK7DE2nfM+w3plAzYAzxsbd3CV9YbEAYxyY5Ee+YqactRVbT2awVnj+ZlKQJlwMxTrleGcZuxWu2ZJd2MQMWj0ERRvFYRHvaDpaEo77OYAt4+7CKDytNQ+/ff8Djtm4CwppkkqvQ2j/Hne89dGPG1gKoXzDF0VPKoiMonmwko2sbm75JDqWOb6uglel6bxBMZyf/AycPQPVmohjStm9nrfXDbqjKmhJZoA+wxy3IPzWeezwNLIhOIkqgdCvpbhKo077wVku/3PEDJNCIuFwbrIoIF0Yv1KfZq5tj25ScdZ0CQH3FZ6iUktA7UPrzzOSLKjIC6OkPZklkQfPbDNcXQ8xX2xa4UlJVRxTECYF4aehzYCjE3vA52ysJ1aFZziCoEgaKXFiKuASwePoovOjLZuqleQjnTB6HWNrAus/AzzZmXpdIjV8qND9ic3sDj19N/1OcNM2pnVVY01FKYG58omW8gXPlAz3mV/Xruxkw5w0fmzFfn+0QQ+R2Al1ozY2QW6Kd9ZNm9hPW3BaYQi+p80YHo/uz6Z/WUf1bw9WMx7ExmNNTo9D3G/G8
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjFIcnhqSFk3Z0NCaVUwY0lSLzhCbGhQeDhHVE1udVRUVW9sMmQ0Ym1XNndn?=
 =?utf-8?B?VUhHYmRUNVVQdFFHdDBoZzVPU3pIWml1UnA1eitzR1Y5dHI0dXNoSDVuaUpk?=
 =?utf-8?B?V0k3UlNTS0xVZHM4R1FTSnRZL2gyV1BKSjZTY0U1Zmc0V3kxNTJ0UDRHQW9l?=
 =?utf-8?B?S3g0ZVhYZWltdlVCb3VWSTZaeGxHRnJCSFhCMFZ6Y1NEU25zQzhRSlVrTnpQ?=
 =?utf-8?B?YVNCNHFQbndySGxON0c2ZWduVUVsb3hpOTdBK05PKytEMjRTaW9lSVc3eHlK?=
 =?utf-8?B?RExxMy94dnhlcWpXRlU2OE4zZmd4VGVmSXF4b1RieDhVVFQ1bkQrdnQ5Uk4y?=
 =?utf-8?B?Y0liT1h5U0Z4RjUrMVdZTjF0MWx3cldMY3c3ZE5Pc0ZWdVRFNDRvNU5RK29C?=
 =?utf-8?B?QU9CYlFqZmZCbVQ2ZTFXZ1BxVWlHYnpObXdWSDhKcEI0NkRDbllCME5EODJ3?=
 =?utf-8?B?MlNFbHhUZGkydXQyMGxTTGpCSVgzK3pMOWtBalFxa3BoelpmeGViSU1YaEZJ?=
 =?utf-8?B?b1hSNWRMeWF6N0ZReElDbDZzNThVNGh2NkpDd1ZuOTVqR1JHT3VsclVaZU9j?=
 =?utf-8?B?YkFEYTFuNTZSUUlhc0g4R2IyekR4dXArYWZhZVJJcnZDMTNpVmwrdEhrTXk1?=
 =?utf-8?B?VHpDS2FQb2szN0JkMTBVcnJWbUJVQ0Y3YnowcDVXUm1wZklVc2N4eGlMZjRz?=
 =?utf-8?B?VXlwQnMrMHh4THBUWWhWVEV5dVEzRW0xZEtsZ25rYXVTTHlGSHJxZW9TQ0xK?=
 =?utf-8?B?NlRHRFVKYkZ2VDQrb0JxOFdUc3JwMEZPZnJhSHhqaWdhU2RnWURQcDNmVndG?=
 =?utf-8?B?MWFZSzlNZTlIdjZxcE9aaHlycXE2SU5aeXlrTXU4UEpGTnNJemlnWlh3OG45?=
 =?utf-8?B?OG8xYk9pM25nbE1nRnl1K3lZUUVTakE2Z29xRzFmSkNoWUJ0MGV0MUFxNFdX?=
 =?utf-8?B?YUo3bHowL0w5UmRGVWhjRk51VkNYeGR3QmxKKzdKWFVHMTYrY25zTHRieWRi?=
 =?utf-8?B?NDlhK1k2bjNVbWd1V0JFa1JLdDRNQzdKT2ExTnQ5RGVjKzRENS90dndXbWxE?=
 =?utf-8?B?UGFNSVdTQU5nSzNnZFpwL3pVaUdFQlVvSXZmYkxTUFhXS0JyV0hkWVppcjAz?=
 =?utf-8?B?QTZMbjNBclZrTGxmUmRmUzVlWkplQVJRWi8wRUJaS3dlczdNZ3FsVndGOE9y?=
 =?utf-8?B?MWhYZzRaSmh6azRNL3l4ZGNjU1FvTWZ2ZSsxMTVUL3VJeTBIWlVXTE1SQkJ1?=
 =?utf-8?B?ZDVmcThoWVVBbElpd2pmSEk2bW8wdjFTaGNsMXlCSHduZjRTMUZMbXRxb09H?=
 =?utf-8?B?TnJDaG8xMW9IbG9tWjE5eGN2MjZDa0RCQ0ZXYVgvbllmQWV6Nm5PV3ErNmNn?=
 =?utf-8?B?cVNjMzJicE8vdHMxcHVjdXhtbDAybDNPRTRhaXlnL01CTXR2c0V1Y09IY2o3?=
 =?utf-8?B?UWdpRXlUZFZaUVl5MWlhQjYrdHVEUFpqMFRFMHVhWDNVZzFwWE1mdm54VFg2?=
 =?utf-8?B?L0FOaUcyaFhzSEVuREJ6UTFqZ0h3WTBLampNNHQrY3RvZzAxY1JvVFhLRW0w?=
 =?utf-8?B?SHlxT2N1N1FHdEl4TVlERVBDWjZnSjBZOHpTQkIxM1ZkN290U1lsVkI1dmor?=
 =?utf-8?B?L3Z1RHhXWnJNZDhHMXJvR2NnYTJvQnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-c704e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR17MB6275.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2c64ef-2b6b-41b5-504d-08db7620d578
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 08:39:19.5159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3783
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGkgUmljaGFyZCwNCg0KUGVyaGFwcyB0aGUgcmVhZHMgYXJlIGNvbXBldGluZyB3aXRoIGRlbGF5
ZWQgd3JpdGVzIGZyb20gdGhlIGZpbGUgY3JlYXRpb24gcGhhc2UsIGlmIHlvdXIgc2V0dXAgaXMg
bm90IGhvbm9yaW5nIGZzeW5jcyBpc3N1ZWQgYnkgdGhlIGNyZWF0ZV9mc3luYyBvcHRpb24uIFlv
dSBhbHNvIGNhbiB0cnkgYSByYW1wX3RpbWUgdG8gdHJvdWJsZXNob290IGFueSBjcmVhdGUtdG8t
cnVuIHBoYXNlIHRyYW5zaXRpb24gcmVsYXRlZCBsYXRlbmNpZXMuICANCg0KQWRhbQ0KDQo+IE9u
IEp1biAyNSwgMjAyMywgYXQgNTo1OCBQTSwgcmljaGFyZCBjbGFyayA8cmljaGFyZC54bnUuY2xh
cmtAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IO+7v0hpLA0KPiANCj4gSSBmb3VuZCB0aGF0IHRo
ZSBsYXRlbmN5IG91dHB1dCBmcm9tIGZpbyAocnVubmluZyBpbiBteSBvd24gZW1iZWRkZWQNCj4g
Ym9hcmQpIGluY3JlYXNlcyB3aGVuIHRoZSBzaXplIGlzIGFsc28gaW5jcmVhc2VkLCB0aGUgb3V0
cHV0IGlzOg0KPiANCj4gZmlvIC0tZGlyZWN0PTAgLS1pb2RlcHRoPTEgIC0tdGhyZWFkIC0tcnc9
cmVhZCAtLWlvZW5naW5lPXN5bmMgLS1icz00aw0KPiAtLXNpemU9MTZNIC0tbnVtam9icz0xIC0t
cnVudGltZT0zMCAtLWdyb3VwX3JlcG9ydGluZw0KPiAtLWZpbGVuYW1lPS90bXAvZjAgLS1uYW1l
PWR1bW15DQo+IA0KPiBmMDogTGF5aW5nIG91dCBJTyBmaWxlICgxIGZpbGUgLyAxNk1pQikNCj4g
DQo+IA0KPiBmMDogKGdyb3VwaWQ9MCwgam9icz0xKTogZXJyPSAwOiBwaWQ9MzogTW9uIEp1biAy
NiAwNTo0MTo0NyAyMDIzDQo+IA0KPiAgcmVhZDogSU9QUz0xNS42aywgQlc9NjEuMU1pQi9zICg2
NC4wTUIvcykoMTYuME1pQi8yNjJtc2VjKQ0KPiANCj4gICAgY2xhdCAodXNlYyk6IG1pbj01MSwg
bWF4PTE4MSwgYXZnPTU1Ljc1LCBzdGRldj0gNS42Mw0KPiANCj4gICAgIGxhdCAodXNlYyk6IG1p
bj01MiwgbWF4PTE4MiwgYXZnPTU2LjYyLCBzdGRldj0gNS42Nw0KPiANCj4gICAgY2xhdCBwZXJj
ZW50aWxlcyAodXNlYyk6DQo+IA0KPiAgICAgfCAgMS4wMHRoPVsgICA1Ml0sICA1LjAwdGg9WyAg
IDUzXSwgMTAuMDB0aD1bICAgNTNdLCAyMC4wMHRoPVsgICA1NF0sDQo+IA0KPiAgICAgfCAzMC4w
MHRoPVsgICA1NV0sIDQwLjAwdGg9WyAgIDU1XSwgNTAuMDB0aD1bICAgNTZdLCA2MC4wMHRoPVsg
ICA1Nl0sDQo+IA0KPiAgICAgfCA3MC4wMHRoPVsgICA1N10sIDgwLjAwdGg9WyAgIDU3XSwgOTAu
MDB0aD1bICAgNThdLCA5NS4wMHRoPVsgICA2MF0sDQo+IA0KPiAgICAgfCA5OS4wMHRoPVsgICA4
NV0sIDk5LjUwdGg9WyAgIDkyXSwgOTkuOTB0aD1bICAxMDhdLCA5OS45NXRoPVsgIDEyN10sDQo+
IA0KPiAgICAgfCA5OS45OXRoPVsgIDE4Ml0NCj4gDQo+ICBsYXQgKHVzZWMpICAgOiAxMDA9OTku
NzMlLCAyNTA9MC4yNyUNCj4gDQo+ICBjcHUgICAgICAgICAgOiB1c3I9MzUuMjUlLCBzeXM9MC4w
MCUsIGN0eD0wLCBtYWpmPTAsIG1pbmY9MA0KPiANCj4gIElPIGRlcHRocyAgICA6IDE9MTAwLjAl
LCAyPTAuMCUsIDQ9MC4wJSwgOD0wLjAlLCAxNj0wLjAlLCAzMj0wLjAlLCA+PTY0PTAuMCUNCj4g
DQo+ICAgICBzdWJtaXQgICAgOiAwPTAuMCUsIDQ9MTAwLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMy
PTAuMCUsIDY0PTAuMCUsID49NjQ9MC4wJQ0KPiANCj4gICAgIGNvbXBsZXRlICA6IDA9MC4wJSwg
ND0xMDAuMCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9MC4wJSwgNjQ9MC4wJSwgPj02ND0wLjAlDQo+
IA0KPiAgICAgaXNzdWVkIHJ3dHM6IHRvdGFsPTQwOTYsMCwwLDAgc2hvcnQ9MCwwLDAsMCBkcm9w
cGVkPTAsMCwwLDANCj4gDQo+ICAgICBsYXRlbmN5ICAgOiB0YXJnZXQ9MCwgd2luZG93PTAsIHBl
cmNlbnRpbGU9MTAwLjAwJSwgZGVwdGg9MQ0KPiANCj4gDQo+IFJ1biBzdGF0dXMgZ3JvdXAgMCAo
YWxsIGpvYnMpOg0KPiANCj4gICBSRUFEOiBidz02MS4xTWlCL3MgKDY0LjBNQi9zKSwgNjEuMU1p
Qi9zLTYxLjFNaUIvcw0KPiAoNjQuME1CL3MtNjQuME1CL3MpLCBpbz0xNi4wTWlCICgxNi44TUIp
LCBydW49MjYyLTI2Mm1zZWMNCj4gDQo+IGZpbyAtLWRpcmVjdD0wIC0taW9kZXB0aD0xICAtLXRo
cmVhZCAtLXJ3PXJlYWQgLS1pb2VuZ2luZT1zeW5jIC0tYnM9NGsNCj4gLS1zaXplPTMyTSAtLW51
bWpvYnM9MSAtLXJ1bnRpbWU9MzAgLS1ncm91cF9yZXBvcnRpbmcNCj4gLS1maWxlbmFtZT0vdG1w
L2YwIC0tbmFtZT1kdW1teQ0KPiANCj4gZjA6IExheWluZyBvdXQgSU8gZmlsZSAoMSBmaWxlIC8g
MzJNaUIpDQo+IA0KPiANCj4gZjA6IChncm91cGlkPTAsIGpvYnM9MSk6IGVycj0gMDogcGlkPTM6
IE1vbiBKdW4gMjYgMDU6NDM6NDcgMjAyMw0KPiANCj4gIHJlYWQ6IElPUFM9MTIuNGssIEJXPTQ4
LjRNaUIvcyAoNTAuOE1CL3MpKDMyLjBNaUIvNjYxbXNlYykNCj4gDQo+ICAgIGNsYXQgKHVzZWMp
OiBtaW49NjQsIG1heD00MjAsIGF2Zz03Mi4zOSwgc3RkZXY9IDguODUNCj4gDQo+ICAgICBsYXQg
KHVzZWMpOiBtaW49NjUsIG1heD00MjEsIGF2Zz03My4yNywgc3RkZXY9IDguODcNCj4gDQo+ICAg
IGNsYXQgcGVyY2VudGlsZXMgKHVzZWMpOg0KPiANCj4gICAgIHwgIDEuMDB0aD1bICAgNjddLCAg
NS4wMHRoPVsgICA2OF0sIDEwLjAwdGg9WyAgIDY4XSwgMjAuMDB0aD1bICAgNjldLA0KPiANCj4g
ICAgIHwgMzAuMDB0aD1bICAgNzBdLCA0MC4wMHRoPVsgICA3MV0sIDUwLjAwdGg9WyAgIDcyXSwg
NjAuMDB0aD1bICAgNzNdLA0KPiANCj4gICAgIHwgNzAuMDB0aD1bICAgNzRdLCA4MC4wMHRoPVsg
ICA3NV0sIDkwLjAwdGg9WyAgIDc2XSwgOTUuMDB0aD1bICAgNzhdLA0KPiANCj4gICAgIHwgOTku
MDB0aD1bICAxMTVdLCA5OS41MHRoPVsgIDEzMV0sIDk5LjkwdGg9WyAgMTYzXSwgOTkuOTV0aD1b
ICAxNjldLA0KPiANCj4gICAgIHwgOTkuOTl0aD1bICA0MjBdDQo+IA0KPiAgIGJ3ICggIEtpQi9z
KTogbWluPTQ4ODQwLCBtYXg9NDg4NDAsIHBlcj05OC41MiUsIGF2Zz00ODg0MC4wMCwNCj4gc3Rk
ZXY9IDAuMDAsIHNhbXBsZXM9MQ0KPiANCj4gICBpb3BzICAgICAgICA6IG1pbj0xMjIxMCwgbWF4
PTEyMjEwLCBhdmc9MTIyMTAuMDAsIHN0ZGV2PSAwLjAwLCBzYW1wbGVzPTENCj4gDQo+ICBsYXQg
KHVzZWMpICAgOiAxMDA9OTguNTclLCAyNTA9MS40MiUsIDUwMD0wLjAxJQ0KPiANCj4gIGNwdSAg
ICAgICAgICA6IHVzcj0yMy4wMyUsIHN5cz0wLjAwJSwgY3R4PTAsIG1hamY9MCwgbWluZj0wDQo+
IA0KPiAgSU8gZGVwdGhzICAgIDogMT0xMDAuMCUsIDI9MC4wJSwgND0wLjAlLCA4PTAuMCUsIDE2
PTAuMCUsIDMyPTAuMCUsID49NjQ9MC4wJQ0KPiANCj4gICAgIHN1Ym1pdCAgICA6IDA9MC4wJSwg
ND0xMDAuMCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9MC4wJSwgNjQ9MC4wJSwgPj02ND0wLjAlDQo+
IA0KPiAgICAgY29tcGxldGUgIDogMD0wLjAlLCA0PTEwMC4wJSwgOD0wLjAlLCAxNj0wLjAlLCAz
Mj0wLjAlLCA2ND0wLjAlLCA+PTY0PTAuMCUNCj4gDQo+ICAgICBpc3N1ZWQgcnd0czogdG90YWw9
ODE5MiwwLDAsMCBzaG9ydD0wLDAsMCwwIGRyb3BwZWQ9MCwwLDAsMA0KPiANCj4gICAgIGxhdGVu
Y3kgICA6IHRhcmdldD0wLCB3aW5kb3c9MCwgcGVyY2VudGlsZT0xMDAuMDAlLCBkZXB0aD0xDQo+
IA0KPiANCj4gUnVuIHN0YXR1cyBncm91cCAwIChhbGwgam9icyk6DQo+IA0KPiAgIFJFQUQ6IGJ3
PTQ4LjRNaUIvcyAoNTAuOE1CL3MpLCA0OC40TWlCL3MtNDguNE1pQi9zDQo+ICg1MC44TUIvcy01
MC44TUIvcyksIGlvPTMyLjBNaUIgKDMzLjZNQiksIHJ1bj02NjEtNjYxbXNlYw0KPiANCj4gRG9l
cyBhbnlvbmUgaGVscCBleHBsYWluIHdoeSB0aGUgbGF0ZW5jeSBpbmNyZWFzZXMgd2hlbiB0aGUg
c2l6ZQ0KPiBjaGFuZ2VzIGZyb20gMTZNIHRvIDMyTT8gVGhhbmtzIQ0K
