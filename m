Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22722C433F5
	for <fio@archiver.kernel.org>; Tue, 24 May 2022 14:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiEXOXh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 May 2022 10:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiEXOXd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 May 2022 10:23:33 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63887606CF
        for <fio@vger.kernel.org>; Tue, 24 May 2022 07:23:31 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220524142327usoutp026b9b6e9d9ff4d542296ce0ccc9b73d85~yEIwlvYZc2888728887usoutp020;
        Tue, 24 May 2022 14:23:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220524142327usoutp026b9b6e9d9ff4d542296ce0ccc9b73d85~yEIwlvYZc2888728887usoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653402207;
        bh=nIqvQiL6D7471V0XYuoIuXab2ubUvzeTv6Mcsu0sU7o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=jlLWaokQ4St/QLqx1nbKGAyFXZ+d/6JJuWlDPfgz7ZctaSSAEUIC6T5NJBbEUu0t2
         bLsC0DswfMImDFqLJMAMpnI0sZP756n+Gr+Yo/gq3e/fV1aZ+PGsCofPslW/xhmJzE
         bQAesXzMJbSD+4FPEEN60gAg1NNivavntuI/nYuY=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p17a2bc5729cfdb4caca7a25f3d0526e17~yEIwFgKjq2168621686uscas1p1T;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 0E.C3.09749.E5AEC826; Tue,
        24 May 2022 10:23:26 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p27c8cd9fd4f344840227201790f922bb5~yEIvyPoW12647626476uscas1p2q;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
X-AuditID: cbfec370-a6bff70000002615-4f-628cea5ed714
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 27.77.52945.E5AEC826; Tue,
        24 May 2022 10:23:26 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 24 May 2022 07:23:25 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        24 May 2022 07:23:25 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH v2 5/5] docs: update discussion of huge page sizes
