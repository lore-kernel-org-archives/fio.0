Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA2C4332F
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 05:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiKRFjG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 00:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiKRFjF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 00:39:05 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C85A786DA
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 21:38:59 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221118053858epoutp03da26c92e1fcc6f23d018c7b9c0d86158~olzow4jzD1108811088epoutp03K
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 05:38:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221118053858epoutp03da26c92e1fcc6f23d018c7b9c0d86158~olzow4jzD1108811088epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668749938;
        bh=Ln3J44Em2vs5tLjyQHSaOqEHcAh9k2QW1TYdTwTp8ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KU6CtgMq7aaG81eowAtKTp56+76BgbE2ZOrczkY7sEavktp1UpZaMBJ0LqfW2sPu9
         Btxrc6kiWumO6QBVmCgbktRcDQa86I47W3pmnD2M7e8XPklX2tM81bHnPpuqMopLoN
         ACUpgqDv9CEtE5wxD59hoIuOVFEm+QMbUvrjpeU0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221118053857epcas5p3564c0f0606fbf3c16c1fc697b6d9540e~olzoPzHjs0315803158epcas5p3p;
        Fri, 18 Nov 2022 05:38:57 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4ND5Dw27b7z4x9Q7; Fri, 18 Nov
        2022 05:38:56 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.AC.56352.07A17736; Fri, 18 Nov 2022 14:38:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221118052634epcas5p1955a5364530a816efb34065542ad2e78~olo0C1-LY1008910089epcas5p17;
        Fri, 18 Nov 2022 05:26:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221118052634epsmtrp1084ae98687b2420e0b7377eb2c54062d~olo0CMp412947929479epsmtrp1Z;
        Fri, 18 Nov 2022 05:26:34 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-97-63771a7031a4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A2.0B.14392.A8717736; Fri, 18 Nov 2022 14:26:34 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221118052633epsmtip1fd1c4de821b30493696dad3d8aaedc39~olozEV4RR2456124561epsmtip1G;
        Fri, 18 Nov 2022 05:26:33 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] test: add test for mix random and sequential workload
Date:   Fri, 18 Nov 2022 10:44:54 +0530
Message-Id: <20221118051454.31288-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118051454.31288-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmpm6BVHmywettvBZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnTPywh7FgukLF4WXfWRsY70p0MXJy
        SAiYSFyZ/Zuxi5GLQ0hgN6PE1MnroZxPjBLHO54wQTjfGCXWf1jFCNOy8uhbNojEXkaJW9t/
        skA4rUwSW+btYwWpYhPQlnj19gYziC0iICyxv6OVBcRmFgiVOHntCzuILSzgJdH7bgXYVBYB
        VYnlyy6B9fIK2EjsuLeaFWKbvMTqDQeA5nBwcArYSsxtiYUIr2KXOPHEFsJ2kZj75wZUubDE
        q+Nb2CFsKYmX/W1QdrbEpoc/mSDsAokjL3qZIWx7idZT/WDjmQU0Jdbv0ocIy0pMPbWOCeJi
        Pone30+gWnkldsyDsVUl/t67zQJhS0vcfHcVyvaQuNvygh0SJBMYJWYvW8c8gVFuFsKKBYyM
        qxglUwuKc9NTi00LjPNSy+GRlpyfu4kRnKa0vHcwPnrwQe8QIxMH4yFGCQ5mJRHe3IulyUK8
        KYmVValF+fFFpTmpxYcYTYHBN5FZSjQ5H5go80riDU0sDUzMzMxMLI3NDJXEeRfP0EoWEkhP
        LEnNTk0tSC2C6WPi4JRqYJLPmc6Sy3LFyM5Cc6FyRI6GY06/tp73xLiX8i8e3ayQ3jphgf6X
        Tzd+XlwgYPrf41/NO9ZGafEVDm5f49fdV4rXTFvc7Lv+7rLfvy5N/WpacP38rsdXtrLb2mnd
        UhT+fviJ9Jr2WNvCzW0hzNMtU2RLrhb0f4oKe6Jgr6AdO/eN0Sv+2nCPzf1+y7YwTzfleDjr
        Cm9tUM4e4wT7wLtRP0srOp+UvNK7v2Xr9eItTx9tOBo6l0eX+57DZd/7mYtKflzyM9Uq2+n/
        /pnc88PfZT6Wajz6ZHpUcJvNjZ3lb892FxfbiIv/sa8qLJz/8mfrs9WGPnVrvpw4V27ziuNT
        x17R06nley8sn9vwPFNvpp0SS3FGoqEWc1FxIgBFqot63AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSnG6XeHmywZy53BZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVM/LCHsWC6
        QsXhZd9ZGxjvSnQxcnJICJhIrDz6lq2LkYtDSGA3o8SKrgdMXYwcQAlpiYXrEyFqhCVW/nvO
        DlHTzCQx5X4TM0iCTUBb4tXbG2C2CFDR/o5WFhCbWSBcYvqByYwgtrCAl0TvuxVgNouAqsTy
        ZZdYQWxeARuJHfdWs0IskJdYveEAM8heTgFbibktsSBhIaCS02teM09g5FvAyLCKUTK1oDg3
        PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4jLQ0dzBuX/VB7xAjEwfjIUYJDmYlEd7ci6XJQrwp
        iZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTA17tJ933N5WsDd
        a55WH1/YimTJlCSKafFN621imOMjuUFqXuyVnMT5s6c4/e2e7bRX8Gbki+dz79pypu1KXe+p
        odU+/U/k0pdcfRzTnrwWmGg9VXc236J8l6miDtl2zj1xm6yXuShw9qxWNu9xeDZ10bpc8Qs9
        X8PS715LcbLaEXpQwPn246OP1uzlC3C+ec9ni1rc1KfHGC9tCfum7RyobbOe6diq4KfeqtvO
        Fj3e2aguv49pKpfyh3MaSlXH1NKNgvqU2s6sjlhavbhpY/Kso+kH6oLvT1QpUHiVVHtXb5HB
        ovkvA+94SwatUPBUvPkqfVfVq+22x9/M5Uq58PrTU53e52eO1KddKzjwslRViaU4I9FQi7mo
        OBEAH6ozYpICAAA=
