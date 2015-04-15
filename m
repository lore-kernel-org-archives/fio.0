Return-Path: <axboe@kernel.dk>
Message-ID: <552EBC50.6060901@kernel.dk>
Date: Wed, 15 Apr 2015 13:30:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] Add new writetrim rw= mode for trims preceding writes
References: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>	<1429052300-9822-3-git-send-email-dehrenberg@chromium.org>	<552DB434.2060709@kernel.dk> <CAAK6Zt27UwQrKiqLf_DEAsUsMKrUYPSdSASBoE0q-yQ8wizwMg@mail.gmail.com>
In-Reply-To: <CAAK6Zt27UwQrKiqLf_DEAsUsMKrUYPSdSASBoE0q-yQ8wizwMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On 04/15/2015 11:49 AM, Daniel Ehrenberg wrote:
> Thanks for the quick feedback. This should be fixed in v2. What do you think?

I didn't find any other issues in the previous posting, so I added the 
doc bits and changed the writetrim to trimwrite. Any other differences 
between master and your v2 posting? If so, separate them out and send it 
in and I'll get it applied.

-- 
Jens Axboe


