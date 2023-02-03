Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49152C61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 18:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjBCSH3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 13:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjBCSH0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 13:07:26 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2CEAC21B
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 10:07:25 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id i2so3978170ybt.2
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 10:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6VCuW4qqyhbK9ZAeU0nJrKAb3cF+AQhIuURZuWyOsUc=;
        b=lG/BM7fy0pRuo+WYconWg7P8C6C2fOD4T28LEUaTO3KoDcHwpaxGR1g4YzIqj8xaYM
         nHzIjIlsZCahJwp887gl0jt1G/ie409+aNtIKkI8dnOV9EL4LcaYw4ZQXOsx2v8ut9x4
         +WLlxAhmPF/1LImhuDKCyqIblrWmjVfZGXESBrvrx3RFcAI61cXVCUXXlmt2FQY6xa2t
         IxtjP2Z8vVmeSgUpDqSLZJOhUAVyXHTFG0NdjKvw6AQMmICVoWy6zTb/Uj8GMFj4IG8E
         EkMMWwwtjVRcxA4KYcr4+wqdbqYP/u/BxPhRjy1f6s1og92urjnk3sSJNFZoUXCpreEk
         ogFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6VCuW4qqyhbK9ZAeU0nJrKAb3cF+AQhIuURZuWyOsUc=;
        b=N1NCgtRl3foj7DmPfGmUuwxjjWjRY5tjYbt5xTdDyM+jK7e0ytgHor4ljlog2/XJHP
         vVq5hyYjpjw9xw2ezeQQ1hT3CMxEoL3pOHz3SJSnw7pWIg/hnUlI2W4ZMeb9f5B281bH
         wY3G782GDzsMjaN/fIDouIRATK/VkgT7i1dHy4OcLIgcMjciwl7LCBx3Kv+rD6M24Gpf
         +eZ9J1j97IeeZgaeYt5M9a7J+p9Rc1vWQ+MrqEyQnbDy/ljDffZIlRwDzHWFj8EXZeQp
         4fG9kXNO5EylMoVVeq/pFdbajZJLSpAiauMjgNFlCzC3BdyUkfnNO3XiLLKCZSODcabk
         Y10A==
X-Gm-Message-State: AO0yUKUWQ0ihv/da41JX9CIULEEqKIKmw/i/TUInwaS8fcUil8v/7ayM
        bCRWIE7Fq5qXZY0KSlp0DyA5HY5q+/GyCJCG9pE=
X-Google-Smtp-Source: AK7set9aTOe/et2098FA2NucGDx9IEZ+Co0Q3VfZEqCMbXsfptjji/nyQlApqcdaR9FW6XMSH3aAWhSJO71BIy+bmlo=
X-Received: by 2002:a5b:610:0:b0:871:347:96b4 with SMTP id d16-20020a5b0610000000b00871034796b4mr231268ybq.262.1675447644691;
 Fri, 03 Feb 2023 10:07:24 -0800 (PST)
MIME-Version: 1.0
References: <CAJ3QLKfSFjufUU2htxZQywrJX7iYiEwPGZf2TNdyO7O4u3tVYQ@mail.gmail.com>
 <CAJ3QLKfnvrYz_VqjppaNA-MyyRdEdfeHKb5M6TOPg7n7ZKACXA@mail.gmail.com>
In-Reply-To: <CAJ3QLKfnvrYz_VqjppaNA-MyyRdEdfeHKb5M6TOPg7n7ZKACXA@mail.gmail.com>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Fri, 3 Feb 2023 23:36:40 +0530
Message-ID: <CAKi7+wdkKz7-urkzXdWB2OTaC8aYSw3AWAtA7jfzJ1w1xU28cg@mail.gmail.com>
Subject: Re: Reverse Sequential Read or Write
To:     Jay Han <jayhan258@gmail.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hey Jan,

Replying again as the first one didn't go to the mailing list because
of that not being in plain text.

Yes, you can read/write in reverse order and there is already an
example fio configuration.
Check out:
https://github.com/axboe/fio/blob/master/examples/backwards-read.fio

Regards
Ankit


On Fri, Feb 3, 2023 at 10:58 PM Jay Han <jayhan258@gmail.com> wrote:
>
> Hello,
> I am trying to configure a sequential read or write pattern that reads
> or writes in reverse manner in terms of LBAs. Is this feasible with
> the features that are in current build? If so, any guidance would be
> greatly appreciated.
>
> Thank you,
> Jay,
