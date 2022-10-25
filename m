Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1DEC38A2D
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiJYXxK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiJYXxJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:53:09 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5CC34D1
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666741988; x=1698277988;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kL1O0/iVWKex7uRpFpoX8ZLAHZnsWKoxuoS1zcvgs5A=;
  b=IbEIYpxGtdjNph0wCTms6Qcx4+BbXcqxxDw9Dj+vNqVDaGjJgpBSobFH
   oy1oMBleFXoe/qSXSvYOJP/c+hI0d0zmWWbIf0RIq5b/zCmLNMyw/fLpA
   K69p0Y93B33Ux9f2KK5KNwfdL+6iZx/i/2whBIl3+sTuOcm5mKeujoziR
   yTbm0BIo4nyZDWRbC3B5E9PC4hxA2MTVMchVgdbix1N/ZhYSv5S8bL91W
   ipposj9lYKHFI0YsbrTszYCSudHCWVgHeOl5fw6iz+yFXneR4EoDQd3Wv
   17sLqL91+zVd+tF7tVoDwFVoxn3XWiP5ad03xlZfG3mV8wsZ6saovyttn
   g==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="214730420"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:53:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxxXImGCccjj1T/7HdzwcDSAgP20HOCmKeQ56Nr20hW5tREtM/yBt88HpZ8ZuWuNXE1iqm9uKK64ZnqJ2cGT4kqHUUTbiyNBpTCkcOtSIEJzUz/CEQ8OXJQCB+ueBURGlsf2QaI86wsmLUZMLtSl4/iAIr6h2MB5rE3IEH+VDrn07VXkup3J6J0LAyoQXnEJgGYEomW0ls467iP0HzlIdsvu+7dY+/dgeC8Woc1QulXSFr6WDYl1PYVUw07GD4GDWiKR7vq3C0m7vNG7w39KniZcQ+ecLLc+ZZ56wxEPCwTV9rlYrLdiNHeIq9guyGpG9nUWAELpuF4sK7wtZ7GvQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kL1O0/iVWKex7uRpFpoX8ZLAHZnsWKoxuoS1zcvgs5A=;
 b=KwTDHpJTxFhBTwlGBCDD7GMDI0CaVbfp2bz/7vHL4Hjr8nHgSHwyNU1E8BvB4aWd5jClkSMuyLsNwWVONlNGj/WAQiYNgCqhchlGWbP+y7sGaX8LuC2sXXZOUKXeKuXKvk+cZzP1yuPVaG2JleMSIiHO9pZYGU0bYHBQzG+Iz/meCqFx5hnqkQYdxtNwMiJXiSvUU2ayZc1jWiOrpqiZpbrlEuTmQ5fWmCCKfjU+WLsOzglfhtXt/PWxu04lpXuB8OFfImfJHNJmUIkHpBtukhU1cKtHoKZQYcVw1QufHzJ8j+nMwIhpgCrjgf6j5zCg+WcsVjxukOjyeGpFrtnA0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kL1O0/iVWKex7uRpFpoX8ZLAHZnsWKoxuoS1zcvgs5A=;
 b=HDkgK6CRsJnqDJ4MpkbD47flmF9+D7nRb1sdlCNEJHpz2pW8xryA7gob1X7jXFuU6aqmSeuH4UA805u0LNJmlQexDtiDFIZW3mdblR6cJbk/b+ucpYScNjoo58Vjr9O1WEdArA/8araoaQ5yL6Oc4dDXqkz2b18cep6BjsCK1ZY=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:53:06 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:53:06 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 04/11] zbd: allow block size not divisor of zone size
