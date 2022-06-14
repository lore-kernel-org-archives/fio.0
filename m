Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C483C43334
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 15:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbiFNP7C (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354337AbiFNP6j (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 11:58:39 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915E127176
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 08:58:35 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220614155831usoutp024c0c3172045a72b1f4db89d218e4250f~4h_w7mxCs1379313793usoutp02n;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220614155831usoutp024c0c3172045a72b1f4db89d218e4250f~4h_w7mxCs1379313793usoutp02n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655222311;
        bh=ceG+4uj4PDkj6rxJ7cw76DgPDnxOZp6lFo8eUKnetks=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=s5wXWjAqjAkwQu3JBoO8Wf360kIQovSmfmf2o8sk/cXiAlIUjSh9MrGc6pJ/7cHSN
         scI8k/tRvtykUqIx6BZuAsaSw4o7EMf4OPdRqHw4iuPa0+EK6x3z8oIv+AnYmrXhZr
         19Go4pN7q80ZpDeP8nZOljFAe3KrL6MJlUGvXjFo=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155831uscas1p125b58dccd053331bfead16eab6418652~4h_wojTlE0698806988uscas1p1o;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id D1.54.09642.720B8A26; Tue,
        14 Jun 2022 11:58:31 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220614155831uscas1p2312cb623924e5df60abefb210affa1f4~4h_wUmqtp1401314013uscas1p2j;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-c6-62a8b0271081
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id AD.FC.52945.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 14 Jun 2022 08:58:30 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        14 Jun 2022 08:58:30 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 3/5] HOWTO: improve description of latency measures
Thread-Topic: [PATCH 3/5] HOWTO: improve description of latency measures
Thread-Index: AQHYgAeXYkfonsLA+kyRzDi3vqgTAQ==
Date:   Tue, 14 Jun 2022 15:58:29 +0000
Message-ID: <20220614155822.307771-4-vincent.fu@samsung.com>
In-Reply-To: <20220614155822.307771-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djX87rqG1YkGez/JWqx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr40jnSeaC7xIVu6//ZW5gnCXUxcjJISFgIvH3
        9G+2LkYuDiGBlYwSyyf0sUA4rUwSf9b1sMJU7fg+AapqLaPE/cV72CGcT4wSn+d8Y4ZwljFK
        XDxxASjDwcEmoCnxdn8BSLeIQJjEz0fbwSYxC6hLHNu4gQ3EFhZwlvj/rZEVosZDYuuRl0wQ
        tp7Eg1tTmUHGsAioSuzptAQJ8wrYSMy908MOYnMK2ErM2ToPrJxRQEzi+6k1TBDjxSVuPZnP
        BHG0oMSi2XuYIWwxiX+7HrJB2IoS97+/ZIeo15O4MXUKG4StLbFs4WtmiF2CEidnPmGBqJeU
        OLjiBjhUJAR6OSRevz0OtcBF4uvxTVBDpSWmr7kMVdTOKDF34xeo7gmMEtefSEHY1hL/Oq9B
        beaT+PvrEeMERuVZSA6fheSoWUiOmoXkqAWMLKsYxUuLi3PTU4uN8lLL9YoTc4tL89L1kvNz
        NzEC08bpf4fzdzBev/VR7xAjEwfjIUYJDmYlEd7JF5clCfGmJFZWpRblxxeV5qQWH2KU5mBR
        EuddlrkhUUggPbEkNTs1tSC1CCbLxMEp1cDkfvDLdw5x5eubQs1Ks9YVvDj1Q3LZ88ty9yyd
        OIqO5C5uXDfp1fnAK4+3RdSkMf22PGjpyLJVNuNoUtiaCNfJ60RvWWr0vrG20Gtbfpcjd+YB
        v2l68wuFq44qfPNOadQ9HV3bMj3m15Pvpfq1+asuPcqz+nt0Yuj8dN6tGkKrWqZ6HSs3akr8
        aPuGdeKW4yk6p1skX1t/fx0x46my/V5t9m9iD+LCZ03a+fWJ0rwgi/ObUqpWzPfa2MHROzf/
        1ZRZnFzOR7LT/bWVrdgYl74Mczvr2iK3bo9dafGnFE3lc1p7fqrbB0/xuPDBynRCuehC9iw2
        D9WGmp3cAs1/dTdJXmwKTk7eX3jB5v7Fn+pKLMUZiYZazEXFiQAXmVCtigMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqKu2YUWSwduJZhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyjnSeZC74LlGx+/pf5gbGWUJdjJwcEgImEju+
        T2DrYuTiEBJYzShx/+4LKOcTo8S0Tb+ZIJxljBIP2pcwdzFycLAJaEq83V8A0i0iECbx89F2
        VhCbWUBd4tjGDWwgtrCAs8T/b42sEDUeEluPvGSCsPUkHtyaCjaGRUBVYk+nJUiYV8BGYu6d
        HnYQWwjI3rXlCDOIzSlgKzFn6zywVkYBMYnvp9YwQawSl7j1ZD4TxAMCEkv2nGeGsEUlXj7+
        xwphK0rc//6SHaJeT+LG1ClsELa2xLKFr5kh9gpKnJz5hAWiXlLi4IobLBMYxWchWTELSfss
        JO2zkLQvYGRZxSheWlycm15RbJyXWq5XnJhbXJqXrpecn7uJERhXp/8djtnBeO/WR71DjEwc
        jIcYJTiYlUR4J19cliTEm5JYWZValB9fVJqTWnyIUZqDRUmc1yN2YryQQHpiSWp2ampBahFM
        lomDU6qBSfv3twLZ3Kr/UYGaTy4e+pB5abXc0ZqVVhOObllw3l1uWUTDxFt1iVVJrtIW/K4f
        xfk2pAkwSXM9+DmTjXPq7/vrjd1mxr/mOZ6l+ev3jjcv592ruFQkZxKan6e+kneuYdWzLf6K
        3vvmynv/nHRd8mHfg7cVVXe0Ky/p/ZQOcorOVwgRCrq46syZtZtsCliemG/Q3jn9obmNh/jd
        v0f97zztf3vcu6nk58x1yQe37L7H/OXE6t2ys6b6ZDvvTBJoPxjpPunr5Lcfz+w773V43j4b
        Ni1Ts+aMtxtDnhXeETxubmAe/eNx7JlyuQ2fJupcOxXcvqn82OOjTgoTdBwO5/LEHVnqe1f8
        utes7W+jP9grsRRnJBpqMRcVJwIAxQnOyBoDAAA=
X-CMS-MailID: 20220614155831uscas1p2312cb623924e5df60abefb210affa1f4
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155831uscas1p2312cb623924e5df60abefb210affa1f4
References: <20220614155822.307771-1-vincent.fu@samsung.com>
        <CGME20220614155831uscas1p2312cb623924e5df60abefb210affa1f4@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

- clarify how submission latency is calculated for async ioengines
- it is slat (not clat) that is near zero for sync ioengines
- Note that submission latency + completion latency =3D total latency

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 28ac2b7c..470777e2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4165,24 +4165,31 @@ writes in the example above).  In the order listed,=
 they denote:
 **slat**
 		Submission latency (**min** being the minimum, **max** being the
 		maximum, **avg** being the average, **stdev** being the standard
-		deviation).  This is the time it took to submit the I/O.  For
-		sync I/O this row is not displayed as the slat is really the
-		completion latency (since queue/complete is one operation there).
-		This value can be in nanoseconds, microseconds or milliseconds ---
-		fio will choose the most appropriate base and print that (in the
-		example above nanoseconds was the best scale).  Note: in :option:`--mini=
mal` mode
-		latencies are always expressed in microseconds.
+                deviation).  This is the time from when fio initialized th=
e I/O
+                to submission.  For synchronous ioengines this includes th=
e time
+                up until just before the ioengine's queue function is call=
ed.
+                For asynchronous ioengines this includes the time up throu=
gh the
+                completion of the ioengine's queue function (and commit fu=
nction
+                if it is defined). For sync I/O this row is not displayed =
as the
+                slat is negligible.  This value can be in nanoseconds,
+                microseconds or milliseconds --- fio will choose the most
+                appropriate base and print that (in the example above
+                nanoseconds was the best scale).  Note: in :option:`--mini=
mal`
+                mode latencies are always expressed in microseconds.
=20
 **clat**
 		Completion latency. Same names as slat, this denotes the time from
-		submission to completion of the I/O pieces. For sync I/O, clat will
-		usually be equal (or very close) to 0, as the time from submit to
-		complete is basically just CPU time (I/O has already been done, see slat
-		explanation).
+                submission to completion of the I/O pieces. For sync I/O, =
this
+                represents the time from when the I/O was submitted to the
+                operating system to when it was completed. For asynchronou=
s
+                ioengines this is the time from when the ioengine's queue =
(and
+                commit if available) functions were completed to when the =
I/O's
+                completion was reaped by fio.
=20
 **lat**
 		Total latency. Same names as slat and clat, this denotes the time from
 		when fio created the I/O unit to completion of the I/O operation.
+                It is the sum of submission and completion latency.
=20
 **bw**
 		Bandwidth statistics based on samples. Same names as the xlat stats,
--=20
2.25.1
