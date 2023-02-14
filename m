Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3F9C61DA4
	for <fio@archiver.kernel.org>; Tue, 14 Feb 2023 15:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjBNPcV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Feb 2023 10:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBNPcU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Feb 2023 10:32:20 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092EE25B9C
        for <fio@vger.kernel.org>; Tue, 14 Feb 2023 07:32:20 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id 5so17833294qtp.9
        for <fio@vger.kernel.org>; Tue, 14 Feb 2023 07:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F5EeQ4oroWwq2UbUgLk6P2z5Dwt0YyPh5Q5qqAH7At8=;
        b=agG4dhxsvauQOnFvPgwX2As0Bt9jL6h7EKEnJKDvePlKmLfnJgl5u6dkbB4k8Fcs0a
         6pIkdo1YNVNj1bqpVf2orrMDQcdUo2aAUgltlmtt3H43qlawwf/VYK8V905n+ElZq931
         LLEUz0HoyQc7dMavLtEHuZSFML6zTRZGFOcFGzsbwcWSznXUYd8Omqd2msYYinJ849Ka
         JcLhkIuLqejwYW64d/cYehNiEi7GMGw06eK2mc76aq9aHaNcZkT3YhvkuHhWMbrIkwT0
         hi/Zy7VrOe/Bax6vdrXCdGesMfh6MiRzWMflZiGa2vIkr92oVZBBK9XrfHLprfcAlzHR
         0siA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F5EeQ4oroWwq2UbUgLk6P2z5Dwt0YyPh5Q5qqAH7At8=;
        b=l/ZpluxizcnOcVbWBrFlH31y2/rBaB8ksAgDp9HQIeSmf7cUAd6ANcxpR7jp696lKY
         WnNZb/TZovkYPzkpb+zAzN55CiQXz+21eGDTjNMc2SX3+wo6qptZcZ0SPWbH8B7t0sbl
         5OaW0E02BLa2z/vXIRsCtl0URedEp22Ee7RIO3XBQBdU+uXeHiWriFNqftLhA+xFlMhJ
         HRMCRlpPwFYxYwBzQAwNHkbGMsmsQBbpAHRPAStbDGRo853O605Y6XkRU76+94XzNufj
         VvwksHDkrcSapf9+0X7z4dwW2nY4jMeYn0VVx0q7SK31Dt87RLCJNKAfpXZwEJ8fIA5K
         7C2A==
X-Gm-Message-State: AO0yUKVOQxevI7wy0P2KmiVVN0H26mMtf9o++ttIOHT1iCo2g6h17ckm
        KbqMXVamDXXcqKyTaRXjsfw=
X-Google-Smtp-Source: AK7set/b7Jtw0hUa1pdvCsjh5gxn1oG/zP3Rn9NnamUxk2O8YmEYkaTirSXzObIoWvXsgSsA1BDuxQ==
X-Received: by 2002:ac8:5992:0:b0:3ba:1c07:e472 with SMTP id e18-20020ac85992000000b003ba1c07e472mr4929097qte.51.1676388738979;
        Tue, 14 Feb 2023 07:32:18 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id k6-20020ac80206000000b003b86d5c4fbbsm11576644qtg.1.2023.02.14.07.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 07:32:18 -0800 (PST)
Message-ID: <741027bc-2639-4078-49c2-d10ad8767065@gmail.com>
Date:   Tue, 14 Feb 2023 10:32:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH fio] examples: Small updates to nbd.fio
Content-Language: en-US
To:     "Richard W.M. Jones" <rjones@redhat.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <20230213132327.445863-1-rjones@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230213132327.445863-1-rjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/13/23 08:23, Richard W.M. Jones wrote:
> Improve the documentation, describing how to use nbdkit with a local
> file.  Move the suggested test file to /var/tmp since /tmp might be a
> tmpfs.  Use indenting to make it easier to read.
> 
> Use ${uri} instead of ${unixsocket} since nbdkit 1.14 was released
> nearly 4 years ago.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>

Applied. Thanks.

