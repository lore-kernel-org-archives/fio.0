Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA23C433EF
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 23:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiDFXwr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 19:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiDFXwq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 19:52:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8155FB8982
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 16:50:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y10so3925957pfa.7
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 16:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=E7UfNDXApZJShCF4XNInc1Ds9t89yjZtolSvK/wkyEI=;
        b=nDbn4VeMf4oXpZBdoIoM2WNFzYHd8KJG/67a0/+HqIbSp3/mMbZpSxAGcRV1hg3Gnd
         lDFsTpAnQa0+okNYcVaOMACpJHRXC89IzWHmLY103/bER3w6B9PEs9psVxlw5I3yhZnU
         Ynv51avAeF8ywuJXDcOC6+wmABHSxkjqoZP4k02Qm/H/ob5GmhR0z+L8+nbPm7bOo9XL
         upg2RAJ3/FC0rzUYgbRZjuKzVCIWBIhfuyqX+hvjtRHu/t+RJqAAITAnwVRYpj/CZodV
         ZKrqkjvF0G/QrpKV7OZ5XPyYA8omR1cznD5IOj7pN6Vga11W4XNDe6J9PNuQnxAOGBFP
         MNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E7UfNDXApZJShCF4XNInc1Ds9t89yjZtolSvK/wkyEI=;
        b=0QRcDCQa7XkaMIG9oAgeqFSsMJ0Y5mQXwInkVm9Ik7QXRYHvZZz2VJEDhybsTmGCkn
         lusgupWq77wwYkN8SIvHDUmS9lfm2Ouq1TIisuOCpngLsBRQgUx9IRRfkn1QAnjwui2W
         MKIvFvidPWdsgscjUHwdUKAu7hLiI2LlAHFNHWjrs4/o6JwxqTSLJuLGMe7O+0LXpZrm
         FHdeluiTFKxVCjPv1Bk4bj4sLoTtGwFkS3KYfZQ/OS6DnNhKyq5XGjCfwsgI1es6EkLH
         Iu1SNqeGmMEk3D+Pi45wEkOglnKHHE5EeoJkSmXluKopjbzG+//M6UllMY/UrAdwhtHs
         GUzw==
X-Gm-Message-State: AOAM533RbnAA5FdsEvzRbJEphGfBpmHOK6ZFkDt21okn6hFTUbNG5Hw8
        zjyWoRkVaURD+X1zGZ32bfvGx3j6TSw5pw==
X-Google-Smtp-Source: ABdhPJwghgaTOeOqEBLnz0vtV3mbou6GNQILWJR3UnE8S7rK8pPSpSgP4YarL9E6LmT6Pl7O4Fai4w==
X-Received: by 2002:a63:5144:0:b0:382:11ef:7962 with SMTP id r4-20020a635144000000b0038211ef7962mr9058453pgl.171.1649289047849;
        Wed, 06 Apr 2022 16:50:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm20425291pfj.43.2022.04.06.16.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:50:47 -0700 (PDT)
Message-ID: <fb36eee8-923a-f8a1-0a1d-6f4f19bb2772@kernel.dk>
Date:   Wed, 6 Apr 2022 17:50:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/3] iolog: add version 3 with timestamp support
Content-Language: en-US
To:     Mohamad Gebai <mogeb@fb.com>, fio@vger.kernel.org
References: <20220406170530.2198263-1-mogeb@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220406170530.2198263-1-mogeb@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/6/22 11:05 AM, Mohamad Gebai wrote:
> This set of patches introduces version 3 of the iolog replay. This
> version adds support for timestamps on both iolog_read and iolog_write.
> The 'wait' action is no longer supported with version 3, as the same
> behavior can be achieved with timestamps, and it keeps the iolog file
> easier to follow. This could also allow to potentially deprecate the
> 'wait' action eventially.

Not sure if it's just for me, but patch 1 isn't there. I do however see
it on the mailing list, so maybe it is just me?

-- 
Jens Axboe

