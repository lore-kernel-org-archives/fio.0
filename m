Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318E7C433EF
	for <fio@archiver.kernel.org>; Fri, 15 Oct 2021 12:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBA160F21
	for <fio@archiver.kernel.org>; Fri, 15 Oct 2021 12:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhJOMMi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:12:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54781 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbhJOMMh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Oct 2021 08:12:37 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20211015121030euoutp0166446d16b418c9cdefd5111c149d46b7~uMwln6NiV0060000600euoutp01Z
        for <fio@vger.kernel.org>; Fri, 15 Oct 2021 12:10:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20211015121030euoutp0166446d16b418c9cdefd5111c149d46b7~uMwln6NiV0060000600euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634299830;
        bh=ajizKGaFkyp2JsvREUrtSGLYEJGEW3ITCnfJXboYafw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=oo68NAcVz3YFQzvL5raUZMZAVC4Y7hobGDEh30w8YyWc34wKP8JEhfcEYBxb/s5/f
         6+3/sQf4XUfzPj/N2FcZVADjQZLp8dujU+fkaSyRctUidTExKWrti4twhv1/au7EDY
         fW1HJB7RbS/KekTMSlB7oM25hYow21ZSVYRZ04jE=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211015121029eucas1p10362758ff1ef7c548a22beb4811c9f36~uMwlVu-_n3111631116eucas1p1U;
        Fri, 15 Oct 2021 12:10:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id B3.1D.56448.5BF69616; Fri, 15
        Oct 2021 13:10:29 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211015121029eucas1p159b174d661cb7a67684032107f870b5c~uMwk2Nrql1221612216eucas1p1Q;
        Fri, 15 Oct 2021 12:10:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211015121029eusmtrp2c8040da076350caec8482c576b890681~uMwk1hNyY0585205852eusmtrp23;
        Fri, 15 Oct 2021 12:10:29 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-10-61696fb514f6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 96.D5.31287.5BF69616; Fri, 15
        Oct 2021 13:10:29 +0100 (BST)
Received: from localhost (unknown [106.210.248.47]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211015121029eusmtip1e289835429830b0b92e807fda96b3953~uMwkhrp9u1009810098eusmtip17;
        Fri, 15 Oct 2021 12:10:29 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
Cc:     =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] t/io_uring: Fix the parameters calculation for multiple
 threads scenario
