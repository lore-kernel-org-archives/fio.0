Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA144C2BB41
	for <fio@archiver.kernel.org>; Tue, 16 Aug 2022 08:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiHPITh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 Aug 2022 04:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiHPISy (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Aug 2022 04:18:54 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CB4CE460
        for <fio@vger.kernel.org>; Mon, 15 Aug 2022 23:05:35 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220816060532epoutp0319845b8395d41e5ba14021a898329cc6~Lvh-4g9991734617346epoutp03z
        for <fio@vger.kernel.org>; Tue, 16 Aug 2022 06:05:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220816060532epoutp0319845b8395d41e5ba14021a898329cc6~Lvh-4g9991734617346epoutp03z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660629932;
        bh=GdlI0Kw7WJAbOZABN1nkZTEnfElkzaMEWfSvADcnfr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOgz7TMEegyWUL35GwPYudvCk0jJnk+vCL9AyaeEibUU7IEXsWZYQ1mOf1d2geG7i
         4j7BzbNbg3+c7l+vwLjwVSjPfNpEa6tVAI9N/nLtAASCSsi/DFz0b22kdXWTFvQwLI
         ztAvWX54BMY7IL+BZU9W3jj4PNVf2c5AOgw8MWLM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220816060531epcas5p485eda1f9a1dc384b87f9f63e184b79f4~Lvh_7qmfo0569005690epcas5p4G;
        Tue, 16 Aug 2022 06:05:31 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4M6LGt4ZGMz4x9QF; Tue, 16 Aug
        2022 06:05:26 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.34.49477.3A33BF26; Tue, 16 Aug 2022 15:05:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220816054810epcas5p4bc47353694128a80ad48fbcc89fb1907~LvS1VZDwm3166131661epcas5p4Q;
        Tue, 16 Aug 2022 05:48:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220816054810epsmtrp282b1880d45d1636fab7a0aff421d96b7~LvS1UhXcq2873628736epsmtrp2Q;
        Tue, 16 Aug 2022 05:48:10 +0000 (GMT)
X-AuditID: b6c32a49-843ff7000000c145-f0-62fb33a37b06
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.DA.08802.99F2BF26; Tue, 16 Aug 2022 14:48:09 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220816054809epsmtip1545f189fd24cacee126896a2cc263b1d~LvS0c88iT1625416254epsmtip1y;
        Tue, 16 Aug 2022 05:48:08 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] doc: update fio doc for xnvme engine
