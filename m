Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F05C433EF
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbiFAJkz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350921AbiFAJkw (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:52 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9675D5DD
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:42 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220601094041epoutp02fd90c837e1145b9a0057fe84ec69ed55~0dcJrzkGU2839228392epoutp02D
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220601094041epoutp02fd90c837e1145b9a0057fe84ec69ed55~0dcJrzkGU2839228392epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076441;
        bh=gV04KS99Biv4BzVp4TcG8hqLRsdpB33tQprXr6r33yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIQZhNwYhGYM/tAZsWalkgileVELrDQU6909pIznkGYXn2uUvMxXAMC4+BjLak/bL
         Mhz8ymN1Z5aUiNgw36ZuX5vsyGCkwURR5Hu+cmWqJak8YTmGBsbHc6ViTyKjPdufgE
         tdrhRd9kCzXXJMY74EghbeRdLDSaaLxSCku8+7UQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220601094040epcas5p2a105f35c7f34cbd8bac02aa633e9822a~0dcJFMh3t0242802428epcas5p2-;
        Wed,  1 Jun 2022 09:40:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LCkfF3wlbz4x9Q0; Wed,  1 Jun
        2022 09:40:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.C0.09762.01437926; Wed,  1 Jun 2022 18:40:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8~0NB6DtwK52562125621epcas5p1-;
        Tue, 31 May 2022 13:37:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133748epsmtrp2774e47be7cc6931c4f654b9d008244c7~0NB6C9Emh0382803828epsmtrp2a;
        Tue, 31 May 2022 13:37:48 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-82-629734108163
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.4E.08924.C2A16926; Tue, 31 May 2022 22:37:48 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133747epsmtip25991f353418322cce6f7c33b5f0d55d3~0NB5FnMWA2552125521epsmtip2t;
        Tue, 31 May 2022 13:37:47 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 7/9] zbd: Check for direct flag only if its block device
