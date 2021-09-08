Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8045C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 15:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A594A61104
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 15:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352068AbhIHPBI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352074AbhIHPAe (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 11:00:34 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119E9C0613A3
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 07:59:24 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id u17so2610176ilm.13
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 07:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7OyGriSgSDMcCZh9v0Zi/60PRfo71d2roRkG9zy6aIo=;
        b=zyP7nvs9IW5ZcNCkPR2MW6XOch31H3o9jIVgZDGETBep4fMi2EuwmOVaD4SSCAWpjT
         BrTR+QFOSsSh/LNx0H5tD5+6cSrmO9AOAinO/o/w3HJ9neMUx7t41fKyfgkEsH33fZaH
         qgM7aeRoRq+xnSIohMOKPC+h/aVTQMNd4Q5DNrK6C72XPCSA4CxD4z5ioRqd9GT4DcKm
         h6ib5CAnn3uDDreGYuDK/aCUCjUKLif9bDdXqDBg8wg4f8l77j6n8ODHNrSz6hltnGp8
         QLxOD1+GRbduvuYotphRCZ0H2XWOrW+/39KUNMn6eW4dfMOEEU7QeaiTFm4AWL+ICNxM
         oV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7OyGriSgSDMcCZh9v0Zi/60PRfo71d2roRkG9zy6aIo=;
        b=xzkL0hxeIpliprK4opFIVR2qV9im8e284EJ05A5MmWE9NkC0TbV53M1YaQZ0r76cNW
         ejtBzvto0XDOZn94wfw4eNJqFcPjjtFx6oIDj2eKHESmwKIb7Rbtks0PzFgZCY243yvi
         VLiI8rs3QvjTime83ep5ziGT43cehqc7K8Rj5WV6wHe+z3minLhG1QsmmlYUK1zRXmAI
         h64k7DzKPA+8AukpXx64mW2mbdqPtcsGTwBkVu3qL0RQuh+MUEu1D8Mo5UPdMj2z9rwt
         WvNYuiO8Dqxi4/1D6sLSFHNkfg2+88OftFERZRsVqRr6Ye//v//+TU7oAeGWQ28a8wHU
         xbOQ==
X-Gm-Message-State: AOAM531yuw8CTYH1UnccnC4bg+HaQWIwrNO6wf9NAuhUdZg/MjC5bTZ7
        JfafLCeErsaOPMUSPMvbvB369Aj6a3+g9Q==
X-Google-Smtp-Source: ABdhPJy9YEhEnxLLTsii3I8eNuxOJActlHWVgaG2oV3ic3LkGFe/9PqpiPpx3JihjFIfrEQZC60zew==
X-Received: by 2002:a92:d5d1:: with SMTP id d17mr242448ilq.106.1631113163104;
        Wed, 08 Sep 2021 07:59:23 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c23sm1264153ioi.31.2021.09.08.07.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 07:59:22 -0700 (PDT)
Subject: Re: Future release date
To:     Erwan Velu <e.velu@criteo.com>, fio@vger.kernel.org
References: <5334e390-2a45-7967-f164-b57aef1353f5@criteo.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <611fcb3a-0ca6-5840-b991-5d83a30badea@kernel.dk>
Date:   Wed, 8 Sep 2021 08:59:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5334e390-2a45-7967-f164-b57aef1353f5@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/18/21 4:20 AM, Erwan Velu wrote:
> Hey Jens,
> 
> Any idea when the next release will be tagged ?
> 
> 3.27 was released in May and since we got 60 commits.
> 
> I can't hide my own interest of having a 3.28 with some of my commits in 
> it ;)

I think we should tag on very soon!

-- 
Jens Axboe