Date:   Tue, 16 Aug 2022 11:08:21 +0530
Message-Id: <20220816053821.440-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220816053821.440-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmlu4S499JBlNamCzWXPnNbrH6bj+b
        xcdZL5gtHnd3MDqweFw+W+rRt2UVo8fnTXIBzFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGm
        ZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAy5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqp
        BSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RkzVt9hLJitU3Hj5kTWBsZ5yl2MnBwSAiYS
        83s+sHYxcnEICexmlFh5dzMLhPOJUWLz1DfMEM5nRomv09axw7RcX3qRDSKxi1Hi0ofFUC2t
        TBJHT81mBKliE9CWePX2BjOILSIgLLG/oxWoiIODWSBC4uQLD5CwsIClxKJj88BKWARUJWb/
        mwhWwitgJfHmngHELnmJ1RsOgJVwClhLfPuyiREivohd4uNhNgjbRWLRjlMsELawxKvjW6Du
        lJL4/G4vVE22xKaHP5kg7AKJIy96mSFse4nWU/3MEJdpSqzfpQ8RlpWYemodWDmzAJ9E7+8n
        UK28EjvmwdiqEn/v3YZaKy1x891VKNtDYv2xZ9AQ7WOUmHVhBdMERrlZCCsWMDKuYpRMLSjO
        TU8tNi0wzEsth8dZcn7uJkZwctLy3MF498EHvUOMTByMhxglOJiVRHgFX/xIEuJNSaysSi3K
        jy8qzUktPsRoCgy+icxSosn5wPSYVxJvaGJpYGJmZmZiaWxmqCTO63V1U5KQQHpiSWp2ampB
        ahFMHxMHp1QDE4fS7F8X/gvZd2xZf6Dr4PHrobwmXxv+1d/mXpybNott4YtL67Q685sX3N+X
        wbHSiHlrr0So6wcL011Gy6ZsqJ+7+36jwOUHU7aHHp2QdV5qoeznvzMObvxzufONl+MktXrp
        BU8jBYKeT9PJMfvmsLiXzS35t1TodKc7op+tNu+/JqyqfWK94jJPn/iWn4fOJOiG+v5bqTLN
        kV1RM+BX6l3/nODFKudPK2Xs/lDrtKrl5tXvzf93Nx2ZV8Fw2dg7zvHS/qIt8xyeV0RbtRTd
        +eQ8yWXW4rcVZ3gyHjAs+rpv+YZDrXsPHmT/8ubstBPCs2Y5tBbLL1IXnOfaMiO3U2gyH9/k
        eq2/O+50LV6Z2pioxFKckWioxVxUnAgA7WvqvtcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsWy7bCSnO5M/d9JBh/nmVqsufKb3WL13X42
        i4+zXjBbPO7uYHRg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4MmasvsNYMFun4sbN
        iawNjPOUuxg5OSQETCSuL73I1sXIxSEksINR4vSk1YxdjBxACWmJhesTIWqEJVb+e84OUdPM
        JHH6VBsLSIJNQFvi1dsbzCC2CFDR/o5WsDizQJTEw8sXwWxhAUuJRcfmgdWwCKhKzP43kQVk
        Pq+AlcSbewYQ8+UlVm84AFbCKWAt8e3LJkYQWwio5E7TD6YJjHwLGBlWMUqmFhTnpucWGxYY
        5aWW6xUn5haX5qXrJefnbmIEh4+W1g7GPas+6B1iZOJgPMQowcGsJMIr+OJHkhBvSmJlVWpR
        fnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MaRtOZLPHtf3Wzy42evZi
        T9+m/XP2qIklZC3e1/5DZqXgpBm/WLOMBH6/nbrkSeN1rnXVkhV+OzZMj76e+1XLOHVj87kv
        XDuLjsdbFzkqWStXvvEy/aT6PDHg1AHnGyt+fbJ4uvHl7GnfTdkFBba1uig49a7J22N0oVjW
        jPHOk6VXjL8/uzCpxWJCsOL8fX+8dl9MPPB3ddWLkxyNYQr82/4XZvNFS7fYCLpvZjklpPb3
        tAqj39xrM+Vk5h27pVOuu9Nt6+Ley1eir3Gq9LRskDxxTbx2h+dez3n5C12l03P+GMbHRHhk
        6EkpbKs+fFKpzHuJTcX6d8bR+d1lQh9D7zUVmYoqpymun7BiyplZSizFGYmGWsxFxYkAH1s2
        oI4CAAA=
X-CMS-MailID: 20220816054810epcas5p4bc47353694128a80ad48fbcc89fb1907
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220816054810epcas5p4bc47353694128a80ad48fbcc89fb1907
References: <20220816053821.440-1-ankit.kumar@samsung.com>
        <CGME20220816054810epcas5p4bc47353694128a80ad48fbcc89fb1907@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

- Elaborate about the various sync, async and admin
  interfaces.
- add missing io_uring_cmd async backend entry.
- xnvme ioengine doesn't support file stat.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 37 ++++++++++++++++++++++++++-----------
 fio.1     | 34 +++++++++++++++++++++-------------
 2 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 05fc117f..b2750b56 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2780,41 +2780,56 @@ with the caveat that when used on the command line, they must come after the
 	Select the xnvme async command interface. This can take these values.
 
 	**emu**
-		This is default and used to emulate asynchronous I/O.
+		This is default and use to emulate asynchronous I/O by using a
+		single thread to create a queue pair on top of a synchronous
+		I/O interface using the NVMe driver IOCTL.
 	**thrpool**
-		Use thread pool for Asynchronous I/O.
+		Emulate an asynchronous I/O interface with a pool of userspace
+		threads on top of a synchronous I/O interface using the NVMe
+		driver IOCTL. By default four threads are used.
 	**io_uring**
-		Use Linux io_uring/liburing for Asynchronous I/O.
+		Linux native asynchronous I/O interface which supports both
+		direct and buffered I/O.
+	**io_uring_cmd**
+		Fast Linux native asynchronous I/O interface for NVMe pass
+		through commands. This only works with NVMe character device
+		(/dev/ngXnY).
 	**libaio**
 		Use Linux aio for Asynchronous I/O.
 	**posix**
