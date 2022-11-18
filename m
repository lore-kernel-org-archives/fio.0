Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49CFC433FE
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 05:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiKRFjG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 00:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiKRFjF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 00:39:05 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED34370A23
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 21:38:56 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221118053854epoutp010734ddb4eb8aef29a2e1d5ad84f6472a~olzlIaQVS0100901009epoutp012
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 05:38:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221118053854epoutp010734ddb4eb8aef29a2e1d5ad84f6472a~olzlIaQVS0100901009epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668749934;
        bh=2/KNGPjzzBr1Qkd92tOAUmxYUkrSBJtDSngv5NMdIvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tkb4+OE++q0TruI5lTaMM35Zz8E8fbhtMMmiUWB26u7/bThKDQkUXf6FdIsdHbFHk
         5lGspcUITXGlTBteYKBg+4f1sFnMBjbd8PldRwFstto9+HdGm5vHrCGVdgCG7cJf2Z
         7YCgz0T7zannyYHbpdTxYp+6ZSYPy20XNl3TkjAo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221118053853epcas5p33cf35bfc4c5dbf146c575bc7d9f681e1~olzkzDoYV0315803158epcas5p3f;
        Fri, 18 Nov 2022 05:38:53 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4ND5Dr40gwz4x9Q6; Fri, 18 Nov
        2022 05:38:52 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.AC.56352.C6A17736; Fri, 18 Nov 2022 14:38:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e~oloy_kSn01432214322epcas5p2G;
        Fri, 18 Nov 2022 05:26:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221118052633epsmtrp2ba40fc9826b4c3e3fe366772e1580ed6~oloy94x-t1039310393epsmtrp2I;
        Fri, 18 Nov 2022 05:26:33 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-8f-63771a6c0bb0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.55.18644.98717736; Fri, 18 Nov 2022 14:26:33 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221118052632epsmtip15268035952abc11165ba12bc0c164904~oloyK4j712451624516epsmtip1R;
        Fri, 18 Nov 2022 05:26:32 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] io_u: fix offset generation for mix of random and
 sequential workload
Date:   Fri, 18 Nov 2022 10:44:53 +0530
Message-Id: <20221118051454.31288-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118051454.31288-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmpm6OVHmywcT7khZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnLDyRWdDMUXHnwX+mBsYpbF2MnBwS
        AiYSHRses3QxcnEICexmlJh78QkThPOJUWLenH+sEM5nRol9L//AtTT962aGSOxilHi6ppUV
        JCEk0MokcWShDIjNJqAt8ertDWYQW0RAWGJ/RysLiM0sECpx8toXdhBbWCBG4v+FZrChLAKq
        Ervn3gSr5xWwkfj2Zi8rxDJ5idUbDgDFOTg4BWwl5rbEguyVEFjFLnFr3gMmiBoXiScLJ0Ad
        Jyzx6vgWdghbSuLzu71Q8WyJTQ9/QtUXSBx50csMYdtLtJ7qB5vPLKApsX6XPkRYVmLqqXVM
        ECfzSfT+fgLVyiuxYx6MrSrx995tFghbWuLmu6tQtofE/mP/oOEzgVHixYaFzBMY5WYhrFjA
        yLiKUTK1oDg3PbXYtMA4L7UcHmfJ+bmbGMFJSst7B+OjBx/0DjEycTAeYpTgYFYS4c29WJos
        xJuSWFmVWpQfX1Sak1p8iNEUGH4TmaVEk/OBaTKvJN7QxNLAxMzMzMTS2MxQSZx38QytZCGB
        9MSS1OzU1ILUIpg+Jg5OqQYmywVnb0h1ZEj8cPsUkfD615qOAP6kiF9PJsUutFlzMSvq4q89
        PlH2ry1rl2xNXVCwW+blbkHp2K/H33/gd3kTZr4y05B/6pzNr6VsGruPVaR+YhVV3WJhMkE9
        /77clsRj9ZuSjq4svJ3f6PVV56n6lhW2M3/NneT0elWxxeKbSx0zxJ6su+f2sqZwMef2osvz
        z7ZwnjBZku8u5LZ4gunKy4vC9zNs1K/a5ZP8ZvOz3DxzjX8a79JWJcRMv3BzgVzdsYz715k+
        N8l9mDF/aYNHS+d82di/Jd4mQfM8V8mtFWaU3244+9TDyoKnzfc3v13Z66T4YPfvT7H7jV0/
        LXsiwif9IJr5W/mGNz8/fhGreKTEUpyRaKjFXFScCAD1/UGi2wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsWy7bCSnG6neHmywbT1LBZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGUsPJFZ0MxR
        cefBf6YGxilsXYycHBICJhJN/7qZuxi5OIQEdjBKPOmZzNLFyAGUkJZYuD4RokZYYuW/5+wQ
        Nc1MEveWHWYFSbAJaEu8enuDGcQWASra39HKAmIzC4RLTD8wmRHEFhaIkpj9fxKYzSKgKrF7
        7k2wel4BG4lvb/ayQiyQl1i94QAzyF5OAVuJuS2xIGEhoJLTa14zT2DkW8DIsIpRMrWgODc9
        t9iwwCgvtVyvODG3uDQvXS85P3cTIziItLR2MO5Z9UHvECMTB+MhRgkOZiUR3tyLpclCvCmJ
        lVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MOX4J7/kvpX8VL78
        pGBLod7sS4mWKjtn/SjzWmqiMqk6fDXvzlNfC+snO6i+3ymp/m7TtFfn3u5o2btmR4LkJomC
        etl11wNmvH5kxcH9QmmVxCuzrOsPilf/mbD50skJNfsFDs3bLu77/Z7V47l7jaKW2uQrGFur
        LF7j5Vz7WEFa+cSd5L2MTmuMGD349Et//agSsSoXbfifs/rPW/dXYhLpHIWl9546Cvz8WSuy
        6blkiPvKjaxaL3+etf+x653SQsa8eQfCo1wWlL0tv5c89/6fB1+OLHVZZiiYyl9x0eJ2M0fX
        tX0Ws/83G7GqGnhMnPoztWLX9/9tRyeJuhlJ1+k82PbgjcD9SWms97SKb11XYinOSDTUYi4q
        TgQA+IzYSZECAAA=
X-CMS-MailID: 20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e
References: <20221118051454.31288-1-ankit.kumar@samsung.com>
        <CGME20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Sometimes while running a mix of sequential and random I/O's the
generated sequential offset is outside the I/O region. This usually
happens if the previous I/O is the last block in the region and
thus results in this sequential I/O's offset to be just outside the
region.
With this fix, fio generates a random offset within the I/O region.

This fixes #1486

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 io_u.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 8035f4b7..e49b1b29 100644
--- a/io_u.c
+++ b/io_u.c
@@ -432,8 +432,11 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 				*is_random = false;
 				io_u_set(td, io_u, IO_U_F_BUSY_OK);
 				ret = get_next_seq_offset(td, f, ddir, &offset);
-				if (ret)
+				if (ret || offset >= f->io_size) {
 					ret = get_next_rand_block(td, f, ddir, &b);
+					offset = -1ULL;
+					*is_random = true;
+				}
 			}
 		} else {
 			*is_random = false;
-- 
2.17.1

