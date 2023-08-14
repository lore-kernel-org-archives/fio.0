Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B411EB64DD
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjHNJlT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjHNJkz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:40:55 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED26DA
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:40:52 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230814094049epoutp045fc5e4309e2045fbe68151561b4d2776~7Nol_tms42047120471epoutp04c
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:40:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230814094049epoutp045fc5e4309e2045fbe68151561b4d2776~7Nol_tms42047120471epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006049;
        bh=s5SKoJdHyBiPU7qTZ34lzV0EH4EJnM7KaKU7ZLaXl9k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=CONGaSg/DwT+80hrU4bW7j6HR5N+U6uSv5gUyNiizSHXW1K9qsv3ySB+Tl3UvyDet
         LJEv/ATFCxaPjMkhTw+4DVFQua89+sRx36QnYTPzw61cQQO76pi+XWGAId/MrQJ4K3
         wdYPyr9XKSRbVeylMtr8Djv6+x+ByVaoYTbuPPOQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230814094048epcas5p26480eb4dc42333af64016c87317fafd2~7NoltBSTi0790607906epcas5p2i;
        Mon, 14 Aug 2023 09:40:48 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RPTsq1n0Yz4x9Pv; Mon, 14 Aug
        2023 09:40:47 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.3E.55522.F96F9D46; Mon, 14 Aug 2023 18:40:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230814093836epcas5p44bc762fa6e4368d532126494115aeba4~7Nmq1zHBL1183811838epcas5p4C;
        Mon, 14 Aug 2023 09:38:36 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230814093836epsmtrp1359028fbf393d5a53d67c347abf3f3a3~7Nmq1GDRK2343923439epsmtrp1E;
        Mon, 14 Aug 2023 09:38:36 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-3d-64d9f69f6677
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.30.30535.C16F9D46; Mon, 14 Aug 2023 18:38:36 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093835epsmtip1528c2215909e767ec533f0b6c3a68478~7NmpSJgRI1005810058epsmtip1F;
        Mon, 14 Aug 2023 09:38:35 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 00/10] Protection information support for io_uring
 passthrough engine
Date:   Mon, 14 Aug 2023 20:27:37 +0530
Message-Id: <20230814145747.114725-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTS3f+t5spBgfXsFusufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOaOwtKJguVrH/12SWBsYdgl2MnBwSAiYSuzcdY+xi5OIQEtjNKPF7+iY2COcTo8Sr
        OetZQKqEBL4xSrT94IbpOHvtEytEfC+jxOItihANnUwS17qPgSXYBLQlXr29wdzFyMEhIqAh
        seZuKkgNs0ALo8Tu7tlgNcICURL3j99hA7FZBFQlftw8yw5i8wrYSmxZdY8ZYpm8xMxL36Hi
        ghInZz4BO4gZKN68dTZUzTV2iSXXcyBsF4nOvR/YIGxhiVfHt7BD2FISL/vboOxsiU0PfzJB
        2AUSR170Qs2xl2g91Q92M7OApsT6XfoQYVmJqafWMUGs5ZPo/f0EqpVXYsc8GFtV4u+92ywQ
        trTEzXdXoWwPiaUbzzFCwipW4saT+cwTGOVnIflmFpJvZiFsXsDIvIpRMrWgODc9tdi0wDAv
        tRweq8n5uZsYwalRy3MH490HH/QOMTJxMB5ilOBgVhLhveV+LUWINyWxsiq1KD++qDQntfgQ
        oykwiCcyS4km5wOTc15JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxS
        DUxM7515Jtbxppt6sjoo9qyMuj3xn8Ttg8/+TeBJYb77oW/yNPWjjVN0w+b2X323li/CYRbD
        buPMx7ud9jvq/tWYdmq/1DP1mGTVd41r8979q/OZdZ/7irc2Q5KN/xsVO/1zz3wlM4znBzUp
        VLQWz4zs1Xhyi9NDeseF7D12C99eu2xlvHdjifiimTavViUX9R3713kp7SCDe8HX9upHtZmt
        l8/NObrvnaNXcMQb2WkPTkZxxh6w9Ts32zXoxVPrKSV3u8Lrl8SzHpfpnzZj/82KsOf3jFWe
        eH/bYinjwswlEv/9rwPLEfPF9y0XOXeZtYgunPNCTrOD51L/6heXCh2+f7nn7bW2mzXt9bs/
        718rsRRnJBpqMRcVJwIAfR5wDxYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSnK7Mt5spBke+GlqsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGU09hYUTBer2P9rMksD4w7BLkZODgkBE4mz1z6xdjFycQgJ
        7GaUmDTpBWMXIwdQQlpi4fpEiBphiZX/nrND1LQzSbRuP8gKkmAT0JZ49fYGM4gtIqAlcWxd
        ExtIEbNAF6PE3t3T2EASwgIREu+nHGIHsVkEVCV+3DwLZvMK2EpsWXWPGWKDvMTMS9+h4oIS
        J2c+YQGxmYHizVtnM09g5JuFJDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95Pzc
        TYzgUNXS2sG4Z9UHvUOMTByMhxglOJiVRHhvuV9LEeJNSaysSi3Kjy8qzUktPsQozcGiJM77
        7XVvipBAemJJanZqakFqEUyWiYNTqoEpIc+0uH/rHvVJdzk1fcRXbXaU9tfrXMkm0h6+49Hq
        ezerbOJt5vEm26rp2bL89kwoW8T8k31t6w191tr4qc4XSkpK2qwb0ydfVfxtapX8KPKPg3zQ
        9HOWR25/sVLk+rL9yxMRwctLLJZ9Xdtvz/xNtVvEcmvaU8btdRZvl/rMFLtjuDAp6T4fT5z3
        y6Nfm+9NVu7cm5859drH6Ru22Z2590Oz7vf8J1NaLhnNflZit/3C7w7vre9uX3eRf1q98WB2
        gJli//o6pojGyrhptzhnFb3cfqrlEbOlQOr3az5HtAz+LkjYH/D3lKILQ370zoRon6X2C9/e
        LnrVIOW289+deU+P8u349Lvm+4rCw0++K7EUZyQaajEXFScCACuGm3jEAgAA
