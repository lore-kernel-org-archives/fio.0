Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349B5C433EF
	for <fio@archiver.kernel.org>; Thu,  5 May 2022 13:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbiEEOBO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 5 May 2022 10:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359536AbiEEOBM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 May 2022 10:01:12 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2211056C33
        for <fio@vger.kernel.org>; Thu,  5 May 2022 06:57:32 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220505135730epoutp03a00a1e3c17957ed6f53649daa81b1d86~sOhrQfyVy1330213302epoutp03L
        for <fio@vger.kernel.org>; Thu,  5 May 2022 13:57:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220505135730epoutp03a00a1e3c17957ed6f53649daa81b1d86~sOhrQfyVy1330213302epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651759050;
        bh=OuWX4oDXY/YHPZgpQFVFVPjtjwlNA82gC8dBqC319Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azJlMcZrW37MNOgglkFE6tPYsPwAa/VDt4YDcTiRhJl3cseGhyx+Ey9F1RICWw18k
         9m3TMDGeuMuLFVL8DmHFE96JzNDiqvf8YgillXMZCbi8ZV3FV72EwxACfiVwLgIB7f
         OzG8lqcCvSM/CwauqOQIL+kN8zVDsTSTc8QU5FNc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220505135729epcas5p3b9a9dee4585eb0e49473bd88adfba539~sOhq4REpk1331313313epcas5p38;
        Thu,  5 May 2022 13:57:29 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KvFd33jB7z4x9Pq; Thu,  5 May
        2022 13:57:27 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.09.09762.7C7D3726; Thu,  5 May 2022 22:57:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220505132546epcas5p331f666cadd5c7e788d27d09b144e0b8a~sOF_TUPRy1413414134epcas5p3l;
        Thu,  5 May 2022 13:25:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505132546epsmtrp11a7da2959191dbd2a285a120808691a6~sOF_Sngl_0694906949epsmtrp1Q;
        Thu,  5 May 2022 13:25:46 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-20-6273d7c75263
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.A3.08924.A50D3726; Thu,  5 May 2022 22:25:46 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505132545epsmtip29677b9e4738b1ce0387a892d3c944771~sOF9Xv08B0591605916epsmtip2J;
        Thu,  5 May 2022 13:25:45 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 3/3] examples: add example job file for xnvme engine usage
Date:   Thu,  5 May 2022 18:49:35 +0530
Message-Id: <20220505131935.32076-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220505131935.32076-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmuu7x68VJBqt62CzWXPnNbrH6bj+b
        xcdZL5gtFm5cxmRxt3sGuwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnTFx5hemgoVqFQ/bf7I1MM6X72Lk
        4JAQMJG4tMe4i5GLQ0hgN6PEna3/2CGcT4wSv69fZ4NwPjNKvOucDOSwg3XcSYQI72KUmL/m
        JiOE08oksX36KiCHk4NNQFvi1dsbzCC2iICwxP6OVhYQm1mgUGLrnX6wGmEBL4lnV56ygtgs
        AqoSN9ecBbN5BWwkLsw7DFYvISAvsXrDAbA5nAK2Ek+OLWQBWSYhsIpd4vqpC0wQRS4SK58v
        gWoQlnh1fAs7hC0l8bK/DcrOlmh89JcNwi6R2HlrOzOEbS9xcc9fJlBQMAtoSqzfpQ8RlpWY
        emodE8TNfBK9v59AreKV2DEPxlaV+HvvNtRaaYmb765C2R4S288sZYEEygRGiT8zTjNNYJSb
        hbBiASPjKkbJ1ILi3PTUYtMC47zUcnicJefnbmIEpykt7x2Mjx580DvEyMTBeIhRgoNZSYTX
        eWlBkhBvSmJlVWpRfnxRaU5q8SFGU2AATmSWEk3OBybKvJJ4QxNLAxMzMzMTS2MzQyVx3lPp
        GxKFBNITS1KzU1MLUotg+pg4OKUamKp0RByXftTorb0ZtKxbWHep1AW9XWccLS/84tl34s3E
        X3K1fddfH/t8tqmrX1rf47X45GmOjobC/6virP6t88g+pnmeLc77BW9gtMXJZ101TtZF67Pc
        J0y5PCHd5cRBg7LbdiLX1qp2zH5xPOKd8imDhMCijqgcVpHvi9T03Dau7vjb8nEX+6/E+s43
        DEWnZGL+qUVm3bst8mrf7G17Q8QC9Cc67T2zX7xiV2HfsfYo2d1C924/VLl58LY64wb2WumD
        TR7xj/Yfm/6mgCEv61295IoWbcWjXhdqpt1WjHlQcrLg7yXDpR/Eqp65TDg6LUvq0PXEqUb/
        lyapxZWxR15gmVc4d3LcydxDKwqPlCuxFGckGmoxFxUnAgD2BdR83AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvG7UheIkg75pIhZrrvxmt1h9t5/N
        4uOsF8wWCzcuY7K42z2D3YHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKmDjzC1PB
        QrWKh+0/2RoY58t3MbJzSAiYSNxJ7GLk4hAS2MEosWbPc9YuRg6gsLTEwvVAcU4gU1hi5b/n
        7BA1zUwST5bfZAVJsAloS7x6e4MZxBYBKtrf0coCYjMLlEo0fVzFBmILC3hJPLvyFKyeRUBV
        4uaas2A2r4CNxIV5h1kgFshLrN5wAGwOp4CtxJNjC8HiQkA1Z3tOME9g5FvAyLCKUTK1oDg3
        PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4jLS0djDuWfVB7xAjEwfjIUYJDmYlEV7npQVJQrwp
        iZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCtKl1lHmXVUbOl
        vcJzrjPLx0dn8nP9zLoesmjWBGvzrPE4fftv6P7ZjHsdJu1nC3a7qKvreNcx0fal4PvuZrvW
        Z0dl0na86Pb5ujCB+aTlcleDhLff9d6cOFS596rcm8vXaxMEmKXuN01ZHbVQvFjut/ClqqOL
        v/68nra4fLPzxWMt/3Ze1VXcfrDuqPSX6OBzOg3/o+ax/ZJk0Xl8OyTrobOO5E7vyd1LtFSD
        BKZoFKgUX7eO4nU8bJhvLRH7Zu+5NR3n++t7kt/dTHwgJqRhscFLnZN1QnC/qEeWBKPKxhiP
        QF2Hf4/ZZL78Mv0V/SnW4+8slls/T4W5zzhlHHQ9pW+SyE89kwSnhqU7JyqxFGckGmoxFxUn
        AgBJLb6CkgIAAA==
