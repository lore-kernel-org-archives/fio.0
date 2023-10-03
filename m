Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531D2E7545C
	for <fio@archiver.kernel.org>; Tue,  3 Oct 2023 18:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjJCS3l (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 3 Oct 2023 14:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjJCS3k (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Oct 2023 14:29:40 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1483083
        for <fio@vger.kernel.org>; Tue,  3 Oct 2023 11:29:38 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-49d8dd34f7bso551727e0c.3
        for <fio@vger.kernel.org>; Tue, 03 Oct 2023 11:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696357777; x=1696962577; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLbFzejwjkoJLGHdFG8IRyIxaQFwHuPpvRIJGNQnOQc=;
        b=itOyRjtIE9lFCtwoKY5SY8QfI1CQ6Nn2PWCn++i/SGc2NZwjuc5M087Oplgf1xXKCc
         1KKgiWnNQ/mGR1wPkJjStZ+71vxoGbRirRoeCAW8xSPv8DbnctRM6Udox7Po+bkhtccl
         G43Qh3GiqFICwSWV3QXpDK/jRY9nsEd6LXRcPfU1wpa7owL1s9N8L+y8C2AplUgLNmQ3
         Jlv1AA6iwSixu8TWnrd41MAb3oiQKL3akIHzXeo4MkNu4hqQVWbfEZ16bGWENb/6W9wt
         Zu1zwTtAlXlMvBtkNiFln+FPSdwwyNZRUSMY+EpoApaV39tHfyKH0PIH4V4Hvk+adtWp
         OJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696357777; x=1696962577;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tLbFzejwjkoJLGHdFG8IRyIxaQFwHuPpvRIJGNQnOQc=;
        b=aQZ79nLXta6kT3TpQ1o3+BejG3IdTPwqQsdPxeaDr1Gk6r9ARUV5tkRGshbmWmREzx
         u4lPkV8dxh0nDYRG+3oXUFZxP5sHMxVQtQVpOcDePSULPoWc2XqOeyFHA9JVGHIl2juB
         rezZ5wcEz4GAlTgrI8rX6+cLFpdnvQFhgqCOyuthzh16bqDlRp3Ti9GCblbYtxrvf0nV
         l7zU+fyHz+0uiCyWeUu/pmzKmQbVldDn7brsew/8KJUxNbzI70Nub5dPAqYKCFuts09e
         Yldve2WyGr1bLn4B8uSHjg1rk8xRmbMicEDB0hydA9ppxp0ZeENTCcuiRo3QIDtLccJe
         ++gQ==
X-Gm-Message-State: AOJu0YxG16UIFQtVOWbkn9Vfs0dPXP1ENLaI71i5AztlZ5JvaB7IN6cf
        iLB7SLQ8d/0eEvLNcevcNFeeZDTROrWqIQ==
X-Google-Smtp-Source: AGHT+IFFw6xbpQ3Gp5ddB704bplIZ1ZeIgl5JC6/3Xpc6VfbVSRHTRHss0U/YfHpHWGBPOsvlSLIzA==
X-Received: by 2002:a1f:4843:0:b0:496:248e:43fc with SMTP id v64-20020a1f4843000000b00496248e43fcmr100973vka.8.1696357776617;
        Tue, 03 Oct 2023 11:29:36 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id br7-20020a05622a1e0700b004181c32dcc3sm639693qtb.16.2023.10.03.11.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 11:29:36 -0700 (PDT)
Message-ID: <6ce6c3ad-8a95-6bd0-7083-09585646af64@gmail.com>
Date:   Tue, 3 Oct 2023 14:29:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Blog post on protection information for NVMe devices part 2
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, a.manzanares@samsung.com,
        krish.reddy@samsung.com, k.jensen@samsung.com, rstenfort@meta.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Ankit Kumar and I are back again with part 2 of our blog post series 
describing protection information for NVMe devices. This one discusses 
using fio to exercise these capabilities. Take a look:

https://github.com/vincentkfu/fio-blog/wiki/Fio-end-to-end-data-protection-part-2-fio-support

Comments, corrections, etc are welcome!

Vincent
