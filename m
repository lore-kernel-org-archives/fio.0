Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ECFEB64DD
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbjHKHrY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjHKHrV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:47:21 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8A2D52
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:47:17 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230811074715epoutp027b4a864332b73ccfbbae91462f849ea2~6RJlqY4EP2840728407epoutp02n
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:47:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230811074715epoutp027b4a864332b73ccfbbae91462f849ea2~6RJlqY4EP2840728407epoutp02n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740035;
        bh=eyAlKVxTVebxREjzXmsRi6NbvcPVRLsVEF8359d1Pv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYGBDwFbEq1V7ScNkuilx1nwnxvLYebErvdvxgOYmqQBZ/N2O8kQpjLe+P+aUesp+
         QRDVsP6qd2iJ2MqTB9XB2TqrchCDLAwJOM2Hi5FC2l2nU3Xf/5EKvib8SGBi5keRpI
         4ZYJthcqZ/XsaDR1RI6dzXU/+/Qo/fuG7hSVLUxY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230811074715epcas5p28bf18493b8aee4cea5befd1c16aabb8b~6RJlUVPb61855618556epcas5p2A;
        Fri, 11 Aug 2023 07:47:15 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RMbV94pT1z4x9Q2; Fri, 11 Aug
        2023 07:47:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.59.57354.187E5D46; Fri, 11 Aug 2023 16:47:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060645epcas5p1715aa40476d539b21e2507ff17a88dd4~6Px14nDPe2171421714epcas5p1P;
        Fri, 11 Aug 2023 06:06:45 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230811060645epsmtrp15c95b7255280029e9ad91b7870b0f0d2~6Px13_Jq93264632646epsmtrp1z;
        Fri, 11 Aug 2023 06:06:45 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-02-64d5e7815a99
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.E0.14748.5FFC5D46; Fri, 11 Aug 2023 15:06:45 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060644epsmtip16a9aa18d44f3cb69d0d9f68e96d2edbb~6Px0vCdhg0091300913epsmtip1Z;
        Fri, 11 Aug 2023 06:06:44 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 08/10] crc: pull required crc64 nvme apis from linux
 kernel
Date:   Fri, 11 Aug 2023 16:55:45 +0530
Message-Id: <20230811112547.92345-9-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmhm7j86spBtueKFmsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOmLJEomCFS8W391NZGhhXWncxcnJICJhIPDo8mbWLkYtDSGA3o8TXCW0sEM4nRok7
        L9czQjjfGCU23XwG5HCAtZyYEg8R38soMaHlMFR7J5NE77Q2NpC5bALaEq/e3mAGaRAR0JBY
        czcVpIZZoIVRYnf3bFaQGmGBAIlL/88ygtgsAqoSd/ZsZAGxeQVsJP7MO8EGcZ+8xMxL39lB
        5nAK2EosWiEGUSIocXLmE7ByZqCS5q2zmSHKP7JLbL1iC2G7SGw4Pw9qjLDEq+Nb2CFsKYmX
        /W1QdrbEpoc/mSDsAokjL3qh5thLtJ7qBzufWUBTYv0ufYiwrMTUU+uYINbySfT+fgLVyiux
        Yx6MrSrx995tFghbWuLmu6tQtofE9mVboYE7gVHi2uvDbBMYFWYheWcWkndmIaxewMi8ilEy
        taA4Nz012bTAMC+1HB7Fyfm5mxjBSVPLZQfjjfn/9A4xMnEwHmKU4GBWEuG1Db6UIsSbklhZ
        lVqUH19UmpNafIjRFBjcE5mlRJPzgWk7ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs
        1NSC1CKYPiYOTqkGJq8YoZu6KdM19CdcvWQjZcAbbnr3QZ1QwJr/NaFrVIKNxTbeWvricOmq
        6iyGhLKLhp/rODpFcpU1/zD1/PVhd7vD43e/i9dM4t29I+Eh/bM3qXc9UjgaasvfFmn69riG
        TfTb1m/qEhWZ07iWFvifDwjsCGq8vCExv/AL505e1o87e+c2118tX3+Lef8KhnvNDkqPNuqv
        01eZv+KQVc3yEDtnBpfQVc0nc0/lRsd1JOhtXX448+mOw5VpyspScT/YdDwCLjwQSpxmu//7
        if9y63y2uTJPWecfutCu6cDhjCMWXGlNvQ/mL7u6eV3EmVJ+kW82DN9magXcvHElMYVLdJds
        d1r7mfxPlfrJDL5KLMUZiYZazEXFiQA/sk7NIwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSnO7X81dTDD6e17RYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MqYskSiYIVLxbf3U1kaGFdadzFycEgImEicmBLfxcjFISSw
        m1Gice0nVoi4tMTC9YldjJxAprDEyn/P2SFq2pkklvf9ZgFJsAloS7x6e4MZxBYR0JI4tq6J
        DaSIWaCLUWLv7mlsIAlhAT+JtY8nsIPYLAKqEnf2bARr5hWwkfgz7wQbxAZ5iZmXvrODLOYU
        sJVYtEIMJCwEVPJq5m82iHJBiZMzn4C1MgOVN2+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OT
        DQsM81LL9YoTc4tL89L1kvNzNzGCw1pLYwfjvfn/9A4xMnEwHmKU4GBWEuG1Db6UIsSbklhZ
        lVqUH19UmpNafIhRmoNFSZzXcMbsFCGB9MSS1OzU1ILUIpgsEwenVAOT+99Y1kXTc36riPe0
        GebUn697deL0PbFH3+7cmXzmiaXMtxOhvwO7Yl5v33By1v/iKrnvjz/kTJfOYHH9c4Pb71Gv
        m8Snr/0VGls7v347yd6QsGZpWcsW1wmlTEWiJZyPear83L+98193y+ZzjzzDIt6CqrvenKyF
        ae4XtJ9G3Hl+Xm5m0BqH6NAFkvHvpE9PWzFhxSuttr5iEcH6aZlz42o3PL+ns8X/Y0/05Itq
        zDqP85zD1tcZtS336zCTmntgu+eSfp9v97613jdj33GoIljIU+lacrvrgftVZaq9+6dUJlfI
        3a0RPXxeWGdOnZv0s7Xu50V5pk2/bmu9Xue9j0H5NNfTH0/ctzzkduWLEktxRqKhFnNRcSIA
        LprXINoCAAA=