Date:   Fri, 15 Oct 2021 14:09:56 +0200
Message-Id: <20211015120956.41848-1-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7djP87pb8zMTDa58MbVYfbefzeLjrBfM
        Fo/vfGa3+Ly0hd2BxePy2VKPvi2rGD0+b5ILYI7isklJzcksSy3St0vgylh+4x57wRHWiu8X
        H7E2MK5g6WLk5JAQMJH4eeoVcxcjF4eQwApGiWVXjzBBOF8YJb7+fMEK4XxmlGi7O5MJpmXX
        3Q1QieWMEvu/X2KEcF4wSmx9fwNoMAcHm4CWRGMnO0iDiIC1xPyfj8HCzAIZEt1/fUHCwgLR
        Eo0HPoCVsAioSrza8xNsPq+ApcSGVbfYIXbJS8y89J0dIi4ocXLmE7CzmYHizVtng50tIfCT
        XeLgz+tMIPMlBFwk1l0zhOgVlnh1fAvUHBmJ/zvnQ90/mVHi2KpEiN71jBIt3QtYIXqtJfrO
        5ECcqSmxfpc+RLmjxNv+h+wQFXwSN94KQlzAJzFp23RmiDCvREebEES1ksTOn0+glkpIXG6a
        wwJR4iHx67orSFhIIFZi9qwexgmMCrOQvDULyVuzEE5YwMi8ilE8tbQ4Nz212DgvtVyvODG3
        uDQvXS85P3cTIzBdnP53/OsOxhWvPuodYmTiYDzEKMHBrCTC++5AeqIQb0piZVVqUX58UWlO
        avEhRmkOFiVx3l1b18QLCaQnlqRmp6YWpBbBZJk4OKUamMKVPk3k+steX/Kupmz/LoX+611f
        G2sTOKsk2j4f53M9NJfrYsvx/6yufRo1AeeyGd7NlPKzktXzaEt7EiTeeWLq/Tbr3P0ndj5I
        yy+ctXXTnysueU6r9q/gfLqHrUvlVFBQW7C69twLbFImCfUT909bsISfa9LbP9tkK5z3JDN8
        LVLau3qR3oabHnptactPLj6S9jJLO116k0fJWoWNfybaTxGyv/A5UWThbv1TxZahwgf0uizS
        Gj+ZzFOSnbrmQ75Mqp3WKo9Cjh6uPWuyH6mKWL73UbCaf7W+YMXB4hnbFW+q3359f+pGtVfr
        vE/auheseLyoYev9IMZdRxTW771S+U+uXuWomQGz4MFdDEosxRmJhlrMRcWJAKflkq+GAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xu7pb8zMTDba/FLFYfbefzeLjrBfM
        Fo/vfGa3+Ly0hd2BxePy2VKPvi2rGD0+b5ILYI7SsynKLy1JVcjILy6xVYo2tDDSM7S00DMy
        sdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy1h+4x57wRHWiu8XH7E2MK5g6WLk5JAQMJHYdXcD
        axcjF4eQwFJGif9LdjNBJCQkbi9sYoSwhSX+XOtigyh6xiix8fY0oG4ODjYBLYnGTnaQGhEB
        W4kjC3ewgtjMAhkSP5atALOFBSIlLm9uZAOxWQRUJV7t+Qk2n1fAUmLDqlvsEPPlJWZe+s4O
        EReUODnzCQvEHHmJ5q2zmScw8s1CkpqFJLWAkWkVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZG
        YLhuO/Zz8w7Gea8+6h1iZOJgPMQowcGsJML77kB6ohBvSmJlVWpRfnxRaU5q8SFGU6D7JjJL
        iSbnAyMmryTe0MzA1NDEzNLA1NLMWEmcd+vcNfFCAumJJanZqakFqUUwfUwcnFINTHq/LBgF
        Fn0TNJSu+VprVvNHpOGYsD3HVxvtVbFde78cDqx+P/0Jm0JlQcNXH4dEw/At3109fz4ILTw3
        adFpoYwbM5fNXtbX2fknTPfctLu92pcEbPPzTu1NXLJ0epZBzUPTZ3+m5j030Gk5tzJVg/GB
        x+JVVXxz3FObXl/e+ubURKkWZVnhJwpvP3ofSNkW9aKlrixycow+x8xPzg9DXRLOnZbViLvy
        q3EvQ/+noN2HErpl+SOTHxt8DulkK85u0U/yXaRZ5fU+tPfG8pioUoPDoVkaQe598qUnXApV
        E8LkTDz9TafpG0QGntu9/ZjK29Xzn01PXORbI2C0obNeca+SzamPrDuSUgNctc4rsRRnJBpq
        MRcVJwIAOx3L+uACAAA=
X-CMS-MailID: 20211015121029eucas1p159b174d661cb7a67684032107f870b5c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211015121029eucas1p159b174d661cb7a67684032107f870b5c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211015121029eucas1p159b174d661cb7a67684032107f870b5c
References: <CGME20211015121029eucas1p159b174d661cb7a67684032107f870b5c@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The this_done, this_call and this_reap parameter should be a summation of 
the corresponding field from all the submitters. 

Currently, we are adding the done, calls and reaps param of the last used 
submitter nthread times. 

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 t/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/t/io_uring.c b/t/io_uring.c
index 5a80e074..a87042f8 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1348,6 +1348,7 @@ int main(int argc, char *argv[])
 			stats_running = 1;
 
 		for (j = 0; j < nthreads; j++) {
+			s = get_submitter(j);
 			this_done += s->done;
 			this_call += s->calls;
 			this_reap += s->reaps;
-- 
2.25.1

