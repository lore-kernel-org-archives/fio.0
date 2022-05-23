Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C458BC433EF
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiEWSf1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241339AbiEWSfG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:35:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355DE73556
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:12:56 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 202so7392501pfu.0
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lyfVcotX01/Ra23SkYH+b8OKj1xNo0lFa7Eh0qfuY+E=;
        b=yHrb9jOXBaZ3nOKMV4pkuXkJO7tBfBO0W7dVOeTfy9EXKls9AC/hkoCSFyY3zRPkfH
         lD1+LTqUO5bhPksLLy1tHQEmLsw0gi13d4zCbjh2VbszXMNrvfDAE2A6QXrtFr69G89d
         oHX+7e3GyCbsntHH+xmIU/r8daFssHtd2yZiUAj7MVipQchfwyuKOd/orowcdA9tdfHQ
         05mIvGLz2WIwMKRh7AQOipXGX69VvOQucSitnmTkXWL6isznCPn9JCyQQDm+e2KRd7gp
         IOOv2cTT5gVp0sPj4NO/KqxrLBjcyKDZVq/RBy81YZvv9ELJwz2+Tv2tE7MVHzct8zuj
         Tvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lyfVcotX01/Ra23SkYH+b8OKj1xNo0lFa7Eh0qfuY+E=;
        b=vafkzZ22BQ1XjZzaxtSmNXNXrOvV87cjQDSaZmIe1lT/60Upxb2xia6Z92MP9Wnpxf
         M4jjbG1erKH1CdQoO3D7Mw0Bf9j0Uk1ZSwQMyJyWD+FURVtOs0QuP86S6Wj7cfFBcLOc
         H7EE3hK/2o30976m3hcZkjdiDFpdeBYkn554CIFZdU5/73/VNOsm5rvqQLIEjoL2ei0u
         rw1qGhNK0GPlR4yMPb2S/4tqA09oXkHZ8cMurAoVdGg6cwwVs9rA2TfKVEC55AXo7HCj
         ZBcgWJ3nk1z7/Xlc4N97wyFoP1slFGCQP2etTcWcmWlN+UU+xgbR+WOjjx4v6JOgHvxV
         VWVQ==
X-Gm-Message-State: AOAM533zHwSs4UhsOVWnpckUsIG5rXWZSgRCsPx6dJfg8qxB8hP2etkJ
        XxgYSWbIZHwEDb5Fe8wnA1qsUw==
X-Google-Smtp-Source: ABdhPJwQDnpZCPJ7IHhKtUnpNEkOn2pW6KppAkZADzF6N3akb3OEb2fnNyfS/9rL0WWV0YdQj0EBMg==
X-Received: by 2002:aa7:888a:0:b0:518:a0b8:f5c1 with SMTP id z10-20020aa7888a000000b00518a0b8f5c1mr6053234pfe.46.1653329575032;
        Mon, 23 May 2022 11:12:55 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 11-20020a62170b000000b005189f7ab7aesm2797394pfx.19.2022.05.23.11.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:12:54 -0700 (PDT)
Message-ID: <3aeda4fc-4ea5-3dda-12c8-ed95403f9862@kernel.dk>
Date:   Mon, 23 May 2022 12:12:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5/6] mem: try to parse /proc/meminfo to get huge page size
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220523175650.130895-1-vincent.fu@samsung.com>
 <CGME20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1@uscas1p1.samsung.com>
 <20220523175650.130895-6-vincent.fu@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220523175650.130895-6-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/23/22 11:57 AM, Vincent Fu wrote:
> Instead of relying on a platform-specific default huge page size, try to
> parse /proc/meminfo to get the huge page size when it is not explicitly
> specified as an option.

It's really sad that there isn't a nice way to get this information, but
parsing meminfo will only get you one of them. Eg on my laptop:

axboe@m1 ~> cat /proc/meminfo | grep -i size
Hugepagesize:      32768 kB

But if you look in:

axboe@m1 ~> ls /sys/kernel/mm/hugepages/
hugepages-1048576kB/  hugepages-2048kB/  hugepages-32768kB/

and each directory has entries for increasing the number of them and how
many are currently there.

Parsing /sys/kernel/mm/hugepages/ is probably a better idea than
meminfo.

-- 
Jens Axboe

