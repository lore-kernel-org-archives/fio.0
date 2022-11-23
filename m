Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C270C433FE
	for <fio@archiver.kernel.org>; Wed, 23 Nov 2022 12:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbiKWMOk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiKWMOa (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Nov 2022 07:14:30 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D1F2C13F
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 04:14:12 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221123121410epoutp0467fcc4cf35d4fb41344618aff96a47ad~qNbIHG_1g1746917469epoutp04_
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 12:14:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221123121410epoutp0467fcc4cf35d4fb41344618aff96a47ad~qNbIHG_1g1746917469epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669205650;
        bh=WGDwsbpPKGk8dwLQQKV2ujSzvWdFdZh/C3keaFVBfGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USmveY85JFNxLsSu1FkCnnnDfEynYLkNsfKEJh0PYQ+7MzZvBjrwOmcuo+CAFep+1
         fmdspfMBry6ymsRa4tl+VkPXwhoYdprpDmM5qgfmBw0EP80V/oHRIEbVzUJo8Vj/ve
         pJ/uxVrqkzo+p/Ww1tjwSywz5ceFTScdDx8wxJbw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221123121409epcas5p398aa5ab9a209277caf39cc683ff03e62~qNbHhDEaO0081800818epcas5p37;
        Wed, 23 Nov 2022 12:14:09 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NHKmb5hmdz4x9Pw; Wed, 23 Nov
        2022 12:14:07 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.4C.56352.E8E0E736; Wed, 23 Nov 2022 21:14:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221123113913epcas5p16b5d461d117f374cc0df83ae60104900~qM8m1Ckq32089320893epcas5p1Q;
        Wed, 23 Nov 2022 11:39:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221123113913epsmtrp22234f2eb19bccb1b57c54dce0681ccca~qM8m0fo7W0414004140epsmtrp2p;
        Wed, 23 Nov 2022 11:39:13 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-04-637e0e8edc00
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.DC.14392.1660E736; Wed, 23 Nov 2022 20:39:13 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221123113912epsmtip1a18274f6f9e08c99268911e5616babd3~qM8mF91Lf2285822858epsmtip1w;
        Wed, 23 Nov 2022 11:39:12 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 2/2] doc: update about sqthread_poll
