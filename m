Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494B5C433FE
	for <fio@archiver.kernel.org>; Tue, 16 Nov 2021 00:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3751561131
	for <fio@archiver.kernel.org>; Tue, 16 Nov 2021 00:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350043AbhKPAZ2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:25:28 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:47812 "EHLO
        mailout2.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349826AbhKOUUF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:20:05 -0500
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200822usoutp022f42f83e142c4b6c3578871164895f30~30Rqs-WLC0459204592usoutp02J;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20211115200822usoutp022f42f83e142c4b6c3578871164895f30~30Rqs-WLC0459204592usoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006902;
        bh=EI9+vT/jleJ7dv/C45pf0gHj9trClTb5vz6OMeT3rVU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=qb6zgnSAZ6TlvK2nnnVjAJWX5daAadCC3mu6O2BhFTVGy0dLhmMHuho/l8/dOOWlH
         26+WvMZnuNwGYxm0RQg1iFzbDE5AA1UBGgg/nc5kVDzv8TnQEuQBzQ+4XeGJ4tXsa9
         AX4efMcfWgQLUivUpXdfmVOzLxQ+90BxFjBQUEdg=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p25742f55cf94221fc2cdaf8c21eb3f109~30Rqjr0Ek1521815218uscas1p2V;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id AD.71.03480.53EB2916; Mon,
        15 Nov 2021 15:08:21 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p1319ea93782358999fb69feb0f2f2c087~30RqQ5AGS1400714007uscas1p1L;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
X-AuditID: cbfec36f-ec7ff70000010d98-c7-6192be35f029
Received: from SSI-EX2.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 3F.0C.56110.53EB2916; Mon,
        15 Nov 2021 15:08:21 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Mon, 15 Nov 2021 12:07:17 -0800
Received: from SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7]) by
        SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7%13]) with mapi id
        15.01.2242.008; Mon, 15 Nov 2021 12:07:17 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/6] sg: add support for WRITE SAME(16) commands with NDOB
 flag set
Thread-Topic: [PATCH 2/6] sg: add support for WRITE SAME(16) commands with
        NDOB flag set
Thread-Index: AQHX2lxjOmxv7RizE0q35V6gLVmVWw==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-3-vincent.fu@samsung.com>
In-Reply-To: <20211115200807.117138-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djXc7qm+yYlGqz4bGKx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEro+9XO1tBi27FxrUTGRsYDyt3MXJySAiYSNye
        e4Oli5GLQ0hgJaNEZ2sDG4TTyiTxftojFpiq1XNaoRJrGSVOf3zPDOF8ZJTYfuESWJWQwEFG
        iWMblboYOTjYBDQl3u4vAAmLCIRJ/Hy0nRXEZhZQB6rYwAZiCwuESsy5sZUVoiZKYtnVj4wQ
        tp7Ej89/wGwWAVWJm6emgdm8AjYSy+ccZwKxOQVsJZbOO8kOYjMKiEl8P7WGCWK+uMStJ/OZ
        II4WlFg0ew8zhC0m8W/XQzYIW1Hi/veX7BD1ehI3pk5hg7C1JZYtfM0MsUtQ4uTMJ1DPS0oc
        XAEJIgmBTg6JtqXv2CESLhJHTpyHWiYtMX3NZaiGc4wSD/4FQzRcZ5RY8WUxK0TCWmLhn/VQ
        l/JJ/P31iHECo/IsJIfPQnLULCRHzUJy1AJGllWM4qXFxbnpqcVGeanlesWJucWleel6yfm5
        mxiBaeP0v8P5Oxiv3/qod4iRiYPxEKMEB7OSCC9L9KREId6UxMqq1KL8+KLSnNTiQ4zSHCxK
        4ryn/zQkCgmkJ5akZqemFqQWwWSZODilGpjqkq5GLU06ptO969eZvW+42R6/7uvq3dCTN6k+
        +vhEvXW8av8XdH2RLuSOKF5t4/3lsdVjrlPcvnrNy//pc7Op7MxfIKUdz6cRNK/Kc+HFF1Pe
        uvDc3Kz95c43rbyda6yf/1hmErB2hvisO4GHnU7y/+0I8W45cehvn5zW7Fka+wJjNk/s/vXO
        9RPfCkHrmVEWa2o1jwkoLro5f6bd/17B6/oF/bUuOxoVrk/mD8kTmJxjYqw//8UUtt89Byr3
        nJrSdtumyePsLYMk7cMH3bk2sUVu6diWzV75ozpzgsJOppmv5qjn/E1M4rm9V2SD28Z3/n9i
        OPZ4HVh9SOlXU/DFRKXju9kbvklHH9xc17RDiaU4I9FQi7moOBEArCj1jooDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCaqGu6b1KiwdeVvBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgy+n61sxW06FZsXDuRsYHxsHIXIyeHhICJxOo5
        rWxdjFwcQgKrGSXePlrDCuF8ZJS4u3gnE4RzkFHi540NQBkODjYBTYm3+wtAukUEwiR+PtrO
        CmIzC6hLHNu4gQ3EFhYIlZhzYysrRE2UxLLDe5ggbD2JH5//MILYLAKqEjdPTQOzeQVsJJbP
        OQ5WIwRkb9raD2ZzCthKLJ13kh3EZhQQk/h+ag0TxC5xiVtP5jNBfCAgsWTPeWYIW1Ti5eN/
        rBC2osT97y/ZIer1JG5MncIGYWtLLFv4mhlir6DEyZlPWCDqJSUOrrjBMoFRfBaSFbOQtM9C
        0j4LSfsCRpZVjOKlxcW56RXFxnmp5XrFibnFpXnpesn5uZsYgZF1+t/hmB2M92591DvEyMTB
        eIhRgoNZSYSXJXpSohBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFej9iJ8UIC6YklqdmpqQWpRTBZ
        Jg5OqQamHtXsZzrsNrfPcxY7ar6c6tZ5Iob13+rMr/aVh52DLgU03dz4ry/pIq/zxD1B0gsU
        Zymu/SqtOyXV5/nCXVtTXKZnXv/brDDnu86m4xPye39Lf7y9Zf/tromXAgvEC+VZJ9z+fu5c
        KcuOXb8nzj8glrW0tuuuoGv1FXHejz0MKXYXFLZNcdpmZZd4/OOENifTvwGZXxPSNTJXb57H
        W17QW6N3nFOh2Jl1n7PCLPnVgitlD07culnnt9OXedlvlL0bZ1QrNCu6VM2zTOfR+bDtmHnq
        aY2Unh1iJq83nD3zOmz1vfsRF0866LtoXNL/1qufFhadY17U7XR+omf60ztbsm+tl2BYdv5D
        wFmWjZKVSizFGYmGWsxFxYkAbcyUURsDAAA=
