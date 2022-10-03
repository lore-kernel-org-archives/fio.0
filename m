Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083EBC4332F
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 20:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJCUfC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJCUe4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 16:34:56 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9269EE26
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 13:34:49 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20221003203444usoutp01ee61a1cbe5ab380e366e0fa940a77fcc~aqWn0pRww2620526205usoutp01k;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20221003203444usoutp01ee61a1cbe5ab380e366e0fa940a77fcc~aqWn0pRww2620526205usoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664829284;
        bh=knNLDDZPWROCN0IzcjHdZcPKgInWeMudUdgajFOiyz0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=E1QTRPutW+MBZL+5+/iMxdyphaegi6VTwVGjjh8eEEIeKnwIaumDUtKSLXiMMhCZU
         qrIDHVyCHx05zSs21UJb3304SKuPXn+ZfGGNd9IE41yFP/1x6zdgLodY7VxiJmWYZS
         9GuO0ObrZZCP27p6S6ipWm3opYdd6XeMb7JnsijM=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203444uscas1p2a145ebc407253167a5fa202f16b4e797~aqWntLkxA2024120241uscas1p2j;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 5A.F9.18126.4674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221003203444uscas1p109394dfb26b6c26bd0948b8e3c202549~aqWneQ0hZ1318713187uscas1p1r;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
