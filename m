Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6885AC433EF
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348443AbiFAJlW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350017AbiFAJk4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:56 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3E149913
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:54 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220601094052epoutp016b6b9bd71f3e5d21d4147f4fa3ea4975~0dcUueVMn1201512015epoutp01f
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220601094052epoutp016b6b9bd71f3e5d21d4147f4fa3ea4975~0dcUueVMn1201512015epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076452;
        bh=NQWO5/1Xs8ZpiaDcfYhXC/Yii+HnEkNFuSYJCgm7DC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwJoIY9H3ksdKjEgYadHtM/9INLjjJd11PIHGCHWz22EZr+ijqwTUPRdive9Fs+aD
         imdfXWCsZpx6jhjBMs9wGgvSkQYGq1iOzPrmiD/RgTAuDWQNOxc16DdNx7/+gXJQAk
         6VQP0o7heYya2wz6uHN/1k7M3QGBvq73rMYt2Fpo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220601094052epcas5p201b2b28f7d8e2e36c3ce9e0e83545b3c~0dcT-iAQ-0474904749epcas5p24;
        Wed,  1 Jun 2022 09:40:52 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LCkfR5bbxz4x9Py; Wed,  1 Jun
        2022 09:40:47 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A2.97.09827.91437926; Wed,  1 Jun 2022 18:40:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220531133751epcas5p3819dec97a26ac12bf81d03d947a7272d~0NB8MYinj0535705357epcas5p3p;
        Tue, 31 May 2022 13:37:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133751epsmtrp275c8cd6c44ad5941e0fe06fb4e1e60b8~0NB8LGN-E0338303383epsmtrp2I;
        Tue, 31 May 2022 13:37:51 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-ca-62973419aaab
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.F4.11276.E2A16926; Tue, 31 May 2022 22:37:50 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133750epsmtip27ea1856b9f07217d45a69f46665ab5f5~0NB7SYyYo0157701577epsmtip2I;
        Tue, 31 May 2022 13:37:50 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v3 9/9] examples: add 2 example job file for io_uring_cmd
 engine
Date:   Tue, 31 May 2022 19:01:55 +0530
Message-Id: <20220531133155.17493-10-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmpq6kyfQkg1+H9CyaJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXFo31nGgut8FUenOTUwHuHpYuTk
        kBAwkWg6/Ym9i5GLQ0hgN6PErt27GSGcT4wS5/5PZ4JwvjFKXN33lwmm5cjjP8wQib2MEg3/
        F0K1tDJJXLv8GKyKTUBb4tXbG8wgtoiAsMT+jlYWEJtZIFbi+bYGoBoODmGBIInNk8DKWQRU
        JR6vPssOYvMK2EosPXWQGWKZvMTqDQfAbE6g+Lyp61kh4svYJS5MSwMZIyHgIrHsqAZEWFji
        1fEt7BC2lMTnd3vZIOxsicZHf6HsEomdt7ZDjbeXuLjnL9g1zAKaEut36UOEZSWmnlrHBHEw
        n0Tv7ydQr/NK7JgHY6tK/L13mwXClpa4+e4qlO0h8bTrNwskRCYwSkxcfZ5pAqPcLIQVCxgZ
        VzFKphYU56anFpsWGOWllsOjLDk/dxMjOElpee1gfPjgg94hRiYOxkOMEhzMSiK8JbumJgnx
        piRWVqUW5ccXleakFh9iNAUG30RmKdHkfGCazCuJNzSxNDAxMzMzsTQ2M1QS5xX435gkJJCe
        WJKanZpakFoE08fEwSnVwNQQvUf/9HXtndsymtLV9iXUhQf+mSyrwSAvbvV5qabLr7c/n90P
        vrOMn7fcpeTYhZY8B9ujkYwPIkJF0tXXBb9dU38iPPjpw/pHQUun77A10V3N5xzWxMt+a1qd
        dliwZNlF41N82p6T3zDe3rk1iXHhmUWbNSaWVH2uZmOJ7rg7YTJLscaBI9uCFNRYitf62DW2
        awuLq1yqETxSfUxjRuXzNfeOrJhxxDa3SEWlzP5ysfmWpTmsoSyFTBKTBCQXeai+Fmp5qz65
        wH9DC/v0r//3lNwPrFkXb7KxTybZW9KAJ1tN8sXxyrO5K568fSV+zVWuhrtnseHGZQviNu77
        WS611KBYZbO2oar6NfcSJZbijERDLeai4kQAafcePNsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvK6e1LQkgxsbrC2aJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcWjfWcaC
        63wVR6c5NTAe4eli5OSQEDCROPL4DzOILSSwm1Fi90GvLkYOoLi0xML1iRAlwhIr/z1n72Lk
        AippZpLY17aLDSTBJqAt8ertDbBeEaCi/R2tLCA2s0CixI5JuxhBbGGBAIlf9y6yg9gsAqoS
        j1efBbN5BWwllp46yAyxQF5i9YYDYDYnUHze1PWsEPfYSEx9sYBxAiPfAkaGVYySqQXFuem5
        xYYFhnmp5XrFibnFpXnpesn5uZsYwWGkpbmDcfuqD3qHGJk4GA8xSnAwK4nwluyamiTEm5JY
        WZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk5i2wW+R6Iv/uq5s
        ZP2n+sI68cJazZnO26OrvkduOCfptbpjZ93DLz8vyvxoZU51ba5bdCzcarZO2y/5oxdmx/Ck
        pv6W3e/ow2preHXSrv2XDbMORSdLTk38PuuUTtvbaa7HDNZNSej45ZrYJT1paryzwv25u3UC
        1OMnm1haTTPZZfo46V+j/vbjIY+XtUc8Yjz+9SKftoTBX58X8mFeyaKCuc/O7bmtMOtNGY/2
        523nVwZcOaGwd9vSzLqMdZIVtj+fmTtFTwnRPOwhtyp1j/vcA/d3nViywIpf2Ivtj2TWjZzz
        erN0JzFkVaYce/BMyEps+pz0uXa2XgLp8oslanb7ePbdfnZ1ffPXvuqlWkosxRmJhlrMRcWJ
        AMD4olySAgAA
