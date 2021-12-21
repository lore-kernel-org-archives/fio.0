Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9623C433F5
	for <fio@archiver.kernel.org>; Tue, 21 Dec 2021 11:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbhLULfq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Dec 2021 06:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbhLULfp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Dec 2021 06:35:45 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CEBC061574
        for <fio@vger.kernel.org>; Tue, 21 Dec 2021 03:35:45 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id g11so28720638lfu.2
        for <fio@vger.kernel.org>; Tue, 21 Dec 2021 03:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:cc:from:subject:in-reply-to:content-transfer-encoding;
        bh=v5JHDYmtyC0Zwx8w6sDLeaabrS9khZ/m0QrAqbLC5oo=;
        b=VlDqMQz8SDZC9+/4/s/nK28FgQ0gA2W04KgCY+kApnXZ39vDdkTaZHq5YmnK3of60w
         KfMyU4AvJt33vnzXykqHxzQomOjn77PLMJVRBWA8TpxCtP8B9SO+Rzq0aK6odCbMGskA
         /ViXxDH1yRkBoCsC9sUZwWzRaS3XTa6qnSCLdZRR+DTagrUeBJi1U5EkzESW/l+hab1D
         QTIVTt8dDZ30u7ndcSkNAtyJ5hVQ8BX77akoY7cXG0qidSFoxe70AIAPQkWAo7FUIuIS
         sdUrJfuVgk5Lh9Y80GVzwjCa4eiy0RQON6tc40QODO0wF4BEVuxXfQ7mPvJO/dVCAHmr
         /IrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:cc:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=v5JHDYmtyC0Zwx8w6sDLeaabrS9khZ/m0QrAqbLC5oo=;
        b=w0GKZ425p/iErxBzYZ85JvbxC0EU98FEBmQWoCht0OzNo4gEZGTK2Kmap6NPiy7BA5
         epOu+BrTouFNxMcoAhTW5ACp1GF0zkpN6CBFbR29zQnGK+n+8zx1voflinAVzC/oXKOh
         GIfPR5Kgcf6nb31yH4f/YvVE9wLC9uPLHPeGM/jB0//8oOTGBwub0xnHFFdafDQP+Sfm
         DBXxqTjDKEHFvyEGt2S+Mb1OOoOyxYv8TC1zcAovChtSlHjH9VoDcCJ+dk1EI6oDzByu
         St2ka38Yx79/DB7E+BbMBYj/mpTIf1lUHBoQU4HaV1VkQgc4ryrNGTvSJwUHQuw1vbOb
         2+bA==
X-Gm-Message-State: AOAM531VwwLuRAn5Js76e6hpXSLZber0DGRARXvGC2qVWjmMgG1EBKV3
        3hFKRf6the8FdxRCUvrSySx6I7BQFTs5ebit
X-Google-Smtp-Source: ABdhPJwqPFuEt/JY5v6gRsD0zOCmii/L7BMW2CPq6OxeicaHrSahLTDTnFcOiJgOYwixeVGjAgjjxw==
X-Received: by 2002:ac2:52a4:: with SMTP id r4mr2651788lfm.645.1640086543551;
        Tue, 21 Dec 2021 03:35:43 -0800 (PST)
Received: from [192.168.222.111] ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id m10sm2723703lji.11.2021.12.21.03.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 03:35:43 -0800 (PST)
Message-ID: <c6a02612-51e1-c759-0fcd-a6a2e8721d97@cloudlinux.com>
Date:   Tue, 21 Dec 2021 14:35:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Seyed Mohammad Fakhraie <fk.smoh@gmail.com>
References: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
 <d3c7a9ca-af7e-9d70-f229-74558d17cfe2@cloudlinux.com>
 <CACzyWQzih6gCQ4vYGA9Hwj-Zq4_d+YKC1j=secP8W9nr7bZCgg@mail.gmail.com>
 <44a99ee0-4856-51eb-0172-9d635582223e@cloudlinux.com>
 <CACzyWQwCvsCkh=Ui_cr5Hh8jqZGEkX4B1YwujEnR6nYutjPveA@mail.gmail.com>
 <7cc48a89-7bc3-bd55-733b-c9d40fecb0ab@cloudlinux.com>
 <CACzyWQwe2SYR_W=XyuCk=THBZ-0frnh5u1gtjALfnZBpu6EerA@mail.gmail.com>
 <f3ac3012-b641-d95c-5b73-315979842114@cloudlinux.com>
 <CACzyWQy7MXp619uJhJ=uDWqabT_xwt=6bu=Z5103twPJJMz1=A@mail.gmail.com>
Cc:     fio@vger.kernel.org
From:   Dmitry Antipov <dantipov@cloudlinux.com>
Subject: Re: Using FIO to benchmark Gluster
In-Reply-To: <CACzyWQy7MXp619uJhJ=uDWqabT_xwt=6bu=Z5103twPJJMz1=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/21/21 13:21, Seyed Mohammad Fakhraie wrote:

> Thanks Dmitry. As you pointed out, 18446744073709551615 is an
> interesting number. I'm just thinking out loud here and I haven't
> looked at the code yet, could it be caused by an overflow?

Looking through fio sources, my guess is that -1 internally means
"not decided (yet)". Passing -1 via gfapi tells the GlusterFS brick
process to create (size_t)-1 bytes file, which is 2^64 - 1 and not
supported by GlusterFS. Most likely this value is too large for an
underlying filesystem as well (for example, XFS native limit is
2^63 - 1 bytes).

I would suggest to consider simpler scenarios. For example, the
following seems works as expected, and it's quite similar to your
job file:

fio --ioengine=gfapi --volume=test0 --brick=localhost --direct=1 \
     --create_on_open=1 --iodepth=1 --numjobs=1 --bs=4k --size=1G \
     --time_based --runtime=180 --rw=randread --name=test0

Dmitry
