Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB159C77B73
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 11:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243776AbjD0LsI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243775AbjD0LsH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 07:48:07 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0775659FC
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 04:48:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-517f1d5645aso1369824a12.0
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 04:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682596083; x=1685188083;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=32XQ3+ZCmfjjdoPj6HZo9njH0s8zAKo0k4zwc30Vq4Y=;
        b=IiyasIK67uVMtcnlhbBv2CDyQwQi0HjVdccjDwmhKuEWtK+bEpruW6u/HJ9EUHBFgv
         PjiBp5/p82NVVhMn8NSJthwKwrD7RXcTEcB1FxTF0kNhbK+ysrO5IkNQto3EoZTUOveW
         sleVEVOVm3UP4LftpILY4H56UBkd+rCRkT73N8sVgS2mvvP2fpd0vy9L0Uv9KapHkAm9
         L+SNBuL/PLQ5+rDeMZT8GnO+RQK1ylh/MmYwN1sW4W5aRPFs2LLgIeQHyveaaotl7tLS
         BmXxbio+j0gwXmX3Cmwkg8fLZvfwRv2XUKiwUkcPG1q1Rcj48MQptmstU4i6ZtG7EmX+
         WDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682596083; x=1685188083;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=32XQ3+ZCmfjjdoPj6HZo9njH0s8zAKo0k4zwc30Vq4Y=;
        b=cVTDNulVubzcwHquSf0OT5kNLbvypD/oMdGSURKPQJ7JKU+5uC/emn822zUzqPIuwG
         MChVDYrrSHip2vY3H24J0OkSY8JbPe0mDl7Jm1Kh2gnxswAVvb+vjcqRqMSgJN1bGrBb
         LWpvmKmI2MO1+KcXix34XwUH8Y0QBDtBBF4FnRQbHT52XL1gZn565y594j7t3cIJWfrb
         YTCR/3llnwD06Qy9OtK6qpJwi7ZPjXlpAysI6DluWBBRFQ77mYVVZYZnjvMdXVqSLK+o
         d3QTYHw4XfLPwioiAGe2y10MMRpZGgRQPRJJfIov3o+7mxzg1RGSi2teNzV/+0ZAms5S
         fYEQ==
X-Gm-Message-State: AC+VfDznCnFjJi20En1GUcwLe+epfHxY3ezmLDUkIRcrzsN4ps8SagHa
        vGKHj7MhFwO7gwyOsb4Z0al+8g==
X-Google-Smtp-Source: ACHHUZ6tGNesoyyV0rAQZmb0bEnskUF8M6Cb9jqFTQSoziz4jeYmaHVeggyTmZ94dN2M4T13mmoWgg==
X-Received: by 2002:a17:902:da85:b0:1a1:956d:2281 with SMTP id j5-20020a170902da8500b001a1956d2281mr1496781plx.3.1682596083405;
        Thu, 27 Apr 2023 04:48:03 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t23-20020a170902b21700b0019fea4d61c9sm11535058plr.198.2023.04.27.04.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 04:48:03 -0700 (PDT)
Message-ID: <4e368610-30aa-4f2a-202b-d93050ea1f02@kernel.dk>
Date:   Thu, 27 Apr 2023 05:48:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] t/io_uring: fix error handling for setup_ring
Content-Language: en-US
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        ankit.kumar@samsung.com, anuj1072538@gmail.com
References: <CGME20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8@epcas5p3.samsung.com>
 <20230427151004.1146679-1-anuj20.g@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230427151004.1146679-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/27/23 9:10 AM, Anuj Gupta wrote:
> s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
> incase setup_ring fails. This will cause a segmentation fault.
> 
> In case setup_ring fails, bail out by setting finish.

Any reason why we don't just use the return code of submitter_init()
on whether to abort or not?

-- 
Jens Axboe


