Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130DDC433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 17:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAE061158
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 17:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350166AbhIHRN6 convert rfc822-to-8bit (ORCPT
        <rfc822;fio@archiver.kernel.org>); Wed, 8 Sep 2021 13:13:58 -0400
Received: from smtp.digdes.com ([85.114.5.13]:36697 "EHLO smtp.digdes.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhIHRN6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 13:13:58 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Sep 2021 13:13:57 EDT
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 8 Sep
 2021 20:07:27 +0300
Received: from DDSM-MAIL02.digdes.com (172.16.100.74) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 8 Sep 2021 20:07:27 +0300
Received: from DDSM-MAIL02.digdes.com ([fe80::3088:3004:df3c:83c4]) by
 ddsm-mail02.digdes.com ([fe80::3088:3004:df3c:83c4%8]) with mapi id
 15.01.2176.009; Wed, 8 Sep 2021 20:07:27 +0300
From:   Abrakhin Andrey <Abrakhin.A@raidix.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Feature request: iteration counter in `verify_pattern`
Thread-Topic: Feature request: iteration counter in `verify_pattern`
Thread-Index: AQHXpM+QZfh3I58ScUS9KEplYeYEgA==
Date:   Wed, 8 Sep 2021 17:07:27 +0000
Message-ID: <55447f96a32f4fc69332a0cc8e29f749@raidix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.100.54]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello,

I am testing block device corruption with fio, and i believe fio lacks a certain helpful feature.

This is the config i am using:

```
[global]
ioengine=libaio
direct=1
group_reporting
exitall

bs=8k
rw=write
iodepth=64
size=671088640
numjobs=1

verify=pattern
loops=1000
verify_dump=1
verify_fatal=1
filename=/dev/sdad

[job0x0]
verify_pattern=0x0102030405060708090a0b0c0d0e0f210908163826%o
offset=0

[job0x1]
verify_pattern=0x1112131415161718191a1b1c1d1e1f210908163826%o
offset=671088640

[job0x2]
verify_pattern=0x2122232425262728292a2b2c2d2e2f210908163826%o
offset=1342177280

[job0x3]
verify_pattern=0x3132333435363738393a3b3c3d3e3f210908163826%o
offset=2013265920

[job0x4]
verify_pattern=0x4142434445464748494a4b4c4d4e4f210908163826%o
offset=2684354560

[job0x5]
verify_pattern=0x5152535455565758595a5b5c5d5e5f210908163826%o
offset=3355443200

[job0x6]
verify_pattern=0x6162636465666768696a6b6c6d6e6f210908163826%o
offset=4026531840

[job0x7]
verify_pattern=0x7172737475767778797a7b7c7d7e7f210908163826%o
offset=4697620480

[job0x8]
verify_pattern=0x8182838485868788898a8b8c8d8e8f210908163826%o
offset=5368709120

[job0x9]
verify_pattern=0x9192939495969798999a9b9c9d9e9f210908163826%o
offset=6039797760

[job0xa]
verify_pattern=0xa1a2a3a4a5a6a7a8a9aaabacadaeaf210908163826%o
offset=6710886400

[job0xb]
verify_pattern=0xb1b2b3b4b5b6b7b8b9babbbcbdbebf210908163826%o
offset=7381975040

[job0xc]
verify_pattern=0xc1c2c3c4c5c6c7c8c9cacbcccdcecf210908163826%o
offset=8053063680

[job0xd]
verify_pattern=0xd1d2d3d4d5d6d7d8d9dadbdcdddedf210908163826%o
offset=8724152320

[job0xe]
verify_pattern=0xe1e2e3e4e5e6e7e8e9eaebecedeeef210908163826%o
offset=9395240960

[job0xf]
verify_pattern=0xf1f2f3f4f5f6f7f8f9fafbfcfdfeff210908163826%o
offset=10066329600
```

By changing the timestamp in verify_pattern i can tell if the .received block i
get is left over from the last run or is a newly written one.

Unfortunately, i have to use the `loops` option to have a better chance of
getting corruption in a single run. This leaves an ambiguity in the results i
get: i am not able to tell if a corruption has arisen from the driver
accidentally duplicating a write request, misplacing it or loosing it
completely.

I would like to be able to add e.g. a `%i` format option that would update with
each iteration, i.e. one of the patterns above would be rewritten as

verify_pattern=0x0102030405060708090a0b0c0d0e0f210908163826%o%i

and would expand to

0x0102030405060708090a0b0c0d0e0f210908163826 0020130000000000 0000000000000000

on the very first (0th) iteration of the loop, and would expand to

0x0102030405060708090a0b0c0d0e0f210908163826 0020130000000000 0f27000000000000

on the very last (9999th, i.e 0x270Fth) iteration of the loop (assuming pattern
for the block #153 of size 8k, i.e. offset of 1253376 bytes), whitespace
inserted for clarity.

This feature would give very valuable insight into the verification fail i am
investigating.

Thank you,
Abrakhin Andrei
