Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:36252 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031600AbdD0VaY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2017 17:30:24 -0400
Received: by mail-vk0-f46.google.com with SMTP id q78so24459909vke.3
        for <fio@vger.kernel.org>; Thu, 27 Apr 2017 14:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <07fa4af4953de5cca876fdc266a4356c@mail.gmail.com>
References: <07fa4af4953de5cca876fdc266a4356c@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 27 Apr 2017 22:29:53 +0100
Message-ID: <CALjAwxjXO51xx1F==-axhdxyGnjTr-A=8iM-nBrue5wfNec=ow@mail.gmail.com>
Subject: Re: Running fio with buffer_compress_percentage=0 and
 scramble_buffers=1 produces high-dedupe data
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bryan Gurney <bgurney@permabit.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 26 April 2017 at 21:19, Bryan Gurney <bgurney@permabit.com> wrote:
>
> I performed some tests for various non-zero values of
> "buffer_compress_percentage", and the resulting data was not dedupable
> (which would be consistent with the behavior of "scramble_buffers=1", but
> the data pattern seems to suggest that the algorithm used in
> scramble_buffers is not being used.  Comparing this to when
> buffer_compress_percentage is set to zero, the resulting data is almost
> incompressible, but exhibits a high frequency of dedupe.  This is despite
> the intentions of the user's configuration for buffer data content of 0%
> compression, and scrambled to avoid dedupe.

http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-buffer-compress-percentage
alludes to buffer_compress_percentage=0 actually turning the option
off rather than setting a compression ratio of 0%. Here's a link to
the code that would normally react to the option:
https://github.com/axboe/fio/blob/fio-2.19/io_u.c#L2045 .

-- 
Sitsofe | http://sucs.org/~sits/
