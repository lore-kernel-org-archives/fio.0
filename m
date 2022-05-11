Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00F3C433EF
	for <fio@archiver.kernel.org>; Wed, 11 May 2022 19:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbiEKTMG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 May 2022 15:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238335AbiEKTMF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 May 2022 15:12:05 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837A57357A
        for <fio@vger.kernel.org>; Wed, 11 May 2022 12:12:01 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220511191156epoutp02720dc1abe5ef15a8883e000393ae6958~uIr72va1J2573225732epoutp02N
        for <fio@vger.kernel.org>; Wed, 11 May 2022 19:11:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220511191156epoutp02720dc1abe5ef15a8883e000393ae6958~uIr72va1J2573225732epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652296316;
        bh=I9NWsfbnlr3wf+JitdldC7DAQybr3Q772m9o6BpDLo4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Gstt+3pZ1aDR1HzMgN9xiojYF4L2mOzzEWhnSTTEDHhAB4TEvDjJM78QpEv6XqeWi
         uNRNOwM3GRIWLHEuRKscXwtZsC1f74ctK52TmwJyGnCOh0W8Ons++zwZNuZmGUzv3D
         ZGyxVOG+0SIwjjaGpP8S2nD6mQNcyBtm+HSN0Los=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220511191156epcas5p4efa05ecb9163bd4a850d058ab56bbe8c~uIr7ULAHx0095600956epcas5p45;
        Wed, 11 May 2022 19:11:56 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Kz4K45pM1z4x9Pq; Wed, 11 May
        2022 19:11:52 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.26.09762.87A0C726; Thu, 12 May 2022 04:11:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a~uGjqOXOtO2344723447epcas5p4P;
        Wed, 11 May 2022 16:35:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220511163552epsmtrp2436ea8c1b16d917b6f0a4686e2ac616e~uGjqNwKwU0266902669epsmtrp2F;
        Wed, 11 May 2022 16:35:52 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-17-627c0a782aca
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.E0.08924.7E5EB726; Thu, 12 May 2022 01:35:51 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220511163551epsmtip2bf7cc894b05b74b11f8a65b64de13c50~uGjpSbNkW0049300493epsmtip2a;
        Wed, 11 May 2022 16:35:50 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/3] fio: add xnvme engine
Date:   Wed, 11 May 2022 22:00:16 +0530
Message-Id: <20220511163019.5608-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsWy7bCmum4FV02SweJfOhZrrvxmt1h9t5/N
        4uOsF8wWCzcuY7K42z2D3YHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIznj2Zi5jwR2hiq8P2xkbGE/zdTFy
        ckgImEhcen+RvYuRi0NIYDejxNr9V1kgnE+MEj3/JjJBOJ+BMtO/M8G0vJy8ixEisYtRYveZ
        fVAtrUwS81v2sIFUsQloS7x6e4MZxBYREJbY39HKAmIzCxRKbL3TzwhiCwvoSmy+/AashkVA
        VeLYn6OsIDavgLXE1JWz2CC2yUus3nCAGWSBhMBkdon3Wy6zQyRcJB7M3skKYQtLvDq+BSou
        JfH53V6o5myJxkd/oewSiZ23tjND2PYSF/f8BXqHA+ggTYn1u/QhwrISU0+tY4K4k0+i9/cT
        qI95JXbMg7FVJf7eu80CYUtL3Hx3Fcr2kLi2ZBrYeCGBWIkX9zezTGCUnYWwYQEj4ypGydSC
        4tz01GLTAuO81HJ4TCXn525iBKckLe8djI8efNA7xMjEwXiIUYKDWUmEd39fRZIQb0piZVVq
        UX58UWlOavEhRlNgmE1klhJNzgcmxbySeEMTSwMTMzMzE0tjM0Mlcd5T6RsShQTSE0tSs1NT
        C1KLYPqYODilGpgKjQ/9rH21YyrTqbnW8lXFFTVZ/6Y0+Fd/8HmW7/j++7Y/v2zaVjqIV7za
        njCzqeOf6L0F/IX6Mq3PAlSZPMIm/7sb9n/dq81LPjcyBHJMTTwcJK2oXPziXe392VmnusWX
        Om56Z5UnHnJRpE+pt1gq48dOs58p+SG5bUvmX9CYGMR28XBjF8uGB/7K3NWpEa4rI94aMl63
        0Aubk+N08HBXYRhLzs39dWm2F1e/mvpB91z4U+GFmclvJ0ySXZJ/+IjNxl/vDwpkfPQ5Y7sh
        51rQJcM3wq+5fRZsVV4iHbLs/3oe7ebyrJfbAmqk9vef9jKwEUyZfmja8VbdM3LmXd/3r1hg
        klBhULl20u+fL1iVWIozEg21mIuKEwG/f6+d0gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsWy7bCSvO7zp9VJBiearCzWXPnNbrH6bj+b
        xcdZL5gtFm5cxmRxt3sGuwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8ezNXMaC
        O0IVXx+2MzYwnubrYuTkkBAwkXg5eRdjFyMXh5DADkaJWef+M3UxcgAlpCUWrk+EqBGWWPnv
        OTtETTOTxM3JWxlBEmwC2hKv3t5gBrFFgIr2d7SygNjMAqUSTR9XsYHYwgK6EpsvvwGrYRFQ
        lTj25ygriM0rYC0xdeUsNogF8hKrNxxgnsDIs4CRYRWjZGpBcW56brFhgVFearlecWJucWle
        ul5yfu4mRnBoaGntYNyz6oPeIUYmDsZDjBIczEoivPv7KpKEeFMSK6tSi/Lji0pzUosPMUpz
        sCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYEo88eNi7GKT5giXmVvFLD9Wf/kWH/T+bo7G
        hp8Rm3bfkbmV22Jf9ahW7tZLUyd9pYfyv9+zHekxqbS94mHFJeeW78E5t0yG3y5wxhtur85o
        zkWuEo/MH34z12NgnX/X9dGk+Y+qefxVFm9RtHz/+MFhG9vN60s1tPcs/CLTn/fK2OGF74FD
        m7vY506oKdVbvD3wusC2Z8Y7jP9G7lhubJeuGq/rxvXDwstYlif70UnrEzu2LhVc36/22Hmj
        lB9zx4fJOi5HnBs2tv/6JZS173XHt5Wz9K499FlY+kjx0a1A/aTH54MPPwratMLVsHLOCeG3
        nBzh86ZvDfNh/xfCEfXxW6RVkcbxHIZfLH/KvyuxFGckGmoxFxUnAgAZKGvYfAIAAA==
