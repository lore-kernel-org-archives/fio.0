Return-Path: <Stuart.Davies@skyera.com>
Message-ID: <53697FED.5060001@skyera.com>
Date: Tue, 6 May 2014 17:35:57 -0700
From: Stoo Davies <sdavies@skyera.com>
MIME-Version: 1.0
Subject: Re: Meta verification regression starting with fio 2.1.5
References: <536928FE.6020109@skyera.com> <53695B3C.8060201@kernel.dk>
In-Reply-To: <53695B3C.8060201@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/06/2014 02:59 PM, Jens Axboe wrote:
> 2.1.5 did indeed change when the IO was logged for verification, so that
> does explain why it fails for you now. That's a problem.
>
> Can you try with this patch? I'm not going to commit it yet, I want to
> carefully audit all paths to ensure we also unlog or trim an io_piece,
> if we don't fully complete it.
>
10 loops through the powerfail test and all the hosts are still happy.
Looks good to me, thanks for the fast response.

Stoo


