Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5D2C43334
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 15:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbiFNP7B (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353778AbiFNP6j (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 11:58:39 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954DB205E9
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 08:58:34 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220614155831usoutp0168ad782e5c74da92f50864f0bdc93291~4h_wRboGW2287422874usoutp01h;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220614155831usoutp0168ad782e5c74da92f50864f0bdc93291~4h_wRboGW2287422874usoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655222311;
        bh=4jieIZy4VPGi6UvM6//TkxYuk9sG9q15aEwXgLpTOCI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=Di2AC/V3x4yT8y1ZsDQWxRN1RNbazZ1Tci9naJbtjr6K61E57s2R0zCA4u+rnwRWC
         1ObDJGmSLG3JJYdmhLhhA51c4u3mUlPAUvPcdVckMkNPdis87RWLbOfDRNiWfdCBbi
         7Hj/TRmCmnUHTfbTwEBMM0nIxzZfzJNdVf5yj++o=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220614155830uscas1p2f70f86b8ee2a052d683395412efa55ae~4h_wMAXjB2519925199uscas1p2u;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 9B.4F.09760.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9~4h_wAVdP32032020320uscas1p18;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-93-62a8b026b00b
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 7D.FC.52945.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 14 Jun 2022 08:58:29 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        14 Jun 2022 08:58:29 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/5] ioengines: don't record issue_time if ioengines already
 do it
Thread-Topic: [PATCH 2/5] ioengines: don't record issue_time if ioengines
        already do it
Thread-Index: AQHYgAeXX1Hbmdfg3ESlLF8U0k4WhQ==
Date:   Tue, 14 Jun 2022 15:58:29 +0000
Message-ID: <20220614155822.307771-3-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djX87pqG1YkGUy+YWax+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEro/HTZbaCb8oVb972MzUwPpDtYuTkkBAwkWh+
        cZmli5GLQ0hgJaPEnb0/WCGcViaJeV8+s8BUnVm+HSqxllFi7a5tjBDOJ0aJA+tnQPUvY5To
        W7UFqIyDg01AU+Lt/gKQbhGBMImfj0C6OTmYBdQljm3cwAZSIiwQIvGnNxDEFBGIlDh6PACi
        Wk/i7eN5jCBhFgFViT2dliAmr4CNxM83tiAVnAK2EnO2zmMCsRkFxCS+n1rDBDFbXOLWk/lM
        EBcLSiyavYcZwhaT+LfrIRuErShx//tLdoh6PYkbU6ewQdjaEssWvgar5wXqPTnzCdTnkhIH
        V9wA+09CoJNDouHYSlaIhIvEx32X2SFsaYnpay5DFbUzSszd+AWqewKjxPUnUhC2tcS/zmtQ
        m/kk/v56xDiBUXkWksNnITlqFpKjZiE5agEjyypG8dLi4tz01GLDvNRyveLE3OLSvHS95Pzc
        TYzAhHH63+HcHYw7bn3UO8TIxMF4iFGCg1lJhHfyxWVJQrwpiZVVqUX58UWlOanFhxilOViU
        xHmXZW5IFBJITyxJzU5NLUgtgskycXBKNTAlyqkd53Zc0Sin2B+9XuC7RKSlr0yzGsfpCZre
        5w/1MzAoCy5LTn616g3Tee6CXy8V1XL+bgjSf7j8TSr/7s47NumNnuyLbrH11GZP+eH42jvu
        5pZfU9ZmrPC9FCL/IaLkZ8iMS54G6Zxrl10qORt68Zetn/OHqMzKjVebOKY08FT5aATU38tT
        +lyqZP36Wh4HS2mpMo9J1r+XLw0rjnb1pCRpTORjP14cJGnadWNywtw+9TkPVnZMeBpcHRbN
        diP1dKuw4Dy3SYX3TOXUpv7Msw4tunXa+fzRfyK73Ne+2FnrqfKI+ZaO45mr4QvEvy77s953
        nrFWU8l9Yela9ycr7DfvlHy8MrTg+mJFaSWW4oxEQy3mouJEALHjTN2HAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LJbGCaqKu2YUWSwaFbqhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyGj9dZiv4plzx5m0/UwPjA9kuRk4OCQETiTPL
        t7N2MXJxCAmsZpSYfGMfG4TziVGi9eo0qMwyRokbT6+ydDFycLAJaEq83V8A0i0iECbx8xFI
        NycHs4C6xLGNG9hASoQFQiT+9AZClERKzPrwjx3C1pN4+3geI0gJi4CqxJ5OSxCTV8BG4ucb
        W5AKISBz15YjzCA2p4CtxJyt85hAbEYBMYnvp9YwQSwSl7j1ZD4TxPkCEkv2nGeGsEUlXj7+
        xwphK0rc//6SHaJeT+LG1ClsELa2xLKFr8HqeQUEJU7OfMICUS8pcXDFDZYJjOKzkKyYhaR9
        FpL2WUjaFzCyrGIULy0uzk2vKDbOSy3XK07MLS7NS9dLzs/dxAiMqdP/DsfsYLx366PeIUYm
        DsZDjBIczEoivJMvLksS4k1JrKxKLcqPLyrNSS0+xCjNwaIkzusROzFeSCA9sSQ1OzW1ILUI
        JsvEwSnVwFQwZdMW1VMq6Y+ZtYpzd1m8WV+vNP9d5f3DvzWE1qwWOfvlW1deWmXvfGP5TR78
        a/yqvE4H7KpfeeDEw4TY/i5nFYlF7jZ/n67r2Lr+XlmXiohw6I9o6dMCzqESjCynNLXOJUwq
        XPHxq47sR9FiWc2q7us919Pq1k4JjeZflFeq4FzKO0HmzSMuTfVfZ5LDC+z61rM2rX/7KYFP
        QeFDxIE1Pf3FZy8+WDL/B+PEAys0fVgft9zeUqK0mXmK8rq9Ai6SeZN26C75tfdksqnknjen
        9jy+cNwnRvNs063Stc02u7fX78l+77RD8kA888cq9qnd5uKKVw7MbnVSrTktq3PHo8zqpJvx
        Ah8d5+RnP5RYijMSDbWYi4oTAWMoI6wYAwAA
X-CMS-MailID: 20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9
References: <20220614155822.307771-1-vincent.fu@samsung.com>
        <CGME20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

io_uring, io_uring_cmd, and libaio record issue_time inside the ioengine
code when their commit functions are called. So we don't need to record
issue_time again for these ioengines in td_io_queue.

If we do fill issue_time twice, then mean(slat) + mean(clat) !=3D
mean(lat):

user@ubuntu:~/fio-dev$ fio-canonical/fio --name=3Dtest --ioengine=3Dio_urin=
g --number_ios=3D1 --rw=3Drandread --size=3D1M
test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 40=
96B-4096B, ioengine=3Dio_uring, iodepth=3D1
fio-3.30-48-g26fa
Starting 1 process

test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D172145: Mon Jun  6 16:12:42 =
2022
  read: IOPS=3D1000, BW=3D4000KiB/s (4096kB/s)(4096B/1msec)
    slat (nsec): min=3D61424, max=3D61424, avg=3D61424.00, stdev=3D 0.00
    clat (nsec): min=3D242709, max=3D242709, avg=3D242709.00, stdev=3D 0.00
     lat (nsec): min=3D308346, max=3D308346, avg=3D308346.00, stdev=3D 0.00

61424 + 242709 =3D 304133 !=3D 308346

If we fill issue_time only once, then the equality will hold (as it
should):

user@ubuntu:~/fio-dev$ fio-latency/fio --name=3Dtest --ioengine=3Dio_uring =
--number_ios=3D1 --rw=3Drandread --size=3D1M
test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 40=
96B-4096B, ioengine=3Dio_uring, iodepth=3D1
fio-3.30-48-g26fa-dirty
Starting 1 process

test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D172220: Mon Jun  6 16:12:47 =
2022
  read: IOPS=3D1000, BW=3D4000KiB/s (4096kB/s)(4096B/1msec)
    slat (nsec): min=3D53701, max=3D53701, avg=3D53701.00, stdev=3D 0.00
    clat (nsec): min=3D259566, max=3D259566, avg=3D259566.00, stdev=3D 0.00
     lat (nsec): min=3D313267, max=3D313267, avg=3D313267.00, stdev=3D 0.00

53701 + 259566 =3D 313267

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c | 7 +++++--
 engines/libaio.c   | 3 ++-
 ioengines.c        | 3 ++-
 ioengines.h        | 2 ++
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index cceafe69..474d215c 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1191,7 +1191,8 @@ static int fio_ioring_cmd_get_max_open_zones(struct t=
hread_data *td,
 static struct ioengine_ops ioengine_uring =3D {
 	.name			=3D "io_uring",
 	.version		=3D FIO_IOOPS_VERSION,
-	.flags			=3D FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD,
+	.flags			=3D FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			=3D fio_ioring_init,
 	.post_init		=3D fio_ioring_post_init,
 	.io_u_init		=3D fio_ioring_io_u_init,
@@ -1211,7 +1212,9 @@ static struct ioengine_ops ioengine_uring =3D {
 static struct ioengine_ops ioengine_uring_cmd =3D {
 	.name			=3D "io_uring_cmd",
 	.version		=3D FIO_IOOPS_VERSION,
-	.flags			=3D FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_=
RAWIO,
+	.flags			=3D FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
+					FIO_MEMALIGN | FIO_RAWIO |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			=3D fio_ioring_init,
 	.post_init		=3D fio_ioring_cmd_post_init,
 	.io_u_init		=3D fio_ioring_io_u_init,
diff --git a/engines/libaio.c b/engines/libaio.c
index 9c278d06..da5279f4 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -511,7 +511,8 @@ static int fio_libaio_init(struct thread_data *td)
 FIO_STATIC struct ioengine_ops ioengine =3D {
 	.name			=3D "libaio",
 	.version		=3D FIO_IOOPS_VERSION,
-	.flags			=3D FIO_ASYNCIO_SYNC_TRIM,
+	.flags			=3D FIO_ASYNCIO_SYNC_TRIM |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			=3D fio_libaio_init,
 	.post_init		=3D fio_libaio_post_init,
 	.prep			=3D fio_libaio_prep,
diff --git a/ioengines.c b/ioengines.c
index 280da3c8..e4ad698c 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -442,7 +442,8 @@ enum fio_q_status td_io_queue(struct thread_data *td, s=
truct io_u *io_u)
=20
 	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
 		!async_ioengine_sync_trim(td, io_u)) {
-		if (fio_fill_issue_time(td))
+		if (fio_fill_issue_time(td) &&
+			!td_ioengine_flagged(td, FIO_ASYNCIO_SETS_ISSUE_TIME))
 			fio_gettime(&io_u->issue_time, NULL);
=20
 		/*
diff --git a/ioengines.h b/ioengines.h
index acdb0071..fafa1e48 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -83,6 +83,8 @@ enum fio_ioengine_flags {
 	FIO_ASYNCIO_SYNC_TRIM
 			=3D 1 << 14,	/* io engine has async ->queue except for trim */
 	FIO_NO_OFFLOAD	=3D 1 << 15,	/* no async offload */
+	FIO_ASYNCIO_SETS_ISSUE_TIME
+			=3D 1 << 16,	/* async ioengine with commit function that sets issue_tim=
e */
 };
=20
 /*
--=20
2.25.1
