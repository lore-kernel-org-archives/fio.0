Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35571 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753303AbdEKIEO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 May 2017 04:04:14 -0400
Received: by mail-ua0-f169.google.com with SMTP id e55so21325936uaa.2
        for <fio@vger.kernel.org>; Thu, 11 May 2017 01:04:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACqzM2CQsTnY-1d=hZ-e6d7HD9on8_3OXTtySB1nk3Kjb2-qAg@mail.gmail.com>
References: <CACqzM2CQsTnY-1d=hZ-e6d7HD9on8_3OXTtySB1nk3Kjb2-qAg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 11 May 2017 09:03:43 +0100
Message-ID: <CALjAwxhEbtgZoyZ5V3+HNaqkvbKMS7hwnYrD6KUZAC7j0gSzpw@mail.gmail.com>
Subject: Re: FIO Latency and IOPS variation with blktrace
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Guruganesh Hegde <guruhegde4u@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 11 May 2017 at 08:27, Guruganesh Hegde <guruhegde4u@gmail.com> wrote:
>
> When fio is run with blktrace,
> IOPS drops by 8%, average clat increased by 9% and max clat is5 times
> more compared to the test run without running blktrace.
>
> Is this expected overhead when blktrace is run?
> Wondering why max latency is 5 time more!!

This isn't an easy question to answer as there are too many variables:
How much CPU is left when fio is running by itself? How much is left
when you are running it and blktrace together?
What sort of IOPs are you seeing without blktrace?
Are you saving your blktrace log to a completely different disk on a
completely different controller to the ones being used by fio or
otherwise storing the entirety of the trace entirely in RAM? If you
generate competing I/O towards the same disk(s) you'll hurt your
speeds.

Also this isn't so much an fio question as a blktrace one so it might
also be useful to ask on the blktrace mailing list (see the bottom of
http://git.kernel.dk/?p=blktrace.git;a=blob;f=README;h=f52f48d8d621f916d7b940bbe5ed2b9b92f4c836;hb=43fc870ce04e963def45dfc0d1ed4ea21ef10d4b#l172
).

-- 
Sitsofe | http://sucs.org/~sits/
