Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADBAC001DC
	for <fio@archiver.kernel.org>; Thu, 13 Jul 2023 08:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjGMIpj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjGMIpT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2023 04:45:19 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48482689
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 01:44:55 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230713084450epoutp04b53239f6bf753993d08e726be9f112f1~xYOlacGHy2464924649epoutp04U
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 08:44:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230713084450epoutp04b53239f6bf753993d08e726be9f112f1~xYOlacGHy2464924649epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689237890;
        bh=hH0VR4B6alrRSffWaq/Wz2k+6cPDaq72tO3zx57rhvc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=GoaO/9egaRMlNi9Bp328qHWK+JOQmkHzt1o5sTJZTLKBJHDQK+qUM9SeTjC2IgRLg
         W5zi0oLAx5ydQaI+Nugh41WiJHs+u9tYrT+0DPlmOBetPu405lw4vl7CfdqUh35iKA
         yNCbK9F4QHE7j8Y3tCkQnHPwkjG389uvTKkLz8G8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230713084450epcas5p2b62125a13b4b89cde8e50e431c1e781b~xYOk_Q4yL2828128281epcas5p2z;
        Thu, 13 Jul 2023 08:44:50 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4R1p80329Lz4x9Pp; Thu, 13 Jul
        2023 08:44:48 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.1A.57354.F79BFA46; Thu, 13 Jul 2023 17:44:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050110epcas5p1282a4e40485cb37545ec7cb55a3dcff1~xBiA3ACHU0751107511epcas5p1o;
        Wed, 12 Jul 2023 05:01:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230712050110epsmtrp1766484a089a6a12109e7d580ec6d5346~xBiA1dqlo0214902149epsmtrp1L;
        Wed, 12 Jul 2023 05:01:10 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-30-64afb97f8f26
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.33.34491.6933EA46; Wed, 12 Jul 2023 14:01:10 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050109epsmtip17a0031a5c9194b5db74babaa4dac34ac~xBh-2heOS0079700797epsmtip1w;
        Wed, 12 Jul 2023 05:01:09 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/4] fdp fixes, random placment id and xnvme support
