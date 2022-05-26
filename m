Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C6C433F5
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiEZQst (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348215AbiEZQsq (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:46 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD5B4EA31
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:44 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220526164843epoutp03ac73db8f29a5e658539d2a80a49df94a~ytaKXd_ep1259012590epoutp03c
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220526164843epoutp03ac73db8f29a5e658539d2a80a49df94a~ytaKXd_ep1259012590epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583723;
        bh=QM2YWd1PGOsLse8jVl2UH2Yqy/4zavHZ+9AIFopJDYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqonM6FcT2aRopRr0UNJyWHNOqTs5piBdjsBeIPl7xgPWai41mHXR0O5yCs2uiDme
         tF4zY1/6pPv1CMM7fAJmuG5D06/VDgK4TN/RGPuU2W6uQogDMHLZp58pm4XpGfnLoz
         QakAQ1xMRQaMnajlFukd1vW0sOEUvTQlhKcLv1cU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220526164842epcas5p1b72f6a418a401d2a05b023465dc9cf39~ytaJYvxOe1652716527epcas5p18;
        Thu, 26 May 2022 16:48:42 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L8DQv03JVz4x9Pp; Thu, 26 May
        2022 16:48:39 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.71.09762.66FAF826; Fri, 27 May 2022 01:48:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145406epcas5p255f21b413d5dd504ff415bb38577200b~yr2GJKwLj0963309633epcas5p2B;
        Thu, 26 May 2022 14:54:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220526145406epsmtrp27bf584fa6e6a76a80b0099d490238d1e~yr2GIjXox1477014770epsmtrp2v;
        Thu, 26 May 2022 14:54:06 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-0d-628faf66d651
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.4E.08924.E849F826; Thu, 26 May 2022 23:54:06 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145405epsmtip22d7eb0f4c8587505ed64835045c3d813~yr2FUAYYX1809618096epsmtip2H;
        Thu, 26 May 2022 14:54:05 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v2 8/8] examples: add 2 example job file for io_uring_cmd
 engine
Date:   Thu, 26 May 2022 20:18:09 +0530
Message-Id: <20220526144809.14877-9-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmhm7a+v4kg0ndFhZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzuhbKlHQLlpxbPUn9gbGk4JdjBwc
        EgImEhOPpnYxcnIICexmlJi9V7WLkQvI/sQocartCRuE85lRYt/T08wgVSAND08vYodI7GKU
        +DFjM5TTyiRxtWUaG0gVm4C2xKu3N8A6RASEJfZ3tLKA2MwCsRLPtzUwgdjCAkESF1ctAKtn
        EVCVmHX9MVg9r4CNxKSjH9khtslLrN5wACzOKWArce72DLCTJASWsUucX3SaCaLIRWLu3a9Q
        DcISr45vgbKlJD6/28sGYWdLND76C2WXSOy8tR3qHXuJi3v+MoHCgllAU2L9Ln2IsKzE1FPr
        mCBu5pPo/f0EahWvxI55MLaqxN97t1kgbGmJm++uQtkeEh9/32aChOkERomdc2omMMrNQtiw
        gJFxFaNkakFxbnpqsWmBcV5qOTzKkvNzNzGCk5SW9w7GRw8+6B1iZOJgPMQowcGsJMJ74Wlv
        khBvSmJlVWpRfnxRaU5q8SFGU2D4TWSWEk3OB6bJvJJ4QxNLAxMzMzMTS2MzQyVxXoH/jUlC
        AumJJanZqakFqUUwfUwcnFINTDan1x/7tsfDden085fOCYZ1Vi0UNyvrdIp5f+7neama8h1v
        f0dxBbVbTD0/KcheZ/5CTwGrvdNanfWWJNXLNzvuf/q64bOHb9/zmvbHG29V6WmyCYv4mXzm
        LlJtKzr/0uLCV1FBIfmDVtPL1OV3+t1InHLwmtZpyRVNsyz8J2Yyvj9YXxPvvM/l84R6NuFX
        k117z/f+SDmwOvfyxg8rFSQ2+/sv1rG1fjTNx/rWj5uqs00uKAUev2T7dNOy0JyN0WddVaVE
        jBlkNR794Nz51Ia9cFPS1VNL3Fcs5BFY82tp80HrTxPDcvQcM338TGduE7LgXhL853lic9vT
        a/uD3rSFu15b9MrSMfOY3cr+U0osxRmJhlrMRcWJAFFqWTHbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXrdvSn+SwcL1KhZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK6FsqUdAu
        WnFs9Sf2BsaTgl2MnBwSAiYSD08vYu9i5OIQEtjBKHFwxivWLkYOoIS0xML1iRA1whIr/z2H
        qmlmklh09A0zSIJNQFvi1dsbYLYIUNH+jlYWEJtZIFFix6RdjCC2sECAxKaPT9lAbBYBVYlZ
        1x+D1fMK2EhMOvqRHWKBvMTqDQfA4pwCthLnbs8AqxcCqvm37yLTBEa+BYwMqxglUwuKc9Nz
        iw0LjPJSy/WKE3OLS/PS9ZLzczcxggNJS2sH455VH/QOMTJxMB5ilOBgVhLhvfC0N0mINyWx
        siq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpu0xsa/ZHK9Hvtju
        9/iQ7JVrH7fcvbnm5sPPjx91qOouYF7F9u3Dgiap50q+51I1TKbHT3lg5m6t0ix88vP/kqXt
        +iZ+j8S5zjLNnrXr/wa+dENlq1vqRs9braJ+my0NfdPp9v1PFPO+P3G5sjcsktzPGJX+Y7Ow
        PiHgk1YvcHZFB88PHbHbWw7uv60Yf/FuZHzgFC39K7F+68rVU1gyvz/r/Nu49ejh7dv2V97c
        p6FgLmv8T59ndmG1xrXLLV8t7r4oEt158tRuqziX4pviGVWS0t/UXraLm2k/Z27d4qtcxMpu
        vkwh42X647Uyuz66LFDMe5Us1N3w1lxvgv1/TyPFu1MXsrtLVP5Td9j6WYmlOCPRUIu5qDgR
        ADBG9A+TAgAA
X-CMS-MailID: 20220526145406epcas5p255f21b413d5dd504ff415bb38577200b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145406epcas5p255f21b413d5dd504ff415bb38577200b
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145406epcas5p255f21b413d5dd504ff415bb38577200b@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

examples/uring-cmd-ng.fio has usage for conventional nvme-ns char device
examples/uring-cmd-zoned.fio has usage for ZNS nvme-ns char device

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Co-authored-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 examples/uring-cmd-ng.fio    | 35 +++++++++++++++++++++++++++++++
 examples/uring-cmd-zoned.fio | 40 ++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio

diff --git a/examples/uring-cmd-ng.fio b/examples/uring-cmd-ng.fio
new file mode 100644
index 00000000..db4292d3
--- /dev/null
+++ b/examples/uring-cmd-ng.fio
@@ -0,0 +1,35 @@
+; io_uring_cmd I/O engine for nvme-ns generic character device
+;
+; This job-file is intended to be used as:
+;
+; fio examples/uring-cmd-ng.fio \
+;   --section=default \
+;   --ioengine=io_uring_cmd \
+;   --sqthread_poll=1 \
+;   --cmd_type=nvme \
+;   --filename=/dev/ng0n1
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
+; FIO_BS="512" FIO_RW="write" FIO_IODEPTH=16 fio examples/uring-cmd-ng.fio \
+;   --section=override --ioengine=io_uring_cmd --cmd_type=nvme \
+;   --filename=/dev/ng0n1
+;
+[global]
+rw=randread
+size=12G
+iodepth=1
+bs=4K
+thread=1
+time_based=1
+runtime=7
+ramp_time=3
+norandommap=1
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
new file mode 100644
index 00000000..2649d2fe
--- /dev/null
+++ b/examples/uring-cmd-zoned.fio
@@ -0,0 +1,40 @@
+; io_uring_cmd I/O engine for nvme-ns generic zoned character device
+;
+; NOTE: with write workload iodepth must be set to 1 as there is no IO
+; scheduler.
+;
+; Writes 1GB at QD1 using 4K BS and verifies it.
+;
+; This job-file is intended to be used as:
+;
+; fio examples/uring-cmd-zoned.fio \
+;   --section=default \
+;   --ioengine=io_uring_cmd \
+;   --sqthread_poll=1 \
+;   --cmd_type=nvme \
+;   --filename=/dev/ng0n1
+;
+; NOTE: If you want to override the default bs, size and workload, then
+; invoke it as:
+;
+; FIO_BS="32k" FIO_RW="randwrite" FIO_SIZE="2G" fio \
+;   examples/uring-cmd-zoned.fio --section=override --ioengine=io_uring_cmd \
+;   --sqthread_poll=1 --cmd_type=nvme --filename=/dev/ng0n1
+;
+[global]
+zonemode=zbd
+rw=write
+size=1G
+iodepth=1
+bs=4K
+thread=1
+ramp_time=1
+norandommap=1
+verify=crc32c
+
+[default]
+
+[override]
+rw=${FIO_RW}
+size=${FIO_SIZE}
+bs=${FIO_BS}
-- 
2.17.1

