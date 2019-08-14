Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20190814201012.253060-1-bvanassche@acm.org> <20190814201012.253060-8-bvanassche@acm.org>
 <CALjAwxjQ_dukjjVH6qnrZTJL-jbcsx6FgbfENJxvdsCJk5fUag@mail.gmail.com> <01203a78-591d-6727-1bec-1fd6c8fb5208@acm.org>
In-Reply-To: <01203a78-591d-6727-1bec-1fd6c8fb5208@acm.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Aug 2019 22:40:24 +0100
Message-ID: <CALjAwxjwJD8hdtCysmrfFVshQcsq2V6FvELQUQn4LViMDb=Gnw@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] Makefile: Add 'fulltest' target
Content-Type: text/plain; charset="UTF-8"
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, 14 Aug 2019 at 22:14, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/14/19 2:11 PM, Sitsofe Wheeler wrote:
> > Looks good. We just need to switch
> > https://github.com/axboe/fio/blob/master/.travis.yml over to run
> > both...
>
> Hi Sitsofe,
>
> I'm not sure whether Travis supports kernel module loading. See also
> https://github.com/travis-ci/travis-ci/issues/2291.

Doh - I hadn't twigged. Apologies for the noise...

-- 
Sitsofe | http://sucs.org/~sits/

