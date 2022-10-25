Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD498C38A2D
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiJYXve (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiJYXvd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:51:33 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7B8A2A93
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666741891; x=1698277891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vlNG85v/kvFW+hyfBZGSbZM3B8MqE18qwRP6wZvqsDA=;
  b=DGFC/onFo4H3bFnE4aF+JPE3dLXoFkY3MBt+q28toXYsYpVSgLI+tiK8
   doRtJX0FuQJaLCykX/HJ6GYyepQ2uuC0NGqFCm3YKx7nsZmIYvW71xX3R
   yIC+bpWcZxxmyQp65uxUlVCQq5+Z3OQsr0WDAkCLyrTmDYC677jz5f+T1
   Klcj9/oYOIfD50YgPyMsCi9bMq9qb85Oa32KJqANb+knHKxHn/ZR9xBYs
   4fn1Ikl4PE+jqfs0DjyCLm+AxsPZTaZrYjODt63YKsFmfKwCORLhmE+A2
   K8aiZaOU5r5AQ8cn6vJdzgpeJaxWzqMM0SVK7jsIN4Q4xt+3ItZ0uU/Un
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="214730352"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:51:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtrtbYuZNw4s70ACmC9eSANOgQvqfgVnLzGRmQ7bCkOFVblnnE1wv7MneqmdhTPBPPiM7yHLa55OwWxHyoIfDtwi7pOKFmJ/oM+dqugSuWJxthaplcnDTqzUmgvfrYq4dHJ1Vkw/bG5RhZwSkShh6svBrJwjHVH+ZS+1XHXIcCK2ZJUiNgIvREdpvmq2KGZcxMfEkORpUmxecadaouDlGVkgp560Zy/Z4QVasv3HJ0o7Ak0uZrgkuRP4u9ll1hX4J9+yQvjzH4I/h73jx9oelkrOlpL7wTFn+JHi0ctchjQor02xu2IvXmnWCSN5Xd9+p2JH3R7Fkp4uhCzlijYoGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlNG85v/kvFW+hyfBZGSbZM3B8MqE18qwRP6wZvqsDA=;
 b=S8K++ccW4l/wPYy56LEzPLScgRTaVMHjKL4mncMNynGKAM/RCPj/YS3PPgDZIWk/qXh+rJ4TUZMvr+xoZSTAV1I3/ZddA+5M5n5OV+hDzTWiWZigDdntvOq9ZFWvQ0Zf2BuBEKd0u9nGdTGTuC6Y/+PUQ3wjX0xL3RdE2JhbCMAoua0FFZwuyLyuKFCfeI9XDVjA1Pq/qi30OMqbzvG39nEL3EJqdrq26j/hfvfVFy7aOowFWVjHdAMMhBgjj2wnqyadR54NkL79BoMI4KwdEW9BD2Mf6X4lJg2pov32t89L5zY85k0xs40K9dR16H63g0yMPkmwZbefjkVvlk7W0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlNG85v/kvFW+hyfBZGSbZM3B8MqE18qwRP6wZvqsDA=;
 b=l2Wup/KjTfz5ZOmgbyt1rmiBaLsuwduhMWxwnBIJoMIxQ9Z8+hvg/hJO55/1+Ed+bwu+UdhtZQewQ5pfNgzXY2aMkR5A6/+QXIeqji0UudW1ra9APXT8l0olUWWLjvM9XaAxWEitdloanpcr5D7ofamGrvuWl98nAhCJTtDh1x8=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:51:28 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:51:28 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 02/11] engines/libzbc: add libzbc_finish_zone() helper
 function
Thread-Topic: [PATCH 02/11] engines/libzbc: add libzbc_finish_zone() helper
 function
