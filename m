Return-Path: <htobonm@eafit.edu.co>
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Subject: [io_uring] Performance analysis
Message-ID: <2ce17fe4-3e39-a19e-b049-cd550d77a76d@eafit.edu.co>
Date: Mon, 15 Jun 2020 23:56:02 -0400
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Return-Path: htobonm@eafit.edu.co
MIME-Version: 1.0
To: fio@vger.kernel.org
Cc: axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

Hello there,

I've been using and analyzing io_uring's performance with fio. I'm 
trying to replicate the results that Jens Axboe shows when he presents 
io uring in Kernel Recipes 2019. The problem is that I'm not even closer 
to that, nor that behavior. I have a server with two Intel Optanes (he 
mentions that he had to use two devices), but I think the problem is 
that I'm not using the proper fio parameter combination. Can you please 
tell me what fio configuration is needed to get 1.6 million iops with 
only one thread?, or at least that same behavior, not necesarily the 1.6 
million iops. I'm comparing io_uring in polling mode vs libaio, but I 
get the same iops with both of them, about 400K iops, issuing requests 
to both devices through separate files.

Jens Axboe's presentation is here: 
https://kernel-recipes.org/en/2019/talks/faster-io-through-io_uring/

Jens it would be nice if you can explain the set up you used to get the 
most out of io_uring.

Thank you.

Hamilton.


