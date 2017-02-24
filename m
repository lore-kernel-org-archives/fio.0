Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20170224163523.6608-1-tkusumi@tuxera.com>
References: <20170224163523.6608-1-tkusumi@tuxera.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 24 Feb 2017 17:23:08 +0000
Message-ID: <CALjAwxgJxhLQKBMDCG4Qjcc5W2iDwZ6Uofoyzhz6b2ZxX09bjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add runtime handlers for 97900ebf for BSDs
Content-Type: text/plain; charset=UTF-8
To: Tomohiro Kusumi <tkusumi@tuxera.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 24 February 2017 at 16:35, Tomohiro Kusumi <tkusumi@tuxera.com> wrote:
> As 97900ebf itself explains, this is a runtime tunable on FreeBSD
> and DragonFlyBSD, so they need to check the sysctl on runtime.
>
> Not sure if OpenBSD has any tunable for this as the original commit
> only says about >=5.1, but afaik recent versions of OpenBSD can't

I'm not aware of any tunable for this on OpenBSD - only that the
behaviour is listed as changing in 5.1.

> even compile fio anyway. Also not sure how it works on NetBSD, and
> the original commit said nothing about it too.

I'm going to guess that NetBSD doesn't behave this way based on the
result reported by
https://lists.cairographics.org/archives/cairo/2012-October/023652.html
. Additionally in
https://lists.cairographics.org/archives/cairo/2012-October/023652.html
you can see the configure test cairo uses to determine how the
platform behaves with regard to attaching to removed segments. FWIW
OSX 10.12 lacks the desired behaviour according to the result of the
cairo test.

-- 
Sitsofe | http://sucs.org/~sits/