Thread-Index: AQHY5RcpokMeDC7FvEKg1Wg4CvQVrq4fzzaA
Date:   Tue, 25 Oct 2022 23:51:28 +0000
Message-ID: <75fd094bcdb68d06b699e3e383e0ae8dd5fcb97e.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-3-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: f05799ed-dd1c-4222-bf99-08dab6e3d5b5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JKoF/N3jPAqGMMAZyo+UkpKcMWK+EehU5ec1JI9VStcVbAo0uS8wplosF0O0TqjN9U28iH8rYI1gCH5P3GqWM02pQMNsvIBp4HK0kKH1+fXSyV/bE6wmAmi4l10zTGar9U1pgy5zRVPkeOJvEJ8Otw01JDsA/lHe9289bgiUjg6WStSBhhNal4uPpr7Hw2ZbbhadqVkYZf+v02KU+h/jCvrGyrBdFykmLPnv2KqzjQA7a0ipXc7vM7JkvxbhAtIcn2cXB99It6vNlIzkEiDCIWPY+l4v22bheXzWEBb/14JwPcor9oLfoDT35eNau/mzsP3Fe98nQR4eXOZK5z2c8/1kkRgsPcQuvym61zPoj01rx9tE5LBQx6KWKT67h/Lb6+k5m8tYeoup0v+JG/9CDXxYPyBqxpylJievyDooj7JQ9CgGz/xCACvGd1MK8jJkg8b9fALObR//cKeY/Y7RYPeN88LE93KcLkKgKq0oVPWGG/I5NZZEb8a0dbybDnWMcS5mjp9TMSEZdXauXrBfNQgmj6gPkrGGfLPvwIIh2WMhUdmdfBOfMNZScdl6AuslCQU6D7G9+9B4OMJg03rmrcAgq+tzhpNSp/TI9/QTeYRjThVzhYMKfojfcCd91o2aqiGBzR3toYcp95TcNGL8ZMj9hWvJQroTfChUfiF7789C0GtSZC5tv1dFqDnX261lRPblDJXlWGU6fAt/vX11dkZXJghhKxgX3B30DRQvtFftacW1H8PUnlDlTeKm0RMN9uw2btcxZiWTZbVYH6l8TQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(38100700002)(186003)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTdvbkZ3Q2JHcVplRDdjWmVNNVJrSlhKaklnMno0T1VXdVNqcGhWT2xCYVB6?=
 =?utf-8?B?RG9WeEhCeHJ6eEhYYkdlb09xYnBOL2R1ZU1CS0N4QnJlZ2RDWGVPQTBrQ2Vm?=
 =?utf-8?B?WXo3MjVUaWFURjhsbldwWWlTVkg1bDJ0dWlOLzR2bG51UDVKTVhyYVo1cFlS?=
 =?utf-8?B?SkVEc1hkNm9JMDBCMXhlbDhpRWxTR1FJTW9uck9ockdVS1c2RjhJQWt0V0hX?=
 =?utf-8?B?NTdGVk5ldTRMUnNydnNoSWtzN0dCT1FmME9uNVpTQVVJTzNyOHJTT1hFRmlO?=
 =?utf-8?B?ZjJCRnpYTzh6L2xkVW1MazhEcXdRS0JIQW1Yb3VXdk9Dc2R1VXh0RFo3Zlp3?=
 =?utf-8?B?NUQyNk9sVHZvS0VVNVV4YTE2SFJ6NEdSN01ibEhtRmpLTzM1REpXZWFpWjYr?=
 =?utf-8?B?VDRLNkpHL0EyeEhxczF6S0psZVpvVC9GQTc3NzBMOUdWemxjK1VVMWZkdVQ4?=
 =?utf-8?B?dno5UE9nNUlrWmpyN3hqOGo5bjRDOWRhQno5V0owVHNQYUl1VWwvR2RHbHV6?=
 =?utf-8?B?UjMzNjFxVzVnd0RiVzdNeWpzUlp3MHdRUEJPL1NaQkdpYU0rZ1J2SVFLLzJW?=
 =?utf-8?B?NE9XampDZGhhZzVIUmh3Z081aWhOZ0d0SURWL3Y0blo1M3NETHNJNlREem1V?=
 =?utf-8?B?aUlqMDlhYWxhUERMVk5vK0ZGTFdpZndLNWhudXk2UldGYjVpd3dZTjkxb01k?=
 =?utf-8?B?dWE4MVJnSU92V25aUmZ5bG5jeVE1a2tLOUliQXV3M255a2tuVkpNR2FjQU1K?=
 =?utf-8?B?YUlOVlVmQXpKbWZTakt3dUEyUWgxY3VBRDZ2R3grQmg1RENkdnBUY2VQQWI3?=
 =?utf-8?B?MkIrVEhCVnBIclpQeHZYOTBxb3Q5YnZqaUxxSk5JcU1wM285ZFVjbHQvK3Bm?=
 =?utf-8?B?bVk0RDJWUEg5dVkrWkowT2NBRG93TDhCTHdReU8wOXk2bWh4Umc2SjdlcXhj?=
 =?utf-8?B?NFpOWGFRbTNUWm54eFBBMHF3a1UvZFBWNnNHWk9YV1JEanJ3b2xabHh5bThV?=
 =?utf-8?B?U3ZmK3BsRXhHcktKakxDVUx4azcxWHk2MHZpUnNWVEl6N2ZOUklJTGxuYTZr?=
 =?utf-8?B?RjJBeDYxRHovSXROQSs0OWdOSDdOSzVuanpDZW1NcmJVWGJCQWFTTk0xc1J2?=
 =?utf-8?B?Mm1wM3Z0YWhhOGFMeVVhb29ERFordDFiS2RrYURXYmlkVE5IdGN1bEFDQ2xR?=
 =?utf-8?B?clBvZ3JPZmNIL25ndmt1VTlYelhLM1VWMm52NjJaamg1T0l3d1JneFlQQTNq?=
 =?utf-8?B?Qm04b29qV0hXV01RZktPVWZBWUpWdmRwcTVBWHBZeWpxNkNZV28rWjZacThN?=
 =?utf-8?B?aDBtWDZ5RFFoeUdWVCtuL3lhb1VUemtxVkxkMmhNdnd3VmdvTzErbW8vUGY5?=
 =?utf-8?B?Q2JPcnFWaGlyQjRhbHZ5NC9PWmFvdkx2djY2MDRYWkV0TmdTR1QyZ29oN092?=
 =?utf-8?B?TW1OS0EzU1U0d1V0UEdJTFJVeVFGanNTNjFvZUNTcnpCeG94UUpTRklmWHFN?=
 =?utf-8?B?MVUzSnBETUhUbXZTT0d0dDBqV054R3IzUFR3VDRxNXBEVEVDT0g4Q2ZveHBG?=
 =?utf-8?B?bm52SGJWcDNkVFpXd2JGR2VORlYwVVNYS1JFaTZTVnlJNktRaEs3VGl1aHlO?=
 =?utf-8?B?V1V6VTFZK044MDNaNlVRdlhNNTZWUXlpNXpxeDVQL2dNR1Z3YktZdVlQUVBj?=
 =?utf-8?B?ekVLMCtMYlBTcDg3cWFPTFdaazV4b0pMNHVSUXU4L2VqY0ljbEFTM2ZaQitz?=
 =?utf-8?B?L1d4QW5aL1JES1QxOG43b3B6VVlXZ0lLdWdMSkxRRFBuWUZsWXZuMEpCOGJF?=
 =?utf-8?B?Ym42SmVqaGV6M1owZnk5UkRZd1BXYXBPTUNpeklnVnVzeURFOUdDa2o0QVVl?=
 =?utf-8?B?d0E4WitOcFYxMTFyUGN1dy9zQUhVcW9XeU5BRzF0ZkRJTldyNmlmRC91Rkpz?=
 =?utf-8?B?R2hRMGhpamdWajJ2bTlCTUJFdEh4SmptZGErd3NkVnRpdm5LWkZvT1NPMTN2?=
 =?utf-8?B?M3UrUWJHakI3SzEwLzNldm5hN3hhVUwyVTBPTXFaeVBVSk5GZEpsYVRxTTdo?=
 =?utf-8?B?Ri9hRzRkS2c2R0RRNFA0KzNzMnpVelhNQlB3M2NRcC8zaW0zcWVCOGYvWEkw?=
 =?utf-8?B?SFhVSTFIdjBVb0tCQUMvbm9kd1RPTnRQeXdUS3Q2TzlKY3FnaW1zazFMb25M?=
 =?utf-8?B?YkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36C4116C5D9D964D9341C1217CADE52E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f05799ed-dd1c-4222-bf99-08dab6e3d5b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:51:28.5323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHa2V6Q2tuKpJ3L3FlvTg4InmifMZgAhnMnWynqg1WjuYXmIQ3WbzWaDhFH/QXaA1z8FDBj4yDNQAVXivvhFIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBUbyBzdXBwb3J0IHpvbmUgZmluaXNoIG9wZXJhdGlvbiB0byBaQkMgZHJpdmVzIHRo
