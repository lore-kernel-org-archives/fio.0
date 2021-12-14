Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDBDC433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 13:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhLNNsw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 08:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhLNNsw (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 08:48:52 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4885EC061574
        for <fio@vger.kernel.org>; Tue, 14 Dec 2021 05:48:52 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id a11so17533297ilj.6
        for <fio@vger.kernel.org>; Tue, 14 Dec 2021 05:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=O44UucYZJ4pXdRM29JsN/iPrRfbFKqd9RbSihVI3Spc=;
        b=6+SFV5rGkgEBUJQrlzzZfBoMz4ZxhHY7QPrJNfOOt/qp/WADwxoIMn7X1gGYqHc1ff
         b41DQQnS/Lv86jc2Vg/in5TZE/znhgy8a+zdC+evhnBql0MZNAddnoLF39hJK8O1aOIq
         pqypETONvDvsNwggwebcDdC8/JSYordvYjpkwrxhguKAIsybrl6FhwvueQ2LcJDIQYwo
         Lnrmyq0qleCTCbp8e6Y0MDMCN0NgocDfTNIBSF5CVv3jPZ6yT/UGvpkg33WHq3vqyuxp
         vcBNnnTjXsx0Ke6cQO/8GZZnDGeBMuhR2viDsJWtR83fJmi4AIAselGW9dlnxH8MJJU3
         +eKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=O44UucYZJ4pXdRM29JsN/iPrRfbFKqd9RbSihVI3Spc=;
        b=GVCMEXtByS49S+gBeUpa3Eua0MOqs6rpxNbIfskEALjN7AlhVoqqNRg0Nzz6sbG4m7
         ZJs8Z5MRxwvAjGMUuNxa/nW59c4VBtdHTjT0994WQbv9w917C1kbv4g10btwx533tnTV
         0q942kw37taVT2BN0cbP7BkALneb5rkMaZNTJnl11+1PARYm3k15khNW/OQteKXQABKp
         wwkWFGEBZZ/9oe6MlTAQbo/7C6bHopMzmZW3vRCfXPGWkzAunG2rYijl4HSyn7pP1IxC
         HYdjLtmUvLgE7O9QOcblhYdhyzgLUP8SEFSQJ3PYJgGm8JF7ZRPs28zSFbZ0PkXIqf1g
         kGnA==
X-Gm-Message-State: AOAM532YzxbHA2RxwkG4TM+md/RgITI0qNcAJUSv9SDtNwlzlFzlSXEa
        CI3/3wyJjEitZNs1k4cn/oE7AvRozEHqTg==
X-Google-Smtp-Source: ABdhPJx9QM95mUNJFc6C2mK1X8iUPGVC1UOAane8nZNvB5Wh2YlbLN1i2Y8AGf4NA7shRO/Y2gaeAQ==
X-Received: by 2002:a05:6e02:1986:: with SMTP id g6mr3219608ilf.135.1639489731497;
        Tue, 14 Dec 2021 05:48:51 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o7sm8765463ilt.19.2021.12.14.05.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 05:48:51 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        fio@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 00/12] Cleanup zbd code
Message-Id: <163948972941.172789.15225072509405725163.b4-ty@kernel.dk>
Date:   Tue, 14 Dec 2021 06:48:49 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 14 Dec 2021 10:24:01 +0900, Damien Le Moal wrote:
> The patch series cleans up zbd.c code, improving code readability.
> Patches 1 to 11 do not introduce any functional change. Patch 12 fixes
> a problem with the zbd test script.
> 
> Changes from v1:
> * Renamed zbd_verify_file_sizes() to zbd_zone_align_file_sizes() in
>   patch 5
> * Change function names as suggested by Niklas in patches 10 and 11
> * Added Niklas Reviewed-by tag
> * Added patch 12
> 
> [...]

Applied, thanks!

[01/12] fio: Improve documentation of ignore_zone_limits option
        commit: 12324d569861b83fb76e874122ddfcf28ee8d485
[02/12] zbd: define local functions as static
        commit: 38334c1347e624237118d08f467aff35a8fcafe6
[03/12] zbd: move and cleanup code
        commit: 410a071c59d7992968af7073bf39546df18542ff
[04/12] zbd: remove is_zone_open() helper
        commit: b5a0f7ce303d5fa5cca51af0652b7f7cf9bc5d61
[05/12] zbd: introduce zbd_zone_align_file_sizes() helper
        commit: 0bf93a1a7ed700b24177edb6db6c4c42e93ca7b2
[06/12] zbd: fix code style issues
        commit: 139d8dc666e5e4a05eaa9f5e603fc3453c5fe43f
[07/12] zbd: simplify zbd_close_zone()
        commit: a23411bb2e1c7de1e97c505ca2ec7270a35f7be1
[08/12] zbd: simplify zbd_open_zone()
        commit: aad7c276b01304d3fa128c84dc885eb557944b29
[09/12] zbd: rename zbd_zone_idx() and zbd_zone_nr()
        commit: dc8a3d629310d1ac9143d62c9f37ff16331737d5
[10/12] zbd: rename get_zone()
        commit: 39e06ee779cae55cb7d02eb11a5f12ca7f21a337
[11/12] zbd: introduce zbd_offset_to_zone() helper
        commit: 53aa61719b906bdf8e058c94ca93e537b90806b1
[12/12] t/zbd: Avoid inappropriate blkzone command call in zone_cap_bs
        commit: 9ffe433d729101a34d9709030d7d4dd2444347ef

Best regards,
-- 
Jens Axboe


