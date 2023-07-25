Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5E1C001DF
	for <fio@archiver.kernel.org>; Tue, 25 Jul 2023 16:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjGYQzO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Jul 2023 12:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjGYQzO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Jul 2023 12:55:14 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B71C10B
        for <fio@vger.kernel.org>; Tue, 25 Jul 2023 09:54:48 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-76ae5b44426so304886085a.2
        for <fio@vger.kernel.org>; Tue, 25 Jul 2023 09:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690304087; x=1690908887;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i6bTv08TE9f8R+54n9MWEsVWdEHSyZ13aWBKbEgqLnc=;
        b=D1xUgejeuhgt7lE9QkAu+KNUgzk8hrTzjnRS4VUSjODtuY5tA1H8X/k4c0wLoEMgw/
         kYhmKbQLFv//imaesXufme73Iuhl1b3QTp06aOt1UI9uj8hQI4uCpmklzJ6/cziREWmJ
         sTu31tpOYAw3eoLpGfv687jwnk0Oe9hBk4QaFkFZQGf/CWEe9gh8QtPYwPmZcFV7ikDk
         B9HkupE7MMMNVg+j3FapEkx1IbLOu1PPJqtKhmv0Jq8EluKCbp4533/I+/HJd7rLChRY
         DdMVBoCXqhJqLbwEnY0H52txlRu3PK2GOK4g2DNodUr9uCc8Z2GbEpFdt5F4SyLZ+Mjx
         OkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690304087; x=1690908887;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6bTv08TE9f8R+54n9MWEsVWdEHSyZ13aWBKbEgqLnc=;
        b=lmVo+q6uDqJU1LsLfugoLIUHv0QWoiI+C16cuE3Fibk2j29m+wP1x49n5Rtrn84ezY
         /ay9CCH4edxAKsDa2PgN3rjVkSvDnN2CyNqc7crforwcUTvo2HezrGJgvPR1sAocqf8R
         kBDvqvazPcxxST9WPsPofpkEe3J9XgbrlSrMQFIqNmhgBZpYWNbJxWMxVthClorqtaPj
         H3qQhDMBa1InM79ldUTcmHo2jd1lK0kx6kAnj37XgxbBgv0osrUl3BWfTfJ0hGp89I3m
         7Cp3N1sJ0X3bMAHQzTs9YwU0AAzXxEl4wGPuq+w3wdORo8t36Gr5iIXu/uYLgfNap2Rg
         7rXg==
X-Gm-Message-State: ABy/qLYzNfSGjo6B2HQAVj3s6ImOuaGPieMNnK0M0/dy9EIlKXg545TU
        vwlPBOogprkMoyvE5vae7JI=
X-Google-Smtp-Source: APBJJlEHhpIQE+cEFZTh35IH5UgGC0UPclxgK5ucVlzw8tVfeG7jBiHyUMl5GPmEP1pJuRt4TmQbLg==
X-Received: by 2002:ad4:4592:0:b0:636:fda0:a23 with SMTP id x18-20020ad44592000000b00636fda00a23mr2913842qvu.27.1690304086861;
        Tue, 25 Jul 2023 09:54:46 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id o7-20020a05620a15c700b00767cd2dbd82sm3798577qkm.15.2023.07.25.09.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 09:54:46 -0700 (PDT)
Message-ID: <0f9e734f-ede3-510c-a38c-c51251529484@gmail.com>
Date:   Tue, 25 Jul 2023 12:54:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Maximum number of files we can read/write with FIO
To:     stelios evagorou <stelios_evagorou@hotmail.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
References: <AS4PR07MB8681AC26C1E2CB7796A97463F903A@AS4PR07MB8681.eurprd07.prod.outlook.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <AS4PR07MB8681AC26C1E2CB7796A97463F903A@AS4PR07MB8681.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/25/23 09:47, stelios evagorou wrote:
> Hello,
> 
> I was trying to create a job file that has the following form:
> 
> [global]
> blocksize=4k
> ioengine=libaio
> readwrite=randwrite
> size=20G
> name=test
> numjobs=32
> group_reporting=1
> file_service_type=random
> iodepth=128
> fallocate=native
> runtime=120
> directory=/tmp/ssfs/home/sevag/fuse_ext4
> [jobs1]
> filename:f1:f2:f3......f8192
> 
> 
> but when i tried to run it i got the error message "value exceeds max 
> length of 4096 fio". Is there anyway to achieve the above setting?
> 
> Many thanks,
> Stelios Evagorou

The error occurs because the maximum possible length for the value for 
the filename option is set to 4096.

Instead of filename=... try the following:

nrfiles=8192
filename_format=f$filenum

The files will be named f0, f1, ..., f8191.

Vincent
