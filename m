Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9EEEB64DA
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 19:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjGTTdi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Jul 2023 15:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjGTTde (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2023 15:33:34 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2817E1B6
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 12:33:32 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3461b58c61dso1651675ab.1
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 12:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689881611; x=1690486411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r47DU1gIFsuk+mttXaxh7RBIJ7zR9xJMGA/+/kyIwe8=;
        b=ddyOoWXpb934OTO/MhKSzgSk9xYx/Zqf4rtAcmB8IyYbnpvKjvY2FhIQwGRPbnhDbt
         IC2bZvmO81LisKCRrq+lSg/blxGLz9HdRSHUsJUPGoCuNYunJAlAIGl4BXUCK/OhZDH/
         HGrGfsNJNOtjZ43Ub/Puad+z6yuVjsigjOE2kMfoyKHzPYy+rIpKD7yy8bVcyKhVuOg5
         ou+JgMGCpeU0S0PtCkuU3x2YbipW3mmRvBdi3SZQnrG+YRJOqpMT4FyZuqo7CQC5heYB
         SFLFtYONFuXoTIH5IlachKHYC1VoVKjxitdKJsLPbJ7Fg3vVOgxghUiS0xEtZ5tlgimM
         uOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689881611; x=1690486411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r47DU1gIFsuk+mttXaxh7RBIJ7zR9xJMGA/+/kyIwe8=;
        b=KMtSb6bXYMndWbaUqaqEYO7S68u9+fCS4zMAhyJF7tRSJXwqZ74Cm1bZkzvZgFHNN6
         7SUaoKOX+DUtOlpI9r5YdTbgkuur0dBUZyGmnO35iADNkWgRMJxE/mZ6M/J+m+Rdd2H4
         N+21SHpa1zn1E43GtfKTgrcDTOSm3pry/uyorWEMNQKlNMu18l+oHnPmTngfqirlAp0o
         7btUHlQKZtj1pzVV4M7URi6GZMkp489r0d4FPwOQnYc5jedVfUipbx7M8r541K7Igst1
         M0l6/9RJps5pXyVMTIqs7LqqVazddyqaUKIS7N7IyDRpeq8wa4PntztZQwjZJD4i9F9z
         wpZA==
X-Gm-Message-State: ABy/qLa3LQbbBk4e2mSlqOVYZ7azjQvIgIA5aCj8dkEdpEVeWZaG/J7I
        8ZBm+KBTci+EGw1D/rsO2ANRMQ==
X-Google-Smtp-Source: APBJJlG22oVtf6dQKa2PQiDr6dKp6+ec/ACJhq8zBw0rf4YIMTq0SMqSvZ4SC20eI6DFdSIwg4+R2Q==
X-Received: by 2002:a05:6602:3404:b0:77a:ee79:652 with SMTP id n4-20020a056602340400b0077aee790652mr4557901ioz.1.1689881611469;
        Thu, 20 Jul 2023 12:33:31 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o19-20020a02c6b3000000b0042b144abf71sm496113jan.179.2023.07.20.12.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 12:33:30 -0700 (PDT)
Message-ID: <272fe8ef-49e4-e2b9-2763-0e11fcdbb118@kernel.dk>
Date:   Thu, 20 Jul 2023 13:33:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 3/5] options: add priohint option
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, fio@vger.kernel.org,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720013114.28158-1-dlemoal@kernel.org>
 <20230720013114.28158-4-dlemoal@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720013114.28158-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/19/23 7:31?PM, Damien Le Moal wrote:
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 7ae8ea7b..9b9472a8 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -3424,6 +3424,12 @@ Threads, processes and job synchronization
>  	priority setting, see I/O engine specific :option:`cmdprio_percentage`
>  	and :option:`cmdprio_class` options.
>  
> +.. option:: priohint=int
> +
> +	Set the I/O priority hint. This has effects only for devices with
> +	features controlled through priority hints (e.g. block devices
> +	supporting command duration limits).
> +

I would rephrase that as:

	Set the I/O priority hint. This is only applicable to devices with
	features controlled through priority hints (e.g. block devices
	supporting command duration limits, or CDL). CDL is a way to XXX

and finish the XXX, and apply to the man page as well.

Assume people don't know what CDL is, because that will generally be
true!

-- 
Jens Axboe

