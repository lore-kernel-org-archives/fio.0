Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BF5EB64D7
	for <fio@archiver.kernel.org>; Fri, 16 Jun 2023 20:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjFPU2n (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 16 Jun 2023 16:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjFPU2m (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Jun 2023 16:28:42 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCEC35A6
        for <fio@vger.kernel.org>; Fri, 16 Jun 2023 13:28:41 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f9dc03029eso8130651cf.3
        for <fio@vger.kernel.org>; Fri, 16 Jun 2023 13:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686947320; x=1689539320;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5N5BvO/kFysBl5wAwNjt+Kz4IngdFDuDq+R5Pm/DSwY=;
        b=oaAAQOiVO3dcmrUQ2m0phn/HfVuxJzEcnwnZ5fB5nfEc4ZHRU2WQ5bgbxVwVaJJNEc
         9C1fIEHyOYbfazALc6CSAeGcfX79xrXh2G+4VT6uuf2l7ipqrYMxWdS9QsF0m6ptS8SG
         UFQ23bLJbDmkKWvE1e0CCl88TofE80ip3y1eCObkSh86MEPAnAb0AQmFpEtcFrXDYi+C
         JojSweDpD+biX/sEHtFyUWVtTL8JdGO7eh/4vDcpBvQri5HpI3lutBoxCzFRfKd4TrwA
         1Q0tTPRwOUxQfIS4gOiYX33reTN14fgJYdqfDzMlBxrYJEH1HkMthll8z5NfudB4rX9u
         GdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686947320; x=1689539320;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5N5BvO/kFysBl5wAwNjt+Kz4IngdFDuDq+R5Pm/DSwY=;
        b=JsyJJSMjM79GD08xL282IsGNEFjjeljUUvUgSqvAfV4q3T82t6T2+t2BLdt4JprPUu
         d2Zq2+BZJjhWrRf3zcyfyqvas/OEwAmQ9Ekr50skoykOZ9K6f0SVcNPFbuAyNvhQge4o
         8Fhl13WygCKwMWUif7dy8SlU8DCArwpW3Va3Smu4IbjCNE7m7iJpgdcxvwz6e1hCWW00
         oZXgo/3tTGu+uH1CSB26AlG+ai1k7V6UDNxtwuzmjl3GLGmJaxZ4u6j1FZY/mbugcSZK
         Bq6ao1HHVJPrWX1ck9Sg29WevOkoa4DUux8nDVuroIJ5euNCSaGAKJbcy8fX6H2NLEOi
         6QIg==
X-Gm-Message-State: AC+VfDwGmdM6qD9YR3BGTLDqVk7osvEpNQFGKPEtWWeCz4OFKvwzGfob
        FaVUbyF7hdv6j7PFwYp+Kzxgnfi9V+U=
X-Google-Smtp-Source: ACHHUZ5LGLHaFy4KRpIPiHrv93B3egxhTdHItAVe4ltwrmspJFY/xua2M/WAWauw3DHMz3TPm0IXew==
X-Received: by 2002:ac8:584c:0:b0:3f8:6aa0:57ee with SMTP id h12-20020ac8584c000000b003f86aa057eemr3412388qth.46.1686947320324;
        Fri, 16 Jun 2023 13:28:40 -0700 (PDT)
Received: from [192.168.1.241] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ff25-20020a05622a4d9900b003fddfbc6e06sm321208qtb.96.2023.06.16.13.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 13:28:39 -0700 (PDT)
Message-ID: <4cf9e355-2c30-8d4d-255d-3a7c395cc61c@gmail.com>
Date:   Fri, 16 Jun 2023 16:28:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Re: Requesting help with random I/O distribution
To:     Surbhi Palande <csurbhi@gmail.com>, fio@vger.kernel.org
References: <CAMBkX3dN8d5kSNUDpPBBmx34+Ov7JzgK=dmgwAfeAaecLX+-7A@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAMBkX3dN8d5kSNUDpPBBmx34+Ov7JzgK=dmgwAfeAaecLX+-7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/8/23 21:11, Surbhi Palande wrote:
> Hi All,
> 
> I am trying to performance test my device mapper for zoned devices; I
> am trying to repliate the 80 - 20 principle for I/O. I understand that
> this can be done in the following three ways using fio.
> 
> a) zoned - simplest of the three :
> zoned:80/20:20/80
> However, this restricts the first 20% space to get 80% of the I/O and
> vice versa. The good thing though is that zoned distribution can be
> used to achieve a russian doll effect.
> 
> b) zipf:1.2
> 
> I used fio-genzipf to visualize the random I/O pattern:
> fio-genzipf -t zipf -i 1.2 -b 4096 -g 100GiB
> Generating Zipf distribution with 1.200000 input and 100 GiB size and
> 4096 block_size.
> 
>     Rows           Hits %         Sum %           # Hits          Size
> -----------------------------------------------------------------------
> Top   5.00% 93.31% 93.31% 24459924 93.31G
> |->  10.00%  1.34% 94.65%  352314  1.34G
> |->  15.00%  0.77% 95.42%  201010 785.20M
> |->  20.00%  0.51% 95.92%  132667 518.23M
> |->  25.00%  0.47% 96.39%  122386 478.07M
> |->  30.00%  0.34% 96.73%   89402 349.23M
> |->  35.00%  0.23% 96.97%   61193 239.04M
> |->  40.00%  0.23% 97.20%   61193 239.04M
> |->  45.00%  0.23% 97.43%   61193 239.04M
> |->  50.00%  0.23% 97.67%   61193 239.04M
> |->  55.00%  0.23% 97.90%   61193 239.04M
> |->  60.00%  0.23% 98.13%   61193 239.04M
> |->  65.00%  0.23% 98.37%   61193 239.04M
> |->  70.00%  0.23% 98.60%   61193 239.04M
> |->  75.00%  0.23% 98.83%   61193 239.04M
> |->  80.00%  0.23% 99.07%   61193 239.04M
> |->  85.00%  0.23% 99.30%   61193 239.04M
> |->  90.00%  0.23% 99.53%   61193 239.04M
> |->  95.00%  0.23% 99.77%   61193 239.04M
> |-> 100.00%  0.23% 100.00%   61188 239.02M
> -----------------------------------------------------------------------
> Total 26214400
> 
> I need help with this interpretation. Does this mean that 5% of the
> LBAs get 93.31% hits, the next 5% gets 1.34% etc. It seems that way to
> me.

