Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BE2C41513
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 14:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjHNOk5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 10:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjHNOke (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 10:40:34 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D7210C
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 07:40:33 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-79414715edeso787095241.0
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692024032; x=1692628832;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDE/xXIll4Kx9g8PZsYNNK1Zf4e23GOUForzycEFlIs=;
        b=iW4D+py8F+U0M7ke+X0zh9vfA24D9e0UpIxkXcjxi6t0vFhBDjbmI+i2yFAnkvg7DZ
         GHtJF2QrG65VcZRqt3/bWquSl5rWdpBNyVa08ptbUbW/tcHYiWGWNXlWMCmMQkTDbaum
         YL8Ws0tTrT8D8u+L95iIoCmYJj1wF4qg6+IfPrfhh+larYgNgSvC+1eLg7Sgb/1Bu+EG
         t0xM3ELjJWHNna3Xr3soywLb7AUntb+zR8+mn/kOlLHUl3BX6Q0b1xfk61yKvlvjSp+u
         y+7st/LmTYkjMsMS+rHI+R82bnpFu97eFXAcU8QIohb2pp9xim39hgHhglPPFYZx/3C0
         usDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692024032; x=1692628832;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDE/xXIll4Kx9g8PZsYNNK1Zf4e23GOUForzycEFlIs=;
        b=FFNroSvuk4JRVhTQgIdcvncGXIqxWvzGXW3o2hVexD/EFRl171OSViet+nbgZ4Pogy
         9A7GbtST5hDYhFK+UGNIt/kSreAR8iUl9/wYQtB+UIMD4L3t/q/LBMebHHEePMfOzBX+
         3jdNR6RGN34BPZUHAaGiSFGSqY6w6tH6hWx9Vc8QhTMY6/u9ZS+nRIhEd4TSqAc10wDg
         slD1E2syCM2eJBzLQDpF+YMFlcJvozvJ772W7WO9aBsB7HNZ2YWdm84TfYHPIbFLjPhM
         tU818Znwc3ecirdhkKQsefI6m74/3oZLFhqCnk/eWPm9Fj3fPeT3IcmBzwHKuQEJ6hJs
         ATdg==
X-Gm-Message-State: AOJu0Ywr0KaFb8LVXTSlZRKLEHEgT89TRx9TOgYd5KPjo+sPaqvDosTE
        NHtme176h8v4IadLdKKO/h4=
X-Google-Smtp-Source: AGHT+IGx+6zXHoklvJ6trUzw9aWh5PbQceH+jgxcov3bFEV0V51d9AIdoyz1VX5OnhcnjJifLwSKog==
X-Received: by 2002:a67:ba03:0:b0:443:c87f:ebb1 with SMTP id l3-20020a67ba03000000b00443c87febb1mr6787369vsn.29.1692024032290;
        Mon, 14 Aug 2023 07:40:32 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id m7-20020a0cf187000000b0064723b94a23sm602041qvl.27.2023.08.14.07.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 07:40:31 -0700 (PDT)
Message-ID: <071f3084-ce5d-8326-01a2-d9c499eb79e3@gmail.com>
Date:   Mon, 14 Aug 2023 10:40:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/10] Protection information support for io_uring
 passthrough engine
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <CGME20230814093836epcas5p44bc762fa6e4368d532126494115aeba4@epcas5p4.samsung.com>
 <20230814145747.114725-1-ankit.kumar@samsung.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/14/23 10:57, Ankit Kumar wrote:
> This patch series enables protection information support with io_uring
> passthrough (io_uring_cmd) ioengine. This support is added for both DIF
> (extended logical blocks) and DIX (separate metadata buffer) cases.
> 
> The initial patch adds support for metadata buffer. As we are unaware
> of metadata size during metadata buffer allocation, we provide an
> option md_per_io_size. This must be used to specify metadata size for
> single IO, if namespace is formatted with separate metadata buffer.
> 
> This then enables the protection information support with and without
> PRACT bit set for both DIF and DIX cases. The support covers 16-bit and
> 64-bit guard protection information format, without storage tags. As
> 32-bit guard protection information format mandates minimum 16 bits for
> storage tags, it is not considered.
> 
> For the sake of consistency metadata and protection information specific
> options are the same as the ones used by SPDK's external ioengine.
> 
> This series also borrows relevant kernel crc16-t10 and NVMe CRC64
> generation files, along with 48-bit accessors for reference tags.
> 
> The NVMe CRC64 table is not generated at build time which is what kernel
> does. This will be done in future.
> 
> Changes from v2:
>   - fix windows/mac build issue from crct10 files (missed during v2)
>     https://github.com/fiotestbot/fio/actions/runs/5830346708
> 
> Changes from v1:
>   - Fixed build issue on windows and macos.
>   - Changed name of CRC64 tables and algorithm as per NVMe command set
>     specification (Keith's suggestion).
>   - Addressed review comments from Vincent.
> 
> Ankit Kumar (10):
>    engines:io_uring: add missing error during open file
>    engines:io_uring: update arguments to fetch nvme data
>    engines:io_uring: enable support for separate metadata buffer
>    engines:io_uring: uring_cmd add support for protection info
>    io_u: move engine data out of union
>    crc: pull required crc16-t10 files from linux kernel
>    engines:io_uring: generate and verify pi for 16b guard
>    crc: pull required crc64 nvme apis from linux kernel
>    engines:nvme: pull required 48 bit accessors from linux kernel
>    engines:io_uring: generate and verify pi for 64b guard
> 
>   HOWTO.rst              |  39 ++++
>   crc/crc-t10dif.h       |   9 +
>   crc/crc64.c            |  32 +++
>   crc/crc64.h            |   3 +
>   crc/crc64table.h       | 130 ++++++++++++
>   crc/crct10dif_common.c |  78 +++++++
>   engines/io_uring.c     | 225 +++++++++++++++++---
>   engines/nvme.c         | 466 +++++++++++++++++++++++++++++++++++++++--
>   engines/nvme.h         | 230 +++++++++++++++++++-
>   fio.1                  |  38 ++++
>   io_u.h                 |   2 +-
>   11 files changed, 1199 insertions(+), 53 deletions(-)
>   create mode 100644 crc/crc-t10dif.h
>   create mode 100644 crc/crc64table.h
>   create mode 100644 crc/crct10dif_common.c
> 

Applied. Thanks Ankit!

Vincent
