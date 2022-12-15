Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96D0C4332F
	for <fio@archiver.kernel.org>; Thu, 15 Dec 2022 19:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiLOTmg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 15 Dec 2022 14:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLOTmf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Dec 2022 14:42:35 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED4511C7
        for <fio@vger.kernel.org>; Thu, 15 Dec 2022 11:42:32 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id g20so180072iob.2
        for <fio@vger.kernel.org>; Thu, 15 Dec 2022 11:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VxdnQMCwu6HCBvz7hIL8gaG/MAkOvNlbfW2rhy2Uo50=;
        b=kkpyZRGwbnyQqW19XMvXFMXh1IrDc8zfqPi3D7eR7qSBu2BL+fjdP6PcWXyb50XwLL
         A31T7i1VjAOFI+7FDQ6FY+wmVBX1zAKMfdk7P2zlmEU0ECtvzT/A5D7QyUlzKVdZRs0h
         K5lxWhxHnVugAISfaV7Hlt74r2oFY6ZSRNJ9isR2eNRoGlgxlXK6YSoFBOpaCaHc8OLX
         cRD1CpuTws+BKtNSN4UVw3bZazzcZVtNxSNufJJ9LG5SDq9FzH7+v091ICwI7/Ruds0Z
         f7X0Fz5MsZGJAUr3ytEXh3FhSeRmvkzS+kRaNeKvLf/p3Ay0HeoJj1YAR2jAlsRC3HvZ
         cb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxdnQMCwu6HCBvz7hIL8gaG/MAkOvNlbfW2rhy2Uo50=;
        b=F5r8u21x8aYQbu5mD+JymYeK2bqys67dH2WiYkLzsAM++0nvpn+ux8TaXqZRgocwdQ
         MPA4F2fE3bhnQymrA4TZDcrijRhPnN65pxJfaVTaosT9P+mMpgXFyh40ApS/MzxwcNbQ
         ScWm+6NjThpZ5a6r53BgISs/qGLWown87GhaCi63y1VDvVD8gg5z0OPzySMec4c11pzz
         ONncVTzRZD3GBDQhOkjVAX29Q5o/uLyXF+QdfMOIEa3FOrEOEZBFp6pBpSWgGMdrYr5y
         W+pV1oI1rdDPHfVyeoCIxrbixtba5vGh8CX2scm7h8iu22ht7bbzlkfrOqtxYkrGhG3s
         jg5A==
X-Gm-Message-State: ANoB5pnAfgTHR8gLdSf1+26NsQzm7XoEzZeLPI3IWCdUZkMgT/NSpam7
        cUU92nwnwnS5pGEWokqIByDTV8cALwfpSSRH5DE=
X-Google-Smtp-Source: AA0mqf6BPZRSCnRq4FUVuhhLjdpqvHAICKHZwdBvpVxoAxFZGYnOXZZPUQpLEqWJXFyLNlhodOCXyg==
X-Received: by 2002:a6b:c415:0:b0:6cc:8b29:9a73 with SMTP id y21-20020a6bc415000000b006cc8b299a73mr3263958ioa.1.1671133351626;
        Thu, 15 Dec 2022 11:42:31 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v11-20020a056602058b00b006bb57cfcb88sm1412417iox.44.2022.12.15.11.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 11:42:30 -0800 (PST)
Message-ID: <0503ccaf-d958-b919-9f59-dbc8be8710a9@kernel.dk>
Date:   Thu, 15 Dec 2022 12:42:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 0/4] clarify usage of options for zonemode=zbd
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/14/22 6:56 PM, Shin'ichiro Kawasaki wrote:
> Options for zonemode=zbd have some confusions. Clarify their usage by improving
> HOWTO/man descriptions and example scripts. The first patch fixes a minor issue
> found during man page update. The second patch improves the descriptions about
> max_open_zones and job_max_open_zones. The third and forth patches show how to
> use zone_reset_threshold, zone_reset_frequency, trim workload and 'z' postfix of
> size option.

Applied with the wording fixed up as suggested by Damien, thanks.

-- 
Jens Axboe


