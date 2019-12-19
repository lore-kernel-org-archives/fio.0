Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:42002 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfLSReY (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 19 Dec 2019 12:34:24 -0500
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJGAnkh019247
        for <fio@vger.kernel.org>; Thu, 19 Dec 2019 12:34:23 -0500
Received: from mx0b-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 2wyc60h5jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 19 Dec 2019 12:34:22 -0500
Received: from pps.filterd (m0090350.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJGDFsX001937
        for <fio@vger.kernel.org>; Thu, 19 Dec 2019 12:34:21 -0500
Received: from ausxippc101.us.dell.com (ausxippc101.us.dell.com [143.166.85.207])
        by mx0b-00154901.pphosted.com with ESMTP id 2wyquumhy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Thu, 19 Dec 2019 12:34:21 -0500
From: <Charles.Colburn@dell.com>
Subject: RE: Running FIO until DUT leaves steadystate
Date: Thu, 19 Dec 2019 17:34:18 +0000
Message-ID: <06dee952d2214867863d4423127553b8@AUSX13MPS306.AMER.DELL.COM>
References: <CANbyPNfpV0dazkiyviWs1yZtnGkjC-3zYBZt6QCr2wGgnGv1jw@mail.gmail.com>
 <CALjAwxjuA71m-FdOb=gpFDt8mrgedgcgEikB62gUjv0M248nrA@mail.gmail.com>
In-Reply-To: <CALjAwxjuA71m-FdOb=gpFDt8mrgedgcgEikB62gUjv0M248nrA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sitsofe@gmail.com, mike.kingsbury@cacheio.com
Cc: fio@vger.kernel.org

U2l0c29mZQ0KDQpJcyB0aGVyZSBhbiBleGFtcGxlIG9mIHVzaW5nIHRoZSBzdGVhZHlzdGF0ZSBv
cHRpb24gdG8gZG8gcmFuZG9tIHByZWNvbmRpdGlvbmluZyBvZiBhbmQgU1NEPyAtIEkgYXNzdW1l
IHRoYXQgaXMgd2hhdCBpdCBpcyBmb3IuIEkgdHJpZWQgdG8gdXNlIHRoZSBmZWF0dXJlZCBhIHdo
aWxlIGJhY2sgYnV0IG5ldmVyIGdvdCBpdCB0byB3b3JrIGFzIGV4cGVjdGVkLg0KDQpDaHVjayBD
b2xidXJuDQoNCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogZmlvLW93bmVy
QHZnZXIua2VybmVsLm9yZyA8ZmlvLW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24gQmVoYWxmIE9m
IFNpdHNvZmUgV2hlZWxlcg0KU2VudDogVGh1cnNkYXksIERlY2VtYmVyIDE5LCAyMDE5IDE6MTEg
QU0NClRvOiBNaWtlIEtpbmdzYnVyeQ0KQ2M6IGZpbw0KU3ViamVjdDogUmU6IFJ1bm5pbmcgRklP
IHVudGlsIERVVCBsZWF2ZXMgc3RlYWR5c3RhdGUNCg0KDQpbRVhURVJOQUwgRU1BSUxdIA0KDQpI
aSwNCg0KT24gRnJpLCAxMyBEZWMgMjAxOSBhdCAxNjoyOSwgTWlrZSBLaW5nc2J1cnkgPG1pa2Uu
a2luZ3NidXJ5QGNhY2hlaW8uY29tPiB3cm90ZToNCj4NCj4gUmVhZGluZyB0aHJvdWdoIHRoZSBk
b2NzIGFuZCBsb29rZWQgYXQgc29tZSBleGFtcGxlcywgaXRzIG5vdCBjbGVhciBpZiANCj4gaXRz
IHBvc3NpYmxlIHRvIGFjY29tcGxpc2ggdGhpcy4gSW4gb3VyIGNhc2UsIHdlJ3JlIGF0dGVtcHRp
bmcgdG8gDQo+IGV2YWx1YXRlIFNTRHMgYW5kIGRldGVybWluZSB3aGVuIHRoZXkgc3RhcnQgaW50
ZXJuYWwgZ2FyYmFnZSANCj4gY29sbGVjdGlvbiBhbmQgaG93IG11Y2ggcGVyZm9ybWFuY2UgZHJv
cHMuICBJcyB0aGVyZSBhIHdheSB0byBkZXRlY3QgDQo+IHN0ZWFkeXN0YXRlLCBhbmQgdGhlbiBl
eGl0IHdoZW4gdGhlIERVVCBwZXJmb3JtYW5jZSBsZWF2ZXMgdGhhdCANCj4gc3RlYWR5c3RhdGU/
DQoNCk5vdCByZWFsbHkuIFlvdSBjYW4gdXNlIHRoZSBzdGVhZHlzdGF0ZSBvcHRpb24gKGh0dHBz
Oi8vZmlvLnJlYWR0aGVkb2NzLmlvL2VuL2xhdGVzdC9maW9fZG9jLmh0bWwjY21kb3B0aW9uLWFy
Zy1zdGVhZHlzdGF0ZQ0KKSB0byB0cnkgYW5kIGRldGVybWluZSB3aGVuIHlvdSdyZSBpbiB0aGUg
c3RlYWR5c3RhdGUgYnV0IHRoZW4geW91J3JlIGtpbmQgb2Ygc3R1Y2suIE1heWJlIG9uY2UgeW91
IGtuZXcgd2hhdCBleHBlY3RlZCBsYXRlbmNpZXMgd2VyZSwgeW91IGNvdWxkIHRoZW4gdXNlIG1h
eF9sYXRlbmN5IChodHRwczovL2Zpby5yZWFkdGhlZG9jcy5pby9lbi9sYXRlc3QvZmlvX2RvYy5o
dG1sI2NtZG9wdGlvbi1hcmctbWF4LWxhdGVuY3kNCikgdG8gYWxsb3cgYSBqb2IgdG8gZXhpdCBp
ZiBvbmUgZ290IG9idmlvdXNseSB0b28gaGlnaD8gWW91IHdvdWxkIGhhdmUgdG8gZG8gYSBmYWly
IGJpdCBvZiBpbnRlcm1lZGlhdGUgc3RvcmFnZSBhbmQgcHJvY2Vzc2luZyB0byBtYWtlIHRoaXMg
d29yayBhbmQgaXQncyBub3QgY2xlYXIgaG93IHJlbGlhYmxlIGl0IHdvdWxkIGJlIHRob3VnaC4u
Lg0KDQotLQ0KU2l0c29mZSB8IGh0dHA6Ly9zdWNzLm9yZy9+c2l0cy8NCg==

