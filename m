Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0704C77B78
	for <fio@archiver.kernel.org>; Thu,  4 May 2023 15:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjEDPog (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 May 2023 11:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjEDPoc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 May 2023 11:44:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBFC44A1
        for <fio@vger.kernel.org>; Thu,  4 May 2023 08:44:31 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-74d0dbd7c58so28672485a.3
        for <fio@vger.kernel.org>; Thu, 04 May 2023 08:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683215070; x=1685807070;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YviBRXl3+eQqVMfwPLgk7UPVN1I6Ohnk3oX+Chw63y4=;
        b=fnKtqYuwjw5VefLSb4adNqNBhqbBaiKrfKumVJ2/VT/tbB1fZzqEiWGaMAbQf5fDOc
         0xQu+yMcb6CJ433eeHzNs+MnXXIPZpJSsuiEl1o9+l/jm+IAHwcyTcgcfkhXRtsc3W9P
         bzByl9EtK+8XXPrnmq4o5XUmZSiqZsfmFYN3yWElrpQQm6hh6ghHRSuR+r2sRuX7LuYR
         kU1uprCqQm52Rx/qjAGj7uBuQRPN95URvYeHjgGiKVc4D+X2ciU0YY43qO0fyrWKuRAx
         Yl+WKg4QY6qos3+O9B7L85XZDTQSudaUpaygDh/FJVWCjUXTXZVyF8hkO7Jnso+t5CQu
         mEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683215070; x=1685807070;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YviBRXl3+eQqVMfwPLgk7UPVN1I6Ohnk3oX+Chw63y4=;
        b=ZlhmSpfiPqEmLRnWW6cWdCEGDhpJX13CGtoS+LNtpbQF7hv8shbIG6eI4zWjJrEhRH
         D6Pc5pa/KF+7q2WYVLK4yhGIFkpO85hFkMt9iICnoSmtECATa5BO55oW7wXuj6Wn3UVq
         HMVhyYdkRZCJ5un6w8X4EhYKrHVlvp/XK9wpOTVlb90+FBVpt7T17kLST9LD6WdMGoLk
         5pu52UyvIdqtMWQnlm7hTbSg5OyNS6wLpVBOlzcUu1APCVDujHSk+sZlLHLwL+Wkeq5u
         kb7n/quXbq8IlpEQEB7gIM6Ofk/YSDGbiiLuYZYlcaFbC1ulpnT0M33m7HIn8POakskI
         bCTQ==
X-Gm-Message-State: AC+VfDyELzROzcCC2w0DrXew/1liKNz31mMmuXGmRuL2GRDtrjA7yKdy
        9kbPN1NgjM2JFstjbNro8YAN+ZZkw4c=
X-Google-Smtp-Source: ACHHUZ6SIePPnvy2E4/rATXatNbe8i+0eW0OAbZ41ZHOZem5i93aMxFtcaYjpuwW0S0KHNFglDc2vQ==
X-Received: by 2002:a05:6214:21aa:b0:5df:4d3e:b8e0 with SMTP id t10-20020a05621421aa00b005df4d3eb8e0mr16724201qvc.4.1683215069947;
        Thu, 04 May 2023 08:44:29 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id b5-20020a0cf045000000b0061b5d3a61aesm3115278qvl.9.2023.05.04.08.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 08:44:29 -0700 (PDT)
Message-ID: <3a41f856-ecbf-ae80-9222-5260d05a0010@gmail.com>
Date:   Thu, 4 May 2023 11:44:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Fio blog post on periodic performance measurements
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc:     gost.dev@samsung.com, a.manzanares@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I am happy to announce that the fio blog has a new post. I describe 
fio's periodic performance measurements and how they can be used to 
understand how performance levels vary during a job run.

Take a look:

https://github.com/vincentkfu/fio-blog/wiki/Periodic-performance-measurements

Feedback is welcome!

Vincent
