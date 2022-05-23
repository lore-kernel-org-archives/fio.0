Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDDCC433EF
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiEWQ2l (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbiEWQ2h (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:28:37 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAC967D1E
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:28:33 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220523162829epoutp033cc2b08147599bb95f76a7878c855b84~xyMpjHyen1806518065epoutp039
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:28:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220523162829epoutp033cc2b08147599bb95f76a7878c855b84~xyMpjHyen1806518065epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323309;
        bh=lwwUsw5hThPQsaK3x7lUsdmvE6rPp+6vBD0pbUDovn0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=PQMlrGUYsILpFuDtqtbkUPf/uPvEIOrP36hkrYNCrw9MsjuCJkFDAG2bRIx46zNtQ
         +tuTGHP5kKDsv0I5yitOD72g1utW5vumO0KNjC0QMZo3o8KNy0wPe50YzOQG48j7Qt
         86HD6rukxK9VMWiugG1fD0qs+oU8QLCx0WMNvO/E=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220523162828epcas5p26446eaa1126b80870c36923cc9a9d90a~xyMoTk7_F2735027350epcas5p2B;
        Mon, 23 May 2022 16:28:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L6N6y183wz4x9Pv; Mon, 23 May
        2022 16:28:26 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.CF.09827.A26BB826; Tue, 24 May 2022 01:28:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220523131607epcas5p3dbb26f3b6f62fc8bcbe219304d60a7d1~xvkr98Ot20901009010epcas5p3B;
        Mon, 23 May 2022 13:16:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220523131607epsmtrp29fb90e3b1ca94f8a5ee3accdcd56cc84~xvkr9KT032951529515epsmtrp2h;
        Mon, 23 May 2022 13:16:07 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-76-628bb62a49a8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.D2.11276.7198B826; Mon, 23 May 2022 22:16:07 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131606epsmtip2e641c71cfc4d9590648c9c1ca940af31~xvkq8hEhE1953619536epsmtip2a;
        Mon, 23 May 2022 13:16:06 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/7] add support for uring passthrough commands
Date:   Mon, 23 May 2022 18:40:32 +0530
Message-Id: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7bCmhq7Wtu4kgytL2SzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjLu9K5gK/opU7HpxhL2B
        cbZAFyMnh4SAicS23XPYuhi5OIQEdjNKTNo3lRHC+cQocfdDPzOE841RYtn8t2wwLYumNDFB
        JPYySpz4+AGqqpVJ4t/cZWBVbALaEq/e3mAGsUUEhCX2d7SygBQxC7QwSjSuXssCkhAWsJe4
        0f6RCcRmEVCVON/fCdbMK2AjMf/WURaIdfISqzccANsgITCZXWJD+zWoO1wkHl/fwARhC0u8
        Or6FHcKWkvj8bi9UTbZE46O/UHaJxM5b25khbHuJi3v+AvVyAF2kKbF+lz5EWFZi6ql1YCOZ
        Bfgken8/gRrPK7FjHoytKvH33m2o26Qlbr67CmV7SDxeOwusRkggVuL1rOuMExhlZyFsWMDI
        uIpRMrWgODc9tdi0wCgvtRweVcn5uZsYwelJy2sH48MHH/QOMTJxMB5ilOBgVhLh3Z7YkSTE
        m5JYWZValB9fVJqTWnyI0RQYZhOZpUST84EJMq8k3tDE0sDEzMzMxNLYzFBJnFfgf2OSkEB6
        YklqdmpqQWoRTB8TB6dUA5POvaUTLyx5tcBn8cT9jJr3rJkFdh6+EV2/Q//+/fS4ume382cn
        32pymBrE/UbymWE3347z/acy6gLvCVtOrPqyS8D4mdvXpyH2PWpxbm9nH3xwKPK8R7ex3Fnx
        ywacV2tkktiXzLsml+1Q1viK9dNxEclnX4pW/py1tJ0tIYThSepCrdPP2NxMb7vNTJ6/66FH
        7vK4KZHHX6ZIfT19Vfftg+suG3VW3ni8a3LQ5dK0bQ7dDJkHUh5xnhLreLzzoanqmYdb3Qt1
        81s4d9VJ/JHJ+yagYcId/0XStePD4ykdbTe33nizgXlV1kKZB3xzNA80bGCtS49On7Swp6pg
        9f4LG0xWJnOluj4oSZ3Fl/9WiaU4I9FQi7moOBEAOeNSvNgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsWy7bCSvK54Z3eSwYFTEhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        3d4VTAV/RSp2vTjC3sA4W6CLkZNDQsBEYtGUJiYQW0hgN6NE93mHLkYOoLi0xML1iRAlwhIr
        /z1n72LkAippZpKYO/8JI0iCTUBb4tXbG8wgtghQ0f6OVhaQImagyRI9nafAhgoL2EvcaP8I
        ZrMIqEqc7+9kA7F5BWwk5t86ygKxQV5i9YYDzBMYeRYwMqxilEwtKM5Nzy02LDDMSy3XK07M
        LS7NS9dLzs/dxAgOEi3NHYzbV33QO8TIxMF4iFGCg1lJhHd7YkeSEG9KYmVValF+fFFpTmrx
        IUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUwdFovbOc8a/N4/uX/v1A3KF5Tn/tet
        /rHnvrJ65BXHs7bOSn/Uxe4IFqq6z7/JMvth12/7Xckqh5SXf3qZUtubcHp9Vu/rLy6yDLwl
        H29f13bT5THeXRwbNWlW7JGbejGHGQwWW6+7Xdv+YYJGeNAvRoOHbm2V6k3aS39KZ3l1aPdU
        3ExQf7Pn8G7HZV0Ws1xDPLsnxXBNPWcTUGzru9d5k+kRhbbLoi2RRyLuLd38dv3qM9/mTl7C
        plVYKb3K3bKM2155pphI+6X58q1cORP3b/1c+IUpp0zyyDuz32GVRYpsHIfPbz2c03my0dlr
        so26e/LFzUs1uA+6rfpmO0P7vjZjytyeFaHpdmvKvZVYijMSDbWYi4oTARSZoDKBAgAA
X-CMS-MailID: 20220523131607epcas5p3dbb26f3b6f62fc8bcbe219304d60a7d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131607epcas5p3dbb26f3b6f62fc8bcbe219304d60a7d1
References: <CGME20220523131607epcas5p3dbb26f3b6f62fc8bcbe219304d60a7d1@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patchset adds a new I/O engine (io_uring_cmd), which enables support for
io_uring passthrough commands. The new I/O engine will be built only if its
support is present in the kernel.
https://git.kernel.dk/cgit/linux-block/log/?h=for-next

This engine will use most of the existing helpers from io_uring. The I/O
preparation, completion, file open, file close and post init paths are going
to differ and hence io_uring_cmd will have its own helper for them.

The supported io_uring_cmd options are:
* registerfiles
* sqthread_poll
* sqthread_poll_cpu
* cmd_type (new)

The current uring passthrough support is present only with nvme-ns character
device (/dev/ngXnY). This includes both conventional as well as ZNS devices.
cmd_type provides the flexibility to support different types of passthrough
commands in future.
O_DIRECT flag support is not present with nvme-ns charatcer devices, hence
zbd will check for them only if fio filetype is a block device.

To enable support for nvme passthrough commands, fio will use libnvme to use
NVMe specification structures, enums and helper functions for sending commands.
As nvme specific uring_cmd changes are not yet part of mainline kernel, they
are not integrated with libnvme. Below is the PR for libnvme changes.
https://github.com/linux-nvme/libnvme/pull/362

NOTE: The io_uring_cmd I/O engine changes are present in engines/io_uring.c
These changes are guarded with config flags CONFIG_URING_CMD and
CONFIG_LIBNVME which makes the code a bit messy. This can be neat if
io_uring_cmd is decoupled from engines/io_uring.c

Ankit Kumar (4):
  configure: check if uring_cmd support is present
  docs: document options for io_uring_cmd I/O engine
  zbd: Check for direct flag only if its block device
  engines/io_uring: Enable zone device support for io_uring_cmd I/O
    engine

Anuj Gupta (3):
  io_uring.h: add IORING_SETUP_SQE128 and IORING_SETUP_CQE32
  engines/io_uring: add new I/O engine for uring passthrough support
  examples: add 2 example job file for io_uring_cmd engine

 HOWTO.rst                    |  17 +-
 Makefile                     |   4 +
 configure                    |  45 +++
 engines/io_uring.c           | 686 ++++++++++++++++++++++++++++++++++-
 examples/uring-cmd-ng.fio    |  35 ++
 examples/uring-cmd-zoned.fio |  40 ++
 file.h                       |  12 +-
 fio.1                        |  19 +-
 os/linux/io_uring.h          |  45 ++-
 zbd.c                        |   4 +-
 10 files changed, 886 insertions(+), 21 deletions(-)
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio

-- 
2.17.1

