Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54627C44.3080909@kernel.dk>
References: <54627C44.3080909@kernel.dk>
Date: Tue, 11 Nov 2014 17:11:58 -0800
Message-ID: <CAF+0mv=H9cauEbP+CMCup0aLUD0qE42Jz9WPzboAv0U757acYw@mail.gmail.com>
Subject: Re: Fio 2.1.14 released
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> - Fio will exit a bit faster now, since the disk util thread and the
>   helper thread were combined into one, and it'll be immediately torn
>   down on exit. It had to wait around 250msecs before this change. You
>   might have noticed this delay when doing ctrl-c on a workload.

I find this update interesting, as I have a script that calls fio
multiple times, one after the other.

Are there any options that would make fio start or exit faster?  For
example, if I used disk_util=0, would this help fio exit any faster?

