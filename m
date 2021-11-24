Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F26C433F5
	for <fio@archiver.kernel.org>; Wed, 24 Nov 2021 16:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348559AbhKXQ1Y (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Nov 2021 11:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348524AbhKXQ1Y (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Nov 2021 11:27:24 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25376C061714
        for <fio@vger.kernel.org>; Wed, 24 Nov 2021 08:24:14 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f18so8698125lfv.6
        for <fio@vger.kernel.org>; Wed, 24 Nov 2021 08:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fGfzYKSRXlBXdrQYUHVIkQWwdUtoMQJRrklt5mZZ83Q=;
        b=klsONyRu5NfE/y5YVVvsPkFihFjRfE9O6QELqKSb3co0ULpwbMjAXEqrvJBA6iTk2b
         bOFeN32c2W0XLZKOJUjWTwxZujK1j7HxeC27KKnp/Wm9XPfszdeswWrHrfyQ4mubFNLi
         FK8ynBo3RQKvwp42OCWvWakzZ98seVlYNtDq2h9d9QJDP1qIv/ESWkcuI5BuyTyRSmAb
         4kGX8KDRMrmrCO+HJGPMi225SvxFN9ZHD20XQuQz+pAS3AvAWv2CZQ8cy8qJW/JW5FY/
         JpmF3OMi5AbSyKWGAFcPa4thS8GBGRL7BJJSZuFLqljnOz/CXSMnxjNjqWdl9owUTeU9
         54IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fGfzYKSRXlBXdrQYUHVIkQWwdUtoMQJRrklt5mZZ83Q=;
        b=qEyTf/io7mUsKTiT6eB2Ybo0SQWEN+0+2J2fHp3yiwiQ9Q7Ktf0DY3cokO0yxzjVF6
         FkT5j5abJL5kvznn5Ds236nTf5D/FYsHUSMW+4jGPZgR0fqG7gAoSMAzYpiyAT7JnxuL
         lwBSGJoDnvQ8ByXftOlNtibeoeT7GNdtQWrEOd4RS7JodybEawQq+0W78V3z4ql+26u7
         NwIvyHkhTgqAS6ps8gnjb79KUct7fPztEQlyyfZmxrcksQ3CvgVhUtePX69LrXTuCNti
         zL8oKqVjDkzKMAn4+cOqs53nNJ9hZFGKXhj5OrPdk8LYWXtS9HuDX++BGHceWem8xzUr
         3cCQ==
X-Gm-Message-State: AOAM531sjc+GTZm8ahJ5LLceWwQ4oGsB3HtAR1yejgGgJV87AiGPU86/
        u8ZeZ5ASmhrV2Zt/IS9l3BuM6Y4A1ueftQ==
X-Google-Smtp-Source: ABdhPJww8G9o5JVUR3JiHouZzHMpS+gXm20kVwn8fdLdPAUTeFvBXG0d4Vw0iFJSO6MSL0bXtB37dA==
X-Received: by 2002:a05:6512:2286:: with SMTP id f6mr16538291lfu.368.1637771052433;
        Wed, 24 Nov 2021 08:24:12 -0800 (PST)
Received: from [192.168.222.110] ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id i13sm26925lfb.45.2021.11.24.08.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 08:24:12 -0800 (PST)
Message-ID: <d3c7a9ca-af7e-9d70-f229-74558d17cfe2@cloudlinux.com>
Date:   Wed, 24 Nov 2021 19:24:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Using FIO to benchmark Gluster
Content-Language: en-US
To:     Seyed Mohammad Fakhraie <fk.smoh@gmail.com>, fio@vger.kernel.org
References: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
From:   Dmitry Antipov <dantipov@cloudlinux.com>
In-Reply-To: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/24/21 19:01, Seyed Mohammad Fakhraie wrote:

> I am trying to benchmark Gluster with FIO. I am getting the following error:

Please provide full command line and an output of 'gluster volume info'.

Dmitry
