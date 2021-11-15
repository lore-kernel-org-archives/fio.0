Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A36C4332F
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C5061B3F
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhKOVRO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:17:14 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37192 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346506AbhKOUSN (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:18:13 -0500
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200822usoutp01374d546e5d4c77d9bb832e66ce56aca0~30RrDyWQ52207922079usoutp01N;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20211115200822usoutp01374d546e5d4c77d9bb832e66ce56aca0~30RrDyWQ52207922079usoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006902;
        bh=JfMKY/Iisi7x96CcYjE7CBk6Q18+XkRnTTrgqf0FkWQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=Fuqp1xJR0OO/+pXO6eqPn6gLVfApL+RwPaTFVk14kSG5ucHzVWJaaUiefAJXsyhTf
         7f/Gk8LRFV3fiKKXkLf+CpBYlFkWd5/WVitfrpdTN8TsdBjSqikFbRPvpv0t4yhtxS
         /xZ9AsJsKBZm5+gmthEMXH1qEIgbzb1eRjLzCrhc=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200822uscas1p19500aabff215f629e0e0eb1e7631cf55~30RqxMnVS1398813988uscas1p1K;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 12.25.19318.53EB2916; Mon,
        15 Nov 2021 15:08:22 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p209c5e40580f1e5a6328f1a725f887f0f~30RqgrgEL2406324063uscas1p2y;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
X-AuditID: cbfec370-c4fff70000014b76-27-6192be35ec00
Received: from SSI-EX2.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 8F.0C.56110.53EB2916; Mon,
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
Subject: [PATCH 3/6] sg: improve sg_write_mode option names
Thread-Topic: [PATCH 3/6] sg: improve sg_write_mode option names
Thread-Index: AQHX2lxjNVbNvmIUI0Wi203bpmrcgQ==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-4-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7pm+yYlGmxvZrRYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVcXR6J2vBJ5WKtuv/2BoYD8t0MXJySAiYSBz6
        +4qpi5GLQ0hgJaPExAldrBBOK5PEypl7mbsYOcCq5m4sgYivZZT4+eIWM4TzkVFi+4VLLCCj
        hAQOMkoc26gE0sAmoCnxdn8BSFhEIEzi56PtrCA2s4A6UMUGNhBbWMBaYvatV4wQNQ4Sfzct
        grL1JJ7Pn80MYrMIqErcPDUNLM4rYCOxtacHbBWngK3E0nkn2UFsRgExie+n1jBBzBeXuPVk
        PhPEZ4ISi2bvYYawxST+7XrIBmErStz//pIdol5P4sbUKWwQtrbEsoWvmSF2CUqcnPmEBaJe
        UuLgihtQdieHRP9lUQjbReLwk8lQcWmJ6WsuQ9nnGCUe/AsGhY+EwHVGiRVfFrNCJKwlFv5Z
        D3Uon8TfX48YJzAqz0Jy9ywkN81CctMsJDctYGRZxSheWlycm55abJyXWq5XnJhbXJqXrpec
        n7uJEZgyTv87XLCD8datj3qHGJk4GA8xSnAwK4nwskRPShTiTUmsrEotyo8vKs1JLT7EKM3B
        oiTOe/pPQ6KQQHpiSWp2ampBahFMlomDU6qBicNzT7BMylaRGcuEW03vvOqaYLx8+sfOKfcM
        jnqJN3vXnPlfq3Eg4cnMprD2bc8va2vHsspXxWfLnK6p4BfMDFvikGL3/tXeLZP0LnwWcvzF
        aPzeyYYts/uq82YZxUvZQtK6xz0UWiIvHbk+L0qTxW2XzZGQKPk1P/f+kbv+UsC6jv2F/waL
        +lvzxJWWMEVk9wuY1jTe3TPdw3xFTNlttfDshFUWJRUrzv+4oPn7ZAS/ntcc1eV3RbLf7JDd
        7W/WErbA8Y2PudtpTYl4hZqVT+L2HXp2SflxScD/VacilzSq/TasORunHhiu7GkhyrVtQda9
        igt/z7PfeJXFYmRpxbWllfekz5fyBRflo1crsRRnJBpqMRcVJwIAajNRA4gDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqGu6b1Kiwdr5shar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyjk7vZC34pFLRdv0fWwPjYZkuRg4OCQETibkb
        S7oYuTiEBFYzSjy484cVwvnIKHF38U4mCOcgo8TPGxtYQTrYBDQl3u4v6GLk5BARCJP4+Wg7
        K4jNLKAucWzjBjYQW1jAWmL2rVeMEDUOEn83LYKy9SSez5/NDGKzCKhK3Dw1DSzOK2AjsbWn
        hwXEFgKyN23tZwKxOQVsJZbOO8kOYjMKiEl8P7WGCWKXuMStJ/PBbAkBAYkle84zQ9iiEi8f
        /2OFsBUl7n9/yQ5RrydxY+oUNghbW2LZwtfMEHsFJU7OfMICUS8pcXDFDZYJjOKzkKyYhaR9
        FpL2WUjaFzCyrGIULy0uzk2vKDbOSy3XK07MLS7NS9dLzs/dxAiMq9P/DsfsYLx366PeIUYm
        DsZDjBIczEoivCzRkxKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83rETowXEkhPLEnNTk0tSC2C
        yTJxcEo1MFUHs6SmLylNSjwZ5KKqnan0efkq950uHPWf2Fa/f2fM5pcca3zvTXKlbeCUgF/P
        J0bnu5Q85lW+vYmX4Z1fn+tJt9bACL2P8re3bRAudS9nT1O8fmde7DpjvnNfZ8p9eHHk4t4f
        31nObJdJrVnwe61//erIKFNJae1TD56czVH/dSq0nbuzqlqmxoJ1x+mMZbk/LyTzT1k1/Ufq
        NqU/LhPfGt2xvNicvzxtjim/2u3wrab6U14HuOw4dEVzYkJNPI9FsujZL89ebajezrXbPmVV
        u7TNqm21flYa8/fUcM4+JX190ofvh2OmPjogxXnmVNJhqTdzTRdFxJzamGEbsH/vfGbpv1EV
        KQba8mv1a5VYijMSDbWYi4oTAc/c1LcaAwAA
X-CMS-MailID: 20211115200821uscas1p209c5e40580f1e5a6328f1a725f887f0f
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200821uscas1p209c5e40580f1e5a6328f1a725f887f0f
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211115200821uscas1p209c5e40580f1e5a6328f1a725f887f0f@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

There is a name collision for the sg_write_mode options for the WRITE AND
VERIFY and VERIFY commands. Deprecate the 'verify' option and use
'write_and_verify' instead. Do the same thing for 'same' and 'write_same' t=
o
have a consistent naming scheme. The original option names are still suppor=
ted
for backward compatibility but list them as deprecated.

Here are the new sg_write_mode options:

Option			SCSI command
write			WRITE (default)
write_and_verify	WRITE AND VERIFY
verify (deprecated)	WRITE AND VERIFY
write_same		WRITE SAME
same (deprecated)	WRITE SAME
write_same_ndob         WRITE SAME with NDOB flag set
verify_bytchk_00	VERIFY with BYTCHK set to 00
verify_bytchk_01	VERIFY with BYTCHK set to 01
verify_bytchk_11	VERIFY with BYTCHK set to 11

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO        |  8 ++++++--
 engines/sg.c | 14 ++++++++++++--
 fio.1        | 10 ++++++++--
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3c507d50..0f204afa 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2486,11 +2486,13 @@ with the caveat that when used on the command line,=
 they must come after the
=20
 	**write**
 		This is the default where write opcodes are issued as usual.
-	**verify**
+	**write_and_verify**
 		Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 0. This
 		directs the device to carry out a medium verification with no data
 		comparison. The writefua option is ignored with this selection.
-	**same**
+	**verify**
+		This option is deprecated. Use write_and_verify instead.
+	**write_same**
 		Issue WRITE SAME commands. This transfers a single block to the device
 		and writes this same block of data to a contiguous sequence of LBAs
 		beginning at the specified offset. fio's block size parameter specifies
@@ -2501,6 +2503,8 @@ with the caveat that when used on the command line, t=
hey must come after the
 		for each command but only the first 512 bytes will be used and
 		transferred to the device. The writefua option is ignored with this
 		selection.
+	**same**
+		This option is deprecated. Use write_same instead.
 	**write_same_ndob**
 		Issue WRITE SAME(16) commands as above but with the No Data Output
 		Buffer (NDOB) bit set. No data will be transferred to the device with
diff --git a/engines/sg.c b/engines/sg.c
index 3c4e986d..d15b438f 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -124,14 +124,24 @@ static struct fio_option options[] =3D {
 			    .oval =3D FIO_SG_WRITE,
 			    .help =3D "Issue standard SCSI WRITE commands",
 			  },
-			  { .ival =3D "verify",
+			  { .ival =3D "write_and_verify",
 			    .oval =3D FIO_SG_WRITE_VERIFY,
 			    .help =3D "Issue SCSI WRITE AND VERIFY commands",
 			  },
-			  { .ival =3D "same",
+			  { .ival =3D "verify",
+			    .oval =3D FIO_SG_WRITE_VERIFY,
+			    .help =3D "Issue SCSI WRITE AND VERIFY commands. This "
+				    "option is deprecated. Use write_and_verify instead.",
+			  },
+			  { .ival =3D "write_same",
 			    .oval =3D FIO_SG_WRITE_SAME,
 			    .help =3D "Issue SCSI WRITE SAME commands",
 			  },
+			  { .ival =3D "same",
+			    .oval =3D FIO_SG_WRITE_SAME,
+			    .help =3D "Issue SCSI WRITE SAME commands. This "
+				    "option is deprecated. Use write_same instead.",
+			  },
 			  { .ival =3D "write_same_ndob",
 			    .oval =3D FIO_SG_WRITE_SAME_NDOB,
 			    .help =3D "Issue SCSI WRITE SAME(16) commands with NDOB flag set",
diff --git a/fio.1 b/fio.1
index b1af6e8f..71f98135 100644
--- a/fio.1
+++ b/fio.1
@@ -2289,12 +2289,15 @@ values:
 .B write (default)
 Write opcodes are issued as usual
 .TP
-.B verify
+.B write_and_verify
 Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 00b. This direct=
s the
 device to carry out a medium verification with no data comparison for the =
data
 that was written. The writefua option is ignored with this selection.
 .TP
-.B same
+.B verify
+This option is deprecated. Use write_and_verify instead.
+.TP
+.B write_same
 Issue WRITE SAME commands. This transfers a single block to the device
 and writes this same block of data to a contiguous sequence of LBAs
 beginning at the specified offset. fio's block size parameter
@@ -2306,6 +2309,9 @@ generate 8k of data for each command butonly the firs=
t 512 bytes will
 be used and transferred to the device. The writefua option is ignored
 with this selection.
 .TP
+.B same
+This option is deprecated. Use write_same instead.
+.TP
 .B write_same_ndob
 Issue WRITE SAME(16) commands as above but with the No Data Output
 Buffer (NDOB) bit set. No data will be transferred to the device with
--=20
2.25.1
