Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F6AC4332F
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243361AbiEWS1k (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343636AbiEWS1a (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:27:30 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54253134E28
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:03:07 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175713usoutp024387f5957f7f07ba8755b91ba468a32d~xzaHnzy8S2760727607usoutp027;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220523175713usoutp024387f5957f7f07ba8755b91ba468a32d~xzaHnzy8S2760727607usoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328633;
        bh=UcFD0i3NOiIKiAoyJK6SpWI658+alFrr/u2cB/7CXeE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=I1CcWcqCqXIFPp8NvxkYzf8bHELMqXOc9M+SJMNUmKHuWloxhQzGfAFs3GuURPr/B
         +z88AlNlzGY7sbzJishptD+sPrrHG7natPR00A2LB34XtGKTafSSAT3ox661Qf2yFr
         mNrgJyfClPjb9bRPiSQIJRhMHy3VkhNMXnAOw0FQ=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p273cc8c5eda8a63539cee47396c9531a3~xzaHf1XGD2431024310uscas1p2S;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id DF.94.09760.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p2f3ee56d2e2f5918b12be64634d6b818b~xzaHOiqUh0405304053uscas1p2d;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-20-628bcaf92e77
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 43.5D.57470.8FACB826; Mon,
        23 May 2022 13:57:12 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 10:57:12 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 10:57:12 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/6] configure: refer to zlib1g-dev package for zlib support
Thread-Topic: [PATCH 2/6] configure: refer to zlib1g-dev package for zlib
        support
Thread-Index: AQHYbs6HF+4Vip+vTEmVJReKhuoPOg==
Date:   Mon, 23 May 2022 17:57:11 +0000
Message-ID: <20220523175650.130895-3-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djXc7o/T3UnGfxaLmix+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY83LHWwFbWwVF5atYGlgfMPSxcjJISFgIjHn
        13kgm4tDSGAlo8TCO2fZIZxWJomdB84zw1QtnP+fESKxllFiXdcnqJZPjBKLzvyDcpYxSvy8
        /AGohYODTUBT4u3+ApBuEYEwiZ+PtrOC2MwC6hLHNm5gA7GFBXwkptz4ywhREyxx79gSRpBW
        EQE9iS/TTEDCLAKqEm9v3AYr5xWwkXgz6ynYQZwCthI7F31mB7EZBcQkvp9awwQxXlzi1pP5
        TBBHC0osmr0H6gExiX+7HrJB2IoS97+/ZIeo15O4MXUKG4StLbFs4WtmiF2CEidnPoEGkaTE
        wRU3wF6UEOjlkDjQ95kVIuEicefVFqgF0hJ/7y5jgihqZ5SYu/ELVPcERonrT6QgbGuJf53X
        oDbzSfz99YhxAqPyLCSHz0Jy1CwkR81CctQCRpZVjOKlxcW56anFhnmp5XrFibnFpXnpesn5
        uZsYgWnj9L/DuTsYd9z6qHeIkYmD8RCjBAezkgjv9sSOJCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8yzI3JAoJpCeWpGanphakFsFkmTg4pRqYdkaXBH4q095/TmTW1yNtH886tSoK1kvcZqkS
        mfvGTEXs7N2JWVnbbzDZG/vOYW5WO3V81Tezt1MfR3796X/qj9vNqFOuH9PctS7vihOevbdA
        Wuex8hze92u+cr2ayrNTLOiGXNYyhpNrPEwbRDm3F5t3yS9/YHt+05Tbyndm3Z4V4sb2TDZ2
        Zzyf6f2wKwdDZvh48U6auEdHnGPez0OTp86aYJx74Kx/nhLvwbXFC6XO87/6eiWISVmAXf3t
        /z0OvHXpBTkHPnCWXphsfOOK+2mb6Xw3F0cbdV2WdeP89LPuWFLFgcWfn/LkK5l2B2fnb1ZP
        6Nnc8KVjf5vdDIFnB2umxE/NO/w752O4rltwlxJLcUaioRZzUXEiACUsDKuKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqPvjVHeSwePfFhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgy1rzcwVbQxlZxYdkKlgbGNyxdjJwcEgImEgvn
        /2fsYuTiEBJYzSixt/MNK4TziVHi1LNJLBDOMkaJX5ffMXUxcnCwCWhKvN1fANItIhAm8fPR
        dlYQm1lAXeLYxg1sILawgI/ElBt/GSFqgiW2bF7FCNIqIqAn8WWaCUiYRUBV4u2N22DlvAI2
        Em9mPWUGsYWA7K9fOsCO4xSwldi56DM7iM0oICbx/dQaJohV4hK3nsxngnhAQGLJnvPMELao
        xMvH/1ghbEWJ+99fskPU60ncmDqFDcLWlli28DUzxF5BiZMzn0ADQlLi4IobLBMYxWchWTEL
        SfssJO2zkLQvYGRZxSheWlycm15RbJSXWq5XnJhbXJqXrpecn7uJERhXp/8djt7BePvWR71D
        jEwcjIcYJTiYlUR4tyd2JAnxpiRWVqUW5ccXleakFh9ilOZgURLnfRk1MV5IID2xJDU7NbUg
        tQgmy8TBKdXAtI3VQPPXnnb1gtXhb/x4hfjjT37S1LqyUVX01bwIWbNVO3Q3+Ad3KgtGLrlT
        n/ncSzZxnofTk1uXTzKnRkRvTklXvDtPeH3jNuaK1aV5n00fTdTYcC4tvFJQuKP1iGnc2rvR
        74UadxefLvIse+d0pLNvst1cBT/7tsgaGxd51tT5MpPU9tyKKpty+J7a043L919jPrpx8a+o
        opKGw9WtiX9msiY0qyWfKdoce6qoarrJNo2NCnrfC5ZrKl2Oz1vyu/vYwrN8KoV7V9uIZD7q
        E/uTyhqU0fuRs31rmjnniakVDD0Lfy2dmanynIVRZaGwE496afH/3fxWkrWJdxsjr9oV77r3
        8cJB47hG/w1KLMUZiYZazEXFiQBgHXWWGgMAAA==
X-CMS-MailID: 20220523175713uscas1p2f3ee56d2e2f5918b12be64634d6b818b
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175713uscas1p2f3ee56d2e2f5918b12be64634d6b818b
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175713uscas1p2f3ee56d2e2f5918b12be64634d6b818b@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent Debian-based distributions provide zlib support in the zlib1g-dev
package.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 95b60bb7..4ee536a0 100755
--- a/configure
+++ b/configure
@@ -3142,7 +3142,7 @@ if test "$libzbc" =3D "yes" ; then
   output_sym "CONFIG_LIBZBC"
 fi
 if test "$zlib" =3D "no" ; then
-  echo "Consider installing zlib-dev (zlib-devel, some fio features depend=
 on it."
+  echo "Consider installing zlib1g-dev (zlib-devel) as some fio features d=
epend on it."
   if test "$build_static" =3D "yes"; then
     echo "Note that some distros have separate packages for static librari=
es."
   fi
--=20
2.25.1
