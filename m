Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23216C001DB
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjHNJlu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbjHNJlR (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:17 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E367DA
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:16 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230814094114epoutp020867c17ea5b8e86ee6a8d2f378b429c9~7No9mGy0q2563725637epoutp02w
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230814094114epoutp020867c17ea5b8e86ee6a8d2f378b429c9~7No9mGy0q2563725637epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006074;
        bh=KcRxHgmkKh6npwl+t5y2G127gEnooaRfGEO81ez+L5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRmkcqLGOSD3T+VGY5nKbzLcRDMmUoh8i6R/8nhQNxQP/uxsrvypkPa5PRjQdnnPL
         TYfdAUlKHi9gY0X7+NmUeJmpcxQuxQ4g2dIV0UIvUvJviorgE1cCes1LjaGlQhUoPM
         LgPmnCJKl309WzE89aIJGH/8KTE61WGIfQDPlXjM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230814094114epcas5p29918d430cc26b1e536d91e943d0bc85f~7No9VW3Sp3215632156epcas5p2I;
        Mon, 14 Aug 2023 09:41:14 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RPTtJ1G3Jz4x9Q7; Mon, 14 Aug
        2023 09:41:12 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.24.55173.6B6F9D46; Mon, 14 Aug 2023 18:41:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230814093848epcas5p412a0c5dbf28155c30fe89297135c021d~7Nm1ZoGHY1860318603epcas5p4j;
        Mon, 14 Aug 2023 09:38:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230814093848epsmtrp29e6852fb86256e8a46eec1d6179629e4~7Nm1ZBqDj1882118821epsmtrp2a;
        Mon, 14 Aug 2023 09:38:48 +0000 (GMT)
X-AuditID: b6c32a50-df1ff7000001d785-a1-64d9f6b63105
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.31.64355.826F9D46; Mon, 14 Aug 2023 18:38:48 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093846epsmtip1739c3eb01ece8ea05ef55364efee96a9~7Nmzf9S0I1006510065epsmtip1D;
        Mon, 14 Aug 2023 09:38:45 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 06/10] crc: pull required crc16-t10 files from linux
 kernel
Date:   Mon, 14 Aug 2023 20:27:43 +0530
Message-Id: <20230814145747.114725-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmpu62bzdTDJr+slisufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOuNTUw1ywTrXi674J7A2MZ+W6GDk5JARMJH4d3c/axcjFISSwh1HiTt9SFpCEkMAn
        Ron+e1oQCSB71fmZzF2MHGAdV1bbQsR3Mkqs757DDuF0MklceHyWDaSbTUBb4tXbG2ANIgIa
        EmvupoLUMAu0MErs7p7NClIjLBAgMevsIlaQGhYBVYlde9xBwrwCthJHZ11hgbhOXmLmpe/s
        IDangJ3E/ym/2SFqBCVOznwCVsMMVNO8dTYzyHwJgZfsEh2zOhkhml0kbh+GaJYQEJZ4dXwL
        lC0l8fndXjYIO1ti08OfTBB2gcSRF73MELa9ROupfrD7mQU0Jdbv0ocIy0pMPbWOCWIvn0Tv
        7ydQrbwSO+bB2KoSf+/dhrpfWuLmu6tQtofE3akXGSFhNZFRYuLCK6wTGBVmIflnFpJ/ZiGs
        XsDIvIpRKrWgODc9Ndm0wFA3L7UcHsnJ+bmbGMGJUytgB+PqDX/1DjEycTAeYpTgYFYS4b3l
        fi1FiDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJJucDU3deSbyhiaWBiZmZmYmlsZmhkjjv69a5
        KUIC6YklqdmpqQWpRTB9TBycUg1Mi5IcZDOT9ucc3b1MUeL17Z+1N7c9c/zflfpLk8vlcfaP
        37arw368vv6e+djRhSKTjlzdurteU0CK8fvk3/EmH9JPicziXbwvzvv/Ka3XFnMDdKwcH6V3
        z4vXXHCsVe+ixsXElEflC34zF3/137OaW/zR0X7V+ydmnqxettH2oMnhOdeuHmd9ffD0+3P7
        mM4J8Z2NWfNrqlfmIs+/m3Val9/L1Z128UKkq4qcZwgPW9aqHL452z8f4psgKBhv2HIvX7t0
        W0+nq+HfPjNJY5VDe4PEPq553rQm48zGV9qRm1P1dyycce3ZwtDg+Sf8OuYserjt57MnGut5
        Pjj/U2EttVUuPOy64n//g2VvF/+4/vOoEktxRqKhFnNRcSIADn1L9yUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSnK7Gt5spBgdfclisufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGVcauphLlinWvF13wT2Bsazcl2MHBwSAiYSV1bbdjFycQgJ
        bGeUmD7lDBtEXFpi4frELkZOIFNYYuW/5+wQNe1MElOOPGUESbAJaEu8enuDGcQWEdCSOLau
        iQ2kiFmgi1Fi7+5pYIOEBfwkdj/zBTFZBFQldu1xBynnFbCVODrrCgvEfHmJmZe+s4PYnAJ2
        Ev+n/AazhYBqVi3cywpRLyhxcuYTsHpmoPrmrbOZJzAKzEKSmoUktYCRaRWjaGpBcW56bnKB
        oV5xYm5xaV66XnJ+7iZGcDhrBe1gXLb+r94hRiYOxkOMEhzMSiK8t9yvpQjxpiRWVqUW5ccX
        leakFh9ilOZgURLnVc7pTBESSE8sSc1OTS1ILYLJMnFwSjUwhXbwnjVcdvaAvk1J8lp3R3aT
        cs1ix8ucV99Ne8z4Ni01RCamsPvp775dS0+uexqaXfs+5Os7jdQ5YTfMV3yynvqCR4+9/Hyd
        RmtMcdhxniTxKQU7npQod/UyOZV0J7YInDggxXF11tMr7yWVjY91SPv+nGzsvSut5rZBSsFR
        8TTFC0m3WXld7hkeFeZgiTU/PZ3RP/SfXeSTHo7qZSt5v8Z8y0qZtmi+4RY7Df3f2pnBfavK
        c91rM42CtzmGSSbeaaz4VJH45T1L4NI/Pabfbt1fVOkefMPX+tVuvmdfpsx5Wmg6ueTEmS1v
        62NKlET/x2rw5EzdwFtSWlW04+Db36aTv695pT9tLtfOynQlluKMREMt5qLiRAA8XYg/1gIA
        AA==
