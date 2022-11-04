Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08808C4332F
	for <fio@archiver.kernel.org>; Fri,  4 Nov 2022 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiKDMiO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Nov 2022 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiKDMiC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Nov 2022 08:38:02 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6A52DA9D
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 05:37:58 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221104123756epoutp0232ba8f723a5b2f4885c6c66757e91f71~kYfdG6yzJ1791017910epoutp02j
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 12:37:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221104123756epoutp0232ba8f723a5b2f4885c6c66757e91f71~kYfdG6yzJ1791017910epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667565476;
        bh=bJ5Y7Pg3Lmdq0BZKA/syIb4sRPFkOPau4vu6T8CXIYk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=dw1eDz4bGcbg+RHZJTkEMMXGjEKN1A4ZcUwEg5DM8q39KODBflSqaqL5vXeboieY5
         ufK7zzTkg0cE9iEzPEJOYUfAB6489B/57NRJIUouoOSvOLTWSAc4xVbV85cvrItlvA
         v2ALPfpgCVgC4Qz7bF6x2EQhZFa9rsIGvgJ4QcAo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221104123756epcas5p4dc9eac53abec5cfa8011c6feadd4faa0~kYfc5v03U1037810378epcas5p4i;
        Fri,  4 Nov 2022 12:37:56 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N3gBq3Wwkz4x9Pp; Fri,  4 Nov
        2022 12:37:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.1F.56352.3A705636; Fri,  4 Nov 2022 21:37:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221104112440epcas5p24f13b6a1c3db0b38b8453a896fb31575~kXfew9FQd0031900319epcas5p2T;
        Fri,  4 Nov 2022 11:24:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221104112440epsmtrp1f7045f8c67ab5faf0d82a4dc8101cae2~kXfewUd4J1354313543epsmtrp1c;
        Fri,  4 Nov 2022 11:24:40 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-4c-636507a32e41
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.34.18644.876F4636; Fri,  4 Nov 2022 20:24:40 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104112438epsmtip294098ea2317d15f641dfde671be50118~kXfdS5LdT0554505545epsmtip2B;
        Fri,  4 Nov 2022 11:24:38 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] slat and clat reporting with sqthread_poll
Date:   Fri,  4 Nov 2022 16:43:12 +0530
Message-Id: <20221104111314.25535-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7bCmuu5i9tRkg3mHpC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO2HLzEVPBU/6Knr/7mBoYD/F0MXJy
        SAiYSCw9fIe1i5GLQ0hgN6PE+1nfGSGcT4wSc59OZ4NwPjNKLJrwkRWmZf6lJewgtpDALkaJ
        p321EEWtTBK7frYwgSTYBLQlXr29wQxiiwgIS+zvaGUBsZkFQiVOXvsC1iwsYC8xd99UoDgH
        B4uAqsSui2AlvAI2Elubz7ND7JKXWL3hADPIfAmBfnaJK98/skAkXCSmLWmEsoUlXh3fAtUg
        JfGyvw3KzpbY9PAnE4RdIHHkRS8zhG0v0XqqnxlkL7OApsT6XfoQYVmJqafWMUGcySfR+/sJ
        VCuvxI55MLaqxN97t6HWSkvcfHcVyvaQOLlxCzRMYiU2fnzLPoFRdhbChgWMjKsYJVMLinPT
        U4tNC4zzUsvh8ZScn7uJEZyMtLx3MD568EHvECMTB+MhRgkOZiUR3k/bkpOFeFMSK6tSi/Lj
        i0pzUosPMZoCg2wis5Rocj4wHeaVxBuaWBqYmJmZmVgamxkqifMunqGVLCSQnliSmp2aWpBa
        BNPHxMEp1cCkUBx2xPUqz8u4GTP6lhzm5Tm1aWl3Uze3L/+SpCYLgc8qFaJfqrae7pgkVLuo
        aYNmBs+j0tMnnv17ejoukvu1ceycRpf+Ks4l+X/9Gne8kuvZs/yOWr//xrccRecvBW+/lD3j
        v77t+qwa23C181NfPp7JYfW78uGZWU8EZrz5v0ojYe4Nl6UJ+y7eW9NYGhYzw9HwyKNTc7N+
        fzn/9WrYtd4Azcj1SserS3zehL34tHRycrJhp03lEkfFx7OmskiePVS55m6dWOhxPeYlVY9/
        GGzdYtkqYlD//5B+5y0+lULb/xxsWTzib39f3ri0c+/nae8+z7v35cA67S7bb/uX/1u/6PHd
        XV87r70OVf4jGKjEUpyRaKjFXFScCADOaQL9zwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsWy7bCSvG7Ft5Rkg0PN4hZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVsufmIqeAp
        f0XP331MDYyHeLoYOTkkBEwk5l9awt7FyMUhJLCDUWJmw1TWLkYOoIS0xML1iRA1whIr/z2H
        qmlmkliy/w4jSIJNQFvi1dsbzCC2CFDR/o5WFhCbWSBcYvqByWA1wgL2EnP3TWUBmckioCqx
        6yJYCa+AjcTW5vPsEPPlJVZvOMA8gZFnASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT8
        3E2M4LDQ0trBuGfVB71DjEwcjIcYJTiYlUR4P21LThbiTUmsrEotyo8vKs1JLT7EKM3BoiTO
        e6HrZLyQQHpiSWp2ampBahFMlomDU6qB6fQz/00sC8yb912+G7H36drkG2Erdq0767LpQcfu
        ncqTZc9E6ZrOW394wq7tH9uC13EwPyoLvbd0vYrw70TfutKpChunTAqS3ZS6Y/Las9Zmz/dO
        eXrdT4D5mH6i+3fWz/XNCfU1ByK6t8hY1vV4FjHEnf2hzx9dWbzS7lXAG/UO7m/b28/YiWo+
        zf7xPWVZ9pWCILfNRmd2Nz/606zwTDOepdgheqq7o5fGnw4v9q2qvNN3WMso7lDew8MQ+nLh
        bu7ZtidFvBbpKOsePuyw7tIRnS+HpV6nnjGRCnPhfvfGN375tlbWT32Xi95/lPsYUHn8Wd2X
        UyFn3jN5vP94MO+j46rZts8W5dldnjzR6KASS3FGoqEWc1FxIgBlc5rdegIAAA==
