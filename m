Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F140C433EF
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 15:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F3B619F5
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 15:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344600AbhI3Phx (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Sep 2021 11:37:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55636 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344587AbhI3Phx (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Sep 2021 11:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633016169; x=1664552169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u4EQ6w2XXMuBc9WzqqywlhxVVuXgGzNaF1bbdbLulyk=;
  b=ZJ7vHwMDSHZBQbi7faaOBGD1BE/ajLPPZy2j8EoD4kcEhhQsGQ5iyvLT
   Es8DgL/1qdpQtGYSKmvZNgfNTzfMmHVoo2hSt1MtqsurzKvfyZdpR4pxY
   QdZTlNhlgqZzMmmfr2M3QmRyjr1bt59qluk4vrkI7EIdGFihoHUaBuC/X
   501wqsm4HzevjkFNck3vUN23qHed7Ps5JWH0vPWPrMWRW75kmE5Xnc05G
   HoL6udM19IoKtmwl5JwvIpxeWyyToKweZ8Ej8RRzD8+Cmp8raKp1c1oD2
   TLfkytspB0+Sv22mSd/joDXGt+crvTYwSHU0vYrLjiNwuuULbbVTzwQ+i
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,336,1624291200"; 
   d="scan'208";a="181451622"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 30 Sep 2021 23:28:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBiu/6B7fnMt9sgdtlAqRvIQy6hYSmNBzZgD7Gvqo2M21XkDReyt26zlb8HZfsN08akMZFBeG718YR642k7gAKHbimCmO4VrtcsqPIFYlyohOtD2e8qSaH4PHEY1CmDh0SbCIFyUJYPJksnpZVDYc+InLxCFH4eU/ZCkknOQ0M8CmY+pmhxIQ0VDtFaJvsHgWqG2SR0dWeijbzBE9YyH0Cg4qIRlZCdADF2YrBm0qK+mgPnJytkoMo3gsfTuK5HRlB9/28Zf/3EXE+PWZ3NmE3JetRWdW7RgcyjfPZyUuuIQYKek5NngYbmqtZxnWSkPnCZzoBc71c+xw9685+Ic4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=u4EQ6w2XXMuBc9WzqqywlhxVVuXgGzNaF1bbdbLulyk=;
 b=IPqzSkiCzSO28T+1bVIHTI+FdX0UZ7r+/4NWE8nzhE+CGbgujuiFv4krYjUYtx2BkP4Rf2a/PibgaOBaUSLcJi1aqePX7YO57ioxBboMSaViruc+TD7I29eKpACzcc6pgOSbMTqMGa63sDOxJkS9JvXhGSL5/aIfUytcXjwzK0O0e9duqzs1qfZ9lM0YdTnJLI5rEEwgZFLiAZUbwqjrPz+5oxBeS7sVrM0ySPtd6uRwgwFtQCtlltww43vwJGsJh0gAD8E6qgyHBPC3UKFQ6S+0UjNPA92ROhqV7mdOpZkkfn/wYrfz+nFz5gIEg9UEMv1s0wMSYMid6Hm83+nT6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4EQ6w2XXMuBc9WzqqywlhxVVuXgGzNaF1bbdbLulyk=;
 b=MLeqDFxG5kNFTc683R+mHNgUmAcpux2dWFDDO/z+xybyEzvw3x0r0uNs0YybLhcJExDSWHIOt5t1RrvmTmGx3Jnw5kr7jNdZiM4hdvqPY7X435s7McIUHNvPCgKIyE5QAjfomJM16YhqnmtnAs0HCkMglFc0FYPbHjWXS3Hrcdk=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by MN2PR04MB5566.namprd04.prod.outlook.com (2603:10b6:208:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 15:28:11 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::d1d7:7b74:3337:f3cc]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::d1d7:7b74:3337:f3cc%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 15:28:10 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH] zbd: Fix unexpected job termination by open zone search
 failure
Thread-Topic: [PATCH] zbd: Fix unexpected job termination by open zone search
 failure
Thread-Index: AQHXtY5+yG9NySYOb0KTlfiIX3EIlqu8tG8A
Date:   Thu, 30 Sep 2021 15:28:10 +0000
Message-ID: <706c1cd44e6bfcb9b75db1722c1b77a4ab3309ef.camel@wdc.com>
References: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0-1 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aba72077-40b6-4d14-897c-08d98426e970
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5566B7E0D6FCFA7EB8D58C7BE1AA9@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bG0LazgYLHL4h7B1Ovt1P/z5VUob3h7k6ZRzznGHvihRevjVuZR3bXxzCqZFEpLBLRRXyFnlB2W8Bj9CoZnFamaUwC4eoC1dYu2iLaCZ8bK5MKCGCr7nlTO3/tgW+croLRPo/E7vj7Mg8MW+GaNyuutv5ga5OsEkwwbGfbd4NSzcqQ25e7XsDG6iDpTzApIOd6qdaxxn+4ltRDUnDDlUfnF1Z5itbhP4+yUB7fTS9P364KlzGePB9u6U1sc15DLZiEQfHEGVk7bn36nY0C/NFinhq+E08N5yzxzRprgKbWuzrxRn2u3ry9zgPg52p/1jWltLxAHY7MglLRrIqHOBytVBjQZwOfEVUBlK8JBqwvwFU3iDnFR+6L4QaPbc/bPA7noTGdAyQxMEzuW4prH2mC62/1BIFjE5frPwbd63y7fhta0uSLZoZMvzIE5dyfVYHVYQCw6JrA1D77rw+5xJ2PgPeLGLsSXQx7xdM0Dmqr7TbKornG7KmJetV4HV2GLu5BpeXvkEJCaArCq59IZShPWXXFJUDJM7qQScfcnDZCq7lECAz4pm8xJ+BNeHscQQZeshNviQNMUu4ROzwGDwKyO23rvHUXh4+7Be+OdZOoBOxTJnlmCQFqPbjILkI0P10YNQequUiSCNyMHQnV4H51YRF0CCo3svjj+fvQBZTLYBOnx5h9jHj1e5ao7YL5upx4Np+EZuJHUcjYDN07nfXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(122000001)(8936002)(6506007)(6636002)(8676002)(6486002)(110136005)(508600001)(316002)(54906003)(83380400001)(38070700005)(38100700002)(36756003)(6512007)(26005)(86362001)(66946007)(66446008)(2906002)(76116006)(71200400001)(64756008)(66476007)(4326008)(66556008)(186003)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDJJQ2V5bDBnSWRML0l3Umt4RlpKUER3S2MzakZUSmQ5cDNtQldEVlhVUG9r?=
 =?utf-8?B?Vng1d2llTUthR0QvUm9xa0xmajVIYXFYY1JtbTdzU09xYUNPd3dvOWxEWmRv?=
 =?utf-8?B?Zy9ET1BHejdYL2ZFbEFhSStyNCtZV1ZmcGN0VmhQUG8zSzVISXpVWTJMaEwy?=
 =?utf-8?B?SG8rdkpXeGp0TlMyUFhrWEt6ZW8xZXowV09OY2pRUGVNWHVJemJtckFaZ3NI?=
 =?utf-8?B?K3R0T0daL2NQd1NtSkVBVm4xVEhjaTNYMUtXMlRMcWE1ZExobUZrK3o5dE13?=
 =?utf-8?B?R1VwSFNWcnFoMWVjQytOQjFNQnRjNHk1djU3MVN1RDlMaElaNXc3VTdCR0Mr?=
 =?utf-8?B?QUV0M1FVN1ZnVzYwamg5UmdpYk9oOWFxRlJHRjJUUVhSdWliODdCL3NmaG9K?=
 =?utf-8?B?eGs0VXNseXIvVlFRR1B2c2VqS0tTc3ZlUWtVSVR5a3I4MXE5OFJ6Z1J3NExO?=
 =?utf-8?B?alBoMElVM1dIWTVRZmhyT1NrNmx0YS91L3JSQ1lvL3JZTlQwRml6ZjMxS2hU?=
 =?utf-8?B?Ujl3VGRRYldEM3N4di9RMDlYRjczclVyUGVNNkE2eDNHb1hZOG9YV0diNzBL?=
 =?utf-8?B?eGg0U1FkemhHY3NOZ0g5aU05WHVMelFqY3QxRXRJSXBndmVpZVpPMFNPSFU1?=
 =?utf-8?B?TnFOUGhQdVRIcytEZHFpbjY0OWJ1R3JadldobnhBRnZ4NGtrbG1lRWxkdWNq?=
 =?utf-8?B?WUVmdDM1dHhJZlIrNnBzaEN5NkpXaXNDUlZ1Z2hwWFZTZUR0cnB4MlRPNWts?=
 =?utf-8?B?ZGVIOFdyc1FEU241YllpWjlpQjFac2FQOW94MTRXZ0VoSmZpUHlpZm5TVmxW?=
 =?utf-8?B?d1V5MmRjZ3kwUEorOExqWWhiaFIzb24zT1o1OEQ5SHp5QVo3TWNFYmtObXBu?=
 =?utf-8?B?MEFpNGhOKzljbDgvRTZ3VUpEVkk1YkxZR09lN1g4dUkzdWRYcWpnakM0ZXhY?=
 =?utf-8?B?UE1DcnhtWnRYYzdDdFp4R3JVUGVUc2tHZTJTeEZSUnluZ2hRMit0RkpLQmFF?=
 =?utf-8?B?RkVpNXl6d0xVUEJrZzZRNGxQejlIRG1Xc3lvYWthWUVpKzhyb1liczdoTTMy?=
 =?utf-8?B?OWpKUFRQQUdsbDJVL05HRElQa0Y3bGZqWU1OM1I4TUNpeW03bU5qdWpHK1JS?=
 =?utf-8?B?QkhFNjVTWitGb21SNG9WcVJuWHdPR2NFaDV6ZUN1aFMvTzVlNWRNUmhEUy9l?=
 =?utf-8?B?ZTk2Y2toVXIva1VDMDROeXZrQlY1cHNFVnRrWU1kaElKczF1NURlZHlzeEVp?=
 =?utf-8?B?UC9PU2V1YU5RcFQvZ2lkZDdYQkVERER4NVdiQnhySU83ZkhrcEp3THJWTEJL?=
 =?utf-8?B?ajUzUGUxODN5bGZLcEpVRXIxL044ejVxa2U2SWl5amxyVzJRTmpkN29VVHg3?=
 =?utf-8?B?am5aYW5BaU52TnVFOUN4aTNycmdTN0JZck9lcW1pdWFzc1lFQ1pIMzlSNEtl?=
 =?utf-8?B?bjlOTUJMT2RKV1RUWk1HRG5Nc3JpM28yWmdWam0vL2NmRGt2dkJwZDZVeGJJ?=
 =?utf-8?B?RVpPdHZZVStxYVc1QVJPejMrenNOTXpBMXRCR3pkQ2JBTjFZbER0S2szemJy?=
 =?utf-8?B?TU5MWUQwTk91bFVwNXJ0cTlRb3ZKN0hWWHl4Y3hSUGVWS0llanhvc2d6QTRo?=
 =?utf-8?B?QnRMWVBmNUkxRDZGS0xnbEVaMGxxMEJ1cjNqNEp6YXlOM0Y5bnoxVW1pSXpp?=
 =?utf-8?B?cStzL3UzWkJnQWFraU1NSnFpYjZQR3ZDbmowTTB2WW5kdnBWbGhYR1ZqWmdh?=
 =?utf-8?B?WHY3ekx0NTI1NGJ1SVJyZ1hhTFhKWGIvdWJWNWlZbHJ2TWZqbmRXT3Q1bngy?=
 =?utf-8?B?dHZZakxuUmpSSmFDV2Nmdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29FBCAC74D5A5E4AB17022DA11BAFA92@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba72077-40b6-4d14-897c-08d98426e970
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 15:28:10.7957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8a8hPH6vgBQnwlcwJUxZrXAkt7v/9J/BuRHvws8VlyCNal2seY05oG3M0Pr7QA4Dno/bCx1/A5k9ZD1pFvgaqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gVGh1LCAyMDIxLTA5LTMwIGF0IDA5OjAyICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gVGVzdCBjYXNlICM0NiBpbiB0L3piZC90ZXN0LXpiZC1zdXBwb3J0IGZhaWxzIHdo
ZW4gaXQgaXMgcmVwZWF0ZWQNCj4gaHVuZHJlZHMgb2YgdGltZXMgb24gbnVsbF9ibGsgem9uZWQg
ZGV2aWNlcy4gVGhlIHRlc3QgY2FzZSB1c2VzIGxpYmFpbw0KPiBJTyBlbmdpbmUgdG8gcnVuIDgg
cmFuZG9tIHdyaXRlIGpvYnMgb24gNCBzZXF1ZW50aWFsIHdyaXRlIHJlcXVpcmVkDQo+IHpvbmVz
LiBXaGVuIGFsbCBvZiB0aGUgNCB6b25lcyBnZXQgYWxtb3N0IGZ1bGwgYnV0IHN0aWxsIG9wZW4g
Zm9yDQo+IGluLWZsaWdodCB3cml0ZXMsIHRoZSBoZWxwZXIgZnVuY3Rpb24gemJkX2NvbnZlcnRf
dG9fb3Blbl96b25lKCkgZmFpbHMNCj4gdG8gZ2V0IGFuIG9wZW5lZCB6b25lIGZvciBuZXh0IHdy
aXRlLiBUaGlzIHJlc3VsdHMgaW4gdW5leHBlY3RlZCBqb2INCj4gdGVybWluYXRpb24uDQo+IA0K
PiBUbyBhdm9pZCB0aGUgdW5leHBlY3RlZCBqb2IgdGVybWluYXRpb24sIHJldHJ5IHRoZSBzdGVw
cyBpbg0KPiB6YmRfY29udmVydF90b19vcGVuX3pvbmUoKS4gQmVmb3JlIHJldHJ5LCBjYWxsIGlv
X3VfcXVpZXNjZSgpIHRvIGVuc3VyZQ0KPiB0aGF0IHRoZSBpbi1mbGlnaHQgd3JpdGVzIGdldCBj
b21wbGV0ZWQuDQo+IA0KPiBUbyBwcmV2ZW50IGluZmluaXRlIGxvb3AgYnkgdGhlIHJldHJ5LCBy
ZXRyeSBvbmx5IHdoZW4gYW55IElPcyBhcmUNCj4gaW4tZmxpZ2h0IG9yIGluLWZsaWdodCBJT3Mg
Z2V0IGNvbXBsZXRlZC4gVG8gY2hlY2sgaW4tZmxpZ2h0IElPIGNvdW50DQo+IG9mDQo+IGFsbCBq
b2JzLCBhZGQgYSBuZXcgaGVscGVyIGZ1bmN0aW9uIGFueV9pb19pbl9mbGlnaHQoKS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFNoaW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtp
QHdkYy5jb20+DQoNCkxvb2tzIGdvb2QsDQpSZXZpZXdlZC1ieTogRG1pdHJ5IEZvbWljaGV2IDxk
bWl0cnkuZm9taWNoZXZAd2RjLmNvbT4NCg0KPiAtLS0NCj4gwqB6YmQuYyB8IDM0ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMzQgaW5zZXJ0
aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3piZC5jIGIvemJkLmMNCj4gaW5kZXggNjQ0MTVk
MmIuLmMwYjBiODFjIDEwMDY0NA0KPiAtLS0gYS96YmQuYw0KPiArKysgYi96YmQuYw0KPiBAQCAt
MTIwNCw2ICsxMjA0LDE5IEBAIHN0YXRpYyB1aW50MzJfdCBwaWNrX3JhbmRvbV96b25lX2lkeChj
b25zdA0KPiBzdHJ1Y3QgZmlvX2ZpbGUgKmYsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZi0+aW9fc2l6ZTsNCj4gwqB9DQo+IMKgDQo+ICtzdGF0aWMgYm9vbCBhbnlfaW9faW5f
ZmxpZ2h0KHZvaWQpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB0aHJlYWRfZGF0YSAq
dGQ7DQo+ICvCoMKgwqDCoMKgwqDCoGludCBpOw0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGZvcl9l
YWNoX3RkKHRkLCBpKSB7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodGQt
PmlvX3VfaW5fZmxpZ2h0KQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiB0cnVlOw0KPiArwqDCoMKgwqDCoMKgwqB9DQo+ICsNCj4gK8KgwqDC
oMKgwqDCoMKgcmV0dXJuIGZhbHNlOw0KPiArfQ0KPiArDQo+IMKgLyoNCj4gwqAgKiBNb2RpZnkg
dGhlIG9mZnNldCBvZiBhbiBJL08gdW5pdCB0aGF0IGRvZXMgbm90IHJlZmVyIHRvIGFuIG9wZW4N
Cj4gem9uZSBzdWNoDQo+IMKgICogdGhhdCBpdCByZWZlcnMgdG8gYW4gb3BlbiB6b25lLiBDbG9z
ZSBhbiBvcGVuIHpvbmUgYW5kIG9wZW4gYSBuZXcNCj4gem9uZSBpZg0KPiBAQCAtMTIyMyw2ICsx
MjM2LDggQEAgc3RhdGljIHN0cnVjdCBmaW9fem9uZV9pbmZvDQo+ICp6YmRfY29udmVydF90b19v
cGVuX3pvbmUoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwNCj4gwqDCoMKgwqDCoMKgwqDCoHVpbnQz
Ml90IHpvbmVfaWR4LCBuZXdfem9uZV9pZHg7DQo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgaTsNCj4g
wqDCoMKgwqDCoMKgwqDCoGJvb2wgd2FpdF96b25lX2Nsb3NlOw0KPiArwqDCoMKgwqDCoMKgwqBi
b29sIGluX2ZsaWdodDsNCj4gK8KgwqDCoMKgwqDCoMKgYm9vbCBzaG91bGRfcmV0cnkgPSB0cnVl
Ow0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKgYXNzZXJ0KGlzX3ZhbGlkX29mZnNldChmLCBpb191
LT5vZmZzZXQpKTsNCj4gwqANCj4gQEAgLTEzMzcsNiArMTM1Miw3IEBAIG9wZW5fb3RoZXJfem9u
ZToNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpb191X3F1aWVzY2UodGQpOw0K
PiDCoMKgwqDCoMKgwqDCoMKgfQ0KPiDCoA0KPiArcmV0cnk6DQo+IMKgwqDCoMKgwqDCoMKgwqAv
KiBab25lICd6JyBpcyBmdWxsLCBzbyB0cnkgdG8gb3BlbiBhIG5ldyB6b25lLiAqLw0KPiDCoMKg
wqDCoMKgwqDCoMKgZm9yIChpID0gZi0+aW9fc2l6ZSAvIHpiZGktPnpvbmVfc2l6ZTsgaSA+IDA7
IGktLSkgew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHpvbmVfaWR4Kys7DQo+
IEBAIC0xMzc2LDYgKzEzOTIsMjQgQEAgb3Blbl9vdGhlcl96b25lOg0KPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dDsNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwdGhyZWFkX211dGV4X2xvY2soJnpiZGktPm11dGV4KTsN
Cj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gKw0KPiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDCoMKg
wqDCoMKgwqAgKiBXaGVuIGFueSBJL08gaXMgaW4tZmxpZ2h0IG9yIHdoZW4gYWxsIEkvT3MgaW4t
ZmxpZ2h0IGdldA0KPiBjb21wbGV0ZWQsDQo+ICvCoMKgwqDCoMKgwqDCoCAqIHRoZSBJL09zIG1p
Z2h0IGhhdmUgY2xvc2VkIHpvbmVzIHRoZW4gcmV0cnkgdGhlIHN0ZXBzIHRvDQo+IG9wZW4gYSB6
b25lLg0KPiArwqDCoMKgwqDCoMKgwqAgKiBCZWZvcmUgcmV0cnksIGNhbGwgaW9fdV9xdWllc2Nl
KCkgdG8gY29tcGxldGUgaW4tZmxpZ2h0DQo+IHdyaXRlcy4NCj4gK8KgwqDCoMKgwqDCoMKgICov
DQo+ICvCoMKgwqDCoMKgwqDCoGluX2ZsaWdodCA9IGFueV9pb19pbl9mbGlnaHQoKTsNCj4gK8Kg
wqDCoMKgwqDCoMKgaWYgKGluX2ZsaWdodCB8fCBzaG91bGRfcmV0cnkpIHsNCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRwcmludChGRF9aQkQsICIlcyglcyk6IHdhaXQgem9uZSBj
bG9zZSBhbmQgcmV0cnkgb3Blbg0KPiB6b25lc1xuIiwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2Z1bmNfXywgZi0+ZmlsZV9uYW1lKTsNCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHB0aHJlYWRfbXV0ZXhfdW5sb2NrKCZ6YmRpLT5tdXRl
eCk7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB6b25lX3VubG9jayh6KTsNCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlvX3VfcXVpZXNjZSh0ZCk7DQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB6b25lX2xvY2sodGQsIGYsIHopOw0KPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2hvdWxkX3JldHJ5ID0gaW5fZmxpZ2h0Ow0KPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byByZXRyeTsNCj4gK8KgwqDCoMKgwqDCoMKg
fQ0KPiArDQo+IMKgwqDCoMKgwqDCoMKgwqBwdGhyZWFkX211dGV4X3VubG9jaygmemJkaS0+bXV0
ZXgpOw0KPiDCoMKgwqDCoMKgwqDCoMKgem9uZV91bmxvY2soeik7DQo+IMKgwqDCoMKgwqDCoMKg
wqBkcHJpbnQoRkRfWkJELCAiJXMoJXMpOiBkaWQgbm90IG9wZW4gYW5vdGhlciB6b25lXG4iLCBf
X2Z1bmNfXywNCg0K
