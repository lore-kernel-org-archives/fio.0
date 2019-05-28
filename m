Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:46690 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfE2Cy3 (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 28 May 2019 22:54:29 -0400
Received: from pps.filterd (m0170395.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SEOp3t010852
        for <fio@vger.kernel.org>; Tue, 28 May 2019 10:33:04 -0400
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0b-00154904.pphosted.com with ESMTP id 2sq2cna7mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Tue, 28 May 2019 10:33:04 -0400
Received: from pps.filterd (m0144104.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SEMqOI133883
        for <fio@vger.kernel.org>; Tue, 28 May 2019 10:33:03 -0400
Received: from ausxipps301.us.dell.com (ausxipps301.us.dell.com [143.166.148.223])
        by mx0b-00154901.pphosted.com with ESMTP id 2ss4pgahg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Tue, 28 May 2019 10:33:03 -0400
From: <Kurt.Dorsey@dell.com>
Subject: RE: Reverse Sequential with Offset
Date: Tue, 28 May 2019 14:33:01 +0000
Message-ID: <8dcac75b130d4b3b84c973a78aa8293e@ausx13mps316.AMER.DELL.COM>
References: <72b31a3d5cb84498b62265003e6882e2@ausx13mps316.AMER.DELL.COM>
 <CALjAwxjN3mA6rrH22rX6hDiiYZT3t4qefpm0R70cZ1nQHOT8hQ@mail.gmail.com>
In-Reply-To: <CALjAwxjN3mA6rrH22rX6hDiiYZT3t4qefpm0R70cZ1nQHOT8hQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sitsofe@gmail.com
Cc: fio@vger.kernel.org

VGhhbmsgeW91IFNpdHNvZmUhICBUaGlzIHdvcmtlZCBwZXJmZWN0bHkNCkkgZGlkbid0IHRoaW5r
IG9mIGNvbnN0cmFpbmluZyB0aGUgc2l6ZSBvZiB0aGUgZGV2aWNlIHRvIGdldCB0aGUgam9iIGRv
bmUNCg0KLUt1cnQNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFNpdHNvZmUg
V2hlZWxlciA8c2l0c29mZUBnbWFpbC5jb20+IA0KU2VudDogU2F0dXJkYXksIE1heSAyNSwgMjAx
OSA0OjA1IEFNDQpUbzogRG9yc2V5LCBLdXJ0DQpDYzogZmlvDQpTdWJqZWN0OiBSZTogUmV2ZXJz
ZSBTZXF1ZW50aWFsIHdpdGggT2Zmc2V0DQoNCg0KW0VYVEVSTkFMIEVNQUlMXSANCg0KSGksDQoN
Ck9uIEZyaSwgMjQgTWF5IDIwMTkgYXQgMTM6MzYsIDxLdXJ0LkRvcnNleUBkZWxsLmNvbT4gd3Jv
dGU6DQo+DQo+IEhlbGxvLA0KPg0KPiBJIGFtIGxvb2tpbmcgdG8gZG8gcmV2ZXJzZSBzZXF1ZW50
aWFsIElPIGFuZCBhbSBoYXZpbmcgc29tZSBpc3N1ZXMuDQo+DQo+IFBlciB0aGUgbWFuIHBhZ2Ug
YW5kIGRvY3MgdGhpcyBpcyB0aGUgam9iIEkgYW0gdXNpbmcsIHV0aWxpemluZyB0aGUgcmVhZDot
NjRLICAgUmVhZCAzMksgdGhlbiBiYWNrdHJhY2sgNjRLDQo+DQo+IGZpbyAtLWdyb3VwX3JlcG9y
dGluZz0xIC0tbmFtZT1yZXZlcnNlX3NlcSAtLWZpbGVuYW1lPS9kZXYvc2RiIA0KPiAtLWlvZGVw
dGg9MSAtLXJ3PXJlYWQ6LTY0SyAtLW9mZnNldD0xMDI0SyAtLXJ3bWl4d3JpdGU9MCAgLS1icz0z
MksgDQo+IC0tZGVzY3JpcHRpb249MzJLX1JldmVyc2VfU2VxIC0tcmFuZG9tX2dlbmVyYXRvcj10
YXVzd29ydGhlNjQgDQo+IC0tcmFuZHJlcGVhdD0xICAtLW51bWpvYnM9MSAtLWJhPTRLIC0taW9l
bmdpbmU9bGliYWlvICAtLWRpcmVjdD0xDQo+DQo+IExvb2tpbmcgYXQgdGhlIGJsb2NrIHRyYWNl
IGl0IGlzIGRlZmluaXRlbHkgZG9pbmcgYSByZXZlcnNlIHNlcXVlbnRpYWwgYnV0IGl0IGlzIHN0
YXJ0aW5nIGF0IHRoZSBMQVNUIExCQSBvZiB0aGUgZGV2aWNlIGFuZCB3b3JraW5nIGJhY2t3YXJk
cyB0byAwLg0KPiAgIDgsMTYgIDE3ICAgICAgICAxICAgICAwLjAwMDAwMDAwMCA1ODQ4MCAgUSAg
IFIgMjE3ODEzNjQyMjQgKyA2NCBbZmlvXQ0KPiAgIDgsMTYgIDE5ICAgICAgICAxICAgICAwLjAw
ODAyOTIxOSAgICAgMCAgQyAgIFIgMjE3ODEzNjQyMjQgKyA2NCBbMF0NCj4gICA4LDE2ICAxOSAg
ICAgICAgMiAgICAgMC4wMDgwNjI4MTUgNTg0ODAgIFEgICBSIDIxNzgxMzY0MTYwICsgNjQgW2Zp
b10NCj4gICA4LDE2ICAgMCAgICAgICAgMSAgICAgMC4wMDg1NTA5NDMgICAgIDAgIEMgICBSIDIx
NzgxMzY0MTYwICsgNjQgWzBdDQo+ICAgOCwxNiAgIDAgICAgICAgIDIgICAgIDAuMDA4NTk5NzA3
IDU4NDgwICBRICAgUiAyMTc4MTM2NDA5NiArIDY0IFtmaW9dDQo+DQo+IFVuZm9ydHVuYXRlbHkg
aXQgZG9lc24ndCBsb29rIGxpa2UgLS1vZmZzZXQgaXMgZG9pbmcgd2hhdCBJIHdhbnRlZC4gTG9v
a2luZyBhdCB0aGUgbWFuIHBhZ2UgIC0tb2Zmc2V0IHdpbGwgbm90IHdvcmsgaW4gdGhpcyBpbnN0
YW5jZSAiRGF0YSBiZWZvcmUgdGhlIGdpdmVuIG9mZnNldCB3aWxsIG5vdCBiZSB0b3VjaGVkLiIN
Cj4NCj4gU2luY2UgdGhlcmUgaXMgYSBkaWZmZXJlbmNlIG9uIFNlcXVlbnRpYWwgKGFuZCBSZXZl
cnNlIFNlcXVlbnRpYWwpIFBlcmZvcm1hbmNlIGZvciBIRERzIGRlcGVuZGluZyBvbiBpZiB5b3Ug
YXJlIHdvcmtpbmcgb24gdGhlIElEIG9yIE9EIEkgbmVlZCB0byBnaXZlIGFuIG9mZnNldCB0byB0
aGUgam9iIGFuZCB0aGVuIGhhdmUgaXQgd29yayBiYWNrd2FyZHMgZnJvbSB0aGF0IG9mZnNldCB0
byAwIHJhdGhlciB0aGFuIHdvcmsgYmFjayBmcm9tIE1heCBMQkEgdG8gMC4NCj4NCj4gSXMgdGhl
cmUgYSB3YXkgdG8gZG8gdGhpcyBvciBhZGQgdGhpcyBmdW5jdGlvbmFsaXR5Pw0KDQpJdCBzb3Vu
ZHMgbGlrZSB3aGF0IHlvdSB3YW50IGlzIHRvIGNvbnRyb2wgdGhlIGVuZCByYW5nZS9hcmVhIGZp
byBpcyB3b3JraW5nIGluLi4uIFNpbmNlIGZpbyB3b3JrcyBpbiB0ZXJtcyBvZiBieXRlcyByYXRo
ZXIgdGhhbiBMQkFzIGhhdmUgeW91IGxvb2tlZCBpbnRvIHVzaW5nIHNpemUNCihodHRwczovL2Zp
by5yZWFkdGhlZG9jcy5pby9lbi9sYXRlc3QvZmlvX2RvYy5odG1sI2NtZG9wdGlvbi1hcmctc2l6
ZSkNCndoaWNoIEkgdGhpbmsgaXMgbWVudGlvbmVkIGluIHRoZSBmaW8gbWFuIHBhZ2UgZG9jdW1l
bnRhdGlvbiBmb3Igb2Zmc2V0IChodHRwczovL2Zpby5yZWFkdGhlZG9jcy5pby9lbi9sYXRlc3Qv
ZmlvX2RvYy5odG1sI2NtZG9wdGlvbi1hcmctb2Zmc2V0DQopPw0KDQotLQ0KU2l0c29mZSB8IGh0
dHA6Ly9zdWNzLm9yZy9+c2l0cy8NCg==

