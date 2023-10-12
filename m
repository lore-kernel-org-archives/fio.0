Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAA4C41513
	for <fio@archiver.kernel.org>; Thu, 12 Oct 2023 16:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347302AbjJLQFS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 Oct 2023 12:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbjJLQFD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Oct 2023 12:05:03 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B27E3
        for <fio@vger.kernel.org>; Thu, 12 Oct 2023 09:05:02 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2c501bd6ff1so3260161fa.3
        for <fio@vger.kernel.org>; Thu, 12 Oct 2023 09:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697126700; x=1697731500; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V48q4qcFa3hVTC7SGKaGy4kdQ2B8fy6fgLUNyLNJVw8=;
        b=Gw3LKK+aneqT6Mkb9dBvDjTDPQN7nW2tDLlmVkoeGSh7inSI8l7YlaJsule+WTwH6e
         4pSMo9SZ4fly1q5TTbmBRU8xHrIyfeTqsKB28cm8gDvFVxMDwAnAopLOp97Jgrs/OUmF
         nLoOT5dkrwZklVAeW4nVAKRaNnmb3yORByZVMdAB3ZsNAomlBxUC4eEs+6MlCFrfRE09
         JvEcz/+M2NbbTHjYw8CchEVC2sHd8NXNFt2Ms7CIxl/36na7KyMXooXW/+Ru4YUUuCZU
         5RFV9/UZedSo1ONHTRHYRRi+d9xdqG2Y/cSc7GcWyCmlDf4r0Zl15Uf9NqK0yL5M3VCJ
         RIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697126700; x=1697731500;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V48q4qcFa3hVTC7SGKaGy4kdQ2B8fy6fgLUNyLNJVw8=;
        b=OdO18C5nvNBHkPd+opjAorRHIEUbnWE06t/w920+piVqFDg2ISlOFx4jqNUGEiQ9Ah
         JxMS1UvX7rHys8NjA3BVN8/+VDxmq0DFlYuqGh90+W4y1FTZC6sZ8GdoBxmu0lQ7fHUl
         +k16E966ty0bfvbVwhN4GR3BYXLZtMuYB9wJLg/KYv+iCXpPE0lxv0d2roYqVb4SSliQ
         N69EWiUB0yJWkL0oqvyR9I8kcBCLgi0m8YgtMxDBdH9BiK0Fhr5CNfPv6qPgGjwol1js
         WDOFY9De1sudajKXOyXW7hQnxsn3CMFqrJXU7kDc8eb+FySkk3RTlO0nY84ULfYcOZ17
         nNKg==
X-Gm-Message-State: AOJu0YwDB2NfItPzpQqPavO7BEP3doPBNYiizk0dxDIeUSXdlJD3r3mH
        68Bj01EX6JkeIKNr3mKVpDxAQmFATvImVEUB7TpB058Pi8a57/8pscHhaQ==
X-Google-Smtp-Source: AGHT+IHdIYUNDytsR32V1HGQQCAuWPlC6aDCgh+nom8wsKJZ4Bj1kV2Yh7TUuJgBn2FqYnQYum6V7QOg8kA9qgEYZHs=
X-Received: by 2002:a2e:9e53:0:b0:2bf:fa62:5d0e with SMTP id
 g19-20020a2e9e53000000b002bffa625d0emr21333698ljk.2.1697126700004; Thu, 12
 Oct 2023 09:05:00 -0700 (PDT)
MIME-Version: 1.0
From:   Willy Yang <wyyang@google.com>
Date:   Fri, 13 Oct 2023 00:04:49 +0800
Message-ID: <CALcbBwmxhjzU+E-o9q64UaYnhyPTDgaEEcMBGX5_5MCRvb8D5g@mail.gmail.com>
Subject: The release plan of next version
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi fio maintainers,

As for the title, could you share some information about when the next
version will be published?


Best Regards,
Willy Yang
