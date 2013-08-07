Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58743 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3HGS5w (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Aug 2013 14:57:52 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so4195258wib.5
        for <fio@vger.kernel.org>; Wed, 07 Aug 2013 11:57:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: jiahua@gmail.com
In-Reply-To: <CA+S_sg4sVwquhtxLpmjQQXiNOBya+6vF0mSbyWZG_Q1YtbPPCA@mail.gmail.com>
References: <CA+S_sg4sVwquhtxLpmjQQXiNOBya+6vF0mSbyWZG_Q1YtbPPCA@mail.gmail.com>
Date: Wed, 7 Aug 2013 11:57:51 -0700
Message-ID: <CA+S_sg4ROD-+qdBKz9VMwMcOn4OrpOTBh9sF=gQEbfT54HZCXw@mail.gmail.com>
Subject: Re: How to control the number of random I/O's acrossing the whole file/device?
From: Jiahua <jiahua@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Sorry to bother you again! Can anyone shed some light here? Or can you
give a pointer into the code where I should look at to implement the
feature I want?

Thanks,
Jiahua

On Tue, Aug 6, 2013 at 4:19 PM, Jiahua <jiahua@gmail.com> wrote:
> Hi all,
>
> What I want is to touch a file/device randomly but up to a given
> number of times. I tried the "size=" option but it also limits the
> file size. Is there a way to do that instead of time_based, which is
> approximate to my requirement?
>
> Thanks,
> Jiahua