I haven't thoroughly digested the source code but all indications 
suggest that this is the correct interpretation.

> However, this does not have the Russian doll effect  - ie the 5% of
> the rest of 95% does not get the rest of ~93% I/O.

Add "-o 40" or "-o 100" to increase the number of rows. That way you can 
see the distribution within each 5% band. The results suggest to me that 
the distribution is skewed even within each band. If I understand 
correctly what you mean by "Russian doll effect," this distribution does 
follow that pattern to some extent, although the distribution is 
essentially flat in its tail which is inconsistent with that pattern.

Look at the zipf probability density function listed on Wikipedia and 
imagine its shape after you have removed the most frequent values. Even 
if you use a new normalizing constant, it won't have the same shape as 
the original distribution because the distance between, for example, 1/2 
and 1/3 will not be the same as the distance between 1/200 and 1/201

> Is the 5% range - scattered over the disk or is this similar to zoned
> distribution, in that a contiguous
> space gets the 93% I/O. In that case, this is similar to zoned
> distribution, right?

Try running fio and examining the offsets it produces. Then use some 
utilities to extract the offsets and analyze them:

$ fio --name=test --ioengine=null --filesize=10240 --bs=512 
--rw=randread --randrepeat=0 --random_distribution=zipf:1.2 --debug=io | 
grep complete: | cut -d ':' -f3 | cut -d ',' -f1 | cut -d '=' -f2 | sort 
| uniq -c | sort -r
       7 0x1200
       5 0x0
       3 0xc00
       2 0x1c00
       1 0x600
       1 0x2200
       1 0x1600

In each row, the first number is the count and the second number is the 
offset. Thus you can see that random_distribution=zipf produces offsets 
all over the map which is different from zoned.

> c)  pareto -
> fio-genzipf -t pareto -i 0.04 -b 4096 -g 100GiB
> Generating Pareto distribution with 0.040000 input and 100 GiB size
> and 4096 block_size.
> 
>     Rows           Hits %         Sum %           # Hits          Size
> -----------------------------------------------------------------------
> Top   5.00% 93.04% 93.04% 24388831 93.04G
> |->  10.00%  0.99% 94.02%  259143 1012.28M
> |->  15.00%  0.60% 94.63%  158285 618.30M
> |->  20.00%  0.59% 95.22%  154826 604.79M
> |->  25.00%  0.35% 95.57%   92138 359.91M
> |->  30.00%  0.30% 95.87%   77413 302.39M
> |->  35.00%  0.30% 96.16%   77413 302.39M
> |->  40.00%  0.30% 96.46%   77413 302.39M
> |->  45.00%  0.30% 96.75%   77413 302.39M
> |->  50.00%  0.30% 97.05%   77413 302.39M
> |->  55.00%  0.30% 97.34%   77413 302.39M
> |->  60.00%  0.30% 97.64%   77413 302.39M
> |->  65.00%  0.30% 97.93%   77413 302.39M
> |->  70.00%  0.30% 98.23%   77413 302.39M
> |->  75.00%  0.30% 98.52%   77413 302.39M
> |->  80.00%  0.30% 98.82%   77413 302.39M
> |->  85.00%  0.30% 99.11%   77413 302.39M
> |->  90.00%  0.30% 99.41%   77413 302.39M
> |->  95.00%  0.30% 99.70%   77413 302.39M
> |-> 100.00%  0.30% 100.00%   77395 302.32M
> -----------------------------------------------------------------------
> Total 26214400
> 
> This to me looks pretty much similar to the zipf distribution above.
> 
> Is this understanding correct ? Or am I missing something here?

There are plenty of discussions online about the relationship between 
the zipf and pareto distributions. I don't have any particular expertise 
to add to what you can already easily find.

Vincent
