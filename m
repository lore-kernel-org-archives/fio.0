Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E12C433EF
	for <fio@archiver.kernel.org>; Fri, 28 Jan 2022 21:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351613AbiA1Vqw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jan 2022 16:46:52 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:63718 "EHLO
        mailout2.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351614AbiA1Vqv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jan 2022 16:46:51 -0500
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220128214649usoutp0201811f189e05d643c99638e0c5c4e53c~OjWwTnOIh0322703227usoutp02Z;
        Fri, 28 Jan 2022 21:46:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220128214649usoutp0201811f189e05d643c99638e0c5c4e53c~OjWwTnOIh0322703227usoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1643406409;
        bh=/QljMQB8Kb0FKFFInuYfc1sfKg5+ou9SfodjUkZF0xw=;
        h=From:To:CC:Subject:Date:References:From;
        b=G/pfkl5O5jy/6ZkXW7y37n45Xo904qZHP+RT1DNz2RgCiR4wHPKQjrIO6njAYOzIQ
         NttgwGc4psElC93qEu2K/UfyG7E8qX9YKlhzkaPb5VK5+fjnWm3nkwXnZQbPMaS+2i
         J9q4qyhg4wG5O1Zq+cypQX24FBr+QAVvbIq0UgbM=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220128214649uscas1p273a1466f1e55a80ec4e2e18ec143ba7a~OjWwNtJBO0898808988uscas1p2K;
        Fri, 28 Jan 2022 21:46:49 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 35.B2.10104.84464F16; Fri,
        28 Jan 2022 16:46:48 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220128214648uscas1p1093b2602603486134890a51b38270e45~OjWv3a2s52136821368uscas1p18;
        Fri, 28 Jan 2022 21:46:48 +0000 (GMT)
X-AuditID: cbfec36f-2fdff70000002778-4d-61f464484312
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 9E.44.09671.84464F16; Fri,
        28 Jan 2022 16:46:48 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 28 Jan 2022 13:46:37 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Fri, 28 Jan 2022 13:46:37 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>,
        Professor Pro <annivation@gmail.com>
Subject: [PATCH] Makefile: build t/fio-dedupe only if zlib support is found
Thread-Topic: [PATCH] Makefile: build t/fio-dedupe only if zlib support is
        found
