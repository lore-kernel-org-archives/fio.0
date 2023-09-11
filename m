Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB2CCA0ECB
	for <fio@archiver.kernel.org>; Mon, 11 Sep 2023 22:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359182AbjIKWPn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbjIKQ4b (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Sep 2023 12:56:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55914FB
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 09:56:26 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68a4dab8172so1184091b3a.0
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 09:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694451386; x=1695056186; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pzwrvCCJZB1zYs+tHyN4+IjMwUSb0ioFymlBDamkJ28=;
        b=T135L+y2NkgBYoQSY0zX5Vn86yaJqN3uXXdUJb+79d5YvAUcGqbwDySyQkpf1RzuU8
         6Zbw6lA+H+5HvmKqBGjoa/v2foPCdwcL2s2dqiXS3JEvHpKz0EfgJV6OZREnXWU1b1ed
         s4lm0q1hEKNeBBqNh5NvCvJIMhfocshUn4ZdlImLKkET4bUjAl3a9jsbE7c48ii7BR4s
         ADox9IJKvnRM5CEW03idjWZQ0EemnwCNoGW2L/D0rL4AytpqRLBZunyw6qsLKBGN/fT9
         qSzpsarl+eG/ti6djz56c+CgN7mePhNahM+M1j51D/drRErTlQyxv1Pfy/gHy4VsRssR
         RJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694451386; x=1695056186;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pzwrvCCJZB1zYs+tHyN4+IjMwUSb0ioFymlBDamkJ28=;
        b=E/sNSl/Qw1Ah6ZDNKNd+odFjiuq4RS7LsF64BxZd3LtqrEYwWlQzFJBtA/GOYqLMaI
         BBe+1m8zXBCNiWs1AOevOP/WixMyDNa0awg35hOUaOKl/VB1zd6sn+a4Gu4gwiiJXMKY
         qzlK5wy3ZmiQofzbuNeMgsiG7seooVY6GPcXzx9DMhvNbRDoJVR2s7ei960+KmmVUyeq
         97yEwqPl+PnlKSqjhkpJfbUGhzf34D8mUGnerh2vHFaVeQYB8pg1+5BUN0grlHEZby5N
         aaUNeBLko99K5jYBdoALH2q2o/MmnSuRDH0CWfBwGdKWT8jCQCsBgc1FrEppEl8ZXN3m
         edpQ==
X-Gm-Message-State: AOJu0YyKdV5XKXMeZAiYuP15bJ7xIF+lSP7/dgPF+Q0bnjpGQpPDdXOE
        0lPol2dNwRxNrEZX67V72kSte3FloQYfNEqT0LW4IA==
X-Google-Smtp-Source: AGHT+IFDfLtZy7KlGxYyqEs1j5UxxS/PpyGbLzt0F5HTPEG+k8k1RSnV9ookqsc6GAhrgLHa6tfWJQ==
X-Received: by 2002:a05:6a21:a594:b0:13e:1d49:7249 with SMTP id gd20-20020a056a21a59400b0013e1d497249mr14356366pzc.2.1694451385801;
        Mon, 11 Sep 2023 09:56:25 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x5-20020a654145000000b00565e2ad12e5sm5010015pgp.91.2023.09.11.09.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 09:56:25 -0700 (PDT)
Message-ID: <be158fdb-c368-41e4-bbf0-bd1ff4a073e9@kernel.dk>
Date:   Mon, 11 Sep 2023 10:56:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] E2E PI two small fixes for io_uring passthru engine.
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, joshi.k@samsung.com
References: <CGME20230911110620epcas5p20ba906dcc78e21b1936dd37e5b5a1090@epcas5p2.samsung.com>
 <20230911162500.271118-1-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230911162500.271118-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/11/23 10:24 AM, Ankit Kumar wrote:
> 1. The fio verify cannot work when end to end data protection is enabled
> This issue is only when nvme namespace has extended logical blocks, as
> the PI portion of data buffer conflicts with any specified verify
> option. Disallow verify for this case.
> 2. There is no need to fill LBA reference and application tag in the
> command if the relevant bits for PI check is not set.

Applied, thanks.

-- 
Jens Axboe


