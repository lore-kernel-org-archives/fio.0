Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0742C433FE
	for <fio@archiver.kernel.org>; Sat, 15 Oct 2022 19:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJOTlO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Oct 2022 15:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJOTlN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Oct 2022 15:41:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBC33FA1F
        for <fio@vger.kernel.org>; Sat, 15 Oct 2022 12:41:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s30so11018224eds.1
        for <fio@vger.kernel.org>; Sat, 15 Oct 2022 12:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FZf5x5oi2eNxBR9uvZ1LtyOkjnuwHt2SgAcT2vQl3JQ=;
        b=SE7eLGWy7OA+ITXpMYtYy7JlSbeUPaHlUYyGdDR7BdKCS/vuQ7IRqyd2h2GnGfU4hQ
         RW4lWTFalAFleinPHoEEXTeQ0IMuAChNVrb2OyBB0X+PzH2ZCHJ7vJtdbb9oa2lUpuOt
         Kf78Ms6MV5agrPzsgZcxv6YO85aIpfF/HBW0vidWlJl1qcstD38bc9z9tfbbnADSNxyj
         SYvQ6Mva47wIGwMFL5LJq82ZLo89wD48wngIvRsXnMeUQPMtdFQsvsmQJYoqdYyZ+j8Q
         zqEDKqoTtPQObYErA4Po14yk4yb0GgI7IFVxN7dgNgF6OImPyd0mRPNOcO+SK4IgwUlq
         6JTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZf5x5oi2eNxBR9uvZ1LtyOkjnuwHt2SgAcT2vQl3JQ=;
        b=vR4ZOvaC9DpGXBtcybTOXFg4rt6Fovv5BW5sdy2wKQ74y/vRH5BFaUk3KFlXPvkmPw
         RoD9x9jtvwNOPFrYhSThAceVGZa/VtcU8anwK9pv3pEFP8wBs3KYfwGLH7jjpr1E79Us
         5/LUSGwWkB7CEgcpjfd/cXvjDiKyLqlAWbujOQMtwEjDhdgvicI8uv/mPOrQS9Ri4RHb
         HKPtEWeCYvrPQB1Bs56hSpUMT82jAKX1JT9NUKHGPoy0utNEM+mwQXorXFkezA/m+VXw
         pTBHoATOtuRYgCqeeUjKpLHT/Q7PWJE2mG0wNMm8kM3c66f9a+8aogGKfEmxqky4ooay
         1NQg==
X-Gm-Message-State: ACrzQf0xHXQKhhDqSzCVg/sIgk2uWV6FEif+ovlaQAe4iGvEstx5dONK
        3jlFf6iNxiI3rgsgaIDjgw==
X-Google-Smtp-Source: AMsMyM5sLq9PJKoWg9KN44DXI9lqcoLz1n73FFMGxtogaZb8h9LzCgjR1lPvHzR716cWfjwKWr2iVw==
X-Received: by 2002:a05:6402:5190:b0:45c:fca7:e07b with SMTP id q16-20020a056402519000b0045cfca7e07bmr3485250edd.327.1665862870982;
        Sat, 15 Oct 2022 12:41:10 -0700 (PDT)
Received: from localhost.localdomain ([46.53.248.196])
        by smtp.gmail.com with ESMTPSA id de13-20020a1709069bcd00b0078d957e65b6sm3531299ejc.23.2022.10.15.12.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 12:41:10 -0700 (PDT)
Date:   Sat, 15 Oct 2022 22:41:08 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org
Subject: [PATCH] fio: warn about "ioengine=psync" and "iodepth >= 1"
Message-ID: <Y0sM1PJKEzfv47ZB@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Some users are using both ioengine=psync and iodepth=2+
without blinking in front of the millions:

	https://youtu.be/coShLkCriXc?t=840
	https://youtu.be/coShLkCriXc?t=890
	
Help them with helpful message.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 backend.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/backend.c
+++ b/backend.c
@@ -1791,6 +1791,11 @@ static void *thread_main(void *data)
 	if (td_io_init(td))
 		goto err;
 
+	if (td_ioengine_flagged(td, FIO_SYNCIO) && td->o.iodepth > 1) {
+		log_info("note: both iodepth>=1 and synchronous I/O engine are selected, "
+			 "queue depth will be capped at 1\n");
+	}
+
 	if (init_io_u(td))
 		goto err;
 
