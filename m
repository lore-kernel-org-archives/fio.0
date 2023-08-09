Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A0CC04A6A
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjHIGD0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjHIGDZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:25 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED781FDC
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:03:13 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230809060311epoutp034d9c05d896ef9879f75320e44e5e03d6~5ocJ2a2ir2120421204epoutp03W
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:03:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230809060311epoutp034d9c05d896ef9879f75320e44e5e03d6~5ocJ2a2ir2120421204epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560991;
        bh=Jw6wnocXNCmlZnIJjIgce7XfbwW8Umqn8ddeVuG3anw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDUtBTDeMwkBXy0fRkggU0SpCNKUw4UEziN8DZKiUfDSMwI2FUhF52S4dPYIlrfXm
         M8AgoErful8k0Jk3WkNX1lQWrFMjNIF7X2JqO0ZP+B3q3k+V9wzxtmxQiTjZpfg/KZ
         afItt8FLx/b/3qdrJa67pTosxMyC8ZoG2CohnNO0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230809060311epcas5p2d51d4368b2536ddcb0c7139c5172682d~5ocJc-iE_1913319133epcas5p2L;
        Wed,  9 Aug 2023 06:03:11 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RLKH16cL8z4x9Pt; Wed,  9 Aug
        2023 06:03:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.5E.57354.D1C23D46; Wed,  9 Aug 2023 15:03:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230809055423epcas5p3dc7782753e9e60522b4adc749edc8426~5oUdnug781080510805epcas5p3o;
        Wed,  9 Aug 2023 05:54:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230809055423epsmtrp28b02fe94f21042f6b063a5762e98db70~5oUdm_B4j0724607246epsmtrp2C;
        Wed,  9 Aug 2023 05:54:23 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-c3-64d32c1dfa19
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.BB.34491.E0A23D46; Wed,  9 Aug 2023 14:54:22 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055421epsmtip1f5ee7aaa8cd02c62aa001edfe2ef8c33~5oUcfqet10678306783epsmtip1v;
        Wed,  9 Aug 2023 05:54:21 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 08/10] crc: pull required rocksoft crc64 apis from linux
 kernel
