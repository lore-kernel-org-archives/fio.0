Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6DCC04A6A
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjHKHrK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjHKHrJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:47:09 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F22211B
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:47:09 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230811074707epoutp0295ad2e0c7d36db6a0d93a421609ad20c~6RJeAxFry2716427164epoutp02S
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:47:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230811074707epoutp0295ad2e0c7d36db6a0d93a421609ad20c~6RJeAxFry2716427164epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740027;
        bh=CLm+RWZgaLTHnXOJ4GTabVgSgEpqDa+x6yIeHPtMINU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3YpvoKOL0Tpvn6lHCESO3GsmhqwJfMEiHAIr0xdMmoSAxOsGchwfbsxx5dsseE8U
         D+SJfXZpm8kE6vvu5J4dbkBFoOhaCrpFg5mjIRDvosEk3jiXsZcshICWr4TuqFmCev
         BKjvFq07oHFT7rIfEf5wjQ/zUTDjRYopnOD2L/74=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230811074707epcas5p2083be8ac0751037c98687bafacdd3cc3~6RJdxyVn81138711387epcas5p2k;
        Fri, 11 Aug 2023 07:47:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RMbV12wB8z4x9Pt; Fri, 11 Aug
        2023 07:47:05 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.73.55522.977E5D46; Fri, 11 Aug 2023 16:47:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230811060642epcas5p2262ab4f7aa495c5ebbcdbae5dd5a142c~6PxywnnuW1476614766epcas5p2x;
        Fri, 11 Aug 2023 06:06:42 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230811060642epsmtrp1ea87cc35f9bbe29f4d9ff4d621092d34~6PxyvxJZ13260432604epsmtrp1R;
        Fri, 11 Aug 2023 06:06:42 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-99-64d5e7795c71
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.60.30535.2FFC5D46; Fri, 11 Aug 2023 15:06:42 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060641epsmtip14ccf73e132e2a77c30be36404f988a8a~6PxxeUk4m3217932179epsmtip13;
        Fri, 11 Aug 2023 06:06:40 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 06/10] crc: pull required crc16-t10 files from linux
 kernel
