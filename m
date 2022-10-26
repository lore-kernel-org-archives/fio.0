Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BFAC433FE
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbiJZTkM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbiJZTkB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:40:01 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDD0AE5E
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=8bQ++m+cUIjSAYv/VzzUMxGh9LKf/VtNxe+z5TcwelM=; b=D4+9Z+PCX12LVMvqOWsJN+E552
        D/kY8MKaShBQ4s4tQezeh49BOWfrwSPIxiSMotkEyB5hbkozwr6c2tggU6+u65TgjhISDj8OP9O6+
        avmogA0+VBuwF/U1NnAHTqsopS6mzrUGP0h2PCBEUf5TwyW5ChezyF+lDhXsVY8HoPFtRZRCov25s
        XCguMfZwF6mSqkwmRytIy6ZEHhyPFpTWENvMAP8I69z6CrBBAiiBxALJb1p54Coe9qn+4FTLwh6U/
        qrpv13GGHcItDFuYJYiDBkjHvHVW44Y82hxEA9YVEPoSfsxjpZcd7OiJBlJYqLjAQ8geM4MijuUU3
        Lf6wbmRw==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1onmFq-000Hht-QW; Wed, 26 Oct 2022 13:39:59 -0600
Message-ID: <39cca570-3e98-9602-531c-54af67167f15@deltatee.com>
Date:   Wed, 26 Oct 2022 13:39:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>
References: <20221026193902.32571-1-logang@deltatee.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20221026193902.32571-1-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v11 0/9] Userspace P2PDMA with O_DIRECT NVMe devices
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Apologies! I messed up and sent the wrong patches.

Please disregard.

Logan