X-CMS-MailID: 20220531133751epcas5p3819dec97a26ac12bf81d03d947a7272d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133751epcas5p3819dec97a26ac12bf81d03d947a7272d
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133751epcas5p3819dec97a26ac12bf81d03d947a7272d@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

examples/uring-cmd-ng.fio has usage for conventional nvme-ns char device
examples/uring-cmd-zoned.fio has usage for ZNS nvme-ns char device

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Co-authored-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 examples/uring-cmd-ng.fio    | 25 +++++++++++++++++++++++++
 examples/uring-cmd-zoned.fio | 31 +++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio

diff --git a/examples/uring-cmd-ng.fio b/examples/uring-cmd-ng.fio
new file mode 100644
index 00000000..b2888a00
--- /dev/null
+++ b/examples/uring-cmd-ng.fio
@@ -0,0 +1,25 @@
+# io_uring_cmd I/O engine for nvme-ns generic character device
+
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=1G
+iodepth=32
+bs=4K
+thread=1
+stonewall=1
+
+[rand-write]
+rw=randwrite
+sqthread_poll=1
+
+[rand-read]
+rw=randread
+
+[write-opts]
+rw=write
+sqthread_poll=1
+sqthread_poll_cpu=0
+nonvectored=1
+registerfiles=1
diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
new file mode 100644
index 00000000..58e8f79e
--- /dev/null
+++ b/examples/uring-cmd-zoned.fio
@@ -0,0 +1,31 @@
+# io_uring_cmd I/O engine for nvme-ns generic zoned character device
+#
+# NOTE: with write workload iodepth must be set to 1 as there is no IO
+# scheduler.
+
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+zonemode=zbd
+size=1G
+iodepth=1
+bs=256K
+verify=crc32c
+stonewall=1
+
+[rand-write]
+rw=randwrite
+
+[write-opts]
+rw=write
+registerfiles=1
+sqthread_poll=1
+sqthread_poll_cpu=0
+
+[randwrite-opts]
+rw=randwrite
+sqthread_poll=1
+sqthread_poll_cpu=0
+nonvectored=1
+registerfiles=1
-- 
2.17.1