Date:   Fri, 11 Aug 2023 16:55:43 +0530
Message-Id: <20230811112547.92345-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmum7l86spBn1XRCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnrNnwnqlguWpFw5dr7A2Mt+W6GDk4JARMJK7vyu9i5OIQEtjNKDG54xAThPOJUeLo
        8T5WCOcbo8TlVVPZYDquLNSGiO9llJhz/BkbhNPJJLFtwmOWLkZODjYBbYlXb28wgzSICGhI
        rLmbClLDLNDCKLG7ezYrSI2wQIDEqQsr2UBsFgFVidX3jjOB2LwCNhI/FrWBzZEQkJeYeek7
        O8gcTgFbiUUrxCBKBCVOznwCVsIMVNK8dTYzyHwJgY/sEq1vepkhel0kOpddYYKwhSVeHd/C
        DmFLSbzsb4OysyU2PfwJVVMgceQFTK+9ROupfrD7mQU0Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQ
        rbwSO+bB2KoSf+/dhjpfWuLmu6tQtofE8+0nmSFhNYFRYt+ZiYwTGBVmIflnFpJ/ZiGsXsDI
        vIpRMrWgODc9tdi0wDAvtRwex8n5uZsYwWlTy3MH490HH/QOMTJxMB5ilOBgVhLhtQ2+lCLE
        m5JYWZValB9fVJqTWnyI0RQY3hOZpUST84GJO68k3tDE0sDEzMzMxNLYzFBJnPd169wUIYH0
        xJLU7NTUgtQimD4mDk6pBqatf/7Kih7L/++R0aw7f0tGs2I24+KHOau3K+lIr1n9va9T7Out
        zgfbL62qz+Bu/5zh2PrNUj/440J1cSPWZo60P2m+D9L9fM/KPvu1YLnTbMXfj1ebbmL5fP7O
        9ZJZPGeTJri77E34t1lwZpP03ISb4U9ae1u9pls/M2Tu5Vk7NfliEU9UpibTc9+rB7YcnNZz
        Pl5iganghtys0vog/p8yUaZrjj+T9Tovd9p7xu91qy58a92q5bOtOOveM/+ftr99OU7Of7CK
        YQrnLlNrG5Y3P+y2+DxMWHZ39co7N67U722v6Y/qmFy9u/We9azmQzysk7lY3+91/no4bd3m
        9+c+Zv9awtr9ffnjyx9mtQgVKrEUZyQaajEXFScCAB7ix88kBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnO6n81dTDHYsl7BYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MpYs+E9U8Fy1YqGL9fYGxhvy3UxcnBICJhIXFmo3cXIxSEk
        sJtRYsb1a+wQcWmJhesTuxg5gUxhiZX/nrND1LQzSfxZ95odJMEmoC3x6u0NZhBbREBL4ti6
        JjaQImaBLkaJvbunsYEkhAX8JF7vmwvWwCKgKrH63nEmEJtXwEbix6I2FogN8hIzL30HW8wp
        YCuxaIUYSFgIqOTVzN9sEOWCEidnPgErZwYqb946m3kCo8AsJKlZSFILGJlWMUqmFhTnpucW
        GxYY5aWW6xUn5haX5qXrJefnbmIEB7aW1g7GPas+6B1iZOJgPMQowcGsJMJrG3wpRYg3JbGy
        KrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6YklqdmpqQWpRTBZJg5OqQYmQeEMbj6LiIV2Zdxz
        /qf3dmpUnQo+erKSs2Trrpw5TU9PzulY18W0kF9BJDtj8gETjjWqh5+lr3rwaP2FHIaGgBmy
        3VLWoVVHFHKlLt/gcT0Y31F9wc/l8LScVo5/UrekZxUu596//vfO63+Fwx4Vv/8U8FL6TVUY
        U9HaS8x3o6WlA67sWrrmhlnszXmcf98Jt9azzdj675NBaUPruzPfjQrW2ez7zmB+QPvZ4eRa
        Ub/u6ZOefJsvfG8b9+Pj5u9W3Wn76qy7eMnE28/fzPX7bzfN6+LMFeKBO08dOT+bpetHTI5u
        iCS7waMEhS32dptuJR3MOrXEOP+o8oy2ZVdvi5ofnr56SbcM155opZ0/WZVYijMSDbWYi4oT
        AfhZQH7bAgAA
X-CMS-MailID: 20230811060642epcas5p2262ab4f7aa495c5ebbcdbae5dd5a142c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060642epcas5p2262ab4f7aa495c5ebbcdbae5dd5a142c
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060642epcas5p2262ab4f7aa495c5ebbcdbae5dd5a142c@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Pull the required crc16 t10 files from the linux kernel. This is
required to generate and verify guard tag for nvme backend of
io_uring_cmd ioengine.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 crc/crc-t10dif.h       | 10 ++++++
 crc/crct10dif_common.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)
 create mode 100644 crc/crc-t10dif.h
 create mode 100644 crc/crct10dif_common.c

diff --git a/crc/crc-t10dif.h b/crc/crc-t10dif.h
new file mode 100644
index 00000000..22121244
--- /dev/null
+++ b/crc/crc-t10dif.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __CRC_T10DIF_H
+#define __CRC_T10DIF_H
+
+#include <linux/types.h>
+
+extern __u16 fio_crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
+				    unsigned int len);
+
+#endif
diff --git a/crc/crct10dif_common.c b/crc/crct10dif_common.c
new file mode 100644
index 00000000..bd3439fa
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
+#include <stdio.h>
+#include "crc-t10dif.h"
+
+/* Table generated using the following polynomium:
+ * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
+ * gt: 0x8bb7
+ */
+static const __u16 t10_dif_crc_table[256] = {
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
+__u16 fio_crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
+			     unsigned int len)
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

