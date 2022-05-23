Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1A3C433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbiEWQ2p (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238699AbiEWQ2o (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:28:44 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FD668998
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:28:43 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220523162841epoutp03a18256ca90d610d17af50f75ab374d1b~xyM0eYyvL1562815628epoutp03Z
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:28:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220523162841epoutp03a18256ca90d610d17af50f75ab374d1b~xyM0eYyvL1562815628epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323321;
        bh=pNgONEfqSdJ0XNG48jEcuZDftkMXBaeSOqG+8zDe7a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhwZcq2hN+v0bRxjsAkW7zRRAgPHRyfyOkpnP7USZPPqxoRiMwSUGlCE0rro4Guu6
         r0BNqDlH9tpe3mz/Pwgp/9qrd80q6o0vOMOTiCX+VJ1y3o5RKyEcmj8t7Q8hsMGEAk
         p/T0Skl9+u3Ac+an6jej8o2R/aeQvzziSTWe8Ua8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220523162840epcas5p2a95de6949162b85d843beda1640d9442~xyMz_FPQE2515925159epcas5p2Z;
        Mon, 23 May 2022 16:28:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L6N7B61VSz4x9Pp; Mon, 23 May
        2022 16:28:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.DE.09762.636BB826; Tue, 24 May 2022 01:28:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220523131611epcas5p44aef6eae876d30b1d92ab4dc4533eaa5~xvkvjPYDO1988519885epcas5p4r;
        Mon, 23 May 2022 13:16:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220523131611epsmtrp214b7a726951c4d4961f340b426a371c1~xvkviUBRd2951529515epsmtrp2j;
        Mon, 23 May 2022 13:16:11 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-05-628bb636ecf2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.6D.08924.B198B826; Mon, 23 May 2022 22:16:11 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131610epsmtip2ccc556b263760493036b86a78d1334dc~xvkuhWqcj1064510645epsmtip2b;
        Mon, 23 May 2022 13:16:10 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/7] configure: check if uring_cmd support is present
Date:   Mon, 23 May 2022 18:40:33 +0530
Message-Id: <20220523131039.17697-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmuq7Ztu4kg1vndSzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjDVrvrEVdIpWPPgwk72B
        cYFgFyMHh4SAiURjX30XIxeHkMBuRonpa88zdzFyAjmfGCW2LWaFSHxmlFhxdCFYAqThx85X
        7BBFuxglzh+VgihqZZLYPvc/C0iCTUBb4tXbG2ANIgLCEvs7WllAipgFWhglGlevBSsSFnCV
        uHTwGRuIzSKgKvHp9AsmEJtXwEbi9aOtbBDb5CVWbzgANohTwFbizod/zCCDJAS2sUvcvfYQ
        qshF4sXS16wQtrDEq+Nb2CFsKYnP7/ZC1WRLND76C2WXSOy8tR3qHXuJi3v+MoHCgllAU2L9
        Ln2IsKzE1FPrwO5hFuCT6P39hAkiziuxYx6MrSrx995tFghbWuLmu6tQtodE46vn7JBQmcAo
        MfPoT7YJjHKzEFYsYGRcxSiZWlCcm55abFpgnJdaDo+05PzcTYzglKXlvYPx0YMPeocYmTgY
        DzFKcDArifBuT+xIEuJNSaysSi3Kjy8qzUktPsRoCgzAicxSosn5wKSZVxJvaGJpYGJmZmZi
        aWxmqCTOK/C/MUlIID2xJDU7NbUgtQimj4mDU6qBKefE7euR1zQaM6ZumcxrKb/8hYRNQ7by
        p2sBG12TPkmxnSp/yvHqaKj9uvWHGP8KSF7bm3x9Y6TFk6V8NlueX1410/CV3fQKp1mpIY2n
        J3E5PBJdMCs0p9FH0y2c6dXC+t0iPkwsm75e8twwT0Dv543TVgrFoY8kSj3nKUrnnfTJDUmY
        9679nR+LbbpFxmGzS4tjHUP+VVT6vZCdO2u78I1DE1fn1rB1CMk/cnnIqWtWy777w+ZL0jJJ
        DffyT+3uWqm4c4mBQtC5TbLFs1c6Jh6fPdMmeXGf5e4AUfOGBSsP3eo728KTejp9uf/CwpNT
        bzBsVO/hmGSalTffccnLH2eTlLf08HKp/Iw+tOWcoRJLcUaioRZzUXEiABJ8D9ziAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42LZdlhJXle6szvJoH0Nn8WaK7/ZLZom/GW2
        WH23n83i46wXzBZH/79ls1i4cRmTA5vH5bOlHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJWx
        Zs03toJO0YoHH2ayNzAuEOxi5OSQEDCR+LHzFXsXIxeHkMAORonGl9+Zuhg5gBLSEgvXJ0LU
        CEus/PccqqaZSeLL1w5GkASbgLbEq7c3mEFsEaCi/R2tLCBFzAJdjBI9naeYQBLCAq4Slw4+
        YwOxWQRUJT6dfgEW5xWwkXj9aCsbxAZ5idUbDoAN4hSwlbjz4R8zyBFCQDU7foRMYORbwMiw
        ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOKi0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHe
        7YkdSUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwrU7f
        Gruj7tj5z0tLmj/FN5Ue0vI1Uc3W+7ji7KNXrx71bzu39vnj94tZ9D5zujJqhrc8b6/yfNhq
        UvbSYcG1L+F218+9rWINsD4l+ibiX56jTteGnR9uvN9yregt7743Qr+iDPIfczB9mZcx62TQ
        vgOXvq9+YvU9e+L5x2c2qDmE+G+fXjZxj+2b3yF32x0tph3gPjFbeX+Sz3V5Vg+7hG+G8xq2
        7P+T88791Hxr46oXM4umf0s+fXl/S86PqQJ6LB823Ilf9nTuy7YeQem2zzMvd7vptlyYZBvp
        KzmnRcpR7sXU4PbgphIlI44zc2d73DYJ2/pX6bbcmhtbMydIfvvCOyfy0USPIiUumxU5+aZK
        LMUZiYZazEXFiQC4zfJ/mQIAAA==
X-CMS-MailID: 20220523131611epcas5p44aef6eae876d30b1d92ab4dc4533eaa5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131611epcas5p44aef6eae876d30b1d92ab4dc4533eaa5
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131611epcas5p44aef6eae876d30b1d92ab4dc4533eaa5@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The new ioengine io_uring_cmd can be used to send uring passthrough
commands. Check if we have the infrastructure to support it.
To submit nvme passthrough commands, FIO will require libnvme.

This will generate two config flags:
 - CONFIG_URING_CMD
 - CONFIG_LIBNVME

CONFIG_URING_CMD is a prerequisite for libnvme

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 Makefile  |  4 ++++
 configure | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/Makefile b/Makefile
index ed66305a..08f0d6fa 100644
--- a/Makefile
+++ b/Makefile
@@ -235,6 +235,10 @@ ifeq ($(CONFIG_TARGET_OS), Linux)
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
+endif
+ifdef CONFIG_LIBNVME
+  LIBS += $(LIBNVME_LIBS)
+  CFLAGS += $(LIBNVME_CFLAGS)
 endif
   LIBS += -lpthread -ldl
   LDFLAGS += -rdynamic
diff --git a/configure b/configure
index 95b60bb7..a09364f4 100755
--- a/configure
+++ b/configure
@@ -2561,6 +2561,46 @@ fi
 print_config "Zoned block device capacity" "$rep_capacity"
 fi
 
+##########################################
+# Check IORING_OP_URING_CMD
+cat > $TMPC << EOF
+#include <linux/io_uring.h>
+int main(int argc, char **argv)
+{
+  return IORING_OP_URING_CMD;
+}
+EOF
+if compile_prog "" "" "uring cmd"; then
+  output_sym "CONFIG_URING_CMD"
+  uring_cmd="yes"
+else
+  uring_cmd="no"
+fi
+print_config "uring_cmd" "$uring_cmd"
+
+##########################################
+# Check if we have libnvme support
+# uring_cmd is a prerequisite
+# For sending nvme passthrough commands we need the opcodes
+# and nvme_uring_cmd structure introduced in 5.19 kernel
+if test "$uring_cmd" = "yes"; then
+  cat > $TMPC << EOF
+#include <nvme/ioctl.h>
+int main(int argc, char **argv)
+{
+  return NVME_URING_CMD_IO;
+}
+EOF
+  if compile_prog "" "-lnvme" "libnvme"; then
+    libnvme="yes"
+    libnvme_cflags=$(pkg-config --cflags libnvme)
+    libnvme_libs=$(pkg-config --libs libnvme)
+  else
+    libnvme="no"
+  fi
+fi
+print_config "libnvme" "$libnvme"
+
 ##########################################
 # libzbc probe
 cat > $TMPC << EOF
@@ -3212,6 +3252,11 @@ if test "$xnvme" = "yes" ; then
   echo "LIBXNVME_CFLAGS=$xnvme_cflags" >> $config_host_mak
   echo "LIBXNVME_LIBS=$xnvme_libs" >> $config_host_mak
 fi
+if test "$libnvme" = "yes" ; then
+  output_sym "CONFIG_LIBNVME"
+  echo "LIBNVME_CFLAGS=$libnvme_cflags" >> $config_host_mak
+  echo "LIBNVME_LIBS=$libnvme_libs" >> $config_host_mak
+fi
 if test "$dynamic_engines" = "yes" ; then
   output_sym "CONFIG_DYNAMIC_ENGINES"
 fi
-- 
2.17.1

