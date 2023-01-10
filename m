Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB51EC46467
	for <fio@archiver.kernel.org>; Tue, 10 Jan 2023 06:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjAJG6N (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 10 Jan 2023 01:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjAJG6L (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Jan 2023 01:58:11 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7C43BE84
        for <fio@vger.kernel.org>; Mon,  9 Jan 2023 22:58:07 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230110065803epoutp03ce67d3274b5fe775cf1b906c6b64a30a~44E0MPjqj2231422314epoutp034
        for <fio@vger.kernel.org>; Tue, 10 Jan 2023 06:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230110065803epoutp03ce67d3274b5fe775cf1b906c6b64a30a~44E0MPjqj2231422314epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673333883;
        bh=Xj8/UBlGYuLz6062nt/sfYtByThmmnJdeGZv5wsezRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcfwYHPSRd/JLEYI2bUjAxnYtoMSchD5lP4efMLLoFDSBCgmumiWhUtc+daizbOBn
         do/wJ3ug1CaI6EAUao9xUb0t1H5qXCM1x8DqROAK/sX1IgcfEftTrjCm271ZVICj3f
         syX2bKAxM34YeybhJV1PF3N/Ib4BqoL0gYZ+d3c4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230110065802epcas5p1702b33887932052eac565f61b939dabc~44Ezae0uD1075710757epcas5p1K;
        Tue, 10 Jan 2023 06:58:02 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NrhTh5rDtz4x9Q1; Tue, 10 Jan
        2023 06:58:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.A0.03362.87C0DB36; Tue, 10 Jan 2023 15:58:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230110064319epcas5p3de72dc6ff06df62ba8d6441878c4ea6b~43388wV6U2908329083epcas5p3t;
        Tue, 10 Jan 2023 06:43:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230110064319epsmtrp13f3408332ae4cdd1edd6ccc890f1864a~43387vzrz3052030520epsmtrp17;
        Tue, 10 Jan 2023 06:43:19 +0000 (GMT)
X-AuditID: b6c32a4b-287ff70000010d22-45-63bd0c785c69
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.C2.02211.6090DB36; Tue, 10 Jan 2023 15:43:19 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230110064318epsmtip21d71396f8d701e581a989c1607fae4af~4338Lqcsd1176911769epsmtip2I;
        Tue, 10 Jan 2023 06:43:18 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] doc: clarify the usage of rw_sequencer
Date:   Tue, 10 Jan 2023 12:12:40 +0530
Message-Id: <20230110064240.30344-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230110064240.30344-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmhm4Fz95kgz+T9S3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOuN4bXNAvUnH84SOWBsblAl2MnBwS
        AiYSi1avZOti5OIQEtjNKPH30Q0WCOcTo8TGu+uhnG+MEn9OHWaDaZn3YjkTiC0ksJdR4ktz
        CURRM5PE7dUvmUESbALaEq/e3gCzRQSEJfZ3tLKA2MwCoRInr31h72Lk4BAWsJb4/jQDJMwi
        oCqxrGk5I4jNK2AjcX96A9QueYnVGw4wg5RzCthK/N8dALJKQmAVu8S3vR9ZIGpcJJoWdDFB
        2MISr45vYYewpSRe9rdB2dkSmx7+hKopkDjyopcZwraXaD3VDzafWUBTYv0ufYiwrMTUU+uY
        IC7mk+j9/QSqlVdixzwYW1Xi773bUCdIS9x8dxXK9pB4vuYPKyRIJjBKrD1wjn0Co9wshBUL
        GBlXMUqmFhTnpqcWmxYY56WWw6MsOT93EyM4RWl572B89OCD3iFGJg7GQ4wSHMxKIrwrOfck
        C/GmJFZWpRblxxeV5qQWH2I0BYbfRGYp0eR8YJLMK4k3NLE0MDEzMzOxNDYzVBLnTd06P1lI
        ID2xJDU7NbUgtQimj4mDU6qByUZVTGTPP45Vhzc9vS9cJZ8o5lsVN+VRVsesRYfvhV3orX0k
        WrNwZWj0ottJSedc34c37eO+KmrKs/DN3Q1fn8QI2TO4BX2duHFSV2hOa4bhlObHq85vzxUz
        lxefvenGhW/vNfcELUo+Wv/1w4NPW38IMGvaqqgzH3Rpsfrpt+6V7Z6ljYqeLOXN/+uC2sVm
        ZaTlPjgb/7P1vOObxC5p22NZlauYpFZ5HWsSnPbgcsBxf8sZ5vu5klVPKK40K+9jODVvV9D0
        UvYjUUUnrF6ErHdd4ff9UvDi61YxOftzF87/oKWnnyzeNzXnKNNHo5iNB+boaNouDFuvx8Jn
        yehimLPv0vbb1exZYUorK/PrlFiKMxINtZiLihMB4TxpqdoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSvC47595kg9+lFmuu/Ga3WH23n83i
        46wXzBYb2gQdWDx2zrrL7nH5bKlH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZVzvDS7oF6k4
        /vARSwPjcoEuRk4OCQETiXkvljN1MXJxCAnsZpS4dXsjexcjB1BCWmLh+kSIGmGJlf+es0PU
        NDJJfJr/hhUkwSagLfHq7Q1mEFsEqGh/RysLiM0sEC4x/cBkRpA5wgLWEt+fZoCEWQRUJZY1
        LWcEsXkFbCTuT29gg5gvL7F6wwFmkHJOAVuJ/7sDQMJCQCW7uvawTGDkW8DIsIpRMrWgODc9
        t9iwwDAvtVyvODG3uDQvXS85P3cTIziAtDR3MG5f9UHvECMTB+MhRgkOZiUR3pWce5KFeFMS
        K6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYNq1qEB/SRDj9wo2
        ruOLe5nvK+5oZr/4oGpfx+ODS5jfm+3d9Lzgp/Y8p38X1zfYOT39Xrlxv0s4e8R+6YAcx067
        vaaf53KtvxQmvH3DI8YpzV//P4z9We05oc31iPe8Wqn//3a/WHKbbx3Lh/uvcnJbq/UDeuLv
        15ocPHC6eAFLzYc8s8QZ7xoO/ZtUkR12jEVjbsuMInaXY02XT2w0N9J9/kTwv5z6bt5pG0un
        JHtm753n8ui02IHnCYd7Qg8/+P3JQ+HbJMFt58Ucop0DrnJkfcnn+iq74euEZfHsSyc0S4fd
        Zeuv5pj8c9H+d0nXG+WWzTohvdZu8oGzmT1qOy2NL7U7mCQ8ZtGa9KVu2gdOJZbijERDLeai
        4kQAnQWAzI8CAAA=
X-CMS-MailID: 20230110064319epcas5p3de72dc6ff06df62ba8d6441878c4ea6b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230110064319epcas5p3de72dc6ff06df62ba8d6441878c4ea6b
References: <20230110064240.30344-1-ankit.kumar@samsung.com>
        <CGME20230110064319epcas5p3de72dc6ff06df62ba8d6441878c4ea6b@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update man page clarifying the usage of rw_sequencer=sequential

Fixes: https://github.com/axboe/fio/issues/1223

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 10 +++++-----
 fio.1     | 12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0a48a453..806c1053 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1176,11 +1176,11 @@ I/O type
 			Generate the same offset.
 
 	``sequential`` is only useful for random I/O, where fio would normally
-	generate a new random offset for every I/O. If you append e.g. 8 to randread,
-	you would get a new random offset for every 8 I/Os. The result would be a
-	seek for only every 8 I/Os, instead of for every I/O. Use ``rw=randread:8``
-	to specify that. As sequential I/O is already sequential, setting
-	``sequential`` for that would not result in any differences.  ``identical``
+	generate a new random offset for every I/O. If you append e.g. 8 to
+	randread, i.e. ``rw=randread:8`` you would get a new random offset for
+	every 8 I/Os. The result would be one single random offset and 7
+	sequential offset. As sequential I/O is already sequential, setting
+	``sequential`` for that would not result in any difference.  ``identical``
 	behaves in a similar fashion, except it sends the same offset 8 number of
 	times before generating a new offset.
 
diff --git a/fio.1 b/fio.1
index eb87533f..c5ba0436 100644
--- a/fio.1
+++ b/fio.1
@@ -952,12 +952,12 @@ Generate the same offset.
 .P
 \fBsequential\fR is only useful for random I/O, where fio would normally
 generate a new random offset for every I/O. If you append e.g. 8 to randread,
-you would get a new random offset for every 8 I/Os. The result would be a
-seek for only every 8 I/Os, instead of for every I/O. Use `rw=randread:8'
-to specify that. As sequential I/O is already sequential, setting
-\fBsequential\fR for that would not result in any differences. \fBidentical\fR
-behaves in a similar fashion, except it sends the same offset 8 number of
-times before generating a new offset.
+i.e. `rw=randread:8' you would get a new random offset for every 8 I/Os. The
+result would be one single random offset and 7 sequential offset. As
+sequential I/O is already sequential, setting \fBsequential\fR for that would
+not result in any difference. \fBidentical\fR behaves in a similar fashion,
+except it sends the same offset 8 number of times before generating a new
+offset.
 .RE
 .TP
 .BI unified_rw_reporting \fR=\fPstr
-- 
2.17.1