Thread-Topic: [PATCH v2 5/5] docs: update discussion of huge page sizes
Thread-Index: AQHYb3nUOny+39wFuky5AohFolyfqA==
Date:   Tue, 24 May 2022 14:23:24 +0000
Message-ID: <20220524142229.135808-6-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7pxr3qSDNZe0bJYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVsWVKccE+9YpdjS9ZGhinyHcxcnJICJhI7O5Z
        ytbFyMUhJLCSUWJ663cmCKeVSaJ56nZWmKq2N+eZIRJrGSWOPP0CVfWJUeLl7u1Q/csYJZ70
        tgO1cHCwCWhKvN1fANItIhAm8fMRxCRmAXWJYxs3sIHYwgJOEjPXn2KFqHGX+HVhEyOErScx
        99IfZhCbRUBVYsfbTUwgNq+AjcSRc+1MIOM5BWwlFv6QBQkzCohJfD+1hglivLjErSfzmSCO
        FpRYNHsPM4QtJvFv10M2CFtR4v73l+wQ9XoSN6ZOYYOwtSWWLXzNDLFKUOLkzCcsEPWSEgdX
        3GABeVFCoJND4t2lRmiouEic/XEcqkhaYvqay1BF7YwSczd+gUpMYJS4/kQKwraW+Nd5DWoz
        n8TfX48YJzAqz0Jy+CwkR81CctQsJEctYGRZxSheWlycm55abJyXWq5XnJhbXJqXrpecn7uJ
        EZg0Tv87XLCD8datj3qHGJk4GA8xSnAwK4nwpoT1JAnxpiRWVqUW5ccXleakFh9ilOZgURLn
        XZa5IVFIID2xJDU7NbUgtQgmy8TBKdXAFPu/PnGa14bZlyyOijw+y1/JzlS9SiUuoWWCCN9T
        2YMf5jU9/XQ1ZkeSesNs45sO5V8+3Z2yLjC740zP3yUuuV7Xfss3C71lcOvJ3PH4NNOp7G+J
        H5in+y/9kPJ3xv2zfXybpzSFT50X8OqVsc3sHO20ieuFeoK5jXN1vCYob3q+PTYlVEK3cnI4
        b07RdKGci5lmP+zmTHPZptnIw7r56JnEhPeFjE76Xmwbtl5pu8s43fPXl21zP+z9w3569vpV
        vYqrPzyYeZ6tSOdu1o4ueXkj8VrrzfYbQi5OcmVM6bpUrZjjuO1A47ekP02H/jN6LwrZIfom
        dv5Mrh9OL9vaIjL830yLX+7JfWERk4zdLiWW4oxEQy3mouJEAEy+Z/+JAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCaqBv3qifJYF2viMXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6MLVOKC/apV+xqfMnSwDhFvouRk0NCwESi7c15
        5i5GLg4hgdWMEl1LvzBBOJ8YJS5uOQrlLGOUePjhJVsXIwcHm4CmxNv9BSDdIgJhEj8fbWcF
        sZkF1CWObdzABmILCzhJzFx/ihWixl3i14VNjBC2nsTcS3+YQWwWAVWJHW83MYHYvAI2EkfO
        tYPZQkD20Rt7wFZxCthKLPwhCxJmFBCT+H5qDRPEKnGJW0/mM0E8ICCxZM95ZghbVOLl43+s
        ELaixP3vL9kh6vUkbkydwgZha0ssW/iaGWKtoMTJmU9YIOolJQ6uuMEygVF8FpIVs5C0z0LS
        PgtJ+wJGllWM4qXFxbnpFcXGeanlesWJucWleel6yfm5mxiBUXX63+GYHYz3bn3UO8TIxMF4
        iFGCg1lJhDclrCdJiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9H7MR4IYH0xJLU7NTUgtQimCwT
        B6dUA1Og/LtJYtFtKw8dUzz6Wv2U7YzbIopsW73FWBZVneS+/nNRnHt91dZNzh6sP1/pu3ux
        7i/q81ypVD33yJ7ry9zmbT6k96qm50ox48X1Ln27zpnmzv6TP3vP25+2b/u23MgUsvc6/EnV
        v3g1dxDjx/cnRWfM1hYLWPr0oFn7s+v7Vz2wycyRq3+tc/zf4ie2W35/DFV5qXX1f9Ksx2s8
        Ms/PryyraHZPe/ym+OHv+F/fn0hHbz9vJVmxRqr0UVmlSnc270+umKuRf1mjuE4wdPu1nXjC
        svZwfKqClPTLW1m75U680Y87NKtXIuB7R4fKtElMOmG7ny7pfiLsdkxdje33j0MlQs5/p8X9
        nHj4xrSnSizFGYmGWsxFxYkAc6xZ1hkDAAA=
X-CMS-MailID: 20220524142326uscas1p27c8cd9fd4f344840227201790f922bb5
CMS-TYPE: 301P
X-CMS-RootMailID: 20220524142326uscas1p27c8cd9fd4f344840227201790f922bb5
References: <20220524142229.135808-1-vincent.fu@samsung.com>
        <CGME20220524142326uscas1p27c8cd9fd4f344840227201790f922bb5@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Note that the default huge page size is either 2 or 4 MiB, depending on
the platform. Also mention /sys/kernel/mm/hugepages/ as another place to
see the supported huge page sizes.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst | 25 ++++++++++++++-----------
 fio.1     | 19 ++++++++++---------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index eee386c1..58d02fa2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1823,13 +1823,14 @@ Buffers and memory
 	**mmaphuge** to work, the system must have free huge pages allocated. Thi=
s
 	can normally be checked and set by reading/writing
 	:file:`/proc/sys/vm/nr_hugepages` on a Linux system. Fio assumes a huge p=
age
-	is 4MiB in size. So to calculate the number of huge pages you need for a
-	given job file, add up the I/O depth of all jobs (normally one unless
-	:option:`iodepth` is used) and multiply by the maximum bs set. Then divid=
e
-	that number by the huge page size. You can see the size of the huge pages=
 in
