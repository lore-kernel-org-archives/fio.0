Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1ADC433FE
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 20:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8609E61AEE
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 20:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355412AbhJAUr5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 16:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355403AbhJAUr4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 16:47:56 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478FC06177E
        for <fio@vger.kernel.org>; Fri,  1 Oct 2021 13:46:12 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r75so13119697iod.7
        for <fio@vger.kernel.org>; Fri, 01 Oct 2021 13:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3DybLe1RpzKsxnKzIBemCIAZ6AMadRGjezFEaPOKcoc=;
        b=0Mqo6jiy7LSz9NJceKhYYwz+bqIpqn86YEP1lSboYwJsyrCWFDv/zPuusAreK8LrbG
         dOBy6xQbCFWUnsJObIKSGUolFp5JpxVy+iZDnwfjQwkq9+j/kgq9Cfk/PddfFBicXVBe
         0rd4X6Fx2ne9F0PRJlCIOOIS/mZmvNqpFOZf1QSaBXxmORDRUi5cQDOZ7zlkH1Y+cgvA
         PMrEFuspnAugsz6ebvjI5S77M7PiekhFkEoeKAohXo+9ql6L2QtTwpe/hMrsKT4Z/G2l
         1mUOynhnX9wo/GgXxj7XF6oSFe6EhnG1TpL6naVXtsttClWegRM/ili06+pB91QSIPtq
         KFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3DybLe1RpzKsxnKzIBemCIAZ6AMadRGjezFEaPOKcoc=;
        b=zZl5f116R3iZYJNExH6i4O/uVVXHJHMyf9SFl875nOkLhj/F8c+S0/X8ZhV1v+r7WQ
         t8Qu7bAPW98XfNym7GdyZbuhrsHL1YOrF8zpTQqhdp+Mrtou3IzlMZLzOnkB/kZKD+aB
         hI5Dl5tLBuZdV63Lf0oOmx89d9yXoqctw33E5agA3mN22fA1KfrO07rVDrrrS4YToSw7
         bz3tc4Mztgl/G7hLRjjwzLDgdDXjxKHVCBpFq8H1buuiVrEoQ7WL7HBfigPbFI9fSzdJ
         dy4E4hsY3LBpiwH+C3zPhgW3ce2SvpNFPrXmEGLdHqmHQVjeaKi5rQLKCZIOvXPjo8Fe
         oRpg==
X-Gm-Message-State: AOAM531zE9VHy5FdjwLubFT7+SvfJknmSQEsrmTcpaAfg80AvzfPjxBk
        0Df5LTsguYoPh8a7GnRjrC7gVpJ7Ky1lIg==
X-Google-Smtp-Source: ABdhPJxRF3HtTAPQy1InC/PX0rp3wBc3cCHRSp5RngTsCHkXQyq7cht+lu3OYkDNBl265bIMoy1VTA==
X-Received: by 2002:a6b:8b52:: with SMTP id n79mr40121iod.8.1633121171288;
        Fri, 01 Oct 2021 13:46:11 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o3sm4144856ilh.5.2021.10.01.13.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 13:46:10 -0700 (PDT)
Subject: Re: generic/095 failing in ext4 and xfs
To:     Luis Henriques <lhenriques@suse.de>, fstests@vger.kernel.org,
        fio@vger.kernel.org
References: <YVdBVdOjPLCayG1k@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <882f4c20-2e21-219b-0ca3-7e215e2d7cfa@kernel.dk>
Date:   Fri, 1 Oct 2021 14:46:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YVdBVdOjPLCayG1k@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/1/21 11:11 AM, Luis Henriques wrote:
> Hi!
> 
> I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> Here's what I'm getting:
> 
> # cat results/generic/095.out.bad 
> QA output created by 095
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
> fio: pid=4090, got signal=11
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
> fio: pid=4086, got signal=11
> Silence is golden
> 
> This was for ext4 but the output for xfs is similar.  Since fio is getting
> killed I suspect this may be an issue with this tool.  Thus I'm sending
> this to both fio and fstests mailing-lists.
> 
> I'm using a 5.15-rc3 kernel and fio-3.28.  Is anyone else seeing something
> similar?

Hmm, do older versions fail? I see Ted suggested that 3.27 doesn't, can
you give that a go? If that does work, would be great if you could try
and bisect it.

-- 
Jens Axboe

