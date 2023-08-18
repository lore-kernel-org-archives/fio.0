Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A179EE498D
	for <fio@archiver.kernel.org>; Fri, 18 Aug 2023 18:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379517AbjHRS6W (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Aug 2023 14:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379532AbjHRS6P (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Aug 2023 14:58:15 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1199726BB
        for <fio@vger.kernel.org>; Fri, 18 Aug 2023 11:58:14 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-56c74961e0cso850102eaf.3
        for <fio@vger.kernel.org>; Fri, 18 Aug 2023 11:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692385093; x=1692989893;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j1hY9hqxytBwIemBSdj3nSTRuQ/fGL+lLz4l23CZa1I=;
        b=VnHY9esIWBoWN6UsoJwRTLXzAwH2CvoiwpdDDcCBhPN6mXI4UeFZGNT/kkSuKQiKr6
         0TjPUkrIvQLWVQl2CJcmSjJS1NA7tXv7Uag2TDqOZKur2X7g5xsRlGlj0xIAnmt0fEPD
         UBWNsbh5p03/BflPwUQ8fAGnFQ/5KAivCsyQ9ujjcyPa7a9Q83xqXJ9lbB1uscvF6Qao
         Ft4CtSsEv+V4euwS2T4lcXlYMPkrLVM4iz9hIZZ4qH3O5QnKV3wcH396SHcy1WQHMH15
         4c/00sH0NAab22E7vlWBG340xM3Olny8D9/1gdqipGtyzRIVs00fSGg42RE/R+nTMe33
         wJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692385093; x=1692989893;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j1hY9hqxytBwIemBSdj3nSTRuQ/fGL+lLz4l23CZa1I=;
        b=GBeoBhOVg2+Td1GGioOF8CWECFBAj6e67vZEdJFR1V6nWJ4edo0aE6JMzrClCuX7Wv
         lL7lfxzOk5AT4EIxf2K7sIUB0ZzhJ2kp/+XwfGHu+00gSkyOnWYB+8sw/HBGqQdld2SK
         a+6OwreSjwq2/9UJjXMv96sEBwJWKdnkkqdOfNiilMrrYudR4XOaLhwksy7osyV8mOGM
         CTWzZPDJZxdlbpCAMu3Md7BdQJgiiogYOZu1T692m/zyk6YWUiOmLp4r//KMmFL4Mlwy
         cl+nYNGV+a0A2wDYkbMC7UCSRoc7jlb3uywmsalUlYpFKWpWBdyPaalwxfAflVP6wUwg
         +xmQ==
X-Gm-Message-State: AOJu0Yy70XAChaT+LfapHn94EkkbwLYrutC0iviXHKd368QqHw35XKxF
        Zo6AFFFr8LNRUUQAFw57VDI=
X-Google-Smtp-Source: AGHT+IHxjq0FhYVE5PoGFbEZVxJw2hPeX7niVE5AhrsxZQ0fOIolOEVr6Vm8uTPjX4/0sMMQdWsbqw==
X-Received: by 2002:a05:6358:24a3:b0:139:c279:1ee7 with SMTP id m35-20020a05635824a300b00139c2791ee7mr136152rwc.18.1692385092902;
        Fri, 18 Aug 2023 11:58:12 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id m17-20020a0cdb91000000b0063d3744c5c5sm881034qvk.5.2023.08.18.11.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Aug 2023 11:58:12 -0700 (PDT)
Message-ID: <4bd9b597-6221-1f07-991a-d79981d0fc0f@gmail.com>
Date:   Fri, 18 Aug 2023 14:58:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: fio and epoch issues
Content-Language: en-US
To:     Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVTqVUra10ET=P+hPA86iimSs3oC7=eWJNdpWjo5e4p+p1g@mail.gmail.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CADqNVTqVUra10ET=P+hPA86iimSs3oC7=eWJNdpWjo5e4p+p1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/16/23 16:45, Nick Neumann wrote:
> I've tried advocating for this via github issues a couple times
> (https://github.com/axboe/fio/issues/1544,
> https://github.com/axboe/fio/pull/1353/commits) but haven't had much
> luck/interest. I thought I'd try here and see if I could get enough
> interest to get some improvements to fio timekeeping committed. :-)
> 
> The main issue is that by default, fio log files use timestamps based
> on an epoch that is the beginning of the job. If you have multiple
> jobs, especially with some jobs waiting on other jobs before starting,
> this means you have different epochs and the times in the logs for
> each job cannot be compared/ordered.
> 
> Using log_alternate_epoch solves this problem since with it all logs
> share a common epoch, but introduces a different problem of not
> knowing the start time for each job relative to the common epoch.
> 
> Using the default beginning of job epoch for log files, but also
> recording the start time of each job against a common (alternate)
> epoch, would solve both problems and bring other minor benefits too.
> 
> Any thoughts? Issue 1544 has a 6-month-old PR that implements this.
> I'm happy to update, make changes, or approach it differently if
> desired.
> 
> Thanks,
> Nick
> 

I've left feedback at https://github.com/axboe/fio/pull/1353. I think we 
should be able to get something done to get this working for you.

Vincent

