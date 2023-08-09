Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AF0EB64DD
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjHIGDX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjHIGDW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:22 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9EE2111
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:03:07 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230809060306epoutp0145b508857a0705914311261aad232cbc~5ocEuUlzB3201432014epoutp01T
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:03:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230809060306epoutp0145b508857a0705914311261aad232cbc~5ocEuUlzB3201432014epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560986;
        bh=CLm+RWZgaLTHnXOJ4GTabVgSgEpqDa+x6yIeHPtMINU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qus4PuciOs6tk+FF7N2Czaa9uXmrdCL3q/aGPEIufg8dGveoI4AYj3nCTTYFykjoA
         MoDlHFBes2XJX6mGPXlOjBWQgjEVqRqbr78svqMT4I+vHwQlNLVyXGSKH4aT4mXRPc
         kP3Icqm8FklnNs64O0algo0Qno29c4RU1L6WYQMk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230809060305epcas5p42c16d3f79db5ea6cf58a0ce9fa102761~5ocESWF311789317893epcas5p4E;
        Wed,  9 Aug 2023 06:03:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RLKGw0jRQz4x9Px; Wed,  9 Aug
        2023 06:03:04 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.D1.55522.71C23D46; Wed,  9 Aug 2023 15:03:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055420epcas5p1ad0cf0a20f2d91668d141b25c1d12b14~5oUbMd4931424614246epcas5p1k;
        Wed,  9 Aug 2023 05:54:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230809055420epsmtrp2f7d920004c557df04c63f20649706ff0~5oUbLz3Zt0724507245epsmtrp2_;
        Wed,  9 Aug 2023 05:54:20 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-fd-64d32c1745c1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.BB.34491.C0A23D46; Wed,  9 Aug 2023 14:54:20 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055419epsmtip1ddbbef1107cdf94ca4b10700e1648332~5oUaCPjUU0789507895epsmtip1D;
        Wed,  9 Aug 2023 05:54:19 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 06/10] crc: pull required crc16-t10 files from linux kernel
Date:   Wed,  9 Aug 2023 16:43:10 +0530
Message-Id: <20230809111314.76947-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmpq64zuUUg+MHrSzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnrNnwnqlguWpFw5dr7A2Mt+W6GDk5JARMJDYsOcPYxcjFISSwm1Hi4547LBDOJ0aJ
        I7cvQ2W+MUo8vTyREaZl2vnvzBCJvYwSN9buZAJJCAl0Mkn8XZIHYrMJaEu8ensDqIiDQ0RA
        Q2LN3VSQemaBFkaJ3d2zWUFqhAW8Jfo/z2QDsVkEVCX2zb7OAmLzCthI3H/RyQaxTF5i5qXv
        7CA2p4CtxKo1N6BqBCVOznwCZjMD1TRvnQ12kITAR3aJO9cnskM0u0jsfHWNGcIWlnh1fAtU
        XEri87u9UAuyJTY9/MkEYRdIHHnRC1VvL9F6qh/sAWYBTYn1u/QhwrISU0+tY4LYyyfR+/sJ
        VCuvxI55MLaqxN97t1kgbGmJm++uQtkeEneXz4MG3ARGiVUvTzBNYFSYheSfWUj+mYWwegEj
        8ypGydSC4tz01GLTAsO81HJ4LCfn525iBKdOLc8djHcffNA7xMjEwXiIUYKDWUmE1zb4UooQ
        b0piZVVqUX58UWlOavEhRlNggE9klhJNzgcm77ySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATS
        E0tSs1NTC1KLYPqYODilGpgqds9WTVT9cNfI46LLjKn+Qq+NtguKXjV1kXQV3S+4rOcPf4FI
        4IPplhens8kejDd93lLz+03KctvYvQ8sI11mmQv7uUkkm6RntsZWrH2SmuScLdtR4/xsAqe5
        zPKznqusFn38cZL/1xHLac0FZ9fdlHvTeIpp+fu3WRXTFiWvL7G/zD25zriwXlS98KTzu4K4
        myd3tmzhvGdqaxmuaq3vFdejF+oiUvzN0WzpCf1XhS3FpzM/+3gyXDgQonI5M37HO5MEXsP3
        3n5SoiJabx7PDE51a667qLp22dpGrcCSP0vsOT8k1DwOX73OyD0790zJhWvttxJ3Xwv/PDto
        ZeZGHtWUrFYP+dscvHcfKbEUZyQaajEXFScCAN40vgUmBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnC6P1uUUg50/RSzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDLWbHjPVLBctaLhyzX2Bsbbcl2MnBwSAiYS085/Z+5i5OIQ
        EtjNKNH3chJbFyMHUEJaYuH6RIgaYYmV/56zQ9S0M0n0HuhkA0mwCWhLvHp7gxnEFhHQkji2
        rokNpIhZoItRYu/uaWBFwgLeEv2fZ4LZLAKqEvtmX2cBsXkFbCTuv4AYJCEgLzHz0nd2EJtT
        wFZi1ZobYDVCQDUL305khqgXlDg58wlYnBmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55b
        bFhgmJdarlecmFtcmpeul5yfu4kRHNxamjsYt6/6oHeIkYmD8RCjBAezkgivbfClFCHelMTK
        qtSi/Pii0pzU4kOM0hwsSuK84i96U4QE0hNLUrNTUwtSi2CyTBycUg1MZn0aK/Q17Pdz+vzr
        Dun3sUheUb6zcOt8p8lP/GTLtaxMlToysh/oztZh2Hn9lsI5jRk7V5SI3Vj522aboEHQ5MU8
        R489FF4U2Mvya+l2rY7Uct6/U3rbf8zVO9hwOaJPTT2gmlv5Ydn+nd/OhvuWXZvcb7KvtVF4
        S+WRb2uf/zt7vOaqpZjUZf2F+a1P+5cs9d95ieWltY1Bu+fburuf9nqbCPI8zw4I8Nu+x3U6
        d9M0SQPHqIN3855mH7pUqRQV8ObI+cSlS93Erm2eGGFrurVYnHP+afNdqS/l2XtSNE3O+b8t
        u7bSN+i/Z8J+Hcvtp66+/Dl3O1v8wwdhItPVpotz6dyYumf9y0Mu9u/1lFiKMxINtZiLihMB
        54MUGd0CAAA=
X-CMS-MailID: 20230809055420epcas5p1ad0cf0a20f2d91668d141b25c1d12b14
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055420epcas5p1ad0cf0a20f2d91668d141b25c1d12b14
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055420epcas5p1ad0cf0a20f2d91668d141b25c1d12b14@epcas5p1.samsung.com>
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

