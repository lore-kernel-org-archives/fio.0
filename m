Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E014C433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 15:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B37C60F6C
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 15:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348609AbhIHPRP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348450AbhIHPRP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 11:17:15 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402FDC061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 08:16:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z1so3708322ioh.7
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 08:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SiNR5eqRInkdhrJa+ypi/NNhxcMT6MJK4usQZrvrP8E=;
        b=TYqNGEGjwZqx8DJsqGJob1O0lsKTzLEruBWFJ+mudhrtkBD9OKm2jYVG+Fl1PCmjMF
         9rJB3hTeee2GcChhsX6kCPHMRUPzJNi+5U4i9JErInaNv3hpRpqySuOyy/gQRBqobcsK
         NCcecl0EO4mv0Y2h94L0e4bA9fQTHJ3wK19Yt2CR9ujq9rjMeoCk2bZEpz5paSL4WdYo
         zFBAsSNbo/n/HtII7rH9xWsFyF9YiMMNjXZKwgYpK0C7aRvpdGya8vL+g6G66v+CCg6c
         elm2tgOHbNshLaq8w3Y0zkHbyW2xbeUOw/DY64aJ26szvnOI9obFSAyxrNvJBJp+Kn2S
         5DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SiNR5eqRInkdhrJa+ypi/NNhxcMT6MJK4usQZrvrP8E=;
        b=drhJeA4acpeVT8isRINk8qHMbYchF9vjtI9f7KuUikE/xOonFooqFrbpQLVn8biJ35
         YE44JrUVlvJDs14yMFB+gSEcX9MZ160Zfu3sGcL25QGvqgBBLOJ1KPrIzEU6kQNG/L9v
         Gtxl2sujBfeG/gNr6ZTNKk9Af7luWTk2bA9Se1AgxNv5aCBBCVwAc7IHeB66HRl0LrY/
         S7VoY9kQRK00WHFSTd8yuH8mq/GjTLuXrhzObIqB+WXpB1x578/oU/PJkR/wnGJFzTGR
         sr5+v6LZdnqxjTKHYF6uGzq/0mpnIZerlb5ZM4oo74hAdAAOQrn6i2at+x87CR0gIRE8
         MmsA==
X-Gm-Message-State: AOAM5324jJgHTui2nvUgVt0/MYm7ZP39FTZWdQK63t2zBj2TKUMHnHfj
        0eqQiGDQNUbhZ9cFAtUobp7k9i9zFCTJ8A==
X-Google-Smtp-Source: ABdhPJxvNMXnqFjXBQXwDQig/GimqtdBsjyS4Jc0HmBnmdYg22/uTVw98nZh9OFK/LvClCuQO9GFqg==
X-Received: by 2002:a05:6602:2436:: with SMTP id g22mr299167iob.109.1631114166404;
        Wed, 08 Sep 2021 08:16:06 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n11sm1226738ilq.21.2021.09.08.08.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 08:16:06 -0700 (PDT)
Subject: Re: [PATCH v2] t/io_uring: allow flexible IO threads assignment
To:     Andrzej Jakowski <andrzej.jakowski@intel.com>, fio@vger.kernel.org
References: <1631113652-25526-1-git-send-email-andrzej.jakowski@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d358a412-5080-cf7f-02a4-3fe2670f0ddc@kernel.dk>
Date:   Wed, 8 Sep 2021 09:16:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1631113652-25526-1-git-send-email-andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/8/21 9:07 AM, Andrzej Jakowski wrote:
> This patch allows to flexibly assign IO threads to fileset. When
> you specify:
> 
> t/io_uring -n 5 /dev/dev1 dev/dev2
> 
> First file/device will get 3 IO threads and second file/device
> remaining 2 IO threads. When there is more files then IO threads,
> IO thread may get assigned multiple files/devices.

Not to nit pick, but:
  
> @@ -620,37 +621,57 @@ int main(int argc, char *argv[])
>  
>  	j = 0;
>  	i = optind;
> +	nfiles = argc - i;
> +	if (!nfiles) {
> +		printf("no files specified\n");
> +		return 1;
> +	}

I think this looks correct now, do we want to call usage() here?
Seems common practice for any kind of invocation error.

usage() should probably exit() with non-zero though, in general.

-- 
Jens Axboe

