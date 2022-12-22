Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7696C4332F
	for <fio@archiver.kernel.org>; Thu, 22 Dec 2022 04:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiLVEsM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVEsJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2022 23:48:09 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161631A80E
        for <fio@vger.kernel.org>; Wed, 21 Dec 2022 20:48:07 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221222044806epoutp02d32b5efc9d49ef4617d389b49e10fdaa~zBC7e8OXQ0754307543epoutp02e
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 04:48:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221222044806epoutp02d32b5efc9d49ef4617d389b49e10fdaa~zBC7e8OXQ0754307543epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1671684486;
        bh=8veZQ9ok95aUs/TTWaLboEUcKH1llYm49Itm+R8lBxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9TVy6T/TISqvv0kpiWAYDs/3tZByn6JfPlJLV+Cb0EjXrjLaFDx92yN/P8BogIgC
         uC0TDPkYuYRF/iQJR7/SnCfk2vSnhjouAAErR+qne9gQ+rBZhRxrM3RoOTmCy1xQtP
         VQCpmCBQEDKZ+JwjfevL/O9TbAfwpqmXkC0gp/Hg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221222044805epcas5p4620631b31d84d89500939e358132bb5e~zBC7N7J5v0895308953epcas5p4V;
        Thu, 22 Dec 2022 04:48:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NcyVX3CGGz4x9Q9; Thu, 22 Dec
        2022 04:48:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.EB.02301.281E3A36; Thu, 22 Dec 2022 13:48:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221222044041epcas5p28ebdf57c30725c2f266e55658e327564~zA8dSaoAD0408204082epcas5p2e;
        Thu, 22 Dec 2022 04:40:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221222044041epsmtrp20e9ee7f4f569d5dcf8fb2a2fadc4d4d8~zA8dRuihR0798207982epsmtrp2L;
        Thu, 22 Dec 2022 04:40:41 +0000 (GMT)
X-AuditID: b6c32a49-473fd700000108fd-56-63a3e182934e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.12.10542.9CFD3A36; Thu, 22 Dec 2022 13:40:41 +0900 (KST)
Received: from green.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044040epsmtip17880d25509884283c3637e239db90d56~zA8cSkXqN0411504115epsmtip1l;
        Thu, 22 Dec 2022 04:40:40 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, simon.lund@samsung.com,
        m.ynddal@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/4] engines/xnvme: fixes for xnvme ioengine
