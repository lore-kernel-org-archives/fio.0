Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61A4C433F5
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbiFAJkE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351174AbiFAJkD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:03 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E83B434B4
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:00 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220601093954epoutp01cf1dd9fae2db7d5a891ad9e97187bfa7~0dbeMXQw61167311673epoutp01U
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:39:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220601093954epoutp01cf1dd9fae2db7d5a891ad9e97187bfa7~0dbeMXQw61167311673epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076394;
        bh=+7SCfJ8G75tcOmjkNQRDNTueTx8Rzdvc0TYrm3+lsxY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ZLLQcXrtertnf81NeJFzsidPUFfN0ifzb4Hbo62D0j8dXz75dEkOoySnOUQoQMDhb
         m9DMw/DSOP6uLQkxSM6BNh8JZDEIurUkX+BYFZzdzDdEGuSV9uQSpwIzU5DB+03T5C
         mdKycwEWWKSde8uuy7IpA3lCWXalQDpEG135In48=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220601093953epcas5p4db0595772358d2292985bdba56757e24~0dbd2IN603151731517epcas5p4n;
        Wed,  1 Jun 2022 09:39:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LCkdL6CXNz4x9Px; Wed,  1 Jun
        2022 09:39:50 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.47.09827.4E337926; Wed,  1 Jun 2022 18:39:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220531133739epcas5p31aa9479d49d5ae82a85b493bd0bb4e47~0NBxYZJ6v0535905359epcas5p3r;
        Tue, 31 May 2022 13:37:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133739epsmtrp2042aee7ec19d335e2ceb6b888caa015f~0NBxXpJTw0338303383epsmtrp2B;
        Tue, 31 May 2022 13:37:39 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-2d-629733e4b61a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.F4.11276.32A16926; Tue, 31 May 2022 22:37:39 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133738epsmtip261ccacca549e7218c4b1fc3cfd425a55~0NBwZkJ0h2552425524epsmtip2A;
        Tue, 31 May 2022 13:37:38 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 0/9] Add support for uring passthrough commands
Date:   Tue, 31 May 2022 19:01:46 +0530
Message-Id: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmhu4T4+lJBttO8lisufKb3aJpwl9m
        i9V3+9ksPs56wWxx9P9bNouFG5cxObB5XD5b6tG3ZRWjx+dNcgHMUdk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGc9mL2Yv6JSoWDu3rIFx
        lVAXIweHhICJxK9rVV2MXBxCArsZJR62nmDsYuQEcj4xStx+FQiR+MYo0brrK1gCpGH7lLWM
        EIm9jBJzWvrZIZxWJonpU0+CVbEJaEu8enuDGcQWERCW2N/RygJSxCzQwijRuHotC0hCWMBJ
        YtrFs2ANLAKqEnfO94LZvAI2Eu/3bIFaJy+xesMBZpBmCYHJ7BLv57WzQiRcJFb8ngtVJCzx
        6vgWdghbSuLzu71sEHa2ROOjv1B2icTOW9uZIWx7iYt7/jKBAoBZQFNi/S59iLCsxNRT65hA
        bGYBPone30+YIOK8EjvmwdiqEn/v3WaBsKUlbr67CmV7SLy58YsVEnaxEr9/vWabwCg7C2HD
        AkbGVYySqQXFuempxaYFRnmp5fB4Ss7P3cQITkxaXjsYHz74oHeIkYmD8RCjBAezkghvya6p
        SUK8KYmVValF+fFFpTmpxYcYTYFhNpFZSjQ5H5ga80riDU0sDUzMzMxMLI3NDJXEeQX+NyYJ
        CaQnlqRmp6YWpBbB9DFxcEo1MNVVp8UXfzqvEvjtuFthX1zJvIN3mi9udfj4NLBbWcaucdZ+
        i2rej8ffazNzpFRtTT/iu3b3OaXMLycFXJfFXOm9aON+RV34h+PTqyKbxKW9OHUuHTHR+r2p
        pPhe+e5rk28EfeSdULYs/Ee5BtfuxpRPupIvddNXP0m61tl43dfljs0/xhM/tVZm/gnamuO9
        0nT389XXpz4vC931sPPljnkL01OkGXifrZiQH5zyqXv7xNYQloT4Sf75cUxH9NKbjm0JS1/7
        8Fma9gf5D3POnHiQYvOmybywyMx655LlZfUmG0W6DE5O0+A9XjL9zJ2w/8fD47RcM/v7D3RM
        7s0Re8OYenTXcgn3vcmnDEs3HVNiKc5INNRiLipOBACOYO//1QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsWy7bCSvK6y1LQkg0dHJS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
        Z7MXsxd0SlSsnVvWwLhKqIuRk0NCwERi+5S1jCC2kMBuRokDe527GDmA4tISC9cnQpQIS6z8
        95wdoqSZSeLzamsQm01AW+LV2xvMILYIUM3+jlaWLkYuDmaBLkaJns5TTCAJYQEniWkXz4LN
        ZxFQlbhzvhfM5hWwkXi/ZwsjxAJ5idUbDjBPYORZwMiwilEytaA4Nz232LDAMC+1XK84Mbe4
        NC9dLzk/dxMjOEC0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHekl1Tk4R4UxIrq1KL8uOLSnNSiw8x
        SnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgurTnYqmz+9JilvCYcOPlbL9S5Xq+Bpgw
        X78QaJpxQWJD5/Vf8mU7lavYbWKj6o7WrKqoLyiysHw+l+X+dNVz0zu/G3qFHGmS91vxLZXT
        5a6/kPY0U7nJ9183yyy/ITdl47M5NsIbUhyFXLoKQhYU+ZSbTH6q9dox9Zu4wIMzdq9/Zv7N
        7JRZ7mRlaPjocHzmygcdk3/Nk/jDHPmHNdry8OH/xWsd9ukduark8Lpe20f0X89Zy4nXGy+2
        fJBc0T3RZo9aYdB2u09ZL9vWF+ZOm/Sjs0L82nXJspNWHPflfwVtSTDbcOF8/1Of2xknfpsf
        FdDUPLWDLUD5/MbIZJHle/oeLe7NuxoU/cu/VdBQiaU4I9FQi7moOBEAh3gqNn8CAAA=