-	:file:`/proc/meminfo`. If no huge pages are allocated by having a non-zer=
o
-	number in `nr_hugepages`, using **mmaphuge** or **shmhuge** will fail. Al=
so
-	see :option:`hugepage-size`.
+        is 2 or 4MiB in size depending on the platform. So to calculate th=
e
+        number of huge pages you need for a given job file, add up the I/O
+        depth of all jobs (normally one unless :option:`iodepth` is used) =
and
+        multiply by the maximum bs set. Then divide that number by the hug=
e
+        page size. You can see the size of the huge pages in
+        :file:`/proc/meminfo`. If no huge pages are allocated by having a
+        non-zero number in `nr_hugepages`, using **mmaphuge** or **shmhuge=
**
+        will fail. Also see :option:`hugepage-size`.
=20
 	**mmaphuge** also needs to have hugetlbfs mounted and the file location
 	should point there. So if it's mounted in :file:`/huge`, you would use
@@ -1848,10 +1849,12 @@ Buffers and memory
=20
 .. option:: hugepage-size=3Dint
=20
-	Defines the size of a huge page. Must at least be equal to the system
-	setting, see :file:`/proc/meminfo`. Defaults to 4MiB.  Should probably
-	always be a multiple of megabytes, so using ``hugepage-size=3DXm`` is the
-	preferred way to set this to avoid setting a non-pow-2 bad value.
+        Defines the size of a huge page. Must at least be equal to the sys=
tem
+        setting, see :file:`/proc/meminfo` and
+        :file:`/sys/kernel/mm/hugepages/`. Defaults to 2 or 4MiB depending=
 on
+        the platform.  Should probably always be a multiple of megabytes, =
so
+        using ``hugepage-size=3DXm`` is the preferred way to set this to a=
void
+        setting a non-pow-2 bad value.
=20
 .. option:: lockmem=3Dint
=20
diff --git a/fio.1 b/fio.1
index ded7bbfc..5f057574 100644
--- a/fio.1
+++ b/fio.1
@@ -1631,11 +1631,11 @@ multiplied by the I/O depth given. Note that for \f=
Bshmhuge\fR and
 \fBmmaphuge\fR to work, the system must have free huge pages allocated. Th=
is
 can normally be checked and set by reading/writing
 `/proc/sys/vm/nr_hugepages' on a Linux system. Fio assumes a huge page
-is 4MiB in size. So to calculate the number of huge pages you need for a
-given job file, add up the I/O depth of all jobs (normally one unless
-\fBiodepth\fR is used) and multiply by the maximum bs set. Then divide
-that number by the huge page size. You can see the size of the huge pages =
in
-`/proc/meminfo'. If no huge pages are allocated by having a non-zero
+is 2 or 4MiB in size depending on the platform. So to calculate the number=
 of
+huge pages you need for a given job file, add up the I/O depth of all jobs
+(normally one unless \fBiodepth\fR is used) and multiply by the maximum bs=
 set.
+Then divide that number by the huge page size. You can see the size of the=
 huge
+pages in `/proc/meminfo'. If no huge pages are allocated by having a non-z=
ero
 number in `nr_hugepages', using \fBmmaphuge\fR or \fBshmhuge\fR will fail.=
 Also
 see \fBhugepage\-size\fR.
 .P
@@ -1655,10 +1655,11 @@ of subsequent I/O memory buffers is the sum of the =
\fBiomem_align\fR and
 \fBbs\fR used.
 .TP
 .BI hugepage\-size \fR=3D\fPint
-Defines the size of a huge page. Must at least be equal to the system
-setting, see `/proc/meminfo'. Defaults to 4MiB. Should probably
-always be a multiple of megabytes, so using `hugepage\-size=3DXm' is the
-preferred way to set this to avoid setting a non-pow-2 bad value.
+Defines the size of a huge page. Must at least be equal to the system sett=
ing,
+see `/proc/meminfo' and `/sys/kernel/mm/hugepages/'. Defaults to 2 or 4MiB
+depending on the platform. Should probably always be a multiple of megabyt=
es,
+so using `hugepage\-size=3DXm' is the preferred way to set this to avoid s=
etting
+a non-pow-2 bad value.
 .TP
 .BI lockmem \fR=3D\fPint
 Pin the specified amount of memory with \fBmlock\fR\|(2). Can be used to
--=20
2.25.1
