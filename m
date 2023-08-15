Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0D2C41513
	for <fio@archiver.kernel.org>; Tue, 15 Aug 2023 12:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjHOMA6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Aug 2023 08:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbjHOMAb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Aug 2023 08:00:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD31519A1
        for <fio@vger.kernel.org>; Tue, 15 Aug 2023 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=62G70zpHDuK3DRhJtQLzU9zyha6ZscGv15e77tnyj2I=; b=esqgwWdg7g4dNRluTxBLs6vdfE
        DzFkWqaL4f4ox2b2Vi+96cQk4reJj6jf5PSt8+s3DDnd0zCnnwj3i2XyvjmtjgcY0taHYLv+SsOJN
        QlTlt8BUb8HRGvPrF1LW9SDZSYehqeMB5s00Vc4jd94H5Eo/bevJoq/HMma758RFJAZ7cTtb88cMF
        Zh11Tx0lmPQH1bnpdpGDYYrKL5gaFllqBDrdhhUc5N01TpOIk58dQhJwMkYNRB+9ex4NgYECwcg1u
        s9xvKWOJWGMuuovjjv5Hf5dG4OajGCJZwkIj78do6XJlVDzUN5pVyDZDT75zUDgF/vbV0NaKUXVFx
        bzFzSLGw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVsiV-0082eD-P9
        for fio@vger.kernel.org; Tue, 15 Aug 2023 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1C7351BC0167; Tue, 15 Aug 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230815120002.1C7351BC0167@kernel.dk>
Date:   Tue, 15 Aug 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 62f35562722f0c903567096d0f10a836d1ae2f60:

  eta: calculate aggregate bw statistics even when eta is disabled (2023-08-03 11:49:08 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6795954bde09c8697e0accb865b4f438d62c601f:

  engines/io_uring: fix leak of 'ld' in error path (2023-08-14 19:59:20 -0600)

----------------------------------------------------------------
Ankit Kumar (10):
      engines:io_uring: add missing error during open file
      engines:io_uring: update arguments to fetch nvme data
      engines:io_uring: enable support for separate metadata buffer
      engines:io_uring: uring_cmd add support for protection info
      io_u: move engine data out of union
      crc: pull required crc16-t10 files from linux kernel
      engines:io_uring: generate and verify pi for 16b guard
      crc: pull required crc64 nvme apis from linux kernel
      engines:nvme: pull required 48 bit accessors from linux kernel
      engines:io_uring: generate and verify pi for 64b guard

Jens Axboe (1):
      engines/io_uring: fix leak of 'ld' in error path

Vincent Fu (2):
      t/fiotestlib: use config variable to skip test at runtime
      t/nvmept_pi: test script for protection information

 HOWTO.rst              |  39 ++
 crc/crc-t10dif.h       |   9 +
 crc/crc64.c            |  32 ++
 crc/crc64.h            |   3 +
 crc/crc64table.h       | 130 +++++++
 crc/crct10dif_common.c |  78 ++++
 engines/io_uring.c     | 228 ++++++++++--
 engines/nvme.c         | 466 ++++++++++++++++++++++--
 engines/nvme.h         | 230 +++++++++++-
 fio.1                  |  38 ++
 io_u.h                 |   2 +-
 t/fiotestlib.py        |   5 +-
 t/nvmept_pi.py         | 949 +++++++++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 2154 insertions(+), 55 deletions(-)
 create mode 100644 crc/crc-t10dif.h
 create mode 100644 crc/crc64table.h
 create mode 100644 crc/crct10dif_common.c
 create mode 100755 t/nvmept_pi.py

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ac8314f3..89032941 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2487,6 +2487,45 @@ with the caveat that when used on the command line, they must come after the
         want fio to use placement identifier only at indices 0, 2 and 5 specify
         ``fdp_pli=0,2,5``.
 
+.. option:: md_per_io_size=int : [io_uring_cmd]
+
+	Size in bytes for separate metadata buffer per IO. Default: 0.
+
+.. option:: pi_act=int : [io_uring_cmd]
+
+	Action to take when nvme namespace is formatted with protection
+	information. If this is set to 1 and namespace is formatted with
+	metadata size equal to protection information size, fio won't use
+	separate metadata buffer or extended logical block. If this is set to
+	1 and namespace is formatted with metadata size greater than protection
+	information size, fio will not generate or verify the protection
+	information portion of metadata for write or read case respectively.
+	If this is set to 0, fio generates protection information for
+	write case and verifies for read case. Default: 1.
+
+.. option:: pi_chk=str[,str][,str] : [io_uring_cmd]
+
+	Controls the protection information check. This can take one or more
+	of these values. Default: none.
+
+	**GUARD**
+		Enables protection information checking of guard field.
+	**REFTAG**
+		Enables protection information checking of logical block
+		reference tag field.
+	**APPTAG**
+		Enables protection information checking of application tag field.
+
+.. option:: apptag=int : [io_uring_cmd]
+
+	Specifies logical block application tag value, if namespace is
+	formatted to use end to end protection information. Default: 0x1234.
+
+.. option:: apptag_mask=int : [io_uring_cmd]
+
+	Specifies logical block application tag mask value, if namespace is
+	formatted to use end to end protection information. Default: 0xffff.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
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
diff --git a/engines/io_uring.c b/engines/io_uring.c
index b361e6a5..6cdf1b4f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -59,6 +59,7 @@ struct ioring_data {
 	int ring_fd;
 
 	struct io_u **io_u_index;
+	char *md_buf;
 
 	int *fds;
 
@@ -95,6 +96,12 @@ struct ioring_options {
 	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
+	unsigned int md_per_io_size;
+	unsigned int pi_act;
+	unsigned int apptag;
+	unsigned int apptag_mask;
+	unsigned int prchk;
+	char *pi_chk;
 	enum uring_cmd_type cmd_type;
 };
 
@@ -217,6 +224,56 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_IOURING,
 	},
 	CMDPRIO_OPTIONS(struct ioring_options, FIO_OPT_G_IOURING),
+	{
+		.name	= "md_per_io_size",
+		.lname	= "Separate Metadata Buffer Size per I/O",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, md_per_io_size),
+		.def	= "0",
+		.help	= "Size of separate metadata buffer per I/O (Default: 0)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "pi_act",
+		.lname	= "Protection Information Action",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct ioring_options, pi_act),
+		.def	= "1",
+		.help	= "Protection Information Action bit (pi_act=1 or pi_act=0)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "pi_chk",
+		.lname	= "Protection Information Check",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct ioring_options, pi_chk),
+		.def	= NULL,
+		.help	= "Control of Protection Information Checking (pi_chk=GUARD,REFTAG,APPTAG)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "apptag",
+		.lname	= "Application Tag used in Protection Information",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, apptag),
+		.def	= "0x1234",
+		.help	= "Application Tag used in Protection Information field (Default: 0x1234)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "apptag_mask",
+		.lname	= "Application Tag Mask",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, apptag_mask),
+		.def	= "0xffff",
+		.help	= "Application Tag Mask used with Application Tag (Default: 0xffff)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -399,7 +456,9 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	struct ioring_options *o = td->eo;
 	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
