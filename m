Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67C3C05027
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 17:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjBCRKt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 12:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbjBCRKq (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 12:10:46 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C82C22DF4
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 09:10:44 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id p10so6040248vsu.5
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 09:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+bCVyioBWO/39sviZkK7UvFvvKk3zlgK5+3BdzVJVXw=;
        b=MpRZj9+GFs9gcmQgp3AbKQaKzrtCsqO53DrkMTlyVjlTn2CKC4t1B25M3llVPrGjD/
         JGTRlumDN4eJwKHg1PMbYRyFMR3GnVlCHoa5ADhCR7+78TmfxL0NiLVe/8J7veN8CxzQ
         4/13vNdcfgGArL30NvM2T663nzk7OOYLcZGIUXs5LBWoB8nAQ86ljjpKnQp1f+/rF1Cl
         tCulV0iUl1DK73TcCL278ieoYzU2BLvp4eEmod5VaKFRRT26cp5bJn7xloNOH5l/qyzk
         B4biS7SZKRMoINLKYqWsP/lOJbGpxXZUgTK8O+WCM+cu2OshIHbf/7BvAkrdss3tgXbj
         OxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+bCVyioBWO/39sviZkK7UvFvvKk3zlgK5+3BdzVJVXw=;
        b=Sr5UXvxYxTST6pQrMHGCXaH6gkEsf/vmhM8y8oMC4G+KunNbphF43BdqRPhPX4w+n2
         Xp9aa4yfyjbTBvA3lpTNyGN4x+5hrq6zSFQwcVNw4z+AidiFT3i9yebrFlh4juLQV9ro
         AgLLbBYoeYdZTsZX/G/cKVOGSympxJmtlxCrFeR3HaV2KjbuJBYcafb3ztXUNe02G4vH
         9tskvGCODJhVl0fv0izxzDu6fk7T3S3HuWBEFwkXcHSqYsFl7Mo6z+Z4kdzrgYpSGx0g
         97Mjhlqhpq2JBSlp69e0JOZt8WY6ZyNMOfAEogNd6hNZu3xCyX4yJk6Gpt2u73XsPazl
         6LGg==
X-Gm-Message-State: AO0yUKXWKKHcoOW5YSYWdNfiPjO/8eSdJwpnaWHN1zJ9k4ksWRIehGWH
        CBHGR0Quo0e5hqP22xlNA3GKgk9V6VzvrYDUVTzg8/s0
X-Google-Smtp-Source: AK7set/+ASp37G2MrEohmJEOx0LVqP5bHmguOWwlQe73KGGDSuQn4llCHVKRQ0YQAVVwy2z91qlV9JnIJT/10svNKJc=
X-Received: by 2002:a67:e049:0:b0:3eb:a613:7142 with SMTP id
 n9-20020a67e049000000b003eba6137142mr1777715vsl.82.1675444243055; Fri, 03 Feb
 2023 09:10:43 -0800 (PST)
MIME-Version: 1.0
References: <CAJ3QLKfSFjufUU2htxZQywrJX7iYiEwPGZf2TNdyO7O4u3tVYQ@mail.gmail.com>
In-Reply-To: <CAJ3QLKfSFjufUU2htxZQywrJX7iYiEwPGZf2TNdyO7O4u3tVYQ@mail.gmail.com>
From:   Jay Han <jayhan258@gmail.com>
Date:   Fri, 3 Feb 2023 10:10:32 -0700
Message-ID: <CAJ3QLKfnvrYz_VqjppaNA-MyyRdEdfeHKb5M6TOPg7n7ZKACXA@mail.gmail.com>
Subject: Fwd: Reverse Sequential Read or Write
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello,
I am trying to configure a sequential read or write pattern that reads
or writes in reverse manner in terms of LBAs. Is this feasible with
the features that are in current build? If so, any guidance would be
greatly appreciated.

Thank you,
Jay,