Date:   Wed,  9 Aug 2023 16:43:12 +0530
Message-Id: <20230809111314.76947-9-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmuq6szuUUg5V3jCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnnGyYy1Jw1qViw6nvLA2Md6y7GDk5JARMJP79vMHaxcjFISSwm1Fix74zTBDOJ0aJ
        6+3rWECqhAS+MUoc6paC6ejc840Romgvo8Sth6vZIZxOJomWvc1sIFVsAtoSr97eYO5i5OAQ
        EdCQWHM3FaSGWaCFUWJ392xWkLiwQKDE3V8aIOUsAqoSG3d9YQKxeQVsJNbtOcwIsUxeYual
        7+wgNqeArcSqNTdYIGoEJU7OfAJmMwPVNG+dzQwyX0LgK7vEiV3b2CCaXSTaz59hhbCFJV4d
        38IOYUtJfH63F6omW2LTw59MEHaBxJEXvcwQtr1E66l+sPuZBTQl1u/ShwjLSkw9tY4JYi+f
        RO/vJ1CtvBI75sHYqhJ/791mgbClJW6+uwple0jM+dvACAnQCYwSa/baTGBUmIXknVlI3pmF
        sHkBI/MqRsnUguLc9NRk0wLDvNRyeBwn5+duYgSnTS2XHYw35v/TO8TIxMF4iFGCg1lJhNc2
        +FKKEG9KYmVValF+fFFpTmrxIUZTYHhPZJYSTc4HJu68knhDE0sDEzMzMxNLYzNDJXHe161z
        U4QE0hNLUrNTUwtSi2D6mDg4pRqYdmclPlvMZWoVve6+78El0cqScb8YZzSfkFzx+EQOf4Go
        3MKjrQYFCdMjTsR+iazaonIhtUxTuqvwVfsDx5clmRnXnC4HCFQfkFKbMvOqwPad66zkxNbr
        +Kzp4Zt8ezFH/JX8eiYzKZNy60L23dfXHJhX/LHz52Opwh0s94rtJIU/P+fxWyj5MulucvJs
        hmKG6AlXjJf6JtTU/rBx5bhsx7N1/eTsi555x4XW75/hE5FSnnDOSl6ucGOYGreNdIFgzk/n
        azwb5h4V2bi0MD76sNkKrqDPgfcMMhX3ZfXkiFhEcl3iZPd5tZFXUPzSnI17vv39WXREwPTi
        O665PL16uovuT4xn8ql5u+1svJISS3FGoqEWc1FxIgCgn5z8JAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnC6f1uUUg6Y11hZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbOYdOgao8Xy4/+YLDa0CTqwe+ycdZfd4/LZUo9NqzrZPD4+vcXi0bdlFaPH
        501yAWxRXDYpqTmZZalF+nYJXBknG+ayFJx1qdhw6jtLA+Md6y5GTg4JAROJzj3fGLsYuTiE
        BHYzSpx9sIy9i5EDKCEtsXB9IkSNsMTKf8/ZIWramSS2bXnNDJJgE9CWePX2BpgtIqAlcWxd
        ExtIEbNAF6PE3t3T2EASwgL+Ep+m7AazWQRUJTbu+sIEYvMK2Eis23OYEWKDvMTMS9/ZQWxO
        AVuJVWtusIDYQkA1C99OZIaoF5Q4OfMJWJwZqL5562zmCYwCs5CkZiFJLWBkWsUomVpQnJue
        W2xYYJiXWq5XnJhbXJqXrpecn7uJERzcWpo7GLev+qB3iJGJg/EQowQHs5IIr23wpRQh3pTE
        yqrUovz4otKc1OJDjNIcLErivOIvelOEBNITS1KzU1MLUotgskwcnFINTLoWZte9fqY99T7Q
        deBstbBXf15ukN3PGRJhWY5LDt44W2sx/4fQbZtuxSv5CyfoVkRPnr7rwzavKTXVy7ZvCbmq
        eMjmKYPHmaZP3Fd9zs9OXPJ6g/KboGCftTvXXmzPm1I2MeRec/rmjhnKOtu+2ez7J8HQ1OtT
        8GDzxX8n/qpxvtNX+eJmf6j7w6zEi71RRWVMAstuzND8HJf2ZNmm8mlTFqXvXrF945UNu9eL
        zXHq/r3x/8KFUa86ZWYEvnx/b8W8Hz63ojzirdUf1100LIoMSotlSYwPiJRt2b5s1fWr0y49
        YjriICzpW39xUkKvqkTn6vlzNffZsZSsfTFNxd17wpsQj+fizDsicq8azK5TYinOSDTUYi4q
        TgQAJGYSJ90CAAA=
X-CMS-MailID: 20230809055423epcas5p3dc7782753e9e60522b4adc749edc8426
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055423epcas5p3dc7782753e9e60522b4adc749edc8426
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055423epcas5p3dc7782753e9e60522b4adc749edc8426@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Pull the required rocksoft crc64 apis from the linux kernel. This
is required to generate and verify 64 bit guard tag for nvme backend
of io_uring_cmd ioengine.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 crc/crc64.c      |  31 +++++++++++
 crc/crc64.h      |   4 ++
 crc/crc64table.h | 132 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+)
 create mode 100644 crc/crc64table.h

diff --git a/crc/crc64.c b/crc/crc64.c
index bf24a97b..8b703066 100644
--- a/crc/crc64.c
+++ b/crc/crc64.c
@@ -1,4 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * crc64rocksoft[256] table is from the Rocksoft specification polynomial
+ * defined as,
+ *
+ * x^64 + x^63 + x^61 + x^59 + x^58 + x^56 + x^55 + x^52 + x^49 + x^48 + x^47 +
+ * x^46 + x^44 + x^41 + x^37 + x^36 + x^34 + x^32 + x^31 + x^28 + x^26 + x^23 +
+ * x^22 + x^19 + x^16 + x^13 + x^12 + x^10 + x^9 + x^6 + x^4 + x^3 + 1
+ *
+ */
+
 #include "crc64.h"
