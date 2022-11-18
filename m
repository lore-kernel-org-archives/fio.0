Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AFEC433FE
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 17:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiKRRzW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 12:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiKRRzV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 12:55:21 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A44BFCE2
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 09:55:20 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id h24so3596072qta.9
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 09:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LybGoQwsYWvK2lXNwHIdhBRtUXIYeKRQMBvphhwK4BA=;
        b=UMfClJdlabFvLFiOEwhYgsbByHbJK1oRK8/7iFHlJOqaR3MyMlyFn5NUdd955S6zvs
         o+AUIwajqmsujWKDL0pOSW9B1KDOOfcaHbB30I3rMl8WUmzkONjUXGtDiTM5Vvh0PZfC
         AHWnKJHqlWf4oMDTfEpPyzHGUxqzNL9ZKrmdWAJAtnt7TCgQNkzmZsppnWKmVoRqYFKb
         yyVQr8Pgp+d48r/ZTpVYGNcwaREWNNRVV63L61miBHXDr+EOFA9W5nNMqesJzk7SteIz
         aaN27XF6o2DzaXmfKtNcYLHJLLeHuzQM4bLLt3eWQF28R+qF476B6jupYEPM8IV1SbQI
         zWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LybGoQwsYWvK2lXNwHIdhBRtUXIYeKRQMBvphhwK4BA=;
        b=VEdK6cD+hB0Voc5MggoKE90NYeLAqMdsxoeuY5AdSJmW3cdDevFYKzkp3mCGgCmHxS
         YZluItNj7cOtYV7Ov0RO/WmXKYK0sOJZn9uelnslRfm5H+Dar0REMWB2Vt/La0vldOkA
         FdwqyPjl1VHnIKYkERLW7rS427pi9ULRJWpegNaAWqqAGaRiOqmHiURAqJYStHO0rp6+
         4OuBlb25rs7OKCuqHme0BmccBMEpLti8BkZB7qmZ/fbiCadAO1FFOZa6RPAJDsw9Q5eU
         UmUHyqAK7bbTmjoSxbfMKxyQchZe+No0DrPA4i+0WX+gHlxOVDzXmF+GlHzeZZvkv5T3
         nhhw==
X-Gm-Message-State: ANoB5pn7c20qsfyKG4RJCIGdRW4T1EI8MTQ/PJRSXI3zaAhofoWkIQnu
        Rj+1mhS5Wa/i/K4Vy/uf2LU=
X-Google-Smtp-Source: AA0mqf5dhQAQvOItqV9BXVbAr52C7zpaY5tRMeNmDUm3SGnQtyA791ZXqibpx854mwVOpn98Z4y2gg==
X-Received: by 2002:ac8:1098:0:b0:399:fb3a:4d0e with SMTP id a24-20020ac81098000000b00399fb3a4d0emr7491178qtj.256.1668794119540;
        Fri, 18 Nov 2022 09:55:19 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id gb14-20020a05622a598e00b003a5d7b54894sm2347632qtb.31.2022.11.18.09.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 09:55:18 -0800 (PST)
Message-ID: <07371a91-7a9f-e7af-5bc4-c1c57f8a50ba@gmail.com>
Date:   Fri, 18 Nov 2022 12:55:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 3/5] lib/pattern: Support short repeated read calls
 when loading from file
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>
References: <20221117220523.83501-1-logang@deltatee.com>
 <20221117220523.83501-4-logang@deltatee.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221117220523.83501-4-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/17/22 17:05, Logan Gunthorpe wrote:
 > Once a pattern file can be much larger, it will be possible that
 > kernel will return a short read while loading the file and thus may
 > randomly only load part of the file.
 >
 > Fix this by putting the read in a loop so the entire file will be
 > read.
 > ---
 >   lib/pattern.c | 15 +++++++++++----
 >   1 file changed, 11 insertions(+), 4 deletions(-)
 >
 > diff --git a/lib/pattern.c b/lib/pattern.c
 > index 70d0313d237e..d324263c2b34 100644
 > --- a/lib/pattern.c
 > +++ b/lib/pattern.c
 > @@ -32,7 +32,7 @@ static const char *parse_file(const char *beg, char 
*out,
 >   	const char *end;
 >   	char *file;
 >   	int fd;
 > -	ssize_t count;
 > +	ssize_t rc, count = 0;
 >
 >   	if (!out_len)
 >   		goto err_out;
 > @@ -52,9 +52,16 @@ static const char *parse_file(const char *beg, 
char *out,
 >   		goto err_free_out;
 >
 >   	if (out) {
 > -		count = read(fd, out, out_len);
 > -		if (count == -1)
 > -			goto err_free_close_out;
 > +		while (1) {
 > +			rc = read(fd, out, out_len - count);
 > +			if (rc == 0)
 > +				break;
 > +			if (rc == -1)
 > +				goto err_free_close_out;
 > +
 > +			count += rc;
 > +			out += rc;
 > +		}
 >   	} else {
 >   		count = lseek(fd, 0, SEEK_END);
 >   		if (count == -1)

Please add your sign-off to the commit message.
