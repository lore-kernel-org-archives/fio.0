Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:11111 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbeJYO1F (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Oct 2018 10:27:05 -0400
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id 3A1831A63
        for <fio@vger.kernel.org>; Thu, 25 Oct 2018 05:55:54 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: rand-read: increasing iodepth makes throughput drop
Date: Thu, 25 Oct 2018 05:55:51 +0000
Message-ID: <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
In-Reply-To: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Federico Motta <federico@willer.it>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Mark Brown <mark.brown@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>

PiBQYW9sbyBWYWxlbnRlIGFuZCBJIGZvdW5kIGFuIHVuZXhwZWN0ZWQgc3VycHJpc2Ugd2hpbGUg
aW52ZXN0aWdhdGluZw0KPiBpb2RlcHRoIGltcGFjdCBvbiB0aHJvdWdocHV0LiBCb3RoIG9uIG15
IGRldmljZSAoc3NkIHNhbXN1bmcgOTYwIHBybw0KPiBudm1lIG0uMiA1MTJnYikgYW5kIGhpcyBv
bmUgKHNzZCBwbGV4dG9yIHB4LTI1Nm01cyksIHRocm91Z2hwdXQNCj4gZGVjcmVhc2VzIGFzIHRo
ZSBpb2RlcHRoIGluY3JlYXNlcy4NCi4uLg0KPiBXaGF0IHdlIG9ic2VydmVkIGlzIHRoYXQgd2l0
aCAiaW9kZXB0aD0xIGFuZCBpb2VuZ2luZT1zeW5jIg0KPiB0aHJvdWdocHV0DQo+IGlzIGdyZWF0
ZXIgdGhhbiB3aXRoICJpb2RlcHRoPTggYW5kIGlvZW5naW5lPWxpYmFpbyIuICBGb3IgZXhhbXBs
ZToNCj4gLSBpb2RlcHRoPTEsICBzeW5jOiAxNzAuOTQyIMKxIDExLjEyMiBbbWIvc10NCj4gLSBp
b2RlcHRoPTgsIGFzeW5jOiAxNjEuMzYwIMKxIDEwLjE2NSBbbWIvc10NCj4gDQo+IA0KPiBTbywg
SSB3b3VsZCBsaWtlIHRvIGFzazoNCj4gMSkgSXMgaXQgbm9ybWFsIHRoYXQgdGhyb3VnaHB1dCBk
cm9wPyAoc2hvdWxkbid0IGRldmljZSBpbnRlcm5hbA0KPiBxdWV1ZXMNCj4gYmUgbW9yZSBmaWxs
ZWQgd2l0aCBhIGdyZWF0ZXIgaW9kZXB0aCBhbmQgdGh1cyBsZWFkIHRvIGEgZ3JlYXRlcg0KPiB0
aHJvdWdocHV0PykNCg0KVGhlIGRyaXZlIHNwZWNzIGFyZToNCiogMzUwMCBNQi9zIHNlcXVlbnRp
YWwgcmVhZA0KKiA1Ny4zNDQgTUIvcyByYW5kb20gcmVhZCwgUUQxICgxNDAwMCBJT1BTIGRvaW5n
IHJhbmRvbSA0IEtpQiByZWFkcykNCiogMTM1MS42OCBNQi9zIHJhbmRvbSByZWFkLCBRRDQgKDMz
MDAwMCBJT1BTIGRvaW5nIHJhbmRvbSA0IEtpQiByZWFkcykNCg0Kc28gdGhlIGJpZ2dlciBpc3N1
ZSBpcyB3aHkgaXQncyB1bmRlcmFjaGlldmluZyBieSAxMHguDQoNCmRpcmVjdD0wIG1lYW5zIHlv
dSdyZSBpbnZvbHZpbmcgdGhlIHBhZ2UgY2FjaGUsIHdoaWNoIGRpc3RvcnRzIHJlc3VsdHMsDQpl
c3BlY2lhbGx5IHdpdGggbGliYWlvOg0KDQogICAgaW9kZXB0aD1pbnQNCiAgICBOdW1iZXIgb2Yg
SS9PIHVuaXRzIHRvIGtlZXAgaW4gZmxpZ2h0IGFnYWluc3QgdGhlIGZpbGUuIE5vdGUgdGhhdA0K
ICAgIGluY3JlYXNpbmcgaW9kZXB0aCBiZXlvbmQgMSB3aWxsIG5vdCBhZmZlY3Qgc3luY2hyb25v
dXMgaW9lbmdpbmVzDQogICAgKGV4Y2VwdCBmb3Igc21hbGwgZGVncmVzcyB3aGVuIHZlcmlmeV9h
c3luYyBpcyBpbiB1c2UpLiBFdmVuIGFzeW5jDQogICAgZW5naW5lcyBtYXkgaW1wb3NlIE9TIHJl
c3RyaWN0aW9ucyBjYXVzaW5nIHRoZSBkZXNpcmVkIGRlcHRoIG5vdCB0bw0KICAgIGJlIGFjaGll
dmVkLiBUaGlzIG1heSBoYXBwZW4gb24gTGludXggd2hlbiB1c2luZyBsaWJhaW8gYW5kIG5vdA0K
ICAgIHNldHRpbmcgZGlyZWN0PTEsIHNpbmNlIGJ1ZmZlcmVkIElPIGlzIG5vdCBhc3luYyBvbiB0
aGF0IE9TLiBLZWVwDQogICAgYW4gZXllIG9uIHRoZSBJTyBkZXB0aCBkaXN0cmlidXRpb24gaW4g
dGhlIGZpbyBvdXRwdXQgdG8gdmVyaWZ5DQogICAgdGhhdCB0aGUgYWNoaWV2ZWQgZGVwdGggaXMg
YXMgZXhwZWN0ZWQuIERlZmF1bHQ6IDEuIA0KDQpJZiB5b3UncmUgdHJ5aW5nIHRvIHRlc3Qgc3Rv
cmFnZSBkZXZpY2UgcGVyZm9ybWFuY2UsIHN0aWNrIHdpdGggZGlyZWN0PTEuDQoNCg0K

