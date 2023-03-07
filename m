Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1EAC6FD1A
	for <fio@archiver.kernel.org>; Tue,  7 Mar 2023 17:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjCGRut (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Mar 2023 12:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjCGRu3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Mar 2023 12:50:29 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939A3A2C33
        for <fio@vger.kernel.org>; Tue,  7 Mar 2023 09:45:27 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id nf5so9423971qvb.5
        for <fio@vger.kernel.org>; Tue, 07 Mar 2023 09:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678211126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GCamnLZ0d4586v4F2uLGl9v0b7s8KdxWRzoInTK7zuk=;
        b=JqSo0BZjp7U+kIh9KWf5b2UesVA94OcyCbmpZTiEGVA10wkcxFnN5cEE+ruP9Gb0LV
         JKanFe+8oxfUTVV5l0uMRbGVTGofUwwo/zZ/4BgSfUizilJMkQgq/wF1QBifu3LASRAT
         3eebAyMjDEPFiOVS2Nx4CIV7fdFBqEzwq655Q2On8f4PIZdCI+srTdDRhwAvZClGcJB0
         Hohd67eIalsIGFn3dyLC+uMzu0BRXsHZArVS6YV75T5yDPSgKFu3qGbtgxJOuKXZQ4Hd
         5dg0rIvi/5RA/8qKnvU5Kg2J6BzwkpbeTeqHvSzKsxBOwt5ifohAxj9WV3LRAlC0sH/N
         OCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GCamnLZ0d4586v4F2uLGl9v0b7s8KdxWRzoInTK7zuk=;
        b=YAMNIJNUKvtN5uVYwnLny/zSpj0KCeGw5qJkK14Rbh7TmBwN1Mwql+wkkNVbT/V7W/
         KfjDtB08EluiVclx8g6UzW9gENR+kEAhVRM8+2ZJ1Ij6+V+x8af0snpMPbS6rPx79o35
         ao4W47sw/BkOuaT+i/8b4LH6ugVt2NDkzmbo13pXWruabr8GBu5IWvteTAImQl6if93u
         KkyJMHIFxNb0vF1klyFsnMc1ZXKNfkxSLadtvw+akfyNiFEbM9AFzlSROuUTV6s1f9vD
         I/ep+M2UrpeAi+IKaeMeF+5ZrMoLzV0WClrOPHTyHvMWFC8JFshoBP5gbvS1idLA4Nnz
         U+aw==
X-Gm-Message-State: AO0yUKW+NCKvRGKjIcq8qUFlubVkQDMkG2GnVk2t4+mlkeYXdX5oZ+cO
        Dpn8cvVeMF395O4hovupbRm+iT6f1KRu7Q==
X-Google-Smtp-Source: AK7set9/K+EO4cVKf8j5Sl3GzDtNR/hZys7xkujGpZTP8XCDevFpjVajTbmcJ+5zVQdi1g29Qc2J+g==
X-Received: by 2002:a05:6214:dae:b0:56e:af49:7a1d with SMTP id h14-20020a0562140dae00b0056eaf497a1dmr28006773qvh.24.1678211126491;
        Tue, 07 Mar 2023 09:45:26 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id v3-20020a379303000000b0073917fae4f8sm9933477qkd.25.2023.03.07.09.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 09:45:26 -0800 (PST)
Message-ID: <44db83ca-a943-77f5-2802-3872e6bf095b@gmail.com>
Date:   Tue, 7 Mar 2023 12:45:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/2] t/zbd: fix minimum write size to sequential write
 required zones
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/6/23 00:58, Shin'ichiro Kawasaki wrote:
> ZBC and ZAC require that writes to sequential write required zones shall
> be aligned to physical block size. However, the t/zbd/test-zbd-support
> script uses logical block size as the minimum write unit, then some test
> cases fail due to unaligned write command errors. This series fix the
> failures. The first patch is a preparation. The second patch fixes the test
> script to refer the correct size as the minimum write size.
> 
> Shin'ichiro Kawasaki (2):
>    t/zbd: rename logical_block_size to min_seq_write_size
>    t/zbd: fix minimum write size to sequential write required zones
> 
>   t/zbd/functions        | 28 +++++++++++++++++++++++++---
>   t/zbd/test-zbd-support | 42 +++++++++++++++++++++---------------------
>   2 files changed, 46 insertions(+), 24 deletions(-)
> 

Applied. Thanks.

Vincent
