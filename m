Return-Path: <axboe@kernel.dk>
Message-ID: <54D4E751.2060700@kernel.dk>
Date: Fri, 06 Feb 2015 09:09:53 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] configure: fix libnuma_v2 probe to work with -Werror
References: <1422554856-65305-1-git-send-email-castor.fu@egocast.org>
In-Reply-To: <1422554856-65305-1-git-send-email-castor.fu@egocast.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: castor.fu@egocast.org, fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>
List-ID: <fio@vger.kernel.org>

On 01/29/2015 11:07 AM, castor.fu@egocast.org wrote:
> From: Castor Fu <castor@alumni.caltech.edu>
>
> I noticed that libnuma_v2 wasn't getting detected in our build
> environment because we would get an error that mask was unused.

Applied, thanks.


-- 
Jens Axboe