X-CMS-MailID: 20220531133739epcas5p31aa9479d49d5ae82a85b493bd0bb4e47
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133739epcas5p31aa9479d49d5ae82a85b493bd0bb4e47
References: <CGME20220531133739epcas5p31aa9479d49d5ae82a85b493bd0bb4e47@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patchset adds a new I/O engine (io_uring_cmd), which enables support for
io_uring passthrough commands. This work is based on upcoming 5.19 kernel.
https://github.com/torvalds/linux/commits/master

This engine will use most of the existing helpers from io_uring. The I/O
preparation, completion, file open, file close and post init paths are going to
differ and hence io_uring_cmd will have its own helpers for them.

The current uring passthrough support is present only with nvme-ns character
device (/dev/ngXnY). This includes both conventional as well as ZNS devices.
Add a new io_uring_cmd engine specific option:
* cmd_type

cmd_type provides the flexibility to support different types of passthrough
commands in future.

To enable support for nvme passthrough commands, we are adding nvme.c and
nvme.h files. These will have the necessary NVMe specification data
structures, opcodes and helper functions for sending admin and I/O passthrough
commands.

O_DIRECT flag support is not present with nvme-ns charatcer devices, hence
zbd will check for them only if fio filetype is a block device. The
t/zbd/test-zbd-support test case #1 is now appropriately updated to run only
for block device.

Changes from v2 to v3:
- I/O command formation cleanup and example config file changes as per the
  review comments from Vincent and Jens.
- Addressed review comments from Kanchan with regards to io_uring_cmd options.
- test case 1 skip only for character device fixed, as reported by Shin'ichiro.

Ankit Kumar (5):
  configure: check nvme uring command support
  nvme: add nvme opcodes, structures and helper functions
  docs: document options for io_uring_cmd I/O engine
  zbd: Check for direct flag only if its block device
  engines/io_uring: Enable zone device support for io_uring_cmd I/O
    engine

Anuj Gupta (4):
  io_uring.h: add IORING_SETUP_SQE128 and IORING_SETUP_CQE32
  init: return error incase an invalid value is passed as option
  engines/io_uring: add new I/O engine for uring passthrough support
  examples: add 2 example job file for io_uring_cmd engine

 HOWTO.rst                    |  41 +++-
 Makefile                     |   4 +-
 configure                    |  21 +++
 engines/io_uring.c           | 350 ++++++++++++++++++++++++++++++++++-
 engines/nvme.c               | 345 ++++++++++++++++++++++++++++++++++
 engines/nvme.h               | 214 +++++++++++++++++++++
 examples/uring-cmd-ng.fio    |  25 +++
 examples/uring-cmd-zoned.fio |  31 ++++
 file.h                       |  12 +-
 fio.1                        |  33 +++-
 init.c                       |   9 +
 os/linux/io_uring.h          |  45 ++++-
 t/zbd/test-zbd-support       |  11 +-
 zbd.c                        |   4 +-
 14 files changed, 1113 insertions(+), 32 deletions(-)
 create mode 100644 engines/nvme.c
 create mode 100644 engines/nvme.h
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio


base-commit: e1aeff3ac96a51128b0493377f405e38bdc83500
-- 
2.17.1

