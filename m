Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218CBC433FE
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 20:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJCUe6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJCUey (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 16:34:54 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44782DE1
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 13:34:49 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20221003203445usoutp02296344875ad2ce590c25a2fb2a89d088~aqWoidE8R0888408884usoutp02e;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20221003203445usoutp02296344875ad2ce590c25a2fb2a89d088~aqWoidE8R0888408884usoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664829285;
        bh=Qn1bLbq6Ih0Gh70OlIHwOcQ3tr2cW2HNmoGDPUNrkSM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=RdgzciHIfV539XDd0cIXfl19v+zqvpuwiiigDkIsqnyADT3iCHbNS2tymKoPZPrCs
         oTfBlQcNXSFaiptI8oc5rvDLAs5prdN/vUHirVv4HHW0emE2VLe6DDcv7Lj4pod/RB
         isjvfSVsLcj5mCe6pgm842d+xkC5Juc0uBJFS1/k=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203445uscas1p2b0e65e03849191fa64d7c27e47e383db~aqWoF2Gkp1598215982uscas1p22;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id C2.B6.35398.4674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221003203444uscas1p13c033cfe15efd4bcbce4c2bf2ce33f63~aqWneFFpf1319213192uscas1p1o;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
X-AuditID: cbfec370-82fff70000028a46-52-633b476442f4
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id B0.D4.32876.4674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 3 Oct 2022 13:34:43 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        3 Oct 2022 13:34:43 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/4] randtrimwrite: write at same offset as trim
Thread-Topic: [PATCH 1/4] randtrimwrite: write at same offset as trim
Thread-Index: AQHY12eRvhawbuqLjUuvExLaH9Si4A==
Date:   Mon, 3 Oct 2022 20:34:43 +0000
Message-ID: <20221003203427.123969-2-vincent.fu@samsung.com>
In-Reply-To: <20221003203427.123969-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWy7djXc7op7tbJBlv3qVusvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKaP83la1glVDFrQcb2RsYH/J1MXJySAiYSDRO
        2MfWxcjFISSwklFi1/FZUE4rk8S9x/8ZYaqOrZ/PDpFYyyjRsP0AM4TzkVHi/udVTBDOUkaJ
        NZv2sHQxcnCwCWhKvN1fANItIhAm8fPRdlYQm1lAXeLYxg1sILawgIPE+p6jbBA1rhLd3zrY
        IWw9id9HpzCB2CwCKhKTj34C6+UVsJHY9bMX7CJOAVuJbU2zWEBsRgExie+n1jBBzBeXuPVk
        PhPE1YISi2bvYYawxST+7XrIBmErStz//pIdol5P4sbUKWwQtrbEsoWvmSF2CUqcnPmEBaJe
        UuLgihssID9KCLRySHzeNgcq4SIx+eRZqAXSEtPXXIYqameUmLvxC1TRBEaJ60+kIGxriX+d
        16A280n8/fWIcQKj8iwkh89CctQsJEfNQnLUAkaWVYzipcXFuempxcZ5qeV6xYm5xaV56XrJ
        +bmbGIGJ4/S/wwU7GG/d+qh3iJGJg/EQowQHs5II75xHVslCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEeaNmaCULCaQnlqRmp6YWpBbBZJk4OKUamNImHst+6O5p1NGaGXDAgcv9hdPSAM6Mgz22
        X5kbnnCGTf8RHVJrVTmXy+Cs+5+Lf5/GBQt5fH87P6lWVGzq26khb/hPV4ifN6xMfe/0esm6
        TXzL30qmHM1+tXe3/JTfqxJWqE2/Nk/oYrnoe33DILEp3yMXbRCTrnsu+zHS0ZEn7nDlhJNX
        xcJspkebRjP+Xnmmzcw5fE9Z4yUzNselV5vNzuyZn8ixa8rBUHG9Ipve9ZtzXq6dyiHgsL/e
        6l7eWeMSpiMFppwPH5VarFqy7d7NWqU5V2fFznj6uOS3YmTUjZgXJoemtArn2Px61hPS/1hk
        laAL8zdv+/JryRKH/TdwTS5RvJF9oiSPX7lTR4mlOCPRUIu5qDgRAOtOfbaLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCapJvibp1s8OmEkMXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6M9n9T2QpWCVXcerCRvYHxIV8XIyeHhICJxLH1
        89m7GLk4hARWM0o8/v8GyvnIKLF36kUWCGcpkLP6D1CGg4NNQFPi7f4CkG4RgTCJn4+2s4LY
        zALqEsc2bmADsYUFHCTW9xxlg6hxlej+1sEOYetJ/D46hQnEZhFQkZh89BNYL6+AjcSun72M
        ILYQkP30wRmwOKeArcS2plksIDajgJjE91NrmCB2iUvcejKfCeIDAYkle84zQ9iiEi8f/2OF
        sBUl7n9/yQ5RrydxY+oUNghbW2LZwtfMEHsFJU7OfMICUS8pcXDFDZYJjOKzkKyYhaR9FpL2
        WUjaFzCyrGIULy0uzk2vKDbOSy3XK07MLS7NS9dLzs/dxAiMrNP/DsfsYLx366PeIUYmDsZD
        jBIczEoivHMeWSUL8aYkVlalFuXHF5XmpBYfYpTmYFES5/WInRgvJJCeWJKanZpakFoEk2Xi
        4JRqYAq7WbrnTLZPyRylb00Lp1zVfGSezbOyKX77ChHuPWHzAucdFJqpV+mzyfFsct/ew3u3
        llj0dbxtr9H+FXVw/dNbHSrVrgW7Bbi3sx8qzlA2jbSQihSP0/f+6Xfwp2LV5KUb5m8UirGM
        E5W7J8v6+82xgmSjszIKQReeafg2SNxXdUhZ9PijqZlQ9JarLlseilYKZXZk8Xe8XfL/nMyK
        JO1G3yyOI1a39/HL/1nmVTWxeLFH15bgxc/TLA5pHPa+bavKoBu41q754ukv83g9lzzQ/ukz
        idvnsqLhx3+n7ubEHb21lfH3ywSxvBVM5uI+dtONb3+4qZUUe+R39Kkr9sXy/k+0yn985zyj
        7S8kqMRSnJFoqMVcVJwIAFRtIm8bAwAA
