Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65141CDB47E
	for <fio@archiver.kernel.org>; Fri, 13 Oct 2023 21:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJMVcv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 13 Oct 2023 17:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjJMVcu (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Oct 2023 17:32:50 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B8EB7
        for <fio@vger.kernel.org>; Fri, 13 Oct 2023 14:32:49 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-77409065623so161863285a.0
        for <fio@vger.kernel.org>; Fri, 13 Oct 2023 14:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697232768; x=1697837568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E/lnkgmxN8Ub4q033AqtepHxCrK5teKH7op4ToC6gfY=;
        b=DQrbeQtvDNcmIiRx50YgHr89FrtjWzy8z4wT4PFGujvaG+tl+mzQvOe7yCYc69ESGH
         xlQRYqSUo2iidvIhr0UNpgZajGG1qGFve/kwECnCuiFG3jsfCs55UVxlBL9r4w7eD0r2
         0JftVo7cuP1O+t0TfZVQpSJ9Etd+O15D33FuBd/8syIJnX5kI9KCka4DSYvk2B5WqNgQ
         f7CzspG4HWTYk/RguI9HiK8JQNvQorCc6kSQtOow5tUpl9e4s5i7fgeqPDe/CqaOQmb6
         SfvykxFm4UJE3cq9FVWXul+6+6VMOyu6apk9fwk5CzVlRpZjMgIxE9vuRY6TeBmdHlY2
         +98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697232768; x=1697837568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/lnkgmxN8Ub4q033AqtepHxCrK5teKH7op4ToC6gfY=;
        b=uoZvU7aRd07CNhV7uJBMPzu/kXf5gVKk8acWkfTUNrpaXld84LK1AqyPMrUgDTtdzb
         /8cmBdp/W3MOhkxAnHoWONnT7gks9EdbRVOv+hvOuSuMIqVFmgvTAjXEppBYH9tSZlg2
         KRVaqanN35riBF5cYzGgnvPJQviNv9Z4STFcX9QdjDNekZojhLCr3B8BXgGt1R/O8HHk
         YELaHep1eQ/SlNLkrMecw2ildGp6i1W+7xbD+nYtFsHxJKFR1xf3nrvcxKv2BJKwVt+7
         9eiblCPsIylok1JfJq4389ja+VZyLlLjZv+C2X7AM/RMOBbED2fwFRq0ix7FwKwyLm22
         LMDg==
X-Gm-Message-State: AOJu0Yw/KhYxqjG6UggxyQH5Mk1r8+fhZaB6NQqGd/W1dcak8czbXFKb
        wSgoGDx9DBvugScnGDjuas7nWrs6cYMA/w==
X-Google-Smtp-Source: AGHT+IF/uKXvZ1vt1iLQAedFApegokhBg3ashnDtwvQtrEaDLdNARyunId9MERC53X2vyruhfAMibg==
X-Received: by 2002:a05:622a:54b:b0:417:a74f:69b6 with SMTP id m11-20020a05622a054b00b00417a74f69b6mr29301575qtx.65.1697232768109;
        Fri, 13 Oct 2023 14:32:48 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id p4-20020ac84604000000b004181234dd1dsm905970qtn.96.2023.10.13.14.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 14:32:47 -0700 (PDT)
Message-ID: <e3d6913b-b1ef-7281-2dc5-adfd370034bf@gmail.com>
Date:   Fri, 13 Oct 2023 17:32:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] t/zbd: avoid test case 45 failure
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20231006071320.425270-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20231006071320.425270-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/6/23 03:13, Shin'ichiro Kawasaki wrote:
> When zonemode=zbd option is not specified, random writes to zoned block
> devices fail because writes to sequential write required zones shall
> happen only at write pointers. Randomly chosen write addresses do not
> match with the write pointers, then fail. On such failures, fio prints
> out the message below and tell users how to avoid the failures:
> 
>      "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd".
> 
> The test case 45 in t/zbd/test-zbd-support confirms the message is
> printed when the first random write command to a sequential write
> required zone fails. However, the random write can succeed very rarely
> since the randomly chosen write address can be same as the write pointer
> address. For example, a zoned block device with 1MB zone size with 4KB
> block size device can have the first random write at write pointer with
> ratio of 4KB/1MB = 1/256. This causes sporadic test case failures.
> 
> Avoid the failures by two changes. Firstly, change the random write
> range from a zone to whole sequential write required zones to reduce the
> failure ratio. Secondly, repeat the test if the message is not printed
> by the accidental write success. As the test repeated, failure ratio is
> multiplied and the failure ratio becomes as small as it can be ignored.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   t/zbd/test-zbd-support | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 0436d319..2f15a191 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1058,15 +1058,20 @@ test44() {
>   
>   test45() {
>       local bs i
> +    local grep_str="fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
>   
>       require_zbd || return $SKIP_TESTCASE
>       prep_write
>       bs=$((min_seq_write_size))
> -    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
> -		    --offset=$((first_sequential_zone_sector * 512)) \
> -		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
> -	tee -a "${logfile}.${test_number}" |
> -	grep -q "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
> +    for ((i = 0; i < 10; i++)); do
> +	    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite \
> +			    --offset=$((first_sequential_zone_sector * 512)) \
> +			    --bs="$bs" --time_based --runtime=1s \
> +			    --do_verify=1 --verify=md5 \
> +		    >> "${logfile}.${test_number}" 2>&1
> +	    grep -qe "$grep_str" "${logfile}.${test_number}" && return 0
> +    done
> +    return 1
>   }
>   
>   # Random write to sequential zones, libaio, 8 jobs, queue depth 64 per job

Applied. Thanks.

Vincent
