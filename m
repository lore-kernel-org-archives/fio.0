Return-Path: <axboe@kernel.dk>
Message-ID: <544ABB51.1040107@kernel.dk>
Date: Fri, 24 Oct 2014 14:49:21 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix alignement to prevent bus error on ARM
References: <1414183357-31504-1-git-send-email-gwendal@chromium.org> <CAAbOScn8QgtqeM6A20p9Zy1vBkcyDuk4R1ia34u+Q=KKJtnc+Q@mail.gmail.com>
In-Reply-To: <CAAbOScn8QgtqeM6A20p9Zy1vBkcyDuk4R1ia34u+Q=KKJtnc+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mike Frysinger <vapier@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
Cc: fio@vger.kernel.org, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On 10/24/2014 02:47 PM, Mike Frysinger wrote:
> the code seems to be fine with gcc-isms, so i might suggest anon unions
> instead to make it harder to break:
> union {
>   uint64_t __aligner;
>   uint16_t continue_on_error;
> };

It's not a bad idea... Your commit broke alignment further down, btw,
but I fixed it up.

I'll be happy to take anon union patches for the alignment parts :-)

-- 
Jens Axboe


