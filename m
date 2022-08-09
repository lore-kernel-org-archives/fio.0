Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6287AC19F2D
	for <fio@archiver.kernel.org>; Tue,  9 Aug 2022 13:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiHINKF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Aug 2022 09:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiHINKE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Aug 2022 09:10:04 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD3B851
        for <fio@vger.kernel.org>; Tue,  9 Aug 2022 06:10:02 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z19so11307531plb.1
        for <fio@vger.kernel.org>; Tue, 09 Aug 2022 06:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=QWWpHXZSYCLpv3on2tdVUsrdvcD0dUStTo6QznXON4s=;
        b=HfwbbIDSUPmmX14aItAt2MPewexQxpm77gQE7TqRws2ebE4BVJYh89zZUT5KrOqg5k
         Co8QhD9jIsw6sBEMpg3WGv79jXg73yxX9NraKxEpW3oenznMgpstdP6R+MnXKjz6VTQg
         gExMrdlA3SgG3u1wYFRgS9rRyxLqocMq/xKJR1Eqy3+30UnFOpowZOtDv4dlwTLhwngd
         F2AgB3FWHvCc3xqGucSycEcFi9od/y9PhKUE2kZOrwQ4nz1xkh610JsZbgsQo4Xw97qM
         woRQ6+5pm+OpxX/c4dw/E9fA/mRuH1+Ng/XC/GOIlsCLNvD/93zHDQBpI4aBn73fLOdb
         5d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QWWpHXZSYCLpv3on2tdVUsrdvcD0dUStTo6QznXON4s=;
        b=VLCbY6fIVp0SJH+/iUdINT5cotiuZQYQozvZb3zsFekEimuySaud1HaxksJMu1k8IZ
         fv+d8iE1+ELScSDAmv3pdbMbqfVjEa90nge1U6UfmRfrAZJaCvciOnpinoZxF/sT1Du6
         OUd/PA9Rlw0ufuxnW7dCA36b1oSg7ApK3wx8injEk6xDnQ7uFiyrx6IrKBDWVOJotQqj
         dc7g5VJXFykW3P2LHmFg9uhWwc6vyp9M7v7YXRSBmYswFVKRcDzngqglZzh3hsqp3TOf
         NiNPQNZ6/ZKl9P5V7z29KnNifdbZogoAaC4k6Ge4EbrbZVC2v4RXA8Ji6qcm8MOIi6sR
         4CMg==
X-Gm-Message-State: ACgBeo2QlWaKCtm0OT1clguKucHouWG7dYh0pPaYq3tQTqza91Fey58q
        rOJ7qaLzQtdVU4yldZz+vuzc2LjXuzPrXw==
X-Google-Smtp-Source: AA6agR4ZiPks2e+hRtFhLkjO4M6TPk2kSu7STUz0mt0QNnDcwxfW8CXnnqhtZONexS2tZZpMVpxxZg==
X-Received: by 2002:a17:902:988a:b0:16e:d52a:cce4 with SMTP id s10-20020a170902988a00b0016ed52acce4mr23832462plp.127.1660050602306;
        Tue, 09 Aug 2022 06:10:02 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902dacb00b0016dcfedfe30sm10902212plx.90.2022.08.09.06.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 06:10:01 -0700 (PDT)
Message-ID: <746d3789-1551-6649-e49e-2472954be751@kernel.dk>
Date:   Tue, 9 Aug 2022 07:10:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com>
 <20220808175133.37920-1-vincent.fu@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220808175133.37920-1-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/8/22 11:51 AM, Vincent Fu wrote:
> Jens, here is a patch that should allow AppVeyor to upload Windows
> installers as GitHub releases. This will require you to change the
> authentication key in the patch to get it working.
> 
> Here are the steps:
> 
> - Go to https://github.com/settings/tokens and generate a GitHub token
>   with public_repo scope.
> - Go to https://ci.appveyor.com/tools/encrypt (and login) and encrypt
>   the GitHub token from the previous step.
> - Replace the token in the patch (under auth_token: secure:) with the
>   one from the previous step.
> 
> To test this, push a tag for a commit on the master branch to GitHub and
> we should end up with a Windows installer at
> https://github.com/axboe/fio/releases

I applied the patch and updated the key, and pushed a test tag. Let's
see if this works!

-- 
Jens Axboe

