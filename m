Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.dell-outbound.iphmx.com ([68.232.153.94]:21821 "EHLO
        esa3.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbeJZI0X (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 26 Oct 2018 04:26:23 -0400
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9PNmD0v122690
        for <fio@vger.kernel.org>; Thu, 25 Oct 2018 19:51:32 -0400
Received: from esa6.dell-outbound2.iphmx.com (esa6.dell-outbound2.iphmx.com [68.232.154.99])
        by mx0a-00154901.pphosted.com with ESMTP id 2nbpkwg8tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Thu, 25 Oct 2018 19:51:32 -0400
From: "Beierl, Mark" <Mark.Beierl@dell.com>
Received: from maildlpprd06.lss.emc.com (maildlpprd06.lss.emc.com [10.253.24.38])
        by mailuogwprd02.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id w9PNpUxw017718
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <fio@vger.kernel.org>; Thu, 25 Oct 2018 19:51:30 -0400
Received: from mailusrhubprd52.lss.emc.com (mailusrhubprd52.lss.emc.com [10.106.48.25]) by maildlpprd06.lss.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Thu, 25 Oct 2018 19:51:15 -0400
Received: from MXHUB305.corp.emc.com (MXHUB305.corp.emc.com [10.146.3.31])
        by mailusrhubprd52.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id w9PNpLXi004357
        (version=TLSv1.2 cipher=AES128-SHA256 bits=128 verify=FAIL)
        for <fio@vger.kernel.org>; Thu, 25 Oct 2018 19:51:22 -0400
Subject: Static linking and RDB/Rados
Date: Thu, 25 Oct 2018 23:51:21 +0000
Message-ID: <3AF0240C-DE31-4E79-AB21-31D04B863142@emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <87CC64C38180BE499FB61BD13179B5FB@mail.corp.emc.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

SeKAmXZlIGJlZW4gZG9pbmcgc29tZSBwbGF5aW5nIGFyb3VuZCB3aXRoIHN0YXRpYyBsaW5raW5n
IGFuZCBmcm9tIHRoZSBsb29rcyBvZiBpdCB0aGUgc3RhdGljIGxpYnJhcmllcyBmb3IgUmFkb3Mg
YW5kIFJEQiBhcmUgbm8gbG9uZ2VyIGF2YWlsYWJsZS4gIFNhbWUgZ29lcyBmb3Igc29tZSBvZiB0
aGUgbGlicmFyaWVzIG5lZWRlZCB0byBlbmFibGUgSFRUUCAoUzMpIHN1cHBvcnQuDQoNClNvLCBJ
IGRvbuKAmXQgdGhpbmsgdGhlIG9wdGlvbnMgZm9yIOKAk2J1aWxkLXN0YXRpYyBhcmUgdmFsaWQg
YW55bW9yZS4gIElmIGFueW9uZSBoYXMgcG9pbnRlcnMgYXMgdG8gaG93IHRvIGdldCB0aGUgc3Rh
dGljIFJhZG9zIG9yIFJEQiBsaWJyYXJpZXMsIEnigJlkIGxvdmUgdG8gaGVhciBhYm91dCBpdCA6
KQ0KDQpSZWdhcmRzLA0KTWFyaw0KIA0KTWFyayBCZWllcmwNClNXIFN5c3RlbSBTciBQcmluY2lw
YWwgRGV2ZWxvcGVyDQpEZWxsIEVNQyB8IENsb3VkICYgQ29tbXVuaWNhdGlvbiBTZXJ2aWNlIFBy
b3ZpZGVyIFNvbHV0aW9uDQpNYXJrLkJlaWVybEBEZWxsLmNvbQ0KDQo=

