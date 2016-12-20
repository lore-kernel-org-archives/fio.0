Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-dm3nam03on0113.outbound.protection.outlook.com ([104.47.41.113]:22854
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934254AbcLTRDP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 12:03:15 -0500
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v2] fio: add device dax engine
Date: Tue, 20 Dec 2016 16:30:17 +0000
Message-ID: <DF4PR84MB016903FA84DE6978FFF39083AB900@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dave Jiang <dave.jiang@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGZpby1vd25lckB2Z2VyLmtl
cm5lbC5vcmcgW21haWx0bzpmaW8tb3duZXJAdmdlci5rZXJuZWwub3JnXSBPbg0KPiBCZWhhbGYg
T2YgRGF2ZSBKaWFuZw0KPiBTdWJqZWN0OiBbUEFUQ0ggdjJdIGZpbzogYWRkIGRldmljZSBkYXgg
ZW5naW5lDQo+IA0KPiBkaWZmIC0tZ2l0IGEvY29uZmlndXJlIGIvY29uZmlndXJlDQouLi4NCj4g
QEAgLTEzNiw2ICsxMzYsNyBAQCBleGl0X3ZhbD0wDQo+ICBnZmlvX2NoZWNrPSJubyINCj4gIGxp
YmhkZnM9Im5vIg0KPiAgcG1lbWJsaz0ibm8iDQo+ICtkZXZkYXg9Im5vIg0KPiAgZGlzYWJsZV9s
ZXg9IiINCj4gIHByZWZpeD0vdXNyL2xvY2FsDQo+IA0KPiBAQCAtMTc0LDYgKzE3NSw4IEBAIGZv
ciBvcHQgZG8NCj4gICAgOzsNCj4gICAgLS1lbmFibGUtcG1lbWJsaykgcG1lbWJsaz0ieWVzIg0K
PiAgICA7Ow0KPiArICAtLWVuYWJsZS1kZXZkYXgpIGRldmRheD0ieWVzIg0KPiArICA7Ow0KPiAg
ICAtLWRpc2FibGUtbGV4KSBkaXNhYmxlX2xleD0ieWVzIg0KPiAgICA7Ow0KPiAgICAtLWVuYWJs
ZS1sZXgpIGRpc2FibGVfbGV4PSJubyINCj4gQEAgLTIwNSw2ICsyMDgsNyBAQCBpZiB0ZXN0ICIk
c2hvd19oZWxwIiA9ICJ5ZXMiIDsgdGhlbg0KPiAgICBlY2hvICItLWRpc2FibGUtZ2ZhcGkgICAg
ICAgIERpc2FibGUgZ2ZhcGkiDQo+ICAgIGVjaG8gIi0tZW5hYmxlLWxpYmhkZnMgICAgICAgRW5h
YmxlIGhkZnMgc3VwcG9ydCINCj4gICAgZWNobyAiLS1lbmFibGUtcG1lbWJsayAgICAgICBFbmFi
bGUgTlZNTCBsaWJwbWVtYmxrIHN1cHBvcnQiDQo+ICsgIGVjaG8gIi0tZW5hYmxlLWRldmRheCAg
ICAgICAgRW5hYmxlIE5WTSBEZXZpY2UgRGF4IHN1cHBvcnQiDQo+ICAgIGVjaG8gIi0tZGlzYWJs
ZS1sZXggICAgICAgICAgRGlzYWJsZSB1c2Ugb2YgbGV4L3lhY2MgZm9yIG1hdGgiDQo+ICAgIGVj
aG8gIi0tZW5hYmxlLWxleCAgICAgICAgICAgRW5hYmxlIHVzZSBvZiBsZXgveWFjYyBmb3IgbWF0
aCINCj4gICAgZWNobyAiLS1kaXNhYmxlLXNobSAgICAgICAgICBEaXNhYmxlIFNITSBzdXBwb3J0
Ig0KDQpJIGRpZG4ndCBub3RpY2UgdGhhdCBwbWVtYmxrIHdhcyBub3QgYXV0b21hdGljYWxseSBk
ZXRlY3RlZCwgYW5kIGRldmRheA0KaXMgdXNpbmcgdGhlIHNhbWUgYXBwcm9hY2guICBDb3VsZCB0
aGV5IGJvdGggYXV0b21hdGljYWxseSBiZSBpbnN0YWxsZWQNCmlmIE5WTUwgaXMgZGV0ZWN0ZWQg
b24gdGhlIGJ1aWxkIHN5c3RlbSBtYWNoaW5lICh3aXRoIGEgLS1kaXNhYmxlLWxpYm51bWENCmFy
Z3VtZW50IHRvIG92ZXJyaWRlIGlmIG5lZWRlZCk/DQoNCkFsc28sICJOVk0iIHNob3VsZCBiZSAi
TlZNTCIgaW4gdGhhdCBoZWxwIG1lc3NhZ2UuDQoNCg0KDQo=