+	struct nvme_data *data;
 	unsigned index;
+	int ret;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 	if (o->cmd_type == FIO_URING_CMD_NVME)
@@ -413,6 +472,15 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	else
 		io_u->error = 0;
 
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		data = FILE_ENG_DATA(io_u->file);
+		if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
+			ret = fio_nvme_pi_verify(data, io_u);
+			if (ret)
+				io_u->error = ret;
+		}
+	}
+
 	return io_u;
 }
 
@@ -474,6 +542,33 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 	return r < 0 ? r : events;
 }
 
+static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
+					  struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct nvme_uring_cmd *cmd;
+	struct io_uring_sqe *sqe;
+	struct nvme_cmd_ext_io_opts ext_opts = {0};
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+
+	if (io_u->ddir == DDIR_TRIM)
+		return;
+
+	sqe = &ld->sqes[(io_u->index) << 1];
+	cmd = (struct nvme_uring_cmd *)sqe->cmd;
+
+	if (data->pi_type) {
+		if (o->pi_act)
+			ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
+		ext_opts.io_flags |= o->prchk;
+		ext_opts.apptag = o->apptag;
+		ext_opts.apptag_mask = o->apptag_mask;
+	}
+
+	fio_nvme_pi_fill(cmd, io_u, &ext_opts);
+}
+
 static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 					   struct io_u *io_u)
 {
@@ -488,6 +583,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct io_sq_ring *ring = &ld->sq_ring;
 	unsigned tail, next_tail;
 
@@ -515,6 +611,10 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
 
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
+		o->cmd_type == FIO_URING_CMD_NVME)
+		fio_ioring_cmd_nvme_pi(td, io_u);
+
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	atomic_store_release(ring->tail, next_tail);
 
@@ -631,6 +731,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 
 		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
+		free(ld->md_buf);
 		free(ld->iovecs);
 		free(ld->fds);
 		free(ld->dsm);
@@ -1012,10 +1113,24 @@ static int fio_ioring_cmd_post_init(struct thread_data *td)
 	return 0;
 }
 
+static void parse_prchk_flags(struct ioring_options *o)
+{
+	if (!o->pi_chk)
+		return;
+
+	if (strstr(o->pi_chk, "GUARD") != NULL)
+		o->prchk = NVME_IO_PRINFO_PRCHK_GUARD;
+	if (strstr(o->pi_chk, "REFTAG") != NULL)
+		o->prchk |= NVME_IO_PRINFO_PRCHK_REF;
+	if (strstr(o->pi_chk, "APPTAG") != NULL)
+		o->prchk |= NVME_IO_PRINFO_PRCHK_APP;
+}
+
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
+	unsigned long long md_size;
 	int ret;
 
 	/* sqthread submission requires registered files */
@@ -1036,6 +1151,32 @@ static int fio_ioring_init(struct thread_data *td)
 
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
+
+	/*
+	 * metadata buffer for nvme command.
+	 * We are only supporting iomem=malloc / mem=malloc as of now.
+	 */
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
+	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) {
+		md_size = (unsigned long long) o->md_per_io_size
+				* (unsigned long long) td->o.iodepth;
+		md_size += page_mask + td->o.mem_align;
+		if (td->o.mem_align && td->o.mem_align > page_size)
+			md_size += td->o.mem_align - page_size;
+		if (td->o.mem_type == MEM_MALLOC) {
+			ld->md_buf = malloc(md_size);
+			if (!ld->md_buf) {
+				free(ld);
+				return 1;
+			}
+		} else {
+			log_err("fio: Only iomem=malloc or mem=malloc is supported\n");
+			free(ld);
+			return 1;
+		}
+	}
+	parse_prchk_flags(o);
+
 	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
@@ -1062,11 +1203,42 @@ static int fio_ioring_init(struct thread_data *td)
 static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct nvme_pi_data *pi_data;
+	char *p;
 
 	ld->io_u_index[io_u->index] = io_u;
+
+	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
+		p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
+		p += o->md_per_io_size * io_u->index;
+		io_u->mmap_data = p;
+
+		if (!o->pi_act) {
+			pi_data = calloc(1, sizeof(*pi_data));
+			pi_data->io_flags |= o->prchk;
+			pi_data->apptag_mask = o->apptag_mask;
+			pi_data->apptag = o->apptag;
+			io_u->engine_data = pi_data;
+		}
+	}
+
 	return 0;
 }
 
+static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_options *o = td->eo;
+	struct nvme_pi *pi;
+
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
+	    (o->cmd_type == FIO_URING_CMD_NVME)) {
+		pi = io_u->engine_data;
+		free(pi);
+		io_u->engine_data = NULL;
+	}
+}
+
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -1086,39 +1258,44 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
-		unsigned int nsid, lba_size = 0;
-		__u32 ms = 0;
+		unsigned int lba_size = 0;
 		__u64 nlba = 0;
 		int ret;
 
 		/* Store the namespace-id and lba size. */
 		data = FILE_ENG_DATA(f);
 		if (data == NULL) {
-			ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
-			if (ret)
-				return ret;
-
 			data = calloc(1, sizeof(struct nvme_data));
-			data->nsid = nsid;
-			if (ms)
-				data->lba_ext = lba_size + ms;
-			else
-				data->lba_shift = ilog2(lba_size);
+			ret = fio_nvme_get_info(f, &nlba, o->pi_act, data);
+			if (ret) {
+				free(data);
+				return ret;
+			}
 
 			FILE_SET_ENG_DATA(f, data);
 		}
 
-		assert(data->lba_shift < 32);
-		lba_size = data->lba_ext ? data->lba_ext : (1U << data->lba_shift);
+		lba_size = data->lba_ext ? data->lba_ext : data->lba_size;
 
 		for_each_rw_ddir(ddir) {
 			if (td->o.min_bs[ddir] % lba_size ||
 				td->o.max_bs[ddir] % lba_size) {
 				if (data->lba_ext)
-					log_err("block size must be a multiple of "
-						"(LBA data size + Metadata size)\n");
+					log_err("%s: block size must be a multiple of (LBA data size + Metadata size)\n",
+						f->file_name);
 				else
-					log_err("block size must be a multiple of LBA data size\n");
+					log_err("%s: block size must be a multiple of LBA data size\n",
+						f->file_name);
+				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+				return 1;
+			}
+			if (data->ms && !data->lba_ext && ddir != DDIR_TRIM &&
+			    (o->md_per_io_size < ((td->o.max_bs[ddir] / data->lba_size) *
+						  data->ms))) {
+				log_err("%s: md_per_io_size should be at least %llu bytes\n",
+					f->file_name,
+					((td->o.max_bs[ddir] / data->lba_size) * data->ms));
+				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 				return 1;
 			}
                 }
@@ -1171,23 +1348,17 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
-		unsigned int nsid, lba_size = 0;
-		__u32 ms = 0;
 		__u64 nlba = 0;
 		int ret;
 
-		ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
-		if (ret)
-			return ret;
-
 		data = calloc(1, sizeof(struct nvme_data));
