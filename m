Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC5AC04A6A
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 15:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjHIP11 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 11:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjHIP1Z (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 11:27:25 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ADBE7E
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 08:27:24 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-40ff796e8ddso41655921cf.2
        for <fio@vger.kernel.org>; Wed, 09 Aug 2023 08:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691594843; x=1692199643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xuWRe9LUFPW8ur9j3NeUKS0kYJuHARYqbKpBL1NGZaY=;
        b=RM7+qhxaaDLANA47FbhB+0NRYdOrVVjKZAMMxpyfrmR6sktsVyLfimivnjDKyzO9rd
         3jSv7AkFj/CM1bQXJwR5VV8E+/jeY4PV+Fw6oM2dukzAYZldnTToS5P8sd7Y8vfJA+16
         37RTi0KbyU8FAq+eCwHjHnywvaSvPx7Hig8iUYb3LxfyvxHxvxLexLvqGbwpC2ClMKZc
         Fn66Nic7rCFrlShlCMFy3aoemKqwQdDVTAzTPXLdHgx18pLKLNTzwSvj++VLEmuY+4NX
         nUcpkFRp/LTipFowVPaPHgSET6qFfA5EV7zkItU0+CB3tgumlYq+LEvrnuQ/j1SsZ9Dt
         xl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691594843; x=1692199643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xuWRe9LUFPW8ur9j3NeUKS0kYJuHARYqbKpBL1NGZaY=;
        b=H+UmVhLTJFCwDX+n15NIlG6Ec5KpN4uDFRcrZihCOl6SAu7htEqKl03dtbKeDRIQ3l
         N86+ZWNp3fEKPjpzkbP6wURaKLhF/qpYeLDBnUXvF7lKuHU1FPPteWH+SpD+BljxwpyH
         Ffdhumw3nWCXMViUc7ZOANu6znRD7TH7bZMMsPaooDqZxouccdGc3XsHik90hvvT3kpv
         Rc49Gz5n2pB5WFhJ7tJ9PvMQS+gWAhe+nWjiQaNfa0I6x8j11KBt4c+EgsFeDW2Dsvky
         Zoavj1ezuQssLvGZUb6wxC8aK7w8qtgMHQQFgx/4fwrbscQWV4kl7eblWYPL3UrHGnEJ
         Hsuw==
X-Gm-Message-State: AOJu0YyIjHCaIHu/15cIfPX0NrS+HY1D09ThR9/JH3+Xel3fkGlDKFuN
        tSUo3JMtIZplH+l4hS9Z90o=
X-Google-Smtp-Source: AGHT+IGGii0yI1WABES26tircPtn3rhErRGuQm6SKuFjyJnx82MXvd5+40L9yEqgnf1PetnrJLznYg==
X-Received: by 2002:a05:622a:c2:b0:402:d96c:c840 with SMTP id p2-20020a05622a00c200b00402d96cc840mr4392378qtw.18.1691594843295;
        Wed, 09 Aug 2023 08:27:23 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bn6-20020a05622a1dc600b003ff1f891206sm4100348qtb.61.2023.08.09.08.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:27:22 -0700 (PDT)
Message-ID: <17dc48b3-0499-c953-0e3a-7f5a0250c387@gmail.com>
Date:   Wed, 9 Aug 2023 11:27:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 00/10] Protection information support for io_uring
 passthrough
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <CGME20230809055412epcas5p2730555562d72605bd2956964598d7333@epcas5p2.samsung.com>
 <20230809111314.76947-1-ankit.kumar@samsung.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/23 07:13, Ankit Kumar wrote:
> This patch series enables protection information support with io_uring
> passthrough (io_uring_cmd) ioengine. This support is added for both DIF
> (extended logical blocks) and DIX (separate metadata buffer) cases.
> 
> The initial patch adds support for metadata buffer. As we are unaware
> of metadata size during metadata buffer allocation, we provide an option
> md_per_io_size, which must be used to specify metadata size for single IO.
> 
> This then enables the protection information support with and without
> PRACT bit set for both DIF and DIX cases. The support covers 16-bit and
> 64-bit guard protection information format, without storage tags. As 32-bit
> guard protection information format mandates minimum 16 bits for storage
> tag, it is not considered.
> 
> This series also borrows relevant kernel crc16-t10 and crc64 rocksoft
> generation files, along with 48-bit accessors for reference tags.
> 
> Ankit Kumar (10):
>    engines:io_uring: add missing error during open file
>    engines:io_uring: update arguments to fetch nvme data
>    engines:io_uring: enable support for separate metadata buffer
>    engines:io_uring: uring_cmd add support for protection info
>    io_u: move engine data out of union
>    crc: pull required crc16-t10 files from linux kernel
>    engines:io_uring: generate and verify pi for 16b guard
>    crc: pull required rocksoft crc64 apis from linux kernel
>    engines:nvme: pull required 48 bit accessors from linux kernel
>    engines:io_uring: generate and verify pi for 64b guard
> 
>   HOWTO.rst              |  36 ++++
>   crc/crc-t10dif.h       |  10 +
>   crc/crc64.c            |  31 +++
>   crc/crc64.h            |   4 +
>   crc/crc64table.h       | 132 ++++++++++++
>   crc/crct10dif_common.c |  78 +++++++
>   engines/io_uring.c     | 216 ++++++++++++++++---
>   engines/nvme.c         | 467 +++++++++++++++++++++++++++++++++++++++--
>   engines/nvme.h         | 230 +++++++++++++++++++-
>   fio.1                  |  35 +++
>   io_u.h                 |   2 +-
>   11 files changed, 1191 insertions(+), 50 deletions(-)
>   create mode 100644 crc/crc-t10dif.h
>   create mode 100644 crc/crc64table.h
>   create mode 100644 crc/crct10dif_common.c
> 

FWIW, I have a branch with these patches applied that also contains a 
test script exercising this functionality:

https://github.com/vincentkfu/fio/commits/pi

Vincent
