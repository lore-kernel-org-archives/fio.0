Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A75EC04A6A
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 21:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjHNVxn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 17:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjHNVxk (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 17:53:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF58E7E
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 14:53:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-268663fb09cso608095a91.0
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 14:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692050019; x=1692654819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEVleOoFnF9pESZURgnzyIWnBX9qRRGsJRG5O1Zsz8o=;
        b=r6qZtlRZjb9oSTJSeECEQTHE13Vs1B8W1NmR9henVwMSz6cPo7xhr6WUa2GNUCNv9A
         pLpc4LsMfOH8DsvyxpUnbpnAqmPJQKd0pwhq4yK4NxjlsaPthLfRpI9VW5Hdn1nnfwCH
         t4Xpjj0S0Of9lU/QJNksl6BfvBpboNaGVADt8r0Ct6zfK0N5fmPj1EHkI6FclZKqGET9
         4iSFMez+UIBQeuPScH1slReVu4OfDWxaMdcWorGjTfutfPPx4Ak/8FT6rCy++mP0KS5q
         klfeNKNl8mm7qU2Yni6tty+L6bz3mITqy1l9hugjRKSqix+tFco2iCklg+B5tLSGuvU/
         k3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692050019; x=1692654819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEVleOoFnF9pESZURgnzyIWnBX9qRRGsJRG5O1Zsz8o=;
        b=ZZFilYJnHUwkocTvHwPxEm+aoU4oTDvbHEAIxAwvquUNgqHmpSGM8Z+dK55JJHNwDb
         9NLQqcgzo1jKAiUfjbn0qHwCf7Gg4ylVWQviPLeDLymGnNO4tzfm92cpX2cFpMHM1/et
         8d7Byl0kWdVNSuaAUpq7VxLENKzndnCflJN7mPKzEsAFcH7/d8M8zt914GXRyQXgCEpr
         V0wnr7z9TaMTBYLADybk809uV4HDpSJ5KLNOa7hhMonrMm8+hhKo+w9iLF0DuRj4Ybfn
         luyHPrAvv+YCskLAo/95gbBnFZkkGMwgOK0mawAxyS88k5iDox7BKBKidPye8u0wxA4N
         vOhQ==
X-Gm-Message-State: AOJu0Yy5j2o1crW3weNLtvxLONtQ+DmN1IbTcQRN3qHvuv8wsm1pTqFy
        k9bQrw3fAjIRqZmecN0ycEWcYg==
X-Google-Smtp-Source: AGHT+IEHtP5UlkkcMwbiBhqKuEUIOLZUpVKBdxZ6LHcCf+Ycl1TmAAxSj6S1GWA0Td1iLlk1J5JAaA==
X-Received: by 2002:a17:90a:12c5:b0:26b:25c:34a9 with SMTP id b5-20020a17090a12c500b0026b025c34a9mr8677321pjg.2.1692050018810;
        Mon, 14 Aug 2023 14:53:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090a2b4700b0025dc5749b4csm10366324pjc.21.2023.08.14.14.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 14:53:38 -0700 (PDT)
Message-ID: <b4b031ef-d52c-4fa3-b5a0-a3175d83621d@kernel.dk>
Date:   Mon, 14 Aug 2023 15:53:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] Protection information support for io_uring
 passthrough engine
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <CGME20230814093836epcas5p44bc762fa6e4368d532126494115aeba4@epcas5p4.samsung.com>
 <20230814145747.114725-1-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/14/23 8:57 AM, Ankit Kumar wrote:
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

Please add an example job file, new options like this should always come
with one.

-- 
Jens Axboe

