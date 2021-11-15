Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27BCC433F5
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B7961B4C
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbhKOVRJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:17:09 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37202 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346514AbhKOUSM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:18:12 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2021 15:18:12 EST
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200821usoutp01abb460c858164f830c43d06b73dab4d8~30RqniumF2139421394usoutp01n;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20211115200821usoutp01abb460c858164f830c43d06b73dab4d8~30RqniumF2139421394usoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006902;
        bh=6LsOdNUpyxHBHFQtSwglorEZpRoHTWETiaZ2vVnyM1c=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=dxQJawEYk6QgvTqNwTloJPrms4cpAFdicvUU9E3XS4ZAdEx6NKTff51U4espz0LAv
         ArQT87UpOCSCvtfXiyuChvS/qoJfON+c3UULjnUMCPaF7VFk8XhnSMPP/m9qIoJ57b
         UrnXM31Yj4IiQH/foT/pUu8nDCH0NPtwel2IMyio=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p1a3e1b8ecf52c58324136740c9849f2ca~30RqZVX2w1399213992uscas1p1Q;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id E1.25.19318.53EB2916; Mon,
        15 Nov 2021 15:08:21 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p2e7dc56386571a492e3379b718ca2770c~30RqNDh852403524035uscas1p20;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
X-AuditID: cbfec370-c37ff70000014b76-26-6192be354161
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 2F.0C.56110.43EB2916; Mon,
        15 Nov 2021 15:08:21 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Mon, 15 Nov 2021 12:07:17 -0800
Received: from SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7]) by
        SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7%13]) with mapi id
        15.01.2242.008; Mon, 15 Nov 2021 12:07:17 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/6] sg: add support for VERIFY command using write modes
Thread-Topic: [PATCH 1/6] sg: add support for VERIFY command using write
        modes
Thread-Index: AQHX2lxj16gK4axd1kagUO8N3Degkg==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-2-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7qm+yYlGkz4pmGx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY+PFy8wFS30qnh/dytjAeMemi5GTQ0LARGLq
        uuusXYxcHEICKxkl9rxuYodwWpkk+jdNYoWpali4jhEisZZR4tOzPewgCSGBj4wSX/s0IOyD
        jBLHNip1MXJwsAloSrzdXwASFhEIk/j5aDvYHGYBdaCKDWwgtrCAp8SJh6tZIWoCJKbOf80M
        YetJ9ExuYQGxWQRUJW6emsYIYvMK2Ej0Pn/BBGJzCthKLJ13EuwERgExie+n1jBBzBeXuPVk
        PhPEzYISi2bvYYawxST+7XrIBmErStz//pIdol5P4sbUKWwQtrbEsoUQN/AC9Z6c+YQFol5S
        4uCKGywgv0sIdHJIvG5aBDXIReLwtFPsELa0xPQ1l6EazjFKPPgXDNFwnVFixZfF0FC0llj4
        Zz3UpXwSf389YpzAqDwLyeGzkBw1C8lRs5ActYCRZRWjeGlxcW56arFxXmq5XnFibnFpXrpe
        cn7uJkZg0jj973DBDsZbtz7qHWJk4mA8xCjBwawkwssSPSlRiDclsbIqtSg/vqg0J7X4EKM0
        B4uSOO/pPw2JQgLpiSWp2ampBalFMFkmDk6pBqaEdYFXRd0D+25z/78UcyRvccfF2BfZOeJr
        zRZq9jIYvH2+1Hbj2VjBrolT2n5PWdbLrHbf8LSEmeXZ8yfcoz97tn1xWxSR2cRSof2FKeyL
        v+Ktl1qHUxgKHJlLn0e+k5vmv8tRsMOeq2P1Dh3BNc+OXLw6QWyy26KiG3O89J6+5jr8KNc1
        trqzjCdK6sti54dOURdtC855KqxOSJbkK2cwO+hZJyQx423TrtOn7qqttj2ywqfHufPT+9lL
        t946skGDZZ3Vhsb5jpbn78xl+lf7vfixbKn/gcQL3vMfLp2j8NBjx7Er34UDvMRtXLboPtf5
        vDtu6hbLf6nH9kWIr3rPJJ05Obxy4vb0QxeOGZkosRRnJBpqMRcVJwIA8gAQK4kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCapGu6b1Kiwc39bBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyNl68zFyw1Kfi+dGtjA2Md2y6GDk5JARMJBoW
        rmPsYuTiEBJYzSgx/9hfJgjnI6PEvE0LWSCcg4wSP29sYO1i5OBgE9CUeLu/AKRbRCBM4uej
        7awgNrOAusSxjRvYQGxhAU+JEw9Xs0LU+En82nKCBcLWk+iZ3AJmswioStw8NY0RxOYVsJHo
        ff6CCcQWArI3be0HszkFbCWWzjvJDmIzCohJfD+1hglil7jErSfzmSA+EJBYsuc8M4QtKvHy
        8T9WCFtR4v73l+wQ9XoSN6ZOYYOwtSWWLXzNDLFXUOLkzCcsEPWSEgdX3GCZwCg+C8mKWUja
        ZyFpn4WkfQEjyypG8dLi4tz0imLjvNRyveLE3OLSvHS95PzcTYzAyDr973DMDsZ7tz7qHWJk
        4mA8xCjBwawkwssSPSlRiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9H7MR4IYH0xJLU7NTUgtQi
        mCwTB6dUA5N8nqsT88frK8vb51QvE7LvvXrvgkO8bQrPJZ2SW4eCS5ekrpt2R92pTm2Op9G7
        Lb9efGS98F4zvfZFaaiUYGvr3kgmjdDYSp8l+2TucN0MbzDtd06eKRCx+8gG7T7F3O+xZ4wk
        l/0yyt1w8MXkI4vS9NYfneKzbZ/6fGep9X9nsrSt5bqT7Gm+rzLXcadv+bzDC1vz9morSP35
        evRcVeLsTJ4Yv4VPL7258LfzwLV0C862lNyJAYcf91+LYnTtvuXmvGE/Z5l98RKRJN7SnRu1
        dD/tELs5s+FlYmPJXUZv+bVR1a/YtPXtFY4HWtp83i6QdMGnUVznyqktJ7gUpi0UqXSb9vRC
        UDvH9ZYESyWW4oxEQy3mouJEAJKqlTYbAwAA
