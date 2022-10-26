Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7B7C433FE
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 20:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJZU11 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbiJZU10 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 16:27:26 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4194D696E9
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 13:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=z2461RIm+8kxhRbUDdt15R+7/pisfMGWFJiuHJMgfDs=; b=NBRGW7Bw13FZbU5gpj5HsfDvaA
        G1tpPRQEyjtcg3L4FI7kL/z+eT4XySXC6JCUhohiaouqeSAy+1aVNjsueI1Bn8aECilWDKsu/FpHb
        +phZpRj5gC2O6QLg8dKJxM0JoP9T62Wfz6QMcau2GQ2GCzexZaZPOQoC91yznSkqGN+mq2gzPKFfE
        tZaEjcMLPVG39ZpA5xvzzNCletgxSR6392a+ah2hOm1nq9MwTljOKDwMZpGcf+pV10Q55kK3Fx14v
        RUxFb7sr9MiLTagde+sqH66s1U2bG6d+iY9UY5h7VG+xitPxVILKCeGm3KvBMSepumDjPEqbfq+ME
        PXFGqWLA==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1onmzj-000INI-QY; Wed, 26 Oct 2022 14:27:24 -0600
Message-ID: <0e3c4a70-7745-b8b6-3f9e-294fd91f30a9@deltatee.com>
Date:   Wed, 26 Oct 2022 14:27:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logan.gunthorpe@eideticom.com>
References: <20221026194019.32776-1-logang@deltatee.com>
 <20221026194019.32776-2-logang@deltatee.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20221026194019.32776-2-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logan.gunthorpe@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 1/4] cconv: Support pattern buffers of arbitrary size
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org



On 2022-10-26 13:40, Logan Gunthorpe wrote:
> From: Logan Gunthorpe <logan.gunthorpe@eideticom.com>

Seems I really messed up sending these patches out. Sorry for all the
noise. The From email should be the same as the signed-off by. I'll fix
this in v2 after collecting feedback on any code issues.

Logan
