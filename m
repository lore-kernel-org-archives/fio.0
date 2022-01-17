Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5631C433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 14:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiAQOXb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiAQOXa (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 09:23:30 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAB0C061574
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 06:23:30 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id w7so16526503ioj.5
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 06:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bAa8dDCBXsUcs8lth6oGsKoQrFDKuHw6QABr7qdrucc=;
        b=h/rgA9xN75BmkpNNfEm+obqAC14thR4x7rpvWsuxkmteRP809aw9IhDeheuVS9EbcI
         wAqM2PgtJ0J34lI6j6/vuG4bQGnWrhvafwOKh8WkgXSoCTA+villIvETRr9u7zMLLpsI
         nBIE33P5Oh9dhvx08tdc2JCx+n3xRenER6g+oDyVx8ZElpc8zlh9E6CarLt8uXIdh5Bm
         f2syBFp3JOTAUaiGhPw+bTulswpCzgy4NjFqKnskrkbNogKTBdFq1gWKUn9bPV/bxiXT
         uRCgD1xWOqPUBrJNGcuwXfeWWwpgaC+MLmI/+bxnwMfuHrk9y16814g1APg/XfjjmekI
         hKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bAa8dDCBXsUcs8lth6oGsKoQrFDKuHw6QABr7qdrucc=;
        b=qC1dhPE4W25GAqLCJ44EL+DQm2FjWmVV4XdMAv+1jRtmMc5KANwuhJp71Pczq7BOHu
         D6DdIy2bLG7xr5BpyKVzgU3rCoNTFA/GmO0rgCIZXlpzO8KTe8Xp0DzdayJPuCSabw5T
         HxX883PVqbYnb5TJVVroAAucrO8ZCq5d2ZFt3pAWOIZ+IFh5GGaxFuXrJUwr3d/x0Kco
         kiZiLPQCr59jsJdvb814seQf5q8TCBtqGdnPehOkTtqXjgjg+yQBARwVZle3ZqD+Vild
         Pv4IbUYtEHZBUGhnrnjm50ZjMO4oEP/zIYs7sEKKEY6Aa8zB4IOdH9jNWq6w+P2OgA6V
         fedw==
X-Gm-Message-State: AOAM530t6bCQw1CboWeWcl2fw6Wqoy4obScdaTRvLJa4pTMQVOa36poq
        sS11Eor+3hMzae9HS2kbvmRoEA==
X-Google-Smtp-Source: ABdhPJxv6zkFQKnATOT6BjGQ8yVoFj31lc9pMEGZIMVXiyCjE5Khvr+CGKhbv6QYzDa1kkRP3ZRTfQ==
X-Received: by 2002:a6b:f715:: with SMTP id k21mr10181199iog.96.1642429409927;
        Mon, 17 Jan 2022 06:23:29 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y19sm10655019iov.23.2022.01.17.06.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 06:23:29 -0800 (PST)
Subject: Re: [PATCH v2 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
References: <20220117110932.300809-1-Niklas.Cassel@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6aacebfa-9e60-0a67-bc04-73776df07f9f@kernel.dk>
Date:   Mon, 17 Jan 2022 07:23:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220117110932.300809-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/17/22 4:09 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>

[snip]

When sending more than one patch, please use a cover letter. Not
_strictly_ required, but I do prefer to see one as it's a natural place
to put the changelog (v1 -> v2, etc). If that isn't there, I do expect
to see a per-patch changelog in each patch.

-- 
Jens Axboe