X-CMS-MailID: 20211115200821uscas1p1319ea93782358999fb69feb0f2f2c087
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200821uscas1p1319ea93782358999fb69feb0f2f2c087
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211115200821uscas1p1319ea93782358999fb69feb0f2f2c087@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add the sg_write_mode option write_same_ndob to issue WRITE SAME(16) comman=
ds
with the no data output buffer flag set. This flag is not supported for WRI=
TE
SAME(10). So all commands with this option will be WRITE SAME(16).

Also include an example job file.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO                           |  5 ++++
 engines/sg.c                    | 19 +++++++++++---
 examples/sg_write_same_ndob.fio | 44 +++++++++++++++++++++++++++++++++
 fio.1                           |  6 +++++
 4 files changed, 70 insertions(+), 4 deletions(-)
 create mode 100644 examples/sg_write_same_ndob.fio

diff --git a/HOWTO b/HOWTO
index c641a2a5..3c507d50 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2501,6 +2501,11 @@ with the caveat that when used on the command line, =
they must come after the
 		for each command but only the first 512 bytes will be used and
 		transferred to the device. The writefua option is ignored with this
 		selection.
+	**write_same_ndob**
+		Issue WRITE SAME(16) commands as above but with the No Data Output
+		Buffer (NDOB) bit set. No data will be transferred to the device with
+		this bit set. Data written will be a pre-determined pattern such as
+		all zeroes.
 	**verify_bytchk_00**
 		Issue VERIFY commands with BYTCHK set to 00. This directs the
 		device to carry out a medium verification with no data comparison.
