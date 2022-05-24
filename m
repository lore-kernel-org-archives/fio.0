Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15DBC433F5
	for <fio@archiver.kernel.org>; Tue, 24 May 2022 14:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiEXOXe (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 May 2022 10:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbiEXOXc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 May 2022 10:23:32 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A0666226
        for <fio@vger.kernel.org>; Tue, 24 May 2022 07:23:31 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220524142326usoutp028ba2891a12134f99e45383e0b83e81f5~yEIvnXrEi2809328093usoutp02E;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220524142326usoutp028ba2891a12134f99e45383e0b83e81f5~yEIvnXrEi2809328093usoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653402206;
        bh=41bSFFQRs8jKVsO3vdOI3Q4WWV+4OPhxYP2D7na2goI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=sNti0prsRpqjw12mkGk0/05x+Y0L0/45iozMIAAl5KLWAaXY6FC1NePQ3+XaRU9as
         pYVX8vFezCSLod90c++JI98H9ZUGH2dDLJKl5TXlChQdP/EKCq0Fbj0b19eQg3intQ
         EKD6SnsPfyGMTVUCvqb+Eixtuljt6CO2lXfYd8JQ=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p1eb484e6ce510aec71c3c069f00ea995e~yEIvgv9qg0862908629uscas1p1K;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 11.D5.09760.E5AEC826; Tue,
        24 May 2022 10:23:26 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142325uscas1p1ac4d3543301cc43d0e5fa8dce8882dcb~yEIu4Qh0b1922519225uscas1p1e;
        Tue, 24 May 2022 14:23:25 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-d3-628cea5e4474
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id AF.A8.57470.D5AEC826; Tue,
        24 May 2022 10:23:25 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 24 May 2022 07:23:24 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        24 May 2022 07:23:24 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH v2 1/5] steadystate: delete incorrect comment
