Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5727EC433FE
	for <fio@archiver.kernel.org>; Tue, 15 Nov 2022 21:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiKOVTn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiKOVTm (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Nov 2022 16:19:42 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A265DFCE
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 13:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=t9U7MVkvM/2qWWmZVFbLlV1KgNrHkz83m/fU6d2Fjso=; b=FfJghw8dDDmZfLrXPrBJ3jlET4
        //WIwSA3DH+XculodD4fYt64nIPwVOgg90bPc23kWRHq+dU44elu4ZBGiC4kH14W9IxuNxA6Bio9e
        zql3hhdXq2A9RTU50rr12OKm/lfwhaZeL/qKaNCzOmY2VXJpJ2A46/jovUxLOxytH6H3QEmrBHKyh
        i2aETUvDJI2f9wWjrlnO9/iQKRmVp2I4lYiwW+l8lths3c7TH7Vo7wKK4Fn/juWZja4wIU1dkdQMV
        XySfke3+TfhRmYIzF/maKBnCYLlVrcwwj5b4Tb/3Monc0TOSwFy65vCsNWGmXpPnNc8fKnhbN44Ap
        qbe/PiJA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ov3Kv-003F8R-Sv; Tue, 15 Nov 2022 14:19:18 -0700
Message-ID: <a0179719-2b2e-75d0-303f-1ff548918f88@deltatee.com>
Date:   Tue, 15 Nov 2022 14:19:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-CA
To:     Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>
References: <20221026194019.32776-1-logang@deltatee.com>
 <b7f2106f-9427-25df-9aa3-ff9dd6958996@gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <b7f2106f-9427-25df-9aa3-ff9dd6958996@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: vincentfu@gmail.com, fio@vger.kernel.org, axboe@kernel.dk, David.Sloan@eideticom.com, sbates@raithlin.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 0/4] Support large pattern buffers
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org



On 2022-11-15 13:57, Vincent Fu wrote:
> I've looked through the patches, done some testing and see no problems 
> apart from the small changes already mentioned.
> 
> It would be nice to have an addition to our test suite that covers this 
> functionality.

Thanks! I'll make the change you mentioned and look into writing a test
for this. I'll send a v2 in the next week or so.

Logan