X-CMS-MailID: 20221118052634epcas5p1955a5364530a816efb34065542ad2e78
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221118052634epcas5p1955a5364530a816efb34065542ad2e78
References: <20221118051454.31288-1-ankit.kumar@samsung.com>
        <CGME20221118052634epcas5p1955a5364530a816efb34065542ad2e78@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a test case to confirm that with mix sequential and random workload
i.e. with fio option percentage_random set to 0 < percentage_random < 100
we are actually writing the specified size.

The test includes pre and post job files, where the former lays out 3
I/O files each of size 4MiB to be used by latter to do random write
with 1MiB size per job. This is intended to cover such cases where
fio generates offset just at the end of I/O region resulting in the
next sequential I/O to be outside the region, when the size is less than
actual filesize.

This covers #1486

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/jobs/t0028-post.fio | 27 +++++++++++++++++++++++++++
 t/jobs/t0028-pre.fio  | 21 +++++++++++++++++++++
 t/run-fio-tests.py    | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)
 create mode 100644 t/jobs/t0028-post.fio
 create mode 100644 t/jobs/t0028-pre.fio

diff --git a/t/jobs/t0028-post.fio b/t/jobs/t0028-post.fio
new file mode 100644
index 00000000..d5ad88ca
--- /dev/null
+++ b/t/jobs/t0028-post.fio
@@ -0,0 +1,27 @@
+# specify mixture of sequential and random workloads
+[global]
+ioengine=libaio
+size=1M
+rw=randwrite
+
+# Expected result: 	1M data written
+# Buggy result: 	Less than 1M data written
+[basic]
+bs=4K
+percentage_random=50
+
+# Expected result: 	1M data written
+# Buggy result: 	Less than 1M data written
+[rand_skewed]
+bs=4K
+randseed=47827
+percentage_random=90
+iodepth=32
+
+# Expected result: 	1M data written
+# Buggy result: 	Less than 1M data written
+[bsrange]
+bsrange=512-4K
+randseed=7847
+percentage_random=50
+iodepth=32
diff --git a/t/jobs/t0028-pre.fio b/t/jobs/t0028-pre.fio
new file mode 100644
index 00000000..dafc4b06
--- /dev/null
+++ b/t/jobs/t0028-pre.fio
@@ -0,0 +1,21 @@
+# specify mixture of sequential and random workloads
+[global]
+ioengine=libaio
+size=4M
+rw=randwrite
+
+[basic]
+bs=4K
+percentage_random=50
+
+[rand_skewed]
+bs=4K
+randseed=47827
+percentage_random=90
+iodepth=32
+
+[bsrange]
+bsrange=512-4K
+randseed=7847
+percentage_random=50
+iodepth=32
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e5b307ac..500ca841 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -800,6 +800,30 @@ class FioJobTest_t0025(FioJobTest):
             self.passed = False
 
 
+class FioJobTest_t0028(FioJobTest):
+    """Test consists for test job t0028-post.fio
+    Confirm for all jobs that write['io_kbytes'] == 1024"""
+
+    def check_result(self):
+        super(FioJobTest_t0028, self).check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][0]['write']['io_kbytes'] != 1024:
+            self.passed = False
+            self.failure_reason = "{basic} data written != 1024KiB,".format(self.failure_reason)
+
+        if self.json_data['jobs'][1]['write']['io_kbytes'] != 1024:
+            self.passed = False
+            self.failure_reason = "{rand_skewed} data written != 1024KiB,".format(self.failure_reason)
+
+        kbytes = self.json_data['jobs'][2]['write']['io_kbytes']
+        if kbytes < 1021 or kbytes > 1027:
+            self.passed = False
+            self.failure_reason = "{bsrange} data written != 1024KiB,".format(self.failure_reason)
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -1214,6 +1238,16 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [Requirements.not_windows],
     },
+    {
+        'test_id':          28,
+        'test_class':       FioJobTest_t0028,
+        'job':              't0028-post.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          't0028-pre.fio',
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.17.1

