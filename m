Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC64C433FE
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiEZQsH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344911AbiEZQsF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:05 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB01636B
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:00 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220526164753epoutp0251d38b29dad5db8899c3a647e7373130~ytZcTVov23220332203epoutp02N
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:47:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220526164753epoutp0251d38b29dad5db8899c3a647e7373130~ytZcTVov23220332203epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583673;
        bh=oDrMd166Tr5Js9LOrDm15IP65GAYphuSZvFjDTD52Z8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Z/DTCUxXtFlFDR8aFaIF+BwbRNuJF/MyUe7e9fPW1YneSfwAq8cUCcwNfKizTg0q0
         VNYuTaF6msPROwiAsjvyygumYfxkwhO0dtt5ZVyetgPsDcXtEnFjsJyo8rzCtuKcCX
         YnfT02U5MpsH1RuwRLV0Ozc2000yoAKhFjk/dl3g=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220526164752epcas5p3c0eeeff8a174836168602c64905cb347~ytZbIZXhC1959819598epcas5p3p;
        Thu, 26 May 2022 16:47:52 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L8DPw4q6Lz4x9Pw; Thu, 26 May
        2022 16:47:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.A1.09827.43FAF826; Fri, 27 May 2022 01:47:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c~yr1w5dp3Z0672706727epcas5p3s;
        Thu, 26 May 2022 14:53:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220526145343epsmtrp1d80bda29b9cec9e99c87b7a986495820~yr1w4vqUV0379103791epsmtrp1V;
        Thu, 26 May 2022 14:53:43 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-f0-628faf34a796
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.3E.08924.7749F826; Thu, 26 May 2022 23:53:43 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145342epsmtip22ba22398302a071f811faa949b61c9fc~yr1v5Sawa1809618096epsmtip2E;
        Thu, 26 May 2022 14:53:42 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/8] Add support for uring passthrough commands
Date:   Thu, 26 May 2022 20:18:01 +0530
Message-Id: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsWy7bCmlq7J+v4kg/9TlS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjOUXb7IV/BSr6J/9nbWB
        8axgFyMnh4SAicT3u7/Yuxi5OIQEdjNKHFvQzAThfGKUeHh9GRuE85lRov33BFaYlkcTPjND
        JHYxSvw9/Z0Fwmllkri4dDsLSBWbgLbEq7c3mEFsEQFhif0drWBFzAItjBKNq9eCFQkLOElc
        O70UrIhFQFWi69JsMJtXwEZiU+clRoh18hKrNxwAWychMI9d4t6Gk0DnsgM5LhJrSyFKhCVe
        Hd/CDmFLSbzsb4OysyUaH/1lg7BLJHbe2s4MYdtLXNzzF+hPDqB7NCXW79KHCMtKTD21jgnE
        Zhbgk+j9/YQJIs4rsWMejK0q8ffebRYIW1ri5rurULaHxMsdu8HWCgnESlya+oZ1AqPsLIQN
        CxgZVzFKphYU56anFpsWGOWllsMjKjk/dxMjODVpee1gfPjgg94hRiYOxkOMEhzMSiK8F572
        JgnxpiRWVqUW5ccXleakFh9iNAWG2ERmKdHkfGByzCuJNzSxNDAxMzMzsTQ2M1QS5xX435gk
        JJCeWJKanZpakFoE08fEwSnVwOR5n0NsZc3HmS+P5YedUHqdoJySqLDnoFQ7TyannNiauD0b
        fzdqlym/N++6lhXNJ/uo/57D5OsbN4c9PmQ5V67kZu9u40P1h0KVlzfd2y2QaRl//vWbdZJR
        wQ/eRP9nOL4kijnYnP1lffO7/KY77CWtm/wesV1u2/KleO+Pqsu5Ip+WOd2d+W72nYbG980d
        5kcs43aqH351TK+ff/nP5DMbVnNlcic9vaP5M+SqpnjaSrmERXVdmzryPKYvOW7ud3ktz9e1
        eoyvXbYcD3rGrnlBhqHSreFAkGnbr7MnuyaudCvMO5Gasl5twQ6uadcXbfnR0V3/JV3ZTaiw
        4vjKVRlbROQXO1uU/ahMnvh86lslluKMREMt5qLiRAB6DUg71gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsWy7bCSvG75lP4kgy8LdS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
        5RdvshX8FKvon/2dtYHxrGAXIyeHhICJxKMJn5lBbCGBHYwSG+7UdjFyAMWlJRauT4QoEZZY
        +e85excjF1BJM5PEhK/nWUASbALaEq/e3gDrFQEq2t/RygJSxCzQxSjR03mKCSQhLOAkce30
        UrAiFgFVia5Ls8FsXgEbiU2dlxghNshLrN5wgHkCI88CRoZVjJKpBcW56bnFhgVGeanlesWJ
        ucWleel6yfm5mxjBQaKltYNxz6oPeocYmTgYDzFKcDArifBeeNqbJMSbklhZlVqUH19UmpNa
        fIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVANTxc7yiKuSfB+DY/c/99iwd8WW1f37
        nm37sVs34x/XX/aLTAHr+f9+abzz/bnQo/ebHZhaNMNUWhfVRc/JS7B33HJQ+jiHxm6T64ee
        uCktYbh3vXvlNraFd0w4LnW/3ndy/m33fCn27v0iQtMf5pyIYlnRs6+2M2rJKY3veYp10g+Y
        WoVqlE6+en1jIV+uyp61Vo9y93Ivl32y2/7Aug1uQo239H+bH+ye8C5mjqPgY5f5e41O3p+0
        JnJeaf4+J7cjP5L2MHBoPQrxzphbXnny3n+36fE2rsViK38//Pr82489rHwH+tO+9NloMs4I
        kXoSULTyudG6cuVkTY+sS5OeRa+YWvj58Pcn8193r1zKuFSJpTgj0VCLuag4EQCm2WnjgQIA
        AA==
