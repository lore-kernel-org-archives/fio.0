Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB409C433EF
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 12:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E2860EE2
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 12:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhJKNAy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbhJKNAy (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 09:00:54 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84543C061570
        for <fio@vger.kernel.org>; Mon, 11 Oct 2021 05:58:54 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id d125so3732496iof.5
        for <fio@vger.kernel.org>; Mon, 11 Oct 2021 05:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dHAxG+SBTUfLrJG1KHEteB3Yt5wkA+2ENjYbUGW25mM=;
        b=kadtHSwppB4c5wy4XiQ1hUZANIX9+EUEo6RDOXyJqYmlHA2LVFmNp09wpqxUwIjnRY
         HnKbWaw8GPMXHWo+h9L3jfMTrjqqdTiJUDUUZn4RfrHkICzDaKizqmrZCQ2W6ERbTLSA
         HJmHicPFsD0jNzOK26+fJbDT77YuOx5Qocb54CUGnQyc5xMvFZEKtj6tjjNLKmSnWqE9
         dteakKM2JPFTdY1kLRS5WWzk57uNW2rRjVhg0kaMhoMwGMvECj/Ft3oMYYBgTVdTkPD3
         sLwq5R8n9gmxEUFgpwWzRnewM66pBdj48i3g77egA0dKn7MDUYWkbNbd+3k+FXg0p0+x
         C78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dHAxG+SBTUfLrJG1KHEteB3Yt5wkA+2ENjYbUGW25mM=;
        b=LU6J/KZE+Z3t13E1ru1DVf+RnJvvMBxb6DXQbYVhKOzbj5Cof1SX0gu9v7bruUcteF
         Fib5I/8HpBuirn887+1DSDhLHANetr798BWhZOODvSxZ/FI0GKMku/H+fnxGrn71JIFw
         jtr6+fPJ+F9A2dR8tKXK73ZTdoIq2YryZHG3kf2mD+WD09hjETX06CT8RlVL+2eMK8RI
         4JvvoLRG+Gv0hihUYa2uWsaLuO/w/S8PUNQwg0nlBaM9uHAr5jDIcg9HOSRR4d46hCIm
         7LVhnDAEmkGfoeXIJDDgbLFfYjdtQTflSgVnzUHfxdtxJU5IAt7bXDbX/+kXTzhKEmKn
         wPtw==
X-Gm-Message-State: AOAM532ewALoJrjsGurn7Sq/9yKcIe4L1jYGUR9eFwNdj/kLWMa46wi7
        QY/sjDjUoM75BEezYNuGIsq/usemM1FJnw==
X-Google-Smtp-Source: ABdhPJypMPnpindrB0TZ+CfTLMS4MH1BvXzBfKT3n/JbQ6O9tCbg3B1RnfAtd+1cnwxZ6w88SDU9VQ==
X-Received: by 2002:a02:2b08:: with SMTP id h8mr19453438jaa.137.1633957133729;
        Mon, 11 Oct 2021 05:58:53 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d11sm4120381iom.29.2021.10.11.05.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 05:58:53 -0700 (PDT)
Subject: Re: [PATCH] fio: make sure io_u->file isn't NULL before using it
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     fio@vger.kernel.org
References: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <20211011102739.10429-1-lhenriques@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <42aee776-323c-634f-d950-9792de7724d2@kernel.dk>
Date:   Mon, 11 Oct 2021 06:58:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211011102739.10429-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/11/21 4:27 AM, Luís Henriques wrote:
> While running fstests generic/095 against ext4 on a zram device I started
> seeing fio crashing.  Fix it by making sure io_u->file isn't NULL before
> accessing it.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  io_u.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/io_u.c b/io_u.c
> index 5289b5d1d9c6..b8e715d4118c 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -2009,7 +2009,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
>  			io_u->xfer_buf += bytes;
>  			io_u->offset += bytes;
>  			td->ts.short_io_u[io_u->ddir]++;
> -			if (io_u->offset < io_u->file->real_file_size) {
> +			if (io_u->file &&
> +			    (io_u->offset < io_u->file->real_file_size)) {
>  				requeue_io_u(td, io_u_ptr);
>  				return;
>  			}

This will prevent the crash, but I'm wondering why io_u-> == NULL for this case.
It really should be a valid file.

Can you let me know exactly how you're reproducing this? Then I'll give it
a whirl too.

-- 
Jens Axboe

