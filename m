Return-Path: <tirea@google.com>
MIME-Version: 1.0
In-Reply-To: <4F420FD6.10907@kernel.dk>
References: <CAAUT-yOi26hzpOdzCbSDTS9AE_y96USLK25LVYvfzCFP5skJ4g@mail.gmail.com>
 <CAAUT-yOd-gnfN-tEC3SY-RcBON5tYqOz6DyRqXfwNyGq71mPgA@mail.gmail.com> <4F420FD6.10907@kernel.dk>
From: Steven Lang <tirea@google.com>
Date: Tue, 21 Feb 2012 14:19:18 -0800
Message-ID: <CAAUT-yNdF4WFkauy5+29NzW+nt007kRJmmfy9VnVE9OmrZFbEQ@mail.gmail.com>
Subject: Re: Something odd with the fio random offset generator & time_based runs
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Feb 20, 2012 at 1:18 AM, Jens Axboe <axboe@kernel.dk> wrote:
> I agree that the correct solution would be to NOT jump out of the loop
> and just keep going for time_based. As you point out, it might need
> another change or two to ensure that we handle every condition. For
> things like random map, we do need to clear it when it's full (or close
> to), but that need not reset everything.
>
> Do you have any time to hunt this further?

Probably not for a week or two; I haven't even had enough time to dig
into the main IO loop to figure out where the other exit conditions
(End of iolog, random map full, etc) are coming from.

I also still owe a documentation patch to add the continue_on_error
option to the man page.

