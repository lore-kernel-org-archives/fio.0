Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C037C433F5
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 20:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJCUfA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiJCUe4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 16:34:56 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5570E0AC
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 13:34:49 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20221003203445usoutp01a52844bf775991efc340ea3cf32aa235~aqWojsMMf2503725037usoutp01_;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20221003203445usoutp01a52844bf775991efc340ea3cf32aa235~aqWojsMMf2503725037usoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664829285;
        bh=VAx9U+ZU9cSJDS3AHYV+i+UH2lA9qLiNz7Sx5gpSuec=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=QiDi7nhi34thjDHOGYz6KGs8gjkm4lvMO9MoGVbdCGiaPctrO7a+YFQdT3J/gshTQ
         lusu3hEA6igHcFmf68WeYMtRzaItzK4NJMV+thx1qWsAewZK29OIvbOrmbDeufr0yl
         gGxVJVKoJ/6N91T77vThKC48XsrwlSwnrPcoAGoc=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203445uscas1p2e110fd7c89d51757cc491a4b31789237~aqWoJ8Kk71598215982uscas1p24;
        Mon,  3 Oct 2022 20:34:45 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 33.B6.35398.5674B336; Mon, 
        3 Oct 2022 16:34:45 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0~aqWn1pAQA1323713237uscas1p12;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
X-AuditID: cbfec370-82fff70000028a46-56-633b47653e52
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id D3.A5.19363.4674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 3 Oct 2022 13:34:43 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        3 Oct 2022 13:34:43 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 3/4] randtrimwrite: fix offsets for corner case
Thread-Topic: [PATCH 3/4] randtrimwrite: fix offsets for corner case
Thread-Index: AQHY12eRGuq8HrrqBkC595mOagTE5w==
Date:   Mon, 3 Oct 2022 20:34:43 +0000
Message-ID: <20221003203427.123969-4-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87qp7tbJBie3s1usvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKeDJzG0vBYsGKY98PsDYwXuftYuTkkBAwkZiz
        /iR7FyMXh5DASkaJaT0LWSCcViaJTR8vscBUHWhZwQZiCwmsZZQ4dKoeougjo8SBp3+ZIJyl
        jBJrNu0B6uDgYBPQlHi7vwCkQUQgTOLno+2sIDazgLrEsY0b2EBKhAXsJb5Or4EocZGYf/Yr
        WKeIgJ5E+5ZYkDCLgIrE5KOfwDp5BWwkHs5pZQexOQVsJbY1zQI7jVFATOL7qTVMENPFJW49
        mc8EcbKgxKLZe5ghbDGJf7seskHYihL3v79kh6jXk7gxdQobhK0tsWzha2aIXYISJ2c+gXpd
        UuLgihvgMJEQmMgh8XPOCUaIhIvE1F/LoRZIS1y9PpUZoqidUWLuxi9Q3RMYJa4/kYKwrSX+
        dV6D2swn8ffXI8YJjMqzkBw+C8lRs5AcNQvJUQsYWVYxipcWF+empxYb56WW6xUn5haX5qXr
        JefnbmIEpozT/w4X7GC8deuj3iFGJg7GQ4wSHMxKIrxzHlklC/GmJFZWpRblxxeV5qQWH2KU
        5mBREueNmqGVLCSQnliSmp2aWpBaBJNl4uCUamAy2iiSKPnute6b/iNLzyzX1GXW6gt+1bc/
        54Jp7SO9jocMVkyLnacovpY3/3NZbFXCzzhv3+Zdtjxv5UMkNmcsSvDkm5rbfWZm1X8dA60r
        kzI8BQJPtl07er5FnfXpHJl1EnOVz+e8FPOwteV7xRpsvP1xE8PSJ74/rih4bewXfH1H0XLP
        gvrHd5/XTLNffdEj6cmVMxpsUvlJS0RKi8uyij8sMBb/3u6TkOvBd6fjxynxORb9UyICbkVd
        4JDOfGi16e0r7sTl3OwmIeuCHFUur32d/euIu2LZ1+CqMn/hLwucWNsPFH0Wz/FyK6qvW2+9
        6MGZFV8TgpR3heVZqpTe/23wYHa7ftBdNS++mUosxRmJhlrMRcWJABPNSKGIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCapJvibp1ssPOAlsXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6MJzO3sRQsFqw49v0AawPjdd4uRk4OCQETiQMt
        K9i6GLk4hARWM0rM7HzCCuF8ZJQ49eASVGYpo8Te1X/Yuxg5ONgENCXe7i8A6RYRCJP4+Wg7
        K4jNLKAucWzjBjaQEmEBe4mv02sgSlwk5p/9ygISFhHQk2jfEgsSZhFQkZh89BNYJ6+AjcTD
        Oa3sILYQkP30wRmwOKeArcS2plksIDajgJjE91NrmCA2iUvcejKfCeJ+AYkle84zQ9iiEi8f
        /2OFsBUl7n9/yQ5RrydxY+oUNghbW2LZwtfMEHsFJU7OfMICUS8pcXDFDZYJjOKzkKyYhaR9
        FpL2WUjaFzCyrGIULy0uzk2vKDbMSy3XK07MLS7NS9dLzs/dxAiMqtP/DkfuYDx666PeIUYm
        DsZDjBIczEoivHMeWSUL8aYkVlalFuXHF5XmpBYfYpTmYFES5xVynRgvJJCeWJKanZpakFoE
        k2Xi4JRqYFp78emKT/sX1L7K6zUyN17aJcsv8VBtjg3jXPmTuc4/LLdy21sGTLZpVLZxWiRu
        YfddslM/d8nebR+URX2a3waVrpR4Mu3RDcXFKt5LHrwIrDBcxdm8akvZdcbEuXMZ3pxaf2+f
        dWeI1ZGt/5q5/gXPSSqf1L36ofiDn5zZpk8XblgUlbSof2b+rh/dn5+2nlpxO/T7xzeCn479
        dyj9apr1ZuY1gVn8zfPEX6j3PmDU3nJr6a51E+/I/Qr4lnxl7rQrjnXTONk4n97ZkXHyz82l
        S+Q9nIUP7pE8FrTokfiHPdff6rtvqSnsP2Uyr+PX6Vcv17+ZcHg1386XKzUK5jy31dn3U7xm
        57mfovNK91lsmqrEUpyRaKjFXFScCABvektwGQMAAA==
