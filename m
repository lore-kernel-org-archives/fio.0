Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236C9C433EF
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 01:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239488AbiDGBd7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242137AbiDGBcG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 21:32:06 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99D71903C6
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 18:26:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s137so957740pgs.5
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 18:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=VYwtCY+WaVVmjSmI7YejJOFzs88g9gSwHN74cOLVHlg=;
        b=V5AEx/XQ4dDJWc949+pYiqv5gjo2qwen2RzyyZHPBEn4R5nVZPALjTTeO6VlodmXer
         yaNICSsJ811jii08JauHdgkqQdY94fvvch4ScePXEBC9CXRQz7TW5PVAb/FDhLw7NBpn
         rZ0dj3VLdZUaicbBs2oKWIzeCf2FYDUS4U+3WuBPANkFaFrom8fxP+r+ilMiSlImThKj
         qjnNxMZGFMUNm4Yg0MY9aku9yOFXHYD34oNlhUwRMawmJBtDu79cRYysePxscRlwLMe6
         +2WUsPjJtVIGUGsijdLwrZ/UhSsliD8S0as/Fk0FsAygQAU/6R27nuX3Geykiq3qvE29
         9MdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VYwtCY+WaVVmjSmI7YejJOFzs88g9gSwHN74cOLVHlg=;
        b=KffwVg0YbZe0lzzEQ6wHsidlA89BM3h+E//ZnF5nL6q1zfBeCsUXgJOHWFnbQu+s/J
         EQGdVBdodqWNpPs/VUVmuoeHBLO8e9Te1eMa/YT1lSdRybT/4i67qg3Y4YWDkUccOHvr
         kTuw/uonJ+M/GFu1SKP062Gj4KrJ6amgUy9X6TmtsiRASeywdhVyrmNwgiEhFVZ58paQ
         tOzJfETIXHREcFNQyuPfcnXZjUPNp0lL9k1u3rM0OxfehCTL3T5Q9RYw8CMxEcCXWMh9
         kPKW3vUNxXPNfb0pmji/Ia93hOCc+v1iUpDpb1B4BQBW9VMbH5dPvVBXAE+5QVeBfXhU
         Ikfw==
X-Gm-Message-State: AOAM53117p5j288agwj/8sCIrjTuVg1dbxX/TEYaZ7fPz+poGn3ofxCX
        7gySXsRIrOixtoUatXDyM5FX7A==
X-Google-Smtp-Source: ABdhPJxW7uApp2Z0yRhWu4cUkjKRkCko/xChP4VINocgwCPUKD867HVkBunDQdnDTkE5N8Zzw7ccng==
X-Received: by 2002:a63:1141:0:b0:39c:b664:c508 with SMTP id 1-20020a631141000000b0039cb664c508mr3393981pgr.49.1649294779304;
        Wed, 06 Apr 2022 18:26:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a7f9500b001c97c6bcaf4sm7032031pjl.39.2022.04.06.18.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 18:26:18 -0700 (PDT)
Message-ID: <0cb84a01-f172-4d54-e90a-598b56dcba31@kernel.dk>
Date:   Wed, 6 Apr 2022 19:26:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/3] iolog: add version 3 with timestamp support
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mohamad Gebai <mogeb@fb.com>, fio@vger.kernel.org
References: <20220406170530.2198263-1-mogeb@fb.com>
 <fb36eee8-923a-f8a1-0a1d-6f4f19bb2772@kernel.dk>
 <0bc4cff5-bc05-a72d-72d1-088df260c761@opensource.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0bc4cff5-bc05-a72d-72d1-088df260c761@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/6/22 6:59 PM, Damien Le Moal wrote:
> On 4/7/22 08:50, Jens Axboe wrote:
>> On 4/6/22 11:05 AM, Mohamad Gebai wrote:
>>> This set of patches introduces version 3 of the iolog replay. This
>>> version adds support for timestamps on both iolog_read and iolog_write.
>>> The 'wait' action is no longer supported with version 3, as the same
>>> behavior can be achieved with timestamps, and it keeps the iolog file
>>> easier to follow. This could also allow to potentially deprecate the
>>> 'wait' action eventially.
>>
>> Not sure if it's just for me, but patch 1 isn't there. I do however see
>> it on the mailing list, so maybe it is just me?
> 
> I did receive it from the list... Junk folder ?

Indeed, it was in there.

> vger seems to have bad days recently. Lots of weird behavior.

Yep vger seems like a shit show these days, it's really messing with my
workflow.

-- 
Jens Axboe

