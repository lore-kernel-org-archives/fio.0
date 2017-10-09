Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 0/2] minor latency-related patches
Date: Mon,  9 Oct 2017 10:47:10 -0400
Message-Id: <1507560432-28946-1-git-send-email-vincentfu@gmail.com>
To: fio@vger.kernel.org, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

Jens, please consider the following two patches.

The first updates the comment describing the data structure used for
recording completion latencies so that it is consistent with the
changes made for nanosecond timing.

The second updates the json+ output format for the new
--lat_percentiles option.

Vincent


