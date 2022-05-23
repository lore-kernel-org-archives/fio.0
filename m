Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39C2C433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241321AbiEWSXb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244569AbiEWSVr (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:21:47 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE5BDFF77
        for <fio@vger.kernel.org>; Mon, 23 May 2022 10:57:46 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175714usoutp02b0f39b5752cf2ddb3296c0eebbc9577c~xzaIXSsGu2714627146usoutp02J;
        Mon, 23 May 2022 17:57:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220523175714usoutp02b0f39b5752cf2ddb3296c0eebbc9577c~xzaIXSsGu2714627146usoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328634;
        bh=SB/hJtAYPqWCWNptnKAqHmHlq54WwCgIVno7VfEC5V0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=hDYkqsu2616MhCu5uePRi6nQbFVQStAXlEK9/MdvrU4y9uAwmA8xJWGyhV0yGQl/d
         zljQvwNLRWKJ3ITId0E5ZVflk9ylwYZSYeSNAySS6B6pSEyLDL4QUOlWQ1w56Hizn9
         vKlHCxaGAqH61bUrLSEK4dneMe7ytJUfbziAn4Ps=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175714uscas1p22cdc11aed91867478204c86ef99b4256~xzaIPe25P2490624906uscas1p2L;
        Mon, 23 May 2022 17:57:14 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 40.A4.09760.AFACB826; Mon,
        23 May 2022 13:57:14 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p26b156f466662f82746e78f1673e4461a~xzaIATAfO0404904049uscas1p26;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-23-628bcafafe5d
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id EA.8C.52945.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 10:57:13 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 10:57:13 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 6/6] docs: update for huge page size parsing
Thread-Topic: [PATCH 6/6] docs: update for huge page size parsing
Thread-Index: AQHYbs6Hei9slfmHO0WfcyJcH7AtaA==
Date:   Mon, 23 May 2022 17:57:12 +0000
Message-ID: <20220523175650.130895-7-vincent.fu@samsung.com>
In-Reply-To: <20220523175650.130895-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7q/TnUnGbxby2qx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY+PbyILlJhXr/jSyNDBO0exi5OSQEDCRaDh3
        hg3EFhJYySixY7NwFyMXkN3KJNF1rpUJpujbrH9QRWsZJSavVoco+sQoceDLTSYIZxmjxOr/
        z4EcDg42AU2Jt/sLQBpEBMIkfj7azgpiMwuoSxzbuAFskLCAjcS06VeZIWocJdbtPMYCYetJ
        XL78DyzOIqAqsejfVUYQmxeofsqEo2BzOAVsJXYu+swOYjMKiEl8P7WGCWK+uMStJ/OhjhaU
        WDR7DzOELSbxb9dDNghbUeL+95fsEPV6EjemTmGDsLUlli18zQyxS1Di5MwnLBD1khIHV9xg
        AflRQqCTQ+LepCtQQ10k9kzrYISwpSWmr7kMVdTOKDF34xeo7gmMEtefSEHY1hL/Oq9BbeaT
        +PvrEeMERuVZSA6fheSoWUiOmoXkqAWMLKsYxUuLi3PTU4sN81LL9YoTc4tL89L1kvNzNzEC
        U8bpf4dzdzDuuPVR7xAjEwfjIUYJDmYlEd7tiR1JQrwpiZVVqUX58UWlOanFhxilOViUxHmX
        ZW5IFBJITyxJzU5NLUgtgskycXBKNTB18xT0fkq9oChjy2NQs/1X/3wVTe8HS7OebbNTC/X6
        98N5mui98KksrgdPGTM/PSP2hy3gz5yQ5S9U1sxqPVLS8nNCf0lfjKDTFrHzF3abbtwqPevU
        EnHj7dp3874948yqMFrP6PVy96wr67k7lV2tDn9Q2hT2w9c4r+YQD/OOG9Z1KU/O7XrSI9mq
        0uS+WGFOX3nQ1bwTYVOMGQ/ECpv0F/90PG7YpCxU/KXDklUif8U1x6sue69PbJpQ6MORnl/9
        SNLJLWUOd2PjsxdX1nQn7Nf/fiEp6CdLBYN8RUGCtFTEsszSJxMmWD429Q+/v2nHjO23a3b6
        dhyttUiRfHM/JPbk3Ib3Kz5oH7Z98luJpTgj0VCLuag4EQD8927CiAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCapPvzVHeSwbdluhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyNr6NLFhuUrHuTyNLA+MUzS5GTg4JAROJb7P+
        sXUxcnEICaxmlGiYs4EFwvnEKLFl10tWCGcZo8TFY2uYuxg5ONgENCXe7i8A6RYRCJP4+Wg7
        K4jNLKAucWzjBjYQW1jARmLa9KvMEDWOEut2HmOBsPUkLl/+BxZnEVCVWPTvKiOIzQtUP2XC
        UbA5QkD21y8dYPWcArYSOxd9ZgexGQXEJL6fWsMEsUtc4taT+UwQHwhILNlznhnCFpV4+fgf
        K4StKHH/+0t2iHo9iRtTp7BB2NoSyxa+ZobYKyhxcuYTFoh6SYmDK26wTGAUn4VkxSwk7bOQ
        tM9C0r6AkWUVo3hpcXFuekWxcV5quV5xYm5xaV66XnJ+7iZGYFyd/nc4ZgfjvVsf9Q4xMnEw
        HmKU4GBWEuHdntiRJMSbklhZlVqUH19UmpNafIhRmoNFSZzXI3ZivJBAemJJanZqakFqEUyW
        iYNTqoEpMe3Ln8v7Q1SOKYbUzN161lvldlP7NMarskqWyokv8q4Evzn2Tyn2njOPsni/b0Tp
        y1478ZBtTyZvOmbv5ZEwf+2+7SvlWl6qhD9Qc7AVW8G/3SX0rs1vlaMbZrmFXztVnZh+KkRT
        zWuiw35/iSCtBbPC/hSLGHnKz3tVEjBz26pTurOid+97+m2Z6u2A5Ubh/9wvacQ79M8+n3+0
        iWfX0kS2DAYxLtkP+86cjDy3fLn6xEqlN8ECco73th5+oZGQaiTLybv07pRLtRYTOJXm72pN
        uGbfxJnz0PTY3ElRvNkmjZ7Wi0xSX38ok33tUBV+Xry60rn429SeWw6+z1c/uFXbwpb+JaPr
        6pd9NXuVWIozEg21mIuKEwF7w/mSGgMAAA==