X-CMS-MailID: 20230814093836epcas5p44bc762fa6e4368d532126494115aeba4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093836epcas5p44bc762fa6e4368d532126494115aeba4
References: <CGME20230814093836epcas5p44bc762fa6e4368d532126494115aeba4@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch series enables protection information support with io_uring
passthrough (io_uring_cmd) ioengine. This support is added for both DIF
(extended logical blocks) and DIX (separate metadata buffer) cases.

The initial patch adds support for metadata buffer. As we are unaware
of metadata size during metadata buffer allocation, we provide an
option md_per_io_size. This must be used to specify metadata size for
single IO, if namespace is formatted with separate metadata buffer.

This then enables the protection information support with and without
PRACT bit set for both DIF and DIX cases. The support covers 16-bit and
64-bit guard protection information format, without storage tags. As
32-bit guard protection information format mandates minimum 16 bits for
storage tags, it is not considered.

For the sake of consistency metadata and protection information specific
options are the same as the ones used by SPDK's external ioengine.

This series also borrows relevant kernel crc16-t10 and NVMe CRC64
generation files, along with 48-bit accessors for reference tags.

The NVMe CRC64 table is not generated at build time which is what kernel
does. This will be done in future.

Changes from v2:
 - fix windows/mac build issue from crct10 files (missed during v2)
   https://github.com/fiotestbot/fio/actions/runs/5830346708

Changes from v1:
 - Fixed build issue on windows and macos.
 - Changed name of CRC64 tables and algorithm as per NVMe command set
   specification (Keith's suggestion).
 - Addressed review comments from Vincent.

Ankit Kumar (10):
  engines:io_uring: add missing error during open file
  engines:io_uring: update arguments to fetch nvme data
  engines:io_uring: enable support for separate metadata buffer
  engines:io_uring: uring_cmd add support for protection info
  io_u: move engine data out of union
  crc: pull required crc16-t10 files from linux kernel
  engines:io_uring: generate and verify pi for 16b guard
  crc: pull required crc64 nvme apis from linux kernel
  engines:nvme: pull required 48 bit accessors from linux kernel
  engines:io_uring: generate and verify pi for 64b guard

 HOWTO.rst              |  39 ++++
 crc/crc-t10dif.h       |   9 +
 crc/crc64.c            |  32 +++
 crc/crc64.h            |   3 +
 crc/crc64table.h       | 130 ++++++++++++
 crc/crct10dif_common.c |  78 +++++++
 engines/io_uring.c     | 225 +++++++++++++++++---
 engines/nvme.c         | 466 +++++++++++++++++++++++++++++++++++++++--
 engines/nvme.h         | 230 +++++++++++++++++++-
 fio.1                  |  38 ++++
 io_u.h                 |   2 +-
 11 files changed, 1199 insertions(+), 53 deletions(-)
 create mode 100644 crc/crc-t10dif.h
 create mode 100644 crc/crc64table.h
 create mode 100644 crc/crct10dif_common.c

-- 
2.25.1

