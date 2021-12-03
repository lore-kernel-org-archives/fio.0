Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B42C433FE
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 21:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbhLCVOj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:14:39 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:42982 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353853AbhLCVOi (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Dec 2021 16:14:38 -0500
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20211203211113usoutp010cd09ed9a5cff0b48753382800f3d998~9WvsA8t-q1743617436usoutp01Y;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20211203211113usoutp010cd09ed9a5cff0b48753382800f3d998~9WvsA8t-q1743617436usoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1638565873;
        bh=u1moXpoCxhHaFngi39nmK/bv7i1wGCMBFQQ5J4Gkbe8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=SU9GyfrSBUzTx1OaIAWaQpqdnZdKYRtYjPMYJ1WwFTgWhf78C4KvOg48UkFdM33aR
         iRDsrSjMGCpbXH+tGXIdAl8oyugwT3sVE8tbok8v8Lqy7dcMejQ48++adO1A3aJbys
         mf+PnKdrwUW8cstR+mdG2rce794Lu3fbGPIxlUUM=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211203211113uscas1p2334933e9eb2473e9c311a615947ea8e8~9Wvr3dvMe1677116771uscas1p2K;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 8D.53.09687.1F78AA16; Fri, 
        3 Dec 2021 16:11:13 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211203211112uscas1p1e12f2c24afadcb54828f9fa31ddd2a69~9Wvrdu3ZU1527015270uscas1p11;
        Fri,  3 Dec 2021 21:11:12 +0000 (GMT)
X-AuditID: cbfec370-9ddff700000025d7-59-61aa87f18a27
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 35.8B.09671.0F78AA16; Fri, 
        3 Dec 2021 16:11:12 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 3 Dec 2021 13:10:10 -0800
Received: from SSI-EX1.ssi.samsung.com ([::1]) by SSI-EX1.ssi.samsung.com
        ([fe80::f93d:5544:8666:3356%7]) with mapi id 15.01.2242.008; Fri, 3 Dec 2021
        13:10:10 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/2] io_ddir: return appropriate string for DDIR_INVAL
