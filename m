Return-Path: <axboe@kernel.dk>
Message-ID: <52FC45E9.3090101@kernel.dk>
Date: Wed, 12 Feb 2014 21:11:21 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix g++ warning about void* used in arithmetic
References: <1392229542-14083-1-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392229542-14083-1-git-send-email-d.gollub@telekom.de>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Daniel Gollub <daniel.gollub@t-online.de>, fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>

On 2014-02-12 11:25, Daniel Gollub wrote:
> ../parse.h: In function ‘void* td_var(thread_options*, fio_option*, unsigned int)’:
> ../parse.h:110:10: warning: pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]
> ../parse.h:112:9: warning: pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]

I bet there are a lot of these, or other similar code that would prevent 
compiling with g++. I'm dubious of the value add here. Fio is written in 
C, after all.

-- 
Jens Axboe


