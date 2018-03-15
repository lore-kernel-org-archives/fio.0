Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20587 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbeCOVBQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Mar 2018 17:01:16 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: ZBC/FLEX FIO addition ideas
Date: Thu, 15 Mar 2018 21:01:13 +0000
Message-ID: <1521147672.2834.37.camel@wdc.com>
References: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
         <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
         <CALjAwxgn-yxPf5noENrdbhPKS7T3BVsArSa8wG50e0r88DPr-A@mail.gmail.com>
         <1521132231.2834.4.camel@wdc.com>
         <CAODBMznzVriS6kL5aFddKZBfdLfBLYOk=Chfas4+Xn6LjOxveQ@mail.gmail.com>
         <1521139102.2834.26.camel@wdc.com>
         <CAODBMzk6+f0Hjn-uuzz6rmS0idH1oSD21D8rd21rd9Qhqv+-VQ@mail.gmail.com>
In-Reply-To: <CAODBMzk6+f0Hjn-uuzz6rmS0idH1oSD21D8rd21rd9Qhqv+-VQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC0A98394CFC1344A920F45B998012E9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>
Cc: "sitsofe@gmail.com" <sitsofe@gmail.com>, Kris Davis <Kris.Davis@wdc.com>, Jason Jorgensen <jason.jorgensen@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>

T24gVGh1LCAyMDE4LTAzLTE1IGF0IDEzOjQwIC0wNjAwLCBQaGlsbGlwIENoZW4gd3JvdGU6DQo+
IEkgaGF2ZW4ndCB1c2VkIHRoZSBwcm9maWxlIGFyZ3VtZW50IGZvciBGSU8gYmVmb3JlLCBzbyB3
aGVuIEkgcmVhZA0KPiBwcm9maWxlIEkgdGhvdWdodCBpdCB3YXMgYmVpbmcgdXNlZCBhcyBhIHN5
bm9ueW0gSS9PIHByb2ZpbGUgb3INCj4gd29ya2xvYWQuIFNvIEkgdGhpbmsgeW91J3JlIHJpZ2h0
IHRoYXQgd2Ugc2hvdWxkbid0IGJlIGNyZWF0aW5nIGEgbmV3DQo+IHByb2ZpbGUgZm9yIFpCQyBi
dXQgcmF0aGVyIGZvY3VzaW5nIG9uIHRoZSBleGlzdGluZyBGSU8gZ2VuZXJhdGVkDQo+IHdvcmts
b2Fkcy4NCj4gV2hlbiBJIHdhcyB0YWxraW5nIGFib3V0IHZhbGlkIEkgbWVhbnQgdGhhdCBnZXRf
bmV4dF9ibG9jaygpIHdvdWxkDQo+IGdlbmVyYXRlIElPIHRoYXQgd291bGQgbm90IGNhdXNlIGVy
cm9ycyBvciByZWFkIGZpbGxlciBkYXRhIHBhc3QgdGhlDQo+IHdyaXRlIHBvaW50ZXIgcmF0aGVy
IHRoYW4gaGF2aW5nIHpiY19hZGp1c3RfYmxvY2soKSBtb2RpZnkgdGhlIElPDQo+IGFmdGVyd2Fy
ZHMuDQo+IFlvdSBtYWtlIGEgZ29vZCBwb2ludCB0aGF0IHRoZSB0d28gYXBwcm9hY2hlcyBjYW4g
ZWFzaWx5IGNvZXhpc3QuIElmDQo+IHlvdSBnZXQgeW91ciBjaGFuZ2VzIGFkZGVkIEkgd291bGQg
bGlrZSB0byB0cnkgYW5kIGJ1aWxkIHRoZQ0KPiBhZGRpdGlvbmFsIHdvcmtsb2FkcyBvbiB0b3Ag
b2YgeW91ciBleGlzdGluZyBjaGFuZ2VzIHNvIHRoYXQgSSBjYW4NCj4gbGV2ZXJhZ2UgeW91ciB3
cml0ZSBwb2ludGVyIHRyYWNraW5nIGNvZGUuDQoNCkhlbGxvIFBoaWxsaXAsDQoNClRoYXQgc291
bmRzIGxpa2UgYSBwbGFuIHRvIG1lIDotKSBDYW4geW91IGhhdmUgYSBsb29rIGF0IHRoZSBmb2xs
b3dpbmcgY29kZToNCmh0dHBzOi8vZ2l0aHViLmNvbS9idmFuYXNzY2hlL2Zpby90cmVlL3piYy4g
VGhlIHF1aWNrIGZpbyB0ZXN0cyBJIHJhbiB3aXRoDQp0aGlzIGNvZGUgd29yayBmaW5lIHdpdGgg
dGhlIFpCQyBhbmQgWkFDIGRpc2tzIEkgdHJpZWQuDQoNCkkgd2lsbCBzZW5kIHRoYXQgY29kZSB0
byBKZW5zIG9uY2UgdGhlIGZvbGxvd2luZyB0d28gcHVsbCByZXF1ZXN0cyBoYXZlIGJlZW4NCmFj
Y2VwdGVkOg0KKiAiSW1wcm92ZW1lbnRzIGZvciBhbmFseXppbmcgZmlvIHdpdGggVmFsZ3JpbmQi
DQogIChodHRwczovL2dpdGh1Yi5jb20vYXhib2UvZmlvL3B1bGwvNTYwKS4NCiogIkFkZCBhbiBh
c3ByaW50ZigpIGltcGxlbWVudGF0aW9uIiAoaHR0cHM6Ly9naXRodWIuY29tL2F4Ym9lL2Zpby9w
dWxsLzU2MSkuDQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQo=
