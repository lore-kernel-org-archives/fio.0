Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71D4ECAAD8
	for <fio@archiver.kernel.org>; Thu, 22 Sep 2022 23:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiIVXL3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 22 Sep 2022 19:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIVXL3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Sep 2022 19:11:29 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A218CD2D5B
        for <fio@vger.kernel.org>; Thu, 22 Sep 2022 16:11:27 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso2240767wmq.4
        for <fio@vger.kernel.org>; Thu, 22 Sep 2022 16:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3d0KJHBYf+2XOzB0h4hbgbgKjfoRIPIvNexK/yd6KiQ=;
        b=MMAgZgh954WN7VT5czgX5d2PM7UAS6jGrKv7/I3YFCe5KP9nfNdR/wEd2D3e/2G77y
         4NDVwprxZSvlef0mftFWHrKtP5WVuspxSmn+QsAOPgndHjVPJjcgmHn+0OoXS6BQMezg
         qPwa2WBQiXdlKSQJjaTwQ56E8ArRGunAL9PeQUSmLaeb13VK8aeEZLL0J5MFh3B9bOc6
         KlGDRRnyiTsOTkOVlJzAUw0V7ZVP54PqY40+DAaOKn+/QVBPLIZHlLkzbDsh14hQa/29
         CU3MFPuEPbV7xzVMVH41kpmIsGmjbqzWjZUb7K+uXbqS60N3ERs+VGkqAamU2xTU2Wx9
         Ew/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3d0KJHBYf+2XOzB0h4hbgbgKjfoRIPIvNexK/yd6KiQ=;
        b=rIxSu4qWjlufsEfmhFAH5bWP+ipxCGuQ1uONip/GpIcL1Re0NB9/knWRjn6RZ/4FfK
         wT3zJodEkheKvrQgyJR2sQ9e+KdgHwJwSEVxeT95N0WUGKe8atyUqBg6eBG8YIYKBzKR
         fBw9JDT3KUG2XgJyOj7bhfLAIyxZf2WFUOpNcJG56YtoUZRkcHeliPL6+q/JdYILXklC
         1ftnthqXcHKwkLhGzKfLNFFCuxxb01GosRiHLd92cfty6YoJeia/hUld27pBhUavHu4m
         aFnz4R5dUMHKIse+PCoPjuOMJ5C6sBMN4NlbBud+Si8K1tAnY/KFOwRd4LNqW7nHXa1H
         To4w==
X-Gm-Message-State: ACrzQf21qmgrbhGy/Bc8AMEVkjcEdgTde5rNioWmm/f5PRBgjing9hpQ
        eebwlPsO0xJK0S0cB5z4znsh3OTnLd9trenwaHWlOG1iKl/1qg==
X-Google-Smtp-Source: AMsMyM5/CJyZW88ZMSR6TL54KM6lPw3/TPQ0Rk4hLZrOvnpRLSCkuPIQzA9V8yCvZ8BCgzmwVQe65rt65rU5LPivL3U=
X-Received: by 2002:a05:600c:4ece:b0:3b4:a79c:1333 with SMTP id
 g14-20020a05600c4ece00b003b4a79c1333mr4003343wmq.49.1663888286143; Thu, 22
 Sep 2022 16:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com> <CADqNVTqQLuC6fXsBg6AnCgFWaNiDX=vjOhHvAskm_EP_vD-Q_Q@mail.gmail.com>
 <022e132e-f051-28af-f85c-c2700b9ba992@opensource.wdc.com>
In-Reply-To: <022e132e-f051-28af-f85c-c2700b9ba992@opensource.wdc.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 22 Sep 2022 18:11:13 -0500
Message-ID: <CADqNVToJWUPRb7zP0AD5MVagmgtjVB-_OxhvKQJV3zKAxL3g=w@mail.gmail.com>
Subject: Re: Best practices for handling drive failures during a run?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sat, Sep 10, 2022 at 3:28 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
> You can use write-long, to "destroy" sectors: you will get errors when
> attempting to read the affected sectors. But that is a really big hammer. A
> simpler solution is to use dm-flakey to create "soft" IO errors.

Thank you for mentioning this - I'm not a linux veteran so I did not
know about these tools.

I tried dm-flakey, but when the device is down, the errors are
returned immediately. I also looked at dm-delay, and that actually
worked pretty well for getting fio to sit and wait on an I/O.

Unfortunately I have a hard time getting the delay to be "big". The
time it takes to add the delay rule appears to be a linear function of
the amount of delay, with a very big constant factor. A half second
delay takes 11 seconds to add, and a 5 second delay takes 112 seconds:
sudo time dmsetup create test9 --table "0 1024 delay /dev/nullb1 0 500
/dev/nullb1 0 0"
0.00user
0.00system
0:11.28elapsed
...
sudo time dmsetup create test10 --table "0 1024 delay /dev/nullb1 0
5000 /dev/nullb1 0 0"
0.00user
0.00system
1:52.70elapsed

And unfortunately something breaks at some point, as my attempt to do
a 70 second delay had not finished after 2 hours. I'm experimenting
right now to try to find a smaller but still big value that is useful
for testing the nvme timeout/retry defaults. I've seen code snippets
online though that set the delay to 100 seconds, so I'm at a loss why
the time to do it is growing so large on my system.
