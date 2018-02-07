Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:42081 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753856AbeBGRmQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:16 -0500
Received: by mail-vk0-f47.google.com with SMTP id t4so1058401vkb.9
        for <fio@vger.kernel.org>; Wed, 07 Feb 2018 09:42:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f4456b3c-214b-ba74-d979-9ed143df9811@kcl.ac.uk>
References: <f4456b3c-214b-ba74-d979-9ed143df9811@kcl.ac.uk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Feb 2018 17:41:45 +0000
Message-ID: <CALjAwxjAB61v0aW_3hE8MpzBwjZ+y7kKbsKjzkEz1s7OQ2ThaQ@mail.gmail.com>
Subject: Re: Possible bug in client/server mode - spurious lines leaking into
 logfile fio-3.3-39-g9025
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tim Watts <tim.j.watts@kcl.ac.uk>
Cc: fio <fio@vger.kernel.org>

Hi,

On 7 February 2018 at 16:42, Tim Watts <tim.j.watts@kcl.ac.uk> wrote:
>
> The hostname=vmhost-21 is being generated on the fio server instance by
> client.c lines 1416-1418, a log_info() statement
>
> The other stuff looks like it is the result of the server instance
> defaulting output_format to FIO_OUTPUT_NORMAL - and there's no option like
> "--output_format=none" to be able to give to the server
>
> At the end of the email is a hacky patch that "fixes" the problem - but
> almost certainly, it's not done right.
>
>
> The invocations were:
>
> (Server)
> fio --server
>
> (Client)
> fio --output=/test/logs/a.log --output-format=json --client=vmhost-21
> /test/fio/a.fio
>
>
> Before guessing if this is a bug or a user error, I thought I'd send it here
> for your comment :)

Looks like bugs to me:

The client doesn't send the server the output-format it's currently
using (bug 1, might be tricky to fix unless you take a big hammer
style approach) and the "hostname=..." output should be suppressed
when not using normal output (bug 2, easily solved with an if (not
normal output)).

Curiously, if you launch the server with --output-format=json some of
the output is suppressed (bug 3?)...

-- 
Sitsofe | http://sucs.org/~sits/
