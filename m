Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36964C433FE
	for <fio@archiver.kernel.org>; Tue, 16 Nov 2021 00:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E65861131
	for <fio@archiver.kernel.org>; Tue, 16 Nov 2021 00:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343612AbhKPAZb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:25:31 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:47806 "EHLO
        mailout2.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349828AbhKOUUJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:20:09 -0500
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200822usoutp02a18d052a1291282f5c53e70b0dff3f78~30RrVwRA60463804638usoutp02A;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20211115200822usoutp02a18d052a1291282f5c53e70b0dff3f78~30RrVwRA60463804638usoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006902;
        bh=HBVeGLsHY5ENfGUs5ykKKFNwnkR3s0g1bzKIPzq7A34=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=MOQMO9c0Od/zucC2+lFQ+0c3K5UZpMraAT6wM71/SQj7VXabULRDdtIIw1ctZQXpm
         eiL5UJqyNAj7hpfvZjHghC5euy/axuJOcXpsKmotMKOSLOMcTk75X1uik2uxMcp5qX
         I4wmNMaySXzyIb6uYiXOb2rkOkH8rxCJns/NGvi4=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200822uscas1p2aada212f80f7c9fca074f2e671388847~30Rq-L01Y1819518195uscas1p2C;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 3E.71.03480.63EB2916; Mon,
        15 Nov 2021 15:08:22 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p28671af8f28d8326c7dd2dc2ff1204d4b~30RqljLDH1717017170uscas1p2U;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
X-AuditID: cbfec36f-edfff70000010d98-c8-6192be36ff5a
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 71.22.47905.53EB2916; Mon,
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
Subject: [PATCH 4/6] sg: add support for WRITE STREAM(16) commands
Thread-Topic: [PATCH 4/6] sg: add support for WRITE STREAM(16) commands
Thread-Index: AQHX2lxjiTiwV9c9yUafN6+5nkkOAQ==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-5-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87pm+yYlGqy/IGix+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY/KHx+wFG8Uqpt1sZ2tgfCXYxcjJISFgIrF4
        4UvGLkYuDiGBlYwSp//vgHJamSTunZrBAlM183IfO0RiLaNE155+dpCEkMBHRomvfRoQ9kFG
        iWMblboYOTjYBDQl3u4vAAmLCIRJ/Hy0nRXEZhZQB6rYwAZiCws4Sbw/85IVosZd4kbTfDYI
        W09i4rv3YHtZBFQlbp6axghi8wrYSNzcdRAszilgK7F03kmwExgFxCS+n1rDBDFfXOLWk/lM
        EDcLSiyavYcZwhaT+LfrIRuErShx//tLdoh6PYkbU6ewQdjaEssWvmaG2CUocXLmE6jfJSUO
        rrgBZXdySGzalQphu0g0XL0JNV9a4ur1qVD2OUaJB/+CQWElIXCdUWLFl8WsEAlriYV/1kMd
        yifx99cjxgmMyrOQ3D0LyU2zkNw0C8lNCxhZVjGKlxYX56anFhvlpZbrFSfmFpfmpesl5+du
        YgSmjNP/DufvYLx+66PeIUYmDsZDjBIczEoivCzRkxKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
        857+05AoJJCeWJKanZpakFoEk2Xi4JRqYBI4ozLR6PqL5nhL1Y/sxmZ6aYZ3bJznbW34nPZ7
        q6dQWPDC302/9EMKuqrWzjltesWhKYlx3pLXN0KVuR2Ca80b5xQctpH/pMeRpcNqtPJspIGg
        zH5bcVcnJSMjJYPg/RtFHaS2aHntWTl/YzJb2wWH+3eWbIps+LHElOdjhuJT/rt186KTNtzX
        6fsjmmZbxTLXsaHhmVxd5tGsjf97v3/Py3DZcjD6nv+Nn63zNtj9ipYJKlYxX5mZYS+87vOZ
        +99WTjzNcWJjUflTZQdHHb3JM56WRvu9/9Mr+O3hcunUtxfbdm39KS9mcS7lme/dhpVeeeJK
        C2rfsW1Yl7/74bw9fnoRljzvjK7ZfVnYqMRSnJFoqMVcVJwIAMlsbeyIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCaqGu6b1Kiwfe/Zhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyJn94zF6wUaxi2s12tgbGV4JdjJwcEgImEjMv
        97F3MXJxCAmsZpQ4MO82C4TzkVFi3qaFUM5BRomfNzawdjFycLAJaEq83V8A0i0iECbx89F2
        VhCbWUBd4tjGDWwgtrCAk8T7My9ZIWrcJW40zWeDsPUkJr57zwJiswioStw8NY0RxOYVsJG4
        uesgWFwIyN60tZ8JxOYUsJVYOu8kO4jNKCAm8f3UGiaIXeISt57MZ4L4QEBiyZ7zzBC2qMTL
        x/9YIWxFifvfX7JD1OtJ3Jg6hQ3C1pZYtvA1M8ReQYmTM5+wQNRLShxccYNlAqP4LCQrZiFp
        n4WkfRaS9gWMLKsYxUuLi3PTK4oN81LL9YoTc4tL89L1kvNzNzECI+v0v8OROxiP3vqod4iR
        iYPxEKMEB7OSCC9L9KREId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxCrhPjhQTSE0tSs1NTC1KL
        YLJMHJxSDUw3pTbxtzY63HuTK3DC84mqq6Z2366b7ZsFvtxnm3hkz9Z+o6979toeOV/QnFPm
        GFspohW5a6KOp/gBGz+W0pnPJ0SEr3saKLe+/BfXmjXiCa+vck78ZXV11xHD/t2x09UXXX6x
        /fsnyz4LH5Wru3q0a5X+llXfrN6Y9sfQ5qzusR1lGrKa6btNt6jrJa/P9fmt/+yR1+XOxqKv
        pnKsJSuur2cO2Chccarz5X2vaXUuwYYKNTWhSYXzp+h5bqu97adnVpO8IyLse3fQOZknHF7l
        oaZXNM6yzDp4VX1qSnMe4/srZ8MUDojGtwdWm888E7pPnXuu86rCDaomNjK7nu3Xs+TReVHk
        mrX/RvC2TCWW4oxEQy3mouJEAOQIaxwbAwAA
