Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357BFC433F5
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 06:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1CE3611BD
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 06:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhJPGT4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 16 Oct 2021 02:19:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47786 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhJPGTz (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Oct 2021 02:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=bsdio.com;
        s=xmission; h=Subject:Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l8ihtaB3TT1XlOgrc5jKYy9AQbNkS9HUJs/lp5Acem0=; b=SkJ13aXlIocYKtSoTC8hvcB8UT
        3iYT+Wgf1OLFprft1GwaVf47CyT7xYlGOhKGfVOP37cvXgNk95i5tOTPM605brzEK66i3jqMmamhq
        Qe2UzxaBIR2L4Pmen0uhMF0rQDiXXQl9XjIAsV2m3FFtwJ164icv/zmb1nk0OkiN0M3I=;
Received: from in01.mta.xmission.com ([166.70.13.51]:43804)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mbd0t-003cMB-3C; Sat, 16 Oct 2021 00:17:47 -0600
Received: from mta5.zcs.xmission.com ([166.70.13.69]:60950)
        by in01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mbd0r-00HQ29-QH; Sat, 16 Oct 2021 00:17:46 -0600
Received: from localhost (localhost [127.0.0.1])
        by mta5.zcs.xmission.com (Postfix) with ESMTP id 990CB1281643;
        Sat, 16 Oct 2021 00:17:45 -0600 (MDT)
X-Amavis-Modified: Mail body modified (using disclaimer) -
        mta5.zcs.xmission.com
Received: from mta5.zcs.xmission.com ([127.0.0.1])
        by localhost (mta5.zcs.xmission.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A892APaYbIN0; Sat, 16 Oct 2021 00:17:45 -0600 (MDT)
Received: from timp.int.bluestop.org (c-174-52-16-57.hsd1.ut.comcast.net [174.52.16.57])
        by mta5.zcs.xmission.com (Postfix) with ESMTPSA id 66B331280440;
        Sat, 16 Oct 2021 00:17:45 -0600 (MDT)
From:   Rebecca Cran <rebecca@bsdio.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Rebecca Cran <rebecca@bsdio.com>
Date:   Sat, 16 Oct 2021 00:17:38 -0600
Message-Id: <20211016061738.76654-1-rebecca@bsdio.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1mbd0r-00HQ29-QH;;;mid=<20211016061738.76654-1-rebecca@bsdio.com>;;;hst=in01.mta.xmission.com;;;ip=166.70.13.69;;;frm=rebecca@bsdio.com;;;spf=none
X-SA-Exim-Connect-IP: 166.70.13.69
X-SA-Exim-Mail-From: rebecca@bsdio.com
Subject: [PATCH 1/1] engines/http.c: add fallthrough annotation to _curl_trace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

To avoid the warning from clang "warning: unannotated fall-through
between switch labels [-Wimplicit-fallthrough]" swap the "fall through"
comment with the "fallthrough;" annotation from compiler.h.

Since the second "fall through" comment isn't really a new fall-through,
remove it.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 engines/http.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/engines/http.c b/engines/http.c
index 7a61b132b92b..35c44871da63 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -297,10 +297,9 @@ static int _curl_trace(CURL *handle, curl_infotype type,
 	switch (type) {
 	case CURLINFO_TEXT:
 		fprintf(stderr, "== Info: %s", data);
-		/* fall through */
+		fallthrough;
 	default:
 	case CURLINFO_SSL_DATA_OUT:
-		/* fall through */
 	case CURLINFO_SSL_DATA_IN:
 		return 0;
 
-- 
2.31.1