-		data->nsid = nsid;
-		if (ms)
-			data->lba_ext = lba_size + ms;
-		else
-			data->lba_shift = ilog2(lba_size);
+		ret = fio_nvme_get_info(f, &nlba, o->pi_act, data);
+		if (ret) {
+			free(data);
+			return ret;
+		}
 
-		f->real_file_size = lba_size * nlba;
+		f->real_file_size = data->lba_size * nlba;
 		fio_file_set_size_known(f);
 
 		FILE_SET_ENG_DATA(f, data);
@@ -1276,6 +1447,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
+	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
 	.queue			= fio_ioring_queue,
 	.commit			= fio_ioring_commit,
diff --git a/engines/nvme.c b/engines/nvme.c
index b18ad4c2..08503b33 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -1,9 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * nvme structure declarations and helper functions for the
  * io_uring_cmd engine.
  */
 
 #include "nvme.h"
+#include "../crc/crc-t10dif.h"
+#include "../crc/crc64.h"
 
 static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
 {
@@ -21,6 +24,310 @@ static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
 		return (io_u->xfer_buflen >> data->lba_shift) - 1;
 }
 
+static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
+					   struct io_u *io_u,
+					   struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_16b_guard_pif *pi;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	__u64 slba = get_slba(data, io_u);
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+	__u16 guard = 0;
+
+	if (data->pi_loc) {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - data->ms;
+		else
+			pi_data->interval = 0;
+	} else {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - sizeof(struct nvme_16b_guard_pif);
+		else
+			pi_data->interval = data->ms - sizeof(struct nvme_16b_guard_pif);
+	}
+
+	if (io_u->ddir != DDIR_WRITE)
+		return;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_16b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_16b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc_t10dif(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc_t10dif(0, buf, data->lba_size);
+				guard = fio_crc_t10dif(guard, md_buf, pi_data->interval);
+			}
+			pi->guard = cpu_to_be16(guard);
+		}
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			pi->apptag = cpu_to_be16(pi_data->apptag);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				pi->srtag = cpu_to_be32((__u32)slba + lba_num);
+				break;
+			case NVME_NS_DPS_PI_TYPE3:
+				break;
+			}
+		}
+		if (data->lba_ext) {
+			buf += data->lba_ext;
+		} else {
+			buf += data->lba_size;
+			md_buf += data->ms;
+		}
+		lba_num++;
+	}
+}
+
+static int fio_nvme_verify_pi_16b_guard(struct nvme_data *data,
+					struct io_u *io_u)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_16b_guard_pif *pi;
+	struct fio_file *f = io_u->file;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	__u64 slba = get_slba(data, io_u);
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+	__u16 unmask_app, unmask_app_exp, guard = 0;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_16b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_16b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (data->pi_type == NVME_NS_DPS_PI_TYPE3) {
+			if (pi->apptag == NVME_PI_APP_DISABLE &&
+			    pi->srtag == NVME_PI_REF_DISABLE)
+				goto next;
+		} else if (data->pi_type == NVME_NS_DPS_PI_TYPE1 ||
+			   data->pi_type == NVME_NS_DPS_PI_TYPE2) {
+			if (pi->apptag == NVME_PI_APP_DISABLE)
+				goto next;
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc_t10dif(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc_t10dif(0, buf, data->lba_size);
+				guard = fio_crc_t10dif(guard, md_buf, pi_data->interval);
+			}
+			if (be16_to_cpu(pi->guard) != guard) {
+				log_err("%s: Guard compare error: LBA: %llu Expected=%x, Actual=%x\n",
+					f->file_name, (unsigned long long)slba,
+					guard, be16_to_cpu(pi->guard));
+				return -EIO;
+			}
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_APP) {
+			unmask_app = be16_to_cpu(pi->apptag) & pi_data->apptag_mask;
+			unmask_app_exp = pi_data->apptag & pi_data->apptag_mask;
+			if (unmask_app != unmask_app_exp) {
+				log_err("%s: APPTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
+					f->file_name, (unsigned long long)slba,
+					unmask_app_exp, unmask_app);
+				return -EIO;
+			}
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				if (be32_to_cpu(pi->srtag) !=
+				    ((__u32)slba + lba_num)) {
+					log_err("%s: REFTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
+						f->file_name, (unsigned long long)slba,
+						(__u32)slba + lba_num,
+						be32_to_cpu(pi->srtag));
+					return -EIO;
+				}
+				break;
+			case NVME_NS_DPS_PI_TYPE3:
+				break;
+			}
+		}
+next:
+		if (data->lba_ext) {
+			buf += data->lba_ext;
+		} else {
+			buf += data->lba_size;
+			md_buf += data->ms;
+		}
+		lba_num++;
+	}
+
+	return 0;
+}
+
+static void fio_nvme_generate_pi_64b_guard(struct nvme_data *data,
+					   struct io_u *io_u,
+					   struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_64b_guard_pif *pi;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	uint64_t guard = 0;
+	__u64 slba = get_slba(data, io_u);
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+
+	if (data->pi_loc) {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - data->ms;
+		else
+			pi_data->interval = 0;
+	} else {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - sizeof(struct nvme_64b_guard_pif);
+		else
+			pi_data->interval = data->ms - sizeof(struct nvme_64b_guard_pif);
+	}
+
+	if (io_u->ddir != DDIR_WRITE)
+		return;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_64b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_64b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc64_nvme(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc64_nvme(0, buf, data->lba_size);
+				guard = fio_crc64_nvme(guard, md_buf, pi_data->interval);
+			}
+			pi->guard = cpu_to_be64(guard);
+		}
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			pi->apptag = cpu_to_be16(pi_data->apptag);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				put_unaligned_be48(slba + lba_num, pi->srtag);
+				break;
+			case NVME_NS_DPS_PI_TYPE3:
+				break;
+			}
+		}
+		if (data->lba_ext) {
+			buf += data->lba_ext;
+		} else {
+			buf += data->lba_size;
+			md_buf += data->ms;
+		}
+		lba_num++;
+	}
+}
+
+static int fio_nvme_verify_pi_64b_guard(struct nvme_data *data,
+					struct io_u *io_u)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_64b_guard_pif *pi;
+	struct fio_file *f = io_u->file;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	__u64 slba = get_slba(data, io_u);
+	__u64 ref, ref_exp, guard = 0;
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+	__u16 unmask_app, unmask_app_exp;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_64b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_64b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (data->pi_type == NVME_NS_DPS_PI_TYPE3) {
+			if (pi->apptag == NVME_PI_APP_DISABLE &&
+			    fio_nvme_pi_ref_escape(pi->srtag))
+				goto next;
+		} else if (data->pi_type == NVME_NS_DPS_PI_TYPE1 ||
+			   data->pi_type == NVME_NS_DPS_PI_TYPE2) {
+			if (pi->apptag == NVME_PI_APP_DISABLE)
+				goto next;
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc64_nvme(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc64_nvme(0, buf, data->lba_size);
+				guard = fio_crc64_nvme(guard, md_buf, pi_data->interval);
+			}
+			if (be64_to_cpu((uint64_t)pi->guard) != guard) {
+				log_err("%s: Guard compare error: LBA: %llu Expected=%llx, Actual=%llx\n",
+					f->file_name, (unsigned long long)slba,
+					guard, be64_to_cpu((uint64_t)pi->guard));
+				return -EIO;
+			}
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_APP) {
+			unmask_app = be16_to_cpu(pi->apptag) & pi_data->apptag_mask;
+			unmask_app_exp = pi_data->apptag & pi_data->apptag_mask;
+			if (unmask_app != unmask_app_exp) {
+				log_err("%s: APPTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
+					f->file_name, (unsigned long long)slba,
+					unmask_app_exp, unmask_app);
+				return -EIO;
+			}
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				ref = get_unaligned_be48(pi->srtag);
+				ref_exp = (slba + lba_num) & ((1ULL << 48) - 1);
+				if (ref != ref_exp) {
+					log_err("%s: REFTAG compare error: LBA: %llu Expected=%llx, Actual=%llx\n",
+						f->file_name, (unsigned long long)slba,
+						ref_exp, ref);
+					return -EIO;
+				}
+				break;
+			case NVME_NS_DPS_PI_TYPE3:
+				break;
+			}
+		}
+next:
+		if (data->lba_ext) {
+			buf += data->lba_ext;
+		} else {
+			buf += data->lba_size;
+			md_buf += data->ms;
+		}
+		lba_num++;
+	}
+
+	return 0;
+}
 void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 				  struct nvme_dsm_range *dsm)
 {
@@ -79,10 +386,72 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
 		cmd->data_len = io_u->xfer_buflen;
 	}