Date:   Wed, 12 Jul 2023 15:50:37 +0530
Message-Id: <20230712102041.20283-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmhm79zvUpBotfSFqsufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjcq2yUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
        SCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzrg89xBj
        wQ3OisbWA2wNjHfZuhg5OSQETCSuf5wPZgsJ7GaU+Hw5vIuRC8j+xCjx5vxnVgjnG6PEov3H
        GGE65t3dC5XYyygx7eQmKKeTSeL0hEvsIFVsAtoSr97eYO5i5OAQEdCQWHM3FSTMLJAtsejU
        MmYQW1jAXWLjyiMsIDaLgKrE/513wWxeARuJa5sPskMsk5eYeek7O0RcUOLkzCcsEHPkJZq3
        zmYG2SshcIxd4sHbPhaIBheJT+fboZqFJV4d3wJlS0m87G+DsrMlNj38yQRhF0gcedHLDGHb
        S7Se6ge7mVlAU2L9Ln2IsKzE1FPrmCD28kn0/n4C1corsWMejK0q8ffebagTpCVuvrsKZXtI
        PDp4ihkSvLESvZNnsE1glJ+F5J1ZSN6ZhbB5ASPzKkbJ1ILi3PTUZNMCw7zUcni8JufnbmIE
        p0Itlx2MN+b/0zvEyMTBeIhRgoNZSYRXZdu6FCHelMTKqtSi/Pii0pzU4kOMpsAwnsgsJZqc
        D0zGeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MDEeqVF0l/uw
        3Xvxl/5Pz4JXz4+Y8MEz24jn5RvPz3NjIg4uv2w+b2tyWcKeVdHVudq3lx8zeZ/7wNk87ZbS
        shc8GtpfT7q9tI87LpZlmi16IK33y9nZFpu67xb/dRct2fXOVeKkwIdbjWlObbcXPLQzD/l0
        6wLbi3cPnLxcJa6LXJPYd7y19nXO7YCbG+YcdzAIq2bse6Eta7bRQ+gvu6J2ysHqSA0Zu4CA
        +M5tkyYdDf6ectEwYvNW/ek890zbZLdd/LKs98qHm5sls6qC3vvWlcTEeqxiqjn+W6FYd1eX
        +HXbVao5X3umJ2TdPW72ijFmtVWdwe75r+sPhEvwTEyck12zWk+cIdxxUk94qhJLcUaioRZz
        UXEiALmJlO4OBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSnO4043UpBueuKFisufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjeKySUnN
        ySxLLdK3S+DKuDz3EGPBDc6KxtYDbA2Md9m6GDk5JARMJObd3cvaxcjFISSwm1Hi44ctLF2M
        HEAJaYmF6xMhaoQlVv57zg5iCwm0M0kcupwLYrMJaEu8enuDGcQWEdCSOLauiQ2klVkgX+L6
        PbASYQF3iY0rj7CA2CwCqhL/d94Fs3kFbCSubT7IDjFeXmLmpe/sEHFBiZMzn4DVMAPFm7fO
        Zp7AyDcLSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBIamluYNx+6oP
        eocYmTgYDzFKcDArifAWHFyVIsSbklhZlVqUH19UmpNafIhRmoNFSZxX/EVvipBAemJJanZq
        akFqEUyWiYNTqoHJSCbwvqF0kcXlWNHFLeWrH3B+zHdQZWbzdt2UGJ2Skc5/7Ne7Wz4iJ9k7
        DJ49enTtSN5Sldcvl3EoBM2IZpgiU8m4a98V9t5jgmU5V1desHe9V3rk7nn3t34pUn0t/7Uc
        4479Waa0NF3hyt2ponr8NjlTffs6uKtTdshqF+ys73Up5nETK/IQaMiyKav/vtmSyeTB51vv
        JBYe6JmVp7Jof1bIgj3TH7ot+shk9yjhkk/MCvMfurryJfcqJkhYlk/ZuPXs6hvtm/renRRX
        3rb5lMr00jtPvtftt75xZ92BSvsnac8ZzGJkZDuMts349LXt5N9dCQc7xL515hXMvpEx75JD
        c435o0dPQlS0RO4osRRnJBpqMRcVJwIAISlvzLgCAAA=
X-CMS-MailID: 20230712050110epcas5p1282a4e40485cb37545ec7cb55a3dcff1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230712050110epcas5p1282a4e40485cb37545ec7cb55a3dcff1
References: <CGME20230712050110epcas5p1282a4e40485cb37545ec7cb55a3dcff1@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This series now enables us to either roundrobin or select a random
placement ID from the available ones. In future a non-unifrom
placement id selection such as zipf, pareto etc can be added.

The current boundary check for input placment ids was not correct.
Added a fix for that.

This series also adds FDP support to the xnvme I/O engine.

Changes since v1:
 - Split the macro change and placement id check fix into separate
   patches as suggested by Vincent

Ankit Kumar (4):
  fdp: use macros
  fdp: fix placement id check
  fdp: support random placement id selection
  engines/xnvme: add support for fdp

 HOWTO.rst              | 19 ++++++++--
 configure              |  2 +-
 engines/io_uring.c     |  2 +-
 engines/xnvme.c        | 78 +++++++++++++++++++++++++++++++++++++++++-
 examples/xnvme-fdp.fio | 36 +++++++++++++++++++
 fdp.c                  | 22 +++++++-----
 fdp.h                  | 13 +++++++
 fio.1                  | 20 +++++++++--
 fio.h                  |  2 ++
 init.c                 |  2 ++
 options.c              | 20 +++++++++++
 thread_options.h       |  2 ++
 12 files changed, 203 insertions(+), 15 deletions(-)
 create mode 100644 examples/xnvme-fdp.fio

-- 
2.25.1