Date:   Thu, 22 Dec 2022 10:09:48 +0530
Message-Id: <20221222043951.24590-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221222043951.24590-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7bCmhm7Tw8XJBidfqVusufKb3WL13X42
        i4+zXjBbTPrVyGhxt3sGu8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RkLVsxjKWjirZi+
        cTZTA+MOri5GTg4JAROJqbtesXUxcnEICexmlNj3ZyqU84lRYsmK7+wQzmdGiXNzLzDCtKz+
        9Q3MFhLYxSjROjMSoqiJSeLPt0YmkASbgLbEq7c3mEFsEQFhif0drSwgRcwCzYwSay6uYQFJ
        CAvYSLRcvMYKYrMIqEqsvvQLbCovUPzW/73MENvkJVZvOABmcwrYSkxfcoEFIr6LXeL3xFgI
        20XiZOMmdghbWOLV8S1QtpTE53d72SDsbIlND38yQdgFEkde9ELNt5doPdUPZHMAHacpsX6X
        PkRYVmLqqXVg5cwCfBK9v59AtfJK7JgHY6tK/L13G+ocaYmb765C2R4S9w8vZYUEygRGicWv
        b7NMYJSbhbBiASPjKkbJ1ILi3PTUYtMCw7zUcnisJefnbmIEJy8tzx2Mdx980DvEyMTBeIhR
        goNZSYT30oXFyUK8KYmVValF+fFFpTmpxYcYTYHhN5FZSjQ5H5g+80riDU0sDUzMzMxMLI3N
        DJXEeVO3zk8WEkhPLEnNTk0tSC2C6WPi4JRqYCpwW112momHe75T6bFW3blbDJ89rg76OnUD
        98v+Lp4/VpE9fHYLz1vlWb1aK3xvmh5XgMqTa1XTnmjeVPyy/lHt2uBXu3cxdx67NfXyiYrs
        wL9Lcm9PK1Ko1p0w4WnjvA+lRyt2/9U0KnfebeHls1agxKXwRMWLlJOegfbZJ54dLjfJfWbt
        9DJHyz7ykfoa7Uv6rO+v9x/+wsU0e9Lv7W09alVPwxW6Qi8b56zyWrK4rMiq+EGPjl3y33tp
        P/rMT07en7ndz+lE2M8Hry79lWWa+9d125ECL/Mvn8UObTmgmPv/E8cT43S/wiv2S733+pn+
        LBGQds3uexaxSaXR7O3arsh905TK6nmdw25++KDEUpyRaKjFXFScCAB4aI0m5wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42LZdlhJTvfk/cXJBnO+c1qsufKb3WL13X42
        i4+zXjBbTPrVyGhxt3sGu8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6
        dglcGQtWzGMpaOKtmL5xNlMD4w6uLkZODgkBE4nVv74xdjFycQgJ7GCU+Dt/AmsXIwdQQlpi
        4fpEiBphiZX/nrND1DQwSUz6cZgJJMEmoC3x6u0NZhBbBKhof0crC0gRs0Ano8TOnwfAioQF
        bCRaLl5jBbFZBFQlVl/6xQhi8wLFb/3fywyxQV5i9YYDYDangK3E9CUXWEBsIaCaBbtfMk1g
        5FvAyLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4vLS0djDuWfVB7xAjEwfjIUYJ
        DmYlEd5LFxYnC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp
        1cDkbKyuy23XFX+R5cKuN0+7yuYqTCyLS+daGmWzLqKgduUTU/n1P57uz6oN0NX3exZopRzL
        v8BUwP+78VSR6PTrN59eKfYpE1srXqV30Fb0XaTYvjkTY5rmfzfaZH3XwLT9sqvJz1m7VI9J
        LroStHF1WoWKi6h6v9cWuwNJT0pUFmyeUFaycoPGSfOe2LQJU978FjTb91Oxfk1XYWN5FlML
        c8fMZxdbQjPezbn6/chUuz+Lvmw3CAt7s23li6kT5u3+s/Xm5Q3WXcHK1aGBW6fe6+vcZeO0
        M3PPgmua/9OaH29YeuPKwwfvQlZvuaiTwfWH3UbC+cccic9TNSoP7bZ5KJt+wUoy9vmW6lmF
        XkWLlViKMxINtZiLihMBoYGxop4CAAA=
X-CMS-MailID: 20221222044041epcas5p28ebdf57c30725c2f266e55658e327564
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221222044041epcas5p28ebdf57c30725c2f266e55658e327564
References: <20221222043951.24590-1-ankit.kumar@samsung.com>
        <CGME20221222044041epcas5p28ebdf57c30725c2f266e55658e327564@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

1. fix error-handling in xnvme_fioe_queue()
2. fix resource-leak in xnvme_fioe_init()

Signed-off-by: Simon A. F. Lund <simon.lund@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/xnvme.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/engines/xnvme.c b/engines/xnvme.c
index d8647481..dcc54998 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -322,12 +322,15 @@ static int xnvme_fioe_init(struct thread_data *td)
 
 	xd->iocq = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!xd->iocq) {
-		log_err("ioeng->init(): !calloc(), err(%d)\n", errno);
+		free(xd);
+		log_err("ioeng->init(): !calloc(xd->iocq), err(%d)\n", errno);
 		return 1;
 	}
 
 	xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
 	if (!xd->iovec) {
+		free(xd->iocq);
+		free(xd);
 		log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
 		return 1;
 	}
@@ -338,6 +341,10 @@ static int xnvme_fioe_init(struct thread_data *td)
 	for_each_file(td, f, i)
 	{
 		if (_dev_open(td, f)) {
+			/*
+			 * Note: We are not freeing xd, iocq and iovec. This
+			 * will be done as part of cleanup routine.
+			 */
 			log_err("ioeng->init(): failed; _dev_open(%s)\n", f->file_name);
 			return 1;
 		}
@@ -506,9 +513,11 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 
 	default:
 		log_err("ioeng->queue(): ENOSYS: %u\n", io_u->ddir);
-		err = -1;
+		xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
+
+		io_u->error = ENOSYS;
 		assert(false);
-		break;
+		return FIO_Q_COMPLETED;
 	}
 
 	if (vectored_io) {
-- 
2.17.1

