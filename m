Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAFDECAAD4
	for <fio@archiver.kernel.org>; Fri, 26 Aug 2022 11:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiHZLoc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbiHZLoa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Aug 2022 07:44:30 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7922D7CC8
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 04:44:28 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220826114425epoutp028819a1964125f07125fecea6009173ec~O4mv4yq4z2065920659epoutp02K
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 11:44:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220826114425epoutp028819a1964125f07125fecea6009173ec~O4mv4yq4z2065920659epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661514265;
        bh=04TdPAxVViW92Q5708gtsFSxBphS/k0YR/ACfD/h8Ww=;
        h=From:To:Cc:Subject:Date:References:From;
        b=YTXAhSnWTT9Z191xnWPD94tD5pNfG5wEaFQPbnfKaTVjRRLiWTHr8QdwBnS1QO35+
         vm6+m0Kb7M9Y++qcGNYbGdUUr8lp/ZhmdYxmHeB73kXT1f5H3FKkSu8/k/LTQKuS9A
         3ljM5vt7Y/HiFHScY2IAB/XOXpumdTGINKHwBKnI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220826114425epcas5p49953980d3a9fae21e4594cb2d54aa18f~O4mvkZq892501925019epcas5p4Z;
        Fri, 26 Aug 2022 11:44:25 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MDdKJ1Jz2z4x9Q0; Fri, 26 Aug
        2022 11:44:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.E6.53458.412B8036; Fri, 26 Aug 2022 20:44:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220826114305epcas5p4a5636b062f33534f75f0d907af31bc50~O4lldmaWj1948519485epcas5p4Q;
        Fri, 26 Aug 2022 11:43:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220826114305epsmtrp22b91b3d337cd2b036d34d6a525dcd337~O4llc52Rt2360523605epsmtrp2Z;
        Fri, 26 Aug 2022 11:43:05 +0000 (GMT)
X-AuditID: b6c32a4a-caffb7000000d0d2-69-6308b21478ad
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.88.18644.9C1B8036; Fri, 26 Aug 2022 20:43:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220826114304epsmtip238288252cbaf0b464ff691b2603eb0d9~O4lkhHWSO2750827508epsmtip2U;
        Fri, 26 Aug 2022 11:43:04 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 0/2] Add support for uring-passthrough in t/io_uring
Date:   Fri, 26 Aug 2022 17:03:04 +0530
Message-Id: <20220826113306.4139-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmlq7IJo5kg1v72C3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RldzcEFBwUrzvxb
        ydLA2M3fxcjJISFgIvHnezNjFyMXh5DAbkaJR9MnskE4nxglZp/fwQzhfGaU+PKkjRGmZeW/
        71BVuxglzrx4yQRXteDzGnaQKjYBdYkjz1uBOjg4RAQ0JNbcTQUJMwtkSbz8cYEVxBYWcJfY
        /2kRM4jNIqAq8WjGEbAFvAIWEudPTmeFWCYvMfPSd3aIuKDEyZlPWCDmyEs0b50Ndp2EwC52
        iUcvVkA1uEh03FjMDmELS7w6vgXKlpL4/G4vG4SdLvHj8lMmCLtAovnYPqjP7CVaT/Uzg9zM
        LKApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpJoXzkHypaQ2HuuAcr2kPizfjqYLSQQ
        K7F80362CYzys5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCUl1oOj9fk/NxNjOAEqOW1g/Hh
        gw96hxiZOBgPMUpwMCuJ8FodY0kW4k1JrKxKLcqPLyrNSS0+xGgKDOOJzFKiyfnAFJxXEm9o
        YmlgYmZmZmJpbGaoJM47RZsxWUggPbEkNTs1tSC1CKaPiYNTqoEpLPXVPTv/iIXKn1yZS+1n
        nFjlm75Ou+rlj+qk179+RXK+vGX24OPDQ59e2Cb0KyY9iP8eujMqTX76tsaLC88v52rTvs+U
        F5w648OHAi8JhqLEIMvFJY9OvPKZqhT49UDHgikTasVC09+pNOfMazvGnBR46prr3XWn/SqU
        AqKUZqqFK5vMe3F7k3VI8mp/Jv8Hs7i/udVo/7hwn/NL+sGJEqHhPhdij4hKNGQ/Wp326jvn
        txv92lvW/PxWoPTP8M/b1+U2xVOf1Noz7hIqiYk2WFrGLyrzha9C9qXEPUm+41bxTCY1SqUM
        1UuF1zq1bH5mN/FRo0Zv42S9lDWfpaazfHLerl70yvHQ6krNGhklluKMREMt5qLiRADq8aZE
        CQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsWy7bCSvO7JjRzJBne3WVisufKb3aJpwl9m
        i9V3+9ksPs56wWxx9P9bNosNbYIObB47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJSczLLUov0
        7RK4MrqagwsOClac+beSpYGxm7+LkZNDQsBEYuW/72wgtpDADkaJzTPjIeISEqdeLmOEsIWB
        ap6zdzFyAdV8ZJRYM+ErC0iCTUBd4sjzVrAiEQEtiWPrmsAGMQvkSXTdPQdWIyzgLrH/0yJm
        EJtFQFXi0YwjYPW8AhYS509OZ4VYIC8x89J3doi4oMTJmU9YIObISzRvnc08gZFvFpLULCSp
        BYxMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgkNRS2sH455VH/QOMTJxMB5ilOBg
        VhLhtTrGkizEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD
        0/bLO5bPttCKbzJ986x5yqz7/6x1TjmH7Z+RGrRpZZXXhsl2poq9ivv2PvJW0TR5vNAhgTVx
        YXft5RfXnjMt/by9mal/Kce3r/W56nlxQdd2TDrvaTr9xJyLRo6vCoxP/Qlln++eI/D+hpXi
        89Oa0+cxXHxZLMT5yLPjyuuijeE/Nsqb1txYIX9v4yzXtXG1Z6+rXAhTuRo9h6V4istylwSe
        o1LF1lezf/jem9KbY1dy/bros5Oll/R2dRwLmiTyupRLv3ZSqYDdGmndB083HOD0ZPNnX/PV
        fybn9JuXDoSbX7KSmsOqedOK7YSG3FL/yidPFphO9k6ak2Jc/YJF75BQ612nnX9kF+iZNXny
        z1ViKc5INNRiLipOBAA0SO/4tAIAAA==
