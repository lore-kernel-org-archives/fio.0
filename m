Return-Path: <fio-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:41924 "EHLO
        rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdECCoa (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 2 May 2017 22:44:30 -0400
Received: from XCH-RTP-016.cisco.com (xch-rtp-016.cisco.com [64.101.220.156])
        by alln-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id v432iSQ4004152
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Wed, 3 May 2017 02:44:29 GMT
From: "Scott Forman (scforman)" <scforman@cisco.com>
Subject: Writing buffers allocated by numa_alloc_onnode to files opened with
 O_DIRECT
Date: Wed, 3 May 2017 02:44:28 +0000
Message-ID: <E12F3002-0737-4C94-8E43-D2E4B449ED0A@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C89C8C20DFC4549BA713B54FFEC9650@emea.cisco.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

SGksDQoNCkkgYW0gd29uZGVyaW5nIGlmIHNvbWVvbmUgb24gdGhpcyBtYWlsaW5nIGxpc3Qgd291
bGQga25vdyBpZiB0aGUgbnVtYV9hbGxvY19vbm5vZGUoKSBmdW5jdGlvbiBwcm9wZXJseSBhbGln
bnMgbWVtb3J5IGJ1ZmZlcnMgc28gdGhhdCB0aGV5IGNhbiBiZSB3cml0dGVuIHRvIGEgZmlsZSBv
cGVuZWQgd2l0aCB0aGUgT19ESVJFQ1QgZmxhZy4NCg0KSSBoYXZlIHNlZW4gc29tZSBjb25mbGlj
dGluZyBpbmZvcm1hdGlvbiBvbiB0aGUgd2ViIGFib3V0IHRoaXMsIHNvIEkgd291bGQgYXBwcmVj
aWF0ZSBhbnkgaW5wdXQgeW91IG1pZ2h0IGhhdmUuDQoNClRoYW5rcyBtdWNoLA0KU2NvdHQNCg0K
