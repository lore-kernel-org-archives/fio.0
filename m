Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84660CCA47A
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 15:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiFNP7B (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351203AbiFNP6i (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 11:58:38 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953CB1F2C4
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 08:58:34 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220614155831usoutp01852f4cc703d3f5d3ad125845a9c8bcf0~4h_xEy4PM2630626306usoutp01C;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220614155831usoutp01852f4cc703d3f5d3ad125845a9c8bcf0~4h_xEy4PM2630626306usoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655222311;
        bh=tlpEqtB5wSqmcp5Ad4e2+237Z8skB46V3FLoHjVIYEA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=O3sgveYKUoAB24KrkL5SZ4TUdk2rsGaat3xKnRrqUl3WzceoH9U/GphYbdTWuP7PJ
         pZGGBfNonnvHHsJinmc29fJsCGdS7hLFu6fKNidyW0E0MaCUURWsxZ+4I23pMxmyPA
         7cimTU/euZ8uSMhFVbk0toN9a1xMyJyn3O2zBBKw=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155831uscas1p14a4987d2804cb5759cb96f0f41e739f4~4h_w1o7Of0463404634uscas1p1F;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 15.2B.09749.720B8A26; Tue,
        14 Jun 2022 11:58:31 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155831uscas1p16ab7450c13a1587f2058617130f4f122~4h_we7cp70698806988uscas1p1n;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
X-AuditID: cbfec370-a6bff70000002615-d9-62a8b02705bb
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 9C.2E.57470.620B8A26; Tue,
        14 Jun 2022 11:58:31 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 14 Jun 2022 08:58:30 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        14 Jun 2022 08:58:30 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 5/5] ioengines: clean up latency accounting for 3 ioengines
Thread-Topic: [PATCH 5/5] ioengines: clean up latency accounting for 3
        ioengines
Thread-Index: AQHYgAeXSrR7OMPnsESpPRoN5gVR7Q==
Date:   Tue, 14 Jun 2022 15:58:29 +0000
Message-ID: <20220614155822.307771-6-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7rqG1YkGWz+KW+x+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEro+V9A0vBDcmKvcfa2RoYl4t2MXJySAiYSLT1
        72PpYuTiEBJYyShxrfUtG4TTyiRxd8kKZpiqho7vjBCJtYwS96c9ZodwPjFKbHk/nxXCWcYo
        cfHEBaAMBwebgKbE2/0FIN0iAmESPx9tZwWxmQXUJY5t3MAGUiIs4C2xb20OiCkiECQx4y8L
        RLWexLrls1lAwiwCqhJ7Oi1BwrwCNhLTtp1jBLE5BWwl5mydxwRiMwqISXw/tYYJYri4xK0n
        85kgThaUWDR7D9T5YhL/dj1kg7AVJe5/f8kOUa8ncWPqFDYIW1ti2cLXzBC7BCVOznzCAlEv
        KXFwxQ1wAEkI9HJIfLh5FWqQi0T3stlQtrTE37vLmCCK2hkl5m78AtU9gVHi+hMpCNta4l/n
        NajNfBJ/fz1inMCoPAvJ4bOQHDULyVGzkBy1gJFlFaN4aXFxbnpqsXFearlecWJucWleul5y
        fu4mRmDKOP3vcMEOxlu3PuodYmTiYDzEKMHBrCTCO/nisiQh3pTEyqrUovz4otKc1OJDjNIc
        LErivMsyNyQKCaQnlqRmp6YWpBbBZJk4OKUamDK2mJRtq/RhOHbartRJvchrUew3HRsXU0Xf
        P5mVOcfk6wMznh3y9uqV9HnMtju/2a2pXorH6sIOod1RUwpF761hnfxlafKaP4v4Gu5c9qnj
        tZTcMSenaC7nCqGeqTsE58cZLDE5svXIFhMJP0WPg3svLI98+ZRFjEX7RG/GR7NKgVIR/2KP
        6b9nBgbqPt2w/+oea+Pl4gefXcv300oPnSP00q733ZnUkAPbVxcd4XGckrYp7Z4I37OL1zIf
        iZYVTwlpLJYSbzA0XHfOttJ8zmYLtjNrwqRi3poeF+9k0ZrS9WbSg918H7xvnvNsNUgN/OhW
        XlnmdfoNd5DUBaZdHsGxm7ZyR0r1/N9d3VihxFKckWioxVxUnAgA0yBcyIgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCaqKu+YUWSwZzZHBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyWt43sBTckKzYe6ydrYFxuWgXIyeHhICJREPH
        d8YuRi4OIYHVjBLvJh9nh3A+MUp8f3+MCcJZxijxoH0JcxcjBwebgKbE2/0FIN0iAmESPx9t
        ZwWxmQXUJY5t3MAGUiIs4C2xb20OREmQRNez/ywQtp7EuuWzWUBKWARUJfZ0WoKEeQVsJKZt
        O8cIYgsB2bu2HGEGsTkFbCXmbJ3HBGIzCohJfD+1hglik7jErSfzmSDuF5BYsuc8M4QtKvHy
        8T9WCFtR4v73l+wQ9XoSN6ZOYYOwtSWWLXzNDLFXUOLkzCcsEPWSEgdX3GCZwCg+C8mKWUja
        ZyFpn4WkfQEjyypG8dLi4tz0imKjvNRyveLE3OLSvHS95PzcTYzAqDr973D0Dsbbtz7qHWJk
        4mA8xCjBwawkwjv54rIkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwvoybGCwmkJ5akZqemFqQW
        wWSZODilGpgSuLNykh59fXSpXNOq8YadaVf01fdWfV3SHuXWS9nWzkqvfNN8tkarkpdXWo3r
        Wm0Y61mBM08vBvKEmf8XnO63+esh0RXbPubH7rrD8F3n1Z+3l6tkjk/oON7R7J21PGVvIW/g
        d55LW+N2fTo8RTXBLY5346nNR0VW7PSMfe9wMvOZtfJjndWSt29f747qDWjam76P8ealQ8cL
        1zKue/no2TTFZ4VihjZPvLaURcv+Cjq3VKZPoiVz1dVDdQmG7rU/M7/z8Wttq1Zp131ybfGX
        smNL9m7Sn6+dwKrfPIGnzWHyY8XPi3PEZ/B0qs+0fXjkdP2Zsvui/zR7rmyfZPZbzr9O/+0U
        f0Ylbzb9jx+VWIozEg21mIuKEwEDlM/BGQMAAA==
X-CMS-MailID: 20220614155831uscas1p16ab7450c13a1587f2058617130f4f122
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155831uscas1p16ab7450c13a1587f2058617130f4f122
References: <20220614155822.307771-1-vincent.fu@samsung.com>
        <CGME20220614155831uscas1p16ab7450c13a1587f2058617130f4f122@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The librpma_apm_client, librpma_gpspm_client, and rdma ioengines have
commit functions that record submission latency. In order to avoid
setting issue_time twice add the FIO_ASYNCIO_SETS_ISSUE_TIME flag. Also
add code to update the iolog issue time when needed.

I don't have the means to test this patch.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/librpma_apm.c   | 2 +-
 engines/librpma_fio.c   | 9 ++++++++-
 engines/librpma_gpspm.c | 2 +-
 engines/rdma.c          | 9 ++++++++-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/engines/librpma_apm.c b/engines/librpma_apm.c
index d1166ad8..896240dd 100644
--- a/engines/librpma_apm.c
+++ b/engines/librpma_apm.c
@@ -208,7 +208,7 @@ FIO_STATIC struct ioengine_ops ioengine_client =3D {
 	.errdetails		=3D librpma_fio_client_errdetails,
 	.close_file		=3D librpma_fio_file_nop,
 	.cleanup		=3D client_cleanup,
-	.flags			=3D FIO_DISKLESSIO,
+	.flags			=3D FIO_DISKLESSIO | FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.options		=3D librpma_fio_options,
 	.option_struct_size	=3D sizeof(struct librpma_fio_options_values),
 };
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index 34818904..a78a1e57 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -621,9 +621,16 @@ int librpma_fio_client_commit(struct thread_data *td)
 		}
 	}
