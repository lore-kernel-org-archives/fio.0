Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B2AC433EF
	for <fio@archiver.kernel.org>; Thu,  9 Jun 2022 13:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244790AbiFINqU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Jun 2022 09:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238462AbiFINqT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Jun 2022 09:46:19 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C239F25D6
        for <fio@vger.kernel.org>; Thu,  9 Jun 2022 06:46:17 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c83so5277503qke.3
        for <fio@vger.kernel.org>; Thu, 09 Jun 2022 06:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=htVgx4X7wS3lsyyWTzkUBpM7KUC33TUdUvwrDGyQqfE=;
        b=HJIGxFhC61IytB/QixiWXCUPPNnusveK59meh+xLaPfif2KNqcg/Vks1cC81T7MRYU
         WH6s8c6fRXrPmV4PllFt10Y+dyfF61nq72Ja7a8wZNHWOGw6Ecf4ravOw+o817c8GMF/
         wq0v7KIA0Ad5xlCXUNBxNFnQ6FBwNtrrmrsvySDPI68CQM0DonL7B2217R3WpUVulFmC
         SljFWINhOAoZ4Bu0Asyn9R0zcd+LOap1zy5pQ9Zvg7vbxDpgLxPdCGsTYiLRX3VTyxb5
         ppx5S/JojjeuQ+iXe5n7Co+TkazR1i4HaF9py89s75JiB0kz1INW7kwSeEQC24cBmMHr
         5pJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=htVgx4X7wS3lsyyWTzkUBpM7KUC33TUdUvwrDGyQqfE=;
        b=nRnyDad7ZyW0SLNqq1I42H29SrFH/Ym62aB4DT8th3GuoZQjfvtsN+bZ8mubIw+64U
         sHuCB1FzY6O5l0CUoMUQKrFHivMaULiWPjBr7mgaGx15R6Nv55ThQXmlupe9Z/wCs+EB
         /zDA66ThgimKk8fTpIgBu+cPBhRO/OwdbnbpeZJsyT3cez8ZZnMFeF/VAXq/QTizq2fM
         H6Yyuyss76qc0Zx5LkSmUnAgBIsgFYocU005IIqUqV0OQY9vR+WpEKyLJyntz6kXgK9b
         ++N4S/Q0NrtXZ1KHXz3hQc5hd26n5adN9tnePQuntK/9Sf4aUwlMD7vv4Zwka5dyyivw
         zzTQ==
X-Gm-Message-State: AOAM533qBJNjjVjcn8Ohiqbupvg5+N3Wb34m4NogFP0/Q292598hHMLD
        f0VfLllojaIzWUxwQDxNEj2Z9BHJgfw=
X-Google-Smtp-Source: ABdhPJwED4ahWpTAlTM2BhoVf6D98zwE6OJOyW6+bZcZcjWS8uKPS5EsQwK1Ej8UHJsQCokx5A1Ljw==
X-Received: by 2002:a05:620a:319f:b0:6a7:1c2b:5ea3 with SMTP id bi31-20020a05620a319f00b006a71c2b5ea3mr3745435qkb.637.1654782376671;
        Thu, 09 Jun 2022 06:46:16 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-46-23.washdc.fios.verizon.net. [173.79.46.23])
        by smtp.gmail.com with ESMTPSA id t19-20020a05620a451300b006a6d4261f40sm8379561qkp.111.2022.06.09.06.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 06:46:16 -0700 (PDT)
Message-ID: <b862c6ba-ba87-bf1d-b695-4529e19335a6@gmail.com>
Date:   Thu, 9 Jun 2022 09:46:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, gost.dev@samsung.com
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Blog post on how fio measures latency
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I have a new blog post describing how fio measures latency:

https://github.com/vincentkfu/fio-blog/wiki/How-does-fio-measure-latency

Feedback is welcome!

Vincent
