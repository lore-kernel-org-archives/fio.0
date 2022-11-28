Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C853C4321E
	for <fio@archiver.kernel.org>; Mon, 28 Nov 2022 21:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiK1V5c (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 28 Nov 2022 16:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiK1V5b (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 28 Nov 2022 16:57:31 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFA12C64C
        for <fio@vger.kernel.org>; Mon, 28 Nov 2022 13:57:30 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id w9so7693043qtv.13
        for <fio@vger.kernel.org>; Mon, 28 Nov 2022 13:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sW881rPxtSzuVG/J9qH8APj2ymEQUUQPmGI9JbkMq0o=;
        b=myfJI+YWotMvxAYB0tq3RVveVmwl+jVIW5QvC6/pFqgo+7oa0/hyqlWqBJqNhmiiY7
         Jppbl01DQhCMIT43hijNXLesJv69m97ogsP6KPC0cqijT/b07UJDJPm9gw0qA4KNN4mg
         WOKeqtlZjZa6ZjvJKbMevXWHX19RofzvJaIUSeAu26ra2ZiUvh8+XR1xFQQIvuxPGeYo
         5ZZuS7NrftbU/970xdQj/t6ZgKmzxYuaAeAYXzkAu9OdDbEzbrfXd4G8CA7QumPXfQq+
         qIDKfu3qbT/768iv92DnsS/sGb8iMEnwhkbTM8SE1XOMDLKv6oPOdDk+RNa9ZjAnahvl
         bZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sW881rPxtSzuVG/J9qH8APj2ymEQUUQPmGI9JbkMq0o=;
        b=pV3JgMOzVTBA/hbn9WvuB48r8kAf2z4b6XO4/9qzUbOySxDy43aU2iZlpgglem8EIa
         nh24rns5iRM+7QLiVBt/E+lVjfxOScT35bpu8SVwcMxAjcw+tfeVc27w3HS0akx16Q9a
         R/ZoDMEvAOxoemjvGBP68eSrRQi9w7iy0ksyxDPXqxkSNJmsVebHIRsFFVdueduSuCVp
         AroGBS2eduG1dE+S6hnAbwum8omW8eBeh2OEuvcLZ7tAFKdphF1+auvJY18ree0VVAxG
         bXM6pz30ftqurEFdlu9VrrrHVyv+SBd2Nd3vd+rKHCoy0xWWcf2tu4ZkHh38OgoTZC/2
         5fbg==
X-Gm-Message-State: ANoB5pmO2w9fqWmBacatGLqEIyQY4boltZOHzZL8wTpuv0iIF8gyJ74J
        5A9JB/NvRRrrKcMUW1J/zX8=
X-Google-Smtp-Source: AA0mqf58ZlMS+Qbf3nisz3yjPZrj3uxE65CgMjV+lXHZq04UVwjBD3zFzXiT4gBm5RpxDSyROdK4fg==
X-Received: by 2002:ac8:4cd1:0:b0:3a5:1940:a027 with SMTP id l17-20020ac84cd1000000b003a51940a027mr48634258qtv.195.1669672649687;
        Mon, 28 Nov 2022 13:57:29 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bl15-20020a05620a1a8f00b006ce9e880c6fsm9198311qkb.111.2022.11.28.13.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 13:57:28 -0800 (PST)
Message-ID: <1d29e8c8-ce79-0608-d979-d50bfbc9e112@gmail.com>
Date:   Mon, 28 Nov 2022 16:57:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] io_u: fix offset generation for mix of random and
 sequential workload
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <20221118051454.31288-1-ankit.kumar@samsung.com>
 <CGME20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e@epcas5p2.samsung.com>
 <20221118051454.31288-2-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221118051454.31288-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/18/22 00:14, Ankit Kumar wrote:
 > Sometimes while running a mix of sequential and random I/O's the
 > generated sequential offset is outside the I/O region. This usually
 > happens if the previous I/O is the last block in the region and
 > thus results in this sequential I/O's offset to be just outside the
 > region.
 > With this fix, fio generates a random offset within the I/O region.
 >
 > This fixes #1486
 >
 > Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
 > ---
 >   io_u.c | 5 ++++-
 >   1 file changed, 4 insertions(+), 1 deletion(-)
 >
 > diff --git a/io_u.c b/io_u.c
 > index 8035f4b7..e49b1b29 100644
 > --- a/io_u.c
 > +++ b/io_u.c
 > @@ -432,8 +432,11 @@ static int get_next_block(struct thread_data 
*td, struct io_u *io_u,
 >   				*is_random = false;
 >   				io_u_set(td, io_u, IO_U_F_BUSY_OK);
 >   				ret = get_next_seq_offset(td, f, ddir, &offset);
 > -				if (ret)
 > +				if (ret || offset >= f->io_size) {
 >   					ret = get_next_rand_block(td, f, ddir, &b);
 > +					offset = -1ULL;
 > +					*is_random = true;
 > +				}
 >   			}
 >   		} else {
 >   			*is_random = false;

This patch causes a regression with a workload such as:

fio --name=test --bs=4k --filesize=32k --nrfiles=10 --number_ios=10 
--file_service_type=sequential --percentage_random=50 --rw=randread 
--randrepeat=0 --ioengine=null --debug=io

Only the first file will be accessed when this patch is applied. Bad 
offsets are needed in order to trigger the move to the next file.

Here is a related issue: https://github.com/axboe/fio/issues/1372

Perhaps the right thing to do is to limit the offset >= f->io_size check 
to cases where nrfiles = 1 as in the patch for issue 1372.

Also, it seems to me that if we are intending to generate a sequential 
offset for this case and succeed in doing so, we should just wrap around 
to the beginning of the file instead of choosing a new random offset.

In general we have an overwhelming set of ways to generate offsets and 
little automated testing for offset generation. In the long run we 
should develop a set of tests for offset generation that exercise the 
different options. This will help us detect issues and give us 
confidence that future code changes won't introduce regressions.

Vincent
