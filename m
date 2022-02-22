Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C955C433EF
	for <fio@archiver.kernel.org>; Tue, 22 Feb 2022 14:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiBVOAb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiBVOAb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Feb 2022 09:00:31 -0500
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2123.outbound.protection.outlook.com [40.107.24.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7FC127D5A
        for <fio@vger.kernel.org>; Tue, 22 Feb 2022 06:00:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Me1uulB8kZJ0HCC3o3AVvmOR2meuDS3TGFiDxadS2mEMLsA5kmSK9fo812Yej0AN8zQ1QYdjRKG9+e4RVaWzsCxTaJWorIRVo8ThL1mSFk3JF/a5ccZjMpPR1w/OmfzzSUuVBSBA/OKYgn2cJN3MgZhN717bn1+pWO6w1U6d9EVBAE2o7gdhFQo7HnZ0EV3jh6JMuXaACTqlzCDkKbRq4WAY84B1rZrV6OwOnvNQJYWBdZfPNQnCbmBMQGdcWyBxczhhgLUES20K35lM3iXf3vkI/hEzXT2ms/bHybOFlEtAy/BYERwmBxBlTFBywMY/ByGffOQtQVw7mcjsii0c5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bQe4HZ0ujkK7L2ZdBZY6Kdw0TMsihlEux9sCDq1Pds=;
 b=JKO5F6k5olSTFmPgg2LErWVlzMpfK+fANPd2X10ar0bFV0xJzXwHoN37NlhAWN7tlsf5Z3fOJ1E8BpfMLlMLOkNbc4pRe6hiEmuBOoLS1/dvjSfaxn5oZ/qKRR10cESpM5afWLRZtVcvSsagGvfgRozRNNwFGwgpuWrbUdFTUvfRh3QCcWJbhBZleiLzpfRoyIcgb7uKRx+9zloh72+C53R7SbLqxQBeQ7uoC8gxtO2/rCckeGN/DaCKasgWYiFbnBTZoa5B1GvDSZnIq9/p+DhZ4ab3Utfsg2C4CEa0LsYkZvNLegrwKGPPRoiYP6N25jf86ree5sJ6o9kdQsi/lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bQe4HZ0ujkK7L2ZdBZY6Kdw0TMsihlEux9sCDq1Pds=;
 b=quXMxYIzHPgKZiDbFpSYwIFzVG/IJEJoVgDGWQVAvGL6rePhdzaeLOlF1+CNtOvEZ0X3s2OWlO0kNA4kY/aVXY/0LwKhxbddPv3yGuS+HFMO4OFKJhC8jI4IAlOnd91ZCfaXkwdXUqM1irj6MRigrcXjqEqZV3JVmY+N4EH4l/s=
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by GVAP278MB0248.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 14:00:02 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 14:00:02 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: Using FIO on systems with <=512MB RAM
Thread-Topic: Using FIO on systems with <=512MB RAM
Thread-Index: AQHYJzEERcXvP3wQB0KCk0vhofz1/qyeqsMAgADv0wA=
Date:   Tue, 22 Feb 2022 14:00:02 +0000
Message-ID: <7c8c801bba09694a19695a551191cd970f5c6a97.camel@toradex.com>
References: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
         <a93f0c6f-2b1e-c046-2cbd-654894cddcd8@opensource.wdc.com>
In-Reply-To: <a93f0c6f-2b1e-c046-2cbd-654894cddcd8@opensource.wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22a95e76-cc3f-44ec-5896-08d9f60b9f2f
x-ms-traffictypediagnostic: GVAP278MB0248:EE_
x-microsoft-antispam-prvs: <GVAP278MB0248F8B6D85354EE9DC66368F43B9@GVAP278MB0248.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MRWexGY24WKaSDVli53ESTxCMrWcV/ohvadN10S6jAJdYksJQHIRWPXTlfecyxadq6Q/tj+bKG9qCTLtd8QfklAqvQYRx/9CYy13pQKIYHNRCgsRnPUCMd7iUT6GMm/c8Y7ORGdRRhLdE8dg6C8Kk7bFtHLKxpuaimhe3wzMq6lMoOWrnEQSCjWnKw2fM7Fqgtbcpqb0nuVGiL7LStwOeTy7IMQlzP/fHdm4kEgwN8IgI25Sl69cb7Awku/KwusfyotzWNxeh/WnoXqsYdenGSTFby2I4IGFJhM1Qz1JUSe8bTqYHtI39DI7jzxkt5+CvHLuNg3MF3HqfkZLgzhe3J12RlcGnzzjVb00UMriPkuEaSgwMiVTr/XW63ZdvuOGfQan9dQTwIByVbHI42dgJfsKpWAuyMahtS6n3Z1uQ9/PzNJsfSH7KTXVEBj1zKWKz/jDNDTdybI2BpFfbJY8HK43LHRazmXfmozICmp7HHAtj3rfSLw84WBkEomBQDGFh4bs3vRTBK72G2F5LglJuOjZ/NsRLNbbJhcjmSv1OyHI76RfXjP93xQn4OQqlyrWUEbXvwDAapQyG6OFfttIK1iX/KuPUxeTn29M+5Sw1p/o8OQxQ+MsqMEkBUlC5BRc1f1HGnI0APnH8IX8y74ImccrX3F+R2UYjHzmBV/HtURpOiou56UXZBmXy8jKwA0f3K9BQ9yR1pPSMk4+0QSbww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(66476007)(66446008)(6486002)(186003)(8676002)(76116006)(122000001)(26005)(66556008)(66946007)(2616005)(71200400001)(86362001)(64756008)(498600001)(5660300002)(6506007)(53546011)(36756003)(6512007)(44832011)(2906002)(38100700002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnpkWk9CemEvMm1hbUZ0bTlMMUtFaWhMalBSdG0zVlRwSGNWdmlsdzNXZGNR?=
 =?utf-8?B?U25kTjNRZW9JK1d0NmY4YlVHWUNZOUlMVWNZUVhiOExqRElJQlhmYTFPMi9w?=
 =?utf-8?B?Y0lFZjN5WXJVaUhMaWRQZ2pieWs4MHBuZkF2NEducVdFL2R3UHNNK2wzV0ZS?=
 =?utf-8?B?Mzd4dTNWVlpKN2NUVUpjelNMbWtYYnQzdmtkdUVCYWc4amJrYThLaS9JSmNy?=
 =?utf-8?B?b3J1bTB1VWduQVRuWEwvcDRRTGFoODM2R0ZVc0poTm40b3lsam1KTnBOUDY3?=
 =?utf-8?B?ZG5lMG84d1kyeDhKWFVJc0lVNXozWnYvVWY4VDFrWlpJQTdUSkdaNEIzTkNv?=
 =?utf-8?B?b1p3cDBjbUYyd2tvYjRlbHF3ZFFKWjNBREY3NW1zcjNQbE15S3k2YnJpRkNQ?=
 =?utf-8?B?ekh6MHg5Qk91L3I2YXR0b3ZVbEFSOTNMODBCT3QwcXVvVVUzck1Hdzc4VlZu?=
 =?utf-8?B?elMybllZOU5rRk9NdFJ5c1l5Sk45K24vVUhhelRISk5WU3BlMU9KamhuNWQ3?=
 =?utf-8?B?Tng4K2FmSjR2QlIyeGN1RnVzUER1WTNGSzhmYVlGWWF3djJvMXJzZGxOQ3Ar?=
 =?utf-8?B?SUNib1BwOXpLeklhS2xNUEwxeEhXUnVZblpLV0dHUkZzcnlNclE2YzdIc2di?=
 =?utf-8?B?S2F4ZUl3Q0h3eXBxMGExWDhjb3hzZEI2bVRqcW5BVTJIMS9JMEFNVjNHWXJq?=
 =?utf-8?B?dzNJMkZmL2t4ODQvSVhJNGhIWEtYaEh6eTR2MXdGUTh0NE9MeUtjcEE0akRM?=
 =?utf-8?B?NXBoOHd5RHA3dGNwaGdsc1ovVnNTOUthQnY4dFk5YlhmUHJEVjV4ZHpmc3BZ?=
 =?utf-8?B?MUp0RTkxR3JOSUlCaFlaWmIxZnNib09Hb2x3MjErWnJDem53c1g5Ni9oZTI1?=
 =?utf-8?B?eXcxeU9XZTNXMDhudkZTOC96dnA3MGJmQ09Tak0yaFpTaXdDYmpmK3dqWmI1?=
 =?utf-8?B?WjAwUUFGL3dCdXFiVjJxT0FHUktURzVLM21rOGNYUjFjY1ZuRGNXSXdyS2hs?=
 =?utf-8?B?a0l1ZEhqRmtPNEpLczBGT3Qwd1BReFc4SVh0OHcwL1hvMHhIME03eStaVmNM?=
 =?utf-8?B?M1BaazBBU01BQkNSQU52RXJnQ0VtaW1XT0VQNVl0eUdycGRqZWUxdStPUUE5?=
 =?utf-8?B?TVNFODZqaTAxUVMxdzZEYTF3NUJCbWhZVjJzeldXMm4zdkRtNmxIamlKNm5x?=
 =?utf-8?B?NG5meDg3NXV2QUNxOWRybGpCWCtIY3hsaU8yVVF0OUE2UHRJRm5UTGN5a29k?=
 =?utf-8?B?NFRDbXE5VTlKSWEvVC90ZUUraVY2czBNd1J5NDR1YU5ubzQrVFlMTVFLak9y?=
 =?utf-8?B?SGZmS2Z6cG9QSVFISGhWb0gxajNrQkpEUDhTOTdHNFNwK0lUS3VYS0h1dmpa?=
 =?utf-8?B?emFjbEVJVlIyUG03OXhja2k5djdaNU15R1ZadFRFVkVvSndWNFFyVTQxY1RX?=
 =?utf-8?B?VUpEN2txeTRnZjNsY3JDaHBsMmRhVElOcng0ckxWaWxRUldyTkF6VGhEUXpB?=
 =?utf-8?B?cTBPckVGZG5ydzBZNUNLczQ4bkhSR0xaMFFqcmJWOGVQVlpTajVEcVFmWXF1?=
 =?utf-8?B?YUJmZEdjWnlrZWVMZnZ2N1NSQmhQdy9uV0IvbklzUnFKNmlXZVRoNWY0cmhM?=
 =?utf-8?B?WVptK0VSMThXKzEvR2VRazZ2WjU2aWVUZUR0cXJ1MlE3VXVoZW5tNi91Z0Zh?=
 =?utf-8?B?eEpLQzl0L3FVTnpwckFIdkcxeXZTWVh1cHpEVksrLzRlZDZZWmw0OFBweHho?=
 =?utf-8?B?MTZOM0pHM1lvQ1Jab0l2cVAzZjB1ekpRSFdvM2kzWWJGV3ExMDFEOXF0cWsy?=
 =?utf-8?B?UWQ1d2t0SWR2MTFjZHpIUFVZdVBEVU9WTi9tWVlBdFd3WnZLamdEeHNZL3hZ?=
 =?utf-8?B?dVh3ZkFwVExxc1QyWllSbUVQUHF6dTVhRXZOSWJCalp6cGx2Mkk4cHNhZ2F6?=
 =?utf-8?B?WGtnS0RENEhGNFA4cmV4SkdmKy9xUUFoRXhGbHNqc1BMcEdtR3gyQTVFK083?=
 =?utf-8?B?R24rT1EwdFVCWk0rUmJDUWpReFE3NDlESzl1cFZiZitueWN4MXFwZDViekJr?=
 =?utf-8?B?OTFvdmlFQWticjkwa0UvRVIzOVUyRWcrcnFIT05PTEgyRzRyaVlHbzdJNWxD?=
 =?utf-8?B?SjRiV1NkSXJ1dUJCa25rVlhnSTFqMWcyOUErUi92RngwTXp1aHgwMnJhNCt2?=
 =?utf-8?B?ajFFR2E4QnpJb2MxZjYxQ05pbWZHUnFudlRWa0FTOTVKYUxyMEFJQlcvbE5L?=
 =?utf-8?Q?T4UmCOHfmfTPDUH4POzpp8Ol5GzSs4FBputVFrN3Tg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DBD8B6F9903F64BA313E2C292D38686@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a95e76-cc3f-44ec-5896-08d9f60b9f2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 14:00:02.4764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MjOSeNvc90jTBfDIxC5o9f77tn/ig2Ag+Seb4lZFEIWOgf+iqRh/RJRRpw0Bd40Ogbiv3wnCCMdK5wzjy17LVonc6VLkMiiyJmoWcU5i5oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0248
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gVHVlLCAyMDIyLTAyLTIyIGF0IDA4OjQxICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gMi8yMS8yMiAyMzo0MCwgUGhpbGlwcGUgU2NoZW5rZXIgd3JvdGU6DQo+ID4gSGVsbG8N
Cj4gPiANCj4gPiBXZSB1c2UgRklPIHRvIGNoZWNrIHRoZSBlTU1DIHN0b3JhZ2Ugb24gb3VyIGVt
YmVkZGVkIGJvYXJkcy4gVGhpcw0KPiA+IHdvcmtzDQo+ID4gZ3JlYXQgZm9yIG91ciBtb2R1bGVz
IHRoYXQgaGF2ZSA+PSAxR0IgUkFNIGJ1dCBvbiBhbGwgbG93ZXItbWVtb3J5DQo+ID4gb25lcw0K
PiA+ICg8PSA1MTJNQikgdGhlIE9PTSBraWxsZXIgYWx3YXlzIGtpbGxzIEZJTy4NCj4gPiANCj4g
PiBJIGNhbiBob29rIHVwIGEgc3dhcCB3aGljaCBoZWxwcyBidXQgaXMganVzdCBwYWluZnVsbHkg
c2xvdy4NCj4gDQo+IFdlbGwgeWVzLCB5b3VyIHN5c3RlbSB3aWxsIGJlIHRyYXNoaW5nLi4uDQo+
IA0KPiA+IA0KPiA+IEkgcGxheWVkIHdpdGggdGhlIHNldHRpbmdzIG1lbSwgYnMsIGlvZGVwdGgg
YW5kIHNpemUgYnV0IGNhbm5vdA0KPiA+IGFjaGlldmUNCj4gPiBhIGNvbmZpZ3VyYXRpb24gdGhh
dCB3b3JrcyBvbiBsb3ctbWVtb3J5IGVtYmVkZGVkIHN5c3RlbXMuDQo+ID4gDQo+ID4gQ2FuIGFu
eW9uZSBndWlkZSBtZSBob3cgSSBjYW4gbWFrZSB0aGlzIHdvcms/DQo+IA0KPiBTZWUgaWYgcGxh
eWluZyB3aXRoIG9wdGlvbiAiLS1hbGxvYy1zaXplPSIgaGVscHMuIFlvdSBjYW4gYWxzbyByZWR1
Y2UNCj4gdGhlIG1heGltdW0gbnVtYmVyIG9mIGpvYnMgd2l0aCAiLS1tYXgtam9icz0iLiBBbHNv
IHRyeSB1c2luZyB0aHJlYWRzDQo+IGluc3RlYWQgb2YgKGRlZmF1bHQpIHByb2Nlc3NlcyBmb3Ig
am9icyAoLS10aHJlYWQgb3B0aW9uKS4gQW5kIG9mDQo+IGNvdXJzZQ0KPiBtYWtlIHN1cmUgdGhh
dCB0aGUgdG90YWwgYW1vdW50IG9mIElPIGJ1ZmZlcnMgeW91IG5lZWQgKG51bSBqb2JzICogaW8N
Cj4gZGVwdGggcGVyIGpvYiAqIGJzKSBpcyBub3QgdG9vIGxhcmdlIGZvciB5b3VyIFJBTSBzaXpl
Lg0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB5b3VyIGhlbHAgb24gdGhpcyB0b3BpYy4gSSB0
cmllZCB0aG9zZQ0KcGFyYW1ldGVycyBiYWNrIGFuZCBmb3J0aCwgaG93ZXZlciBpdCBzZWVtcyB0
byBhbHdheXMgcmVzZXJ2ZSB+NDAwTUIgb24NCnRoZSBiaWdnZXN0IGNodW5rIChjaGVja2VkIGlu
IC9wcm9jLzxwaWQtb2YtZmlvPi9zbWFwcykuDQoNCmRlY3JlYXNpbmcgdGhlIG1heCBhbGxvd2Vk
IHNoYXJlZCBtZW1vcnkgaW4gL3Byb2Mvc3lzL2tlcm5lbC9zaG1tYXggdG8NCn42NE0gZG9lcyBz
b2x2ZSBvdXIgaXNzdWUgYW5kIGZpbyB3b3JrcyBhbHNvIG9uIDI1Nk1CIHJhbS4NCg0KSG93ZXZl
ciB0aGlzIGxlYWRzIHRvIHRoZSBxdWVzdGlvbiBpZiB0aGlzIGlzIG5vdCBhIGJ1Zz8gSSBtZWFu
IGl0IHNlZW1zDQp0byByZXNlcnZlIHRoaXMgbWVtb3J5IGRlc3BpdGUgaXQncyBub3QgbmVlZGlu
ZyBpdD8NCldoYXQgbGVhZHMgbWUgdG8gdGhpcyBhc3N1bXB0aW9uIGlzIHRoYXQgSSBjYW4gYWxz
byBzZXQgbWVtPW1hbGxvYw0KaW5zdGVhZCBvZiBtZW09c2htIGFuZCBJIGdldCBzdGlsbCB0aGUg
c2FtZSBlcnJvci4NCg0KV2UgdXNlIGZpbyAzLjE3IGlzIHRoaXMgbWF5YmUgc29sdmVkIGluIG5l
d2VyIHZlcnNpb25zPw0KDQpCZXN0IFJlZ2FyZHMsDQpQaGlsaXBwZQ0KDQo+IA0KPiA+IA0KPiA+
IEJlc3QgUmVnYXJkcywNCj4gPiBQaGlsaXBwZQ0KPiA+IA0KPiANCj4gDQoNCg==
