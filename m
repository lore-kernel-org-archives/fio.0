Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C327DC433EF
	for <fio@archiver.kernel.org>; Fri, 15 Oct 2021 12:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC1E361056
	for <fio@archiver.kernel.org>; Fri, 15 Oct 2021 12:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhJOMXK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbhJOMXK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Oct 2021 08:23:10 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF8FC061762
        for <fio@vger.kernel.org>; Fri, 15 Oct 2021 05:21:03 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z69so4312041iof.9
        for <fio@vger.kernel.org>; Fri, 15 Oct 2021 05:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=In3rwq/Oqw3VFTnwKMwJvr5OoyrqoJ13PC54OdhejF8=;
        b=LdxGOLmHLo3qwqPsSOPukTo90DftC3UoxIXz6xSeGkJDtlQnuJlYYquJhU+ji7fbIc
         2tdQFEJRk7w6GVV9uTDGJwbbJMl7ZKMWdhI9hmAISc3sMWhTtvU+qhBEurGtBchIcJlR
         BOpShFAKBFUoxjwB2dvntwL5XZGAA0bmYWZpC007SL7hBYWbrR14GfRfCLmRVqbHvqYc
         00hqFDRQBwWrvUAExmEwTykVyrJ1NtK05DPWpHEqqLm6ierhDn5elYORMLS4fHHinACZ
         LN+nOix2L32kW90xXJE6g10MvIGFFFYnLae+vtqRBXdgTXl9RGuNri4DMavcBOoujov8
         RfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=In3rwq/Oqw3VFTnwKMwJvr5OoyrqoJ13PC54OdhejF8=;
        b=620pT6R3zFR9ITjPNMSi2o0Y1EMbePA/Rh9g4pEj0XlYYMYBbj5ZJlYGRUJwAV3+w8
         kfhK9LeTYwdiaVrpzoNmsEUTthT5wzd62UgTWY6lGvoW6/bKx0ukFJGrs6mHkk0s/V4i
         gmxk52p3pMBm5WCID2hSKZ3QYG9gqiwFMRZCU/PRLa/MOY1+sqg1Tr4kNapUxuziEkgP
         2jTA2BUbTpeTY5PVbmYixBtbBgFRhQ46jzfmtD6QSJMLp82bpQQi8UsXktEOAawiRRXn
         oic4pPouHK+pQpYJn7CN7IeN4htppEPeezYP1YYCjJ06T5eEZvepKOEozU7PVz0psOB+
         jxWg==
X-Gm-Message-State: AOAM533X8wOOSYsp5s5+0O1WpZ0LgEaEmIQwzFc3rPhCbdHtPlVyyleA
        YqoxW5INWVKb00m6jn/TU02tBI4TIng8ZA==
X-Google-Smtp-Source: ABdhPJzZjCoXkcdIS8dw/S2iwi/mQKdxakI9cLWjgOqAuFwzkpMgPrcJpX74CGROBjlwZs1i+5WHzA==
X-Received: by 2002:a05:6602:2b04:: with SMTP id p4mr3517655iov.189.1634300463196;
        Fri, 15 Oct 2021 05:21:03 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a16sm2770285ila.21.2021.10.15.05.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 05:21:02 -0700 (PDT)
Subject: Re: [PATCH] t/io_uring: Fix the parameters calculation for multiple
 threads scenario
To:     Pankaj Raghav <p.raghav@samsung.com>, fio <fio@vger.kernel.org>
Cc:     =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>
References: <CGME20211015121029eucas1p159b174d661cb7a67684032107f870b5c@eucas1p1.samsung.com>
 <20211015120956.41848-1-p.raghav@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1f217a42-82e9-dba3-7e62-29c98a9fd013@kernel.dk>
Date:   Fri, 15 Oct 2021 06:21:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211015120956.41848-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/15/21 6:09 AM, Pankaj Raghav wrote:
> The this_done, this_call and this_reap parameter should be a summation of 
> the corresponding field from all the submitters. 
> 
> Currently, we are adding the done, calls and reaps param of the last used 
> submitter nthread times. 

Oops, applied thanks.

-- 
Jens Axboe

