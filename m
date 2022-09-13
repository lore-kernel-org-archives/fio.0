Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C932C54EE9
	for <fio@archiver.kernel.org>; Tue, 13 Sep 2022 21:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiIMVDS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIMVDQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2022 17:03:16 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17F6B162
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 14:03:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bj14so22643742wrb.12
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 14:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=1OGk8O67r94RMWUvjZgFCLRV4B05gOIfjIfeFgxNTYw=;
        b=Kuzd59WR3JurSW5iQvYyV2XcPo1D3E55RG+rh96FwNhDV72Dmj7udKMPBjQY6uil2Q
         A5SSdVkl7FJ6ae5pLQeD+II+Hlqzz4OsEOLVLQb0HPFDEQRJxwDiut/6vUv6oJ9sz7Ej
         ZcJF7SAuF7HQjXmPaD1zjw+KHDonMs448mXqj730Ig7siK2eUNydAZIY9yNmMpkyVMzA
         +usmk0aZ3P6JjSxL/nMqBj/XlQSMnnsKbjXRb/Aqs469sVqyTdujDFRc/POxa4rsNkgc
         D7a0pGJtFGg+xUnErQSPcp364DiIwkD7WN2CTxAbYXqYCrpW+3TqWQHyo7InoJWcwEbv
         pLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1OGk8O67r94RMWUvjZgFCLRV4B05gOIfjIfeFgxNTYw=;
        b=eQkvm4LqBY3IPry6NWmcALJumqQMJ0UnDMiqjpLxt9jL29HdnOphAWh1TK+OOrwkjd
         AY9Hm5QAM/fe6zaXAzn6XHWE1e0eD+dONZQTWw1Fl1ZrL3vsUKVjrCktA5VaGMv71/wx
         +ZITj0Pzn6ut5LDoEpu8iXewlked4jnbcUxzG+P8fEhKwC6onhEJGxKzamnoCgNZ/Ntf
         RJKFDOjj3ztbV0gAVHxU1yDT2oiO+23ITW5a9nFqerjYAkJRlDojWjpBYJ0NMQdjAp07
         jgeB4WheTg3cRePSOqEimcvCJsVccqQ3aN1jmyhz7L41ZbfneBXzgms1afzjDuyAfFD/
         pIqg==
X-Gm-Message-State: ACgBeo0IuAclJ0Ts4674y7ltSc8oxN8AnujRNRZZtQyd5E5sh/kCj69g
        IJ3guOkV6cgMQYbj/FG/qNSslA==
X-Google-Smtp-Source: AA6agR4xlmal1XHgI8CaCp0BzfCaqe9XwgWOsP0fXe6qTH4gVRf3v4it8x0Etz7Nj/ZwYOGV5CGYLw==
X-Received: by 2002:adf:fa10:0:b0:228:a0a4:844a with SMTP id m16-20020adffa10000000b00228a0a4844amr18652152wrr.127.1663102992847;
        Tue, 13 Sep 2022 14:03:12 -0700 (PDT)
Received: from [172.16.38.121] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id x5-20020a05600c21c500b003b4727d199asm12018885wmj.15.2022.09.13.14.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 14:03:12 -0700 (PDT)
Message-ID: <2e4f4cd3-c8ef-25f9-b888-d594e72bfba7@kernel.dk>
Date:   Tue, 13 Sep 2022 15:02:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 1/1] backend: number of ios not as expected for trimwrite
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org
References: <20220913104527.18734-1-ankit.kumar@samsung.com>
 <CGME20220913105532epcas5p43dcd5a649dbad6bc6d39574677cb73b9@epcas5p4.samsung.com>
 <20220913104527.18734-2-ankit.kumar@samsung.com>
 <8b947201-1c71-d151-4748-0e80cfda4d04@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8b947201-1c71-d151-4748-0e80cfda4d04@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/13/22 10:07 AM, Vincent Fu wrote:
> On 9/13/22 06:45, Ankit Kumar wrote:
>> number_ios should be twice for trimwrite, just like size or
>> io_size. Update the documentation for "rw=trimwrite" to explain the
>> changes.
>>
>> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
>> ---
>>   HOWTO.rst | 6 +++++-
>>   backend.c | 6 ++++--
>>   fio.1     | 5 ++++-
>>   3 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/HOWTO.rst b/HOWTO.rst
>> index 2c6c6dbe..924f5ed9 100644
>> --- a/HOWTO.rst
>> +++ b/HOWTO.rst
>> @@ -1129,7 +1129,11 @@ I/O type
>>                   Random mixed reads and writes.
>>           **trimwrite**
>>                   Sequential trim+write sequences. Blocks will be trimmed first,
>> -                then the same blocks will be written to.
>> +                then the same blocks will be written to. So if ``io_size=64K``
>> +                is specified, Fio will trim a total of 64K bytes and also
>> +                write 64K bytes on the same trimmed blocks. This behaviour
>> +                will be consistent with ``number_ios`` or other Fio options
>> +                limiting the total bytes or number of I/O's.
>>         Fio defaults to read if the option is not specified.  For the mixed I/O
>>       types, the default is to split them 50/50.  For certain types of I/O the
>> diff --git a/backend.c b/backend.c
>> index fe614f6e..ec535bcc 100644
>> --- a/backend.c
>> +++ b/backend.c
>> @@ -971,9 +971,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
>>           total_bytes += td->o.size;
>>         /* In trimwrite mode, each byte is trimmed and then written, so
>> -     * allow total_bytes to be twice as big */
>> -    if (td_trimwrite(td))
>> +     * allow total_bytes or number of ios to be twice as big */
>> +    if (td_trimwrite(td)) {
>>           total_bytes += td->total_io_size;
>> +        td->o.number_ios *= 2;
>> +    }
>>         while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
>>           (!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
>> diff --git a/fio.1 b/fio.1
>> index 67d7c710..c67bd464 100644
>> --- a/fio.1
>> +++ b/fio.1
>> @@ -900,7 +900,10 @@ Random mixed reads and writes.
>>   .TP
>>   .B trimwrite
>>   Sequential trim+write sequences. Blocks will be trimmed first,
>> -then the same blocks will be written to.
>> +then the same blocks will be written to. So if `io_size=64K' is specified,
>> +Fio will trim a total of 64K bytes and also write 64K bytes on the same
>> +trimmed blocks. This behaviour will be consistent with `number_ios' or
>> +other Fio options limiting the total bytes or number of I/O's.
>>   .RE
>>   .P
>>   Fio defaults to read if the option is not specified. For the mixed I/O
> 
> This is the right behavior because io_size and number_ios should be consistent. But this will require folks who have worked around the inconsistent behavior to adjust. I'll let Jens make the final call on this one.
> 
> Reviewed-by: Vincent Fu <vincent.fu@samsung.com>

For cases like this, I do still prefer to fix it up so that it's consistent.

-- 
Jens Axboe


