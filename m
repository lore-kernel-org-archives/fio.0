Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B46C433EF
	for <fio@archiver.kernel.org>; Tue, 31 May 2022 21:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348096AbiEaVtR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 31 May 2022 17:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiEaVtQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 May 2022 17:49:16 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD21B8D6A0
        for <fio@vger.kernel.org>; Tue, 31 May 2022 14:49:14 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220531214912usoutp01245e8e55344bc11b96cb095f8aab6f8a~0Tu89fbLD3036130361usoutp012;
        Tue, 31 May 2022 21:49:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220531214912usoutp01245e8e55344bc11b96cb095f8aab6f8a~0Tu89fbLD3036130361usoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654033752;
        bh=0cOIr6aWyu3Lhny2n73f4CqU75p0fA+gFAzQwcG2ErM=;
        h=From:To:CC:Subject:Date:References:From;
        b=aABytCsm6g979tvZiPxaUQjmrWwjEcEW9wQAl/FkQ9kpBGPAuilsMjLA7xWLzRtTm
         J9VBQxBa1b7oeiWw9Xk27L6Gn6j/BKASD6WK455zhGyvcp3ee36F902LVr1+m8TZBz
         oAzbdtwRASCWHqCc+6Z366PwTWr39xyhC3QZKEDQ=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220531214912uscas1p2b1730c9acf3877922cf17fa8af1fb20f~0Tu83WVza1367613676uscas1p2J;
        Tue, 31 May 2022 21:49:12 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 95.D0.09760.85D86926; Tue,
        31 May 2022 17:49:12 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220531214912uscas1p2d80942edd01e3f12d80514ccf3ab9f6d~0Tu8ojNRI0446504465uscas1p2R;
        Tue, 31 May 2022 21:49:12 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-8a-62968d5875d8
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 7D.0C.57470.75D86926; Tue,
        31 May 2022 17:49:12 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 31 May 2022 14:49:11 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        31 May 2022 14:49:11 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] docs: update language setting for Sphinx build
