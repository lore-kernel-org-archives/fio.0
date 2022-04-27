Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BC0C433F5
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 10:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiD0LA4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 07:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiD0LAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 07:00:12 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887FA37306E
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 03:48:06 -0700 (PDT)
Received: from [192.168.88.87] (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 807417E77D;
        Wed, 27 Apr 2022 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651053153;
        bh=Dv9bSOzIQ/c1W7Zi3RnlEDDugtp9LRIhQfFsGGKGajo=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=PfzEWV6WRCfKcTJwP1JB7RQX3853/+lih0CQB0PBD2ijjfgDac+9pg5/rcm4JIQqh
         k2Oo11nEy31uMdNbU6y8C0t6v4xZ0kZCoS5sqkBy7iN07WV+zQCkEc2B6kDcxAZK0A
         EIX4LThHZ6HlrKYK/XfI6KjZycS7W9pNZyTtUOegFzmbK57omW0UUyfrGUErESNQ0E
         5Q1QOmQqt9O62q8VjfGwsZkz2QKr5xmymYuwWcKcH7JJehYNtjY2gldmkmnFsG/QQt
         D7haZRfXDF9FZcpSjo26O4WsZ6WzeGSDQCUuTqfrtUKqWlV9ELFojEdrTovNX2HFiH
         icKLRkPydPIQw==
Message-ID: <1b00082c-8563-87ad-ad94-4c4f8c61cc7c@gnuweeb.org>
Date:   Wed, 27 Apr 2022 16:52:19 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
 <20220427091125.114146-4-ammarfaizi2@gnuweeb.org>
 <YmkORZJIxvBOxHJN@x1-carbon>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v2 3/6] stat: Handle `ENOMEM` case in `__show_run_stats()`
In-Reply-To: <YmkORZJIxvBOxHJN@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/27/22 4:35 PM, Niklas Cassel wrote:
> Hello Ammar,
> 
> here you allocate runstats with calloc.
> 
>> +	if (!runstats) {
>> +		log_err("fio: failed to allocate runstats\n");
>> +		return;
>> +	}
>>   
>>   	for (i = 0; i < groupid + 1; i++)
>>   		init_group_run_stat(&runstats[i]);
> 
> Here you call init_group_run_stat() on each runstats,
> which calls memset(). Seems a bit excessive to clear
> the memory to zero twice.

Agreed, I will CC you in the next versions.

Also, it seems like the vger kernel is messed up. My cover letter
and patch #5 don't appear on the lore.

> If you intend to modify init_group_run_stat(), be careful,
> as it is also called by client.c

Let's use `malloc()` for runstats instead of modifying
init_group_run_stat(), which is way much more simpler.

Will spin v3. Thank you!

-- 
Ammar Faizi
