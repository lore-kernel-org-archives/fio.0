Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B81C32771
	for <fio@archiver.kernel.org>; Mon, 26 Sep 2022 19:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiIZTPF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 26 Sep 2022 15:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIZTPE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Sep 2022 15:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23C845076
        for <fio@vger.kernel.org>; Mon, 26 Sep 2022 12:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664219701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vhnN07WkwVkY/KiYtJuHP7OYdXh9qy32bxwPCTJWUNI=;
        b=iIak6uzHT1SZY/kVA1W4qEOccylFC7VZ7Pqv4RNq3pVqZKwJ3a+adISxSqI7dyxlxjy0uz
        0hG9WO/tTa4g3SwVkb/3iIPCBqxmS6lTDVktclKjU0XkO3sVPW7vhek4eGY95yjtM6Sm5D
        xUob84PCvW9sVvnl2la68J/SzlikLio=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-qzKL4n4kPzuUk0HjZfZKWg-1; Mon, 26 Sep 2022 15:14:57 -0400
X-MC-Unique: qzKL4n4kPzuUk0HjZfZKWg-1
Received: by mail-il1-f200.google.com with SMTP id r12-20020a92cd8c000000b002f32d0d9fceso5914417ilb.11
        for <fio@vger.kernel.org>; Mon, 26 Sep 2022 12:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vhnN07WkwVkY/KiYtJuHP7OYdXh9qy32bxwPCTJWUNI=;
        b=XhjDlshie8rvWPHShfa6uHRTGyz6z7qcXBU/gPObugyp74Zrb5VIi+Wq4Jh6evL0vM
         UO2k0gU/0l2m41Ci9ez4iEvGJFzJ2hVpzp9IidREB+8FpuAkeF9MjvcGR/zoh+myDjHO
         WOu9W8I63/z4UwoY62PbuDY6DbD5gOVPFqe8qKSDo5+QE7qmOgUSGk65c/FPzi1XSCgu
         UgylOD3zFWh1UIEhzGRMSrwAGDHrheiEAJKVAPG45pLtIC2XGT19SiouYDj1GKegAYW0
         qAm20hrMjZDEil9c8sFC00RvtHLSKL3NlCDSoQABAgUAaUP6J4qXLQ+YJJQX7V6T7Njy
         8Ddg==
X-Gm-Message-State: ACrzQf2XA9/KRiUbJokU6+9cce0AMe7UF7+eRSqedk0jGwcKB53A+4NT
        2jzZwRDF/1h2wTjFkkaMsnEYQmJ0SR2zGbRz+01gsvLkQUX1WghqGgowjs+O5XyA25gCT9aHZbH
        x9HDy4UF9HZ3ALK8FX3qy9x+S+TqP
X-Received: by 2002:a05:6e02:1749:b0:2f6:9928:f1d with SMTP id y9-20020a056e02174900b002f699280f1dmr11022769ill.52.1664219696513;
        Mon, 26 Sep 2022 12:14:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4r7LucXen6S3rwCNOzb0vAT4b/XhBJlJaoLaW/pUi0ZyIyuns2lwuk8XZ0MCBdbQitCIATc3ENkuUT0ICF/9U=
X-Received: by 2002:a05:6e02:1749:b0:2f6:9928:f1d with SMTP id
 y9-20020a056e02174900b002f699280f1dmr11022759ill.52.1664219696293; Mon, 26
 Sep 2022 12:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com> <CADqNVTqQLuC6fXsBg6AnCgFWaNiDX=vjOhHvAskm_EP_vD-Q_Q@mail.gmail.com>
 <022e132e-f051-28af-f85c-c2700b9ba992@opensource.wdc.com> <CADqNVToJWUPRb7zP0AD5MVagmgtjVB-_OxhvKQJV3zKAxL3g=w@mail.gmail.com>
In-Reply-To: <CADqNVToJWUPRb7zP0AD5MVagmgtjVB-_OxhvKQJV3zKAxL3g=w@mail.gmail.com>
From:   Bryan Gurney <bgurney@redhat.com>
Date:   Mon, 26 Sep 2022 15:14:45 -0400
Message-ID: <CAHhmqcQkSUQ184JFtkfyVS24QfYqa_nG+guNf9c1dXf+ArZbBQ@mail.gmail.com>
Subject: Re: Best practices for handling drive failures during a run?
To:     Nick Neumann <nick@pcpartpicker.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Sep 22, 2022 at 7:11 PM Nick Neumann <nick@pcpartpicker.com> wrote:
>
> On Sat, Sep 10, 2022 at 3:28 AM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
> > You can use write-long, to "destroy" sectors: you will get errors when
> > attempting to read the affected sectors. But that is a really big hammer. A
> > simpler solution is to use dm-flakey to create "soft" IO errors.
>
> Thank you for mentioning this - I'm not a linux veteran so I did not
> know about these tools.
>
> I tried dm-flakey, but when the device is down, the errors are
> returned immediately. I also looked at dm-delay, and that actually
> worked pretty well for getting fio to sit and wait on an I/O.
>
> Unfortunately I have a hard time getting the delay to be "big". The
> time it takes to add the delay rule appears to be a linear function of
> the amount of delay, with a very big constant factor. A half second
> delay takes 11 seconds to add, and a 5 second delay takes 112 seconds:
> sudo time dmsetup create test9 --table "0 1024 delay /dev/nullb1 0 500
> /dev/nullb1 0 0"
> 0.00user
> 0.00system
> 0:11.28elapsed
> ...
> sudo time dmsetup create test10 --table "0 1024 delay /dev/nullb1 0
> 5000 /dev/nullb1 0 0"
> 0.00user
> 0.00system
> 1:52.70elapsed
>
> And unfortunately something breaks at some point, as my attempt to do
> a 70 second delay had not finished after 2 hours. I'm experimenting
> right now to try to find a smaller but still big value that is useful
> for testing the nvme timeout/retry defaults. I've seen code snippets
> online though that set the delay to 100 seconds, so I'm at a loss why
> the time to do it is growing so large on my system.
>

Hi Nick,

If you're trying to create an error at an arbitrary location, at an
arbitrary time, you might be interested in using the dm-dust target.
The documentation in the admin-guide for dm-dust [1] has information
on the command interface that the target uses (via the "dmsetup
message" command) in order to set up a specific failure scenario for a
test device.


Thanks,

Bryan

[1] https://www.kernel.org/doc/html/v5.19/admin-guide/device-mapper/dm-dust.html