=20
-	if ((fill_time =3D fio_fill_issue_time(td)))
+	if ((fill_time =3D fio_fill_issue_time(td))) {
 		fio_gettime(&now, NULL);
=20
+		/*
+		 * only used for iolog
+		 */
+		if (td->o.read_iolog_file)
+			memcpy(&td->last_issue, &now, sizeof(now));
+
+	}
 	/* move executed io_us from queued[] to flight[] */
 	for (i =3D 0; i < ccd->io_u_queued_nr; i++) {
 		struct io_u *io_u =3D ccd->io_us_queued[i];
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
index 5cf97472..f00717a7 100644
--- a/engines/librpma_gpspm.c
+++ b/engines/librpma_gpspm.c
@@ -352,7 +352,7 @@ FIO_STATIC struct ioengine_ops ioengine_client =3D {
 	.errdetails		=3D librpma_fio_client_errdetails,
 	.close_file		=3D librpma_fio_file_nop,
 	.cleanup		=3D client_cleanup,
-	.flags			=3D FIO_DISKLESSIO,
+	.flags			=3D FIO_DISKLESSIO | FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.options		=3D librpma_fio_options,
 	.option_struct_size	=3D sizeof(struct librpma_fio_options_values),
 };
diff --git a/engines/rdma.c b/engines/rdma.c
index 4eb86652..e3bb2567 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -832,6 +832,12 @@ static void fio_rdmaio_queued(struct thread_data *td, =
struct io_u **io_us,
 		memcpy(&io_u->issue_time, &now, sizeof(now));
 		io_u_queued(td, io_u);
 	}
+
+	/*
+	 * only used for iolog
+	 */
+	if (td->o.read_iolog_file)
+		memcpy(&td->last_issue, &now, sizeof(now));
 }
=20
 static int fio_rdmaio_commit(struct thread_data *td)
@@ -1404,7 +1410,8 @@ FIO_STATIC struct ioengine_ops ioengine =3D {
 	.cleanup		=3D fio_rdmaio_cleanup,
 	.open_file		=3D fio_rdmaio_open_file,
 	.close_file		=3D fio_rdmaio_close_file,
-	.flags			=3D FIO_DISKLESSIO | FIO_UNIDIR | FIO_PIPEIO,
+	.flags			=3D FIO_DISKLESSIO | FIO_UNIDIR | FIO_PIPEIO |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.options		=3D options,
 	.option_struct_size	=3D sizeof(struct rdmaio_options),
 };
--=20
2.25.1
