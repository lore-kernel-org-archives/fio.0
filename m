Return-Path: <danny.al-gaaf@bisect.de>
Message-ID: <53617267.8070909@bisect.de>
Date: Thu, 01 May 2014 00:00:07 +0200
From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Reply-To: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
MIME-Version: 1.0
Subject: Re: [PATCH] crc/test.c: fix include of time.h
References: <1398883696-12041-1-git-send-email-danny.al-gaaf@bisect.de> <5361647E.6090904@kernel.dk>
In-Reply-To: <5361647E.6090904@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@t-online.de>
List-ID: <fio@vger.kernel.org>

Am 30.04.2014 23:00, schrieb Jens Axboe:
> On 04/30/2014 12:48 PM, Danny Al-Gaaf wrote:
>> Replace include of time.h with renamed fio_time.h to fix build.
> 
> Thanks Danny, applied. Mine still builds fine, for some odd reason...
> But it of course needs fixing.
> 

It seems it was the same strange issue for Daniel.

Regards,

Danny

