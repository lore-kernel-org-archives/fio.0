Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D9DC4332F
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 15:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242185AbiKRPGe (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiKRPGP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 10:06:15 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050238C794
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 07:04:46 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id x18so3565087qki.4
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 07:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FC8wLMwYliXU0Zz1dUYBmBlaHfSUBgc1gY70nGaFCTM=;
        b=YH7ZQhaw+cE5VQslCQlIz6liLqWrxKfA6t9FBkLiUrbpZmTW1J9S/1ep+z4zoKLfmJ
         ZPTOsy3+1rnzcu9on5Yy6d29jcwrp03JBUhzDn4Wq19HjndnWBYno5XEFlJn++p+wVmF
         HT3sDzY2mH2eqNH+/qFYJ55bFBAIhNsTzRTzO/RgTJuEDQOooPVk2e6rWPOl5ezopiEN
         hP2iaNhwe1rHDp+J7ReAR0+wYMAU/apWUI2FA2WSnm5lsyIlvhEI7Rajcw1UpYCMUR8A
         HhIGXUKvlU5W30iyv4ZWczf7ejAPLfp3ycyIVttm83zCiVrCMw25er/EtwYZKDvSTGpE
         3jMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FC8wLMwYliXU0Zz1dUYBmBlaHfSUBgc1gY70nGaFCTM=;
        b=0J4NqbxFwlBxzT0cKgkcVBOfv7nMGLt7p+FN0TotoRN6fSo3qkCu3PJ+cfV2AjvYVF
         2CBD4dDHfNPc3j3EYh2ejY/39pJfR29mtaaXxCn7p11ajjq9fE/wVNY1pvdl0+SMJILQ
         N7vEAYjZgZyn072Ax6YP7DeNUg1exJcW7JebjMWn966GJgT2fei/o+SU/BVEEAp0aGxE
         9okTZZAgA0O3wjDORELjNlN/lzrs1vyz/VCmcvTB4TsVZHABOmv7DA4tGpbQOofdSjDr
         GcUE14f5mrxErYo3EE7LodtoDralz/4gqKKS4KraIcKlYsstnssi6vQjK5g/hGukXcNP
         +7NA==
X-Gm-Message-State: ANoB5pn0YE1InZx/IX2341JsoCdeENWeMilD2kqWug288v9fxLGHOkLR
        ddqQShvjwmuY4zJZ5tzfAUUMuoLIdAqWHw==
X-Google-Smtp-Source: AA0mqf6RrCCAFY4pI278FvEuVkaq7jP0LzM2cuLiAHKeKZmDpYykxrLYnfn7ffk0vF/sYej5vKSBVQ==
X-Received: by 2002:a05:620a:21ce:b0:6fa:d149:6d47 with SMTP id h14-20020a05620a21ce00b006fad1496d47mr6218434qka.734.1668783884900;
        Fri, 18 Nov 2022 07:04:44 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id r13-20020ac8794d000000b0039cc82a319asm2062491qtt.76.2022.11.18.07.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 07:04:44 -0800 (PST)
Message-ID: <7c4b684c-03e8-9f33-3809-443ac7678a07@gmail.com>
Date:   Fri, 18 Nov 2022 10:04:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Content-Language: en-US
To:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        fio <fio@vger.kernel.org>
Cc:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>,
        "Kento.A.Kobayashi@sony.com" <Kento.A.Kobayashi@sony.com>
References: <HK0PR04MB23884FFF415F7EFCB424CABEFD049@HK0PR04MB2388.apcprd04.prod.outlook.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <HK0PR04MB23884FFF415F7EFCB424CABEFD049@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/15/22 03:39, Friendy.Su@sony.com wrote:
> Show correct file operation strings in log.
> 
> For file operation measurement, 'rw' field is set to 'read' in job file.
> The corresponding 'rw' in log is also 'read'. This makes user confused
> since file operation and IO read are totally different things.
> In this commit, add 3 new file operations to 'rw' field.
> 
> For implementation, TD_DDIR_FILECREATE/TD_DDIR_FILESTAT/TD_DDIR_FILEDELETE
> are added. Meanwhile, DDIR_FILE_OP is added to identify the file
> operation and IO operation. DDIR_FILE_OP is same value as
> DDIR_READ, then clat_stat[DDIR_FILE_READ] can be 'borrowed' for file
> operation statistics. Just set DDIR_FILE_OP_MASK when get io_ddir_name().
> This avoid big code change if add a new index to enum fio_ddir.
> 
> With this commit, user can explicitly specify the exact file operation
> in job file 'rw' field. 'rw' string and 'ddir' string in log is also
> correct.
> 
> Example:
> 
> $ fio   filestat-ioengine.fio
> t0: (g=0): rw=filestat, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=filestat, iodepth=1
> t1: (g=0): rw=filestat, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=filestat, iodepth=1
> fio-3.33
> Starting 2 threads
> 
> t0: (groupid=0, jobs=1): err= 0: pid=4744: Thu Nov 10 18:24:00 2022
>    file_operation: IOPS=20.0k, BW=78.1MiB/s (81.9MB/s)(80.0KiB/1msec)
>      clat (nsec): min=12645, max=29394, avg=13751.35, stdev=3690.55
>      clat percentiles (nsec):
>       |  1.00th=[12608],  5.00th=[12608], 10.00th=[12736], 20.00th=[12736],
>       | 30.00th=[12736], 40.00th=[12736], 50.00th=[12864], 60.00th=[12992],
>       | 70.00th=[12992], 80.00th=[13120], 90.00th=[13120], 95.00th=[13760],
>       | 99.00th=[29312], 99.50th=[29312], 99.90th=[29312], 99.95th=[29312],
>       | 99.99th=[29312]
> 
> Signed-off-by: friendy-su <friendy.su@sony.com>

<snip>

I think having this option will be confusing and lead to users trying to 
run a job with --ioengine=psync --rw=filecreate.

However, I understand the confusion that arises when the file operation 
ioengines are used. Might there be some other way to help? Perhaps the 
ioengine could emit some sort of message? Or the documentation for the 
file operation ioengines could be enhanced?

Vincent

