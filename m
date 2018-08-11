Return-Path: <fio-owner@vger.kernel.org>
Received: from aliyun-cloud.icoremail.net ([47.90.104.110]:52320 "HELO
        aliyun-sdnproxy-3.icoremail.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with SMTP id S1727182AbeHKLNh (ORCPT
        <rfc822;fio@vger.kernel.org>); Sat, 11 Aug 2018 07:13:37 -0400
Date: Sat, 11 Aug 2018 16:32:56 +0800 (GMT+08:00)
From: "Shaonan Ma" <msn18@mails.tsinghua.edu.cn>
Subject: How to use fio to test performance of a large amount of small
 files?
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <299b1737.698d.165281df382.Coremail.msn18@mails.tsinghua.edu.cn>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

SGksDQoNCkkgYW0gdXNpbmcgZmlvIHRvIHRlc3TCoHBlcmZvcm1hbmNlIG9mIGEgbGFyZ2UgYW1v
dW50IG9mIHNtYWxsIGZpbGVzLiBJIHVzZSByYmQgb2YgY2VwaCBhbmQgbWFwIHRoZSBpbWFnZSB0
byBhIGRldmljZSwgbW91bnQgdGhlIGRldmljZSBhbmQgd3JpdGUgYSBsb3Qgb2Ygc21hbGwgZmls
ZXMuDQoNCkkgd2FudCB0byBrbm93IHdoZXRoZXIgZmlvIGNhbiB0ZXN0IHBlcmZvcm1hbmNlIG9m
IHNtYWxsIGZpbGVzIHdlbGwuDQoNCkkgdXNlIHRoZSBlbmdpbmUgbGliYWlvLCBteSBjb25maWcg
aXM6DQoNCltnbG9iYWxdDQppb2VuZ2luZT1saWJhaW8NCmJ1ZmZlcmVkPTANCnJ3PXJhbmR3cml0
ZQ0KYnM9NGsNCnNpemU9MUcNCmlvX3NpemU9MUcNCmlvZGVwdGg9MjU2DQpmaWxlc2l6ZT00aw0K
bnJmaWxlcz0yNTYwMDANCltqb2IxXQ0KZGlyZWN0b3J5PXJiZG1hcC9yYmRtYXAwDQoNCkkgZG9u
J3Qga25vdyB3aGV0aGVyIG15IGNvbmZpZyBpcyBjb3JyZWN0LiBCZWNhdXNlIEkgaW5jcmVhc2Ug
dGhlIGZpbGVzaXplIGZyb20gNGsgdG8gMjU2aywgYW5kIG1vZGlmeSBzaXplIGFuZCBpb19zaXpl
LiBUaGUgcmVzdWx0IG9mIGJhbmR3aWR0aCBhbmQgaW9wcyBpcyBhcyBmb2xsb3dpbmc6DQoNCkkg
ZG9uJ3Qga25vdyB3aGV0aGVyIHRoZSBwZXJmb3JtYW5jZSBpcyBjb3JyZWN0LCBvciBmaW8gaXMg
bm90IHN1aXRhYmxlIGZvciBhIGxvdCBvZiBzbWFsbCBmaWxlcy4NCg0KVGhhbmtzLg0KDQotLQ0K
U2hhb25hbiBNYQ0KVHNpbmdodWEgVW5pdmVyc2l0eQ==

