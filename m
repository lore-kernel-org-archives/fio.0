Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF97C4321E
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1802561B4D
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345070AbhKOVRT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:17:19 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37224 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346515AbhKOUSO (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:18:14 -0500
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200822usoutp0119b2145e7de0a0a1d5f67e0350734f12~30RrVwBc52191621916usoutp01b;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20211115200822usoutp0119b2145e7de0a0a1d5f67e0350734f12~30RrVwBc52191621916usoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006902;
        bh=YBnfryWtueAG91LIYGZGShsPP8Ybgt3+ZSc8SwCZOXo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=klrBylGbpTNxuzVAyPzXDykoZ0xl1KHOkgDDD/TCEYxTDwO+2G871yIt5yD0DqvEQ
         uYNwT8lgY1LDkYTE5ibTZMd3m/OEMtidGd9uDmMNIHNUbraSsVaro88pPbshs+Q390
         AwthhyfQCKTqv6QTViGm5uHiOuzMT+yAjmPrlx+k=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200822uscas1p25db8675ec4fa006470ea2eb44ee8ac93~30RrORP2I1716117161uscas1p2b;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 9D.23.32368.63EB2916; Mon,
        15 Nov 2021 15:08:22 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200822uscas1p16f41fc3283e4f36e668ff9ea189f16c5~30Rq3gWs-1400814008uscas1p1E;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
X-AuditID: cbfec36d-c03ff70000017e70-8d-6192be36f6ea
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id A1.22.47905.53EB2916; Mon,
        15 Nov 2021 15:08:22 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Mon, 15 Nov 2021 12:07:18 -0800
Received: from SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7]) by
        SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7%13]) with mapi id
        15.01.2242.008; Mon, 15 Nov 2021 12:07:18 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 5/6] sg: allow fio to open and close streams for WRITE
 STREAM(16) commands
Thread-Topic: [PATCH 5/6] sg: allow fio to open and close streams for WRITE
        STREAM(16) commands
Thread-Index: AQHX2lxjCgmt2hM4QEKeN9DYahjsyg==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-6-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWy7djX87pm+yYlGiz5oGCx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY/O5buaCx2YV246fZ2lgXKvTxcjJISFgIjGl
        8yNzFyMXh5DASkaJc3/3MEI4rUwSD79+Y4Wp+nb3HAtEYi2jROO7+VBVHxkltr8+DZU5yCjR
        u2kfkMPBwSagKfF2fwFIt4hAmMTPR9vBJjELqEsc27iBDcQWFoiRmP/5NjNETaLEls657BC2
        nsSa2cvB4iwCqhI3T01jBLF5BWwknq/9AlbDKWArsXTeSTCbUUBM4vupNUwQ88Ulbj2ZzwRx
        taDEotl7mCFsMYl/ux6yQdiKEve/v2SHqNeTuDF1ChuErS2xbOFrZohdghInZz5hgaiXlDi4
        4gbYjxICnRwS377Mgkq4SExuPgM1VFri6vWpUMvOMUo8+BcM0XCdUWLFl8XQcLSWWPhnPdSl
        fBJ/fz1inMCoPAvJ4bOQHDULyVGzkBy1gJFlFaN4aXFxbnpqsWFearlecWJucWleul5yfu4m
        RmDiOP3vcO4Oxh23PuodYmTiYDzEKMHBrCTCyxI9KVGINyWxsiq1KD++qDQntfgQozQHi5I4
        7+k/DYlCAumJJanZqakFqUUwWSYOTqkGJsG3YrHfJr9xXfEq+P7DLayssqd/+TL1JQppL3zU
        83PxpfRi8R1vTljW8Jy4NVX4ndPR3Wnq08zjhLN21ihM4QplOCZr6P9Xb9rab297m80tWT5U
        3shlWqK654nBsaaGg/9Xbp3866pjxvkHNUc/eXZXKiXanJ5yMWKCkbnG+qTLM8VnbDr8+5Hz
        2zsrcl0+fzn3wz1IepqDJktHXXzUs6jDHO+lLh5McxO0Wf1ZrD4icqmDVAH/tv1XdvMfiZ3s
        0Mu6YSe79vOvMU/i0yp7b4Xv3HnP5gXTeS7FRNbL3Sf27jmwrUgv8Ke70Dqt4vXK95msfraL
        v1pwonKvwA3tiUoXly+6ynh8wp2Hm4Pjd71VYinOSDTUYi4qTgQAM0l1XIsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqGu2b1KiwY1VXBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyNp/rZi54bFax7fh5lgbGtTpdjJwcEgImEt/u
        nmMBsYUEVjNKTLxr08XIBWR/ZJQ48e4DO4RzkFHiwtTlzF2MHBxsApoSb/cXgDSICIRJ/Hy0
        nRXEZhZQlzi2cQMbiC0sECMx//NtZoiaRImOf9OZIGw9iTWzl4PFWQRUJW6emsYIYvMK2Eg8
        X/uFHeIIG4lNW/vB6jkFbCWWzjsJFmcUEJP4fmoNE8QucYlbT+YzQTwgILFkz3lmCFtU4uXj
        f6wQtqLE/e8v2SHq9SRuTJ3CBmFrSyxb+JoZYq+gxMmZT1gg6iUlDq64wTKBUXwWkhWzkLTP
        QtI+C0n7AkaWVYzipcXFuekVxYZ5qeV6xYm5xaV56XrJ+bmbGIFxdfrf4cgdjEdvfdQ7xMjE
        wXiIUYKDWUmElyV6UqIQb0piZVVqUX58UWlOavEhRmkOFiVxXiHXifFCAumJJanZqakFqUUw
        WSYOTqkGJicG3WMnpzuxZpd+nCr45VJsj2zhwtfdPcLtxmJJK7PCP5j9n63l82f6qsAP3hPz
        Y9iLfzP8rQ+cVsUwe8O19QudD0m2h2uYbvJazceYvuVb4BVB+wOPF/Xr3ZP62Rypt/ZBa9EL
        Fn6tM30KzF/X+ixJYWNZKyJsdjNFNUY/5bFd0Pz+oztUjizledKrmC7e/iyuwXJyzZ207PwV
        Yr+2Jfo8ETwSu9TwmAT/OYcqh1k3Sj/svqdws9dW6LelQ/PyZ1e65KznHki+4meTpLUw5Frj
        tmd7SzpurG0O/Xhg5QrL7pfrez6IaImf7tQWM4liOF348NdyZkuFnLxLotYcVdJtH64Vqupt
        /+8fazZHiaU4I9FQi7moOBEA+7Ev7hoDAAA=
