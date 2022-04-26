Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F71FC433EF
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355390AbiDZV2D (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiDZV2C (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:28:02 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5863F17B3A3
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:24:54 -0700 (PDT)
Received: from [192.168.88.87] (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id CFD8C7E787;
        Tue, 26 Apr 2022 21:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008294;
        bh=MdNIKPfR4zKWtL86DFAR0CP47IGlur35JdxQ4ssDWjo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GurIlntysA5KodH8idSDBgIBMst5A+qTVGUOtQTLP+2svE2FkegYjljHLPbG/OzcJ
         Y6dAyf4oCao+DwGbSIFHT5e26UZJFWKg+b8/Tq/ZvKo+3PAUkPR8XuPKidrEttfaMc
         AayKVBASbKHjsSbRVZ00wkCVS7baXxWKDuwhupOlfPJWJeFq+pS2mrjKLvR78x1A4X
         +/iMEgH82iOskaqTiLgCnhmUiLkeD95aHIUk5aYt/ospx+GhNfhwRn+24QCih8iGhe
         MWCij1e2GWCXQKYWgmlv98GUrlyYB2ZQ9l7x359wco2q53uUSYGpiLiCYoOf49vymB
         Om0KE+lMPYuRg==
Message-ID: <b7d5d8df-73af-a895-790d-1678dc95d399@gnuweeb.org>
Date:   Wed, 27 Apr 2022 04:24:44 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1 3/6] stat: Handle `ENOMEM` case on `malloc()` call
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
 <20220426212044.78898-4-ammarfaizi2@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220426212044.78898-4-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/27/22 4:20 AM, Ammar Faizi wrote:
>   	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
> +	if (!threadstats) {
> +		log_err("fio: failed to allocate threadstats\n");
> +		return;
> +	}
> +
>   	opt_lists = malloc(nr_ts * sizeof(struct flist_head *));
> +	if (!opt_lists) {
> +		log_err("fio: failed to allocate opt_lists\n");

I should free(threadstats) here, will send v2 soon.

> +		return;
> +	}
>   
>   	for (i = 0; i < nr_ts; i++) {
>   		init_thread_stat(&threadstats[i]);

-- 
Ammar Faizi
