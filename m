Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10521C3F6B0
	for <fio@archiver.kernel.org>; Wed,  3 Aug 2022 15:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbiHCPg2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 3 Aug 2022 11:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiHCPg1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Aug 2022 11:36:27 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017861659D
        for <fio@vger.kernel.org>; Wed,  3 Aug 2022 08:36:25 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c3so13047563qko.1
        for <fio@vger.kernel.org>; Wed, 03 Aug 2022 08:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=76EdPpW8XSdeqa0mtwlpsJW4dsIT6xDJX+4+7JWKaqo=;
        b=UfNw/EQ4TYR/RwS2KGrNCjfkJiTLp9Fx2buRqRd/9X4Xbr3I2R3P4+u4/BLDYWXn7G
         8tHsfKCjecXgzoAPZ5j0ATMBQuPQnus9kZTQVNC7Y0CC9lE773TaptCdw7UOu7Z2H+LW
         LhlPIgA6rG/TNmQm5Fc+KAIoBscxCeuxMooPl8+9ugItvlrQkkHnPEmxGjP4feF4INtC
         xpxBzuzyQgsqvJe/FIU1mrbvkPbmw+s/8Ap7dZ616b8ZD3MItWwvzGt2xn+2uKxA2W3r
         JPKHSsfTRzAiC6XaZtlZVCXvnXG3n7fK/Xp+lKZaGaguZqmeTqLxAEGwbePtofGKquU6
         IfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=76EdPpW8XSdeqa0mtwlpsJW4dsIT6xDJX+4+7JWKaqo=;
        b=KNsv2WU3nIfZe6q/+CFLLXmzF4ETaClivF0csyqSqi7sYTSb5ymekn2BNReren8KH8
         DwJZF7uXsHHMexRQVG3lAJYltJeuSIh0oTqeplYlAPMuSbac8NM3Fb/7Ss6gpHJrfYHJ
         +QBUCQkE7fi510c9vcUUT4vHSuXE1TUcvjd7b/H0P2b9XBgkjAJOcTnMrBf9lCYaINS8
         0k7hxN8/ksPJw7A26M7kBnD6aL89yCJcUm8UytFU63VWo/+ZREB0txbZ2pCSGAULuG8X
         01jiDszEPVOIcRWmOeR4OyHCsjFKJHK3l5rD8nB8kFIdHI9a52ar2hQs4S1V6CvA2TNs
         FZAA==
X-Gm-Message-State: AJIora/woawc0QNKQcarRpGKXFoatGMMdzf8tiHHwGUWCsN+TmQ7gVcn
        2xRDwsrGsTonVTumB6Ae2q0QXETGfFQ=
X-Google-Smtp-Source: AGRyM1sHdSwQytiL+GvXdaaeTlqIBZTAhY2f29joYCyoARG+RHXdpmcF6/6Iuehl33Zjk4URPGlI3Q==
X-Received: by 2002:a05:620a:4142:b0:6b5:d666:cf40 with SMTP id k2-20020a05620a414200b006b5d666cf40mr19397179qko.700.1659540984970;
        Wed, 03 Aug 2022 08:36:24 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id x13-20020a05620a258d00b006b60e1cf2c2sm12562209qko.0.2022.08.03.08.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 08:36:24 -0700 (PDT)
Message-ID: <f0a02d35-4ac2-7e6c-9669-e782acbe593e@gmail.com>
Date:   Wed, 3 Aug 2022 11:36:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] ioengines: merge filecreate, filestat, filedelete
 engines to fileoperations.c
Content-Language: en-US
To:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        fio <fio@vger.kernel.org>
Cc:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
References: <HK0PR04MB2388AF0A140EE14FAF3604BAFD9A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <HK0PR04MB2388AF0A140EE14FAF3604BAFD9A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/1/22 02:57, Friendy.Su@sony.com wrote:
> file operation engines have similar structure, implement them
> in one file.
> 
> Signed-off-by: friendy-su <friendy.su@sony.com>
> ---
<snip>

Hello Friendly, this patch does not build successfully on Linux:

https://github.com/vincentkfu/fio/actions/runs/2790158279

On Windows everything seems to be ok:

https://ci.appveyor.com/project/vincentkfu/fio/builds/44362845

Vincent
