Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7C0C4332F
	for <fio@archiver.kernel.org>; Wed, 23 Nov 2022 12:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiKWMO3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiKWMOQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Nov 2022 07:14:16 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E171924F2B
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 04:14:02 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221123121401epoutp04560ea0444a290c26a15cc4e80f322fbe~qNa-kgk6T1846018460epoutp04O
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 12:14:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221123121401epoutp04560ea0444a290c26a15cc4e80f322fbe~qNa-kgk6T1846018460epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669205641;
        bh=3x6gB51A1ZcKCql9fWP7tfn7DGWopIYoVNR9DjpOiBM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=MRLDug5W1cif9UMIf0jhomvUR4omXZC3d30naggpwTWg/DiTBxF9LcQA2ca83QeSG
         xhHGjCl5zk7Y2EntXZ263ifrljoCrrJUK7+hXgp6IiXQZ7M4FUbxB5ciwPQfnYDsz2
         gsjWZM9V4394os+/lwK8sDKV2UEeRPacx8WNGc40=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221123121400epcas5p4183f9705bba611d9791c43610c457568~qNa_9_xB51482814828epcas5p4A;
        Wed, 23 Nov 2022 12:14:00 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NHKmR2B6Gz4x9Pv; Wed, 23 Nov
        2022 12:13:59 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.45.39477.78E0E736; Wed, 23 Nov 2022 21:13:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221123113911epcas5p198248dd58155d554974c3221d843271d~qM8lJtjVF2089320893epcas5p1P;
        Wed, 23 Nov 2022 11:39:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221123113911epsmtrp1066e50ad1c31df29dc692969767328f9~qM8lJJkPB2031420314epsmtrp1o;
        Wed, 23 Nov 2022 11:39:11 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-a3-637e0e87c593
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.DC.14392.F560E736; Wed, 23 Nov 2022 20:39:11 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221123113910epsmtip1ff859b4e10921bd32ff021b3698dce46~qM8kMdZe22228622286epsmtip1_;
        Wed, 23 Nov 2022 11:39:10 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/2] fix clat reporting with sqthread poll
Date:   Wed, 23 Nov 2022 16:57:36 +0530
Message-Id: <20221123112738.24820-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmum47X12ywbU3/BZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnbHzwhr1gnUDF9v5OxgbGTzxdjJwc
        EgImErtfdDN1MXJxCAnsZpTYOKmXFcL5xCgxo307O4TzjVHi8/71jDAtkxbfhErsZZQ4NHkX
        M4TTyiTRsPoMO0gVm4C2xKu3N5hBbBEBYYn9Ha0sIDazQKjEyWtfwGqEBWwleg43s4HYLAKq
        ElNffmMFsXkFbCT2n3zJDrFNXmL1hgNgCyQE2tklmluuADVwADkuEms/F0HUCEu8Or4Fql5K
        4mV/G5SdLbHp4U8mCLtA4siLXmYI216i9VQ/M8gYZgFNifW79CHCshJTT61jgjiTT6L39xOo
        Vl6JHfNgbFWJv/dus0DY0hI3312Fsj0krqy4AzZeSCBW4u6suYwTGGVnIWxYwMi4ilEytaA4
        Nz212LTAKC+1HB5Ryfm5mxjB6UjLawfjwwcf9A4xMnEwHmKU4GBWEuGt96xJFuJNSaysSi3K
        jy8qzUktPsRoCgyyicxSosn5wISYVxJvaGJpYGJmZmZiaWxmqCTOu3iGVrKQQHpiSWp2ampB
        ahFMHxMHp1QDU3lDzy9vH34Gvh39KRIcJa5Pb26/Geq09NaFT9YPTHes7Q5I2HOyqf7Q5dQ9
        267FFlRHqpauf9CzJS1FYns7O9dOufUHxLfbtLPLGdeelvmhNevaVe6H4vWfOLLUE/aFTqzQ
        fzHPVsPq9sYjbreLXvRdmJEXecb9xulGXQ2Tq5fO6wcmdAY6xM/h8Od69PDBlqvLVxYf8BTy
        Ftpp1/iAW81ont7D2V+vzC/oF7gy/d+hmBdengunHJV4HzD7Wsy77gezmcxCbbz0D8yINtx3
        4SPXreU/Nh4S2MT+uPWRf6sjG+PphTn69/Z4Cc3tcGOzP1J1bvFKxVU3pic4rlRoLmR2lJeK
        mVc3s9f4wq8zPUosxRmJhlrMRcWJANJIn2rQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsWy7bCSnG48W12ywaLb0hZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVsfPCGvWCd
        QMX2/k7GBsZPPF2MnBwSAiYSkxbfZAexhQR2M0q8nJHVxcgBFJeWWLg+EaJEWGLlv+dQJc1M
        Egc++IDYbALaEq/e3mAGsUWAavZ3tLKA2MwC4RLTD0xmBLGFBWwleg43s4HYLAKqElNffmMF
        sXkFbCT2n3zJDjFfXmL1hgPMExh5FjAyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93E
        CA4KLc0djNtXfdA7xMjEwXiIUYKDWUmEt96zJlmINyWxsiq1KD++qDQntfgQozQHi5I474Wu
        k/FCAumJJanZqakFqUUwWSYOTqkGpn1WWhf9zE51/K0Kcn7SMfX/2ifv17p5MlYKRfzySP1s
        vLYyM6H/9Z8zS8t/OX+ZoOz0OTzdZAfH3r1twTM6Hxl/1o1l++Iaa6DXGj5fYsO92pSdVlOP
        Hkn6c/SjUdR0ERm251W1kU7TPs1R4H24WbJxXezs6t8FFzoy+tczv2pYetjjq0ifdue53JcW
        fy6ZZH1eNn3pK5/8liIPXsHSovQ6FodFrD/dXAOzSnwX2/g9YJn5Vm9W0j5/1h0BJqkd9Qmr
        i1cs+ecWPE3CoD8qtPly/WTd7Uk8Otx8cnufF+d+m+lq8NwjJfJzHpdW2WM16+2Mn30duC2E
        ZC/nCF1xeRtjmL5M4/Nhg33Pg9iVWIozEg21mIuKEwE1meV9eQIAAA==
