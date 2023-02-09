Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ED3C636CC
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 00:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBIAYV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 19:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBIAYU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 19:24:20 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AE41B557
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 16:24:19 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id f10so341423qtv.1
        for <fio@vger.kernel.org>; Wed, 08 Feb 2023 16:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jmVyWzcV61jp3iC4kc4T2iuo61Ge4KFvyr2rRUgFTJw=;
        b=RPmh98CFL5jfr6eUjG0wWNxt/cdym1dM4fILS+/V+83g3QNhi+LgtHz58ymCMwffT4
         M7X5v16Y1ngx0vLlBhvSFYLDsBvx+fPLA//OoL89fndtEx2mEPlYDGQlkuyPZPQqImBb
         Gc9tBM9s+ZMBZx44uXNwJ9u5LW9svm0WEHl0t0ZKe2NTIULkiKIe4EXFdHOQrZahjub3
         2LalL1EsnMghItnjyOvrfhWUGVD69hftOQqZAx4quf0fCWRKDxfqCrvGNN1jsmeJNXwO
         i1YO36jld4pjiAbopfPkXgQSjv/6sl9qLu2uxPS+J1wwiZD8d8pdJ7n/RjBJodVceW6t
         b94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmVyWzcV61jp3iC4kc4T2iuo61Ge4KFvyr2rRUgFTJw=;
        b=eLPLf2B4Dq9QIlabR9Dshrha3qKSM7qv1lZYL8MqwXW5WFmXanzlgMecKv/OQGSeZv
         oyMT/XOqSwYVIYDllqGILRNyeXw3iygmcu4twgY1u1u+aLZcJJr64Wq5Rqnhv+Fgeo6i
         Ela6N3/3pKj0vvNpGzZ0Oik3pb0sjglQ+e3clwIBDsWZ+0UOxOQUr+iEyFfxSL9qQgDG
         doMhhtc2tGLaU5UkhX8lAGygXJNlf1IV6VcWyJerBiCZMb8itraJpKKs28GvlLbCZFWw
         Hq4VwDYPxiyg5iYFzugbsByN9xoJj4MSKp3XH6Ki6fVF/C/z92Dd9Vf0TpMbj1wOSSjR
         lvhg==
X-Gm-Message-State: AO0yUKXUh51NVJPoHq/u1o8MWYFyKQzjMy8isk06VMmDM6yr1f4xcOXI
        G+BPZ1//eWwWwD9XWpv2E2CQAiNJSW1QSQ==
X-Google-Smtp-Source: AK7set9Paapk3yQkAtkaR4OGa6HK1nT1EZZFXceY6rL0XYMjluLYzzJYcJNlPDIcIK3Wq1rS7YlYdQ==
X-Received: by 2002:ac8:5b51:0:b0:3ae:2272:e43c with SMTP id n17-20020ac85b51000000b003ae2272e43cmr15526539qtw.29.1675902258470;
        Wed, 08 Feb 2023 16:24:18 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c18-20020a05622a025200b003b85ed59fa2sm214067qtx.50.2023.02.08.16.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 16:24:17 -0800 (PST)
Message-ID: <c83b9788-63eb-ebe1-51fd-67873fd0746b@gmail.com>
Date:   Wed, 8 Feb 2023 19:24:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230208222023.895024-1-kbusch@meta.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230208222023.895024-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/8/23 17:20, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> NVMe TP4146 creates a new feature called Flexible Data Placement. This
> feature allows a host to tell the device how to group write data through
> the use of "Placement Identifiers" in write commands.
> 
> Add support for using placement identifiers in write commands. The user
> can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
> ioengine. By default, the fio jobs will cycle through all the namespace's
> available placement identifiers for write commands. The user can limit
> which placement identifiers can be used with additional parameter,
> "fdp_plis=<list,>", which can be used to separate write intensive jobs
> from less intenstive ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

You need to git add fdp.h.

https://github.com/fiotestbot/fio/actions/runs/4129005801

Vincent

