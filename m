Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8FFC433F5
	for <fio@archiver.kernel.org>; Wed,  2 Mar 2022 19:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbiCBTmq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Mar 2022 14:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiCBTmp (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Mar 2022 14:42:45 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A431CC7D47
        for <fio@vger.kernel.org>; Wed,  2 Mar 2022 11:41:59 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id w1so2656811qtj.2
        for <fio@vger.kernel.org>; Wed, 02 Mar 2022 11:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZBt+RR3icIY8VgnJ0gn5z0k5fA2ifDcbjGCDSs5i140=;
        b=FPgTr2/efNkVOIK0EW3hM2/aorjPZlwkZw/gU+SoUhcURm40IVI1Civ2l9oTfRyRsI
         XwEPvyItSIbhx23dwmw7uvN1eUZkc63+X6nzyFavIAzN/cq6+c6JLEkCSzAWKS/mZRTR
         RI/vMv4+psm97SHcGO6acp+e/NNkRMIDiyQXtvvIcFyqEXM1qtpmLLSdUFNYscZZulXj
         X/RRxMo67QrUoIhPfdr//tlxBw65lJYkA0yl3+yMvb4kiE2KyrOqporpF61qb/wwQn9S
         V9S4w2WwQFpQzQjw+4nMwglJ0mwhDJQAxs4FMIt6BPSiKM0NztB0TM+XIhOaoDVw94rS
         KNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZBt+RR3icIY8VgnJ0gn5z0k5fA2ifDcbjGCDSs5i140=;
        b=eKa6w+QazkVZmHiPLsSfVvCNSTaRvIKgCEkfu4IknaK9BQZzIRKYxqEkPeY+bTwdLT
         l2N9ylA/Agj7/ERsuewL4JbHZabGqKYAadT+ahoLGkIIQaRYjKTDgTYIJ0Gtz5vm0+J2
         3oXQMVbrIRLSjBsLFJ9H9m1HPOjYTsPRLgIgkSbPLUxrqQNuERDArqBCjor05NRooRDB
         npAE+aO6exjK5+8kal0RDpB0Ng0O/HA3nKmMqQj723kD8K1EmT9mjagFU3KIeD3XVJDN
         yT8xBiNH+FVQJtdfzoCjeqze14664wnq8YR2S/1xHfHoCSP6CqLnQtn+ujvrPSKdH0GC
         WzkA==
X-Gm-Message-State: AOAM530MVpXk709jTLhWncQSD7i71kKJYBVuBzOzP+AI1rCgnb9PT18l
        2OhiUOf3bzEuSqsO6v5Gf+P7ItFoA7VQ/PW0dfnPzAZ9BLs=
X-Google-Smtp-Source: ABdhPJy1rXt0mtu0rdeF8t9pAHhLxJlCfu8IRi9yrxQhVOnfkghrk9RRAMvoWuo9YB1WDAbSjoI8okJhUYZUN5Kb6es=
X-Received: by 2002:a05:622a:4c7:b0:2dd:92df:ece0 with SMTP id
 q7-20020a05622a04c700b002dd92dfece0mr25316755qtx.450.1646250118725; Wed, 02
 Mar 2022 11:41:58 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220224200742uscas1p144ff2f87331ec864d2aaac92459b0c44@uscas1p1.samsung.com>
 <CADqNVTqmWV8MiFZ6x8N4u8Poefxb9jRbpLkH03w7VPoFzEixUQ@mail.gmail.com> <dd8cee13d295483e9be4e1a375823a3a@samsung.com>
In-Reply-To: <dd8cee13d295483e9be4e1a375823a3a@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 2 Mar 2022 13:41:46 -0600
Message-ID: <CADqNVTqz-458F0T8dpFq=0R1eGnaCmYWgyf+eURhYhX2pVz8sw@mail.gmail.com>
Subject: Re: Not logging zero entry intervals when using --log_avg_msec seems problematic
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Mar 2, 2022 at 12:20 PM Vincent Fu <vincent.fu@samsung.com> wrote:
> stat.c:__add_samples() is where log entries are added. It contains a cont=
inue statement which skips entries during log intervals with no IO. I would=
 start poking around there if you want log entries for those intervals. Per=
haps make the new behavior an option for those that depend on the current b=
ehavior.

Thanks for the pointer. We could do an option, but honestly, not
having those 0 entries can be really misleading. The end user of fio
wanting to see how a disk performs over time is likely just specifying
log_interval_ms and then graphing the results. As the example I
provided shows, if zero entries are happening between non-zero entries
but are omitted, graphs/conclusions made from those logs are likely
wrong. (In my extreme example, the graphs made from those logs would
be *extremely* wrong.)

The bandwidth/iops log stuff has other quirks too, some of which I've
posted about in other mailings to this list. The code for
bandwidth/iops logging leverages the live statistics code, while the
code for latency logging is distinct. As such, bw/iops logs have the
following quirks, but latency logs do not:
1) Data after the last full interval is omitted (e.g. if you use 300ms
interval and your job takes 5 seconds, the last 200 ms is not in the
logs). This really surprised me and I don't think an end-user would
expect this. It never happens with latency logs.
2) Log intervals are not consistently sized - the code aims to hit the
specified log_interval_ms, but you often end up with intervals that
are bigger/smaller. (This can happen with latency logs, but is much
rarer - only when operations are not happening at a normal rate.)

Further, the latency logs also do not have zero-entry intervals, but
that is not really concerning - for latency, an interval is reporting
average latency per operation, and if there are no operations in an
interval, that is ill-defined.

Thanks,
Nick
