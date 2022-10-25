Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DE3ECDFA1
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiJYXyi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiJYXyg (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:54:36 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC821AF37
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742073; x=1698278073;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tyeEKWxUZUrGwuenK6Cb2mcD35LYRq0voqg5cL2VZbs=;
  b=APtziSPV3/6WmJuAopJpObsmfuxxUkkNgTaYv4bcpiFZqf82C05Ef4yY
   auznkzlTM3TlfjCVHkIQNufejmIYA9y8dIL3aR1dPMkJi9/b54Kx3L7FV
   mcdPsgvYJecjX2kX0oRs2rGoKnbNQHVCHsW5zqsJBbqsSyY0gaZudpI03
   PmLDS7HLg9n0becX2rF3GmNb6v8PqDR2QGbScd6TyvaITOnZTbvFtnwaS
   RrXN/TQHs/XFiYk6yAKa3VMTsUQYgVZdwZecSS4FqBVZIWwGi9UA/s5gh
   84AFsrfGcgPgroZ4xoifhPyA6iXylBMadmdb7/kzz7bkeAjE4YhS43Y8/
   A==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="326842694"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:54:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W30rIusW8UY/PZCTWFxZnvBbRtWq3WkNjAOeOoLYt3EbDHJiwhkfocbBkZ+bh09jhyebYFGL/Gf7YNlFtzILqVY5dTh8fTe6jZVWIMmIEChdJ9K1UyHnMPhU4IJmkMxg8Vsig93j9Vw7bp1FeQ9O1TtpxIPxEgFm6xqdhLZwpo6H7+iNU3GRhmPqyB9lOgjJaIwVl33IzUVq928v3clS4dEMImYOZjTEM6H2vOwPS+xgWqtpb8ZqWaF0wDVfgV4EhXvXBGna3G3sYRRnpRy9aQhvnFyXkWwmd8xHX2GtJeMXkXwdHBnogBFNY6fLPj6OUf0wR/NPIg82uh7ExaKjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyeEKWxUZUrGwuenK6Cb2mcD35LYRq0voqg5cL2VZbs=;
 b=KPoVEss8UyNayxf+sY2cSgA8AI/3J73rQv0UP/1u9aV/fYw+ID0dvDxvadUUf0pHs9OTHpv5TZGGPw8oxt7DeX2X7+yYcjWACTWiQzJ5fqnnlXkcAgnrtcNfjq1LQlL9DWk5maFH14uv+se1yWAvF8+7nyBrTU5tBJQdoPGbgZSVJREDnQkrXT4rwGwe7sVuKmBYNzzYyGcJkUjqZpKI87pdJQS5qKGKntPYePIF9N/CdrEYSendDwpEwYXg35tRbwhNrP3ZaX/tE1pu0DsxUuB2VYl2K4qnKxm/pi8Fcnv3Rmg11/kKH4AX7fzLynqzuvFJ3FtA1SIGyClCs2pMsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyeEKWxUZUrGwuenK6Cb2mcD35LYRq0voqg5cL2VZbs=;
 b=0FoTnzQZwXBTMh4qradv96wjm6g2DC55qmtVlYXQk2HhgreT2yWUkKmbGAYD8H4UPUqEoLPQ3OsU1fGdsQXDaMCuYQlBhTZRzG+93vXJMcuwTdsdr+S49cyfK1i9ePCsrlv0Bn1URZQtNAf353vLZ7DYYfoX2xRkJwg8thf4pPQ=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:54:30 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:54:30 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 07/11] zbd: prevent experimental verify with zonemode=zbd
