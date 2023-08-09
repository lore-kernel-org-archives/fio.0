Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511E5C001B0
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 16:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjHIQnr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjHIQno (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 12:43:44 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33611BF2
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 09:43:43 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-63fba828747so170056d6.0
        for <fio@vger.kernel.org>; Wed, 09 Aug 2023 09:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691599423; x=1692204223;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OsOz9FazW9im5uTAMo2SBLCjWun35W9objA4r//q3mk=;
        b=oLfgzKkxw+QwfbvudKuY3EULgKfzDa22DRQ8gEULTn25iV1o5t9Vprhs9yzbRd5pSx
         X4oqOov5/EvpupAqepyFHD5QbZ3+nid6wJAXIQB68GeOqCLd8zgOUK5VO3pPcCo993Cl
         PK8ZkxIf+WayVcEVVt77GXDzEW2DHneD4nXlEcOmhi4AJy9aaWO+l0gK/LYYX+o2OlSY
         MrVTZCuyBP3qTV5xn31OlSp8ZC5HUs8dRAY4rdvtjlJVf3Ufb+ZuY2oyWKORSQNXTeP9
         RizPrhBDXBKz/VEzVrRDynFVJMjF3ywJl/6U2V2VkUajaJEt/bKhTcTgK9i0MwfK57gg
         1JJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691599423; x=1692204223;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OsOz9FazW9im5uTAMo2SBLCjWun35W9objA4r//q3mk=;
        b=JNECkMp5TJKGBSCFmj13Pq0xUWYzqhpmqkTknGRtpgMzAmDzNbsVEdNZeH222EyMAl
         W6Kibw6Kp19VzP9YPM8BvWVvGzehzDEMaTIApKGL9XKATtErBQD5TzX7RN2Oc84cgcR5
         QdJdZOqKuCLFiNJC19QfydLeLTsA3Ici4MgfmyexP3eZXmHqKA6+Exw0+T9d2h1ZSQ8l
         /7JDXJ/A/PZc5HtT4qkNx4DiRGOx2CX0tMBbCSTB0DR8CyS5G4Dsn1+mAlLuEhg9/cjm
         8s12905XcNpBkTN/SxkFHwRf3JSjqCLAU1uHin7Y7GEYFOMlg5gnsIb8xVpCbgdCSKCe
         2UQg==
X-Gm-Message-State: AOJu0Ywjh+sIjawpJgrAzzbqFPzyP4InqwRTsl6GqtFtnZpbQTKkx99l
        qflOtHsPL976A7lXmsh0jC8=
X-Google-Smtp-Source: AGHT+IHSHN617uKqQFOgkVb+iJHk1z6Io0KN85A3urqxQEtnkFaV0yYz/TB494Ya3WF0Z5MjS8aCKQ==
X-Received: by 2002:a0c:f48f:0:b0:63c:f0a7:cef2 with SMTP id i15-20020a0cf48f000000b0063cf0a7cef2mr3199251qvm.25.1691599422878;
        Wed, 09 Aug 2023 09:43:42 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id s12-20020a0ce30c000000b0062df126ca11sm4519161qvl.21.2023.08.09.09.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:43:42 -0700 (PDT)
Message-ID: <8c190e82-f9ed-5a1f-19d1-f1d60c72ce15@gmail.com>
Date:   Wed, 9 Aug 2023 12:43:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 04/10] engines:io_uring: uring_cmd add support for
 protection info
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
 <CGME20230809055417epcas5p45c05f72300690040773b32ca76984ff0@epcas5p4.samsung.com>
 <20230809111314.76947-5-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230809111314.76947-5-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/23 07:13, Ankit Kumar wrote:
> This patch enables support for protection information to nvme command
> backend of io_uring_cmd ioengine. The patch only supports protection
> information action bit set to 1, for read and write operation.
> 
> This adds 4 new ioengine specific options
>   * pi_act - Protection information action. Default: 1
>   * pi_chk - Can be set to GUARD, APPTAG or REFTAG
>   * apptag - Sets apptag field of command dword 15
>   * apptag_mask - Sets apptag_mask field of command dword 15
> 
> For pi_act=1, if namespace is formatted with metadata size equal to
> protection information size, the nvme controller inserts and removes
> protection information for write and read command respectively.
> Added a check so that fio doesn't send metadata for such cases.
> 
> Storage tag support is not present, so return an error for that.
> 

I think it's worth mentioning in the commit message that for the sake of 
consistency these options are the same as the ones used by SPDK's 
external ioengine.

> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   HOWTO.rst          |  32 ++++++++
>   engines/io_uring.c |  95 +++++++++++++++++++++-
>   engines/nvme.c     | 112 +++++++++++++++++++++++---
>   engines/nvme.h     | 191 ++++++++++++++++++++++++++++++++++++++++++++-
>   fio.1              |  32 ++++++++
>   5 files changed, 448 insertions(+), 14 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 6e0677f2..aa5a36bd 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2491,6 +2491,38 @@ with the caveat that when used on the command line, they must come after the
>   
>   	Size in bytes for separate metadata buffer per IO. Default: 0.
>   
> +.. option:: pi_act=int : [io_uring_cmd]
> +
> +	Action to take, when nvme namespace is formatted with protection
> +	information. If this is set to 1 and namespace is formatted with
> +	metadata size equal to 8 bytes, fio does not send or check for

s/8 bytes/protection information size/

> +	protection information during write or read case respectively. If
> +	this is set to 0, fio generates protection information for write case
> +	and verifies for read case. Default: 1.
> +
> +.. option:: pi_chk=str[,str][,str] : [io_uring_cmd]
> +
> +	Controls the protection information check. This can take one or more
> +	of these values.
> +
> +	**GUARD**
> +		Enables protection information checking of guard field.
> +	**REFTAG**
> +		Enables protection information checking of logical block
> +		reference tag field.
> +	**APPTAG**
> +		Enables protection information checking of application tag field.
> +

Please add a note that the default is none.