+	if (data->lba_shift && data->ms) {
+		cmd->metadata = (__u64)(uintptr_t)io_u->mmap_data;
+		cmd->metadata_len = (nlb + 1) * data->ms;
+	}
 	cmd->nsid = data->nsid;
 	return 0;
 }
 
+void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+		      struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	__u64 slba;
+
+	slba = get_slba(data, io_u);
+	cmd->cdw12 |= opts->io_flags;
+
+	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
+		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
+			fio_nvme_generate_pi_16b_guard(data, io_u, opts);
+		else if (data->guard_type == NVME_NVM_NS_64B_GUARD)
+			fio_nvme_generate_pi_64b_guard(data, io_u, opts);
+	}
+
+	switch (data->pi_type) {
+	case NVME_NS_DPS_PI_TYPE1:
+	case NVME_NS_DPS_PI_TYPE2:
+		switch (data->guard_type) {
+		case NVME_NVM_NS_16B_GUARD:
+			cmd->cdw14 = (__u32)slba;
+			break;
+		case NVME_NVM_NS_64B_GUARD:
+			cmd->cdw14 = (__u32)slba;
+			cmd->cdw3 = ((slba >> 32) & 0xffff);
+			break;
+		default:
+			break;
+		}
+		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		break;
+	case NVME_NS_DPS_PI_TYPE3:
+		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		break;
+	case NVME_NS_DPS_PI_NONE:
+		break;
+	}
+}
+
+int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u)
+{
+	int ret = 0;
+
+	switch (data->guard_type) {
+	case NVME_NVM_NS_16B_GUARD:
+		ret = fio_nvme_verify_pi_16b_guard(data, io_u);
+		break;
+	case NVME_NVM_NS_64B_GUARD:
+		ret = fio_nvme_verify_pi_64b_guard(data, io_u);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 			 enum nvme_csi csi, void *data)
 {
@@ -99,13 +468,15 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
 }
 
-int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u32 *ms, __u64 *nlba)
+int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
+		      struct nvme_data *data)
 {
 	struct nvme_id_ns ns;
+	struct nvme_id_ctrl ctrl;
+	struct nvme_nvm_id_ns nvm_ns;
 	int namespace_id;
 	int fd, err;
-	__u32 format_idx;
+	__u32 format_idx, elbaf;
 
 	if (f->filetype != FIO_TYPE_CHAR) {
 		log_err("ioengine io_uring_cmd only works with nvme ns "
@@ -124,6 +495,12 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 		goto out;
 	}
 
+	err = nvme_identify(fd, 0, NVME_IDENTIFY_CNS_CTRL, NVME_CSI_NVM, &ctrl);
+	if (err) {
+		log_err("%s: failed to fetch identify ctrl\n", f->file_name);
+		goto out;
+	}
+
 	/*
 	 * Identify namespace to get namespace-id, namespace size in LBA's
 	 * and LBA data size.
@@ -133,11 +510,10 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	if (err) {
 		log_err("%s: failed to fetch identify namespace\n",
 			f->file_name);
-		close(fd);
-		return err;
+		goto out;
 	}
 
-	*nsid = namespace_id;
+	data->nsid = namespace_id;
 
 	/*
 	 * 16 or 64 as maximum number of supported LBA formats.
@@ -149,28 +525,74 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	else
 		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
 
-	*lba_sz = 1 << ns.lbaf[format_idx].ds;
+	data->lba_size = 1 << ns.lbaf[format_idx].ds;
+	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
+
+	/* Check for end to end data protection support */
+	if (data->ms && (ns.dps & NVME_NS_DPS_PI_MASK))
+		data->pi_type = (ns.dps & NVME_NS_DPS_PI_MASK);
+
+	if (!data->pi_type)
+		goto check_elba;
+
+	if (ctrl.ctratt & NVME_CTRL_CTRATT_ELBAS) {
+		err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_CSI_NS,
+					NVME_CSI_NVM, &nvm_ns);
+		if (err) {
+			log_err("%s: failed to fetch identify nvm namespace\n",
+				f->file_name);
+			goto out;
+		}
+
+		elbaf = le32_to_cpu(nvm_ns.elbaf[format_idx]);
+
+		/* Currently we don't support storage tags */
+		if (elbaf & NVME_ID_NS_NVM_STS_MASK) {
+			log_err("%s: Storage tag not supported\n",
+				f->file_name);
+			err = -ENOTSUP;
+			goto out;
+		}
+
+		data->guard_type = (elbaf >> NVME_ID_NS_NVM_GUARD_SHIFT) &
+				NVME_ID_NS_NVM_GUARD_MASK;
+
+		/* No 32 bit guard, as storage tag is mandatory for it */
+		switch (data->guard_type) {
+		case NVME_NVM_NS_16B_GUARD:
+			data->pi_size = sizeof(struct nvme_16b_guard_pif);
+			break;
+		case NVME_NVM_NS_64B_GUARD:
+			data->pi_size = sizeof(struct nvme_64b_guard_pif);
+			break;
+		default:
+			break;
+		}
+	} else {
+		data->guard_type = NVME_NVM_NS_16B_GUARD;
+		data->pi_size = sizeof(struct nvme_16b_guard_pif);
+	}
+
+	/*
+	 * when PRACT bit is set to 1, and metadata size is equal to protection
+	 * information size, controller inserts and removes PI for write and
+	 * read commands respectively.
+	 */
+	if (pi_act && data->ms == data->pi_size)
+		data->ms = 0;
+
+	data->pi_loc = (ns.dps & NVME_NS_DPS_PI_FIRST);
 
+check_elba:
 	/*
-	 * Only extended LBA can be supported.
 	 * Bit 4 for flbas indicates if metadata is transferred at the end of
 	 * logical block creating an extended LBA.
 	 */
-	*ms = le16_to_cpu(ns.lbaf[format_idx].ms);
-	if (*ms && !((ns.flbas >> 4) & 0x1)) {
-		log_err("%s: only extended logical block can be supported\n",
-			f->file_name);
-		err = -ENOTSUP;
-		goto out;
-	}
+	if (data->ms && ((ns.flbas >> 4) & 0x1))
+		data->lba_ext = data->lba_size + data->ms;
+	else
+		data->lba_shift = ilog2(data->lba_size);
 
-	/* Check for end to end data protection support */
-	if (ns.dps & 0x3) {
-		log_err("%s: end to end data protection not supported\n",
-			f->file_name);
-		err = -ENOTSUP;
-		goto out;
-	}
 	*nlba = ns.nsze;
 
 out:
diff --git a/engines/nvme.h b/engines/nvme.h
index 238471dd..792b35d8 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * nvme structure declarations and helper functions for the
  * io_uring_cmd engine.
@@ -42,6 +43,10 @@ struct nvme_uring_cmd {
 #define NVME_DEFAULT_IOCTL_TIMEOUT 0
 #define NVME_IDENTIFY_DATA_SIZE 4096
 #define NVME_IDENTIFY_CSI_SHIFT 24
+#define NVME_NQN_LENGTH	256
+
+#define NVME_PI_APP_DISABLE 0xFFFF
+#define NVME_PI_REF_DISABLE 0xFFFFFFFF
 
 #define NVME_ZNS_ZRA_REPORT_ZONES 0
 #define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
@@ -52,6 +57,7 @@ struct nvme_uring_cmd {
 
 enum nvme_identify_cns {
 	NVME_IDENTIFY_CNS_NS		= 0x00,
+	NVME_IDENTIFY_CNS_CTRL		= 0x01,
 	NVME_IDENTIFY_CNS_CSI_NS	= 0x05,
 	NVME_IDENTIFY_CNS_CSI_CTRL	= 0x06,
 };
@@ -85,10 +91,55 @@ enum nvme_zns_zs {
 	NVME_ZNS_ZS_OFFLINE		= 0xf,
 };
 
+enum nvme_id_ctrl_ctratt {
+	NVME_CTRL_CTRATT_ELBAS		= 1 << 15,
+};
+
+enum {
+	NVME_ID_NS_NVM_STS_MASK		= 0x7f,
+	NVME_ID_NS_NVM_GUARD_SHIFT	= 7,
+	NVME_ID_NS_NVM_GUARD_MASK	= 0x3,
+};
+
+enum {
+	NVME_NVM_NS_16B_GUARD		= 0,
+	NVME_NVM_NS_32B_GUARD		= 1,
+	NVME_NVM_NS_64B_GUARD		= 2,
+};
+
 struct nvme_data {
 	__u32 nsid;
 	__u32 lba_shift;
+	__u32 lba_size;
 	__u32 lba_ext;
+	__u16 ms;
+	__u16 pi_size;
+	__u8 pi_type;
+	__u8 guard_type;
+	__u8 pi_loc;
+};
+
+enum nvme_id_ns_dps {
+	NVME_NS_DPS_PI_NONE		= 0,
+	NVME_NS_DPS_PI_TYPE1		= 1,
+	NVME_NS_DPS_PI_TYPE2		= 2,
+	NVME_NS_DPS_PI_TYPE3		= 3,
+	NVME_NS_DPS_PI_MASK		= 7 << 0,
+	NVME_NS_DPS_PI_FIRST		= 1 << 3,
+};
+
+enum nvme_io_control_flags {
+	NVME_IO_PRINFO_PRCHK_REF	= 1U << 26,
+	NVME_IO_PRINFO_PRCHK_APP	= 1U << 27,
+	NVME_IO_PRINFO_PRCHK_GUARD	= 1U << 28,
+	NVME_IO_PRINFO_PRACT		= 1U << 29,
+};
+
+struct nvme_pi_data {
+	__u32 interval;
+	__u32 io_flags;
+	__u16 apptag;
+	__u16 apptag_mask;
 };
 
 struct nvme_lbaf {
@@ -97,6 +148,20 @@ struct nvme_lbaf {
 	__u8			rp;
 };
 
+/* 16 bit guard protection Information format */
+struct nvme_16b_guard_pif {
+	__be16 guard;
+	__be16 apptag;
+	__be32 srtag;
+};
+
+/* 64 bit guard protection Information format */
+struct nvme_64b_guard_pif {
+	__be64 guard;
+	__be16 apptag;
+	__u8 srtag[6];
+};
+
 struct nvme_id_ns {
 	__le64			nsze;
 	__le64			ncap;
@@ -139,6 +204,133 @@ struct nvme_id_ns {
 	__u8			vs[3712];
 };
 
+struct nvme_id_psd {
+	__le16			mp;
+	__u8			rsvd2;
+	__u8			flags;
+	__le32			enlat;
+	__le32			exlat;
+	__u8			rrt;
+	__u8			rrl;
+	__u8			rwt;
+	__u8			rwl;
+	__le16			idlp;
+	__u8			ips;
+	__u8			rsvd19;
+	__le16			actp;
+	__u8			apws;
+	__u8			rsvd23[9];
+};
+
+struct nvme_id_ctrl {
+	__le16			vid;
+	__le16			ssvid;
+	char			sn[20];
+	char			mn[40];
+	char			fr[8];
+	__u8			rab;
+	__u8			ieee[3];
+	__u8			cmic;
+	__u8			mdts;
+	__le16			cntlid;
+	__le32			ver;
+	__le32			rtd3r;
+	__le32			rtd3e;
+	__le32			oaes;
+	__le32			ctratt;
+	__le16			rrls;
+	__u8			rsvd102[9];
+	__u8			cntrltype;
+	__u8			fguid[16];
+	__le16			crdt1;
+	__le16			crdt2;
+	__le16			crdt3;
+	__u8			rsvd134[119];
+	__u8			nvmsr;
+	__u8			vwci;
+	__u8			mec;
+	__le16			oacs;
+	__u8			acl;
+	__u8			aerl;
+	__u8			frmw;
+	__u8			lpa;
+	__u8			elpe;
+	__u8			npss;
+	__u8			avscc;
+	__u8			apsta;
+	__le16			wctemp;
+	__le16			cctemp;
+	__le16			mtfa;
+	__le32			hmpre;
+	__le32			hmmin;
+	__u8			tnvmcap[16];
+	__u8			unvmcap[16];
+	__le32			rpmbs;
+	__le16			edstt;
+	__u8			dsto;
+	__u8			fwug;
+	__le16			kas;
+	__le16			hctma;
+	__le16			mntmt;
+	__le16			mxtmt;
+	__le32			sanicap;
+	__le32			hmminds;
+	__le16			hmmaxd;
+	__le16			nsetidmax;
+	__le16			endgidmax;
+	__u8			anatt;
+	__u8			anacap;
+	__le32			anagrpmax;
+	__le32			nanagrpid;
+	__le32			pels;
+	__le16			domainid;
+	__u8			rsvd358[10];
+	__u8			megcap[16];
+	__u8			rsvd384[128];
+	__u8			sqes;
+	__u8			cqes;
+	__le16			maxcmd;
+	__le32			nn;
+	__le16			oncs;
+	__le16			fuses;
+	__u8			fna;
+	__u8			vwc;
+	__le16			awun;
+	__le16			awupf;
+	__u8			icsvscc;
+	__u8			nwpc;
+	__le16			acwu;
+	__le16			ocfs;
+	__le32			sgls;
+	__le32			mnan;
+	__u8			maxdna[16];
+	__le32			maxcna;
+	__u8			rsvd564[204];
+	char			subnqn[NVME_NQN_LENGTH];
+	__u8			rsvd1024[768];
+
+	/* Fabrics Only */
+	__le32			ioccsz;
+	__le32			iorcsz;
+	__le16			icdoff;
+	__u8			fcatt;
+	__u8			msdbd;
+	__le16			ofcs;
+	__u8			dctype;
+	__u8			rsvd1807[241];
+
+	struct nvme_id_psd	psd[32];
+	__u8			vs[1024];
+};
+
+struct nvme_nvm_id_ns {
+	__le64			lbstm;
+	__u8			pic;
+	__u8			rsvd9[3];
+	__le32			elbaf[64];
+	__u8			rsvd268[3828];
+};
+
 static inline int ilog2(uint32_t i)
 {
 	int log = -1;
@@ -216,15 +408,26 @@ struct nvme_dsm_range {
 	__le64	slba;
 };
 
+struct nvme_cmd_ext_io_opts {
+	__u32 io_flags;
+	__u16 apptag;
+	__u16 apptag_mask;
+};
+
 int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
-int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u32 *ms, __u64 *nlba);
+int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
+		      struct nvme_data *data);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm_range *dsm);
 
+void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+		      struct nvme_cmd_ext_io_opts *opts);
+
+int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u);
+
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
 			     enum zbd_zoned_model *model);
 
