Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1B1C77B7A
	for <fio@archiver.kernel.org>; Fri, 26 May 2023 17:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjEZR2d (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 May 2023 13:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjEZR2c (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 May 2023 13:28:32 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7115FF7
        for <fio@vger.kernel.org>; Fri, 26 May 2023 10:28:31 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f8115ca685so488581cf.1
        for <fio@vger.kernel.org>; Fri, 26 May 2023 10:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685122110; x=1687714110;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g3MK05Rh6NKtOKRvoFmboUEhucO/pIYHUdthsiCOjeg=;
        b=H/8qf730EobDNmqoDPNDQBSCJ/Grt0IM0heoL6brq/9mheN0oHYnJy0zqyEyGUZA+D
         EwpTM43No6oXZ8UXW61TtXRj5sG8YieHB4uCpNlJ9lNZKkgPjkdWOM4T6RK65IqjcPuc
         aiB8BMbyHgd7xDodyWeL7PDfOpbWoVhtW1xfKd2Jm6Be99EMI/oLX9zKvd4nVS3OgVlN
         CJY+GZ0MtrCzo+5DZd4YGLgpHlm8l5IhJQi0MWCJv9AgMMBIWpLTDri56RRPahqwY1ga
         c5YWhNBwvcgSNxNB5EncAj04MwkmxA6PyonokgF7fZLHR3YTizPmXGqSGgyLVRhH/Jq9
         rlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122110; x=1687714110;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g3MK05Rh6NKtOKRvoFmboUEhucO/pIYHUdthsiCOjeg=;
        b=CzQYlD84omI6NQ+DfpH0FOkRpLw6S9FQCGuJE17vCAx/ERC/ETK47BoVyQnJuj/v7m
         +jySpVufQl1vDauulvtQIidVMZ5+84ra2QLKNiBoMYxUWNSDJDrREH+Pg1nqvbIEHu9s
         2SlI+kvHWBIkEiR6ZxMDjKl3ArOcP5QGDe7DpqhphWGNhcuIWQ0ex85AmJJFa3OMZXYh
         Ua5JdSjeQFlnz0rTfejHuaCciRqtPo3DW1qWRxinDwRJ9VMEqqrQvKYJEss4Ahbefao1
         0ZZbfGli2r+d7Mn3mHP8B9To0TjVYJvfTbGc+LcEFzZZKTuYjixxXHFVs76hCxRIYaKP
         lDWg==
X-Gm-Message-State: AC+VfDyCJ9cNx7kdUnzy7/Ap/jtyT/5IaZ5P4DpnBbOUMZXYZHbbggus
        2aZj8FOmKhoSAuAqXS2jCOAMkI3pkeI=
X-Google-Smtp-Source: ACHHUZ4slUk9o3bpf/wlBzMrebOZcTwO+h5z+p9pnhMPLD4nmztyKuvb39YuMhbQ+o5cEAngUulZJQ==
X-Received: by 2002:ac8:5c88:0:b0:3f6:b918:2351 with SMTP id r8-20020ac85c88000000b003f6b9182351mr2040272qta.0.1685122110250;
        Fri, 26 May 2023 10:28:30 -0700 (PDT)
Received: from [192.168.1.241] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bb40-20020a05622a1b2800b003e6a1bf26a4sm1400344qtb.64.2023.05.26.10.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 10:28:29 -0700 (PDT)
Message-ID: <09fe872b-37ac-48f3-44cc-5c17b48a7884@gmail.com>
Date:   Fri, 26 May 2023 13:28:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Ending condition for non-rr file service
Content-Language: en-US
To:     Travis Downs <travis.downs@gmail.com>, fio@vger.kernel.org
References: <CAOBGo4wFOxyXXhjeqk6MJ-QkjsaypQYOBaL8wCVkMpk6H-khsw@mail.gmail.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAOBGo4wFOxyXXhjeqk6MJ-QkjsaypQYOBaL8wCVkMpk6H-khsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/26/23 11:38, Travis Downs wrote:
 > I guess I understand when fio "stops" when using 1 file per job: after
 > `io_size` IOs,
 > which is usually the same as `size` if `io_size` has not been
 > specified explicitly.
 >
 > When size == io_size, this means that all blocks of the files are
 > written exactly once
 > with linear or random writes, except if norandmap=1, in which case
 > some blocks will
 > likely be written 0 times and others 2 or more times.
 >
 > How does this work for nrfiles > 1 and linear writes (rw=write) and
 > file_service_type
 > set to one of the random ones? For the non-uniform distributions some
 > files will be
 > written at a higher rate than others: does the write pointer just loop
 > when it gets to
 > the end of the file? So io_size writes will still be done, but some
 > files will not be
 > completely written while others may be written more than once?
 >
 > Travis
Fio's behavior in this situation is not explicitly spelled out in the 
documentation.

For a job with a single file, fio will just start over again and write 
the file multiple times when io_size > filesize. I would expect the same 
to happen when nrfiles > 1.

Try a run with --debug=io,file and let us know!

Vincent