X-CMS-MailID: 20220826114305epcas5p4a5636b062f33534f75f0d907af31bc50
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220826114305epcas5p4a5636b062f33534f75f0d907af31bc50
References: <CGME20220826114305epcas5p4a5636b062f33534f75f0d907af31bc50@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This series adds support for measuring peak performance of uring-passthrough path
using t/io_uring utility. Added new -u1 option, that makes t/io_uring to do io using
nvme passthrough commands.

Uring-passthrough on nvme-generic device:

root@test-MS-7C34:/home/test/upstream/github/fio# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=5415, file=/dev/ng0n1, node=-1
polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=1.97M, BW=959MiB/s, IOS/call=32/31
IOPS=1.96M, BW=956MiB/s, IOS/call=32/32
IOPS=1.96M, BW=957MiB/s, IOS/call=32/32
IOPS=1.96M, BW=956MiB/s, IOS/call=31/31
^CExiting on signal
Maximum IOPS=1.97M

Regular io_uring on nvme-block device:

root@test-MS-7C34:/home/test/upstream/github/fio# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -n1 /dev/nvme0n1
submitter=0, tid=5418, file=/dev/nvme0n1, node=-1
polled=0, fixedbufs=0/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=1.53M, BW=748MiB/s, IOS/call=32/31
IOPS=1.53M, BW=746MiB/s, IOS/call=32/32
IOPS=1.53M, BW=746MiB/s, IOS/call=32/32
IOPS=1.53M, BW=745MiB/s, IOS/call=32/32
IOPS=1.53M, BW=745MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=1.53M

Changes since v1:
https://lore.kernel.org/fio/20220824093109.308791-1-anuj20.g@samsung.com/T/#m17c6dcf1a3989a74865ceee0b87f470716aa5711

Use shift instead of expensive integer divisions (Jens)
Put expensive nvme_uring_cmd initialization part in setup rather than having it in fast path (Jens)
Create separate init_io_pt and reap_events_uring_pt functions for initializing i/o and reaping completions for passthru path(Jens)
Put nsid and lba_shift a part of struct file (Jens)

Add check for polled i/o for passthru case during failure (Kanchan)
Check (bs % lbs) instead of (bs < lbs) (Kanchan)

Fix index calculation for cqe during passthru i/o

Anuj Gupta (2):
  t/io_uring: prep for including engines/nvme.h in t/io_uring
  t/io_uring: add support for async-passthru

 t/io_uring.c | 256 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 239 insertions(+), 17 deletions(-)

-- 
2.25.1

