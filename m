Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68031C19F2A
	for <fio@archiver.kernel.org>; Thu, 11 Aug 2022 19:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiHKTRX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Aug 2022 15:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKTRW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Aug 2022 15:17:22 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C342AA0630
        for <fio@vger.kernel.org>; Thu, 11 Aug 2022 12:17:21 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id i24so14179983qkg.13
        for <fio@vger.kernel.org>; Thu, 11 Aug 2022 12:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Ub2ZZXXQgWsdtyUfKI6r5HTE7moyMwL3dXtjqsX+gDc=;
        b=DdJrgSitd9/UScRRWcHP07hJQvz52i5NxkxfD3swyQPHn5Np1dqh3oO3P/LoZDyI3M
         gu6DFVopqeGEyj+Tv8i9RygDf5Pk37RdvPi5nRZ/3XoElckWDDvoH9Z7u4j9D2tFqm65
         NZ7iD4AUCDMhyaw1zIg8PnU+hpNY/Y8b7Hyy4fs4cjQVnZNGJxKTO99JT4JK8pwkmxbA
         xEErtys3c4tfm/wa4OqXcoYLb02rY5V2Mvb49TUwAY82afPlA+hmu+GsjOOIvuV/DD7W
         Tal2mhKxNhLFerOqyJH6/INxZaGYVMaJWpXctOV0bRVWhtuhAeIOdlgI35Z7wb2fdRpL
         CT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ub2ZZXXQgWsdtyUfKI6r5HTE7moyMwL3dXtjqsX+gDc=;
        b=G6iPLXNcjy0ZowC9vUoSc33XW/nd7vY7UO7+FxkTx6QQ3i4J97FxUKIq8EQIG88zqz
         g77zxKblFG+yLIA22hEIpZ9h+FO87uIUw1jleuG/uw9YlrtqSHmUeXH58gNVQrmaUj97
         q/UXHVaIzmE8CkxydFrmqlWiBflkS3VOB/i0PSgwrsCrkNpVdEIBCFaV5NUAWP84pdnl
         5GfzjzTSgI+2ZQTCojSqAXQZQWcplA3gggSKO/PRi9x2e8xfduNBrZ8yOILvDAJLo4t7
         XDavWxiTO6yMLAW3MwapjmGP1ST/+2ypdK6SqkbQJgJXJncozGwNJQzt6h5SF+BnbHdD
         WGVA==
X-Gm-Message-State: ACgBeo3Y9lZ6Xi8Y2VR6hbzBJh8D57G/EmBryZs1yQumy/yxkqanSn8k
        TpAUYlJKI3yMW97X5uNT7HB+Eglr4eE=
X-Google-Smtp-Source: AA6agR6rEmqyBElkzbI9VZIWQugjwfaFSAFDM1dWGKLynPsyMdpguLvifQbV6Lb52q4vHt7tb2kEqw==
X-Received: by 2002:a37:dc46:0:b0:6b6:3757:f376 with SMTP id v67-20020a37dc46000000b006b63757f376mr342962qki.543.1660245440663;
        Thu, 11 Aug 2022 12:17:20 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id v19-20020a05620a0f1300b006b9c9b7db8bsm83395qkl.82.2022.08.11.12.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 12:17:20 -0700 (PDT)
Message-ID: <8c384539-3b62-dc1a-d196-da2a2708887f@gmail.com>
Date:   Thu, 11 Aug 2022 15:17:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] ioengines: merge filecreate, filestat, filedelete
 engines to fileoperations.c
Content-Language: en-US
To:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        fio <fio@vger.kernel.org>
Cc:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
References: <HK0PR04MB238816B8DD699406857FDB16FD639@HK0PR04MB2388.apcprd04.prod.outlook.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <HK0PR04MB238816B8DD699406857FDB16FD639@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/8/22 04:35, Friendy.Su@sony.com wrote:
> file operation engines have similar structure, implement them
> in one file.
> 
> Signed-off-by: friendy-su <friendy.su@sony.com>

Applied, thanks.

Vincent