X-CMS-MailID: 20221104112440epcas5p24f13b6a1c3db0b38b8453a896fb31575
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104112440epcas5p24f13b6a1c3db0b38b8453a896fb31575
References: <CGME20221104112440epcas5p24f13b6a1c3db0b38b8453a896fb31575@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When sqthread_poll is specified for io_uring and io_uring_cmd I/O engines,
fio doesn't report submission latency and the completion latency is too big.
Latency data before:

fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
    clat (msec): min=1120.1k, max=1120.1k, avg=1120092.65, stdev= 8.32
     lat (usec): min=104, max=5312, avg=132.81, stdev=325.05
    clat percentiles (msec):
     |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113], 20.00th=[17113],
     | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113], 60.00th=[17113],
     | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113], 95.00th=[17113],
     | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
     | 99.99th=[17113]
  lat (msec)   : >=2000=100.00%

As kernel polling thread handles the submission, there is no way to know when
the actual submission happened. We can only rely on the commit hook and
measure the issue time.
Latency data after the change:

fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
    slat (nsec): min=50, max=2230, avg=146.68, stdev=138.08
    clat (usec): min=105, max=5151, avg=132.98, stdev=314.89
     lat (usec): min=105, max=5153, avg=133.13, stdev=315.03
    clat percentiles (usec):
     |  1.00th=[  106],  5.00th=[  108], 10.00th=[  109], 20.00th=[  110],
     | 30.00th=[  111], 40.00th=[  113], 50.00th=[  114], 60.00th=[  115],
     | 70.00th=[  117], 80.00th=[  118], 90.00th=[  119], 95.00th=[  121],
     | 99.00th=[  123], 99.50th=[  123], 99.90th=[ 5145], 99.95th=[ 5145],
     | 99.99th=[ 5145]
  lat (usec)   : 250=99.61%
  lat (msec)   : 10=0.39%

This fixes the issue: https://github.com/axboe/fio/issues/1484

Ankit Kumar (2):
  engines:io_uring: slat and clat calculation with sqthread_poll
  doc: update about sqthread_poll

 HOWTO.rst          | 4 +++-
 engines/io_uring.c | 4 ++++
 fio.1              | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.17.1