diff --git a/engines/sg.c b/engines/sg.c
index 0c525fae..3c4e986d 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -68,6 +68,7 @@ enum {
 	FIO_SG_WRITE		=3D 1,
 	FIO_SG_WRITE_VERIFY,
 	FIO_SG_WRITE_SAME,
+	FIO_SG_WRITE_SAME_NDOB,
 	FIO_SG_VERIFY_BYTCHK_00,
 	FIO_SG_VERIFY_BYTCHK_01,
 	FIO_SG_VERIFY_BYTCHK_11,
@@ -131,6 +132,10 @@ static struct fio_option options[] =3D {
 			    .oval =3D FIO_SG_WRITE_SAME,
 			    .help =3D "Issue SCSI WRITE SAME commands",
 			  },
+			  { .ival =3D "write_same_ndob",
+			    .oval =3D FIO_SG_WRITE_SAME_NDOB,
+			    .help =3D "Issue SCSI WRITE SAME(16) commands with NDOB flag set",
+			  },
 			  { .ival =3D "verify_bytchk_00",
 			    .oval =3D FIO_SG_VERIFY_BYTCHK_00,
 			    .help =3D "Issue SCSI VERIFY commands with BYTCHK set to 00",
@@ -517,9 +522,9 @@ static enum fio_q_status fio_sgio_doio(struct thread_da=
ta *td,
 }
=20
 static void fio_sgio_rw_lba(struct sg_io_hdr *hdr, unsigned long long lba,
-			    unsigned long long nr_blocks)
+			    unsigned long long nr_blocks, bool override16)
 {
-	if (lba < MAX_10B_LBA) {
+	if (lba < MAX_10B_LBA && !override16) {
 		sgio_set_be32((uint32_t) lba, &hdr->cmdp[2]);
 		sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[7]);
 	} else {
@@ -560,7 +565,7 @@ static int fio_sgio_prep(struct thread_data *td, struct=
 io_u *io_u)
 		if (o->readfua)
 			hdr->cmdp[1] |=3D 0x08;
=20
-		fio_sgio_rw_lba(hdr, lba, nr_blocks);
+		fio_sgio_rw_lba(hdr, lba, nr_blocks, false);
=20
 	} else if (io_u->ddir =3D=3D DDIR_WRITE) {
 		sgio_hdr_init(sd, hdr, io_u, 1);
@@ -591,6 +596,11 @@ static int fio_sgio_prep(struct thread_data *td, struc=
t io_u *io_u)
 			else
 				hdr->cmdp[0] =3D 0x93; // write same(16)
 			break;
+		case FIO_SG_WRITE_SAME_NDOB:
+			hdr->cmdp[0] =3D 0x93; // write same(16)
+			hdr->cmdp[1] |=3D 0x1; // no data output buffer
+			hdr->dxfer_len =3D 0;
+			break;
 		case FIO_SG_VERIFY_BYTCHK_00:
 			if (lba < MAX_10B_LBA)
 				hdr->cmdp[0] =3D 0x2f; // VERIFY(10)
@@ -615,7 +625,8 @@ static int fio_sgio_prep(struct thread_data *td, struct=
 io_u *io_u)
 			break;
 		};
=20
-		fio_sgio_rw_lba(hdr, lba, nr_blocks);
+		fio_sgio_rw_lba(hdr, lba, nr_blocks,
+			o->write_mode =3D=3D FIO_SG_WRITE_SAME_NDOB);
=20
 	} else if (io_u->ddir =3D=3D DDIR_TRIM) {
 		struct sgio_trim *st;
diff --git a/examples/sg_write_same_ndob.fio b/examples/sg_write_same_ndob.=
fio
new file mode 100644
index 00000000..fb047319
--- /dev/null
+++ b/examples/sg_write_same_ndob.fio
@@ -0,0 +1,44 @@
+#
+# **********************************
+# * !!THIS IS A DESTRUCTIVE TEST!! *
+# * IF NOT CHANGED THIS TEST WILL  *
+# * DESTROY DATA ON /dev/sdb       *
+# **********************************
+#
+# Test WRITE SAME commands with the NDOB flag set
+# issued via the sg ioengine
+# All of the jobs below should complete without error
+# except the last one
+#
+# job			description
+# precon		Precondition the device by writing 20 blocks with a
+# 			known pattern
+# write_same_ndob	Write 19 sectors of all zeroes with the NDOB flag set
+# verify-pass		Verify 19 blocks of all zeroes
+# verify-fail		Verify 20 blocks of all zeroes. This should fail.
+#
+
+[global]
+filename=3D/dev/sdb
+buffer_pattern=3D0x01
+ioengine=3Dsg
+rw=3Dwrite
+bs=3D512
+stonewall
+
+[precon]
+number_ios=3D20
+
+[write_same_ndob]
+sg_write_mode=3Dwrite_same_ndob
+number_ios=3D19
+
+[verify-pass]
+sg_write_mode=3Dverify_bytchk_01
+buffer_pattern=3D0x00
+number_ios=3D19
+
+[verify-fail]
+sg_write_mode=3Dverify_bytchk_01
+buffer_pattern=3D0x00
+number_ios=3D20
diff --git a/fio.1 b/fio.1
index 2d69615b..b1af6e8f 100644
--- a/fio.1
+++ b/fio.1
@@ -2306,6 +2306,12 @@ generate 8k of data for each command butonly the fir=
st 512 bytes will
 be used and transferred to the device. The writefua option is ignored
 with this selection.
 .TP
+.B write_same_ndob
+Issue WRITE SAME(16) commands as above but with the No Data Output
+Buffer (NDOB) bit set. No data will be transferred to the device with
+this bit set. Data written will be a pre-determined pattern such as
+all zeroes.
+.TP
 .B verify_bytchk_00
 Issue VERIFY commands with BYTCHK set to 00. This directs the device to ca=
rry
 out a medium verification with no data comparison.
--=20
2.25.1