+#include "crc64table.h"
 
 /*
  * poly 0x95AC9329AC4BC9B5ULL and init 0xFFFFFFFFFFFFFFFFULL
@@ -102,3 +114,22 @@ unsigned long long fio_crc64(const unsigned char *buffer, unsigned long length)
 	return crc;
 }
 
+/**
+ * crc64_rocksoft_generic - Calculate bitwise Rocksoft CRC64
+ * @crc: seed value for computation. 0 for a new CRC calculation, or the
+ * 	 previous crc64 value if computing incrementally.
+ * @p: pointer to buffer over which CRC64 is run
+ * @len: length of buffer @p
+ */
+__u64 fio_crc64_rocksoft_generic(__u64 crc, const void *p, unsigned int len)
+{
+	const unsigned char *_p = p;
+	unsigned int i;
+
+	crc = ~crc;
+
+	for (i = 0; i < len; i++)
+		crc = (crc >> 8) ^ crc64rocksofttable[(crc & 0xff) ^ *_p++];
+
+	return ~crc;
+}
diff --git a/crc/crc64.h b/crc/crc64.h
index fe9cad3e..7f39c573 100644
--- a/crc/crc64.h
+++ b/crc/crc64.h
@@ -1,6 +1,10 @@
 #ifndef CRC64_H
 #define CRC64_H
 
+#include <linux/types.h>
+
 unsigned long long fio_crc64(const unsigned char *, unsigned long);
 
+__u64 fio_crc64_rocksoft_generic(__u64 crc, const void *p, unsigned int len);
+
 #endif
