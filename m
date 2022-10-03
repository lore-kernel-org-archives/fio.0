Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E21C433FE
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 20:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJCUe4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiJCUey (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 16:34:54 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E539BDF5F
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 13:34:49 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20221003203445usoutp026e17050d6028ab16fc99a770baaf3c4c~aqWou7Dkc0927009270usoutp02P;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20221003203445usoutp026e17050d6028ab16fc99a770baaf3c4c~aqWou7Dkc0927009270usoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664829285;
        bh=H3hTok6D/8+QWOo7NwPN814XOMbH7PJfiLF0XpplmZQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=CsVt5A5Fpc3jr21aLDjI3cGD2evC6jT+1MQ/eTli2YO8ZYiX14AFgclC4Z2JQcpKy
         XYGnZbnVrf4iMghlwjmba/1gK/Qa1q1mhgp/BT/wnJMGapxpmWuDMACCOkjVZKlJOJ
         /hLM0w+ov3DIggNFC5RzkphMfjBaAT3SkS3g2dDs=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203445uscas1p2a2a70bfafee8fc8b27b0fe45b4e601de~aqWokbamz2024120241uscas1p2n;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id B3.B6.35398.5674B336; Mon, 
        3 Oct 2022 16:34:45 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203445uscas1p2499ed21c0ed1b564f268ff51e6184229~aqWoIT8qz0313203132uscas1p2-;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
X-AuditID: cbfec370-817ff70000028a46-59-633b476563fd
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 04.A5.19363.4674B336; Mon, 
        3 Oct 2022 16:34:45 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 3 Oct 2022 13:34:44 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        3 Oct 2022 13:34:44 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 4/4] randtrimwrite: fix corner case with variable block
 sizes
Thread-Topic: [PATCH 4/4] randtrimwrite: fix corner case with variable block
        sizes
Thread-Index: AQHY12eRxzRVy1YPlEKhTteS8UMwMg==
Date:   Mon, 3 Oct 2022 20:34:43 +0000
Message-ID: <20221003203427.123969-5-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djX87qp7tbJBrsWKVmsvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKeNYwk7XgOVfF/iXPGBsYH3N0MXJySAiYSMw6
        f4YJxBYSWMkosb2jvIuRC8huZZKYt/gJI0zRmjnfWSASaxklJp2ZyQrhfGSUmNf7gQnCWcoo
        ceLjd/YuRg4ONgFNibf7C0C6RQTCJH4+2s4KYjMLqEsc27iBDcQWFvCX2LDqMCNETYjEv+5p
        TBC2nsT6TfPA4iwCKhKTj34C6+UVsJHYcW02C4jNKWArsa1pFpjNKCAm8f3UGiaI+eISt57M
        Z4K4WlBi0ew9zBC2mMS/XQ/ZIGxFifvfX7JD1OtJ3Jg6hQ3C1pZYtvA1M8QuQYmTM5+wQNRL
        ShxccQPK7uSQePXVC8J2kWh7/I0VwpaWuHp9KjMoHCQE2hkl5m78AtUwgVHi+hMpCNta4l/n
        NajFfBJ/fz1inMCoPAvJ3bOQ3DQLyU2zkNy0gJFlFaN4aXFxbnpqsXFearlecWJucWleul5y
        fu4mRmDSOP3vcMEOxlu3PuodYmTiYDzEKMHBrCTCO+eRVbIQb0piZVVqUX58UWlOavEhRmkO
        FiVx3qgZWslCAumJJanZqakFqUUwWSYOTqkGJndzns+zN4ksna0edfZcyOEFGfMdtNXMTKeI
        qs6f/Fn7/+rNp7e/C4nZlakWIsuasozH5dDC+/4dM88e/sTRdjpC9vVj9TKJma1bPzW+PPN8
        7iKO5U5FVyY0L4rq/+LBeO5XVe9bZ/tvP+z/m7an9fjdtpY/apfYMEPjULuFTGPN0yrJaZXv
        HFK/91nx6nw9snBJ7VKviKbav36amz8JnHk2jT+mYuqyXZdW5j/f+rs2UdY5M/hmB6f+wgAb
        QZPfjgtzHxrWBxWefXw2U2uCxNuUqwv2pvhdcTy6ffphTs0tFvOe/5PKXh5fMf9XD3dZ5Bx7
        kX23jmtOaruwhWPxB06WWHbBqrP/qtvur+WMFVRiKc5INNRiLipOBABSC9GLiQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCapJvqbp1s0PmT0WL13X42i4+zXjA7
        MHlcPlvq8XmTXABTFJdNSmpOZllqkb5dAlfGs4aZrAXPuSr2L3nG2MD4mKOLkZNDQsBEYs2c
        7yxdjFwcQgKrGSXunv7KDuF8ZJTYd3wHM4SzlFHi6unNjF2MHBxsApoSb/cXgHSLCIRJ/Hy0
        nRXEZhZQlzi2cQMbiC0s4Cuxc8djRoiaEImuzlY2CFtPYv2meWBxFgEViclHP4H18grYSOy4
        NpsFxBYCsp8+OAMW5xSwldjWNAssziggJvH91BomiF3iEreezGeC+EBAYsme88wQtqjEy8f/
        WCFsRYn731+yQ9TrSdyYOoUNwtaWWLbwNTPEXkGJkzOfsEDUS0ocXHGDZQKj+CwkK2YhaZ+F
        pH0WkvYFjCyrGMVLi4tz0yuKDfNSy/WKE3OLS/PS9ZLzczcxAiPr9L/DkTsYj976qHeIkYmD
        8RCjBAezkgjvnEdWyUK8KYmVValF+fFFpTmpxYcYpTlYlMR5hVwnxgsJpCeWpGanphakFsFk
        mTg4pRqYEkQ03rtknfoesqSsec8CmTLO10Y7HPy//tr7JUb0jkvd5J3TQwr+LCqd0PNzO0fi
        kex/akfkXx3dXMF92KvncW7Cvqmvb4mltfvoP2qfJDCt6GvC1pL9q1bM3LmYj8HGdxHnTvGW
        NzN3vZ6z7mJKzvSL+VL/KhsTnpau5qzccz6d90/90YmMy/UTnxtO+dL0f/7BLLk+l2muW2ZM
        uH/hRfLjLwst3sXnNKeVXzlQ6Th74dOeDEePH5ky7/8ZswgIL48oZenSz7x0YcMnZUn57yd+
        dx7/O2fj4tCCdr8pkpevs/ft6qu/6sHNzTIlOUDWzTZfquC7wXbvB5+YS2dFvZ+rw+rya6tk
        40RdT+FdR5RYijMSDbWYi4oTAavH1WAbAwAA
