Return-Path: <erwan@enovance.com>
Message-ID: <522791D4.3060201@enovance.com>
Date: Wed, 04 Sep 2013 22:02:28 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: How to loop a timebased job
References: <522639CE.2030705@enovance.com> <20130903223727.GB31170@kernel.dk> <52273BF5.90109@enovance.com> <52277371.5070004@kernel.dk>
In-Reply-To: <52277371.5070004@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/09/2013 19:52, Jens Axboe wrote:
> Good point, yes, that is a problem. Adding a loopbased option would 
> seem to be the best way to solve the dependency issue. 
Ok, I'm working on this option.

Here come the kind of usage I'm thinking about :

[general]
....
loop_based
loops=5

[job_1]
....
runtime=10

[job_2]
....
runtime=20


That lever the question on where we shall "loop" the jobs ?
What's the preferred option regarding your experience on fio ?
The main problem I'm facing is to reinit properly jobs between loops 
(like td->terminate or doing the start_delay,...)

Shall it be better to manage it inside thread_main() or get it outside ?

Thanks for your insights,
Erwan

