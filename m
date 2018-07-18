Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:46538 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730774AbeGRDyU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Jul 2018 23:54:20 -0400
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id D6E2F6107C
        for <fio@vger.kernel.org>; Wed, 18 Jul 2018 03:18:38 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] idle-prof: append output cpu idleness data to terse log
Date: Wed, 18 Jul 2018 03:18:35 +0000
Message-ID: <AT5PR8401MB1169740953CAF420D64D20DCAB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <925A83423110DA4D836092D40AC7A7E8084E0DEE@APYOKXMS108.ap.sony.com>
 <AT5PR8401MB116995DF0FE7729E290EEAB5AB5C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAB-428=sjscbp4UoagO41K102Ba=Ng5uoXhVgCO4Uix4+zEg_g@mail.gmail.com>
 <CALjAwxgEqChgK++6YHxg7gCyGxT4=dCAy7cZNqOgHhC==cHuQA@mail.gmail.com>
 <CAB-428m9DFwvCUu6VOpF-mQkYxFWeb5VM-s4HcQC_F+DGw1xgg@mail.gmail.com>
In-Reply-To: <CAB-428m9DFwvCUu6VOpF-mQkYxFWeb5VM-s4HcQC_F+DGw1xgg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Friendy.Su@sony.com" <Friendy.Su@sony.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "No.Tanaka@sony.com" <No.Tanaka@sony.com>, "Hajime.Tomura@sony.com" <Hajime.Tomura@sony.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxpcmV6YSBIYWdoZG9v
c3QgPGhhZ2hkb29zdEBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMTcsIDIwMTgg
MjoyNSBQTQ0KPiBUbzogU2l0c29mZSBXaGVlbGVyIDxzaXRzb2ZlQGdtYWlsLmNvbT4NCj4gQ2M6
IEVsbGlvdHQsIFJvYmVydCAoUGVyc2lzdGVudCBNZW1vcnkpIDxlbGxpb3R0QGhwZS5jb20+Ow0K
PiBGcmllbmR5LlN1QHNvbnkuY29tOyBmaW9Admdlci5rZXJuZWwub3JnOyBOby5UYW5ha2FAc29u
eS5jb207DQo+IEhhamltZS5Ub211cmFAc29ueS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0g
aWRsZS1wcm9mOiBhcHBlbmQgb3V0cHV0IGNwdSBpZGxlbmVzcyBkYXRhIHRvDQo+IHRlcnNlIGxv
Zw0KPiANCj4gT24gVHVlLCBKdWwgMTcsIDIwMTggYXQgMjoxMyBQTSwgU2l0c29mZSBXaGVlbGVy
IDxzaXRzb2ZlQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiAxNyBKdWx5IDIwMTggYXQg
MTU6MzAsIEFsaXJlemEgSGFnaGRvb3N0IDxoYWdoZG9vc3RAZ21haWwuY29tPiB3cm90ZToNCj4g
PiA+IE9uIFR1ZSwgSnVsIDE3LCAyMDE4IGF0IDk6MTggQU0sIEVsbGlvdHQsIFJvYmVydCAoUGVy
c2lzdGVudCBNZW1vcnkpIC4uLg0KPiA+ID4+IFNpbmNlIHRoZSB0ZXJzZSBmb3JtYXQgaXMgbm90
IHNlbGYtZGVzY3JpYmluZywgbmV3IGZpZWxkcyByZXF1aXJlDQo+ID4gPj4gYSB2ZXJzaW9uIGJ1
bXAgKHNlZSAtdGVyc2UtdmVyc2lvbikuDQo+ID4gPj4NCj4gPiA+PiBNYXliZSBvbmUgb2YgdGhl
IHZlcnNpb25zIHNob3VsZCBwcmludCBvdXQgdGhlIGZpZWxkIG5hbWVzIGFzIHRoZSBmaXJzdA0K
PiA+ID4+IGxpbmUsIHNvIGl0IGJlY29tZXMgc2VsZi1kZXNjcmliaW5nLiAgSSBndWVzcyB0aGUg
anNvbiBmb3JtYXQgYWxyZWFkeQ0KPiA+ID4+IHByb3ZpZGVzIHRoYXQgZnVuY3Rpb25hbGl0eSwg
c28gaXQgbWlnaHQgbm90IGJlIG5lY2Vzc2FyeS4NCj4gPiA+Pg0KPiA+ID4gSG93IGFib3V0IGFk
ZGluZyBhbiBleHRyYSBjb21tYW5kIG9wdGlvbiBsaWtlIC0tdGVyc2UtaGVhZGVyIHRoYXQNCj4g
PiA+IHByaW50cyBvdXQgdGhlIGhlYWRlciBvbmx5PyBJdCBpcyBoYXJkIHRvIGtlZXAgdHJhY2sg
b2YgdGhlc2UgdmVyc2lvbg0KPiA+ID4gY2hhbmdlcyBpbiBvbmUgcGxhY2UgYXQgdGhlIHVzZXIg
bWFudWFsIG9yIHNvbWUgYmxvZyBwb3N0Lg0KPiA+ID4gd2l0aCBhIHRlcnNlIGhlYWRlciBjb21t
YW5kIG9wdGlvbiwgSSBjYW4gaWdub3JlIHRoZSB0ZXJzZSB2ZXJzaW9uIGFuZA0KPiA+ID4gYWRq
dXN0IG15IHRlc3Qgc2NyaXB0cyB0byBxdWVyeSB0aGUgaGVhZGVyIGZpcnN0IGJlZm9yZSBydW5u
aW5nIHRoZQ0KPiA+ID4gdGVzdCwgdGhlbiBwdWxsIHRoZSByaWdodCBjb2x1bW4gYWZ0ZXIgdGhl
IHRlc3QgZmluaXNoZXMuDQo+ID4NCj4gPiBZb3Ugd291bGQgdGhlbiBuZWVkIHRvIGRvY3VtZW50
IGFsbCB0aGUgdGVyc2UgZm9ybWF0cyBiZWNhdXNlIHlvdQ0KPiA+IG5ldmVyIGtub3cgd2hpY2gg
b25lIHNvbWVvbmUgd2lsbCB1c2UgKGl0IGxvb2tzIGxpa2UgdGhlcmUgYXJlIGZvdXI6DQo+ID4g
aHR0cDovL2Zpby5yZWFkdGhlZG9jcy5pby9lbi9sYXRlc3QvZmlvX2RvYy5odG1sI2NtZG9wdGlv
bi10ZXJzZS12ZXJzaW9uDQo+ID4gKS4gQXQgdGhpcyBzdGFnZSBzaG91bGRuJ3Qgd2UgYmUgbnVk
Z2luZyBwZW9wbGUgdG93YXJkcyBKU09OIHdoaWNoIGlzDQo+ID4gbW9yZSBzZWxmIGRlc2NyaWJp
bmcgYW5kIGVhc2llciB0byBleHRlbmQgaW4gYSBiYWNrd2FyZHMgY29tcGF0aWJsZQ0KPiA+IG1h
bm5lcj8NCj4gDQo+IEkgYW0gb24gYm9hcmQgd2l0aCB5b3VyIHN1Z2dlc3Rpb24gYnV0IG5vdCBl
dmVyeSB1c2VyIG1pZ2h0IGhhdmUgYQ0KPiB0aW1lL3Jlc291cmNlIHRvIHJlLWltcGxlbWVudCB0
aGVpciBleGlzdGluZyB0ZXN0IHNjcmlwdCB0byB3b3JrIHdpdGgNCj4ganNvbi4gV2Ugc2hvdWxk
IHN0b3AgYWRkaW5nIG1vcmUgdmVyc2lvbnMgb2YgdGhlIHRlcnNlLiBPdGhlcndpc2UsIElmDQo+
IHdlIHdhbnQgdG8gY29udGludWUgc3VwcG9ydGluZyB0aGUgdGVyc2UgZm9ybWF0LCBJIHJlY29t
bWVuZCB0bw0KPiBmaWd1cmUgb3V0IGEgcHJvZ3JhbW1hdGljIHdheSB0byBoYW5kbGUgaXRzIGNv
bXBsZXhpdHkuDQoNCkhvdyBhYm91dCBkZWZpbmluZyB0aGF0IHRoZSBuZXh0IHRlcnNlIHZlcnNp
b24gYWx3YXlzIGluY2x1ZGVzDQphIGhlYWRlciBsaW5lLCBzbyBpdCdsbCBiZSBzZWxmLWRlc2Ny
aWJpbmcgYW5kIGNhbiBiZSB0aGUgZmluYWwNCnRlcnNlIHZlcnNpb24uDQoNCg0KLS0tDQpSb2Jl
cnQgRWxsaW90dCwgSFBFIFBlcnNpc3RlbnQgTWVtb3J5DQoNCg0K