X-CMS-MailID: 20211115200821uscas1p2e7dc56386571a492e3379b718ca2770c
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200821uscas1p2e7dc56386571a492e3379b718ca2770c
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211115200821uscas1p2e7dc56386571a492e3379b718ca2770c@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

fio does not have an explicit verify data direction and creating a new data
direction just for SCSI VERIFY commands probably is not worthwhile. The for=
mat
of SCSI VERIFY commands matches that of write operations since VERIFY comma=
nds
can include data transfer to the device. So it seems reasonable to have VER=
IFY
commands be accounted for as write operations by fio.

Use the sg_write_mode option to support SCSI VERIFY commands with different
BYTCHK values.

BYTCHK	Description
00	No data is transferred to the device; device data is checked
01	Device data is compared with data transferred to device
11	Same as 01 except that only one sector of data is transferred to the
device and each sector specified in the verification extent is compared aga=
inst
this transferred data.

Also update documentation and add a couple example jobs files.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO                       | 14 +++++++++
 engines/sg.c                | 41 ++++++++++++++++++++++++--
 examples/sg_verify-fail.fio | 48 +++++++++++++++++++++++++++++++
 examples/sg_verify.fio      | 57 +++++++++++++++++++++++++++++++++++++
 fio.1                       | 24 +++++++++++++---
 5 files changed, 178 insertions(+), 6 deletions(-)
 create mode 100644 examples/sg_verify-fail.fio
 create mode 100644 examples/sg_verify.fio

diff --git a/HOWTO b/HOWTO
index 196bca6c..c641a2a5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2501,6 +2501,20 @@ with the caveat that when used on the command line, =
they must come after the
 		for each command but only the first 512 bytes will be used and
 		transferred to the device. The writefua option is ignored with this
 		selection.
+	**verify_bytchk_00**
+		Issue VERIFY commands with BYTCHK set to 00. This directs the
+		device to carry out a medium verification with no data comparison.
+	**verify_bytchk_01**
+		Issue VERIFY commands with BYTCHK set to 01. This directs the device to
+		compare the data on the device with the data transferred to the device.
+	**verify_bytchk_11**
+		Issue VERIFY commands with BYTCHK set to 11. This transfers a
+		single block to the device and compares the contents of this block with =
the
+		data on the device beginning at the specified offset. fio's block size
+		parameter specifies the total amount of data compared with this command.
+		However, only one block (sector) worth of data is transferred to the dev=
ice.
+		This is similar to the WRITE SAME command except that data is compared i=
nstead
+		of written.
=20
 .. option:: hipri : [sg]
