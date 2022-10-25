Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1E2C38A2D
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiJYXzb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiJYXza (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:55:30 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330144361B
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742129; x=1698278129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KMbD56KCJiVnA5raRV2X8X8bDxfnIIwAx7wqVNFkK+A=;
  b=BrH34cuSFcvy8sMe1VVbB5Etdci1ytZWGee2eDclgzZ4RDlk13LNCiHZ
   r27it/dJqhjYUsLJ1ZH51Mon6K79HNoF9bz5m5reSbFJEfcU9KAt9BNtd
   Df+7vScMnGsc9wSOLTChmDHFPD0ChLMUf3EFzMKNTyVOvJbqdBlj4sdlN
   qOHcxEnx3BYjmAgH/Gj7ngTm3RcpdSHpKVrjpfdk0KLWhIVxYbPWaTZz5
   GxoE17WejJXqkzB+RqpMu1w8q1uCyW+pYMW3U8r/bIij+2cjj/+eW0fw6
   z7IX1IY0I+Y209F+BxoU305E8IB4/TRDtCMI+BqLQlHwYQ89xkmbbjZwk
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="215099643"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:55:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltGzC6YhzTEbbvDJ/iqFGHW21TGyZ/EIhJUdnAJ2LFtA+k8T9BpZffE+e0FZAYeXT3QR0e2E0dMW2eWrrAzSXFA5o5s8uT5dEiNkOAANI9jILlRrjE6S1vVV1NbHhF5rVknHfsnLwjTfvit7QWLtb5JM6DnGg5E98OKiG3rZEAjeJXYJUD5CfPMUh8oejAcTmC9UI1hW9PsKt08XRv10xbpApB0OOYD9K1VK4Iwxx9r0Q+KWvMMvxysZdUO472RHGx3ohEzvHBrenq/AdAYZn5s82CHrOMX/7MqgT/ShesEn4ZFwGMUSfeA9zBhwH7bHBzwgFMESXgsung1YKT43OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMbD56KCJiVnA5raRV2X8X8bDxfnIIwAx7wqVNFkK+A=;
 b=DbOTTeV0rsL9TqwYkrt78YjBIF6mdh4bHiqocNuAnRaGCYl87FHTWLimjNTYRKRrldxVlla9Zh1Z570xRi5HBOVm6X7VyaSY/we/0YzjAHXly9kWYfstIyUfwipXut+9uKB59+YqhjBhkjHf58jQ5HpTEY0lmOG0isq7+Mdiz5ZW1C9Ytvj5sE3rKbArChKI6OBNbWjNV7krvTZlYELoDmMC6mwxVRkOaPnp74ZDFmrszmOjVmNQte/6nsrCr2o2GA+poOvsRtFiazKeC40afwO5axANYksOIihTCGBo8KIk1nAoYqH6d48v8fvPqBW/4f8miYhyO2qKN4xYbaYTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMbD56KCJiVnA5raRV2X8X8bDxfnIIwAx7wqVNFkK+A=;
 b=Td/iHVVArcvv1fS4E6Hw5ZBvQ2S5SIoyvd9qajHT8bwSVempjAs+19mFCI3cNIiBR2l8DBm1LVqSoTGCM97bo3g9eAaVwBAkFmGecJi5A58PKpS3gePgFYfn28Rb//BDgQIxyQ/AMDpO3BzcsOtBEhG3C2vgutw101/F+aKlF0c=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:55:26 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:55:26 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 09/11] t/zbd: modify test case #34 for block size
 unaligned to zone size
Thread-Topic: [PATCH 09/11] t/zbd: modify test case #34 for block size
 unaligned to zone size
Thread-Index: AQHY5RcvL4mfR94/JEOeZeIFW8ZmV64f0FGA
Date:   Tue, 25 Oct 2022 23:55:26 +0000
Message-ID: <3f7f6bb0543b5f85fd2d1623e29500c41f1a0e77.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-10-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-10-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: d9b52f66-b268-4e79-799b-08dab6e46385
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fGfLnMQUmRNcYWegahkodsju5/kS1Ozzfv3IbbE9seG+cI0urqgD1txVmtXetUshBUlFKr4JOMjZb0I8E4TI4hYGZQeiNIEwAYQFKYkK+FOy77Hav+XN78LIhjd+iSE5jsaWH91OZt+Z5/GHsZcXUG6RDaJcStKGw5DlIihONfcCmRC8w4ExItnebyT1YqKjQRhtU45gMCmmOa3r2qrt4IBcdDSaiE4Wvkz0ENDTtPp8Bzmd7YRnCRQiBF9Jv9Wen1RH0HaL5kjPnqYVpx+wVZPaMid9rwKzwjzTBARn03vckSDXn8+mJN+1DrRa74Q7peCuyJrVTVvTq3hx8ZOK8ahw3oqkvcqu9wvK0TKvWsdTcwxtCpXMzm0sTaT/M+bPcBolXgBqcvulnYaE4CatyMVblG5IMPDuBIuqHXi2Umt5yYFFzUDLP6n22+x+5MX0Qe5+jN//HJu03rqrCX0Lo0FBNn4OtSNOUBcWBj+VsioVBj6cGgGJMcSq13/7wksj52ygRtqbCyWIlL/npAJ5MULjwfqNCy2gq24gwK/bmczSh+eLpKIobDNIJr1CYAtWQU1vd2VBPlw395dg+9E9dO7o0HJcEfIHhPY8rnhfd2vD/Qpz+7iLeBgnXjCdd+g3AISa1YlCVZiOH6+1M1ZcyzmY0gNoGuF5Ptc4cHvAXrVrIlWG2t75VPBv/jR2bk9jO7MAn2hoXEFAMnmEWr2k/1ixCVNCw3Ej6bdgbCtFcNZSbTIrIw8aB+Kd6Sdf284OuQv8ZYoD6dIWHWacI4rfqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?endLQjM5UjFKU25NZi9pZUxkOWpsTVczelRNTmQrV0FwVWozZUcwUGJ2N0wr?=
 =?utf-8?B?Q0ZsUklheVNWcVdIdHkySnNmc0drcjl3b1p1N3UvblRSTVIzWEJiNnZHcjZr?=
 =?utf-8?B?MU51NVRxUXNKZS96a08wdDFOaTkyTkJEcXZSWmpGQVMrUGFCYnZGd2RRaWFo?=
 =?utf-8?B?QUpzNWVCVS8weVBxNmQ4RjVPTVdjY3VOSklzd3E4NUhxM0V3eWVIR2xvRGNG?=
 =?utf-8?B?ei9DeE1oTWplck1oaTY5MCttaStrL1NyRC8zcmlTQ2JRODZIVjV3R0M4dm9x?=
 =?utf-8?B?aXdycmR4eUVZYy9VelRrSGplUUxrZ0NzRDN6eXUvVTJWSzJFbDNDQXlVQmNq?=
 =?utf-8?B?d3BsZ0ROWXJxL0xDQnIxYndxcFluOWcvdGx2UUQ4YTFZRlFTL2RIa2lCOHFl?=
 =?utf-8?B?djVoZWlZVzZGK0ZYOU9CY2lpbElXeXVPa2VCREwwRC9nb0JLTkZIV3ZPNkZm?=
 =?utf-8?B?a1dZdzN0T2RsOHVBdG5Ibzg3VTdMUUhBbjQrdWZWSTVMZ0o5QlJPcWo2NUVK?=
 =?utf-8?B?QTc3eTZMMGN0UUdjVVVscGpHempYTHdiY2g3QUxnWGZRRFZiK3E0eCtwVG4v?=
 =?utf-8?B?ZmVGR0l4cDFPMjBNK2hKVlVINWlXdXI3ejNCTzdHd1UvMzc5a1JyYUNhbHk5?=
 =?utf-8?B?TzlkRXRaMEQ3M2JBcWp3Q3RoWjJEc0RTeWVUQlVHbG1HREZsNzRkbHN2MnNo?=
 =?utf-8?B?Y3FHSE1DanJLTHZyREVHdm5NcjZMLzI0ZDZWelpPNmNDZC9TQUNGRG9US0Jy?=
 =?utf-8?B?L3prNFZYOGw4YmRLTXFFbEwyTXFEQzNEbGIyT0N5UDN2OGlNRElXcUdTZmIw?=
 =?utf-8?B?dktaUVFtMXo5eGFQRlZjKzdEeE51YmM1cUNMQS9GYy83S0dPUGlyajRkU284?=
 =?utf-8?B?a285aXpwdGJpcjVCMnI4a0svem9nbnNOQ3FvdFhrd2FxSmVURnhLdTZoZmgv?=
 =?utf-8?B?Y0JHOFNmR0lHbWY1MjZqSjJ3cFhQejRYenFGaEFoWk0zNHlIYjNVcnhpOXdM?=
 =?utf-8?B?dHJCdEtYRS9hRlhES3FpbkVTNHZ3S0NsS3BSQnYwbmVRWGFBeVN0NDl2UUtK?=
 =?utf-8?B?N2psdy8vaDR1aUc0WnpmVmYwenAxblBnajU3aGxTT0hLOXdMZ0dpVlZreTc0?=
 =?utf-8?B?UXJIbVdiYVVsdFh2OUZTdDgrekk0MTZwakVmdVJPY1VacjZMcUtPc1NkOWpE?=
 =?utf-8?B?N1FyTUlqa09SL2ppdVBOSTdoeHpiU1VZRzJwQ3BBOC90VGhwdUdRZHJEUGFK?=
 =?utf-8?B?dzAyT3Q4bDJMRzJEM2RlNytDb1JVQ3NjZTJEYjlNQjNsRGZYZlZ3YmRYZFFB?=
 =?utf-8?B?SDZIMHZESjJSL0UwTS82UTdsQ0RqVnIyRVhONGpwL0ltK2psK01PR2xJdnZl?=
 =?utf-8?B?WVdZMzJabTdoQ25IOWRqWDBSbWNZRHVOWU5od0RMVkIwalRTSmZ4MDJFdjRR?=
 =?utf-8?B?MWIxVllGTjd3OEd3Y3poem5mcVlIWHU0bXBkZGtUajRBOHcyVk0welBxeVk1?=
 =?utf-8?B?TFVFR0dITVp6WVJZWWVDUENBTkVaZW0xQitKeUpCK1AxWnpaRGxLVDZwM05o?=
 =?utf-8?B?eFdtaWdMVVY5QklHVXA0dVlHWlhHMXBLbFNrMDRXdmpUcy81T3JmTHZWVWFq?=
 =?utf-8?B?WlFMU1BBb25pWnRqVEVuWGFQblhYTllMNHR2TFlFanNKNDZlbWdwa2tFc1ht?=
 =?utf-8?B?cGhyWkg3UFZtZnhENHp5dnZzK0hNWTkvM0ZxSGtBK21rbmpsY3VvTXFjcUVU?=
 =?utf-8?B?Q2tVZVhFVmdBZzBSVUszQit1Mmo5cWtMQ0I2T0hDSENSS0JTZmtuczJwcUpT?=
 =?utf-8?B?KzVpcndBRTNUTUl6SWdwU3BDZ3hYdmRQeERyUnBVN2lmdThoOHhCUE5pS0J5?=
 =?utf-8?B?MjFQdUovaUQ3UGZLYzcrOHNyOGZDTStUaEMyKzU3ZlNGSHVzZ2xlY0N6VnNQ?=
 =?utf-8?B?dzRMQkVwOFZHSzlaUFc5SENPQnR6clVGMmFlTjBNNHFhRnJwZWdhSnNzeWNT?=
 =?utf-8?B?UVU0VFY4a3hjb1ozeWJEcnZTbU1YeXNXU2MrRmFqTkE1cit1NGI1Ykw3d0w1?=
 =?utf-8?B?ZVd4blIrTmVxSStkVlY2b20vdHhLdlZHNk9IQlhYOUZ0NnNHOVpjUDZ1SFV6?=
 =?utf-8?B?TEhsM1lqbGJDM2FHSTdTTmdYRkRaeWx6TUVmZkpRWDNtVDRMOWVDMzBOVXBR?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54257EA9A0113C43B965C2CDE77D3783@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b52f66-b268-4e79-799b-08dab6e46385
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:55:26.4524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmju+Y7Jr/Es+4dc6BhtzUly2ybG9ip/QBeJLntuBVxWzhk5zsYkuBdS1JrrCQISgiStkMS16s+En8qfbzdLxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gVGhlIHRlc3QgY2FzZSAjMzQgY29uZmlybWVkIHRoYXQgdGhlIGJsb2NrIHNpemUg
dW5hbGlnbmVkIHRvIHpvbmUgc2l6ZQ0KPiBpcyBoYW5kbGVkIGFzIGFuIGVycm9yLiBBZnRlciBy
ZWNlbnQgZml4LCBub3cgZmlvIGlzIGFibGUgdG8gaGFuZGxlIHN1Y2gNCj4gYmxvY2sgc2l6ZXMs
IHRoZW4gdGhlIGNoZWNrIGZvciB0aGUgZXJyb3IgaXMgbm8gbG9uZ2VyIHJlcXVpcmVkLg0KPiAN
Cj4gSW5zdGVhZCBvZiByZW1vdmluZyB0aGlzIHVubmVjZXNzYXJ5IHRlc3QgY2FzZSwgY2hhbmdl
IGl0IHRvIGNvdmVyDQo+IHZlcmlmeSB3aXRoIGNvbXBsZXggd29ya2xvYWQuIEl0IHJ1bnMgcmVh
ZC13cml0ZSBtaXggd29ya2xvYWQgd2l0aCBoaWdoDQo+IHF1ZXVlIGRlcHRoIHdpdGggdmVyaWZ5
IGFuZCBibG9jayBzaXplIHVuYWxpZ25lZCB0byB6b25lIHNpemUuIFRoaXMgdGVzdA0KPiBpcyBz
YW1lIGFzIHRlc3QgY2FzZSAjNTcgZXhjZXB0IHRoZSB2ZXJpZnkgb3B0aW9uLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3YXNha2lAd2Rj
LmNvbT4NCg0KTEdUTQ0KDQpUZXN0ZWQtYnk6IERtaXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWlj
aGV2QHdkYy5jb20+DQpSZXZpZXdlZC1ieTogRG1pdHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNo
ZXZAd2RjLmNvbT4NCg0KPiAtLS0NCj4gwqB0L3piZC90ZXN0LXpiZC1zdXBwb3J0IHwgMjQgKysr
KysrKysrKysrKysrLS0tLS0tLS0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMo
KyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdC96YmQvdGVzdC16YmQtc3Vw
cG9ydCBiL3QvemJkL3Rlc3QtemJkLXN1cHBvcnQNCj4gaW5kZXggZGViZTM3NjMuLmUxN2E4MWRl
IDEwMDc1NQ0KPiAtLS0gYS90L3piZC90ZXN0LXpiZC1zdXBwb3J0DQo+ICsrKyBiL3QvemJkL3Rl
c3QtemJkLXN1cHBvcnQNCj4gQEAgLTgyNiwxNyArODI2LDIzIEBAIHRlc3QzMygpIHsNCj4gwqDC
oMKgwqAgY2hlY2tfd3JpdHRlbiAkKChpb19zaXplIC8gYnMgKiBicykpIHx8IHJldHVybiAkPw0K
PiDCoH0NCj4gwqANCj4gLSMgV3JpdGUgdG8gc2VxdWVudGlhbCB6b25lcyB3aXRoIGEgYmxvY2sg
c2l6ZSB0aGF0IGlzIG5vdCBhIGRpdmlzb3Igb2YgdGhlDQo+IC0jIHpvbmUgc2l6ZSBhbmQgd2l0
aCBkYXRhIHZlcmlmaWNhdGlvbiBlbmFibGVkLg0KPiArIyBUZXN0IHJlcGVhdGVkIGFzeW5jIHdy
aXRlIGpvYiB3aXRoIHZlcmlmeS4NCj4gwqB0ZXN0MzQoKSB7DQo+IC3CoMKgwqAgbG9jYWwgc2l6
ZQ0KPiArwqDCoMKgwqDCoMKgwqBsb2NhbCBicyBvZmYNCj4gwqANCj4gLcKgwqDCoCBwcmVwX3dy
aXRlDQo+IC3CoMKgwqAgc2l6ZT0kKCgyICogem9uZV9zaXplKSkNCj4gLcKgwqDCoCBydW5fZmlv
X29uX3NlcSAiJChpb2VuZ2luZSAicHN5bmMiKSIgLS1pb2RlcHRoPTEgLS1ydz13cml0ZSAtLXNp
emU9JHNpemUgXA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtLWRvX3Zl
cmlmeT0xIC0tdmVyaWZ5PW1kNSAtLWJzPSQoKDMgKiB6b25lX3NpemUgLyA0KSkgXA0KPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA+PiAiJHtsb2dmaWxlfS4ke3Rlc3RfbnVt
YmVyfSIgMj4mMSAmJiByZXR1cm4gMQ0KPiAtwqDCoMKgIGdyZXAgLXEgJ25vdCBhIGRpdmlzb3Ig
b2YnICIke2xvZ2ZpbGV9LiR7dGVzdF9udW1iZXJ9Ig0KPiArwqDCoMKgwqDCoMKgwqByZXF1aXJl
X3piZCB8fCByZXR1cm4gJFNLSVBfVEVTVENBU0UNCj4gK8KgwqDCoMKgwqDCoMKgcHJlcF93cml0
ZQ0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGJzPSQoKDQwOTYgKiA3KSkNCj4gK8KgwqDCoMKgwqDC
oMKgb2ZmPSQoKGZpcnN0X3NlcXVlbnRpYWxfem9uZV9zZWN0b3IgKiA1MTIpKQ0KPiArDQo+ICvC
oMKgwqDCoMKgwqDCoHJ1bl9maW8gLS1uYW1lPWpvYiAtLWZpbGVuYW1lPSIke2Rldn0iIC0tcnc9
cmFuZHdyaXRlIC0tYnM9IiR7YnN9IiBcDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAtLW9mZnNldD0iJHtvZmZ9IiAtLXNpemU9JCgoNCAqIHpvbmVfc2l6ZSkpIC0taW9kZXB0aD0y
NTYgXA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIiQoaW9lbmdpbmUgImxpYmFp
byIpIiAtLXRpbWVfYmFzZWQ9MSAtLXJ1bnRpbWU9MzBzIFwNCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoC0tem9uZW1vZGU9emJkIC0tZGlyZWN0PTEgLS16b25lc2l6ZT0iJHt6b25l
X3NpemV9IiBcDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAtLXZlcmlmeT1jcmMz
MmMgLS1kb192ZXJpZnk9MSBcDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAke2pv
Yl92YXJfb3B0c1tAXX0gXA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPj4gIiR7
bG9nZmlsZX0uJHt0ZXN0X251bWJlcn0iIDI+JjEgfHwgcmV0dXJuICQ/DQo+IMKgfQ0KPiDCoA0K
PiDCoCMgVGVzdCAxLzQgZm9yIHRoZSBJL08gYm91bmRhcnkgcm91bmRpbmcgY29kZTogJHNpemUg
PCAkem9uZV9zaXplLg0KDQo=
