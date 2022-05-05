Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1A3C433F5
	for <fio@archiver.kernel.org>; Thu,  5 May 2022 13:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiEEOA7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 5 May 2022 10:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiEEOA4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 May 2022 10:00:56 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A90426555
        for <fio@vger.kernel.org>; Thu,  5 May 2022 06:57:16 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220505135713epoutp0163ea6b9d9dfdb9b0301c9d52755e2cbc~sOhb4TtN72706627066epoutp01O
        for <fio@vger.kernel.org>; Thu,  5 May 2022 13:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220505135713epoutp0163ea6b9d9dfdb9b0301c9d52755e2cbc~sOhb4TtN72706627066epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651759033;
        bh=wuQawcqx9ctqXAP9AbWlfq8rEKahGkrGqqTyfaM2H3s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ocvf3GaF5AZsTutOlaqQf2XBxDfbBHVtce75xgGAKHBNcAUEhOFjoWaPvGyPciYal
         U/c2Tu78C3q/CQSuOWIvHBNgmy0Tev2gtFG6q/gTlbn6XA5GQkieNAL+l2CbAGCATC
         degQV5imcNQIXKXVKkOvXvDEC4LKv4FgN1jSSCV8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220505135713epcas5p246ee1e0af3967633880e6a7b81c9fdd6~sOhbVTS_t1173811738epcas5p2G;
        Thu,  5 May 2022 13:57:13 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KvFck6Kvdz4x9Pp; Thu,  5 May
        2022 13:57:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.41.10063.4B7D3726; Thu,  5 May 2022 22:57:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220505132529epcas5p25512da35ba70c4eed9890f299b1db12f~sOFu7m2FI0945609456epcas5p2u;
        Thu,  5 May 2022 13:25:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505132529epsmtrp10d5fc459bd7f6638013ad5f3f32edea8~sOFu66S5A0564005640epsmtrp1J;
        Thu,  5 May 2022 13:25:29 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-b1-6273d7b4cc87
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.A3.08924.940D3726; Thu,  5 May 2022 22:25:29 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505132528epsmtip2c272105ed6efc529c86aefde95eee57e~sOFt6GDq02448624486epsmtip2f;
        Thu,  5 May 2022 13:25:28 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/3] fio: add xnvme engine
Date:   Thu,  5 May 2022 18:49:32 +0530
Message-Id: <20220505131935.32076-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmpu6W68VJBnN+q1qsufKb3WL13X42
        i4+zXjBbLNy4jMnibvcMdgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2PliRWsBasEKk5tb2FrYDzO08XI
        ySEhYCJxsWEVK4gtJLCbUeLMbM0uRi4g+xOjxP8561khnM+MEv1HL7HDdHQ+uQaV2MUo8ef7
        G3YIp5VJ4uzdA4wgVWwC2hKv3t5gBrFFBIQl9ne0soDYzAKFElvv9IPVCAtoSTxdugAsziKg
        KnHr0FuwO3gFbCTun5zGBLFNXmL1hgPMIAskBCazS0zuvAZ1hovEmz+TWSFsYYlXx7dAxaUk
        Xva3QdnZEo2P/rJB2CUSO29tZ4aw7SUu7vkLtIAD6CBNifW79CHCshJTT61jgriTT6L39xOo
        G3gldsyDsVUl/t67zQJhS0vcfHcVyvaQ2Hd1KzQcYyXWvepnncAoOwthwwJGxlWMkqkFxbnp
        qcWmBYZ5qeXwiErOz93ECE5IWp47GO8++KB3iJGJg/EQowQHs5IIr/PSgiQh3pTEyqrUovz4
        otKc1OJDjKbAMJvILCWanA9MiXkl8YYmlgYmZmZmJpbGZoZK4ryn0zckCgmkJ5akZqemFqQW
        wfQxcXBKNTDtMGfvaGGVUD4+sdpocuqa1VP3v8y1sp9xpbs/6AjbtRVrOa/WbMx6E804W3LW
        v7iDvlzGlWvu3uluPiBUkpjy9/yczuXlHfMfWZlL6IlPjhc7Hvov9KGVyM26sOSOOcWiK/bE
        PJvweeGiuSzFPk07GqrjmoKNZXeuZ9BmlbvStWTZG35RvSt89S+v66SWTl/Rd0Ln0Xc928ti
        TY831aRtV3nIp9pxylrtj4xKbnr1TTNJMe5d2yfcYFAuS1549vxpnwDfSiO93JObLq4592SP
        Q25nJP9Or4pEt/IFh9Ryy4KCir3+SVysddHgDPzi9Ov0v1L+zxxLaydtL/rHc9z+9sn/9VeW
        Kro+nHz4rKkSS3FGoqEWc1FxIgCofJla0QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsWy7bCSvK7nheIkg8OXjCzWXPnNbrH6bj+b
        xcdZL5gtFm5cxmRxt3sGuwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVsfLECtaC
        VQIVp7a3sDUwHufpYuTkkBAwkeh8co21i5GLQ0hgB6PEgzfrWLoYOYAS0hIL1ydC1AhLrPz3
        nB2ipplJ4s+z9UwgCTYBbYlXb28wg9giQEX7O1pZQGxmgVKJpo+r2EBsYQEtiadLF4DFWQRU
        JW4dessKYvMK2EjcPzmNCWKBvMTqDQeYJzDyLGBkWMUomVpQnJueW2xYYJSXWq5XnJhbXJqX
        rpecn7uJERwaWlo7GPes+qB3iJGJg/EQowQHs5IIr/PSgiQh3pTEyqrUovz4otKc1OJDjNIc
        LErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamOpO7L/f3JjpO9v+3WSeI+1zpXYcy935XTx1
        Y/rDt6enGni3vDkrtz9//k25/iuef6/ELlk5PfN/0mf3wuKta5LvLzo6/WXUlTW8pxnLziks
        jV985E/HO40rehtXZ7zPeX7haNG3y5IdOsdP6unytT0qU2YMkWye+Dj1+OwvmT4l8qHTlwYI
        Fgjt/Wy/+YjMrGmN+S19wrEdr/6mBltqxy7uy39ddC567hcjW9krHwO+eN/Zb7/2JK/hk4dd
        Np4/C3n3bZzYVjVTk9fILsfO6HufnFdt4Ffu44UBq7ump7E1NvCX3l7QKPOytjXiSO+SOQyO
        n+Pm7E4oc7405Yt0ownXPTm/t7PDEiO2blduz1BiKc5INNRiLipOBACgP+MLfAIAAA==
X-CMS-MailID: 20220505132529epcas5p25512da35ba70c4eed9890f299b1db12f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505132529epcas5p25512da35ba70c4eed9890f299b1db12f
References: <CGME20220505132529epcas5p25512da35ba70c4eed9890f299b1db12f@epcas5p2.samsung.com>
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

Ankit Kumar (3):
  engines/xnvme: add xnvme engine
  docs: documentation for xnvme ioengine
  examples: add example job file for xnvme engine usage

 HOWTO.rst                  |   51 +-
 Makefile                   |    7 +-
 configure                  |   22 +
 engines/xnvme.c            | 1000 ++++++++++++++++++++++++++++++++++++
 examples/xnvme-compare.fio |   72 +++
 examples/xnvme-zoned.fio   |   87 ++++
 fio.1                      |   67 ++-
 optgroup.h                 |    2 +
 options.c                  |    5 +
 9 files changed, 1308 insertions(+), 5 deletions(-)
 create mode 100644 engines/xnvme.c
 create mode 100644 examples/xnvme-compare.fio
 create mode 100644 examples/xnvme-zoned.fio

-- 
2.17.1

