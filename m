Return-Path: <fio-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:56081 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdDBWLs (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 2 Apr 2017 18:11:48 -0400
From: "Scott Forman (scforman)" <scforman@cisco.com>
Subject: fio seems to calls functions which are not defined (ffio_file_open,
 io_file_done, ...)
Date: Sun, 2 Apr 2017 22:11:46 +0000
Message-ID: <6929A3FC-5D4B-4121-BC36-5E83B563CCC7@cisco.com>
References: <CA74E5D5-1CEF-4605-BE90-809B55465C79@cisco.com>
In-Reply-To: <CA74E5D5-1CEF-4605-BE90-809B55465C79@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DADD0BF60075648AF2C456FEAB4A77A@emea.cisco.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "andrey.v.kuzmin@gmail.com" <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

SGkgQW5kcmV5LA0KwqANClRoYW5rcyBmb3IgeW91ciBhbnN3ZXIgdG8gdGhlIHF1ZXN0aW9uIGJl
bG93Lg0KwqANCkkgaGF2ZSBhbm90aGVyIGhvcGVmdWxseSBxdWljayBxdWVzdGlvbiBmb3IgeW91
Lg0KwqANCkkgc2VlIHRoZXJlIGFyZSBhIG51bWJlciBvZiBmdW5jdGlvbnMgdGhhdCBhcmUgY2Fs
bGVkLCBidXQgSSBjYW5ub3QgZmluZCB3aGVyZSB0aGV5IGFyZSBkZWZpbmVkLsKgIFNvbWUgb2Yg
dGhlIGZ1bmN0aW9ucyBhcmU6DQrCt8KgwqDCoMKgwqDCoMKgwqDCoGZpb19maWxlX29wZW4NCsK3
wqDCoMKgwqDCoMKgwqDCoMKgZmlvX2ZpbGVfZG9uZQ0KwrfCoMKgwqDCoMKgwqDCoMKgwqBmaW9f
ZmlsZV9jbG9zaW5nDQrCt8KgwqDCoMKgwqDCoMKgwqDCoGZpb19maWxlX2F4bWFwDQrCoA0KQ2Fu
IHlvdSBwb2ludCBtZSB0byB3aGVyZSB0aGVzZSBmdW5jdGlvbnMgYXJlIGRlZmluZWQ/DQrCoA0K
VGhhbmtzIG11Y2gsDQpTY290dA0KDQoNCg==