X-CMS-MailID: 20230814093848epcas5p412a0c5dbf28155c30fe89297135c021d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093848epcas5p412a0c5dbf28155c30fe89297135c021d
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093848epcas5p412a0c5dbf28155c30fe89297135c021d@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Pull the required crc16 t10 files from the linux kernel. This is
required to generate and verify guard tag for nvme backend of
io_uring_cmd ioengine.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 crc/crc-t10dif.h       |  9 +++++
 crc/crct10dif_common.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 crc/crc-t10dif.h
 create mode 100644 crc/crct10dif_common.c

diff --git a/crc/crc-t10dif.h b/crc/crc-t10dif.h
new file mode 100644
index 00000000..fde4ccd7
--- /dev/null
+++ b/crc/crc-t10dif.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __CRC_T10DIF_H
+#define __CRC_T10DIF_H
+
+extern unsigned short fio_crc_t10dif(unsigned short crc,
+				     const unsigned char *buffer,
+				     unsigned int len);
+
+#endif
diff --git a/crc/crct10dif_common.c b/crc/crct10dif_common.c
new file mode 100644
index 00000000..cfb2a1b1
--- /dev/null
+++ b/crc/crct10dif_common.c
@@ -0,0 +1,78 @@
+/*
+ * Cryptographic API.
+ *
+ * T10 Data Integrity Field CRC16 Crypto Transform
+ *
+ * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
+ * Written by Martin K. Petersen <martin.petersen@oracle.com>
+ * Copyright (C) 2013 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include "crc-t10dif.h"
+
+/* Table generated using the following polynomium:
+ * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
+ * gt: 0x8bb7
+ */
+static const unsigned short t10_dif_crc_table[256] = {
+	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
+	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
+	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
+	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
+	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
+	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
+	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
+	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
+	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
+	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
+	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
+	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
+	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
+	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
+	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
+	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
+	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
+	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
+	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
+	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
+	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
+	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
+	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
+	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
+	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
+	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
+	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
+	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
+	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
+	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
+	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
+	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
+};
+
+extern unsigned short fio_crc_t10dif(unsigned short crc,
+				     const unsigned char *buffer,
+				     unsigned int len)
+{
+	unsigned int i;
+
+	for (i = 0 ; i < len ; i++)
+		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
+
+	return crc;
+}
-- 
2.25.1