X-CMS-MailID: 20220505132546epcas5p331f666cadd5c7e788d27d09b144e0b8a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505132546epcas5p331f666cadd5c7e788d27d09b144e0b8a
References: <20220505131935.32076-1-ankit.kumar@samsung.com>
        <CGME20220505132546epcas5p331f666cadd5c7e788d27d09b144e0b8a@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Co-Authored-By: Ankit Kumar <ankit.kumar@samsung.com>
Co-Authored-By: Simon A. F. Lund <simon.lund@samsung.com>
---
 examples/xnvme-compare.fio | 72 +++++++++++++++++++++++++++++++
 examples/xnvme-zoned.fio   | 87 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)
 create mode 100644 examples/xnvme-compare.fio
 create mode 100644 examples/xnvme-zoned.fio

diff --git a/examples/xnvme-compare.fio b/examples/xnvme-compare.fio
new file mode 100644
index 00000000..b89dfdf4
--- /dev/null
+++ b/examples/xnvme-compare.fio
@@ -0,0 +1,72 @@
+; Compare fio IO engines with a random-read workload using BS=4k at QD=1
+;
+; README
+;
+; This job-file is intended to be used as:
+;
+; # Use the built-in io_uring engine to get baseline numbers
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=io_uring \
+;   --sqthread_poll=1 \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and io_uring async. impl.
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --sqthread_poll=1 \
+;   --xnvme_async=io_uring \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and libaio async. impl.
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_async=libaio \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_dev_nsid=1 \
+;   --filename=0000\\:01\\:00.0
+;
+; NOTE: The URI encoded in the filename above, the ":" must be escaped.
+;
+; On the command-line using two "\\":
+;
+; --filename=0000\\:01\\:00.0
+;
+; Within a fio-script using a single "\":
+;
+; filename=0000\:01\:00.0
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
+; FIO_BS="512" FIO_RW="verify" FIO_IODEPTH=16 fio examples/xnvme-compare.fio \
+;   --section=override
+;
+[global]
+rw=randread
+size=12G
+iodepth=1
+bs=4K
+direct=1
+thread=1
+time_based=1
+runtime=7
+ramp_time=3
+norandommap=1
+
+; Avoid accidentally creating device files; e.g. "/dev/nvme0n1", "/dev/nullb0"
+allow_file_create=0
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/examples/xnvme-zoned.fio b/examples/xnvme-zoned.fio
new file mode 100644
index 00000000..1344f9a1
--- /dev/null
+++ b/examples/xnvme-zoned.fio
@@ -0,0 +1,87 @@
+; Running xNVMe/fio on a Zoned Device
+;
+; Writes 1GB at QD1 using 4K BS and verifies it.
+;
+; README
+;
+; This job-file is intended to be used as:
+;
+; # Use the built-in io_uring engine to get baseline numbers
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=io_uring \
+;   --sqthread_poll=1 \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and io_uring async. impl.
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --sqthread_poll=1 \
+;   --xnvme_async=io_uring \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and libaio async. impl.
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_async=libaio \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_dev_nsid=1 \
+;   --filename=0000\\:01\\:00.0
+;
+; NOTE: The URI encoded in the filename above, the ":" must be escaped.
+;
+; On the command-line using two "\\":
+;
+; --filename=0000\\:01\\:00.0
+;
+; Within a fio-script using a single "\":
+;
+; filename=0000\:01\:00.0
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
+; FIO_BS="512" FIO_RW="verify" FIO_IODEPTH=16 fio examples/xnvme-zoned.fio \
+;   --section=override
+;
+; To reset all zones on the device to EMPTY state aka. wipe the entire device.
+;
+; # zoned mgmt-reset /dev/nvme0n2 --slba 0x0 --all
+;
+[global]
+zonemode=zbd
+rw=write
+size=1G
+iodepth=1
+bs=4K
+direct=1
+thread=1
+ramp_time=1
+norandommap=1
+verify=crc32c
+; Avoid accidentally creating device files; e.g. "/dev/nvme0n1", "/dev/nullb0"
+allow_file_create=0
+;
+; NOTE: If fio complains about zone-size, then run:
+;
+; # zoned info /dev/nvme0n1
+;
+; The command will provide the values you need, then in the fio-script define:
+;
+; zonesize=nsect * nbytes
+;
+;zonesize=
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
-- 
2.17.1

