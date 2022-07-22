Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382E9C43334
	for <fio@archiver.kernel.org>; Fri, 22 Jul 2022 08:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiGVIIH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 22 Jul 2022 04:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiGVIIC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Jul 2022 04:08:02 -0400
Received: from smtpproxy21.qq.com (smtpbg703.qq.com [203.205.195.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F019C272
        for <fio@vger.kernel.org>; Fri, 22 Jul 2022 01:07:59 -0700 (PDT)
X-QQ-mid: bizesmtp79t1658477265tai0jwlc
Received: from eureka.localdomain ( [123.124.208.226])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 22 Jul 2022 16:07:30 +0800 (CST)
X-QQ-SSF: 01400000002000B0D000000A0000020
X-QQ-FEAT: BlNBQFNV1ZVeA8rU1SPzmwZ7u+0PdTPHCpU9vugeV7vnr1MKcjuqSYaan6vBb
        MZ8N+01b4UX+1rLUDgiBxMXLGp5UqhbH0dQ984MbYhSdqFEmxdLatNF/1TaIdt55bxHnMQv
        ZZVImDrujg/0IoFGT0xHn99JpnDritGlkSlQ9nvgdzPjvAGyaNwPYQ6kKx2Oho4EdxeIale
        1uzGP9aKqCQC34kW7zxO84sJco5dmkpAi1HKst+X4eN9qbSkzJhSVcKyEHMAZHpayNh2qT6
        grkFygt7hfG2t9jZ4vgPIaUxFirqXwdb8LJ+feXuEPLyF7nxGNyv5g0atEadhyfVA/RuIeV
        zXAZmxfqc4ShUgqIr2GylkRfoBjuPf0f2w2v0XglXYSAYNtELx1J04YwTjuFNq9qI0Hhqv3
        /b9JuUM7mM4=
X-QQ-GoodBg: 1
From:   Wang You <wangyoua@uniontech.com>
To:     bvanassche@acm.org
Cc:     axboe@kernel.dk, fio@vger.kernel.org, hch@lst.de,
        jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        wangxiaohua@uniontech.com, wangyoua@uniontech.com
Subject: Re: [PATCH 1/2] block: Introduce nr_sched_batch sys interface
Date:   Fri, 22 Jul 2022 16:07:30 +0800
Message-Id: <20220722080730.363800-1-wangyoua@uniontech.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <21e7c959-6365-8029-d26d-985ff888333e@acm.org>
References: <21e7c959-6365-8029-d26d-985ff888333e@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign3
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> How can reducing the number of batched requests increase performance?

> Please provide performance numbers.

The test data of the original patch is in [PATCH 2/2], including the case 
of nr_sched_batch = 1, and then I will organize the data of different 
hardware in PATCH v2.

Thanks,

Wang.