X-CMS-MailID: 20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c
References: <CGME20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patchset adds a new I/O engine (io_uring_cmd), which enables support for
io_uring passthrough commands. This work is based on upcoming 5.19 kernel.
https://git.kernel.dk/cgit/linux-block/log/?h=for-next

This engine will use most of the existing helpers from io_uring. The I/O
preparation, completion, file open, file close and post init paths are going to
differ and hence io_uring_cmd will have its own helpers for them.

The supported io_uring_cmd options are:
* registerfiles
* sqthread_poll
* sqthread_poll_cpu
* nonvectored
* force_async
* cmd_type (new)

The current uring passthrough support is present only with nvme-ns character
device (/dev/ngXnY). This includes both conventional as well as ZNS devices.
cmd_type provides the flexibility to support different types of passthrough
commands in future.

To enable support for nvme passthrough commands, we are adding nvme.c and
nvme.h files. These will have the necessary NVMe specification data
strcutures, opcodes and helper functions for sending admin and I/O passthrough
commands.

O_DIRECT flag support is not present with nvme-ns charatcer devices, hence
zbd will check for them only if fio filetype is a block device. The
t/zbd/test-zbd-support test case #1 is now updated to run only for
block device.

Changes since v1:
- Removed libnvme dependency.
- Addressed review comments from Jens, no longer messy CONFIG flags for the
  new engine.
- Addressed review comment from Shinichiro.

Ankit Kumar (5):
  configure: check nvme uring command support
  nvme: add nvme opcodes, structures and helper functions
  docs: document options for io_uring_cmd I/O engine
  zbd: Check for direct flag only if its block device
  engines/io_uring: Enable zone device support for io_uring_cmd I/O
    engine

Anuj Gupta (3):
  io_uring.h: add IORING_SETUP_SQE128 and IORING_SETUP_CQE32
  engines/io_uring: add new I/O engine for uring passthrough support
  examples: add 2 example job file for io_uring_cmd engine

 HOWTO.rst                    |  39 +++-
 Makefile                     |   4 +-
 configure                    |  21 +++
 engines/io_uring.c           | 336 +++++++++++++++++++++++++++++++++-
 engines/nvme.c               | 338 +++++++++++++++++++++++++++++++++++
 engines/nvme.h               | 204 +++++++++++++++++++++
 examples/uring-cmd-ng.fio    |  35 ++++
 examples/uring-cmd-zoned.fio |  40 +++++
 file.h                       |  12 +-
 fio.1                        |  28 ++-
 os/linux/io_uring.h          |  45 ++++-
 t/zbd/test-zbd-support       |   3 +-
 zbd.c                        |   4 +-
 13 files changed, 1080 insertions(+), 29 deletions(-)
 create mode 100644 engines/nvme.c
 create mode 100644 engines/nvme.h
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio


base-commit: 6f1a24593c227a4f392f454698aca20e95f0006c
-- 
2.17.1

