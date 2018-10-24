Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.dell-outbound.iphmx.com ([68.232.149.214]:21745 "EHLO
        esa4.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726433AbeJYCn6 (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 24 Oct 2018 22:43:58 -0400
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9OID6mq014449
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 14:14:52 -0400
Received: from esa5.dell-outbound2.iphmx.com (esa5.dell-outbound2.iphmx.com [68.232.153.203])
        by mx0a-00154901.pphosted.com with ESMTP id 2n7xks7yps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 14:14:52 -0400
From: "Beierl, Mark" <Mark.Beierl@dell.com>
Received: from maildlpprd51.lss.emc.com (maildlpprd51.lss.emc.com [10.106.48.155])
        by mailuogwprd52.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id w9OIEo5p018398
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 14:14:50 -0400
Received: from mailusrhubprd03.lss.emc.com (mailusrhubprd03.lss.emc.com [10.253.24.21]) by maildlpprd51.lss.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Wed, 24 Oct 2018 14:14:25 -0400
Received: from MXHUB311.corp.emc.com (MXHUB311.corp.emc.com [10.146.3.89])
        by mailusrhubprd03.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id w9OIEVvv027444
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 14:14:33 -0400
Subject: Initial Data Write
Date: Wed, 24 Oct 2018 18:14:31 +0000
Message-ID: <F18878F1-E710-4BAC-AF00-C65A7BA90E7E@emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B9D9AEE76CF0E4FA2B6EA375F5D020B@mail.corp.emc.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

SGVsbG8sDQrCoA0KSSB0aGluayBJ4oCZbSBjb25mdXNpbmcgbXlzZWxmIGhlcmUuwqAgV2hlbiBJ
IGlzc3VlIHRoZSBmb2xsb3dpbmcgam9iOg0KwqANCsKgIGZpbyAtLXJ3PXJhbmR3cml0ZSAtLW5h
bWU9aW5pdGlhbGl6ZSAtLWRpcmVjdD0xIC0tc2l6ZT0xMG0gLS1icz00ayAtLWxvb3BzPTEgLS1p
b2RlcHRoPTEgLS1pb2VuZ2luZT1saWJhaW8NCsKgDQphbmQgdGhlbiBkbyBhIGhleGR1bXAgb2Yg
dGhlIG91dHB1dCBmaWxlLCBJIHNlZSBhIGxvdCBvZiBlbXB0eSAoMDAwMCkgZGF0YSBpbiB0aGUg
ZmlsZS7CoCBTaG91bGRu4oCZdCB0aGUgZnVsbCAxMG0gb2YgdGhlIGZpbGUgYmUgZmlsbGVkIHdp
dGggcmFuZG9tIGRhdGE/DQrCoA0KU2FtcGxlIG91dHB1dDoNCsKgDQrCoCBoZXhkdW1wIGluaXRp
YWxpemUuMC4wIHwgaGVhZA0KwqAgMDAwMDAwMCA1MDAwIDAwNGIgMDAwMCAwMDAwIDQwMDAgMDA5
MSAwMDAwIDAwMDANCsKgIDAwMDAwMTAgNjAwMCAwMDIyIDAwMDAgMDAwMCAyMDAwIDAwMzQgMDAw
MCAwMDAwDQrCoCAwMDAwMDIwIDIwMDAgMDA2MSAwMDAwIDAwMDAgMjAwMCAwMDZjIDAwMDAgMDAw
MA0KwqAgMDAwMDAzMCA3MDAwIDAwMTkgMDAwMCAwMDAwIDUwMDAgMDA0OSAwMDAwIDAwMDANCsKg
IDAwMDAwNDAgNDAwMCAwMDc5IDAwMDAgMDAwMCA3MDAwIDAwMmUgMDAwMCAwMDAwDQrCoCAwMDAw
MDUwIDkwMDAgMDA5ZCAwMDAwIDAwMDAgZDAwMCAwMDkwIDAwMDAgMDAwMA0KwqAgMDAwMDA2MCA0
MDAwIDAwMjggMDAwMCAwMDAwIGUwMDAgMDA5NSAwMDAwIDAwMDANCsKgIDAwMDAwNzAgMTAwMCAw
MDBjIDAwMDAgMDAwMCBiMDAwIDAwMDQgMDAwMCAwMDAwDQrCoCAwMDAwMDgwIGQwMDAgMDAwMCAw
MDAwIDAwMDAgZjAwMCAwMDA5IDAwMDAgMDAwMA0KwqAgMDAwMDA5MCBkMDAwIDAwNGYgMDAwMCAw
MDAwIDAwMDAgMDAxOCAwMDAwIDAwMDANCsKgDQpXaGF0IGFtIEkgbWlzc2luZz8NCsKgDQpmaW8g
dmVyaXNpb24gaXMgMi4yLjEwDQoNClJlZ2FyZHMsDQpNYXJrDQogDQpNYXJrIEJlaWVybA0KU1cg
U3lzdGVtIFNyIFByaW5jaXBhbCBEZXZlbG9wZXINCkRlbGwgRU1DIHwgQ2xvdWQgJiBDb21tdW5p
Y2F0aW9uIFNlcnZpY2UgUHJvdmlkZXIgU29sdXRpb24NCk1hcmsuQmVpZXJsQERlbGwuY29tDQoN
Cg==

