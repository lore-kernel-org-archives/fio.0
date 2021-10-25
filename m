Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED038C433EF
	for <fio@archiver.kernel.org>; Mon, 25 Oct 2021 15:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D024D60184
	for <fio@archiver.kernel.org>; Mon, 25 Oct 2021 15:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhJYPqQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 25 Oct 2021 11:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJYPqP (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 25 Oct 2021 11:46:15 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98525C061745
        for <fio@vger.kernel.org>; Mon, 25 Oct 2021 08:43:53 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id p6-20020a9d7446000000b0054e6bb223f3so15546216otk.3
        for <fio@vger.kernel.org>; Mon, 25 Oct 2021 08:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qFbOj/gFhGX2gNSr3e9/k30l5vww5xm/KN5JyrRhMS8=;
        b=01DKLXRJS6HBNQw0Lg6z8ZgGiPBnSVz7i1GVG5AuVrQ+NTQiPCuI2saJNQvTk5pxn3
         JlJdTPmecwtsEDvfV56HPRg6jYnEWSP81+nLQu/zXEVlqkl9lOPZK5LgcvOJzA8cKlGK
         gsEgCSLcDANYIzl/PnklBSFi5hygGAerN3/xW2Yzp7cpUqLXA/Wq+w09uouwKoIb76XH
         E21xBiDWdNiYWjS6VQpee7y3Nmzc840kkCIDYOS6dXrxOPv7bdleP7FU846N28RvyyIs
         7D0FSfNbe7O6TsuHlA9zz8PoAMpNuxAuutNL4tdeUeT1HMXKFVVC98lPMjXkNznbo0Yx
         1Mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qFbOj/gFhGX2gNSr3e9/k30l5vww5xm/KN5JyrRhMS8=;
        b=AK6TKs/2mUvvIxqeycad14BrMfkvMPQGvN3lvl1KJ03ImKhzsr5n/PImlLjVSt2mhl
         JP1opiJ7PiMkWm+x0gf7ayQBB6gRRSAfz70rEQEo+R0vtcuqi7q4uPkug1IQsH8dp6Cv
         Cmku/jZn/FE7PeeTMlEHJEUMQKY2eiQCmzoA/RFERcO05l/R9N+O5XWCQfkKBQQzfoO5
         JdKEGtnjQlb89CiH6nsK1huMMO9RBayIvs/Uy1c7tHlhPC10duwn/ZIxcrS1s7e6F9jj
         m6ot6aCP1DVto0ZIx4kWafSy43Gd1a931dvuB4Yt9TYDE5SVDlGlI8IQnIkmjWTkVM9j
         Zswg==
X-Gm-Message-State: AOAM531K3iPXpiOxfe6fgGCw+6QEe0QObu9xp9llcfjr5EUR+7PyqXP+
        zZV9eybWfkaLbE+0bEKRyE5uv/cQvistKDXn
X-Google-Smtp-Source: ABdhPJwRS7s1KkmSzJ+EyqZjh1UhgYQ7jX055YzBSHR1sX6YFSKGNQllX6tNgrYYSgO+s9TAxUhNMw==
X-Received: by 2002:a9d:2ac2:: with SMTP id e60mr13969766otb.92.1635176632676;
        Mon, 25 Oct 2021 08:43:52 -0700 (PDT)
Received: from ?IPv6:2600:380:602d:d087:5bee:e9ee:c67d:4ccf? ([2600:380:602d:d087:5bee:e9ee:c67d:4ccf])
        by smtp.gmail.com with ESMTPSA id r44sm3802547otv.39.2021.10.25.08.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 08:43:52 -0700 (PDT)
Subject: Re: Recent changes (master)
To:     Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
References: <20211023120001.B33411BC0139@kernel.dk>
 <13b58f71-076c-02a8-985c-60294a6d35b4@bsdio.com>
 <a26a7532-0c76-2b8c-f28c-e760c13b1833@kernel.dk>
 <21aa8192-60ff-e27f-ce51-a4fa72c86bf2@bsdio.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8892d21b-5e11-0167-0215-5c0157556da4@kernel.dk>
Date:   Mon, 25 Oct 2021 09:43:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <21aa8192-60ff-e27f-ce51-a4fa72c86bf2@bsdio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/25/21 9:42 AM, Rebecca Cran wrote:
> On 10/25/21 9:41 AM, Jens Axboe wrote:
> 
>> On 10/25/21 9:37 AM, Rebecca Cran wrote:
>>> On 10/23/21 6:00 AM, Jens Axboe wrote:
>>>> The following changes since commit 09d0a62931df0bb7ed4ae92b83a245e35d04100a:
>>>>
>>>>     Merge branch 'patch-1' of https://github.com/sweettea/fio (2021-10-19 16:09:21 -0600)
>>>>
>>>> are available in the Git repository at:
>>>>
>>>>     git://git.kernel.dk/fio.git master
>>> I just noticed this. Is it possible to change this to specify the https
>>> URL instead, since the git protocol is insecure?
>> Both will work with git.kernel.dk
> 
> I understand, I was thinking we might want to default to a secure protocol.

If you visit the page, it is listing both. This is just my script that sends
out the changes, don't think it's one that most would find and then use to
clone :)

-- 
Jens Axboe