X-AuditID: cbfec36f-fe1ff700000146ce-e9-633b476472b2
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id A3.A5.19363.4674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 3 Oct 2022 13:34:43 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        3 Oct 2022 13:34:43 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/4] test: test job for randtrimwrite
Thread-Topic: [PATCH 2/4] test: test job for randtrimwrite
Thread-Index: AQHY12eRDWDf4wtx7Eu4X91wG4JxqQ==
Date:   Mon, 3 Oct 2022 20:34:43 +0000
Message-ID: <20221003203427.123969-3-vincent.fu@samsung.com>
In-Reply-To: <20221003203427.123969-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7op7tbJBqvPqFmsvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DK+PWmjangsEHFxMWrGRsYbyt1MXJySAiYSGz8
        9pW1i5GLQ0hgJaPE2gVz2CGcViaJhgU7mboYOcCqphySgYivZZQ4cuwPE4TzkVHiwNO/UM5S
        Rok1m/awgHSwCWhKvN1fALJCRCBM4uej7awgNrOAusSxjRvYQGxhAVOJ5T+fM0HUWElMaljM
        CNIqIqAnceMwH0iYRUBFYvLRT6wgYV4BG4n+aY4gYU4BW4ltTbNYQGxGATGJ76fWMEFMF5e4
        9WQ+E8RjghKLZu9hhrDFJP7tesgGYStK3P/+kh2iHmjT1ClsELa2xLKFr8HqeYF6T858wgJR
        LylxcMUNFpAPJQR6OSQmtUxlhEi4SHy4/5QVwpaWuHp9KjNEUTujxNyNX6C6JzBKXH8iBWFb
        S/zrvAa1mU/i769HjBMYlWchOXwWkqNmITlqFpKjFjCyrGIULy0uzk1PLTbKSy3XK07MLS7N
        S9dLzs/dxAhMGaf/Hc7fwXj91ke9Q4xMHIyHGCU4mJVEeOc8skoW4k1JrKxKLcqPLyrNSS0+
        xCjNwaIkzhs1QytZSCA9sSQ1OzW1ILUIJsvEwSnVwLSvIV20YmVlb1yWY0buK5sHZ5YyLp67
        4N3+UMHVl+b6Z4d4KVxc+5mhpVXI/cztF+U3T99MCPVcEq64JlR5+gwOPbuiuvBWxcTtn/22
        xoXmVimvfe62i3Ft6xa7d0fKG4UX3T6kouzn0hRSWMe4Q85y/XT7KwqnL34M/OCfEvvhesOz
        2NcdkQt+ZW/SeiR0RHfD9RO/s49qR+y8ZFldXrusw7o9dsqBY6/F/hdN55DRsZv2cIrO/W+e
        AW82+jqc5ld+1niS98QLhTLvFws3+AZfPlZ4kk9mRnTo8+nKMndSZazvdl5Mszpd+uhinpp9
        4hGLc8e+nb3W1/FQaQcDT9PPA7ti7x/cpp3Q1t0da6bEUpyRaKjFXFScCACZr5+aiAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LJbGCapJvibp1s0LRD1GL13X42i4+zXjA7
        MHlcPlvq8XmTXABTFJdNSmpOZllqkb5dAlfGrzdtTAWHDSomLl7N2MB4W6mLkYNDQsBEYsoh
        mS5GLg4hgdWMEismrGGFcD4ySpx6cIkNwlnKKLF39R92kA42AU2Jt/sLuhg5OUQEwiR+PtrO
        CmIzC6hLHNu4gQ3EFhYwlVj+8zkTRI2VxKSGxYwgrSICehI3DvOBhFkEVCQmH/3EChLmFbCR
        6J/mCBIWAjKfPjgDNpFTwFZiW9MsFhCbUUBM4vupNUwQm8Qlbj2ZD2ZLCAhILNlznhnCFpV4
        +fgfK4StKHH/+0t2iHqgrVOnsEHY2hLLFr4Gq+cVEJQ4OfMJC0S9pMTBFTdYJjCKz0KyYhaS
        9llI2mchaV/AyLKKUby0uDg3vaLYMC+1XK84Mbe4NC9dLzk/dxMjMKZO/zscuYPx6K2PeocY
        mTgYDzFKcDArifDOeWSVLMSbklhZlVqUH19UmpNafIhRmoNFSZxXyHVivJBAemJJanZqakFq
        EUyWiYNTqoFpC1vDu/f2D6tblG1UjUNPqiZ2L+WW0yk4wJr08avB/8DHxnm31uo9YGaUbYif
        sKvl5yJP4/Dl/s5bnRMcN89YKrI7ddU/UR3V+1PWHIt7zHywd2bU7LxLktM31Ihds33C/9y7
        KunVm6g3V6vPatyoqlwo93/f+aAb9VkawYstdx1o3vG5MUNv8b6bvsunBFodSShcdm/Z9M5z
        13yWJSa/PZHdXj03QjTM5GfI9+o/i1KsT26rd+j/XrJ5wcP885/mlWww+N2xo/arR67Um6SP
        W/qE3EwCu/9byv3fbGh1Ovnzm+XM24VVGg462E6fFZE6Y70f15458473hjkbPpy2LDLr4cOO
        v1trU2c+em32S4mlOCPRUIu5qDgRAAeADSIYAwAA
X-CMS-MailID: 20221003203444uscas1p109394dfb26b6c26bd0948b8e3c202549
CMS-TYPE: 301P
X-CMS-RootMailID: 20221003203444uscas1p109394dfb26b6c26bd0948b8e3c202549
References: <20221003203427.123969-1-vincent.fu@samsung.com>
        <CGME20221003203444uscas1p109394dfb26b6c26bd0948b8e3c202549@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This test exposes a problem with randtrimwrite when norandommap is
enabled.

Currently we check to see if the last write and last trim ended at the
same position. If so, we decide that the next operation should be a
trim. This is ok in most cases but if norandommap is enabled, it could
happen by chance that we just finished a trim + write on an offset and
randomly chose that same offset again. This would fool fio into thinking
that it already finished a trim + write pair when it actually issued
only a trim operation.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/jobs/t0023.fio   | 75 ++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py | 64 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 139 insertions(+)
 create mode 100644 t/jobs/t0023.fio

diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
new file mode 100644
index 00000000..0250ee1a
--- /dev/null
+++ b/t/jobs/t0023.fio
@@ -0,0 +1,75 @@
+# randtrimwrite data direction tests
+[global]
+filesize=3D1M
+ioengine=3Dnull
+rw=3Drandtrimwrite
+log_offset=3D1
+per_job_logs=3D0
+randrepeat=3D0
+stonewall
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets touched
+# 			block sizes match
+# Buggy result: 	something else
+[basic]
+write_bw_log
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets trimmed
+# 			block sizes 8k for both write and trim
+# Buggy result: 	something else
+[bs]
+write_bw_log
+bs=3D4k,4k,8k
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bsrange]
+write_bw_log
+bsrange=3D512-4k
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bssplit]
+write_bw_log
+bsrange=3D512/25:1k:25:2k:25:4k/25
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets touched
+# 			block sizes match
+# Buggy result: 	something else
+[basic_no_rm]
+write_bw_log
+norandommap=3D1
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets trimmed
+# 			block sizes 8k for both write and trim
+# Buggy result: 	something else
+[bs_no_rm]
+write_bw_log
+bs=3D4k,4k,8k
+norandommap=3D1
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bsrange_no_rm]
+write_bw_log
+bsrange=3D512-4k
+norandommap=3D1
+
+# Expected result: 	trim issued to random offset followed by write to same=
 offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bssplit_no_rm]
+write_bw_log
+bsrange=3D512/25:1k:25:2k:25:4k/25
+norandommap=3D1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e72fa2a0..a2b036d9 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -649,6 +649,61 @@ class FioJobTest_t0022(FioJobTest):
             self.failure_reason +=3D " no duplicate offsets found with nor=
andommap=3D1".format(len(offsets))
=20
=20
+class FioJobTest_t0023(FioJobTest):
+    """Test consists of fio test job t0023"""
+
+    def check_seq(self, filename):
+        bw_log_filename =3D os.path.join(self.test_dir, filename)
+        file_data, success =3D self.get_file(bw_log_filename)
+        log_lines =3D file_data.split('\n')
+
+        prev_ddir =3D 1
+        for line in log_lines:
+            if len(line.strip()) =3D=3D 0:
+                continue
+            vals =3D line.split(',')
+            ddir =3D int(vals[2])
+            bs =3D int(vals[3])
+            offset =3D int(vals[4])
+            if prev_ddir =3D=3D 1:
+                if ddir !=3D 2:
+                    self.passed =3D False
+                    self.failure_reason +=3D " {0}: write not preceeded by=
 trim: {1}".format(bw_log_filename, line)
+                    break
+            else:
+                if ddir !=3D 1:
+                    self.passed =3D False
+                    self.failure_reason +=3D " {0}: trim not preceeded by =
write: {1}".format(bw_log_filename, line)
+                    break
+                else:
+                    if prev_bs !=3D bs:
+                        self.passed =3D False
+                        self.failure_reason +=3D " {0}: block size does no=
t match: {1}".format(bw_log_filename, line)
+                        break
+                    if prev_offset !=3D offset:
+                        self.passed =3D False
+                        self.failure_reason +=3D " {0}: offset does not ma=
tch: {1}".format(bw_log_filename, line)
+                        break
+            prev_ddir =3D ddir
+            prev_bs =3D bs
+            prev_offset =3D offset
+
+
+    def check_result(self):
+        super(FioJobTest_t0023, self).check_result()
+
+        self.check_seq("basic_bw.log")
+        self.check_seq("bs_bw.log")
+        self.check_seq("bsrange_bw.log")
+        self.check_seq("bssplit_bw.log")
+        self.check_seq("basic_no_rm_bw.log")
+        self.check_seq("bs_no_rm_bw.log")
+        self.check_seq("bsrange_no_rm_bw.log")
+        self.check_seq("bssplit_no_rm_bw.log")
+
+        # TODO make sure all offsets were touched
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops =3D=3D 1000
@@ -1026,6 +1081,15 @@ TEST_LIST =3D [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          23,
+        'test_class':       FioJobTest_t0023,
+        'job':              't0023.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
--=20
2.25.1
