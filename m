Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAEAC433FE
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJCVOL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJCVMS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 17:12:18 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B0B5245C
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 14:07:45 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id l127so6614791iof.12
        for <fio@vger.kernel.org>; Mon, 03 Oct 2022 14:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=rKmP4xE17B21/BtOZP9kadQzQmB57k9ME7kf6vfMf/M=;
        b=Tc9T0auhpBhykBuha38eTGTnUtItE1gkkkfGNlhCn2Eb5Srqy1eUt1c4pLTtnf8ks4
         9ReALVv4qI1ZgJPPHl519y0Kv/VUJyVANEChK3UUnpAb4fnmz30mKgsOym30JsmvBbhL
         +tlo0q6+ADLV5j1zT+5fS5GNr8AKH3EDxv3cfKY0Yvq5wRnmtl7/B92dqMYrQXWIR8NH
         UikX/tuI1WKMNNclyAtA1KlMpq38+1q+pi8K87nos4xjvL2AqNGrsGMzq5jOXKpyJoxM
         3dJBqmtsJGkJEyEIdixCm01U62lzpV+BcgjLGDIkMf9NL5ncjkUkmiehc4UAq9ChuJyN
         N4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rKmP4xE17B21/BtOZP9kadQzQmB57k9ME7kf6vfMf/M=;
        b=C+5h/UPkYu5E5gfXhMQqp1ORRIhKYO+Amp0wGTRvscDzcbdHvv++BNrB/gjbu00Tsr
         /zegRH3XpomU74MDFl6wZFgX4wITMo0XjoGr2lwnDesMIXTQqi7Vt00LocX/Kdj5DCDo
         G8+to+XaK6YeLy7l2kBirOS4Dsx42RTOZT78Ya7OGz0Km2F/jyDn0a2wyuARw9kBmfxI
         Jb55V602zd+r+NukutdKdgksrDVgTYp9v73hNs/MOt3sXuyMhgl4PmPZGCzRmYyY5GIn
         rv7rpTC7j4qW92mLqamKOwrO4LbGlMtPyhf33d1gPTJ0sSlFKGoqSIXGVuQ3RY8RDejW
         pXgw==
X-Gm-Message-State: ACrzQf1ttAc4CsQJnYPJaDvhzSx7708PSQKoeq5WvVYAlaE/vh6QFLFU
        cjjFCOGWl/P1Mg31fB8IzcI+LvSWOa05EA==
X-Google-Smtp-Source: AMsMyM5EdGIpQxO+KlFDiOANFJxacuFaId5YuMzNLB/PkSSZANVP2pQLXPBWuRsZnsEnU30tpR/LPA==
X-Received: by 2002:a02:880b:0:b0:35a:e4be:c408 with SMTP id r11-20020a02880b000000b0035ae4bec408mr11217594jai.113.1664831264978;
        Mon, 03 Oct 2022 14:07:44 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f10-20020a056e020c6a00b002f86a153f42sm4239080ilj.65.2022.10.03.14.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 14:07:44 -0700 (PDT)
Message-ID: <f6e91bcd-d02c-1265-49b7-bd3a3dd41bed@kernel.dk>
Date:   Mon, 3 Oct 2022 15:07:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 3/4] randtrimwrite: fix offsets for corner case
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20221003203427.123969-1-vincent.fu@samsung.com>
 <CGME20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0@uscas1p1.samsung.com>
 <20221003203427.123969-4-vincent.fu@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221003203427.123969-4-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/3/22 2:34 PM, Vincent Fu wrote:
> For randtrimwrite, we decide whether to issue a trim or a write based on
> whether the end offsets for the most recent trim and write commands
> match.  If they don't match that means we just issued a new trim and the
> next operation should be a write. If they *do* match that means we just
> completed a trim + write pair and the next command should be a trim.
> 
> This works fine for sequential workloads but for random workloads it's
> possible to complete a trim + write pair and then have the randomly
> generated offset for the next trim command match the previous offset. If
> that happens we need to alter the offset for the last write operation in
> order to ensure that we issue a write operation the next time through.
> 
> It feels dirty to change the meaning of last_pos[DDIR_WRITE] in this way
> but hopefully the long comment in the code will be sufficient warning.
> 
> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
> ---
>  io_u.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/io_u.c b/io_u.c
> index 3f6c60ee..0a70f72a 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -513,6 +513,24 @@ static int get_next_offset(struct thread_data *td, struct io_u *io_u,
>  		return 1;
>  	}
>  
> +	/*
> +	 * For randtrimwrite, we decide whether to issue a trim or a write
> +	 * based on whether the offsets for the most recent trim and write
> +	 * operations match. If they don't match that means we just issued a
> +	 * new trim and the next operation should be a write. If they *do*
> +	 * match that means we just completed a trim+write pair and the next
> +	 * command should be a trim.
> +	 *
> +	 * This works fine for sequential workloads but for random workloads
> +	 * it's possible to complete a trim+write pair and then have the next
> +	 * randomly generated offset match the previous offset. If that happens
> +	 * we need to alter the offset for the last write operation in order
> +	 * to ensure that we issue a write operation the next time through.
> +	 */
> +	if ((td_randtrimwrite(td) && ddir == DDIR_TRIM) &&
> +	     fio_unlikely(f->last_start[DDIR_TRIM] == io_u->offset))
> +		f->last_pos[DDIR_WRITE]--;

Minor nit - the unlikely bracketing doesn't work well like this, it
has to cover the whole branch. For this case, I'd probably just skip
it.

Outside of that, series looks good to me, thanks a lot for taking
a closer look at this!

-- 
Jens Axboe


