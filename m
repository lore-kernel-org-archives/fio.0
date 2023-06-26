Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAEBEB64DC
	for <fio@archiver.kernel.org>; Mon, 26 Jun 2023 08:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFZIAB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjFZIAA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Jun 2023 04:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B3283
        for <fio@vger.kernel.org>; Mon, 26 Jun 2023 00:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75CDC60B4E
        for <fio@vger.kernel.org>; Mon, 26 Jun 2023 07:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A3FC433C0;
        Mon, 26 Jun 2023 07:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687766398;
        bh=pUp8UFwl2gBhRFikuQjaGbx/m4CmoydO69JE9OaooJ0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=lk7d4xdq8CuMwasT0/icvPmO/xNw8+djHVUH3/QGo9fmJw47eO/MvcpA9VEtVVVTs
         K7SJ7e9aBGaRODTMGj3M7Ql8p/418OI3J5c2WvOkPgA+ozcoYajTMyVDWA8sSEqjp3
         MiXaUNKV4pjmZxWtyb7YlbNGasaRW8JKACQfTIEumDe5jw/u6/QEmfi/uZ/ESpoxER
         6C1q5ReEifBaH7ECZnFq1o5AUf5i0/9T2gREnH6ZSuHY7M+j0hyMMRdmd8NMeVVLyQ
         LWIoJDWzSYrWbAAPZiRHoss2rjp3nYolxpVdgNXaQgHgfMlcrJRvPjoYDcT+WpYhZr
         IOxT/p5qW654w==
Message-ID: <fee6a680-ee2d-09f8-64c5-ca0160f87713@kernel.org>
Date:   Mon, 26 Jun 2023 16:59:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Question about the internals of the file IO latency
Content-Language: en-US
To:     richard clark <richard.xnu.clark@gmail.com>, fio@vger.kernel.org
References: <CAJNi4rNuudfMQEQqGN4SbLB72CwpyoAZ05EkmdLAKAY9d2f7vg@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAJNi4rNuudfMQEQqGN4SbLB72CwpyoAZ05EkmdLAKAY9d2f7vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/26/23 06:57, richard clark wrote:
> Does anyone help explain why the latency increases when the size
> changes from 16M to 32M? Thanks!

More metadata to deal with in your file system ?
Without describing in more details what your setup is, it is hard to tell.

-- 
Damien Le Moal
Western Digital Research