@@ -238,4 +441,27 @@ int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
 int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				unsigned int *max_open_zones);
 
+static inline void put_unaligned_be48(__u64 val, __u8 *p)
+{
+	*p++ = val >> 40;
+	*p++ = val >> 32;
+	*p++ = val >> 24;
+	*p++ = val >> 16;
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline __u64 get_unaligned_be48(__u8 *p)
+{
+	return (__u64)p[0] << 40 | (__u64)p[1] << 32 | (__u64)p[2] << 24 |
+		p[3] << 16 | p[4] << 8 | p[5];
+}
+
+static inline bool fio_nvme_pi_ref_escape(__u8 *reftag)
+{
+	__u8 ref_esc[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+	return memcmp(reftag, ref_esc, sizeof(ref_esc)) == 0;
+}
+
 #endif
diff --git a/fio.1 b/fio.1
index f62617e7..f0dc49ab 100644
--- a/fio.1
+++ b/fio.1
@@ -2247,6 +2247,44 @@ By default, the job will cycle through all available Placement IDs, so use this
 to isolate these identifiers to specific jobs. If you want fio to use placement
 identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
 .TP
+.BI (io_uring_cmd)md_per_io_size \fR=\fPint
+Size in bytes for separate metadata buffer per IO. Default: 0.
+.TP
+.BI (io_uring_cmd)pi_act \fR=\fPint
+Action to take when nvme namespace is formatted with protection information.
+If this is set to 1 and namespace is formatted with metadata size equal to
+protection information size, fio won't use separate metadata buffer or extended
+logical block. If this is set to 1 and namespace is formatted with metadata
+size greater than protection information size, fio will not generate or verify
+the protection information portion of metadata for write or read case
+respectively. If this is set to 0, fio generates protection information for
+write case and verifies for read case. Default: 1.
+.TP
+.BI (io_uring_cmd)pi_chk \fR=\fPstr[,str][,str]
+Controls the protection information check. This can take one or more of these
+values. Default: none.
+.RS
+.RS
+.TP
+.B GUARD
+Enables protection information checking of guard field.
+.TP
+.B REFTAG
+Enables protection information checking of logical block reference tag field.
+.TP
+.B APPTAG
+Enables protection information checking of application tag field.
+.RE
+.RE
+.TP
+.BI (io_uring_cmd)apptag \fR=\fPint
+Specifies logical block application tag value, if namespace is formatted to use
+end to end protection information. Default: 0x1234.
+.TP
+.BI (io_uring_cmd)apptag_mask \fR=\fPint
+Specifies logical block application tag mask value, if namespace is formatted
+to use end to end protection information. Default: 0xffff.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
diff --git a/io_u.h b/io_u.h
index b432a540..786251d5 100644
--- a/io_u.h
+++ b/io_u.h
@@ -89,8 +89,8 @@ struct io_u {
 	union {
 		unsigned int index;
 		unsigned int seen;
-		void *engine_data;
 	};
+	void *engine_data;
 
 	union {
 		struct flist_head verify_list;
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 1f35de0a..a96338a3 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -382,9 +382,10 @@ def run_fio_tests(test_list, test_env, args):
 
     for config in test_list:
         if (args.skip and config['test_id'] in args.skip) or \
-           (args.run_only and config['test_id'] not in args.run_only):
+           (args.run_only and config['test_id'] not in args.run_only) or \
+           ('force_skip' in config and config['force_skip']):
             skipped = skipped + 1
-            print(f"Test {config['test_id']} SKIPPED (User request)")
+            print(f"Test {config['test_id']} SKIPPED (User request or override)")
             continue
 
         if issubclass(config['test_class'], FioJobFileTest):
diff --git a/t/nvmept_pi.py b/t/nvmept_pi.py
new file mode 100755
index 00000000..5de77c9d
--- /dev/null
+++ b/t/nvmept_pi.py
@@ -0,0 +1,949 @@
+#!/usr/bin/env python3
+"""
+# nvmept_pi.py
+#
+# Test fio's io_uring_cmd ioengine support for DIF/DIX end-to-end data
+# protection.
+#
+# USAGE
+# see python3 nvmept_pi.py --help
+#
+# EXAMPLES (THIS IS A DESTRUCTIVE TEST!!)
+# python3 t/nvmept_pi.py --dut /dev/ng0n1 -f ./fio
+# python3 t/nvmept_pi.py --dut /dev/ng0n1 -f ./fio --lbaf 1
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import os
+import sys
+import json
+import time
+import locale
+import logging
+import argparse
+import itertools
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+NUMBER_IOS = 8192
+BS_LOW = 1
+BS_HIGH = 16
+
+class DifDixTest(FioJobCmdTest):
+    """
+    NVMe DIF/DIX test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept_pi",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--bsrange={self.fio_opts['bsrange']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+            f"--md_per_io_size={self.fio_opts['md_per_io_size']}",
+            f"--pi_act={self.fio_opts['pi_act']}",
+            f"--pi_chk={self.fio_opts['pi_chk']}",
+            f"--apptag={self.fio_opts['apptag']}",
+            f"--apptag_mask={self.fio_opts['apptag_mask']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'offset', 'number_ios']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+TEST_LIST = [
+#
+# Write data with pi_act=1 and then read the data back (with both
+# pi_act=[0,1]).
+#
+    {
+        # Write workload with variable IO sizes
+        # pi_act=1
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 1,
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with fixed small IO size
+        # pi_act=0
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_LOW,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with fixed small IO size
+        # pi_act=1
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_LOW,
+        "test_class": DifDixTest,
+    },
+    {
+        # Write workload with fixed large IO size
+        # Precondition for read workloads to follow
+        # pi_act=1
+        "test_id": 104,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 1,
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_HIGH,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        "test_id": 105,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        "test_id": 106,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+#
+# Write data with pi_act=0 and then read the data back (with both
+# pi_act=[0,1]).
+#
+    {
+        # Write workload with variable IO sizes
+        # pi_act=0
+        "test_id": 201,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with fixed small IO size
+        # pi_act=0
+        "test_id": 202,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_LOW,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with fixed small IO size
+        # pi_act=1
+        "test_id": 203,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_LOW,
+        "test_class": DifDixTest,
+    },
+    {
+        # Write workload with fixed large IO sizes
+        # pi_act=0
+        "test_id": 204,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_HIGH,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        "test_id": 205,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        "test_id": 206,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+#
+# Test apptag errors.
+#
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # trigger an apptag error
+        "test_id": 301,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # trigger an apptag error
+        "test_id": 302,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # trigger an apptag error
+        # same as above but with pi_chk=APPTAG only
+        "test_id": 303,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # trigger an apptag error
+        # same as above but with pi_chk=APPTAG only
+        "test_id": 304,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # this case would trigger an apptag error, but pi_chk says to check
+        # only the Guard PI and reftag, so there should be no error
+        "test_id": 305,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # this case would trigger an apptag error, but pi_chk says to check
+        # only the Guard PI and reftag, so there should be no error
+        "test_id": 306,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # this case would trigger an apptag error, but pi_chk says to check
+        # only the Guard PI, so there should be no error
+        "test_id": 307,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "GUARD",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # this case would trigger an apptag error, but pi_chk says to check
+        # only the Guard PI, so there should be no error
+        "test_id": 308,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "GUARD",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # this case would trigger an apptag error, but pi_chk says to check
+        # only the reftag, so there should be no error
+        # This case will be skipped when the device is formatted with Type 3 PI
+        # since Type 3 PI ignores the reftag
+        "test_id": 309,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "skip": "type3",
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # this case would trigger an apptag error, but pi_chk says to check
+        # only the reftag, so there should be no error
+        # This case will be skipped when the device is formatted with Type 3 PI
+        # since Type 3 PI ignores the reftag
+        "test_id": 310,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0888",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "skip": "type3",
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # use apptag mask to ignore apptag mismatch
+        "test_id": 311,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # use apptag mask to ignore apptag mismatch
+        "test_id": 312,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # use apptag mask to ignore apptag mismatch
+        "test_id": 313,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0xF888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # use apptag mask to ignore apptag mismatch
+        "test_id": 314,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0xF888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Write workload with fixed large IO sizes
+        # Set apptag=0xFFFF to disable all checking for Type 1 and 2
+        # pi_act=1
+        "test_id": 315,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0xFFFF",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 1,
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_HIGH,
+        "bs_high": BS_HIGH,
+        "skip": "type3",
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # Data was written with apptag=0xFFFF
+        # Reading the data back should disable all checking for Type 1 and 2
+        "test_id": 316,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x0101",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "skip": "type3",
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=1
+        # Data was written with apptag=0xFFFF
+        # Reading the data back should disable all checking for Type 1 and 2
+        "test_id": 317,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 1,
+            "apptag": "0x0000",
+            "apptag_mask": "0xFFFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "skip": "type3",
+        "test_class": DifDixTest,
+    },
+#
+# Error cases related to block size and metadata size
+#
+    {
+        # Use a min block size that is not a multiple of lba/elba size to
+        # trigger an error.
+        "test_id": 401,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW+0.5,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Use metadata size that is too small
+        "test_id": 402,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "mdsize_adjustment": -1,
+        "success": SUCCESS_NONZERO,
+        "skip": "elba",
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO sizes
+        # pi_act=0
+        # Should still work even if metadata size is too large
+        "test_id": 403,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "pi_act": 0,
+            "apptag": "0x8888",
+            "apptag_mask": "0x0FFF",
+            },
+        "pi_chk": "APPTAG,GUARD,REFTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "mdsize_adjustment": 1,
+        "test_class": DifDixTest,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('--dut', help='target NVMe character device to test '
+                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    parser.add_argument('-l', '--lbaf', nargs='+', type=int,
+                        help='list of lba formats to test')
+    args = parser.parse_args()
+
+    return args
+
+
+def get_lbafs(args):
+    """
+    Determine which LBA formats to use. Use either the ones specified on the
+    command line or if none are specified query the device and use all lba
+    formats with metadata.
+    """
+    lbaf_list = []
+    id_ns_cmd = f"sudo nvme id-ns --output-format=json {args.dut}".split(' ')
+    id_ns_output = subprocess.check_output(id_ns_cmd)
+    lbafs = json.loads(id_ns_output)['lbafs']
+    if args.lbaf:
+        for lbaf in args.lbaf:
+            lbaf_list.append({'lbaf': lbaf, 'ds': 2 ** lbafs[lbaf]['ds'],
+                              'ms': lbafs[lbaf]['ms'], })
+            if lbafs[lbaf]['ms'] == 0:
+                print(f'Error: lbaf {lbaf} has metadata size zero')
+                sys.exit(1)
+    else:
+        for lbaf_num, lbaf in enumerate(lbafs):
+            if lbaf['ms'] != 0:
+                lbaf_list.append({'lbaf': lbaf_num, 'ds': 2 ** lbaf['ds'],
+                                  'ms': lbaf['ms'], })
+
+    return lbaf_list
+
+
+def get_guard_pi(lbaf_list, args):
+    """
+    Find out how many bits of guard protection information are associated with
+    each lbaf to be used. If this is not available assume 16-bit guard pi.
+    Also record the bytes of protection information associated with the number
+    of guard PI bits.
+    """
+    nvm_id_ns_cmd = f"sudo nvme nvm-id-ns --output-format=json {args.dut}".split(' ')
+    try:
+        nvm_id_ns_output = subprocess.check_output(nvm_id_ns_cmd)
+    except subprocess.CalledProcessError:
+        print(f"Non-zero return code from {' '.join(nvm_id_ns_cmd)}; " \
+                "assuming all lbafs use 16b Guard Protection Information")
+        for lbaf in lbaf_list:
+            lbaf['guard_pi_bits'] = 16
+    else:
+        elbafs = json.loads(nvm_id_ns_output)['elbafs']
+        for elbaf_num, elbaf in enumerate(elbafs):
+            for lbaf in lbaf_list:
+                if lbaf['lbaf'] == elbaf_num:
+                    lbaf['guard_pi_bits'] = 16 << elbaf['pif']
+
+    # For 16b Guard Protection Information, the PI requires 8 bytes
+    # For 32b and 64b Guard PI, the PI requires 16 bytes
+    for lbaf in lbaf_list:
+        if lbaf['guard_pi_bits'] == 16:
+            lbaf['pi_bytes'] = 8
+        else:
+            lbaf['pi_bytes'] = 16
+
+
+def get_capabilities(args):
+    """
+    Determine what end-to-end data protection features the device supports.
+    """
+    caps = { 'pil': [], 'pitype': [], 'elba': [] }
+    id_ns_cmd = f"sudo nvme id-ns --output-format=json {args.dut}".split(' ')
+    id_ns_output = subprocess.check_output(id_ns_cmd)
+    id_ns_json = json.loads(id_ns_output)
+
+    mc = id_ns_json['mc']
+    if mc & 1:
+        caps['elba'].append(1)
+    if mc & 2:
+        caps['elba'].append(0)
+
+    dpc = id_ns_json['dpc']
+    if dpc & 1:
+        caps['pitype'].append(1)
+    if dpc & 2:
+        caps['pitype'].append(2)
+    if dpc & 4:
+        caps['pitype'].append(3)
+    if dpc & 8:
+        caps['pil'].append(1)
+    if dpc & 16:
+        caps['pil'].append(0)
+
+    for _, value in caps.items():
+        if len(value) == 0:
+            logging.error("One or more end-to-end data protection features unsupported: %s", caps)
+            sys.exit(-1)
+
+    return caps
+
+
+def format_device(args, lbaf, pitype, pil, elba):
+    """
+    Format device using specified lba format with specified pitype, pil, and
+    elba values.
+    """
+
+    format_cmd = f"sudo nvme format {args.dut} --lbaf={lbaf['lbaf']} " \
+                 f"--pi={pitype} --pil={pil} --ms={elba} --force"
+    logging.debug("Format command: %s", format_cmd)
+    format_cmd = format_cmd.split(' ')
+    format_cmd_result = subprocess.run(format_cmd, capture_output=True, check=False,
+                                       encoding=locale.getpreferredencoding())
+
+    # Sometimes nvme-cli may format the device successfully but fail to
+    # rescan the namespaces after the format. Continue if this happens but
+    # abort if some other error occurs.
+    if format_cmd_result.returncode != 0:
+        if 'failed to rescan namespaces' not in format_cmd_result.stderr \
+                or 'Success formatting namespace' not in format_cmd_result.stdout:
+            logging.error(format_cmd_result.stdout)
+            logging.error(format_cmd_result.stderr)
+            print("Unable to format device; skipping this configuration")
+            return False
+
+    logging.debug(format_cmd_result.stdout)
+    return True
+
+
+def difdix_test(test_env, args, lbaf, pitype, elba):
+    """
+    Adjust test arguments based on values of lbaf, pitype, and elba.  Then run
+    the tests.
+    """
+    for test in TEST_LIST:
+        test['force_skip'] = False
+
+        blocksize = lbaf['ds']
+        # Set fio blocksize parameter at runtime
+        # If we formatted the device in extended LBA mode (e.g., 520-byte
+        # sectors), we usually need to add the lba data size and metadata size
+        # together for fio's bs parameter. However, if pi_act == 1 and the
+        # device is formatted so that the metadata is the same size as the PI,
+        # then the device will take care of everything and the application
+        # should just use regular power of 2 lba data size even when the device
+        # is in extended lba mode.
+        if elba:
+            if not test['fio_opts']['pi_act'] or lbaf['ms'] != lbaf['pi_bytes']:
+                blocksize += lbaf['ms']
+            test['fio_opts']['md_per_io_size'] = 0
+        else:
+        # If we are using a separate buffer for metadata, fio doesn't need to
+        # do anything when pi_act==1 and protection information size is equal to
+        # metadata size since the device is taking care of it all. If either of
+        # the two conditions do not hold, then we do need to allocate a
+        # separate metadata buffer.
+            if test['fio_opts']['pi_act'] and lbaf['ms'] == lbaf['pi_bytes']:
+                test['fio_opts']['md_per_io_size'] = 0
+            else:
+                test['fio_opts']['md_per_io_size'] = lbaf['ms'] * test['bs_high']
+
+        test['fio_opts']['bsrange'] = f"{blocksize * test['bs_low']}-{blocksize * test['bs_high']}"
+        if 'mdsize_adjustment' in test:
+            test['fio_opts']['md_per_io_size'] += test['mdsize_adjustment']
+
+        # Set fio pi_chk parameter at runtime. If the device is formatted
+        # with Type 3 protection information, this means that the reference
+        # tag is not checked and I/O commands may throw an error if they
+        # are submitted with the REFTAG bit set in pi_chk. Make sure fio
+        # does not set pi_chk's REFTAG bit if the device is formatted with
+        # Type 3 PI.
+        if 'pi_chk' in test:
+            if pitype == 3 and 'REFTAG' in test['pi_chk']:
+                test['fio_opts']['pi_chk'] = test['pi_chk'].replace('REFTAG','')
+                logging.debug("Type 3 PI: dropping REFTAG bit")
+            else:
+                test['fio_opts']['pi_chk'] = test['pi_chk']
+
+        if 'skip' in test:
+            if pitype == 3 and 'type3' in test['skip']:
+                test['force_skip'] = True
+                logging.debug("Type 3 PI: skipping test case")
+            if elba and 'elba' in test['skip']:
+                test['force_skip'] = True
+                logging.debug("extended lba format: skipping test case")
+
+        logging.debug("Test %d: pi_act=%d, bsrange=%s, md_per_io_size=%d", test['test_id'],
+                      test['fio_opts']['pi_act'], test['fio_opts']['bsrange'],
+                      test['fio_opts']['md_per_io_size'])
+
+    return run_fio_tests(TEST_LIST, test_env, args)
+
+
+def main():
+    """
+    Run tests using fio's io_uring_cmd ioengine to exercise end-to-end data
+    protection capabilities.
+    """
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept_pi-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
+
+    lbaf_list = get_lbafs(args)
+    get_guard_pi(lbaf_list, args)
+    caps = get_capabilities(args)
+    print("Device capabilities:", caps)
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept_pi',
+              }
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    try:
+        for lbaf, pil, pitype, elba in itertools.product(lbaf_list, caps['pil'], caps['pitype'],
+                                                         caps['elba']):
+            print(f"\nlbaf: {lbaf}, pil: {pil}, pitype: {pitype}, elba: {elba}")
+
+            if not format_device(args, lbaf, pitype, pil, elba):
+                continue
+
+            test_env['artifact_root'] = \
+                os.path.join(artifact_root, f"lbaf{lbaf['lbaf']}pil{pil}pitype{pitype}" \
+                    f"elba{elba}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = difdix_test(test_env, args, lbaf, pitype, elba)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+    except KeyboardInterrupt:
+        pass
+
+    print(f"\n\n{total['passed']} test(s) passed, {total['failed']} failed, " \
+            f"{total['skipped']} skipped")
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
