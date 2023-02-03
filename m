Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54FEC05027
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 22:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjBCWgM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 17:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCWgD (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 17:36:03 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD85D65EC3
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 14:35:58 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c2so7250760qtw.5
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 14:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdb0w5FJiobmtK90JG2s/2CrxbtB28w+N6VutetTDNE=;
        b=EPvvS/MakwWkIw7purUME15IuXTwE6sNirLOdXqO6uMi9okjgWl5hxvTFNYA32+hF1
         qrPdlK+CKs3j+MME7d4KGYCK5AIBEOReHbY9J7iVoHKyv/PRpRYVw3KFomxWgicwOEe+
         9NN6fxhJBm7n8us+QXNMm99ovFzEXEUC2By9fSOAOh6vxR2XJb2GZtIRCEyAtitSdGnH
         +cwNWDJbcXb1v8IiMPgLPhBEH2mZDG/n6lALZypkcrSKjRTVKuPgd1CkyL/WKdrT+oUW
         EP1/LXI0GdsOQfMn97GY/bdMUZWgPZZeSr5gJLRGuz33LnLlEEq1vtmqVpsTs2joTHAu
         Oeog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdb0w5FJiobmtK90JG2s/2CrxbtB28w+N6VutetTDNE=;
        b=NPqEKSfnyelW7lXPXHGAFLFQgpoU/gqJngU2Ez7V4vjs1nVX37X02dhM4Z1IU0gCCI
         Kv0LgmJp6+GUchn2hu/lWYRdNlizQBe88kHte5unK36rAL9lcmxhafi9jw3OgUqElvYx
         IlO+0I/KHgQmCQYC03+4Nc5QF9k81WN1RjrWNOw/Oc8GPYXba9dgEf1jhzFrXKBKWBMK
         LQYDwiF2cbFsYIrIZ6zRUT3XZzoRfdU8Yj2CXVRpXmyDgdCEjIBqzPt+abip4/p7mZaU
         kkMX2kKQN4ddvlG1OJJwn4QTcIz4JFmvoMzX+07YDPDbxXP/DUDfbZYrQ2H9n3fHorTn
         NRaA==
X-Gm-Message-State: AO0yUKUZc3A7HGI8sglRF3rErG9JLbV/FKkF+YOnDqpqSPC7XvgcVlmc
        lTINFskdJPxVGqz39M1IX78=
X-Google-Smtp-Source: AK7set+kSNTzCf+QnNhAnYVXZwmMEqygY79ONtrLz5Uq27o2L37+ZGdroOI0WX1V3+XiTE8lLKgX/Q==
X-Received: by 2002:ac8:5983:0:b0:3a7:e2df:e868 with SMTP id e3-20020ac85983000000b003a7e2dfe868mr22608759qte.41.1675463757770;
        Fri, 03 Feb 2023 14:35:57 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g11-20020ac842cb000000b003b86b088755sm2359366qtm.15.2023.02.03.14.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 14:35:57 -0800 (PST)
Message-ID: <5b1955e4-7364-6355-b0df-70952f4664b0@gmail.com>
Date:   Fri, 3 Feb 2023 17:35:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Reverse Sequential Read or Write
To:     Jay Han <jayhan258@gmail.com>, Ankit Kumar <ankit1455@gmail.com>
Cc:     fio@vger.kernel.org
References: <CAJ3QLKfSFjufUU2htxZQywrJX7iYiEwPGZf2TNdyO7O4u3tVYQ@mail.gmail.com>
 <CAJ3QLKfnvrYz_VqjppaNA-MyyRdEdfeHKb5M6TOPg7n7ZKACXA@mail.gmail.com>
 <CAKi7+wdkKz7-urkzXdWB2OTaC8aYSw3AWAtA7jfzJ1w1xU28cg@mail.gmail.com>
 <CAJ3QLKf4rUaxDAx8=Ysnp9EhYBsv4oEcRw5EuExOsav-1MP=ow@mail.gmail.com>
 <CAJ3QLKfAH4b_OnKbN-OGxnbnmz2m+UPJwsDLoS3YK0gxsJVnnw@mail.gmail.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAJ3QLKfAH4b_OnKbN-OGxnbnmz2m+UPJwsDLoS3YK0gxsJVnnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/3/23 16:17, Jay Han wrote:
> Thank you Ankit! I captured a trace using the example config file.
> What does rw=read:-8k translate to in terms of LBA? I am seeing 4K seq
> read in reverse manner. I am not sure what that 8k implies.
> Each read is apart by 8. For example, the workload accessed LBAs
> 1540000, 1539992, 1539984, 1539976, 1539968, and so on.
> Each read requested 8 logical blocks and the sector size is 512B which
> makes up a 4K read.
> 
> Can you elaborate the -8K for me please?
> 

The relevant documentation for the option in question is at the end of 
this section:

https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite

Basically fio is subtracting 8K from the end of each IO in order to get 
the next LBA to use.

Vincent