X-CMS-MailID: 20211115200822uscas1p16f41fc3283e4f36e668ff9ea189f16c5
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200822uscas1p16f41fc3283e4f36e668ff9ea189f16c5
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211115200822uscas1p16f41fc3283e4f36e668ff9ea189f16c5@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

If --stream_id=3D0 then fio will open a stream for WRITE STREAM(16) command=
s and
close the stream when the device file is closed.

Example:
./fio --name=3Dtest --filename=3D/dev/sdb --ioengine=3Dsg --number_ios=3D1 =
--debug=3Dfile,io --sg_write_mode=3Dwrite_stream --rw=3Drandwrite
fio: set debug option file
fio: set debug option io
test: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4=
096B-4096B, ioengine=3Dsg, iodepth=3D1
fio-3.27
Starting 1 process
file     1072297 setup files
file     1072297 get file size for 0x7f0306fa5110/0//dev/sdb
file     1072307 trying file /dev/sdb 290
file     1072307 fd open /dev/sdb
file     1072307 file not found in hash /dev/sdb
file     1072307 sgio_stream_control: opened stream 1
file     1072307 get file /dev/sdb, ref=3D0
io       1072307 drop page cache /dev/sdb
file     1072307 goodf=3D1, badf=3D2, ff=3D2b1
file     1072307 get_next_file_rr: 0x7f0306fa5110
file     1072307 get_next_file: 0x7f0306fa5110 [/dev/sdb]
file     1072307 get file /dev/sdb, ref=3D1
io       1072307 fill: io_u 0xb55700: off=3D0x35ef554000,len=3D0x1000,ddir=
=3D1,file=3D/dev/sdb
io       1072307 prep: io_u 0xb55700: off=3D0x35ef554000,len=3D0x1000,ddir=
=3D1,file=3D/dev/sdb
io       1072307 prep: io_u 0xb55700: ret=3D0
io       1072307 queue: io_u 0xb55700: off=3D0x35ef554000,len=3D0x1000,ddir=
=3D1,file=3D/dev/sdb
io       1072307 complete: io_u 0xb55700: off=3D0x35ef554000,len=3D0x1000,d=
dir=3D1,file=3D/dev/sdb
file     1072307 put file /dev/sdb, ref=3D2
file     1072307 close files
file     1072307 put file /dev/sdb, ref=3D1
file     1072307 sgio_stream_control: closed stream 1
file     1072307 fd close /dev/sdb
io       1072307 close ioengine sg
io       1072307 free ioengine sg

test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1072307: Mon Aug 16 14:25:45=
 2021
  write: IOPS=3D200, BW=3D800KiB/s (819kB/s)(4096B/5msec); 0 zone resets
    clat (nsec): min=3D93339, max=3D93339, avg=3D93339.00, stdev=3D 0.00
     lat (nsec): min=3D96201, max=3D96201, avg=3D96201.00, stdev=3D 0.00
    clat percentiles (nsec):
     |  1.00th=3D[93696],  5.00th=3D[93696], 10.00th=3D[93696], 20.00th=3D[=
93696],
     | 30.00th=3D[93696], 40.00th=3D[93696], 50.00th=3D[93696], 60.00th=3D[=
93696],
     | 70.00th=3D[93696], 80.00th=3D[93696], 90.00th=3D[93696], 95.00th=3D[=
93696],
     | 99.00th=3D[93696], 99.50th=3D[93696], 99.90th=3D[93696], 99.95th=3D[=
93696],
     | 99.99th=3D[93696]
  lat (usec)   : 100=3D100.00%
  cpu          : usr=3D100.00%, sys=3D0.00%, ctx=3D2, majf=3D0, minf=3D20
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D800KiB/s (819kB/s), 800KiB/s-800KiB/s (819kB/s-819kB/s), io=
=3D4096B (4096B), run=3D5-5msec

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/sg.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index b51edb07..72ee07ba 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -217,6 +217,11 @@ struct sgio_data {
 #endif
 };
