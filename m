Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878E3CD37B0
	for <fio@archiver.kernel.org>; Mon, 18 Sep 2023 16:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjIRQy4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjIRQyz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2023 12:54:55 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405AB83
        for <fio@vger.kernel.org>; Mon, 18 Sep 2023 09:54:49 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-7870821d9a1so2984293241.1
        for <fio@vger.kernel.org>; Mon, 18 Sep 2023 09:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695056088; x=1695660888; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qoTIddLe8NYoucfQJEYmqim99Qxv29RyzC8D0x4Di78=;
        b=IGDF5drNn2eqMkEVzS6T4DEzph4JYcXOQveqP9r9VnnrXtzKCxrOjbL79lgE+eeMIO
         fi/2gL2uKCan5VHf5byPiUdKcFYA0CmCUSVnO7qzSW8LzxjI+IB7XJtSsEhkoEI3WFPL
         SHxq3qzxav1OZ1VAlo36TZsvPQda7NT8Ou5zjD774DLRLGhZLnRWMJJgg1eZLjvOTnLM
         0Ew9S8DL0OSSvXSUjSAnGBSLjD135wLIEiLE7wU2+iZf86vwTYXNtAlaHaTckcN1lk0Q
         yWO+EHmcC94usbBnzbuPFwer3NPtIvKszj4VLUJz91+cMTvlg0kCQerkpxPnNq2zSWl7
         clBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056088; x=1695660888;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qoTIddLe8NYoucfQJEYmqim99Qxv29RyzC8D0x4Di78=;
        b=YE84/trn4d0sFADRexqu66W31WENaXPzq+qQO/+YwepZJPB19QwBaAp1Cp4gGzMSek
         k4Y2DUrhG4Vrni2pmVmzEnmhxHeXAO3G+NhFKd30o72W9XvTRiKGFNYrLacQM9/lK9M6
         +orsVDJ+3MgzfcazZFCLYsDt+XVDzDz+Ue8eLEu0xi/stnTmdUh1Uvf5IMa2qwSZ4+5a
         rJ9lcEv4G+hLCjVGNDBqjByf5NmTfuFh4e6f1AdB5/P5C7VoMx9BukqjsEgnwVT3Hyhv
         10OnQvbAdxKf33OCzuMAFHCxNipmWR6McwM1OFCJdMqYfbt8Ix9yehlGAvDdcZsLjUmE
         TPGg==
X-Gm-Message-State: AOJu0Yw4eND8XFzbAaeEcaacM7IakpR6ZJ3uicGZr8CoT9qTa40LMux4
        rbLLO0enyf8XG6dtgjOrZwZC4UhCaAtNIrqXVNZUuSpk
X-Google-Smtp-Source: AGHT+IEGgcc0ppczhto+abLorgcjwR3h0tQV7DDsuZ8mYagbx8F0c7EfK6GoA4p70KRuuZukvz7rlMqF0yMAvVoGKc4=
X-Received: by 2002:a05:6102:1622:b0:44d:38d6:5cb8 with SMTP id
 cu34-20020a056102162200b0044d38d65cb8mr180872vsb.10.1695056088127; Mon, 18
 Sep 2023 09:54:48 -0700 (PDT)
MIME-Version: 1.0
From:   Jay Han <jayhan258@gmail.com>
Date:   Mon, 18 Sep 2023 10:54:37 -0600
Message-ID: <CAJ3QLKcSM6oRGuyzJ4tquzP5UUfju7KQfkuBZpHdz_eGHL0Gvw@mail.gmail.com>
Subject: Clat calculation
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello,
I am seeing a stiff delta between the fio clat vs blktrace data and
wondering how fio clat is measured in terms of the I/O processing
step. In blktrace, I measured the time delta between the complete(C
action) and issued(D action) per LBA basis.

Can you tell me how fio clat is calculated please?

Thank you,
Jay.