Thread-Topic: [PATCH 07/11] zbd: prevent experimental verify with zonemode=zbd
Thread-Index: AQHY5RcuW0/ehqeSnUW+gPlD0yUZ7a4f0A+A
Date:   Tue, 25 Oct 2022 23:54:30 +0000
Message-ID: <d4a331d5360ae57013c2dc6663dd54dcede6069d.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-8-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-8-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: d8c1bc27-b8da-4266-f27d-08dab6e44229
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GrWgX1uzL9SiyxkL4wc2wrO5OnxzFh/RNluwdJyWUXiI+X3oHLS5DE+uwyzd221kOb0BZaQRjpV1uVVBy3M78swm7R7hD7CPf1fEBGmiseQf7nF+9H3IIkmKufqMvG33C5OFcLhWPzAqnnuCfUTOSfbZ+qBQso0Yi/QOJTFY9AE6dCSfrZg9u+KEz+VGjf6PVUK9wF7jYJrPmWjM6MO2us8uKG37kGXuu7xcJ53VnryFsWPbOUZIhNu0eqT1OW5ypwoC54GM/2FNc9Dq87FHQ/BdGTxQAnGVVcShLXgY6K3tKBUBN1VNZ5xA5NeHZmFkCUqctW++RcRziCkGBePPDGqAuKn0T9FpKmZskwXZTfjUBGD1AEWr9Um9ocaYm776V2KTh9n3yOZ8GETRtWQ0Dqcv8QzDzx3G+Qukm5zToq7GqOSTio/rALz1c3KRYAFDG4UDmMQom5ZIjMh0CmDyst84KiWbZcqk9WSH2nalNt2ZOMlmpyOBfv9v85U9Yl8Pye0X0LbeER8kGQ2+ToSp29vnl4nhTSjmtNCjHoB7p9/3uJKCH4r5GaWEicbEc3SqdWMcNnSUZ7wQMKAfLajJn537Hy+sYeZbTfQZx7U1fOTpFtmA0bOSI0nrVq/qP2vJ4Kff0DtBe01NQIUTMeljQ7/kj3lyLsxyaijpSUOPIBMu0MtSLLBgZV4vuRZ0YYYa9+S0r4gg0E/1y0vUVEAyAOf87bzo0V0M9X0SY/wqSPnZfeRYC+bGtNbBGe5o0ToOVKBO44D+Go7SGYCTGjoxPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(15650500001)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anVZeEFQNm83and3c1FKNzFhWG8yZlJ5SkJQZDRFRU16elVPNHRQYnUxeUg3?=
 =?utf-8?B?ZFJYbVNuWmN4alZoQmU2UGg5OXQ1TXg4MTNuZm5Tcjl4WTQ5aWk1c2s0QW5q?=
 =?utf-8?B?M3FuNXNVM3UySDE1ZTFDRGFDSmgwcExJM2hPT3M3d1JPWUJXOSt5ZGF4VEJz?=
 =?utf-8?B?azdlS3NjTzlIQ0IrNFNqZCsrMVZqZjVqU2JmZWpzaTdZTUsyaFBlb1JrQkUy?=
 =?utf-8?B?N1QvSW13YlJKajV3NU1TVHFsaEFrbjAvRm1RaTUvOUtnMEhJbVM5QW5kbHAz?=
 =?utf-8?B?MnRhODIraENlSjAvSElFY0RhY2dLM0h2Qk93TTBlZ1ZESUVXemE2M2NrUTY2?=
 =?utf-8?B?clR3K0R0V1NxdGY2K2tCcW5FWXRsSUozK3J0ZmVob00veWMxTXBRU0ttOUEw?=
 =?utf-8?B?OEFpU0o3WXg4TTE2MzVxWTAyaTVoZVFRdnkrd3p6UWpuQXpsMWZkZmc0Mnpu?=
 =?utf-8?B?VzhKeU1sclZlNzFXcWJabTVDUGtvVkkrN1dIUDFVS2pkdzNZV1ZtckRnT3Y4?=
 =?utf-8?B?M2ROU3FGQjhLaVVCK0dYM1ZkM3k2RHFLQThaRkhQL0FYMEhtVDVkOS9SNm92?=
 =?utf-8?B?ZTZGd0pDQmpKM3Bad1M1MmZvZ1JodGJpeEg5cnlEd0lLbkUyQTJJZkg2RzlY?=
 =?utf-8?B?N1AyRUpMVTNlRFN6Y2RtT1cweTExeDMzbUJFdE1DM3NHVXdJbEZjQytlckt6?=
 =?utf-8?B?bm5VczlGVzEyR202U29FeVFkcEY1akY0dEcyTXpBTTFUOFdLb2hzeUhwTDJ6?=
 =?utf-8?B?cU1BL2poSFh4RUpDT3pSdldsYzNqT2taeWczaWhYQWU5RmV5YjZlRXR1SHh3?=
 =?utf-8?B?Y0lZNWxSQmhOcXFCWHdUajNjb1RHYkx0Z0hsN2xubkUvcHFUTDdMNGp5bXc0?=
 =?utf-8?B?MUxxSXUwaUc5TVREdkhteVZ4bEZHeUdPanVKNDdjY2dPcW9RQjBtUGdheWpu?=
 =?utf-8?B?Z0ZwN2NuVEpwVEJPcm9yMHl5NkVXVitPM0FyM3B2VWpOdVhKaUxFUGhNWXZG?=
 =?utf-8?B?QVBmUnZLSmIzdjlhdjJpZDdZKy9Xb254SjVnWnlnM3dVdGNHRXB2aFlJWFE4?=
 =?utf-8?B?YloraEcyZEdldmNKRk1Cb283OEpyY1lNa21pN3AraVZCYVdjZW1BS0x5b2Vv?=
 =?utf-8?B?V3QwcW92dW8wVTNQamRBcEFja05uMmhJK3M5NWdsL2Nib2hzc0FwaWtFVmVR?=
 =?utf-8?B?WmpsY05OdHMxQkVmcThSbkF5b1J4UmlUR05WWXdyYUxuSWJLMEtLUVVWVzVa?=
 =?utf-8?B?NURYTTFRWDNtTWF5Zk92OXNicTcyYjJKSUlQekdwb1FiQzl3U2VWRWNYTy9u?=
 =?utf-8?B?eDkvaXRaTFkwMmFxdldxdVFBb1ZVMGN3WFRNenVRdXlkcThpOEk1Mjh0TVli?=
 =?utf-8?B?di9NRHZGd2dEdFFnR091WllyY0RpaThNeU1hdjM1ejNVeUJKNWdFUmR1K2dF?=
 =?utf-8?B?TUpFc09BbjUyS1lmSkc1UnB4dlJTT016ME9BY2V5OFlhNHBLWUgrWkxDYnhr?=
 =?utf-8?B?V3RTSi93UEFXVUMwdnpadGloQkpLZE1ZdVRxRHd4S2NJbzZOdlR0ZS9LeGhK?=
 =?utf-8?B?LzNtb0oyYS9NcTdsS0RMUDU5M2pHV28vL3RxUDBGbzdxMXlaSWcwaUZxS0lv?=
 =?utf-8?B?V1ZNaVBiN0dPODJ2MGtuSTJzVHJkUFdMcGhjUG11NW0xaHk2OXdGaktqcHlz?=
 =?utf-8?B?U29OQVpPSVJFTjZYUU5QUDBjVmc1bWdaOG0wdytYY2d3M0RGOEROcTFvMnVh?=
 =?utf-8?B?M21lVkdyRmIycDBmS0pGeVpINGQycnQraFRLdkZFTTM4bjRoeWNQVmRYRnoz?=
 =?utf-8?B?Q0hJM1l5TjZmVlRocy9FWmZrQVp0UU1NSUJHOEJhRDl0dy9icXJDVVF4OXlH?=
 =?utf-8?B?VmlySGUrbHQ5K0VjTXJWczN0eGtnQ0MrRTgxVENXdUI0UDVUZDVPR051RWRH?=
 =?utf-8?B?NHY2cktjTkRHdVhaQ3lhVmYwUzhJQThMZWZaVjdzVWNwVzRqSkY2aVNHcWFs?=
 =?utf-8?B?dWN4S1I3RnhMMW5ZN1VwQnF1K3RuTDJLNGg2QjV5cUZEUHo5aEx0bnpTdHZw?=
 =?utf-8?B?UUdiUjBmWWozVzBFL1FsUjhRd3U3VmxxaVVCa3VLOGNIKzlhYlBINC9taHRU?=
 =?utf-8?B?T05BRFNZTlVxcTMyc3RiQzlOM2FYQXhTdk1sTnBGd3lucEVVc2xKZTdLK0g0?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2AB235FC9BB6684FB934124A531A6C9E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c1bc27-b8da-4266-f27d-08dab6e44229
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:54:30.5034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nlYrI10/X3kposPD1P4Cw4+D13WZ2KCiRVXy5VbLi3/Gc69UMAG1RodEUIIK+Dqtka5+o2OVqOiVcZ6X0V0dgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBXaGVuIGV4cGVyaW1lbnRhbF92ZXJpZnkgb3B0aW9ucyBpcyBzcGVjaWZpZWQsIGZp
byBkb2VzIG5vdCByZWNvcmQKCnMvZXhwZXJpbWVudGFsX3ZlcmlmeSBvcHRpb25zL3RoZSBleHBl
cmltZW50YWxfdmVyaWZ5IG9wdGlvbi8KCj4gbm9ybWFsIEkvTyBtZXRhZGF0YSB0byBjcmVhdGUg
dmVyaWZ5IHJlYWQgdW5pdC4gSW5zdGVhZCwgZmlvIHJlc2V0cyBmaWxlCj4gc3RhdHVzIGFmdGVy
IG5vcm1hbCBJL08gYW5kIGJlZm9yZSB2ZXJpZnkgc3RhcnQsIHRoZW4gcmVwbGF5IEkvT3MgdG8K
PiByZWdlbmVyYXRlIHdyaXRlIHVuaXQgYW5kIGFkanVzdCBpdCB0byB2ZXJpZnkgcmVhZC4gVGhp
cyBJL08gcmVwbGF5IGRvZXMKPiBub3Qgd29yayBmb3Igem9uZW1vZGU9emJkIHNpbmNlIHpvbmUg
c3RhdHVzIG5lZWRzIHRvIGJlIHJlc3RvcmVkIGF0Cj4gdmVyaWZ5IHN0YXJ0IHRvIHRoZSBzdGF0
dXMgYmVmb3JlIHRoZSBub3JtYWwgSS9PLiBIb3dldmVyLCBzdWNoIHN0YXR1cwo+IHJlc3RvcmUg
bW92ZXMgd3JpdGUgcG9pbnRlcnMgYW5kIGVyYXNlcyBkYXRhIHBhdHRlcm4gZm9yIHZlcmlmeS4K
PiAKPiBDaGVjayB0aGF0IHRoZSBvcHRpb25zIGV4cGVyaW1lbnRhbF92ZXJpZnkgYW5kIHpvbmVt
b2RlPXpiZCBhcmUgbm90Cj4gc3BlY2lmaWVkIHRvZ2V0aGVyIGFuZCBlcnJvciBvdXQgaW4gY2Fz
ZSB0aGV5IGFyZSBib3RoIHNwZWNpZmllZC4gQWxzbwo+IHJlbW92ZSB0aGUgaGVscGVyIGZ1bmN0
aW9uIHpiZF9yZXBsYXlfd3JpdGVfb3JkZXIoKSB3aGljaCBpcyBjYWxsZWQgZnJvbQo+IHpiZF9h
ZGp1c3RfYmxvY2soKS4gVGhpcyBmdW5jdGlvbiBhZGp1c3RzIHZlcmlmeSByZWFkIHVuaXQgdG8g
bWVldCB6b25lCj4gd3JpdGUgcmVzdHJpY3Rpb25zIGZvciBleHBlcmltZW50YWwgdmVyaWZ5LCBi
dXQgc3VjaCBhZGp1c3RtZW50IGRvZXMgbm90Cj4gd29yayBiZWNhdXNlIHpvbmUgc3RhdHVzIGlz
IG5vdCByZXN0b3JlZCBiZWZvcmUgdmVyaWZ5IHN0YXJ0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+CgpUaGFua3Mg
Zm9yIGtpbGxpbmcgemJkX3JlcGxheV93cml0ZV9vcmRlcigpISBJdCBuZXZlciB3b3JrZWQgMTAw
JSBhbmQgd2FzIHZlcnkKZnJhZ2lsZS4KCldpdGggdGhlIGNvbW1pdCBtZXNzYWdlIG5pdCwgbG9v
a3MgZ29vZC4KClRlc3RlZC1ieTogRG1pdHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2Rj
LmNvbT4KUmV2aWV3ZWQtYnk6IERtaXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5j
b20+Cj4gLS0tCj4gwqB6YmQuYyB8IDQ2ICsrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KPiDCoHpiZC5oIHzCoCAyIC0tCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgNDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL3piZC5jIGIv
emJkLmMKPiBpbmRleCBiMmY0Mzg2MC4uYmE5YjlmZWUgMTAwNjQ0Cj4gLS0tIGEvemJkLmMKPiAr
KysgYi96YmQuYwo+IEBAIC0yODgsNyArMjg4LDYgQEAgc3RhdGljIGludCB6YmRfcmVzZXRfem9u
ZShzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLCBzdHJ1Y3QKPiBmaW9fZmlsZSAqZiwKPiDCoMKgwqDC
oMKgwqDCoMKgcHRocmVhZF9tdXRleF91bmxvY2soJmYtPnpiZF9pbmZvLT5tdXRleCk7Cj4gwqAK
PiDCoMKgwqDCoMKgwqDCoMKgei0+d3AgPSB6LT5zdGFydDsKPiAtwqDCoMKgwqDCoMKgwqB6LT52
ZXJpZnlfYmxvY2sgPSAwOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHRkLT50cy5ucl96b25lX3Jl
c2V0cysrOwo+IMKgCj4gQEAgLTEwODIsNiArMTA4MSwxMSBAQCBpbnQgemJkX3NldHVwX2ZpbGVz
KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQpCj4gwqDCoMKgwqDCoMKgwqDCoGlmICghemJkX3Zlcmlm
eV9icygpKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDE7Cj4gwqAK
PiArwqDCoMKgwqDCoMKgwqBpZiAodGQtPm8uZXhwZXJpbWVudGFsX3ZlcmlmeSkgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsb2dfZXJyKCJ6b25lbW9kZT16YmQgZG9lcyBub3Qg
c3VwcG9ydCBleHBlcmltZW50YWwgdmVyaWZ5XG4iKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIDE7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICsKPiDCoMKgwqDCoMKgwqDC
oMKgZm9yX2VhY2hfZmlsZSh0ZCwgZiwgaSkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IHpvbmVkX2Jsb2NrX2RldmljZV9pbmZvICp6YmQgPSBmLT56YmRfaW5mbzsK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBmaW9fem9uZV9pbmZvICp6
Owo+IEBAIC0xNTE4LDQyICsxNTIyLDYgQEAgb3V0Ogo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
ejsKPiDCoH0KPiDCoAo+IC0vKiBUaGUgY2FsbGVyIG11c3QgaG9sZCB6LT5tdXRleC4gKi8KPiAt
c3RhdGljIHN0cnVjdCBmaW9fem9uZV9pbmZvICp6YmRfcmVwbGF5X3dyaXRlX29yZGVyKHN0cnVj
dCB0aHJlYWRfZGF0YSAqdGQsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgc3RydWN0IGlvX3UgKmlvX3UsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGZpb196b25lX2luZm8gKnopCj4gLXsKPiAtwqDCoMKg
wqDCoMKgwqBjb25zdCBzdHJ1Y3QgZmlvX2ZpbGUgKmYgPSBpb191LT5maWxlOwo+IC3CoMKgwqDC
oMKgwqDCoGNvbnN0IHVpbnQ2NF90IG1pbl9icyA9IHRkLT5vLm1pbl9ic1tERElSX1dSSVRFXTsK
PiAtCj4gLcKgwqDCoMKgwqDCoMKgaWYgKCF6YmRfb3Blbl96b25lKHRkLCBmLCB6KSkgewo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB6b25lX3VubG9jayh6KTsKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgeiA9IHpiZF9jb252ZXJ0X3RvX29wZW5fem9uZSh0ZCwgaW9f
dSk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzc2VydCh6KTsKPiAtwqDCoMKg
wqDCoMKgwqB9Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoGlmICh6LT52ZXJpZnlfYmxvY2sgKiBtaW5f
YnMgPj0gei0+Y2FwYWNpdHkpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9n
X2VycigiJXM6ICVkICogJSJQUkl1NjQiID49ICUiUFJJdTY0IlxuIiwKPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGYtPmZpbGVfbmFtZSwgei0+dmVyaWZ5
X2Jsb2NrLCBtaW5fYnMsIHotPmNhcGFjaXR5KTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgLyoKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogSWYgdGhlIGFzc2Vy
dGlvbiBiZWxvdyBmYWlscyBkdXJpbmcgYSB0ZXN0IHJ1biwgYWRkaW5nCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqICItLWV4cGVyaW1lbnRhbF92ZXJpZnk9MSIgdG8gdGhlIGNv
bW1hbmQgbGluZSBtYXkgaGVscC4KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICov
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzc2VydChmYWxzZSk7Cj4gLcKgwqDC
oMKgwqDCoMKgfQo+IC0KPiAtwqDCoMKgwqDCoMKgwqBpb191LT5vZmZzZXQgPSB6LT5zdGFydCAr
IHotPnZlcmlmeV9ibG9jayAqIG1pbl9iczsKPiAtwqDCoMKgwqDCoMKgwqBpZiAoaW9fdS0+b2Zm
c2V0ICsgaW9fdS0+YnVmbGVuID49IHpiZF96b25lX2NhcGFjaXR5X2VuZCh6KSkgewo+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsb2dfZXJyKCIlczogJWxsdSArICVsbHUgPj0gJSJQ
Ukl1NjQiXG4iLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZi0+ZmlsZV9uYW1lLCBpb191LT5vZmZzZXQsIGlvX3UtPmJ1ZmxlbiwKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHpiZF96b25lX2NhcGFjaXR5X2Vu
ZCh6KSk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzc2VydChmYWxzZSk7Cj4g
LcKgwqDCoMKgwqDCoMKgfQo+IC3CoMKgwqDCoMKgwqDCoHotPnZlcmlmeV9ibG9jayArPSBpb191
LT5idWZsZW4gLyBtaW5fYnM7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiB6Owo+IC19Cj4g
LQo+IMKgLyoKPiDCoCAqIEZpbmQgYW5vdGhlciB6b25lIHdoaWNoIGhhcyBAbWluX2J5dGVzIG9m
IHJlYWRhYmxlIGRhdGEuIFNlYXJjaCBpbiB6b25lcwo+IMKgICogQHpiICsgMSAuLiBAemwuIEZv
ciByYW5kb20gd29ya2xvYWQsIGFsc28gc2VhcmNoIGluIHpvbmVzIEB6YiAtIDEgLi4gQHpmLgo+
IEBAIC0xOTA0LDEwICsxODcyLDggQEAgZW51bSBpb191X2FjdGlvbiB6YmRfYWRqdXN0X2Jsb2Nr
KHN0cnVjdCB0aHJlYWRfZGF0YQo+ICp0ZCwgc3RydWN0IGlvX3UgKmlvX3UpCj4gwqAKPiDCoMKg
wqDCoMKgwqDCoMKgc3dpdGNoIChpb191LT5kZGlyKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoGNhc2Ug
RERJUl9SRUFEOgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodGQtPnJ1bnN0
YXRlID09IFREX1ZFUklGWUlORyAmJiB0ZF93cml0ZSh0ZCkpIHsKPiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHpiID0gemJkX3JlcGxheV93cml0ZV9vcmRl
cih0ZCwgaW9fdSwgemIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodGQt
PnJ1bnN0YXRlID09IFREX1ZFUklGWUlORyAmJiB0ZF93cml0ZSh0ZCkpCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBhY2NlcHQ7Cj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIENoZWNrIHRo
YXQgdGhlcmUgaXMgZW5vdWdoIHdyaXR0ZW4gZGF0YSBpbiB0aGUgem9uZSB0byBkbyBhbgo+IGRp
ZmYgLS1naXQgYS96YmQuaCBiL3piZC5oCj4gaW5kZXggMGE3M2I0MWQuLmQ0MjU3MDdlIDEwMDY0
NAo+IC0tLSBhL3piZC5oCj4gKysrIGIvemJkLmgKPiBAQCAtMjUsNyArMjUsNiBAQCBlbnVtIGlv
X3VfYWN0aW9uIHsKPiDCoCAqIEBzdGFydDogem9uZSBzdGFydCBsb2NhdGlvbiAoYnl0ZXMpCj4g
wqAgKiBAd3A6IHpvbmUgd3JpdGUgcG9pbnRlciBsb2NhdGlvbiAoYnl0ZXMpCj4gwqAgKiBAY2Fw
YWNpdHk6IG1heGltdW0gc2l6ZSB1c2FibGUgZnJvbSB0aGUgc3RhcnQgb2YgYSB6b25lIChieXRl
cykKPiAtICogQHZlcmlmeV9ibG9jazogbnVtYmVyIG9mIGJsb2NrcyB0aGF0IGhhdmUgYmVlbiB2
ZXJpZmllZCBmb3IgdGhpcyB6b25lCj4gwqAgKiBAbXV0ZXg6IHByb3RlY3RzIHRoZSBtb2RpZmlh
YmxlIG1lbWJlcnMgaW4gdGhpcyBzdHJ1Y3R1cmUKPiDCoCAqIEB0eXBlOiB6b25lIHR5cGUgKEJM
S19aT05FX1RZUEVfKikKPiDCoCAqIEBjb25kOiB6b25lIHN0YXRlIChCTEtfWk9ORV9DT05EXyop
Cj4gQEAgLTM5LDcgKzM4LDYgQEAgc3RydWN0IGZpb196b25lX2luZm8gewo+IMKgwqDCoMKgwqDC
oMKgwqB1aW50NjRfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RhcnQ7Cj4gwqDC
oMKgwqDCoMKgwqDCoHVpbnQ2NF90wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB3cDsK
PiDCoMKgwqDCoMKgwqDCoMKgdWludDY0X3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGNhcGFjaXR5Owo+IC3CoMKgwqDCoMKgwqDCoHVpbnQzMl90wqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB2ZXJpZnlfYmxvY2s7Cj4gwqDCoMKgwqDCoMKgwqDCoGVudW0gemJkX3pvbmVf
dHlwZcKgwqDCoMKgwqDCoHR5cGU6MjsKPiDCoMKgwqDCoMKgwqDCoMKgZW51bSB6YmRfem9uZV9j
b25kwqDCoMKgwqDCoMKgY29uZDo0Owo+IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnTCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBoYXNfd3A6MTsKCg==