Thread-Topic: [PATCH] docs: update language setting for Sphinx build
Thread-Index: AQHYdThDAm+Gfoy0pk6M09f1/ykQmQ==
Date:   Tue, 31 May 2022 21:49:11 +0000
Message-ID: <20220531214857.169864-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7oRvdOSDFrnSVusvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKeLfjMVPBBY6Ky/O+sjUwNrF3MXJySAiYSPz+
        38bYxcjFISSwklHi+ub3zBBOK5PE+t3dbDBVfy93Q1WtZZT4vOQhM0hCSOATo8Tk08kQiWWM
        EuvvHWTqYuTgYBPQlHi7vwCkRkQgTOLno+2sIDazgLrEsY0bwIYKC9hLTNnQxQJR4yKxufUf
        I4StJ/H60Aowm0VAVeLAm21gu3gFbCQmTjwNdjajgJjE91NrmCBmikvcejKfCeJQQYlFs/cw
        Q9hiEv92PYR6QFHi/veX7BD1ehI3pk5hg7C1JZYtfA01X1Di5MwnLBD1khIHV9xgAflLQuAr
        u8SVDaeh4eUicabhHJQtLfH37jImiKJ2Rom5G79AdU8ABuQTKQjbWuJf5zWozXwSf389YgQF
        kIQAr0RHm9AERqVZSH6YheS+WUjum4XkvgWMLKsYxUuLi3PTU4sN81LL9YoTc4tL89L1kvNz
        NzECk8bpf4dzdzDuuPVR7xAjEwfjIUYJDmYlEd6SXVOThHhTEiurUovy44tKc1KLDzFKc7Ao
        ifMuy9yQKCSQnliSmp2aWpBaBJNl4uCUamBa96C1ZOV3r34uPRcNff8/G3r2yicaXN/SPW3t
        xqTjh1fecRdf8OqU/lsv2Uden99W8cjdk1o/5bSb6aduSeEfIbnJnWaCt4Tyr/imRGe4xZQL
        371onuih6rMx5OHkhs9blu0qyZ7nuVbnVKjkC8lb1TObWNeK6fsqZNSkLlrvceS6fcL2Uv8X
        xqFSHrWnLeM05k+5Znds9ZfTrH+3vN8m91j5x7rInT9ZV+zjOj6V5a7IutXaH3n+ax/7Lp/Y
        U/yO7659dvNWntLtVjuOnvgy/Uou74VHLn8VKjdmxil9Dj8da+dZzer05Obz/q1a++d4rsxd
        l9LE/cba9oTQXIEp1UxT/3YYT57169rrEo9DSizFGYmGWsxFxYkAf3dPdIkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWS2cA0UTeid1qSwelbHBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgy3u14zFRwgaPi8ryvbA2MTexdjJwcEgImEn8v
        dzN2MXJxCAmsZpRYcWISC0hCSOATo8Sme0oQiWWMEt0XDzF1MXJwsAloSrzdXwBSIyIQJvHz
        0XZWEJtZQF3i2MYNbCC2sIC9xJQNXSwQNS4Sm1v/MULYehKvD60As1kEVCUOvNnGDGLzCthI
        TJx4GuwgRgExie+n1jBBzBSXuPVkPhPEoQISS/acZ4awRSVePv7HCmErStz//pIdol5P4sbU
        KWwQtrbEsoWvoeYLSpyc+YQFol5S4uCKGywTGEVnIVkxC0n7LCTts5C0L2BkWcUoXlpcnJte
        UWyUl1quV5yYW1yal66XnJ+7iREYJ6f/HY7ewXj71ke9Q4xMHIyHGCU4mJVEeEt2TU0S4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkzvsyamK8kEB6YklqdmpqQWoRTJaJg1OqgcmFfcniVz4N4Z84
        uiexrju1+dl9n9Pz0tUt/uhV3Euyl9e4ceqZ8cZFSQ6ha9qTF007+PXY5HnmJUYMH3NkVISP
        N3rpx+8WXRET4nO9r6hoXW7PH9HdMhVmf/h711V+9ZzrO3HpNe/diTVuS3elM2nJSzjmbLU8
        uL3Rq0OA7cWZ3W/jjrUfzYyZnJWxyWVD0+zTU4R33mSYXzX73EUB5p513w2brjjzt34N2Wak
        rsOdxFKX42VSeNDj7See+X1SX29KPonid5xgc+yW0Mxf76x2s341rvb7svqOfVoJ3+pl+xbF
        lau4vNCv9GDll3k5f+mWta372+3DVDSr9S3/vJl/luuLaRLnf+Op639N61FiKc5INNRiLipO
        BADvVcBDAgMAAA==
X-CMS-MailID: 20220531214912uscas1p2d80942edd01e3f12d80514ccf3ab9f6d
CMS-TYPE: 301P
X-CMS-RootMailID: 20220531214912uscas1p2d80942edd01e3f12d80514ccf3ab9f6d
References: <CGME20220531214912uscas1p2d80942edd01e3f12d80514ccf3ab9f6d@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Sphinx 5.0.0 no longer accepts None for language. Remove it and Sphinx
will use English as the default and no longer emit a warning.

For details see https://github.com/sphinx-doc/sphinx/issues/10474

Sphinx warnings cause our documentation build on GitHub Actions to fail.
Failures were observed for recent macOS builds which upgraded to Sphinx
5.0.0.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 doc/conf.py | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/doc/conf.py b/doc/conf.py
index 10b72ecb..844f951a 100644
--- a/doc/conf.py
+++ b/doc/conf.py
@@ -85,13 +85,6 @@ def fio_version():
=20
 version, release =3D fio_version()
=20
-# The language for content autogenerated by Sphinx. Refer to documentation
-# for a list of supported languages.
-#
-# This is also used if you do content translation via gettext catalogs.
-# Usually you set "language" from the command line for these cases.
-language =3D None
-
 # There are two options for replacing |today|: either, you set today to so=
me
 # non-false value, then it is used:
 #
--=20
2.25.1
