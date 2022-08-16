Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2760C25B0E
	for <fio@archiver.kernel.org>; Tue, 16 Aug 2022 12:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiHPMTt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 Aug 2022 08:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbiHPMTY (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Aug 2022 08:19:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07563639B
        for <fio@vger.kernel.org>; Tue, 16 Aug 2022 05:18:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 130so8926667pfy.6
        for <fio@vger.kernel.org>; Tue, 16 Aug 2022 05:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=XRvUGmWHzK57igIJ55bOYOnVtQS4/42Fj71Tkl6OtNE=;
        b=1I/zbeiNdfLxTvpV/3QjfXzuRpu0Z/JoFYilO2hHPQSgaF2RlcWcL//+29SrWFqWwg
         lgrH1WBS/ABELCq5EmrlcDOh63RZx0iynqOSINNG4o0Vli8DRZ0YIoPvQPPTF87EDSkR
         uax1whMXRiql2/AwQCqOsG0bzoIKG1GRS3c9pNzcqCD+4aMDsRknjuWlgxUk5FQNXEk9
         ZHq8FMuYmrLxSaHFqjHPRk2qDmIkt/uziSISZ2JB1J9e5Rsd66nyGQkS6k+7XiF1MR8q
         uYSW+pdY5+s7K2VKsQPKtHNdn5WygoAX53WDPDBdedU8cZmuI/u7clg+k41G1KRAg8Fj
         uu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=XRvUGmWHzK57igIJ55bOYOnVtQS4/42Fj71Tkl6OtNE=;
        b=zKECjqkwBpoUOeXucKR1A5xIvp7VWM8fGG+hrEyUF1VVNyEGs4Dar4H8ZtSYqAVz5C
         fhpOA7pHlRwDntQbjWUCzXyv0osw1JDJyus653PPbKRBJ176TYVD9dCEOKDum4HmYRLs
         OAda/lkMKRS5bso0OxCZNxlZLO2b5YmYG+d/1tIRVo5SkBn/l0yL9uTJ3Dyg77nBUWgf
         OVHC7JvaMS4fo3nK5t2KfAjzkLZPyBQQurfwvxuzzkNrpcBtjZJY2RikO8JpaokODdkD
         fsILozOfHMhWIBd48M+6yiuieq2uT+AbDqjZkjW5yY6p2sRNnFYD41ATTITaVE/2X30f
         Ec9w==
X-Gm-Message-State: ACgBeo3eqsbkkEkZqt53II44eICPESIlC9LWzX3KRT4WW2iOkrdnozu1
        PnaDhaHz9Hgy0PhvnvbbnQfp/OzJi6LwKw==
X-Google-Smtp-Source: AA6agR66fbJPKVRVBCEGnz/r5VMZ4KEl4ug65U88zevFbkRvOpZKbh8BRIhZ11Q2xgGUD0tdTM/6xA==
X-Received: by 2002:a63:fe41:0:b0:41d:8ca6:a6ab with SMTP id x1-20020a63fe41000000b0041d8ca6a6abmr17316139pgj.442.1660652336154;
        Tue, 16 Aug 2022 05:18:56 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 200-20020a6216d1000000b005289fad1bbesm8567407pfw.94.2022.08.16.05.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 05:18:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ankit.kumar@samsung.com
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
In-Reply-To: <20220816053821.440-1-ankit.kumar@samsung.com>
References: <CGME20220816054808epcas5p2295e7b76603cdd2183f9e2c2698cd90a@epcas5p2.samsung.com> <20220816053821.440-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH 0/2] *** Two small patches for xnvme I/O engine ***
Message-Id: <166065233440.196298.18131613774596107241.b4-ty@kernel.dk>
Date:   Tue, 16 Aug 2022 06:18:54 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 16 Aug 2022 11:08:19 +0530, Ankit Kumar wrote:
> Fix segmentation fault issue if thread=1 is not specified.
> Update the fio documentation.
> 
> Ankit Kumar (2):
>   engines/xnvme: fix segfault issue with xnvme ioengine
>   doc: update fio doc for xnvme engine
> 
> [...]

Applied, thanks!

[1/2] engines/xnvme: fix segfault issue with xnvme ioengine
      commit: fdac9c68425a7bd4008614476a27e536b0b0bf8b
[2/2] doc: update fio doc for xnvme engine
      commit: 4deb92f9e1a83682143661eb3b04422bdfff5ace

Best regards,
-- 
Jens Axboe


