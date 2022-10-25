Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3569C38A2D
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiJYXzs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiJYXzr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:55:47 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC605F990
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742146; x=1698278146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sd//8hGhJGROG3M46+emLuQT30Nr0ARsyBuoxOU5DCU=;
  b=Y3XL8ubDGN7A5KHBM2uGQLK0QJub/oMtO5WHOlP09Kzf0NEGuYUXdRha
   R2blzzW9WuOkFXT0GXgneNbgr0mB1+MkRKbKwXwfIVuouM3K+OjuPmmlz
   llr+OHcGK0Htlkxm9i0Rdd4Wyh4MSCy5zm3kzF48hF0vAjFCohhi708wx
   XiFT4lSGDXQTmaDgJqB30i5eCup5+JxW0xL3hDqyU3Ts6RH/ypTKgh4gD
   cmVTG2JaCoeLFBZBFUK1JAFPITe3ZE+l+Qs8lTnu9myHPiAXGdA6EfDWj
   ehuKmQGjEg+en+UauQ/EtlSk6con0+dLG6wzuH6SMhg7o7Ex3juYKAxIy
   g==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="326842761"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:55:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chW0STf12P1yhEqthWvSNtf4Qs4s/2XE0cpDukYB3DXzP06BI0fy+xvP9k4VNPDCzue+q4qLsi6ycAlLZ6xRX2xeyHJZagQ0HakT47HFgSq4/0OLNnsVAZGq0qT+btZKvuUhg2sye6+GV44jXpyf12EaE4R/w/IUEi+b/1sWKE1cY2LKn1oOz+YOxg3GRkgOXR7sphgecPRcllBX2hyyTFhYOkysTtop7sMSDBRyamhbnjP0ZM2S8hHTNu++K7vjy3Ac7Yy5x57tu/bimgn3+77cwEhupf4KLL1Y+LvLkeFWict9p+4szqceJ2qu5U+uFjb31q4yKzhPFI1RC4baqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sd//8hGhJGROG3M46+emLuQT30Nr0ARsyBuoxOU5DCU=;
 b=PnDb0meblvhelyH7AHgm5gvFZtqiBwokEW+u+zz5LrsP5arg29sLXclADK0p8v9IdejQRZaTKInzt00/t5Lh/7h5SYp0K0rG/IQY8HFSj6Ys+MwczCtV5RFZBpkqqePtKjZXk29X3AFsoGbH5QMqigmg3Dpovn8b5T/Jn/R7fucYYPgMTnCV1gP7Y+MilVmm+wqekRoeDSN55WtVyRV02ysFlwjiNWymkmg1ZetTzTfyGlz93QItW03zpYJiUpAB5fLStDBM4rVRYxn+mQxp3+4c8HaCAQxRwc3xY75MH3dBXF1IWlfynOYQYqdOtbqbkxtxUx+xse+DkaR6EKudrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sd//8hGhJGROG3M46+emLuQT30Nr0ARsyBuoxOU5DCU=;
 b=sE3SpZloEkPLhR4YrJZnfQPSYfd0GyiuVGsdd5ZlJNX6O1eRHSmrbQjpqNOlGYOdBgVuOpiRKi8bptrsJ8NPYKyWChx/DCgvlJJPcVzkc2Yw/4H6CT2bQoCRuxoZQYwT28dqlwykp+GjZU3UnC+XLoiZn2mL7GTsgTIVw3nhhFU=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:55:44 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:55:44 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 10/11] t/zbd: add test case to check zone_reset_threshold
 option with verify
Thread-Topic: [PATCH 10/11] t/zbd: add test case to check zone_reset_threshold
 option with verify
