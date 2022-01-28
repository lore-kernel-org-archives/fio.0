Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA834C433EF
	for <fio@archiver.kernel.org>; Fri, 28 Jan 2022 17:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbiA1RLa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jan 2022 12:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350473AbiA1RL3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jan 2022 12:11:29 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF57C061747
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 09:11:28 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id e16so5708092qtq.6
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 09:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2S+GGQ1S8no9ArdFCoKIjyPxDXx7S4IpW6WcBC4ycs=;
        b=LW2255qARapkUQWq+pdcq8xlxqf0n1X0FacddKhmAWczbSnjhUhbh2X44TDPX36SII
         eVQJkrHNSBci9OfB4ngLedfZBeqR+AeLpLadqqunEIM9pk2s0mW+PfDOY5vYcrpZMsCl
         1hXoapIGP9ERAfUqONXlGRLtJ3CDZPJobmOZLORcQP9Cxqz9Zf/qj7jdVepp3Us9a1zF
         xWfW7HoJvCmnRX2TzI+gWufsJnmHLR9pT7BTqU3NwE5pbZ+pzvdWycgxVu4uiPmXuOQd
         4hMcslhqTEdzb90lHHVeKiRJw78N9KPfCaTrWg9QGb6pp9A809dmopUI1ts2z4zlwW1Q
         uAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2S+GGQ1S8no9ArdFCoKIjyPxDXx7S4IpW6WcBC4ycs=;
        b=M7t7Ot9HyeVh0NcCWL4aUI738LRA0zk82sm+kCD/MpskJzy1ItFUHesj8kTCe8QuKW
         Z3hy43KukBRzq9fnZ+wbIiGExf4fSgamOIi+BuMM10ufZeWfrgaYokvWRQQAMJsv+KNr
         pPdAMend/xekXCoz460BhyDXbXXYYZMup1xGYbO7iMUvKXV+m6hSNw614lrzp0bC/qBv
         1n+uiuNjB2msuNNF7PFwYEbyWUdpAfRGZyUElhyc9+GwiCpb0M/fiWlyDaSP/BgSPXG3
         Dop9lZM9EccJ4RZrwBKSF0dRrx7XI4yBH0z0innX1a/9nq/b6wlYUwtd2xmSHyxK5yXG
         5CJA==
X-Gm-Message-State: AOAM533zxdzHyYvHOT82vHddMhhrmPqeT8CLs63AI2gETVQu/y83Se1h
        y4ZDR+lyh0Xa47AmPZseMvuzlPwISXDdKumlYouSFf7hujA=
X-Google-Smtp-Source: ABdhPJxAXNQNku0Z0gBA232lUTc6ot9KaeQ/vQmkmFsWVN+S22R9wnQSiBo4XfeDcO3Aa1NpiFNmBNO0up2HLPvjpkM=
X-Received: by 2002:ac8:578e:: with SMTP id v14mr6894315qta.345.1643389888088;
 Fri, 28 Jan 2022 09:11:28 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
 <5f2cbacd-16dc-bc98-3bcb-24a24f160476@criteo.com>
In-Reply-To: <5f2cbacd-16dc-bc98-3bcb-24a24f160476@criteo.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Fri, 28 Jan 2022 11:11:16 -0600
Message-ID: <CADqNVTpO8MeB0A_Xa_rTkCXmYNr-nKAq8kcW6pbMXjxy0T0igA@mail.gmail.com>
Subject: Re: A fio job that just waits?
To:     Erwan Velu <e.velu@criteo.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jan 27, 2022 at 8:03 AM Erwan Velu <e.velu@criteo.com> wrote:
> I've been adding an exec engine in fio that could be used to do any kind
> of behavior.
>
> There is an example where I wanted to perform explicit sleeps between
> jobs to cool down the server :
> https://github.com/axboe/fio/blob/master/examples/exec.fio
>
> You may try something like that
> https://github.com/axboe/fio/tree/master/tools/fiograph can help you
> graphing how jobs are interlaced.
>
> If you look at
> https://github.com/axboe/fio/blob/master/examples/exec.png, it gives a
> visual representation of the sleep action in this example.

Oooh, that looks really nice, and so flexible too. I will definitely
give it a try. On linux I'm running ubuntu 20 so it's an older version
of fio by default, but I can definitely deal with that. I'm also
running fio on windows too though, so unfortunatley it doesn't help
there yet.

Thanks very much for pointing me to this.