Date:   Tue, 31 May 2022 19:01:53 +0530
Message-Id: <20220531133155.17493-8-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmuq6AyfQkgzerzC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjNMXPjIXrBaomPn5PWsD
        43+eLkZODgkBE4lbEy8ydTFycQgJ7GaUOHnrIBuE84lR4vuTz+wQzmdGiYdzZ7HCtEw89Y4V
        IrGLUeLElTlQ/a1MEou2XmIEqWIT0JZ49fYGM4gtIiAssb+jlQWkiFmghVGicfVaFpCEsIC3
        RPOHDrCxLAKqEj86N4M18wrYSBzrX8AIsU5eYvWGA2CDOAVsJeZNXQ+2WkJgG7vE7K83mCCK
        XCR+9R+GahCWeHV8CzuELSXx+d1eNgg7W6Lx0V8ou0Ri563tzBC2vcTFPX+B5nAAXacpsX6X
        PkRYVmLqqXVg45kF+CR6fz+BWsUrsWMejK0q8ffebRYIW1ri5rurULaHROOv74yQUJnAKNHW
        /oVpAqPcLIQVCxgZVzFKphYU56anFpsWGOellsPjLTk/dxMjOHFpee9gfPTgg94hRiYOxkOM
        EhzMSiK8JbumJgnxpiRWVqUW5ccXleakFh9iNAUG4ERmKdHkfGDqzCuJNzSxNDAxMzMzsTQ2
        M1QS5xX435gkJJCeWJKanZpakFoE08fEwSnVwFSWeXDhmpfZ3+z5f1mV/v64hH/XvSdVAeGd
        RwTeWbyIv/BVfdrDe8qhlSVr2sPkXE/u9uks/2sY2fvyxHKnnFMcExyfn7+cLeB8x8d3/+M/
        IdOnJW3i3JwUIpBY9dn0uoB2x5HO+UIqr493TFnlzpYp43ruR1nd0Z/eilf3L3KYsjLM+dP2
        TqEDekceTVq+0Lq1jO3H5dUnuFoV+1kD135huuowfYFpmOkyxUrxJlstlvbQpofVX7b8cfiy
        WfBhi0fW41XPVd7LLPr8cPMUV6tvO0I5cmKLXAxv/vz4aeusNDneA97sk2eViWhzThBguOoR
        s1Ws6KFL8bOficXz1z/3X77826Vs77R5f3bflNVWYinOSDTUYi4qTgQAchXk7eUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42LZdlhJXldHalqSwaWduhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        6QsfmQtWC1TM/PyetYHxP08XIyeHhICJxMRT71i7GLk4hAR2MEqcu3ObpYuRAyghLbFwfSJE
        jbDEyn/P2SFqmpkk5uw6zAySYBPQlnj19gaYLQJUtL+jlQWkiFmgi1Gip/MUE0hCWMBbovlD
        ByuIzSKgKvGjczMjiM0rYCNxrH8BI8QGeYnVGw6ADeIUsJWYN3U9WL0QUM3UFwsYJzDyLWBk
        WMUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERxWWlo7GPes+qB3iJGJg/EQowQHs5II
        b8muqUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MHne
        6p63LexDpeii7S9WKO95vuSA5QKJf9td2zful/5ufeHbrtnGwa81lt6afDAspKKT8S3b1Wkl
        XXamZ/N/+54tC67Z0LrpGs9MDrf5+/T5meccCf8+T/j4xyWiAROMNsaearjhaHtde5HDuR13
        lj66tpg5nMHfbnGgnMC9b36zV65rsOdqEl89w7m074ubArue3F5/zlcmsgtcj6kf71g/NchW
        NvsG499P7qIbDLS5SzPOKnp3/K79p7W6/J8xQ2eWvogw0/LuLMtO3d3SByZtla7fqnlRp/il
        Q98C3e4yb8tFr/a4vdLID/2qaPj514MEuaQajlsSi786PV90OLq+kuei+s9zN7N3nlgQkaDE
        UpyRaKjFXFScCAA5AapfmgIAAA==
X-CMS-MailID: 20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

nvme-ns generic character devices currently do not support O_DIRECT flag.
Check for fio option for direct flag only if filetype is a block device.

t/zbd skip test case #1 for character devices as they don't require
direct I/O.

Tested-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/zbd/test-zbd-support | 11 ++++++++++-
 zbd.c                  |  4 ++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 7e2fff00..5190ae84 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -229,6 +229,14 @@ require_regular_block_dev() {
 	return 0
 }
 
+require_block_dev() {
+	if [[ -b "$realdev" ]]; then
+		return 0
+	fi
+	SKIP_REASON="$dev is not a block device"
+	return 1
+}
+
 require_seq_zones() {
 	local req_seq_zones=${1}
 	local seq_bytes=$((disk_size - first_sequential_zone_sector * 512))
@@ -251,8 +259,9 @@ require_conv_zones() {
 	return 0
 }
 
-# Check whether buffered writes are refused.
+# Check whether buffered writes are refused for block devices.
 test1() {
+    require_block_dev || return $SKIP_TESTCASE
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
 	    "$(ioengine "psync")" --size="${zone_size}" --thread=1	\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
diff --git a/zbd.c b/zbd.c
index b1fd6b4b..627fb968 100644
--- a/zbd.c
+++ b/zbd.c
@@ -466,7 +466,7 @@ out:
 	return res;
 }
 
-/* Verify whether direct I/O is used for all host-managed zoned drives. */
+/* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
 	struct thread_data *td;
@@ -477,7 +477,7 @@ static bool zbd_using_direct_io(void)
 		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
 			continue;
 		for_each_file(td, f, j) {
-			if (f->zbd_info &&
+			if (f->zbd_info && f->filetype == FIO_TYPE_BLOCK &&
 			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
-- 
2.17.1

