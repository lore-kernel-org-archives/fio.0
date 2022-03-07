Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C600EC4332F
	for <fio@archiver.kernel.org>; Mon,  7 Mar 2022 12:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbiCGMeo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 7 Mar 2022 07:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiCGMe1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Mar 2022 07:34:27 -0500
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2113.outbound.protection.outlook.com [40.107.24.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CDD3EF2F
        for <fio@vger.kernel.org>; Mon,  7 Mar 2022 04:33:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQgKfmSYLa0vj+mp9WSTYo+Vmfng3zJ+kVeHy3PNOFBpLMrqjFGuwSXL75oDC4l1hwDNuI4Iatg4U45xQnio1JzZZP3Dh1+6MZ9gIkW4tVJVPZmX15Zj1UFbIqemMWi6yhtguPYIWptE/vL0lyqEPLPctkLttxRHi9VBfsssH6xUUjgeUqST80p/tibZPyHbjZ2Svit/qWepPnfV/1G3CGKsq1RxFT0zbckQ6jvP0kfegFgY7m5ohA0a0AVQFE/xlasqh1+CZKFaZrGzEuu0zm5sonI7uncsxXQM5kDo+pltrCXxL9m2eYVTm3fssIsQ1mSzobsOfXzwIME0+Gzisw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RslSfU2X5A9Ic37ecfjxykGD15t0XBnY8fpfKqce5UQ=;
 b=QJ06r1+mrhCp0gD/fgArVxTOTx3wkoebvu5GXsJyQ2JNcfJwUPtoTM0w7/9y0GD2M/FhWnI/9Fvz8gpgEjYAYkbvwaCjrMMhVcC26Qo0ZeDe7pgTYv1GbzPrmgYhbWyQjF8vNIarEqh2EwqTx0v1t/3CS0zBlnZgxVS01ccmXgXy4SL9eo2k9ozbId3iDh+iqaY9f3v7sEsLdKLG9Q6nbA8gK7G0kox5/3hT+wlv8+QyUFLWHpPZydv9HS+2+JawhXzGTXHUdyoKriUsMqEQofeeyiS3Ze/tXGCIZ3RXSVuuRO9w11utYMPyPfRAhLUfdPBxsbamO0io92hzyMJQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RslSfU2X5A9Ic37ecfjxykGD15t0XBnY8fpfKqce5UQ=;
 b=Y3/tA/Nt11jks9fYt9zqj1jjbRsgE4hZxm3ovnCfUwrnU/GjEDtdvOEnWDl0RK87/KfeLe+S7miysAdEaPrj9Oj0/IzY8JnDwAv3SulxzIuz2WQYn0mMcVPQ000pSwuDydNts7jqZkvsw+T1DoaYGFnoUaHh7mEi0V55zsWbf0I=
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZRAP278MB0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:13::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 12:33:21 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 12:33:21 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "volodymyrhoida@gmail.com" <volodymyrhoida@gmail.com>
Subject: Re: Using FIO on systems with <=512MB RAM
Thread-Topic: Using FIO on systems with <=512MB RAM
Thread-Index: AQHYJzEERcXvP3wQB0KCk0vhofz1/qypmkmAgApWZIA=
Date:   Mon, 7 Mar 2022 12:33:21 +0000
Message-ID: <0fca2e5a77db7289695db234af4a837e44c55198.camel@toradex.com>
References: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
         <75df0a0e-6f0c-66a1-ab88-b735503d9ecb@gmail.com>
In-Reply-To: <75df0a0e-6f0c-66a1-ab88-b735503d9ecb@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4eefa68-e0aa-4084-8955-08da0036aaac
x-ms-traffictypediagnostic: ZRAP278MB0013:EE_
x-microsoft-antispam-prvs: <ZRAP278MB0013C0BB102AB9F532E897F4F4089@ZRAP278MB0013.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kew6t3qGKB5rElIxmVmwjMHSHS21YZmJGIxBsj77QqUlppGiQTRrU2yRaXo1P7Vubvd/zRK98wlwqhiBX9cUM25HCBDDEyQrF62oFGi8PKcY79u12aRi5mEAzFwuz8vcuJotR8cnWtHrmCjAO/TgrPA23la05WPrR/NSTx6w8cizmKoRxbMeTPvIVAUOwW9c0h60x29ckiSk7+SKE0OyK/mrgyYx0LHUQYtsxKVNTXYHSEvfIvUtWekKbHXrBNy4Vsy1cfs1jc0Od0DYfW+ENQJhs894cHxoGrSYaTFKVt/mWFDjqYVnBsRtVtCwl7NGdEk9nf5lJS3IIW9US9zAXpgp4gdp13J4PBXmL5MNRw5MnlOqKjQgisR/NWXGkPlBR0UsPYwz4UqwvKFzNESzN1zG5I8GMN4SgZVzNhKRyOeJ5kTHBkUqM6+cQ+CbIohwzPUlzSQsuqmCGcl+jMV/HaFX6fNbXpk8pcoRl7F8BprSgjzZMcGAkXG4NO7KqXGcrnQOGD4CpgO+MlG+nxZ4+AXeoQ3ibI/B1OmJ/jy5LflJzjYqmY4Zef3yrkEw1T6ZP6xPlrE6hsHTdbKdQYpQMDszk2yE5vBNTxgwq3kFn2PvP6bxdXuLRmcj9/DcoQWhSlXU8iUkoez7zl3UJTWtWz4uYKgU2JvRLCXFVaclEJknKFUgnhPnhEGVLAEhAHgwwV4doTJ9Q7igmyN61vyTpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(136003)(396003)(376002)(39850400004)(346002)(8936002)(26005)(66946007)(66556008)(66446008)(66476007)(64756008)(8676002)(44832011)(5660300002)(186003)(83380400001)(36756003)(110136005)(6486002)(86362001)(2616005)(71200400001)(122000001)(2906002)(6506007)(6512007)(508600001)(76116006)(38070700005)(316002)(91956017)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGhnNWtBdGhuYXp0U3BGbXhkZkJTOWovaXpsand6cU5ScDBTRUFod1NzeWhk?=
 =?utf-8?B?a29nSHZuWTJ2VDhjZ09WWHZmNTBrcUd6RzU4MzArb3JlTVlVNlM4MVRsQ0xF?=
 =?utf-8?B?UFFVZzFVOGcxSURMaFRWTXpGT05WZWtkNTF0VyttaVFLdDcxMGN2ZXFiSytK?=
 =?utf-8?B?WXZwVGd1Z3kxdW1OZ0NDcU16V3BnL1FPOFJiWHhrMmhnenBBdUQ2T3lxK0Ft?=
 =?utf-8?B?ZUFMc041WFk5cXBDN2ZMU21Nd2hjMXZMVmxqM2RqRTRZT2JnNE5zdTlTbXNx?=
 =?utf-8?B?WEFhSk8xNHUycVFkbm45c3MzMzBVaHJMa1o4NTZXQmVyOHY3SU8zMml1RWZU?=
 =?utf-8?B?Y1U1Wmc4ZklnMUVSNjh0VUFvL29zQ0pZejBBU1MvTWVmUW1ZUnVpbnZtUEFO?=
 =?utf-8?B?bmhTSk8vUmt4V1pKdDl0dm9NelgrS01tamN6REpmc3NyU1VMaVlSYXdQY1hJ?=
 =?utf-8?B?WG5TTC9pZDVWTG9DMWhyU0VGMnllNzB4dFkyMjN2QktDZVpXR05XT0FGcW9H?=
 =?utf-8?B?NVNtT0dyU0VKMnRkZjVwT0hvOGRpZTVzL3l4M1dQN25xaklnN3NFRkxGYlJJ?=
 =?utf-8?B?bmdRUXpCeG91OE8zWmVXUEV3ZGg0YmhPR2NZVE5PZGFCN3NKNFlnNzRFV2ND?=
 =?utf-8?B?OWVQT0hjeHNqK1puRmtqSWpzYTFPSTgvbHpBdkVBZk5EOWpTN0R5YXRnU3Zi?=
 =?utf-8?B?djFDNDJmbHluOHZjbk5FdHdyREh6YjAyemZ3bCtrVHduMWZ4RkNYVTNFYkx5?=
 =?utf-8?B?ajA1WFNlOVZ3cWRIbkVyYWJJZXpFSnplY3NhaDNyZTJTU05RWWk0bzE1UjZZ?=
 =?utf-8?B?TkNHT3VVMk9lZ0FTMWZnaDJHendReFIxY3VoK0FJRmZaaWJGVEM1c0RpY25t?=
 =?utf-8?B?YjdmSXYxL1d1UERxa3R4UjFBenBrb0V3TzJoMnl0OHFFOVJvcHFyZkFaZUFj?=
 =?utf-8?B?d3ZJSkJ6QjhvTEl5cytuenEvdldZdTJmWTkzSHMwbGlESUJWSitxS3dlUUY5?=
 =?utf-8?B?UVAwQWpxUlo5b1A3Wm8wTHNSd1BxTWxYcUFRYkZoY0hqbFJ0d0hoVFZBRG5G?=
 =?utf-8?B?VXhNS0U2MFJMS3dOeHE4a1FaWjJveVRuZFlYVnExSWgxbXVONXJUaUo4MWpt?=
 =?utf-8?B?b0VrOHJ0MUYzNGh3ZXpGbnZ4UlJzaXZvWnQrVUtoOCtwa0tWbC9BN2prOVBw?=
 =?utf-8?B?M0FuL25Xalo2amc1c0lTVUhQNWI1Rk93TVcxUHY0amRRRkZCVHpvYU93S0tw?=
 =?utf-8?B?K0JMVUlVUEl2bXhzRnpiSzNrRzY2Yy9ZMlo3Rzk4M1NlMjlhZ3krclNpUk1F?=
 =?utf-8?B?ZlBSVSsvUTljTUptMlRVODZGRFR0aDM4VVhnek5qVEMwdTFTMzVWbmlFSi9Z?=
 =?utf-8?B?cEZoR1FXRGZJcWo0M2hUT0c2SzRzUnB6NUlkUWJvRWpEa0xMWWlPYyt2ZFQr?=
 =?utf-8?B?NnNlUUxjZUU1RnVxTGRmTG1EUmxRUHZEd1pFNldUaVBwWXdrMWZKMUQwSy9m?=
 =?utf-8?B?NWFJVXpjRXEweUFmRkgzTnFneHpuY3JGYmxkQ3FWL2haR2JIbXd4dU1Nb3RS?=
 =?utf-8?B?WmQrckhzZElUV1puUi9WNDBLQlVWREtMV2x2a1g3a2VTZUFzM1d1NExBWFJE?=
 =?utf-8?B?YXJ2bHMvYWFZODdXMFBVRDlsazd5Zm0xSWJtTHBmNGRtOHhXL0RScVk2Zk5s?=
 =?utf-8?B?RWVsNG9OSHdNV2h0Q1AybG4vNDhZSThIYWVxaTY5bXN6RVJ1OFJFNHNIbFZs?=
 =?utf-8?B?OC81VWYvU0ptWDN5RnhPWTBzUTdtNDZsY3htc2kyWUF3Q2xZMmpWY3JMWkdh?=
 =?utf-8?B?eE91K3FRZXBaMElYUnp0NklnTmFlWUtsZllBWVUyMFVJWWF5WkU5TWZsYkFP?=
 =?utf-8?B?cGg3MDJnMHJZT29GT3ZFbmhpblI0VWUycUc1NXBHaTA3MEtmaC9tVW9FWVZn?=
 =?utf-8?B?ZnVpbGxCNmVkVzBkaVpDSkZSODFjbzhjVDdGcDhCK3VRNVJMaXVLWGp3dngz?=
 =?utf-8?B?djAvNWJSMXQ2R3R4L3E4Y3dhR3BrUkJoaHcxaWlGQnNrWUZXejhpUlNxY1V0?=
 =?utf-8?B?MVR6L05yVW1CdTFlUWdZZEh5RU5veUVkVXo1U21YclA1bnhUTkZJNnNtWWJM?=
 =?utf-8?B?aHpWZTM2dXp0ZFBuZjlrZVpza096ditaQXZ4L2J2bk9aYXBwSVNwYUlteUJO?=
 =?utf-8?B?NUlnWU5jaklVRjFJUHBHei9qcExvcE1xSi9TL21taVdMNVRMdXNyUkUwVEVi?=
 =?utf-8?B?ZSs3ZVpIaDRHM2grVWx0S1hBQ2NBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96D56DE605311549A6253AD2BF7E1A78@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d4eefa68-e0aa-4084-8955-08da0036aaac
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 12:33:21.7233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QVODiI+a3ShEdFyHvLG0AKXHc4nyVvkmBOLX2lwfBMaXvcAFkXS6aNWGYbyGBNA3yceuoyiZt/JgVUeOI0KOj1Yq59Gc8o2wzcUgCds4Yx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0013
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGVsbG8gVm9sb2R5bXlyDQoNCkl0IHR1cm5lZCBvdXQgdGhhdCB0aGUgZmlvIHZlcnNpb24gd2Ug
d2hlcmUgdXNpbmcgd2FzIGVpdGhlciBidWdneSBvcg0KdGhlIHBhdGNoZXMgb3VyIGJ1aWxkc3lz
dGVtIChZb2N0by9PcGVuZW1iZWRkZWQpIHdhcyBhcHBseWluZyBkaWQgY2F1c2UNCnRoYXQgaXNz
dWUuDQpJIHVwZGF0ZWQgdG8gdGhlIGxhdGVzdCBmaW8gdmVyc2lvbiBpbiBvdXIgcmVjaXBlcyBh
bmQgSSBoYXZlIGl0IHJ1bm5pbmcNCm9uIDI1Nk1CIFJBTSBzeXN0ZW1zIG5vdy4NCg0KQmVzdCBS
ZWdhcmRzLA0KUGhpbGlwcGUNCg0KT24gVHVlLCAyMDIyLTAzLTAxIGF0IDAwOjQxICswMjAwLCBW
b2xvZHlteXIgSG9pZGEgd3JvdGU6DQo+IEknbSBkZXZlbG9waW5nIGFuZCBtYWludGFpbmluZyB3
ZWIgYmFzZWQgZ3VpIGZvciBmaW8gKHczdG9wKS4gQW5kIEkgDQo+IGNhbid0IGNvbmZpcm0geW91
ciBjb25jZXJuLg0KPiANCj4gT24geDY0IGxpbnV4LCAzODBNYiBvZiBSQU0gaXMgZW5vdWdoIGZv
ciBib3RoIHczdG9wIHN5c3RlbWQgc2VydmljZQ0KPiBhbmQgDQo+IGZpbyBleGVjdXRhYmxlLg0K
PiANCj4gT24gQVJNMzIgdGhlIHczdG9wK2ZpbyBwYWlyIG5lZWRzIGFib3V0IDMwME0gb2YgcmFt
Lg0KPiANCj4gV2hhdCBlbmdpbmVzIGRvIHlvdSB1c2U/IEknbSBhYm91dCBsaWJhaW8sIHBvc2l4
YWlvLCBpb191cmluZywgc3luYyoqKg0KPiBhbmQgbW1hcCB2Mi4yMSAuLi4gdjMuMjggb24gaGVh
ZGxlc3MgbGludXgNCj4gDQo+IDIvMjEvMjAyMiA0OjQwIFBNLCBQaGlsaXBwZSBTY2hlbmtlciDQ
v9C40YjQtdGCOg0KPiA+IEhlbGxvDQo+ID4gDQo+ID4gV2UgdXNlIEZJTyB0byBjaGVjayB0aGUg
ZU1NQyBzdG9yYWdlIG9uIG91ciBlbWJlZGRlZCBib2FyZHMuIFRoaXMNCj4gPiB3b3Jrcw0KPiA+
IGdyZWF0IGZvciBvdXIgbW9kdWxlcyB0aGF0IGhhdmUgPj0gMUdCIFJBTSBidXQgb24gYWxsIGxv
d2VyLW1lbW9yeQ0KPiA+IG9uZXMNCj4gPiAoPD0gNTEyTUIpIHRoZSBPT00ga2lsbGVyIGFsd2F5
cyBraWxscyBGSU8uDQo+ID4gDQo+ID4gSSBjYW4gaG9vayB1cCBhIHN3YXAgd2hpY2ggaGVscHMg
YnV0IGlzIGp1c3QgcGFpbmZ1bGx5IHNsb3cuDQo+ID4gDQo+ID4gSSBwbGF5ZWQgd2l0aCB0aGUg
c2V0dGluZ3MgbWVtLCBicywgaW9kZXB0aCBhbmQgc2l6ZSBidXQgY2Fubm90DQo+ID4gYWNoaWV2
ZQ0KPiA+IGEgY29uZmlndXJhdGlvbiB0aGF0IHdvcmtzIG9uIGxvdy1tZW1vcnkgZW1iZWRkZWQg
c3lzdGVtcy4NCj4gPiANCj4gPiBDYW4gYW55b25lIGd1aWRlIG1lIGhvdyBJIGNhbiBtYWtlIHRo
aXMgd29yaz8NCj4gPiANCj4gPiBCZXN0IFJlZ2FyZHMsDQo+ID4gUGhpbGlwcGUNCj4gPiANCg0K
