Return-Path: <axboe@kernel.dk>
Message-ID: <5361647E.6090904@kernel.dk>
Date: Wed, 30 Apr 2014 15:00:46 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] crc/test.c: fix include of time.h
References: <1398883696-12041-1-git-send-email-danny.al-gaaf@bisect.de>
In-Reply-To: <1398883696-12041-1-git-send-email-danny.al-gaaf@bisect.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Danny Al-Gaaf <danny.al-gaaf@bisect.de>, fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@t-online.de>, Danny Al-Gaaf <d.al-gaaf@telekom.de>
List-ID: <fio@vger.kernel.org>

On 04/30/2014 12:48 PM, Danny Al-Gaaf wrote:
> Replace include of time.h with renamed fio_time.h to fix build.

Thanks Danny, applied. Mine still builds fine, for some odd reason...
But it of course needs fixing.

-- 
Jens Axboe