cm91Z2ggbGliemJjLCBhZGQKPiBmaW5pc2hfem9uZSgpIGNhbGxiYWNrIHRvIHN0cnVjdCBpb2Vu
Z2luZV9vcHMsIGFuZCBpbXBsZW1lbnQgaW4gbGliemJjCj4gSU8gZW5naW5lLiBUaGlzIGZlYXR1
cmUgaXMgdXNlZCB0byBrZWVwIHRoZSBzYW1lIHpvbmUgaGFuZGxpbmcgYnkKPiB6b25lbW9kZT16
YmQgZm9yIGxpYnpiYyBlbmdpbmUgYXMgb3RoZXIgZW5naW5lcy4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29tPgoKTG9v
a3MgZ29vZC4KClRlc3RlZC1ieTogRG1pdHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2Rj
LmNvbT4KUmV2aWV3ZWQtYnk6IERtaXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5j
b20+Cgo+IC0tLQo+IMKgZW5naW5lcy9saWJ6YmMuYyB8IDM0ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKPiDCoGlvZW5naW5lcy5owqDCoMKgwqDCoCB8wqAgMiArKwo+IMKgMiBm
aWxlcyBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2VuZ2luZXMv
bGliemJjLmMgYi9lbmdpbmVzL2xpYnpiYy5jCj4gaW5kZXggMmJjMmM3ZTAuLjJiNjNlZjFhIDEw
MDY0NAo+IC0tLSBhL2VuZ2luZXMvbGliemJjLmMKPiArKysgYi9lbmdpbmVzL2xpYnpiYy5jCj4g
QEAgLTMzMiw2ICszMzIsMzkgQEAgZXJyOgo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLXJldDsK
PiDCoH0KPiDCoAo+ICtzdGF0aWMgaW50IGxpYnpiY19maW5pc2hfem9uZShzdHJ1Y3QgdGhyZWFk
X2RhdGEgKnRkLCBzdHJ1Y3QgZmlvX2ZpbGUgKmYsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IG9mZnNldCwgdWludDY0
X3QgbGVuZ3RoKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGxpYnpiY19kYXRhICpsZCA9
IHRkLT5pb19vcHNfZGF0YTsKPiArwqDCoMKgwqDCoMKgwqB1aW50NjRfdCBzZWN0b3IgPSBvZmZz
ZXQgPj4gOTsKPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnQgbnJfem9uZXM7Cj4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IHpiY19lcnJubyBlcnI7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IGksIHJl
dDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgYXNzZXJ0KGxkKTsKPiArwqDCoMKgwqDCoMKgwqBhc3Nl
cnQobGQtPnpkZXYpOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBucl96b25lcyA9IChsZW5ndGggKyB0
ZC0+by56b25lX3NpemUgLSAxKSAvIHRkLT5vLnpvbmVfc2l6ZTsKPiArwqDCoMKgwqDCoMKgwqBh
c3NlcnQobnJfem9uZXMgPiAwKTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8
IG5yX3pvbmVzOyBpKyssIHNlY3RvciArPSB0ZC0+by56b25lX3NpemUgPj4gOSkgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXQgPSB6YmNfZmluaXNoX3pvbmUobGQtPnpkZXYs
IHNlY3RvciwgMCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyZXQpCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIGVycjsK
PiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+ICsKPiAr
ZXJyOgo+ICvCoMKgwqDCoMKgwqDCoHpiY19lcnJubyhsZC0+emRldiwgJmVycik7Cj4gK8KgwqDC
oMKgwqDCoMKgdGRfdmVycm9yKHRkLCBlcnJubywgInpiY19maW5pc2hfem9uZSBmYWlsZWQiKTsK
PiArwqDCoMKgwqDCoMKgwqBpZiAoZXJyLnNrKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBsb2dfZXJyKCIlczogZmluaXNoIHpvbmUgZmFpbGVkICVzOiVzXG4iLAo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZi0+ZmlsZV9uYW1lLAo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgemJjX3NrX3N0cihl
cnIuc2spLCB6YmNfYXNjX2FzY3Ffc3RyKGVyci5hc2NfYXNjcSkpOwo+ICvCoMKgwqDCoMKgwqDC
oHJldHVybiAtcmV0Owo+ICt9Cj4gKwo+IMKgc3RhdGljIGludCBsaWJ6YmNfZ2V0X21heF9vcGVu
X3pvbmVzKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBmaW9fZmlsZQo+ICpmLAo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgKm1heF9vcGVuX3pvbmVzKQo+IMKgewo+IEBAIC00
MzQsNiArNDY3LDcgQEAgRklPX1NUQVRJQyBzdHJ1Y3QgaW9lbmdpbmVfb3BzIGlvZW5naW5lID0g
ewo+IMKgwqDCoMKgwqDCoMKgwqAucmVwb3J0X3pvbmVzwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0g
bGliemJjX3JlcG9ydF96b25lcywKPiDCoMKgwqDCoMKgwqDCoMKgLnJlc2V0X3dwwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgPSBsaWJ6YmNfcmVzZXRfd3AsCj4gwqDCoMKgwqDCoMKgwqDC
oC5nZXRfbWF4X29wZW5fem9uZXPCoMKgwqDCoMKgPSBsaWJ6YmNfZ2V0X21heF9vcGVuX3pvbmVz
LAo+ICvCoMKgwqDCoMKgwqDCoC5maW5pc2hfem9uZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0g
bGliemJjX2ZpbmlzaF96b25lLAo+IMKgwqDCoMKgwqDCoMKgwqAucXVldWXCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA9IGxpYnpiY19xdWV1ZSwKPiDCoMKgwqDCoMKgwqDCoMKg
LmZsYWdzwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPSBGSU9fU1lOQ0lPIHwg
RklPX05PRVhURU5EIHwgRklPX1JBV0lPLAo+IMKgfTsKPiBkaWZmIC0tZ2l0IGEvaW9lbmdpbmVz
LmggYi9pb2VuZ2luZXMuaAo+IGluZGV4IGZhZmExZTQ4Li4xMWQyMTE1YyAxMDA2NDQKPiAtLS0g
YS9pb2VuZ2luZXMuaAo+ICsrKyBiL2lvZW5naW5lcy5oCj4gQEAgLTYxLDYgKzYxLDggQEAgc3Ry
dWN0IGlvZW5naW5lX29wcyB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgdWludDY0X3QsIHVpbnQ2NF90KTsKPiDCoMKgwqDCoMKgwqDCoMKgaW50ICgq
Z2V0X21heF9vcGVuX3pvbmVzKShzdHJ1Y3QgdGhyZWFkX2RhdGEgKiwgc3RydWN0IGZpb19maWxl
ICosCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCAqKTsKPiArwqDCoMKgwqDCoMKgwqBpbnQgKCpm
aW5pc2hfem9uZSkoc3RydWN0IHRocmVhZF9kYXRhICosIHN0cnVjdCBmaW9fZmlsZSAqLAo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRf
dCwgdWludDY0X3QpOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgb3B0aW9uX3N0cnVjdF9zaXplOwo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZmlvX29wdGlvbiAqb3B0aW9uczsKPiDCoH07Cgo=
