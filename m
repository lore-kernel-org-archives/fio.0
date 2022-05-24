Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164BBC433FE
	for <fio@archiver.kernel.org>; Tue, 24 May 2022 14:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiEXOXh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 May 2022 10:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbiEXOXd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 May 2022 10:23:33 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6394A62BD2
        for <fio@vger.kernel.org>; Tue, 24 May 2022 07:23:31 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220524142326usoutp012b97b96484a90d012b0a2d27d339f0bb~yEIv0Do5j1431114311usoutp01P;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220524142326usoutp012b97b96484a90d012b0a2d27d339f0bb~yEIv0Do5j1431114311usoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653402206;
        bh=Z9O0Q6kDYvont8y1hOs/1sZQfQUc6HK6cwqYZbYnZIk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=I1m+pjWyzLxezfChqUW1ncDtil8Oaln/ZNjyNHMXt0/NNJai38jAS20ebuZSxnN2Z
         tsn/xekrDME1GjZew0hbiUiS8hrZfvuHHZCJBjRreAtP3OuP5i+dvaGDui7thYl7Qq
         KgvLIgivtyRvxjS+KRFr93CBj3IVv8qY/bDRi+0Y=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p1ef948ecdb2110a790a73ea83306b68c2~yEIvtpXA52168621686uscas1p1R;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id BD.C3.09749.E5AEC826; Tue,
        24 May 2022 10:23:26 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p130d78e36a5aa36964068cde26412f4ae~yEIvgR8FQ1920819208uscas1p1e;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-4c-628cea5edd7b
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id F6.77.52945.D5AEC826; Tue,
        24 May 2022 10:23:25 -0400 (EDT)
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
Subject: [PATCH v2 4/5] t/run-fio-tests: improve json data decoding
Thread-Topic: [PATCH v2 4/5] t/run-fio-tests: improve json data decoding
Thread-Index: AQHYb3nUdg2B6LYnlU+auZ0+TK8TFw==
Date:   Tue, 24 May 2022 14:23:24 +0000
Message-ID: <20220524142229.135808-5-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7pxr3qSDCbfF7ZYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVMf/1FJaChbwV/UevsjQwHuTsYuTkkBAwkdj5
        dR1bFyMXh5DASkaJuZt72UASQgKtTBLfdxR0MXKAFS07YgZRs5ZR4tS2G1ANnxglXu7eDuUs
        Y5R40tvOCtLBJqAp8XZ/AcggEYEwiZ+PtrOC2MwC6hLHNm4AWyAs4Cxx79RZFogaD4mO89+Y
        IGw9iQt3vzCC2CwCqhI73m4Ci/MK2EicO3+NEWQ8p4CtxMIfsiBhRgExie+n1jBBjBeXuPVk
        PhPEY4ISi2bvYYawxST+7XrIBmErStz//pIdol5P4sbUKWwQtrbEsoWvmSFWCUqcnPmEBaJe
        UuLgihssIC9KCHRySNze/5MRIuEiMWfBD6giaYnpay5DFbUDQ3HjF6jEBEaJ60+kIGxriX+d
        16A280n8/fWIcQKj8iwkh89CctQsJEfNQnLUAkaWVYzipcXFuempxcZ5qeV6xYm5xaV56XrJ
        +bmbGIEp4/S/wwU7GG/d+qh3iJGJg/EQowQHs5IIb0pYT5IQb0piZVVqUX58UWlOavEhRmkO
        FiVx3mWZGxKFBNITS1KzU1MLUotgskwcnFINTEdN9sdIX+5YulpDyfoTD1e8kYxc7bf01yJy
        7l+8t15lEQ38Gnk/MWr6R+Fco38/5/NM1qoQatxxeM/dgHVLGMSfWuaLJKk1n+sSfDDz6sfg
        F3ZBfT12SQsXqq0xPK6V4aAzR2/aplYFuwrx2tO/pFPnG9ccKVnSYvhxn440y+Glfqf4PQ1u
        5E/mE7zWVP7meoNEl4riFtkmCZnlalVyP9c8vmYUsVdy/zan00VPhEzC7yvsqg464/fu2BK2
        qwaKDNMaOiy5uS9Ehq5TWp34rkCiyfe9t5vDrssH98vL9+2IPSaiOuVpz/1VNUvPrVrYvkA/
        fdf/9XnW69fXZv6Z6i2kxNexoqJN7cGNevZsJZbijERDLeai4kQAwLKgwYgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LJbGCaqBv3qifJYMoyZovVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZ819PYSlYyFvRf/QqSwPjQc4uRg4OCQETiWVH
        zLoYOTmEBFYzSrz5It7FyAVkf2KUuLjlKBOEs4xR4uGHl2wgDWwCmhJv9xeANIgIhEn8fLSd
        FcRmFlCXOLZxAxuILSzgLHHv1FkWiBoPiY7z35ggbD2JC3e/MILYLAKqEjvebgKL8wrYSJw7
        f40R4ggbiaM39oCt4hSwlVj4QxYkzCggJvH91BomiFXiEreezAezJQQEJJbsOc8MYYtKvHz8
        jxXCVpS4//0lO0S9nsSNqVPYIGxtiWULXzNDrBWUODnzCQtEvaTEwRU3WCYwis9CsmIWkvZZ
        SNpnIWlfwMiyilG8tLg4N72i2DgvtVyvODG3uDQvXS85P3cTIzCmTv87HLOD8d6tj3qHGJk4
        GA8xSnAwK4nwpoT1JAnxpiRWVqUW5ccXleakFh9ilOZgURLn9YidGC8kkJ5YkpqdmlqQWgST
        ZeLglGpgOmpxyvfC16sVhx91uZmpaEjo5E6fNDnvaXZpl3XKa5nTV9Iu+qxZz3xO6NvVoIVp
        aWfebnRTTgh8tU3HaPM9kRP5LJ9cbOfvkkk8w8pkmuhn0axwcu/sElMVaw+5wptadtMTOQ8u
        cnjsHFi5JT651/KbT+TF1at+vyhX88o7Hved8d+F5XVqHts4c5e+v3t6z4SCVoGHv5bMj2B5
        wGC01rw9XOLBtxV7D/RFeT1UOa54qZ/hcaHKT7Ut/hI+tQ4LPuqLfn4oeS1MTL5+anKt0pVF
        28QrNnx5a/F2xtn/1Zmcy01MnmmzMx0Nc5i/8vtq5Q+cQQsO+MW+frZ609T539ZfC99QkVv3
        dpbEsXKWSCWW4oxEQy3mouJEAOxNYxgYAwAA