-		Use POSIX aio for Asynchronous I/O.
+		Use the posix asynchronous I/O interface to perform one or
+		more I/O operations asynchronously.
 	**nil**
-		Use nil-io; For introspective perf. evaluation
+		Do not transfer any data; just pretend to. This is mainly used
+		for introspective performance evaluation.
 
 .. option:: xnvme_sync=str : [xnvme]
 
 	Select the xnvme synchronous command interface. This can take these values.
 
 	**nvme**
-		This is default and uses Linux NVMe Driver ioctl() for synchronous I/O.
+		This is default and uses Linux NVMe Driver ioctl() for
+		synchronous I/O.
 	**psync**
-		Use pread()/write() for synchronous I/O.
+		This supports regular as well as vectored pread() and pwrite()
+		commands.
+	**block**
+		This is the same as psync except that it also supports zone
+		management commands using Linux block layer IOCTLs.
 
 .. option:: xnvme_admin=str : [xnvme]
 
 	Select the xnvme admin command interface. This can take these values.
 
 	**nvme**
-		This is default and uses linux NVMe Driver ioctl() for admin commands.
+		This is default and uses linux NVMe Driver ioctl() for admin
+		commands.
 	**block**
 		Use Linux Block Layer ioctl() and sysfs for admin commands.
-	**file_as_ns**
-		Use file-stat to construct NVMe idfy responses.
 
 .. option:: xnvme_dev_nsid=int : [xnvme]
 
-	xnvme namespace identifier, for userspace NVMe driver.
+	xnvme namespace identifier for userspace NVMe driver, such as SPDK.
 
 .. option:: xnvme_iovec=int : [xnvme]
 
diff --git a/fio.1 b/fio.1
index 6630525f..f3f3dc5d 100644
--- a/fio.1
+++ b/fio.1
@@ -2530,22 +2530,29 @@ Select the xnvme async command interface. This can take these values.
 .RS
 .TP
 .B emu
-This is default and used to emulate asynchronous I/O
+This is default and use to emulate asynchronous I/O by using a single thread to
+create a queue pair on top of a synchronous I/O interface using the NVMe driver
+IOCTL.
 .TP
 .BI thrpool
-Use thread pool for Asynchronous I/O
+Emulate an asynchronous I/O interface with a pool of userspace threads on top
+of a synchronous I/O interface using the NVMe driver IOCTL. By default four
+threads are used.
 .TP
 .BI io_uring
-Use Linux io_uring/liburing for Asynchronous I/O
+Linux native asynchronous I/O interface which supports both direct and buffered
+I/O.
 .TP
 .BI libaio
 Use Linux aio for Asynchronous I/O
 .TP
 .BI posix
-Use POSIX aio for Asynchronous I/O
+Use the posix asynchronous I/O interface to perform one or more I/O operations
+asynchronously.
 .TP
 .BI nil
-Use nil-io; For introspective perf. evaluation
+Do not transfer any data; just pretend to. This is mainly used for
+introspective performance evaluation.
 .RE
 .RE
 .TP
@@ -2555,10 +2562,14 @@ Select the xnvme synchronous command interface. This can take these values.
 .RS
 .TP
 .B nvme
-This is default and uses Linux NVMe Driver ioctl() for synchronous I/O
+This is default and uses Linux NVMe Driver ioctl() for synchronous I/O.
 .TP
 .BI psync
-Use pread()/write() for synchronous I/O
+This supports regular as well as vectored pread() and pwrite() commands.
+.TP
+.BI block
+This is the same as psync except that it also supports zone management
+commands using Linux block layer IOCTLs.
 .RE
 .RE
 .TP
@@ -2568,18 +2579,15 @@ Select the xnvme admin command interface. This can take these values.
 .RS
 .TP
 .B nvme
-This is default and uses Linux NVMe Driver ioctl() for admin commands
+This is default and uses Linux NVMe Driver ioctl() for admin commands.
 .TP
 .BI block
-Use Linux Block Layer ioctl() and sysfs for admin commands
-.TP
-.BI file_as_ns
-Use file-stat as to construct NVMe idfy responses
+Use Linux Block Layer ioctl() and sysfs for admin commands.
 .RE
 .RE
 .TP
 .BI (xnvme)xnvme_dev_nsid\fR=\fPint
-xnvme namespace identifier, for userspace NVMe driver.
+xnvme namespace identifier for userspace NVMe driver such as SPDK.
 .TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
-- 
2.17.1

