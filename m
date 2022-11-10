Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73930C4332F
	for <fio@archiver.kernel.org>; Thu, 10 Nov 2022 02:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKJC2R (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Nov 2022 21:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiKJC2Q (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Nov 2022 21:28:16 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6169A275EF
        for <fio@vger.kernel.org>; Wed,  9 Nov 2022 18:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668047295; x=1699583295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7nSc8bvcQkCG2MRIBqzRV3SbrOT3iN/eRXcTvPjWMdE=;
  b=LCX0P+Naso3O1r4j9uP+aKGQ8Aa5VBMzL7m8/l6Vw64YyCOCWyRhtlbn
   0Gk5fh63sRyySrxFV+C5USh1CLqygTHuLQWcQQp9A6VhXkR130Xi7ynuH
   9+BVvYxY1geSAmvneCgZP9vVpD7cbruPVusoi6s5t3c9a7pISp1Z1kcPk
   K5Uf+vTYz+NxluMfgAY7CeINaaAZdm/YxURkYCxdv5kxl09sMPW5N6r5I
   frs13TMD/HfBYp7FA80muQMTKoJhW6zBtx3Fhqi3cW+GATyhjsgDAslM+
   TAeT3ndjY1v99elyJ+f7HzOONksgofYQoVXEAhbS/X06D43jv2STxl/o9
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,152,1665417600"; 
   d="scan'208";a="215915267"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 10:28:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hi97eRI3Hc8T7DTSo6lvAkcij4A9sq2ndpG6w2zAuv0KLS/9EhTiNu6BUm3bZo4oWoEEeUGhWwrWcbx3s+C1mHGq8CprGBKPSWb8qlwXooFSXDUULGzdEjQXX8nennO08VS9AEOHUhxru5o9nZUHIfWzaUfbR0DymxG4TUQsOERDNWYqWX5n7HxCARSONGWBVMtJNOBkMnpu+K6bOshXqzlyZUDGNLkDo43Rs52wHVXQLzz3D1ZMCZnLtCnd5NY8dY2hEm0i3JkEElYa/iNBv9wA0E3FUa6Gk0IxqrzmCp/RZCSfLGhDgiX+jgl+CLpigNdLPkLDYVXRdC/JMGGEeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nSc8bvcQkCG2MRIBqzRV3SbrOT3iN/eRXcTvPjWMdE=;
 b=SkCEAwTTLxkNhpO6VlIGYDdU69xPaz7K8+/STF1MDw7+IenIr3m7lTFCY2agtRdxGvug9qSbM4LknJ8ImZPRnOBuDDCf590xHIaTEWIgGxLBJctf16qBhVo7l5OyX2XH3lD3dWsEAY7bM1G+E2hfeG9BPgzOfnvgRu9MQ95e6xQkeH8cUjL4JpFJmkPCertrcUI+mQuwT08uGnRE7uVymPkBEwx7PF+ENlYkqCYBNWMrsNK21u0AAXYQE1NtZltv2auW7Rqr12dhJXXrt8bEIC6wWBNfYtHNi45hqMjqT4Gw5M/JagCGVDObR/TR9S9YTY+b80JHcVTXfdk7veoQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nSc8bvcQkCG2MRIBqzRV3SbrOT3iN/eRXcTvPjWMdE=;
 b=ZKbDdhASm9hLRhWe2ezg4SVJZf5WaCOiuC8afljGaQcV9SiBRa8fLB5xwhFmLLs7dKi7gP5a3MNXYOBTWSY3cLUxiT28G+1tQTxPjvjC1b9kNzpm7tnc1pxhAMzDBO9LyK+Tjv5zzq1XxydRuOZQ2D9dKortA2Hjef6S6N8TWg4=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by DM6PR04MB3963.namprd04.prod.outlook.com (2603:10b6:5:ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Thu, 10 Nov
 2022 02:28:11 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 02:28:11 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v4 06/13] zbd, verify: verify before zone reset for
 zone_reset_threshold/frequency
Thread-Topic: [PATCH v4 06/13] zbd, verify: verify before zone reset for
 zone_reset_threshold/frequency
Thread-Index: AQHY808Tifz9Q6wq1UaYFEgZVyN1/a43cYaA
Date:   Thu, 10 Nov 2022 02:28:11 +0000
Message-ID: <f728d0cd13f311b5deeae3651ae0e3716c0f3336.camel@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
         <20221108084940.1574939-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221108084940.1574939-7-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|DM6PR04MB3963:EE_
x-ms-office365-filtering-correlation-id: b89582ea-ed3a-47cb-4acd-08dac2c33653
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sVd6QLv0HcdLxdG45/AClMumC6rwvtIYZXBWN/RUAmlaNUTwwwVqFeYTEk2+KsgPmnU1q6q4OggSuTtD64vsSCIKCRcG6j7CKCjrJk3vit7o98Wmy8bykgUs5xPFgcvxRpc1JUzJkSmjwMUe8AmNJgkML919h6ySSFR/+pBZkB093feF3DaSrT7nJTIi9IHdEKQMtf7hYmPhYDuRwLpFjJezVdxrSdwE9fQhyN3Dg1Mb1iTHb05OqrXPYi1x2onhdpr4mTgiHeg8rbzO2vdKeXPFecZMUyQI4sNruUuc3aIR6F0r/X2lsFN7o0rbHMsHp+HyO+w4vxlFch5259jfPPdPQTU8tGKqeJd2gzvvVoS/WoFnx5j0pQwPD5cmwCyx9v0J4omonzDBV0f156ksIiqf0xA4ZIukVwj9nrbv7KJY5W0IlFyE4UkxhgyI/0e0NCYX4egtqe/oT5IutEkulZAGbtcDBVQU0hQvrFZuVzPwpL2CARM0MRHIF6zZQqbslwR+5vf3yo1zDhNp8GqkE9Jx5/a2d6CfYhagV7gloHzNpGNpM9Ao45253mFeKRFhvxkcW19kkFfaWE5Dz7i2IOEiOiB5fUPTPTKDkbHhExGVZ52fKNpmJmV4q+9Jy+culqWGJGlaon98QJkbn/Dt83WOa67S21TQzVrg5zIjousnWWm+KWbuvdEmwGhKC0LiWMERhjr7txfbYTZbxv8Uq6FATc2SCtarf9gyyTbMcaiDqJO/9zbxZUQoO/tt7QQpa156V4JIg93dI1rV5wUiHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199015)(478600001)(6486002)(71200400001)(86362001)(122000001)(38100700002)(54906003)(82960400001)(110136005)(36756003)(8936002)(316002)(83380400001)(91956017)(6506007)(26005)(6512007)(76116006)(41300700001)(38070700005)(8676002)(66556008)(66476007)(64756008)(4326008)(66946007)(2906002)(186003)(5660300002)(15650500001)(66446008)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGllU0QxT3dyYzlQbTVvbUErMTE0S1BtL0JpOEZUWFlLR2hmZk1jTVdlUmdP?=
 =?utf-8?B?ZURQa0szMHVQS2pFQkFHQ2h4aUJ6SnhTeHpWK21tQ3J5Wk1RSHhGVTNnNnpB?=
 =?utf-8?B?d04xd2FJT1JTMGpCdFVlUVcwV2V0aHFaS1NJMVZ2d0tHNFA1Y0I3L3g0QXMx?=
 =?utf-8?B?Ynd0dTZIZmJMa1JwcGlrN20rNDY0L0E3Y3Z3TFpDdFhRY3krb21GYzNVYWQz?=
 =?utf-8?B?a3NBZzBsMy9uWFMwa055Z1NXSWk0cnJIQk1qMXl2WXltMFlCU0ttd1VwSmta?=
 =?utf-8?B?UFFOd2oydklKb2I3c1NhdnZ3VTIzaEdsRkVXckI2NGUvd3AvZzN0ajhGY1Zi?=
 =?utf-8?B?WlBkQUxlVDBZYVEyMlpQZzh2M0F0MXByYWxsLzZnVEJIVmx4ZUFNaG1JRDFz?=
 =?utf-8?B?ejVHbyszWERvcnhuOEVKZy9TMWxiZERDVUJsNXcvL1Q2aGJlSE9ZUmVJSlVT?=
 =?utf-8?B?c0ZSWHpVMk1sQjBxbUdPdG4wbGwxREdHYmJoWlBVZEtFbnBqVERIQnJaazNh?=
 =?utf-8?B?eDN2akdMWUFEMXo4MWtEZHUyMDR5M2NRaDVZTWY3UzExbXAwUUhaUHk4ZUFL?=
 =?utf-8?B?Mjc4a1VsdTdLTDRzOURMOGNOdFFYSkl4d1AzbFdGTUFkdzJLL1FNenlxcGdD?=
 =?utf-8?B?ZUJCQVhFZnp1WHFKVG9FNzBJNm9ybWUzV2dOTUVaNTNzTHdrQ21waE5rYlhs?=
 =?utf-8?B?ZXBRNWlGV2hmalZNcnQyeUJCenVzM0JHa1lTVkRGZzhlTXNMYS9oOWVLWGZz?=
 =?utf-8?B?RkVnUVN5S3ZlcDJvdFE0bEhSTGFOZ2FtR2pKUExNRUlNOHhDTDBlQjdHY1c2?=
 =?utf-8?B?ZjJZSEMvUkRKUzZlYlVBaERzQ2N0TU1CUGFBcVlocjlwK21vWXhRMUV5ZWU5?=
 =?utf-8?B?cEZVTTdaYnZNYlExN2pTK2Q3YURzbTI2a2JBelpxKzllc2dHS2xHQ0VkUkY2?=
 =?utf-8?B?WE11U0xEZHBmeWdVTjdtMlc0eXJyems3cEZLdEFNOGg0cUVIeHFjOVRBTHBY?=
 =?utf-8?B?NEJwbWljbkplR1VBdVByVlVocnVvS3NXTVhaT29oOTBTZW5NMnVWWDhvOXpi?=
 =?utf-8?B?emRDNE9haDNvTzRRampsMmsvQ2JXVnpXcnphdElpeEVyQ2tBTkF3MG1NeFdC?=
 =?utf-8?B?T3did1JaVDJPemtPVzNJa2JlcFJTVmw0NStuZnZRTGtQYkJTNzh5ampvOUY5?=
 =?utf-8?B?czhla0p3WFB0VThNeVV5OVFmcjFTUzhBREt5aUxQNEdJUmoyaG5mc1dQOUhP?=
 =?utf-8?B?YWJJMU9oSnlHdWlNeTNhZjcvNGQzN1Mvb1kyZlcyb1lxTUZJRkE3U2szaTBx?=
 =?utf-8?B?K3BCWjVTR21TY1JWaEZwMFpXSDBQL0RTc081YytPZmtQVGdSUHJNU3owZEdK?=
 =?utf-8?B?OFpRek5uVzNBM1o1SWR5ZkVYd0dqK0l1NjNqa0RmOVVkK3JCUlYvOWhhbjZZ?=
 =?utf-8?B?ZlQ4TnExNXU3dVpYbnRKRytqRUhkUlRUWm5KeE8vUHBHQ3dhRXhtL1h4Uy8x?=
 =?utf-8?B?RnZBKzdkY0dzK3FRelNyc3RPZ0xyZXBhM3RQSmhwZ2tQbml3alpBZms1ZThv?=
 =?utf-8?B?VjFzZWVrK0tqb1pOMGVxUGFPeGpaWjMyWFVUM1BCL1cwTEhnNE1abUI2ZTZV?=
 =?utf-8?B?aU8rd2VuQ3lLTG9ta1phTzI1blFVdU1OaTNwbWpIV091UFV0Z2FjRjM5TXVV?=
 =?utf-8?B?dDFsd2h6dXh2VjlESmg2SVFSbUR1M2pVVExLRG5iYklRMEJaWHpiWFVCdFFF?=
 =?utf-8?B?dTF0S3hhNGY4QUl3cEJUTTY4NXp5blBLNnEyRjRqMml1a3pkdHc0b1Erb1kr?=
 =?utf-8?B?MEloM2h3YjlPOXFKWGZleFBtWjREVkl4cTE2RTcxamRJaGE0Z3Q1QUd2NlNM?=
 =?utf-8?B?enM4bGh5L2ZjV25lREZiQUI4ZVpIVzVES2ZpTnpoWk45THY0bnh4QkpTRkNP?=
 =?utf-8?B?cG80NWovUVluQkJHZnlWWjhJSUs0TnZNNmhLcTE4bkVnS3RFQi9XaHZYVk9D?=
 =?utf-8?B?THVKcysxand4Zk5hODA1Yi8xQlJzOE5UdFl5QXZaQ242YlZlU1V2OHZ4RG5l?=
 =?utf-8?B?eDFORmRINXg1cGVobExQQTR0ZmUrT2c2cXpNTGtBQXVCVjFVRWZZRFNrbHlT?=
 =?utf-8?B?cVppbjEwOFAwRVJOdDBzSXU2Q3p5WllXcW00dDNWZERzNTFuQVJwNy9IVEFu?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <618475D026254042ACC466A17AE2606D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89582ea-ed3a-47cb-4acd-08dac2c33653
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 02:28:11.1559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCMzDNTq812ZGXdcxrIjGeU9iR0GufevnzVAViFQ4VrNua8HUT7U7CuyHjifur70IWnWb582HpB80HUwwnKTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3963
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTA4IGF0IDE3OjQ5ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBXaGVuIHpvbmVfcmVzZXRfdGhyZXNob2xkIGFuZCB6b25lX3Jlc2V0X2ZyZXF1ZW5j
eSBvcHRpb25zIGFyZSBzcGVjaWZpZWQKPiB3aXRoIHpvbmVtb2RlPXpiZCwgaXQgcmVzZXRzIHpv
bmVzIG5vdCBmdWxsLiBXaGVuIHZlcmlmeSBvcHRpb24gaXMKPiBzcGVjaWZpZWQgb24gdG9wIG9m
IHRoYXQsIHRoZSB6b25lIHJlc2V0IG9mIG5vbi1mdWxsIHpvbmVzIGVyYXNlcyBkYXRhCj4gZm9y
IHZlcmlmeSBhbmQgY2F1c2VzIHZlcmlmeSBmYWlsdXJlLiBDdXJyZW50IGltcGxlbWVudGF0aW9u
IGF2b2lkcyB0aGlzCj4gc2NlbmFyaW8gYnkgYXNzZXJ0Lgo+IAo+IFRvIGFsbG93IHpvbmVfcmVz
ZXRfdGhyZXNob2xkL2ZyZXF1ZW5jeSBvcHRpb25zIHRvZ2V0aGVyIHdpdGggdmVyaWZ5LAo+IGRv
IHZlcmlmeSBiZWZvcmUgdGhlIHpvbmUgcmVzZXQuIFdoZW4gem9uZSByZXNldCBpcyByZXF1aXJl
ZCB0byBhbiBvcGVuCj4gem9uZSB3aXRoIHZlcmlmeSBkYXRhLCBjYWxsIGdldF9uZXh0X3Zlcmlm
eSgpIHRvIGdldCBpb191IGZvciB2ZXJpZnkKPiByZWFkIGFuZCByZXR1cm4gaXQgZnJvbSB6YmRf
YWRqdXN0X2Jsb2NrKCkuIFdoZW4gaW9fdS0+ZmlsZSBpcyBzZXQsCj4gZ2V0X25leHRfdmVyaWZ5
KCkgYXNzdW1lcyB0aGUgaW9fdSBpcyByZXF1ZXVlZCBhbmQgZG9lcyBub3RoaW5nLiBVbnNldAo+
IGlvX3UtPmZpbGUgdG8gdGVsbCBnZXRfbmV4dF92ZXJpZnkoKSBpcyBub3QgcmVxdWV1ZWQuCj4g
Cj4gQWxzbyBtb2RpZnkgdmVyaWZ5X2lvX3UoKSB0byBza2lwIHJhbmRfc2VlZCBjaGVjayB3aGVu
IHRoZSBvcHRpb24KPiB6b25lX3Jlc2V0X2ZyZXF1ZW5jeSBpcyBzZXQuIFdoZW4gdGhlIG9wdGlv
biBpcyBzZXQsIHJhbmRvbSBzZWVkIGlzIG5vdAo+IHJlc2V0IGZvciB2ZXJpZnkgcmVhZHMgaW4g
c2FtZSBtYW5uZXIgYXMgdmVyaWZ5X2JhY2tsb2cgb3B0aW9uLCB0aGVuCj4gdGhpcyBjaGVjayBp
cyBub3QgdmFsaWQuCj4gCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNo
aW5pY2hpcm8ua2F3YXNha2lAd2RjLmNvbT4KCkhpIFNoaW4naWNoaXJvLAoKWWVzdGVyZGF5LCBJ
IGVuY291bnRlcmVkIGEgdGVzdCBmYWlsdXJlIHdpdGggdGhlIHZlcnNpb24gMiBvZiB0aGlzIHBh
dGNoLgoKV2hlbiBJIGNyZWF0ZSBhIC9kZXYvbnVsbGIgdXNpbmcgdGhpcyBjb21tYW5kIC0KCm1v
ZHByb2JlIG51bGxfYmxrIG5yX2RldmljZXM9MSB6b25lZD0xIHpvbmVfc2l6ZT0xNiBtZW1vcnlf
YmFja2VkPTEKCmFuZCBydW4gdC96YmQvdGVzdC16YmQtc3VwcG9ydCAvZGV2L251bGxiMCBhZ2Fp
bnN0IHRoaXMgZGV2aWNlLCB0aGUgdGVzdCAjMzQKZmFpbHMgd2l0aCB2ZXJpZmljYXRpb24gZXJy
b3JzOgoKdmVyaWZ5OiBiYWQgbWFnaWMgaGVhZGVyIGZmZmYsIHdhbnRlZCBhY2NhIGF0IGZpbGUg
L2Rldi9udWxsYjAgb2Zmc2V0IDMzNTU0NDMyLApsZW5ndGggMjg2NzIgKHJlcXVlc3RlZCBibG9j
azogb2Zmc2V0PTMzNTU0NDMyLCBsZW5ndGg9Mjg2NzIpCnZlcmlmeTogYmFkIG1hZ2ljIGhlYWRl
ciBmZmZmLCB3YW50ZWQgYWNjYSBhdCBmaWxlIC9kZXYvbnVsbGIwIG9mZnNldCA1MDMzMTY0OCwK
bGVuZ3RoIDI4NjcyIChyZXF1ZXN0ZWQgYmxvY2s6IG9mZnNldD01MDMzMTY0OCwgbGVuZ3RoPTI4
NjcyKQp2ZXJpZnk6IGJhZCBtYWdpYyBoZWFkZXIgZmZmZiwgd2FudGVkIGFjY2EgYXQgZmlsZSAv
ZGV2L251bGxiMCBvZmZzZXQgMTY3NzcyMTYsCmxlbmd0aCAyODY3MiAocmVxdWVzdGVkIGJsb2Nr
OiBvZmZzZXQ9MTY3NzcyMTYsIGxlbmd0aD0yODY3MikKCkkgd2FzIGhvcGluZyB0aGF0IHY0IHdp
bGwgZml4IHRoaXMgaXNzdWUsIGJ1dCBpdCBpcyBzdGlsbCBoYXBwZW5pbmcgaW4gbXkKdGVzdGlu
Zy4gU2V0dGluZyB6b25lX3NpemUgdG8gYW55IG90aGVyIHZhbHVlIG9yIHNldHRpbmcgem9uZV9j
YXBhY2l0eSB0byBhIHZhbHVlCm90aGVyIHRoYW4gem9uZV9zaXplIG1ha2VzIHRoZSB0ZXN0IHJ1
biB3aXRob3V0IGFuIGVycm9yLiBUaGlzIGlzIHZlcnkgcGVjdWxpYXIuCkkgd29uZGVyIGlmIHlv
dSBjYW4gcmVwcm9kdWNlIHRoaXMgZmFpbHVyZS4uLgoKREYKCj4gLS0tCj4gwqB2ZXJpZnkuYyB8
wqAgNiArKysrLS0KPiDCoHpiZC5jwqDCoMKgIHwgMTQgKysrKysrKysrKysrKy0KPiDCoDIgZmls
ZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvdmVyaWZ5LmMgYi92ZXJpZnkuYwo+IGluZGV4IGQ2YTIyOWNhLi5kZGZhZGNjOCAxMDA2
NDQKPiAtLS0gYS92ZXJpZnkuYwo+ICsrKyBiL3ZlcmlmeS5jCj4gQEAgLTkxNyw5ICs5MTcsMTEg
QEAgaW50IHZlcmlmeV9pb191KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBpb191Cj4g
Kippb191X3B0cikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhkciA9IHA7Cj4g
wqAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIE1ha2UgcmFuZF9zZWVkIGNoZWNrIHBhc3Mgd2hlbiBoYXZlIHZl
cmlmeV9iYWNrbG9nLgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBNYWtlIHJh
bmRfc2VlZCBjaGVjayBwYXNzIHdoZW4gaGF2ZSB2ZXJpZnlfYmFja2xvZyBvcgo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB6b25lIHJlc2V0IGZyZXF1ZW5jeSBmb3Igem9uZW1v
ZGU9emJkLgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghdGRfcncodGQpIHx8ICh0ZC0+ZmxhZ3MgJiBURF9G
X1ZFUl9CQUNLTE9HKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCF0ZF9y
dyh0ZCkgfHwgKHRkLT5mbGFncyAmIFREX0ZfVkVSX0JBQ0tMT0cpIHx8Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZC0+by56cmYudS5mKQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlvX3UtPnJhbmRfc2VlZCA9IGhkci0+
cmFuZF9zZWVkOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodGQt
Pm8udmVyaWZ5ICE9IFZFUklGWV9QQVRURVJOX05PX0hEUikgewo+IGRpZmYgLS1naXQgYS96YmQu
YyBiL3piZC5jCj4gaW5kZXggNmY0ZTVhYjIuLmZhZGViNDU4IDEwMDY0NAo+IC0tLSBhL3piZC5j
Cj4gKysrIGIvemJkLmMKPiBAQCAtMjAzMiw3ICsyMDMyLDE5IEBAIHJldHJ5Ogo+IMKgCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBSZXNldCB0aGUgem9uZSBwb2ludGVyIGlm
IG5lY2Vzc2FyeSAqLwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHpiLT5y
ZXNldF96b25lIHx8IHpiZF96b25lX2Z1bGwoZiwgemIsIG1pbl9icykpIHsKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzc2VydCh0ZC0+by52ZXJpZnkg
PT0gVkVSSUZZX05PTkUpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaWYgKHRkLT5vLnZlcmlmeSAhPSBWRVJJRllfTk9ORSkgewo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICogVW5zZXQgaW8tdS0+ZmlsZSB0byB0ZWxsIGdldF9uZXh0X3ZlcmlmeSgpCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICogdGhhdCB0aGlzIElPIGlzIG5vdCByZXF1ZXVlLgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlv
X3UtPmZpbGUgPSBOVUxMOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghZ2V0X25leHRfdmVyaWZ5KHRkLCBpb191KSkg
ewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB6b25lX3VubG9jayh6Yik7Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiBpb191X2FjY2VwdDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW9fdS0+Zmls
ZSA9IGY7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9
Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8q
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogU2lu
Y2UgcHJldmlvdXMgd3JpdGUgcmVxdWVzdHMgbWF5IGhhdmUgYmVlbgo+IHN1Ym1pdHRlZAo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGFzeW5jaHJv
bm91c2x5IGFuZCBzaW5jZSB3ZSB3aWxsIHN1Ym1pdCB0aGUgem9uZQoK
