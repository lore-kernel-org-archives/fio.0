Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCBAC433EF
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiEWSct (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbiEWSce (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:32:34 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F2F69491
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:07:03 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175714usoutp01a7adb59db8d5d770ff1ef7cec25710b0~xzaIOiVg11112211122usoutp01f;
        Mon, 23 May 2022 17:57:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220523175714usoutp01a7adb59db8d5d770ff1ef7cec25710b0~xzaIOiVg11112211122usoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328634;
        bh=c3USjcGzZ6kuYp3a8HoVtMA9rPqOsaFC0jP6dTrME9A=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=fEIXHMJ+hG/3SU+KbN6AZyKjj7qogQb0f3z+7jnJ4qFxoCzC/oGiuFWLpm6z+H23d
         3C8A7l6EcjWSeamx2g2118ihEpQRTS13LWVGH7y2xCx6FMKEWrB/YrnHJ1pz8OW3hw
         RM/vdEY/GEHIzFxqndoASCz2EA9rZR6PyFhpGo6k=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220523175714uscas1p178e3e369586d853fe7cb4c46c20feeb9~xzaIGn07E1006110061uscas1p1T;
        Mon, 23 May 2022 17:57:14 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 63.D1.09749.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1~xzaH0d6Hw2338823388uscas1p1G;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-b9-628bcaf943db
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id BF.4C.52349.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 10:57:12 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 10:57:12 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 5/6] mem: try to parse /proc/meminfo to get huge page size
Thread-Topic: [PATCH 5/6] mem: try to parse /proc/meminfo to get huge page
        size
Thread-Index: AQHYbs6Hmcsriz4iOkKkJvgIZCyMCw==
Date:   Mon, 23 May 2022 17:57:12 +0000
Message-ID: <20220523175650.130895-6-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87o/T3UnGWzusrBYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVcWiRXcFK4YplJ2ayNzDu4O9i5OSQEDCRuNL7
        jLWLkYtDSGAlo8T5A3vYIZxWJon315exwVR9W3GOGcQWEljLKNHxXB2i6BOjxNMTTxghnGWM
        Ej8vfwCq4uBgE9CUeLu/AKRBRCBM4uej7awgNrOAusSxjRvAhgoLeEnMv9jPAlIuIhAo8f02
        M0S5nsSxzv0sIDaLgKrEon9XGUFsXgEbiSP7poPZnAK2EjsXfWYHsRkFxCS+n1rDBDFeXOLW
        k/lMEDcLSiyavYcZwhaT+LfrIdQvihL3v79kh6jXk7gxdQobhK0tsWzha2aIXYISJ2c+YYGo
        l5Q4uOIGC8iLEgK9HBJnFi+BWuAise3zdFYIW1ri6vWpzBBF7YwSczd+geqewChx/YkUhG0t
        8a/zGtRmPom/vx4xTmBUnoXk8FlIjpqF5KhZSI5awMiyilG8tLg4Nz212DgvtVyvODG3uDQv
        XS85P3cTIzBlnP53uGAH461bH/UOMTJxMB5ilOBgVhLh3Z7YkSTEm5JYWZValB9fVJqTWnyI
        UZqDRUmcd1nmhkQhgfTEktTs1NSC1CKYLBMHp1QD02RtiRXfPe+ElCze/96tNEn6hutVp29a
        Tqtc79rVRxd8t+foWbF9z/fT21Jf/zq01nfNtbCHf5dELVuZnjbxrNgW50fHFDylQjy+Bi+1
        nWtgvWvat82B/fOWfcxiV7z88L/giRXneM92p9k89lQQ6v0oxZu/pFrdzv5MAof0XPu6JZGr
        0qcWXpm9v1GFdyr/keRb+azr35nMX2XRbzJzuoPIibfsGiJd6Q+kb95Rdnxt/LD1tuy9uz1P
        vi390Jzx5tP3yStW78+sC59RaSZaXLpkx/kJO+4LPOnLdwxT+bb7wAQFEdklF84+Y3KddarR
        lcH/yio2k135xmK1k1988NR+MOnOJf/C6azdNrW1BY5KLMUZiYZazEXFiQCPqWLniAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqPvzVHeSwc3PShar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyDi2yK1gpXLHsxEz2BsYd/F2MnBwSAiYS31ac
        Y+5i5OIQEljNKLHh03sWCOcTo8Tzj1vYIZxljBK/Lr9j6mLk4GAT0JR4u78ApFtEIEzi56Pt
        rCA2s4C6xLGNG9hAbGEBL4n5F/tZIGoCJRa92MkMYetJHOvcDxZnEVCVWPTvKiOIzStgI3Fk
        33QwWwjI/vqlA6yGU8BWYueiz+wgNqOAmMT3U2uYIHaJS9x6Mp8J4gMBiSV7zjND2KISLx//
        Y4WwFSXuf3/JDlGvJ3Fj6hQ2CFtbYtnC18wQewUlTs58wgJRLylxcMUNlgmM4rOQrJiFpH0W
        kvZZSNoXMLKsYhQvLS7OTa8oNsxLLdcrTswtLs1L10vOz93ECIyr0/8OR+5gPHrro94hRiYO
        xkOMEhzMSiK82xM7koR4UxIrq1KL8uOLSnNSiw8xSnOwKInzCrlOjBcSSE8sSc1OTS1ILYLJ
        MnFwSjUwnTHOnMu1+fYTvcKESV9XHjScc7zVXG7NyRuhJ9fYreO4drl0g6nKlvke98TvXwmK
        7tawro+vZhT57dKYI7BpN+sla1mTuX1/hf9vfHiLjdur8Fsb32rGz2/8exp/Xdzw+dArtiJh
        uSXTfkf8fNx3Rvx16+WKK7P19uy12Vvvcyo2y65l4aYZ/v9n9BiIbJOWfL9msekqRd4VZ487
        CrcGltou1uaa/p07YerdlVMbcmauTTp3Y0nhn4y7c+Kn27xIV9oaFPfWSjvQKnfPLh7uo70t
        b7PTTSIOLdddyJll+O3JJxebxw8/nHbksPslt+dNd8K8r1O5U01MFn5Vj+ZRmDN5oRmb1AK2
        c2df/eI9d1GJpTgj0VCLuag4EQDB+Vt7GgMAAA==
X-CMS-MailID: 20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Instead of relying on a platform-specific default huge page size, try to
parse /proc/meminfo to get the huge page size when it is not explicitly
specified as an option.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 memory.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/memory.c b/memory.c
index 6cf73333..3b58e0bc 100644
--- a/memory.c
+++ b/memory.c
@@ -2,6 +2,7 @@
  * Memory helpers
  */
 #include <fcntl.h>
+#include <ctype.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
@@ -60,13 +61,59 @@ int fio_pin_memory(struct thread_data *td)
 	return 0;
 }
