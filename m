Return-Path: <fio-owner@vger.kernel.org>
Received: from esa7.dell-outbound.iphmx.com ([68.232.153.96]:32429 "EHLO
        esa7.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731065AbeHISBt (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 9 Aug 2018 14:01:49 -0400
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w79FMPw9075380
        for <fio@vger.kernel.org>; Thu, 9 Aug 2018 11:25:17 -0400
Received: from esa4.dell-outbound2.iphmx.com (esa4.dell-outbound2.iphmx.com [68.232.154.98])
        by mx0a-00154901.pphosted.com with ESMTP id 2krkv51kk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Thu, 09 Aug 2018 11:25:17 -0400
From: "Beierl, Mark" <Mark.Beierl@dell.com>
Subject: Re: How to fio benchmark on RAID device avoiding any caching
Date: Thu, 9 Aug 2018 15:25:01 +0000
Message-ID: <1708F6E2-0D25-4698-87BC-289925910E4D@emc.com>
References: <trinity-501fac2d-a584-4e9d-8dd4-a0ffdc09985f-1533824046447@3c-app-webde-bs25>
In-Reply-To: <trinity-501fac2d-a584-4e9d-8dd4-a0ffdc09985f-1533824046447@3c-app-webde-bs25>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <11BDA0245469814797E5BC939BC63519@mail.corp.emc.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "c.monty@web.de" <c.monty@web.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

SSBkb27igJl0IGtub3cgb2YgYW55IG1ldGhvZCB0byBoYXZlIGEgcHJvY2VzcyBvbiB0aGUgT1Mg
aXNzdWUgaW5zdHJ1Y3Rpb25zIHRoYXQgd291bGQgYnlwYXNzIHRoZSBSQUlEIGNvbnRyb2xsZXLi
gJlzIGNhY2hlLg0KDQpJIGhhdGUgdG8gc2F5IGl0LCBidXQgdGhlIG9ubHkgcmVhbGx5IGVmZmVj
dGl2ZSB3YXkgb2YgZW5zdXJpbmcgeW91IGFyZSBub3QgbWVhc3VyaW5nIHRoZSBjYWNoZSBpcyB0
byBlbnN1cmUgdGhhdCB5b3VyIHRlc3QgZmlsZSAob3IgZmlsZXMpIGFyZSBsYXJnZXIgKGxpa2Ug
NC01IHRpbWVzKSB0aGFuIHRoZSBhbW91bnQgb2YgbWVtb3J5IGluIHRoZSBSQUlEIGNvbnRyb2xs
ZXIuDQoNClJlZ2FyZHMsDQpNYXJrDQogDQpNYXJrIEJlaWVybA0KU1cgU3lzdGVtIFNyIFByaW5j
aXBhbCBEZXZlbG9wZXINCkRlbGwgRU1DIHwgQ2xvdWQgJiBDb21tdW5pY2F0aW9uIFNlcnZpY2Ug
UHJvdmlkZXIgU29sdXRpb24NCk1hcmsuQmVpZXJsQERlbGwuY29tDQoNCk9uIDIwMTgtMDgtMDks
IDEwOjE0LCAiZmlvLW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgYy5tb250eUB3
ZWIuZGUiIDxmaW8tb3duZXJAdmdlci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBjLm1vbnR5QHdl
Yi5kZT4gd3JvdGU6DQoNCiAgICBIaSwNCiAgICANCiAgICBjYW4geW91IHJlY29tbWVuZCBhIGZp
byBzZXR0aW5nIGZvciBiZW5jaG1hcmtpbmcgYSBSQUlEIGRldmljZSB0aGF0IGlzIGJ5cGFzc2lu
ZyBhbnkgY2FjaGluZyBlZmZlY3RzIGluIGNhc2UgUkFJRCBjb250cm9sbGVyIGhhcyBjYWNoZSBl
bmFibGVkPw0KICAgIA0KICAgIFRIWA0KICAgIC0tDQogICAgVG8gdW5zdWJzY3JpYmUgZnJvbSB0
aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGZpbyIgaW4NCiAgICB0aGUgYm9k
eSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0KICAgIE1vcmUgbWFq
b3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbWFqb3Jkb21vLWluZm8uaHRt
bA0KICAgIA0KDQo=
