Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806A4C433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 14:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiAQOV0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiAQOVZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 09:21:25 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F42C061574
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 06:21:25 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id a12so16815062iod.9
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 06:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6nqZlu2JimuHoIPPIHQ+Cwkrb6tMjYXVqUs2uZLpxOw=;
        b=o1/bqKE6hkw8nVWB4zMwYo3747b7VRZAa6QXVv44sKkqaXjqNalDPB9oz9QCFxIlV1
         Vz+lUnDw3kOAqINB2uhIvWuswGG11EWrC6iNx6lyUqtoNxBhMb1LL70yPbx4uq4TC3m9
         ztIwsPxD8ctVnWk0vX2b06qdgM4rcjkJWfHAaiu9P+xcifnkQ6pq+ddNCigcN6AI7ABD
         G6A14AKj5reMy/cJQAr3XperzcEc0gz9b1b7zOoiCEBEBwasi3up1gbcWsA6NgoMi8B5
         DMtTjNXwvh2bUzY3oBb76QQphjhOeSl+p50ANvPAqITVyxz8iJzEMJDWjK+84Ojk1AgZ
         WihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6nqZlu2JimuHoIPPIHQ+Cwkrb6tMjYXVqUs2uZLpxOw=;
        b=72j3YbEbJVZYlmohMtH0bubeiSyQQ/kLNoOLzPrrwRZKJdrglCdCkNmhNfb6UDkSk1
         RCdDSb+CyJPmmeGbMqU0uPrLKmppvPP3wzhgci5K7Dfa5/itSvfk+4u43SZyjkCRVeOI
         b3xI0Ja8uNNAg81Kyf3twtMwWPM1jovECOtpLArJutdeXdSqrp7U52/yo7WyfznqpI0Y
         tjOwxGtuRlQJtBxQ7XFUNh/EveOhEDN3CXwOxiIA184BjtNqZK1XhLkNWwOYsnwrnb4Z
         NpUMiHtLd/NsyY0m+4D9ravJE+YJ7oyeDuesstJmM2AOA598CYMp+/3WFCLvHxwiHRID
         6qFg==
X-Gm-Message-State: AOAM532vW8ng77oQGiZp2gV7glegKCtE3lquW+alqyP/bRZjOKc9CnhU
        S2N8+ctbJtwWp2Mx64IL9irV6vyAu2nMmQ==
X-Google-Smtp-Source: ABdhPJx2E/e7ectJ2YuYxAYAEu7a00xRp5/vCCJnJ1XeBrBscKIM1tVbGJw0Skvmj7qtVmck0bNECg==
X-Received: by 2002:a6b:4e10:: with SMTP id c16mr9583759iob.202.1642429284849;
        Mon, 17 Jan 2022 06:21:24 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j18sm7548401ila.86.2022.01.17.06.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 06:21:24 -0800 (PST)
Subject: Re: [PATCH 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
 <20220114154630.221288-2-Niklas.Cassel@wdc.com>
 <0ea0d8c2-e4aa-07c9-1691-62e498710252@opensource.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f4cd459-7f5d-68d6-e271-d8f0e7ec599f@kernel.dk>
Date:   Mon, 17 Jan 2022 07:21:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0ea0d8c2-e4aa-07c9-1691-62e498710252@opensource.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/16/22 5:45 PM, Damien Le Moal wrote:
>> +static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
>> +{
>> +	struct thread_stat *ts_lcl;
>> +
>> +	/*
>> +	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
>> +	 * Trims (ddir = 2)
>> +	 */
>> +	ts_lcl = malloc(sizeof(struct thread_stat));
> 
> No failed allocation check ?

For better or worse, fio generally just happily ignores allocation
failures... That doesn't mean that we should not move towards making
that better, particularly for new additions and where it's easy to
handle it.

-- 
Jens Axboe

