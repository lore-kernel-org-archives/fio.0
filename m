Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FEFC433F5
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348605AbiFAJkL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345160AbiFAJkJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:09 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8044E49254
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:08 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220601094004epoutp0348e0d973facff8bcb8a63b93860701c2~0dboBobsR1348913489epoutp03R
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220601094004epoutp0348e0d973facff8bcb8a63b93860701c2~0dboBobsR1348913489epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076404;
        bh=hK+w5ZBdpHx0A1IyF8ojMJUChqZ0UWSmU4kugeJvFAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqGBQxnVgVSNzk8SH0t70badXn5dY0Mid2casGbZIexNUfv+yje6LLt6GwjYOfB0Q
         h5c/MBAE0/47nFDEPrnaSEHWe21AV+oiPlolYr6C3m3eYJszBW1eDEtyw4MyeGYRKG
         PMe/HWaGwyKrGzwsePxfKUkdvpyrsAUmje+nyhH4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220601094004epcas5p3a87bc939361f172a868324964fd8a4ca~0dbnQs-wq0912309123epcas5p3L;
        Wed,  1 Jun 2022 09:40:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LCkdX5Xjpz4x9Py; Wed,  1 Jun
        2022 09:40:00 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.D4.10063.DE337926; Wed,  1 Jun 2022 18:39:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220531133741epcas5p16383da97824ffedd50f5e3231d09430e~0NBzb_U_l1773117731epcas5p1g;
        Tue, 31 May 2022 13:37:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133741epsmtrp279053f64398ef91ed2c5fa63881e3aac~0NBza_jP80382803828epsmtrp2W;
        Tue, 31 May 2022 13:37:41 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-ef-629733ed5c3b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.F4.11276.52A16926; Tue, 31 May 2022 22:37:41 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133740epsmtip25f8009a922d34f4c0548e9eedd4f205b~0NByeAmVV2550825508epsmtip2D;
        Tue, 31 May 2022 13:37:40 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 2/9] configure: check nvme uring command support
Date:   Tue, 31 May 2022 19:01:48 +0530
Message-Id: <20220531133155.17493-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmpu5b4+lJBkue8VisufKb3aJpwl9m
        i9V3+9ksPs56wWxx9P9bNouFG5cxObB5XD5b6tG3ZRWjx+dNcgHMUdk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGcc25hR0clbcePGGrYFx
        B3sXIyeHhICJxPZbLxm7GLk4hAR2M0p0Nu+Fcj4xSmw61sME4XxjlHi2aBMLTMvKK3vYIBJ7
        GSUezGqGqmplkjj85yAjSBWbgLbEq7c3mEFsEQFhif0drSwgRcwCLYwSjavXgo0SFnCWWLvq
        PBuIzSKgKjHh6DSwq3gFbCQWHj7LCrFOXmL1hgNggzgFbCXmTV3PCjJIQmATu8SP/Q+ZIIpc
        JH49P84GYQtLvDq+Beo9KYnP7/ZCxbMlGh/9hbJLJHbe2s4MYdtLXNzzF2gOB9B1mhLrd+lD
        hGUlpp5aBzaeWYBPovf3E6hVvBI75sHYqhJ/792GBou0xM13V6FsD4l1jb9YIaEygVHi/qxp
        bBMY5WYhrFjAyLiKUTK1oDg3PbXYtMAwL7UcHm3J+bmbGMFpS8tzB+PdBx/0DjEycTAeYpTg
        YFYS4S3ZNTVJiDclsbIqtSg/vqg0J7X4EKMpMAAnMkuJJucDE2deSbyhiaWBiZmZmYmlsZmh
        kjivwP/GJCGB9MSS1OzU1ILUIpg+Jg5OqQYm7bde8tyHFQW+hEp8ZivTi47Y3r729crjesXP
        QhXj1HizZ2/0aMndNyd/yUleAf/uGA5zL74YJ95Z2nmH/xS+e8U38dntTJkvR5wOaggpTvuQ
        qGUSwii3YN3p0I/FmmUKSz3StR3iFkkvjDJhPWXr/KXq2d6Dq4U2vWkVjilnPp/92XeOjPbs
        gLAz/R0fJtiq8Giy3LtvH/BmMqtF8tyUpOD0S4WPdjoqf24IqM7gC/a7dN3rStDEy68C6vRW
        puVzWuUcZOkq+jVlt8rvNSlX/Nw3L555Zu2rg2byM09Zc6qof5R+O0XAoaDsyiG9zzePOgtl
        7eb32mne9k9Z89+8/qLIh3PZ4phmLzkrwaLEUpyRaKjFXFScCABM9rcj5AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42LZdlhJXldValqSwdejahZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        sY05BZ2cFTdevGFrYNzB3sXIySEhYCKx8soeti5GLg4hgd2MEmev9gIlOIAS0hIL1ydC1AhL
        rPz3nB2ipplJ4u3u3awgCTYBbYlXb28wg9giQEX7O1pZQIqYBboYJXo6TzGBJIQFnCXWrjrP
        BmKzCKhKTDg6DWwzr4CNxMLDZ1khNshLrN5wAGwQp4CtxLyp68HiQkA1U18sYJzAyLeAkWEV
        o2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwUGlp7mDcvuqD3iFGJg7GQ4wSHMxKIrwl
        u6YmCfGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cB0VJV1
        k27D/H8LTTUUHPs+Hfmm5v7yRqNMZ0ecivkFs5AFgt98lh0VbSnq5bSKmvqW5WK9Citv/vI/
        MhdWrrOW2K869dWXEJ4vx3nnzpXy0drl4vxxz/fEttizSevq00RbqlPWvAifKeyX9pXrGtt+
        Tb3ghO/L7n118Om5e3v5eZnA3qNRr5ynr7imeX7zP3NHK9aeKE/f4ENXHx7mMCwRXP+La5My
        o6r1ffEaNf8f3flOIf+WSFUbRE0SUv2TleWqxsV3KmOby9rl/NP+r1qVkfN8yYkegdLD3JPC
        1H98Y5EW3ho2k5n7sxgX02KzmBkvji+wWvv6lHLc263rdJ41GqSFfY544ixuYTM3q0GJpTgj
        0VCLuag4EQA5OE0ImQIAAA==
X-CMS-MailID: 20220531133741epcas5p16383da97824ffedd50f5e3231d09430e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133741epcas5p16383da97824ffedd50f5e3231d09430e
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133741epcas5p16383da97824ffedd50f5e3231d09430e@epcas5p1.samsung.com>
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
index 4ee536a0..8182322b 100755
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