X-CMS-MailID: 20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a
References: <CGME20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch introduces a new xnvme fio engine.

xNVMe provides an API for synchronous and asynchronous I/O.
A library backs the API, libxnvme, which provides implementations for API users to
run their I/O application on Linux, FreeBSD, macOS, and Windows without changing the application code.

Implementations of sync. interfaces include:
* psync (preadv/pwritev)
* Linux NVMe driver-ioctl
* FreeBSD NVMe driver-ioctl

Implementations of async. interfaces include:
* io_uring
* io_uring_cmd (experimental)
* libaio
* POSIX aio

In addition to the OS-managed interfaces, the library also utilize user-space NVMe-drivers
e.g. the SPDK NVMe/driver. Furthermore, "async-fallbacks" provide "async-emulation" in a sequential form
and using a thread pool. Finally, a "nil" implementation is available to evaluate encapsulation/library overhead.

The xNVMe C API currently supports Windows interfaces: Windows Storport, IOCP, and experimental io_ring.
However, these are not functional with the engine due to a few missing dependencies.

For more info on visit
https://xnvme.io
https://github.com/OpenMPDK/xNVMe

This patch also includes two example job files for Conventinal and ZNS specific commands.
In addition, it demonstrates how to instrument the engine to use different interfaces and with a user-space NVMe driver.


Changes since v1:
- Addressed review comments from Vincent.
- Improved error-logging and debugging by replacing XNVME_DEBUG with
  log_err, log_info and dprintf.
- Fixed issues when enabling iovec-payloads, now using io_u->mmap_data
  instead of io_u->engine_data as it gets overwritten by io_u->index.

Ankit Kumar (3):
  engines/xnvme: add xnvme engine
  docs: documentation for xnvme ioengine
  examples: add example job file for xnvme engine usage

 HOWTO.rst                  |  55 ++-
 Makefile                   |   7 +-
 configure                  |  22 +
 engines/xnvme.c            | 981 +++++++++++++++++++++++++++++++++++++
 examples/xnvme-compare.fio |  72 +++
 examples/xnvme-zoned.fio   |  87 ++++
 fio.1                      |  70 ++-
 optgroup.h                 |   2 +
 options.c                  |   5 +
 9 files changed, 1296 insertions(+), 5 deletions(-)
 create mode 100644 engines/xnvme.c
 create mode 100644 examples/xnvme-compare.fio
 create mode 100644 examples/xnvme-zoned.fio

-- 
2.17.1

