Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC56C77B76
	for <fio@archiver.kernel.org>; Mon, 17 Apr 2023 14:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDQOeX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Apr 2023 10:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjDQOeW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Apr 2023 10:34:22 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC52959DC
        for <fio@vger.kernel.org>; Mon, 17 Apr 2023 07:34:19 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id js7so5975593qvb.5
        for <fio@vger.kernel.org>; Mon, 17 Apr 2023 07:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681742059; x=1684334059;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i5agO/n3LGoET6PhEjLm5zslDvCUS5f2ALuFjZQ3MHg=;
        b=AH6yd5XtPnXNoPgZwqxFTwN8zhrJcNGVGPOv1ocO1k27dthNtskmne25CQMsp6MqNd
         740Z8qvEg7zYDZLF2AzrmT7XESKq+297T3iNKHjWhoi13l2w8qUuR0TL44RRYCZKxOZR
         zCpaPmqt9xmOLmIGMUZUYLOpirwysd+ESCXR9CIWxUcrLM5UP78m2n8mrB/iJe5BlF2N
         YSwlTnfQxogLgLodnNaEZ0QdxBX6VMF5POmdx1MsK8/KbtTZACiFcY3a+efuCw1/vcSf
         HNZMNLyNwRc0evUJcY0jC0baFYFXzHZMwHcBB0S3SqY4gTuvnbqjkdKeAWMkfeABiyDz
         NZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681742059; x=1684334059;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5agO/n3LGoET6PhEjLm5zslDvCUS5f2ALuFjZQ3MHg=;
        b=i6qAL9Sj85sFhXJUpVGcSd6wAZMqyA/8gqzZRasLWdjgXv6pA4HE4JNPl49lGkZBsi
         XHVI6lGegaFxDVYlzjOZGpR+6pUrSo8AtDu3zNMHrZYhKy6ryuM+yGRESRuwug4QBSNk
         mxb57Xia8MaeecU5IKFPvOtLb84T5SO0C8hQr+qtQilYPQQy73DiCHk1ljohjoISny2X
         yyprTLPbdL0e1vUw8qOSFWQaQOoc/GojbkRoguSZ5YDCXZ3A1gGCc8FLHWFwefuYa1EU
         psIO+0QdkRreXOIcyN4QaIiMYADxrnIPVhBwYIcxCPf5cCDKxG7N1QckEfIWOYSVhwIn
         VTow==
X-Gm-Message-State: AAQBX9eYzdr6HIKFTPWtp0nsaA4B5igJmGXaINfArNLRQCQGzk/8Zwlp
        vcdux8Ojc+cvvc74TV2/uJSCqT8EEVI=
X-Google-Smtp-Source: AKy350Z9WPHWDF8uw8DOwI+7rFB5kwRJe1Y2O2cuFmm/u7UtOpJLog4lkE0hhZBUSjkuJv4j1N9VTw==
X-Received: by 2002:a05:6214:27c2:b0:5ef:4bdd:42e0 with SMTP id ge2-20020a05621427c200b005ef4bdd42e0mr17422502qvb.51.1681742058702;
        Mon, 17 Apr 2023 07:34:18 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id v9-20020a05620a0a8900b0074abe1e1457sm3202019qkg.76.2023.04.17.07.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 07:34:18 -0700 (PDT)
Message-ID: <7b2f76ca-42bb-dc73-dd07-2cc79729ecb0@gmail.com>
Date:   Mon, 17 Apr 2023 10:34:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: fio terse output Write/Read Bandwidth (mean) = zero depending on
 ...blocksize, filesize?
To:     mmoole <mmoole@gmail.com>, fio@vger.kernel.org
References: <f2bd3a9d-8585-4148-8952-9d5ded6f889f@gmail.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <f2bd3a9d-8585-4148-8952-9d5ded6f889f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/17/23 07:44, mmoole wrote:
> Dear fio Team,
> 
> I am running fio in a loop with varying values for some parameters:
> FIO_RESULT=$(fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=$BLOCK_SIZE --iodepth=64 --readwrite=randrw --rwmixread=75 --sync=sync --numjobs=5 --group_reporting --size="$TEST_FILE_SIZE" --filename="/$ZPOOL_NAME/$TEST_FILE" --output-format=terse)
> 
> For each run a zfs pool is created and afterwards discarded.
> 
> Now the output I analyse in Excel looks strange at some points:
> * some combination of those values lead to output of a lot of zeros in relevant columns, especially Write Bandwidth (mean) and Read Bandwidth (mean) and their accompanying columns.
> * it seems that small test file size and large block size lead to that, but not exclusively?
> * on the other hand Write Bandwidth (KB/s) column gives huge values compared to other runs, how does that make sense?
> 
> See picture of collapsed table attached. (https://imgur.com/a/V5FsmmU )
> 
> 
> 
> Would it help to provide the full table, or is there a logical explanation for this, like something regarding block size, multipliers, filesize, r/w percentage or so on?
> 
> 
> greetings
> Sven
> 
> 
> 

Fio will report two types of bandwidth figures:

(1) overall bandwidth: (total bytes) / (total time)
(2) average of bandwidth values from periodic samples taken during the 
job run

You are observing a situation where (1) is non-zero but (2) is zero.

All the evidence you have presented suggests that your jobs are 
finishing too quickly and fio has not collected any bw sample data and 
reports zeros for the sample-based statistics.

For more details see:

https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output

Vincent
