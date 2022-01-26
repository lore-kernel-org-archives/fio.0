Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5F8C2BA4C
	for <fio@archiver.kernel.org>; Wed, 26 Jan 2022 20:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiAZUNQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiAZUNP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jan 2022 15:13:15 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928EFC06161C
        for <fio@vger.kernel.org>; Wed, 26 Jan 2022 12:13:15 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id w7so1012907ioj.5
        for <fio@vger.kernel.org>; Wed, 26 Jan 2022 12:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y7s4BAH18YIak//3LjiUdztqARZWa1oXLDOag2z4iHM=;
        b=ZUJA0RRCYzCMWI4eHQB41ilqbP406SHvYjLYiHAgUSDGdCfXxsGh0LtsJ5AKboHzcF
         cgIyYurhZo9IiEYa9h5ZdIE9JSZ8u07ZPIqzf6EZvloI7fyVnHuG+WntOd14WxT8ihJW
         aE4l4UgAiSpOYWTzCAR7a5qx8+dtMsGzmSaoXxLEKAiERxrlK7nv1xHdPFw6JkHXQ7V9
         BjeZuQm7xPc15lXmINKMfL7zwfhIRkqrErvLDt+Ty6+gYIgKaR895vG02Z1WfDilVWl6
         UNn4KqhK798Z6meLrC2hzH3OEdSETrzXC1KIuUG6iWkfV/+ZlfeauZRqS8FFAJ9VpQIt
         lR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y7s4BAH18YIak//3LjiUdztqARZWa1oXLDOag2z4iHM=;
        b=AGxd0/O3HlPs8nlOUa+SipkvGZZsLcrp8GZUUCxKO6nuMKJQ3SmIeBcGu4XB3AVjzM
         NdBHtzwiTZLJn8EOa2qxlJCnhPRKpcQQpcd3PsXBWakBCFB1evuq7+DCdxl1KW8bea/w
         aRpmnEjC3zP5qgQVGJep7jDVmtqbcjtk8d2ZteuukUmQBKdBw5ycg2XretuL5boOSW2t
         2In2UjcP0CSxtpf4OY66N2M4Y2gqNUTJgiVWyKMBSG1Tp6NGO+FxtCXzgXCku3V9O2aQ
         Pe2feVX5Nc0qBt8nPAT6dCMZ4rOD1FB6vqYPdKIeU+Yd6RuA20g7sYuklHI1kh8A3/yW
         3fAA==
X-Gm-Message-State: AOAM533gQDDlw+YJ4At8i8low4Rxvubqanh3ibDf7a+TF83IvENOU+pr
        HPUO2GhBZu5s11zN00P5E8o1xFiXCxH2/Q==
X-Google-Smtp-Source: ABdhPJxQzeL59qepn70mDFixQkzVNDYDcu/8X08Of+kfeIvKS0oZTB6v6lIO3Xt829ZvX5Ybg6PNiw==
X-Received: by 2002:a05:6638:687:: with SMTP id i7mr186497jab.180.1643227994585;
        Wed, 26 Jan 2022 12:13:14 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p11sm11239545iov.38.2022.01.26.12.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 12:13:14 -0800 (PST)
Subject: Re: [PATCH 0/2] fio: a couple build fixes
To:     Eric Sandeen <esandeen@redhat.com>, fio <fio@vger.kernel.org>
References: <7b124b69-1b3e-bc2b-e251-2b1ef165ef89@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a84a4015-f53c-5a99-a0f5-e7dd65a59dcc@kernel.dk>
Date:   Wed, 26 Jan 2022 13:13:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7b124b69-1b3e-bc2b-e251-2b1ef165ef89@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/25/22 11:55 AM, Eric Sandeen wrote:
> Maybe it's just me, but t/io_uring.c doesn't link for me without -laio when CONFIG_LIBAIO
> is set.
> 
> I also got a report that dynamic engines aren't properly picking up LDFLAGS set by the
> build system (in this case, -Wl,-z,now).
> 
> So these two patches try to resolve those issues.

Applied, thanks Eric. On the patches, looks like format=flowed is set, which
may explain why it ends up being borken.

-- 
Jens Axboe