X-CMS-MailID: 20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0
CMS-TYPE: 301P
X-CMS-RootMailID: 20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0
References: <20221003203427.123969-1-vincent.fu@samsung.com>
        <CGME20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

For randtrimwrite, we decide whether to issue a trim or a write based on
whether the end offsets for the most recent trim and write commands
match.  If they don't match that means we just issued a new trim and the
next operation should be a write. If they *do* match that means we just
completed a trim + write pair and the next command should be a trim.

This works fine for sequential workloads but for random workloads it's
possible to complete a trim + write pair and then have the randomly
generated offset for the next trim command match the previous offset. If
that happens we need to alter the offset for the last write operation in
order to ensure that we issue a write operation the next time through.

It feels dirty to change the meaning of last_pos[DDIR_WRITE] in this way
but hopefully the long comment in the code will be sufficient warning.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 io_u.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/io_u.c b/io_u.c
index 3f6c60ee..0a70f72a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -513,6 +513,24 @@ static int get_next_offset(struct thread_data *td, str=
uct io_u *io_u,
 		return 1;
 	}
=20
+	/*
+	 * For randtrimwrite, we decide whether to issue a trim or a write
+	 * based on whether the offsets for the most recent trim and write
+	 * operations match. If they don't match that means we just issued a
+	 * new trim and the next operation should be a write. If they *do*
+	 * match that means we just completed a trim+write pair and the next
+	 * command should be a trim.
+	 *
+	 * This works fine for sequential workloads but for random workloads
+	 * it's possible to complete a trim+write pair and then have the next
+	 * randomly generated offset match the previous offset. If that happens
+	 * we need to alter the offset for the last write operation in order
+	 * to ensure that we issue a write operation the next time through.
+	 */
+	if ((td_randtrimwrite(td) && ddir =3D=3D DDIR_TRIM) &&
+	     fio_unlikely(f->last_start[DDIR_TRIM] =3D=3D io_u->offset))
+		f->last_pos[DDIR_WRITE]--;
+
 	io_u->verify_offset =3D io_u->offset;
 	return 0;
 }
--=20
2.25.1
