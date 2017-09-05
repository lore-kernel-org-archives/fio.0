Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13254 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752942AbdIEWvd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Sep 2017 18:51:33 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio patch question on filesetup: align layout buffer
Date: Tue, 5 Sep 2017 22:50:43 +0000
Message-ID: <BN3PR0401MB1457BF249ECA9EA33BFC859D8F960@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxikXWD2WTE5d6+8U3=AQz+G7Wq1+FwBxdrHXeRK1+oDsA@mail.gmail.com>
 <BN3PR0401MB1457E83E1425DFC38C6151048F960@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxi2dZQemhi67nnsgtJOH9-Vdy=Qo08tgrQ+cw92onNJag@mail.gmail.com>
In-Reply-To: <CALjAwxi2dZQemhi67nnsgtJOH9-Vdy=Qo08tgrQ+cw92onNJag@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

SSBoYXZlbid0IHRyYWNlZCBkb3duIHRoZSBlbnRpcmUgZmxvdyBmb3IgbWVtX2FsaWduLCBzbyBw
ZXJoYXBzIEkgc2hvdWxkIGludmVzdGlnYXRlIG1vcmUuICBNeSBjb25jZXJuIHdhcyB3aGVuIHRo
ZSB1c2VyIHNldHMgbWVtX2FsaWduIHRvIHNvbWV0aGluZyBvdGhlciB0aGFuIHRoZSBzeXN0ZW0n
cyBwYWdlIHNpemUgb3IgdGhlIHVzZXIncyBibG9jayBzaXplLg0KDQpSZWdhcmRzLA0KSmVmZg0K
DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogU2l0c29mZSBXaGVlbGVyIFttYWls
dG86c2l0c29mZUBnbWFpbC5jb21dIA0KU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDUsIDIwMTcg
MTI6MDIgUE0NClRvOiBKZWZmIEZ1cmxvbmcgPGplZmYuZnVybG9uZ0B3ZGMuY29tPg0KQ2M6IGZp
b0B2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBmaW8gcGF0Y2ggcXVlc3Rpb24gb24gZmls
ZXNldHVwOiBhbGlnbiBsYXlvdXQgYnVmZmVyDQoNCk9uIDUgU2VwdGVtYmVyIDIwMTcgYXQgMTk6
NTcsIEplZmYgRnVybG9uZyA8amVmZi5mdXJsb25nQHdkYy5jb20+IHdyb3RlOg0KPiBSaWdodC4g
IEEgY2hlY2sgb2YgbWVtYWxpZ24gb3IgcGFnZSBzaXplIGNhbiBoZWxwLiAgQnV0IHRoZSBwYXRj
aCBpcyBubyBsb25nZXIgY29tcGF0aWJsZSB3aXRoIHRoZSBsYXRlc3QgZ2l0LCBnaXZlbiB0aGUg
cmVjZW50IHJldmVydC4gIEhvd2V2ZXIsIG15IGNvbmNlcm4gZm9yIG1lbV9hbGlnbiBzdGlsbCBy
ZW1haW5zLiAgSG93IGRvZXMgdGhlIGN1cnJlbnQgZ2l0IHVzZSB0aGUgbWVtX2FsaWduIHBhcmFt
ZXRlciBpbiBmaWxsX2lvX2J1ZmZlcih0ZCwgYiwgYnMsIGJzKT8gIE9yIGlzIGl0IGNvbXBsZXRs
ZXkgaGFuZGxlZCBlbHNld2hlcmUsIG5hbWVseSBpbml0X2lvX3UoKSBhbmQgYWxsb2NhdGVfaW9f
bWVtKCk/DQoNCldoZW4gdGhlIEkvTyBpcyBub3JtYWwgYW5kIHVuY2FjaGVkIHdvbid0IGl0IGFs
bCBiZSB0YWtlbiBjYXJlIG9mIGluIHRoZSBrZXJuZWw/DQoNCi0tIA0KU2l0c29mZSB8IGh0dHA6
Ly9zdWNzLm9yZy9+c2l0cy8NCg==