X-CMS-MailID: 20221003203444uscas1p13c033cfe15efd4bcbce4c2bf2ce33f63
CMS-TYPE: 301P
X-CMS-RootMailID: 20221003203444uscas1p13c033cfe15efd4bcbce4c2bf2ce33f63
References: <20221003203427.123969-1-vincent.fu@samsung.com>
        <CGME20221003203444uscas1p13c033cfe15efd4bcbce4c2bf2ce33f63@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

We need to do a little bit more to make sure that the writes land on the
offsets that were trimmed.

We only have a single random seed for offsets. So we need to just use
the offset from trim commands when issuing writes.

When we have variable block sizes we need to make sure that the trim and
write commands are the same size.

When randommap is enabled we have to let it adjust the block size for
trim commands to make sure that the trim command does not touch any
blocks that have already been touched.

For sizes of write commands just use the size of the trim command.

Fixes: c16dc793a3c45780f67ce65244b6e91323dee014 "Add randtrimwrite data
direction"

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 io_ddir.h |  2 ++
 io_u.c    | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/io_ddir.h b/io_ddir.h
index 7227e9ee..217eb628 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -52,6 +52,8 @@ enum td_ddir {
 #define file_randommap(td, f)	(!(td)->o.norandommap && fio_file_axmap((f))=
)
 #define td_trimwrite(td)	(((td)->o.td_ddir & TD_DDIR_TRIMWRITE) \
 					=3D=3D TD_DDIR_TRIMWRITE)
+#define td_randtrimwrite(td)	(((td)->o.td_ddir & TD_DDIR_RANDTRIMWRITE) \
+					=3D=3D TD_DDIR_RANDTRIMWRITE)
=20
 static inline int ddir_sync(enum fio_ddir ddir)
 {
diff --git a/io_u.c b/io_u.c
index eec378dd..3f6c60ee 100644
--- a/io_u.c
+++ b/io_u.c
@@ -417,7 +417,13 @@ static int get_next_block(struct thread_data *td, stru=
ct io_u *io_u,
=20
 	b =3D offset =3D -1ULL;
=20
-	if (rw_seq) {
+	if (td_randtrimwrite(td) && ddir =3D=3D DDIR_WRITE) {
+		/* don't mark randommap for these writes */
+		io_u_set(td, io_u, IO_U_F_BUSY_OK);
+		offset =3D f->last_start[DDIR_TRIM];
+		*is_random =3D true;
+		ret =3D 0;
+	} else if (rw_seq) {
 		if (td_random(td)) {
 			if (should_do_random(td, ddir)) {
 				ret =3D get_next_rand_block(td, f, ddir, &b);
@@ -530,6 +536,12 @@ static unsigned long long get_next_buflen(struct threa=
d_data *td, struct io_u *i
=20
 	assert(ddir_rw(ddir));
=20
+	if (td_randtrimwrite(td) && ddir =3D=3D DDIR_WRITE) {
+		struct fio_file *f =3D io_u->file;
+
+		return f->last_pos[DDIR_TRIM] - f->last_start[DDIR_TRIM];
+	}
+
 	if (td->o.bs_is_seq_rand)
 		ddir =3D is_random ? DDIR_WRITE : DDIR_READ;
=20
--=20
2.25.1
