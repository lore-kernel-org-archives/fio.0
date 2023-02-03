Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D524C61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 22:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjBCWri (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 17:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBCWrh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 17:47:37 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C7D233CA
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 14:47:36 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id i38so3367144vkd.0
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 14:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k2l3ibF22ZmWYFIPa8Ti/NPHDXuI9R9Vc/3kLcR2ztg=;
        b=ZTXvDz/iX/wuyI3oK7dskpeccBdOFHMCQiiS11SzmYKCGvmWEnz5PLvUrB9/AgdUBT
         109+rIcNAekFiqFD2RYleWqicBGSitay6ExW0BovYRa9/5tWRyWFmsBFi6okphak3zGp
         iV2YhvBQ40Knfq0D45UhW6+zQcJpWbLEiUm02pro/pEM+zWLc8erD0dJyD3Q1zJdJOEp
         YFzuj0ZcBWiiuPPdOhYEEo0O0zE5ljIgxcTFZz1yL4Q0BWPtJeMT+mzcN2ZSMYSU7xZR
         m+vRwoVO6pIotk+JQl43oGoDi9T+avRGZO32hLWkbVhfur3NkHpHT5lZvZcCEp+A2W8w
         ghFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2l3ibF22ZmWYFIPa8Ti/NPHDXuI9R9Vc/3kLcR2ztg=;
        b=b10EMMX9FNfkL1tODTXkBaSgDJ+SOBNUbnnZg+RbqBsHOUltG1qwXRF1pBniXW3Zi2
         Zxb5M0+ztIXOZjztjJ59/zDRAaeL4LtOL4/k4InUqfodbIYLrdHTtuXJBTLwZd1EE6/l
         PTlWRlCBnQ+UgDqrtqFecfDxkYhlZnek9lRMhfcCr2WYpGm9ZzKeKArYW08dpsddyRMN
         Gn+aS9aKaBX7Bvf/VApQBwWdianotJTcmxU/5KZIY3m3yRf9GoT66xjlF/rTY0VghB4J
         /rhVcJ6hlBd6ZZ3e+2MajdxrPkoJQBbIIhusfEMN3h5SRu/94kPW7Egq6p//hCT2nTV6
         qxkg==
X-Gm-Message-State: AO0yUKWXHOQ/QI7jOVd2zi9S3Ea0Iu5xZC3sHK+S9OZOcNc9ucmYDLtp
        KNQDIyoRolUZXV3iFftQjF6cAoMesiES+YSWjxPrDKyNcfo=
X-Google-Smtp-Source: AK7set+mKBm3/mMmOH1ZaFex3eV2stlITjMVB8drB4qeO/lRxSfvPD3Tsj2k4kZiYF8Tij/HdSFIVZeR/N2139Neb9Y=
X-Received: by 2002:ac5:c559:0:b0:3d5:f057:d5ff with SMTP id
 d25-20020ac5c559000000b003d5f057d5ffmr1585403vkl.26.1675464455681; Fri, 03
 Feb 2023 14:47:35 -0800 (PST)
MIME-Version: 1.0
References: <CAJ3QLKfSFjufUU2htxZQywrJX7iYiEwPGZf2TNdyO7O4u3tVYQ@mail.gmail.com>
 <CAJ3QLKfnvrYz_VqjppaNA-MyyRdEdfeHKb5M6TOPg7n7ZKACXA@mail.gmail.com>
 <CAKi7+wdkKz7-urkzXdWB2OTaC8aYSw3AWAtA7jfzJ1w1xU28cg@mail.gmail.com>
 <CAJ3QLKf4rUaxDAx8=Ysnp9EhYBsv4oEcRw5EuExOsav-1MP=ow@mail.gmail.com>
 <CAJ3QLKfAH4b_OnKbN-OGxnbnmz2m+UPJwsDLoS3YK0gxsJVnnw@mail.gmail.com> <5b1955e4-7364-6355-b0df-70952f4664b0@gmail.com>
In-Reply-To: <5b1955e4-7364-6355-b0df-70952f4664b0@gmail.com>
From:   Jay Han <jayhan258@gmail.com>
Date:   Fri, 3 Feb 2023 15:47:24 -0700
Message-ID: <CAJ3QLKc6=_SqmcgoUoBA3NUzRN+--RAkE3mL1=snmv0SRK7UWA@mail.gmail.com>
Subject: Re: Reverse Sequential Read or Write
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     Ankit Kumar <ankit1455@gmail.com>, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Great, thank you very much, Vincent!

On Fri, Feb 3, 2023 at 3:35 PM Vincent Fu <vincentfu@gmail.com> wrote:
>
> On 2/3/23 16:17, Jay Han wrote:
> > Thank you Ankit! I captured a trace using the example config file.
> > What does rw=read:-8k translate to in terms of LBA? I am seeing 4K seq
> > read in reverse manner. I am not sure what that 8k implies.
> > Each read is apart by 8. For example, the workload accessed LBAs
> > 1540000, 1539992, 1539984, 1539976, 1539968, and so on.
> > Each read requested 8 logical blocks and the sector size is 512B which
> > makes up a 4K read.
> >
> > Can you elaborate the -8K for me please?
> >
>
> The relevant documentation for the option in question is at the end of
> this section:
>
> https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
>
> Basically fio is subtracting 8K from the end of each IO in order to get
> the next LBA to use.
>
> Vincent
