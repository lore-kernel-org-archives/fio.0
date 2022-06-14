Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6506BC433EF
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 15:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240445AbiFNP7D (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354997AbiFNP6j (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 11:58:39 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9167427B33
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 08:58:35 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220614155831usoutp0270f3bf88c8a8972e03a1604eba510591~4h_xKRNkZ1291812918usoutp029;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220614155831usoutp0270f3bf88c8a8972e03a1604eba510591~4h_xKRNkZ1291812918usoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655222312;
        bh=gZAk+6gfYIiRG7+q4PoLYRarI6UAPo/iebTOAXVHy9c=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=MCXJJk7k+EYIjHQGXIx/MSDvPEz6QDzbe3FoR6kIbwj5IJHMJZAUg1P8G1mp/V74y
         1zNBXDndGTxfdJH6lub6zAbGF+E+xMJVlUuZBUcTKsJ885ByI7KPQwJg9TqtIZr2cp
         WX4Y5P4i4XLwONRcpKvrzf2cjIfZYx/z4ZOykLrI=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155831uscas1p1fbc1a526b7d7746c616af8f12abd5ae1~4h_xBjmVm0290602906uscas1p17;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 45.2B.09749.720B8A26; Tue,
        14 Jun 2022 11:58:31 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155831uscas1p12c7b262538a47a417dc783a45e8df049~4h_wf9MdS0463404634uscas1p1E;
        Tue, 14 Jun 2022 15:58:31 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-da-62a8b027698e
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id CD.FC.52945.620B8A26; Tue,
        14 Jun 2022 11:58:31 -0400 (EDT)
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
Subject: [PATCH 4/5] ioengines: update last_issue if we set issue_time
Thread-Topic: [PATCH 4/5] ioengines: update last_issue if we set issue_time
Thread-Index: AQHYgAeX7SuLgZZf2kS8lkk/qlSYdQ==
Date:   Tue, 14 Jun 2022 15:58:29 +0000
Message-ID: <20220614155822.307771-5-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djX87rqG1YkGexv17NYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CV0bJ0PVvBKrGK5fvYGhj/CXYxcnJICJhI/O17
        yt7FyMUhJLCSUeLrpJmsIAkhgVYmiYlvPGCK9lxcAFW0llGiZcNXNgjnE6PE5znfmCGcZYwS
        F09cACrj4GAT0JR4u78ApFtEIEzi56PtYFOZBdQljm3cwAZSIizgJrGmMx+ixFti+8mVTBC2
        nkT7mw+sICUsAqoSezotQcK8AjYSc99vYgOxOQVsJeZsnQdWziggJvH91BomiOniEreezGeC
        uFlQYtHsPcwQtpjEv10P2SBsRYn731+yQ9TrSdyYOoUNwtaWWLbwNTPELkGJkzOfsEDUS0oc
        XHGDBeRDCYFODok/b6cxQiRcJH5O2AS1QFpi+prLUEXtjBJzN36B6p7AKHH9iRSEbS3xr/Ma
        1GY+ib+/HjFOYFSeheTwWUiOmoXkqFlIjlrAyLKKUby0uDg3PbXYOC+1XK84Mbe4NC9dLzk/
        dxMjMGGc/ne4YAfjrVsf9Q4xMnEwHmKU4GBWEuGdfHFZkhBvSmJlVWpRfnxRaU5q8SFGaQ4W
        JXHeZZkbEoUE0hNLUrNTUwtSi2CyTBycUg1MjAaaC8OeHGvKfXn0mELrtcTlgcEfHofJecq/
        Ke7cdqzobtGjvddVXnZz9HkdsxNLLwir0ODfKHZ1MctBb/1Vi9ISf/DO9TuTuFA9UGiCSHTh
        J4P7EywPWQtrxS6wvlT8IbEu4OIl4eQV23dGb6uq4g6w8U5//fmtKfd9f8H86hk7d/XcN0qf
        cu+2uX+3hJnurKtLJd4sObjvocq3C7xNn18fiGM9euTkL9elvb0X/zN55xmey15exmWyUu7g
        hjOM6+b/2fUs8tb6SGWD2AsOlQdKgwLfbNm3+5LqlWXRSqGbbh+dneA1d8uWWd+Dy8zvlDok
        x58RXmww5ZW0jtnF8DPPax/fvH2sfumfq/pbHymxFGckGmoxFxUnAgDDc4gthwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LJbGCaqKu+YUWSweP1nBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyWpauZytYJVaxfB9bA+M/wS5GTg4JAROJPRcX
        sHcxcnEICaxmlGh/epYFwvnEKDFt028mCGcZo8SD9iXMXYwcHGwCmhJv9xeAdIsIhEn8fLSd
        FcRmFlCXOLZxAxtIibCAm8SaznyIEm+J7SdXMkHYehLtbz6wgpSwCKhK7Om0BAnzCthIzH2/
        iQ3EFgKyd205wgxicwrYSszZOg+slVFATOL7qTVMEJvEJW49mc8Ecb+AxJI955khbFGJl4//
        sULYihL3v79kh6jXk7gxdQobhK0tsWzha2aIvYISJ2c+YYGol5Q4uOIGywRG8VlIVsxC0j4L
        SfssJO0LGFlWMYqXFhfnplcUG+ellusVJ+YWl+al6yXn525iBMbU6X+HY3Yw3rv1Ue8QIxMH
        4yFGCQ5mJRHeyReXJQnxpiRWVqUW5ccXleakFh9ilOZgURLn9YidGC8kkJ5YkpqdmlqQWgST
        ZeLglGpg8ldiPFYrWDUrTLh/tS8Dk+pq5rqtgcdyK3bNLNxd+PLEe3H57l1ca44nWh7auM/0
        4boO31OXDioI6jq16H993LyYfaPyHfM7ZVk/ZA1avsQe8k7KK0nWip19qc5vF7fsgWtZB19E
        qnJbRK26Izcz97Zk1bWHFuG/J4alKHEJbzQPO3XoGs+k7Dce11/+0vH/KHzOqIzxdorczHOz
        laaIFNzfd/9x+AYOX3HrHxMebeh8uHmG7buntybcPflfape7680lavYTfqaEN1yqc69YqqTC
        f6nVTOFG2fOTXy0k5wm82DXJ0HXT/8UOM4uuTZwesfptbX+v/6bGU4z+RsdVnWTF+Tb4X2R1
        WHD7cfT0L0osxRmJhlrMRcWJAHQIxWUYAwAA
X-CMS-MailID: 20220614155831uscas1p12c7b262538a47a417dc783a45e8df049
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155831uscas1p12c7b262538a47a417dc783a45e8df049
References: <20220614155822.307771-1-vincent.fu@samsung.com>
        <CGME20220614155831uscas1p12c7b262538a47a417dc783a45e8df049@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

If we're not updating issue_time it doesn't make sense to update
last_issue. We should also be updating last_issue in libaio and io_uring
when we record issue_time.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c |  6 ++++++
 engines/libaio.c   |  6 ++++++
 ioengines.c        | 30 ++++++++++++++++--------------
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 474d215c..cffc7371 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -608,6 +608,12 @@ static void fio_ioring_queued(struct thread_data *td, =
int start, int nr)
=20
 		start++;
 	}
+
+	/*
+	 * only used for iolog
+	 */
+	if (td->o.read_iolog_file)
+		memcpy(&td->last_issue, &now, sizeof(now));
 }