X-CMS-MailID: 20220524142326uscas1p130d78e36a5aa36964068cde26412f4ae
CMS-TYPE: 301P
X-CMS-RootMailID: 20220524142326uscas1p130d78e36a5aa36964068cde26412f4ae
References: <20220524142229.135808-1-vincent.fu@samsung.com>
        <CGME20220524142326uscas1p130d78e36a5aa36964068cde26412f4ae@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Instead of skipping up to five lines, just skip everything until the
opening curly brace when trying to decode JSON data.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/run-fio-tests.py | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index ecceb67e..32cdbc19 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -311,21 +311,15 @@ class FioJobTest(FioExeTest):
         #
         # Sometimes fio informational messages are included at the top of =
the
         # JSON output, especially under Windows. Try to decode output as J=
SON
-        # data, lopping off up to the first four lines
+        # data, skipping everything until the first {
         #
         lines =3D file_data.splitlines()
-        for i in range(5):
-            file_data =3D '\n'.join(lines[i:])
-            try:
-                self.json_data =3D json.loads(file_data)
-            except json.JSONDecodeError:
-                continue
-            else:
-                logging.debug("Test %d: skipped %d lines decoding JSON dat=
a", self.testnum, i)
-                return
-
-        self.failure_reason =3D "{0} unable to decode JSON data,".format(s=
elf.failure_reason)
-        self.passed =3D False
+        file_data =3D '\n'.join(lines[lines.index("{"):])
+        try:
+            self.json_data =3D json.loads(file_data)
+        except json.JSONDecodeError:
+            self.failure_reason =3D "{0} unable to decode JSON data,".form=
at(self.failure_reason)
+            self.passed =3D False
=20
=20
 class FioJobTest_t0005(FioJobTest):
--=20
2.25.1