Thread-Index: AQHY5RczFoPMOlMy2kOYfmsEtjLU664f0GeA
Date:   Tue, 25 Oct 2022 23:55:43 +0000
Message-ID: <b7a520f1c48d49fa6849668c783a9750660dbbff.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-11-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-11-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: 4dcb8959-ec73-49a8-913c-08dab6e46df3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TyekvXCPxUTeNFh8DtpbGW0nTSD81jhUG6IDlgMqnY6Gtd/JJX122Zw+X1LX+UaZOuo3+nGSHQc3lWcqq4p1gXHRDV2k65KmNZcDpnL+mxEUBfe9+qcLgu9YlvYBnGjQwtbqHKZiZgHwDxH4vEALEYZe3t8aFHUbAfQL5CB5yrifAKz9EwG7f/QDKRtEpMfK93y2eTfMGd01Kwvvrh/ejkjzyEQRFzbc3SGZAkH5PZe4G18ThdhnkRMmbcrNXT78MjtsIoTR4VhAdp5ce2MY5i8UvQ+0DLsNPl39RAtqmyohONlrKSpzWHBPBqx9q7VvD2SlSiXCNpLNSJIQ6zJvHlD59UBMUFNg8ovWGMOpO6jURV6XWNwbH1Y4UXeZib8ytn/EXQOYrWPpfbshTDtAnedt7ttX96Uz5RP1QB8dEoMkMDRJ6QjjZlgk2CGO6BthnAEeOlbH6RvftKNcJupfjepZCqLmRCkvXFhGRDqleVoue+WKWFsERyN2iayr3wt6N5cT3lPfG9TMU2dT78zBENI4whM14IHcFA3zXgEoO+i2Kirw+PpwNiSRR9cDqdDD9q2XGaetn7JQ+KoWeEomooDcO1Fg7sPOzTYkRdzq3yMVQh6ZzAUy/Rdq8bp93cflNpmTYlX8DlT4bS3mJxN9Pspo4L5fQA8iM1Hyvch443QMfVgt97lVAKY8OfNrNgSMchOTAtfZnEE72AYtb3isRpy16XJEwEu/gWxGTREmCMHW7cR/Qy7QWMcXd1hjRxiAU8+20/JjqI/ZSi+laTA2aA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(15650500001)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDFrNHF2bk56TUtxR3ZqclNsQ3h5ckRrUmpuZ1NiUlBZbGVxU3p3N3dMMTlv?=
 =?utf-8?B?cnR2eXA5Zzg1Y3hERkVOS0V3ektWVXY1T3dsazhMODljTzA0SG1CQ1RZVkw1?=
 =?utf-8?B?dkxQeGN6L2tyclpVS0FXdC9qaWQ0c3FqSXZjSTFMejFEZGZsSWJ4SEtGcVht?=
 =?utf-8?B?YlQzMFRBM1RtSTBpdlpBOGR1UWlyT1U2RlZoQWN3Q1VMVmFVM200cFZMQk1T?=
 =?utf-8?B?OE1FYWg2N2RjbFRZVFNhRlRNQWhnZzFaNldRQUFnNUVYdTZKUzNyTzFIQUNR?=
 =?utf-8?B?cTBaQ3NhdWJlVTBXdUZkN01SUlZsN1dRaGRESU1GVytzclE0WU93UDJVNGc1?=
 =?utf-8?B?SEtUWnVyY3dHN2FUTG1lcEE4WVVBTFV2VjIvd1dSenFpeHJsc0xYMm5pSmJI?=
 =?utf-8?B?K1QrRnhRb25BVHJnOGVja1JxV3pyNGVleEtuOGhNMkZrZVBQM095Mksxd3F2?=
 =?utf-8?B?YzhXbFl6WDN2TUc0N0RTaWlLcjBYbTdqYllhSWozeC9vWG5XNllYcUw1QmJt?=
 =?utf-8?B?UHVaRzFMY25EZHAydlAyWmxEVncvbHV3cUd2TmxwWCsvNHFoMVFYNXFsYUIy?=
 =?utf-8?B?bkRBWWxiZG14WVNFbnJDanEzZlZhZElQYUhTaU1uSTJZZHU4VHI5ekRZbXR5?=
 =?utf-8?B?M2dlallIa2kvOTRGOEhZdm1uVTNnRVE5K1c3dHdvaS9ML2FrR3haTmVQY3d0?=
 =?utf-8?B?QW5oS1A4LzBxRjRPZWdxVkV6dzcwc1AzUHNMa0Z4Wll1MjhWOGlPZHF3Z1Fr?=
 =?utf-8?B?Z1VpMXlBSGpyUHFVdkoydEFrZHJEN01IWWI3VFRsbndPaG01UHJEM2J1aWlx?=
 =?utf-8?B?ZEY2cU1YeXJzQW5IZmkzaGxZY25DNWxRc2lxSDhucnVoQUJCQjhyQ1ZXb2tJ?=
 =?utf-8?B?UUlJTjFtRHpkUmErVlRpS0czSHl4NnZtZG1DNUdydG9kOTlrNTZwUm5aUmFB?=
 =?utf-8?B?TmYrSkkvRUlZQVg1REVQbGRnenU4WHNGTjJ3aThnZWlONStIQSs5ZWovamtN?=
 =?utf-8?B?bGF2cVo4TFRKWHF1dzFXL3k5L3Z2QWp2ZzZvRHFHbkhyTmZRRFVmVytNcFBI?=
 =?utf-8?B?NmhtdXRwTk15N1pUNVowMzNNYjIrUm5rRUd3eVNnREJpdCs1NWhjQjRaYVd1?=
 =?utf-8?B?enZZVFkxYUQ3OVIvVUxGWWFJNWJOaFpzUG1kYjRpT0dCRkNQSko3WmhXcjYv?=
 =?utf-8?B?elhnZVlCeHRocUdkN05telZra3F5ZnpvUVJlUXdFZlk3OGlvd3BxQUlsU05t?=
 =?utf-8?B?NUVZckp6ZEhwRDFEUDUycitablpSQnVObEdEbit3ZHdwMVZwZjVjcXptaFZy?=
 =?utf-8?B?MnBHK1psd0RsRjAyU2ZVbEUvRUdMalVkaVgwN0VndUtERmxVTnI5bngwd3Q5?=
 =?utf-8?B?MiszRTJMS1NaK2EvOC9tTUZxVFEyV21QcHpQMEpLV1I3N0VIOHlPUGRjWVQ4?=
 =?utf-8?B?K1lLalhJdnhOK0pPMVFlSGI4SUNmMUUrTmRDMGh5MkQ3T3B6ZVU5cjg2NlV0?=
 =?utf-8?B?MUtPYnVrMWhCQXpLSjRGM1MwMTJ3eXlGUGZJSWMvUUNjVmlkU0tROTcwNTF3?=
 =?utf-8?B?bmRlS09IZ01zVmN0d0xUYURJNllxVWhQWUFvQTZQZm1odlJGV2M3U3lLcXk2?=
 =?utf-8?B?Q3ZjQUU2Y3RZaFBPZXBCaDFNYjhUTkQwQ0s4Q3BIRDZPUzlNdGFEdjUrV3ZF?=
 =?utf-8?B?U2s5aVhqdWpQaXVWY2tIeXpRQWVBQTA2NnNxcEZJRitQRUdiQWZLek1GVEdZ?=
 =?utf-8?B?YW9ybitnNlJrWkVEUmkzbm41UmtjSk5qU3ZFbmI4WkhRNFl4OEpWWWhlSDBm?=
 =?utf-8?B?dk5RQWFHYlV3d3EyZ2xkRkgxRExXbU1tYVRWcXdHZXY4akVGNDZMbE9Xd1F4?=
 =?utf-8?B?cVZVTlJteTNlcjZNc2I2OWcyWVBXeUExY1pFOStqYVZmcU1yZ2dIaHJjaWVB?=
 =?utf-8?B?Y2RjNmJZejZ0anUxVEc5QXYrd2JuVmZ5Qld3TFlnTG1WNWVDZkNUaW1nTHcx?=
 =?utf-8?B?NXUxSGNnRUhiUFZmcmx1WWptSTdhOHlBdnA1Z3NieXg4K1loRFV1VytaSXE3?=
 =?utf-8?B?ajVWbnVJYWt0TlJoU2x1YWs1QjdIeWIxM0dXaDBjckVBWEltZmpZVWFjQVFy?=
 =?utf-8?B?cit5aS83MGE4c292ZFZvYXo0cW5HQ3lYRzhDM2l2dXhmNW5teUtoSGxrMFNa?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02051B6C46CCCE45AD35691D50BD4A6B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dcb8959-ec73-49a8-913c-08dab6e46df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:55:43.9667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTJA8eR5je4/X50KMJyomfz12nldw/F+CUq5HnMnW3THaXmEbaqclKGCX9PDX6YJ4XBEvvPHHD2k9rmXsqOang==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gUmVjZW50IGNvbW1pdCBmaXggYXNzZXJ0aW9uIGZhaWx1cmUgb2JzZXJ2ZWQgd2l0