=20
diff --git a/engines/sg.c b/engines/sg.c
index 1c019384..0c525fae 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -66,8 +66,11 @@
=20
 enum {
 	FIO_SG_WRITE		=3D 1,
-	FIO_SG_WRITE_VERIFY	=3D 2,
-	FIO_SG_WRITE_SAME	=3D 3
+	FIO_SG_WRITE_VERIFY,
+	FIO_SG_WRITE_SAME,
+	FIO_SG_VERIFY_BYTCHK_00,
+	FIO_SG_VERIFY_BYTCHK_01,
+	FIO_SG_VERIFY_BYTCHK_11,
 };
=20
 struct sg_options {
@@ -128,6 +131,18 @@ static struct fio_option options[] =3D {
 			    .oval =3D FIO_SG_WRITE_SAME,
 			    .help =3D "Issue SCSI WRITE SAME commands",
 			  },
+			  { .ival =3D "verify_bytchk_00",
+			    .oval =3D FIO_SG_VERIFY_BYTCHK_00,
+			    .help =3D "Issue SCSI VERIFY commands with BYTCHK set to 00",
+			  },
+			  { .ival =3D "verify_bytchk_01",
+			    .oval =3D FIO_SG_VERIFY_BYTCHK_01,
+			    .help =3D "Issue SCSI VERIFY commands with BYTCHK set to 01",
+			  },
+			  { .ival =3D "verify_bytchk_11",
+			    .oval =3D FIO_SG_VERIFY_BYTCHK_11,
+			    .help =3D "Issue SCSI VERIFY commands with BYTCHK set to 11",
+			  },
 		},
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_SG,
@@ -576,6 +591,28 @@ static int fio_sgio_prep(struct thread_data *td, struc=
t io_u *io_u)
 			else
 				hdr->cmdp[0] =3D 0x93; // write same(16)
 			break;
+		case FIO_SG_VERIFY_BYTCHK_00:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] =3D 0x2f; // VERIFY(10)
+			else
+				hdr->cmdp[0] =3D 0x8f; // VERIFY(16)
+			hdr->dxfer_len =3D 0;
+			break;
+		case FIO_SG_VERIFY_BYTCHK_01:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] =3D 0x2f; // VERIFY(10)
+			else
+				hdr->cmdp[0] =3D 0x8f; // VERIFY(16)
+			hdr->cmdp[1] |=3D 0x02;		// BYTCHK =3D 01b
+			break;
+		case FIO_SG_VERIFY_BYTCHK_11:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] =3D 0x2f; // VERIFY(10)
+			else
+				hdr->cmdp[0] =3D 0x8f; // VERIFY(16)
+			hdr->cmdp[1] |=3D 0x06;		// BYTCHK =3D 11b
+			hdr->dxfer_len =3D sd->bs;
+			break;
 		};
=20
 		fio_sgio_rw_lba(hdr, lba, nr_blocks);
