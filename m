Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF665ECAAD3
	for <fio@archiver.kernel.org>; Wed, 31 Aug 2022 17:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiHaRfQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 31 Aug 2022 13:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiHaRfP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Aug 2022 13:35:15 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B617B2CE02
        for <fio@vger.kernel.org>; Wed, 31 Aug 2022 10:35:12 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id j6so11364754qkl.10
        for <fio@vger.kernel.org>; Wed, 31 Aug 2022 10:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=0MBd9kaAwae6D1dCjSUuZEP3bRFanAPp8JeevkvCQk0=;
        b=H7yFaRJW6iEVq2Azi5qmnVvBxNZvJFOIFtyYP6gyoX2nACwIy0ksDS5iMJmiRCl93K
         nqsEyOcc+EgYTU5MHylHfhLfnP1FffrB99un7dIoY15ROFA2Cbp8dXyQ2ivU38itgUWn
         UAg6FaNSDpHgIv4armuD5ZhuILV6BN7oyPq7kRJ+wWGQuCsVBx4/8ngqCilyvYSseVhe
         +Qq7kwBw2Ktmnu+emPhQHNI0W9z/jPnyxRJ4bPeLLntJxdNqjBTccBxnVx64LXt4DFhZ
         pptB//e3ZhWOm21ZCHV059OSymHvUlbuyoMsudyhfp5xskI8BdgYX8avEn56znRJQHhS
         0ZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=0MBd9kaAwae6D1dCjSUuZEP3bRFanAPp8JeevkvCQk0=;
        b=hYWEEjCT9k/QBpco/nHVU5vZugosfcyR+hFk4zsUfl/TRlZV1aVkqaQtnfuxXH7q99
         YAslbNbrl3FPs4VDRPvUuIZRXldfIEnPMPCqH85aKeWUfDcVhUKw5a1LDNCfIYN066Ab
         yJFKJMbiXDK875Mp8fCjDprlMZ9+H+UxwDw9PPDtfqqk+8517X5bQyIlF9ANRiMKSKU7
         axIEr2AmHfr2yLt0is5Lh5maiF1RSiuVAplHeW+eSi1D7zlqs9snBWxU7hrL6ImgxlRM
         vlMdULOtcsyV2PWw0aaquyRDONT+GR9pOxvtSTzS1mD0CcupHu82HmipS/Rc7kgsJN/j
         IcGw==
X-Gm-Message-State: ACgBeo1A/iW82snRzo/mFMe/104xo9Ln69lDjuZl2s+LFyB6KP/p/QJU
        YhbgVXBytBZLV4Q0r1Ttl1R6rJvwcwQ=
X-Google-Smtp-Source: AA6agR6ibIV6TxRos/dXCJACXpqlfdtXojmPaSuPiQ0yMuhsbJzsQrEUwouKlhv5cn3MwPDiRZaoqw==
X-Received: by 2002:a05:620a:1215:b0:6ba:7832:3c94 with SMTP id u21-20020a05620a121500b006ba78323c94mr16374082qkj.496.1661967311691;
        Wed, 31 Aug 2022 10:35:11 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id y6-20020a05620a25c600b006b9c355ed75sm10598512qko.70.2022.08.31.10.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 10:35:10 -0700 (PDT)
Message-ID: <031350fb-b712-6af4-e8fa-5899d79e8373@gmail.com>
Date:   Wed, 31 Aug 2022 13:35:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Blog post with fio tips
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>, gost.dev@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I have a new blog post with a collection of tips for using fio:

https://github.com/vincentkfu/fio-blog/wiki/fio-tips

Feedback is welcome!

Vincent