X-CMS-MailID: 20220523175713uscas1p26b156f466662f82746e78f1673e4461a
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175713uscas1p26b156f466662f82746e78f1673e4461a
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175713uscas1p26b156f466662f82746e78f1673e4461a@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update the discussion of huge pages to note that fio will try to parse
/proc/meminfo for the hugepage size if it is not specified. Also note
that the default value used when parsing fails is platform specific.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst | 38 ++++++++++++++++++++++----------------
 fio.1     | 29 ++++++++++++++++-------------
 2 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index eee386c1..1e9fa353 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1818,19 +1818,20 @@ Buffers and memory
 			Use GPU memory as the buffers for GPUDirect RDMA benchmark.
 			The :option:`ioengine` must be `rdma`.
=20
-	The area allocated is a function of the maximum allowed bs size for the j=
ob,
-	multiplied by the I/O depth given. Note that for **shmhuge** and
-	**mmaphuge** to work, the system must have free huge pages allocated. Thi=
s
-	can normally be checked and set by reading/writing
-	:file:`/proc/sys/vm/nr_hugepages` on a Linux system. Fio assumes a huge p=
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
-
+        The area allocated is a function of the maximum allowed bs size fo=
r the job,
+        multiplied by the I/O depth given. Note that for **shmhuge** and
+        **mmaphuge** to work, the system must have free huge pages allocat=
ed. This
+        can normally be checked and set by reading/writing
+        :file:`/proc/sys/vm/nr_hugepages` on a Linux system. To calculate =
the
+        number of huge pages you need for a given job file, add up the I/O
+        depth of all jobs (normally one unless :option:`iodepth` is used) =
and
+        multiply by the maximum bs set. Then divide that number by the hug=
e
+        page size. You can see the size of huge pages in
+        :file:`/proc/meminfo`. If no huge pages are allocated by having a
+        non-zero number in `nr_hugepages`, using **mmaphuge** or **shmhuge=
**
+        will fail. See the option :option:`hugepage-size` below to set the
+        hugepage size for fio to use.=20
+       =20
 	**mmaphuge** also needs to have hugetlbfs mounted and the file location
 	should point there. So if it's mounted in :file:`/huge`, you would use
 	`mem=3Dmmaphuge:/huge/somefile`.
