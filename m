Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E80C433F5
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348152AbiEZQsM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344911AbiEZQsK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:10 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0984636B
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:07 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220526164806epoutp02cccc8f9714793f9087431e3a66bed7de~ytZn8FeJk0327603276epoutp02s
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220526164806epoutp02cccc8f9714793f9087431e3a66bed7de~ytZn8FeJk0327603276epoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583686;
        bh=VV5xRkhTyRIDGRo7W9IPvdFTcONu2z3/75AJZ+WOUaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpchiHK4KapSQUcKNWQKtOzN0YnwNlnsv+fzE6LVMuGht/RzVWqs7PNAUL9PjjEmn
         8Ev33dIj+kD6c9Ick2zZBQB4FJEHhg/oKQqRL3QA488O+APjGfsUnuUWXnqTYQpPdB
         f1JF7aF9Ci/xaatotVR1N9DTu4L97PmJde/PSDow=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220526164805epcas5p4ad07dff6c95002d8d1b94a367f2f0f6e~ytZnCF_DJ3263032630epcas5p4Z;
        Thu, 26 May 2022 16:48:05 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L8DQB1Jzxz4x9Pt; Thu, 26 May
        2022 16:48:02 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.B1.09827.24FAF826; Fri, 27 May 2022 01:48:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220526145359epcas5p342b9d8def710f380169e109ba3824fae~yr1-puGFs0672706727epcas5p35;
        Thu, 26 May 2022 14:53:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220526145359epsmtrp26e1a711c744229325a0edb536a3c64df~yr1-o45371450114501epsmtrp28;
        Thu, 26 May 2022 14:53:59 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-00-628faf42b2b8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.93.11276.7849F826; Thu, 26 May 2022 23:53:59 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145358epsmtip28ab6b97fe98b7b1cada8526a9ba36728~yr1_qFyUn1808418084epsmtip2G;
        Thu, 26 May 2022 14:53:58 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 2/8] configure: check nvme uring command support
Date:   Thu, 26 May 2022 20:18:03 +0530
Message-Id: <20220526144809.14877-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmpq7T+v4kg+5JHBZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzVLZNRmpiSmqRQmpecn5K
        Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xr3nm9kLOjkrjt9ew9jA
        uIO9i5GTQ0LAROLuybvMXYxcHEICuxklrk5fAuV8YpToufyKEcL5xihxdsZyNpiWy6snQ1Xt
        ZZRoPXCEDcJpZZJY/usl2GA2AW2JV29vMIPYIgLCEvs7WllAipgFWhglGlevZQFJCAs4S/y/
        s4EVxGYRUJV42nIebAWvgI3E2tk7GSHWyUus3nAAbBCngK3EudszwLZJCGxjl3h56QsTRJGL
        xITdh6DuE5Z4dXwL1HtSEp/f7YWKZ0s0PvoLZZdI7Ly1nRnCtpe4uOcv0BwOoOs0Jdbv0ocI
        y0pMPbUObDyzAJ9E7+8nUKt4JXbMg7FVJf7eu80CYUtL3Hx3Fcr2kJi+9Bo07CYwSuzc/4Fl
        AqPcLIQVCxgZVzFKphYU56anFpsWGOWllsPjLTk/dxMjOHFpee1gfPjgg94hRiYOxkOMEhzM
        SiK8F572JgnxpiRWVqUW5ccXleakFh9iNAUG4ERmKdHkfGDqzCuJNzSxNDAxMzMzsTQ2M1QS
        5xX435gkJJCeWJKanZpakFoE08fEwSnVwMSjFNLNUF50mfHXJ03zDwe/bbq0uYj7dm78FCct
        7a2GW6s/CieXf7+0g9dVecJOzVvazrFB3/x5Pk28t6F8aTn/w/szxIs2muc8tYmeZPbD4oKY
        BVNgxpL16ba3fr9KP7AlPzp5rfCVc4acO49OsDEJi8+0bk+9dW7C5pdBRVP4d6/OkP5n//pD
        c+P8be9bxXki112cFnS9suTU38R1k6flWc4VVXq6vF0ooJRDZSKzvvKOpDm/DDJz/hgc0vuq
        LMXzdh+TLuP+WZd2rjXXrCz/7VFfMeGIwLVuVxXzYs6UmlLe9Qt/Wey8+fBc1x5XwXm/YwIm
        8u/IP+lX8y0px+ysddiErecCk04d7FO4fU2JpTgj0VCLuag4EQB3CsJt5QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42LZdlhJXrd9Sn+SQc8zZYs1V36zWzRN+Mts
        sfpuP5vFx1kvmC2O/n/LZrFw4zImBzaPy2dLPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj
        3vPN7AWdnBXHb69hbGDcwd7FyMkhIWAicXn1ZOYuRi4OIYHdjBIHnkxn6WLkAEpISyxcnwhR
        Iyyx8t9zdoiaZiaJ2Y/vsYAk2AS0JV69vcEMYosAFe3vaGUBKWIW6GKU6Ok8xQSSEBZwlvh/
        ZwMriM0ioCrxtOU8G4jNK2AjsXb2TkaIDfISqzccABvEKWArce72DLAaIaCaf/suMk1g5FvA
        yLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4rLQ0dzBuX/VB7xAjEwfjIUYJDmYl
        Ed4LT3uThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamBa
        IHGodcP+nTNtZx5ZdUjtwgv5muz5BpN+mXTWRBXKp166cf8G14bmpTeZb71aUPhpkYLorXNs
        LkdCfMWKThjOUDurWTN9k6fBmjPZW4Tzfb6dTFPabX+Eb03h5job0dtGj9JZJad9Xf3L7+e3
        qRFX6vIdb18q2eV+YtvE6jcXckyf3q+9X/iha+oKOZe+B4ZLv85tfVxwSb+DTVax793ep2/e
        l9pLTOK4e3k5t4NeJNuHRck/A+Y2C/kWxERuaExXS7uZ2r+0Q9jIwq926926qlBjI0Hm+743
        f9+S3uUs3rlolVzsHl051lTexe+je9csWR/CyXrIgmdaCGeJ4IHCuKZ6XVn+ZdPv8rN/LypU
        YinOSDTUYi4qTgQAkWJ7AJoCAAA=
X-CMS-MailID: 20220526145359epcas5p342b9d8def710f380169e109ba3824fae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145359epcas5p342b9d8def710f380169e109ba3824fae
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145359epcas5p342b9d8def710f380169e109ba3824fae@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Modify configure to check availability of nvme_uring_cmd, but only
when the target OS is Linux. This way in the follow up patch we
can define the missing structure to prevent compilation errors.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 configure | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/configure b/configure
index 95b60bb7..7e855e0e 100755
--- a/configure
+++ b/configure
@@ -2587,6 +2587,27 @@ if test "$libzbc" != "no" ; then
 fi
 print_config "libzbc engine" "$libzbc"
 
+if test "$targetos" = "Linux" ; then
+##########################################
+# Check NVME_URING_CMD support
+cat > $TMPC << EOF
+#include <linux/nvme_ioctl.h>
+int main(void)
+{
+  struct nvme_uring_cmd *cmd;
+
+  return sizeof(struct nvme_uring_cmd);
+}
+EOF
+if compile_prog "" "" "nvme uring cmd"; then
+  output_sym "CONFIG_NVME_URING_CMD"
+  nvme_uring_cmd="yes"
+else
+  nvme_uring_cmd="no"
+fi
+print_config "NVMe uring command support" "$nvme_uring_cmd"
+fi
+
 ##########################################
 # Check if we have xnvme
 if test "$xnvme" != "yes" ; then
-- 
2.17.1

