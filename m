Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FABC83003
	for <fio@archiver.kernel.org>; Fri,  9 Jun 2023 13:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbjFINsl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjFINsk (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Jun 2023 09:48:40 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277FE18D
        for <fio@vger.kernel.org>; Fri,  9 Jun 2023 06:48:39 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-392116b8f31so593151b6e.2
        for <fio@vger.kernel.org>; Fri, 09 Jun 2023 06:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686318517; x=1688910517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJ9YE56ihk8fkauKd5gyd/+jZ4HKv09kF7MIhZDdxf0=;
        b=m6WU/9Ij346WR0r7Id+XpvBGmS6BQMqv5VGErWDa1e/HTRkmm1d7zJElnOZ1GWEXI5
         kJ4rKtCyVvVco4kRZX6Gc9PZtm1vMSvA7nu2fUJNloGkGleD61jCUKh2yULx+xUomhhu
         42Inz+wHxovjKYVBNrNdp1i0fXrWhpESS0GiXZeKMp/JVabgiYvneYCiGB06wwz6PZFq
         j0ZySnsF2eIasS7/1CAzyGtV9/jyPxlXdEBKWo7UzO8JribW8QyK/Ui+IMMH1yqaBbtw
         PV0ZMIg65Ry5F6nB+rh108qam36NyKrvDOiGVGvyG1Hv4PMHxO9eC1A/h5IG0pBzBui4
         5Bxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686318517; x=1688910517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJ9YE56ihk8fkauKd5gyd/+jZ4HKv09kF7MIhZDdxf0=;
        b=ckYW9Wz8A6cFiWPOYPKFHTweANmttHAEGSl537W3c0ZMQwkzqAOiNOoMYeIDhCxO7k
         PoG/sKmtMkZuuf9jLGnvginmiHuEDJzjNb0PY1LQnpHvr3qWDBH6j7BS9r3oE7lvDEKd
         KQhWIUpPZuhmmcPS69Tt5a+gXN+29cIrM2uezewIvKWTppzebGxC7rlqdV/k4rTqrEH8
         +TdZeLn9+iCZVRJNwVcSVFYa54MiP7tzFclH7ZuEz71V9364Jvy5vALe6op4aIzFmQIO
         73MUMj3PF4yNDjZrcNYgb4aPBjG1Au6hEuDZPPWNPj6wXE59SSrOriNKX8gQZIpiGWYW
         SsTA==
X-Gm-Message-State: AC+VfDwn3rD/ACHZYO294vllrFDuREXg53VmZ32D6+xVK/4kuWZwng6T
        amhOIyuUY9WO0jtIcMO+Mns=
X-Google-Smtp-Source: ACHHUZ5wZbZ5/FjNihUNdVnOcWy3EhGV+OO8wVW12wOEF6hA3KujQvEdiNl2EFfQRsYh+nGYZPSnew==
X-Received: by 2002:a05:6808:7ce:b0:38e:eaf:cf16 with SMTP id f14-20020a05680807ce00b0038e0eafcf16mr1413807oij.54.1686318516601;
        Fri, 09 Jun 2023 06:48:36 -0700 (PDT)
Received: from [192.168.1.241] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id e19-20020a0caa53000000b006262d158ab9sm1141383qvb.124.2023.06.09.06.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 06:48:36 -0700 (PDT)
Message-ID: <5271f7bf-a694-70e5-7cda-ec067b16b45b@gmail.com>
Date:   Fri, 9 Jun 2023 09:48:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
 <be2ca491-c88d-0db9-f7d4-ecf71d485845@gmail.com>
 <c89d540c-cfb6-2830-6e3f-d16d2d577bd1@kernel.dk>
 <cpjjghwm3pzoxvrr2bq2o3an4cpukwgjmqhgz52cb4cgi5u6ps@yv6jpi4lve5f>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <cpjjghwm3pzoxvrr2bq2o3an4cpukwgjmqhgz52cb4cgi5u6ps@yv6jpi4lve5f>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/8/23 23:09, Shinichiro Kawasaki wrote:
> [...]
> 
> Thanks for the notice. I think the defect report is false-positive. The
> variable in_flight is on the stack and thread local, so no other thread
> can change it across the zone_unlock() and zone_lock().
> 
> I guess and hope the following patch will suppress the report. May I ask Vincent
> or Jens to confirm it? If its formal patch helps, please let me know.
> 
> diff --git a/zbd.c b/zbd.c
> index 9455140a..7fcf1ec4 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1547,11 +1547,11 @@ retry:
>   		dprint(FD_ZBD,
>   		       "%s(%s): wait zone write and retry write target zone selection\n",
>   		       __func__, f->file_name);
> +		should_retry = in_flight;
>   		pthread_mutex_unlock(&zbdi->mutex);
>   		zone_unlock(z);
>   		io_u_quiesce(td);
>   		zone_lock(td, f, z);
> -		should_retry = in_flight;
>   		goto retry;
>   	}
>   

Shin'ichiro, yes the above patch silences the Coverity complaint. Would 
you send a patch for me to apply?

Vincent

