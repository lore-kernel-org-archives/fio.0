Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6838BC43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 05:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLAF2z (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 00:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAF2y (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 00:28:54 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15979C609
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 21:28:52 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221201052850epoutp035134d4d3a683891a4533e5a8bc0c97b0~slDgL2Lr22584825848epoutp03g
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 05:28:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221201052850epoutp035134d4d3a683891a4533e5a8bc0c97b0~slDgL2Lr22584825848epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669872530;
        bh=mATnstNsGigN5QE/ygS/TJ32rsdjtmW8AEQizZOhfCA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=SdBGUjFAF0N4jGm5DGaUQ0xM883kVgSPvA9guZD2VRfpkfysCTQjK+DHmIAPtlDOE
         bXvuDCoKYjqGt/0buFeqJzr1Ia4AaGeTUbuwDcBL5oji9iD2N/ERqGyBdlNrUKfOZd
         Td5nrlEVUr55kda1vZxsSd0kl1ZJ1tLK3pEXG9Dk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221201052849epcas5p16ea3de1745401e67083119feb69d9def~slDf6aF_a2341423414epcas5p1j;
        Thu,  1 Dec 2022 05:28:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NN4PC6zLYz4x9Pq; Thu,  1 Dec
        2022 05:28:47 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.B6.56352.F8B38836; Thu,  1 Dec 2022 14:28:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221201052003epcas5p27b512af6c584d1e7e4ba95efb3668371~sk72ANmwi0167801678epcas5p2U;
        Thu,  1 Dec 2022 05:20:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221201052003epsmtrp1a65fefa931448cc047ffca4eb8ce8a19~sk71-iP793031430314epsmtrp1B;
        Thu,  1 Dec 2022 05:20:03 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-27-63883b8f5e67
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.B8.14392.38938836; Thu,  1 Dec 2022 14:20:03 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221201052002epsmtip166c8c9e9db8f3652ab74db989a187e9a~sk70-0oTp2990129901epsmtip18;
        Thu,  1 Dec 2022 05:20:02 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/1] documentation update for size
Date:   Thu,  1 Dec 2022 10:38:31 +0530
Message-Id: <20221201050832.18513-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmpm6/dUeywf0tJhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRn7F22gL3gAkvFtx/3WRsYTzF3MXJy
        SAiYSMycM5uxi5GLQ0hgN6PE/hdzmCGcT4wSlzZvhsp8Y5TY9wikhQOsZV+HK0R8L6PE+i27
        WCGcViaJCUd3sIPMZRPQlnj19gbYDhEBYYn9Ha0sIDazQKjEyWtfwGqEBUwlut49A7NZBFQl
        Vm9YBFbDK2Aj8WhjGwvEffJA8QNgJ0kIdLNLXNj0gg0i4SLRN/sXlC0s8er4FnYIW0riZX8b
        lJ0tsenhTyYIu0DiyIteqKftJVpP9YN9wyygKbF+lz5EWFZi6ql1TBB38kn0/n4C1corsWMe
        jK0q8ffebajbpCVuvrsKZXtILFq5AMwWEoiVONC0gXkCo+wshA0LGBlXMUqmFhTnpqcWmxYY
        56WWwyMqOT93EyM4HWl572B89OCD3iFGJg7GQ4wSHMxKIrwdn9uShXhTEiurUovy44tKc1KL
        DzGaAsNsIrOUaHI+MCHmlcQbmlgamJiZmZlYGpsZKonzLp6hlSwkkJ5YkpqdmlqQWgTTx8TB
        KdXA1LaqLM3vrJDqJ51tjw7ozfnDas/yNfnPjEcHZl1o7959Yo3Lc56/S4v+uXcEyfCuOpZl
        njw5uFv+xoUzk05JPuxj3Lp77bPlpcfl3qY/P/CoNWDOU+5Nfqqr1z7hXDxF9a/Tm9Pm7X9M
        1fpNlMJzHudnL+dndnpglGneqzFTsLZKZneMmOFDmyXx77ZxxymW2Bw8WLz15BaLhDXGU26U
        LHk7QY1TWT35cc1/11mu0xJnpD47JbE/rVvS+O+aU290WX49rai7+fZ+00Tf0zneF5/fM/M+
        ujpm89r7sXdvn5F2fzvdY2bi+uM/lyv1yEeH7ygucHh7YeWrEs875k8euzeGr12994RF5elZ
        89Lk7H4osRRnJBpqMRcVJwIAw4IUStADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsWy7bCSnG6zZUeywfleA4s1V36zW6y+289m
        8XHWC2aLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDL2LlvAXnCB
        peLbj/usDYynmLsYOTgkBEwk9nW4djFycQgJ7GaUWD17HgtEXFpi4frELkZOIFNYYuW/5+wQ
        Nc1MEs/3tbKDJNgEtCVevb3BDGKLABXt72hlAbGZBcIlph+YzAhiCwuYSnS9ewZWzyKgKrF6
        wyKwGl4BG4lHG9tYIBbIA8UPME9g5FnAyLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93
        EyM4LLQ0dzBuX/VB7xAjEwfjIUYJDmYlEd6Oz23JQrwpiZVVqUX58UWlOanFhxilOViUxHkv
        dJ2MFxJITyxJzU5NLUgtgskycXBKNTDN57xqvFZX0TxV4YHcxEuGz23Uog87GomI+N3b+X/i
        jp/hrFXsWxk+uk85odRle2PTok2+eYZdfxQz/6k/9s78GWFkHiy3+GDDlpCTolsNvphMFE1k
        W57J1RkjKP3omvrq5nKJSo26GwLvj9fs0TJ7ELrwY0eP+8btF7zKP/57z+za5DixyrHJfOLp
        xev2s3rJnzzGudGeZ1PE9499GV8WvWa5+OBigpXF4+fmGewy7azbQwU+bRKe1DJ52xZu4ZNu
        CvOYM+dIX5djuDCp93ClyZW5WpujH3WG/EjYM8lw/+USmSLz42tOpy+Y8lj66Mb7CrFJxvsN
        FqyrUjuscnJJNnPohprNaotqJBR3dk5VYinOSDTUYi4qTgQAP7G/hHoCAAA=
X-CMS-MailID: 20221201052003epcas5p27b512af6c584d1e7e4ba95efb3668371
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221201052003epcas5p27b512af6c584d1e7e4ba95efb3668371
References: <CGME20221201052003epcas5p27b512af6c584d1e7e4ba95efb3668371@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

There are cases with fio option size that the number of bytes of data
transferred is less than what is specified. This can happen if there are
gaps or holes while doing I/O's or if we are running a mix of sequential
and random workload. Update the documentation for that.

Fixes: https://github.com/axboe/fio/issues/1486

Changes since v1:
 - Drop the code changes and only update the doc as suggested by
   Vincent.

Ankit Kumar (1):
  doc: update about size

 HOWTO.rst | 7 +++++--
 fio.1     | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.17.1

