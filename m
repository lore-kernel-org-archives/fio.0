Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D0EC433EF
	for <fio@archiver.kernel.org>; Mon, 28 Feb 2022 22:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiB1WmT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 28 Feb 2022 17:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiB1WmS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 28 Feb 2022 17:42:18 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9D312E9E8
        for <fio@vger.kernel.org>; Mon, 28 Feb 2022 14:41:37 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id u11so19463694lju.4
        for <fio@vger.kernel.org>; Mon, 28 Feb 2022 14:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Nv0KJ0KEvZAUkRc0r58GXstA8ET7tQYjyjcev2yVPH8=;
        b=YyJ3rYTvX2ZDY3dH4HA7A2F2l7CKOTdEZoX/6JZQvBF96S3YbIKb+gJDZkHVybtgla
         DpCbgVu/iLuzMNuH7KbjGabxdq3EJMBV1/A8khaKB00az+TwWMaDK/sl6aiNyWwD777a
         FngvXHxJRRV9FP6wbcYrZy6Oj2G+NjIrio2PHjRpxtedrSHThyiM4o1LUngYbwNPa19j
         MpTgCJXVvrqLciQgD9sxuuqtrjwEHCOnQWQyATvI6JhfTX2llGs1TDGWGVA393JV5Hw1
         S4aG+lEwejY98lVLRpk1sTtSAdHcVGzyOnZ+DXm3aE2+vDb4tANznyWQg7tNnqFGunZC
         CBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nv0KJ0KEvZAUkRc0r58GXstA8ET7tQYjyjcev2yVPH8=;
        b=aZGl1iSd9hZIcecJVnOjXXDk80Ho/fPSuFV5+limcikBMGxPh5FvuPT69waooCllLd
         myyKozOn0maj2sLE+SoFg6B2fVIBkpwKQSmP+NS/0zLfV4JqvL2DD4RFwqWFe2rp8fOt
         ZImRk2ghB39Dm3N8KHZ7VTthEMd/OmdrC8r/b33e5lcFhO+mm6W4V59dmtrOSb3y4UK5
         oi+hvh5S9U100cO/0bganQCsESCP9/5oAsJeWeSBVPVTXzPXDshmmanrGRLyiMFkhitg
         Mim/inRsxTFFQcUegyspWwKJdF78DijZBypY6i2JZZeFH0tClldhJMJafahI+PzvoXsE
         fRFg==
X-Gm-Message-State: AOAM533xIb0OlUIGpGJwPuMSclYPbjeYOv4QJHPbsrUdjMqV53UYNy4j
        8kKba5NLSTJpH/Gh2r+o+ZsX5kuEQjw=
X-Google-Smtp-Source: ABdhPJxiMUhrXLL5ufHQVZDvKsi+eeR4viVHe41syLOQ0TuWffppUp2Oh8MemmEkfRkKeucbAK+Fsw==
X-Received: by 2002:a2e:9b92:0:b0:246:3e31:a80f with SMTP id z18-20020a2e9b92000000b002463e31a80fmr14913928lji.11.1646088095095;
        Mon, 28 Feb 2022 14:41:35 -0800 (PST)
Received: from [192.168.1.11] (77-121-241-86.kra.volia.net. [77.121.241.86])
        by smtp.gmail.com with ESMTPSA id a19-20020a2e88d3000000b00246585ccd51sm1572171ljk.14.2022.02.28.14.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 14:41:34 -0800 (PST)
Message-ID: <75df0a0e-6f0c-66a1-ab88-b735503d9ecb@gmail.com>
Date:   Tue, 1 Mar 2022 00:41:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Using FIO on systems with <=512MB RAM
Content-Language: ru
To:     Philippe Schenker <philippe.schenker@toradex.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
From:   Volodymyr Hoida <volodymyrhoida@gmail.com>
In-Reply-To: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm developing and maintaining web based gui for fio (w3top). And I 
can't confirm your concern.

On x64 linux, 380Mb of RAM is enough for both w3top systemd service and 
fio executable.

On ARM32 the w3top+fio pair needs about 300M of ram.

What engines do you use? I'm about libaio, posixaio, io_uring, sync*** 
and mmap v2.21 ... v3.28 on headless linux

2/21/2022 4:40 PM, Philippe Schenker пишет:
> Hello
>
> We use FIO to check the eMMC storage on our embedded boards. This works
> great for our modules that have >= 1GB RAM but on all lower-memory ones
> (<= 512MB) the OOM killer always kills FIO.
>
> I can hook up a swap which helps but is just painfully slow.
>
> I played with the settings mem, bs, iodepth and size but cannot achieve
> a configuration that works on low-memory embedded systems.
>
> Can anyone guide me how I can make this work?
>
> Best Regards,
> Philippe
>