=20
+static inline uint16_t sgio_get_be16(uint8_t *buf)
+{
+	return be16_to_cpu(*((uint16_t *) buf));
+}
+
 static inline uint32_t sgio_get_be32(uint8_t *buf)
 {
 	return be32_to_cpu(*((uint32_t *) buf));
@@ -632,7 +637,7 @@ static int fio_sgio_prep(struct thread_data *td, struct=
 io_u *io_u)
 			if (o->writefua)
 				hdr->cmdp[1] |=3D 0x08;
 			sgio_set_be64(lba, &hdr->cmdp[2]);
-			sgio_set_be16(o->stream_id, &hdr->cmdp[10]);
+			sgio_set_be16((uint16_t) io_u->file->engine_pos, &hdr->cmdp[10]);
 			sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[12]);
 			break;
 		case FIO_SG_VERIFY_BYTCHK_00:
@@ -1053,9 +1058,60 @@ static int fio_sgio_type_check(struct thread_data *t=
d, struct fio_file *f)
 	return 0;
 }
=20
+static int fio_sgio_stream_control(struct fio_file *f, bool open_stream, u=
int16_t *stream_id)
+{
+	struct sg_io_hdr hdr;
+	unsigned char cmd[16];
+	unsigned char sb[64];
+	unsigned char buf[8];
+	int ret;
+
+	memset(&hdr, 0, sizeof(hdr));
+	memset(cmd, 0, sizeof(cmd));
+	memset(sb, 0, sizeof(sb));
+	memset(buf, 0, sizeof(buf));
+
+	hdr.interface_id =3D 'S';
+	hdr.cmdp =3D cmd;
+	hdr.cmd_len =3D 16;
+	hdr.sbp =3D sb;
+	hdr.mx_sb_len =3D sizeof(sb);
+	hdr.timeout =3D SCSI_TIMEOUT_MS;
+	hdr.cmdp[0] =3D 0x9e;
+	hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
+	hdr.dxferp =3D buf;
+	hdr.dxfer_len =3D sizeof(buf);
+	sgio_set_be32(sizeof(buf), &hdr.cmdp[10]);
+
+	if (open_stream)
+		hdr.cmdp[1] =3D 0x34;
+	else {
+		hdr.cmdp[1] =3D 0x54;
+		sgio_set_be16(*stream_id, &hdr.cmdp[4]);
+	}
+
+	ret =3D ioctl(f->fd, SG_IO, &hdr);
+
+	if (ret < 0)
+		return ret;
+
+	if (hdr.info & SG_INFO_CHECK)
+		return 1;
+
+	if (open_stream) {
+		*stream_id =3D sgio_get_be16(&buf[4]);
+		dprint(FD_FILE, "sgio_stream_control: opened stream %u\n", (unsigned int=
) *stream_id);
+		assert(*stream_id !=3D 0);
+	} else
+		dprint(FD_FILE, "sgio_stream_control: closed stream %u\n", (unsigned int=
) *stream_id);
+
+	return 0;
+}
+
 static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 {
 	struct sgio_data *sd =3D td->io_ops_data;
+	struct sg_options *o =3D td->eo;
 	int ret;
=20
 	ret =3D generic_open_file(td, f);
@@ -1067,9 +1123,33 @@ static int fio_sgio_open(struct thread_data *td, str=
uct fio_file *f)
 		return ret;
 	}
=20
+	if (o->write_mode =3D=3D FIO_SG_WRITE_STREAM) {
+		if (o->stream_id)
+			f->engine_pos =3D o->stream_id;
+		else {
+			ret =3D fio_sgio_stream_control(f, true, (uint16_t *) &f->engine_pos);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return 0;
 }
=20
+int fio_sgio_close(struct thread_data *td, struct fio_file *f)
+{
+	struct sg_options *o =3D td->eo;
+	int ret;
+
+	if (!o->stream_id && o->write_mode =3D=3D FIO_SG_WRITE_STREAM) {
+		ret =3D fio_sgio_stream_control(f, false, (uint16_t *) &f->engine_pos);
+		if (ret)
+			return ret;
+	}
+
+	return generic_close_file(td, f);
+}
+
 /*
  * Build an error string with details about the driver, host or scsi
  * error contained in the sg header Caller will use as necessary.
@@ -1344,7 +1424,7 @@ static struct ioengine_ops ioengine =3D {
 	.event		=3D fio_sgio_event,
 	.cleanup	=3D fio_sgio_cleanup,
 	.open_file	=3D fio_sgio_open,
-	.close_file	=3D generic_close_file,
+	.close_file	=3D fio_sgio_close,
 	.get_file_size	=3D fio_sgio_get_file_size,
 	.flags		=3D FIO_SYNCIO | FIO_RAWIO,
 	.options	=3D options,
--=20
2.25.1
