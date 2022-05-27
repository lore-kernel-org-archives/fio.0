Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1612BC433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 14:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353243AbiE0Oyt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 10:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350969AbiE0Oyr (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 10:54:47 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF76A13C4E0
        for <fio@vger.kernel.org>; Fri, 27 May 2022 07:54:46 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id p4so2671848ilj.8
        for <fio@vger.kernel.org>; Fri, 27 May 2022 07:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZochwJ+e53iGcqzGIE6LPBcQX7tunkFXXmghHgbO2x4=;
        b=v2iRlqGlwvsVXT5x0+47tm+tHYKsNrtnUMFLqE/xATHu0U2g+RqPIhQeK28JxxzMTE
         IfpoXiRCKlNpKnHkbvuIU3F0DHrc4Sv+V3uFrAd/gI3pLk+OcIh8gDJXOTxXuDoFCTmL
         n/Geo3P06WKmmE4Q/0gC0xXFiI2qVoQ3MfQAcO2N025X6fHOCNdzDzlkpoYli4Ew5keh
         oF/mzCcrY+Iovy6OkY49NCQVsuX2tlM8EWM75Lk3qfAsoxhVhunz9ZQ3VsrUS2D3CDjB
         ZAvAnDZoYvBBO+rusKuBU/vSKlLfwkLuEITfVD5BEQ8p4hJzw1xbQtAQn+QbHw2inPf7
         b0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZochwJ+e53iGcqzGIE6LPBcQX7tunkFXXmghHgbO2x4=;
        b=A8GLx4DO0y0o+j9o1f/cpAMLTh4rgpkWsNbLwaMTGO7UxBL6Lsz7AbfNswf4fPtAzr
         gSy2syRzf4uosEMftpbmRU2/3KdLY0aFyOfCqZXkHzXOZhbSBRLIxvbgTe/AYT6+MCVA
         hTs+p/MgtVNF6EEW4ABpRInBLXKiBKfNsQEs32A0zexkU9ugO8ye1QmY5QRvZFCaA+8P
         ZdEwjL3bCX+RmZ2hHY76Ak2eX6f2W3RKcnLRxB+64uU2iijr8FJ+wuKk/LYozCpDI9bg
         +SUgMbuTra3L5X9iP1Q2RkkUIIE4Qf4hZwIyEx9Mm0vMN2H2V5JD18mSWbgLsMbjLmsF
         ZEYA==
X-Gm-Message-State: AOAM533H93xAIFWYeFLgwxKWZfMFLaDkoRjXWYiK3g9p+m+FJFVLqMwp
        LWtInHIt8MGKFqOMu8x/14RmeA==
X-Google-Smtp-Source: ABdhPJxyPmBr+BLaLxuVEhc8fsq7yE5IY5FwHr8Z5yRcIplSN2Enaj8Y3wnZcFvdaRjvvbddFEgrdA==
X-Received: by 2002:a05:6e02:1ca3:b0:2d1:aad8:9043 with SMTP id x3-20020a056e021ca300b002d1aad89043mr12943223ill.200.1653663286372;
        Fri, 27 May 2022 07:54:46 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i14-20020a05663815ce00b0032e102760c5sm603965jat.73.2022.05.27.07.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 07:54:45 -0700 (PDT)
Message-ID: <f2c8a94b-7c54-7b87-f417-602a134eef04@kernel.dk>
Date:   Fri, 27 May 2022 08:54:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
 <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
 <20220526144809.14877-4-ankit.kumar@samsung.com>
 <9e2905ec01eb4350b1896491fc29dc8b@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9e2905ec01eb4350b1896491fc29dc8b@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/27/22 8:45 AM, Vincent Fu wrote:
>> -----Original Message-----
>> From: Ankit Kumar [mailto:ankit.kumar@samsung.com]
> 
>> +
>> +	if (io_u->ddir == DDIR_READ)
>> +		cmd->opcode = nvme_cmd_read;
>> +	if (io_u->ddir == DDIR_WRITE)
>> +		cmd->opcode = nvme_cmd_write;
> 
> Consider changing this to a switch statement and adding a default:
> case in case someone tries to send an unsupported command.
> 
> Since this is in the  fast path a switch statement would also reduce
> the number of times ddir is checked.

A switch or if/else won't make any difference there, the compiler should
generate the same code. But I do agree that it's nicer to use a switch
so that unhandled cases are done properly.

-- 
Jens Axboe

