Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <cover.1611578199.git.glqinhongwei@gmail.com> <7f25f16b87fdbdceaaaf66c1d345d981a1984dcc.1611578199.git.glqinhongwei@gmail.com>
In-Reply-To: <7f25f16b87fdbdceaaaf66c1d345d981a1984dcc.1611578199.git.glqinhongwei@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 26 Jan 2021 07:49:34 +0000
Message-ID: <CALjAwxjeBqMOw+8DKc-2mbAzuyqj_kz4J2HQSYJih35fjxsOkw@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] Fix fio.1
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>, Hongwei Qin <glqinhongwei@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, 25 Jan 2021 at 12:40, Hongwei Qin <glqinhongwei@gmail.com> wrote:
>
> Fix the manual format.
>
> Signed-off-by: Hongwei Qin <glqinhongwei@gmail.com>
> ---
>  fio.1 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fio.1 b/fio.1
> index 5d08e81..bf5d2b5 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2314,9 +2314,9 @@ before we have to complete it and do our \fBthinktime\fR. In other words, this
>  setting effectively caps the queue depth if the latter is larger.
>  .TP
>  .BI thinktime_blocks_type \fR=\fPstr
> -Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks triggers.
> -The default is `complete`, which triggers thinktime when fio completes
> -\fBthinktime_blocks blocks. If this is set to `issue`, then the trigger happens
> +Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks\fR triggers.
> +The default is `complete', which triggers \fBthinktime\fR when fio completes
> +\fBthinktime_blocks\fR blocks. If this is set to `issue', then the trigger happens
>  at the issue side.
>  .TP
>  .BI rate \fR=\fPint[,int][,int]
> --
> 1.8.3.1
>

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>

LGTM - Jens can you pull this set?

Hongwei: In general it's preferable to squash/rebase changes like this
last manual fix into the original commit but you've patiently revised
these patches multiple timesso I don't think it's worth changing again
unless something else comes up :-)

--
Sitsofe