X-CMS-MailID: 20230811060645epcas5p1715aa40476d539b21e2507ff17a88dd4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060645epcas5p1715aa40476d539b21e2507ff17a88dd4
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060645epcas5p1715aa40476d539b21e2507ff17a88dd4@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Pull the required nvme crc64 apis and table from the linux kernel. This
is required to generate and verify 64 bit guard tag for nvme backend
of io_uring_cmd ioengine.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 crc/crc64.c      |  32 ++++++++++++
 crc/crc64.h      |   3 ++
 crc/crc64table.h | 130 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)
 create mode 100644 crc/crc64table.h

diff --git a/crc/crc64.c b/crc/crc64.c
index bf24a97b..c910e5b8 100644
--- a/crc/crc64.c
+++ b/crc/crc64.c
@@ -1,4 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * crc64nvme[256] table is from the generator polynomial specified by NVMe
+ * 64b CRC and is defined as,
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
@@ -102,3 +114,23 @@ unsigned long long fio_crc64(const unsigned char *buffer, unsigned long length)
 	return crc;
 }
 
+/**
+ * fio_crc64_nvme - Calculate bitwise NVMe CRC64
+ * @crc: seed value for computation. 0 for a new CRC calculation, or the
+ * 	 previous crc64 value if computing incrementally.
+ * @p: pointer to buffer over which CRC64 is run
+ * @len: length of buffer @p
+ */
+unsigned long long fio_crc64_nvme(unsigned long long crc, const void *p,
+				  unsigned int len)
+{
+	const unsigned char *_p = p;
+	unsigned int i;
+
+	crc = ~crc;
+
+	for (i = 0; i < len; i++)
+		crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *_p++];
+
+	return ~crc;
+}
diff --git a/crc/crc64.h b/crc/crc64.h
index fe9cad3e..e586edee 100644
--- a/crc/crc64.h
+++ b/crc/crc64.h
@@ -3,4 +3,7 @@
 
 unsigned long long fio_crc64(const unsigned char *, unsigned long);
 
+unsigned long long fio_crc64_nvme(unsigned long long crc, const void *p,
+				  unsigned int len);
+
 #endif
diff --git a/crc/crc64table.h b/crc/crc64table.h
new file mode 100644
index 00000000..04224d4f
--- /dev/null
+++ b/crc/crc64table.h
@@ -0,0 +1,130 @@
+static const unsigned long long crc64nvmetable[256] = {
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

