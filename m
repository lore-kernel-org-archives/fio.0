Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2B9C27C42
	for <fio@archiver.kernel.org>; Wed, 16 Aug 2023 20:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346232AbjHPUqP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 16 Aug 2023 16:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbjHPUpq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Aug 2023 16:45:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DF21BE6
        for <fio@vger.kernel.org>; Wed, 16 Aug 2023 13:45:45 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-523476e868dso9045170a12.3
        for <fio@vger.kernel.org>; Wed, 16 Aug 2023 13:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1692218743; x=1692823543;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AlLYjF1RzIMdE9NMXiRxJRDDXTFzi+LG4EROTp6mEQI=;
        b=qFfqLijyYHk6lActW9NRAF3vaTL2vbOZnWSgm0S7vkY65z5Ji8H2GNc2+ZJlqlrIKx
         erxOeetF35faLnuMXHjEulLZ0BFNIVpChjRZ31TZwNLHm1LUoqKFCHx2fj8E7FyG0oen
         Z7P8nGZAZIVPg3htx3CInAwFzH7uAEi0bxb9iDnNvJOT5GCktJYvxCoRi5QBsTGaqEwq
         WsI27RaCLzGp8+z237cNGY2tg8kZmAo2sXx8D7wc2OPz2O/WzbnvucuevvIO+N6ruf0U
         V18j753c/ewPTb454IetVNs5nGXCm28wh90VmHDKqLGEgH+VMV7LJtxZSzEs2bh/g/eB
         afXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692218743; x=1692823543;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AlLYjF1RzIMdE9NMXiRxJRDDXTFzi+LG4EROTp6mEQI=;
        b=R087tiL3xgj4610TeTY4vw+Zg9i3ct5Lf/oKh/HxlZFfGMpFzWvWDqvgwrOdFgwIBS
         6R10d3t4zzYaTxHKcYvW3C2Qswg/5Wa6u/9BBh+xuELiyuRdg9ZjjKJnR8Weftjuqu2H
         xRkY2Bk/2kjxrXFLA3Uu28960SwDFq3GsrvHcmjzhqzgXx0HPM6SX6Py+18PcM9VdMbT
         TuliWj1aOr6fOMM/+uwXuL/Pqo818jTiIQjieTblPpptmDfoCOe0BxHZOqk5AlAgdZvz
         kmF4hDl2HaQuagtWA6uRr5L7iB6FpiVFyyxY50QdaU3InDbcaNkL68KC4EGs3TBhX2Vh
         3xOw==
X-Gm-Message-State: AOJu0Yw3X4awAaiKQISaSxrd6pmb90GHgDKp/mS49oi8D+YtWoClRks5
        gK1ldKgCAN7hths8+eCc6t2ZTSaKC5LjXknpzR7kq/aoqFSo9uy7RWs=
X-Google-Smtp-Source: AGHT+IFeQECYAJljaky5PLr01n2grRURter38sOWBSFh/TqgA3HK/dinbv+Luw1/O0BaD0jSAWnCZllyGyzfyn5Zue4=
X-Received: by 2002:aa7:cd13:0:b0:523:19f0:b113 with SMTP id
 b19-20020aa7cd13000000b0052319f0b113mr2802561edw.31.1692218743322; Wed, 16
 Aug 2023 13:45:43 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 16 Aug 2023 15:45:31 -0500
Message-ID: <CADqNVTqVUra10ET=P+hPA86iimSs3oC7=eWJNdpWjo5e4p+p1g@mail.gmail.com>
Subject: fio and epoch issues
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I've tried advocating for this via github issues a couple times
(https://github.com/axboe/fio/issues/1544,
https://github.com/axboe/fio/pull/1353/commits) but haven't had much
luck/interest. I thought I'd try here and see if I could get enough
interest to get some improvements to fio timekeeping committed. :-)

The main issue is that by default, fio log files use timestamps based
on an epoch that is the beginning of the job. If you have multiple
jobs, especially with some jobs waiting on other jobs before starting,
this means you have different epochs and the times in the logs for
each job cannot be compared/ordered.

Using log_alternate_epoch solves this problem since with it all logs
share a common epoch, but introduces a different problem of not
knowing the start time for each job relative to the common epoch.

Using the default beginning of job epoch for log files, but also
recording the start time of each job against a common (alternate)
epoch, would solve both problems and bring other minor benefits too.

Any thoughts? Issue 1544 has a 6-month-old PR that implements this.
I'm happy to update, make changes, or approach it differently if
desired.

Thanks,
Nick