aCB6b25lX3Jlc2V0X3RocmVzaG9sZA0KPiBvcHRpb24gd2l0aCB2ZXJpZnkuIEFkZCBhIHRlc3Qg
Y2FzZSB0byBjb25maXJtIHRoZSBmaXguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTaGluJ2ljaGly
byBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29tPg0KDQpUZXN0ZWQtYnk6IERt
aXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5jb20+DQpSZXZpZXdlZC1ieTogRG1p
dHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2RjLmNvbT4NCg0KPiAtLS0NCj4gwqB0L3pi
ZC90ZXN0LXpiZC1zdXBwb3J0IHwgMTQgKysrKysrKysrKysrKysNCj4gwqAxIGZpbGUgY2hhbmdl
ZCwgMTQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3QvemJkL3Rlc3QtemJkLXN1
cHBvcnQgYi90L3piZC90ZXN0LXpiZC1zdXBwb3J0DQo+IGluZGV4IGUxN2E4MWRlLi4wZTE4NTk5
NyAxMDA3NTUNCj4gLS0tIGEvdC96YmQvdGVzdC16YmQtc3VwcG9ydA0KPiArKysgYi90L3piZC90
ZXN0LXpiZC1zdXBwb3J0DQo+IEBAIC0xMjc2LDYgKzEyNzYsMjAgQEAgdGVzdDU4KCkgew0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgID4+IiR7bG9nZmlsZX0uJHt0ZXN0X251bWJlcn0iIDI+JjEN
Cj4gwqB9DQo+IMKgDQo+ICsjIFRlc3Qgem9uZV9yZXNldF90aHJlc2hvbGQgd2l0aCB2ZXJpZnku
DQo+ICt0ZXN0NTkoKSB7DQo+ICvCoMKgwqDCoMKgwqDCoGxvY2FsIG9mZiBicyBsb29wcz0yIHNp
emU9JCgoem9uZV9zaXplKSkNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqBwcmVwX3dyaXRlDQo+ICvC
oMKgwqDCoMKgwqDCoG9mZj0kKChmaXJzdF9zZXF1ZW50aWFsX3pvbmVfc2VjdG9yICogNTEyKSkN
Cj4gKw0KPiArwqDCoMKgwqDCoMKgwqBicz0kKG1pbiAkKCgyNTYqMTAyNCkpICIkem9uZV9zaXpl
IikNCj4gK8KgwqDCoMKgwqDCoMKgcnVuX2Zpb19vbl9zZXEgIiQoaW9lbmdpbmUgInBzeW5jIiki
IC0tcnc9d3JpdGUgLS1icz0iJGJzIiBcDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgLS1zaXplPSRzaXplIC0tbG9vcHM9JGxvb3BzIC0tZG9fdmVyaWZ5PTEg
LS12ZXJpZnk9bWQ1IFwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAtLXpvbmVfcmVzZXRfZnJlcXVlbmN5PS45IC0tem9uZV9yZXNldF90aHJlc2hvbGQ9LjEg
XA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID4+ICIke2xv
Z2ZpbGV9LiR7dGVzdF9udW1iZXJ9IiAyPiYxIHx8IHJldHVybiAkPw0KPiArfQ0KPiArDQo+IMKg
U0VDT05EUz0wDQo+IMKgdGVzdHM9KCkNCj4gwqBkeW5hbWljX2FuYWx5emVyPSgpDQoNCg==
