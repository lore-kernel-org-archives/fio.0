Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7703DC761AF
	for <fio@archiver.kernel.org>; Thu, 30 Mar 2023 22:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjC3WCl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Mar 2023 18:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjC3WCk (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Mar 2023 18:02:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5BB5B88
        for <fio@vger.kernel.org>; Thu, 30 Mar 2023 15:02:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so21307394pjz.1
        for <fio@vger.kernel.org>; Thu, 30 Mar 2023 15:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680213759;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nzDvtiXFMv/Op4xE1370C3qAUQfjBr0eePkxVLs3mx0=;
        b=kw6/827XPAcnr+XJ48Ib3KtG+o9h+XvRM6r1MpvQ9OyZcJ4nuXoqzzDo/vwkS6axGM
         1bcuxZP5tAg/cQRPkW+Bb1Jiy20MBhcmyGG7hFRe+uUC8ej8oneUh6dfPvPB/AacE2ir
         BF0xS2B/f7/+G1ans2SqbGOhnK7a44yQb8lB4UIDM6T/u1WDGhnAde3bjFBYFHkLLhmI
         NclkfqEqGtEDzQRi9JPcoxNG3D+Z+KHCSZMK+FYtN5i60gtXFOW+UDBOm1F9QmCRXrVA
         Fi1+6+IVW2+vy9/k6vqsSKO5x7E+FHfQUJ1oPXSBRLxFrROZDfQ4eiofUCTXYkNLVR+x
         aEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680213759;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzDvtiXFMv/Op4xE1370C3qAUQfjBr0eePkxVLs3mx0=;
        b=RSp6it7A5Ipq+elPUTU9ZrVFkctrQBHewJY6apVQ+EGOh7FMyHrFmZn8wCE2H6DcZD
         0nZTMu4geo1UVQ4riheyfnI1PrFbes5UnQ5mBf8XMpE7paCY1hWvG2rzWenOvQ0nCTlX
         qUfuOuXhBEFj7Ke6FvVPiEqz6kNAXacry5N3qHGcpPco/5IlQrHhCWMgWEA0r5NNw/pP
         BOI/D2fxSF15JgCkG0TJgvapKk9KFce8gTNhi3y5WmGnTgVgPLm3xHhKBKla5TY1OxiX
         APz+QG9fVTYzUtwg6CgUs7C2l1cXS2sLcLrMxLNEZCFG6CZDFGVTZPjsh4xhr8HNDpeD
         h6NQ==
X-Gm-Message-State: AAQBX9eYvWQv9V7rPONBimuPuU0T+RZFPDzoQ0t4i02S1J+fc/3QIMFK
        CMLIot2h7SuPkk7duBpGFkeltA==
X-Google-Smtp-Source: AKy350bzwgsjXy+Wj8QC4b5qcaT/Umv6AlBM6848J4CGmTBr6b3j7iNc8PPqfQiSoHjRKBYKvC9bgg==
X-Received: by 2002:a17:902:e54c:b0:1a2:1a52:14b3 with SMTP id n12-20020a170902e54c00b001a21a5214b3mr3858903plf.4.1680213758685;
        Thu, 30 Mar 2023 15:02:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jn22-20020a170903051600b0019a95baaaa6sm174252plb.222.2023.03.30.15.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 15:02:38 -0700 (PDT)
Message-ID: <e8619808-d831-2618-e0ee-84d24100e823@kernel.dk>
Date:   Thu, 30 Mar 2023 16:02:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/2] docs: add noreuse fadvise_hint option
Content-Language: en-US
To:     Yuanchu Xie <yuanchu@google.com>, Vincent Fu <vincentfu@gmail.com>,
        fio@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        "T . J . Alumbaugh" <talumbau@google.com>
References: <20230330212705.2992931-1-yuanchu@google.com>
 <20230330212705.2992931-2-yuanchu@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230330212705.2992931-2-yuanchu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/30/23 3:27 PM, Yuanchu Xie wrote:
> noreuse was added as an fadvise_hint option to apply POSIX_FADV_NOREUSE,
> so we add it to the docs as well.

Can you do the HOWTO as well?

Apart from that oversight, looks fine to me.

-- 
Jens Axboe


