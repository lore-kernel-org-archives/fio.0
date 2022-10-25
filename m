Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB7DC38A2D
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiJYXyQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiJYXyP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:54:15 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18FEC34FB
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742054; x=1698278054;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7exSiqknrGuvda+51JDETw1iW3l8ZyEvM61D+v0kmrg=;
  b=KzzByOC7YKTC6NfmmW8o7FLWeTZ7FAMQJz2PLVXv/Vrbdlr+caA4LVb8
   sBqAji6PBBdYKvIS41vMakCi32UdWxm02TyfN0YrGXjsHsgBxZJbfbq/c
   NPN2RGCornqjbOAG5xzqPiEH4zadkAuQwHDxbx52L4yZOt6SxL0h10aCg
   YF+vl4HamrUqDqtMlpdpDj4hd0koPhTyVwNgUtHsoaYEsBBmTk/zCz/Y/
   DdELKP6Ml27hdlQn3Qj3kvVhAczehp1aiKmHWvGsHC+g5Zatoj3w9X4Vy
   9zN+dGoUipmy8+QCXBjg4rCbG0O0N5BHXZucHxtvCykmsxOCDcXmJsfQi
   A==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="215099601"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:54:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWlbVqHFfH5LX7oNTFET89m8dU7kSnzu+ES+yp5/8u80Yv4S/rdSscRxIM1IRHNyrYOGKzi+bdowNCIHWFdW4MbDfMXX19LOslXv+M8Smymz9Dm01l/dgnVrb5pv27n/4K5vittVaaZK6nwV/IzK95k5blVQoSsjG6BBOewXtmprkXd+zCqPpnSMUYwM5Xl4nSzz/2xcv2f8aD+TG3bitfd4Et7DNGg1zqkclIHAHic956mBH1uukL9KozNJUy0oPlXT1uoB36NssG4FFZUa2fPpuup6KlAjOP4j2QR49HHJOrwOULVjrHmT5AKNAwCLm4TtOl3by7b43Vm9B2xzgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7exSiqknrGuvda+51JDETw1iW3l8ZyEvM61D+v0kmrg=;
 b=ZnKXdkf0I72K+lhDKxnPWF/4sX4awDgjlMUHMChBpUGSYgL7pNTKYTMDFkyjSItYpT35sNQSzXCqx1dCaOqkaLgbihevB/vfZOzkG2qTdGsztok0nVf4BOeCSMYIVwINHicubA84/XeySoK4N8CG7wwCZsGwWf/oymCearEY4ZFVqySd39FJ/LmVfPeSWhgL7oi99vLwSBYlRtuAPJ/dsDQxe8LNVjNQIsHwgaqVOOtmjZoLdjau5NthVL74ny7NrBEboqOhWtdXiiq0xkUK4DwTE4u+EgEuHrsiCvY748Z2wJRSE5t1Tt5+LmZAG+skKqwZyM11eX0ZIt0s3tdwsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7exSiqknrGuvda+51JDETw1iW3l8ZyEvM61D+v0kmrg=;
 b=OZtxJ+5VD5NQ71QpJZLiRgm2TSu8Hxti4Bk5QGPB1brHr0PYACDXiDSxKxVU3sTuGRC3SOs2OUbHXtIfiCgUX32YpV0nvkaMAx64n9rfz217aX0KSLcv/+b5s9LpQsW884LsI6i2XTNY0BPG4n3XYZbNfsgmJsnDHM5WTyULq+U=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:54:12 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:54:12 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 06/11] zbd: fix zone reset condition for verify_backlog
 option
Thread-Topic: [PATCH 06/11] zbd: fix zone reset condition for verify_backlog
 option