X-CMS-MailID: 20221003203445uscas1p2499ed21c0ed1b564f268ff51e6184229
CMS-TYPE: 301P
X-CMS-RootMailID: 20221003203445uscas1p2499ed21c0ed1b564f268ff51e6184229
References: <20221003203427.123969-1-vincent.fu@samsung.com>
        <CGME20221003203445uscas1p2499ed21c0ed1b564f268ff51e6184229@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When we have variable block sizes it's possible to finish a trim + write
pair and then have the next (smaller length) trim operation have a
different start offset but the same end offset as the previous pair of
trim and write operations. This would fool fio into believing that it
had already completed a trim + write pair when it actually completed
only the trim.

Resolve this problem by comparing start offsets instead of end offsets.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 io_u.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_u.c b/io_u.c
index 0a70f72a..a9f0ad0f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -529,7 +529,7 @@ static int get_next_offset(struct thread_data *td, stru=
ct io_u *io_u,
 	 */
 	if ((td_randtrimwrite(td) && ddir =3D=3D DDIR_TRIM) &&
 	     fio_unlikely(f->last_start[DDIR_TRIM] =3D=3D io_u->offset))
-		f->last_pos[DDIR_WRITE]--;
+		f->last_start[DDIR_WRITE]--;
=20
 	io_u->verify_offset =3D io_u->offset;
 	return 0;
@@ -798,7 +798,7 @@ static void set_rw_ddir(struct thread_data *td, struct =
io_u *io_u)
=20
 	if (td_trimwrite(td)) {
 		struct fio_file *f =3D io_u->file;
-		if (f->last_pos[DDIR_WRITE] =3D=3D f->last_pos[DDIR_TRIM])
+		if (f->last_start[DDIR_WRITE] =3D=3D f->last_start[DDIR_TRIM])
 			ddir =3D DDIR_TRIM;
 		else
 			ddir =3D DDIR_WRITE;
--=20
2.25.1
