Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55BDC433F5
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbiBHXWK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Feb 2022 18:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiBHXWJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Feb 2022 18:22:09 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DD0C061577
        for <fio@vger.kernel.org>; Tue,  8 Feb 2022 15:22:09 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id 13so294836qkd.13
        for <fio@vger.kernel.org>; Tue, 08 Feb 2022 15:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ANKM1WcldW/k9H6/6gKDWCGw/GagrScHCwvVC5Xfa8=;
        b=J+Mrf5oq3+IzQfnebbcL+f3eiS2eVpeTm5+7aMoeyl0Pk7jeE/6rh9pDUHhUuhYVws
         yFiL5SS2BdqtHPz76i9GG+eaq4v6zAgRFVgJKlWrSpYTGIhpAo3lCxph4S0QqBrTQ6QC
         DID3OZgvc7Koy5Kw6Dx3GyQuoByNn4anZj+bfqnmi0+JdfISje5SaPh2HqHbat587JW7
         iS+J26MHweT/Sa+b2JIdDUuKgUDzyJVB8ZNr+nvj3gyrnW1ILJgetIQbkKtg1bFA9VPJ
         j7NBPVDyNNhvJi5LuommUGtCz0Olc2puuaeO48NfojqZjVBOIXAOXBVRmYYRG/Bvup4h
         MyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ANKM1WcldW/k9H6/6gKDWCGw/GagrScHCwvVC5Xfa8=;
        b=c3pYIVVC4Huz3qKor8sPX4+wQsIESphJR6LvL3YX/TgWthOauBiHmOAQemUFATBaPA
         yMBFpnzLlZEoezyEwbntuwNTjI9Auxextuth0uL55SrwS8RL/BKvmmlRnld5D8h6UqrV
         ae9zup2E49negLqRuY31tOxUuyxSNGYbMSsv8hS+6TK6MN2bjtV0ebXr+FU7GQrxEFD9
         CZxD8S2efXxvQ5F6QjSFhIR9Q/lJ3xWjjdpw7UGCcFnEs3VImvuR0f39PAoZeCduolIY
         fzwdzJt8MrkEgr7qa0RNdb9h1OAfUdIUYLmfcyr27WiL8k1M4G9SP8ErsjIE4jZpWjG1
         70Kw==
X-Gm-Message-State: AOAM532xX4OsPQAGZzGW3LGyq/nNzqzP4ynYuX20IKzA6JU5Y5MPC5Q4
        4Q/dVHTAeysDuk9E+z7TwRpDc538PmHbNeYWgJfIsHsC55ugCg==
X-Google-Smtp-Source: ABdhPJwyrElhJ8V7FEOhzxYwlUf62QLPwZQdqovYmX5nZJ/M2Ts/kyrcQOV4cjfew4UAyG5vlwfkeL/JRD1YuiHj4XQ=
X-Received: by 2002:a05:620a:d94:: with SMTP id q20mr3885918qkl.133.1644362528112;
 Tue, 08 Feb 2022 15:22:08 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVToxJ4e5ad+YESuhD5SMy9js4cwMd8=7xcXFf7rW8a3+ng@mail.gmail.com>
 <YgLOxOwzMOUfmKkF@x1-carbon> <CADqNVTos8PGkv5py42zWR6DXY=97X5kxHANHLe0cRBMQb2c37A@mail.gmail.com>
In-Reply-To: <CADqNVTos8PGkv5py42zWR6DXY=97X5kxHANHLe0cRBMQb2c37A@mail.gmail.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Tue, 8 Feb 2022 17:21:56 -0600
Message-ID: <CADqNVTo6w0-Rs8WBNSdfgzM4K4qrPOh95WdueJpA0vX1cq0GuA@mail.gmail.com>
Subject: Re: Fio docs say io_submit_mode=offload with async IO is not reliable?
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 8, 2022 at 3:20 PM Nick Neumann <nick@pcpartpicker.com> wrote:
> Ah, thank you very much for finding and sharing those. That is very
> helpful. If Jens or Jeff Furlong has any memories of some of the cases
> with io_uring that are problematic, it would be great to know - I
> could include mention of them while updating the howto/man/comment
> Niklas mentioned.

I think I'm hitting one of those problematic cases now trying to run
one of the docs samples, but on windows. That is, this job file
(targeted at a disk device):

[fixed-rate-submit]
size=128m
rw=read
ioengine=windowsaio
iodepth=32
direct=1
# by setting the submit mode to offload, we can guarantee a fixed rate of
# submission regardless of what the device completion rate is.
io_submit_mode=offload
rate_iops=1000

just spins forever, never performing any reads.

Changing ioengine to sync (and deleting direct=1, necessary on
windows) allows the job to run to completion.
