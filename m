Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CD2C38A2D
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiJYX4u (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiJYX4t (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:56:49 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB157C1DE
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742208; x=1698278208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GZSPv/X55nGclaU7ZztPJBbE52IcrPhqSu+knwTJVHk=;
  b=F6zlUhREBDmbxh3EauVwhPBdgPnc2LudDO4O0zLktu+ODvD/EEvJjolS
   dfDfZjYmxkXO2SPsi/E6N/A5MkyJev29gbQM9FRE1XEcg6tAWYKKoipXl
   cl4ESbsjm4Q+EJNW21Xc/Euw5bpav6kAMq26JOPa9gUNG6iYpbzW0N2l+
   w6V/GtAu+QlwzXVxJqprlCGEt7MkY6AnxuRUghzYL6DXVlNIqpy1CdEOF
   IOodrPAZfM32b++OR8tc4bNGqLX9kmfa/OA8Ol7hubyWzQcYyEmaZhC8A
   gOJvRxM74CN5RCyCILzUE5U5YnII8rjs1wvrYoWEXGlM0mL4L9y+dLsWD
   g==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="326842832"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:56:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N930ZAiNjuad2SXTxA+TdHPq6OLLmebaAlSQ0hq9CWONaShUGFOqj21LErL/3u5rdW9up6O0GRVI3JxzO1Qu0+KOriIpX0Mftysp1f+1d39juhPDd8DVBeSAPX0hzqu6KHwbhjiS/Wz7TF8KbOT7xdHjdOXAAdlGI9z1TCnp1/8Fb7514SRkcih8E1J8Akh4R8Cqgo5cclNl77YhluS67jX8BNe4TvY+M7kh34LuRvk+Z7Hw/YtKk7dli9Qyt1zLN6h2xbnonQOIsQ+WDjK3xx2g+WPNMiKyboy2gRtSC0nSTqzPPbQm+WKqUI4bBzrRR4P6UDmv3ZOebjSbMtnu0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZSPv/X55nGclaU7ZztPJBbE52IcrPhqSu+knwTJVHk=;
 b=Mp330Dg+5Z+NuFSOPH0B6YokGsFGM5FnaQ/L6x6AV0mvEbI8fVlxdIKjL4+GKdASBNr+8rEzlvFaYcI3E1uQ3blAd6sRr2ZGeAmkXnTiCAyK7rjpPnxzhjV3MDNoVPbfgbFsEPiLB645tQ1Ts5SsvAAX09o8zfjyluDXU/4yVgEWyAoj2F3IYkC0T0cMsT/r9OFgbJ7NMMNp8uwlCS0HhX+ePsNU2qqJVXVy9x4P8+F2Om+RP7oaeCOX35j4Hp+TeyqXnzhL0VqkGW/NDWWBDJtPH45/RgrdywPK1Sa9G4boPyUB9PuzcrLkp/BVaq/dIU5URoV+71Kd3m95i4zZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZSPv/X55nGclaU7ZztPJBbE52IcrPhqSu+knwTJVHk=;
 b=RUxWManCn2PeHAlMJKCfO/0UJkJkzJ39CJ7gWqMozBEDDY56718Y726F4KembPvjhKmSZE88trd7+FvNmI56OZx+WU+dyXU1mLCjp5j6SSAG6SPnkG4UlNpTNhjMEwRK/uNxzIOhlqUPrqjw0dhIgFHupIPrwyJKf0h6KzrybdU=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by MN2PR04MB6125.namprd04.prod.outlook.com (2603:10b6:208:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 25 Oct
 2022 23:56:45 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:56:45 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 11/11] t/zbd: remove experimental_verify option from test
 case #54
Thread-Topic: [PATCH 11/11] t/zbd: remove experimental_verify option from test
 case #54
Thread-Index: AQHY5Rc16aFQDIRvlEa2utz+MRuHkK4f0LAA
Date:   Tue, 25 Oct 2022 23:56:44 +0000
Message-ID: <50d574b29488404c745962b1c0009d2c2a5de430.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-12-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-12-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|MN2PR04MB6125:EE_
x-ms-office365-filtering-correlation-id: 61b3491d-a93f-4788-81df-08dab6e49272
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GhfeCVpNMLxTn70LlVTjCcRe9RhEqka1Ur7yhqVBqrDHHA59ug2Wo0Y0opy7h+xPvRezXpNL7IpDTzPoEE3imKrCc9alLAI8ZT1bOq0MyRON8rOIji+/XBnL7iHfW/Py3CGZT+PDut8ZfR8SwUyHhKPUMm2x+msbXXZ1TWUk4Lv9+JS45y1adSwjFt31OmAABkgg35TpDx78wCCuxtr+nyH1TcCHjx9WJ+InO2bJcxGqZDRnsKueQNrnB9efOfHJBA9PJ25D6C66PU+fBWu3zxtgBrpiwCL6XLf54xeqTxw/L/J6KGa2XLcHw81GTxrRucGJWizqXtimwBYZ1/3akQT7mbfU56xxVeVNCO89DiKwrUHIwzziwVpwKPowioSHSTJLOJZR+WXRWgYTA2GSB8BVWAGvG7LKITQnEuThvgCJOMO228X25G4MbJV6OVf9Cm67+KbIZ3QuNB3IDUgRexAtO6X9JAiYHW6xG6faBTrOJu3XiyAjQqbsQmWd/B5fQPEZ9AVTOukAtO2ehCG04jlQlhyMtLuTNUZPcczBWMnv33htIULS0bxSoOQ9sGppC2OCKluAWaywcXiaavM2rSTQvH8+fiXbcNALM3G8iAsp0R68D5H8VUK5mlAfbuKngi4FC/YIv5Mw4ZwENAM3D19L0zIpVSLOODU8nGuK0RkApcfBkuJyJYY6JH/9RqJav19cPpnHnBfp8K6mgA11qpKbutZmCyh2vT/a3qg56L9ETLBO5uNiPO+kqtD56/i2Qa+yiptMoPa3YxDLjVkC1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(83380400001)(2616005)(186003)(2906002)(41300700001)(26005)(110136005)(54906003)(36756003)(71200400001)(6506007)(6512007)(86362001)(8936002)(5660300002)(82960400001)(38100700002)(8676002)(64756008)(76116006)(4326008)(91956017)(316002)(38070700005)(6486002)(4001150100001)(478600001)(66556008)(66446008)(66476007)(66946007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE8zejllWEwrelVZRHpjTlFiRjZrVCtZNFgyWU8wU2dlanY2R041RXhqZ3gx?=
 =?utf-8?B?cGlQMmsrTHpvNnA3aHIrYmFWdFp0VUVvQ245UlQ1dXBacDBPMEtQVUZJRVM3?=
 =?utf-8?B?bmE3L1E0WWZoRXRKckg0TkNzMWNVVEFCQ0srcDBRMTA0WThKbHBLdFVHeWlT?=
 =?utf-8?B?elNnK1pYdEZLWVgrNWxtZ0RGWTl1YmlKTk1sN21qWUlIa3dQZFNYZlFtNzU5?=
 =?utf-8?B?Y0g0dDJzMzhkWStqMjBRdTJ4RldjRlAvQmhZUERUQnp6cHhLaGRoRVI5TWp0?=
 =?utf-8?B?cG5iYWwzMFN4RnRmYlhsRVpCS3J4UnBRUUVnWFJvRitPcEhyV2NLVS9wRHpJ?=
 =?utf-8?B?WUhBQ09ydWJkbDRuSFdRQm01ajJmb250VEpsa3FoS1dOeDJCeFhqQkswTDFp?=
 =?utf-8?B?UGR1UGxGZ2VSTWRPNmRieEhuUy9tTS92NWVldGhOZVk5cUpCUVdGY2p6eVlD?=
 =?utf-8?B?NyszcWl3UHg1ZzM0b0RocFdXRE5UY0UwcFZtWmxReFlyZFhpODBpUjhlSThn?=
 =?utf-8?B?N0hDNkxPL1p6WkNMZGJtN3VjZDJXMDY5U0ZUL3lDbWVSekhrOXJoT3huUFpJ?=
 =?utf-8?B?c2lMbWpFaTQ1ZmwzRENPbHNMdFZPYUZicVhEVDBhUktGWmVyN3JQcDZOdURl?=
 =?utf-8?B?OEpDR1FWZEJRL0FJclgwWFNsZ1FIUnZoMjM5bDFkU3JHTGR0VmZacE1Fc21M?=
 =?utf-8?B?QWFzQ1hTWmRtVEFXYzhsb0JqM2h4YzJzaytmRjRoSW0wSmYzWUF0TWlkNVQv?=
 =?utf-8?B?WmJ2cnJhS2ZPTVRTWDAzNmR0ZTFoUnB5SmludG05MGx6cUoyYjBuZDNHNlZ5?=
 =?utf-8?B?cmxFMDl3dWF6eWtWQlJ0SklZNm96MlF0U2hab2o5ZWY5UEVWb29zTitkcVBB?=
 =?utf-8?B?Uy8rKzRQZXZ4WUhhcEpYSng4L3VxY1R4TUtLWS9ibGoyR0lDNitjdmsrc0tE?=
 =?utf-8?B?OUE0bDZuazlTK011NGFjdHJlbFVYOEFVYmMvQmxTbldaOE51TlNuM1dwY3dq?=
 =?utf-8?B?bnU5MVBWT0w5djRkQWdwL3FrMjVvUm1RMHR5SGRKMzdxT1lSMmoyT2EyOGZl?=
 =?utf-8?B?L2NycWR1UG9sZ2oxazFDRlZYNUM1MG14ZlFJN243VEc1R0ZteUszaGJHY2dT?=
 =?utf-8?B?cWpTTklWMzZZVzh6MFdUTWpLdGZnZkJaZDdJSmJWb21ycmdDWFVUZm96cTl1?=
 =?utf-8?B?OU1jS0MrbmxJOVRtbVFMSVV6WHdia093dHc0U3AvNFEwanpoWHdBWXNMS0VC?=
 =?utf-8?B?bEhtVWo4WkRYREZDbTI3MFhrMjZTVTFRRVBKeGd1U1VFQWlpaU0vVTdaMzdZ?=
 =?utf-8?B?czk5NWhEamcxWTlVQnlSbDNabnduTDFwQW9DNTQxM3pCTTYxc0hFeHZoV3h0?=
 =?utf-8?B?TCtUeVI5NGtwd1VTUXNoenlZL2lHWUdTclNJZmVGN1pTRTV5UlJlWGJiTGhp?=
 =?utf-8?B?U1d0VHZ4OWs3bXZKRUNMeVZsd2p4a2RoN2pmb3BNUlZRb05CWE91Nm4rV1Bm?=
 =?utf-8?B?dCthbEFIVVYvNlR4cnVvWEhIaGVaYVlqQzVCc2hWdnZFaVZZWThrWW9ZbmhJ?=
 =?utf-8?B?dUF4czZUZHFpMFVyNlpTaDIxNC8yd2JNMkkwTDF6WDRQVyt5dVRSbXIzMk5K?=
 =?utf-8?B?dzVQMnVqN0QrM1lyb0F5M1B2aUVnSTM3OVBOdWJFVFNValNqMjlTQzBmSkRD?=
 =?utf-8?B?MjB5QzdTWEIvNkZNNWRIUlBzSU1wUXNaN2ZrUUlEbEV4UUwyVUpKTnNTSGw5?=
 =?utf-8?B?WUVqWThXeVZVK0hITksvVi9FcGJ0dGczbkxhK0N5NCtSbzd6ZzVVNWozY2lj?=
 =?utf-8?B?L2c4NWV6NnA5cFFoNkJPKzd6RHNodUZNS1cvLy9uN0FJbE1MS2pjaklnNVF3?=
 =?utf-8?B?dVhMbWhlbnJVOEZQamlmMHlEbWVacHFtK2YyMjJrMFF3azRqQitITVgzYktT?=
 =?utf-8?B?NnRFUFcxSlZScmU0STdIclJvdlZ0TjEvWXhQb3lHajdkUlg2Nnk3REJVbWpu?=
 =?utf-8?B?STJCNnFzSjBIMEtDdlRXSmNNUWZ6dE1iMWtGUTFxT2pUWklvYnpGb0c2azhh?=
 =?utf-8?B?aTBldDBoblRuY1Bsb0d2KzE5TmtyaUgrbW1WdTVwbmwzbG1yM1VRMVF1NWsr?=
 =?utf-8?B?Y2hUR1ViYzNsc2VaSlY4MVBBQk5ZVlRCbHRFanlST3hXWXRZRklBbWM4OVhu?=
 =?utf-8?B?SUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CD57594A2731B48B02B7C6555FF618F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b3491d-a93f-4788-81df-08dab6e49272
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:56:45.1498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gS4nffS/akAAM6INYJXIstm+w6lk4fCAjv07DR4E73S9HvqfbkmIygZEJcuta0eF2ulQRvaut4TWctpv8jJuSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6125
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gVGhlIG9wdGlvbiBleHBlcmltZW50YWxfdmVyaWZ5IGRvZXMgbm90IHdvcmsgd2l0
aCB6b25lbW9kZT16YmQuIFJlbW92ZQ0KPiBpdCBmcm9tIHRoZSB0ZXN0IGNhc2UgIzU0Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3YXNh
a2lAd2RjLmNvbT4NCg0KVGhpcyBvbmUgbG9va3MgZmluZSwgYnV0IEkgdGhpbmsgdGhhdCBhIG5l
dyB0ZXN0IGNhc2UgdG8gY2hlY2sgdGhhdCAtLQ0Kem9uZW1vZGU9emJkIGlzIGFjdHVhbGx5IHJl
amVjdGVkIHdoZW4gc3BlY2lmaWVkIGFsb25nIHdpdGggd2l0aCAtLQ0KZXhwZXJpbWVudGFsX3Zl
cmlmeSBuZWVkcyB0byBiZSBhZGRlZC4gV2l0aCB0aGlzLA0KDQpUZXN0ZWQtYnk6IERtaXRyeSBG
b21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5jb20+DQpSZXZpZXdlZC1ieTogRG1pdHJ5IEZv
bWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2RjLmNvbT4NCg0KPiAtLS0NCj4gwqB0L3piZC90ZXN0
LXpiZC1zdXBwb3J0IHwgMSAtDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS90L3piZC90ZXN0LXpiZC1zdXBwb3J0IGIvdC96YmQvdGVzdC16YmQt
c3VwcG9ydA0KPiBpbmRleCAwZTE4NTk5Ny4uY2U0YTU5MTYgMTAwNzU1DQo+IC0tLSBhL3QvemJk
L3Rlc3QtemJkLXN1cHBvcnQNCj4gKysrIGIvdC96YmQvdGVzdC16YmQtc3VwcG9ydA0KPiBAQCAt
MTE3OCw3ICsxMTc4LDYgQEAgdGVzdDU0KCkgew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoC0tcnc9cmFuZHJ3OjIgLS1yd21peHdyaXRlPTI1IC0tYnNyYW5nZT00ay0ke3pvbmVf
c2l6ZX0gXA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC0tem9uZW1vZGU9emJk
IC0tem9uZXNpemU9JHt6b25lX3NpemV9IFwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAtLXZlcmlmeT1jcmMzMmMgLS1kb192ZXJpZnk9MSAtLXZlcmlmeV9iYWNrbG9nPTIgXA0K
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLS1leHBlcmltZW50YWxfdmVyaWZ5PTEg
XA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC0tYWxsb2Mtc2l6ZT02NTUzNiAt
LXJhbmRvbV9nZW5lcmF0b3I9dGF1c3dvcnRoZTY0IFwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAke2pvYl92YXJfb3B0c1tAXX0gLS1kZWJ1Zz16YmQgXA0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoD4+ICIke2xvZ2ZpbGV9LiR7dGVzdF9udW1iZXJ9IiAyPiYx
IHx8IHJldHVybiAkPw0KDQo=
