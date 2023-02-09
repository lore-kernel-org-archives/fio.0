Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A54DC636CD
	for <fio@archiver.kernel.org>; Fri, 10 Feb 2023 04:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjBJEkv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 23:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBJEku (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 23:40:50 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61212518F4
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 20:40:48 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230210044043epoutp035de254cd9424b1fbc041062842baa7cf~CXMxPEwLS1987019870epoutp03n
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 04:40:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230210044043epoutp035de254cd9424b1fbc041062842baa7cf~CXMxPEwLS1987019870epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676004043;
        bh=c2ElPGbxbM3at5NF5THihtrblKr2Bvl/IZVm06CAOjo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fRL9YWH9AVw4o2lqct86uiK1MDRWoLjUp7mthGRZ+1zJLo9ePMV3jDVV8KfpgBvXa
         HQ7xorpdwP3ECbPRvZJrye+HN/B/A1+YE7fUhIS8GnXRMUWsM2V+9JU0Jyey/aPLRv
         N8TqgEY8NQ2xa77k58bDclhdKky0/PNyz0ZZXofs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230210044043epcas5p3d1ce2817f01b7e4f28378a627c04b5c5~CXMw3YAny1136911369epcas5p3L;
        Fri, 10 Feb 2023 04:40:43 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4PCgyx63Kqz4x9QF; Fri, 10 Feb
        2023 04:40:41 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.88.55678.9CAC5E36; Fri, 10 Feb 2023 13:40:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230209144042epcas5p4ede6ce94dee46af4d4452cfd3ce7e6e6~CLvVUyjef2871428714epcas5p4m;
        Thu,  9 Feb 2023 14:40:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230209144042epsmtrp2a55f9b30d99535298916edc3cf2a83cb~CLvVUG0p51220912209epsmtrp2n;
        Thu,  9 Feb 2023 14:40:42 +0000 (GMT)
X-AuditID: b6c32a4a-6a3ff7000000d97e-96-63e5cac9ee5f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.A1.17995.AE505E36; Thu,  9 Feb 2023 23:40:42 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230209144041epsmtip1525ea4b3be38f5c71bdfab6566d91d7d~CLvUaUgnR1841518415epsmtip1b;
        Thu,  9 Feb 2023 14:40:41 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     kbusch@kernel.org, fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/3] fdp support in fio
Date:   Thu,  9 Feb 2023 20:10:01 +0530
Message-Id: <20230209144004.15298-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7bCmuu7JU0+TDQ7M4rJYc+U3u8Xqu/1s
        Fh9nvWC2mHToGqPFhjZBB1aPnbPusntcPlvqsWlVJ5tH35ZVjB6fN8kFsEZl22SkJqakFimk
        5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
        29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGc8XvyfvWCLcMXB
        NR4NjKd4uxg5OSQETCTa3y5g62Lk4hAS2M0o8X3DBWYI5xOjxNTnPVCZz4wSJ/u3McG0nJm+
        nhEisYtR4tKyM1BOM5PE5l9vWUGq2AS0JV69vcEMYosICEvs72hl6WLk4GAWyJDouhoDEhYW
        0JL48u8+WAmLgKrEwYcT2EFsXgEbiY//nrJBLJOXWL3hANhJEgLz2CW+XX4MlXCReLP+FSuE
        LSzx6vgWdghbSuLzu71QNdkSmx7+hLq6QOLIi15mCNteovVUPzPEPZoS63fpQ4RlJaaeWgdW
        zizAJ9H7+wlUK6/EjnkwtqrE33u3WSBsaYmb766CvSUh4CHR+UQdJCwkECtx/NoVpgmMsrMQ
        FixgZFzFKJlaUJybnlpsWmCUl1oOj6bk/NxNjOD0pOW1g/Hhgw96hxiZOBgPMUpwMCuJ8H6f
        +DhZiDclsbIqtSg/vqg0J7X4EKMpMMgmMkuJJucDE2ReSbyhiaWBiZmZmYmlsZmhkjivuu3J
        ZCGB9MSS1OzU1ILUIpg+Jg5OqQYmvhCxqa7Oa7SfVE3uWpYXXnb/3rvFy+adO/xu510z7s+z
        +jgW+3VdX3DmVYZtv5KUYoW+VbSHXN2l27EPb99Sm6RqfzZmy/uvFYU8UVaK62d+Zo8Iafuy
        8bDTpsZ92SKLT3wOyK//laDCtcH8zqlz2369CrEsvnvIkUHp412W3YXCH6f/uVCXN4G5PLoo
        5vERoxnBHZaBdwsjKnOCfrx2D7Px+OqyUNXLpeVY60OGavVFjjzzZjA0FuplXr7erMpnkFYh
        8nznMv2jdhuOGi3Zs0Q92SNdcFWTGouW58ofloUsLNYrGlrdNy1gkuI8c8aMgadT8tTCswYV
        GvL6D+77LZ1s9v30r21fujkrHVcqsRRnJBpqMRcVJwIAeL2nBtgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsWy7bCSnO4r1qfJBktPSVqsufKb3WL13X42
        i4+zXjBbTDp0jdFiQ5ugA6vHzll32T0uny312LSqk82jb8sqRo/Pm+QCWKO4bFJSczLLUov0
        7RK4Mh4v/s9esEW44uAajwbGU7xdjJwcEgImEmemr2fsYuTiEBLYwShxrPMOkMMBlJCWWLg+
        EaJGWGLlv+fsEDWNTBKL216ygyTYBLQlXr29wQxiiwAV7e9oZQGxmQVyJE5MeM0IYgsLaEl8
        +XcfrIZFQFXi4MMJYL28AjYSH/89ZYNYIC+xesMB5gmMPAsYGVYxSqYWFOem5xYbFhjlpZbr
        FSfmFpfmpesl5+duYgSHipbWDsY9qz7oHWJk4mA8xCjBwawkwvt94uNkId6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpiOugbGPdhtsnD7IbHbG3r2zztl
        7Je7vzRd7+il+XHal/ttBEJ19Bps6sMT+bIyT+7/sku2cEPpga191f88l6wrEnIXei6z/tHp
        GTvX6X87GDj/yM5dB9rb87PverkftVpvp6S+hP39FPPQT5Hfm47aeirc1Su80H5n3VzJzAX1
        v0zz5Y2EJy2cWjQnoOqv2lE1o9Yipb06xycs3ica2fTv5Nbqj3EZn5mmaDV4vSh+c+KtWLiN
        bM3LIxlN59fe2sGwZ3XIqTY+GfnJc5ZeqylmebFQbe6tmcx8aslqDwtSv27f++jVu9bu5vvW
        fSmTp02uuJXSKbPgZf/hABf7VS1nF864+K9QIHIvEys/o4eIEktxRqKhFnNRcSIADiTyTIQC
        AAA=
