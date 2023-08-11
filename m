Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78412EB64DD
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbjHKHqu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjHKHqs (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:46:48 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA36F1FDD
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:46:44 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230811074640epoutp049b03e09583884f438c72b7567920eb4c~6RJEvl4tT1095110951epoutp047
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:46:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230811074640epoutp049b03e09583884f438c72b7567920eb4c~6RJEvl4tT1095110951epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740000;
        bh=fIcVOKfH2qNahVU0e+TdGt7yRH12vkROIWxDQ3EvrXI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=uIbFeBEl2SI4aADpy25ODeD+LVw2T3yGD8Fham9Tl9rsuZf1joF7zAKh756S19dId
         b28zIqB6rwQFIp7Gj9+eFJ0+x0DCLwN5U8ySXjEavo1rW79Hvjq6fN8yn7F/yJIfrB
         uxgQ6NP6ZVOQhAhi2Eb9uaNY9UmOz2ZSLcl3sXMk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230811074639epcas5p3079a36556e53228e67dbe99537d3b491~6RJEXVVBW0556505565epcas5p3Q;
        Fri, 11 Aug 2023 07:46:39 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RMbTV2jVcz4x9Px; Fri, 11 Aug
        2023 07:46:38 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.B2.55173.E57E5D46; Fri, 11 Aug 2023 16:46:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230811060633epcas5p2afd7e23260a8bebbe91c4ae87b25f6c7~6PxqC0Hqt1460014600epcas5p25;
        Fri, 11 Aug 2023 06:06:33 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230811060633epsmtrp144741353037f1b600471fd17b1ae3556~6PxqCBcS53260432604epsmtrp1M;
        Fri, 11 Aug 2023 06:06:33 +0000 (GMT)
X-AuditID: b6c32a50-df1ff7000001d785-25-64d5e75e469c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.E2.64355.9EFC5D46; Fri, 11 Aug 2023 15:06:33 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060631epsmtip1288aacf7da3ed87f0a3b7cf25cffab10~6PxoZydtX2768827688epsmtip1Q;
        Fri, 11 Aug 2023 06:06:31 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 00/10] Protection information support for io_uring
 passthrough
Date:   Fri, 11 Aug 2023 16:55:37 +0530
Message-Id: <20230811112547.92345-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdlhTUzfu+dUUg1NfhSzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnTNg9gb2gQbRi+cpXTA2MuwS6GDk5JARMJJafP8jaxcjFISSwh1Fi79QeKOcTo8TH
        +bsY4ZyX7z6wwbSc6ZzCDJHYyShx9OIDJgink0ni05wnLCBVbALaEq/e3gCq4uAQEdCQWHM3
        FaSGWaCFUWJ392xWkBphgWCJhruLGUFsFgFViYNz14HFeQVsJBpfb2eF2CYvMfPSd3aIuKDE
        yZkQ85mB4s1bZ4NdISFwiV1iztQvzBANLhK3WvaxQNjCEq+Ob2GHsKUkXva3QdnZEpse/mSC
        sAskjrzoheq1l2g91Q92NLOApsT6XfoQYVmJqafWMUHs5ZPo/f0EqpVXYsc8GFtV4u+921Br
        pSVuvrvKAjJGQsBD4ulNQRBTSCBWYtq9wgmM8rOQPDMLyTOzEPYuYGRexSiVWlCcm56abFpg
        qJuXWg6P2OT83E2M4ASpFbCDcfWGv3qHGJk4GA8xSnAwK4nw2gZfShHiTUmsrEotyo8vKs1J
        LT7EaAoM4onMUqLJ+cAUnVcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8T
        B6dUA9PUWosPKtJqyX95Xhjp3bacG6TkfratfxWnfeYqM7vPa9OFWztqfuROi2P4/nN2cs1l
        Ls6kuzfSf8rvDt+58llr9/0ELoP8/SeWlZQ9bM8xfHbUol7Lrua4hJ/PhUsd710f6nqfqhMX
        kRT6d+9J+/3yDwI7b7Y23BZ7z7xh+voA09P/t/ZXzmgKSL+WHMK57ZvRB0W2lg/rXukl2X8/
        cXmhwRqpM9+Pb82I1Hxu+rqFUUgt9VnFqfMz7h/K5N3vwXqE4eGVwPkhBl8iMpM/rJ/j/Z3L
        zmvu9r6eRR12TJ85WGwXs9xZqqvG8/CIqX61fcLvZYme8d+0UwKb/bYcfMUh66PaYWn79vfl
        KJm9W5VYijMSDbWYi4oTARLUDYYZBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnO7L81dTDBbcYrZYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MqYsHsCe0GDaMXyla+YGhh3CXQxcnJICJhInOmcwtzFyMUh
        JLCdUeL9yT72LkYOoIS0xML1iRA1whIr/z1nh6hpZ5JYu2IlC0iCTUBb4tXbG8wgtoiAlsSx
        dU1sIEXMQKMl9u6exgaSEBYIlDg39SY7iM0ioCpxcO46VhCbV8BGovH1dlaIDfISMy99Z4eI
        C0qcnPkEbAEzULx562zmCYx8s5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeul5yfu4kR
        HKRaQTsYl63/q3eIkYmD8RCjBAezkgivbfClFCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8yjmd
        KUIC6YklqdmpqQWpRTBZJg5OqQam2VvvL2359jhQfc+WjunCJvoqT3NCZ5g3J78J+fVr5+e6
        /RO3NB8ITv3dY5V4JNzRWTklYori2rwGl0mGTDK72D/s3L5xY9znmM7aK5Pff5BW1ZG4Jy6+
        z4w145yQ0J2UNY77w4XkOlf+PtPdc1K80vuf01Gms5yOXxirPfi8PWRnGT4/8OiqUcnpzq0L
        RS9MDvDdf0nzSd7Z1G8c/7hux3NtM1+lEBNobRUV8PHYNdGFri5HpqtUOX13TOHvD+xcWiu7
        /9mBtA/9p54t3adtfuk7z+dX076+EWipiXRt7I5aYO5+40tY8/fkv++yDl6Wuff53o2ti5cd
        jMpbvUTEYJn8+WV+a+Y+871iU940R4mlOCPRUIu5qDgRAJ6k9aTBAgAA
X-CMS-MailID: 20230811060633epcas5p2afd7e23260a8bebbe91c4ae87b25f6c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060633epcas5p2afd7e23260a8bebbe91c4ae87b25f6c7
References: <CGME20230811060633epcas5p2afd7e23260a8bebbe91c4ae87b25f6c7@epcas5p2.samsung.com>
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
 crc/crc-t10dif.h       |  10 +
 crc/crc64.c            |  32 +++
 crc/crc64.h            |   3 +
 crc/crc64table.h       | 130 ++++++++++++
 crc/crct10dif_common.c |  78 +++++++
 engines/io_uring.c     | 225 +++++++++++++++++---
 engines/nvme.c         | 466 +++++++++++++++++++++++++++++++++++++++--
 engines/nvme.h         | 230 +++++++++++++++++++-
 fio.1                  |  38 ++++
 io_u.h                 |   2 +-
 11 files changed, 1200 insertions(+), 53 deletions(-)
 create mode 100644 crc/crc-t10dif.h
 create mode 100644 crc/crc64table.h
 create mode 100644 crc/crct10dif_common.c

-- 
2.25.1