Thread-Topic: [PATCH v2 1/5] steadystate: delete incorrect comment
Thread-Index: AQHYb3nTXRqea5LYvkiplKAmAlgdTA==
Date:   Tue, 24 May 2022 14:23:24 +0000
Message-ID: <20220524142229.135808-2-vincent.fu@samsung.com>
In-Reply-To: <20220524142229.135808-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7pxr3qSDJ6+Y7VYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVsevRBNaCpRwVUzYuY29gvMTWxcjJISFgIrF/
        9h/mLkYuDiGBlYwSJ06sZ4RwWpkkDp15xQ5T9XrBHnaIxFpGiddHv0E5nxglGm7dgmpZxihx
        4/sHli5GDg42AU2Jt/sLQLpFBMIkfj7azgpiMwuoSxzbuAFst7CArUT3td1MIOUiAk4SVw+6
        QpTrSZz9+wKsnEVAVWLH201MIDavgI3E11fXwco5gVoX/pAFCTMKiEl8P7WGCWK6uMStJ/OZ
        IG4WlFg0ew8zhC0m8W/XQ6iPFSXuf3/JDlGvJ3Fj6hQ2CFtbYtnC18wQqwQlTs58wgJRLylx
        cMUNFpAPJQQ6OSQeTH7NDnKDhICLxM65ULukJf7eXcYEUdPOKDF34xeo5gmMEtefSEHY1hL/
        Oq9BLeaT+PvrEeMERuVZSO6eheSmWUhumoXkpgWMLKsYxUuLi3PTU4sN81LL9YoTc4tL89L1
        kvNzNzECU8bpf4dzdzDuuPVR7xAjEwfjIUYJDmYlEd6UsJ4kId6UxMqq1KL8+KLSnNTiQ4zS
        HCxK4rzLMjckCgmkJ5akZqemFqQWwWSZODilGpgSZziuKmAN+BUiPNGqgJXt381lt5TmrLko
        KOS/z9rxfV3u7VtW0r7Ttnqt2foyb2LCyibrJy37325emF9r29Xz6ZDbq4OHlTNcnTp8+ec5
        xiYxuCx2ubeIbfbHk2feVfTuMvwrJjDH9kTdXZ3Ew22t73KXGPf97ypbk2HxUtNz0oRJd4yO
        y5a8kRO1ZrjRl7p3Uvv9e/cuMM793Xr3pIr6guwJVhWz33h5+XUEB3/q/P5jQtXkhU45344+
        2rA9rN6Ae+JftXnnXmUsC8/MZSkryv+sl3r1ZuqLbc/qP4fEeL5qYBVh4Dxh+vUha3OBVPeD
        hGVXmR8riuyJFYvZts/tREDO1a36/Pk2zf4WAdFKLMUZiYZazEXFiQC8n/JoiAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCaqBv7qifJYMFeIYvVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZux5NYC1YylExZeMy9gbGS2xdjJwcEgImEq8X
        7GHvYuTiEBJYzSgx+/dxVgjnE6PEyvMTmSGcZYwSSx4uYuli5OBgE9CUeLu/AKRbRCBM4uej
        7awgNrOAusSxjRvApgoL2Ep0X9vNBFIuIuAkcfWgK0S5nsTZvy/AylkEVCV2vN3EBGLzCthI
        fH11HcwWArKP3tjDBtLKCTRm4Q9ZkDCjgJjE91NrmCA2iUvcejKfCeJ+AYkle84zQ9iiEi8f
        /2OFsBUl7n9/yQ5RrydxY+oUNghbW2LZwtfMEGsFJU7OfMICUS8pcXDFDZYJjOKzkKyYhaR9
        FpL2WUjaFzCyrGIULy0uzk2vKDbKSy3XK07MLS7NS9dLzs/dxAiMqtP/DkfvYLx966PeIUYm
        DsZDjBIczEoivClhPUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeV9GTYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MDmqv+ATVbotsq1Lc6kri2hOWw93hNmbLYtvME+vE22esknKoack40X0urXnTv4K
        dhRftLx3gUrVUVeX8xPndf24W/VRS5Vf2vvLTv/1r7Iigj8mGb+eyVxyXukd/99pQpfLZm18
        ns+q2LqpaudF5+4rhT0JHEovTZjaYrf7T/7s/u9EqkEXa8rXxSX5p+LaK1zKj2xjsiq58snn
        jb900KMl4Qfe27/gu7Z+ut2G9Ut1lTuN5Qxry89JBj11029P01NbNrXUL0lYNb26KWPC95uL
        JwW0P3nS3XvVKvFhklWIdCdfRQKD+YrP268u83zJxdWuEWVgtCdun1zI9omv7vZcvLj/Sjar
        r1OFfQmLEktxRqKhFnNRcSIAPv2eShkDAAA=
X-CMS-MailID: 20220524142325uscas1p1ac4d3543301cc43d0e5fa8dce8882dcb
CMS-TYPE: 301P
X-CMS-RootMailID: 20220524142325uscas1p1ac4d3543301cc43d0e5fa8dce8882dcb
References: <20220524142229.135808-1-vincent.fu@samsung.com>
        <CGME20220524142325uscas1p1ac4d3543301cc43d0e5fa8dce8882dcb@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fio actually does not begin collecting steady state data until the
steady state ramp time has expired. Remove the comment that said steady
state data is collected from the start of the job.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 steadystate.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/steadystate.c b/steadystate.c
index 2e3da1db..ad19318c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -250,13 +250,6 @@ int steadystate_check(void)
 		rate_time =3D mtime_since(&ss->prev_time, &now);
 		memcpy(&ss->prev_time, &now, sizeof(now));
=20
-		/*
-		 * Begin monitoring when job starts but don't actually use
-		 * data in checking stopping criterion until ss->ramp_time is
-		 * over. This ensures that we will have a sane value in
-		 * prev_iops/bw the first time through after ss->ramp_time
-		 * is done.
-		 */
 		if (ss->state & FIO_SS_RAMP_OVER) {
 			group_bw +=3D 1000 * (td_bytes - ss->prev_bytes) / rate_time;
 			group_iops +=3D 1000 * (td_iops - ss->prev_iops) / rate_time;
--=20
2.25.1