X-CMS-MailID: 20230209144042epcas5p4ede6ce94dee46af4d4452cfd3ce7e6e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230209144042epcas5p4ede6ce94dee46af4d4452cfd3ce7e6e6
References: <CGME20230209144042epcas5p4ede6ce94dee46af4d4452cfd3ce7e6e6@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

NVMe TP4146 creates a new feature called Flexible Data Placement. This
feature allows a host to tell the device how to group write data through
the use of "Placement Identifiers" in write commands.

Add support for using placement identifiers in write commands. The user
can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
ioengine. By default, the fio jobs will cycle through all the namespace's
available placement identifiers for write commands. The user can limit
which placement identifiers can be used with additional parameter,
"fdp_pli=<list,>", which can be used to separate write intensive jobs
from less intenstive ones.

Setting up your namespace for FDP is outside the scope of 'fio', so this
assumes the namespace is already properly configured for the mode.

v2 -> v1
1. Enhance fdp support check. Check if get feature fdp has fdp
configuration enabled. Use the fdp config index to determine the
reclaim unit size. This will be handy when we update the fdp backend
to write in different fashion.
2. fetch ruhs info, can even work for more than 1024 reclaim unit
handle descripotors. We just need to query io mangement recv command
twice.
3. Add the missing fdp backend.
4. Update man page for the new options.

Note: I have purposefully left out Signed-off-by tag (Keith's and mine).
Feedback is appreciated.

Ankit Kumar (3):
  fio/fdp: add fdp support to fio
  engines/io_uring: add fdp support for io_uring_cmd engine
  example: add fdp example for uring_cmd engine

 HOWTO.rst                  |  14 +++
 Makefile                   |   2 +-
 engines/io_uring.c         |  15 +++
 engines/nvme.c             | 224 ++++++++++++++++++++++++++++++++++++-
 engines/nvme.h             |  74 ++++++++++++
 examples/uring-cmd-fdp.fio |  37 ++++++
 fdp.c                      | 219 ++++++++++++++++++++++++++++++++++++
 fdp.h                      |  25 +++++
 file.h                     |   3 +
 filesetup.c                |   7 ++
 fio.1                      |  12 ++
 fio.h                      |   2 +
 init.c                     |   1 +
 io_u.c                     |   3 +
 io_u.h                     |   3 +
 ioengines.h                |   7 +-
 options.c                  |  49 ++++++++
 thread_options.h           |   8 ++
 18 files changed, 702 insertions(+), 3 deletions(-)
 create mode 100644 examples/uring-cmd-fdp.fio
 create mode 100644 fdp.c
 create mode 100644 fdp.h

-- 
2.17.1