@@ -1849,9 +1850,14 @@ Buffers and memory
 .. option:: hugepage-size=3Dint
=20
 	Defines the size of a huge page. Must at least be equal to the system
-	setting, see :file:`/proc/meminfo`. Defaults to 4MiB.  Should probably
-	always be a multiple of megabytes, so using ``hugepage-size=3DXm`` is the
-	preferred way to set this to avoid setting a non-pow-2 bad value.
+        setting, see :file:`/proc/meminfo`. Should probably always be a
+        multiple of megabytes, so using ``hugepage-size=3DXm`` is the pref=
erred
+        way to set this to avoid setting a non-pow-2 bad value. If this op=
tion
+        is not specified fio will attempt to parse :file:`/proc/meminfo` t=
o
+        obtain the system huge page size. If this fails fio will use a pla=
tform
+        specific default of 2-4MiB. This value is used by fio to ensure th=
at
+        the amount of memory requested for I/O buffers will be a multiple =
of
+        the huge page size.
=20
 .. option:: lockmem=3Dint
=20
diff --git a/fio.1 b/fio.1
index ded7bbfc..a7b647bf 100644
--- a/fio.1
+++ b/fio.1
@@ -1629,15 +1629,14 @@ The \fBioengine\fR must be \fBrdma\fR.
 The area allocated is a function of the maximum allowed bs size for the jo=
b,
 multiplied by the I/O depth given. Note that for \fBshmhuge\fR and
 \fBmmaphuge\fR to work, the system must have free huge pages allocated. Th=
is
-can normally be checked and set by reading/writing
-`/proc/sys/vm/nr_hugepages' on a Linux system. Fio assumes a huge page
-is 4MiB in size. So to calculate the number of huge pages you need for a
-given job file, add up the I/O depth of all jobs (normally one unless
-\fBiodepth\fR is used) and multiply by the maximum bs set. Then divide
-that number by the huge page size. You can see the size of the huge pages =
in
-`/proc/meminfo'. If no huge pages are allocated by having a non-zero
-number in `nr_hugepages', using \fBmmaphuge\fR or \fBshmhuge\fR will fail.=
 Also
-see \fBhugepage\-size\fR.
+can normally be checked and set by reading/writing `/proc/sys/vm/nr_hugepa=
ges'
+on a Linux system.  To calculate the number of huge pages you need for a g=
iven
+job file, add up the I/O depth of all jobs (normally one unless \fBiodepth=
\fR
+is used) and multiply by the maximum bs set. Then divide that number by th=
e
+huge page size. You can see the size of the huge pages in `/proc/meminfo'.=
 If
+no huge pages are allocated by having a non-zero number in `nr_hugepages',
+using \fBmmaphuge\fR or \fBshmhuge\fR will fail. See the \fBhugepage\-size=
\fR
+option below to set the huge page size for fio to use.
 .P
 \fBmmaphuge\fR also needs to have hugetlbfs mounted and the file location
 should point there. So if it's mounted in `/huge', you would use
@@ -1655,10 +1654,14 @@ of subsequent I/O memory buffers is the sum of the =
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
+see `/proc/meminfo'. Should probably always be a multiple of megabytes, so
+using `hugepage\-size=3DXm' is the preferred way to set this to avoid sett=
ing a
+non-pow-2 bad value. If this option is not specified fio will attempt to p=
arse
+`/proc/meminfo' to obtain the system huge page size. If this fails, fio wi=
ll
+use a platform-specific default of 2-4MiB. This value is used by fio to en=
sure
+that the amount of memory requested for I/O buffers will be a multiple of =
the
+huge page size.
 .TP
 .BI lockmem \fR=3D\fPint
 Pin the specified amount of memory with \fBmlock\fR\|(2). Can be used to
--=20
2.25.1
