Return-Path: <axboe@kernel.dk>
Message-ID: <533C1E6F.1040401@kernel.dk>
Date: Wed, 02 Apr 2014 08:27:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Missing code in options.c ?
References: <533BD35E.2020703@enovance.com>
In-Reply-To: <533BD35E.2020703@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-04-02 03:07, Erwan Velu wrote:
> Hi Jens,
>
> Sorry for spawning many emails but I think it's easier to follow having
> an email per problem instead of long emails with mixed stuff in it.

No worries, we like hearing about bugs we can get fixed :-)

> In options.c, we can see that :
> http://git.kernel.dk/?p=fio.git;a=blob;f=options.c;h=4a54c98c15045864931ea503d3f7920bab4ae431;hb=HEAD#l212
>
>
> ret = bssplit_ddir(&td->o, DDIR_READ, str) is performed while ret can be
> already setup in the previous line. I'm not mastering this part but I
> wonder what is lacks :
>
> - a missing if (!ret) ?
> - some strdup + free around ? Does using str directly is safe here ?
>
> Wouldn't be easier to read to get some goto to the global free code at
> the end of the function instead of a multiple chained if (!ret) {} ?

I need to take a closer look at that part. It does look a bit messy.

-- 
Jens Axboe