Thread-Index: AQHYFJCGvAx5BsXvc0mjzoPd9hynng==
Date:   Fri, 28 Jan 2022 21:46:37 +0000
Message-ID: <20220128214611.165312-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42LZduzreV2PlC+JBu+P2Fis+nqf1WL13X42
        i4+zXjA7MHvsnHWX3ePy2VKPz5vkApijuGxSUnMyy1KL9O0SuDJ2rrrCUvCPs+LmhB1MDYyH
        OLoYOTkkBEwkzm7ax9bFyMUhJLCSUWL+ku9QTiuTxOHly4AcDrCqtS+sIeJrGSWWLdjJCOF8
        ZJS49WgjVMcBRomPc1azgHSwCWhKvN1fALJCRCBM4uej7awgNrOAv8S3f7uZQWxhAW+JL4+f
        M0PUBEkcnXaREcLWkzi1eREbiM0ioCpxdNN5MJtXwEZiRtNsJhCbUUBM4vupNUwQM8Ulbj2Z
        zwTxjqDEotl7mCFsMYl/ux6yQdiKEve/v2SHsEUk1n1/ywbRqydxY+oUKFtbYtnC18wQuwQl
        Ts58wgJRLylxcMUNFpAfJQQ6OSROvZ0OtcxFYvfW91BF0hJXr09lhiiazCjxddt9NghnNaPE
        ywWXGCGqrCUW/lkPdTafxN9fjxgnMCrPQvLFLCRXzUJy1SwkVy1gZFnFKF5aXJybnlpslJda
        rlecmFtcmpeul5yfu4kRmExO/zucv4Px+q2PeocYmTgYDzFKcDArifDO2PQpUYg3JbGyKrUo
        P76oNCe1+BCjNAeLkjjvsswNiUIC6YklqdmpqQWpRTBZJg5OqQam1YbCywJEvvzaumj7RTPn
        bq+2irk39vazZzBO//XFKZ0ndteLafJL6kor3/L8zPxY6961cMG+v0v+Vl92Unu8SUD0/Prt
        WxkXtsl86JltGtYlxXN4+d1++wWcefMXfVqy9KiElqXCliYfdd+n99JcRNW7t3xa/15ksqbQ
        Rk7nd+fzb2h9YWmX9PROlT7QcNhc/+RPgUy7b/9tn/Orl6WwrgxYaVVfnZHOJXIxam+jmqe6
        fpBT7JWfM+eldiiyW3XWOjlHJnkeu1K9ekHM5lVukmUv/xnaMQds2iH00nHOFzs3s3CZm3rr
        tT68+cfp45299OrlSf6VYUsZlufPiDH0ie/uX3DA1CU2VftoygslluKMREMt5qLiRADRYeg8
        lQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LJbGCapOuR8iXR4H2jksWqr/dZLVbf7Wez
        +DjrBbMDs8fOWXfZPS6fLfX4vEkugDmKyyYlNSezLLVI3y6BK2PnqissBf84K25O2MHUwHiI
        o4uRg0NCwERi7QvrLkYuDiGB1YwSNw82M0I4HxklXnxsYYVwDjBKzL3WxQzSwSagKfF2f0EX
        IyeHiECYxM9H21lBbGYBX4nX208ygdjCAt4SXx4/Z4aoCZJo2/mVCcLWkzi1eREbiM0ioCpx
        dNN5MJtXwEZiRtNssBpGATGJ76fWMEHMFJe49WQ+mC0hICCxZM95ZghbVOLl43+sELaixP3v
        L9khbBGJdd/fskH06kncmDoFytaWWLbwNTPELkGJkzOfsEDUS0ocXHGDZQKj2Cwk62YhaZ+F
        pH0WkvYFjCyrGMVLi4tz0yuKDfNSy/WKE3OLS/PS9ZLzczcxAmPq9L/DkTsYj976qHeIkYmD
        8RCjBAezkgjvjE2fEoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzCrlOjBcSSE8sSc1OTS1ILYLJ
        MnFwSjUwTb3qbxa4sMBfOyfq5rqQadvyShJLGvymLOFn/DxnvefeyLkW+/tq2xRDH39abMNn
        PddpUYX4Go0rmlujPEzXdvR93fFsu3N4eJBn9PuUuQznixu7lj6Z7l+08P+uL6/i4me+/f7+
        U5zN2lilGE9Dz9m3dZ1NLjw4KO/PtS/v2Ne93zyerjnaPPvrBs/Lzn6hdzS8zbw++81YdNmQ
        KVuqQ6N9lcv0xdy1dgx9npzJeqmBq0vfJzq13Ko3v/L0x8rdV4ULtc4cWfv+7ZYL/6KYPfg8
        u/UP36xgO7fSOHWVVs/7jljbD/+8gu5Zv7b59z/wwUWrhZ8c3Gz/2nU8zMru/v8tYcNlvv3/
        99QeEHV1V2Ipzkg01GIuKk4EAKPUQI8YAwAA
X-CMS-MailID: 20220128214648uscas1p1093b2602603486134890a51b38270e45
CMS-TYPE: 301P
X-CMS-RootMailID: 20220128214648uscas1p1093b2602603486134890a51b38270e45
References: <CGME20220128214648uscas1p1093b2602603486134890a51b38270e45@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

df284fbdc23974c931865a8ddb7d171606b3c778 added zlib support as a
requirement for building fio-dedupe.

The current patch changes the Makefile to avoid trying to build
fio-dedupe when zlib support is not present.

Link: https://lore.kernel.org/fio/51b79acb-c314-143b-514c-a22ff9462829@gmai=
l.com/T/#u
Reported-by: Professor Pro <annivation@gmail.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 00e79539..2432f519 100644
--- a/Makefile
+++ b/Makefile
@@ -430,7 +430,9 @@ T_TEST_PROGS +=3D $(T_AXMAP_PROGS)
 T_TEST_PROGS +=3D $(T_LFSR_TEST_PROGS)
 T_TEST_PROGS +=3D $(T_GEN_RAND_PROGS)
 T_PROGS +=3D $(T_BTRACE_FIO_PROGS)
+ifdef CONFIG_ZLIB
 T_PROGS +=3D $(T_DEDUPE_PROGS)
+endif
 T_PROGS +=3D $(T_VS_PROGS)
 T_TEST_PROGS +=3D $(T_MEMLOCK_PROGS)
 ifdef CONFIG_PREAD
@@ -618,8 +620,10 @@ t/fio-btrace2fio: $(T_BTRACE_FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
 endif
=20
+ifdef CONFIG_ZLIB
 t/fio-dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
+endif
=20
 t/fio-verify-state: $(T_VS_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_VS_OBJS) $(LIBS)
--=20
2.25.1
