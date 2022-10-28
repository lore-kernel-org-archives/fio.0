Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15449FA373D
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 02:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiJ1CLm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiJ1CLl (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 22:11:41 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6E5691A0
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 19:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666923099; x=1698459099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GbLxqxoyiuC3ex+FC/RDLbRnRcpls92g1ZNkd2sP4Qg=;
  b=hqnCXsWuI0tk9WFNlke2pWQ0K6PchT39pYXmIqzijujU0WJ8waNbGeev
   wuP6HAvLvHzU7/6xymV4Ks7Lkv/Sq3IkI7+2MMhHu5kKlckosaimcV+IJ
   esJHWGsU8AZW8+QPW1xoufRDJme9hvp6vdSsAErfdksT4twpICuIVdzXF
   Q4Tu13tdrsC3lp8XT9QaCqvt8XpgxIXsERkuPCEC6KHs26oSPWI/Cy3jH
   UnnSLTCxv/7b6x5xHoJbes0HiaLVucp3RRfY5ViWamAsQWrDjjrSlbuYa
   MZ1enNGuwA+AiW3Loye3v93ZxiwThAiqK+4hTwWugWF3kfYQBoOtyjwb/
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,219,1661788800"; 
   d="scan'208";a="214930700"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 10:11:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQJU9xVRpavCxJSbR4f3b3vVNyWG1RFWHmP6c6f1t8oL+idJ/ANSTuX+yFbYTrRFyTCkjwrEhO7iMVz0dUA+2VjpYLsl0Sa4zgXgZZFBre0uqVd9bikV2GQzx5knqKc5NyNE8Ym2uBjDcB4x4b3Xxb2y+AA8kYx+Ws4svt+UnG4xpYC/NblyrZCXKzX2SPjp+22eMAR2iCgzMBip7p/wc/iNbSxwoUeZrOxEc1D5kO+6T7if61O+n6cclxPBjMTJfRmiL0HdTJI/hA0vIOVXz7v1dkwZlhUIggYQ+6kpbyL2JG8Cf1In8xGkTxQgRqER2SWuZqKbD92jc9wFQUHYpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbLxqxoyiuC3ex+FC/RDLbRnRcpls92g1ZNkd2sP4Qg=;
 b=O8GIRjaQ7hIyMHu9UeWbfG8MzxIYyOCVUmpqvD/odwtyfjFd/ValBteI0fcsIh0i6ifaMiz8zNeGgNIDJgWudd3QBKzWF4dFkfegc/SoBo5J+oN53LrdS0J/QiG1EClAPLJRiyQ4m4p0sNsz09Jvq9jB3BVDEi4JWu5Ha9Hzf/+8hD3hOI3Pd9H9EyX+4uYNx0NIHJVzWcAuLr9F6sWRHa9h5izpvvVXSep6L77Q5VosH00meFXjCeMp4822pUd7yfRhegWbW+uXsWKtBaBOTWDbicoVmVAs26TRjE1JM7OdHrUlj86f0I1YtnT1xvIHypda10g10B2nmlmbDvdy3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbLxqxoyiuC3ex+FC/RDLbRnRcpls92g1ZNkd2sP4Qg=;
 b=UaBKPs8yOGQNrZDA1520HxzgofLn80n2izxFMDOFJNaP+6YjaiEjzGP0O36TM256BSMr6WUPS/Cp9O7PHRtT9CnIJXON0R7zxSu6rYwusLF70yPN2UvL5Yl9WIP8ZW/B30scMqrbdyLk3Pgvge8PWu0Vwq0irTWGWIQYUfpIYfI=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by MWHPR0401MB3548.namprd04.prod.outlook.com (2603:10b6:301:79::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 02:11:37 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Fri, 28 Oct 2022
 02:11:37 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 00/13] zbd: fix unaligned block size issue and verify
 issues
Thread-Topic: [PATCH v2 00/13] zbd: fix unaligned block size issue and verify
 issues
Thread-Index: AQHY6cmZhZWxYUKMbkSClv6lL6tLk64jEaKA
Date:   Fri, 28 Oct 2022 02:11:36 +0000
Message-ID: <efbddfbab88e4eb07e4c4ee33303d00a1a5be51a.camel@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|MWHPR0401MB3548:EE_
x-ms-office365-filtering-correlation-id: 0d18c118-f0a2-42c5-0134-08dab889be12
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oov5L3u4p+oy3DD4mZAKhBk4S4SOZp8yFH4rrR6ACPDl6cEIOJ4+Ga4A6fNRPS1QNKUdxa81Goq/JpImhL/f5PpdjVMV359GDzaW6e81KpOz6Bem6XXBp6IqLpog734mmHx/Fq7APmbx1jhf48BceuQNQboltIvbIEDCKeY5nhGy8TGiWGCSHy346WtkgAD+IPd2MWV3M+usK77Q2mlme5R0GoHHO5dVobyy6++AUD2OWJVLNYGZb+LNuXZjx4gx1cYmL/+oCRFnQ+gMeHZb6OW0XZ+ayVXfVxYIUHJMQpyplKFgLRD7FrZLvvobrNosIqisVqjMCpTi+qd4ABXkCToMsAvmc4GYGbfvRckxou7vBDQQHdu6ZFo6CDs8ZaWQ1z3xP2y8ko0YhphtxSFN8ycNolJb2wWmjRSiXCnCP6qIxoA04+allKZYNDxktaBCpNDOZH80iZYAFv9g58KajgmR7IPoTnI6t7tHDjbh9F35wjvSfNOEp9jTVuY7HaB5khL0qs5nviu3oN42lUju1JQocrSsgPU3lCnd9zd/mdp837C+KJmk/Qvz4hGfTlmD2U+ocsNFcTQrusRWzCvT9fRWtkFHEi3hU2Y6ruwFme9/8C0oCZ10miY6u95srgREwd7Zt3QwzLzfg9p/h+JxhpLqlACTO94rdD0zRA2Yv7zi6iOFwaxTtdcFYNlIKL1wVkIU2xow+MqGvBWg9b7EkIS5jQvgMVYUKvL/u0IEOmzRLS8/8DpIFvYvQBWVZVeLxh4/vde+KEO1CzBIRvt4Ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(8936002)(6512007)(5660300002)(6506007)(26005)(186003)(82960400001)(122000001)(2616005)(4001150100001)(38100700002)(2906002)(36756003)(41300700001)(38070700005)(15650500001)(83380400001)(478600001)(86362001)(316002)(64756008)(8676002)(6486002)(54906003)(66946007)(76116006)(66556008)(66446008)(66476007)(91956017)(110136005)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LytVNHZjQlVKbHgyczhOWlNVa09XQ3o2dTdZV3BGVXUzTzViRHloTEZMMzRQ?=
 =?utf-8?B?cE9qcVVaL2NWK0ZIUGZaZGdvcWROSFU5Q3pRN3M5ZzNyMUJpOXJKMDVSV3U4?=
 =?utf-8?B?a1BQS3pjQ0R5TUEvWkZoZ3Bnam1mMDdCVndOaUZCaFVUVWhPZ0Z4K0dXdHBG?=
 =?utf-8?B?NWdEUndSbFYvekJRdyttVG1ObS9KalRMbGJQY3E3RE1wQVk3U1hzSmhXaTc3?=
 =?utf-8?B?SVV1RzZlRTM5bEl4ak42cHl5eU1TRGZ4WHZGdXBzaVpQa0liQ0d4c3ZsK29F?=
 =?utf-8?B?UVFSTW9paHpQajRjaWREMFFxTm8zemxoRG1DUjluVzFnTkl1M3VNWGFVdDQx?=
 =?utf-8?B?SW01eTY3RWkzMzgrWExJVUV5WGZma0EwNXJwd2k5Z0s2a3E1NE5KUENpN04v?=
 =?utf-8?B?b0dzVlNBRWpSOUVaRVBmc2VCWFgra3BGQVo4L0VINXpzVDBBNFkvNUgwRG9R?=
 =?utf-8?B?TTJWc1BseUZ4dm83Ym5ZVDV5eDRsSkRxVGlmc3lWVkx1QXEybWdFdDA4S0xq?=
 =?utf-8?B?U3RUTmtJeUNRVnh3OWhIdUI3dTJmLzhrT0EyeElGMFMvQ3pMS2dQVTdXRGwy?=
 =?utf-8?B?SG5KM3hQNUNKcFBzWURyTWRNM0hZdWdxdnNvN3Y3K21qSnY1UVpycjFkVnRH?=
 =?utf-8?B?Wjh2ZVFuY2FQc2pqT1FjYnp6NFpWd1Q0TnZEYWowSEMwb0p4VEpIZ2tsYmFY?=
 =?utf-8?B?QUNsUWw4ZExGM1NKWFBpWVorenY0bnhuRVFpVFIxNEdFbzQ4Zkd0bW5FZ2ow?=
 =?utf-8?B?RWJ6SmlMdi9vVFVLS3VRY2Fwa2RtYndQUGp0a0lZMnZQQWVSdWRnYzFUZnVv?=
 =?utf-8?B?Ri9WVGV5emFQVi9za3dYZ29NM1FpU2hCUUhWMkZqTUtsMWFPeS9pL3M5dmhx?=
 =?utf-8?B?VkhWWCtQMitWVTFhUW1TZitzOXB4a05RcXNNb3pzU0tKT2JvaVI4RWFVeWQv?=
 =?utf-8?B?NElyQWxzTElYTTUrSXNPSWhVL1VMdlNTK2lTaFdDVVJUTlRoKzJpa29NQTRp?=
 =?utf-8?B?S2tmNElzWjVvTmp5dTJMdUZ6TmYxMGtFVC9YN2tXVUtIQUliTkY2ZVU3a0Iv?=
 =?utf-8?B?dFdYVzdjQnUvQ2VvT3Z1K1VGY0xVSVJhbzJLV0dSSjhTMHN0dmg3ekxvc2pY?=
 =?utf-8?B?TTN5WkJlMGxWbnc0SUdKM0c2WlIvS0NoUUhqdW9uN0pna2R1Q09OUGxnb2tW?=
 =?utf-8?B?NW1lMGxOM1FFRlNkNUdmL1duWmM2NFNkbThhcnY0cTRPV3pIemRtZVozNWFo?=
 =?utf-8?B?SHVRbkdtRVJFZlEra3gxMklZNEtGWnArUnlmTjY5dVZzYit1Ry8xbWVPTFRo?=
 =?utf-8?B?akZEdnBnb203TFExVnJ4U01TdXFsemlDNjJIUHRSNWJnTmY5UWx1ZEswMnQ2?=
 =?utf-8?B?VURKTmhaU2U1WUV1dGJvc1BycTZqVG9FZWFtZ1pDY0xyMUg4RE1rdTlNWUQ3?=
 =?utf-8?B?clhPOUdzRjNleFQvZy9tV3NZR053MjRleDZIUkRyN0JTY2w5bW9UU0R6TC9x?=
 =?utf-8?B?MnpubXNveEp3MjlmUjg1dHlnRm9ubUM5a3cvWGFKV0x3Z2JjWExjRU9sQnlT?=
 =?utf-8?B?S3g0MWxOdXJ5Ym9XQWlCMzkzOGxZazNvbFA2TXZRNDF3SE9wZzFNMnoyUkZu?=
 =?utf-8?B?N0N0SXArQTFhNDRvYTBabW04aU1HVVBuUVBpeXhUV1M1dGx2cys0RU10d3FE?=
 =?utf-8?B?ZENETEI2YnlTZkxtUjNWb1I2MjlSVE5FY29XTzd0cnFJMVYyMHhlUUdpVXly?=
 =?utf-8?B?M2VoU3JQdThKV2hEMVRVa1lDMXAzcW9OV25MQUtnMWlBc1FNR0l3NTlYZ3lD?=
 =?utf-8?B?T3VlMjVCZEk5YzRzbkhjZDlGbUJ5QkVqMXNjSlRPTnAxZnI4eFdJNzBndFZM?=
 =?utf-8?B?UmJvM28wWC9JcXZqZ0lZQWZETG9CVDZNSVI2TWRSTjJFcmlPRWlIQmo3TU95?=
 =?utf-8?B?d2NHQXh4eDhvb0wxTU9rL1JDNGJkNEFHc0JCVVNzQ1hYRkJYYkJCall6T2Jv?=
 =?utf-8?B?MkRRYVBjYkdud2Ezelg1bGgyM1VUTGd0WkRFNlk1UEZXU215bE1uSzdVbGhn?=
 =?utf-8?B?QStLdmhLVU0wUHo5dmkyVnpJbjBaZFdsSkh3MU5PNHFBL3pickVtaTZ1QjNx?=
 =?utf-8?B?US9iR0c3R3RDK0dlRTNBZi9CbG5PR1N1MlN1ZlJ6L2J2NXNjNEZvNEswc042?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0E5BA925C832B49B6CE2983747EC8D5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d18c118-f0a2-42c5-0134-08dab889be12
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:11:36.4759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Up87cCe+gzm55J5eE8DMuFFWZakijfMHcVfyCuL3L1/i9Y8KRJePcOgNmf4utPZFYlcdX7Hvn7Twx2g+h4Qjdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0401MB3548
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDE1OjAxICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gV2hlbiB6b25lbW9kZSBpcyB6YmQgYW5kIGJsb2NrIHNpemUgaXMgbm90IGRpdmlz
b3Igb2Ygem9uZSBzaXplLCB3cml0ZSB0YXJnZXQNCj4gem9uZSBzZWxlY3Rpb24gZG9lcyBub3Qg
d29yayBhcyBleHBlY3RlZC4gRmlyc3QgZm91ciBwYXRjaGVzIGluIHRoaXMgc2VyaWVzIGZpeA0K
PiB0aGUgaXNzdWUgYnkgaW50cm9kdWNpbmcgem9uZSBmaW5pc2ggb3BlcmF0aW9uLiBGaXJzdCB0
aHJlZSBwYXRjaGVzIGRvDQo+IHByZXBhcmF0aW9uIGFuZCB0aGUgNHRoIHBhdGNoIGRvZXMgdGhl
IGZpeC4NCj4gDQo+IFRoaXMgc2VyaWVzIGFsc28gZml4IGZvdXIgbW9yZSBpc3N1ZXMgcmVsYXRl
ZCB0byB2ZXJpZnkgd2l0aCB6b25lbW9kZSB6YmQuIFRoZQ0KPiBmaXJzdCBpc3N1ZSBpcyB0aGF0
IHZlcmlmeSBpcyBhbGxvd2VkIG9ubHkgd2hlbiBibG9jayBzaXplIGlzIGRpdmlzb3Igb2Ygem9u
ZQ0KPiBzaXplLiBUaGUgNXRoIHBhdGNoIHJlbW92ZXMgdGhpcyBsaW1pdGF0aW9uLiBUaGUgc2Vj
b25kIGFuZCB0aGlyZCBpc3N1ZSBhcmUNCj4gY2F1c2VkIGJ5IHpvbmUgcmVzZXQsIHdoaWNoIGVy
YXNlcyBkYXRhIHBhdHRlcm4gZm9yIHZlcmlmeS4gVGhlIDZ0aCBhbmQgN3RoDQo+IHBhdGNoZXMg
YWRqdXN0IHZlcmlmeSBhbmQgem9uZSByZXNldCB0aW1pbmcgdG8gYXZvaWQgdmVyaWZ5IGVycm9y
cyBieSB0aGUNCj4gZXJhc2VkDQo+IGRhdGEgcGF0dGVybi4gVGhlIGxhc3QgaXNzdWUgaXMgZXhw
ZXJpbWVudGFsIHZlcmlmeSwgd2hpY2ggZG9lcyBub3Qgd29yayB3aXRoDQo+IHpvbmVtb2RlPXpi
ZC4gVGhlIDh0aCBwYXRjaCBjaGVja3Mgb3B0aW9ucyB0byBlcnJvciBvdXQgd2hlbiBleHBlcmlt
ZW50YWwNCj4gdmVyaWZ5IGlzIHNwZWNpZmllZCB0b2dldGhlciB3aXRoIHpvbmVtb2RlPXpiZC4N
Cj4gDQo+IEZpdmUgbW9yZSBwYXRjaGVzIGZvbGxvdyB0byBtYWtlIHRlc3QgY2FzZXMgaW4gdC96
YmQgbWF0Y2ggd2l0aCB0aGUgZml4ZXMuDQo+IA0KPiBDaGFuZ2VzIGZyb20gdjE6DQo+ICogU2Vw
YXJhdGVkIHpiZF96b25lX3JlbWFpbmRlcigpIGFkZGl0aW9uIHRvIDNyZCBwYXRjaCBhbmQgYWRk
ZWQgc3VnZ2VzdGVkDQo+IGh1bmtzDQo+ICogQWRkZWQgbGFzdCAxM3RoIHBhdGNoIGZvciBhIG5l
dyB0ZXN0IGNhc2UgdG8gdGVzdCBleHBlcmltZW50YWxfdmVyaWZ5IG9wdGlvbg0KPiAqIFJlZmxl
Y3RlZCBvdGhlciBjb21tZW50cyBvbiB0aGUgbGlzdA0KPiAqIEFkZGVkIFRlc3RlZC1ieSBhbmQg
UmV2aWV3ZWQtYnkgdGFncw0KPiANCg0KVGhlIGZvbGxvd2luZyBzY3JpcHRzIHdlcmUgcnVuIHRv
IHRlc3QgdGhpcyBzZXJpZXM6DQoNCnQvemJkL3J1bi10ZXN0cy1hZ2FpbnN0LW51bGxiDQp0L3pi
ZC90ZXN0LXpiZC1zdXBwb3J0IGFnYWluc3QgYSBXREMgU01SIFNBVEEgZHJpdmUNCnQvemJkL3Rl
c3QtemJkLXN1cHBvcnQgYWdhaW5zdCBhIFdEQyBTTVIgU0FTIGRyaXZlDQp0L3piZC90ZXN0LXpi
ZC1zdXBwb3J0IGFnYWluc3QgYSBXREMgWk5TIE5WTWUgZHJpdmUNCnQvemJkL3Rlc3QtemJkLXN1
cHBvcnQgb24gYSBWTSBhZ2FpbnN0IGEgbnVsbF9ibGsgZGV2aWNlIChicz00SykgY3JlYXRlZCBv
biB0aGUNCmhvc3QgYW5kIHZpcnR1YWxpemVkIHZpYSB2aXJ0aW8tYmxrIG1ldGhvZCAoZXhwZXJp
bWVudGFsKS4NCg0KQWxsIHRoZSB0ZXN0cyBhYm92ZSBhcmUgcGFzc2luZy4gVGhlcmUgaXMgb25l
IHNtYWxsIGNvbW1pdCBtZXNzYWdlIGNoYW5nZSB0aGF0IEkNCnN1Z2dlc3RlZCBpbiBhIHNlcGFy
YXRlIGVtYWlsLiBXaXRoIHRoYXQsIGZvciB0aGUgc2VyaWVzLA0KDQpUZXN0ZWQtYnk6IERtaXRy
eSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5jb20+DQpSZXZpZXdlZC1ieTogRG1pdHJ5
IEZvbWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2RjLmNvbT4NCg0KDQo+IFNoaW4naWNoaXJvIEth
d2FzYWtpICgxMyk6DQo+IMKgIG9zbGliOiBibGt6b25lZDogYWRkIGJsa3pvbmVkX2ZpbmlzaF96
b25lKCkgaGVscGVyIGZ1bmN0aW9uDQo+IMKgIGVuZ2luZXMvbGliemJjOiBhZGQgbGliemJjX2Zp
bmlzaF96b25lKCkgaGVscGVyIGZ1bmN0aW9uDQo+IMKgIHpiZDogYWRkIHpiZF96b25lX3JlbWFp
bmRlcigpIGhlbHBlciBmdW5jdGlvbg0KPiDCoCB6YmQ6IGZpbmlzaCB6b25lcyB3aXRoIHJlbWFp
bmRlciBzbWFsbGVyIHRoYW4gbWluaW11bSB3cml0ZSBibG9jayBzaXplDQo+IMKgIHpiZDogYWxs
b3cgYmxvY2sgc2l6ZSBub3QgZGl2aXNvciBvZiB6b25lIHNpemUNCj4gwqAgemJkOiB2ZXJpZnkg
YmVmb3JlIHpvbmUgcmVzZXQgZm9yIHpvbmVfcmVzZXRfdGhyZXNob2xkIG9wdGlvbg0KPiDCoCB6
YmQ6IGZpeCB6b25lIHJlc2V0IGNvbmRpdGlvbiBmb3IgdmVyaWZ5X2JhY2tsb2cgb3B0aW9uDQo+
IMKgIHpiZDogcHJldmVudCBleHBlcmltZW50YWwgdmVyaWZ5IHdpdGggem9uZW1vZGU9emJkDQo+
IMKgIHQvemJkOiBmaXggdGVzdCBjYXNlICMzMyBmb3IgYmxvY2sgc2l6ZSB1bmFsaWduZWQgdG8g
em9uZSBzaXplDQo+IMKgIHQvemJkOiBtb2RpZnkgdGVzdCBjYXNlICMzNCBmb3IgYmxvY2sgc2l6
ZSB1bmFsaWduZWQgdG8gem9uZSBzaXplDQo+IMKgIHQvemJkOiBhZGQgdGVzdCBjYXNlIHRvIGNo
ZWNrIHpvbmVfcmVzZXRfdGhyZXNob2xkIG9wdGlvbiB3aXRoIHZlcmlmeQ0KPiDCoCB0L3piZDog
cmVtb3ZlIGV4cGVyaW1lbnRhbF92ZXJpZnkgb3B0aW9uIGZyb20gdGVzdCBjYXNlICM1NA0KPiDC
oCB0L3piZDogYWRkIHRlc3QgY2FzZSB0byBjaGVjayBleHBlcmltZW50YWxfdmVyaWZ5IG9wdGlv
bg0KPiANCj4gwqBlbmdpbmVzL2xpYnpiYy5jwqDCoMKgwqDCoMKgIHzCoCAzNCArKysrKysrKysN
Cj4gwqBpb2VuZ2luZXMuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMiArDQo+IMKgb3Ns
aWIvYmxrem9uZWQuaMKgwqDCoMKgwqDCoCB8wqDCoCA4ICsrKw0KPiDCoG9zbGliL2xpbnV4LWJs
a3pvbmVkLmMgfMKgIDM3ICsrKysrKysrKysNCj4gwqB0L3piZC90ZXN0LXpiZC1zdXBwb3J0IHzC
oCA1MiArKysrKysrKysrLS0tLQ0KPiDCoHpiZC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDE1OCArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0K
PiDCoHpiZC5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAyIC0NCj4g
wqA3IGZpbGVzIGNoYW5nZWQsIDIyMiBpbnNlcnRpb25zKCspLCA3MSBkZWxldGlvbnMoLSkNCj4g
DQoNCg==