diff --git a/crc/crc64table.h b/crc/crc64table.h
new file mode 100644
index 00000000..e43eb70e
--- /dev/null
+++ b/crc/crc64table.h
@@ -0,0 +1,132 @@
+#include <linux/types.h>
+
+static const __u64 crc64rocksofttable[256] = {
+	0x0000000000000000ULL, 	0x7f6ef0c830358979ULL,
+	0xfedde190606b12f2ULL, 	0x81b31158505e9b8bULL,
+	0xc962e5739841b68fULL, 	0xb60c15bba8743ff6ULL,
+	0x37bf04e3f82aa47dULL, 	0x48d1f42bc81f2d04ULL,
+	0xa61cecb46814fe75ULL, 	0xd9721c7c5821770cULL,
+	0x58c10d24087fec87ULL, 	0x27affdec384a65feULL,
+	0x6f7e09c7f05548faULL, 	0x1010f90fc060c183ULL,
+	0x91a3e857903e5a08ULL, 	0xeecd189fa00bd371ULL,
+	0x78e0ff3b88be6f81ULL, 	0x078e0ff3b88be6f8ULL,
+	0x863d1eabe8d57d73ULL, 	0xf953ee63d8e0f40aULL,
+	0xb1821a4810ffd90eULL, 	0xceecea8020ca5077ULL,
+	0x4f5ffbd87094cbfcULL, 	0x30310b1040a14285ULL,
+	0xdefc138fe0aa91f4ULL, 	0xa192e347d09f188dULL,
+	0x2021f21f80c18306ULL, 	0x5f4f02d7b0f40a7fULL,
+	0x179ef6fc78eb277bULL, 	0x68f0063448deae02ULL,
+	0xe943176c18803589ULL, 	0x962de7a428b5bcf0ULL,
+	0xf1c1fe77117cdf02ULL, 	0x8eaf0ebf2149567bULL,
+	0x0f1c1fe77117cdf0ULL, 	0x7072ef2f41224489ULL,
+	0x38a31b04893d698dULL, 	0x47cdebccb908e0f4ULL,
+	0xc67efa94e9567b7fULL, 	0xb9100a5cd963f206ULL,
+	0x57dd12c379682177ULL, 	0x28b3e20b495da80eULL,
+	0xa900f35319033385ULL, 	0xd66e039b2936bafcULL,
+	0x9ebff7b0e12997f8ULL, 	0xe1d10778d11c1e81ULL,
+	0x606216208142850aULL, 	0x1f0ce6e8b1770c73ULL,
+	0x8921014c99c2b083ULL, 	0xf64ff184a9f739faULL,
+	0x77fce0dcf9a9a271ULL, 	0x08921014c99c2b08ULL,
+	0x4043e43f0183060cULL, 	0x3f2d14f731b68f75ULL,
+	0xbe9e05af61e814feULL, 	0xc1f0f56751dd9d87ULL,
+	0x2f3dedf8f1d64ef6ULL, 	0x50531d30c1e3c78fULL,
+	0xd1e00c6891bd5c04ULL, 	0xae8efca0a188d57dULL,
+	0xe65f088b6997f879ULL, 	0x9931f84359a27100ULL,
+	0x1882e91b09fcea8bULL, 	0x67ec19d339c963f2ULL,
+	0xd75adabd7a6e2d6fULL, 	0xa8342a754a5ba416ULL,
+	0x29873b2d1a053f9dULL, 	0x56e9cbe52a30b6e4ULL,
+	0x1e383fcee22f9be0ULL, 	0x6156cf06d21a1299ULL,
+	0xe0e5de5e82448912ULL, 	0x9f8b2e96b271006bULL,
+	0x71463609127ad31aULL, 	0x0e28c6c1224f5a63ULL,
+	0x8f9bd7997211c1e8ULL, 	0xf0f5275142244891ULL,
+	0xb824d37a8a3b6595ULL, 	0xc74a23b2ba0eececULL,
+	0x46f932eaea507767ULL, 	0x3997c222da65fe1eULL,
+	0xafba2586f2d042eeULL, 	0xd0d4d54ec2e5cb97ULL,
+	0x5167c41692bb501cULL, 	0x2e0934dea28ed965ULL,
+	0x66d8c0f56a91f461ULL, 	0x19b6303d5aa47d18ULL,
+	0x980521650afae693ULL, 	0xe76bd1ad3acf6feaULL,
+	0x09a6c9329ac4bc9bULL, 	0x76c839faaaf135e2ULL,
+	0xf77b28a2faafae69ULL, 	0x8815d86aca9a2710ULL,
+	0xc0c42c4102850a14ULL, 	0xbfaadc8932b0836dULL,
+	0x3e19cdd162ee18e6ULL, 	0x41773d1952db919fULL,
+	0x269b24ca6b12f26dULL, 	0x59f5d4025b277b14ULL,
+	0xd846c55a0b79e09fULL, 	0xa72835923b4c69e6ULL,
+	0xeff9c1b9f35344e2ULL, 	0x90973171c366cd9bULL,
+	0x1124202993385610ULL, 	0x6e4ad0e1a30ddf69ULL,
+	0x8087c87e03060c18ULL, 	0xffe938b633338561ULL,
+	0x7e5a29ee636d1eeaULL, 	0x0134d92653589793ULL,
+	0x49e52d0d9b47ba97ULL, 	0x368bddc5ab7233eeULL,
+	0xb738cc9dfb2ca865ULL, 	0xc8563c55cb19211cULL,
+	0x5e7bdbf1e3ac9decULL, 	0x21152b39d3991495ULL,
+	0xa0a63a6183c78f1eULL, 	0xdfc8caa9b3f20667ULL,
+	0x97193e827bed2b63ULL, 	0xe877ce4a4bd8a21aULL,
+	0x69c4df121b863991ULL, 	0x16aa2fda2bb3b0e8ULL,
+	0xf86737458bb86399ULL, 	0x8709c78dbb8deae0ULL,
+	0x06bad6d5ebd3716bULL, 	0x79d4261ddbe6f812ULL,
+	0x3105d23613f9d516ULL, 	0x4e6b22fe23cc5c6fULL,
+	0xcfd833a67392c7e4ULL, 	0xb0b6c36e43a74e9dULL,
+	0x9a6c9329ac4bc9b5ULL, 	0xe50263e19c7e40ccULL,
+	0x64b172b9cc20db47ULL, 	0x1bdf8271fc15523eULL,
+	0x530e765a340a7f3aULL, 	0x2c608692043ff643ULL,
+	0xadd397ca54616dc8ULL, 	0xd2bd67026454e4b1ULL,
+	0x3c707f9dc45f37c0ULL, 	0x431e8f55f46abeb9ULL,
+	0xc2ad9e0da4342532ULL, 	0xbdc36ec59401ac4bULL,
+	0xf5129aee5c1e814fULL, 	0x8a7c6a266c2b0836ULL,
+	0x0bcf7b7e3c7593bdULL, 	0x74a18bb60c401ac4ULL,
+	0xe28c6c1224f5a634ULL, 	0x9de29cda14c02f4dULL,
+	0x1c518d82449eb4c6ULL, 	0x633f7d4a74ab3dbfULL,
+	0x2bee8961bcb410bbULL, 	0x548079a98c8199c2ULL,
+	0xd53368f1dcdf0249ULL, 	0xaa5d9839ecea8b30ULL,
+	0x449080a64ce15841ULL, 	0x3bfe706e7cd4d138ULL,
+	0xba4d61362c8a4ab3ULL, 	0xc52391fe1cbfc3caULL,
+	0x8df265d5d4a0eeceULL, 	0xf29c951de49567b7ULL,
+	0x732f8445b4cbfc3cULL, 	0x0c41748d84fe7545ULL,
+	0x6bad6d5ebd3716b7ULL, 	0x14c39d968d029fceULL,
+	0x95708ccedd5c0445ULL, 	0xea1e7c06ed698d3cULL,
+	0xa2cf882d2576a038ULL, 	0xdda178e515432941ULL,
+	0x5c1269bd451db2caULL, 	0x237c997575283bb3ULL,
+	0xcdb181ead523e8c2ULL, 	0xb2df7122e51661bbULL,
+	0x336c607ab548fa30ULL, 	0x4c0290b2857d7349ULL,
+	0x04d364994d625e4dULL, 	0x7bbd94517d57d734ULL,
+	0xfa0e85092d094cbfULL, 	0x856075c11d3cc5c6ULL,
+	0x134d926535897936ULL, 	0x6c2362ad05bcf04fULL,
+	0xed9073f555e26bc4ULL, 	0x92fe833d65d7e2bdULL,
+	0xda2f7716adc8cfb9ULL, 	0xa54187de9dfd46c0ULL,
+	0x24f29686cda3dd4bULL, 	0x5b9c664efd965432ULL,
+	0xb5517ed15d9d8743ULL, 	0xca3f8e196da80e3aULL,
+	0x4b8c9f413df695b1ULL, 	0x34e26f890dc31cc8ULL,
+	0x7c339ba2c5dc31ccULL, 	0x035d6b6af5e9b8b5ULL,
+	0x82ee7a32a5b7233eULL, 	0xfd808afa9582aa47ULL,
+	0x4d364994d625e4daULL, 	0x3258b95ce6106da3ULL,
+	0xb3eba804b64ef628ULL, 	0xcc8558cc867b7f51ULL,
+	0x8454ace74e645255ULL, 	0xfb3a5c2f7e51db2cULL,
+	0x7a894d772e0f40a7ULL, 	0x05e7bdbf1e3ac9deULL,
+	0xeb2aa520be311aafULL, 	0x944455e88e0493d6ULL,
+	0x15f744b0de5a085dULL, 	0x6a99b478ee6f8124ULL,
+	0x224840532670ac20ULL, 	0x5d26b09b16452559ULL,
+	0xdc95a1c3461bbed2ULL, 	0xa3fb510b762e37abULL,
+	0x35d6b6af5e9b8b5bULL, 	0x4ab846676eae0222ULL,
+	0xcb0b573f3ef099a9ULL, 	0xb465a7f70ec510d0ULL,
+	0xfcb453dcc6da3dd4ULL, 	0x83daa314f6efb4adULL,
+	0x0269b24ca6b12f26ULL, 	0x7d0742849684a65fULL,
+	0x93ca5a1b368f752eULL, 	0xeca4aad306bafc57ULL,
+	0x6d17bb8b56e467dcULL, 	0x12794b4366d1eea5ULL,
+	0x5aa8bf68aecec3a1ULL, 	0x25c64fa09efb4ad8ULL,
+	0xa4755ef8cea5d153ULL, 	0xdb1bae30fe90582aULL,
+	0xbcf7b7e3c7593bd8ULL, 	0xc399472bf76cb2a1ULL,
+	0x422a5673a732292aULL, 	0x3d44a6bb9707a053ULL,
+	0x759552905f188d57ULL, 	0x0afba2586f2d042eULL,
+	0x8b48b3003f739fa5ULL, 	0xf42643c80f4616dcULL,
+	0x1aeb5b57af4dc5adULL, 	0x6585ab9f9f784cd4ULL,
+	0xe436bac7cf26d75fULL, 	0x9b584a0fff135e26ULL,
+	0xd389be24370c7322ULL, 	0xace74eec0739fa5bULL,
+	0x2d545fb4576761d0ULL, 	0x523aaf7c6752e8a9ULL,
+	0xc41748d84fe75459ULL, 	0xbb79b8107fd2dd20ULL,
+	0x3acaa9482f8c46abULL, 	0x45a459801fb9cfd2ULL,
+	0x0d75adabd7a6e2d6ULL, 	0x721b5d63e7936bafULL,
+	0xf3a84c3bb7cdf024ULL, 	0x8cc6bcf387f8795dULL,
+	0x620ba46c27f3aa2cULL, 	0x1d6554a417c62355ULL,
+	0x9cd645fc4798b8deULL, 	0xe3b8b53477ad31a7ULL,
+	0xab69411fbfb21ca3ULL, 	0xd407b1d78f8795daULL,
+	0x55b4a08fdfd90e51ULL, 	0x2ada5047efec8728ULL,
+};
-- 
2.25.1

