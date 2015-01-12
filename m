Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:42993 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbALW5q (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Jan 2015 17:57:46 -0500
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3427.houston.hp.com (Postfix) with ESMTPS id 89E576F
	for <fio@vger.kernel.org>; Mon, 12 Jan 2015 22:57:45 +0000 (UTC)
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: REPORT: FIO random read performance degradation without
 "norandommap" option
Date: Mon, 12 Jan 2015 22:56:23 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A732BE0@G9W0745.americas.hpqcorp.net>
References: <D0D596A1.FF42%andrey.o.kudryavtsev@intel.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
 <D0D59CE2.FF94%andrey.o.kudryavtsev@intel.com>
 <CANvN+e=i1bs71VjQL+mw-5ud0b2+H=vMG1Cwr0KWudVfHma=QQ@mail.gmail.com>
 <D0D9732D.107AC%andrey.o.kudryavtsev@intel.com>
In-Reply-To: <D0D9732D.107AC%andrey.o.kudryavtsev@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3VkcnlhdnRzZXYsIEFu
ZHJleSBPIFttYWlsdG86YW5kcmV5Lm8ua3VkcnlhdnRzZXZAaW50ZWwuY29tXQ0KPiBTZW50OiBN
b25kYXksIDEyIEphbnVhcnksIDIwMTUgMzowNiBQTQ0KPiBUbzogQW5kcmV5IEt1em1pbg0KPiBD
YzogRWxsaW90dCwgUm9iZXJ0IChTZXJ2ZXIgU3RvcmFnZSk7IGZpb0B2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFJFUE9SVDogRklPIHJhbmRvbSByZWFkIHBlcmZvcm1hbmNlIGRlZ3Jh
ZGF0aW9uIHdpdGhvdXQNCj4gIm5vcmFuZG9tbWFwIiBvcHRpb24NCj4gDQo+IEhpIEFuZHJleSwN
Cj4gVGhhbmsgeW91LCBpdCBleHBsYWlucyB0aGUgcHVycG9zZSBvZiB0aGlzIGZlYXR1cmUuIFVu
Zm9ydHVuYXRlbHkgaXQgd2FzDQo+IG5vdCBjbGVhciB0byBtZSBmcm9tIHRoZSBtYW51YWwsIEkg
ZmF1bHR5IHN1cHBvc2VkIGl0IGluY3JlYXNlcyB0aGUNCj4gcmFuZG9tbmVzcyBvZiB0aGUgcmFu
ZG9tIGdlbmVyYXRvciBkaXN0cmlidXRpb24uIFRoYW5rcyBhZ2FpbiENCj4gDQo+IEnigJlkIHBy
b3Bvc2UgdG8gaGF2ZSBpdCBhdXRvIHNldCB0byAibm9yYW5kb21tYXAiIGlmIOKAnHJhbmRyZWFk
4oCdIHdvcmtsb2FkIGlzDQo+IHNwZWNpZmllZC4gRG9lcyBpdCBtYWtlIHNlbnNlPw0KPiANCg0K
SSBkb24ndCB0aGluayBJJ2QgY2hhbmdlIGl0LiAgRm9yIHJhbmRyZWFkLCByYW5kb21tYXAgZW5z
dXJlcyB0aGF0IGVhY2gNCkxCQSBoYXMgYmVlbiBhY2Nlc3NlZCBvbmNlIGJlZm9yZSBpdCByZXBl
YXRzIHJlYWRpbmcgYW55IG9mIHRoZSBMQkFzLiBUaGF0DQpjb3VsZCBiZSB1c2VmdWwgaW4gc29t
ZSBjYXNlcywgbGlrZSBzY2FubmluZyB0aGUgbWVkaWEgKGVuc3VyaW5nIHlvdSd2ZQ0KcmVhZCBl
YWNoIExCQSkuDQoNCi0tLQ0KUm9iIEVsbGlvdHQgICAgSFAgU2VydmVyIFN0b3JhZ2UNCg0KDQo=