=20
+static unsigned int get_hugepage_size(struct thread_data *td)
+{
+	char buf[2048];
+	FILE *fptr;
+	size_t ret;
+	char *start;
+	unsigned int val;
+
+	if (fio_option_is_set(&td->o, hugepage_size))
+		return td->o.hugepage_size;
+
+	fptr =3D fopen("/proc/meminfo", "r");
+	if (!fptr)
+		return td->o.hugepage_size;
+
+	ret =3D fread(buf, 1, sizeof(buf)-1, fptr);
+	if (!ret)
+		goto out;
+	buf[ret] =3D 0;
+
+	start =3D strstr(buf, "Hugepagesize:");
+	if (!start)
+		goto out;
+	start +=3D strlen("Hugepagesize:");
+	val =3D strtoul(start, NULL, 10);
+	if (!val)
+		goto out;
+
+	/* skip all the spaces and digits */
+	while (*start =3D=3D ' ' || isdigit(*start))
+		start++;
+
+	/* make sure it ends with kB */
+	if (*start++ !=3D 'k')
+		goto out;
+	if (*start++ !=3D 'B')
+		goto out;
+
+	td->o.hugepage_size =3D val * 1024;
+	dprint(FD_MEM, "parsed hugepagesize from /proc/meminfo %u\n", td->o.hugep=
age_size);
+
+out:
+	fclose(fptr);
+	return td->o.hugepage_size;
+}
+
 static int alloc_mem_shm(struct thread_data *td, unsigned int total_mem)
 {
 #ifndef CONFIG_NO_SHM
 	int flags =3D IPC_CREAT | S_IRUSR | S_IWUSR;
=20
 	if (td->o.mem_type =3D=3D MEM_SHMHUGE) {
-		unsigned long mask =3D td->o.hugepage_size - 1;
+		unsigned long mask =3D get_hugepage_size(td) - 1;
=20
 		flags |=3D SHM_HUGETLB;
 		total_mem =3D (total_mem + mask) & ~mask;
@@ -128,7 +175,7 @@ static int alloc_mem_mmap(struct thread_data *td, size_=
t total_mem)
 	td->mmapfd =3D -1;
=20
 	if (td->o.mem_type =3D=3D MEM_MMAPHUGE) {
-		unsigned long mask =3D td->o.hugepage_size - 1;
+		unsigned long mask =3D get_hugepage_size(td) - 1;
=20
 		/* TODO: make sure the file is a real hugetlbfs file */
 		if (!td->o.mmapfile)
--=20
2.25.1