X-CMS-MailID: 20211115200821uscas1p28671af8f28d8326c7dd2dc2ff1204d4b
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200821uscas1p28671af8f28d8326c7dd2dc2ff1204d4b
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211115200821uscas1p28671af8f28d8326c7dd2dc2ff1204d4b@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add the "write_stream" option to sg_write_mode to send WRITE STREAM(16)
commands. Use the new stream_id option to set the stream identifier.

Example:

sg_stream_ctl -o /dev/sdb
Assigned stream id: 1
./fio --name=3Dtest --filename=3D/dev/sdb --ioengine=3Dsg --sg_write_mode=
=3Dwrite_stream --stream_id=3D1 --rw=3Drandwrite --time_based --runtime=3D1=
0s
...
sg_stream_ctl -c --id=3D1 /dev/sdb

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/sg.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index d15b438f..b51edb07 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -69,6 +69,7 @@ enum {
 	FIO_SG_WRITE_VERIFY,
 	FIO_SG_WRITE_SAME,
 	FIO_SG_WRITE_SAME_NDOB,
+	FIO_SG_WRITE_STREAM,
 	FIO_SG_VERIFY_BYTCHK_00,
 	FIO_SG_VERIFY_BYTCHK_01,
 	FIO_SG_VERIFY_BYTCHK_11,
@@ -80,6 +81,7 @@ struct sg_options {
 	unsigned int readfua;
 	unsigned int writefua;
 	unsigned int write_mode;
+	uint16_t stream_id;
 };
=20
 static struct fio_option options[] =3D {
@@ -158,10 +160,24 @@ static struct fio_option options[] =3D {
 			    .oval =3D FIO_SG_VERIFY_BYTCHK_11,
 			    .help =3D "Issue SCSI VERIFY commands with BYTCHK set to 11",
 			  },
+			  { .ival =3D "write_stream",
+			    .oval =3D FIO_SG_WRITE_STREAM,
+			    .help =3D "Issue SCSI WRITE STREAM(16) commands",
+			  },
 		},
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_SG,
 	},
+	{
+		.name	=3D "stream_id",
+		.lname	=3D "stream id for WRITE STREAM(16) commands",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct sg_options, stream_id),
+		.help	=3D "Stream ID for WRITE STREAM(16) commands",
+		.def	=3D "0",
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_SG,
+	},
 	{
 		.name	=3D NULL,
 	},
@@ -611,6 +627,14 @@ static int fio_sgio_prep(struct thread_data *td, struc=
t io_u *io_u)
 			hdr->cmdp[1] |=3D 0x1; // no data output buffer
 			hdr->dxfer_len =3D 0;
 			break;
+		case FIO_SG_WRITE_STREAM:
+			hdr->cmdp[0] =3D 0x9a; // write stream (16)
+			if (o->writefua)
+				hdr->cmdp[1] |=3D 0x08;
+			sgio_set_be64(lba, &hdr->cmdp[2]);
+			sgio_set_be16(o->stream_id, &hdr->cmdp[10]);
+			sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[12]);
+			break;
 		case FIO_SG_VERIFY_BYTCHK_00:
 			if (lba < MAX_10B_LBA)
 				hdr->cmdp[0] =3D 0x2f; // VERIFY(10)
@@ -635,8 +659,9 @@ static int fio_sgio_prep(struct thread_data *td, struct=
 io_u *io_u)
 			break;
 		};
=20
-		fio_sgio_rw_lba(hdr, lba, nr_blocks,
-			o->write_mode =3D=3D FIO_SG_WRITE_SAME_NDOB);
+		if (o->write_mode !=3D FIO_SG_WRITE_STREAM)
+			fio_sgio_rw_lba(hdr, lba, nr_blocks,
+				o->write_mode =3D=3D FIO_SG_WRITE_SAME_NDOB);
=20
 	} else if (io_u->ddir =3D=3D DDIR_TRIM) {
 		struct sgio_trim *st;
--=20
2.25.1