Date:   Wed, 23 Nov 2022 16:57:38 +0530
Message-Id: <20221123112738.24820-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221123112738.24820-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmhm4fX12ywbT1HBZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnbJx5i6VgG2/Fl+sNzA2M17m6GDk5
        JARMJJ4vnsPWxcjFISSwm1Fiy4bP7BDOJ0aJI7fusYBUCQl8Y5S4dFIKpuPY2iOMEPG9jBKz
        plVBNLQySWz8O58ZJMEmoC3x6u0NMFtEQFhif0cr2CBmgVCJk9e+sIPYwgLmEidfXWMFsVkE
        VCXmbZsAVs8rYCNxf/syJohl8hKrNxwAi3MK2EpMmveVFWSZhMAydolbm8+wQRS5SEy7f4Ad
        whaWeHV8C5QtJfH53V6ommyJTQ9/Qg0tkDjyopcZwraXaD3VD2RzAB2nKbF+lz5EWFZi6ql1
        TBA380n0/n4C1corsWMejK0q8ffebRYIW1ri5rurULaHxITrH6ABNAEYiq/sJjDKzULYsICR
        cRWjZGpBcW56arFpgXFeajk8zpLzczcxgpOUlvcOxkcPPugdYmTiYDzEKMHBrCTCW+9ZkyzE
        m5JYWZValB9fVJqTWnyI0RQYfhOZpUST84FpMq8k3tDE0sDEzMzMxNLYzFBJnHfxDK1kIYH0
        xJLU7NTUgtQimD4mDk6pBqZpL3Oar2xw710R9GcWe9D5JA/e7FMPVPxlk6OvCT1P4ZG4K7Q4
        aco0jaRjtzgPphx+2XLfj/fmKll242XH1kufkHjbuupUgPunVz9/WM8x5tuiclri/IQ+p8+y
        phLfY551rdixV8LzalT4WYuofu8tu3aKfC25Jfe5aeLs2/73BW+3RfZZ/bXriLXPipxTFpR+
        Pq2+qVx8Z93+FxNV6z55/xSXnsrhqPH9e9+zHwzP+F/OWZTca3LVWa97m/HG1phNHxfW7j93
        L/R4K08pw7vtEmlB2ke9fURdnQK4D6XVnVQyDCnRMN3nvbx+WVaEwbmm67/sZjnmrZy7bpHd
        Mw+D0+d8pRpWzf38IuWL0jwlluKMREMt5qLiRABXr7Es2wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJTjeRrS7ZYMJdHos1V36zW6y+289m
        8XHWC2aLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDI2zrzFUrCN
        t+LL9QbmBsbrXF2MnBwSAiYSx9YeYexi5OIQEtjNKLHiyCrmLkYOoIS0xML1iRA1whIr/z1n
        h6hpZpL4+mAiK0iCTUBb4tXbG8wgtghQ0f6OVhYQm1kgXGL6gcmMILawgLnEyVfXwOpZBFQl
        5m2bAFbPK2AjcX/7MiaIBfISqzccAItzCthKTJr3FaxeCKjm25ItbBMY+RYwMqxilEwtKM5N
        zy02LDDMSy3XK07MLS7NS9dLzs/dxAgOJC3NHYzbV33QO8TIxMF4iFGCg1lJhLfesyZZiDcl
        sbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqbz5vO96rJVGC78
        stvCv6c/RcrIonfBTqNvhgEpp1LKGrWf3dd459WROc1yU4OH4on5Gz21oqZ+SyieuunStJgn
        35Q8uY4t+7hPWkJEK1S2T4unn/tBoKFTEZOTxjleqVCrfPtFAsHxOe8dJr46ucdsIm/v0vme
        p0ysLA/lVNe6lm6y3GZ9LfRSxNLz076G6k70Lo38c+5kS1dd/ZOvv74VF8/mvsq/wSIm0c99
        +xpDTb3kLZU7Lu4UD3Wd+WklT67/XxV1LjNB5xtiTyVUCgyl657P0rX8Xvt1C+8aBY2F6546
        nc+U2vAvUG/7t6vb5MV8r//VfSC76deC4oBFp+dsSExwfM/pUGPWM5lvjxJLcUaioRZzUXEi
        AAcZA/WTAgAA
X-CMS-MailID: 20221123113913epcas5p16b5d461d117f374cc0df83ae60104900
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123113913epcas5p16b5d461d117f374cc0df83ae60104900
References: <20221123112738.24820-1-ankit.kumar@samsung.com>
        <CGME20221123113913epcas5p16b5d461d117f374cc0df83ae60104900@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update that when sqthread_poll is enabled fio will not report submission
latency.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 4 +++-
 fio.1     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index e796f961..5f8a8466 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2299,7 +2299,9 @@ with the caveat that when used on the command line, they must come after the
 	kernel of available items in the SQ ring. If this option is set, the
 	act of submitting IO will be done by a polling thread in the kernel.
 	This frees up cycles for fio, at the cost of using more CPU in the
-	system.
+	system. As submission is just the time it takes to fill in the sqe
+	entries and any syscall required to wake up the idle kernel thread,
+	fio will not report submission latencies.
 
 .. option:: sqthread_poll_cpu=int : [io_uring] [io_uring_cmd]
 
diff --git a/fio.1 b/fio.1
index 9e33c9e1..a156bf5d 100644
--- a/fio.1
+++ b/fio.1
@@ -2090,7 +2090,9 @@ sqthread_poll option.
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
-the cost of using more CPU in the system.
+the cost of using more CPU in the system. As submission is just the time it
+takes to fill in the sqe entries and any syscall required to wake up the idle
+kernel thread, fio will not report submission latencies.
 .TP
 .BI (io_uring,io_uring_cmd)sqthread_poll_cpu \fR=\fPint
 When `sqthread_poll` is set, this option provides a way to define which CPU
-- 
2.17.1