Thread-Topic: [PATCH 04/11] zbd: allow block size not divisor of zone size
Thread-Index: AQHY5RcqZnv/xIkwBE2F5tJ6gCn3kq4fz6uA
Date:   Tue, 25 Oct 2022 23:53:06 +0000
Message-ID: <f012f00ef374a800858664a5129f31be8763a73b.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: 571aca63-b94b-48c8-bc4a-08dab6e41014
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: giPtRU7Wzm5nQhJ4ecElLmaZmVLX3xMe3mr8h9TfzxOE6p5KgpUYSgTmPJ+FbK5XccLLeH+uwpKy8zu/ImDVQKW79dXQcy4zIOpuhfNLFz7rFLb2/WixY8EmrFc3jvl5hx2eQrN3Pov9yugfIjgnc5GQsbl7Feyio+IxXffSlinv+o5sGoREeGa7H8PL+XgrgaYhcvJZXGbKqXP5tTMcClJ5eHEohjD7Jo8KF2hcgcowY0YNyPrmiIynqlw+OOgf+WczMKJrtuV91OZJc7f003DgYBW1ZmyCTeXalabAMctn6QMMhueNxI6oRu64v4NB0xcUvXEdVq7zyG1TXgDkK9k2CmeJrCc/H0FFfFFnT7Bpmptmwup++5VzjeXMqesLcMBe1y+GYHVtwNn9YhPSt1knoQErpmfViiPyukhGsQ+Vn9xaSxPGyijYyPBw+im1UKkwXePh3MfwTSzHqleYsHnTAHarjhVa8Rfw2+RgRB8dqV60H927a7htCo/lIONP9j8DMV+Xqo22C/qUiKktxjr+qkzQmlWvR4UyXb8eKkCncF1bEuQD/J6kPXOOzgdxe/Nc7CIKk0sBYKdCIvh/1Qlvz+swlc0Lqc8OsQJkF0RVDPyxdTQHc1b6aE5Gdn58meqWEjUtDD1fhd0UBv+gZIEz+Fa5hkJAa5a1r1fTDc/HFfCPyA2wDLPbm1cEu8TKSYPcHDJcIJ3ub3exQsgNXFcl5FGDJM/0g7vDWkC5R6BVIIhNwkkStJxIo2rKmaa2LVrFywWGInP6qQ3xI1wqww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2dEcE5kUk9HYnpMRFBhVnZFdFI1WTdOTWlLbG5zK0pndGZ1MnFQUFlDRTN0?=
 =?utf-8?B?YmI3NGFqSHpwMWJoVlhqeTJKb1g2YjVCY0pjcTE3YlRlSDNzMERYMC9LUW9V?=
 =?utf-8?B?MlZPeFJwM0cvdFVENHVMeHlpR0owL1ErYUkzb3kycU1CeVByU3luSy96M0VT?=
 =?utf-8?B?VnVVb2I4YkFQeENzZk04M0FsS05YbndZbkFZbDRCRmkzcnBpTFNLWWdFTWR4?=
 =?utf-8?B?UjZJY2owUkJ1alFVSUxHSnpMV2VhOGdaRElvQkRWbkN2Y0lmRUhvcDRoVWZs?=
 =?utf-8?B?dzdNVXllZi9FYVEyNjN5SEJDQVhiK2F3RU5NM0xROFc3Mno0UVBEVmZENFdq?=
 =?utf-8?B?TGVOUU5aelMrZDd6UHI2R0ZvdzNCUmVTcnl0VE9hQ3NnSEZ4NHl0R3Q3ZXBx?=
 =?utf-8?B?UHNWbmdPZFZLcGtRNis1TE5QTnYwbnduZ2lyaDRvMzZzckRBQ2dNOVNFNFkx?=
 =?utf-8?B?cTNzWVhvbmlNcFo0d29ZWW1WQXBUZVl4T2F4UXczZklGdklOb3JpZk4wbDBQ?=
 =?utf-8?B?aCtaSXJwQjBoWWJoWnJOTnBqWVVGR2VaeTYyaVhmMGs5WVhvWnZEMmdpVVVW?=
 =?utf-8?B?N0ZhUUN6dElZL2RFSU5nUnpsb1dvZ3puYWRmRXdQZTZrc1hBeG5EclBjVTU1?=
 =?utf-8?B?eXZQUXFSWDVCYmxOVFJHRFEvOWlUVGQwV2ZxSWNqbXdIOHJqM1BqUzMxbWVV?=
 =?utf-8?B?MFVQRlkvVndlSFhUbEVtVkxZMUN4d25QV3d5eU53UzAwTkVNYzR1b2F3M2g1?=
 =?utf-8?B?WFNTb1g2Q21kQllwWEptTzZBbjJKTFpJNEpFS21HK3V3Y05jazdDbktDSFo2?=
 =?utf-8?B?R2hrRTJFVVRlTnZXdlkvRnRVLzNQVnhVZWcxQ1M5WllaM3oweDlIRmRZQnJk?=
 =?utf-8?B?dndIL0N1UnpNMkpKZmwzOGdQeXJOdVcrUFk1M0xYSjM0eFFQdEJZVDkwaC9C?=
 =?utf-8?B?TXdBRzBRODdVMTEwZDd6MkFzdlNFL21YQStTTVR1MzRrVlVkM1hIQ2tORzZo?=
 =?utf-8?B?U0xOYUYrWTkyZ21DNzd5ZlRtdWtsL0lRU3RLdnVRMHhEV3RRa0xjWVo0aXVY?=
 =?utf-8?B?b1dZNlROV0VwbE5Lc0dMK2FsVHJxWWxqczVVMmRsb3dyMkFIaDdjaHNlc1A2?=
 =?utf-8?B?THYveTdDa3F4bzRJM0gzdWJrQVUzNEQ1TmdHenlHTERLem42eG9EbHpmU2FC?=
 =?utf-8?B?clpUMTJWbGxXaDNzRThPMjVsRXptWkR2QTNuNGl3d25ZdENRUmcyVnZFSnZM?=
 =?utf-8?B?RVNZRzhlZ0UvNHE2L29NRXVuZlZKRkJ6ZjFaeFJ3UjZqVjZjWWp4MVY5Qit2?=
 =?utf-8?B?SVliMC9EY2NweG9xcVMwS1FlSHd0VFBnSm5EdUNuYm5RMXE4bXhPYlJ1QVJX?=
 =?utf-8?B?RzgyT3BMck8vOHJtZ0NERVdCZ05oNzNpa0pScUh4cTNSRWZmVmVHTzBQTFBB?=
 =?utf-8?B?THlLTWhYSkt1TVhhcmxQaHZzd1hVKzFJTllHZjVDV2FPbUt1QWV5QjhHeW93?=
 =?utf-8?B?Q0NaMnF6T0VGNnNDS3psa3Y0ZlVMVXI0QzhDajRKamVZWlhNVFkzT1E0eVAw?=
 =?utf-8?B?MVJzdTJiWk5hWXR3UE5leWtpTWFqaXZPYzg0NHRQYWZwdlRyRTJ2bzViK1VW?=
 =?utf-8?B?QlhxYXhwN1J6dkZoL0JMb0Q5S09QNEFLTUpHc1BKWVJtckJSNHlRcVpPeWor?=
 =?utf-8?B?dm05SHlNU1lyZUZWNGFmRWJnak5NZlkzZDd2dkZ3RWpZcDJaTXdKYVQyRVZk?=
 =?utf-8?B?YS9xeml1d1MxTktHeVIzWUMyTlpMZXc4em9vZXlsS3VCQ2lIZFY2R21WamNo?=
 =?utf-8?B?NzdiRXB6cUJEU0JNc1RDREVlRk4wbVRqcnQ1eVpEUFlKOGpTbUVaWERIYjlw?=
 =?utf-8?B?Z0Nsb0tvOVVweENxNlNQKyt2dWNIbThuZHEwZ0FIY0IycFNTVFNpY3lZakNT?=
 =?utf-8?B?K0dhYm9reHNCeExXeWpWU2dRS1Z2VWRtYnI5Z2xlOFNLcW9WNjczZlBJdU1L?=
 =?utf-8?B?aGZ1eHZ3UXZwR2lXWGxrSjRYd2pBOVNxRS9XZmducEVMckd0M1J4aWxmb08y?=
 =?utf-8?B?cTNSN2s3Q0RsMFpTUVVzWm5yK1F1cFllU1dWZ2lQWWNyekxMK3ltUm9Ncm1w?=
 =?utf-8?B?RnIxZEtDNmtOSmNwQWpkcytoUGdDK2MxZnllWFJQdHpsTXoxUHo3blYrbWl4?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D3CD8A4A380B94782196894682AB60F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571aca63-b94b-48c8-bc4a-08dab6e41014
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:53:06.4314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9htdvszHyhz3VzL/GgxyAolmnFYT+6vHHpQtiIxZC9uB6IGT5tqklZXcBmfKCaDnKFb07bphryqX0j+/ZUDmTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBDdXJyZW50IGltcGxlbWVudGF0aW9uIGNoZWNrcyB0aGF0IGJsb2NrIHNpemUgaXMg
ZGl2aXNvciBvZiB6b25lIHNpemUKPiB3aGVuIHZlcmlmeSB3b3JrIGxvYWQgaXMgc3BlY2lmaWVk
LiBBZnRlciB0aGUgcmVjZW50IGZpeCBvZiBibG9jayBzaXplCj4gdW5hbGlnbmVkIHRvIHpvbmUs
IHRoaXMgY2hlY2sgaXMgbm8gbG9uZ2VyIHZhbGlkLiBSZW1vdmUgdGhlIGNoZWNrLgo+IAo+IFRo
ZSBjaGVjayBoYWQgYmVlbiB2YWxpZCBzaW5jZSBzdWNoIGJsb2NrIHNpemUgbGVmdCB1bndyaXR0
ZW4gYXJlYSBhdAo+IGVhY2ggem9uZSBlbmQgYW5kIGtlZXBzIHRoZSB6b25lcyBpbiBvcGVuL2Fj
dGl2ZSBzdGF0dXMgdW50aWwgdmVyaWZ5Cj4gcmVhZCBpcyBkb25lLiBJdCBlYXNpbHkgaGl0IG1h
eCBvcGVuL2FjdGl2ZSB6b25lcyBsaW1pdGF0aW9uLiBBZnRlciB0aGUKPiBmaXgsIHRoZSB6b25l
cyB3aXRoIHVud3JpdHRlbiBhcmVhIGFyZSBmaW5pc2hlZCB0aGVuIHRoZXkgZG8gbm90IGhpdCB0
aGUKPiBsaW1pdGF0aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IFNoaW4naWNoaXJvIEthd2FzYWtp
IDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+CgoKTG9va3MgZ29vZC4KClRlc3RlZC1ieTog
RG1pdHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2RjLmNvbT4KUmV2aWV3ZWQtYnk6IERt
aXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5jb20+Cgo+IC0tLQo+IMKgemJkLmMg
fCAxMSArLS0tLS0tLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxMCBk
ZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvemJkLmMgYi96YmQuYwo+IGluZGV4IDU1YzVj
NzUxLi42MTg1NmFkMSAxMDA2NDQKPiAtLS0gYS96YmQuYwo+ICsrKyBiL3piZC5jCj4gQEAgLTY0
OSw3ICs2NDksNyBAQCBzdGF0aWMgYm9vbCB6YmRfdmVyaWZ5X2JzKHZvaWQpCj4gwqB7Cj4gwqDC
oMKgwqDCoMKgwqDCoHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQ7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0
cnVjdCBmaW9fZmlsZSAqZjsKPiAtwqDCoMKgwqDCoMKgwqBpbnQgaSwgaiwgazsKPiArwqDCoMKg
wqDCoMKgwqBpbnQgaSwgajsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBmb3JfZWFjaF90ZCh0ZCwg
aSkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHRkX3RyaW0odGQpICYm
Cj4gQEAgLTY3MSwxNSArNjcxLDYgQEAgc3RhdGljIGJvb2wgemJkX3ZlcmlmeV9icyh2b2lkKQo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHpvbmVfc2l6ZSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBmYWxz
ZTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmb3IgKGsgPSAw
OyBrIDwgRklPX0FSUkFZX1NJWkUodGQtPm8uYnMpOyBrKyspIHsKPiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodGQtPm8u
dmVyaWZ5ICE9IFZFUklGWV9OT05FICYmCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHpvbmVfc2l6ZSAlIHRkLT5v
LmJzW2tdICE9IDApIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2luZm8oIiVzOiBibG9j
ayBzaXplICVsbHUgaXMgbm90IGEKPiBkaXZpc29yIG9mIHRoZSB6b25lIHNpemUgJSJQUkl1NjQi
XG4iLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGYtPmZpbGVfbmFt
ZSwgdGQtPm8uYnNba10sCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
em9uZV9zaXplKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGZhbHNlOwo+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oH0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gdHJ1ZTsKCg==