diff --git a/examples/sg_verify-fail.fio b/examples/sg_verify-fail.fio
new file mode 100644
index 00000000..64feece3
--- /dev/null
+++ b/examples/sg_verify-fail.fio
@@ -0,0 +1,48 @@
+#
+# **********************************
+# * !!THIS IS A DESTRUCTIVE TEST!! *
+# * IF NOT CHANGED THIS TEST WILL  *
+# * DESTROY DATA ON /dev/sdb       *
+# **********************************
+#
+# Test SCSI VERIFY commands issued via the sg ioengine
+# The jobs with fail in the name should produce errors
+#
+# job			description
+# precon		precondition the device by writing with a known
+#			pattern
+# verify01		verify each block one at a time by comparing to known
+#			pattern
+# verify01-fail		verifying one too many blocks should produce a failure
+# verify11-one_ios	verify all 20 blocks by sending only 512 bytes
+# verify11-fail		verifying beyond the preconditioned region should
+#			produce a failure
+
+[global]
+filename=3D/dev/sdb
+buffer_pattern=3D0x01
+ioengine=3Dsg
+rw=3Dwrite
+bs=3D512
+number_ios=3D20
+stonewall
+
+[precon]
+
+[verify01]
+sg_write_mode=3Dverify_bytchk_01
+number_ios=3D20
+
+[verify01-fail]
+sg_write_mode=3Dverify_bytchk_01
+number_ios=3D21
+
+[verify11-one_ios]
+sg_write_mode=3Dverify_bytchk_11
+number_ios=3D1
+bs=3D10240
+
+[verify11-fail]
+sg_write_mode=3Dverify_bytchk_11
+number_ios=3D1
+bs=3D10752
diff --git a/examples/sg_verify.fio b/examples/sg_verify.fio
new file mode 100644
index 00000000..6db0dd0a
--- /dev/null
+++ b/examples/sg_verify.fio
@@ -0,0 +1,57 @@
+#
+# **********************************
+# * !!THIS IS A DESTRUCTIVE TEST!! *
+# * IF NOT CHANGED THIS TEST WILL  *
+# * DESTROY DATA ON /dev/sdb       *
+# **********************************
+#
+# Test SCSI VERIFY commands issued via the sg ioengine
+# All of the jobs below should complete without error
+#
+# job			description
+# precon		precondition the device by writing with a known
+#			pattern
+# verify00		verify written data on medium only
+# verify01		verify each block one at a time by comparing to known
+#			pattern
+# verify01-two_ios	verify same data but with only two VERIFY operations
+# verify11		verify each block one at a time
+# verify11-five_ios	verify data with five IOs, four blocks at a time,
+#			sending 512 bytes for each IO
+# verify11-one_ios	verify all 20 blocks by sending only 512 bytes
+#
+
+[global]
+filename=3D/dev/sdb
+buffer_pattern=3D0x01
+ioengine=3Dsg
+rw=3Dwrite
+bs=3D512
+number_ios=3D20
+stonewall
+
+[precon]
+
+[verify00]
+sg_write_mode=3Dverify_bytchk_00
+
+[verify01]
+sg_write_mode=3Dverify_bytchk_01
+
+[verify01-two_ios]
+sg_write_mode=3Dverify_bytchk_01
+bs=3D5120
+number_ios=3D2
+
+[verify11]
+sg_write_mode=3Dverify_bytchk_11
+
+[verify11-five_ios]
+sg_write_mode=3Dverify_bytchk_11
+bs=3D2048
+number_ios=3D5
+
+[verify11-one_ios]
+sg_write_mode=3Dverify_bytchk_11
+bs=3D10240
+number_ios=3D1
diff --git a/fio.1 b/fio.1
index e3c3feae..2d69615b 100644
--- a/fio.1
+++ b/fio.1
@@ -2281,7 +2281,7 @@ With writefua option set to 1, write operations inclu=
de the force
 unit access (fua) flag. Default: 0.
 .TP
 .BI (sg)sg_write_mode \fR=3D\fPstr
-Specify the type of write commands to issue. This option can take three
+Specify the type of write commands to issue. This option can take multiple
 values:
 .RS
 .RS
@@ -2290,9 +2290,9 @@ values:
 Write opcodes are issued as usual
 .TP
 .B verify
-Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 0. This
-directs the device to carry out a medium verification with no data
-comparison. The writefua option is ignored with this selection.
+Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 00b. This direct=
s the
+device to carry out a medium verification with no data comparison for the =
data
+that was written. The writefua option is ignored with this selection.
 .TP
 .B same
 Issue WRITE SAME commands. This transfers a single block to the device
@@ -2305,6 +2305,22 @@ blocksize=3D8k will write 16 sectors with each comma=
nd. fio will still
 generate 8k of data for each command butonly the first 512 bytes will
 be used and transferred to the device. The writefua option is ignored
 with this selection.
+.TP
+.B verify_bytchk_00
+Issue VERIFY commands with BYTCHK set to 00. This directs the device to ca=
rry
+out a medium verification with no data comparison.
+.TP
+.B verify_bytchk_01
+Issue VERIFY commands with BYTCHK set to 01. This directs the device to
+compare the data on the device with the data transferred to the device.
+.TP
+.B verify_bytchk_11
+Issue VERIFY commands with BYTCHK set to 11. This transfers a single block=
 to
+the device and compares the contents of this block with the data on the de=
vice
+beginning at the specified offset. fio's block size parameter specifies th=
e
+total amount of data compared with this command. However, only one block
+(sector) worth of data is transferred to the device. This is similar to th=
e
+WRITE SAME command except that data is compared instead of written.
 .RE
 .RE
 .TP
--=20
2.25.1