Thread-Topic: [PATCH 1/2] io_ddir: return appropriate string for DDIR_INVAL
Thread-Index: AQHX6IonfbgHfcQzQUehBIaT1970GA==
Date:   Fri, 3 Dec 2021 21:10:10 +0000
Message-ID: <20211203211050.51241-2-vincent.fu@samsung.com>
In-Reply-To: <20211203211050.51241-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7of21clGsy9JmWx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr49cK8YKFrBUdP+ewNTBOZ+li5OSQEDCRODx9
        KVMXIxeHkMBKRomPd86yQDitTBL3t2xlh6l6sb8drENIYC2jxKHV5RBFHxgljjdtYYRr/3V3
        M1AHBwebgKbE2/0FIA0iAmESPx9tZwWxmQXUJY5t3MAGYgsLuElMf/iPCaLGW2LfzkmMELae
        xMdXS8DqWQRUJL5t7AezeQWsJbbt+A1mcwrYSOy81cYMYjMKiEl8P7WGCWK+uMStJ/OZII4W
        lFg0ew8zhC0m8W/XQzYIW1Hi/veX7BD1ehI3pk5hg7C1JZYtfM0MsUtQ4uTMJ9AgkpQ4uOIG
        OFQkBBo5JKbMOgi1wEVi4pG1UEXSElevT4Vado5R4sG/YIiG64wSK74sZoVIWEss/LMe6lI+
        ib+/HjFOYFSeheTwWUiOmoXkqFlIjlrAyLKKUby0uDg3PbXYOC+1XK84Mbe4NC9dLzk/dxMj
        MGmc/ne4YAfjrVsf9Q4xMnEwHmKU4GBWEuE1qVyVKMSbklhZlVqUH19UmpNafIhRmoNFSZz3
        9J+GRCGB9MSS1OzU1ILUIpgsEwenVANTn86itlUblMuy6wM5bvkfFxEpXJxxl+3XmtvVuZHe
        S9pt5u9Z+zPDxDj+mnPMFiUBeS7zWku3+Cc2jYlbJrxZ0SLmdN9to61Mpf7W4weWLU2J0MmY
        s6z3i+Ur7oJ+q6kW9+ffd1F8031xqdNUzyuTolwFtihsz1Nc+sd16TNRGQeR5LaTYY3LO2af
        mrfTl/WL6fqaZt2wrP13nnI0bk2Q7kiy2pXm/NX7fK/bUymvitw9S0PfGKy5qmH+NMxw3Zvj
        xzl6NHWX5b9uzXy37jPre5ci0xmHngQx8RbGrt7Jby5yr1jzBI/hrHnXv97RreQwnRrivu+y
        3fefmh+T0+NVuA3tk6dpri/2lxEN2K3EUpyRaKjFXFScCADdrJksiQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqPuhfVWiweYjuhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyfq0QL1jIWtHxcw5bA+N0li5GTg4JAROJF/vb
        gWwuDiGB1YwS96euY4RwPjBKnNi8EcpZySjR3fIbyOHgYBPQlHi7vwCkW0QgTOLno+2sIDaz
        gLrEsY0b2EBsYQE3iekP/zFB1HhL7Ns5iRHC1pP4+GoJWD2LgIrEt439YDavgLXEth2/wWwh
        IPtwxzOw6zgFbCR23mpjBrEZBcQkvp9awwSxS1zi1pP5TBAfCEgs2XOeGcIWlXj5+B8rhK0o
        cf/7S3aIej2JG1OnsEHY2hLLFr5mhtgrKHFy5hNoSEhKHFxxg2UCo/gsJCtmIWmfhaR9FpL2
        BYwsqxjFS4uLc9Mrig3zUsv1ihNzi0vz0vWS83M3MQLj6vS/w5E7GI/e+qh3iJGJg/EQowQH
        s5IIr0nlqkQh3pTEyqrUovz4otKc1OJDjNIcLErivEKuE+OFBNITS1KzU1MLUotgskwcnFIN
        TEEnFtxc8FJ5UWq+stPuaZZVpiWTONSvxjad8aoT2XrjZFKOiU3DTy4/1tcT3bsM77NWMymc
        5bsSJFaVU6jDFW78/9O0V1HPV4dk3xHl+/qkQndqesfkK0fl5OLL2LudvmnMmyYxqc5VQ1T4
        31wN36veG4r0jTZLxhVf2aLI+8CZL1PE/E6D1NZ9LScWyGy+Oevp1a2pcg5eL7XSefNcW7Lk
        Em6oHkxVzFPZ8VTo5N8/6mmhZ8SCJIROKrzLEyoxKWQ9MTl+zq4z7CEbOjaYBXxVnvCY43Hp
        voSnf0oldhfrf7NduVPs2tTfOR7GBmwt7m/9e1W+Mga/2Xq4oU2dUXPC9wuK5fFJtskqxj1K
        LMUZiYZazEXFiQDjVIiLGgMAAA==
X-CMS-MailID: 20211203211112uscas1p1e12f2c24afadcb54828f9fa31ddd2a69
CMS-TYPE: 301P
X-CMS-RootMailID: 20211203211112uscas1p1e12f2c24afadcb54828f9fa31ddd2a69
References: <20211203211050.51241-1-vincent.fu@samsung.com>
        <CGME20211203211112uscas1p1e12f2c24afadcb54828f9fa31ddd2a69@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When looking up the appropriate name for a data direction, make sure the
array index is non-negative. This ensures that we return an appropriate
string for DDIR_INVAL.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 io_ddir.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_ddir.h b/io_ddir.h
index a42da97a..296a9d04 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -24,7 +24,7 @@ static inline const char *io_ddir_name(enum fio_ddir ddir=
)
 					"datasync", "sync_file_range",
 					"wait", };
=20
-	if (ddir < DDIR_LAST)
+	if (ddir >=3D 0 && ddir < DDIR_LAST)
 		return name[ddir];
=20
 	return "invalid";
--=20
2.25.1
