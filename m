Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40DBECDFA1
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiJYXvV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiJYXvU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:51:20 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED3F97D40
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666741878; x=1698277878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q7TdWK6oOiIoy7LCojPcYpCnM9iGhHJ/5i9GXwiwL/U=;
  b=IJAzQ4kWFj7WOfdY1FejQ34Xud0KjdLKYBiq2e3oxPuZaNvhdIWIwZX6
   hKzSjnVtAONugsiH8lelx8aEZ0TmDFoq1u4zehy/bofhGGePBMG35S+O0
   dKCRHAEBnsGmoFXHiHdigfK1SKyfjN3T36XRJUBDhc2Kv6nxnUmpLT1Y1
   /89gFevB83QDN40UhHQYrgzeqC2Ue+ZebprZrDo86qiyN1SUZ4CkvsFpt
   L1V3ggYX8KAsNP+OyJ0sDGnw5vskqqyeeA6xtg/Ts2deG+1iIJDutfguV
   4QWbPhATzNus9M5DLG4usfx0UHbS2lVvOe5J7oJBAcwEd6Rcm2OYDZUdc
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="215099488"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:51:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWZXGbnW5l22RLUVJYdhRwscDmNuilq44KLH25pBQL50J4kb8+95DnRAAecM1uTNQd18zNUD1WvmtE27E5PYLn4bYt+VzfuNoogZt6QzWewzcDxajaA+pIeRNAWNQYYrwJBFXvBzf6OAT9hquNA5YKfEX8/HmHAoKJnrcO5BCnH0uBG7cEalOh9vS27OAPdRORDiPYugMYLBrSCATKNKxO1uA6DDXrRWfZ8nRBsaFeXH4Fe9iLV/gK1F+22pSzaR08mERGPXlorLEv+Oms9QSFeceOs971bZtL7DDBmAgXlzIcSEjCMrA5cCxnkFo32I7Per4khvqvMnXlUQtIcZdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7TdWK6oOiIoy7LCojPcYpCnM9iGhHJ/5i9GXwiwL/U=;
 b=hL/f/qPIYa6srft9IEM0EZdDXf4MA6vyDuIVu0JWArRzVif1xxBA47EUmBMOoGH65vOrTUvZdpF7qATWfT5MgMEwoa+KZ9Ur1Q/4nWFnTDdI2PSfV4Mnx2He4NU1tnEI6Lwt/1Nr6C5cePanhoxcPNUR3xa8TfDuN3eF0whTzkzvJjGhUlOKVOkGyzrSMfVfc+uHbmjXWZbQD/HppEqds2Um4pzMUm0NY2mr3zQJm9LGUk23Tv+4h9ZDiUDzLM1vr9h1YE6hMgDW9q6UgVAWX+b6cK/YSvS7Yi0h4PAsmegoSF3ul/QHohtB6AmiJKHlJ6KbcLTfn4cp/Ky0R4iJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7TdWK6oOiIoy7LCojPcYpCnM9iGhHJ/5i9GXwiwL/U=;
 b=Yslyc2P6WwY7VWai7gLYX+nZBd3RbqclfjDxbAhLB+BFef9aeQBQ4u7/28e+iuU1oyyg9Z4A86eUy8+wlxR72T3GBenpi5t4p33PypDd9phULo3/J0bgtaE6GJG710Ln3Jco7/7KaCWdzX3BS+ews5z7L+gDYwp5qlZwpfb3SVo=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:51:13 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:51:13 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 01/11] oslib: blkzoned: add blkzoned_finish_zone() helper
 function
Thread-Topic: [PATCH 01/11] oslib: blkzoned: add blkzoned_finish_zone() helper
 function