=20
 static int fio_ioring_commit(struct thread_data *td)
diff --git a/engines/libaio.c b/engines/libaio.c
index da5279f4..33b8c12f 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -368,6 +368,12 @@ static void fio_libaio_queued(struct thread_data *td, =
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
 static int fio_libaio_commit(struct thread_data *td)
diff --git a/ioengines.c b/ioengines.c
index e4ad698c..e2316ee4 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -358,15 +358,16 @@ enum fio_q_status td_io_queue(struct thread_data *td,=
 struct io_u *io_u)
=20
 	if (td_ioengine_flagged(td, FIO_SYNCIO) ||
 		async_ioengine_sync_trim(td, io_u)) {
-		if (fio_fill_issue_time(td))
+		if (fio_fill_issue_time(td)) {
 			fio_gettime(&io_u->issue_time, NULL);
=20
-		/*
-		 * only used for iolog
-		 */
-		if (td->o.read_iolog_file)
-			memcpy(&td->last_issue, &io_u->issue_time,
-					sizeof(io_u->issue_time));
+			/*
+			 * only used for iolog
+			 */
+			if (td->o.read_iolog_file)
+				memcpy(&td->last_issue, &io_u->issue_time,
+						sizeof(io_u->issue_time));
+		}
 	}
=20
=20
@@ -443,15 +444,16 @@ enum fio_q_status td_io_queue(struct thread_data *td,=
 struct io_u *io_u)
 	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
 		!async_ioengine_sync_trim(td, io_u)) {
 		if (fio_fill_issue_time(td) &&
-			!td_ioengine_flagged(td, FIO_ASYNCIO_SETS_ISSUE_TIME))
+			!td_ioengine_flagged(td, FIO_ASYNCIO_SETS_ISSUE_TIME)) {
 			fio_gettime(&io_u->issue_time, NULL);
=20
-		/*
-		 * only used for iolog
-		 */
-		if (td->o.read_iolog_file)
-			memcpy(&td->last_issue, &io_u->issue_time,
-					sizeof(io_u->issue_time));
+			/*
+			 * only used for iolog
+			 */
+			if (td->o.read_iolog_file)
+				memcpy(&td->last_issue, &io_u->issue_time,
+						sizeof(io_u->issue_time));
+		}
 	}
=20
 	return ret;
--=20
2.25.1
