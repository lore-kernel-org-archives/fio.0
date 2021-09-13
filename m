Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE956C433EF
	for <fio@archiver.kernel.org>; Mon, 13 Sep 2021 07:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42DE60F6F
	for <fio@archiver.kernel.org>; Mon, 13 Sep 2021 07:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhIMHvs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Sep 2021 03:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbhIMHvs (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Sep 2021 03:51:48 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C7AC061760
        for <fio@vger.kernel.org>; Mon, 13 Sep 2021 00:50:31 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bq5so19156528lfb.9
        for <fio@vger.kernel.org>; Mon, 13 Sep 2021 00:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=24KekrCQlT+qsPs0yDK1Js++SnHhy5LhMNvWGCB9erk=;
        b=G189CGAxerYFqPQCKVYEklhY6adZyQqrKFWrlpXoITxfomJQWQAuAvwubOc2v4mmo4
         Tu+E+uy7GXevEDMeXKA3DMnQ+GOPOZRdueyMsfTQYdWJbBIN6KAIz0r9SSF2TYysxUMs
         oAh8BcXecBzoUqn8YOQ9iI9Drs6IzxDy4l7caRlvRIEhTTjwjCYuNIcnWOm8esqEaicr
         pfLopdllYMLtoo8uwbXLkoPBDEpMq3OprZh2h7OuMaq8a7Ivf95pitrnyOeGQrpyLWe/
         8avgY8ksQhT8vUpBDEU5Z1sciDEWoIl0XDGumxUyWD5Vyv+iJb5YQimGt39++nIbwKVd
         IAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24KekrCQlT+qsPs0yDK1Js++SnHhy5LhMNvWGCB9erk=;
        b=C7CMLR/jCT1rDGbmfQIB9a7dTOQrdStVTXM5Fmu2R0HJSZGIDSTa3acsXUIdLQ+DyA
         9nrOneeTg9Rz1CQtDj4XNodBPafOBFt7nooxi7LprahHvV/cmqScqDtu1/47cuek+Xoc
         8G9GgHIOJFIT45vWCyUxXacxhDCvtSMcd/N49x3ba0NAC20L8MMuWTIgsjWquhKjpiuy
         l3hCblcM/0oEPaMLxKfXFZyj4RK/yxEd882bctYBE17BiTIksbbyhtdRXXqS1nDz5CNs
         2fXrKhIrjL2S96kcmPry9HCwHe5KCwZWkFbYmbXBn19pE+E/X3k6dtKKhW5qw1jlwWAC
         jI+A==
X-Gm-Message-State: AOAM532L1zQyjUojs7nWbgtl82GkUUkwPokYtor7u3/mvw9S6H1nGNg6
        Tq4EZFHFCYKj9QQokOrmtPx4fpCJ/wBbKQ==
X-Google-Smtp-Source: ABdhPJze6i+cYIOadoMBVM/JjiCcX1F5AUz5dF9e0sF29OWAfvOsXT/KH6sOZx2HemK907WBK7/Ftg==
X-Received: by 2002:ac2:4f8f:: with SMTP id z15mr8172336lfs.361.1631519430108;
        Mon, 13 Sep 2021 00:50:30 -0700 (PDT)
Received: from localhost.localdomain ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id br13sm744754lfb.71.2021.09.13.00.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 00:50:29 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <7c937a02-0349-7b17-2bcd-89cf32c0f371@cloudlinux.com>
 <214f8c63-849a-a476-225f-531916239b92@kernel.dk>
From:   Dmitry Antipov <dantipov@cloudlinux.com>
Subject: Re: Weird errors initializing I/O engines
Message-ID: <bcf0a2b5-7ab9-46a5-400d-e7cbae8f64a8@cloudlinux.com>
Date:   Mon, 13 Sep 2021 10:50:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <214f8c63-849a-a476-225f-531916239b92@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/10/21 9:38 PM, Jens Axboe wrote:

> Looks like an artifact of using create_on_open and depends on if the
> engine uses lseek() to set the offset. I'll take a look in a bit,
> for now I'd just recommend not using create_on_open.

Yes, dropping '--create_on_open=3D1' makes this works as expected. IMO a =
bit
of extra confusion was added by reporting 'error=3DInput/output error' be=
cause
-EIO is expected from a failed system call.

Dmitry

