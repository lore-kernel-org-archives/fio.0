Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36796 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbGIDTf (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Jul 2015 23:19:35 -0400
Received: by widjy10 with SMTP id jy10so232891270wid.1
        for <fio@vger.kernel.org>; Wed, 08 Jul 2015 20:19:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
References: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
Date: Wed, 8 Jul 2015 20:19:34 -0700
Message-ID: <CAM8G_BLZCApz3TVWXMfuc4vub5eLOVXws1MShFb9J-FRKTdoCg@mail.gmail.com>
Subject: Re: ask a question about fio
From: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john gong <johngong0791@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Here's one example with 4 jobs which you can customize
https://github.com/axboe/fio/blob/master/examples/tiobench-example.fio


On Wed, Jul 8, 2015 at 6:55 PM, john gong <johngong0791@gmail.com> wrote:
> hello All,
>
> I wonder whether FIO can do below things in the same job?
> 1) sequential write
> 2) sequential read
> 3) randomly write
> 4) randomly read
>
> Namely FIO do not need to spawn other processes to do the things respectively.
> All things will be done in the same process.
>
> Thanks in advance!
>
> John.Gong
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
A ship is safer in a harbor.  But that's not what ships are built for.