Thread-Index: AQHY5RcoCGvbtBpHOEmTlacG8npIzK4fzyQA
Date:   Tue, 25 Oct 2022 23:51:13 +0000
Message-ID: <6a722bf378ab4f5237542db786e5ddcb202efa47.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: 7dee6dad-cfb0-4543-6ad5-08dab6e3cc95
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZP5VlgAJyKlFHv24WDhbLAqL9Eoy0oFFPS8nwqxyUPknvOTwHcYZVxEiEE61AUYYUZMdCW47TdGaZVPKF/mwmnWljWWnisDZPEHWMpAUGPvElLC6StSlfh7Vf5J78p3redvtR9muCovXx6rIh7qPj4bKIAD1Mc+GvqCz9W2p7tGbRBybB9XM8pdWwFveiK4D95tuh9UTxAR0y43cJPVrHJsczXdRU6yaPhzNcOaLHwQLll4Sqf+eYG5GJfm7Pz5akl6Pr9yhwt3X9psUfdmJnNNaegNeJYOkNklUIXNgEMT17wxCmgNFtvbYQF7ujkoPEblzJiPQlUMUP6JOhZTVTZBxb3e5jaiVc0bfOgWmcAU7A6fwCymijXD6LerE4eZrDln+mgaXSr4j+A+wMwsnEQn4M8Mza2qMLqtnXFI6idpYo7JdIwz05JRNcig7ssaS0l6c/mxjKMvKIZJqjxGENbC+Qajf5wi8V0/1u+z1EWY0mUWChr0cZV6QnStNcD4sjYvX34q9xjNl/5ans99e/ENb7Si46WMEqYdnKzPBrFU3orYpFIKIpejGyPgqw7wit7/bh6dcHLMVD4nWwfvpbhSpXIM/7c2P1ru0YvYWQNiyHspuQfG/XIoWe6Ye8AUuHxrVzQ+pnaBHqaIFQDg4A5sZwTm9aOmOf6It/vcZiVMIBp5xXE3ksdCxOH8qq8WZHVuBdNQ0FG8WuKuvZHKaDeRapXtMTYEObhnm7vZVW3FmvYAvyZ+ftFBnlX+a5mqFuvK/stT4QbZKQ9uy7+Pmfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHlYYUdZYkVSa3B6Wmo4M3NWakRLUHlhaHZONWxIMnVING9QdkdBUkU2OGhV?=
 =?utf-8?B?WjZnOFduS2hscThxdG40TnZqQis3azd3Ky83M1UwSWpHVDFZbHk0R09lNnR0?=
 =?utf-8?B?TjNaWVdVTjZqUm5CWER5U3BMcm9jREdsQkp3UDNWVFl5TG1zQVNoL0lVVFlI?=
 =?utf-8?B?UW9aM3Y1c28zV0NVc25pOFdManhpMFo5NnVYUnVWL1lFdkxkekxPUjVZM1cr?=
 =?utf-8?B?WGQvZnZ6WmIvMURSV3dJenU5RDhsUjRDcEZlR2htcWEzTkNBeVpPZm0zTDJC?=
 =?utf-8?B?d0ZPOWtiNzBEV3lTcVZnanJWRkw1RWVwTUUvNXhHTFMwRWgvZEFubklDSGo4?=
 =?utf-8?B?MDRsNm1lbGw3cUdQNlQxSTJXaDhGalBta0VwNEFYejFjTDErQjhBVkgzMXlz?=
 =?utf-8?B?eXdLd2JiamZRaDJzNTlpQVV5RlNRZ1hCMWlPT1lzUk9CNzd1VkRuUmlxMXNT?=
 =?utf-8?B?M1MrNmt1RnVtVGpBL0NzNmJMbk1VU1RnbHV0M3dSVWQvNzZnVFVFdkZqcmJT?=
 =?utf-8?B?Nk5iaWdqM21IQ01MWlJ4U2p3QnJ2UFNMZFRkcDJOOC8xTEsrbTAwMmFwbXJW?=
 =?utf-8?B?N3E5Z250UmxLM3dhTlkwV2N6VzZTbUhnVHlaUzlScEtkZlFQYlVUWThhcW4r?=
 =?utf-8?B?d3lDNmo0eVhHU1NFUFozOHovMVAzWjViejBPWkp2RFJuUTRCRGFvVWVoSWNU?=
 =?utf-8?B?Ty9YTmE3UzNMNGdTRkg1QjdkdUxTWHFFWmsxRUtoYTlsVGFpa24yNVM5Mnhy?=
 =?utf-8?B?NzY3Q0k3VXVpT0ZsTjJFSEVkdDEvd0RhRXd6eU9JelEwellqdU1WMVFLd0RG?=
 =?utf-8?B?SmIvTDA3bktDQXNNVkRzdTFIUnppWC9uSUlqUHM1ZC9kbFB2ZG1uYWM4VUtO?=
 =?utf-8?B?ZTgyYnUrNDFvQ0hsaW41NitUZUwxVmMyN3F5Z0RGR1ZEY0pjRUlxMlJHUlFr?=
 =?utf-8?B?VFZKZldvK3ZnM3lML2dpZlZaNGxLMU5NWllZOWhTRU9mWUVscW1UOS92TXN6?=
 =?utf-8?B?NnpSbFRvd0JLMHlacm5nYmw2U00yM1VFVU02YTh4c01wTVBPTVpod3B4dUlk?=
 =?utf-8?B?U1pubVB0dVFuQ0hQYzJhNHZkMUpEenF4ZCtydFptZDNibHF6M1B3bjUzUEk3?=
 =?utf-8?B?Q2VuQ0pGZlBMUnN2bVZwVGtWTVNKT2xRMHhlRHlGMmRmNVBrMGxJR0F0bzln?=
 =?utf-8?B?MzZibEZDcEIvZzRFenFYelhKVlRFWkZQNnljQXoweHZ0dEVPKzhoNDdiQXpM?=
 =?utf-8?B?UndBZ3lLRTBVOGJvejY2KzFReFIyWjl3ZFdYN3kyU0RMalB6VWhHYjRlZjM2?=
 =?utf-8?B?UjFncko3cnhPRlJ3VDBWVEFhc0QrcURPVXlYU3QwVjZNd2RjN3lXOWg2OHVY?=
 =?utf-8?B?L29sTHFRS3NOMlM0TGFTSjFzV0h4elI3amF6bjRFN3VKdERWdVpodVI3ZkpQ?=
 =?utf-8?B?V1JpY3BaMnowZm1kNkFVZGQ0TjNZcUptV3FuOXR0enRTa0E5c1FmQmxRSWM1?=
 =?utf-8?B?VEJIZGxleUExbmJQdWR5NGhUVFR1amhKMnJQUnJrRSt0U1MxVEU4UENhTENI?=
 =?utf-8?B?L0tGYnAvOVlxWG9YOW1JbDRuZTF3RzBMUmRYZGZkdnIxQU9TNEtSS1lNUmxK?=
 =?utf-8?B?cm5PVTZ0b0pvL05GNHNvcUhBNmpJbXE2QkRKb3l2OFZ3TTRUM0NXMEJGbUFw?=
 =?utf-8?B?ck9GUTVDbTJYWjM0b2liK3kzNVRRdDNDZUhjckk2OFBkOEp6MzlCelhiUFBH?=
 =?utf-8?B?T3hWZ1JSbzdHbTBIc3VZSjBpcm5LdExnemx3OGNTVVdTcStzSmlFbTV1bzVC?=
 =?utf-8?B?UXd5VnJ1YkdvWUQvMGNSaHJTMVBiY3ZrOEhBa2ZYcmVXeUNRL0tSYU8yVjh6?=
 =?utf-8?B?bHl0UGYrRTNVT2VYMEtVdFBvMmZGc3hueXczN3ZkTVJrV3FoaTRta3Y5UHcx?=
 =?utf-8?B?SzhjVVhzem1HMy9xOEY2Y0JUbE9jUzdIdkl3RGZZMTIrQzFuY29kOEhmTFVn?=
 =?utf-8?B?VnZQU2ttem02dncvMnRMTFBiNG1POHErQVFSTFV2K2NIVCs4eEdKOVIrTFZB?=
 =?utf-8?B?aURVSXJaWUtXZmh3VU5uV3lkeHJZM3Rtakl4YlBHOFFybGt6clI1VS9lTHVj?=
 =?utf-8?B?SW5UWkFyaFhuZ0YzRXhJUlZ6VWx3emJKcXVacVJPUnprZVI0aDcvbVBYRkE3?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F81D9D3A804E34A85A3F0152218F841@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dee6dad-cfb0-4543-6ad5-08dab6e3cc95
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:51:13.1897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8y8ZfLi8Uut7NmESbYWJ2vjxnuB8Yezyxzq1pqG8a3wQaz04E8GKk4OGO/fub+wjqW3Dokgv9BeYWyxxHds8cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBBZGQgdGhlIGhlbHBlciBmdW5jdGlvbiBibGt6b25lZF9maW5pc2hfem9uZSgpIHRv
IHN1cHBvcnQgem9uZSBmaW5pc2gKPiBvcGVyYXRpb24gdG8gem9uZWQgYmxvY2sgZGV2aWNlcyB0
aHJvdWdoIGlvY3RsLiBUaGlzIGZlYXR1cmUgd2lsbCBiZQo+IHVzZWQgdG8gY2hhbmdlIHN0YXR1
cyBvZiB6b25lcyB3aGljaCBpcyBub3QgeWV0IGZ1bGwgYnV0IGRvZXMgbm90IGhhdmUKPiBlbm91
Z2ggc2l6ZSB0byB3cml0ZSBuZXh0IGJsb2NrLCBzbyB0aGF0IHN1Y2ggem9uZXMgZG8gbm90IGV4
Y2VlZCBtYXgKPiBhY3RpdmUgem9uZXMgbGltaXQuIFRoaXMgZnVuY3Rpb24gZG9lcyB6b25lIGZp
bmlzaCBvbmx5IHdoZW4ga2VybmVsCj4gc3VwcG9ydHMgdGhlIGlvY3RsIEJMS0ZJTklTSFpPTkUu
IE90aGVyd2lzZSwgaXQgZG9lcyBub3RoaW5nLiBUaGlzCj4gc2hvdWxkIGJlIGZpbmUgc2luY2Ug
dGhlIGtlcm5lbCB3aXRob3V0IEJMS0ZJTklTSFpPTkUgZG9lcyBub3QgcmVwb3J0Cj4gbWF4IGFj
dGl2ZSB6b25lIGxpbWl0IHRocm91Z2ggc3lzZnMgdG8gdXNlciBzcGFjZS4KPiAKPiBTaWduZWQt
b2ZmLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29t
PgoKTG9va3MgZ29vZC4KClRlc3RlZC1ieTogRG1pdHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNo
ZXZAd2RjLmNvbT4KUmV2aWV3ZWQtYnk6IERtaXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2
QHdkYy5jb20+Cgo+IC0tLQo+IMKgb3NsaWIvYmxrem9uZWQuaMKgwqDCoMKgwqDCoCB8wqAgOCAr
KysrKysrKwo+IMKgb3NsaWIvbGludXgtYmxrem9uZWQuYyB8IDM3ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysKPiDCoDIgZmlsZXMgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygr
KQo+IAo+IGRpZmYgLS1naXQgYS9vc2xpYi9ibGt6b25lZC5oIGIvb3NsaWIvYmxrem9uZWQuaAo+
IGluZGV4IDcxOWIwNDFkLi4yOWZiMDM0ZiAxMDA2NDQKPiAtLS0gYS9vc2xpYi9ibGt6b25lZC5o
Cj4gKysrIGIvb3NsaWIvYmxrem9uZWQuaAo+IEBAIC0xOCw2ICsxOCw4IEBAIGV4dGVybiBpbnQg
Ymxrem9uZWRfcmVzZXRfd3Aoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0Cj4gZmlvX2Zp
bGUgKmYsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHVpbnQ2NF90IG9mZnNldCwgdWludDY0X3QgbGVuZ3RoKTsKPiDCoGV4
dGVybiBpbnQgYmxrem9uZWRfZ2V0X21heF9vcGVuX3pvbmVzKHN0cnVjdCB0aHJlYWRfZGF0YSAq
dGQsIHN0cnVjdCBmaW9fZmlsZQo+ICpmLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQg
aW50ICptYXhfb3Blbl96b25lcyk7Cj4gK2V4dGVybiBpbnQgYmxrem9uZWRfZmluaXNoX3pvbmUo
c3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0IGZpb19maWxlICpmLAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHVpbnQ2
NF90IG9mZnNldCwgdWludDY0X3QgbGVuZ3RoKTsKPiDCoCNlbHNlCj4gwqAvKgo+IMKgICogRGVm
aW5lIHN0dWJzIGZvciBzeXN0ZW1zIHRoYXQgZG8gbm90IGhhdmUgem9uZWQgYmxvY2sgZGV2aWNl
IHN1cHBvcnQuCj4gQEAgLTUxLDYgKzUzLDEyIEBAIHN0YXRpYyBpbmxpbmUgaW50IGJsa3pvbmVk
X2dldF9tYXhfb3Blbl96b25lcyhzdHJ1Y3QKPiB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBmaW8K
PiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU87Cj4gwqB9Cj4gK3N0YXRpYyBpbmxp
bmUgaW50IGJsa3pvbmVkX2ZpbmlzaF96b25lKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBmaW9fZmlsZSAqZiwKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBsZW5ndGgpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gLUVJTzsKPiArfQo+IMKgI2VuZGlmCj4gwqAKPiDCoCNlbmRpZiAvKiBGSU9fQkxLWk9O
RURfSCAqLwo+IGRpZmYgLS1naXQgYS9vc2xpYi9saW51eC1ibGt6b25lZC5jIGIvb3NsaWIvbGlu
dXgtYmxrem9uZWQuYwo+IGluZGV4IDE4NWJkNTAxLi5jMzEzMGQwZSAxMDA2NDQKPiAtLS0gYS9v
c2xpYi9saW51eC1ibGt6b25lZC5jCj4gKysrIGIvb3NsaWIvbGludXgtYmxrem9uZWQuYwo+IEBA
IC0zMDgsMyArMzA4LDQwIEBAIGludCBibGt6b25lZF9yZXNldF93cChzdHJ1Y3QgdGhyZWFkX2Rh
dGEgKnRkLCBzdHJ1Y3QKPiBmaW9fZmlsZSAqZiwKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gcmV0Owo+IMKgfQo+ICsKPiAraW50IGJsa3pvbmVkX2ZpbmlzaF96b25lKHN0cnVjdCB0aHJl
YWRfZGF0YSAqdGQsIHN0cnVjdCBmaW9fZmlsZSAqZiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRfdCBvZmZzZXQsIHVpbnQ2NF90IGxlbmd0
aCkKPiArewo+ICsjaWZkZWYgQkxLRklOSVNIWk9ORQo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBi
bGtfem9uZV9yYW5nZSB6ciA9IHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLnNl
Y3RvcsKgwqDCoMKgwqDCoMKgwqAgPSBvZmZzZXQgPj4gOSwKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLm5yX3NlY3RvcnPCoMKgwqDCoCA9IGxlbmd0aCA+PiA5LAo+ICvCoMKgwqDC
oMKgwqDCoH07Cj4gK8KgwqDCoMKgwqDCoMKgaW50IGZkLCByZXQgPSAwOwo+ICsKPiArwqDCoMKg
wqDCoMKgwqAvKiBJZiB0aGUgZmlsZSBpcyBub3QgeWV0IG9wZW5lZCwgb3BlbiBpdCBmb3IgdGhp
cyBmdW5jdGlvbi4gKi8KPiArwqDCoMKgwqDCoMKgwqBmZCA9IGYtPmZkOwo+ICvCoMKgwqDCoMKg
wqDCoGlmIChmZCA8IDApIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmQgPSBv
cGVuKGYtPmZpbGVfbmFtZSwgT19SRFdSIHwgT19MQVJHRUZJTEUpOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAoZmQgPCAwKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1lcnJubzsKPiArwqDCoMKgwqDCoMKgwqB9Cj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoGlmIChpb2N0bChmZCwgQkxLRklOSVNIWk9ORSwgJnpyKSA8IDAp
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IC1lcnJubzsKPiArCj4gK8Kg
wqDCoMKgwqDCoMKgaWYgKGYtPmZkIDwgMCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgY2xvc2UoZmQpOwo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0Owo+ICsjZWxzZQo+
ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKgICogS2VybmVsIHZlcnNpb25zIG9s
ZGVyIHRoYW4gNS41IGRvZXMgbm90IHN1cHBvcnQgQkxLRklOSVNIWk9ORS4gVGhlc2UKPiArwqDC
oMKgwqDCoMKgwqAgKiBvbGQga2VybmVscyBhc3N1bWVkIHpvbmVzIGFyZSBjbG9zZWQgYXV0b21h
dGljYWxseSBhdCBtYXhfb3Blbl96b25lcwo+ICvCoMKgwqDCoMKgwqDCoCAqIGxpbWl0LiBBbHNv
IHRoZXkgZGlkIG5vdCBzdXBwb3J0IG1heF9hY3RpdmVfem9uZXMgbGltaXQuIFRoZW4gdGhlcmUK
PiArwqDCoMKgwqDCoMKgwqAgKiB3YXMgbm8gbmVlZCB0byBmaW5pc2ggem9uZXMgdG8gYXZvaWQg
ZXJyb3JzIGNhdXNlZCBieSBtYXhfb3Blbl96b25lcwo+ICvCoMKgwqDCoMKgwqDCoCAqIG9yIG1h
eF9hY3RpdmVfem9uZXMuIEZvciB0aG9zZSBvbGQgdmVyc2lvbnMsIGp1c3QgZG8gbm90aGluZy4K
PiArwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiArI2VuZGlm
Cj4gK30KCg==