Thread-Index: AQHY5RcyXhcjL6Fr/EGJ6Cuch3Czra4fz/mA
Date:   Tue, 25 Oct 2022 23:54:12 +0000
Message-ID: <b07229fb5444c754aa2f40bb1b664ae5da703a06.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-7-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: 3f9228b5-a3fe-4e43-4733-08dab6e43723
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KAN6+SCmsophVcyIAM63BqrKJ42SlplAT+7xeSmzoDWz93QJk6WHO7AAi8MQ8mmBw4jGecAsd32jQHapCO6VslfR5rcY3ZyxoCDz5jUtEQgxJnTWeNFNWUmCEaTm06Czkx1jMqvaFFF98B9CuH/jmLIbSGPZx5KMqkU3QKI5zhYfzyTwHzj4MDZeAtVFsFLgF70DsOa0ftwugufxomvxRDyxxnHiXuxdbdOWf976GMIHQA4lxAIpjnNqrySNUCPjwarianDZdmCqKuc/iSgijIZvq00gBSVaZNiZCKIeekYXvMujKhFk+0XPcW64uGZA6OgrYsrYt8xb7qmcrnrFUEVfMn5au0gDPpGOv/UPWQuXGRmm1Iakl5otBpZX8UEfflar2nd9F9i0o4ZsfFOCliLmYY66bsdj09LtxPn+BCx+WXp6aoscEXJIZpbOZxeNDH+NoyvlR6cXoxqeQ0tWbFhqs3JmZHYX3lzHKBHRnLZXTlW8u7SqZQ3OLhMQVEerh7Bm1E8lpC4v6y37bsUpbRKs4Fbpq4Jgi4rECdJxSrV1TzyReEkX8VOXg7vaEhjD1p14u8b8Ho97xeGlTOiAL8RpdFu8K5c+TBY7tCycl55mwaIsJ4jlxT62B0/ujDtp/2ctZrvKq/+1zdIYl4fFEzH/Tngn01kyWxmkWfK46DBOs6mizLNDWruK+r/h5V61kAU6zAgSLJM8jkuP7zsSXrgPtE9OI9QgAWmo2Ikxz4QuCmdZTg++GXEX9R+OrelMTMxRjBU4svfkdGRUCxm46g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(15650500001)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDhXYmxTVUxvYUczejBlRFBVL3Z1b096UEZRU2poMXRsOHNLdW1EWGh0dDVo?=
 =?utf-8?B?dUhxQ2Z4THNsWnFsZUdBTlBwSGxlUUVZSm9kcEIxUXhsTFZmaVRxYVRtMW5R?=
 =?utf-8?B?cjZHcjN1QkVHQ0ROcm83TEVuTDFXNm44dGRnaUNFQi9DUEswUVpTV2gzMVJu?=
 =?utf-8?B?UWhod1plNXpWUC94M0ZiY0dmUkVOdW5qNU5YU3ZFY0FTektLS1JSR3FkMnVw?=
 =?utf-8?B?Qi9JM2VMWnBZdEZXK1dVR1pFWDlpSVJkRkN6R01uTlpaRE55S1pCbmtvZDVS?=
 =?utf-8?B?Z3BTMUttMGpjN2lmMzVZTHlSRkhEajNQaWlaYk9DTHBLNFhtYlJ2dmRSZ3Z0?=
 =?utf-8?B?R1cxZC9vcnlFaDE5OVNMSHVtTkpGV05CRnRJT1M3d2pNdlR4Z2daNDhCRkl4?=
 =?utf-8?B?RmZQQXdBN3FYdnVMTjlzRkRxbEZNYndKWWl0blJydXlXU2J1VmlmQXM5N3ly?=
 =?utf-8?B?dHYzVmxuR0gyV2FrTmFsbVRVZENZMnEvRUNCRDBEZnpxT05KbzNXdlpMQXpy?=
 =?utf-8?B?UC9ZR3FybnFpQkl3RVUxTFpPZTM1N2RoR2F4WmNBR21nd1VVL2gyYit3dDlH?=
 =?utf-8?B?QkxQMXNXNU1KSC9ieUN5bjNQMGI5WXZwNHFNUTVyMVlRaE1EK2pUdGpacDVm?=
 =?utf-8?B?NTFWbVBXeEp4NkE3R2NyRUNFSmRqM1BFYkpGckkyM3NYMkJpMURDQjU5RHc3?=
 =?utf-8?B?MlA3aDg4WWxyZ1BvakhxT3d1ZDBtY29RbmZwZDdwYWRxM3JyS0dSWkxqWk8x?=
 =?utf-8?B?WUNoU3l4ZEEvM0FQazN5dVlRRTNnZGJnRmlGc29kZGZmOXBVbGZyV29TOHNr?=
 =?utf-8?B?MkZqSVkyZmVmK1BjZ0VlVC83WlVHZTRnazZoalo3Q1B2ZEhmQTQrdHZVTkJz?=
 =?utf-8?B?YVlveFkzT1VSSTlpWEdYZllPOEpvL3RUSUkyWXhseENoaFFhTEdKS0QrRjJu?=
 =?utf-8?B?TitGMTNQbDRwRXNsNVZyZS81ZjVBYndjQVJzTS9lemxKOTJQcHhQMmw5WTJr?=
 =?utf-8?B?elhQMjhmdmx1bnRLNHhZWW9PVVQ1cFJxQ2djWWpFc01JcmEzVlR0SzA1OGVF?=
 =?utf-8?B?SXVLWUVhd1FnSGN1Q0NlWWhXWHp1bmt2Umw5YVpNcXhiMFlQWWV4eEo4K2lM?=
 =?utf-8?B?WXRhQzNjS2NUdjVPTmNzQ0t4V2dsQVg5NUhiRWh2R0QwbVBIclpEUm9xc2dh?=
 =?utf-8?B?NkFNelpMS2xac2xUNVFYWVUzekpTRVRBdGFLUXpPSXk1L1k0Y2ZIQXd5eTRM?=
 =?utf-8?B?QU80TW0xQ2o4K3hHVGovMXRjci9KM1huSFBOWDdVTGVjdWtDVnFHTEtiOWpM?=
 =?utf-8?B?MjdwZFkvalk1UzJLYlpjOXFiSUxDSmhRVjZEdDVyRWk3R2Y5YU13S1Bydnll?=
 =?utf-8?B?Y253MTRaaHBFcGVPQnRENHRQOWMxbU45b0tKQithNGJGMjN5YUw3N09CSFRF?=
 =?utf-8?B?dWdCMWhTeW96dS9wcFVQNHpURlg1azJlRXBXNzBEbmUza2M2bWdwVHlCMG1N?=
 =?utf-8?B?aDUwYnl5dXVOMVVaL3oyWXlKTXFXbUYzdTltTGJoTDZ2S1hmOEVtc1VNLy91?=
 =?utf-8?B?OTY1UXU4OWRXcTVORE5NYnh4LzdkR1AzbmVvTnZEa0djb3ZJTnIvWGcvQmNi?=
 =?utf-8?B?NkJLbmRPTmNSZno4Z010WHNyOGM1amYyU2FmQm02dm5uOHN6WGVzTzJ5V3NW?=
 =?utf-8?B?Ymd4N0FPVzVEVjQyQlVpdi9OWGJxeW9VV0laZ3VhS1p6V1Y1N2Iza1RCQUdM?=
 =?utf-8?B?UGNJUEwxVjV6ZWtUZ3QwRjBxam5CWkxmNERXZTQzZ1J5U3ozWnlqbWN6NzhS?=
 =?utf-8?B?VjJVZXlHMElVTElDOVpZUk1SVUJSdzFiTzdjM0hISlZLZnM0bUVyNitaR0VS?=
 =?utf-8?B?SEQ2NXNsMm83dEtrWkpFQU5QOHFPZ2Rmb1dkdUVFcWhQZHdsSWs0S2EzdmpK?=
 =?utf-8?B?RGw1Z1IzbzBDYTkwTnpuK1QvRVJUMGhWeldVSXllMlJRb2xROVlnYkQyRHVi?=
 =?utf-8?B?Nkx5bndjSVNuN3R0aDJOdzBxRXV3eUNHcCt4dmdoRlZTMEoyWTZjNEMzNUdK?=
 =?utf-8?B?endDZ2N6ZGFMdUV2MjhVUzIwNDYxV295REp6ZWFtNTA5M050UVVlQy9aMXlp?=
 =?utf-8?B?OS9paVFEeVlZam8rcUJoa0E3Q05uNkE4UzBQWTcrTlFWdG9qVWZ1T0kyMTVJ?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81C23C564881C64DB1D434D10EDF01B6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9228b5-a3fe-4e43-4733-08dab6e43723
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:54:12.0047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mVssKko28BRRXEx9XLEVTcQbhCwuuk0bzz/S3vHUIgjbn8NGQoy7UtPTn35Dm9zGHbMWA04K2RO/WjJVI1SJIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gV2hlbiB2ZXJpZnkgb3B0aW9ucyBpcyBzcGVjaWZpZWQsIHpiZF9maWxlX3Jlc2V0
KCkgcmVzZXRzIHpvbmVzIG9ubHkNCg0Kcy92ZXJpZnkgb3B0aW9ucyBpcyBzcGVjaWZpZWQvZGF0
YSB2ZXJpZmljYXRpb24gaXMgcmVxdWVzdGVkLw0KDQo+IHdoZW4gdGQgc3RhdHVzIGlzIG5vdCBU
RF9WRVJJRllJTkcgc28gdGhhdCB0aGUgZGF0YSB0byByZWFkIGJhY2sgZm9yDQo+IHZlcmlmeSBp
cyBub3Qgd2lwZWQgb3V0LiBIb3dldmVyLCB3aGVuIHZlcmlmeV9iYWNrbG9nIG9wdGlvbiBpcyBz
ZXQsIHRoZQ0KPiB2ZXJpZnkgZGF0YSBjYW4gYmUgbGVmdCBldmVuIGlmIHRkIHN0YXR1cyBpcyBu
b3QgVERfVkVSSUZZSU5HIC4gVGhpcw0KDQpUaGVyZSBpcyBhbiBleHRyYSBzcGFjZSBiZWZvcmUg
dGhlIGNvbW1hIGFib3ZlLi4uDQoNCj4gY2F1c2VzIHZlcmlmeSBmYWlsdXJlLg0KPiANCj4gRml4
IHRoaXMgYnkgaW1wcm92aW5nIHRoZSBjb25kaXRpb24gdG8gcmVzZXQgem9uZXMgaW4gemJkX2Zp
bGVfcmVzZXQoKS4NCj4gUmVmZXIgbm90IG9ubHkgdGQgc3RhdHVzIGJ1dCBhbHNvIHZlcmlmeV9i
YXRjaCBhbmQgaW9faGlzdF9sZW4gdmFsdWVzIHRvDQo+IGF2b2lkIHpvbmUgcmVzZXQgd2hlbiB2
ZXJpZnlfYmFja2xvZyBvcHRpb24gaXMgc2V0LiBUaGlzIGlzIHNhbWUgY2hlY2sNCj4gYXMgY2hl
Y2tfZ2V0X3ZlcmlmeSgpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNh
a2kgPHNoaW5pY2hpcm8ua2F3YXNha2lAd2RjLmNvbT4NCg0KV2l0aCB0aGUgY29tbWl0IG1lc3Nh
Z2Ugbml0cywgbG9va3MgZ29vZC4NCg0KVGVzdGVkLWJ5OiBEbWl0cnkgRm9taWNoZXYgPGRtaXRy
eS5mb21pY2hldkB3ZGMuY29tPg0KUmV2aWV3ZWQtYnk6IERtaXRyeSBGb21pY2hldiA8ZG1pdHJ5
LmZvbWljaGV2QHdkYy5jb20+DQoNCj4gLS0tDQo+IMKgemJkLmMgfCA2ICsrKysrLQ0KPiDCoDEg
ZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS96YmQuYyBiL3piZC5jDQo+IGluZGV4IDM4NTVhYjBlLi5iMmY0Mzg2MCAxMDA2NDQN
Cj4gLS0tIGEvemJkLmMNCj4gKysrIGIvemJkLmMNCj4gQEAgLTEyNDYsNiArMTI0Niw3IEBAIHZv
aWQgemJkX2ZpbGVfcmVzZXQoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0DQo+IGZpb19m
aWxlICpmKQ0KPiDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBmaW9fem9uZV9pbmZvICp6
YiwgKnplOw0KPiDCoMKgwqDCoMKgwqDCoMKgdWludDY0X3Qgc3dkOw0KPiArwqDCoMKgwqDCoMKg
wqBib29sIHZlcmlmeV9vbmdvaW5nOw0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFmLT56
YmRfaW5mbyB8fCAhdGRfd3JpdGUodGQpKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybjsNCj4gQEAgLTEyNjIsNyArMTI2MywxMCBAQCB2b2lkIHpiZF9maWxlX3Jlc2V0
KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdA0KPiBmaW9fZmlsZSAqZikNCj4gwqDCoMKg
wqDCoMKgwqDCoCAqIHdyaXRpbmcgYW55IGRhdGEgdG8gYXZvaWQgdGhhdCBhIHpvbmUgcmVzZXQg
aGFzIHRvIGJlIGlzc3VlZCB3aGlsZQ0KPiDCoMKgwqDCoMKgwqDCoMKgICogd3JpdGluZyBkYXRh
LCB3aGljaCBjYXVzZXMgZGF0YSBsb3NzLg0KPiDCoMKgwqDCoMKgwqDCoMKgICovDQo+IC3CoMKg
wqDCoMKgwqDCoGlmICh0ZC0+by52ZXJpZnkgIT0gVkVSSUZZX05PTkUgJiYgdGQtPnJ1bnN0YXRl
ICE9IFREX1ZFUklGWUlORykNCj4gK8KgwqDCoMKgwqDCoMKgdmVyaWZ5X29uZ29pbmcgPSB0ZC0+
cnVuc3RhdGUgPT0gVERfVkVSSUZZSU5HIHx8IHRkLT52ZXJpZnlfYmF0Y2g7DQo+ICvCoMKgwqDC
oMKgwqDCoGlmICh0ZC0+aW9faGlzdF9sZW4gJiYgdGQtPm8udmVyaWZ5X2JhY2tsb2cpDQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2ZXJpZnlfb25nb2luZyA9IHRkLT5pb19oaXN0
X2xlbiAlIHRkLT5vLnZlcmlmeV9iYWNrbG9nOw0KPiArwqDCoMKgwqDCoMKgwqBpZiAodGQtPm8u
dmVyaWZ5ICE9IFZFUklGWV9OT05FICYmICF2ZXJpZnlfb25nb2luZykNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB6YmRfcmVzZXRfem9uZXModGQsIGYsIHpiLCB6ZSk7DQo+IMKg
wqDCoMKgwqDCoMKgwqB6YmRfcmVzZXRfd3JpdGVfY250KHRkLCBmKTsNCj4gwqB9DQoNCg==