X-CMS-MailID: 20221123113911epcas5p198248dd58155d554974c3221d843271d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123113911epcas5p198248dd58155d554974c3221d843271d
References: <CGME20221123113911epcas5p198248dd58155d554974c3221d843271d@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When sqthread_poll is specified for io_uring and io_uring_cmd I/O
engines, fio reports garbage value for completion latencies. This is
because the issue time was not recorded. This adds a change for that.
As the submission latency for sqthread poll is really just
the time it takes to fill in the SQ ring entries and any syscall
required to wake up the idle kernel thread. So there is really no need
to report those.

Also Updated the documentation to reflect the changes.

FIO command used to test:
fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1

Latencies reported before the change:
    clat (msec): min=7543.5k, max=7543.5k, avg=7543493.06, stdev= 8.30
     lat (usec): min=104, max=5070, avg=131.54, stdev=309.92
    clat percentiles (msec):
     |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113], 20.00th=[17113],
     | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113], 60.00th=[17113],
     | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113], 95.00th=[17113],
     | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
     | 99.99th=[17113]
  lat (msec)   : >=2000=100.00%

latency reported after the changes:
    clat (usec): min=106, max=5122, avg=132.95, stdev=313.07
     lat (usec): min=106, max=5125, avg=133.11, stdev=313.27
    clat percentiles (usec):
     |  1.00th=[  108],  5.00th=[  108], 10.00th=[  109], 20.00th=[  111],
     | 30.00th=[  112], 40.00th=[  113], 50.00th=[  114], 60.00th=[  115],
     | 70.00th=[  116], 80.00th=[  118], 90.00th=[  120], 95.00th=[  121],
     | 99.00th=[  122], 99.50th=[  122], 99.90th=[ 5145], 99.95th=[ 5145],
     | 99.99th=[ 5145]
  lat (usec)   : 250=99.61%
  lat (msec)   : 10=0.39%

This fixes the issue: https://github.com/axboe/fio/issues/1484

Ankit Kumar (2):
  engines:io_uring: fix clat calculation for sqthread poll
  doc: update about sqthread_poll

 HOWTO.rst          |  4 +++-
 engines/io_uring.c | 20 ++++++++++++++++++++
 fio.1              |  4 +++-
 3 files changed, 26 insertions(+), 2 deletions(-)

-- 
2.17.1

