Return-Path: <rebecca@bsdio.com>
Subject: Re: Recent changes (master)
References: <20190815120002.693802C22FD@kernel.dk>
From: Rebecca Cran <rebecca@bsdio.com>
Message-ID: <0647fb02-f8db-d611-8079-e7f4348c6715@bsdio.com>
Date: Thu, 15 Aug 2019 08:27:30 -0600
MIME-Version: 1.0
In-Reply-To: <20190815120002.693802C22FD@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/15/2019 6:00 AM, Jens Axboe wrote:
>   void print_status_init(int thr_number)
>   {
> +	struct jobs_eta_packed jep;
> +
> +	compiletime_assert(sizeof(struct jobs_eta) == sizeof(jep), "jobs_eta");
> +

This broke the build on Windows:


     CC eta.o
In file included from fio.h:17:0,
                  from eta.c:12:
eta.c: In function ‘print_status_init’:
compiler/compiler.h:38:44: error: static assertion failed: "jobs_eta"
  #define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                             ^
eta.c:738:2: note: in expansion of macro ‘compiletime_assert’
   compiletime_assert(sizeof(struct jobs_eta) == sizeof(jep), "jobs_eta");
   ^

-- 
Rebecca Cran


