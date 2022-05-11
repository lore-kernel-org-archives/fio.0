Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69565C433F5
	for <fio@archiver.kernel.org>; Wed, 11 May 2022 19:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244322AbiEKTMk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 May 2022 15:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346660AbiEKTMg (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 May 2022 15:12:36 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26707357A
        for <fio@vger.kernel.org>; Wed, 11 May 2022 12:12:32 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220511191228epoutp0439e3bead98d0f4a57ded3b2c38380f36~uIsZjNswy3267932679epoutp04e
        for <fio@vger.kernel.org>; Wed, 11 May 2022 19:12:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220511191228epoutp0439e3bead98d0f4a57ded3b2c38380f36~uIsZjNswy3267932679epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652296348;
        bh=OuWX4oDXY/YHPZgpQFVFVPjtjwlNA82gC8dBqC319Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeT3KlxvPedoAp3GwKNPh1XTaf5d0FxpNo2it+O8RydAobhWK0X1+8Ku/KzVE1iIa
         daSlPxh8ns5WfcH8k6qphIbKBkbUUlfeHb2LFydxHavfSthW7OoO3YMSg9wrD9A88q
         uAHTs5ttuKhrG5wI1IZZwzelrH2Cww9iVFu0pQRs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220511191228epcas5p4f0f8914e3d19f13342ac1aaa9f3a0a9f~uIsZGVY_M1826218262epcas5p4B;
        Wed, 11 May 2022 19:12:28 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Kz4Kj3wj1z4x9Pp; Wed, 11 May
        2022 19:12:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        82.EF.10063.99A0C726; Thu, 12 May 2022 04:12:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220511163600epcas5p23c957325fc8fb7cd935900b02c3cd73f~uGjyZvufw1388413884epcas5p22;
        Wed, 11 May 2022 16:36:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511163600epsmtrp127e7cb07b7da3636f7e76039fad9b765~uGjyZGZsE2080420804epsmtrp1D;
        Wed, 11 May 2022 16:36:00 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-60-627c0a997b32
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.D6.11276.0F5EB726; Thu, 12 May 2022 01:36:00 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220511163559epsmtip28810ed589bacb2c27df61d1bfa5817db~uGjxg7A7k3224432244epsmtip2v;
        Wed, 11 May 2022 16:35:59 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 3/3] examples: add example job file for xnvme engine usage
Date:   Wed, 11 May 2022 22:00:19 +0530
Message-Id: <20220511163019.5608-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220511163019.5608-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsWy7bCmuu5Mrpokg+ZfkhZrrvxmt1h9t5/N
        4uOsF8wWCzcuY7K42z2D3YHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzpg48wtTwUK1ioftP9kaGOfLdzFy
        ckgImEhMuLyLsYuRi0NIYDejxPvLC9ghnE+MEk+nvGUCqRIS+MYosX6fA0zH1nvdLBBFexkl
        JvSsY4NwWpkkji48zwxSxSagLfHq7Q0wW0RAWGJ/RysLiM0sUCix9U4/I4gtLOAl8ezKU1YQ
        m0VAVWJS7zc2EJtXwFpid38bC8Q2eYnVGw6AzeEUsJHobV7JDLJMQmAVu0Rrxzp2iCIXiZnX
        9kM1CEu8Or4FKi4l8bK/DcrOlmh89JcNwi6R2HlrOzOEbS9xcc9foDc5gI7TlFi/Sx8iLCsx
        9dQ6Joib+SR6fz9hgojzSuyYB2OrSvy9dxtqrbTEzXdXoWwPiS/vXzFBAqWfUWLvvoUsExjl
        ZiGsWMDIuIpRMrWgODc9tdi0wDAvtRwea8n5uZsYwalKy3MH490HH/QOMTJxMB5ilOBgVhLh
        3d9XkSTEm5JYWZValB9fVJqTWnyI0RQYgBOZpUST84HJMq8k3tDE0sDEzMzMxNLYzFBJnPd0
        +oZEIYH0xJLU7NTUgtQimD4mDk6pBqaaBRuvL2cPLJH4k/nqLf/cD1MNJsXf+mQ8+cPEcKYp
        mzZnT/FqK/8448XBW9zXNpa+mSBqOGHZlue+McKGD0NXJd/m8JFi5DihEb2uNGDKJsPOmXNX
        /HFI2jwrI37SSdd8GeeofLHdbkcNrac+XjHp9gTXrvXmiqdCNLbILrZYdZ3f49YXP+5JPtc3
        PZ0pqNcj89D00ioDbf+1bcx/1FdIv3x/OEC+YUbXz+ubHQ5WfNx57eiJyu/3rKaZ1Sz4m7T1
        0tQKoTW1iRv3i32U3pnzy1rFtvt8Ye9MldV/En76yuq+u+E67VSxcczj+NqQfd/TffZuZmPS
        kpv4m7fwndjyoze2bdcq3GGTzPuqacIcQyWW4oxEQy3mouJEAJ+iwOneAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXvfD0+okg75v+hZrrvxmt1h9t5/N
        4uOsF8wWCzcuY7K42z2D3YHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKmDjzC1PB
        QrWKh+0/2RoY58t3MXJySAiYSGy9180CYgsJ7GaUaDns38XIARSXlli4PhGiRFhi5b/n7F2M
        XEAlzUwSCw40sYIk2AS0JV69vcEMYosAFe3vaAWbwyxQKtH0cRUbiC0s4CXx7MpTsHoWAVWJ
        Sb3fwOK8AtYSu/vbWCAWyEus3nAAbA6ngI1Eb/NKZoh7rCVO/1rEPoGRbwEjwypGydSC4tz0
        3GLDAsO81HK94sTc4tK8dL3k/NxNjOBA0tLcwbh91Qe9Q4xMHIyHGCU4mJVEePf3VSQJ8aYk
        VlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwMQ4s/XYkZBpuhIP
        Vkev1G/f8SDrV8xe7VUdZ8/EShu65O2wOrzVefHKxM2Pmh7o+6/Z/MzjYWRQ3eP8h0YzeDqT
        BHSDm188ld+4e5KAQBJjus1Li40rdLQ/SAZ9DtbwMTR3z0zZLzepYDej5wImW5N5227Ze35M
        TKkXLvqtO485Vbxeueyt5FVFhokl/L4nd8Wen9L3zews+3eRAzrFH0+Vabu/uCBf2GB7cdal
        J1oHD3DFsG24MntWysYrr+S+ZC/8N3NjnZRB1twAu68cf1hvayx9aGclzhjE4XdqR2xHYOGL
        GqGS4Ce7NvjMYkvk6X29d5u0lcnRDdt+V362vaiyNqild72/1Fef6cY3HyixFGckGmoxFxUn
        AgAxVn9gkwIAAA==
X-CMS-MailID: 20220511163600epcas5p23c957325fc8fb7cd935900b02c3cd73f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511163600epcas5p23c957325fc8fb7cd935900b02c3cd73f
References: <20220511163019.5608-1-ankit.kumar@samsung.com>
        <CGME20220511163600epcas5p23c957325fc8fb7cd935900b02c3cd73f@epcas5p2.samsung.com>
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

