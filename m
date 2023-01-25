Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09610C54E94
	for <fio@archiver.kernel.org>; Wed, 25 Jan 2023 16:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbjAYQig (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 25 Jan 2023 11:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbjAYQif (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Jan 2023 11:38:35 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE3A61A5
        for <fio@vger.kernel.org>; Wed, 25 Jan 2023 08:38:34 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id n190so20308839vsc.11
        for <fio@vger.kernel.org>; Wed, 25 Jan 2023 08:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVj4ojm3n7wqf78jjQ8dmhaDh6EniCKU1W1uO884zeI=;
        b=MHckK+p9P9MG4zVrHw8r55rrZhtYFoaXe1AnX5F11YgRm6yT4iWBvGQtT/gmTBdCWU
         50oLkDtfoj81kRFvax7Ngm4lKTXG1k90W1iJ1JN4LQVZUzFmpqDFoY11MZ+c3oTt1Dh0
         xS+0cLY+zItCGTZ/8/1bbE+Sh6YUU+i5RROfA2aWlREF1y6BFZbdwMSm4QeLTL71bkuM
         KW7xvvgzUYcfntJeDELQwdmoZc86SrW4dMM0UNeYlRrwXjIV+P6edD5Og27WcOviViNq
         ecjflISspXFjkJ52QdJEiWwDN2qLrS8W3OslOF86tddl53d8KGjE3uP+y/7xlemnhe9W
         tATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iVj4ojm3n7wqf78jjQ8dmhaDh6EniCKU1W1uO884zeI=;
        b=KePhNUUHpiabk5WZLADc4N+uGEgb32Nhc4QRbIHc0yO4SDRZqtcMK4jnFASmiiqs9R
         GyG1eldZJKODiNhpOHltrClmEkYdpLXYOtDwmY+dS08ib8LFHC3aYINu2zZ+Lx5g2AsH
         Wt5sC6Fpv9S/PlOJz1ACGD8I/kF1WKiNRlkFmQ1yxxrALhXMUxRztfxGr8jvwY8YJ4ev
         6FBTJfC1i15Quq8sEz4WdthPofntGVDAMc8SRfg2aI9cphGFrXYEzJjWwy5sYruipsjF
         6zitvRqfgOCy/P2IohaIIcEXRuJAhdVTU+Uby24S2e01a028vUFew+SLjty5f0Shy1EK
         sX7A==
X-Gm-Message-State: AFqh2krnAD/eHLsLCMvr5GpiYk6U77wRsM/kngnyNMP3HAwFD+fzgXeK
        SzxlZaMYilDYIQTG9/o9bRHWqKcbzxk=
X-Google-Smtp-Source: AMrXdXsTB+WorR8hhL0BziNgipRsXW1uYaqL+TcM7UyczaAxzV8D7PcB+r3GQBTCsc6GBVJerCk4wg==
X-Received: by 2002:a05:6102:dc9:b0:3d3:d138:2ef6 with SMTP id e9-20020a0561020dc900b003d3d1382ef6mr23222141vst.29.1674664713409;
        Wed, 25 Jan 2023 08:38:33 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id b64-20020a378043000000b00704a9942708sm3761910qkd.73.2023.01.25.08.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 08:38:32 -0800 (PST)
Message-ID: <b7a769fa-ad2f-ef75-9444-f751f498b407@gmail.com>
Date:   Wed, 25 Jan 2023 11:38:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Fio blog post on Erwan Velu's fiograph tool
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc:     gost.dev@samsung.com, a.manzanares@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I am happy to announce that the fio blog has a new post. I provide an 
introduction to the fiograph tool contributed by Erwan Velu. This clever 
script generates diagrams illustrating the main features of fio job 
files. Take a look:

https://github.com/vincentkfu/fio-blog/wiki/fiograph

Feedback is welcome!

Vincent
