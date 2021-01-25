Return-Path: <glqinhongwei@gmail.com>
MIME-Version: 1.0
References: <cover.1611575523.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1611575523.git.glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Date: Mon, 25 Jan 2021 20:23:04 +0800
Message-ID: <CAKvRR0TV3YxMs6cTaJczEYxsyi3xCmTGFyShW4XabkpgdOdMow@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Add a new parameter and fix minimal rate calculation.
Content-Type: text/plain; charset="UTF-8"
To: fio <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

Hi all,
I found an error in the fio.1. My apologies for the mistake and I'll
submit another v6.

Regards,
Hongwei

On Mon, Jan 25, 2021 at 8:09 PM Hongwei Qin <glqinhongwei@gmail.com> wrote:
>
> v4 -> v5:
>         Use lower case thinktime_blocks in help.
>         Modify fio.1 accordingly.
>
> v3 -> v4:
>         Use uint32_t for thinktime_blocks_type.
>         The tests in patch1 has been re-verified.
>
> v3:
>         The first patch adds a new parameter thinktime_blocks_type
>         to control the behavior of thinktime_blocks.
>         It can be either `complete` or `issue`.
>         If it is `complete` (default), fio triggers thinktime when
>         thinktime_blocks number of blocks are **completed**.
>         If it is `issue`, fio triggers thinktime when thinktime_blocks
>         number of blocks are **issued**
>
>         The second patch updates the compare time if handle_thinktime
>         sleeps or spin.
>
>
> Hongwei Qin (2):
>   Add a new parameter.
>   Calculate min_rate with the consideration of thinktime
>
>  HOWTO            |  7 +++++++
>  backend.c        | 22 ++++++++++++++++------
>  cconv.c          |  2 ++
>  engines/cpu.c    |  1 +
>  fio.1            |  6 ++++++
>  fio.h            |  5 +++++
>  options.c        | 22 ++++++++++++++++++++++
>  thread_options.h |  5 +++++
>  8 files changed, 64 insertions(+), 6 deletions(-)
>
> --
> 1.8.3.1
>

